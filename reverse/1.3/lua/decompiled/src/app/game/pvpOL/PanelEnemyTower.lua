local CimeliaSkill = require("app.sprites.pvp.CimeliaSkillModel")
local TAG_EVENT_CREATE_ENEMY = "tag_event_create_enemy"
local TAG_EVENT_PLAY_CIMELIA = "tag_event_create_cimelia"
local M = {}
M = class("PanelEnemyTower", function()
  return display.newNode()
end)

function M:ctor()
  cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
  self:initData()
  self:initUI()
  self:setNodeEventEnabled(true)
end

function M:onEnter()
end

function M:onExit()
  DYNotification.removeAllObservers(self)
  table.walk(self.mNotifyNodes, function(v, k)
    DYNotification.removeAllObservers(v)
  end)
end

function M:initData()
  self.mAtkCimeliaInfo = DataUtils.getAtkCimeliaInfo(CloudData.ENEMY_CIMELIA_INFO.atkCimelia)
  self.mDefCimeliaInfo = DataUtils.getDefCimeliaInfo(CloudData.ENEMY_CIMELIA_INFO.defCimelia, CloudData.ENEMY_TREASURE_INFO)
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mAtkCimeliaInfo.skillName, self.mAtkCimeliaInfo.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  self.hpMax_ = math.floor(self.mDefCimeliaInfo.towerHP * Const.PVPOL_TOWER_HP_RATIO)
  self.hpCur_ = self.hpMax_
  self.mFlag = 9
  self.mHitEffectCount = 0
  self.mCantAttack = false
  self.mIsDead = false
  DYComponent.getTable(self, "battleData.baseData")
  self.mNotifyNodes = {}
end

function M:initUI()
  local towerArmature = self.mDefCimeliaInfo.towerArmature
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb", towerArmature, towerArmature))
  self.towerArmature_ = ccs.Armature:create(towerArmature)
  self.towerArmature_:getAnimation():playWithIndex(0)
  self.towerArmature_:setAnchorPoint(0.5, 0)
  self.towerArmature_:setScale(-0.4, 0.4)
  self:addChild(self.towerArmature_)
  
  local function animationEvent(armatureBack, movementType, movementID)
    local id = movementID
    if movementType == ccs.MovementEventType.loopComplete then
      if id == "under_attack1" then
        if self.hpCur_ / self.hpMax_ >= 0.6666666666666666 then
          self:changeArmatureStateTo("IDLE1")
        elseif self.hpCur_ / self.hpMax_ >= 0.3333333333333333 then
          self:changeArmatureStateTo("IDLE2")
        else
          self:changeArmatureStateTo("IDLE3")
        end
      elseif id == "under_attack2" then
        if self.hpCur_ / self.hpMax_ >= 0.3333333333333333 then
          self:changeArmatureStateTo("IDLE2")
        else
          self:changeArmatureStateTo("IDLE3")
        end
      elseif id == "under_attack3" then
        self:changeArmatureStateTo("IDLE3")
      end
    end
  end
  
  self.towerArmature_:getAnimation():setMovementEventCallFunc(animationEvent)
  local barBg = display.newSprite("gamescene/bar_bg_tower_m.png", 0, self.towerArmature_:getContentSize().height - 10):addTo(self.towerArmature_)
  barBg:setScaleX(-1)
  self.progressTimer_ = cc.ProgressTimer:create(display.newSprite("gamescene/bar_hp_tower_m.png")):addTo(barBg)
  self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.progressTimer_:setPosition(barBg:getContentSize().width / 2, barBg:getContentSize().height / 2)
  self.progressTimer_:setMidpoint(cc.p(0, 0))
  self.progressTimer_:setBarChangeRate(cc.p(1, 0))
  self.progressTimer_:setPercentage(100)
  self.barBg_ = barBg
  self.towerBloodLabel_ = cc.ui.UILabel.new({
    UILabelType = 2,
    text = string.format("%d/%d", self.hpCur_, self.hpMax_),
    size = 20
  }):align(display.CENTER, self.barBg_:getContentSize().width / 2, self.barBg_:getContentSize().height / 2):addTo(self.barBg_, 1)
  local wandPic = display.newSprite(self.mAtkCimeliaInfo.wandIcon):scale(0.8):align(display.RIGHT_BOTTOM, -self.towerArmature_:getContentSize().width * 0.5, -15):addTo(self.towerArmature_)
  local wandBall = display.newSprite(self.mAtkCimeliaInfo.ballIcon):pos(wandPic:getContentSize().width * 0.5, wandPic:getContentSize().height + 40):addTo(wandPic)
  wandBall:setScaleX(-1)
  local sequence = transition.sequence({
    cc.MoveBy:create(0.5, cc.p(0, -10)),
    cc.MoveBy:create(0.5, cc.p(0, 10))
  })
  local action = cc.RepeatForever:create(sequence)
  wandBall:runAction(action)
  self.wandBall = wandBall
end

function M:getHpRate()
  return self.hpCur_ > 0 and math.floor(self.hpCur_ / self.hpMax_ * 100) or 0
end

function M:createEnemy(buddhaId)
  BMgrOL.createPVPMonster(buddhaId)
end

function M:playCimelia(params)
  if "atk" == params.cimeliaType then
    self:castWandSkill(params)
  elseif "def" == params.cimeliaType then
    self:castTowerSkill(params)
  end
end

function M:changeArmatureStateTo(state)
  if state == "IDLE1" then
    if self.curArmatureState_ ~= "IDLE" then
      self.curArmatureState_ = "IDLE"
      self.towerArmature_:getAnimation():playWithIndex(0)
    end
  elseif state == "IDLE2" then
    if self.curArmatureState_ ~= "IDLE" then
      self.curArmatureState_ = "IDLE"
      self.towerArmature_:getAnimation():playWithIndex(2)
    end
  elseif state == "IDLE3" then
    if self.curArmatureState_ ~= "IDLE" then
      self.curArmatureState_ = "IDLE"
      self.towerArmature_:getAnimation():playWithIndex(4)
    end
  elseif state == "HURT1" then
    if self.curArmatureState_ ~= "HURT" then
      self.curArmatureState_ = "HURT"
      self.towerArmature_:getAnimation():playWithIndex(1)
    end
  elseif state == "HURT2" then
    if self.curArmatureState_ ~= "HURT" then
      self.curArmatureState_ = "HURT"
      self.towerArmature_:getAnimation():playWithIndex(3)
    end
  elseif state == "HURT3" and self.curArmatureState_ ~= "HURT" then
    self.curArmatureState_ = "HURT"
    self.towerArmature_:getAnimation():playWithIndex(5)
  end
end

function M:playCommonSkillEffect()
  local frames = display.newFrames("wandPicCast%d.png", 1, 7)
  local animation = display.newAnimation(frames, 0.08)
  local sp = display.newSprite()
  local rect = self:getContentSize()
  sp:setAnchorPoint(cc.p(0.5, 0.5))
  sp:setPositionY(rect.height / 3)
  sp:setScale((rect.width / 1.4 + rect.height / 1.4) / 270)
  self.wandBall:addChild(sp, 50)
  sp:playAnimationOnce(animation, true)
end

function M:underAttack(source, loseHp)
  DDLOG(DYLang.getString("S272", ""), loseHp, self.hpMax_)
  self:hurtEffect()
  self.hpCur_ = self.hpCur_ - loseHp
  self:showDamage(loseHp)
  if self.hpCur_ / self.hpMax_ >= 0.6666666666666666 then
    self:changeArmatureStateTo("HURT1")
  elseif self.hpCur_ / self.hpMax_ >= 0.3333333333333333 then
    self:changeArmatureStateTo("HURT2")
  else
    self:changeArmatureStateTo("HURT3")
  end
  BMgrOL.setEnemyTowerHp(self.hpCur_)
  self:dispatchEvent({
    name = "UPDATE_BLOOD"
  })
  if self.hpCur_ <= 0 then
    self.towerBloodLabel_:setString(string.format("0/%d", self.hpMax_))
    self.progressTimer_:setPercentage(0)
    self:onDead()
    return
  end
  self.towerBloodLabel_:setString(string.format("%d/%d", self.hpCur_, self.hpMax_))
  self.progressTimer_:setPercentage(self.hpCur_ / self.hpMax_ * 100)
end

function M:increaseHP(hp)
  self.hpCur_ = self.hpCur_ + hp
  if self.hpCur_ > self.hpMax_ then
    self.hpCur_ = self.hpMax_
  end
  if self.hpCur_ < 0 then
    self.hpCur_ = 0
  end
  self.towerBloodLabel_:setString(string.format("%d/%d", self.hpCur_, self.hpMax_))
  self.progressTimer_:setPercentage(self.hpCur_ / self.hpMax_ * 100)
end

function M:updateHpRatio(ratio)
  local deltaHp = math.round(self.hpMax_ * ratio / 100)
  self:increaseHP(deltaHp)
end

function M:hurtEffect()
  if not self.isInShake_ then
    self.isInShake_ = true
    local m1 = cc.MoveBy:create(0.1, cc.p(3, 0))
    local m2 = cc.MoveBy:create(0.1, cc.p(-3, 0))
    self.towerArmature_:runAction(transition.sequence({
      m1,
      m2,
      m1,
      m2,
      cc.CallFunc:create(function()
        self.isInShake_ = false
      end)
    }))
  end
  if self.mHitEffectCount < 4 then
    local frames = display.newFrames("shouji%d.png", 1, 4)
    local animation = display.newAnimation(frames, 0.07)
    local sp = display.newSprite()
    sp:setAnchorPoint(cc.p(0.5, 0))
    sp:setScale(0.8)
    self:addChild(sp, 11)
    sp:playAnimationOnce(animation, true, function()
      self.mHitEffectCount = self.mHitEffectCount - 1
    end)
  end
  if self.mHitEffectCount > 6 then
    self.mHitEffectCount = 0
  end
  self.mHitEffectCount = self.mHitEffectCount + 1
end

function M:showDamage(hpLose)
  local font
  font = cc.ui.UILabel.newBMFontLabel_({
    text = string.format("-%d", hpLose),
    font = "fonts/battle_red.fnt"
  }):addTo(self)
  font:setScale(Const.Zoom0)
  font:setPosition(0, self:getContentSize().height * Const.Zoom0)
  local spawn = cc.Spawn:create(cc.MoveBy:create(1, cc.p(0, self:getContentSize().height * Const.Zoom0 * 0.5)), cc.FadeOut:create(1))
  font:runAction(transition.sequence({
    spawn,
    cc.CallFunc:create(function()
      font:removeSelf()
    end)
  }))
end

function M:onDead()
  if not self.mIsDead then
    self.mIsDead = true
    self:dispatchEvent({name = "GAME_WIN"})
  end
end

function M:addBuff()
  return nil
end

function M:getCurABLY(index)
  return self.initABLY[index] + self.addABLY[index] + self.tmpABLY[index]
end

function M:getContentSize()
  return self.towerBg_:getContentSize()
end

function M:getActorType()
  return 1
end

function M:getMyBoundingBox()
  local tmpWidth = 0
  local size = cc.size(self.towerArmature_:getContentSize().width * Const.Zoom0, self.towerArmature_:getContentSize().height * Const.Zoom0)
  size.width = 130
  local tmpX = self:getPositionX()
  local tmpWidth = tmpX + size.width / 20
  return tmpWidth
end

function M:updateEnemyTower()
  if self.mIsSkillPlay then
    self.mCountTick = self.mCountTick + 1
    local delayTime = GameData.SKILL_DELAY or 0.5
    if delayTime <= self.mCountTick / GameData.FRAME_PER_SECOND then
      self.mCountTick = 0
      self.mIsSkillPlay = false
      self.mAtkCimelia:updateNpcBlood()
    end
  end
end

function M:castWandSkill(params)
  if not self.mAtkCimelia then
    local cimeliaAtkParam = {
      cimeliaType = "atk",
      atk = {
        flag = FLAG_TOWER_MONSTER,
        skillId = params.skillId,
        atk = params.atkNum,
        aktType = params.atkType,
        atkDis = params.atkDis,
        hitRate = params.hitRate,
        critRate = params.critRate,
        critHarmRate = params.critHarmRate,
        magDefIgnore = params.magDefIgnore,
        phyDefIgnore = params.phyDefIgnore,
        element = params.element,
        elementValue = params.elementValue
      }
    }
    self.mAtkCimelia = CimeliaSkill.new(cimeliaAtkParam)
  end
  self.mAtkCimelia:castSkill()
  self.mIsSkillPlay = true
  self.mCountTick = 0
end

function M:castTowerSkill(params)
  if not self.mDefCimelia then
    local cimeliaDefParam = {
      cimeliaType = "def",
      def = {
        flag = FLAG_TOWER_MONSTER,
        skillId = params.skillId,
        atk = 0,
        aktType = 1,
        atkDis = -1
      }
    }
    self.mDefCimelia = CimeliaSkill.new(cimeliaDefParam)
  end
  self.mDefCimelia:castSkillTower()
end

function M:getContentSize()
  return self.towerArmature_:getContentSize()
end

function M:getElementType()
  local tFunc = {
    [1] = 3,
    [2] = 4,
    [3] = 1,
    [4] = 2,
    [5] = 5
  }
  return tFunc[self.mDefCimeliaInfo.element]
end

function M:getElementValue(element)
  local res = 0
  local tFunc = {
    [1] = self.mDefCimeliaInfo.propGold,
    [2] = self.mDefCimeliaInfo.propWood,
    [3] = self.mDefCimeliaInfo.propWater,
    [4] = self.mDefCimeliaInfo.propFire,
    [5] = self.mDefCimeliaInfo.propEarth
  }
  res = tFunc[element] + self.mDefCimeliaInfo.propAllElements
  return res
end

return M

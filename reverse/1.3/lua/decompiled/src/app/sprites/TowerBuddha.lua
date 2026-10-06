local TowerBuddha = {}
TowerBuddha = class("TowerBuddha", function()
  return display.newNode()
end)

function TowerBuddha:ctor()
  cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
  self.hpMax_ = GameData.CIMELIA_DEF.towerHP
  if 6 == GameManager.MODE or 9 == GameManager.MODE then
    self.hpMax_ = math.floor(self.hpMax_ * Const.PVPOL_TOWER_HP_RATIO)
  end
  self.mElement = GameData.CIMELIA_DEF.element
  self.hpCur_ = self.hpMax_
  DYComponent.getTable(self, "battleData.baseData")
  local towerArmature = GameData.CIMELIA_DEF.towerArmature
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb", towerArmature, towerArmature))
  self.towerArmature_ = ccs.Armature:create(towerArmature)
  self.towerArmature_:getAnimation():playWithIndex(0)
  self.towerArmature_:setAnchorPoint(0.5, 0)
  self.towerArmature_:setScale(0.4)
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
  self.barBg_ = display.newSprite("gamescene/bar_bg_tower_b.png", 0, self.towerArmature_:getContentSize().height - 10):addTo(self.towerArmature_)
  self.progressTimer_ = cc.ProgressTimer:create(display.newSprite("gamescene/bar_hp_tower_b1.png")):addTo(self.barBg_)
  self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.progressTimer_:setPosition(self.barBg_:getContentSize().width / 2, self.barBg_:getContentSize().height / 2)
  self.progressTimer_:setMidpoint(cc.p(0, 0))
  self.progressTimer_:setBarChangeRate(cc.p(1, 0))
  self.progressTimer_:setPercentage(self.hpCur_ / self.hpMax_ * 100)
  self.towerBloodLabel_ = cc.ui.UILabel.new({
    UILabelType = 2,
    text = string.format("%d/%d", self.hpCur_, self.hpMax_),
    size = 20
  }):align(display.CENTER, self.barBg_:getContentSize().width / 2, self.barBg_:getContentSize().height / 2):addTo(self.barBg_, 1)
  if 5 ~= GameManager.MODE then
    local wandPic = display.newSprite(GameData.CIMELIA_ATK.wandIcon):scale(0.8):align(display.RIGHT_BOTTOM, -self.towerArmature_:getContentSize().width * 0.5, -15):addTo(self.towerArmature_)
    local wandBall = display.newSprite(GameData.CIMELIA_ATK.ballIcon):pos(wandPic:getContentSize().width * 0.5, wandPic:getContentSize().height + 40):addTo(wandPic)
    local sequence = transition.sequence({
      cc.MoveBy:create(0.5, cc.p(0, -10)),
      cc.MoveBy:create(0.5, cc.p(0, 10))
    })
    local action = cc.RepeatForever:create(sequence)
    wandBall:runAction(action)
    self.wandBall = wandBall
  end
  self.mFlag = 10
  self.mHitEffectCount = 0
  self.mCantAttack = false
end

function TowerBuddha:changeArmatureStateTo(state)
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

function TowerBuddha:underAttack(source, loseHp)
  DDLOG(DYLang.getString("S1501", ""), loseHp, self.hpMax_)
  if self.isInRecover_ then
    loseHp = 0
  end
  loseHp = Const.TowerBuddhaLoseHp or loseHp
  self.hpCur_ = self.hpCur_ - loseHp
  self:showDamage(loseHp)
  self:hurtEffect()
  if self.hpCur_ / self.hpMax_ >= 0.6666666666666666 then
    self:changeArmatureStateTo("HURT1")
  elseif self.hpCur_ / self.hpMax_ >= 0.3333333333333333 then
    self:changeArmatureStateTo("HURT2")
  else
    self:changeArmatureStateTo("HURT3")
  end
  if 6 == GameManager.MODE or 9 == GameManager.MODE then
    BMgrOL.setBuddhaTowerHp(self.hpCur_)
  end
  if 0 >= self.hpCur_ then
    self.towerBloodLabel_:setString(string.format("0/%d", self.hpMax_))
    self.progressTimer_:setPercentage(0)
    self:dead()
    return
  end
  self.towerBloodLabel_:setString(string.format("%d/%d", self.hpCur_, self.hpMax_))
  self.progressTimer_:setPercentage(self.hpCur_ / self.hpMax_ * 100)
end

function TowerBuddha:increaseHP(hp)
  self.hpCur_ = self.hpCur_ + hp
  DDLOG(self.hpCur_ .. "/" .. self.hpMax_)
  if self.hpCur_ > self.hpMax_ then
    self.hpCur_ = self.hpMax_
  end
  if self.hpCur_ < 0 then
    self.hpCur_ = 0
  end
  self.towerBloodLabel_:setString(string.format("%d/%d", self.hpCur_, self.hpMax_))
  self.progressTimer_:setPercentage(self.hpCur_ / self.hpMax_ * 100)
end

function TowerBuddha:updateHpRatio(ratio)
  local deltaHp = math.round(self.hpMax_ * ratio / 100)
  self:increaseHP(deltaHp)
end

function TowerBuddha:refreshProgress(hpCur)
  self.towerBloodLabel_:setString(string.format("%d/%d", hpCur, self.hpMax_))
  self.progressTimer_:setPercentage(hpCur / self.hpMax_ * 100)
end

function TowerBuddha:playCommonSkillEffect()
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

function TowerBuddha:hurtEffect()
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
    display.addSpriteFrames("buff/buff_effect.plist", "buff/buff_effect.png")
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

function TowerBuddha:showDamage(hpLose)
  if hpLose <= 0 then
    return
  end
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

function TowerBuddha:dead()
  if not self.mIsDead then
    self.mIsDead = true
    self:dispatchEvent({name = "GAME_LOSE"})
  end
end

function TowerBuddha:towerBoom()
  if self.towerArmature_:getChildByTag(100) then
    return
  end
  local m1 = cc.MoveBy:create(0.1, cc.p(-10, 0))
  local m2 = cc.MoveBy:create(0.1, cc.p(10, 0))
  display.addSpriteFrames("animation/tower_boom.plist", "animation/tower_boom.png")
  local frames = display.newFrames("ta-bazha-%d.png", 1, 17)
  local animation = display.newAnimation(frames, 0.07)
  local emptyPic = display.newSprite():pos(self.towerArmature_:getContentSize().width * 0.1, self.towerArmature_:getContentSize().height * 0.5):addTo(self.towerArmature_, 10, 100)
  emptyPic:setScale(1.5)
  emptyPic:playAnimationForever(animation, 0)
  DYSoundMgr.playEffect(DY_SND.sound_towerBoom)
  self:performWithDelay(function()
    self:dispatchEvent({name = "GAME_LOSE"})
  end, 2)
  self.towerArmature_:runAction(transition.sequence({
    m1,
    m2,
    m1,
    m2
  }))
end

function TowerBuddha:getMyBoundingBox()
  local tmpWidth = 0
  local size = cc.size(self.towerArmature_:getContentSize().width * Const.Zoom0, self.towerArmature_:getContentSize().height * Const.Zoom0)
  size.width = 130
  local tmpX = self:getPositionX()
  local tmpWidth = tmpX - size.width / 20
  return tmpWidth
end

function TowerBuddha:getContentSize()
  return self.towerArmature_:getContentSize()
end

function TowerBuddha:getActorType()
  return 1
end

function TowerBuddha:getCurABLY(index)
  return self.initABLY[index] + self.addABLY[index] + self.tmpABLY[index]
end

function TowerBuddha:addBuff()
  return nil
end

function TowerBuddha:getHp()
  return self.hpCur_
end

function TowerBuddha:getElementType()
  local tFunc = {
    [1] = 3,
    [2] = 4,
    [3] = 1,
    [4] = 2,
    [5] = 5
  }
  return tFunc[self.mElement]
end

function TowerBuddha:getElementValue(element)
  local res = 0
  local tFunc = {
    [1] = GameData.CIMELIA_DEF.propGold,
    [2] = GameData.CIMELIA_DEF.propWood,
    [3] = GameData.CIMELIA_DEF.propWater,
    [4] = GameData.CIMELIA_DEF.propFire,
    [5] = GameData.CIMELIA_DEF.propEarth
  }
  res = tFunc[element] + GameData.CIMELIA_DEF.propAllElements
  return res
end

function TowerBuddha:getLastHp()
  self.hpCur_ = self.hpCur_ - math.floor(self.hpMax_ * 0.15)
  if self.hpCur_ < 0 then
    self.hpCur_ = 0
  end
  return self.hpCur_
end

function TowerBuddha:getHpRate()
  return self.hpCur_ > 0 and math.floor(self.hpCur_ / self.hpMax_ * 100) or 0
end

function TowerBuddha:showShadow()
  if GameData.GAME_TYPE == 2 then
    return
  end
  local node = display.newNode()
  local node1 = display.newNode():scale(0.4):addTo(node)
  local node2 = display.newNode():scale(0.4):addTo(node)
  local node3 = display.newNode():scale(0.4):addTo(node)
  node:setCascadeOpacityEnabled(true)
  node1:setCascadeOpacityEnabled(true)
  node2:setCascadeOpacityEnabled(true)
  node3:setCascadeOpacityEnabled(true)
  node1:setOpacity(128)
  node2:setOpacity(128)
  node3:setOpacity(128)
  node1:setAnchorPoint(cc.p(0.5, 0))
  node2:setAnchorPoint(cc.p(0.5, 0))
  node3:setAnchorPoint(cc.p(0.5, 0))
  local towerArmature = GameData.CIMELIA_DEF.towerArmature
  local towerShaow1 = ccs.Armature:create(towerArmature):addTo(node1, -3)
  local towerShaow2 = ccs.Armature:create(towerArmature):addTo(node2, -2)
  local towerShaow3 = ccs.Armature:create(towerArmature):addTo(node3, -1)
  towerShaow1:setAnchorPoint(cc.p(0.5, 0))
  towerShaow2:setAnchorPoint(cc.p(0.5, 0))
  towerShaow3:setAnchorPoint(cc.p(0.5, 0))
  
  local function tFunc(sp)
    sp:runAction(cc.FadeOut:create(0.6))
    sp:runAction(cc.ScaleTo:create(0.6, 0.5))
  end
  
  tFunc(node1)
  node:performWithDelay(function()
    tFunc(node2)
  end, 0.1)
  node:performWithDelay(function()
    tFunc(node3)
  end, 0.2)
  node:performWithDelay(function()
    node:removeFromParent()
  end, 0.8)
  node:setAnchorPoint(cc.p(0.5, 0))
  node:addTo(self)
end

return TowerBuddha

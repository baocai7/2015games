local GameDialogue = require("app.utils.GameDialogue")
local NoviceGuide = require("app.utils.NoviceGuide")
local CimeliaSkill = require("app.sprites.pvp.CimeliaSkillModel")
local TowerMonster = {}
TowerMonster = class("TowerMonster", function()
  return display.newNode()
end)

function TowerMonster:ctor(towerMonsterModel, gameMode)
  cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
  self.mFlag = 9
  self.mGameMode = gameMode
  self:initData(towerMonsterModel)
  self:initExtra()
  self.mHitEffectCount = 0
  self:setNodeEventEnabled(true)
  self.mCantAttack = false
  if 0 == GameManager.STAGE_NUM and 0 == GameManager.MODE then
    self:performWithDelay(function()
      self:makeMonsterStage0()
    end, 0.1)
    return
  end
  if gameMode == "infiniteMode" then
  elseif gameMode == "pvp" then
  else
    self:performWithDelay(function()
      self:checkStageAI()
      DDLOG("AI is BEGIN")
    end, 1.5)
  end
end

function TowerMonster:onEnter()
end

function TowerMonster:onExit()
  DYNotification.removeAllObservers(self)
  table.walk(self.mNotifyNodes, function(v, k)
    DYNotification.removeAllObservers(v)
  end)
end

function TowerMonster:initData(towerMonsterModel)
  if not towerMonsterModel then
    self.model_ = DataUtils.getDefCimeliaInfo(CloudData.ENEMY_CIMELIA_INFO.defCimelia, CloudData.ENEMY_TREASURE_INFO)
  else
    self.model_ = towerMonsterModel
    towerMonsterModel = nil
  end
  self.hpMax_ = self.model_.towerHP
  self.hpCur_ = self.hpMax_
  self.mElement = self.model_.element
  if GameManager.MODE == 8 then
    local hpCur = GameData.getMonsterTowerHP()
    if 0 < hpCur then
      self.hpCur_ = hpCur
    end
  end
  GameData.setMonsterTowerHP(self.hpCur_)
  self.mStrategy1 = 0
  self.mStrategy2 = 0
  self.mSkillIcons = {}
  self.mIsOnAction1 = false
  self.mIsOnAction2 = false
  if GameManager.MODE < 2 and 0 < GameManager.STAGE_NUM then
    self.mAIData = DataUtils.getStageAIData(GameManager.MODE, GameManager.STAGE_ID)
    for k, v in pairs(self.mAIData.actionType) do
      local pType = tonumber(v)
      if 1 == pType then
        self.mStrategy1 = self.mStrategy1 + 1
      elseif 3 == pType or 5 == pType then
        local skillModel = DataUtils.getCimeliaSkillBaseModel(self.mAIData.actionId[k])
        local skillIcon = skillModel.skillIcon
        table.insert(self.mSkillIcons, skillIcon)
        self.mStrategy2 = self.mStrategy2 + 1
      end
    end
  end
  DYComponent.getTable(self, "battleData.baseData")
  self.mNotifyNodes = {}
end

function TowerMonster:initExtra()
  if "infiniteMode" == self.mGameMode then
    self:initTowerImageFigure(14)
  elseif "pvp" == self.mGameMode then
    self:initPVPTower()
  else
    self:initTowerImageFigure(tonumber(self.model_.towerType))
  end
  local barBg = display.newSprite("gamescene/bar_bg_tower_m.png", self.towerBg_:getContentSize().width * 0.5, self.towerBg_:getContentSize().height * 1.15):addTo(self.towerBg_)
  self.progressTimer_ = cc.ProgressTimer:create(display.newSprite("gamescene/bar_hp_tower_m.png")):addTo(barBg)
  self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.progressTimer_:setPosition(barBg:getContentSize().width / 2, barBg:getContentSize().height / 2)
  self.progressTimer_:setMidpoint(cc.p(0, 0))
  self.progressTimer_:setBarChangeRate(cc.p(1, 0))
  self.progressTimer_:setPercentage(100)
  self.barBg = barBg
  if 0 < self.mStrategy1 and 0 < self.mStrategy2 then
    self.mBossAlert = display.newSprite("gamescene/alert_boss.png"):pos(barBg:getContentSize().width * 0.32, barBg:getContentSize().height + 30):addTo(barBg)
    self.mSkillAlert = display.newSprite(self.mSkillIcons[1]):scale(0.5217391304347826):pos(barBg:getContentSize().width * 0.68, barBg:getContentSize().height + 30):addTo(barBg)
  elseif 0 < self.mStrategy1 then
    self.mBossAlert = display.newSprite("gamescene/alert_boss.png"):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height + 30):addTo(barBg)
  elseif 0 < self.mStrategy2 then
    self.mSkillAlert = display.newSprite(self.mSkillIcons[1]):scale(0.5217391304347826):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height + 30):addTo(barBg)
  end
  if 3 == GameManager.MODE or 10 == GameManager.MODE then
    barBg:setVisible(false)
  end
  if "pvp" == self.mGameMode then
    barBg:setPosition(0, self.towerBg_:getContentSize().height - 10)
    barBg:setScaleX(-1)
  end
  if "infiniteMode" ~= self.mGameMode then
    self.towerBloodLabel_ = cc.ui.UILabel.new({
      UILabelType = 2,
      text = string.format("%d/%d", GameData.getMonsterTowerHP(), self.hpMax_),
      size = 20
    }):align(display.CENTER, barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  end
end

function TowerMonster:checkStageAI()
  local AIData = self.mAIData or DataUtils.getStageAIData(GameManager.MODE, GameManager.STAGE_ID)
  dump(AIData, "AIData : ")
  local normalIdx = 1
  
  local function tNormalEnd()
    normalIdx = normalIdx + 1
    if normalIdx <= #AIData.normalId then
      local strategyId = AIData.normalId[normalIdx]
      self:performWithDelay(function()
        self:triggerStrategyTo(strategyId, tNormalEnd)
      end, 0)
    end
  end
  
  local strategyId = AIData.normalId[normalIdx]
  self:triggerStrategyTo(strategyId, tNormalEnd)
  local cycleIdx = 1
  
  local function tCycleEnd()
    local strategyId
    if 1 == #AIData.cycleId then
      strategyId = AIData.cycleId[1]
    else
      cycleIdx = cycleIdx + 1
      strategyId = AIData.cycleId[cycleIdx]
      if cycleIdx == #AIData.cycleId then
        cycleIdx = 0
      end
    end
    self:performWithDelay(function()
      self:triggerStrategyTo(strategyId, tCycleEnd)
    end, 0)
  end
  
  local strategyId = AIData.cycleId[cycleIdx]
  self:triggerStrategyTo(strategyId, tCycleEnd)
  local n_key = {
    [2] = DY_KEY.kTowerBlood,
    [3] = DY_KEY.kBuddhaCreateNum,
    [4] = DY_KEY.kMonsterCreateNum,
    [5] = DY_KEY.kBuddhaDeadNum,
    [6] = DY_KEY.kMonsterDeadNum
  }
  
  local function tCondStrategy(k, v, symbol)
    local pNode = display.newNode():addTo(self)
    table.insert(self.mNotifyNodes, pNode)
    local key = n_key[v]
    DYNotification.registerScriptObserver(pNode, function(name, param)
      local num = (param - AIData.checkNum[k]) * symbol
      if 0 <= num then
        DYNotification.unregisterScriptObserver(pNode, key)
        self:towerAction(AIData.actionType[k], AIData.actionId[k], AIData.actionTimes[k], AIData.isWarning[k])
      end
    end, key)
  end
  
  for k, v in pairs(AIData.checkType) do
    if 1 == tonumber(v) then
      self:performWithDelay(function()
        if 1 == tonumber(AIData.actionType[k]) then
          DDLOG("================ \229\141\179\229\176\134\229\135\186\231\142\176\228\184\128\229\164\167\230\179\162\229\133\181")
        else
          DDLOG("================ \230\149\140\230\150\185\229\161\148\229\141\179\229\176\134\233\135\138\230\148\190\230\138\128\232\131\189")
        end
      end, tonumber(AIData.checkNum[k]) - 5)
      self:performWithDelay(function()
        self:towerAction(AIData.actionType[k], AIData.actionId[k], AIData.actionTimes[k], AIData.isWarning[k])
      end, tonumber(AIData.checkNum[k]))
    elseif 2 == tonumber(v) then
      tCondStrategy(k, tonumber(v), -1)
    elseif 2 < tonumber(v) then
      tCondStrategy(k, tonumber(v), 1)
    end
  end
end

function TowerMonster:towerAction(ationType, actionId, actionTimes, isWarning)
  actionTimes = actionTimes or 1
  isWarning = isWarning or 0
  if 1 == tonumber(isWarning) then
    print(" ================= Strategy Warning!!!!!!!!")
    SpriteViewMgr.createFBIWarning():pos(display.cx, display.cy):addTo(self:getParent():getParent(), 20)
  end
  if 1 == tonumber(ationType) then
    self:spawnTroops(actionId, actionTimes)
  elseif 2 == tonumber(ationType) then
  elseif 3 == tonumber(ationType) then
    self:castWandSkill(actionId)
  elseif 4 == tonumber(ationType) then
  elseif 5 == tonumber(ationType) then
    self:castTowerSkill(actionId)
  end
  self:alertUpdate(ationType)
end

function TowerMonster:spawnTroops(id, times)
  id = tonumber(id)
  times = tonumber(times)
  local idx = 1
  
  local function tActionEnd()
    idx = idx + 1
    if idx <= times then
      self:performWithDelay(function()
        self:triggerStrategyTo(id, tActionEnd)
      end, 0)
    end
  end
  
  self:triggerStrategyTo(id, tActionEnd)
end

function TowerMonster:triggerStrategyTo(strategyId_, handler_)
  if not strategyId_ or 0 == tonumber(strategyId_) then
    if handler_ then
      handler_()
    end
    return
  end
  print("strategyId_ : " .. strategyId_)
  local sData = DataUtils.getStrategyData(GameManager.MODE, strategyId_)
  dump(sData, "sData : ", 9)
  
  local function tFuncTryCreate(monsterId)
    if #BMgr.getMonsterList() >= GameData.MAX_MONSTER_NUM then
      self:performWithDelay(function()
        tFuncTryCreate(monsterId)
      end, 0.5)
    elseif (GameManager.MODE == 3 or GameManager.MODE == 10) and GameData.BOSS_ID == monsterId then
      BMgr.createMonsterBoss(self:getParent(), monsterId, nil, 1)
    else
      BMgr.createMonster(self:getParent(), monsterId, nil, 1)
    end
  end
  
  local function tFuncCreateMonster(tb, num)
    for i = 1, #tb do
      for j = 1, tonumber(num[i]) do
        self:performWithDelay(function()
          self:showDoorAnimation()
          tFuncTryCreate(tonumber(tb[i]))
        end, 0.5 * (j - 1))
      end
    end
  end
  
  local function tFuncCreateMonsterEx(tb, num)
    tFuncCreateMonster(tb, num)
    if handler_ then
      handler_()
    end
  end
  
  for i = 1, sData.waves do
    local readyTime = sData.strategy[i].readyTime
    local monsterIds = sData.strategy[i].monsterIds
    local monsterNum = sData.strategy[i].monsterNum
    if i == sData.waves then
      self:performWithDelay(function()
        tFuncCreateMonsterEx(monsterIds, monsterNum)
      end, readyTime)
    else
      self:performWithDelay(function()
        tFuncCreateMonster(monsterIds, monsterNum)
      end, readyTime)
    end
  end
end

function TowerMonster:showDoorAnimation()
  local doorOpen = cc.CallFunc:create(function()
    self:openDoor()
  end)
  local doorClose = cc.CallFunc:create(function()
    self:closeDoor()
  end)
  self:runAction(transition.sequence({
    doorOpen,
    cc.DelayTime:create(1),
    doorClose
  }))
end

function TowerMonster:initTowerImageFigure(towerType)
  if towerType == 0 then
    self.door_ = display.newSprite("animation/first.png"):addTo(self, -3)
    self.door_:setAnchorPoint(cc.p(0.5, 0))
    self.door_:setScale(0.4)
    self.dark_ = display.newSprite("gamescene/tower_enemy_0.png"):addTo(self, -2)
    self.dark_:setAnchorPoint(cc.p(0.5, 0))
    self.dark_:setScale(0.4)
    self.light_ = display.newSprite("gamescene/tower_enemy_1.png"):addTo(self, -1)
    self.light_:setAnchorPoint(cc.p(0.5, 0))
    self.light_:setScale(0.4)
    self.light_:runAction(cc.RepeatForever:create(transition.sequence({
      cc.FadeIn:create(1.5),
      cc.FadeOut:create(1.5)
    })))
    self.towerBg_ = display.newSprite("gamescene/tower_enemy_2.png"):addTo(self, 0)
    self.towerBg_:setAnchorPoint(cc.p(0.5, 0))
    self.towerBg_:setScale(0.4)
    self.halo_ = display.newSprite("gamescene/tower_enemy_3.png"):addTo(self, 1)
    self.halo_:setAnchorPoint(cc.p(0.5, 0))
    self.halo_:setScale(0.4)
    self.halo_:runAction(cc.RepeatForever:create(transition.sequence({
      cc.FadeIn:create(1.5),
      cc.FadeOut:create(1.5)
    })))
  elseif towerType == 6 or towerType == 8 then
    self.door_ = display.newSprite("animation/first.png"):addTo(self, -3)
    self.door_:setAnchorPoint(cc.p(0.5, 0))
    self.door_:setScale(0.4)
    self.backBg_ = display.newSprite(string.format("monster_tower/" .. towerType .. "/back.png")):addTo(self, -2)
    self.backBg_:setAnchorPoint(cc.p(0.5, 0))
    self.backBg_:setScale(0.4)
    self.halo_ = display.newSprite(string.format("monster_tower/" .. towerType .. "/halo.png"))
    self.halo_:setAnchorPoint(cc.p(0.5, 0.5))
    if towerType == 6 then
      self.halo_:setPosition(cc.p(self.backBg_:getContentSize().width * 0.475, self.backBg_:getContentSize().height * 0.34))
    else
      self.halo_:setPosition(cc.p(self.backBg_:getContentSize().width * 0.5, self.backBg_:getContentSize().height * 0.35))
    end
    self.halo_:runAction(cc.RepeatForever:create(cc.RotateBy:create(0.5, 90)))
    self.backBg_:addChild(self.halo_)
    self.towerBg_ = display.newSprite(string.format("monster_tower/" .. towerType .. "/front.png")):addTo(self, 0)
    self.towerBg_:setAnchorPoint(cc.p(0.5, 0))
    self.towerBg_:setScale(0.4)
  elseif towerType == 12 then
    self.door_ = display.newSprite("animation/first.png"):addTo(self, -3)
    self.door_:setAnchorPoint(cc.p(0.5, 0))
    self.door_:setScale(0.4)
    self.towerBg_ = display.newSprite(string.format("monster_tower/" .. towerType .. "/bg.png")):addTo(self, 1)
    self.towerBg_:setAnchorPoint(cc.p(0.5, 0))
    self.towerBg_:setScale(0.4)
  elseif towerType == 13 then
    self.towerBg_ = display.newSprite(string.format("monster_tower/" .. towerType .. "/bg.png")):addTo(self, 1)
    self.towerBg_:setAnchorPoint(cc.p(0.5, 0))
    self.towerBg_:setScale(0.4)
    self.backBg_ = display.newSprite("monster_tower/" .. towerType .. "/door.png"):addTo(self, -1)
    self.backBg_:setAnchorPoint(cc.p(0.5, 0))
    self.backBg_:setScale(0.4)
    self.door_ = display.newSprite(string.format("monster_tower/" .. towerType .. "/door1.png")):addTo(self, 0)
    self.door_:setAnchorPoint(cc.p(0.5, 0))
    self.door_:setScale(0.4)
    self.door1_ = display.newSprite(string.format("monster_tower/" .. towerType .. "/door2.png")):addTo(self, 0)
    self.door1_:setAnchorPoint(cc.p(0.5, 0))
    self.door1_:setScale(0.4)
  elseif towerType == 14 then
    self.towerBg_ = display.newSprite(string.format("monster_tower/" .. towerType .. "/bg.png"), 0, -30):addTo(self, 1)
    self.towerBg_:setAnchorPoint(cc.p(0.5, 0))
    self.towerBg_:setScale(0.4)
    self.door_ = display.newSprite(string.format("monster_tower/" .. towerType .. "/door.png"), self.towerBg_:getContentSize().width * 0.5, self.towerBg_:getContentSize().height * 0.63):addTo(self.towerBg_)
    self.door_:runAction(cc.RepeatForever:create(cc.RotateBy:create(0.5, 360)))
  else
    self.towerBg_ = display.newSprite(string.format("monster_tower/" .. towerType .. "/bg.png")):addTo(self, 0)
    self.towerBg_:setAnchorPoint(cc.p(0.5, 0))
    self.towerBg_:setScale(0.4)
    self.door_ = display.newSprite("monster_tower/" .. towerType .. "/door.png"):addTo(self, 1)
    self.door_:setAnchorPoint(cc.p(0.5, 0))
    self.door_:setScale(0.4)
    self.door_:setVisible(false)
  end
end

function TowerMonster:initPVPTower()
  local towerArmature = self.model_.towerArmature
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb", towerArmature, towerArmature))
  self.towerBg_ = ccs.Armature:create(towerArmature)
  self.towerBg_:getAnimation():playWithIndex(0)
  self.towerBg_:setAnchorPoint(0.5, 0)
  self.towerBg_:setScale(-0.4, 0.4)
  self:addChild(self.towerBg_)
  
  local function animationEvent(armatureBack, movementType, movementID)
    local id = movementID
    local currHp = GameData.getMonsterTowerHP()
    if movementType == ccs.MovementEventType.loopComplete then
      if id == "under_attack1" then
        if currHp / self.hpMax_ >= 0.6666666666666666 then
          self:changeArmatureStateTo("IDLE1")
        elseif currHp / self.hpMax_ >= 0.3333333333333333 then
          self:changeArmatureStateTo("IDLE2")
        else
          self:changeArmatureStateTo("IDLE3")
        end
      elseif id == "under_attack2" then
        if currHp / self.hpMax_ >= 0.3333333333333333 then
          self:changeArmatureStateTo("IDLE2")
        else
          self:changeArmatureStateTo("IDLE3")
        end
      elseif id == "under_attack3" then
        self:changeArmatureStateTo("IDLE3")
      end
    end
  end
  
  self.towerBg_:getAnimation():setMovementEventCallFunc(animationEvent)
end

function TowerMonster:alertUpdate(ationType)
  local pType = tonumber(ationType)
  if self.mBossAlert and 1 == pType then
    self.mStrategy1 = self.mStrategy1 - 1
    if self.mIsOnAction1 then
      return
    end
    self.mIsOnAction1 = true
    local spawn = cc.Spawn:create(cc.FadeOut:create(1), cc.MoveBy:create(1, cc.p(0, 100)))
    self.mBossAlert:runAction(spawn)
    if self.mStrategy1 > 0 then
      local seq = transition.sequence({
        cc.DelayTime:create(1),
        cc.MoveBy:create(0.02, cc.p(0, -100)),
        cc.FadeIn:create(0.5),
        cc.CallFunc:create(function()
          self.mIsOnAction1 = false
        end)
      })
      self.mBossAlert:runAction(seq)
    end
  elseif self.mSkillAlert and (3 == pType or 5 == pType) then
    self.mStrategy2 = self.mStrategy2 - 1
    if self.mIsOnAction2 then
      return
    end
    self.mIsOnAction2 = true
    local spawn = cc.Spawn:create(cc.FadeOut:create(1), cc.MoveBy:create(1, cc.p(0, 100)))
    self.mSkillAlert:runAction(spawn)
    if 0 < self.mStrategy2 then
      local seq = transition.sequence({
        cc.DelayTime:create(1),
        cc.CallFunc:create(function()
          local idx = #self.mSkillIcons - self.mStrategy2 + 1
          self.mSkillAlert:setTexture(self.mSkillIcons[idx])
        end),
        cc.MoveBy:create(0.02, cc.p(0, -100)),
        cc.FadeIn:create(0.5),
        cc.CallFunc:create(function()
          self.mIsOnAction2 = false
        end)
      })
      self.mSkillAlert:runAction(seq)
    end
  end
end

function TowerMonster:changeArmatureStateTo(state)
  if state == "IDLE1" then
    if self.curArmatureState_ ~= "IDLE" then
      self.curArmatureState_ = "IDLE"
      self.towerBg_:getAnimation():playWithIndex(0)
    end
  elseif state == "IDLE2" then
    if self.curArmatureState_ ~= "IDLE" then
      self.curArmatureState_ = "IDLE"
      self.towerBg_:getAnimation():playWithIndex(2)
    end
  elseif state == "IDLE3" then
    if self.curArmatureState_ ~= "IDLE" then
      self.curArmatureState_ = "IDLE"
      self.towerBg_:getAnimation():playWithIndex(4)
    end
  elseif state == "HURT1" then
    if self.curArmatureState_ ~= "HURT" then
      self.curArmatureState_ = "HURT"
      self.towerBg_:getAnimation():playWithIndex(1)
    end
  elseif state == "HURT2" then
    if self.curArmatureState_ ~= "HURT" then
      self.curArmatureState_ = "HURT"
      self.towerBg_:getAnimation():playWithIndex(3)
    end
  elseif state == "HURT3" and self.curArmatureState_ ~= "HURT" then
    self.curArmatureState_ = "HURT"
    self.towerBg_:getAnimation():playWithIndex(5)
  end
end

function TowerMonster:underAttack(source, loseHp)
  self:hurtEffect()
  local currHp = GameData.getMonsterTowerHP()
  DDLOG("currHp : " .. currHp)
  DDLOG("loseHp : " .. loseHp)
  currHp = currHp - loseHp
  GameData.setMonsterTowerHP(currHp)
  self:showDamage(loseHp)
  DYNotification.postNotification(DY_KEY.kTowerBlood, currHp / self.hpMax_ * 100)
  if "pvp" == self.mGameMode then
    if currHp / self.hpMax_ >= 0.6666666666666666 then
      self:changeArmatureStateTo("HURT1")
    elseif currHp / self.hpMax_ >= 0.3333333333333333 then
      self:changeArmatureStateTo("HURT2")
    else
      self:changeArmatureStateTo("HURT3")
    end
  end
  if currHp <= 0 then
    if "infiniteMode" ~= self.mGameMode then
      self.towerBloodLabel_:setString(string.format("0/%d", self.hpMax_))
    end
    self.progressTimer_:setPercentage(0)
    self:onDead()
    DYNotification.removeAllObservers(self)
    return
  end
  if "infiniteMode" ~= self.mGameMode then
    self.towerBloodLabel_:setString(string.format("%d/%d", currHp, self.hpMax_))
  end
  self.progressTimer_:setPercentage(currHp / self.hpMax_ * 100)
end

function TowerMonster:increaseHP(hp)
  local currHp = GameData.getMonsterTowerHP()
  currHp = currHp + hp
  if currHp > self.hpMax_ then
    currHp = self.hpMax_
  end
  if currHp < 0 then
    currHp = 0
  end
  GameData.setMonsterTowerHP(currHp)
  self:refreshProgress(currHp)
end

function TowerMonster:updateHpRatio(ratio)
  local deltaHp = math.round(self.hpMax_ * ratio / 100)
  self:increaseHP(deltaHp)
end

function TowerMonster:refreshProgress(hpCur)
  self.towerBloodLabel_:setString(string.format("%d/%d", hpCur, self.hpMax_))
  self.progressTimer_:setPercentage(hpCur / self.hpMax_ * 100)
end

function TowerMonster:showDamage(hpLose)
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

function TowerMonster:onDead()
  self:towerBoom(function()
    if not self.mIsDead then
      self.mIsDead = true
      self:dispatchEvent({name = "GAME_WIN"})
    end
  end)
end

function TowerMonster:addBuff()
  return nil
end

function TowerMonster:hurtEffect()
  if not self.isInTint_ then
    self.isInTint_ = true
    local tint = cc.TintTo:create(0, 243, 83, 7)
    local tintBack = cc.TintTo:create(0, 255, 255, 255)
    local dt = cc.DelayTime:create(0.4)
    self.towerBg_:runAction(transition.sequence({
      tint,
      dt,
      tintBack,
      cc.CallFunc:create(function()
        self.isInTint_ = false
      end)
    }))
  end
  if not self.isInShake_ then
    self.isInShake_ = true
    local m1 = cc.MoveBy:create(0.1, cc.p(-3, 0))
    local m2 = cc.MoveBy:create(0.1, cc.p(3, 0))
    self:runAction(transition.sequence({
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
    local frames = display.newFrames("shouji%d.png", 1, 5)
    local animation = display.newAnimation(frames, 0.07)
    local sp = display.newSprite()
    sp:setAnchorPoint(cc.p(0.5, 0))
    local rect = self:getContentSize()
    local tmpScale = (rect.width / 1.4 + rect.height / 1.4) / 600
    local tmpRand = math.random(-10, 10)
    sp:setScale(tmpScale - tmpRand / 40)
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

function TowerMonster:towerBoom(cb)
  self:performWithDelay(cb, 2)
  if self.towerBg_:getChildByTag(100) then
    return
  end
  display.addSpriteFrames("animation/tower_boom.plist", "animation/tower_boom.png")
  local frames = display.newFrames("ta-bazha-%d.png", 1, 17)
  local animation = display.newAnimation(frames, 0.07)
  local emptyPic = display.newSprite():pos(self.towerBg_:getContentSize().width * 0.5, self.towerBg_:getContentSize().height * 0.5):addTo(self.towerBg_, 10, 100)
  emptyPic:setScale(1.5)
  emptyPic:playAnimationForever(animation, 0)
  local m1 = cc.MoveBy:create(0.1, cc.p(-10, 0))
  local m2 = cc.MoveBy:create(0.1, cc.p(10, 0))
  self.towerBg_:runAction(transition.sequence({
    m1,
    m2,
    m1,
    m2
  }))
  DYSoundMgr.playEffect(DY_SND.sound_towerBoom)
end

function TowerMonster:getMyBoundingBox()
  local tmpWidth = 0
  local size = cc.size(self.towerBg_:getContentSize().width * Const.Zoom0, self.towerBg_:getContentSize().height * Const.Zoom0)
  size.width = 130
  local tmpX = self:getPositionX()
  local tmpWidth = tmpX + size.width / 20
  return tmpWidth
end

function TowerMonster:openDoor()
  if tonumber(self.model_.towerType) == 13 then
    self.door_:setVisible(false)
    self.door1_:setVisible(false)
  elseif self.door_ then
    self.door_:setVisible(true)
  end
end

function TowerMonster:closeDoor()
  if tonumber(self.model_.towerType) == 13 then
    self.door_:setVisible(true)
    self.door1_:setVisible(true)
  elseif self.door_ then
    self.door_:setVisible(false)
  end
end

function TowerMonster:castWandSkill(actionId)
  if not self.mAtkCimelia then
    local cimeliaAtkParam = {
      cimeliaType = "atk",
      atk = {
        flag = FLAG_TOWER_MONSTER,
        skillId = tonumber(actionId),
        atk = self.model_.phyAtk,
        aktType = self.model_.magAtk,
        atkDis = 1000,
        hitRate = 115,
        critRate = 0,
        critHarmRate = 150,
        magDefIgnore = 0,
        phyDefIgnore = 0,
        element = self.model_.element,
        elementValue = {
          [1] = self.model_.propGold + self.model_.propAllElements,
          [2] = self.model_.propWood + self.model_.propAllElements,
          [3] = self.model_.propWater + self.model_.propAllElements,
          [4] = self.model_.propFire + self.model_.propAllElements,
          [5] = self.model_.propEarth + self.model_.propAllElements
        }
      }
    }
    self.mAtkCimelia = CimeliaSkill.new(cimeliaAtkParam)
  end
  self.mAtkCimelia:castSkill()
  local delayTime = GameData.SKILL_DELAY or 0.5
  self:performWithDelay(function()
    self.mAtkCimelia:updateNpcBlood()
  end, delayTime)
end

function TowerMonster:castTowerSkill(actionId)
  if not self.mDefCimelia then
    local cimeliaDefParam = {
      cimeliaType = "def",
      def = {
        flag = FLAG_TOWER_MONSTER,
        skillId = tonumber(actionId),
        atk = 0,
        aktType = 1,
        atkDis = -1
      }
    }
    self.mDefCimelia = CimeliaSkill.new(cimeliaDefParam)
  end
  if 588002 == tonumber(actionId) or 588203 == tonumber(actionId) then
    self.mDefCimelia:castPVETowerSkill()
  else
    self.mDefCimelia:castSkillTower()
  end
end

function TowerMonster:getHp()
  local currHp = GameData.getMonsterTowerHP()
  return currHp
end

function TowerMonster:getLastHp()
  local currHp = GameData.getMonsterTowerHP()
  currHp = currHp - math.floor(self.hpMax_ * 0.15)
  if currHp < 0 then
    currHp = 0
  end
  GameData.setMonsterTowerHP(currHp)
  return currHp
end

function TowerMonster:getHpRate()
  local currHp = GameData.getMonsterTowerHP()
  return 0 < currHp and math.floor(currHp / self.hpMax_ * 100) or 0
end

function TowerMonster:getCurABLY(index)
  return self.initABLY[index] + self.addABLY[index] + self.tmpABLY[index]
end

function TowerMonster:getElementType()
  local tFunc = {
    [1] = 3,
    [2] = 4,
    [3] = 1,
    [4] = 2,
    [5] = 5
  }
  return tFunc[self.mElement]
end

function TowerMonster:getElementValue(element)
  local res = 0
  local tFunc = {
    [1] = self.model_.propGold,
    [2] = self.model_.propWood,
    [3] = self.model_.propWater,
    [4] = self.model_.propFire,
    [5] = self.model_.propEarth
  }
  res = tFunc[element] + self.model_.propAllElements
  return res
end

function TowerMonster:getContentSize()
  return self.towerBg_:getContentSize()
end

function TowerMonster:getActorType()
  return 1
end

function TowerMonster:makeMonsterStage0()
  local monsterIds = {
    "1",
    "2",
    "3",
    "5",
    "6",
    "7"
  }
  local bajieTime = 2
  local wukongTime = 5
  local shasengTime = 7
  local faqiTime = 28
  local boss1Time = 22
  local boss2Time = 24
  local wutianTime = 30
  for i = 1, 5 do
    local randNum = math.random(1, 6)
    local monsterId = monsterIds[randNum]
    local pos = cc.p(self:getPositionX() + GameData.TOWER_DISTANCE * 0.5 - i * 60, self:getPositionY() + (randNum - 2) * 5)
    BMgr.createMonster(self:getParent(), monsterId, pos, 1)
  end
  self.mScheduleStage0 = self:schedule(function()
    local randNum = math.random(1, 6)
    local monsterId = monsterIds[randNum]
    BMgr.createMonster(self:getParent(), monsterId)
  end, 5)
  
  local function tFunc()
    self:resume()
    GameData.GAME_LAYER:gameResume()
  end
  
  self:performWithDelay(function()
    self:pause()
    GameData.GAME_LAYER:gamePause()
    local drama = GameDialogue.new("STAGE0_1", tFunc):addTo(GameData.GAME_LAYER, 20)
  end, 1)
  
  local function tFunc()
    self:resume()
    local guide = DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE0_LAYER0_1") or NoviceGuide.new("GUDIE_STAGE0_LAYER0_1", function()
      GameData.GAME_LAYER:gameResume()
    end, {
      GameData.TEAM_ICON[1]
    }):addTo(GameData.GAME_LAYER, 50)
  end
  
  self:performWithDelay(function()
    GameData.TEAM_ICON[1]:removeProTimer()
  end, bajieTime - 0.2)
  self:performWithDelay(function()
    self:pause()
    GameData.GAME_LAYER:gamePause()
    local drama = GameDialogue.new("STAGE0_2", tFunc):addTo(GameData.GAME_LAYER, 20)
  end, bajieTime)
  
  local function tFunc()
    self:resume()
    local guide = DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE0_LAYER0_2") or NoviceGuide.new("GUDIE_STAGE0_LAYER0_2", function()
      GameData.GAME_LAYER:gameResume()
    end):addTo(GameData.GAME_LAYER, 50)
  end
  
  self:performWithDelay(function()
    GameData.TEAM_ICON[2]:removeProTimer()
  end, wukongTime - 0.2)
  self:performWithDelay(function()
    self:pause()
    GameData.GAME_LAYER:gamePause()
    local drama = GameDialogue.new("STAGE0_3", tFunc):addTo(GameData.GAME_LAYER, 20)
  end, wukongTime)
  
  local function tFunc()
    self:resume()
    GameData.GAME_LAYER:gameResume()
    local guide = DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE0_LAYER0_3") or NoviceGuide.new("GUDIE_STAGE0_LAYER0_3"):addTo(GameData.GAME_LAYER, 50)
  end
  
  self:performWithDelay(function()
    GameData.TEAM_ICON[3]:removeProTimer()
  end, shasengTime - 0.2)
  self:performWithDelay(function()
    self:pause()
    GameData.GAME_LAYER:gamePause()
    local drama = GameDialogue.new("STAGE0_4", tFunc):addTo(GameData.GAME_LAYER, 20)
  end, shasengTime)
  
  local function tFunc()
    self:resume()
    local guide = DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE0_LAYER0_4") or NoviceGuide.new("GUDIE_STAGE0_LAYER0_4", function()
      GameData.GAME_LAYER:gameResume()
    end):addTo(GameData.GAME_LAYER, 50)
  end
  
  self:performWithDelay(function()
    self:pause()
    GameData.GAME_LAYER:gamePause()
    GameData.GAME_LAYER.mCimeliaPanel:removeProTimer()
    local drama = GameDialogue.new("STAGE0_5", tFunc):addTo(GameData.GAME_LAYER, 20)
  end, faqiTime)
  self:performWithDelay(function()
    BMgr.createMonster(self:getParent(), "9", nil, 1)
  end, boss1Time)
  self:performWithDelay(function()
    BMgr.createMonster(self:getParent(), "12", nil, 1)
  end, boss2Time)
  self:performWithDelay(function()
    SpriteViewMgr.createFBIWarning():pos(display.cx, display.cy):addTo(GameData.GAME_LAYER, 20)
  end, wutianTime - 5)
  
  local function tFunc()
    self:resume()
    GameData.GAME_LAYER:gameResume()
    self:wuTianShow()
  end
  
  self:performWithDelay(function()
    self:pause()
    GameData.GAME_LAYER:gamePause()
    local drama = GameDialogue.new("STAGE0_6", tFunc):addTo(GameData.GAME_LAYER, 20)
  end, wutianTime)
end

function TowerMonster:wuTianShow()
  local pLayer = GameData.GAME_LAYER
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.05, 1.1),
    cc.ScaleTo:create(0.04, 0.95),
    cc.ScaleTo:create(0.06, 1.1),
    cc.ScaleTo:create(0.05, 1)
  })
  pLayer:runAction(transition.sequence({
    popupLayer,
    popupLayer,
    popupLayer
  }))
  self:performWithDelay(function()
    self.mArmature = BMgr.createMonster(self:getParent(), "10", nil, 1)
    self.mArmature.mView:setAnimationSpeed(1)
    self.mArmature:setLocalZOrder(15)
  end, 1.2)
  
  local function tFunc()
    self:resume()
    GameData.GAME_LAYER:gameResume()
    self.mArmature.mState = "AnimationPlay"
  end
  
  self:performWithDelay(function()
    self:pause()
    GameData.GAME_LAYER:gamePause()
    local drama = GameDialogue.new("STAGE0_7", tFunc):addTo(GameData.GAME_LAYER, 20)
  end, 3)
  self:performWithDelay(function()
    self:stopAction(self.mScheduleStage0)
    self:devour()
  end, 5)
end

function TowerMonster:devour()
  local pLayer = GameData.GAME_LAYER
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.05, 1.1),
    cc.ScaleTo:create(0.04, 0.95),
    cc.ScaleTo:create(0.06, 1.1),
    cc.ScaleTo:create(0.05, 1)
  })
  pLayer:runAction(transition.sequence({
    popupLayer,
    popupLayer,
    popupLayer
  }))
  GameData.GAME_LAYER.mSkillArmature:getAnimation():play("wufawutian")
  pLayer.mRedBg:show()
  pLayer.mRedBg:runAction(transition.sequence({
    cc.Blink:create(3, 15),
    cc.CallFunc:create(function()
      pLayer.mRedBg:removeSelf()
    end)
  }))
  local monsterList = BMgr.getMonsterList()
  for k, v in pairs(monsterList) do
    if v.model_.npcId ~= 10 then
      v:hide()
      
      function v.mView.SpiritCover()
        return true
      end
      
      v:onKillByWutian(cc.p(self.mArmature:getPosition()))
    end
  end
  local buddhaList = BMgr.getBuddhaList()
  for k, v in pairs(buddhaList) do
    v:hide()
    v:onKillByWutian(cc.p(self.mArmature:getPosition()))
  end
  self:performWithDelay(function()
    function self.mArmature.mView.update()
      return nil
    end
    
    self.mArmature:setPosition(cc.p(BMgrOL.getBuddhaPos()))
    self.mArmature.mView:moveTo(1, BMgrOL.getBuddhaPos().x - 150, BMgrOL.getBuddhaPos().y)
    self:performWithDelay(function()
      local point = cc.p(BMgrOL.getBuddhaPos().x - 150, BMgrOL.getBuddhaPos().y)
      self.mArmature:hide()
      BMgr.createMonster(self:getParent(), "11", point, 1)
    end, 1)
  end, 3)
end

return TowerMonster

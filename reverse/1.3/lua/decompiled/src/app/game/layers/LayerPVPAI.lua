local PanelBG = require("app.game.panel.PanelBG")
local PanelGame = require("app.game.pvpOL.PanelGame")
local PanelTimer = require("app.game.pvpOL.PanelTimer")
local PanelCimelia = require("app.game.pvpOL.PanelCimelia")
local PanelSkill = require("app.game.pvpOL.PanelSkill")
local PanelSpirit = require("app.game.pvpOL.PanelSpirit")
local PanelEnemyInfo = require("app.game.pvpOL.PanelEnemyInfo")
local PanelTeam = require("app.game.pvpOL.PanelTeam")
local PanelGroove = require("app.game.pvpOL.PanelGroove")
local PanelRelics = require("app.game.panel.PanelRelics")
local LayerPVPOlResult = require("app.layers.LayerPVPOlResult")
local AlertConnection = require("app.layers.AlertConnection")
local PanelAI = require("app.game.pvpOL.PanelAI")
local AIManager = require("app.game.managers.AIManager")
CLASS_NAME = "LayerPVPAI"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.FRAME_PER_SECOND = 48
M.SERVER_PER_SECOND = 8
M.MIN_DETAL_TIME = 1
M.AI_SYN_CD = 5
local TAG_EVENT_RESULT = "tag_event_result_ai"

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:initData()
  self:initUI()
  self:loadAIManager()
  self:initEvents()
  self:performWithDelay(function()
    self:onEventFightResult()
    self.mSchedule = self:schedule(handler(self, self.update), 1 / M.FRAME_PER_SECOND)
  end, 0.5)
  self.mSocketSche = self:schedule(handler(self, self.checkSocket), 1)
  self:setNodeEventEnabled(true)
end

function M:initData()
  display.addSpriteFrames("pvp_ol/pvp_battle.plist", "pvp_ol/pvp_battle.png")
  BMgrOL.initRandomSeed(CloudData.FIGHT_SEED)
  self.mMode = CloudData.COMPETE_MODE
  GameData.CIMELIA_ATK = DataUtils.getAtkCimeliaInfo(CloudData.BUDDHA_CIMELIA_INFO.atkCimelia)
  GameData.CIMELIA_DEF = DataUtils.getDefCimeliaInfo(CloudData.BUDDHA_CIMELIA_INFO.defCimelia, CloudData.BUDDHA_TREASURE_INFO)
  GameData.CIMELIA_ATK_ENEMY = DataUtils.getAtkCimeliaInfo(CloudData.ENEMY_CIMELIA_INFO.atkCimelia)
  GameData.CIMELIA_DEF_ENEMY = DataUtils.getDefCimeliaInfo(CloudData.ENEMY_CIMELIA_INFO.defCimelia, CloudData.ENEMY_TREASURE_INFO)
  local filePath = string.format("skillcimelia/%s/%s.csb", GameData.CIMELIA_ATK.skillName, GameData.CIMELIA_ATK.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  self.mTowerDistance = Const.CardMode.Distance
  GameData.TOWER_DISTANCE = self.mTowerDistance
  GameData.FRAME_PER_SECOND = 24
  GameData.IS_ON_CREATING_BUDDHA = false
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  self.mTimeScale = 1
  self.mIsTimeOver = false
  GameData.FRAME_RATE = 1 / GameData.FRAME_PER_SECOND
  self.mCountTick = 0
  self.mIsOnEvent = false
end

function M:initUI()
  self.mBgPanel = PanelBG.new(self.mTowerDistance):pos(0, 0):addTo(self)
  self.mBgPanel:setBgScale(1, 1)
  self.mGamePanel = PanelGame.new(handler(self, self.onEventPanelGame)):addTo(self, 2)
  self.mTowerEnemy = BMgrOL.getMonsterTower()
  self.mTimerPanel = PanelTimer.new(self.mCleanTime, handler(self, self.onEventPanelTimer)):align(display.CENTER, display.width * 0.5, display.height * 0.9):addTo(self, 1)
  self.mSpiritPanel = PanelSpirit.new(handler(self, self.onEventButtonSpirit)):align(display.CENTER, display.width - 65, display.height * 0.93):addTo(self, 1)
  GameData.setCurrentSpirit(Const.PVPCurSprite or 0)
  self.mEnemyInfoPanel = PanelEnemyInfo.new():align(display.CENTER, 65, display.height * 0.93):addTo(self, 1)
  self.mCimeliaPanel = PanelCimelia.new(handler(self, self.onEventPanelCimelia)):align(display.CENTER, 75, 75):addTo(self, 1)
  self.mSkillPanel = PanelSkill.new(handler(self, self.onEventPanelSkill)):align(display.CENTER, display.width - 75, 75):addTo(self, 1)
  self.mRelicsPanel = PanelRelics.new():addTo(self, 1)
  if self.mMode == Const.GameType.CardType then
    GameData.INTERVAL_TIME = Const.CardMode.INTERVAL_TIME
    
    function GameData.climeliaRangeTrip.startTips()
    end
    
    self.mGroovePanel = PanelGroove.new(handler(self, self.onEventPanelGroove)):align(display.CENTER, display.cx, 0):addTo(self, 1)
    GameData.setCurrentSpirit(Const.CardMode.InitSpirit)
    self.mCimeliaPanel:hide()
    self.mSkillPanel:hide()
  else
    local frame = display.newScale9Sprite("gamescene/team_frame.png", 0, 0, cc.size(1280, 62), cc.rect(50, 30, 2, 2)):align(display.CENTER_BOTTOM, display.cx, 0):addTo(self)
    local teamInfo = CloudData.BUDDHA_ATTACK_TEAM
    for i = 1, #teamInfo do
      local buddhaId = teamInfo[i]
      if buddhaId ~= "" then
        local buddhaModel = DataUtils.getModelForPVPOnline("buddha", tonumber(buddhaId))
        local icon = PanelTeam.new(buddhaModel, handler(self, self.onEventPanelTeam)):pos(frame:getContentSize().width * (0.1 * i + 0.15), 60):addTo(frame, 1)
        icon.mIdx = i
        GameData.TEAM_ICON[#GameData.TEAM_ICON + 1] = icon
      end
    end
  end
  self.mAIPanel = PanelAI.new(handler(self, self.onEventPanelAI)):addTo(self)
  self.mTowerEnemy:addEventListener("UPDATE_BLOOD", function()
    self:onEventPanelEnemyInfo(self.mTowerEnemy.hpCur_)
  end)
end

local function getAIInitData(mode)
  local selfTower = {
    totalHp = math.floor(GameData.CIMELIA_DEF_ENEMY.towerHP * Const.PVPOL_TOWER_HP_RATIO)
  }
  local enemyTower = {
    totalHp = math.floor(GameData.CIMELIA_DEF.towerHP * Const.PVPOL_TOWER_HP_RATIO)
  }
  local actionData = DataUtils.getAction()
  local actionSeriesData = DataUtils.getActionSeries()
  local strategyData = DataUtils.getStrategy()
  local fightMode = 1
  if mode == Const.GameType.CardType then
    fightMode = 2
  end
  local data = {
    towerData = {selfTower = selfTower, enemyTower = enemyTower},
    action = actionData,
    actionSeries = actionSeriesData,
    strategy = strategyData,
    tick = M.AI_SYN_CD * GameData.FRAME_RATE,
    fightMode = fightMode,
    towerDis = GameData.TOWER_DISTANCE
  }
  return data
end

function M:loadAIManager()
  local aiData = getAIInitData(self.mMode)
  AI = AIManager.new(aiData)
end

function M:initEvents()
  local cls = AI.class
  cc.EventProxy.new(AI, self):addEventListener(cls.EVENT_CREATE_CARD, handler(self, self.onEventCreateEnemy)):addEventListener(cls.EVENT_UPGRADE_SPIRIT, handler(self, self.onEventSpiritEnemy)):addEventListener(cls.EVENT_CIMELIA_ATTACK, handler(self, self.onEventCimeliaAtkEnemy)):addEventListener(cls.EVENT_CIMELIA_DEFENCE, handler(self, self.onEventCimeliaDefEnemy))
end

function M:onEventFightResult()
  local function tFuncEvent(param)
    dump(param, "fight result : ")
    
    CloudData.PVP_ONLINE_RESULT = param
    local cause = param.cause
    local result = param.is_win
    if 0 == result and 1 == cause then
      if CloudData.PVP_ONLINE_RESULT and CloudData.PVP_ONLINE_RESULT.self_add_coin then
        local addCoin = checknumber(CloudData.PVP_ONLINE_RESULT.self_add_coin)
        local myCoin = checknumber(CloudData.GAME_ITEM_INFO["7"])
        CloudData.GAME_ITEM_INFO["7"] = myCoin + addCoin
      end
      self:performWithDelay(function()
        if checknumber(GameManager.IS_FRIEND_PK) == 1 then
          GameManager.IS_FRIEND_PK = 0
          GameManager.MODE = 0
          display.replaceScene(require("scenes.TinyLoadingScene").new("CHAPTER_SCENE"))
        elseif checknumber(GameManager.IS_PVPOL_RANK) ~= 1 then
          GameManager.IS_PVPOL_RANK = 0
          display.replaceScene(require("scenes.TinyLoadingScene").new("SCENE_PVPOL_COMPETE"))
        else
          GameManager.IS_PVPOL_RANK = 0
          CloudData.GRADE_INFO = param.pvp_data
          display.replaceScene(require("scenes.TinyLoadingScene").new("SCENE_PVPOL_RANK"))
        end
      end, 0.1)
    else
      local wrl = LayerPVPOlResult.new()
      self:addChild(wrl, 20)
    end
  end
  
  self:safeSocketListen("CMD_FIGHT_RESULT", tFuncEvent, true)
end

function M:update()
  self:sendAIMsg()
  BMgrOL.update()
  self.mTimerPanel:updateTime()
  self.mSpiritPanel:updateSpirit()
  self.mCimeliaPanel:updateAtkCimeliaPro()
  self.mSkillPanel:updateDefCimeliaPro()
  self.mTowerEnemy:updateEnemyTower()
  if self.mGroovePanel then
    self.mGroovePanel:update()
  end
  for j = 1, #GameData.TEAM_ICON do
    local icon = GameData.TEAM_ICON[j]
    icon:updateSpirit()
    icon:updateTeamPro()
  end
end

function M:getBattleData()
  local function getActorData(_type, _list)
    local towerPosX, flag = BMgrOL.getBuddhaPos().x, 1
    
    if "buddha" == _type then
      towerPosX, flag = BMgrOL.getMonsterPos().x, -1
    end
    local tempList = {}
    for i = 1, #_list do
      local buddha = _list[i]
      local buddhaId = buddha:getBuddhaId()
      local force = buddha:getBuddhaForce()
      local distance = (towerPosX - buddha:getPositionX()) * flag
      local t = {
        id = buddhaId,
        force = force,
        dis = distance
      }
      table.insert(tempList, t)
    end
    return tempList
  end
  
  local AIActorList = BMgrOL.getMonsterList()
  local selfList = getActorData("monster", AIActorList)
  local selfTower = {
    hp = BMgrOL.getEnemyTowerHP()
  }
  local selfActorList = BMgrOL.getBuddhaList()
  local enemyList = getActorData("buddha", selfActorList)
  local enemyTower = {
    hp = BMgrOL.getBuddhaTowerHP()
  }
  local spiritData = {
    value = self.mAIPanel:getCurrSpiritNum(),
    level = self.mAIPanel:getSpiritLevel(),
    isValueFull = self.mAIPanel:isSpiritFull(),
    isLevelFull = self.mAIPanel:isSpiritMaxLevel(),
    canUpgrade = self.mAIPanel:isCanUpSpirit()
  }
  local teamData = self.mAIPanel:getCurrTeamData()
  local aiCimelia = self.mAIPanel:getCimeliaData()
  local cimeliaData = {
    selfAttack = aiCimelia.atkCimelia,
    selfDefence = aiCimelia.defCimelia,
    enemyAttack = self.mCimeliaPanel:getDataForAI(),
    enemyDefence = self.mSkillPanel:getDataForAI()
  }
  local data = {
    self = selfList,
    enemy = enemyList,
    selfTower = selfTower,
    enemyTower = enemyTower,
    spirit = spiritData,
    team = teamData,
    cimelia = cimeliaData,
    isOnEvent = self.mIsOnEvent
  }
  if self.mIsOnEvent == true then
    self.mIsOnEvent = false
  end
  return data
end

function M:sendAIMsg()
  self.mCountTick = self.mCountTick + 1
  if self.mCountTick < M.AI_SYN_CD then
    return
  end
  self.mCountTick = 0
  local data = self:getBattleData()
  AI:heartbeat(data)
end

function M:checkSocket()
  if SocketMgr:isConnected() then
    return
  end
  self:stopAction(self.mSocketSche)
  self:stopAction(self.mSchedule)
  local connectionLayer_ = AlertConnection.new():addTo(self, 500)
  self:performWithDelay(function()
    connectionLayer_:removeSelf()
    LayerPVPOlResult.new():addTo(self, 20)
  end, 8)
end

function M:onEventCreateSelf(event)
  DDLOG("======= Event: CreateSelf")
  local buddhaId = event.buddha_id
  for i = 1, #GameData.TEAM_ICON do
    local teamIcon = GameData.TEAM_ICON[i]
    if buddhaId == teamIcon.mBuddhaModel.npcId then
      teamIcon:createBuddha(buddhaId)
    end
  end
  if self.mMode == Const.GameType.CardType then
    BMgrOL.createPVPBuddha(buddhaId)
  end
end

function M:onEventCreateEnemy(event)
  DDLOG("======= Event: CreateEnemy")
  self.mIsOnEvent = true
  self.mAIPanel:createBuddha({
    idx = event.params.cardIndex
  })
end

function M:onEventSpiritSelf(event)
  DDLOG("======= Event: UpgradeSpiritSelf")
  BMgrOL.AddBattleCount(1, 7, 1)
  self.mSpiritPanel:upgradeSpirit()
end

function M:onEventSpiritEnemy(event)
  DDLOG("======= Event: UpgradeSpiritEnemy")
  self.mAIPanel:upgradeSpirit()
  self.mEnemyInfoPanel:upgradeSpirit()
end

function M:onEventCimeliaAtkEnemy(event)
  DDLOG("========== Event :  Play AtkCimelia Enemy")
  local params = {
    cimeliaType = "atk",
    skillId = GameData.CIMELIA_ATK_ENEMY.skillId,
    atkNum = GameData.CIMELIA_ATK_ENEMY.atkNum,
    atkType = GameData.CIMELIA_ATK_ENEMY.attackType,
    atkDis = GameData.CIMELIA_ATK_ENEMY.atkDistance,
    hitRate = GameData.CIMELIA_ATK_ENEMY.hitRate,
    critRate = GameData.CIMELIA_ATK_ENEMY.critRate,
    critHarmRate = GameData.CIMELIA_ATK_ENEMY.critHarmRate,
    magDefIgnore = GameData.CIMELIA_ATK_ENEMY.magDefIgnore,
    phyDefIgnore = GameData.CIMELIA_ATK_ENEMY.phyDefIgnore,
    element = GameData.CIMELIA_ATK_ENEMY.element,
    elementValue = {
      [1] = GameData.CIMELIA_ATK_ENEMY.propGold + GameData.CIMELIA_ATK_ENEMY.propAllElements,
      [2] = GameData.CIMELIA_ATK_ENEMY.propWood + GameData.CIMELIA_ATK_ENEMY.propAllElements,
      [3] = GameData.CIMELIA_ATK_ENEMY.propWater + GameData.CIMELIA_ATK_ENEMY.propAllElements,
      [4] = GameData.CIMELIA_ATK_ENEMY.propFire + GameData.CIMELIA_ATK_ENEMY.propAllElements,
      [5] = GameData.CIMELIA_ATK_ENEMY.propEarth + GameData.CIMELIA_ATK_ENEMY.propAllElements
    }
  }
  self.mTowerEnemy:playCimelia(params)
  self.mAIPanel:playCimelia({cimeliaType = "atk"})
end

function M:onEventCimeliaDefEnemy(event)
  DDLOG("========== Event :  Play DefCimelia Enemy")
  local params = {
    cimeliaType = "def",
    skillId = GameData.CIMELIA_DEF_ENEMY.skillId
  }
  self.mTowerEnemy:playCimelia(params)
  self.mAIPanel:playCimelia({cimeliaType = "def"})
end

function M:commitFightResult(param)
  self:stopAction(self.mSchedule)
  self:gamePause()
  local params = {
    is_win = param,
    ai_rank_data = CloudData.ENEMY_INFO.pvpData,
    fight_type = 2
  }
  self:safeSocketRequest("CMD_COMMIT_RESULT", params)
end

function M:onEventPanelGame(tag, param)
  DDLOG("=============== commitFightResult ")
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  local warResult = 0
  if PanelGame.TAG_TOWER_MONSTER_DEAD == tag then
    warResult = 1
  elseif PanelGame.TAG_TOWER_BUDDHA_DEAD == tag then
    warResult = 0
  end
  self:commitFightResult(warResult)
end

function M:onEventPanelTimer(param)
  DDLOG("======= TimeOver !!!")
  if self.mIsTimeOver then
    return
  end
  self.mIsTimeOver = true
  local buddhaTowerHp = BMgrOL.getBuddhaTowerHP()
  local enemyTowerHp = BMgrOL.getEnemyTowerHP()
  local warResult = 65
  if buddhaTowerHp > enemyTowerHp then
    warResult = 1
  elseif buddhaTowerHp < enemyTowerHp then
    warResult = 0
  elseif buddhaTowerHp == enemyTowerHp then
    local buddhaScore = CloudData.GRADE_INFO.score
    local enemyScore = CloudData.ENEMY_INFO.pvpData.score
    if buddhaScore < enemyScore then
      warResult = 1
    elseif buddhaScore > enemyScore then
      warResult = 0
    elseif buddhaScore == enemyScore then
      warResult = CloudData.FIGHT_PRIORITY
    end
  end
  self:commitFightResult(warResult)
end

function M:onEventPanelGroove(params)
  if 1001 == params.type then
    local currentSpirit = GameData.getCurrentSpirit()
    DYSoundMgr.playEffect(DY_SND.sfx_lq_upgrade)
    GameData.setCurrentSpirit(currentSpirit + params.spiritNum)
  elseif 1002 == params.type then
    if not params.isReady then
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_buddha_makeup)
    local currentSpirit = GameData.getCurrentSpirit()
    currentSpirit = currentSpirit - params.buddhaModel.consume
    GameData.setCurrentSpirit(currentSpirit)
    self:onEventCreateSelf({
      buddha_id = params.buddhaModel.npcId
    })
  elseif 1003 == params.type then
    local currentSpirit = GameData.getCurrentSpirit()
    currentSpirit = currentSpirit - params.costSpirit
    GameData.setCurrentSpirit(currentSpirit)
    self.mCimeliaPanel.mIsInCD = false
    self.mCimeliaPanel:iconClicked()
  elseif 1004 == params.type then
    local currentSpirit = GameData.getCurrentSpirit()
    currentSpirit = currentSpirit - params.costSpirit
    GameData.setCurrentSpirit(currentSpirit)
    self.mSkillPanel.mIsInCD = false
    self.mSkillPanel:iconClicked()
  end
end

function M:onEventButtonSpirit(param)
  self:onEventSpiritSelf(param)
end

function M:onEventPanelEnemyInfo(param)
  self.mEnemyInfoPanel:updateTowerBlood(param)
end

function M:onEventPanelCimelia(params)
  self.mCimeliaPanel:playCimeliaSkill()
end

function M:onEventPanelSkill(params)
  self.mSkillPanel:playTowerSkill()
end

function M:onEventPanelTeam(params)
  self:onEventCreateSelf(params)
end

function M:onEventPanelAI(params)
  if PanelAI.WAND_SKILL == params.tag then
    self:onEventCimeliaAtkEnemy()
  elseif PanelAI.TOWER_SKILL == params.tag then
    self:onEventCimeliaDefEnemy()
  end
end

function M:gamePause()
  self:pause()
end

function M:gameResume()
  self:resume()
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  return true
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

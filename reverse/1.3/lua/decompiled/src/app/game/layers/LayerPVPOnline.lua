local PanelBG = require("app.game.panel.PanelBG")
local PanelGame = require("app.game.pvpOL.PanelGame")
local PanelTimer = require("app.game.pvpOL.PanelTimer")
local PanelCimelia = require("app.game.pvpOL.PanelCimelia")
local PanelSkill = require("app.game.pvpOL.PanelSkill")
local PanelRelics = require("app.game.pvpOL.PanelRelics")
local PanelSpirit = require("app.game.pvpOL.PanelSpirit")
local PanelEnemyInfo = require("app.game.pvpOL.PanelEnemyInfo")
local PanelTeam = require("app.game.pvpOL.PanelTeam")
local PanelGroove = require("app.game.pvpOL.PanelGroove")
local LayerPVPOlResult = require("app.layers.LayerPVPOlResult")
local CLASS_NAME = "LayerPVPOnline"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.EVENT_CREATE_BUDDHA = 201
M.EVENT_CREATE_MONSTER = 202
M.EVENT_CIMELIA_BUDDHA = 203
M.EVENT_CIMELIA_MONSTER = 204
M.EVENT_CHAT = 205
M.EVENT_BUDDHA_SPIRIT = 206
M.EVENT_ENEMY_SPIRIT = 207
M.EVENT_FIRST_ATTACK = 208
M.EVENT_RELICS_BUDDHA = 209
M.EVENT_RELICS_MONSTER = 210
M.FRAME_PER_SECOND = 48
M.SERVER_PER_SECOND = 8
M.MIN_DETAL_TIME = 1
M.RATION = M.FRAME_PER_SECOND / M.SERVER_PER_SECOND
local TAG_EVENT_TICK = "tag_event_tick"
local TAG_EVENT_RESULT = "tag_event_result"
local TAG_EVENT_CACHE_MSG = "tag_event_cache_msg"
local M_waitOther

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mEventList = {}
  self.mGamePanel = nil
  self.mBgPanel = nil
  self.mMode = CloudData.COMPETE_MODE
  self:initData()
  self:initUI()
  self:setNodeEventEnabled(true)
  self:safeSocketRequest("CMD_FIGHT_READY")
  self:onEventUpdateTick()
  self:onEventFightResult()
  self:onEventRetransMisson()
  self.mCount = 10
  self:performWithDelay(function()
    self:schedule(function()
      self:updateSync()
    end, 1 / M.FRAME_PER_SECOND)
  end, 0.5)
  self.mLastTick = 0
  self.mCurClientTick = 0
  self.mCurServerTick = 0
  self.waitForRequest = true
  GameData.mSocketInRequest = false
end

function M:initData()
  display.addSpriteFrames("pvp_ol/pvp_battle.plist", "pvp_ol/pvp_battle.png")
  BMgrOL.initRandomSeed(CloudData.FIGHT_SEED)
  GameData.CIMELIA_ATK = DataUtils.getAtkCimeliaInfo(CloudData.BUDDHA_CIMELIA_INFO.atkCimelia)
  GameData.CIMELIA_DEF = DataUtils.getDefCimeliaInfo(CloudData.BUDDHA_CIMELIA_INFO.defCimelia, CloudData.BUDDHA_TREASURE_INFO)
  local filePath = string.format("skillcimelia/%s/%s.csb", GameData.CIMELIA_ATK.skillName, GameData.CIMELIA_ATK.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  self.mTowerDistance = Const.CardMode.Distance
  GameData.TOWER_DISTANCE = self.mTowerDistance
  GameData.FRAME_PER_SECOND = 24
  GameData.IS_ON_CREATING_BUDDHA = false
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  self.mTimeScale = 1
  self.mIsTimeOver = false
  self.mPanelTable = {}
end

function M:initUI()
  self.mBgPanel = PanelBG.new(self.mTowerDistance):pos(0, 0):addTo(self)
  self.mBgPanel:setBgScale(1, 1)
  self.mGamePanel = PanelGame.new(handler(self, self.onEventPanelGame)):addTo(self, 2)
  table.insert(self.mPanelTable, self.mGamePanel)
  self.mTowerEnemy = BMgrOL.getMonsterTower()
  self.mTimerPanel = PanelTimer.new(self.mCleanTime, handler(self, self.onEventPanelTimer)):align(display.CENTER, display.width * 0.5, display.height * 0.9):addTo(self, 1)
  table.insert(self.mPanelTable, self.mTimerPanel)
  self.mSpiritPanel = PanelSpirit.new(handler(self, self.onEventButtonSpirit)):align(display.CENTER, display.width - 65, display.height * 0.93):addTo(self, 1)
  GameData.setCurrentSpirit(Const.PVPCurSprite or 0)
  table.insert(self.mPanelTable, self.mSpiritPanel)
  self.mEnemyInfoPanel = PanelEnemyInfo.new():align(display.CENTER, 65, display.height * 0.93):addTo(self, 1)
  self.mCimeliaPanel = PanelCimelia.new(handler(self, self.onEventPanelCimelia)):align(display.CENTER, 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mCimeliaPanel)
  self.mSkillPanel = PanelSkill.new(handler(self, self.onEventPanelSkill)):align(display.CENTER, display.width - 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mSkillPanel)
  self.mRelicsPanel = PanelRelics.new(handler(self, self.onEventPanelRelics)):addTo(self, 1)
  table.insert(self.mPanelTable, self.mRelicsPanel)
  if self.mMode == Const.GameType.CardType then
    GameData.INTERVAL_TIME = Const.CardMode.INTERVAL_TIME
    
    function GameData.climeliaRangeTrip.startTips()
    end
    
    self.mGroovePanel = PanelGroove.new(handler(self, self.onEventPanelGroove)):align(display.CENTER, display.cx, 0):addTo(self, 1)
    table.insert(self.mPanelTable, self.mGroovePanel)
    GameData.setCurrentSpirit(Const.CardMode.InitSpirit)
    self.mCimeliaPanel:hide()
    self.mSkillPanel:hide()
  else
    local frame = display.newScale9Sprite("gamescene/team_frame.png", 0, 0, cc.size(1280, 62), cc.rect(50, 30, 2, 2)):align(display.CENTER_BOTTOM, display.cx, 0):addTo(self)
    local teamInfo = DataUtils.getBuddhaTableOnTeam()
    for i = 1, #teamInfo do
      local buddhaId = teamInfo[i]
      if buddhaId ~= "" then
        local buddhaModel = DataUtils.getModelForPVPOnline("buddha", tonumber(buddhaId))
        local icon = PanelTeam.new(buddhaModel, handler(self, self.onEventPanelTeam)):pos(frame:getContentSize().width * (0.1 * i + 0.15), 60):addTo(frame, 1)
        icon.mIdx = i
        GameData.TEAM_ICON[#GameData.TEAM_ICON + 1] = icon
        table.insert(self.mPanelTable, icon)
      end
    end
  end
  self.mWaitOther = M_waitOther():addTo(self, 50)
  self.mWaitOther:show()
  self.mTowerEnemy:addEventListener("UPDATE_BLOOD", function()
    self:onEventPanelEnemyInfo(self.mTowerEnemy.hpCur_)
  end)
end

function M:update(client, server)
  self.mCurClientTick = math.floor(self.mCount / M.RATION)
  if self.mEventList[self.mCurClientTick] then
    self.mCount = self.mCount + 1
    BMgrOL.update()
    if self.mCurClientTick ~= self.mLastTick then
      local eventList = self.mEventList[self.mCurClientTick]
      if eventList and 0 < #eventList then
        for i = 1, #eventList do
          local evt = eventList[i]
          local tFunc = {
            [M.EVENT_CREATE_BUDDHA] = function()
              self:onEventCreateBuddha(evt)
            end,
            [M.EVENT_CREATE_MONSTER] = function()
              self:onEventCreateMonster(evt)
            end,
            [M.EVENT_CIMELIA_BUDDHA] = function()
              self:onEventCimeliaBuddha(evt)
            end,
            [M.EVENT_CIMELIA_MONSTER] = function()
              self:onEventCimeliaMonster(evt)
            end,
            [M.EVENT_CHAT] = function()
              self:onEventChat(evt)
            end,
            [M.EVENT_BUDDHA_SPIRIT] = function()
              self:onEventBuddhaSpirit(evt)
            end,
            [M.EVENT_ENEMY_SPIRIT] = function()
              self:onEventEnemySpirit(evt)
            end,
            [M.EVENT_FIRST_ATTACK] = function()
              self:onEventFirstAttack(evt)
            end,
            [M.EVENT_RELICS_BUDDHA] = function()
              self:onEventRelicsBuddha(evt)
            end,
            [M.EVENT_RELICS_MONSTER] = function()
              self:onEventRelicsMonster(evt)
            end
          }
          tFunc[evt.eid]()
        end
      end
    end
    self.mLastTick = self.mCurClientTick
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
  elseif not GameData.mSocketInRequest and GameData.BATTLE_TICK > self.mCurClientTick then
    self:safeSocketRequest("CMD_RETRANS_MISSION", {
      tick = GameData.BATTLE_TICK
    })
    GameData.mSocketInRequest = true
    DDLOG(DYLang.getString("S244", ""))
  end
end

function M:updateSync()
  if not GameData.BATTLE_TICK or GameData.BATTLE_TICK < 1 then
    self.mWaitOther:show()
    return
  end
  self.mWaitOther:hide()
  self.mCurClientTick = math.floor(self.mCount / M.RATION)
  self.mCurServerTick = GameData.BATTLE_TICK
  if self.mCurServerTick - self.mCurClientTick > M.MIN_DETAL_TIME then
    for i = self.mCurClientTick, self.mCurServerTick - M.MIN_DETAL_TIME do
      self:update(self.mCurClientTick, self.mCurServerTick)
    end
  else
    self:update(self.mCurClientTick, self.mCurServerTick)
  end
end

function M:onEventUpdateTick()
  local function tFuncEvent(param)
    GameData.BATTLE_TICK = param.tick
    
    local eventList = param.event_list
    self.mEventList = self.mEventList or {}
    self.mEventList[param.tick] = eventList
  end
  
  self:safeSocketListen("CMD_UPDATE_TICK", tFuncEvent)
end

function M:onEventRelicsBuddha(params)
  self.mRelicsPanel:castRelicsSkill(params, true)
end

function M:onEventRelicsMonster(params)
  self.mRelicsPanel:castRelicsSkill(params, false)
end

function M:onEventCreateBuddha(params)
  DDLOG("========== Create Buddha@%d!!!@%d", params.buddha_id, self.mCurClientTick)
  local buddhaId = params.buddha_id
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

function M:onEventCreateMonster(params)
  DDLOG("========== Create Monster@%d!!!@%d", params.buddha_id, self.mCurClientTick)
  self.mTowerEnemy:createEnemy(params.buddha_id)
end

function M:onEventCimeliaBuddha(params)
  DDLOG("========== Buddha Play Cimelia!!!@%d", self.mCurClientTick)
  if "atk" == params.cimeliaType then
    self.mCimeliaPanel:playCimeliaSkill()
  elseif "def" == params.cimeliaType then
    self.mSkillPanel:playTowerSkill()
  end
end

function M:onEventCimeliaMonster(params)
  DDLOG("========== Monster Play Cimelia!!!@%d", self.mCurClientTick)
  self.mTowerEnemy:playCimelia(params)
end

function M:onEventChat(params)
  DDLOG("========== Chat!!!")
  self.mEnemyInfoPanel:chatContent(params)
end

function M:onEventBuddhaSpirit(params)
  DDLOG("========== Buddha Upgrade Spirit!!!")
  BMgrOL.AddBattleCount(1, 7, 1)
  self.mSpiritPanel:upgradeSpirit()
end

function M:onEventEnemySpirit(params)
  DDLOG("========== Enemy Upgrade Spirit!!!")
  BMgrOL.AddBattleCount(2, 7, 1)
  self.mEnemyInfoPanel:upgradeSpirit()
end

function M:onEventFirstAttack(params)
  DDLOG("========== First Attack !!!")
  GameData.updateSpirit(50)
end

function M:onEventFightResult()
  local function tFuncEvent(param)
    dump(param, "fight result : ")
    
    self:safeSocketCancel("CMD_UPDATE_TICK")
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
      self:gamePause()
      local wrl = LayerPVPOlResult.new()
      self:addChild(wrl, 20)
    end
  end
  
  self:safeSocketListen("CMD_FIGHT_RESULT", tFuncEvent, true)
end

function M:onEventRetransMisson()
  local function tFuncEvent(param)
    dump(param, "cache msg list : ", 9)
    
    CloudData.CACHE_MSG_LIST = param
    local eventList = param.msg_list or {}
    self.mCurClientTick = self.mCurClientTick or 0
    self.mEventList = self.mEventList or {}
    for i = self.mCurClientTick, param.cur_tick or self.mCurClientTick do
      self.mEventList[i] = self.mEventList[i] or {}
    end
    for k, v in pairs(eventList) do
      self.mEventList[v.tick] = v.event_list
    end
    GameData.mSocketInRequest = false
  end
  
  self:safeSocketListen("CMD_CACHE_MSG_LIST", tFuncEvent)
end

function M:onEventPanelGame(tag, param)
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  local warResult = 0
  if PanelGame.TAG_TOWER_MONSTER_DEAD == tag then
    warResult = 1
  elseif PanelGame.TAG_TOWER_BUDDHA_DEAD == tag then
    warResult = 0
  end
  self:safeSocketRequest("CMD_COMMIT_RESULT", {is_win = warResult})
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
  self:safeSocketRequest("CMD_COMMIT_RESULT", {is_win = warResult})
end

function M:onEventPanelGroove(params)
  if 101 == params.type then
    local currentSpirit = GameData.getCurrentSpirit()
    DYSoundMgr.playEffect(DY_SND.sfx_lq_upgrade)
    self:safeSocketRequest("CMD_UPGRADE_SPIRIT")
    local ac = transition.sequence({
      cc.ScaleTo:create(0.2, 1.2),
      cc.ScaleTo:create(0.2, 0.75)
    })
    self.mSpiritPanel.mNumLabel:runAction(ac)
    self.mSpiritPanel:reInit()
  elseif 1001 == params.type then
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
    self:safeSocketRequest("CMD_COMMIT_BUDDHA", {
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
  self:safeSocketRequest("CMD_UPGRADE_SPIRIT")
end

function M:onEventPanelEnemyInfo(param)
  self.mEnemyInfoPanel:updateTowerBlood(param)
end

function M:onEventPanelCimelia(params)
  self:safeSocketRequest("CMD_COMMIT_CIMELIA", params)
end

function M:onEventPanelSkill(params)
  self:safeSocketRequest("CMD_COMMIT_CIMELIA", params)
end

function M:onEventPanelRelics(params)
  self:safeSocketRequest("CMD_COMMIT_RELICS", params)
end

function M:onEventPanelTeam(params)
  self:safeSocketRequest("CMD_COMMIT_BUDDHA", params)
end

function M:gamePause()
  for k, v in pairs(self.mPanelTable) do
    if v.pauseEx then
      v:pauseEx()
    end
    v:pause()
  end
  self:pause()
end

function M:gameResume()
  for k, v in pairs(self.mPanelTable) do
    if v.resumeEx then
      v:resumeEx()
    end
    v:resume()
  end
  self:resume()
end

function M_waitOther()
  local waitLayer = display.newLayer()
  local nodeBg = display.newSprite("connection/waiting.png", display.cx, display.cy - 30):addTo(waitLayer)
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb", "jiuweihu1", "jiuweihu1"))
  local armature = ccs.Armature:create("jiuweihu1")
  armature:setPosition(nodeBg:getContentSize().width * 0.2, nodeBg:getContentSize().height * 0.18)
  armature:setScale(0.6)
  nodeBg:addChild(armature, 5)
  armature:getAnimation():playWithIndex(1)
  armature:getAnimation():setSpeedScale(1.4)
  return waitLayer
end

function M:onKeypad(keyCode, event)
  return false
end

function M:listAddBuff(sprites, buffid, dt, time, effect)
  for k, v in pairs(sprites) do
    v:addBuff(v, buffid, dt, time, effect)
  end
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

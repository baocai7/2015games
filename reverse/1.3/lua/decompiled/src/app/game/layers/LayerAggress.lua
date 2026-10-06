local PanelBG = require("app.game.panel.PanelBG")
local PanelTimer = require("app.game.panel.PanelTimer")
local PanelSpirit = require("app.game.panel.PanelSpirit")
local PanelCimelia = require("app.game.panel.PanelCimelia")
local PanelSkill = require("app.game.panel.PanelSkill")
local PanelTeam = require("app.game.panel.PanelTeam")
local PanelGame = require("app.game.panel.PanelGame")
local PanelBossBar = require("app.game.panel.PanelBossBar")
local PanelCounter = require("app.game.panel.PanelCounter")
local LayerWarResult = require("app.layers.LayerWarResult")
local LayerErrorGameData = require("app.layers.LayerErrorGameData")
local PanelRelics = require("app.game.panel.PanelRelics")
CLASS_NAME = "LayerAggress"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.FRAME_PER_SECOND = GameData.PVE_FRAME

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mGamePanel = nil
  self.mBgPanel = nil
  self:initData()
  self:initUI()
  self:performWithDelay(function()
    self:schedule(function()
      self:update()
    end, 1 / M.FRAME_PER_SECOND)
  end, 0.5)
  self:setNodeEventEnabled(true)
end

function M:initData()
  GameData.CIMELIA_ATK = DataUtils.getAtkCimeliaInfo(CloudData.PVE_ATK_CIMELIA_DATA)
  GameData.CIMELIA_DEF = DataUtils.getDefCimeliaInfo(CloudData.PVE_DEF_CIMELIA_DATA)
  local stageModel = DataUtils.getStageInfo(GameManager.MODE, GameManager.STAGE_ID)
  GameData.MAX_MONSTER_NUM = stageModel.maxNum
  self.mTowerDistance = stageModel.towerDistance
  GameData.TOWER_DISTANCE = self.mTowerDistance
  self.mCleanTime = stageModel.cleanTime
  GameData.CLEAN_TIME = self.mCleanTime
  GameData.BOSS_ID = stageModel.bossId
  GameData.IS_ON_CREATING_BUDDHA = false
  cc.Director:getInstance():getScheduler():setTimeScale(2)
  self.mTimeScale = 2
  self.mPanelTable = {}
end

function M:initUI()
  self.mBgPanel = PanelBG.new(self.mTowerDistance):pos(0, 0):addTo(self)
  self.mGamePanel = PanelGame.new(handler(self, self.onEventPanelGame)):addTo(self, 2)
  table.insert(self.mPanelTable, self.mGamePanel)
  local timerPanel = PanelTimer.new(self.mCleanTime, handler(self, self.onEventPanelTimer)):align(display.CENTER, display.width * 0.37, display.height * 0.93):addTo(self, 1)
  table.insert(self.mPanelTable, timerPanel)
  self.mTimePanel = timerPanel
  cc.ui.UIPushButton.new({
    normal = "gamescene/speed2.png",
    pressed = "gamescene/speed2.png"
  }):onButtonPressed(function(event)
  end):align(display.CENTER, display.width * 0.58, display.height * 0.93):addTo(self, 1)
  self.mSpiritPanel = PanelSpirit.new(handler(self, self.onEventButtonSpirit)):align(display.CENTER, display.width - 65, display.height * 0.93):addTo(self, 1)
  self.mSpiritPanel:setMaxSpiritNum()
  table.insert(self.mPanelTable, self.mSpiritPanel)
  self.mCimeliaPanel = PanelCimelia.new(handler(self, self.onEventPanelCimelia)):align(display.CENTER, 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mCimeliaPanel)
  self.mSkillPanel = PanelSkill.new(handler(self, self.onEventPanelSkill)):align(display.CENTER, display.width - 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mSkillPanel)
  self.mRelicsPanel = PanelRelics.new():addTo(self, 1)
  table.insert(self.mPanelTable, self.mRelicsPanel)
  self.mBossBarPanel = PanelBossBar.new():pos(display.width * 0.25, display.height * 0.76):addTo(self, 1)
  local frame = display.newScale9Sprite("gamescene/team_frame.png", 0, 0, cc.size(1280, 62), cc.rect(50, 30, 2, 2)):align(display.CENTER_BOTTOM, display.cx, 0):addTo(self)
  local teamInfo = DataUtils.getBuddhaTableOnTeam()
  for i, buddhaId in pairs(teamInfo) do
    if buddhaId ~= "" then
      local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
      local icon = PanelTeam.new(buddhaModel, handler(self, self.onEventPanelTeam)):pos(frame:getContentSize().width * (0.1 * i + 0.15), 60):addTo(frame, 1)
      GameData.TEAM_ICON[#GameData.TEAM_ICON + 1] = icon
      table.insert(self.mPanelTable, icon)
    end
  end
  local counterPanel = PanelCounter.new():addTo(self, 1)
end

function M:update()
  BMgrOL.update()
  self.mCimeliaPanel:updateCimeAtk()
  self.mSkillPanel:updateCimeDEF()
  self.mTimePanel:updateTimer()
end

function M:onEventButtonPause(tag, param)
end

function M:onEventPanelGame(tag, param)
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  local bossCurHp = 0
  local maxHp = 0
  local curDamage = 0
  local bossObj = BMgrOL.getPurgatoryBoss()
  if bossObj then
    bossCurHp = BMgrOL.getPurgatoryBoss():getCurABLY(LIFE_CUR)
    maxHp = BMgrOL.getPurgatoryBoss():getCurABLY(LIFE)
    curDamage = CloudData.AGGRESS_BOSS_LEFT_HP - BMgrOL.getPurgatoryBoss():getCurABLY(LIFE_CUR)
  else
    bossCurHp = CloudData.AGGRESS_BOSS_LEFT_HP
    maxHp = bossCurHp
    curDamage = 0
  end
  curDamage = curDamage < 0 and 0 or curDamage
  curDamage = maxHp < curDamage and maxHp or curDamage
  local hurtPer = curDamage / maxHp * 100
  if not GameManager.RESULT_SHOWED then
    local warResult = 0
    if PanelGame.TAG_TOWER_MONSTER_DEAD == tag then
      warResult = 1
    elseif PanelGame.TAG_TOWER_BUDDHA_DEAD == tag then
      warResult = 0
      if bossCurHp <= 0 then
        bossCurHp = CloudData.AGGRESS_BOSS_LEFT_HP
      end
    end
    local legal = BMgrOL.checkBattleTime(GameData.BATTLE_TIME)
    if not legal then
      warResult = 2
    end
    local team = DataUtils.getBuddhaTableOnTeam()
    local teamInfoTable = {}
    for i, buddhaId in pairs(team) do
      if buddhaId ~= "" then
        local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
        local tempTable = {}
        tempTable.buddhaId = buddhaId
        tempTable.level = buddhaModel.level
        tempTable.star = buddhaModel.starLevel
        table.insert(teamInfoTable, tempTable)
      end
    end
    local teamInfoStr = json.encode(teamInfoTable)
    
    local function tFuncListener(info)
      CloudData.WAR_RESULT_TABLE = info.data or {}
      CloudData.WAR_RESULT_TABLE.retTime = info.time
      CloudData.WAR_RESULT_TABLE.aggressBossDamage = curDamage
      CloudData.WAR_RESULT_TABLE.aggressBossDamagePer = hurtPer
      if warResult == 1 then
        local wrl = LayerWarResult.new(LayerWarResult.WIN)
        self:addChild(wrl, 20)
      elseif warResult == 0 then
        local wrl = LayerWarResult.new(LayerWarResult.LOSE)
        self:addChild(wrl, 20)
      elseif warResult == 2 then
        LayerErrorGameData.new():addTo(self, 99999)
      end
    end
    
    CloudData.AGGRESS_BOSS_LEFT_HP = bossCurHp
    local tBlood = math.floor(curDamage)
    local tAggressId = checkstring(CloudData.AGGRESS_ID)
    local strAppSecret = "AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&aggressId=%s&blood=%s&token=%s&uid=%s", strAppSecret .. "", tAggressId, tBlood .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
    local params = {}
    params.aggressId = tAggressId
    params.blood = tBlood
    params.sign = crypto.md5(strSign, false)
    DYHttpMgr.aggressFightResult(tFuncListener, params)
  end
  self:gamePause()
end

function M:onEventPanelPause(tag, param)
  if tag == PanelPause.TAG_CONTINUE then
    self:gameResume()
  elseif tag == PanelPause.TAG_EXIT then
    DYSoundMgr.stopMusic(true)
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
    cc.Director:getInstance():getScheduler():setTimeScale(1)
    display.replaceScene(require("scenes.TinyLoadingScene").new("CHAPTER_SCENE"))
  elseif tag == PanelPause.TAG_RESTART then
    DYSoundMgr.stopMusic(true)
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
    cc.Director:getInstance():getScheduler():setTimeScale(1)
    display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE"))
  end
end

function M:onEventPanelSpeed(param)
end

function M:onEventPanelTimer(param)
  BMgr.createMonster(GameData.BG, 999999, nil, 1)
end

function M:onEventButtonSpirit(param)
  local currentSpirit = GameData.getCurrentSpirit()
  DYSoundMgr.playEffect(DY_SND.sfx_lq_upgrade)
  GameData.setCurrentSpirit(currentSpirit - param)
  GameData.SPIRIT_LEVEL = GameData.SPIRIT_LEVEL + 1
  self.mSpiritPanel:reInit()
end

function M:onEventPanelCimelia(param)
end

function M:onEventPanelSkill(param)
end

function M:onEventPanelTeam(params)
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

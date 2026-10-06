local PanelBG = require("app.game.panel.PanelBG")
local PanelPause = require("app.game.panel.PanelPause")
local PanelStage = require("app.game.panel.PanelStage")
local PanelTimer = require("app.game.panel.PanelTimer")
local PanelSpirit = require("app.game.panel.PanelSpirit")
local PanelCimelia = require("app.game.panel.PanelCimelia")
local PanelSkill = require("app.game.panel.PanelSkill")
local PanelTeam = require("app.game.panel.PanelTeam")
local PanelGame = require("app.game.panel.PanelGame")
local PanelCounter = require("app.game.panel.PanelCounter")
local LayerWarResult = require("app.layers.LayerWarResult")
local LayerErrorGameData = require("app.layers.LayerErrorGameData")
local PanelRelics = require("app.game.panel.PanelRelics")
CLASS_NAME = "LayerElite"
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
  GameData.GAME_TYPE = stageModel.gameType or 0
  GameData.STAR_TIME = stageModel.starTime
  if 1 == GameData.GAME_TYPE then
    GameData.INTERVAL_TIME = stageModel.intervalTime
  end
  self.mTowerDistance = stageModel.towerDistance
  GameData.TOWER_DISTANCE = self.mTowerDistance
  self.mCleanTime = stageModel.cleanTime
  GameData.CLEAN_TIME = self.mCleanTime
  GameData.IS_ON_CREATING_BUDDHA = false
  local speed = DYStat.getValueInt(DY_KEY.kGameSpeed, 1)
  if speed == 2 then
    cc.Director:getInstance():getScheduler():setTimeScale(2)
    self.mTimeScale = 2
  else
    cc.Director:getInstance():getScheduler():setTimeScale(1.3)
    self.mTimeScale = 1.3
  end
  self.mPanelTable = {}
end

function M:initUI()
  self.mBgPanel = PanelBG.new(self.mTowerDistance):pos(0, 0):addTo(self)
  self.mGamePanel = PanelGame.new(handler(self, self.onEventPanelGame)):addTo(self, 2)
  table.insert(self.mPanelTable, self.mGamePanel)
  cc.ui.UIPushButton.new({
    normal = "gamescene/pause.png",
    pressed = "gamescene/pause1.png"
  }):onButtonClicked(handler(self, self.onEventButtonPause)):align(display.CENTER_LEFT, display.width * 0.01, display.height * 0.93):addTo(self, 1)
  PanelStage.new():align(display.CENTER, display.width * 0.18, display.height * 0.93):addTo(self, 1)
  local timerPanel = PanelTimer.new(self.mCleanTime, handler(self, self.onEventPanelTimer)):align(display.CENTER, display.width * 0.37, display.height * 0.93):addTo(self, 1)
  table.insert(self.mPanelTable, timerPanel)
  self.mTimePanel = timerPanel
  local normalImg = "gamescene/speed1.png"
  local pressedImg = "gamescene/speed2.png"
  if self.mTimeScale == 2 then
    normalImg = "gamescene/speed2.png"
    pressedImg = "gamescene/speed1.png"
  end
  cc.ui.UIPushButton.new({normal = normalImg, pressed = pressedImg}):onButtonPressed(function(event)
    self:onEventPanelSpeed(event.target)
  end):align(display.CENTER, display.width * 0.58, display.height * 0.93):addTo(self, 1)
  self.mSpiritPanel = PanelSpirit.new(handler(self, self.onEventButtonSpirit)):align(display.CENTER, display.width - 65, display.height * 0.93):addTo(self, 1)
  GameData.setCurrentSpirit(Const.CurSprite or 0)
  table.insert(self.mPanelTable, self.mSpiritPanel)
  self.mCimeliaPanel = PanelCimelia.new(handler(self, self.onEventPanelCimelia)):align(display.CENTER, 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mCimeliaPanel)
  self.mSkillPanel = PanelSkill.new(handler(self, self.onEventPanelSkill)):align(display.CENTER, display.width - 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mSkillPanel)
  self.mRelicsPanel = PanelRelics.new():addTo(self, 1)
  table.insert(self.mPanelTable, self.mRelicsPanel)
  if 1 == GameData.GAME_TYPE then
    local groovePanel = PanelGroove.new(handler(self, self.onEventPanelGroove)):align(display.CENTER, display.cx, 0):addTo(self, 1)
    table.insert(self.mPanelTable, groovePanel)
    self.mCimeliaPanel:hide()
    self.mSkillPanel:hide()
  elseif 0 == GameData.GAME_TYPE then
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
  PanelPause.new(handler(self, self.onEventPanelPause)):addTo(self, 1)
  self:gamePause()
end

function M:onEventPanelGame(tag, param)
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  if not GameManager.RESULT_SHOWED then
    local warResult = 0
    if PanelGame.TAG_TOWER_MONSTER_DEAD == tag then
      warResult = 1
    elseif PanelGame.TAG_TOWER_BUDDHA_DEAD == tag then
      warResult = 0
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
    
    local strAppSecret = "AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&fightResult=%s&stageId=%s&team=%s&token=%s&uid=%s", strAppSecret .. "", warResult .. "", GameManager.STAGE_ID .. "", teamInfoStr .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
    local params = {}
    params.fightResult = warResult
    params.stageId = GameManager.STAGE_ID
    params.team = teamInfoStr
    params.sign = crypto.md5(strSign, false)
    DYHttpMgr.eliteWarResult(tFuncListener, params)
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
  if 1.3 == self.mTimeScale then
    cc.Director:getInstance():getScheduler():setTimeScale(2)
    self.mTimeScale = 2
    param:setButtonImage("normal", "gamescene/speed2.png")
    param:setButtonImage("pressed", "gamescene/speed1.png")
  elseif 2 == self.mTimeScale then
    cc.Director:getInstance():getScheduler():setTimeScale(1.3)
    self.mTimeScale = 1.3
    param:setButtonImage("normal", "gamescene/speed1.png")
    param:setButtonImage("pressed", "gamescene/speed2.png")
  end
  DYStat.setValueInt(DY_KEY.kGameSpeed, math.floor(self.mTimeScale))
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

function M:onEventPanelGroove(params)
  if 101 == params.type then
    local currentSpirit = GameData.getCurrentSpirit()
    DYSoundMgr.playEffect(DY_SND.sfx_lq_upgrade)
    GameData.SPIRIT_LEVEL = GameData.SPIRIT_LEVEL + 1
    if GameData.SPIRIT_LEVEL > GameData.SPIRIT_MAX_LEVEL then
      GameData.SPIRIT_LEVEL = GameData.SPIRIT_MAX_LEVEL
      return
    end
    local ac = transition.sequence({
      cc.ScaleTo:create(0.2, 1.2),
      cc.ScaleTo:create(0.2, 0.75)
    })
    self.mSpiritPanel.mNumLabel:runAction(ac)
    self.mSpiritPanel:reInit()
  elseif 102 == params.type then
    local currentSpirit = GameData.getCurrentSpirit()
    DYSoundMgr.playEffect(DY_SND.sfx_lq_upgrade)
    GameData.setCurrentSpirit(currentSpirit + params.spiritNum)
  elseif 103 == params.type then
    if not params.isReady or GameData.IS_BUDDHA_LIMIT then
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_buddha_makeup)
    local currentSpirit = GameData.getCurrentSpirit()
    currentSpirit = currentSpirit - params.buddhaModel.consume
    GameData.setCurrentSpirit(currentSpirit)
    BMgr.createBuddha(GameData.BG, params.buddhaModel.npcId, nil, 1)
  elseif 104 == params.type then
    self.mCimeliaPanel:skillOnCast()
  elseif 105 == params.type then
    self.mSkillPanel:skillOnCast()
  end
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

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

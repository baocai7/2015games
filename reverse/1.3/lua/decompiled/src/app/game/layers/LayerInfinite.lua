local PanelBG = require("app.game.panel.PanelBG")
local PanelGame = require("app.game.panel.PanelGame")
local PanelPause = require("app.game.panel.PanelPause")
local PanelSpirit = require("app.game.panel.PanelSpirit")
local PanelCimelia = require("app.game.panel.PanelCimelia")
local PanelSkill = require("app.game.panel.PanelSkill")
local PanelTeam = require("app.game.panel.PanelTeam")
local PanelCounter = require("app.game.panel.PanelCounter")
local PanelWave = require("app.game.panel.PanelWave")
local PanelTimerInfinite = require("app.game.panel.PanelTimerInfinite")
local LayerWarResult = require("app.layers.LayerWarResult")
local PanelRelics = require("app.game.panel.PanelRelics")
CLASS_NAME = "LayerInfinite"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.FRAME_PER_SECOND = 24

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mGamePanel = nil
  self.mBgPanel = nil
  self:initData()
  self:initUI()
  self:addWaveTip()
  self.mSkill1 = {}
  self.mSkill2 = {}
  DYComponent.getMethods(self.mSkill1, "CimeliaSkill")
  DYComponent.getMethods(self.mSkill2, "CimeliaTowerSkill")
  local cimeliaAtkParam = {
    faceTo = 1,
    flag = FLAG_TOWER_BUDDHA,
    skillId = Const.CIMELIA_SKILL or GameData.CIMELIA_ATK.skillId,
    atk = GameData.CIMELIA_ATK.atkNum,
    aktType = GameData.CIMELIA_ATK.atkType,
    atkDis = GameData.CIMELIA_ATK.atkDistance
  }
  local cimeliaDefParam = {
    faceTo = 1,
    flag = FLAG_TOWER_BUDDHA,
    skillId = Const.CIMELIA_DEF_SKILL or GameData.CIMELIA_DEF.skillId
  }
  self.mSkill1:initCimData(cimeliaAtkParam)
  self.mSkill2:initCimData(cimeliaDefParam)
  self:performWithDelay(function()
    self:schedule(function()
      self:update()
    end, 1 / M.FRAME_PER_SECOND)
  end, 0.5)
  self:setNodeEventEnabled(true)
end

function M:initData()
  GameData.CIMELIA_ATK = DataUtils.getAtkCimeliaInfo()
  GameData.CIMELIA_DEF = DataUtils.getDefCimeliaInfo()
  local stageModel = DataUtils.getStageInfo(GameManager.MODE, GameManager.STAGE_ID)
  GameData.MAX_MONSTER_NUM = stageModel.maxNum
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
  self.mWavePanel = PanelWave.new():align(display.CENTER, display.width * 0.27, display.height * 0.93):addTo(self, 1)
  local normalImg = "gamescene/speed1.png"
  local pressedImg = "gamescene/speed2.png"
  if self.mTimeScale == 2 then
    normalImg = "gamescene/speed2.png"
    pressedImg = "gamescene/speed1.png"
  end
  cc.ui.UIPushButton.new({normal = normalImg, pressed = pressedImg}):onButtonPressed(function(event)
    self:onEventPanelSpeed(event.target)
  end):align(display.CENTER, display.width * 0.52, display.height * 0.93):addTo(self, 1)
  self.mSpiritPanel = PanelSpirit.new(handler(self, self.onEventButtonSpirit)):align(display.CENTER, display.width - 65, display.height * 0.93):addTo(self, 1)
  self.mSpiritPanel:setMaxSpirit()
  table.insert(self.mPanelTable, self.mSpiritPanel)
  self.mTimerPanel = PanelTimerInfinite.new(handler(self, self.onEventPanelTimer)):align(display.CENTER, 200, display.height * 0.75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mTimerPanel)
  self.mCimeliaPanel = PanelCimelia.new(handler(self, self.onEventPanelCimelia)):align(display.CENTER, 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mCimeliaPanel)
  self.mSkillPanel = PanelSkill.new(handler(self, self.onEventPanelSkill)):align(display.CENTER, display.width - 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mSkillPanel)
  self.mRelicsPanel = PanelRelics.new():addTo(self, 1)
  table.insert(self.mPanelTable, self.mRelicsPanel)
  local frame = display.newScale9Sprite("gamescene/team_frame.png", 0, 0, cc.size(display.width, 62), cc.rect(50, 30, 2, 2)):align(display.CENTER_BOTTOM, display.cx, 0):addTo(self)
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
      else
        local wrl = LayerWarResult.new(LayerWarResult.LOSE)
        self:addChild(wrl, 20)
      end
    end
    
    local time = CloudData.DELTA_TIME + os.time()
    local waveId = GameData.WAVE_NUM
    local strAppSecret = "AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&fightResult=%s&stageId=%s&team=%s&time=%s&token=%s&uid=%s&waveId=%s", strAppSecret .. "", warResult .. "", GameManager.STAGE_NUM .. "", teamInfoStr .. "", time .. "", CloudData.TOKEN .. "", CloudData.UID .. "", waveId .. "")
    local params = {}
    params.fightResult = warResult
    params.stageId = GameManager.STAGE_NUM
    params.team = teamInfoStr
    params.time = time
    params.waveId = waveId
    params.sign = crypto.md5(strSign, false)
    DYHttpMgr.towerWarResult(tFuncListener, params)
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
  self.mWavePanel:updateLabel()
  self:waveAction()
end

function M:onEventButtonSpirit(param)
  local currentSpirit = GameData.getCurrentSpirit()
  DYSoundMgr.playEffect(DY_SND.sfx_lq_upgrade)
  GameData.setCurrentSpirit(currentSpirit - param)
  GameData.SPIRIT_LEVEL = GameData.SPIRIT_LEVEL + 1
  self.mSpiritPanel:reInit()
end

function M:onEventPanelCimelia(param)
  self.mCimeliaPanel:initProgressTimer()
  self.mSkill1:castSkill()
end

function M:onEventPanelSkill(param)
  self.mSkillPanel:initProgressTimer()
  self.mSkill2:castTowerSkill()
end

function M:onEventPanelTeam(params)
end

function M:addWaveTip()
  self.mWaveFrame = display.newSprite("game_infinite/wave_frame.png", 0, 0):addTo(self, 5)
  self.mWaveNumLabel = display.newSprite(string.format("spin/%d.png", GameData.WAVE_NUM), self.mWaveFrame:getContentSize().width * 0.53, self.mWaveFrame:getContentSize().height * 0.5):scale(1.5):addTo(self.mWaveFrame)
  self:waveAction()
end

function M:waveAction()
  self.mWaveFrame:setPosition(cc.p(-display.width * 0.5, display.cy))
  self.mWaveNumLabel:setTexture(string.format("spin/%d.png", GameData.WAVE_NUM))
  local fadeIn = cc.FadeIn:create(0.25)
  local fadeOut = cc.FadeOut:create(0.25)
  local moveTo1 = cc.MoveTo:create(0.25, cc.p(display.cx, display.cy))
  local moveTo2 = cc.MoveTo:create(0.25, cc.p(display.width * 1.5, display.cy))
  local spawn1 = cc.Spawn:create(fadeIn, moveTo1)
  local spawn2 = cc.Spawn:create(fadeOut, moveTo2)
  self.mWaveFrame:runAction(transition.sequence({
    spawn1,
    cc.DelayTime:create(1.5),
    spawn2
  }))
end

function M:gamePause()
  for k, v in pairs(self.mPanelTable) do
    if v.pauseEx then
      v:pauseEx()
    end
    v:pause()
  end
end

function M:gameResume()
  for k, v in pairs(self.mPanelTable) do
    if v.resumeEx then
      v:resumeEx()
    end
    v:resume()
  end
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

local PanelBG = require("app.game.panel.PanelBG")
local PanelTimer = require("app.game.panel.PanelTimer")
local PanelSpiritPVP = require("app.game.panel.PanelSpiritPVP")
local PanelGame = require("app.game.panel.PanelGame")
local PanelTeamPVP = require("app.game.panel.PanelTeamPVP")
local LayerWarResult = require("app.layers.LayerWarResult")
local LayerFightWin = require("app.babel.layers.LayerFightWin")
local PanelRelics = require("app.game.panel.PanelRelics")
local CLASS_NAME = "LayerPVP"
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
  self:setNodeEventEnabled(true)
end

function M:initData()
  GameData.CIMELIA_DEF = DataUtils.getDefCimeliaInfo()
  GameData.CIMELIA_ATK = DataUtils.getAtkCimeliaInfo()
  GameData.TOWER_DISTANCE = 1000
  GameData.CLEAN_TIME = 300
  GameData.FRAME_PER_SECOND = 24
  GameData.TEAM_ICON = {}
  local speed = DYStat.getValueInt(DY_KEY.kGameSpeed, 1)
  if speed == 2 then
    cc.Director:getInstance():getScheduler():setTimeScale(2)
    self.mTimeScale = 2
  else
    cc.Director:getInstance():getScheduler():setTimeScale(1.3)
    self.mTimeScale = 1.3
  end
  self:performWithDelay(function()
    self:schedule(function()
      self:update()
    end, 1 / M.FRAME_PER_SECOND)
  end, 0.5)
  self.mPanelTable = {}
end

function M:initUI()
  self.mBgPanel = PanelBG.new(GameData.TOWER_DISTANCE):pos(0, 0):addTo(self)
  self.mGamePanel = PanelGame.new(handler(self, self.onEventPanelGame)):addTo(self, 2)
  table.insert(self.mPanelTable, self.mGamePanel)
  local timerPanel = PanelTimer.new(GameData.CLEAN_TIME, handler(self, self.onEventPanelTimer)):align(display.CENTER, display.width * 0.35, display.height * 0.93):addTo(self, 1)
  table.insert(self.mPanelTable, timerPanel)
  self.mTimePanel = timerPanel
  self.mSpiritPanel1 = PanelSpiritPVP.new(PanelSpiritPVP.BUDDHA_SPIRIT):align(display.CENTER, display.width - 65, display.height * 0.93):addTo(self, 1)
  self.mSpiritPanel2 = PanelSpiritPVP.new(PanelSpiritPVP.ENEMY_SPIRIT):align(display.CENTER, 65, display.height * 0.93):addTo(self, 1)
  self.mTeamPanel = PanelTeamPVP.new(handler(self, self.onEventPanelTeam)):align(display.CENTER_BOTTOM, display.cx, 0):addTo(self, 1)
  table.insert(self.mPanelTable, self.mTeamPanel)
  local normalImg = "gamescene/speed1.png"
  local pressedImg = "gamescene/speed2.png"
  if self.mTimeScale == 2 then
    normalImg = "gamescene/speed2.png"
    pressedImg = "gamescene/speed1.png"
  end
  cc.ui.UIPushButton.new({normal = normalImg, pressed = pressedImg}):onButtonPressed(function(event)
    self:onEventPanelSpeed(event.target)
  end):align(display.CENTER, display.width * 0.65, display.height * 0.93):addTo(self, 1)
end

function M:update()
  local buddhaTower = BMgrOL.getBuddhaTower()
  local monsterTower = BMgrOL.getMonsterTower()
  local tick = 0
  if not BMgrOL.SKIP_BATTLE then
    BMgrOL.update()
    self.mTeamPanel:update()
    self.mTimePanel:updateTimer()
  else
    while 0 < buddhaTower:getHp() and 0 < monsterTower:getHp() do
      tick = tick + 1
      BMgrOL.update()
      self.mTeamPanel:update()
      self.mTimePanel:updateTimer()
    end
  end
  if self.mTeamPanel.mCurrNpcNum == self.mTeamPanel.mNpcCountNum then
    local buddhaList = BMgr.getBuddhaList()
    local monsterList = BMgr.getMonsterList()
    if 0 == #buddhaList and 0 == #monsterList then
      self:onEventPanelGame(PanelGame.TAG_TOWER_BUDDHA_DEAD)
    end
  end
end

function M:onEventPanelGame(tag, param)
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  BMgrOL.calcuteBattleRest()
  if not GameManager.RESULT_SHOWED then
    local warResult = 0
    if PanelGame.TAG_TOWER_MONSTER_DEAD == tag then
      warResult = 1
    elseif PanelGame.TAG_TOWER_BUDDHA_DEAD == tag then
      warResult = 0
    end
    local enemyTeam = GameManager.PVP_ENEMY_INFO.buddhaInfo
    local selfTeam = GameManager.PVP_BUDDHA_INFO.buddhaInfo
    local enemyTeamInfoStr = json.encode(enemyTeam)
    local selfTeamInfoStr = json.encode(selfTeam)
    local enemySword = GameManager.PVP_ENEMY_INFO.sword
    local selfSword = GameManager.PVP_BUDDHA_INFO.sword
    local enemyUid = GameManager.PVP_ENEMY_INFO.uid
    if GameManager.IS_BABEL_GRAB == 1 then
      if warResult == 1 then
        local wrl = LayerFightWin.new()
        self:addChild(wrl, 20)
      else
        local function tFuncListener(info)
          if info.errorCode > 0 then
            local errMsg = info.errorMsg or "UNKONWN"
            
            WSToast.new(errMsg):addTo(self, 20)
          else
            CloudData.WAR_RESULT_TABLE = info.data or {}
            CloudData.WAR_RESULT_TABLE.retTime = info.time
            local wrl = LayerWarResult.new(LayerWarResult.LOSE)
            self:addChild(wrl, 20)
          end
        end
        
        local strAppSecret = "AFDASDFA47#$%@568%^076"
        local strSign = string.format("%s&fightResult=%s&opponentPower=%s&opponentTeam=%s&opponentUid=%s&seatId=%s&selfPower=%s&selfTeam=%s&token=%s&uid=%s", strAppSecret .. "", warResult .. "", enemySword .. "", enemyTeamInfoStr .. "", enemyUid .. "", GameManager.STAGE_ID .. "", selfSword .. "", selfTeamInfoStr .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
        local params = {}
        params.fightResult = warResult
        params.opponentPower = enemySword
        params.opponentTeam = enemyTeamInfoStr
        params.opponentUid = enemyUid
        params.seatId = GameManager.STAGE_ID
        params.selfPower = selfSword
        params.selfTeam = selfTeamInfoStr
        params.sign = crypto.md5(strSign, false)
        DYHttpMgr.babelFightResult(tFuncListener, params)
      end
      self:gamePause()
      return
    end
    
    local function tFuncListener(info)
      CloudData.WAR_RESULT_TABLE = info.data or {}
      if warResult == 1 then
        local wrl = LayerWarResult.new(LayerWarResult.WIN)
        self:addChild(wrl, 20)
      else
        local wrl = LayerWarResult.new(LayerWarResult.LOSE)
        self:addChild(wrl, 20)
      end
    end
    
    local strAppSecret = "AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&fightResult=%s&IsRevenge=%s&selfPower=%s&SelfTeam=%s&targetPower=%s&TargetTeam=%s&TargetUid=%s&token=%s&uid=%s", strAppSecret .. "", warResult .. "", GameManager.IS_REVENGE .. "", selfSword .. "", selfTeamInfoStr .. "", enemySword .. "", enemyTeamInfoStr .. "", enemyUid .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
    local params = {}
    params.fightResult = warResult
    params.IsRevenge = GameManager.IS_REVENGE
    params.selfPower = selfSword
    params.SelfTeam = selfTeamInfoStr
    params.targetPower = enemySword
    params.TargetTeam = enemyTeamInfoStr
    params.TargetUid = enemyUid
    params.sign = crypto.md5(strSign, false)
    DYHttpMgr.pvpRaceReward(tFuncListener, params)
  end
  self:gamePause()
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
  self:onEventPanelGame(PanelGame.TAG_TOWER_BUDDHA_DEAD)
end

function M:onEventButtonSpirit(param)
end

function M:onEventPanelTeam(params)
  if "buddha" == params then
    self.mSpiritPanel1:updateLabel(PanelSpiritPVP.BUDDHA_SPIRIT)
  else
    self.mSpiritPanel2:updateLabel(PanelSpiritPVP.ENEMY_SPIRIT)
  end
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  return true
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

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

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
local PanelGroove = require("app.game.panel.PanelGroove")
local LayerWarResult = require("app.layers.LayerWarResult")
local PanelDemoBuddha = require("app.game.panel.PanelDemoBuddha")
local PanelRelics = require("app.game.panel.PanelRelics")
local LayerErrorGameData = require("app.layers.LayerErrorGameData")
local NoviceGuide = require("app.utils.NoviceGuide")
local GameDialogue = require("app.utils.GameDialogue")
CLASS_NAME = "LayerNormal"
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
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  if stageProgress >= GameManager.STAGE_NUM then
    self:performWithDelay(function()
      self.mDemoBuddha:show()
    end, 2)
  else
    self.mGuideSch = self:schedule(function()
      self:dealUserGuide()
    end, 0.5)
  end
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
    GameData.CIMELIA_DEF.skillCDTime = 1
    GameData.CIMELIA_ATK.skillCDTime = 1
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
  if 3 ~= GameData.GAME_TYPE then
    cc.ui.UIPushButton.new({
      normal = "gamescene/pause.png",
      pressed = "gamescene/pause1.png"
    }):onButtonClicked(handler(self, self.onEventButtonPause)):align(display.CENTER_LEFT, display.width * 0.01, display.height * 0.93):addTo(self, 1)
  end
  local panelStage = PanelStage.new():align(display.CENTER, display.width * 0.18, display.height * 0.93):addTo(self, 1)
  if 3 == GameData.GAME_TYPE then
    panelStage:setVisible(false)
  end
  local timerPanel
  if 3 == GameData.GAME_TYPE then
    GameData.MODE = 7
    timerPanel = PanelTimer.new(self.mCleanTime, handler(self, self.onEventTrainPanelTimer))
    GameData.MODE = 0
  else
    timerPanel = PanelTimer.new(self.mCleanTime, handler(self, self.onEventPanelTimer))
  end
  timerPanel:align(display.CENTER, display.width * 0.37, display.height * 0.93):addTo(self, 1)
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
  self.mSpiritPanel = PanelSpirit.new(handler(self, self.onEventButtonSpirit)):align(display.CENTER, display.width * 0.95, display.height * 0.93):addTo(self, 1)
  GameData.setCurrentSpirit(Const.CurSprite or 0)
  table.insert(self.mPanelTable, self.mSpiritPanel)
  if 3 == GameData.GAME_TYPE then
    GameData.setCurrentSpirit(99999)
  end
  self.mCimeliaPanel = PanelCimelia.new(handler(self, self.onEventPanelCimelia)):align(display.CENTER, 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mCimeliaPanel)
  self.mSkillPanel = PanelSkill.new(handler(self, self.onEventPanelSkill)):align(display.CENTER, display.width - 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mSkillPanel)
  self.mDemoBuddha = PanelDemoBuddha.new(GameManager.STAGE_NUM):align(display.CENTER, display.width * 0.05, display.height * 0.6):hide():addTo(self, 1)
  self.mDemoBuddhaPlay = false
  table.insert(self.mPanelTable, self.mDemoBuddha)
  self.mRelicsPanel = PanelRelics.new():addTo(self, 1)
  table.insert(self.mPanelTable, self.mRelicsPanel)
  if 1 == GameData.GAME_TYPE then
    local groovePanel = PanelGroove.new(handler(self, self.onEventPanelGroove)):align(display.CENTER, display.cx, 0):addTo(self, 1)
    table.insert(self.mPanelTable, groovePanel)
    self.mCimeliaPanel:hide()
    self.mSkillPanel:hide()
  else
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
  for i = 1, 1 do
    BMgrOL.update()
    self.mCimeliaPanel:updateCimeAtk()
    self.mSkillPanel:updateCimeDEF()
    self.mTimePanel:updateTimer()
  end
end

function M:checkIconReady()
  for k, v in pairs(GameData.TEAM_ICON) do
    if v.mIsReady == true then
      v:addFingerEffect()
    elseif v.mIsReady == false then
      v:removeFingerEffect()
    end
  end
end

local function fingerEffect()
  local guideFinger = display.newNode()
  local finger = display.newSprite("novice_guide/finger.png"):addTo(guideFinger)
  finger:setScale(0.8)
  local moveBy1 = cc.MoveBy:create(0.5, cc.p(-20, 20))
  local moveBy2 = cc.MoveBy:create(0.5, cc.p(20, -20))
  local seq1 = transition.sequence({moveBy1, moveBy2})
  finger:runAction(cc.RepeatForever:create(seq1))
  finger:performWithDelay(function()
    finger:hide()
  end, 4)
  return guideFinger
end

function M:showSpiriteGuide()
  local tips2 = display.newSprite("novice_guide/2.png"):addTo(self)
  tips2:hide()
  tips2:setPosition(display.width * 0.74, display.height * 0.86)
  self:performWithDelay(function()
    tips2:show()
    self:performWithDelay(function()
      tips2:hide()
    end, 4)
  end, 0)
end

function M:dealUserGuide()
  local stageNum = GameManager.STAGE_NUM
  if stageNum == 1 then
    if not DataUtils.getGuideIsFirstPlayed("DIALOGUE_STAGE1_1") then
      self:gamePause()
      DataUtils.setGuideIsFirstPlayed("DIALOGUE_STAGE1_1", true)
      local guideLayer = GameDialogue.new("STAGE1_1", function()
        self:gameResume()
      end):addTo(self, 999)
      return
    elseif DataUtils.getGuideIsFirstPlayed("DIALOGUE_STAGE1_1") and not DataUtils.getGuideIsFirstPlayed("GUIDE_STAGE1_GAMESCN_1") then
      self:gamePause()
      local guide = NoviceGuide.new("GUIDE_STAGE1_GAMESCN_1", function()
        self:gameResume()
      end):addTo(self, 50)
      return
    elseif DataUtils.getGuideIsFirstPlayed("GUIDE_STAGE1_GAMESCN_1") and not DataUtils.getGuideIsFirstPlayed("GUIDE_STAGE1_GAMESCN_3") then
      self:gamePause()
      local guide = NoviceGuide.new("GUIDE_STAGE1_GAMESCN_3", function()
        self:gameResume()
      end):addTo(self, 50)
      return
    elseif DataUtils.getGuideIsFirstPlayed("GUIDE_STAGE1_GAMESCN_3") and not DataUtils.getGuideIsFirstPlayed("GUIDE_STAGE1_GAMESCN_4") then
      DataUtils.setGuideIsFirstPlayed("GUIDE_STAGE1_GAMESCN_4", true)
      self:showSpiriteGuide()
      return
    else
      self:checkIconReady()
    end
  end
  if stageNum == 2 then
    if not DataUtils.getGuideIsFirstPlayed("DIALOGUE_STAGE2_1") then
      DataUtils.setGuideIsFirstPlayed("DIALOGUE_STAGE2_1", true)
      self:gamePause()
      local guideLayer = GameDialogue.new("STAGE2_1", function()
        self:gameResume()
        local guide = NoviceGuide.new("GUIDE_STAGE2_STAGESCN_1"):addTo(self, 50)
      end):addTo(self, 50)
    end
    for _, monster in pairs(BMgr.getMonsterList()) do
      if tonumber(monster.model_.npcId) == 100180 and not self.mDemoBuddhaPlay and monster:getPositionX() > 300 then
        self.mDemoBuddhaPlay = true
        self:gamePause()
        local guideLayer = GameDialogue.new("STAGE2_1_1", function()
          self.mCimeliaPanel:removeProTimer()
          self:gamePause()
          local guide = NoviceGuide.new("GUIDE_CLICK_CLIME_ATK", function()
            self:gameResume()
          end):addTo(self, 50)
        end):addTo(self, 50)
      end
    end
  end
  if stageNum == 3 and not self.mDemoBuddhaPlay then
    self.mDemoBuddhaPlay = true
    
    local function tFunc()
      local guideLayer = GameDialogue.new("STAGE3_1", function()
        self.mDemoBuddha:show()
        self:gameResume()
        self:performWithDelay(function()
          self:gamePause()
          local tmpguide = NoviceGuide.new("GUIDE_STAGE3_STAGESCN_2", function()
            self:gameResume()
          end):addTo(self, 999)
          DYUtils.setGlobalZOrder(tmpguide, 10)
        end, 3)
      end):addTo(self, 999)
    end
    
    self:performWithDelay(function()
      self:gamePause()
      local guide = NoviceGuide.new("GUIDE_STAGE3_STAGESCN_1", function()
        self:gameResume()
        self:performWithDelay(function()
          self:gamePause()
        end, 1)
        tFunc()
      end):addTo(self, 999)
    end, 0.5)
  end
  if stageNum == 4 then
    for _, monster in pairs(BMgr.getMonsterList()) do
      if tonumber(monster.model_.npcId) == 500001 and not self.mDemoBuddhaPlay then
        self.mDemoBuddhaPlay = true
        self:gamePause()
        local guideLayer = GameDialogue.new("STAGE4_1", function()
          self.mSkillPanel:removeProTimer()
          self:gameResume()
          self:performWithDelay(function()
            self:gamePause()
            NoviceGuide.new("GUIDE_CLICK_CLIME_DEF", function()
              self:gameResume()
            end):addTo(self, 50)
          end, 1)
        end):addTo(self, 50)
      end
    end
  end
  if stageNum == 5 then
    if not self.mDemoBuddhaPlay then
      self.mDemoBuddhaPlay = true
      self:performWithDelay(function()
        BMgrOL.createDemoBuddha("24")
      end, 5)
      self:performWithDelay(function()
        BMgrOL.createDemoBuddha("25")
      end, 9)
      self:performWithDelay(function()
        BMgrOL.createDemoBuddha("26")
      end, 13)
      self:performWithDelay(function()
        require("app.layers.LayerGuideStage3").new(1, self):addTo(self, 50)
      end, 7)
      self:performWithDelay(function()
        self:gamePause()
        local guideLayer = GameDialogue.new("STAGE5_1", function()
          self:gameResume()
        end):addTo(self, 50)
      end, 3)
    end
    for _, monster in pairs(BMgr.getMonsterList()) do
      if tonumber(monster.model_.npcId) == 100406 and not self.mDemoBuddhaPlay1 then
        self.mDemoBuddhaPlay1 = true
        self:gamePause()
        local guideLayer = GameDialogue.new("STAGE5_2", function()
          self.mDemoBuddha:show()
          self:gameResume()
        end):addTo(self, 50)
      end
    end
  end
  if stageNum == 7 and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE7_GAMESCN_ZOOM") then
    DataUtils.setGuideIsFirstPlayed("GUDIE_STAGE7_GAMESCN_ZOOM", true)
    local guide = NoviceGuide.new("GUDIE_STAGE7_GAMESCN_ZOOM"):addTo(self, 50)
    self:performWithDelay(function()
      guide:removeSelf()
      BMgr.resume()
    end, 4)
  end
  if stageNum == 9 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STAGE9_CARD") then
    local guide = require("app.layers.LayerGuideStage9").new(1):addTo(self, 50)
    DataUtils.setGuideIsFirstPlayed("GUIDE_STAGE9_CARD", true)
    return
  end
  if stageNum == 10 then
    for _, monster in pairs(BMgr.getMonsterList()) do
      if tonumber(monster.model_.npcId) == 500002 and not self.mDemoBuddhaPlay then
        self.mDemoBuddhaPlay = true
        self:gamePause()
        GameDialogue.new("STAGE10_1", function()
          self.mDemoBuddha:show()
          self:gameResume()
        end):addTo(self, 999)
      end
    end
  end
  if stageNum == 11 and not self.mDemoBuddhaPlay then
    self.mDemoBuddhaPlay = true
    self:performWithDelay(function()
      self:gamePause()
      GameDialogue.new("STAGE11_1", function()
        self.mDemoBuddha:show()
        self:gameResume()
      end):addTo(self, 999)
    end, 3)
  end
  if stageNum == 12 and not self.mDemoBuddhaPlay then
    self.mDemoBuddhaPlay = true
    self:performWithDelay(function()
      self:gamePause()
      GameDialogue.new("STAGE12_1", function()
        self.mDemoBuddha:show()
        self:gameResume()
      end):addTo(self, 999)
    end, 3)
  end
  if stageNum == 15 and not self.mDemoBuddhaPlay then
    self.mDemoBuddhaPlay = true
    self:performWithDelay(function()
      self:gamePause()
      GameDialogue.new("STAGE15_1", function()
        self.mDemoBuddha:show()
        self:gameResume()
      end):addTo(self, 999)
    end, 3)
  end
  if stageNum == 19 and not self.mDemoBuddhaPlay then
    self.mDemoBuddhaPlay = true
    self:performWithDelay(function()
      self:gamePause()
      GameDialogue.new("STAGE19_1", function()
        self.mDemoBuddha:show()
        self:gameResume()
      end):addTo(self, 999)
    end, 3)
  end
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
      if warResult == 1 then
        CloudData.WAR_RESULT_TABLE = info.data or {}
        CloudData.WAR_RESULT_TABLE.retTime = info.time
        local wrl = LayerWarResult.new(LayerWarResult.WIN)
        self:addChild(wrl, 20)
      elseif warResult == 0 then
        CloudData.ENERGY = tonumber(info.data)
        CloudData.GAME_ITEM_INFO["3"] = CloudData.ENERGY
        DYAnalyze.item.consume(3, "ENERGY", GameManager.ENERGY_COST, "MAIN_STAGE_FIGHT")
        GameManager.ENERGY_COST = 0
        CloudData.WAR_RESULT_TABLE = {}
        CloudData.WAR_RESULT_TABLE.retTime = info.time or 0
        local wrl = LayerWarResult.new(LayerWarResult.LOSE)
        self:addChild(wrl, 20)
      elseif warResult == 2 then
        CloudData.ENERGY = tonumber(info.data) or CloudData.ENERGY
        CloudData.GAME_ITEM_INFO["3"] = CloudData.ENERGY
        DYAnalyze.item.consume(3, "ENERGY", GameManager.ENERGY_COST, "MAIN_STAGE_FIGHT")
        GameManager.ENERGY_COST = 0
        CloudData.WAR_RESULT_TABLE = {}
        LayerErrorGameData.new():addTo(self, 99999)
      end
    end
    
    local fightTime = GameData.BATTLE_TIME
    local strAppSecret = "AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&fightResult=%s&fightTime=%s&stageId=%s&team=%s&token=%s&uid=%s", strAppSecret .. "", warResult .. "", fightTime .. "", GameManager.STAGE_ID .. "", teamInfoStr .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
    local params = {}
    params.fightResult = warResult
    params.fightTime = fightTime
    params.stageId = GameManager.STAGE_ID
    params.team = teamInfoStr
    params.sign = crypto.md5(strSign, false)
    DYHttpMgr.mainWarResult(tFuncListener, params)
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

function M:onEventTrainPanelTimer()
  local monster = GameData.DEFENCE_BOSS
  local curDamage = 0
  if monster ~= nil then
    DDLOG(monster:getCurABLY(LIFE) .. "/" .. monster:getCurABLY(LIFE_CUR))
    curDamage = monster:getCurABLY(LIFE) - monster:getCurABLY(LIFE_CUR)
  end
  
  local function trainResult(param)
    dump(param)
    if param.ret_code ~= 0 then
      WSToast.new(param.err_msg):pos(0, 0):addTo(self, 20)
      param.train_exp = 0
    end
    require("app.layers.LayerTrainResult").new(LayerWarResult.WIN, curDamage, param.train_exp):addTo(self, 10)
  end
  
  DDLOG(DYLang.getString("S241", "") .. curDamage)
  self:safeSocketRequest("CMD_TRAIN_CLAN_BOSS", {
    boss_id = GameManager.DEFENCE_BOSS_ID,
    damage = curDamage
  }, trainResult)
  self:gamePause()
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
  DDLOG(keyCode)
  if keyCode == 124 then
    DDLOG("\232\131\156\229\136\169")
    self:onEventPanelGame(1000)
  end
  if keyCode == 78 then
    local list = BMgrOL:getMonsterList()
    self:listAddBuff(list, 1019, 10, 10, -20)
    local list = BMgrOL:getBuddhaList()
    self:listAddBuff(list, 1019, 10, 10, -20)
  end
  return true
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

local PanelBG = require("app.game.panel.PanelBG")
local PanelTimer = require("app.game.panel.PanelTimer")
local PanelSpirit = require("app.game.panel.PanelSpirit")
local PanelCimelia = require("app.game.panel.PanelCimelia")
local PanelSkill = require("app.game.panel.PanelSkill")
local PanelTeam = require("app.game.panel.PanelTeam")
local PanelGame = require("app.game.panel.PanelGame")
local PanelCounter = require("app.game.panel.PanelCounter")
local LayerWarResult = require("app.layers.LayerWarResult")
local PanelRelics = require("app.game.panel.PanelRelics")
local NoviceGuide = require("app.utils.NoviceGuide")
local GameDialogue = require("app.utils.GameDialogue")
CLASS_NAME = "LayerStage0"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mGamePanel = nil
  self.mBgPanel = nil
  self:initData()
  self:initUI()
  self:setNodeEventEnabled(true)
end

function M:initData()
  GameData.CIMELIA_ATK = DataUtils.getAtkCimeliaInfo()
  GameData.CIMELIA_DEF = DataUtils.getDefCimeliaInfo()
  GameData.CIMELIA_ATK.atkNum = 5000
  GameData.CIMELIA_ATK.skillId = 299111
  GameData.CIMELIA_ATK.skillCDTime = 1800
  GameData.CIMELIA_DEF.towerArmature = "tower_armature6"
  GameData.CIMELIA_ATK.wandIcon = "cimelia/pic/pic3.png"
  GameData.CIMELIA_ATK.ballIcon = "cimelia/icon/icon11.png"
  GameData.GAME_LAYER = self
  local stageModel = DataUtils.getStageInfo(GameManager.MODE, GameManager.STAGE_ID)
  GameData.MAX_MONSTER_NUM = stageModel.maxNum
  self.mTowerDistance = stageModel.towerDistance
  GameData.TOWER_DISTANCE = self.mTowerDistance
  self.mCleanTime = stageModel.cleanTime
  GameData.CLEAN_TIME = self.mCleanTime
  cc.Director:getInstance():getScheduler():setTimeScale(1.3)
  self.mTimeScale = 1.3
  GameData.IS_ON_CREATING_BUDDHA = false
  self.mPanelTable = {}
  self:performWithDelay(function()
    self:schedule(function()
      self:update()
    end, 0.041666666666666664)
  end, 0.5)
  self.mSkillArmature = ccs.Armature:create("tajinengdonghua")
  self.mSkillArmature:setPosition(display.cx, display.cy)
  self:addChild(self.mSkillArmature, 10)
end

function M:initUI()
  self.mRedBg = display.newColorLayer(cc.c4b(150, 0, 0, 120)):hide():addTo(self, 10)
  self.mBgPanel = PanelBG.new(self.mTowerDistance):pos(0, 0):addTo(self)
  self.mBgPanel:setBgScale(1, 1)
  self.mGamePanel = PanelGame.new(handler(self, self.onEventPanelGame)):addTo(self, 2)
  table.insert(self.mPanelTable, self.mGamePanel)
  self.mSpiritPanel = PanelSpirit.new(handler(self, self.onEventButtonSpirit)):align(display.CENTER, display.width - 65, display.height * 0.93):addTo(self, 1)
  GameData.setCurrentSpirit(Const.CurSprite or 0)
  table.insert(self.mPanelTable, self.mSpiritPanel)
  self.mSpiritPanel:hide()
  self.mCimeliaPanel = PanelCimelia.new(handler(self, self.onEventPanelCimelia)):align(display.CENTER, 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mCimeliaPanel)
  self.mSkillPanel = PanelSkill.new(handler(self, self.onEventPanelSkill)):align(display.CENTER, display.width - 75, 75):addTo(self, 1)
  table.insert(self.mPanelTable, self.mSkillPanel)
  self.mSkipButton = display.newSprite("common_ui/skip.png"):align(display.CENTER, display.width - 65, display.height * 0.93):addTo(self, 1)
  self.mSkipButton:setTouchEnabled(true)
  self.mSkipButton:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      DYSoundMgr.stopMusic(true)
      display.replaceScene(require("app.scenes.LoadingScene").new())
    end
  end)
  local frame = display.newScale9Sprite("gamescene/team_frame.png", 0, 0, cc.size(1280, 62), cc.rect(50, 30, 2, 2)):align(display.CENTER_BOTTOM, display.cx, 0):addTo(self)
  local teamInfo = {
    "15",
    "13",
    "14"
  }
  for i, buddhaId in pairs(teamInfo) do
    if buddhaId ~= "" then
      local buddhaModel = DataUtils.getMonsterModel(tonumber(buddhaId))
      buddhaModel.npcId = tonumber(buddhaId)
      local icon = PanelTeam.new(buddhaModel, handler(self, self.onEventPanelTeam)):pos(frame:getContentSize().width * (0.1 * i + 0.15), 60):addTo(frame, 1)
      icon:cooldown()
      GameData.TEAM_ICON[#GameData.TEAM_ICON + 1] = icon
      table.insert(self.mPanelTable, icon)
    end
  end
  local buddhaTower = BMgr.getBuddhaTower()
  
  function buddhaTower.underAttack()
    self:gamePause()
    DYSoundMgr.stopMusic(true)
    DYSoundMgr.playMusic(DY_SND.sound_stage0_comic)
    DYRes.unloadFileInfo(GameData.S_FILE_INFO)
    GameData.S_FILE_INFO = {}
    display.removeUnusedSpriteFrames()
    require("app.sprites.PanelComic").new(function()
      self:battleOver()
    end):addTo(self, 99)
  end
end

function M:update()
  BMgrOL.update()
  self.mCimeliaPanel:updateCimeAtk()
  self.mSkillPanel:updateCimeDEF()
end

function M:onEventPanelGame(tag, param)
end

function M:onEventPanelTimer(param)
end

function M:onEventButtonSpirit(param)
  local currentSpirit = GameData.getCurrentSpirit()
  DYSoundMgr.playEffect(DY_SND.sfx_lq_upgrade)
  GameData.setCurrentSpirit(currentSpirit - param)
  GameData.SPIRIT_LEVEL = GameData.SPIRIT_LEVEL + 1
  self.mSpiritPanel:reInit()
end

function M:onEventPanelCimelia(param)
  self.mSkillArmature:getAnimation():play("fengyitianxiang")
end

function M:onEventPanelSkill(param)
end

function M:onEventPanelTeam(params)
end

function M:battleOver()
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  self:gamePause()
  DYSoundMgr.stopMusic(true)
  local black = display.newSprite("opening_comic/bg_frame.png"):opacity(0):pos(display.cx, display.cy):addTo(self, 100)
  local textStr = DYLang.getString("S245", "")
  local lb = cc.ui.UILabel.new({
    text = textStr,
    size = 36,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dimensions = cc.size(800, 200),
    align = cc.ui.TEXT_ALIGN_LEFT
  }):opacity(0):align(display.CENTER, display.cx, display.cy):addTo(self, 101)
  black:runAction(cc.FadeIn:create(1.2))
  lb:runAction(transition.sequence({
    cc.DelayTime:create(1.2),
    cc.FadeIn:create(1.5),
    cc.DelayTime:create(2),
    cc.CallFunc:create(function()
      self:palyAnimation()
    end)
  }))
end

function M:palyAnimation()
  DYSoundMgr.stopMusic(true)
  DYSoundMgr.playMusic(DY_SND.sound_stage0_open_eyes)
  DYRes.loadFileInfo("opening_comic/tangsengzhengyan/tangsengzhengyan.csb", GameData.S_FILE_INFO)
  local bg = display.newSprite("opening_comic/tiankong.png", display.cx, display.cy):addTo(self, 101)
  local armature = ccs.Armature:create("tangsengzhengyan")
  armature:setScale(1.4)
  armature:setPosition(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5)
  armature:addTo(bg, 2)
  armature:getAnimation():playWithIndex(0)
  local bubble = display.newSprite("opening_comic/guangxian.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg)
  bubble:runAction(cc.RepeatForever:create(cc.RotateBy:create(10, 360)))
  self:performWithDelay(function()
    DDLOG(" ======================= ")
    
    local function tFunc()
      DYSoundMgr.stopMusic(true)
      self:startStage(1)
    end
    
    local guideLayer = GameDialogue.new("MAP_0_1", tFunc):addTo(self, 999)
  end, 7)
end

function M:startStage(stageNum)
  CloudData.ENERGY = CloudData.ENERGY - 8
  GameManager.ENERGY_COST = 8
  GameManager.STAGE_ID = stageNum + 10000
  GameManager.STAGE_NUM = stageNum or 0
  GameManager.MODE = 0
  display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE", "NORMAL"))
end

function M:gamePause()
  for k, v in pairs(self.mPanelTable) do
    if v.pauseEx then
      v:pauseEx()
    end
    v:pause()
  end
  self:iconPause()
end

function M:gameResume()
  for k, v in pairs(self.mPanelTable) do
    if v.resumeEx then
      v:resumeEx()
    end
    v:resume()
  end
end

function M:iconPause()
  for _, v in pairs(GameData.TEAM_ICON) do
    v:pauseEx()
  end
end

function M:iconResume()
  for _, v in pairs(GameData.TEAM_ICON) do
    v:resumeEx()
  end
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYRes.unloadFileInfo(GameData.S_FILE_INFO)
  GameData.S_FILE_INFO = {}
end

return M

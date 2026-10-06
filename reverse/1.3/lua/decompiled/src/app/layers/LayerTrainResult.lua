local WSToast = require("app.utils.WSToast")
local IconItem = require("app.icons.IconItem")
local LayerPvpRecordUp = require("app.layers.LayerPvpRecordUp")
local LayerLevelUpAni = require("app.layers.LayerLevelUpAni")
local mode_main_stage = 0
local mode_elite_stage = 1
local mode_infinite = 2
local mode_purgatory = 3
local mode_travel = 4
local mode_pvp = 5
local CLASS_NAME = "LayerWarResult"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.WIN = 1
M.LOSE = 0

function M:ctor(resultType, damage, train)
  GameManager.RESULT_SHOWED = true
  DYSoundMgr.stopMusic(true)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode()
  self.mNode:setPosition(display.cx, display.cy)
  self:addChild(self.mNode)
  self.mInfo = CloudData.WAR_RESULT_TABLE
  self.mBg = nil
  self.mExp = 0
  self.mEssence = 0
  self.mLianyubi = 0
  self.mFeat = 0
  self.mPeach = 0
  self.mStars = -1
  self.mAwardTable = {}
  self.mDropsList = {}
  self.mOldLevelRate = DataUtils.getExpLevelRate()
  self.mNewLevelRate = 0
  self.mDamage = damage
  self.mTrain = train
  self.mUserLevel = CloudData.USER_LEVEL
  self.mMode = GameManager.MODE
  self.mResultTpye = resultType
  self.mTouchEnabled = false
  self.mArmature_posY = 0.77
  self.mMark_posY = 390
  self.mStageFirstPass = false
  if self.mMode == mode_infinite then
    if self.mInfo.reachTowerStage ~= nil then
      CloudData.INFINITE_MAX_STAGE = tonumber(self.mInfo.reachTowerStage)
      CloudData.INFINITE_CUR_STAGE = CloudData.INFINITE_MAX_STAGE
    end
    if self.mInfo.reachTowerWave ~= nil then
      CloudData.INFINITE_MAX_WAVE = tonumber(self.mInfo.reachTowerWave)
    end
  end
  self:initBg()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initBg()
  self.mBg = display.newSprite("war_result/frame.png"):addTo(self.mNode)
  if self.mResultTpye == M.WIN then
    self:showSuccess()
  else
    self:showFailure()
  end
end

function M:showSuccess()
  DYSoundMgr.playEffect(DY_SND.sfx_win)
  display.addSpriteFrames("animation/shengli_xingxing.plist", "animation/shengli_xingxing.png")
  display.addSpriteFrames("animation/shengli_zouguang.plist", "animation/shengli_zouguang.png")
  self:addSuccArmature()
  self:addBottomBtns()
  self:addBattleTime()
  self:addBattleDamage()
  self:addBattleTrain()
end

function M:addBottomBtns()
  local num = GameManager.STAGE_NUM or 0
  local stageInfo = {
    {
      id = "start_main_" .. num,
      lab = DYLang.getString("S958", "")
    },
    {
      id = "start_elite_" .. num,
      lab = DYLang.getString("S959", "")
    },
    {
      id = "start_tower_" .. num,
      lab = DYLang.getString("S960", "")
    },
    {
      id = "start_purgatory_" .. num,
      lab = DYLang.getString("S961", "")
    },
    {
      id = "start_travel_" .. num,
      lab = DYLang.getString("S962", "")
    },
    {
      id = "start_pvp_" .. num,
      lab = DYLang.getString("S963", "")
    }
  }
  local info = {}
  if self.mResultTpye == M.WIN then
    info = {
      {
        str = DYLang.getString("S964", ""),
        func = function()
          self:returnCallBack()
        end,
        posX = 630
      }
    }
  end
  for i = 1, #info do
    local strLabel = cc.ui.UILabel.new({
      text = info[i].str,
      size = 30,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    })
    strLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }, {scale9 = true}):setButtonSize(180, 75):setButtonLabel("normal", strLabel):onButtonClicked(function()
      self:returnCallBack()
    end):align(display.CENTER, info[i].posX, 100):addTo(self.mBg, 1)
  end
end

function M:showRecordUpLayer(info)
  local lay = LayerPvpRecordUp.new(info)
  self:addChild(lay, 20)
end

function M:addBattleTime()
  local posY = self.mMark_posY
  local timeStr = cc.ui.UILabel.new({
    text = DYLang.getString("S965", ""),
    size = 24,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 393, posY):addTo(self.mBg)
  timeStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local time = GameData.BATTLE_TIME or 0
  local timeLabel = cc.ui.UILabel.new({
    text = time .. DYLang.getString("S967", ""),
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 870, posY):addTo(self.mBg)
  timeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:addBattleDamage()
  local posY = self.mMark_posY - 75
  local timeStr = cc.ui.UILabel.new({
    text = DYLang.getString("S968", ""),
    size = 24,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 393, posY):addTo(self.mBg)
  timeStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local damage = self.mDamage
  local timeLabel = cc.ui.UILabel.new({
    text = damage .. DYLang.getString("S969", ""),
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 870, posY):addTo(self.mBg)
  timeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:addBattleTrain()
  local posY = self.mMark_posY - 150
  local timeStr = cc.ui.UILabel.new({
    text = DYLang.getString("S970", ""),
    size = 24,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 393, posY):addTo(self.mBg)
  timeStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local timeLabel = cc.ui.UILabel.new({
    text = self.mTrain .. DYLang.getString("S969", ""),
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 870, posY):addTo(self.mBg)
  timeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:addSuccArmature()
  display.newSprite("war_result/halo1.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.5, 470):addTo(self.mBg, -1)
  local aniNode = display.newSprite():pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * self.mArmature_posY):addTo(self.mBg)
  display.newSprite("war_result/light.png"):align(display.CENTER, aniNode:getContentSize().width * 0.5, aniNode:getContentSize().height * 0.5 - 180):addTo(aniNode, -1)
  cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("animation/game_win/shenglidonghau0.csb")
  local game_win = ccs.Armature:create("shenglidonghau")
  game_win:setPosition(0, 0)
  game_win:getAnimation():playWithIndex(0)
  aniNode:addChild(game_win)
  cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
  self:runAction(transition.sequence({
    cc.DelayTime:create(0.7),
    cc.CallFunc:create(function()
      self.schedule_ = self:schedule(function()
        local frames1 = display.newFrames("shengli-zouguang%d.png", 1, 28)
        local animation1 = display.newAnimation(frames1, 0.08)
        local emptySp1 = display.newSprite():pos(self.mBg:getContentSize().width * 0.5 - 5, self.mBg:getContentSize().height * self.mArmature_posY - 20):addTo(self.mBg, 2)
        emptySp1:playAnimationOnce(animation1, true)
      end, 3.2)
    end)
  }))
end

function M:returnCallBack(scene, params)
  DDLOG(DYLang.getString("S973", ""))
  display.removeUnusedSpriteFrames()
  GameManager.RESULT_SHOWED = false
  GameManager.IS_USER_BUSY = 0
  DYSoundMgr.playMusic(DY_SND.bgm_theme)
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  CloudData.WAR_RESULT_TABLE = {}
  display.replaceScene(require("scenes.TinyLoadingScene").new("SCENE_UNION", {
    dest = "DefenceBoss"
  }))
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE and self.mTouchEnabled == true then
    self:returnCallBack()
  end
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

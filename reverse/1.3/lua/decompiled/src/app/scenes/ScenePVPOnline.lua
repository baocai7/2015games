local WSToast = require("app.utils.WSToast")
local LayerMatchPVPOL = require("app.layers.LayerMatchPVPOL")
local LayerTeam = require("app.layers.LayerTeam")
local LayerPVPOlReward = require("app.layers.LayerPVPOlReward")
local IconPkBubble = require("app.icons.IconPkBubble")
local LayerRule = require("app.layers.LayerRule")
local CLASS_NAME = "ScenePVPOnline"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene(CLASS_NAME)
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  if not audio.isMusicPlaying() then
    DYSoundMgr.playMusic(DY_SND.bgm_theme)
  end
  GameManager.MODE = 0
  GameManager.IS_USER_BUSY = 0
  self.mBg = nil
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initData()
  self:initUIFrame()
  self:initPkBubble()
end

function M:initUIFrame()
  local bg = display.newSprite("common_ui/common_bg.png", display.cx, display.cy)
  self:addChild(bg)
  local frame = display.newSprite("pvp_ol/entrance_bg.png", bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg)
  self.mBg = frame
  self:addContent()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 788, 535):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(frame)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1371", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, 529, 169):onButtonClicked(function()
    local function tFunc(attackTeam, helpTeam)
      local params = {}
      
      params.attackTeam = attackTeam
      params.helpTeam = helpTeam
      self:safeSocketRequest("CMD_UPDATE_TEAM", params)
    end
    
    LayerTeam.new(LayerTeam.TEAM_NORMAL, tFunc):addTo(self, 20)
  end):addTo(frame)
  self.mReadyBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1372", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, 712, 169):onButtonClicked(function()
    LayerMatchPVPOL.new():addTo(self, 20)
  end):addTo(frame)
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new()
  self:add(self.mPkBubble, 900)
end

function M:initData()
end

function M:addContent()
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):pos(137, 441):addTo(self.mBg)
  display.newSprite(CloudData.USER_ICON):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  display.newSprite("pvp_ol/name_bg.png"):pos(291, 469):addTo(self.mBg)
  display.newSprite("pvp_ol/win_str.png"):pos(189, 259):addTo(self.mBg)
  display.newSprite("pvp_ol/lose_str.png"):pos(190, 182):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "pvp_ol/rank_icon.png",
    pressed = "pvp_ol/rank_icon1.png"
  }):align(display.CENTER, 720, 350):onButtonClicked(function()
    self:showRankAward()
  end):addTo(self.mBg)
  LayerRule.newRuleIcon(LayerRule.PVPOL):align(display.CENTER, 60, 530):addTo(self.mBg)
  local rank = tonumber(CloudData.GRADE_INFO.ranking) + 1
  if rank == 0 then
    rank = DYLang.getString("S1374", "")
  end
  local score = CloudData.GRADE_INFO.score
  local winCount = CloudData.GRADE_INFO.win_count
  local loseCount = CloudData.GRADE_INFO.lost_count
  local rate = 0
  if 0 < winCount + loseCount then
    rate = math.round(winCount / (winCount + loseCount) * 100)
  end
  local info = {
    {
      text = CloudData.USER_NAME,
      color = cc.c3b(255, 255, 255),
      size = 24,
      x = 291,
      y = 469,
      align = display.CENTER
    },
    {
      text = "LV." .. CloudData.USER_LEVEL,
      color = cc.c3b(86, 42, 3),
      size = 24,
      x = 221,
      y = 412,
      align = display.CENTER_LEFT
    },
    {
      text = score,
      color = cc.c3b(86, 42, 3),
      size = 25,
      x = 579,
      y = 415,
      align = display.CENTER_LEFT
    },
    {
      text = rank,
      color = cc.c3b(86, 42, 3),
      size = 25,
      x = 579,
      y = 338,
      align = display.CENTER_LEFT
    },
    {
      text = winCount,
      color = cc.c3b(86, 42, 3),
      size = 35,
      x = 237,
      y = 256,
      align = display.CENTER_LEFT
    },
    {
      text = loseCount,
      color = cc.c3b(86, 42, 3),
      size = 35,
      x = 237,
      y = 179,
      align = display.CENTER_LEFT
    },
    {
      text = DYLang.getString("S1375", "") .. rate .. "%",
      color = cc.c3b(0, 255, 24),
      size = 22,
      x = 365,
      y = 117,
      align = display.CENTER_RIGHT
    }
  }
  for i = 1, #info do
    local textLabel = cc.ui.UILabel.new({
      text = info[i].text,
      size = info[i].size,
      color = info[i].color,
      font = GameManager.FONTNAME_TTF
    }):align(info[i].align, info[i].x, info[i].y):addTo(self.mBg)
    if i == #info then
      textLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    end
  end
end

function M:showRankAward()
  LayerPVPOlReward.new():addTo(self, 20)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  GameManager.MODE = 0
  CloudData.PVP_INFO = {}
  local nextScene = require("scenes.ChapterScene").new(3)
  display.replaceScene(nextScene, "fade", 0.2)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  display.removeUnusedSpriteFrames()
end

return M

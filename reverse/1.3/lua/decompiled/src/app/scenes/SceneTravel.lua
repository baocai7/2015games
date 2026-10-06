local DataLabelIcon = require("app.icons.DataLabelIcon")
local WSToast = require("app.utils.WSToast")
local LayerTravel = require("app.layers.LayerTravel")
local IconPkBubble = require("app.icons.IconPkBubble")
local M = {}
M = class("SceneTravel", function()
  return display.newScene("SceneTravel")
end)
M.ODD = 1
M.EVEN = 2
M.SUNDAY = 3

function M:ctor()
  GameManager.MODE = 4
  if not audio.isMusicPlaying() then
    DYSoundMgr.playMusic(DY_SND.bgm_theme)
  end
  self.mBg = nil
  self.mDayType = M.ODD
  self.mTimes = 0
  self:initBg()
  self:initPkBubble()
  self:reguestData()
  self.mKeypadListener = handler(self, self.onKeypad)
end

function M:reguestData()
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local msg = info.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    elseif self.initData then
      self:initData(info.data)
    end
  end
  
  DYHttpMgr.travelInit(tFuncListener)
end

function M:initData(info)
  self.mDayType = CloudData.TEST_TRAVEL_TYPE or tonumber(info.type)
  self.mTimes = tonumber(info.leftChallengeTimes)
  self:initUI()
end

function M:initBg()
  display.newSprite("common_ui/common_bg.png", display.cx, display.cy):addTo(self)
  self.mBg = display.newSprite("travel/bg.png", display.cx, display.cy):addTo(self)
  cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):scale(0.8):align(display.CENTER, display.width * 0.05, display.height * 0.95):onButtonClicked(function()
    self:returnCallBack()
  end):addTo(self, 15)
end

function M:initUI()
  local imgTable = {}
  for i = 1, 3 do
    local stageInfo = DYCommon.getDataByTag(DataRetainer.TRAVEL_STAGE_INFO, "type", tostring(i))[1]
    if not stageInfo then
      DDERROR("travel_stage type : %d with error data", tonumber(i))
    else
      imgTable[i] = stageInfo.icon
    end
  end
  cc.ui.UIPushButton.new("travel/" .. imgTable[self.mDayType] .. ".png"):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.75):onButtonClicked(function()
    self:chooseMode()
  end):addTo(self.mBg)
  table.remove(imgTable, self.mDayType)
  for i = 1, 2 do
    cc.ui.UIPushButton.new("travel/" .. imgTable[i] .. "_gray.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * (0.75 - i * 0.25)):onButtonClicked(function()
      local t = WSToast.new(DYLang.getString("S1420", ""), 1)
      self:addChild(t, 20)
    end):addTo(self.mBg)
  end
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new()
  self:add(self.mPkBubble, 900)
end

function M:chooseMode()
  local tasklevel = LayerTravel.new(self.mDayType, self.mTimes)
  self:addChild(tasklevel, 20)
end

function M:returnCallBack()
  GameManager.MODE = 0
  local nextScene = require("scenes.ChapterScene").new(8)
  display.replaceScene(nextScene, "fade", 0.2)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:returnCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
  GameManager.MODE = 4
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

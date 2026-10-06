local M = {}
M = class("AlertConnection", function()
  return display.newLayer()
end)
local M_timeOut, M_errorOccured

function M:ctor()
  self.mFailTimes = 0
  self:initUI()
  self:setNodeEventEnabled(true)
end

function M:initUI()
  self.mBg = display.newSprite("connection/connecting.png", display.cx, display.cy - 30):addTo(self)
  self.mBg:setVisible(false)
  self.mFile = {}
  DYRes.loadFileInfo("armature/jiuweihu1/jiuweihu1.csb", self.mFile)
  self.mArmature = ccs.Armature:create("jiuweihu1")
  self.mArmature:setPosition(self.mBg:getContentSize().width * 0.2, self.mBg:getContentSize().height * 0.18)
  self.mArmature:setScale(0.6)
  self.mBg:addChild(self.mArmature, 5)
  self.mArmature:getAnimation():playWithIndex(1)
  self.mArmature:getAnimation():setSpeedScale(1.4)
  self.mBg:runAction(transition.sequence({
    cc.DelayTime:create(1.5),
    cc.Show:create()
  }))
end

function M:timeOutCountDown()
  if self.mFailTimes >= 2 then
    self:runAction(transition.sequence({
      cc.DelayTime:create(10),
      cc.CallFunc:create(function()
        M_errorOccured(self)
      end)
    }))
  else
    self:runAction(transition.sequence({
      cc.DelayTime:create(10),
      cc.CallFunc:create(function()
        M_timeOut(self)
      end)
    }))
  end
end

function M_timeOut(self)
  if self.mBg then
    self.mBg:removeSelf()
    self.mBg = nil
  end
  local timeOutBg = display.newSprite("connection/timeout_bg.png", display.cx, display.cy):addTo(self)
  cc.ui.UIPushButton.new({
    normal = "connection/retry.png",
    pressed = "connection/retry1.png"
  }):onButtonClicked(function()
    self.mFailTimes = self.mFailTimes + 1
    timeOutBg:removeSelf()
    self:initUI()
  end):align(display.CENTER, timeOutBg:getContentSize().width * 0.5, timeOutBg:getContentSize().height / 4):addTo(timeOutBg)
end

function M_errorOccured(self)
  if self.mBg then
    self.mBg:removeSelf()
    self.mBg = nil
  end
  local timeOutBg = display.newSprite("connection/error_bg.png", display.cx, display.cy):addTo(self)
  cc.ui.UIPushButton.new({
    normal = "connection/restart.png",
    pressed = "connection/restart1.png"
  }):onButtonClicked(function()
    cc.Director:getInstance():endToLua()
    if device.platform == "windows" or device.platform == "mac" or device.platform == "ios" then
      os.exit()
    end
  end):align(display.CENTER, timeOutBg:getContentSize().width * 0.5, timeOutBg:getContentSize().height / 4):addTo(timeOutBg)
end

function M:closeDialog()
  self:removeSelf()
  DYRes.unloadFileInfo(self.mFile)
  self.mFile = {}
end

function M:onEnter()
end

function M:onExit()
  DYRes.unloadFileInfo(self.mFile)
  self.mFile = {}
end

AlertConnection = M
return M

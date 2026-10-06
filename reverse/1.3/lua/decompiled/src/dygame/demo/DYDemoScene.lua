local CLASS_NAME = "DYDemoScene"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene(CLASS_NAME)
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYNotification.registerScriptObserver(self, handler(self, self.onNotify), "onAddDiamonds")
  self:layoutUI()
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYNotification.removeAllObservers(self)
end

function M:onNotify(tag, param)
  DDLOG("on Notification callback ~")
end

function M:layoutUI()
  local label = cc.Label:create()
  label:setString("Hello world!")
  label:setPosition(display.cx, 600)
  label:setSystemFontSize(48)
  self:addChild(label)
  local ds = DYSprite.create("activity/activityBg.png", false)
  ds:setPosition(display.cx, display.cy)
  self:addChild(ds)
end

DYDemoScene = M
return M

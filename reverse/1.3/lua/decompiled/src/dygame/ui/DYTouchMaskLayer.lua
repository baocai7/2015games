local CLASS_NAME = "DYTouchMaskLayer"
local M = {}
M = class(CLASS_NAME, function(cb)
  return display.newNode(cb)
end)
M.TAG_CLICK = 1000

function M:ctor(cb)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCallback = cb
  self:layoutUI()
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
end

function M:layoutUI()
  local layer = display.newNode():addTo(self, -1)
  local listener = cc.EventListenerTouchOneByOne:create()
  listener:setSwallowTouches(true)
  listener:registerScriptHandler(function()
    self:invokeCallback(M.TAG_CLICK)
    return true
  end, cc.Handler.EVENT_TOUCH_BEGAN)
  local dispatcher = cc.Director:getInstance():getEventDispatcher()
  dispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
end

function M:invokeCallback(tag)
  DDLOG(CLASS_NAME .. " : invokeCallback")
  if self.mCallback then
    self.mCallback(tag)
  end
end

return M

local CLASS_NAME = "PanelGame"
local M = {}
M = class(CLASS_NAME, function()
  return display.newNode(CLASS_NAME)
end)
M.TAG_PAUSE = 1000
M.TAG_TEST1 = 1001
M.TAG_TEST2 = 1002

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
  local bg = display.newSprite("gi_logo.png")
  bg:setScale(0.5)
  self:addChild(bg)
  
  local function tFunc()
    self:invokeCallback(M.TAG_PAUSE)
  end
  
  self:performWithDelay(tFunc, 1)
end

function M:invokeCallback(tag, param)
  DDLOG(CLASS_NAME .. ": invokeCallback, tag = %d", tag)
  if self.mCallback then
    self.mCallback(tag, param)
  end
end

return M

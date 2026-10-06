local CLASS_NAME = "DYDemoLayer"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene(CLASS_NAME)
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  self:layoutUI()
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
end

function M:layoutUI()
end

DYDemoLayer = M
return M

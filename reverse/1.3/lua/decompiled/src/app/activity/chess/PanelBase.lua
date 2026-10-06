local DYClass = "PanelBase"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)

function M:ctor(params, cb)
  self.mData = params
  self.mCallback = cb
  cc(self):addComponent("framework.cc.components.behavior.EventProtocol"):exportMethods()
end

function M_filePath(name)
  return string.format("flight_chess/%s.png", name)
end

return M

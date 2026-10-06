local PanelBase = import(".PanelBase")
local DYClass = "PanelFateCard"
local M = {}
M = class(DYClass, PanelBase)

function M:ctor(params, cb)
  M.super.ctor(self, params, cb)
  self:layoutUI()
end

function M:layoutUI()
  local card = cc.ui.UIPushButton.new({
    normal = M_filePath("img_card")
  }):onButtonClicked(handler(self, self.onEventTouch)):align(display.CENTER, 93, 130):addTo(self)
end

function M:onEventTouch()
  if self.mCallback then
    self.mCallback()
  end
end

return M

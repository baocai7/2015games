local M = {}
M = class("PanelStage", function()
  return display.newNode()
end)

function M:ctor(index)
  self:initUI()
end

function M:initUI()
  local frame = display.newSprite("gamescene/label_frame.png"):addTo(self)
  cc.ui.UILabel.new({
    text = string.format(DYLang.getString("S268", ""), GameManager.STAGE_NUM),
    size = 30,
    color = cc.c3b(254, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
end

return M

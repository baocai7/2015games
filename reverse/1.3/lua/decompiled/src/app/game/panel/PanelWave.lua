local M = {}
M = class("PanelWave", function()
  return display.newNode()
end)

function M:ctor()
  self:initUI()
end

function M:initUI()
  local frame = display.newSprite("gamescene/label_frame.png"):addTo(self)
  self.mWaveLabel = cc.ui.UILabel.new({
    text = string.format(DYLang.getString("S269", ""), GameData.WAVE_NUM),
    size = 30,
    color = cc.c3b(254, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
end

function M:updateLabel()
  self.mWaveLabel:setString(string.format(DYLang.getString("S269", ""), GameData.WAVE_NUM))
end

return M

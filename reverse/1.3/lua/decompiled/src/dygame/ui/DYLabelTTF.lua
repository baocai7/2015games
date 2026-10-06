local CLASS_NAME = "DYLabelTTF"
local M = {}
M = class(CLASS_NAME, function()
  return display.newNode(CLASS_NAME)
end)
local M_ALIGN = {
  CENTER = display.CENTER,
  CENTER_LEFT = display.CENTER_LEFT,
  CENTER_RIGHT = display.CENTER_RIGHT,
  CENTER_TOP = display.CENTER_TOP,
  CENTER_BOTTOM = display.CENTER_BOTTOM,
  TOP_LEFT = display.TOP_LEFT,
  TOP_RIGHT = display.TOP_RIGHT,
  TOP_CENTER = display.TOP_CENTER,
  BOTTOM_LEFT = display.BOTTOM_LEFT,
  BOTTOM_RIGHT = display.BOTTOM_RIGHT,
  BOTTOM_CENTER = display.BOTTOM_CENTER,
  RIGHT_CENTER = display.RIGHT_CENTER,
  RIGHT_TOP = display.RIGHT_TOP,
  RIGHT_BOTTOM = display.RIGHT_BOTTOM,
  LEFT_CENTER = display.LEFT_CENTER,
  LEFT_TOP = display.LEFT_TOP,
  LEFT_BOTTOM = display.LEFT_BOTTOM
}

function M:ctor(params1, params2)
  local align = params1.dyalign or "CENTER"
  params1.dyalign = nil
  self.mFontSize = params1.size or 30
  self.mFontName = params1.font
  if params2 then
    self:createTTFWithOutline(align, params1, params2)
    return
  end
  self:createNormalTTF(align, params1)
end

function M:onEnter()
end

function M:onExit()
end

function M:createNormalTTF(align, params)
  local label = cc.ui.UILabel.new(params):align(M_ALIGN[align], 0, 0):addTo(self)
  self.mTextList = {label}
end

function M:createTTFWithOutline(align, params1, params2)
  local lineWidth = params2.lineWidth or 1.5
  local tempParams = clone(params1)
  tempParams.color = params2.lineColor or display.COLOR_BLACK
  local label = cc.ui.UILabel.new(params1):align(M_ALIGN[align], 0, 0):addTo(self)
  local leftLabel = cc.ui.UILabel.new(tempParams):align(M_ALIGN[align], -lineWidth, 0):addTo(self, -1)
  local rightLabel = cc.ui.UILabel.new(tempParams):align(M_ALIGN[align], lineWidth, 0):addTo(self, -1)
  local topLabel = cc.ui.UILabel.new(tempParams):align(M_ALIGN[align], 0, lineWidth):addTo(self, -1)
  local bottomLabel = cc.ui.UILabel.new(tempParams):align(M_ALIGN[align], 0, -lineWidth):addTo(self, -1)
  self.mTextList = {
    label,
    leftLabel,
    rightLabel,
    topLabel,
    bottomLabel
  }
end

function M:setString(text)
  for k, v in pairs(self.mTextList) do
    v:setString(text)
  end
end

function M:getString()
  return self.mTextList[1]:getString()
end

function M:setColor(color)
  self.mTextList[1]:setColor(color)
end

function M:getColor()
  return self.mTextList[1]:getColor()
end

function M:getFontSize()
  return self.mFontSize
end

function M:getFontName()
  return self.mFontName
end

function M:getContentSize()
  return self.mTextList[1]:getContentSize()
end

return M

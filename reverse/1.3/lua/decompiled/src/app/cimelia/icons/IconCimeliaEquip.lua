local M = {}
local M = class("IconCimeliaEquip", function()
  return display.newNode()
end)

function M:ctor(cimeliaModel, handler_)
  self.mCallback = handler_
  self:initData(cimeliaModel)
  self:initUI()
end

function M:initData(cimeliaModel)
  self.mCimeliaModel = cimeliaModel
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(780, 167), cc.rect(45, 30, 2, 2)):addTo(self)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mCimeliaModel.quality)):scale(0.85):align(display.CENTER_LEFT, 20, bg:getContentSize().height * 0.5 + 15):addTo(bg)
  local icon = display.newSprite(self.mCimeliaModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 < self.mCimeliaModel.stage then
    local topFrame = display.newSprite("cimelia/top_frame.png"):align(display.CENTER_TOP, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame)
    local pNode = display.newNode():align(display.CENTER, topFrame:getContentSize().width * 0.5, topFrame:getContentSize().height * 0.5):addTo(topFrame)
    pNode:setContentSize(18 * (self.mCimeliaModel.stage - 1), 24)
    for i = 1, self.mCimeliaModel.stage do
      display.newSprite("cimelia/magatama.png", 18 * (i - 1), 12):addTo(pNode)
    end
  end
  DYLabelTTF.new({
    text = string.format("Lv.%d", self.mCimeliaModel.level),
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {}):pos(iconFrame:getContentSize().width - 10, 20):addTo(iconFrame, 1)
  local textColor = DataUtils.getCimeliaNameColor(self.mCimeliaModel.quality)
  local lb = DYLabelTTF.new({
    text = self.mCimeliaModel.name,
    size = 24,
    color = textColor,
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(83, 54, 20)
  }):pos(bg:getContentSize().width * 0.09, bg:getContentSize().height * 0.15):addTo(bg)
  for i = 1, #self.mCimeliaModel.proType do
    local proType = tonumber(self.mCimeliaModel.proType[i])
    local typeLabel = display.newSprite(string.format("cimelia/type%d.png", proType)):align(display.CENTER_LEFT, bg:getContentSize().width * (0.52 - 0.3 * (i % 2)), bg:getContentSize().height * (0.96 - 0.24 * math.ceil(i / 2))):addTo(bg)
    local numLabel = cc.ui.UILabel.new({
      text = "",
      size = 24,
      color = cc.c3b(26, 18, 9),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, bg:getContentSize().width * (0.7 - 0.3 * (i % 2)), typeLabel:getPositionY()):addTo(bg)
    if 5 == proType then
      numLabel:setString(self.mCimeliaModel.proNum[i])
    elseif 6 == proType and -1 == tonumber(self.mCimeliaModel.proBaseNum[i]) then
      numLabel:setString(DYLang.getString("S365", ""))
    elseif 7 == proType then
      numLabel:setString(self.mCimeliaModel.proNum[i] .. "%")
    elseif 8 == proType then
      numLabel:setString(self.mCimeliaModel.proNum[i] .. "%")
    else
      numLabel:setString(self.mCimeliaModel.proNum[i])
    end
  end
  local num = #self.mCimeliaModel.proType + 1
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S366", ""),
    size = 28,
    color = cc.c3b(255, 249, 199),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(bg:getContentSize().width * (0.52 - 0.3 * (num % 2)), bg:getContentSize().height * (0.96 - 0.24 * math.ceil(num / 2))):addTo(bg)
  local lb = cc.ui.UILabel.new({
    text = "[" .. self.mCimeliaModel.skillName .. "]",
    size = 24,
    color = cc.c3b(29, 140, 7),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, lb:getContentSize().width + lb:getPositionX(), lb:getPositionY()):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S367", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.89, bg:getContentSize().height * 0.5):onButtonClicked(function()
    if self.mCallback then
      self.mCallback(self.mCimeliaModel.ucid)
    end
  end):addTo(bg)
end

return M

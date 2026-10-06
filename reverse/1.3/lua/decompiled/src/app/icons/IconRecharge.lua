local M = {}
M = class("IconRecharge", function()
  return display.newNode()
end)

function M:ctor(index)
  self.mInfoTable = CloudData.PAYMENT_INFO_TABLE[index]
  self.mStatus = tonumber(CloudData.PAYMENT_INFO_TABLE[index].status)
  self.mType = tonumber(self.mInfoTable.type)
  if self.mInfoTable == nil then
    self.mInfoTable = {}
    return
  end
  self:initUI()
end

function M:initUI()
  local frame = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(449, 181), cc.rect(55, 45, 2, 2)):addTo(self)
  local IconFrame = display.newSprite("common_ui/frame2.png"):pos(frame:getContentSize().width * 0.17, frame:getContentSize().height * 0.5):addTo(frame)
  display.newSprite(self.mInfoTable.icon):pos(IconFrame:getContentSize().width * 0.5, IconFrame:getContentSize().height * 0.5):addTo(IconFrame)
  local titleColor = cc.c3b(100, 56, 0)
  if 0 == self.mStatus then
    if 1 == self.mType then
      display.newSprite("recharge/double.png"):align(display.LEFT_TOP, 0, frame:getContentSize().height):addTo(frame, 1)
    elseif 2 <= self.mType and self.mType <= 4 then
      display.newSprite("recharge/tip.png"):align(display.LEFT_TOP, 0, frame:getContentSize().height):addTo(frame, 1)
      titleColor = cc.c3b(197, 19, 255)
    end
    cc.ui.UILabel.new({
      text = self.mInfoTable.intro,
      size = 20,
      color = cc.c3b(0, 144, 14),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.34, frame:getContentSize().height * 0.5):addTo(frame)
  end
  if self.mType > 4 then
    titleColor = cc.c3b(197, 19, 255)
  end
  display.newSprite("recharge/name_bg.png"):pos(frame:getContentSize().width * 0.64, frame:getContentSize().height * 0.72):addTo(frame)
  local titleLabel = cc.ui.UILabel.new({
    text = self.mInfoTable.title,
    size = 25,
    color = titleColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, frame:getContentSize().width * 0.64, frame:getContentSize().height * 0.72):addTo(frame)
  local tagLabel = cc.ui.UILabel.new({
    text = "\239\191\165:",
    size = 32,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.33, frame:getContentSize().height * 0.22):addTo(frame)
  tagLabel:enableOutline(cc.c4b(83, 54, 20, 255), 2)
  local priceFrame = display.newSprite("recharge/price_frame.png"):pos(frame:getContentSize().width * 0.69, frame:getContentSize().height * 0.22):addTo(frame)
  local priceLabel = cc.ui.UILabel.new({
    text = self.mInfoTable.price,
    size = 26,
    color = cc.c3b(255, 236, 212),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, priceFrame:getContentSize().width * 0.3, priceFrame:getContentSize().height * 0.5):addTo(priceFrame)
  priceLabel:enableOutline(cc.c4b(83, 54, 20, 255), 2)
end

return M

local LayerBuyVipGift = require("app.layers.LayerBuyVipGift")
local IconItem = require("app.icons.IconItem")
local M = {}
M = class("IconVipGift", function()
  return display.newNode()
end)

function M:ctor(index)
  self.mVipLevel = index
  self.mOriginPrice = 0
  self.mCurPrice = 0
  self.mBuyBtn = nil
  self.mGiftsInfo = {}
  local vipInfo = DYCommon.getDataByTag(DataRetainer.VIP_PRIVILEGE_INFO, "level", tostring(index))[1]
  if not vipInfo then
    DDERROR("vipInfo index : %d with error data", tonumber(index))
  else
    self.mOriginPrice = vipInfo.primePrice
    self.mCurPrice = vipInfo.dicountPrice
    local idInfo = split(vipInfo.packageThings, ";")
    local numInfo = split(vipInfo.packageNum, ";")
    for i = 1, #idInfo do
      self.mGiftsInfo[i] = {
        id = tonumber(idInfo[i]),
        num = tonumber(numInfo[i])
      }
    end
  end
  self:initBg()
end

function M:initBg()
  local bg = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(882, 200), cc.rect(55, 45, 2, 2)):addTo(self)
  display.newSprite("recharge/gift_title.png", bg:getContentSize().width * 0.45, bg:getContentSize().height * 0.85):addTo(bg)
  local titleLabel = cc.ui.UILabel.new({
    text = self.mVipLevel,
    size = 30,
    color = cc.c3b(7, 255, 25),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.455, bg:getContentSize().height * 0.85):addTo(bg)
  titleLabel:enableOutline(cc.c4b(83, 54, 20, 255), 2)
  display.newSprite("recharge/gift_bg.png", bg:getContentSize().width * 0.34, bg:getContentSize().height * 0.405):addTo(bg)
  display.newSprite("recharge/line.png", bg:getContentSize().width * 0.68, bg:getContentSize().height * 0.6):scale(0.9):addTo(bg, 1)
  display.newSprite("item_icon/pic_peach.png", bg:getContentSize().width * 0.68, bg:getContentSize().height * 0.58):scale(0.65):addTo(bg)
  local oPriceLabel = cc.ui.UILabel.new({
    text = self.mOriginPrice,
    size = 23,
    color = cc.c3b(255, 251, 195),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.705, bg:getContentSize().height * 0.59):addTo(bg)
  oPriceLabel:enableOutline(cc.c4b(13, 4, 9, 255), 2)
  display.newSprite("item_icon/pic_peach.png", bg:getContentSize().width * 0.68, bg:getContentSize().height * 0.25):scale(0.65):addTo(bg)
  local col = cc.c3b(255, 255, 255)
  if tonumber(CloudData.PEACH) < tonumber(self.mCurPrice) then
    col = cc.c3b(254, 61, 29)
  end
  local oPriceLabel = cc.ui.UILabel.new({
    text = self.mCurPrice,
    size = 23,
    color = col,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.705, bg:getContentSize().height * 0.26):addTo(bg)
  oPriceLabel:enableOutline(cc.c4b(13, 4, 9, 255), 2)
  for i = 1, #self.mGiftsInfo do
    local x = 0.127 * i - 0.03
    local icon = IconItem.new(self.mGiftsInfo[i].id, self.mGiftsInfo[i].num)
    icon:setPosition(bg:getContentSize().width * x, bg:getContentSize().height * 0.405)
    icon:setScale(0.82)
    bg:addChild(icon)
    icon:showItemTip()
  end
  local vip = CloudData.VIP_LEVEL
  if vip < self.mVipLevel then
    local vipLabel = cc.ui.UILabel.new({
      text = string.format("(VIP%d\229\143\175\232\180\173\228\185\176)", self.mVipLevel),
      size = 20,
      color = cc.c3b(26, 255, 15),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, bg:getContentSize().width * 0.89, bg:getContentSize().height * 0.43):addTo(bg)
    vipLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  else
    local buyText = cc.ui.UILabel.new({
      UILabelType = 2,
      text = DYLang.getString("S407", ""),
      size = 26,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    })
    buyText:enableOutline(cc.c4b(25, 30, 3, 255), 2)
    local buyText1 = cc.ui.UILabel.new({
      UILabelType = 2,
      text = DYLang.getString("S407", ""),
      size = 26,
      color = cc.c3b(202, 199, 199),
      font = GameManager.FONTNAME_TTF
    })
    buyText1:enableOutline(cc.c4b(40, 40, 40, 255), 2)
    self.mBuyBtn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png",
      disabled = "common_ui/btn_disabled1.png"
    }):align(display.CENTER, bg:getContentSize().width * 0.89, bg:getContentSize().height * 0.43):addTo(bg):setButtonLabel("normal", buyText):setButtonLabel("disabled", buyText1):onButtonClicked(function()
      self:clickGift(self.mVipLevel)
    end)
    local status = tonumber(CloudData.VIP_PACKAGE_STATUS_INFO[tostring(self.mVipLevel)])
    if status == 1 then
      self:performWithDelay(function()
        self.mBuyBtn:setButtonEnabled(false)
      end, 0)
    end
  end
end

function M:clickGift()
  local info = {
    award = self.mGiftsInfo,
    price = self.mCurPrice,
    vip = self.mVipLevel,
    cb = handler(self, self.giftBuySucc)
  }
  local tip = LayerBuyVipGift.new(info)
  display.getRunningScene():addChild(tip, 20)
end

function M:giftBuySucc()
  if self.mBuyBtn then
    self.mBuyBtn:setButtonEnabled(false)
  end
  for i = 1, #self.mGiftsInfo do
    DYAnalyze.item.get(self.mGiftsInfo[i].id, "", self.mGiftsInfo[i].num, "BUY_VIP_GIFT")
  end
end

return M

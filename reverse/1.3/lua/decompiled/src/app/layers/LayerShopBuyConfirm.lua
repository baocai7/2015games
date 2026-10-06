local WSToast = require("app.utils.WSToast")
local IconItem = require("app.icons.IconItem")
local CLASS_NAME = "LayerShopBuyConfirm"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(params)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.cb = params.func
  self.mQuality = 0
  self.mIcon = nil
  self.mCoinImg = nil
  self.mLimit = 0
  self.mBuyNum = 1
  self.mBuyNumLabel = nil
  self.mPriceLabel = nil
  self.mShopType = params.tag or 1
  self.mInfo = params.info
  if not self.mInfo then
    self:runAction(cc.RemoveSelf:create())
    return
  end
  self.mPrice = tonumber(self.mInfo.price)
  self.mId = tonumber(self.mInfo.thingId)
  self.mSum = CloudData.GAME_ITEM_INFO[tostring(self.mId)] or 0
  self.mColor = cc.c3b(255, 255, 255)
  local itemInfo = DataUtils.getItemModelWithColor(self.mId)
  if itemInfo then
    self.mColor = itemInfo.color
  end
  self.mCoinImg = DataUtils.getCoinPic(self.mInfo.finance)
  self.mLimit = tonumber(self.mInfo.limitTimes) - tonumber(self.mInfo.buyTimes)
  if 0 > self.mLimit then
    self.mLimit = 0
  end
  self.mCanTouch = true
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  if self.mShopType == 1 then
    self:initNormalBg()
  else
    self:initOtherShopBg()
  end
end

local function getCost(time)
  local costInfo = DYCommon.getDataByTag(DataRetainer.PVP_COUNT_CONSUME, "id", tostring(time))[1]
  if not costInfo then
    DDERROR("pvp countConsume: %d with error data", tonumber(time))
    return 0
  end
  return tonumber(costInfo.ginsenBuyPeach) or 0
end

function M:getPrice(id, num, price)
  local consume = 0
  local sum = tonumber(num)
  if tonumber(id) == 2005 and self.mShopType ~= 6 then
    local time = CloudData.GINSEN_BUY_TIME
    for i = 1, sum do
      local cost = getCost(time + i)
      consume = consume + cost
    end
  else
    consume = tonumber(price) * sum
  end
  return consume
end

function M:initNormalBg()
  local tip = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(598, 468), cc.rect(598, 125, 5, 5)):addTo(self.mNode)
  local IconFrame = IconItem.new(self.mId):scale(0.8):pos(tip:getContentSize().width * 0.17, tip:getContentSize().height * 0.82):addTo(tip)
  IconFrame:showItemTip()
  local nameBg = display.newScale9Sprite("common_ui/num_bg.png", 0, 0, cc.size(208, 42), cc.rect(50, 17, 1, 1)):pos(tip:getContentSize().width * 0.45, tip:getContentSize().height * 0.885):addTo(tip)
  local nameStr = cc.ui.UILabel.new({
    text = self.mInfo.name,
    size = 25,
    color = self.mColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, nameBg:getContentSize().width * 0.5, nameBg:getContentSize().height * 0.5):addTo(nameBg)
  nameStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local numStr = cc.ui.UILabel.new({
    text = DYLang.getString("S879", ""),
    size = 25,
    color = cc.c3b(255, 246, 6),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, tip:getContentSize().width * 0.39, tip:getContentSize().height * 0.77):addTo(tip)
  numStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local numLabel = cc.ui.UILabel.new({
    text = self.mSum,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, tip:getContentSize().width * 0.52, tip:getContentSize().height * 0.77):addTo(tip)
  numLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local numBg = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(475, 121), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.56):addTo(tip)
  self.mBuyNumLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = self.mBuyNum,
    font = "fonts/white_num.fnt"
  }):scale(1.5):align(display.CENTER, numBg:getContentSize().width * 0.5, numBg:getContentSize().height * 0.5):addTo(numBg)
  local decBtn = cc.ui.UIPushButton.new({
    normal = "package/btn_add.png"
  }):align(display.CENTER, numBg:getContentSize().width * 0.25, numBg:getContentSize().height * 0.5):addTo(numBg, 2):onButtonClicked(function()
    self:toSubtract()
  end)
  decBtn:setScaleX(-1)
  cc.ui.UIPushButton.new({
    normal = "package/btn_add.png"
  }):align(display.CENTER, numBg:getContentSize().width * 0.75, numBg:getContentSize().height * 0.5):addTo(numBg, 2):onButtonClicked(function()
    self:toAdd()
  end)
  local priceText = cc.ui.UILabel.new({
    text = DYLang.getString("S880", ""),
    size = 25,
    color = cc.c3b(255, 246, 6),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, tip:getContentSize().width * 0.16, tip:getContentSize().height * 0.35):addTo(tip)
  priceText:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  display.newSprite(self.mCoinImg):scale(0.8):pos(tip:getContentSize().width * 0.262, tip:getContentSize().height * 0.35):addTo(tip)
  self.mPriceLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = self.mPrice * self.mBuyNum,
    font = "fonts/white.fnt"
  }):scale(1.2):align(display.CENTER_LEFT, tip:getContentSize().width * 0.32, tip:getContentSize().height * 0.35 - 6):addTo(tip)
  if 0 < self.mLimit then
    local str = DYLang.getString("S881", "") .. self.mLimit .. DYLang.getString("S882", "")
    local limitLabel = cc.ui.UILabel.new({
      text = str,
      size = 20,
      color = cc.c3b(18, 255, 40),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_RIGHT, tip:getContentSize().width * 0.89, tip:getContentSize().height * 0.37):addTo(tip)
    limitLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  end
  local calcelLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S883", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  calcelLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, tip:getContentSize().width * 0.25, tip:getContentSize().height * 0.19):addTo(tip, 2):setButtonLabel("normal", calcelLabel):onButtonClicked(function()
    self:closeCallBack()
  end)
  local confirmLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S884", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  confirmLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, tip:getContentSize().width * 0.75, tip:getContentSize().height * 0.19):addTo(tip, 2):setButtonLabel("normal", confirmLabel):onButtonClicked(function()
    self:toBuy()
  end)
end

function M:initOtherShopBg()
  local tip = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  local IconFrame = IconItem.new(self.mId):pos(160, 213):addTo(tip)
  IconFrame:showItemTip()
  local nameBg = display.newScale9Sprite("common_ui/num_bg.png", 0, 0, cc.size(208, 42), cc.rect(50, 17, 1, 1)):pos(160, 298):addTo(tip)
  local nameStr = cc.ui.UILabel.new({
    text = self.mInfo.name,
    size = 25,
    color = self.mColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, nameBg:getContentSize().width * 0.5, nameBg:getContentSize().height * 0.5):addTo(nameBg)
  nameStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local numStr = cc.ui.UILabel.new({
    text = DYLang.getString("S879", ""),
    size = 25,
    color = cc.c3b(255, 246, 6),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 230, 243):addTo(tip)
  numStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local numLabel = cc.ui.UILabel.new({
    text = self.mSum,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, numStr:getPositionX() + numStr:getContentSize().width + 10, numStr:getPositionY()):addTo(tip)
  numLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local priceText = cc.ui.UILabel.new({
    text = DYLang.getString("S886", ""),
    size = 25,
    color = cc.c3b(255, 246, 6),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 230, 186):addTo(tip)
  priceText:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local coinImg = display.newSprite(self.mCoinImg):scale(0.8):align(display.CENTER_LEFT, priceText:getPositionX() + priceText:getContentSize().width + 5, priceText:getPositionY()):addTo(tip)
  self.mPriceLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = self.mPrice,
    font = "fonts/white.fnt"
  }):scale(1.2):align(display.CENTER_LEFT, coinImg:getPositionX() + coinImg:getContentSize().width, coinImg:getPositionY() - 6):addTo(tip)
  local calcelLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S883", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  calcelLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, 180, 85):addTo(tip, 2):setButtonLabel("normal", calcelLabel):onButtonClicked(function()
    self:closeCallBack()
  end)
  local confirmLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S884", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  confirmLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, 420, 85):addTo(tip, 2):setButtonLabel("normal", confirmLabel):onButtonClicked(function()
    self:toBuy()
  end)
end

function M:toSubtract()
  self.mBuyNum = self.mBuyNum - 1
  if self.mBuyNum < 1 then
    self.mBuyNum = 1
    local toast = WSToast.new(DYLang.getString("S889", ""), 1)
    self:addChild(toast, 5)
  else
    self.mBuyNumLabel:setString(self.mBuyNum)
    local price = self:getPrice(self.mId, self.mBuyNum, self.mPrice)
    self.mPriceLabel:setString(price)
  end
end

function M:toAdd()
  self.mBuyNum = self.mBuyNum + 1
  if self.mBuyNum > self.mLimit then
    self.mBuyNum = self.mLimit
    local toast = WSToast.new(DYLang.getString("S890", ""), 1)
    self:addChild(toast, 5)
  else
    self.mBuyNumLabel:setString(self.mBuyNum)
    local price = self:getPrice(self.mId, self.mBuyNum, self.mPrice)
    self.mPriceLabel:setString(price)
  end
end

function M:toBuy()
  local price = self:getPrice(self.mId, self.mBuyNum, self.mPrice)
  local cost = tonumber(CloudData.GAME_ITEM_INFO[tostring(self.mInfo.finance)]) or 0
  if price > cost then
    DYSoundMgr.playEffect(DY_SND.sfx_wrong)
    local info = DataUtils.getItemModel(self.mInfo.finance)
    local str = info.itemName .. DYLang.getString("S39", "")
    local toast = WSToast.new(str, 1.5)
    self:addChild(toast, 5)
  elseif self.mShopType == 1 and 0 < self.mLimit and self.mBuyNum > self.mLimit then
    local toast = WSToast.new(DYLang.getString("S890", ""), 1.5)
    self:addChild(toast, 5)
  else
    if self.cb and self.mCanTouch then
      self.mCanTouch = false
      self.cb(self.mBuyNum)
    end
    self:closeCallBack()
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:removeSelf()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

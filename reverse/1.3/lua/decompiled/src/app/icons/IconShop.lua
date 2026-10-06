local LayerShopBuyConfirm = require("app.layers.LayerShopBuyConfirm")
local IconItem = require("app.icons.IconItem")
local M = {}
M = class("IconShop", function()
  return display.newNode()
end)

local function getCost(time)
  local costInfo = DYCommon.getDataByTag(DataRetainer.PVP_COUNT_CONSUME, "id", tostring(time))[1]
  if not costInfo then
    DDERROR("pvp countConsume: %d with error data", tonumber(time))
    return 0
  end
  return tonumber(costInfo.ginsenBuyPeach) or 0
end

function M:ctor(params)
  self.mType = params.tag or 1
  self.mIndex = params.id
  self.mCoinImg = nil
  self.mLimitLabel = nil
  self.mPriceLabel = nil
  self.mNeedNum = 1
  self.mNeedLimit = 0
  self.mColor = cc.c3b(255, 255, 255)
  self.mInfo = params.info or {}
  self.cb = params.func
  self.mPrice = checknumber(self.mInfo.price)
  self.mBuyTime = checknumber(self.mInfo.buyTimes)
  self.mId = tonumber(self.mInfo.thingId)
  if self.mId == 2005 and self.mType < 5 then
    self.mPrice = getCost(CloudData.GINSEN_BUY_TIME + 1)
  end
  local itemInfo = DataUtils.getItemModelWithColor(self.mId)
  if itemInfo then
    self.mColor = itemInfo.color
  end
  self.mCoinImg = DataUtils.getCoinPic(self.mInfo.finance)
  if self.mType == 1 then
    self.mNeedNum = 0
    self.mNeedLimit = 1
  elseif self.mType == 6 then
    self.mNeedLimit = 1
  end
  self.mIsUnlock = 1
  if self.mType == 6 then
    if checknumber(CloudData.UNION_INFO.level) < checknumber(self.mInfo.unionlevel) then
      self.mIsUnlock = 0
      self:showGrayUI()
    elseif self.mBuyTime == 0 and 0 < checknumber(self.mInfo.limitTimes) then
      self:showNormalUI()
    else
      self:showGrayUI()
    end
  elseif self.mBuyTime >= checknumber(self.mInfo.limitTimes) then
    self:showGrayUI()
  else
    self:showNormalUI()
  end
end

function M:showNormalUI()
  self.mBg = display.newSprite("shop/item.png"):addTo(self)
  local IconFrame
  if self.mNeedNum == 1 then
    IconFrame = IconItem.new(self.mId, self.mInfo.count)
  else
    IconFrame = IconItem.new(self.mId)
  end
  IconFrame:setPosition(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.72)
  self.mBg:addChild(IconFrame)
  IconFrame:showItemTip()
  local nameBg = display.newScale9Sprite("common_ui/common_text.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.4, cc.size(140, 39), cc.rect(60, 0, 37, 0)):addTo(self.mBg)
  nameBg:setColor(cc.c3b(157, 146, 116))
  local titleLabel = cc.ui.UILabel.new({
    text = self.mInfo.name,
    size = 20,
    color = self.mColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, nameBg:getContentSize().width * 0.5, nameBg:getContentSize().height * 0.5):addTo(nameBg)
  titleLabel:enableOutline(cc.c4b(83, 54, 20, 255), 2)
  local buyBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):onButtonClicked(function()
    self:clickBuyBtn()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.17):addTo(self.mBg)
  buyBtn:setTouchSwallowEnabled(false)
  self.mPriceLabel = cc.ui.UILabel.new({
    text = self.mPrice,
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 20, 0):addTo(buyBtn)
  self.mPriceLabel:enableOutline(cc.c4b(83, 54, 20, 255), 2)
  local coinImg = display.newSprite(self.mCoinImg):scale(0.7):align(display.CENTER_RIGHT, self.mPriceLabel:getPositionX() - self.mPriceLabel:getContentSize().width * 0.5 - 5, 0):addTo(buyBtn)
  local discount = math.ceil(tonumber(self.mInfo.discount) or 0)
  if 0 < discount and discount < 10 then
    local discountBg = display.newSprite("shop/discount_bg.png"):align(display.TOP_LEFT, 0, self.mBg:getContentSize().height * 1):addTo(self.mBg, 1)
    display.newSprite("shop/discount" .. discount .. ".png"):align(display.CENTER, 21, 44):addTo(discountBg, 1)
  end
  if self.mNeedLimit == 1 then
    local limitBg = display.newSprite("shop/limit.png"):align(display.TOP_RIGHT, self.mBg:getContentSize().width * 1 + 5, self.mBg:getContentSize().height * 1 + 5):addTo(self.mBg, 1)
    local time = tonumber(self.mInfo.limitTimes) - self.mBuyTime
    self.mLimitLabel = cc.ui.UILabel.new({
      text = time,
      size = 26,
      color = cc.c3b(58, 255, 233),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, 39, 25):addTo(limitBg)
    self.mLimitLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  end
end

function M:showGrayUI()
  self.mBg = display.newGraySprite("shop/item.png", {
    0.2,
    0.3,
    0.5,
    0.1
  }):addTo(self)
  local IconFrame
  if self.mNeedNum == 1 then
    IconFrame = IconItem.new(self.mId, self.mInfo.count, "GRAY")
  else
    IconFrame = IconItem.new(self.mId, 0, "GRAY")
  end
  IconFrame:setPosition(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.72)
  self.mBg:addChild(IconFrame)
  IconFrame:showItemTip()
  local nameBg = display.newScale9Sprite("common_ui/common_text.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.4, cc.size(140, 39), cc.rect(60, 0, 37, 0)):addTo(self.mBg)
  nameBg:setColor(cc.c3b(111, 111, 111))
  local titleLabel = cc.ui.UILabel.new({
    text = self.mInfo.name,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, nameBg:getContentSize().width * 0.5, nameBg:getContentSize().height * 0.5):addTo(nameBg)
  local buyBtn = display.newSprite("common_ui/btn_disabled1.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.17):addTo(self.mBg)
  local priceLabel = cc.ui.UILabel.new({
    text = self.mPrice,
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 90, 35):addTo(buyBtn)
  local coinImg = display.newGraySprite(self.mCoinImg, {
    0.2,
    0.3,
    0.5,
    0.1
  }):scale(0.7):align(display.CENTER_RIGHT, priceLabel:getPositionX() - priceLabel:getContentSize().width * 0.5 - 5, 35):addTo(buyBtn)
  if self.mIsUnlock == 1 then
    local img = "shop/sold.png"
    if self.mType == 6 then
      img = "shop/sold.png"
      local time = checknumber(self.mInfo.limitTimes)
      if 0 < time then
        img = "union/shop_bought.png"
        local limitBg = display.newGraySprite("shop/limit.png", {
          0.2,
          0.3,
          0.5,
          0.1
        }):align(display.TOP_RIGHT, self.mBg:getContentSize().width * 1 + 5, self.mBg:getContentSize().height * 1 + 5):addTo(self.mBg, 1)
        self.mLimitLabel = cc.ui.UILabel.new({
          text = time,
          size = 26,
          color = cc.c3b(120, 120, 120),
          font = GameManager.FONTNAME_TTF
        }):align(display.CENTER, 39, 25):addTo(limitBg)
        self.mLimitLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
      end
    end
    display.newSprite(img, self.mBg:getContentSize().width * 0.65, self.mBg:getContentSize().height * 0.54):addTo(self.mBg, 1)
  else
    local lock = display.newSprite("union/shop_lock.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5):addTo(self.mBg, 1)
    local str = DYLang.getString("S395", "") .. checknumber(self.mInfo.unionlevel) .. DYLang.getString("S396", "")
    DYLabelTTF.new({
      text = str,
      size = 25,
      color = cc.c3b(255, 207, 76),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER"
    }, {}):pos(lock:getContentSize().width * 0.5, lock:getContentSize().height * 0.5):addTo(lock)
  end
end

function M:clickBuyBtn()
  if self.mType == 4 then
    local info = CloudData.SHOP_TOTAL_INFO[self.mType].goods
    local buy = 0
    for k, v in pairs(info) do
      if 0 < v.buyTimes then
        buy = buy + 1
      end
    end
    if 2 <= buy then
      local toast = WSToast.new(DYLang.getString("S397", ""), 1.5)
      display.getRunningScene():addChild(toast, 20)
      return
    end
  end
  self.mInfo.price = self.mPrice
  self.mInfo.buyTimes = self.mBuyTime
  local params = {
    tag = self.mType,
    info = self.mInfo,
    func = handler(self, self.buyCallback)
  }
  local tip = LayerShopBuyConfirm.new(params)
  display.getRunningScene():addChild(tip, 20)
end

function M:buyCallback(num)
  local function tFuncListener(response)
    if response.errorCode ~= 0 then
      DYSoundMgr.playEffect(DY_SND.sfx_wrong)
      
      local toast = WSToast.new(response.errorMsg, 2)
      display.getRunningScene():addChild(toast, 20)
    else
      self.mBuyTime = tonumber(response.data.buyTimes) or 1
      if self.mId == 2005 and self.mType ~= 6 then
        CloudData.GINSEN_BUY_TIME = CloudData.GINSEN_BUY_TIME + num
        local price = getCost(CloudData.GINSEN_BUY_TIME + 1)
        self.mPrice = price
      end
      if CloudData.SHOP_TOTAL_INFO[self.mType] then
        CloudData.SHOP_TOTAL_INFO[self.mType].goods[tostring(self.mIndex)].buyTimes = self.mBuyTime
        CloudData.SHOP_TOTAL_INFO[self.mType].goods[tostring(self.mIndex)].price = self.mPrice
      end
      response.data.buyItemNum = checknumber(num) * checknumber(self.mInfo.count)
      self:buySuccessed(response.data)
    end
  end
  
  local params = {}
  params.id = self.mIndex
  if self.mType == 1 then
    params.count = num
    DYHttpMgr.normalShopBuy(tFuncListener, params)
  elseif self.mType == 2 then
    DYHttpMgr.featShopBuy(tFuncListener, params)
  elseif self.mType == 3 then
    DYHttpMgr.purgatoryShopBuy(tFuncListener, params)
  elseif self.mType == 4 then
    DYHttpMgr.mysteryShopBuy(tFuncListener, params)
  elseif self.mType == 5 then
    DYHttpMgr.pvpOlShopBuy(tFuncListener, params)
  elseif self.mType == 6 then
    local param = {
      order = self.mIndex
    }
    self:safeSocketRequest("CMD_BUY_CLAN_SHOP", param, function(param)
      self:unionShopBuy(param)
    end)
  end
end

function M:unionShopBuy(param)
  if param.ret_code and param.ret_code == 0 then
    local coin = CloudData.GAME_ITEM_INFO[tostring(self.mInfo.finance)] or 0
    local leftCoin = coin - self.mPrice
    local thing = CloudData.GAME_ITEM_INFO[tostring(self.mId)] or 0
    local thingSum = thing + checknumber(self.mInfo.count)
    local info = {
      leftFinance = leftCoin,
      leftThing = thingSum,
      buyItemNum = checknumber(self.mInfo.count)
    }
    self.mBuyTime = checknumber(self.mInfo.limitTimes)
    self.mInfo.limitTimes = checknumber(param.limitTimes)
    self:buySuccessed(info)
  else
    DYSoundMgr.playEffect(DY_SND.sfx_wrong)
    local msg = param.err_msg or "UNKNOWN"
    WSToast.new(msg):addTo(display.getRunningScene(), 20)
  end
end

function M:buySuccessed(info)
  local t = WSToast.new(DYLang.getString("S398", ""), 2)
  display.getRunningScene():addChild(t, 100)
  DYSoundMgr.playEffect(DY_SND.sfx_item_sell)
  self:refreshUI()
  local finance = tonumber(info.leftFinance)
  local cost = DataUtils.updateItemNum(self.mInfo.finance, finance)
  local leftThing = tonumber(info.leftThing)
  DataUtils.updateItemNum(self.mId, leftThing)
  DYAnalyze.item.buy(self.mId, "", info.buyItemNum, cost, self.mInfo.finance, self.mType)
  DYAnalyze.item.get(self.mId, "", info.buyItemNum, string.format("SHOP_%s", checkstring(self.mType)))
  if self.cb then
    self.cb()
  end
end

function M:refreshUI()
  local time = tonumber(self.mInfo.limitTimes) - self.mBuyTime
  if self.mLimitLabel and 0 < time then
    self.mLimitLabel:setString(time)
    self.mPriceLabel:setString(self.mPrice)
  else
    self.mBg:removeSelf()
    self.mBg = nil
    self:showGrayUI()
  end
end

return M

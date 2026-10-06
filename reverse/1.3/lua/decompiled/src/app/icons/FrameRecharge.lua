local IconRecharge = require("app.icons.IconRecharge")
local WSToast = require("app.utils.WSToast")
local AlertConnection = require("app.layers.AlertConnection")
local M = {}
M = class("FrameRecharge", function()
  return display.newNode()
end)
local M_onIapListener

function M:ctor(cb)
  self.mBg = nil
  self.mSum = 0
  self.mInfoTable = {}
  self.mIsPaying = false
  self.mOrderId = ""
  self.mPayItem = nil
  self.mIconTable = {}
  self.cb = cb
  self.mConnectionMask = nil
  self.mNode = display.newSprite():addTo(self, 1)
  self.mNode:setContentSize(976, 482)
  self:initData()
end

function M:initData()
  self.mInfoTable = CloudData.PAYMENT_INFO_TABLE
  self.mSum = #self.mInfoTable
  dump(self.mInfoTable)
  self:showRechargeList()
end

function M:initBg()
  self.mBg = display.newSprite():addTo(self)
  self.mBg:setContentSize(976, 482)
  self:showRechargeList()
end

function M:showRechargeList()
  if self.mListview then
    self.mListview:removeSelf()
    self.mListview = nil
  end
  self.mListview = cc.ui.UIListView.new({
    async = true,
    viewRect = cc.rect(17, 85, 945, 390),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(self.mNode)
  self.mListview:setAnchorPoint(0.5, 0.5)
  local row = math.ceil(self.mSum / 2)
  
  local function tFuncDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
      return row
    else
      if cc.ui.UIListView.CELL_TAG == tag then
        local item = self.mListview:newItem()
        local content = display.newNode()
        content:setAnchorPoint(0.5, 0.5)
        local column = 2
        if idx == row then
          column = (self.mSum - 1) % 2 + 1
        end
        for count = 1, column do
          local index = (idx - 1) * 2 + count
          local icon = IconRecharge.new(index)
          icon:setPosition(465 * count - 227, 97)
          content:addChild(icon)
          self.mIconTable[index] = icon
        end
        content:setContentSize(940, 195)
        item:addContent(content)
        item:setItemSize(940, 195)
        return item
      else
      end
    end
  end
  
  self.mListview:setDelegate(tFuncDelegate)
  self.mListview:reload()
end

function M:touchListener(event)
  if "clicked" == event.name then
    local x = event.point.x
    local column
    if x < 454 and 12 < x then
      column = 1
    elseif x < 929 and 487 < x then
      column = 2
    else
      return
    end
    local idx = (event.itemPos - 1) * 2 + column
    if idx > self.mSum then
      return
    end
    local id = tonumber(self.mInfoTable[idx].id)
    local item = self.mIconTable[idx]
    item:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1, 0.95), cc.ScaleTo:create(0.1, 1)))
    self:clickItem(id)
    local rechargeType = tonumber(self.mInfoTable[idx].type)
    if rechargeType == 2 then
    elseif rechargeType == 3 then
    else
      local price = self.mInfoTable[idx].price or 0
    end
  end
end

function M:clickItem(id)
  print("recharge ........ " .. id)
  if CloudData.USER_SERVER_INFO.payable and tonumber(CloudData.USER_SERVER_INFO.payable) == 0 then
    local toast = WSToast.new(checkstring(DYLang.getString("S323", ""), 10))
    display.getRunningScene():addChild(toast, 200)
    return
  end
  if self.mIsPaying then
    return
  end
  self.mIsPaying = true
  
  local function tFuncListener(jsonTable)
    if 0 == jsonTable.errorCode then
      self.mOrderId = jsonTable.data.orderId
      local payItem = clone(DYIAPMgr.getProducts()[id])
      payItem.userId = CloudData.UID
      payItem.orderId = jsonTable.data.orderId
      DYIAPMgr.pay(payItem, handler(self, M_onIapListener))
      self.mPayItem = payItem
      if self.mConnectionMask then
        self.mConnectionMask:runAction(cc.RemoveSelf:create())
        self.mConnectionMask = nil
      end
      self.mConnectionMask = DYTouchMaskLayer.new()
      display.getRunningScene():addChild(self.mConnectionMask, 200)
      display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self.mConnectionMask)
    else
      local toast = WSToast.new(checkstring(jsonTable.errorMsg or DYLang.getString("S324", "")), 3)
      display.getRunningScene():addChild(toast, 200)
      self.mIsPaying = false
    end
  end
  
  local channelName = DYUtils.channelName()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&channel=%s&productId=%s&regionId=%s&token=%s&uid=%s", strAppSecret .. "", channelName .. "", id .. "", CloudData.USER_SERVER_ID .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.accountId = CloudData.ACCOUNT_ID
  params.paymentId = id
  params.channel = channelName
  params.sign = crypto.md5(strSign, false)
  params.gameId = DYUtils.gameId()
  DYHttpMgr.getProductOrder(tFuncListener, params)
end

function M_onIapListener(self, et)
  self.mIsPaying = false
  if self.mConnectionMask then
    self.mConnectionMask:runAction(cc.RemoveSelf:create())
    self.mConnectionMask = nil
  end
  DDLOG("M_onIapListener: " .. pickle(et))
  if et.event == dy.iap.EVENT_PAY_SUCC then
    local id = tonumber(et.param.id)
    self.mCheckTimes = 0
    self:checkPaymentStatus(id)
  else
    local toast = WSToast.new(DYLang.getString("S326", ""), 3)
    display.getRunningScene():addChild(toast, 200)
  end
end

function M:checkPaymentStatus(productId)
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode == 0 then
      self:rechargeSuccess(productId, jsonTable)
      
      return
    end
    self.mCheckTimes = self.mCheckTimes + 1
    if self.mCheckTimes >= 10 then
      if jsonTable.errorMsg then
        local toast = WSToast.new(checkstring(jsonTable.errorMsg), 3)
        display.getRunningScene():addChild(toast, 200)
      else
        local toast = WSToast.new(checkstring(DYLang.getString("S325", "")), 3)
        display.getRunningScene():addChild(toast, 200)
      end
      return
    end
    WSToast.new(string.format("\229\133\133\229\128\188\231\187\147\230\158\156\233\170\140\232\175\129\228\184\173%d", self.mCheckTimes), 0.5):addTo(display.getRunningScene(), 200)
    self:performWithDelay(function()
      self:checkPaymentStatus(productId)
    end, 1)
  end
  
  local channelName = DYUtils.channelName()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&channel=%s&orderId=%s&regionId=%s&token=%s&uid=%s", strAppSecret .. "", channelName .. "", self.mOrderId .. "", CloudData.USER_SERVER_ID .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.channel = channelName
  params.orderId = self.mOrderId
  params.sign = crypto.md5(strSign, false)
  DYHttpMgr.paymentSuccessReport(tFuncListener, params)
end

function M:rechargeSuccess(id, jsonTable)
  do
    local tag1 = checknumber(CloudData.VIP_LEVEL)
    local tag2 = checknumber(jsonTable.data.vip)
    if tag1 ~= tag2 then
      DYAnalyze.account.changeTag("VIP", tag1, tag2)
    end
    DYAnalyze.currency.paymentSuccess(self.mOrderId, self.mPayItem.id, self.mPayItem.price, self.mPayItem.type, DYUtils.channelName())
  end
  for k, v in pairs(jsonTable.data.drop) do
    DataUtils.updateItemNum(k, v)
    if tonumber(k) == 1 then
      DYAnalyze.item.buy(1, "PEACH", num, self.mPayItem.price, "RMB", "")
      DYAnalyze.item.get(1, "PEACH", num, "RECHARGE")
    else
      DYAnalyze.item.get(k, "", v, "RECHARGE")
    end
  end
  CloudData.PEACH_BUY_COUNT = jsonTable.data.peachBuy
  CloudData.VIP_LEVEL = jsonTable.data.vip
  CloudData.MONEY = jsonTable.data.money or 0
  CloudData.FIRST_RECHARGE_STATE = tonumber(jsonTable.data.firstPay)
  local currScene = display.getRunningScene()
  if "ChapterScene" == currScene.__cname then
    currScene:checkNewFirstRecharge()
  end
  self:showRechargeList()
  if self.cb then
    self:performWithDelay(function()
      self.cb()
    end, 0.2)
  end
end

return M

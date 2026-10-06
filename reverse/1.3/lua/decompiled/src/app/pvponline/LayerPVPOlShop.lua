local IconShop = require("app.icons.IconShop")
local DYClass = "LayerPVPOlShop"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M:ctor(callback)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mInfo = {}
  self.mBg = nil
  self.mCoinSumLabel = nil
  self.mRefreshCoinIcon = nil
  self.mRefreshCostLabel = nil
  self.mTimeLabel = nil
  self.refreshBtn = nil
  self.refreshNumLab = nil
  self.mCoinType = 7
  self.mRefreshCost = 0
  self.mRefreshTimes = 0
  self.mRefreshTime = 0
  self:initUI()
  self:requestData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:requestData()
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local msg = info.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      self:initData(info.data)
    end
  end
  
  DYHttpMgr.pvpOlShopInit(tFuncListener)
end

function M:initData(info)
  self.mInfo = info.shop or {}
  self.mCoinType = checknumber(info.finance)
  self.mRefreshCost = checknumber(info.refreshCost)
  self.mRefreshTimes = checknumber(info.refreshTimes)
  self.mRefreshTime = checknumber(info.refreshTime)
  self:initGoodsList()
  self:refreshWidgets()
  self:startCountDown()
end

function M:initUI()
  local bg = display.newSprite("pvp_ol/bg_shop.png"):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 925, 575):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg, 1)
  self:initCoinWidegt()
  self:initRefreshWidget()
end

function M:initCoinWidegt()
  local tip = display.newScale9Sprite("common_ui/num_bg.png", 0, 0, cc.size(150, 34), cc.rect(50, 0, 34, 0)):pos(200, self.mBg:getContentSize().height * 0.76):addTo(self.mBg)
  display.newSprite("item_icon/pic_horn.png"):scale(0.72):pos(tip:getContentSize().width * 0.05, tip:getContentSize().height * 0.5):addTo(tip)
  self.mCoinSumLabel = cc.ui.UILabel.new({
    text = "",
    size = 22,
    color = cc.c3b(11, 253, 32),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, tip:getContentSize().width * 0.52, tip:getContentSize().height * 0.5):addTo(tip)
  self.mCoinSumLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:initRefreshWidget()
  display.newSprite("shop/refresh.png"):scale(0.9):align(display.CENTER_RIGHT, 425, self.mBg:getContentSize().height * 0.77):addTo(self.mBg)
  self.mTimeLabel = cc.ui.UILabel.new({
    text = "",
    size = 22,
    color = cc.c3b(96, 255, 1),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 435, self.mBg:getContentSize().height * 0.77):addTo(self.mBg)
  self.mTimeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  self.refreshBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }):scale(0.9):align(display.CENTER, 815, self.mBg:getContentSize().height * 0.78):addTo(self.mBg, 2):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1179", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(147, 78, 1)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1179", ""),
    size = 25,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:clickRefresh()
  end)
  self.refreshNumLab = cc.ui.UILabel.new({
    text = "",
    size = 25,
    color = cc.c3b(11, 253, 32),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 10, 0):addTo(self.refreshBtn)
  self.refreshNumLab:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local costBg = display.newScale9Sprite("common_ui/num_bg.png", 0, 0, cc.size(120, 34), cc.rect(50, 0, 34, 0)):align(display.CENTER_RIGHT, -100, -5):addTo(self.refreshBtn)
  costBg:setTouchEnabled(true)
  self.mRefreshCoinIcon = display.newSprite():scale(0.8):pos(costBg:getContentSize().width * 0.05, costBg:getContentSize().height * 0.5):addTo(costBg)
  self.mRefreshCostLabel = cc.ui.UILabel.new({
    text = "",
    size = 26,
    color = cc.c3b(11, 253, 32),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, costBg:getContentSize().width * 0.52, costBg:getContentSize().height * 0.5):addTo(costBg)
  self.mRefreshCostLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:initGoodsList()
  if self.mListview then
    self.mListview:runAction(cc.RemoveSelf:create())
    self.mListview = nil
  end
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(95, 87, 765, 389),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  self.mListview = listView
  local sum = 0
  for k, v in pairs(self.mInfo) do
    sum = sum + 1
  end
  local row = math.ceil(sum / 4)
  for i = 1, row do
    local item = listView:newItem()
    local content = display.newNode()
    content:setAnchorPoint(0.5, 0.5)
    content:setContentSize(765, 276)
    local column = 4
    if i == row then
      column = (sum - 1) % 4 + 1
    end
    for count = 1, column do
      local index = (i - 1) * 4 + count
      local params = {
        id = index,
        tag = 5,
        info = self.mInfo[tostring(index)],
        func = handler(self, self.refreshWidgets)
      }
      local icon = IconShop.new(params)
      icon:setPosition(content:getContentSize().width * (0.25 * count - 0.125), content:getContentSize().height * 0.5)
      content:addChild(icon)
    end
    item:addContent(content)
    item:setItemSize(765, 282)
    listView:addItem(item)
  end
  listView:reload()
end

function M:refreshWidgets()
  local sum = CloudData.GAME_ITEM_INFO["7"] or 0
  self.mCoinSumLabel:setString(sum)
  local pic = DataUtils.getCoinPic(self.mCoinType)
  self.mRefreshCoinIcon:setTexture(pic)
  self.mRefreshCostLabel:setString(self.mRefreshCost)
  self.refreshNumLab:setString("(" .. self.mRefreshTimes .. ")")
  if 0 >= self.mRefreshTimes then
    self.refreshBtn:setButtonEnabled(false)
    self.refreshNumLab:setColor(cc.c3b(255, 255, 255))
  else
    self.refreshBtn:setButtonEnabled(true)
  end
  if self.mCallback then
    self.mCallback()
  end
end

function M:clickRefresh()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  local sum = CloudData.GAME_ITEM_INFO[tostring(self.mCoinType)] or 0
  if sum < self.mRefreshCost then
    local toast = WSToast.new(DYLang.getString("S1181", ""), 2)
    self:addChild(toast, 20)
    return
  end
  
  local function tFuncListener(response)
    if response.errorCode ~= 0 then
      local toast = WSToast.new(response.errorMsg, 2)
      self:addChild(toast, 20)
    elseif self.refreshSuccessed then
      self:refreshSuccessed(response.data)
    end
  end
  
  DYHttpMgr.pvpOlShopRefresh(tFuncListener)
end

function M:refreshSuccessed(info)
  self.mInfo = info.shopList or {}
  self.mCoinType = checknumber(info.finance)
  self.mRefreshCost = checknumber(info.leftFinance)
  self.mRefreshTimes = checknumber(info.refreshTimes)
  local coinType = checknumber(info.refreshFinance)
  local num = checknumber(info.refreshLeftFinance)
  DataUtils.updateItemNum(coinType, num)
  self:initGoodsList()
  self:refreshWidgets()
end

function M:startCountDown()
  local time = self.mRefreshTime
  self.mHours = math.floor(time / 3600)
  time = time % 3600
  self.mMinutes = math.floor(time / 60)
  self.mSeconds = math.floor(time % 60)
  self.mTimeLabel:setString(string.format("%02d:%02d:%02d", self.mHours, self.mMinutes, self.mSeconds))
  self.schedule = self:schedule(function()
    self:updateSecond()
  end, 1)
end

function M:updateSecond()
  if self.mSeconds > 0 then
    self.mSeconds = self.mSeconds - 1
  elseif 0 < self.mMinutes then
    self.mMinutes = self.mMinutes - 1
    self.mSeconds = 59
  elseif 0 < self.mHours then
    self.mHours = self.mHours - 1
    self.mMinutes = 59
    self.mSeconds = 59
  else
    self:countdownOver()
  end
  self.mTimeLabel:setString(string.format("%02d:%02d:%02d", self.mHours, self.mMinutes, self.mSeconds))
end

function M:countdownOver()
  self:stopAction(self.schedule)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
  if self.mCallback then
    self.mCallback()
  end
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

local IconShop = require("app.icons.IconShop")
local DYClass = "LayerUnionShop"
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
  self.mRecord = {}
  self.mCoinType = 9
  self.mRefreshTime = 0
  self.mBg = nil
  self.mCoinSumLabel = nil
  self.mTimeLabel = nil
  self:initUI()
  self:requestData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:requestData()
  local function tFuncEvent(param)
    if param.err_msg and param.err_msg ~= "" then
      WSToast.new(param.err_msg):addTo(self, 20)
    elseif self.initData then
      self:initData(param)
    end
  end
  
  self:safeSocketRequest("CMD_CLAN_SHOP_DATA", nil, tFuncEvent)
end

function M:initData(info)
  self.mInfo = info.shop_data or {}
  self.mRefreshTime = math.ceil(info.next_refresh_time)
  self.mRecord = info.my_shop_record or {}
  self:initGoodsList()
  self:refreshWidgets()
  self:startCountDown()
end

function M:initUI()
  local bg = display.newSprite("shop/bg.png"):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 1000, 575):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg, 1)
  self:initCoinWidegt()
  self:initRefreshWidget()
end

function M:initCoinWidegt()
  local tip = display.newScale9Sprite("common_ui/num_bg.png", 0, 0, cc.size(150, 34), cc.rect(50, 0, 34, 0)):pos(325, self.mBg:getContentSize().height * 0.77):addTo(self.mBg)
  local img = DataUtils.getCoinPic(self.mCoinType)
  display.newSprite(img):pos(tip:getContentSize().width * 0.05, tip:getContentSize().height * 0.5):addTo(tip)
  self.mCoinSumLabel = cc.ui.UILabel.new({
    text = "",
    size = 22,
    color = cc.c3b(11, 253, 32),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, tip:getContentSize().width * 0.52, tip:getContentSize().height * 0.5):addTo(tip)
  self.mCoinSumLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:initRefreshWidget()
  display.newSprite("shop/refresh.png"):scale(0.9):align(display.CENTER_RIGHT, 700, self.mBg:getContentSize().height * 0.77):addTo(self.mBg)
  self.mTimeLabel = cc.ui.UILabel.new({
    text = "",
    size = 22,
    color = cc.c3b(96, 255, 1),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 710, self.mBg:getContentSize().height * 0.77):addTo(self.mBg)
  self.mTimeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:initGoodsList()
  if self.mListview then
    self.mListview:runAction(cc.RemoveSelf:create())
    self.mListview = nil
  end
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(218, 105, 765, 389),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  self.mListview = listView
  local sum = #self.mInfo
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
      if self.mRecord[tostring(index)] then
        self.mInfo[index].buyTimes = 1
      else
        self.mInfo[index].buyTimes = 0
      end
      local params = {
        id = index,
        tag = 6,
        info = self.mInfo[index],
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
  local sum = CloudData.GAME_ITEM_INFO[tostring(self.mCoinType)] or 0
  self.mCoinSumLabel:setString(sum)
  if self.mCallback then
    self.mCallback()
  end
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
  self.schedule = nil
  self:requestData()
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

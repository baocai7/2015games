local IconActivityTask = require("app.icons.IconActivityTask")
local IconActivityBuy = require("app.icons.IconActivityBuy")
local IconShop = require("app.icons.IconShop")
local IconInvest = require("app.icons.IconInvest")
local LayerRecharge = require("app.layers.LayerRecharge")
local LayerVipShopClosed = require("app.layers.LayerVipShopClosed")
local LayerCommon = require("app.union.layers.LayerCommon")
local M = {}
local CLASS_NAME = "LayerShopNew"
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local M_TAB_IMG = {
  [1] = "label_vip",
  [2] = "label_invest",
  [3] = "label_normal",
  [4] = "label_gongxun",
  [5] = "label_lianyu",
  [6] = "label_mystery"
}
local M_SHOP_CONDITION = {
  [2] = {
    level = Const.FUNC_UNLOCK.pvp,
    scene = "scenes.ScenePVP"
  },
  [3] = {
    level = Const.FUNC_UNLOCK.purgatory,
    scene = "scenes.ScenePurgatory"
  }
}
M.SHOP_NORMAL = 1
M.SHOP_GONGXUN = 2
M.SHOP_LIANYU = 3
M.SHOP_MYSTERY = 4
M.TAG_TIME1 = 101
M.TAG_TIME2 = 102

local function getTimeText(time)
  local day = math.floor(time / 24 / 3600)
  local hour = math.floor((time - day * 24 * 3600) / 3600)
  local minutes = math.floor((time - day * 24 * 3600 - hour * 3600) / 60)
  local seconds = time - day * 24 * 3600 - hour * 3600 - minutes * 60
  local isNeedCountdown = false
  local textStr = ""
  if 0 < day then
    textStr = string.format("%d\229\164\169%d\229\176\143\230\151\182", day, hour)
  elseif 0 < hour then
    textStr = string.format("%d\229\176\143\230\151\182%d\229\136\134", hour, minutes)
  else
    textStr = string.format("%d\229\136\134%d\231\167\146", minutes, seconds)
    isNeedCountdown = true
  end
  return textStr, isNeedCountdown
end

local function M_parseTime(time)
  local hour = math.floor(time / 3600)
  local mins = math.floor((time - hour * 3600) / 60)
  local secs = time - hour * 3600 - mins * 60
  return hour, mins, secs
end

local function M_filePath(name)
  return string.format("shop_new/%s.png", name)
end

function M:ctor(initIdx, callback)
  self.mInitIdx = initIdx or 1
  if self.mInitIdx < 1 or self.mInitIdx > 6 then
    self.mInitIdx = 1
  end
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:initUI()
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  local function tFuncListener(jsonTable)
    self.mModelTable = {}
    
    local activityList = jsonTable.data.list
    for k, v in pairs(activityList) do
      local pModel = {}
      pModel.activeId = v.id
      pModel.priority = v.index
      pModel.aType = v.type
      pModel.closeTime = v.closeTimeSeconds or 0
      pModel.awardTime = v.awardTimeSeconds or 0
      pModel.taskIds = split(v.taskIds, ";") or {}
      pModel.name = v.name or ""
      table.insert(self.mModelTable, pModel)
    end
    table.sort(self.mModelTable, function(v1, v2)
      return v1.priority < v2.priority
    end)
    if not self.class or self.class.__cname ~= CLASS_NAME then
      return
    end
    self.mActivityProArr = jsonTable.data.currentProgress
    self:initInvestData(jsonTable.data.invest)
    self:initShopData(jsonTable.data)
    CloudData.GINSEN_BUY_TIME = jsonTable.data.ginsenBuyTimes
    self.mGiftData = self.mModelTable[1]
    self.mCountTime = 0
    self.mTabBtns = {}
    self.mTabTag = self.mInitIdx
    self.mCurrTab = nil
    self.mSheetBtns = {}
    self.mSheetTag = 1
    self.mCurrSheet = nil
    self.mSchedule = self:schedule(function()
      self:updateCountTime()
    end, 1)
    self:initTabBtn()
  end
  
  local countCE = DataUtils.getUserCountCE()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&power=%s&token=%s&uid=%s", strAppSecret .. "", countCE .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.sign = crypto.md5(strSign, false)
  params.power = countCE
  DYHttpMgr.shopInit(tFuncListener, params)
end

function M:initInvestData(data)
  self.mInvestInfo = {
    isBuy = data.isBuy,
    vip = data.vip,
    peach = data.peachCost,
    peachGet = data.peachSum
  }
  self.mInvestData = data.list
  table.sort(self.mInvestData, function(v1, v2)
    if v1.isDraw == v2.isDraw then
      return v1.level < v2.level
    else
      return v1.isDraw < v2.isDraw
    end
  end)
end

function M:initShopData(data)
  CloudData.SHOP_TOTAL_INFO[1] = {
    refreshTime = data.commonRefreshTime,
    goods = data.commonShop,
    coinCount = CloudData.PEACH
  }
  CloudData.SHOP_TOTAL_INFO[2] = {
    coinType = data.medalFinance,
    refreshTime = data.medalRefreshTime,
    refreshCost = data.medalRefreshCost,
    refreshTimes = data.medalRefreshTimes,
    goods = data.medalShop,
    coinCount = CloudData.FEAT,
    coinIcon = "item_icon/pic_feat.png"
  }
  CloudData.SHOP_TOTAL_INFO[3] = {
    coinType = data.purgatoryFinance,
    refreshTime = data.purgatoryRefreshTime,
    refreshCost = data.purgatoryRefreshCost,
    refreshTimes = data.purgatoryRefreshTimes,
    goods = data.purgatoryShop,
    coinCount = CloudData.LIANYUBI,
    coinIcon = "item_icon/pic_lianyubi.png"
  }
  CloudData.SHOP_TOTAL_INFO[4] = {
    coinType = data.mysteryFinance,
    refreshTime = data.mysteryRefreshTime,
    refreshCost = data.mysteryRefreshCost,
    refreshTimes = data.mysteryRefreshTimes,
    coinCount = CloudData.PEACH,
    goods = data.mysteryShop
  }
  self.mIsMysteryShopOpen = data.mysteryShow
end

function M:initUI()
  local bg = display.newSprite(M_filePath("bg")):addTo(self.mNode)
  self.mBg = bg
  display.newSprite(M_filePath("title")):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.89):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.94, self.mBg:getContentSize().height * 0.85):addTo(self.mBg, 2)
end

function M:initTabBtn()
  local tabFrame = display.newSprite(M_filePath("bg_small")):pos(self.mBg:getContentSize().width * 0.18, self.mBg:getContentSize().height * 0.47):addTo(self.mBg)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 10, 230, 450),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.onTouchTabBtn)):addTo(tabFrame)
  for i = 1, #M_TAB_IMG do
    local item = listView:newItem()
    local icon = display.newSprite(M_filePath("btn_normal"))
    display.newSprite(M_filePath(M_TAB_IMG[i]), 95, 35):addTo(icon)
    if self.mInitIdx == i then
      icon:setTexture(M_filePath("btn_pressed"))
      self.mCurrTab = icon
      self:layoutUI(self.mInitIdx)
    end
    table.insert(self.mTabBtns, icon)
    item:addContent(icon)
    item:setItemSize(230, 80)
    listView:addItem(item)
    if 1 == i and #CloudData.ACTIVITY_VIP_INFO > 0 then
      icon.redPoint = display.newSprite("common_ui/red_point.png", 20, 50):addTo(icon)
    end
    if 2 == i and 1 == CloudData.ACTIVITY_INVEST then
      icon.redPoint = display.newSprite("common_ui/red_point.png", 20, 50):addTo(icon)
    end
    if 6 == i and 1 == CloudData.MYSTERY_SHOP_NEW then
      icon.redPoint = display.newSprite("common_ui/red_point.png", 20, 50):addTo(icon)
    end
  end
  listView:reload()
end

function M:layoutUI(idx)
  if self.mCurrFrame then
    self.mCurrFrame:hide()
  end
  local tFunc = {
    [1] = function()
      self:loadVipGift()
    end,
    [2] = function()
      self:loadInvestGift()
    end,
    [3] = function()
      self:loadShopNormal()
    end,
    [4] = function()
      self:loadShopGongxun()
    end,
    [5] = function()
      self:loadShopLianyu()
    end,
    [6] = function()
      self:loadShopMystery()
    end
  }
  tFunc[idx]()
end

function M:loadVipGift()
  if self.mGiftFrame then
    self.mGiftFrame:show()
    self.mCurrFrame = self.mGiftFrame
    self:onSheetBtnClick(1)
    return
  end
  local frame = display.newSprite(M_filePath("bg_part")):pos(self.mBg:getContentSize().width * 0.61, self.mBg:getContentSize().height * 0.44):addTo(self.mBg)
  self.mGiftFrame = frame
  local btnImg = {
    {
      normal = M_filePath("btn_gift1"),
      disabled = M_filePath("btn_gift2")
    },
    {
      normal = M_filePath("btn_gift_week1"),
      disabled = M_filePath("btn_gift_week2")
    },
    {
      normal = M_filePath("btn_gift_rebate1"),
      disabled = M_filePath("btn_gift_rebate2")
    }
  }
  for i = 1, #btnImg do
    local btn = cc.ui.UIPushButton.new(btnImg[i]):onButtonClicked(function()
      self:onSheetBtnClick(i)
    end):align(display.CENTER_BOTTOM, 108 + 160 * (i - 1), frame:getContentSize().height):addTo(frame)
    table.insert(self.mSheetBtns, btn)
    if 1 == i then
      self.mCurrSheet = btn
      btn:setButtonEnabled(false)
      self:giftVipUI()
    end
  end
  self.mCurrFrame = frame
end

function M:loadInvestGift()
  if self.mInvestFrame then
    self.mInvestFrame:show()
    self.mInvestFrame.listView:reload()
    self.mCurrFrame = self.mInvestFrame
    return
  end
  local frame = display.newScale9Sprite(M_filePath("bg_part"), 0, 0, cc.size(621, 470), cc.rect(100, 100, 1, 1)):pos(self.mBg:getContentSize().width * 0.61, self.mBg:getContentSize().height * 0.47):addTo(self.mBg)
  self.mInvestFrame = frame
  frame.activeNum = 0
  local infoFrame = self:getInvestPanel()
  infoFrame:pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.83)
  infoFrame:addTo(frame)
  frame.investPanel = infoFrame
  self.mInvestFrame.listView = self:getInvestList()
  self.mInvestFrame.listView:addTo(frame)
  self.mCurrFrame = frame
end

function M:loadShopNormal()
  self.mShopType = M.SHOP_NORMAL
  if self.mShopFrame1 then
    self.mShopFrame1:show()
    self.mCurrFrame = self.mShopFrame1
    return
  end
  local shopData = CloudData.SHOP_TOTAL_INFO[M.SHOP_NORMAL]
  local frame = display.newSprite(M_filePath("bg_part")):pos(self.mBg:getContentSize().width * 0.61, self.mBg:getContentSize().height * 0.44):addTo(self.mBg)
  self.mShopFrame1 = frame
  display.newSprite("shop/normal_refresh.png"):pos(frame:getContentSize().width * 0.75, frame:getContentSize().height + 20):addTo(frame)
  self.mShopFrame1.listView = self:getShopItemList(shopData)
  self.mShopFrame1.listView:addTo(frame)
  self.mCurrFrame = frame
end

function M:loadShopGongxun()
  self.mShopType = M.SHOP_GONGXUN
  if self.mShopFrame2 then
    self.mShopFrame2:show()
    self.mCurrFrame = self.mShopFrame2
    return
  end
  local shopData = CloudData.SHOP_TOTAL_INFO[M.SHOP_GONGXUN]
  local frame = display.newSprite(M_filePath("bg_part")):pos(self.mBg:getContentSize().width * 0.61, self.mBg:getContentSize().height * 0.44):addTo(self.mBg)
  self.mShopFrame2 = frame
  local panel = self:getShopPanel(shopData)
  panel:setPosition(frame:getContentSize().width * 0.5, frame:getContentSize().height + 25)
  panel:addTo(frame)
  self.mShopFrame2.shopPanel = panel
  local refreshTime = self:getRefreshTimePanel(shopData.refreshTime)
  refreshTime:setPosition(255, -60)
  refreshTime:addTo(frame)
  self.mShopFrame2.timePanel = refreshTime
  self.mShopFrame2.listView = self:getShopItemList(shopData)
  self.mShopFrame2.listView:addTo(frame)
  self.mCurrFrame = frame
end

function M:loadShopLianyu()
  self.mShopType = M.SHOP_LIANYU
  if self.mShopFrame3 then
    self.mShopFrame3:show()
    self.mCurrFrame = self.mShopFrame3
    return
  end
  local shopData = CloudData.SHOP_TOTAL_INFO[M.SHOP_LIANYU]
  local frame = display.newSprite(M_filePath("bg_part")):pos(self.mBg:getContentSize().width * 0.61, self.mBg:getContentSize().height * 0.44):addTo(self.mBg)
  self.mShopFrame3 = frame
  local panel = self:getShopPanel(shopData)
  panel:setPosition(frame:getContentSize().width * 0.5, frame:getContentSize().height + 25)
  panel:addTo(frame)
  self.mShopFrame3.shopPanel = panel
  local refreshTime = self:getRefreshTimePanel(shopData.refreshTime)
  refreshTime:setPosition(255, -60)
  refreshTime:addTo(frame)
  self.mShopFrame3.timePanel = refreshTime
  self.mShopFrame3.listView = self:getShopItemList(shopData)
  self.mShopFrame3.listView:addTo(frame)
  self.mCurrFrame = frame
end

function M:loadShopMystery()
  self.mShopType = M.SHOP_MYSTERY
  if self.mCurrTab.redPoint then
    self.mCurrTab.redPoint:runAction(cc.RemoveSelf:create())
    self.mCurrTab.redPoint = nil
    CloudData.MYSTERY_SHOP_NEW = 2
  end
  if self.mShopFrame4 then
    self.mShopFrame4:show()
    self.mCurrFrame = self.mShopFrame4
    return
  end
  local shopData = CloudData.SHOP_TOTAL_INFO[M.SHOP_MYSTERY]
  local frame = display.newSprite(M_filePath("bg_part")):pos(self.mBg:getContentSize().width * 0.61, self.mBg:getContentSize().height * 0.44):addTo(self.mBg)
  self.mShopFrame4 = frame
  local panel = self:getShopPanel(shopData)
  panel:setPosition(frame:getContentSize().width * 0.5, frame:getContentSize().height + 25)
  panel:addTo(frame)
  self.mShopFrame4.shopPanel = panel
  local refreshTime = self:getRefreshTimePanel(shopData.refreshTime)
  refreshTime:setPosition(255, -60)
  refreshTime:addTo(frame)
  self.mShopFrame4.timePanel = refreshTime
  self.mShopFrame4.listView = self:getShopItemList(shopData)
  self.mShopFrame4.listView:addTo(frame)
  self.mCurrFrame = frame
end

function M:funcChange(index)
  if self.mTabTag == index then
    return
  end
  if 6 == index and self.mIsMysteryShopOpen ~= 1 then
    LayerVipShopClosed.new():addTo(self, 20)
    return
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  if self.mCurrTab == nil then
    DDTRACE("LayerShopNew:funcChange", string.format("index : %s", index))
    return
  end
  self.mCurrTab:setTexture(M_filePath("btn_normal"))
  self.mTabTag = index
  self.mCurrTab = self.mTabBtns[index]
  self.mCurrTab:setTexture(M_filePath("btn_pressed"))
  self:layoutUI(index)
end

function M:onSheetBtnClick(tag)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mCurrSheet:setButtonEnabled(true)
  if self.mCurrSheet.redPoint then
    self.mCurrSheet.redPoint:setPosition(51, 28)
  end
  self.mSheetTag = tag
  self.mCurrSheet = self.mSheetBtns[tag]
  self.mCurrSheet:setButtonEnabled(false)
  if self.mCurrSheet.redPoint then
    self.mCurrSheet.redPoint:setPosition(50, 35)
  end
  self.mGiftData = self.mModelTable[tag]
  if self.mCurrSheetFrame then
    self.mCurrSheetFrame:hide()
  end
  local tFunc = {
    [1] = function()
      self:giftVipUI()
    end,
    [2] = function()
      self:giftWeekUI()
    end,
    [3] = function()
      self:giftRebateUI()
    end
  }
  tFunc[tag]()
end

function M:giftVipUI()
  if self.mVipFrame then
    self.mVipFrame:show()
    self.mVipFrame.listView:reload()
    self.mCurrSheetFrame = self.mVipFrame
    return
  end
  local frame = display.newSprite(M_filePath("bg_part")):pos(self.mGiftFrame:getContentSize().width * 0.5, self.mGiftFrame:getContentSize().height * 0.5):addTo(self.mGiftFrame)
  self.mVipFrame = frame
  self.mCurrSheetFrame = frame
  frame.activeNum = 0
  local activityId = self.mGiftData.activeId
  local activityData = self.mActivityProArr[tostring(activityId)]
  local countNum = #self.mGiftData.taskIds
  
  local function sortTable(tb)
    local tb1 = {}
    local tb2 = {}
    for i = 1, #tb do
      local id = tb[i]
      local status = activityData[tostring(id)].isDraw
      if 0 < status then
        table.insert(tb1, id)
      else
        table.insert(tb2, id)
      end
    end
    table.insertto(tb2, tb1)
    return tb2
  end
  
  self.mGiftData.taskIds = sortTable(self.mGiftData.taskIds)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 5, 588, 415),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  for i = 1, countNum do
    local item = listView:newItem()
    local taskId = self.mGiftData.taskIds[i]
    local taskInfo = activityData[tostring(taskId)]
    local params = {taskId = taskId, taskInfo = taskInfo}
    local icon = IconActivityTask.new(params, handler(self, self.onEventActivityTask))
    local content = icon
    item:addContent(content)
    item:setItemSize(582, 150)
    listView:addItem(item)
    if icon.mIsActive then
      frame.activeNum = frame.activeNum + 1
    end
  end
  listView:reload()
  self.mVipFrame.listView = listView
  if frame.activeNum > 0 then
    self.mCurrSheet.redPoint = display.newSprite("common_ui/red_point.png", 50, 35):scale(0.7):addTo(self.mCurrSheet)
  end
end

function M:giftWeekUI()
  if self.mWeekFrame then
    self.mWeekFrame:show()
    self.mWeekFrame.listView:reload()
    self.mCurrSheetFrame = self.mWeekFrame
    return
  end
  local frame = display.newSprite(M_filePath("bg_part")):pos(self.mGiftFrame:getContentSize().width * 0.5, self.mGiftFrame:getContentSize().height * 0.5):addTo(self.mGiftFrame)
  self.mWeekFrame = frame
  self.mCurrSheetFrame = frame
  if self.mGiftData.closeTime > 0 then
    local frame1 = display.newSprite("activity/label4.png"):align(display.CENTER, 260, -60):addTo(frame)
    local textStr, isNeedCountdown = getTimeText(self.mGiftData.closeTime - self.mCountTime)
    self.mTimeLabel1 = DYLabelTTF.new({
      text = textStr,
      size = 21,
      color = cc.c3b(0, 255, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(frame1:getPositionX() + frame1:getContentSize().width * 0.5, frame1:getPositionY()):addTo(frame)
    if isNeedCountdown then
      self.mTimeLabel1.tag = M.TAG_TIME2
      self:startCountDown(self.mTimeLabel1, self.mGiftData.closeTime - self.mCountTime)
    end
  end
  local countNum = #self.mGiftData.taskIds
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 5, 588, 415),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  for i = 1, countNum do
    local item = listView:newItem()
    local activityId = self.mGiftData.activeId
    local taskId = self.mGiftData.taskIds[i]
    local taskInfo = self.mActivityProArr[tostring(activityId)][tostring(taskId)]
    local params = {taskId = taskId, taskInfo = taskInfo}
    local icon = IconActivityBuy.new(params, handler(self, self.onEventActivityBuy))
    local content = icon
    item:addContent(content)
    item:setItemSize(582, 150)
    listView:addItem(item)
  end
  listView:reload()
  self.mWeekFrame.listView = listView
end

function M:giftRebateUI()
  if self.mRebateFrame then
    self.mRebateFrame:show()
    self.mRebateFrame.listView:reload()
    self.mCurrSheetFrame = self.mRebateFrame
    return
  end
  local frame = display.newSprite(M_filePath("bg_part")):pos(self.mGiftFrame:getContentSize().width * 0.5, self.mGiftFrame:getContentSize().height * 0.5):addTo(self.mGiftFrame)
  self.mRebateFrame = frame
  self.mCurrSheetFrame = frame
  local countNum = #self.mGiftData.taskIds
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 5, 588, 415),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  for i = 1, countNum do
    local item = listView:newItem()
    local activityId = self.mGiftData.activeId
    local taskId = self.mGiftData.taskIds[i]
    local taskInfo = self.mActivityProArr[tostring(activityId)][tostring(taskId)]
    local params = {taskId = taskId, taskInfo = taskInfo}
    local icon = IconActivityBuy.new(params, handler(self, self.onEventActivityBuy))
    local content = icon
    item:addContent(content)
    item:setItemSize(582, 150)
    listView:addItem(item)
  end
  listView:reload()
  self.mRebateFrame.listView = listView
end

function M:getInvestPanel()
  local infoFrame = display.newSprite("activity/icon.png")
  local textStr = "\232\180\173\228\185\176\230\138\149\232\181\132\232\174\161\229\136\146\239\188\140\230\128\187\232\174\161\229\143\175\232\142\183\229\190\151"
  local lb1 = DYLabelTTF.new({
    text = textStr,
    size = 24,
    color = cc.c3b(73, 40, 4),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(20, 95):addTo(infoFrame)
  DYLabelTTF.new({
    text = self.mInvestInfo.peachGet .. "\232\159\160\230\161\131",
    size = 24,
    color = cc.c3b(255, 36, 36),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb1:getPositionX() + lb1:getContentSize().width, lb1:getPositionY()):addTo(infoFrame)
  local lb2 = DYLabelTTF.new({
    text = "\232\180\173\228\185\176\230\157\161\228\187\182\239\188\154",
    size = 24,
    color = cc.c3b(73, 40, 4),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb1:getPositionX(), 64):addTo(infoFrame)
  DYLabelTTF.new({
    text = "\229\136\176\232\190\190VIP" .. self.mInvestInfo.vip,
    size = 24,
    color = cc.c3b(255, 36, 36),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb2:getPositionX() + lb2:getContentSize().width, lb2:getPositionY()):addTo(infoFrame)
  infoFrame.btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = "\232\180\173  \228\185\176",
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {})):setButtonLabel("disabled", DYLabelTTF.new({
    text = "\229\183\178\232\180\173\228\185\176",
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  })):align(display.CENTER, infoFrame:getContentSize().width * 0.85, infoFrame:getContentSize().height * 0.65):onButtonClicked(function()
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
    local params = {
      type = 1,
      text = string.format("\231\161\174\232\174\164\232\138\177\232\180\185%d\232\159\160\230\161\131\230\191\128\230\180\187\230\138\149\232\181\132\232\174\161\229\136\146\229\144\151?", self.mInvestInfo.peach)
    }
    LayerCommon.new(params, handler(self, self.onEventActivateInvest)):addTo(self, 10)
  end):addTo(infoFrame)
  local pic = display.newSprite("item_icon/pic_peach.png", 470, 30):scale(0.65):addTo(infoFrame)
  DYLabelTTF.new({
    text = self.mInvestInfo.peach,
    size = 22,
    color = cc.c3b(44, 255, 9),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(pic:getPositionX() + pic:getContentSize().width * 0.34, pic:getPositionY()):addTo(infoFrame)
  if 1 == self.mInvestInfo.isBuy then
    self:performWithDelay(function()
      infoFrame.btn:setButtonEnabled(false)
    end, 0)
  end
  return infoFrame
end

function M:getInvestList()
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(20, 5, 582, 310),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  })
  for i = 1, #self.mInvestData do
    local item = listView:newItem()
    local data = self.mInvestData[i]
    data.isBuy = self.mInvestInfo.isBuy
    local content = IconInvest.new(data, handler(self, self.onEventInvestAward))
    item:addContent(content)
    item:setItemSize(582, 142)
    listView:addItem(item)
    if content.mIsActive then
      if not self.mCurrTab.redPoint then
        self.mCurrTab.redPoint = display.newSprite("common_ui/red_point.png", 20, 50):addTo(self.mCurrTab)
      end
      self.mInvestFrame.activeNum = self.mInvestFrame.activeNum + 1
    end
  end
  listView:reload()
  return listView
end

function M:getShopItemList(data)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(10, 5, 600, 415),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  })
  local count = 0
  for k, v in pairs(data.goods) do
    count = count + 1
  end
  local row = math.ceil(count / 3)
  for i = 1, row do
    local item = listView:newItem()
    local content = display.newNode()
    content:setAnchorPoint(0.5, 0.5)
    content:setContentSize(600, 282)
    local column = 3
    if i == row then
      column = count - (row - 1) * 3
    end
    for idx = 1, column do
      local index = (i - 1) * 3 + idx
      local params = {
        id = index,
        tag = self.mShopType,
        info = data.goods[tostring(index)],
        func = handler(self, self.onEventBuyItem)
      }
      local icon = IconShop.new(params)
      icon:setPosition(content:getContentSize().width * (idx - 0.5) / 3, content:getContentSize().height * 0.5)
      content:addChild(icon)
    end
    item:addContent(content)
    item:setItemSize(600, 282)
    listView:addItem(item)
  end
  listView:reload()
  return listView
end

function M:getShopPanel(data)
  local coinNum = data.coinCount
  local coinPic = DataUtils.getCoinPic(data.coinType)
  local pNode = display.newNode()
  pNode:setAnchorPoint(0.5, 0.5)
  pNode:setContentSize(620, 40)
  local lb = DYLabelTTF.new({
    text = "\229\137\169\228\189\153\229\136\183\230\150\176\230\172\161\230\149\176\239\188\154",
    size = 22,
    color = cc.c3b(11, 253, 32),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(240, 20):addTo(pNode)
  pNode.timesLabel = DYLabelTTF.new({
    text = data.refreshTimes,
    size = 22,
    color = cc.c3b(11, 253, 32),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(lb:getPositionX() + lb:getContentSize().width, lb:getPositionY()):addTo(pNode)
  pNode.btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
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
  })):setButtonLabelOffset(-20, 3):onButtonClicked(function()
    self:onEventRefreshShop()
  end):align(display.CENTER, 535, 28):addTo(pNode)
  local costSP = display.newSprite(coinPic, 15, 3):scale(0.72):addTo(pNode.btn)
  local costLabel = DYLabelTTF.new({
    text = data.refreshCost,
    size = 22,
    color = cc.c3b(11, 253, 32),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(35, 3):addTo(pNode.btn)
  if M.SHOP_GONGXUN == self.mShopType or M.SHOP_LIANYU == self.mShopType then
    local condition = M_SHOP_CONDITION[self.mShopType]
    local numFrame = display.newScale9Sprite("common_ui/num_bg.png", 0, 0, cc.size(140, 34), cc.rect(50, 0, 34, 0)):pos(110, 20):addTo(pNode)
    display.newSprite(data.coinIcon):scale(0.72):pos(numFrame:getContentSize().width * 0.05, numFrame:getContentSize().height * 0.5):addTo(numFrame)
    pNode.coinNumLabel = DYLabelTTF.new({
      text = coinNum,
      size = 22,
      color = cc.c3b(11, 253, 32),
      font = GameManager.FONTNAME_TTF
    }, {}):pos(numFrame:getContentSize().width * 0.5, numFrame:getContentSize().height * 0.5):addTo(numFrame)
    cc.ui.UIPushButton.new({
      normal = "common_ui/add.png",
      pressed = "common_ui/add1.png"
    }):pos(numFrame:getContentSize().width, numFrame:getContentSize().height * 0.5):addTo(numFrame):onButtonClicked(function()
      if tonumber(CloudData.USER_LEVEL) >= condition.level then
        display.replaceScene(require(condition.scene).new())
      else
        WSToast.new(DYLang.getString("S1386", "") .. condition.level .. DYLang.getString("S1387", "")):addTo(self, 20)
      end
    end)
  end
  if M.SHOP_MYSTERY == self.mShopType then
    display.newSprite("shop/tip.png", 100, 45):addTo(pNode)
  end
  
  function pNode:updateRefreshCost(pData)
    local coinPic = DataUtils.getCoinPic(pData.coinType)
    costSP:setTexture(coinPic)
    costLabel:setString(pData.refreshCost)
  end
  
  return pNode
end

function M:getRefreshTimePanel(time)
  local lb = display.newSprite("shop/refresh.png")
  local textStr = string.format("%02d:%02d:%02d", M_parseTime(time))
  local timeLabel = DYLabelTTF.new({
    text = textStr,
    size = 24,
    color = cc.c3b(96, 255, 1),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(lb:getContentSize().width + 5, lb:getContentSize().height * 0.5):addTo(lb)
  timeLabel.tag = M.TAG_TIME1
  self:startCountDown(timeLabel, time)
  return lb
end

function M:updateUI(data)
  local shopData = CloudData.SHOP_TOTAL_INFO[self.mShopType]
  self.mCurrFrame.listView:runAction(cc.RemoveSelf:create())
  self.mCurrFrame.listView = self:getShopItemList(shopData)
  self.mCurrFrame.listView:addTo(self.mCurrFrame)
  self.mCurrFrame.shopPanel.timesLabel:setString(shopData.refreshTimes)
  self.mCurrFrame.shopPanel:updateRefreshCost(shopData)
  if self.mCurrFrame.shopPanel.coinNumLabel then
    self.mCurrFrame.shopPanel.coinNumLabel:setString(shopData.coinCount)
  end
end

function M:layerTransition(type_)
  local tFunc = {
    [1] = function()
      require("app.layers.LayerRecharge").new():addTo(self, 20)
    end,
    [2] = function()
      display.replaceScene(require("app.scenes.SceneStage").new())
    end,
    [3] = function()
      require("app.layers.LayerRecharge").new():addTo(self, 20)
    end,
    [4] = function()
      display.replaceScene(require("app.scenes.UpgradeScene").new())
    end,
    [5] = function()
      if not GameManager.IS_CHAT_LOGIN_OK then
        WSToast.new("PVP\229\136\157\229\167\139\229\140\150\230\156\170\229\174\140\230\136\144"):addTo(self, 100)
      else
        require("app.layers.LayerPVPEntrance").new():addTo(self, 20)
      end
    end,
    [6] = function()
      require("app.layers.LayerSign").new():addTo(self, 20)
    end,
    [7] = function()
      if CloudData.USER_LEVEL >= Const.FUNC_UNLOCK.summon then
        display.replaceScene(require("app.scenes.SceneSummon").new())
      else
        local str = DYLang.getString("S474", "") .. Const.FUNC_UNLOCK.summon .. DYLang.getString("S475", "")
        WSToast.new(str):addTo(self, 50)
      end
    end,
    [8] = function()
      require("app.layers.LayerDungeon").new():addTo(self, 20)
    end,
    [9] = function()
      if CloudData.USER_LEVEL >= Const.FUNC_UNLOCK.cimelia then
        display.replaceScene(require("app.cimelia.scenes.SceneCimelia").new())
      else
        local str = DYLang.getString("S474", "") .. Const.FUNC_UNLOCK.cimelia .. DYLang.getString("S475", "")
        WSToast.new(str):addTo(self, 50)
      end
    end
  }
  return tFunc[type_]()
end

function M:onEventActivateInvest()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    CloudData.PEACH = jsonTable.data.peachLeft
    self.mInvestInfo.isBuy = 1
    CloudData.ACTIVITY_INVEST = 1
    self.mCurrFrame.investPanel.btn:setButtonEnabled(false)
    self.mCurrFrame.listView:runAction(cc.RemoveSelf:create())
    self.mCurrFrame.listView = self:getInvestList()
    self.mCurrFrame.listView:addTo(self.mCurrFrame)
    return
  end
  
  local param = {level = -1}
  DYHttpMgr.investAward(tFuncListener, param)
end

function M:onEventInvestAward(params)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    CloudData.PEACH = jsonTable.data.peachLeft
    params.btn:setButtonEnabled(false)
    self.mInvestFrame.activeNum = self.mInvestFrame.activeNum - 1
    if 0 == self.mInvestFrame.activeNum and self.mCurrTab.redPoint ~= nil then
      self.mCurrTab.redPoint:runAction(cc.RemoveSelf:create())
      self.mCurrTab.redPoint = nil
      CloudData.ACTIVITY_INVEST = 0
    end
    local str = "\232\159\160\230\161\131X" .. jsonTable.data.peachGain
    WSToast.new(str):addTo(self, 20)
    return
  end
  
  local param = {
    level = params.level
  }
  DYHttpMgr.investAward(tFuncListener, param)
end

function M:onEventRefreshShop()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  
  local function tFuncListener(response)
    if response.errorCode ~= 0 then
      local toast = WSToast.new(response.errorMsg, 2):addTo(self, 20)
      return
    end
    local refreshData = response.data
    CloudData.SHOP_TOTAL_INFO[self.mShopType].goods = refreshData.shopList
    CloudData.SHOP_TOTAL_INFO[self.mShopType].coinType = tonumber(refreshData.finance)
    CloudData.SHOP_TOTAL_INFO[self.mShopType].refreshCost = tonumber(refreshData.leftFinance)
    CloudData.SHOP_TOTAL_INFO[self.mShopType].refreshTimes = tonumber(refreshData.refreshTimes)
    local coinType = checknumber(refreshData.refreshFinance)
    local num = checknumber(refreshData.refreshLeftFinance)
    DataUtils.updateItemNum(coinType, num)
    local numList = {
      CloudData.PEACH,
      CloudData.FEAT,
      CloudData.LIANYUBI,
      CloudData.PEACH
    }
    CloudData.SHOP_TOTAL_INFO[self.mShopType].coinCount = numList[self.mShopType]
    self:updateUI({
      coinNum = refreshData.refreshLeftFinance
    })
  end
  
  local tFunc = {
    [2] = function()
      DYHttpMgr.featShopRefresh(tFuncListener)
    end,
    [3] = function()
      DYHttpMgr.purgatoryShopRefresh(tFuncListener)
    end,
    [4] = function()
      DYHttpMgr.mysteryShopRefresh(tFuncListener)
    end
  }
  tFunc[self.mShopType]()
end

function M:onEventBuyItem()
  local numList = {
    CloudData.PEACH,
    CloudData.FEAT,
    CloudData.LIANYUBI,
    CloudData.PEACH
  }
  local coinNum = numList[self.mShopType]
  if not self.mCurrFrame.shopPanel then
    return
  end
  if self.mCurrFrame.shopPanel.coinNumLabel then
    self.mCurrFrame.shopPanel.coinNumLabel:setString(coinNum)
  end
end

function M:onEventActivityTask(params)
  if params.loadTo > 0 then
    self:layerTransition(params.loadTo)
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
    local activityId = tostring(self.mGiftData.activeId)
    local taskId = tostring(params.taskId)
    self.mActivityProArr[activityId][taskId].isDraw = 1
    params.tar:setButtonEnabled(false)
    self.mCurrSheetFrame.activeNum = self.mCurrSheetFrame.activeNum - 1
    if 0 == self.mCurrSheetFrame.activeNum then
      if self.mCurrSheet.redPoint then
        self.mCurrSheet.redPoint:runAction(cc.RemoveSelf:create())
        self.mCurrSheet.redPoint = nil
      end
      if self.mCurrTab.redPoint then
        self.mCurrTab.redPoint:runAction(cc.RemoveSelf:create())
        self.mCurrTab.redPoint = nil
      end
      CloudData.ACTIVITY_VIP_INFO = {}
    end
    local text = DYLang.getString("S24", "")
    for k, v in pairs(jsonTable.data.drop) do
      DataUtils.updateItemNum(k, v)
      local itemModel = DataUtils.getItemModel(k)
      local itemName = itemModel.itemName
      local itemNum = jsonTable.data.dropGain[k]
      text = text .. itemName .. "X" .. itemNum .. "  "
      DYAnalyze.item.get(k, "", itemNum, "Activity_reward")
    end
    WSToast.new(text):addTo(self, 20)
  end
  
  local param = {}
  param.activityId = self.mGiftData.activeId
  param.taskId = params.taskId
  DYHttpMgr.getTaskActivityAward(tFuncListener, param)
end

function M:onEventActivityBuy(params)
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
    local buyTimes = jsonTable.data.buyTimes
    local limitTimes = jsonTable.data.limitTimes
    DataUtils.updateItemNum(tostring(params.thingId), jsonTable.data.thingLeft)
    local activityId = tostring(self.mGiftData.activeId)
    local taskId = tostring(params.taskId)
    self.mActivityProArr[activityId][taskId].isDraw = buyTimes
    if buyTimes >= limitTimes or jsonTable.data.thingLeft < params.thingNum then
      params.tar:setButtonEnabled(false)
    end
    params.text:setString(string.format("%d/%d", limitTimes - buyTimes, limitTimes))
    local text = DYLang.getString("S24", "")
    for k, v in pairs(jsonTable.data.drop) do
      DataUtils.updateItemNum(k, v)
      local itemModel = DataUtils.getItemModel(k)
      local itemName = itemModel.itemName
      local itemNum = jsonTable.data.dropGain[k]
      text = text .. itemName .. "X" .. itemNum .. "  "
      DYAnalyze.item.get(k, "", itemNum, "Activity_buy")
    end
    WSToast.new(text):addTo(self, 20)
  end
  
  local param = {}
  param.activityId = self.mGiftData.activeId
  param.taskId = params.taskId
  DYHttpMgr.getBuyActivityAward(tFuncListener, param)
end

function M:updateCountTime()
  self.mCountTime = self.mCountTime + 1
end

function M:startCountDown(node, time)
  if time <= 0 then
    node.schedule = false
    self:countdownOver(node)
    return
  end
  node.hour, node.mins, node.secs = M_parseTime(time)
  node.schedule = self:schedule(function()
    self:updateTime(node)
  end, 1)
end

function M:updateTime(node)
  local function updateLabel()
    local timeStr
    
    if M.TAG_TIME1 == node.tag then
      timeStr = string.format("%02d:%02d:%02d", node.hour, node.mins, node.secs)
    else
      timeStr = string.format("%d\229\136\134%d\231\167\146", node.mins, node.secs)
    end
    node:setString(timeStr)
  end
  
  if node.secs > 0 then
    node.secs = node.secs - 1
  elseif 0 < node.mins then
    node.secs = 59
    node.mins = node.mins - 1
  elseif 0 < node.hour then
    node.secs, node.mins = 59, 59
    node.hour = node.hour - 1
  else
    self:countdownOver(node)
  end
  updateLabel()
end

function M:countdownOver(node)
  if node.schedule then
    self:stopAction(node.schedule)
  end
end

function M:onTouchTabBtn(event)
  local lv = event.listView
  if "clicked" == event.name then
    local idx = event.itemPos
    self:funcChange(idx)
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
  self:runAction(cc.RemoveSelf:create())
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
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

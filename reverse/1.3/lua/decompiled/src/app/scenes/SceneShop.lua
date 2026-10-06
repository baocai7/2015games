local IconShop = require("app.icons.IconShop")
local DataLabelIcon = require("app.icons.DataLabelIcon")
local LayerVipShopClosed = require("app.layers.LayerVipShopClosed")
local IconPkBubble = require("app.icons.IconPkBubble")
local CLASS_NAME = "SceneShop"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene(CLASS_NAME)
end)
M.NORMAL = 1
M.FEAT = 2
M.PURGATORY = 3
M.MYSTERY = 4

function M:ctor(mType)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  if not audio.isMusicPlaying() then
    DYSoundMgr.playMusic(DY_SND.bgm_theme)
  end
  DYSoundMgr.playEffect(DY_SND.sfx_shop_open)
  self.mBg = nil
  self.mType = mType or M.NORMAL
  if self.mType < 1 or self.mType > 4 then
    self.mType = M.NORMAL
  end
  self.mListview = nil
  self.mTimeTag = 0
  self.mHours = 0
  self.mMinutes = 0
  self.mSeconds = 0
  self.mTimeLabel = nil
  self.refreshBtn = nil
  self.refreshNumLab = nil
  self.mCoinIcon = nil
  self.mCostLabel = nil
  self.mRefreshTip = nil
  self.mShowMystery = 1
  self.mTabs = {}
  self.mTopTip = nil
  self.mDataLoaded = false
  self.mNormalefreshImg = nil
  self:initBg()
  self:initPkBubble()
  self:requestData()
end

function M:initBg()
  local bg = display.newSprite("common_ui/common_bg.png", display.cx, display.cy):addTo(self)
  self.mBg = display.newSprite("shop/bg.png", bg:getContentSize().width * 0.5 - 70, bg:getContentSize().height * 0.5 - 30):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):align(display.CENTER, display.width * 0.05, display.height * 0.95):onButtonClicked(function()
    self:returnCallBack()
  end):addTo(self, 15)
  local essenceLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ESSENCE, true)
  essenceLabel:setPosition(display.width * 0.3, display.height * 0.95)
  self:addChild(essenceLabel, 15)
  local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH, true)
  peachLabel:setPosition(cc.p(display.width * 0.7, display.height * 0.95))
  self:addChild(peachLabel, 15)
  local tabInfo = {
    "tag_normal",
    "tag_feat",
    "tag_purgatory",
    "tag_mystery"
  }
  for i = 1, #tabInfo do
    self.mTabs[i] = cc.ui.UIPushButton.new({
      normal = "shop/" .. tabInfo[i] .. ".png",
      disabled = "shop/" .. tabInfo[i] .. "1.png"
    }):onButtonClicked(function()
      DYSoundMgr.playEffect(DY_SND.sfx_touch)
      self:changeTab(i)
    end):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.915, self.mBg:getContentSize().height * 0.7 + 60 - i * 95):addTo(self.mBg)
  end
  self.mTabs[M.MYSTERY]:setVisible(false)
  self.mTabs[M.MYSTERY].newMark = display.newSprite("common_ui/red_point.png"):hide():pos(134, 22):addTo(self.mTabs[M.MYSTERY], 1)
  self.mNormalefreshImg = display.newSprite("shop/normal_refresh.png"):align(display.CENTER_RIGHT, self.mBg:getContentSize().width * 0.9, self.mBg:getContentSize().height * 0.77):addTo(self.mBg)
  self.mNormalefreshImg:setVisible(false)
  self.mRefreshTip = display.newSprite("shop/refresh.png"):scale(0.9):align(display.CENTER_RIGHT, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.77):addTo(self.mBg)
  self.mRefreshTip:setVisible(false)
  self.mTimeLabel = cc.ui.UILabel.new({
    text = "",
    size = 22,
    color = cc.c3b(96, 255, 1),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.5 + 10, self.mBg:getContentSize().height * 0.77):addTo(self.mBg)
  self.mTimeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  self.mTimeLabel:setVisible(false)
  local textLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S1179", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  textLabel:enableOutline(cc.c4b(147, 78, 1, 255), 2)
  local textDisabled = cc.ui.UILabel.new({
    text = DYLang.getString("S1179", ""),
    size = 25,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  })
  textDisabled:enableOutline(cc.c4b(40, 40, 40, 255), 2)
  self.refreshBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }):scale(0.9):align(display.CENTER, self.mBg:getContentSize().width * 0.83, self.mBg:getContentSize().height * 0.78):addTo(self.mBg, 2):setButtonLabel("normal", textLabel):setButtonLabel("disabled", textDisabled):onButtonClicked(function()
    self:clickRefresh()
  end)
  self.refreshBtn:setVisible(false)
  self.refreshNumLab = cc.ui.UILabel.new({
    text = "",
    size = 25,
    color = cc.c3b(11, 253, 32),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 10, 0):addTo(self.refreshBtn)
  self.refreshNumLab:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local costBg = display.newScale9Sprite("common_ui/num_bg.png", 0, 0, cc.size(120, 34), cc.rect(50, 0, 34, 0)):align(display.CENTER_RIGHT, -100, -5):addTo(self.refreshBtn)
  costBg:setTouchEnabled(true)
  self.mCoinIcon = display.newSprite():scale(0.8):pos(costBg:getContentSize().width * 0.05, costBg:getContentSize().height * 0.5):addTo(costBg)
  self.mCostLabel = cc.ui.UILabel.new({
    text = "",
    size = 26,
    color = cc.c3b(11, 253, 32),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, costBg:getContentSize().width * 0.52, costBg:getContentSize().height * 0.5):addTo(costBg)
  self.mCostLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new()
  self:add(self.mPkBubble, 900)
end

function M:requestData()
  self.mDataLoaded = false
  
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local msg = info.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      self.mDataLoaded = true
      if not self.initData or not self.startCountDown then
        return
      end
      self:initData(info.data)
      self:startCountDown()
    end
  end
  
  local countCE = DataUtils.getUserCountCE()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&power=%s&token=%s&uid=%s", strAppSecret .. "", countCE .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.sign = crypto.md5(strSign, false)
  params.power = countCE
  DYHttpMgr.shopInit(tFuncListener, params)
end

function M:initData(info)
  CloudData.SHOP_TOTAL_INFO = {}
  CloudData.SHOP_TOTAL_INFO[M.NORMAL] = {}
  CloudData.SHOP_TOTAL_INFO[M.NORMAL].goods = info.commonShop
  CloudData.SHOP_TOTAL_INFO[M.NORMAL].refreshTime = tonumber(info.commonRefreshTime)
  CloudData.SHOP_TOTAL_INFO[M.FEAT] = {}
  CloudData.SHOP_TOTAL_INFO[M.FEAT].goods = info.medalShop
  CloudData.SHOP_TOTAL_INFO[M.FEAT].coinType = tonumber(info.medalFinance)
  CloudData.SHOP_TOTAL_INFO[M.FEAT].refreshCost = tonumber(info.medalRefreshCost)
  CloudData.SHOP_TOTAL_INFO[M.FEAT].refreshTimes = tonumber(info.medalRefreshTimes)
  CloudData.SHOP_TOTAL_INFO[M.FEAT].refreshTime = tonumber(info.medalRefreshTime)
  CloudData.SHOP_TOTAL_INFO[M.PURGATORY] = {}
  CloudData.SHOP_TOTAL_INFO[M.PURGATORY].goods = info.purgatoryShop
  CloudData.SHOP_TOTAL_INFO[M.PURGATORY].coinType = tonumber(info.purgatoryFinance)
  CloudData.SHOP_TOTAL_INFO[M.PURGATORY].refreshCost = tonumber(info.purgatoryRefreshCost)
  CloudData.SHOP_TOTAL_INFO[M.PURGATORY].refreshTimes = tonumber(info.purgatoryRefreshTimes)
  CloudData.SHOP_TOTAL_INFO[M.PURGATORY].refreshTime = tonumber(info.purgatoryRefreshTime)
  CloudData.GINSEN_BUY_TIME = tonumber(info.ginsenBuyCount) or 0
  CloudData.SHOP_TOTAL_INFO[M.MYSTERY] = {}
  self.mShowMystery = tonumber(info.mysteryShow)
  self.mTabs[M.MYSTERY]:setVisible(true)
  if self.mShowMystery == 1 then
    CloudData.SHOP_TOTAL_INFO[M.MYSTERY].goods = info.mysteryShop
    CloudData.SHOP_TOTAL_INFO[M.MYSTERY].coinType = tonumber(info.mysteryFinance)
    CloudData.SHOP_TOTAL_INFO[M.MYSTERY].refreshCost = tonumber(info.mysteryRefreshCost)
    CloudData.SHOP_TOTAL_INFO[M.MYSTERY].refreshTimes = tonumber(info.mysteryRefreshTimes)
    CloudData.SHOP_TOTAL_INFO[M.MYSTERY].refreshTime = tonumber(info.mysteryRefreshTime)
    if CloudData.MYSTERY_SHOP_NEW == 1 then
      self.mTabs[M.MYSTERY].newMark:show()
    end
  else
    self.mTabs[M.MYSTERY]:setButtonImage("normal", "shop/tag_mystery_gray.png")
    self.mTabs[M.MYSTERY]:setButtonImage("pressed", "shop/tag_mystery_gray.png")
    if self.mType == M.MYSTERY then
      self.mType = M.NORMAL
      WSToast.new(DYLang.getString("S1379", "")):addTo(self, 50)
    end
  end
  self:changeTab(self.mType)
end

function M:refreshList()
  if CloudData.SHOP_TOTAL_INFO == nil or CloudData.SHOP_TOTAL_INFO[self.mType] == nil then
    return
  end
  local sum = 0
  for k, v in pairs(CloudData.SHOP_TOTAL_INFO[self.mType].goods) do
    sum = sum + 1
  end
  if self.mListview then
    self.mListview:runAction(cc.RemoveSelf:create())
    self.mListview = nil
  end
  self.mListview = cc.ui.UIListView.new({
    viewRect = cc.rect(215, 102, 765, 389),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  local row = math.ceil(sum / 4)
  for i = 1, row do
    local item = self.mListview:newItem()
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
        tag = self.mType,
        info = CloudData.SHOP_TOTAL_INFO[self.mType].goods[tostring(index)],
        func = handler(self, self.showTopTip)
      }
      local icon = IconShop.new(params)
      icon:setPosition(content:getContentSize().width * (0.25 * count - 0.125), content:getContentSize().height * 0.5)
      content:addChild(icon)
    end
    item:addContent(content)
    item:setItemSize(765, 282)
    self.mListview:addItem(item)
  end
  self.mListview:reload()
end

function M:switchTimeLabel(time)
  self.mHours = math.floor(time / 3600)
  time = time % 3600
  self.mMinutes = math.floor(time / 60)
  self.mSeconds = math.floor(time % 60)
  self.mTimeLabel:setString(string.format("%02d:%02d:%02d", self.mHours, self.mMinutes, self.mSeconds))
  if self.mType == M.NORMAL then
    self.mRefreshTip:setVisible(false)
    self.mTimeLabel:setVisible(false)
    self.refreshBtn:setVisible(false)
    self.mNormalefreshImg:setVisible(true)
  else
    self.mRefreshTip:setVisible(true)
    self.mTimeLabel:setVisible(true)
    self.refreshBtn:setVisible(true)
    self.mNormalefreshImg:setVisible(false)
    self:refreshTimeControls()
  end
end

function M:refreshTimeControls()
  local coinType = CloudData.SHOP_TOTAL_INFO[self.mType].coinType
  local cost = CloudData.SHOP_TOTAL_INFO[self.mType].refreshCost
  local num = CloudData.SHOP_TOTAL_INFO[self.mType].refreshTimes
  local pic = DataUtils.getCoinPic(coinType)
  self.mCoinIcon:setTexture(pic)
  self.mCostLabel:setString(cost)
  self.refreshNumLab:setString("(" .. num .. ")")
  if num <= 0 then
    self.refreshBtn:setButtonEnabled(false)
    self.refreshNumLab:setColor(cc.c3b(255, 255, 255))
  else
    self.refreshBtn:setButtonEnabled(true)
  end
end

function M:clickRefresh()
  if not self.mDataLoaded then
    return
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  
  local function tFuncListener(response)
    if response.errorCode ~= 0 then
      local toast = WSToast.new(response.errorMsg, 2)
      self:addChild(toast, 20)
    elseif self.refreshSuccessed then
      self:refreshSuccessed(response.data)
    end
  end
  
  if self.mType == M.FEAT then
    DYHttpMgr.featShopRefresh(tFuncListener)
  elseif self.mType == M.PURGATORY then
    DYHttpMgr.purgatoryShopRefresh(tFuncListener)
  elseif self.mType == M.MYSTERY and self.mShowMystery == 1 then
    DYHttpMgr.mysteryShopRefresh(tFuncListener)
  end
end

function M:refreshSuccessed(info)
  CloudData.SHOP_TOTAL_INFO[self.mType].goods = info.shopList
  CloudData.SHOP_TOTAL_INFO[self.mType].coinType = tonumber(info.finance)
  CloudData.SHOP_TOTAL_INFO[self.mType].refreshCost = tonumber(info.leftFinance)
  CloudData.SHOP_TOTAL_INFO[self.mType].refreshTimes = tonumber(info.refreshTimes)
  self:refreshTimeControls()
  self:refreshList()
  local coinType = checknumber(info.refreshFinance)
  local num = checknumber(info.refreshLeftFinance)
  DataUtils.updateItemNum(coinType, num)
  self:showTopTip()
end

function M:changeTab(tag)
  if not self.mDataLoaded then
    return
  end
  local info = {
    {
      id = "click_normal_shop",
      lab = DYLang.getString("S1380", "")
    },
    {
      id = "click_feat_shop",
      lab = DYLang.getString("S1381", "")
    },
    {
      id = "click_purgatory_shop",
      lab = DYLang.getString("S1382", "")
    },
    {
      id = "click_mystery_shop",
      lab = DYLang.getString("S1383", "")
    }
  }
  if tag == M.NORMAL or info[tag] then
  end
  if tag == M.MYSTERY then
    CloudData.MYSTERY_SHOP_NEW = 2
    self.mTabs[M.MYSTERY].newMark:hide()
    if self.mShowMystery ~= 1 then
      LayerVipShopClosed.new():addTo(self, 20)
      return
    end
  end
  self.mType = tag
  for i = 1, #self.mTabs do
    self.mTabs[i]:setButtonEnabled(true)
  end
  self.mTabs[self.mType]:setButtonEnabled(false)
  self:refreshList()
  local time = checknumber(CloudData.SHOP_TOTAL_INFO[self.mType].refreshTime) - self.mTimeTag
  if time < 0 then
    time = 0
  end
  self:switchTimeLabel(time)
  self:showTopTip()
end

function M:showTopTip()
  if self.mTopTip then
    self.mTopTip:removeSelf()
    self.mTopTip = nil
  end
  if self.mType == M.FEAT or self.mType == M.PURGATORY then
    local info = {
      {
        img = "item_icon/pic_feat.png",
        num = CloudData.FEAT,
        scene = "scenes.ScenePVP",
        level = Const.FUNC_UNLOCK.pvp
      },
      {
        img = "item_icon/pic_lianyubi.png",
        num = CloudData.LIANYUBI,
        scene = "scenes.ScenePurgatory",
        level = Const.FUNC_UNLOCK.purgatory
      }
    }
    self.mTopTip = display.newScale9Sprite("common_ui/num_bg.png", 0, 0, cc.size(150, 34), cc.rect(50, 0, 34, 0)):pos(self.mBg:getContentSize().width * 0.29, self.mBg:getContentSize().height * 0.77):addTo(self.mBg)
    display.newSprite(info[self.mType - 1].img):scale(0.72):pos(self.mTopTip:getContentSize().width * 0.05, self.mTopTip:getContentSize().height * 0.5):addTo(self.mTopTip)
    local num = info[self.mType - 1].num
    if 100000 <= num then
      local count = math.floor(num / 10000)
      num = count .. DYLang.getString("S42", "")
    end
    local numLabel = cc.ui.UILabel.new({
      text = num,
      size = 22,
      color = cc.c3b(11, 253, 32),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, self.mTopTip:getContentSize().width * 0.52, self.mTopTip:getContentSize().height * 0.5):addTo(self.mTopTip)
    numLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    cc.ui.UIPushButton.new({
      normal = "common_ui/add.png",
      pressed = "common_ui/add1.png"
    }):pos(self.mTopTip:getContentSize().width, self.mTopTip:getContentSize().height * 0.5):addTo(self.mTopTip):onButtonClicked(function()
      if tonumber(CloudData.USER_LEVEL) >= info[self.mType - 1].level then
        display.replaceScene(require(info[self.mType - 1].scene).new())
      else
        WSToast.new(DYLang.getString("S1386", "") .. info[self.mType - 1].level .. DYLang.getString("S1387", "")):addTo(self, 20)
      end
    end)
  elseif self.mType == M.MYSTERY then
    self.mTopTip = display.newSprite("shop/tip.png"):pos(self.mBg:getContentSize().width * 0.28, self.mBg:getContentSize().height * 0.82):addTo(self.mBg)
  end
end

function M:startCountDown()
  self.schedule = self:schedule(function()
    self:updateSecond()
  end, 1)
end

function M:updateSecond()
  self.mTimeTag = self.mTimeTag + 1
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
    return
  end
  self.mTimeLabel:setString(string.format("%02d:%02d:%02d", self.mHours, self.mMinutes, self.mSeconds))
end

function M:countdownOver()
  self:stopAction(self.schedule)
end

function M:returnCallBack()
  CloudData.SHOP_TOTAL_INFO = {}
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local nextScene = require("scenes.ChapterScene").new()
  display.replaceScene(nextScene, "fade", 0.2)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:returnCallBack()
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

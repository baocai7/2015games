local WSToast = require("app.utils.WSToast")
local PackageIcon = require("app.icons.PackageIcon")
local FeedExpTable = require("app.profiles.union_boss_feed")
local LayerFeedRecord = require("app.union.layers.LayerUnionBossRecord")
local M = {}
M = class("LayerUnionBossFeed", function()
  return display.newLayer()
end)
M.BUDDHA_PIECE = 1
M.ITEM_PIECE = 2

function M:ctor(Boss, cb)
  self.mBossId = Boss.bossid
  if Boss.ExpCur > Boss.ExpMax then
    Boss.ExpCur = Boss.ExpMax
  end
  self.mBossInitExp = Boss.ExpCur
  self.mBossCurExp = Boss.ExpCur
  self.mBossMaxExp = Boss.ExpMax
  self.mBossFinalExp = self.mBossCurExp
  self.mBossFeedRecord = Boss.Feed_Record
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mModeType = M.BUDDHA_PIECE
  self.mNode = display.newNode():pos(display.cx, display.cy)
  self:addChild(self.mNode)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self:initUI()
  self:initItemData()
  self.mCb = cb
  self.mCanClick = true
end

local function createProgress(currNum, maxxNum)
  local node = display.newNode()
  local barBg = display.newSprite("stage/exp_progress_bg.png"):addTo(node)
  node.mPieceNumLabel = DYLabelTTF.new({
    UILabelType = 2,
    text = string.format("%d/%d", currNum, maxxNum),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  node.mProgressTimer = cc.ProgressTimer:create(display.newSprite("stage/exp_progress_bar.png")):addTo(barBg)
  node.mProgressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  node.mProgressTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  node.mProgressTimer:setMidpoint(cc.p(0, 0))
  node.mProgressTimer:setBarChangeRate(cc.p(1, 0))
  node.mProgressTimer:setPercentage(currNum / maxxNum * 100)
  
  function node:refresh(num1, num2)
    node.mProgressTimer:setPercentage(num1 / num2 * 100)
    node.mPieceNumLabel:setString(string.format("%d/%d", num1, num2))
  end
  
  return node
end

function M:initUI()
  self.mBg = display.newSprite("purgatory/bg.png"):addTo(self.mNode)
  self.mWidth = self.mBg:getContentSize().width
  self.mHeight = self.mBg:getContentSize().height
  self:initTabBtn()
  display.newSprite("union/defence/tangseng.png"):align(display.BOTTOM_LEFT, self.mBg:getContentSize().width * 0.05, self.mBg:getContentSize().height * 0.08):addTo(self.mBg, 2)
  display.newSprite("union/defence/change.png"):align(display.BOTTOM_LEFT, self.mBg:getContentSize().width * 0.7, self.mBg:getContentSize().height * 0.08):addTo(self.mBg, 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, self.mBg:getContentSize().width * 0.99, self.mBg:getContentSize().height * 0.99):addTo(self.mBg, 2):onButtonClicked(function()
    self:closeCallBack()
  end)
  display.newSprite("union/defence/feed.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.85):addTo(self.mBg)
  self.mProgress = createProgress(self.mBossCurExp, self.mBossMaxExp):pos(self.mWidth * 0.5, self.mHeight * 0.36):addTo(self.mBg)
  display.newScale9Sprite("common_ui/common_frame11.png", self.mWidth * 0.5, self.mHeight * 0.6, cc.size(800, 283), cc.rect(50, 50, 2, 2)):addTo(self.mBg)
  self.mDropBox = display.newSprite("common_ui/frame1.png"):pos(self.mWidth * 0.5, self.mHeight * 0.22):addTo(self.mBg)
  self.mMiddleFeedBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1683", ""),
    size = 30,
    color = cc.c3b(247, 227, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:onClickFeedBtn()
  end):scale(1):align(display.CENTER, self.mWidth * 0.5, self.mHeight * 0.07):addTo(self.mBg)
  self.mRecord = display.newSprite("union/defence/feed_record.png"):pos(self.mWidth * 0.05, self.mHeight * 0.92):addTo(self.mBg)
  M.bindClickEvent(self.mRecord, function()
    LayerFeedRecord.new(self.mBossFeedRecord):addTo(self, 20)
  end)
end

function M:initTabBtn()
  self.mTabBtnTable = {}
  local M_TAB_BTN = {
    {
      normal = "union/defence/tab_btn1_h.png",
      pressed = "union/defence/tab_btn1_h.png",
      disabled = "union/defence/tab_btn1.png"
    },
    {
      normal = "union/defence/tab_btn2_h.png",
      pressed = "union/defence/tab_btn2_h.png",
      disabled = "union/defence/tab_btn2.png"
    }
  }
  for i = 1, #M_TAB_BTN do
    local btn = cc.ui.UIPushButton.new(M_TAB_BTN[i]):onButtonClicked(function()
      self:funcChange(i)
    end):align(display.CENTER_RIGHT, 70, self.mBg:getContentSize().height * (0.9 - i * 0.12)):addTo(self.mBg)
    btn:setButtonEnabled(true)
    table.insert(self.mTabBtnTable, btn)
  end
  self.mTabBtnTable[1]:setButtonEnabled(false)
end

function M:funcChange(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mBtnTag = index
  for i = 1, #self.mTabBtnTable do
    local tabBtn = self.mTabBtnTable[i]
    if index == i then
      tabBtn:setButtonEnabled(false)
    else
      tabBtn:setButtonEnabled(true)
    end
  end
  self.mProgress:refresh(self.mBossFinalExp, self.mBossMaxExp)
  if self.mDropBox:getChildrenCount() > 0 then
    self.mDropBox.mIcon:removeSelf()
    self.mDropBox.mIcon = nil
  end
  if self.mListView then
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
  end
  self.mModeType = index
  self:initListView(index)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCb then
    self.mCb(self.mBossId, self.mBossFinalExp)
  end
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:runAction(cc.RemoveSelf:create())
    end)
  })
  self.mNode:runAction(popupLayer)
end

function M:calBuddhaPiece()
  local pieceData = {}
  for i = 1001, 1093 do
    local tmpPiece = {}
    local model = DataUtils.getBuddhaModel(i)
    local itemData = DYCommon.getDataByTag(FeedExpTable, "id", tostring(i))[1]
    if model ~= nil and itemData ~= nil then
      tmpPiece.id = i
      tmpPiece.quality = model.pieceQuality
      tmpPiece.pieceIcon = model.pieceIcon
      tmpPiece.count = model.currPieceNum
      if tmpPiece.count > 0 then
        table.insert(pieceData, tmpPiece)
      end
    end
  end
  return pieceData
end

local function buddhaPieceIcon(id, quality, pieceIcon, count)
  local iconNode = display.newNode()
  local itemData = DYCommon.getDataByTag(FeedExpTable, "id", tostring(id))[1]
  iconNode.frame1 = display.newSprite(string.format("common_ui/frame%d.png", quality)):addTo(iconNode)
  iconNode.mPieceIcon = display.newSprite(pieceIcon):pos(iconNode.frame1:getContentSize().width * 0.5, iconNode.frame1:getContentSize().height * 0.5):addTo(iconNode.frame1, 1)
  iconNode.mCurNum = count
  iconNode.mId = id
  iconNode.quality = quality
  iconNode.pieceIcon = pieceIcon
  iconNode.mFeedExp = tonumber(itemData.add_exp)
  iconNode.mConExp = tonumber(itemData.add_contribution)
  iconNode.mUnitcount = tonumber(itemData.unitcount)
  iconNode.mNumLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("*%d", count),
    font = "fonts/whiteNum.fnt"
  }):align(display.CENTER_RIGHT, iconNode.frame1:getContentSize().width * 0.95, iconNode.frame1:getContentSize().height * 0.15):scale(0.5):addTo(iconNode.frame1, 3)
  
  function iconNode:setString(num)
    iconNode.mNumLabel:setString(string.format("*%d", num))
  end
  
  return iconNode
end

local function itemIcon(id, currNum)
  local itemNode = display.newNode()
  local itemData = DYCommon.getDataByTag(FeedExpTable, "id", tostring(id))[1]
  itemNode.mIcon = PackageIcon.new(id, currNum):addTo(itemNode)
  itemNode.mId = id
  itemNode.mCurNum = currNum
  itemNode.mFeedExp = tonumber(itemData.add_exp)
  itemNode.mConExp = tonumber(itemData.add_contribution)
  itemNode.mUnitcount = tonumber(itemData.unitcount)
  
  function itemNode:setString(num)
    itemNode.mIcon.mNumLabel:setString(string.format("*%d", num))
  end
  
  return itemNode
end

function M:initItemData()
  self.mItemPieceTable = {}
  table.insert(self.mItemPieceTable, {
    id = 1,
    currNum = tonumber(DataUtils.getPackageItem(1).currNum)
  })
  table.insert(self.mItemPieceTable, {
    id = 2,
    currNum = tonumber(DataUtils.getPackageItem(2).currNum)
  })
  
  local function tFuncListener(packageInfo)
    for k, v in pairs(packageInfo.data) do
      local item = {}
      item.id = k
      item.currNum = tonumber(v)
      local itemData = DYCommon.getDataByTag(FeedExpTable, "id", tostring(item.id))[1]
      if itemData ~= nil and item.currNum > 0 then
        table.insert(self.mItemPieceTable, item)
      end
    end
    self:initListView(M.BUDDHA_PIECE)
  end
  
  DYHttpMgr.initPackageInfo(tFuncListener)
end

function M:initListView(pTag)
  self.mBossCurExp = self.mBossFinalExp
  local rankData
  if pTag == M.BUDDHA_PIECE then
    rankData = self:calBuddhaPiece()
  elseif pTag == M.ITEM_PIECE then
    rankData = self.mItemPieceTable
  end
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(140, 295, 769, 270),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  local sumCount = #rankData
  local columns = 6
  local rows = math.ceil(sumCount / columns)
  local tmpCount = 1
  for i = 1, rows do
    local item = self.mListView:newItem()
    local content = display.newNode()
    for j = 1, columns do
      if sumCount < tmpCount then
        break
      end
      local icon
      if pTag == M.BUDDHA_PIECE then
        icon = buddhaPieceIcon(rankData[tmpCount].id, rankData[tmpCount].quality, rankData[tmpCount].pieceIcon, rankData[tmpCount].count)
      elseif pTag == M.ITEM_PIECE then
        icon = itemIcon(rankData[tmpCount].id, rankData[tmpCount].currNum)
      end
      icon:setPosition(122 * j - 61, 62)
      icon:setTouchEnabled(true)
      icon:setTouchSwallowEnabled(false)
      M.bindClickEvent(icon, function()
        self:onIconClick(icon)
      end)
      content:addChild(icon)
      tmpCount = tmpCount + 1
    end
    content:setContentSize(122 * columns, 132)
    item:addContent(content)
    item:setItemSize(122 * columns, 132)
    self.mListView:addItem(item)
  end
  self.mListView:reload()
end

function M:onIconClick(icon)
  if self.mDropBox:getChildrenCount() < 1 then
    if icon.mCurNum < icon.mUnitcount then
      WSToast.new(DYLang.getString("S1684", "")):addTo(self, 50)
      return
    end
    if self.mModeType == M.BUDDHA_PIECE then
      self.mDropBox.mIcon = buddhaPieceIcon(icon.mId, icon.quality, icon.pieceIcon, icon.mUnitcount):pos(59, 59):addTo(self.mDropBox)
    elseif self.mModeType == M.ITEM_PIECE then
      self.mDropBox.mIcon = itemIcon(icon.mId, icon.mUnitcount):pos(59, 59):addTo(self.mDropBox)
    end
    icon.mCurNum = icon.mCurNum - icon.mUnitcount
    icon:setString(icon.mCurNum)
    self:refreshProgress(self.mDropBox.mIcon, icon.mUnitcount)
    self.mDropBox.mIcon.mLinkIcon = icon
    self.mDropBox.mIcon:setTouchEnabled(true)
    self.mDropBox.mIcon:setString(icon.mUnitcount)
    self.mDropBox.mIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      self:onDropBoxClick(event, self.mDropBox.mIcon)
    end)
  elseif self.mDropBox.mIcon.mId == icon.mId and icon.mCurNum > icon.mUnitcount then
    self:refreshProgress(self.mDropBox.mIcon, icon.mUnitcount)
    self.mDropBox.mIcon.mCurNum = self.mDropBox.mIcon.mCurNum + icon.mUnitcount
    self.mDropBox.mIcon:setString(self.mDropBox.mIcon.mCurNum)
    icon.mCurNum = icon.mCurNum - icon.mUnitcount
    icon:setString(icon.mCurNum)
  end
end

function M:refreshProgress(feedItem, num)
  local addNum = tonumber(feedItem.mFeedExp) * num
  self.mBossCurExp = self.mBossCurExp + addNum
  if self.mBossCurExp > self.mBossMaxExp then
    self.mBossCurExp = self.mBossMaxExp
  end
  if self.mBossCurExp < self.mBossInitExp then
    self.mBossCurExp = self.mBossInitExp
  end
  self.mProgress:refresh(self.mBossCurExp, self.mBossMaxExp)
end

function M:onDropBoxClick(event, icon)
  if event.name == "began" then
    if icon == nil then
      return
    end
    if icon.mCurNum >= icon.mUnitcount then
      icon.mCurNum = icon.mCurNum - icon.mUnitcount
      icon:setString(icon.mCurNum)
      self.mDropBox.mIcon.mLinkIcon.mCurNum = self.mDropBox.mIcon.mLinkIcon.mCurNum + icon.mUnitcount
      self.mDropBox.mIcon.mLinkIcon:setString(self.mDropBox.mIcon.mLinkIcon.mCurNum)
      self:refreshProgress(self.mDropBox.mIcon, -icon.mUnitcount)
      if icon.mCurNum == 0 then
        self.mDropBox.mIcon:removeSelf()
        self.mDropBox.mIcon = nil
      end
    end
  end
end

function M:onClickFeedBtn(feedType)
  local feedItem = self.mDropBox.mIcon
  if feedItem == nil or self.mCanClick == false or feedItem.mId == nil or feedItem.mCurNum == nil then
    return
  end
  self.mCanClick = false
  
  local function tFunc(event)
    if not self.mBossFinalExp then
      return
    end
    self.mCanClick = true
    if event.ret_code == 0 then
      DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
      self.mBossFinalExp = self.mBossCurExp
      local addExp = self.mBossFinalExp - self.mBossInitExp
      local tmpText = string.format(DYLang.getString("S1686", ""), event.add_contribution, addExp)
      if addExp == 0 then
        tmpText = string.format(DYLang.getString("S1687", ""), event.add_contribution, addExp)
      end
      WSToast.new(tmpText):pos(0, 0):addTo(self.mNode)
      self.mBossInitExp = self.mBossCurExp
      DataUtils.updateItemNum(self.mDropBox.mIcon.mLinkIcon.mId, self.mDropBox.mIcon.mLinkIcon.mCurNum)
      self.mDropBox.mIcon:removeSelf()
      CloudData.UNION_CONTRI_NUM = CloudData.UNION_CONTRI_NUM + event.add_contribution
      CloudData.GAME_ITEM_INFO["9"] = CloudData.UNION_CONTRI_NUM
      CloudData.UNION_SELF_INFO.clan_contribution = CloudData.UNION_SELF_INFO.clan_contribution + event.add_contribution
    else
      WSToast.new(event.err_msg):pos(0, 0):addTo(self.mNode)
    end
  end
  
  self:safeSocketRequest("CMD_FEED_CLAN_BOSS", {
    boss_id = self.mBossId,
    item_id = feedItem.mId,
    item_count = feedItem.mCurNum
  }, tFunc)
end

function M.bindClickEvent(node, tFunc)
  node:setTouchEnabled(true)
  node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      node.pointBegan = {x = x, y = y}
      return true
    elseif name == "ended" then
      local pointEnd = {x = x, y = y}
      if math.abs(node.pointBegan.x - pointEnd.x) < 50 and math.abs(node.pointBegan.y - pointEnd.y) < 50 then
        node:runAction(cc.CallFunc:create(function(event)
          tFunc(event)
        end))
      end
    end
  end)
  return node
end

return M

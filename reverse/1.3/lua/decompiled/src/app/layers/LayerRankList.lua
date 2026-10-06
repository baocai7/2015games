local RankingIcon = require("app.icons.RankingIcon")
local DYClass = "LayerRankList"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
M.RANK_CE = 1
M.RANK_LEVEL = 2
M.RANK_PVP = 3
M.RANK_DUNGEON = 4
M.RANK_RELICS = 5

function M:ctor(rankType, cb)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mRankIdx = rankType or M.RANK_CE
  self.mCallback = cb
  self.mUserInfoBg = nil
  self:initUI()
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function getRelatedNum(self)
  if M.RANK_RELICS == self.mBtnTag then
    return ""
  end
  local info = self.mCurrRank.user
  local textStr = ""
  local tFunc = {
    [1] = info.power,
    [2] = info.level,
    [3] = info.power,
    [4] = info.star
  }
  textStr = tFunc[self.mBtnTag]
  return textStr
end

function M:initData()
  local function tFuncListener(jsonTable)
    local userCEData = {
      rank = jsonTable.data.powerRankData,
      
      user = jsonTable.data.powerUserData
    }
    local levelData = {
      rank = jsonTable.data.levelRankData,
      user = jsonTable.data.levelUserData
    }
    local pvpData = {
      rank = jsonTable.data.pvpRankData,
      user = jsonTable.data.pvpUserData
    }
    local dungeonData = {
      rank = jsonTable.data.dungeonRankData,
      user = jsonTable.data.dungeonUserData
    }
    local equipData = {
      rank = jsonTable.data.equipmentRankData
    }
    self.mRankList = {
      userCEData,
      levelData,
      pvpData,
      dungeonData,
      equipData
    }
    self.mBtnTag = self.mRankIdx
    self.mCurrRank = self.mRankList[self.mRankIdx]
    self:performWithDelay(handler(self, self.initUserInfo), 0.3)
    self:performWithDelay(handler(self, self.initListView), 0.8)
  end
  
  local countCE = DataUtils.getUserCountCE()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&power=%s&token=%s&uid=%s", strAppSecret .. "", countCE .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.sign = crypto.md5(strSign, false)
  params.power = countCE
  self:safeHttpRequest("getRankingList", tFuncListener, params)
end

function M:initUI()
  local bg = display.newSprite("common_ui/common_bg.png"):addTo(self.mNode)
  self.mBg = display.newSprite("ranking/bg.png"):pos(bg:getContentSize().width * 0.5 + 40, bg:getContentSize().height * 0.5):addTo(bg)
  local h = self.mRankIdx == M.RANK_RELICS and 504 or 375
  self.mListFrame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(794, h), cc.rect(40, 40, 2, 2)):align(display.CENTER_BOTTOM, self.mBg:getContentSize().width * 0.5, 100):addTo(self.mBg)
  local titleFrame = display.newSprite("common_ui/title_frame.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.92):addTo(self.mBg, 2)
  display.newSprite("ranking/title.png"):pos(titleFrame:getContentSize().width * 0.5, titleFrame:getContentSize().height * 0.52):addTo(titleFrame)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.96, self.mBg:getContentSize().height * 0.94):onButtonClicked(function()
    self:performWithDelay(function()
      self:closeCallBack()
    end, 0.1)
  end):addTo(self.mBg, 15)
  self.mTabBtnTable = {}
  self.mRalatedTable = {
    DYLang.getString("S851", ""),
    DYLang.getString("S852", ""),
    DYLang.getString("S851", ""),
    DYLang.getString("S854", ""),
    DYLang.getString("S855", "")
  }
  self:initTabBtn()
end

function M:initTabBtn()
  local M_TAB_BTN = {
    {
      normal = "ranking/tab_btn1.png",
      pressed = "ranking/tab_btn1.png",
      disabled = "ranking/tab_btn1_h.png"
    },
    {
      normal = "ranking/tab_btn2.png",
      pressed = "ranking/tab_btn2.png",
      disabled = "ranking/tab_btn2_h.png"
    },
    {
      normal = "ranking/tab_btn3.png",
      pressed = "ranking/tab_btn3.png",
      disabled = "ranking/tab_btn3_h.png"
    },
    {
      normal = "ranking/tab_btn4.png",
      pressed = "ranking/tab_btn4.png",
      disabled = "ranking/tab_btn4_h.png"
    },
    {
      normal = "ranking/tab_btn5.png",
      pressed = "ranking/tab_btn5.png",
      disabled = "ranking/tab_btn5_h.png"
    }
  }
  for i = 1, #M_TAB_BTN do
    local btn = cc.ui.UIPushButton.new(M_TAB_BTN[i]):onButtonClicked(function()
      self:funcChange(i)
    end):align(display.CENTER_RIGHT, 60, self.mBg:getContentSize().height * (0.9 - i * 0.12)):addTo(self.mBg)
    if self.mRankIdx == i then
      btn:setButtonEnabled(false)
    end
    table.insert(self.mTabBtnTable, btn)
  end
end

function M:initUserInfo()
  local infoBg = display.newSprite("ranking/bg_info.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.78):addTo(self.mBg)
  self.mUserInfoBg = infoBg
  if self.mBtnTag == M.RANK_RELICS then
    self.mUserInfoBg:hide()
  else
    self.mUserInfoBg:show()
  end
  local iconFrame = display.newSprite("common_ui/frame4.png"):scale(0.85):align(display.CENTER_LEFT, infoBg:getContentSize().width * 0.03, infoBg:getContentSize().height * 0.5):addTo(infoBg)
  local userIocn = display.newSprite(CloudData.USER_ICON):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if CloudData.VIP_LEVEL > 0 then
    local vipFrame = display.newSprite("ranking/bg_vip.png"):align(display.CENTER_RIGHT, iconFrame:getContentSize().width, iconFrame:getContentSize().height):addTo(iconFrame)
    DYLabelTTF.new({
      text = string.format("%d", CloudData.VIP_LEVEL),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(111, 47, 2)
    }):pos(vipFrame:getContentSize().width * 0.72, vipFrame:getContentSize().height * 0.32):addTo(vipFrame)
  end
  cc.ui.UILabel.new({
    text = CloudData.USER_NAME,
    size = 25,
    color = cc.c3b(87, 35, 4),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, infoBg:getContentSize().width * 0.18, infoBg:getContentSize().height * 0.73):addTo(infoBg)
  cc.ui.UILabel.new({
    text = string.format("LV.%d", CloudData.USER_LEVEL),
    size = 25,
    color = cc.c3b(87, 35, 4),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, infoBg:getContentSize().width * 0.18, infoBg:getContentSize().height * 0.27):addTo(infoBg)
  local textStr = getRelatedNum(self)
  self.mRelatedLabel = DYLabelTTF.new({
    text = DYLang.getString("S851", ""),
    size = 26,
    color = cc.c3b(255, 221, 26),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(infoBg:getContentSize().width * 0.4, infoBg:getContentSize().height * 0.25):addTo(infoBg)
  self.mRelatedNum = DYLabelTTF.new({
    text = textStr,
    size = 24,
    color = cc.c3b(74, 255, 11),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(infoBg:getContentSize().width * 0.4 + self.mRelatedLabel:getContentSize().width, infoBg:getContentSize().height * 0.25):addTo(infoBg)
  local currRankLabel = DYLabelTTF.new({
    text = DYLang.getString("S857", ""),
    size = 26,
    color = cc.c3b(255, 221, 26),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(infoBg:getContentSize().width * 0.7, infoBg:getContentSize().height * 0.25):addTo(infoBg)
  local rank = checknumber(self.mCurrRank.user and self.mCurrRank.user.rank)
  self.mCurrRankNum = DYLabelTTF.new({
    text = rank,
    size = 24,
    color = cc.c3b(74, 255, 11),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(infoBg:getContentSize().width * 0.7 + currRankLabel:getContentSize().width, infoBg:getContentSize().height * 0.25):addTo(infoBg)
  if 10000 < rank and self.mRankIdx == 3 then
    self.mCurrRankNum:setString(DYLang.getString("S858", ""))
  end
end

function M:initListView()
  local h = self.mBtnTag == M.RANK_RELICS and 484 or 355
  self.mListFrame:setContentSize(794, h + 20)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(75, 108, 774, h),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(self.mBg, 2)
  local idx = 1
  local row = #self.mCurrRank.rank
  local rowInView = self.mBtnTag == M.RANK_RELICS and 5 or 4
  
  local function tFuncAddItem()
    while idx <= row do
      local item = listView:newItem()
      item:setItemSize(770, 112)
      listView:addItem(item)
      if idx <= rowInView then
        self:onEventDisplayItem(item, idx, true)
      else
        self:onEventDisplayItem(item, idx, false)
      end
      idx = idx + 1
    end
    listView:reload()
  end
  
  self:performWithDelay(tFuncAddItem, 0)
  self.mListView = listView
end

function M:initListView2(pTag)
  local rankData = self.mCurrRank.rank
  self.mListView = cc.ui.UIListView.new({
    async = true,
    viewRect = cc.rect(75, 108, 774, 355),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(self.mBg, 2)
  
  local function tFuncDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
      return #rankData
    else
      if cc.ui.UIListView.CELL_TAG == tag then
        local item = self.mListView:newItem()
        local content = RankingIcon.new(rankData[idx], pTag)
        item:addContent(content)
        item:setItemSize(770, 112)
        return item
      else
      end
    end
  end
  
  self.mListView:setDelegate(tFuncDelegate)
  self.mListView:reload()
end

function M:funcChange(index)
  if not self.mRankList then
    return
  end
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
  self.mCurrRank = self.mRankList[index]
  self.mRelatedLabel:setString(self.mRalatedTable[index])
  if self.mBtnTag ~= M.RANK_RELICS then
    self.mUserInfoBg:show()
    local textStr = getRelatedNum(self)
    self.mRelatedNum:setString(textStr)
    self.mRelatedNum:setPositionX(self.mRelatedLabel:getPositionX() + self.mRelatedLabel:getContentSize().width)
    if tonumber(self.mCurrRank.user.rank) > 10000 and index == 3 then
      self.mCurrRankNum:setString(DYLang.getString("S858", ""))
    else
      self.mCurrRankNum:setString(self.mCurrRank.user.rank)
    end
  else
    self.mUserInfoBg:hide()
  end
  if self.mListView then
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
  end
  self:initListView(index)
end

function M:onEventDisplayItem(item, idx, flag)
  local pTag = self.mBtnTag
  local rankData = self.mCurrRank.rank
  if flag then
    if not item.isValid then
      item:removeAllChildren()
      local content = display.newNode()
      content:setContentSize(770, 112)
      RankingIcon.new(rankData[idx], pTag):addTo(content):pos(385, 56)
      item:addContent(content)
      item.isValid = true
    end
  elseif item.isValid or item.isValid == nil then
    item:removeAllChildren()
    local content = display.newNode()
    content:setContentSize(790, 170)
    item:addContent(content)
    item.isValid = false
  end
end

function M:touchListener(event)
  if event.name == "itemAppearChange" then
    self:onEventDisplayItem(event.item, event.itemPos, true)
  elseif event.name == "itemDisappear" then
    self:onEventDisplayItem(event.item, event.itemPos, false)
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

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
  self:invokeCallback()
end

function M:invokeCallback(tag, param1, param2)
  if self.mCallback then
    self.mCallback(tag, param1, param2)
  end
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

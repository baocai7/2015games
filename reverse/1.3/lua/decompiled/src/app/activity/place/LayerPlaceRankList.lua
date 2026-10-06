local RankingIcon = require("app.activity.place.PlaceRankingIcon")
local DYClass = "LayerPlaceRankList"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
local RANK_TEXT = {
  nian = "\230\156\172\232\189\174\228\188\164\229\174\179\239\188\154",
  duanwu = "\230\156\172\232\189\174\232\136\170\231\168\139\239\188\154"
}

function M:ctor(params)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mType = params.type
  self.mRankList = {}
  self.mNode = display.newNode():addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mRankIdx = 1
  self:initUI()
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function getRelatedNum(self)
  local info = self.mRankList[1].user
  local textStr = ""
  local tFunc = {
    [1] = info.hurt,
    [2] = info.hurt
  }
  textStr = tFunc[self.mBtnTag]
  return textStr
end

function M:initData()
  local function tFuncListener(jsonTable)
    local userCEData = {
      rank = jsonTable.data.list,
      
      user = jsonTable.data.player
    }
    self.mRankList[1] = userCEData
    self.mTabBtnTable = {}
    self.mRalatedTable = {
      RANK_TEXT[self.mType],
      RANK_TEXT[self.mType]
    }
    self.mBtnTag = self.mRankIdx
    self.mCurrRank = self.mRankList[1]
    self:initTabBtn()
    self:initUserInfo()
    self:initListView(self.mRankIdx)
  end
  
  local params = {}
  DYHttpMgr.requestPlaceActiveRank(tFuncListener)
  
  local function tFuncListener2(jsonTable)
    dump(jsonTable, "  ", 9)
    self.mRankList[2] = jsonTable.data
  end
  
  DYHttpMgr.requestPlaceActiveLastRank(tFuncListener2)
end

function M:initUI()
  local bg = display.newSprite("common_ui/common_bg.png"):addTo(self.mNode)
  self.mBg = display.newSprite("ranking/bg.png"):pos(bg:getContentSize().width * 0.5 + 40, bg:getContentSize().height * 0.5):addTo(bg)
  self.mListFrame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(794, 375), cc.rect(40, 40, 2, 2)):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.41):addTo(self.mBg)
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
end

function M:initTabBtn()
  local M_TAB_BTN = {
    {
      normal = "new_year/place/tab_btn1_h.png",
      pressed = "new_year/place/tab_btn1_h.png",
      disabled = "new_year/place/tab_btn1.png"
    },
    {
      normal = "new_year/place/tab_btn2_h.png",
      pressed = "new_year/place/tab_btn2_h.png",
      disabled = "new_year/place/tab_btn2.png"
    }
  }
  for i = 1, #M_TAB_BTN do
    local btn = cc.ui.UIPushButton.new(M_TAB_BTN[i]):onButtonClicked(function()
      self:funcChange(i)
    end):align(display.CENTER_RIGHT, 70, self.mBg:getContentSize().height * (0.9 - i * 0.12)):addTo(self.mBg)
    if self.mRankIdx == i then
      btn:setButtonEnabled(false)
    end
    table.insert(self.mTabBtnTable, btn)
  end
end

function M:initUserInfo()
  local infoBg = display.newSprite("ranking/bg_info.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.78):addTo(self.mBg)
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
    text = RANK_TEXT[self.mType],
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
    text = DYLang.getString("S64", ""),
    size = 26,
    color = cc.c3b(255, 221, 26),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(infoBg:getContentSize().width * 0.4, infoBg:getContentSize().height * 0.6):addTo(infoBg)
  self.mCurrRankNum = DYLabelTTF.new({
    text = self.mCurrRank.user.rank,
    size = 24,
    color = cc.c3b(74, 255, 11),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(infoBg:getContentSize().width * 0.4 + currRankLabel:getContentSize().width, infoBg:getContentSize().height * 0.6):addTo(infoBg)
end

function M:initListView(pTag)
  local rankData = self.mCurrRank.rank or self.mCurrRank
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
        local content = RankingIcon.new(rankData[idx], pTag, self.mType)
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
  local textStr = getRelatedNum(self)
  self.mRelatedNum:setString(textStr)
  self.mRelatedNum:setPositionX(self.mRelatedLabel:getPositionX() + self.mRelatedLabel:getContentSize().width)
  self.mCurrRankNum:setString(self.mRankList[1].user.rank)
  if self.mListView then
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
  end
  self:initListView(index)
end

function M:touchListener(event)
  local lv = event.listView
  if "clicked" == event.name then
    print(event.itemPos)
  elseif "moved" == event.name then
  else
    if "ended" == event.name then
    else
    end
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
  self:removeSelf()
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

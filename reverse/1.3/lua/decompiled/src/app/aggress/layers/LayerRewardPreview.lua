local IconItem = require("app.icons.IconItem")
local CLASS_NAME = "LayerRewardPreview"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(param)
  self.mParam = param or {}
  self.mCoreNode = display.newNode():pos(0, 0):addTo(self)
  self:initData()
  self:layoutUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mRewardData = {}
  
  local function tFuncParseRawData(rawData)
    if not rawData then
      return {}
    end
    local t = {}
    local strItems = string.split(rawData, ";")
    for i = 1, #strItems do
      local strVals = string.split(strItems[i], ",")
      local item = {}
      item.id = strVals[1]
      item.num = strVals[2]
      table.insert(t, item)
    end
    return t
  end
  
  self.mRewardData.BEST = tFuncParseRawData(self.mParam.mvpAward)
  self.mRewardData.KILL = tFuncParseRawData(self.mParam.killAward)
  self.mRewardData.HELP = tFuncParseRawData(self.mParam.helpAward)
  self.mRewardData.DISCOVER = tFuncParseRawData(self.mParam.findAward)
end

function M:layoutUI()
  self:addWidget()
  self:addContent()
end

function M:addWidget()
  local node = self.mCoreNode
  local widget = cc.uiloader:load("ui/LayerRewardPreview.csb")
  widget:addTo(node)
  self.mWidget = widget
  local WIDGET_ITEM = {
    "ButtonClose",
    "TextTitleBest",
    "TextTitleKill",
    "TextTitleHelp",
    "TextTitleDiscover",
    "ListViewBest",
    "ListViewKill",
    "ListViewHelp",
    "ListViewDiscover"
  }
  self:bindWidget(widget, WIDGET_ITEM)
end

function M:bindWidget(widget, items)
  for i = 1, #items do
    local name = items[i]
    local item = cc.uiloader:seekNodeByName(widget, name)
    local ki = "m" .. name
    self[ki] = item
    local isBtn = string.find(name, "Button") == 1
    if isBtn then
      item:addTouchEventListener(handler(self, self.onEventButton))
    end
    local isListView = string.find(name, "ListView") == 1
    if isListView then
      item:addEventListener(handler(self, self.onEventListView))
      item:addScrollViewEventListener(handler(self, self.onEventScrollView))
    end
  end
end

function M:addContent()
  self.mTextTitleBest:setString(DYLang.getString("STR_MVP", ""))
  self.mTextTitleKill:setString(DYLang.getString("STR_KILL", ""))
  self.mTextTitleHelp:setString(DYLang.getString("STR_HELP", ""))
  self.mTextTitleDiscover:setString(DYLang.getString("STR_DISCOVER", ""))
  
  local function tFuncTouchEvent(sender, eventType)
    local frame = sender.iconFrame
    if not frame then
      return
    end
    if eventType == ccui.TouchEventType.began then
      frame:showTip()
    elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
      frame:hideTip()
    end
  end
  
  local function tFuncGenItem(id, num)
    local frame = IconItem.new(id, num):pos(60, 58)
    frame:setScale(0.9)
    local custom_item = ccui.Layout:create()
    custom_item:setContentSize(120, 116)
    custom_item:addChild(frame)
    custom_item:setTouchEnabled(true)
    custom_item.iconFrame = frame
    custom_item:addTouchEventListener(tFuncTouchEvent)
    return custom_item
  end
  
  local function tFuncFillList(data, lv)
    for i = 1, #data do
      local item = tFuncGenItem(data[i].id, data[i].num)
      lv:addChild(item)
    end
  end
  
  tFuncFillList(self.mRewardData.BEST, self.mListViewBest)
  tFuncFillList(self.mRewardData.KILL, self.mListViewKill)
  tFuncFillList(self.mRewardData.HELP, self.mListViewHelp)
  tFuncFillList(self.mRewardData.DISCOVER, self.mListViewDiscover)
end

function M:onEventListView(sender, eventType)
  if eventType == ccui.ListViewEventType.ONSELECTEDITEM_START then
  elseif eventType == ccui.ListViewEventType.ONSELECTEDITEM_END then
  end
end

function M:onEventScrollView(sender, eventType)
  if evenType == ccui.ScrollviewEventType.scrollToBottom then
  elseif evenType == ccui.ScrollviewEventType.scrollToTop then
  end
end

function M:onEventButton(sender, eventType)
  if eventType and eventType ~= ccui.TouchEventType.ended then
    return
  end
  DDLOG("buttonListener: %s", sender:getName())
  if sender == self.mButtonClose then
    self:onClickClose()
  end
end

function M:onClickClose()
  DDLOG("onClickClose")
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:onClickClose()
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

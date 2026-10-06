local LayerBoxShow = require("app.layers.LayerBoxShow")
local LayerTip = require("app.babel.layers.LayerTip")
local CLASS_NAME = "LayerMail"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer(CLASS_NAME)
end)

function M:ctor(handler_)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCallback = handler_
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mCoreNode = display.newNode():addTo(self)
  self.mCoreNode:setPosition(cc.p(display.cx, display.cy))
  self.mPanelLeft = nil
  self.mPanelRight = nil
  self.mPanelAttach = nil
  self.mLabelMailSender = nil
  self.mLabelMailText = nil
  self.mLabelMailSender = nil
  self.mListMail = nil
  self.mLastContent = nil
  self.mBtnObtain = nil
  self.mBtnObtainAll = nil
  self.mSoundFile = ""
  self:layoutUI()
  self:setNodeEventEnabled(true)
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:hide()
    return true
  end
  return false
end

function M:layoutUI()
  self:addWidget()
  self:addContent()
end

function M:addWidget()
  local node = self.mCoreNode
  local widget = cc.uiloader:load("ui/LayerMail.csb")
  widget:addTo(node)
  self.mWidget = widget
  local panelRoot = cc.uiloader:seekNodeByName(widget, "PanelRoot")
  panelRoot:setPosition(dy.p(0, 0))
  self.mPanelLeft = cc.uiloader:seekNodeByName(widget, "PanelLeft")
  self.mPanelRight = cc.uiloader:seekNodeByName(widget, "PanelRight")
  self.mPanelAttach = cc.uiloader:seekNodeByName(widget, "PanelAttach")
  self.mLabelMailSender = cc.uiloader:seekNodeByName(widget, "LabelMailSender")
  self.mLabelMailText = cc.uiloader:seekNodeByName(widget, "LabelMailText")
  self.mBtnClose = cc.uiloader:seekNodeByName(widget, "ButtonClose")
  self.mBtnObtain = cc.uiloader:seekNodeByName(widget, "ButtonObtain")
  self.mBtnObtainAll = cc.uiloader:seekNodeByName(widget, "ButtonObtainAll")
  self.mPanelRight:setVisible(false)
  self.mPanelAttach:removeAllChildren()
  self.mBtnObtain:setEnabled(true)
  self.mBtnObtain:addTouchEventListener(handler(self, self.onClickButtonObtain))
  self.mBtnObtainAll:addTouchEventListener(handler(self, self.onClickButtonObtainAll))
  self.mBtnClose:addTouchEventListener(handler(self, self.onClickButtonClose))
end

function M:addContent()
  local node = self.mCoreNode
  if CloudData.SERVER_MSG then
    self.mData = CloudData.SERVER_MSG.msg or {}
  else
    CloudData.SERVER_MSG = {}
    CloudData.SERVER_MSG.msg = {}
    self.mData = {}
  end
  local listView = cc.ui.UIListView.new({
    bgColor = cc.c4b(255, 255, 255, 0),
    viewRect = cc.rect(-205, -250, 410, 500),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  })
  listView:onTouch(handler(self, self.onTouch))
  listView:addTo(self.mPanelLeft)
  self.mListMail = listView
  self:reloadMail()
end

function M:reloadMail()
  local ListItemMail = require("layers.ListItemMail")
  local cnt = #self.mData
  for i = 1, cnt do
    local item = self.mListMail:newItem()
    local data = self.mData[i]
    local content = ListItemMail.new(data)
    content.item = item
    content.itemPos = i
    item:addContent(content)
    item:setItemSize(410, 140)
    self.mListMail:addItem(item)
    if i == 1 then
      self:performWithDelay(function()
        self:onClickItem(item)
      end, 0)
    end
  end
  self.mListMail:reload()
end

function M:onTouch(event)
  if "began" == event.name then
    return true
  elseif "clicked" == event.name then
    DDLOG(event.itemPos)
    self:onClickItem(event.item)
  end
end

function M:onClickItem(item)
  if not item then
    return
  end
  local content = item:getContent()
  content:setReadFlag(true)
  content:setSelectFlag(true)
  local data = content:getData()
  self:showMail(data)
  if self.mLastContent and self.mLastContent ~= content then
    self.mLastContent:setSelectFlag(false)
  end
  self.mLastContent = content
end

function M:showMail(data)
  self.mPanelRight:setVisible(true)
  self.mPanelAttach:removeAllChildren()
  self.mLabelMailSender:setString(DYLang.getString("S740", ""))
  self.mLabelMailSender:setColor(cc.c3b(255, 255, 0))
  self.mLabelMailText:setString(data.content)
  self.mBtnObtain:setEnabled(true)
  if data.things == "" then
    self.mBtnObtain:setTitleText(DYLang.getString("S38", ""))
    self.mSoundFile = DY_SND.sfx_touch
    return
  end
  self.mBtnObtain:setTitleText(DYLang.getString("S9", ""))
  self.mSoundFile = DY_SND.sfx_treasure_falling
  local aThings = string.split(data.things, ";")
  local aCounts = string.split(data.counts, ";")
  local cnt = #aThings
  if 4 < cnt then
    cnt = 4
  end
  local IconItem = require("icons.IconItem")
  for i = 1, cnt do
    if checkstring(aThings[i]) ~= "" and 0 < checkint(aCounts[i]) then
      local ath = IconItem.new(aThings[i], aCounts[i])
      ath:setPosition(-195 + (i - 1) * 130, 0)
      self.mPanelAttach:addChild(ath)
      ath:showItemTip()
    end
  end
end

function M:show()
end

function M:hide()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
  self:runAction(cc.RemoveSelf:create())
end

function M:onClickButtonClose(sender, eventType)
  if eventType ~= ccui.TouchEventType.ended then
    return
  end
  self:hide()
end

function M:onClickButtonObtain(sender, eventType)
  if eventType ~= ccui.TouchEventType.ended then
    return
  end
  if not self.mLastContent then
    return
  end
  self.mPanelRight:setVisible(false)
  DYSoundMgr.playEffect(self.mSoundFile)
  local content = self.mLastContent
  local data = content:getData()
  
  local function tFuncListener(jsonTable)
    if tonumber(jsonTable.errorCode) == 0 then
      table.walk(jsonTable.data, function(v, k)
        local num = DataUtils.updateItemNum(k, v)
        DYAnalyze.item.get(k, "", num, "MAIL")
      end)
      if not self or self.__cname ~= CLASS_NAME then
        return
      end
      
      local function tFuncActionEnd()
        table.remove(self.mData, content.itemPos)
        self.mListMail:removeAllItems()
        self.mLastContent = nil
        self:reloadMail()
      end
      
      content.item:runAction(cc.Sequence:create(cc.MoveBy:create(0.2, cc.p(-420, 0)), cc.CallFunc:create(tFuncActionEnd)))
      content.item:runAction(cc.FadeOut:create(0.2))
    else
      local msg = jsonTable.errorMsg or ""
      if msg == "" then
        msg = DYLang.getString("S743", "")
      end
      local tip = WSToast.new(msg, 1)
      display.getRunningScene():addChild(tip, 20)
      if self and self.mPanelRight then
        self.mPanelRight:setVisible(true)
      end
    end
  end
  
  local params = {}
  params.id = data.id
  DYHttpMgr.getMailReward(tFuncListener, params)
end

function M:onClickButtonObtainAll(sender, eventType)
  if eventType ~= ccui.TouchEventType.ended then
    return
  end
  if not self.mLastContent then
    return
  end
  self.mPanelRight:setVisible(false)
  DYSoundMgr.playEffect(self.mSoundFile)
  DDLOG("on click button obtain all")
  
  local function tFuncListener(jsonTable)
    if tonumber(jsonTable.errorCode) == 0 then
      for id, num in pairs(jsonTable.data.drop) do
        DataUtils.updateItemNum(id, num)
      end
      local reward = {}
      for k, v in pairs(jsonTable.data.dropGain) do
        table.insert(reward, {
          id = checknumber(k),
          num = checknumber(v)
        })
        DYAnalyze.item.get(id, "", num, "MAIL")
      end
      if 0 < #reward then
        local awardTable = {boxInfo = reward}
        local tip = LayerBoxShow.new(awardTable, LayerBoxShow.AWARD_GET, handler(self, self.hide))
        self:addChild(tip, 50)
      else
        LayerTip.new(DYLang.getString("S744", ""), handler(self, self.hide)):addTo(self, 50)
      end
      if CloudData.SERVER_MSG then
        CloudData.SERVER_MSG.msg = {}
      end
      self.mData = {}
    else
      local msg = jsonTable.errorMsg or ""
      if msg == "" then
        msg = DYLang.getString("S743", "")
      end
      local tip = WSToast.new(msg, 1)
      display.getRunningScene():addChild(tip, 20)
      if self and self.mPanelRight then
        self.mPanelRight:setVisible(true)
      end
    end
  end
  
  local params = {}
  DYHttpMgr.getAllMailReward(tFuncListener, params)
end

return M

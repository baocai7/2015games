local CLASS_NAME = "LayerPVPOlReward"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer(CLASS_NAME)
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mCoreNode = display.newNode():addTo(self)
  self.mCoreNode:setPosition(cc.p(display.cx, display.cy))
  self.mData = nil
  self.mPanelRoot = nil
  self.mListView = nil
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
  self:initData()
  self:addWidget()
  self:addContent()
end

function M:initData()
  self.mData = {}
  for i = 1, 11 do
    table.insert(self.mData, DataUtils.getPVPActualModel(i))
  end
end

function M:addWidget()
  local node = self.mCoreNode
  display.newColorLayer(cc.c4b(0, 0, 0, 128)):addTo(self, -1)
  local widget = cc.uiloader:load("ui/LayerPVPOlReward.csb")
  widget:addTo(node)
  self.mWidget = widget
  local panelRoot = cc.uiloader:seekNodeByName(widget, "PanelRoot")
  panelRoot:setPosition(dy.p(0, 0))
  self.mPanelRoot = panelRoot
  self.mBtnClose = cc.uiloader:seekNodeByName(widget, "ButtonClose")
  self.mBtnClose:addTouchEventListener(handler(self, self.onClickButtonClose))
end

function M:addContent()
  local node = self.mCoreNode
  local listView = cc.ui.UIListView.new({
    bgColor = cc.c4b(255, 255, 255, 0),
    viewRect = cc.rect(-305, -240, 610, 480),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  })
  listView:addTo(self.mPanelRoot)
  self.mListView = listView
  self:reloadData()
end

function M:reloadData()
  local IconItem = import("icons.IconItem")
  local cnt = #self.mData
  for i = 1, cnt do
    local item = self.mListView:newItem()
    local data = self.mData[i]
    local content = cc.uiloader:load("ui/ListItemPVPOlReward.csb")
    local imageIndex = cc.uiloader:seekNodeByName(content, "ImageIndex")
    local labelIndex = cc.uiloader:seekNodeByName(content, "LabelIndex")
    if i <= 3 then
      imageIndex:setVisible(true)
      labelIndex:setVisible(false)
      imageIndex:loadTexture(string.format("pvp_ol/gi_rank%d.png", i), ccui.TextureResType.localType)
    else
      imageIndex:setVisible(false)
      labelIndex:setVisible(true)
      labelIndex:setString(string.format("%d-%d", data.minNum, data.maxNum))
    end
    for i = 1, 3 do
      local itemId = data.itemIds[i]
      local itemNum = data.itemNums[i]
      local nodeR = cc.uiloader:seekNodeByName(content, "NodeR" .. i)
      if itemId and itemNum then
        nodeR:setVisible(true)
        nodeR:removeAllChildren()
        local icon = IconItem.new(itemId, itemNum)
        icon:showItemTip()
        nodeR:addChild(icon)
      else
        nodeR:setVisible(false)
      end
    end
    content.item = item
    content.itemPos = i
    item:addContent(content)
    item:setItemSize(605, 130)
    self.mListView:addItem(item)
  end
  self.mListView:reload()
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

return M

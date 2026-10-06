local LayerItem = require("app.layers.LayerItem")
local M = {}
M = class("LayerSummonReward", function()
  return display.newLayer()
end)
M.NORMAL_SUMMON = 2001
M.ADVANCE_SUMMON = 2002
M.VIP_SUMMON = 2003
M.RED_PACKET = 2004

function M:ctor(summonType)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initData(summonType)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData(summonType)
  local poolList = {}
  if M.NORMAL_SUMMON == summonType then
    poolList = CloudData.SUMMON_NORMAL_POOL
  elseif M.ADVANCE_SUMMON == summonType then
    poolList = CloudData.SUMMON_ADVANCE_POOL
  elseif M.VIP_SUMMON == summonType then
    poolList = CloudData.SUMMON_VIP_POOL
  elseif M.RED_PACKET == summonType then
    poolList = CloudData.RED_PACKET_POOL
  end
  local list1 = {}
  local list2 = {}
  for k, v in pairs(poolList) do
    local itemModel = DataUtils.getItemModel(v)
    if 3 == itemModel.itemType then
      table.insert(list1, itemModel)
    else
      table.insert(list2, itemModel)
    end
  end
  table.sort(list1, function(v1, v2)
    if v1.quality == v2.quality then
      return v1.itemId < v2.itemId
    else
      return v1.quality > v2.quality
    end
  end)
  table.sort(list2, function(v1, v2)
    if v1.quality == v2.quality then
      return v1.itemId < v2.itemId
    else
      return v1.quality > v2.quality
    end
  end)
  self.mItemIdList = {list1, list2}
  self.mIconTable = {}
  self.mTabBtnTable = {}
end

function M:initUI()
  self.mBg = display.newSprite("ranking/bg.png"):addTo(self.mNode)
  self:initTabBtn()
  self:initListView(1)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.96, self.mBg:getContentSize().height * 0.93):addTo(self.mBg, 2)
end

function M:initTabBtn()
  local M_TAB_BTN = {
    {
      normal = "summon_scene/tab_piece1.png",
      pressed = "summon_scene/tab_piece1.png",
      disabled = "summon_scene/tab_piece2.png"
    },
    {
      normal = "summon_scene/tab_item1.png",
      pressed = "summon_scene/tab_item1.png",
      disabled = "summon_scene/tab_item2.png"
    }
  }
  for i = 1, #M_TAB_BTN do
    local btn = cc.ui.UIPushButton.new(M_TAB_BTN[i]):onButtonClicked(function()
      self:funcChange(i)
    end):align(display.CENTER_RIGHT, 65, self.mBg:getContentSize().height * (0.9 - i * 0.14)):addTo(self.mBg, 3)
    if 1 == i then
      btn:setButtonEnabled(false)
    end
    table.insert(self.mTabBtnTable, btn)
  end
end

function M:initListView(tag)
  local tb = self.mItemIdList[tag]
  local listFrame = display.newScale9Sprite("common_ui/common_frame11.png", self.mBg:getContentSize().width * 0.5 + 5, self.mBg:getContentSize().height * 0.51, cc.size(800, 500), cc.rect(50, 40, 5, 5)):addTo(self.mBg)
  self.mListFrame = listFrame
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(22, 15, 756, 470),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(listFrame, 2)
  local totalNum = #tb
  local row = math.ceil(totalNum / 6)
  local column = totalNum % 6
  local endNum = 6
  for i = 1, row do
    if i == row and column ~= 0 then
      endNum = column
    end
    local item = listView:newItem()
    local content = display.newNode()
    for count = 1, endNum do
      local itemModel = tb[count + (i - 1) * 6]
      local icon = self:getIconFrame(itemModel)
      icon:setPosition(126 * count - 63, 63)
      content:addChild(icon)
      table.insert(self.mIconTable, itemModel.itemId)
    end
    content:setContentSize(756, 126)
    item:addContent(content)
    item:setItemSize(756, 126)
    listView:addItem(item)
  end
  listView:reload()
end

function M:funcChange(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  for i = 1, #self.mTabBtnTable do
    local tabBtn = self.mTabBtnTable[i]
    if index == i then
      tabBtn:setButtonEnabled(false)
    else
      tabBtn:setButtonEnabled(true)
    end
  end
  if self.mListFrame then
    self.mListFrame:runAction(cc.RemoveSelf:create())
    self.mListFrame = nil
    self.mIconTable = {}
  end
  self:initListView(index)
end

function M:getIconFrame(itemModel)
  local icon = itemModel.itemIcon
  local quality = itemModel.quality
  local itemType = itemModel.itemType
  local iconFrame = display.newSprite("common_ui/frame" .. quality .. ".png")
  local icon = display.newSprite(icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  return iconFrame
end

function M:touchListener(event)
  local lv = event.listView
  if "clicked" == event.name then
    local column = math.ceil(event.point.x / 126)
    local idx = (event.itemPos - 1) * 6 + column
    local id = self.mIconTable[idx]
    if id then
      LayerItem.new(LayerItem.TYPE_LAYER, id):addTo(self, 20)
    end
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:removeSelf()
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

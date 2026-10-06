local DYClass = "LayerServers"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
M.ST_NORMAL = 0
M.ST_MAINTAIN = 1
M.ST_NEW = 2
M.ST_HOT = 3
local STATUS_TEXT = {
  [M.ST_NORMAL] = DYLang.getString("S875", ""),
  [M.ST_MAINTAIN] = DYLang.getString("S876", ""),
  [M.ST_NEW] = DYLang.getString("S877", ""),
  [M.ST_HOT] = DYLang.getString("S878", "")
}
M.STATUS_TEXT = STATUS_TEXT
local STATUS_COLOR = {
  [M.ST_NORMAL] = cc.c3b(0, 196, 14),
  [M.ST_MAINTAIN] = cc.c3b(128, 128, 128),
  [M.ST_NEW] = cc.c3b(0, 196, 14),
  [M.ST_HOT] = cc.c3b(254, 140, 5)
}
M.STATUS_COLOR = STATUS_COLOR

function M:ctor(callback)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mCallback = callback
  DYRes.loadSheet("login_scene/server_module.plist")
  self:initData()
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mHistoryServers = CloudData.HISTORY_SERVERS
  self.mAllServers = CloudData.SERVERS_ARRAY
  self.mSelectedItem = {}
  self.mAllItems = {}
end

function M:initUI()
  self.mBg = display.newSprite("login_scene/server_frame.png"):addTo(self.mNode)
  self:loadHistoryList()
  self:loadAllServersList()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):align(display.CENTER, self.mBg:getContentSize().width * 0.98, self.mBg:getContentSize().height * 0.98):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mBg, 15)
end

function M:loadHistoryList()
  local listFrame = display.newScale9Sprite("#common_frame.png", 205, 295, cc.size(283, 493), cc.rect(20, 20, 1, 1)):addTo(self.mBg)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(10, 10, 263, 473),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(listFrame)
  for i = 1, #self.mHistoryServers do
    local info = self.mHistoryServers[i]
    local item = listView:newItem()
    local content = display.newSprite("#item1.png")
    cc.ui.UILabel.new({
      text = info.name,
      size = 30,
      color = cc.c3b(74, 41, 11),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 60, content:getContentSize().height * 0.52):addTo(content)
    local frame = display.newSprite("#item_level.png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.5):addTo(content)
    cc.ui.UILabel.new({
      text = info.level,
      size = 22,
      color = cc.c3b(248, 222, 167),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, 26, 26):addTo(frame)
    if 1 == i then
      content:setSpriteFrame("item2.png")
      self.mSelectedItem[1] = content
    end
    item:addContent(content)
    item:setItemSize(263, 68)
    listView:addItem(item)
  end
  listView:reload()
end

function M:loadAllServersList()
  local listFrame = display.newScale9Sprite("#common_frame.png", 630, 295, cc.size(537, 493), cc.rect(20, 20, 1, 1)):addTo(self.mBg)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(5, 10, 527, 473),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener1)):addTo(listFrame)
  local totalNum = #self.mAllServers
  local row = math.ceil(totalNum / 2)
  local column = totalNum % 2
  local endNum = 2
  for i = 1, row do
    local item = listView:newItem()
    local content = display.newNode()
    if i == row and 0 < column then
      endNum = column
    end
    for count = 1, endNum do
      local info = self.mAllServers[(i - 1) * 2 + count]
      local frame = display.newSprite("#item1.png")
      cc.ui.UILabel.new({
        text = info.name,
        size = 30,
        color = cc.c3b(74, 41, 11),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER_LEFT, 60, frame:getContentSize().height * 0.52):addTo(frame)
      if 0 < info.status and info.status < 4 then
        display.newSprite("#tip" .. info.status .. ".png"):align(display.CENTER_LEFT, 5, frame:getContentSize().height * 0.55):addTo(frame)
      end
      if CloudData.USER_SERVER_ID == info.id then
        frame:setSpriteFrame("item2.png")
        self.mSelectedItem[2] = frame
      end
      if 1 == info.status then
        frame:setSpriteFrame("item3.png")
      end
      frame:setPosition(263 * count - 131.5, 34)
      content:addChild(frame)
      table.insert(self.mAllItems, frame)
    end
    content:setContentSize(526, 68)
    item:addContent(content)
    item:setItemSize(526, 68)
    listView:addItem(item)
  end
  listView:reload()
end

local function updateFrame(self, tag, itemFrame)
  if self.mSelectedItem[tag] ~= nil then
    self.mSelectedItem[tag]:setSpriteFrame("item1.png")
  end
  if itemFrame then
    itemFrame:setSpriteFrame("item2.png")
    self.mSelectedItem[tag] = itemFrame
  end
end

function M:touchListener(event)
  local lv = event.listView
  if "clicked" == event.name then
    updateFrame(self, 1, event.item:getContent())
    self:confirmServer(self.mHistoryServers[event.itemPos].index)
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  elseif "began" == event.name then
    updateFrame(self, 1, event.item:getContent())
  end
end

function M:touchListener1(event)
  local lv = event.listView
  if "clicked" == event.name then
    local column = math.ceil(event.point.x / 263)
    local idx = 0
    if event.itemPos ~= nil then
      idx = (event.itemPos - 1) * 2 + column
    end
    updateFrame(self, 2, self.mAllItems[idx])
    if self.mAllItems[idx] then
      self:confirmServer(idx)
    end
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  elseif "began" == event.name then
    local column = math.ceil(event.point.x / 263)
    local idx = 0
    if event.itemPos ~= nil then
      idx = (event.itemPos - 1) * 2 + column
    end
    updateFrame(self, 2, self.mAllItems[idx])
  end
end

function M:confirmServer(idx)
  local info = self.mAllServers[idx]
  if not info then
    return
  end
  CloudData.USER_SERVER_ID = info.id
  CloudData.USER_SERVER_INFO = info
  self:performWithDelay(self.closeCallBack, 0.05)
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
  if self.mCallback then
    self.mCallback()
  end
  self:removeSelf()
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYRes.unloadSheet("login_scene/server_module.plist")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

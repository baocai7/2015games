local CLASS_NAME = "LayerUnionBossRecord"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(param)
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mRecordList = param
  self.mBg = nil
  self:initBg()
  self:setNodeEventEnabled(true)
end

function M:initData()
end

function M:initBg()
  local bg = display.newSprite("task/bg.png", 30, 0):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, self.mBg:getContentSize().width, self.mBg:getContentSize().height):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mBg, 1)
  local titleBg = display.newSprite("common_ui/title_frame.png", 500, 660):addTo(bg)
  display.newSprite("union/defence/feed_record_title.png", 217, 49):addTo(titleBg)
  display.newScale9Sprite("common_ui/common_frame11.png", 500, 350, cc.size(860, 518, cc.rect(50, 50, 2, 2))):addTo(self.mBg)
  self:initRecordInfo()
end

function M:initRecordInfo()
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(75, 98, 855, 500),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  for i = #self.mRecordList, 1, -1 do
    local item = list:newItem()
    local content = display.newNode()
    content:setContentSize(855, 50)
    local info = self.mRecordList[i]
    local itemModel = DataUtils.getItemModelWithColor(info.item_id)
    local itemName = itemModel.name
    local itemNum = info.item_count
    local nameColor = itemModel.color
    local nameLabel = DYLabelTTF.new({
      text = checkstring(info.nick),
      size = 25,
      color = cc.c3b(255, 255, 255),
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_LEFT, 40, 20):addTo(content)
    local numberLabel = DYLabelTTF.new({
      text = DYLang.getString("S1688", ""),
      size = 25,
      color = cc.c3b(73, 43, 0, 255),
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 190, 20):addTo(content)
    local itemLabel = DYLabelTTF.new({
      text = itemName,
      size = 25,
      color = nameColor,
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_LEFT, 265, 20):addTo(content)
    DYLabelTTF.new({
      text = checknumber(itemNum) .. DYLang.getString("S1689", ""),
      size = 25,
      color = cc.c3b(30, 255, 0, 255),
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_LEFT, 500, 20):addTo(content)
    item:addContent(content)
    item:setItemSize(855, 50)
    list:addItem(item)
  end
  list:reload()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

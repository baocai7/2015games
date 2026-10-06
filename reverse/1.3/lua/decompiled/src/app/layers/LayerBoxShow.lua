local IconItem = require("app.icons.IconItem")
local CLASS_NAME = "LayerBoxShow"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.BOX_SHOW = 1
M.AWARD_GET = 2

function M:ctor(info, tag, cb)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mBg = nil
  self.mInfo = info or {}
  self.mTag = tag or M.BOX_SHOW
  self.cb = cb
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:initBg()
end

function M:initBg()
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  local cancelLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S511", ""),
    size = 35,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  cancelLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.21):addTo(bg):setButtonLabel("normal", cancelLabel):onButtonClicked(function()
    self:closeCallBack()
  end)
  local img = "stage/box_text.png"
  if self.mTag == M.AWARD_GET then
    img = "stage/award.png"
  end
  display.newSprite(img):align(display.CENTER_LEFT, bg:getContentSize().width * 0.1, bg:getContentSize().height * 0.84):addTo(bg)
  if self.mInfo.tip then
    DYLabelTTF.new({
      text = self.mInfo.tip,
      size = 22,
      color = cc.c3b(53, 255, 6),
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.39, bg:getContentSize().height * 0.84):addTo(bg)
  end
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(514, 150), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.55):addTo(bg)
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(7, 15, 501, 120),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(frame)
  local boxInfo = self.mInfo.boxInfo or {}
  local sum = 1
  for i = 1, #boxInfo do
    local item = list:newItem()
    local content = IconItem.new(boxInfo[i].id, boxInfo[i].num)
    content:showItemTip()
    content:setScale(0.9)
    item:addContent(content)
    item:setItemSize(120, 120)
    list:addItem(item)
  end
  list:reload()
end

function M:closeCallBack()
  if self.cb then
    self.cb()
  end
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

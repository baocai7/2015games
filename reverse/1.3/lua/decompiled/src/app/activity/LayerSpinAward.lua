local IconItem = require("app.icons.IconItem")
local DYClass = "LayerSpinAward"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M:ctor(info, cb)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  if not info or "table" ~= type(info) then
    self:closeCallBack()
    return
  end
  self.mId = checknumber(info.thingId)
  self.mNum = checknumber(info.count)
  self.mItemName = ""
  self.mItemDesc = ""
  self.mCallback = cb
  self:initData()
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  local itemInfo = DataUtils.getItemModel(self.mId)
  if itemInfo then
    self.mItemName = checkstring(itemInfo.itemName)
    self.mItemDesc = checkstring(itemInfo.itemDesc)
  end
  DYAnalyze.item.get(self.mId, self.mItemName, self.mNum, "SPIN")
end

function M:initUI()
  local bg = display.newSprite("spin/frame.png"):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S40", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(147, 78, 1)
  })):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.17):addTo(bg)
  local frame = IconItem.new(self.mId)
  frame:setPosition(bg:getContentSize().width * 0.4, bg:getContentSize().height * 0.78)
  bg:addChild(frame)
  local tipLabel = display.newSprite("spin/label.png", bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.878):addTo(bg)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = self.mItemName,
    size = 24,
    color = display.WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.856):addTo(bg)
  local numLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S41", ""),
    size = 24,
    color = cc.c3b(252, 255, 4),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.715):addTo(bg)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = self.mNum,
    font = "fonts/greenNum.fnt"
  }):scale(0.7):align(display.CENTER_LEFT, numLabel:getPositionX() + 70, numLabel:getPositionY()):addTo(bg)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = self.mItemDesc,
    size = 23,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(410, 100),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.433):addTo(bg)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
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
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

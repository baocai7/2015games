local CLASS_NAME = "LayerPvpRecordUp"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(info)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mRecord = info.record
  self.mIncRecord = info.up
  self.mPeach = info.peach
  local mask = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      return true
    elseif event.name == "ended" then
      self:closeCallBack()
    end
  end)
  self:setTouchEnabled(true)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:initBg()
end

function M:initBg()
  local tip = display.newSprite("pvp/record_bg.png"):addTo(self.mNode)
  display.newSprite("war_result/record.png"):scale(1.2):align(display.CENTER_RIGHT, 560, 186):addTo(tip)
  local recordLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = self.mRecord .. "(",
    font = "fonts/white_num.fnt"
  }):scale(1.2):align(display.CENTER_LEFT, 579, 181):addTo(tip)
  local arrow = display.newSprite("war_result/up.png"):align(display.CENTER_LEFT, recordLabel:getPositionX() + recordLabel:getContentSize().width * 1.2 + 2, 186):addTo(tip)
  local incLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = self.mIncRecord,
    font = "fonts/greenNum.fnt"
  }):scale(0.85):align(display.CENTER_LEFT, arrow:getPositionX() + arrow:getContentSize().width + 2, 186):addTo(tip)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = ")",
    font = "fonts/white_num.fnt"
  }):scale(1.2):align(display.CENTER_LEFT, incLabel:getPositionX() + incLabel:getContentSize().width * 0.85 + 2, 181):addTo(tip)
  display.newSprite("pvp/award.png"):align(display.CENTER_RIGHT, 560, 95):addTo(tip)
  display.newSprite("item_icon/pic_peach.png"):scale(0.85):align(display.CENTER, 605, 95):addTo(tip)
  local recordLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = self.mPeach,
    font = "fonts/greenNum.fnt"
  }):scale(0.85):align(display.CENTER_LEFT, 640, 95):addTo(tip)
end

function M:closeCallBack()
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:runAction(cc.RemoveSelf:create())
  end
  return true
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

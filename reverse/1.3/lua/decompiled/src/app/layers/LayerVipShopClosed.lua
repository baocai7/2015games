local CLASS_NAME = "LayerVipShopClosed"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:initBg()
end

function M:initBg()
  local tip = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(523, 160), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.54):addTo(tip)
  local str = DYLang.getString("S1042", "")
  cc.ui.UILabel.new({
    text = str,
    size = 25,
    color = cc.c3b(66, 49, 29),
    dimensions = cc.size(435, 100),
    align = cc.ui.TEXT_ALIGN_LEFT,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.54):addTo(tip)
  local confirmLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S1043", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  confirmLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):align(display.CENTER, tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.2):addTo(tip, 2):setButtonLabel("normal", confirmLabel):onButtonClicked(function()
    self:closeCallBack()
  end)
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

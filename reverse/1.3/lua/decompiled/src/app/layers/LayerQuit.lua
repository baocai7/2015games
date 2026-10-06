local DYClass = "LayerQuit"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M:ctor()
  DDLOG(DYClass .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mCoreNode = display.newNode()
  self:addChild(self.mCoreNode)
  self:layoutUI()
  self:setNodeEventEnabled(true)
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:hide()
  end
  return true
end

function M:layoutUI()
  local node = self.mCoreNode
  local returnMask = display.newColorLayer(cc.c4b(0, 0, 0, 150))
  self:addChild(returnMask, -1)
  local bg = display.newScale9Sprite("common_ui/common_dialog.png"):pos(display.cx, display.cy):addTo(node, 1)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(523, 160), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.54):addTo(bg)
  cc.ui.UILabel.new({
    text = DYLang.getString("S847", ""),
    size = 30,
    color = cc.c3b(66, 49, 29),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.54):addTo(bg)
  local cancelLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S848", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  cancelLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.2):addTo(bg, 2):setButtonLabel("normal", cancelLabel):onButtonClicked(function()
    self:hide()
  end)
  local confirmLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S849", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  confirmLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.2):addTo(bg, 2):setButtonLabel("normal", confirmLabel):onButtonClicked(function()
    DYCommon.tryQuit(true)
  end)
end

function M:show()
  local node = self.mCoreNode
  DYUtils.setGlobalZOrder(node, 2)
  local scene = display.getRunningScene()
  scene:addChild(self, 2000)
end

function M:hide()
  self:runAction(cc.RemoveSelf:create())
end

return M

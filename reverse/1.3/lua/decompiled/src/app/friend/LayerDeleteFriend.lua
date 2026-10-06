local DYClass = "LayerDeleteFriend"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M:ctor(info, cb)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  self.mCallBack = cb
  self.mInfo = info or {}
  self:layoutUI()
  self:addRegister()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:layoutUI()
  self:addWidget()
end

function M:addWidget()
  local node = self.mNode
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  local tip = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(523, 160), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.54):addTo(tip)
  local str = self.mInfo.text
  cc.ui.UILabel.new({
    text = str,
    size = 30,
    color = cc.c3b(66, 49, 29),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.54):addTo(tip)
  local cancelLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S616", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  cancelLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):align(display.CENTER, tip:getContentSize().width * 0.3, tip:getContentSize().height * 0.2):addTo(tip, 2):setButtonLabel("normal", cancelLabel):onButtonClicked(function()
    self:closeCallBack()
  end)
  local confirmLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S617", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  confirmLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):align(display.CENTER, tip:getContentSize().width * 0.7, tip:getContentSize().height * 0.2):addTo(tip, 2):setButtonLabel("normal", confirmLabel):onButtonClicked(function()
    self:toDelete()
  end)
end

function M:toDelete()
  local param = {
    receiver = checknumber(self.mInfo.uid),
    uid = CloudData.UID
  }
  self:safeSocketRequest("CMD_FRIEND_DELETE", param)
  self:delete()
end

function M:delete()
  local toast = WSToast.new(DYLang.getString("S618", ""), 2)
  display.getRunningScene():addChild(toast, 20)
  self:closeCallBack(1)
end

function M:addRegister()
end

function M:closeCallBack(tag)
  self:runAction(cc.RemoveSelf:create())
  if self.mCallBack then
    self.mCallBack(tag)
  end
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
  DYNotification.removeAllObservers(self)
end

return M

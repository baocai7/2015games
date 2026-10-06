local DYClass = "LayerToAddFriend"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M.scene(cb)
  local scene = display.newScene()
  scene:addChild(M.new(cb))
  return scene
end

function M:ctor(uid, callback, index)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callback
  self.mIndex = checknumber(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mUid = checkstring(uid)
  self.mNickInput = nil
  self.mCanBeClicked = false
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("common_ui/common_dialog.png", 0, 0):addTo(self.mNode)
  display.newSprite("friends/title_friend_apply.png", 299, 355):addTo(bg)
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_WAIT_ADD_TIP", ""),
    size = 30,
    color = cc.c3b(63, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 91, 279):addTo(bg)
  display.newScale9Sprite("friends/img_input.png", 299, 208, cc.size(411, 66), cc.rect(33, 33, 1, 1)):addTo(bg)
  local input = cc.ui.UIInput.new({
    image = "common_ui/img_square.png",
    size = cc.size(385, 40),
    x = 299,
    y = 208
  })
  input:setColor(cc.c3b(255, 246, 220))
  input:setPlaceHolder(DYLang.getString("STR_APPEND_MSG", ""))
  input:setPlaceholderFontColor(cc.c3b(151, 105, 87))
  input:setPlaceholderFontName(GameManager.FONTNAME_TTF)
  input:setPlaceholderFontSize(24)
  input:setFontColor(cc.c3b(80, 30, 0))
  input:setFontName(GameManager.FONTNAME_TTF)
  input:setFontSize(24)
  input:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  self.mNickInput = input
  bg:addChild(input)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, 165, 93):addTo(bg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S567", ""),
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  })):onButtonClicked(function()
    self:closeCallBack()
  end)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, 446, 93):addTo(bg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S574", ""),
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  })):onButtonClicked(function()
    self:confirm()
  end)
end

function M:confirm()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local text = self.mNickInput:getText()
  local str = text == "" and DYLang.getString("STR_APPEND_MSG", "") or text
  local param = {
    receiver = self.mUid,
    uid = CloudData.UID,
    desc = str
  }
  self:safeSocketRequest("CMD_FRIEND_TO_ADD", param)
  self:closeCallBack(self.mIndex)
end

function M:closeCallBack(tag)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
  if self.mCallback then
    self.mCallback(tag)
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
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

local CLASS_NAME = "LayerCommonAlert"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(params, callbcak)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callbcak
  self.mType = params.type or 1
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:initUI(params)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI(params)
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  self.mBg = bg
  self:loadCommonContent(params)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\229\143\150  \230\182\136",
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {})):onButtonClicked(function()
    self:closeCallBack(false)
  end):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.22):addTo(bg)
end

function M:loadCommonContent(params)
  DYLabelTTF.new({
    text = params.text,
    size = 30,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dimensions = cc.size(500, 160),
    align = cc.ui.TEXT_ALIGN_LEFT
  }):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.52):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\231\161\174  \229\174\154",
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {})):onButtonClicked(function()
    self:closeCallBack(true)
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.7, self.mBg:getContentSize().height * 0.22):addTo(self.mBg)
end

function M:closeCallBack(flag)
  if self.mCallback then
    self.mCallback(flag)
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create(true))
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack(false)
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

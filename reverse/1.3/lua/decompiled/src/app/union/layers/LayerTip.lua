local CLASS_NAME = "LayerTip"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(text, cb, params)
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mText = checkstring(text)
  self.cb = cb
  self.mParams = params
  self:initBg()
  self:setNodeEventEnabled(true)
end

function M:initBg()
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(514, 150), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, 218):addTo(bg)
  if #self.mText > 45 then
    cc.ui.UILabel.new({
      text = self.mText,
      size = 25,
      align = cc.ui.TEXT_ALIGN_CENTER,
      dimensions = cc.size(480, 80),
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, bg:getContentSize().width * 0.5, 218):addTo(bg)
  else
    cc.ui.UILabel.new({
      text = self.mText,
      size = 25,
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, bg:getContentSize().width * 0.5, 218):addTo(bg)
  end
  local confirmBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.5, 79):addTo(bg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1653", ""),
    size = 32,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:confirm()
  end)
  if self.cb then
    confirmBtn:setPositionX(183)
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }):align(display.CENTER, 423, 79):addTo(bg):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("S1654", ""),
      size = 32,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(25, 30, 3)
    })):onButtonClicked(function()
      self:closeCallBack()
    end)
  end
end

function M:confirm()
  if self.cb then
    self.cb(self.mParams)
  end
  self:closeCallBack()
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

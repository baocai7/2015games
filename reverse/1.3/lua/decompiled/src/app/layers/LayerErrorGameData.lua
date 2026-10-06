local CLASS_NAME = "LayerErrorGameData"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(text)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mText = text or DYLang.getString("S628", "")
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:initUI()
end

function M:initUI()
  local bg = display.newSprite("connection/bg.png"):addTo(self.mNode)
  local textLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = self.mText,
    dimensions = cc.size(300, 90),
    align = cc.ui.TEXT_ALIGN_CENTER,
    size = 30,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.56):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S629", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height / 4):addTo(bg)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
  display.replaceScene(require("scenes.ChapterScene").new())
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

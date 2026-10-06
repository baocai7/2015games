local ForceUpdateLayer = {}
ForceUpdateLayer = class("ForceUpdateLayer", function()
  return display.newLayer()
end)

function ForceUpdateLayer:ctor()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.node = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  local title = DYLang.getString("S423", "")
  local message = DYLang.getString("S424", "")
  local bg = display.newSprite("common_ui/common_bg.png"):addTo(self.node)
  cc.ui.UILabel.new({
    text = title,
    size = 34,
    color = display.COLOR_BLACK,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.79):addTo(bg)
  cc.ui.UILabel.new({
    text = message,
    size = 30,
    color = display.COLOR_BLACK,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(490, 110),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.52):addTo(bg)
  local str = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S425", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  str:enableOutline(cc.c4b(147, 78, 1, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.9):setButtonLabel("normal", str):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.22):onButtonClicked(function()
    cc.Director:getInstance():endToLua()
  end):addTo(bg, 2)
end

return ForceUpdateLayer

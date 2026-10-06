local WSToast = {}
WSToast = class("WSToast", function()
  return display.newNode()
end)

function WSToast:ctor(textStr, time)
  textStr = textStr or ""
  local lab = cc.ui.UILabel.new({
    text = textStr,
    size = 24,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER):addTo(self, 2)
  local width = lab:getContentSize().width + 40
  local toast = display.newScale9Sprite("common_ui/toast.png", 0, 0, cc.size(width, 60), cc.rect(20, 20, 1, 1)):addTo(self, 1)
  self:setPosition(display.cx, display.cy)
  local delayTime = time or 1.5
  local popupLayer = transition.sequence({
    cc.DelayTime:create(delayTime),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self:runAction(popupLayer)
end

return WSToast

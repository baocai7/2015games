local ConnectionLayer = class("ConnectionLayer", function()
  return display.newLayer()
end)

function ConnectionLayer:ctor()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.emptyNode_ = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.emptyNode_:runAction(popupLayer)
  self:initUI_()
end

function ConnectionLayer:initUI_()
  local bg = display.newSprite("connection/loading_bg.png", 0, 0):addTo(self.emptyNode_)
  local circle = display.newSprite("connection/loading.png", bg:getContentSize().width / 5, bg:getContentSize().height / 2):addTo(bg)
  circle:runAction(cc.RepeatForever:create(cc.RotateBy:create(0.5, 90)))
end

return ConnectionLayer

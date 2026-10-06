local GuideStage8Layer = class("GuideStage8Layer", function()
  return display.newLayer()
end)

function GuideStage8Layer:ctor()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.emptyNode_ = display.newNode()
  self.emptyNode_:setPosition(display.cx, display.cy)
  self:addChild(self.emptyNode_)
  self.emptyNode_:setScale(0)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.emptyNode_:runAction(popupLayer)
  self:initUI_()
end

function GuideStage8Layer:initUI_()
  self.guideBtn1_ = cc.ui.UIPushButton.new({
    normal = "novice_guide/card1.png",
    pressed = "novice_guide/card1.png"
  }):align(display.CENTER, 0, 0):onButtonClicked(function()
    self:toNextGuide_()
  end):addTo(self.emptyNode_)
  self.guideBtn2_ = cc.ui.UIPushButton.new({
    normal = "novice_guide/card2.png",
    pressed = "novice_guide/card2.png"
  }):align(display.CENTER, 0, 0):onButtonClicked(function()
    self:closeCallBack_()
  end):hide():addTo(self.emptyNode_)
end

function GuideStage8Layer:toNextGuide_()
  self.guideBtn1_:removeSelf()
  self.guideBtn2_:show()
end

function GuideStage8Layer:closeCallBack_()
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.emptyNode_:runAction(popupLayer)
end

return GuideStage8Layer

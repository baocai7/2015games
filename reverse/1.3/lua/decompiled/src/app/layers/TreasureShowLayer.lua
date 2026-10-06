local TreasureShowLayer = class("TreasureShowLayer", function()
  return display.newLayer()
end)

function TreasureShowLayer:ctor(treasureId)
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
  self:initUI_(treasureId)
end

function TreasureShowLayer:initUI_(treasureId)
  local bg = display.newSprite("sign/frame.png"):addTo(self.emptyNode_)
  local tipLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S1124", ""),
    size = 30,
    color = cc.c3b(63, 31, 4),
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(240, 100),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.68, bg:getContentSize().height * 0.63):addTo(bg)
  local treasurePic = display.newSprite(string.format("treasure/icon%d.png", treasureId), bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.6):addTo(bg)
  local treasureName = display.newSprite(string.format("treasure/treasure%d_name.png", treasureId), bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.2):scale(0.75):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "sign/known.png",
    pressed = "sign/known_h.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.65, bg:getContentSize().height * 0.25):onButtonClicked(function()
    self:closeCallBack_()
  end):addTo(bg)
end

function TreasureShowLayer:closeCallBack_()
  display.replaceScene(require("scenes.TreasureScene").new())
end

return TreasureShowLayer

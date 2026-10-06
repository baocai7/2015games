local DYClass = "LayerCompeteAlert"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M:ctor(time)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mEmptyNode = display.newNode()
  self.mEmptyNode:setPosition(display.cx, display.cy)
  self:addChild(self.mEmptyNode)
  self.mEmptyNode:setScale(0)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mEmptyNode:runAction(popupLayer)
  self.mTime = time
  self:initUI()
end

function M:initUI()
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mEmptyNode)
  local text1 = cc.ui.UILabel.new({
    text = DYLang.getString("S1154", ""),
    size = 30,
    color = cc.c3b(55, 23, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.6):addTo(bg)
  self.mTimeLabel = cc.ui.UILabel.new({
    text = string.format("00:%02d", self.mTime),
    size = 30,
    color = cc.c3b(55, 23, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.4):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1155", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallback()
  end):align(display.CENTER, bg:getContentSize().width * 0.32, bg:getContentSize().height * 0.2):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1156", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:safeSocketRequest("CMD_PVP_INIT_DATA")
    display.replaceScene(require("app.pvponline.LayerCompeteInfo").new())
  end):align(display.CENTER, bg:getContentSize().width * 0.68, bg:getContentSize().height * 0.2):addTo(bg)
  self.mSchedule = self:schedule(function()
    self:updateTime()
  end, 1)
end

function M:updateTime()
  if self.mTime > 0 then
    self.mTime = self.mTime - 1
  else
    self:stopAction(self.mSchedule)
    self.mSchedule = nil
    self:closeCallback()
  end
  self.mTimeLabel:setString(string.format("00:%02d", self.mTime))
end

function M:closeCallback()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.mEmptyNode:runAction(popupLayer)
end

return M

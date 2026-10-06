local ErrorCodeLayer = class("ErrorCodeLayer", function()
  return display.newLayer()
end)

function ErrorCodeLayer:ctor(errCode, errMsg, callback)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYTouchMaskLayer.new():addTo(self, -1)
  self.emptyNode_ = display.newNode()
  self.emptyNode_:setPosition(display.cx, display.cy)
  self:addChild(self.emptyNode_)
  self.emptyNode_:setScale(0)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.emptyNode_:runAction(popupLayer)
  self.mCallback = callback
  self:initUI_(errCode, errMsg)
end

function ErrorCodeLayer:initUI_(errCode, errMsg)
  local bg = display.newSprite("connection/bg.png"):addTo(self.emptyNode_)
  local text1 = cc.ui.UILabel.new({
    UILabelType = 2,
    text = string.format(DYLang.getString("S421", ""), errCode),
    size = 30,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.6):addTo(bg)
  if 600 == errCode then
    text1:setString(DYLang.getString("S422", ""))
  end
  if errMsg and type(errMsg) == "string" and string.len(errMsg) > 0 then
    text1:setString(errMsg)
  end
  local cb = handler(self, self.restart)
  local param = {
    nImage = "connection/restart.png",
    pImage = "connection/restart1.png",
    listener = cb,
    scale = 0.98
  }
  param.title = ""
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(bg:getContentSize().width * 0.5, bg:getContentSize().height / 4))
  bg:addChild(button, 1)
end

function ErrorCodeLayer:restart()
  if self.mCallback then
    self.mCallback()
  else
    cc.Director:getInstance():endToLua()
    if device.platform == "windows" or device.platform == "mac" or device.platform == "ios" then
      os.exit()
    end
  end
end

function ErrorCodeLayer:closeCallback()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
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

return ErrorCodeLayer

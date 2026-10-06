local SurveyLayer = class("SurveyLayer", function()
  return display.newLayer()
end)

function SurveyLayer:ctor()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.node_ = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  self.node_:setAnchorPoint(0.5, 0.5)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.node_:runAction(popupLayer)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initUI_()
end

function SurveyLayer:initUI_()
  self.bg_ = display.newSprite("survey/bg.png"):addTo(self.node_)
  if device.platform == "android" or device.platform == "ios" then
    local size = self.bg_:getContentSize()
    local webView = ccui.WebView.create()
    self.m_webView = webView
    webView:loadURL("http://www.baidu.com")
    webView:setScalesPageToFit(true)
    self.bg_:addChild(webView, 1, 1)
    webView:setAnchorPoint(cc.p(0.5, 0.5))
    webView:setPosition(size.width / 2, size.height / 2)
    webView:setContentSize(size.width * 0.9, size.height * 0.9)
  end
  self.closeBtn_ = cc.ui.UIPushButton.new("survey/close.png"):align(display.CENTER, self.bg_:getContentSize().width * 0.98, self.bg_:getContentSize().height * 0.98):onButtonClicked(function()
    self:closeCallBack_()
  end):scale(0.65):addTo(self.bg_, 5)
end

function SurveyLayer:closeCallBack_()
  if device.platform == "ios" or device.platform == "android" then
    self.bg_:removeChild(self.m_webView)
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.node_:runAction(popupLayer)
end

return SurveyLayer

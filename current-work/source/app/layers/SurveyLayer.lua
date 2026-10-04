--
--问卷调查界面
--

local SurveyLayer  =  class("SurveyLayer", function()
    return display.newLayer()
end)

function SurveyLayer:ctor()
    --背景
    display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1)

    --空节点
    self.node_ = display.newNode()
        :scale(0)
        :pos(display.cx, display.cy)
        :addTo(self,1)
    self.node_:setAnchorPoint(0.5, 0.5)

    --添加触摸事件
    -- self.node_:setTouchEnabled(true)
    -- self.node_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --     return  self:closeCallBack_(event.name,event.x,event.y)
    -- end)

    --添加空白图扩充点击区域
    -- local emptyLayer = display.newColorLayer(cc.c4b(255,255,255,0))
    -- emptyLayer:setAnchorPoint(0.5,0.5)
    -- emptyLayer:setContentSize(cc.size(display.width,display.height))
    -- self.node_:addChild(emptyLayer,-1)

    local popupLayer = transition.sequence(
        {cc.ScaleTo:create(0.2, 1.1),
            cc.ScaleTo:create(0.1, 1.0)})
    self.node_:runAction(popupLayer)

    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
    end

    self:initUI_()
end

function SurveyLayer:initUI_()
    self.bg_ = display.newSprite("survey/bg.png"):addTo(self.node_)

    -- ccui.WebView 只能适用于android与ios平台
    if device.platform == "android" or device.platform == "ios" then
        local size = self.bg_:getContentSize()
        local webView = ccui.WebView.create()
        self.m_webView = webView
        webView:loadURL("http://www.baidu.com")
        webView:setScalesPageToFit(true)
        self.bg_:addChild(webView,1,1)
        webView:setAnchorPoint(cc.p(0.5, 0.5))
        webView:setPosition(size.width/2,size.height/2)
        webView:setContentSize(size.width * 0.9,size.height * 0.9)
    end

    --关闭按钮
    self.closeBtn_ = cc.ui.UIPushButton.new("survey/close.png")
        :align(display.CENTER, self.bg_:getContentSize().width * 0.98,self.bg_:getContentSize().height * 0.98)
        :onButtonClicked(function()
            self:closeCallBack_()           
        end)
        :scale(0.65)
        :addTo(self.bg_,5)
    --self.closeBtn_:setTouchSwallowEnabled(false)
end

function SurveyLayer:closeCallBack_()
    if device.platform == "ios" or device.platform == "android" then
        self.bg_:removeChild(self.m_webView)
    end

    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
    end

    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
    })
    self.node_:runAction(popupLayer)
end

return SurveyLayer
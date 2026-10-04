--
--提示蟠桃不足界面
--
local PaymentLayer  = import("layers.PaymentLayer")

local AlertLackPeachLayer = class("AlertLackPeachLayer", function ()
    return display.newLayer()
end)

function AlertLackPeachLayer:ctor()
    --添加遮罩层
    self.mask = display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1)

    --初始化基础节点
    self.node = display.newNode()
        :scale(0)
        :pos(display.cx, display.cy)
        :addTo(self,1)

    --弹出效果
    local popupLayer = transition.sequence(
        {cc.ScaleTo:create(0.2, 1.1),
            cc.ScaleTo:create(0.1, 1.0)})
    self.node:runAction(popupLayer)

    --初始化界面
    self:initUI_()
end

function AlertLackPeachLayer:initUI_()
    --背景
    local bg = display.newSprite("common_ui/common_bg.png")
        :addTo(self.node)

    --文字标签
    cc.ui.UILabel.new({UILabelType = 2,text = "蟠桃不足，确定去购买？",size = 30,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.56)
        :addTo(bg)

    --确定按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :scale(0.85)
        :pos(bg:getContentSize().width * 0.33,bg:getContentSize().height * 0.25)
        :onButtonClicked(function()
            self:confirmCallBack_()
        end)
        :addTo(bg)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "activity/close.png",pressed = "activity/close_h.png"})
        :scale(0.9)
        :pos(bg:getContentSize().width * 0.67,bg:getContentSize().height * 0.25)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :addTo(bg)
end

function AlertLackPeachLayer:confirmCallBack_()
    self:closeCallBack_()
    local currScene = display.getRunningScene()
    local layer = PaymentLayer.new()
    currScene:addChild(layer,100)

    --DataEye统计
    if USE_DATAEYE  then
        DCEvent.onEvent("goto_peach_payment")
    end
end

--弹窗关闭
function AlertLackPeachLayer:closeCallBack_()
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
    })
    self.node:runAction(popupLayer)
end

return AlertLackPeachLayer
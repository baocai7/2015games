--
--提示经验不足界面
--
local WSToast = import("utils.WSToast")

local AlertLackEXPLayer = class("AlertLackEXPLayer", function ()
    return display.newLayer()
end)

function AlertLackEXPLayer:ctor()
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

function AlertLackEXPLayer:initUI_()
    --背景
    local bg = display.newSprite("common_ui/common_bg.png")
        :addTo(self.node)

    --文字标签
    cc.ui.UILabel.new({UILabelType = 2,text = "经验不足，确定去商店购买？",size = 30,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
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

function AlertLackEXPLayer:confirmCallBack_()
    if CloudData.STAGE_PROGRESS < 6 then
        local t = WSToast.new("商店第6关以后开启！", 1.5)
        self:addChild(t, 20)
        self:closeCallBack_()
    else
        self:removeSelf()
        display.replaceScene(require("scenes.ShopScene1").new(SHOP_TYPE_EXP_MALL))

        --DataEye统计
        if USE_DATAEYE then
            DCEvent.onEvent("goto_exp_exchange")
        end
    end
end

--弹窗关闭
function AlertLackEXPLayer:closeCallBack_()
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
    })
    self.node:runAction(popupLayer)
end

return AlertLackEXPLayer
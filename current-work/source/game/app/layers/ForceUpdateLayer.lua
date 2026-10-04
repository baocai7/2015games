--
--强制更新弹窗
--

local ForceUpdateLayer = {} 
ForceUpdateLayer = class("ForceUpdateLayer", function ()
    return display.newLayer()
end)

function ForceUpdateLayer:ctor()   
    --添加遮罩层
    display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1)
    
    --初始化基础节点   
    self.node = display.newNode()
        :pos(display.cx, display.cy)
        :addTo(self,1)

    local title = "版本更新"
    local message = "发现新版本，前往商店赶紧更新吧。更多精彩，就等您来！"

    local bg = display.newSprite("common_ui/common_bg.png"):addTo(self.node)
    cc.ui.UILabel.new({
        text = title ,size = 34,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.79)
        :addTo(bg)

    cc.ui.UILabel.new({
        text = message, size = 30,color = display.COLOR_BLACK,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(490,110),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.52)
        :addTo(bg)

    --确定按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :scale(0.9)
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.22)
        :onButtonClicked(function()
            cc.Director:getInstance():endToLua()
        end)
        :addTo(bg,2)  
end

return ForceUpdateLayer
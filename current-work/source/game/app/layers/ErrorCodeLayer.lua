
--[[=============================================================================
#     FileName: ErrorCodeLayer.lua
#         Desc: 联网异常时反馈的错误信息
#       Author: Hoo
#   LastChange: 2015-05-06 
#      History:
=============================================================================]]

local ErrorCodeLayer = class("ErrorCodeLayer", function()
	return display.newLayer()
end)

function ErrorCodeLayer:ctor( errCode )
	--添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

	--初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.cy)
	self:addChild(self.emptyNode_)

	--弹出效果
	self.emptyNode_:setScale(0)
	local popupLayer = transition.sequence(
		{cc.ScaleTo:create(0.2, 1.1),
		cc.ScaleTo:create(0.1, 1.0)})
	self.emptyNode_:runAction(popupLayer)

   --初始化界面
   self:initUI_( errCode )
end

--初始化UI
function ErrorCodeLayer:initUI_( errCode )
    -- 背景
    local bg = display.newSprite("connection/bg.png"):addTo(self.emptyNode_)

    -- 文字说明
    local text1 = cc.ui.UILabel.new({UILabelType = 2,text = "数据异常,请重启游戏",size = 30,color = display.COLOR_WHITE,
        font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.75)
        :addTo(bg)

    local text2 = cc.ui.UILabel.new({UILabelType = 2,text = string.format("错误代码:%d",errCode),size = 30,color = display.COLOR_WHITE,
        font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.50)
        :addTo(bg)

    -- 重启按钮
    cc.ui.UIPushButton.new({normal = "connection/restart.png",pressed = "connection/restart1.png"})
        :onButtonClicked(function()
            cc.Director:getInstance():endToLua()
            if device.platform == "windows" or device.platform == "mac" or device.platform == "ios" then
                os.exit()
            end
        end)
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height /4)
        :addTo(bg)
end

return ErrorCodeLayer
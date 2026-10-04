--
--当有宝物收集完全时,章节界面弹窗引导点击进入宝物界面
--

local TreasureShowLayer = class("TreasureShowLayer", function()
	return display.newLayer()
end)

function TreasureShowLayer:ctor(treasureId)
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
   self:initUI_(treasureId)
end

--首充UI
function TreasureShowLayer:initUI_(treasureId)
    --背景
    local bg = display.newSprite("sign/frame.png")
        :addTo(self.emptyNode_)
    -- bg:setTouchEnabled(true)
    -- bg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --     return self:onTouch(event.name,event.x,event.y)
    -- end)

    --tip描述("宝物已成功激活.......")
    local tipLabel = cc.ui.UILabel.new({UILabelType = 2,text = "宝物已成功激活!可前往宝物界面查看详细信息!",size = 30,color = cc.c3b(63,31,4),
        align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(240,100),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.68,bg:getContentSize().height * 0.63)
        :addTo(bg)

    --宝物图片显示
    local treasurePic = display.newSprite(string.format("treasure/icon%d.png",treasureId),bg:getContentSize().width * 0.25,bg:getContentSize().height * 0.6)  
        :addTo(bg)
    
    --宝物名称显示
    local treasureName = display.newSprite(string.format("treasure/treasure%d_name.png",treasureId),bg:getContentSize().width * 0.25,bg:getContentSize().height * 0.2)  
        :scale(0.75)
        :addTo(bg)
    
    --关闭按钮
    cc.ui.UIPushButton.new({normal = "sign/known.png",pressed = "sign/known_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.65,bg:getContentSize().height * 0.25)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :addTo(bg)
end

function TreasureShowLayer:closeCallBack_()
    display.replaceScene(require("scenes.TreasureScene").new())
end
--点击事件的判断
-- function TreasureShowLayer:onTouch(event,x,y)
--     if event == "began" then
--         display.replaceScene(import(".TreasureScene").new())
--         return true
--     end
-- end

return TreasureShowLayer
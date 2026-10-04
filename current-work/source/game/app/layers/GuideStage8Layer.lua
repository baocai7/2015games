--
--活动码,兑换码等数据处理
--

local GuideStage8Layer = class("GuideStage8Layer", function()
	return display.newLayer()
end)

function GuideStage8Layer:ctor()
	--添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

	--初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.cy)
	self:addChild(self.emptyNode_)

    --游戏暂停
    operateAllSchedulerAndActions(display.getRunningScene(),"PAUSE")

	--弹出效果
	self.emptyNode_:setScale(0)
	local popupLayer = transition.sequence(
		{cc.ScaleTo:create(0.2, 1.1),
		cc.ScaleTo:create(0.1, 1.0)})
	self.emptyNode_:runAction(popupLayer)

   --初始化界面
   self:initUI_()
end

--初始化UI
function GuideStage8Layer:initUI_()
   --第一张卡片
    self.guideBtn1_ =  cc.ui.UIPushButton.new({normal = "novice_guide/card1.png",pressed = "novice_guide/card1.png"})
        :align(display.CENTER,0,0)
        :onButtonClicked(function()
            self:toNextGuide_()
        end)
        :addTo(self.emptyNode_)

    --    
    self.guideBtn2_ =  cc.ui.UIPushButton.new({normal = "novice_guide/card2.png",pressed = "novice_guide/card2.png"})
        :align(display.CENTER,0,0)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :hide()
        :addTo(self.emptyNode_)
end

function GuideStage8Layer:toNextGuide_()
    self.guideBtn1_:removeSelf()
    self.guideBtn2_:show()
end

function GuideStage8Layer:closeCallBack_()
    --游戏恢复
    operateAllSchedulerAndActions(display.getRunningScene(),"RESUME")

    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.emptyNode_:runAction(popupLayer)
end

return GuideStage8Layer
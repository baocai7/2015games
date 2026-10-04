--
--第三关引导自动出兵
--

local GuideStage3Layer = class("GuideStage3Layer", function()
	return display.newLayer()
end)

function GuideStage3Layer:ctor( flag )
	--添加遮罩层
	self.gray_ = display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

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
   self:initUI_(flag)
end

--初始化UI
function GuideStage3Layer:initUI_(flag)
    local path = string.format("novice_guide/auto_guide%d.png",flag)
    cc.ui.UIPushButton.new({normal = path,pressed = path})
        :align(display.CENTER,0,0)
        :onButtonClicked(function()
            self:guideCallBack_(flag)
        end)
        :addTo(self.emptyNode_)
end

function GuideStage3Layer:guideCallBack_(flag)
    local icon = Game.TEAM_ICON[1]
    if flag == 1 then
        icon:changeAutoMode(100)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_AUTO1",true)
    else
        icon:changeAutoMode(-100)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_AUTO2",true)
    end
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

return GuideStage3Layer
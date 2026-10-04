 
local WSToast = import("utils.WSToast")

ACTIVITY_TYPE_ODD = 1
ACTIVITY_TYPE_EVEN = 2
ACTIVITY_TYPE_SUNDAY = 3

local DiarytasklevelLayer  =  class("DiarytasklevelLayer", function()
	return display.newLayer()
end)

function DiarytasklevelLayer:ctor(activityType)
	--添加遮罩层
	self.mask = display.newColorLayer(cc.c4b(0,0,0,175))
	self:addChild(self.mask,20)

	--初始化基础节点
	self.node = display.newNode()
	self.node:setPosition(display.cx,display.cy)
	self:addChild(self.node,20)
	
	--弹出效果	
	self.node:setScale(0)
	local popupLayer = transition.sequence(
		{cc.ScaleTo:create(0.2, 1.1),
		cc.ScaleTo:create(0.1, 1.0)})
	self.node:runAction(popupLayer)

	--init
	self:initData(activityType)
end

function DiarytasklevelLayer:initData(activityType)
	self.activityType_ = activityType
	self.stageProgress_ = CloudData.STAGE_PROGRESS
	if tonumber(CloudData.DIARY_NUM_LEFT) < 0 then
		self.restTimes_ = 0
	else
		self.restTimes_ = CloudData.DIARY_NUM_LEFT
	end
	if self.stageProgress_ < 41 then
		self.mode_ = 1
	elseif self.stageProgress_ >= 61 then
		self.mode_ = 3
	else
		self.mode_ = 2
	end
	
	self:initUI_(activityType)
end

function DiarytasklevelLayer:initUI_(activityType)
	--背景
	self.bg_ = display.newSprite("Diary/alert_frame.png")
	self.node:addChild(self.bg_,20)
	
	cc.ui.UILabel.new({
        text = "今日剩余次数：",size = 32,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 1.1)
        :addTo(self.bg_)
		
	cc.ui.UILabel.new({
        text = self.restTimes_,size = 34,align = cc.ui.TEXT_ALIGN_LEFT,color = display.COLOR_GREEN, dimensions = cc.size(85,40),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.628, self.bg_:getContentSize().height * 1.095)
        :addTo(self.bg_)
		
	--普通模式
	self.normal_ = display.newSprite("Diary/normal_icon.png")
		:pos(self.bg_:getContentSize().width * 0.25,self.bg_:getContentSize().height * 0.5)
		:addTo(self.bg_)
		self.normal_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
				return self:selectMode(event.name, 1)			
			end)
		self.normal_:setTouchEnabled(true)
	
	--困难模式
	self.hard_ = display.newSprite("Diary/hard_icon.png")
		:pos(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
		:addTo(self.bg_)
		self.hard_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
				return self:selectMode(event.name, 2)			
			end)
		self.hard_:setTouchEnabled(true)
	
	if self.mode_ == 1 then
		local mask = display.newSprite("summon_scene/gray.png")
		:scale(25/33)
			:pos(self.hard_:getContentSize().width*0.5,self.hard_:getContentSize().height*0.5)
			:addTo(self.hard_,10)
			--mask:setContentSize(self.hard_:getContentSize().width, self.hard_:getContentSize().height)
			mask:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
				local t = WSToast.new("41关开启",1)
				self:addChild(t, 20)
			end)
			mask:setTouchEnabled(true)
	end
	
	--变态模式
	self.awful_ = display.newSprite("Diary/awful_icon.png")
		:pos(self.bg_:getContentSize().width * 0.75,self.bg_:getContentSize().height * 0.5)
		:addTo(self.bg_)
		self.awful_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
				return self:selectMode(event.name, 3)			
			end)
		self.awful_:setTouchEnabled(true)	
	
	if self.mode_ < 3 then
		local mask = display.newSprite("summon_scene/gray.png")
			:scale(25/33)
			--:scaleY(25/33)
			:pos(self.awful_:getContentSize().width*0.5,self.awful_:getContentSize().height*0.5)
			:addTo(self.awful_,10)
			--mask:setContentSize(self.awful_:getContentSize().width, self.awful_:getContentSize().height)
			mask:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
				local t = WSToast.new("61关开启",1)
				self:addChild(t, 20)
			end)
			mask:setTouchEnabled(true)
	end
			
	self.frame1 = display.newSprite("Diary/brown.png")
		:scale(0.45)
		:pos(self.normal_:getContentSize().width * 0.5,self.normal_:getContentSize().height * 0.16)
		:addTo(self.normal_)
		
	self.frame2 = display.newSprite("Diary/purple.png")
		:scale(0.45)
		:pos(self.hard_:getContentSize().width * 0.37,self.hard_:getContentSize().height * 0.16)
		:addTo(self.hard_)
		
	self.frame3 = display.newSprite("Diary/blue.png")
		:scale(0.45)
		:pos(self.awful_:getContentSize().width * 0.37,self.awful_:getContentSize().height * 0.16)
		:addTo(self.awful_)

	if activityType == ACTIVITY_TYPE_ODD then
		self:initEXPUI_()
	elseif activityType == ACTIVITY_TYPE_EVEN then
		self:initPIECEUI_()
	else
		self:initPEACHUI_()
	end
	--关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
    :onButtonClicked(function()
    	self:closeCallBack_()
    end)
    :align(display.CENTER,self.bg_:getContentSize().width * 0.92,self.bg_:getContentSize().height * 0.94)
	:scale(0.8)
    :addTo(self.bg_,20)
end

function DiarytasklevelLayer:initEXPUI_()
	self.pic1_ = "Diary/exp.png"
	self.pic2_ = "Diary/exp.png"
	self.pic4_ = "Diary/stone.png"
	self.pic3_ = "Diary/exp.png"
	self.pic5_ = "Diary/several_stone.png"
	
	display.newSprite(self.pic1_)
		:pos(self.frame1:getContentSize().width * 0.5,self.frame1:getContentSize().height * 0.5)
		:addTo(self.frame1)
		
	display.newSprite(self.pic2_)
		:pos(self.frame2:getContentSize().width * 0.5,self.frame2:getContentSize().height * 0.5)
		:addTo(self.frame2)
		
	display.newSprite(self.pic3_)
		:pos(self.frame3:getContentSize().width * 0.5,self.frame3:getContentSize().height * 0.5)
		:addTo(self.frame3)
	
	self.frame4 = display.newSprite("Diary/brown.png")
		:scale(0.45)
		:pos(self.hard_:getContentSize().width * 0.63,self.hard_:getContentSize().height * 0.16)
		:addTo(self.hard_)
	
	display.newSprite(self.pic4_)
		:pos(self.frame4:getContentSize().width * 0.5,self.frame4:getContentSize().height * 0.5)
		:addTo(self.frame4)
			
	self.frame5 = display.newSprite("Diary/brown.png")
		:scale(0.45)
		:pos(self.awful_:getContentSize().width * 0.63,self.awful_:getContentSize().height * 0.16)
		:addTo(self.awful_)
	
	display.newSprite(self.pic5_)
		:pos(self.frame5:getContentSize().width * 0.5,self.frame5:getContentSize().height * 0.5)
		:addTo(self.frame5)
end

function DiarytasklevelLayer:initPEACHUI_()
	self.pic1_ = "recharge/peach.png"
	self.pic2_ = "Diary/exp.png"
	self.pic4_ = "recharge/several_peach.png"
	self.pic3_ = "Diary/exp.png"
	self.pic5_ = "recharge/pile_peach.png"
	
	display.newSprite(self.pic1_)
		:scale(105/134)
		:pos(self.frame1:getContentSize().width * 0.5,self.frame1:getContentSize().height * 0.5)
		:addTo(self.frame1)
		
	display.newSprite(self.pic2_)
		:pos(self.frame2:getContentSize().width * 0.5,self.frame2:getContentSize().height * 0.5)
		:addTo(self.frame2)
		
	display.newSprite(self.pic3_)
		:pos(self.frame3:getContentSize().width * 0.5,self.frame3:getContentSize().height * 0.5)
		:addTo(self.frame3)
	
	self.frame4 = display.newSprite("Diary/brown.png")
		:scale(0.45)
		:pos(self.hard_:getContentSize().width * 0.63,self.hard_:getContentSize().height * 0.16)
		:addTo(self.hard_)
	
	display.newSprite(self.pic4_)
		:scale(105/134)
		:pos(self.frame4:getContentSize().width * 0.5,self.frame4:getContentSize().height * 0.5)
		:addTo(self.frame4)
			
	self.frame5 = display.newSprite("Diary/brown.png")
		:scale(0.45)
		:pos(self.awful_:getContentSize().width * 0.63,self.awful_:getContentSize().height * 0.16)
		:addTo(self.awful_)
	
	display.newSprite(self.pic5_)
		:scale(105/134)
		:pos(self.frame5:getContentSize().width * 0.5,self.frame5:getContentSize().height * 0.5)
		:addTo(self.frame5)
end

function DiarytasklevelLayer:initPIECEUI_()
	self.pic1_ = "Diary/piece.png"
	self.pic2_ = "Diary/piece.png"
	self.pic3_ = "Diary/piece.png"
	self.num1_ = 200
	self.num2_ = 300
	self.num3_ = 500
	
	display.newSprite(self.pic1_)
		:pos(self.frame1:getContentSize().width * 0.5,self.frame1:getContentSize().height * 0.5)
		:addTo(self.frame1)
	
	self.frame1:setPosition(self.normal_:getContentSize().width * 0.4,self.normal_:getContentSize().height * 0.16)
	self.frame2:setPosition(self.hard_:getContentSize().width * 0.4,self.hard_:getContentSize().height * 0.16)
	self.frame3:setPosition(self.awful_:getContentSize().width * 0.4,self.awful_:getContentSize().height * 0.16)
	
	cc.ui.UILabel.new({
        text = "x " .. self.num1_,size = 22,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(85,30),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.normal_:getContentSize().width * 0.78, self.normal_:getContentSize().height * 0.14)
        :addTo(self.normal_)
			
	display.newSprite(self.pic2_)
		:pos(self.frame2:getContentSize().width * 0.5,self.frame2:getContentSize().height * 0.5)
		:addTo(self.frame2)
	
	cc.ui.UILabel.new({
        text = "x " .. self.num2_,size = 22,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(85,30),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.hard_:getContentSize().width * 0.78, self.hard_:getContentSize().height * 0.14)
        :addTo(self.hard_)
			
	display.newSprite(self.pic3_)
		:pos(self.frame3:getContentSize().width * 0.5,self.frame3:getContentSize().height * 0.5)
		:addTo(self.frame3)
		
	cc.ui.UILabel.new({
        text = "x " .. self.num3_,size = 22,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(85,30),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.awful_:getContentSize().width * 0.78, self.awful_:getContentSize().height * 0.14)
        :addTo(self.awful_)
end

function DiarytasklevelLayer:selectMode(event, mode)
	if event == "began" then
		return true
	end
	if event == "ended" then
		print("**ChangeStage--" .. (self.activityType_ - 1) * 3 + mode)
		if self.restTimes_ == 0 then
			local t = WSToast.new("今日次数已用尽", 1)
			self:addChild(t, 20)
		else			
			self.restTimes_ = self.restTimes_ - 1
			local stageNum = tonumber((self.activityType_ - 1) * 3 + mode)
			--DataEye统计任务
	        if USE_DATAEYE then	        	
	            DCTask.begin("Diary" .. stageNum, DC_Daily)	                  
	        end

			GameManager.STAGE_NUM_DIARY = stageNum
			GameManager.TOWER_DISTANCE  = 900
			display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE","DIARY"))
		end	
    end	
end

--弹窗关闭
function DiarytasklevelLayer:closeCallBack_()
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.node:runAction(popupLayer)
end

return DiarytasklevelLayer
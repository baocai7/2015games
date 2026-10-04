
--[[=============================================================================
#     FileName: ActivityStageLayer.lua
#         Desc: 活动关卡
#       Author: Hoo
#   LastChange: 2015-04-27
#      History:
=============================================================================]]

local ActivityStageIcon = import("icons.ActivityStageIcon")
local AlertConnection   = import("customs.AlertConnection")
local AlertUpdate       = import("customs.AlertUpdate")
local BuyEnergyLayer    = import("layers.BuyEnergyLayer")
local ExchangeLayer     = import("layers.ExchangeLayer")
local WSToast           = import("utils.WSToast")

local ActivityStageLayer  =  class("ActivityStageLayer", function()
	return display.newLayer()
end)

function ActivityStageLayer:ctor()
	-- 添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-2)

	-- 初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.cy)
	self:addChild(self.emptyNode_)

	-- 弹出效果
	self.emptyNode_:setScale(0)
	local popupLayer = transition.sequence(
		{cc.ScaleTo:create(0.2, 1.1),
		cc.ScaleTo:create(0.1, 1.0)})
	self.emptyNode_:runAction(popupLayer)

	-- 播放音效(打开层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end

	-- 兑换界面是否关闭
	GameManager.IS_EXCHANGE_LAYER_CLOSED = false

	-- 活动是否开启
	self.isActivityOpen_ = true

	-- init
	self:initData_()

	-- 
	self:initUI_()

	-- 检测兑换界面是否关闭
	self:schedule(function()
        self:updateExchangeLayerIsClosed_()
    end,0.1)
end

function ActivityStageLayer:initData_()
	local ac = AlertConnection.new(CONNECTION_ACTIVITY_STAGE_INFO)
    self:addChild(ac,100,12346)

    self.scheduleInfo_ = self:schedule(function()
        if not self:getChildByTag(12346) then
            self:stopAction(self.scheduleInfo_)

            local startTime = CloudData.ACTIVITY_STAGE_INFO_TABLE["startTime"]  -- 活动开始时间
            local endTime   = CloudData.ACTIVITY_STAGE_INFO_TABLE["endTime"]    -- 活动结束时间
            local leftTime  = CloudData.ACTIVITY_STAGE_INFO_TABLE["leftTime"]   -- 活动剩余时间

            -- 活动时间
		    local activityTime = cc.ui.UILabel.new({
		        UILabelType = 2,text = "活动时间：",size = 24,color = cc.c3b(254,236,16),font = GameManager.FONTNAME_TTF})
		        :align(display.CENTER,self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.89)
		        :addTo(self.bg_)    
		    local timeLabel = cc.ui.UILabel.new({
		        UILabelType = 2,text = string.format("%s-%s", startTime,endTime),size = 24,color = cc.c3b(43,255,15),font = GameManager.FONTNAME_TTF})
		        :align(display.CENTER_LEFT,self.bg_:getContentSize().width * 0.5 + activityTime:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.89)
		        :addTo(self.bg_)  

	        -- 活动剩余时间
	        local hour    = math.floor(leftTime / 3600)
		    local minutes = math.floor((leftTime - hour * 3600) / 60)
		    local seconds = math.floor(leftTime - hour * 3600 - minutes * 60)
		    local lb = cc.ui.UILabel.new({
		        UILabelType = 2,text = "活动剩余时间:",size = 20,color = cc.c3b(255,255,255),font = GameManager.FONTNAME_TTF})
		        :align(display.CENTER,self.bg_:getContentSize().width * 0.12,self.bg_:getContentSize().height * 0.10)
		        :addTo(self.bg_,3)
		    self.timeLabel_ = cc.ui.UILabel.new({
		        UILabelType = 2,text = string.format("%02d:%02d:%02ds", hour,minutes,seconds),size = 20,color = cc.c3b(255,0,0),font = GameManager.FONTNAME_TTF})
		        :align(display.CENTER_LEFT,self.bg_:getContentSize().width * 0.12 + lb:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.10)
		        :addTo(self.bg_,3)  

	        -- 开始倒计时
	        self:startCountDown_(leftTime)
        end
    end,0.1)
end
function ActivityStageLayer:initUI_()
	self.tag_ = 0
	self.stageIconTable_ = {}
	-- 背景
	self.bg_ = display.newSprite("common_ui/bg_frame.png"):addTo(self.emptyNode_)
    display.newSprite("activity_stage/title.png",self.bg_:getContentSize().width * 0.25,self.bg_:getContentSize().height * 0.92):addTo(self.bg_)

    -- 底层颜色背景
    display.newSprite("activity_stage/bg_frame.png",self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.49):addTo(self.bg_)

    -- 规则按钮
	cc.ui.UIPushButton.new({normal = "chart/rule.png",pressed = "chart/rule1.png"})
	    :onButtonClicked(function()
	    	self:openRuleContent_()
	    end)
	    :scale(0.9)
	    :align(display.CENTER,self.bg_:getContentSize().width * 0.88,self.bg_:getContentSize().height * 0.89)
	    :addTo(self.bg_,2)

    -- 加载关卡图标
    for i=1,3 do
    	local stageIcon = ActivityStageIcon.new(i)
    	stageIcon:setPosition(cc.p(self.bg_:getContentSize().width * 0.1 * (3 * i - 1),self.bg_:getContentSize().height * 0.52))
    	self.bg_:addChild(stageIcon)
    	table.insert(self.stageIconTable_,stageIcon)

    	stageIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            return self:onTouch(event.name,event.x,event.y)
        end)
    end

    -- 当前代币数量
    cc.ui.UILabel.new({
        UILabelType = 2,text = "当前数量:",size = 20,color = cc.c3b(255,255,255),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.78,self.bg_:getContentSize().height * 0.10)
        :addTo(self.bg_,3)
    local rewardPic = display.newSprite("activity_stage/currency_pic1.png",
    	self.bg_:getContentSize().width * 0.845,self.bg_:getContentSize().height * 0.10)
    	:scale(0.9)
    	:addTo(self.bg_,3)
    	-- 数量
    self.coinsNumLabel_ = cc.ui.UILabel.new({
        UILabelType = 1,text = CloudData.ACTIVITY_COINS,font = "fonts/whiteNum.fnt"})
    	:scale(0.5)
        :align(display.CENTER_LEFT,self.bg_:getContentSize().width * 0.845 + rewardPic:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.10)
        :addTo(self.bg_,3)  

	-- 兑换奖励按钮
	cc.ui.UIPushButton.new({normal = "activity_stage/btn_exchange.png",pressed = "activity_stage/btn_exchange1.png"})
	    :onButtonClicked(function()
	    	self:exchangeCallBack_()
	    end)
	    :scale(0.8)
	    :align(display.CENTER,self.bg_:getContentSize().width * 0.37,self.bg_:getContentSize().height * 0.14)
	    :addTo(self.bg_,1)

    -- 进入战斗按钮
	cc.ui.UIPushButton.new({normal = "activity_stage/btn_start.png",pressed = "activity_stage/btn_start1.png"})
	    :onButtonClicked(function()
	    	self:startCallBack_()
	    end)
	    :scale(0.8)
	    :align(display.CENTER,self.bg_:getContentSize().width * 0.63,self.bg_:getContentSize().height * 0.14)
	    :addTo(self.bg_,1)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
	    :onButtonClicked(function()
	    	self:closeCallBack_()
	    end)
		:scale(0.7)
	    :align(display.CENTER,self.bg_:getContentSize().width * 0.965,self.bg_:getContentSize().height * 0.95)
	    :addTo(self.bg_,2)
end

-- 开始倒计时
function ActivityStageLayer:startCountDown_(time)
	if time ==  0 then
	    self:countdownOver_()
	else
	    -- 转换时分秒
	    self.hour_    = math.floor(time / 3600)
	    self.minutes_ = math.floor((time - self.hour_ * 3600) / 60)
	    self.seconds_ = math.floor(time - self.hour_ * 3600 - self.minutes_ * 60)

	    --倒计时
	    self.schedule_ = self:schedule(function()
	        self:updateTime_()
	    end, 1.0)
	end
    
end
-- 时间更新
function ActivityStageLayer:updateTime_()
    if self.seconds_ > 0 then
        self.seconds_ = self.seconds_ - 1
    else
        if self.minutes_ > 0 then
            self.seconds_ = 59
            self.minutes_ = self.minutes_ - 1
        else
            if self.hour_ > 0 then
                self.seconds_ = 59
                self.minutes_ = 59
                self.hour_    = self.hour_ - 1
            else
                self:countdownOver_()
            end
        end
    end
    --倒计时标签刷新
    self.timeLabel_:setString(string.format("%02d:%02d:%02ds",self.hour_,self.minutes_,self.seconds_))
    
end
-- 倒计时结束
function ActivityStageLayer:countdownOver_()
    -- 停止计时器
    self:stopAction(self.schedule_) 

    -- todo : 逻辑处理（关卡不能进入）
    self.isActivityOpen_ = false
end

function ActivityStageLayer:onTouch(event,x,y)
	if event == "began" then
		self.touchBeginPoint_ = {x = x,y = y}
		return true
	end

	if event == "moved" then
       
	end

	if event == "ended" then
		local touchEndedPoint = {x = x,y = y}
		for i=1,#self.stageIconTable_ do
			local stageIcon = self.stageIconTable_[i]
			if math.abs(self.touchBeginPoint_.x - touchEndedPoint.x) < 20 and math.abs(self.touchBeginPoint_.y - touchEndedPoint.y) < 20 
		    	and cc.rectContainsPoint(stageIcon:getMyBoundingBox(),touchEndedPoint) then
				self:touchStageIcon_(i)
			end
		end
    end
end

function ActivityStageLayer:touchStageIcon_( index )
	-- print(" index : "..index)
	for i=1,#self.stageIconTable_ do
		local stageIcon = self.stageIconTable_[i]
		if i == index then
			stageIcon:isSelected(true)
		else
			stageIcon:isSelected(false)
		end
	end

	self.tag_ = index
end

-- 兑换奖励
function ActivityStageLayer:exchangeCallBack_()
	-- body
	if self.isActivityOpen_ then
		local pLayer = ExchangeLayer.new()
		self:addChild(pLayer,20)
	else
		local toast = WSToast.new("当前不处于活动期间内")
		self:addChild(toast,20)
	end
end

-- 进入战斗
function ActivityStageLayer:startCallBack_()
	if self.isActivityOpen_ then
		if self.tag_ == 0 then
			local toast = WSToast.new("请选择一种关卡模式")
			self:addChild(toast,20)
		else
			local resDownLoaded = cc.UserDefault:getInstance():getBoolForKey("missed_armature_res_downloaded",false)
            if not resDownLoaded then
                local al = AlertUpdate.new(GameManager.URL_MISSED_ARMATURE,5.8,"FORCE",true)
                self:addChild(al,100)
			else
				local costType     =  DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(self.tag_)["costType"]
				local costNum      =  tonumber(DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(self.tag_)["costNum"])
				local towerId      =  tonumber(DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(self.tag_)["towerId"])
				local distance     =  tonumber(DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(self.tag_)["distance"])

				if CloudData.ENERGY >= costNum then
			        local ac = AlertConnection.new(CONNECTION_ACTIVITY_STAGE_START,self.tag_)
			        self:addChild(ac,100,12345)

			        self.scheduleStart_ = self:schedule(function() 
			            if not self:getChildByTag(12345) then
			                self:stopAction(self.scheduleStart_)

							audio.stopMusic()
							if GameManager.SOUND_SWITCH_ON then
								audio.playSound(string.format("sounds/sfx_go.%s",GameManager.POSTFIX))
							end     

							if CloudData.HAS_ENERGY then
							 	GameManager.ACTIVITY_STAGE_TYPE = self.tag_
								GameManager.TOWER_DISTANCE = distance
								GameManager.STAGE_NUM = towerId
				                display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE","ACTIVITY"))
			                else
			                	local bnl = BuyEnergyLayer.new()
			        			self:addChild(bnl,50)
							end
			            end
			        end,0.1)
			    else
			        local bnl = BuyEnergyLayer.new()
			        self:addChild(bnl,50)
		    	end
			end	
		end
	else
		local toast = WSToast.new("当前不处于活动期间内")
		self:addChild(toast,20)
	end
end

-- 打开规则
function ActivityStageLayer:openRuleContent_()
	-- 遮罩层
	local grayLayer = display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,10)

	-- 背景
	local bg = display.newSprite("settings/bg.png", display.cx, display.cy)
        :scale(0)
        :addTo(grayLayer)
    bg:runAction(transition.sequence({cc.ScaleTo:create(0.2, 1.1),cc.ScaleTo:create(0.1, 1.0)}))

    -- 规则信息
    display.newSprite("activity_stage/rule.png",bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.6)
     	:addTo(bg)

    -- 关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.7)
        :align(display.CENTER,bg:getContentSize().width * 0.953,bg:getContentSize().height * 0.93)
        :onButtonClicked(function()
            bg:runAction(transition.sequence({cc.ScaleTo:create(0,1.0),cc.ScaleTo:create(0.1,1.1),
     			cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            		grayLayer:removeSelf()
        		end)
        	}))
        end)
        :addTo(bg)   
end

-- 检测兑换界面是否关闭
function ActivityStageLayer:updateExchangeLayerIsClosed_()
	if GameManager.IS_EXCHANGE_LAYER_CLOSED then
		GameManager.IS_EXCHANGE_LAYER_CLOSED = false
		self.coinsNumLabel_:setString(CloudData.ACTIVITY_COINS)
	end
end

-- 弹窗关闭
function ActivityStageLayer:closeCallBack_()
	-- 播放音效(关闭层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
	end

    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.emptyNode_:runAction(popupLayer)
end

return ActivityStageLayer
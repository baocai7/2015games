--
--日常任务相关数据
--

local AlertAchievement  = import("layers.AlertAchievement")
local AlertConnection   = import("customs.AlertConnection")
local WSToast           = import("utils.WSToast")

local DailyTaskIcon  =  class("DailyTaskIcon", function()
	return display.newNode()
end)

--任务奖励类型
PEACH        = "peach"
EXP          = "exp"
ENERGY       = "energy"

function DailyTaskIcon:ctor(dailyTaskModel)

	--初始化任务数据
	self:initData(dailyTaskModel)

	--初始化icon内容
	self:initContent()

	--self:setContentSize(self.cellFrame_:getContentSize())
end

function DailyTaskIcon:initData( dailyTaskModel )
	self.dailyTaskId_    = tonumber(dailyTaskModel.dailyTaskId_)
    self.dailyTaskDesc_  = dailyTaskModel.dailyTaskDesc_
    self.rewardType_     = dailyTaskModel.rewardType_
    self.totalData_      = tonumber(dailyTaskModel.totalData_)
    self.currentData_    = tonumber(dailyTaskModel.currentData_)
    self.rewardQuantity_ = tonumber(dailyTaskModel.rewardQuantity_)
    self.stageLevel_     = tonumber(dailyTaskModel.stageLevel_)
    
    if self.currentData_ == -1 then
        self.currentData_ = self.totalData_
    elseif self.currentData_ > self.totalData_ then
    	self.currentData_ = self.totalData_
    end

	-- print("-----------------dailyTaskId_:"..self.dailyTaskId_)
	-- print("-----------------dailyTaskDesc_:"..self.dailyTaskDesc_)
	-- print("-----------------rewardType_:"..self.rewardType_)
	-- print("-----------------totalData_:"..self.totalData_)
	-- print("-----------------currentData_:"..self.currentData_)
	-- print("-----------------rewardQuantity_:"..self.rewardQuantity_)
	-- print("-----------------stageLevel_:"..self.stageLevel_)
end

function DailyTaskIcon:initContent()
	--cell背景
	local cellFrame = display.newSprite("tasks/cell_frame.png")
		:addTo(self)
	cellFrame:setAnchorPoint(cc.p(0,0))
	self:setContentSize(cellFrame:getContentSize())

	--完成任务的奖励 (tasks/award_frame.png)
	local awardFrame = display.newSprite("sign/signk.png",cellFrame:getContentSize().width * 0.15,cellFrame:getContentSize().height * 0.5)
		:scale(0.9)
		:addTo(cellFrame)
		--奖励图标
	local awardPic = display.newSprite("sign/pantao.png",awardFrame:getContentSize().width * 0.5,awardFrame:getContentSize().height * 0.5)
		:addTo(awardFrame)
	if self.rewardType_ == PEACH then
		awardPic:setTexture("sign/pantao.png")
	elseif self.rewardType_ == EXP then
		awardPic:setTexture("sign/exp.png")
	else
		awardPic:setTexture("sign/energy.png")
	end

	--任务描述
	local taskDescPic = display.newSprite("tasks/description.png",cellFrame:getContentSize().width * 0.3,cellFrame:getContentSize().height * 0.75)
		:addTo(cellFrame)
	local taskDescLabel = cc.ui.UILabel.new({UILabelType = 2, text = self.dailyTaskDesc_,font = GameManager.FONTNAME_TTF,size = 20,color = cc.c3b(35,5,0)})
		:align(display.CENTER,taskDescPic:getPositionX() + taskDescPic:getContentSize().width * 0.55,cellFrame:getContentSize().height * 0.75)
		:addTo(cellFrame)
	taskDescLabel:setAnchorPoint(0,0.5)
	
	--任务奖励
	local taskRewardPic = display.newSprite("tasks/reward.png",cellFrame:getContentSize().width * 0.3,cellFrame:getContentSize().height * 0.5)
		:addTo(cellFrame)
	local taskRewardLabel = cc.ui.UILabel.new({UILabelType = 2, text = string.format("经验x%d",self.rewardQuantity_),font = GameManager.FONTNAME_TTF,size = 20,color = cc.c3b(35,5,0)})
		:align(display.CENTER,taskRewardPic:getPositionX() + taskRewardPic:getContentSize().width * 0.55,cellFrame:getContentSize().height * 0.5)
		:addTo(cellFrame)
	taskRewardLabel:setAnchorPoint(0,0.5)

	--若为精力领取任务,则显示时间,不显示进度条
	if self.dailyTaskId_ >= 11 then
		taskRewardLabel:setString(string.format("精力x%d",self.rewardQuantity_))

		local timeLabel = cc.ui.UILabel.new({UILabelType = 1,text = "12:00-14:00",font = "fonts/greenNum.fnt"})
			:scale(0.5)
	        :align(display.CENTER,cellFrame:getContentSize().width * 0.36,cellFrame:getContentSize().height * 0.25)
	        :addTo(cellFrame)
	    if self.dailyTaskId_ == 12 then
	    	timeLabel:setString("18:00-20:00")
    	elseif self.dailyTaskId_ == 13 then
    		timeLabel:setString("21:00-24:00")
	    end
    else
    	--任务进度
	        --计算进度值
	    local totalNum      = self.totalData_           --成就总任务度
	    local currNum       = self.currentData_         --当前完成度    
	    local progressValue = currNum / totalNum * 100
	        --进度条显示
	    local barBg = display.newSprite("tasks/progress_bar1.png",cellFrame:getContentSize().width * 0.45,cellFrame:getContentSize().height * 0.25)
	        :addTo(cellFrame)
	    local progressTimer = display.newProgressTimer("tasks/progress_bar2.png", display.PROGRESS_TIMER_BAR)
	        :pos(barBg:getContentSize().width * 0.5,barBg:getContentSize().height * 0.5)
	        :addTo(barBg)
	    progressTimer:setMidpoint(cc.p(0,0))
	    progressTimer:setBarChangeRate(cc.p(1,0))
	    progressTimer:setPercentage(progressValue)
	        --数值显示
	    local taskProgressLabel = cc.ui.UILabel.new({UILabelType = 1, text = string.format("%d/%d",currNum,totalNum),font = "fonts/whiteNum.fnt"})
			:scale(0.5)
	        :align(display.CENTER,barBg:getContentSize().width * 0.5,barBg:getContentSize().height * 0.5)
	        :addTo(barBg)
	end

    --已完成图标
    self.completedTip_ = display.newSprite("tasks/completed.png",cellFrame:getContentSize().width * 0.88,cellFrame:getContentSize().height * 0.5)
		:hide()
    	:addTo(cellFrame)
	--领取奖励按钮
	self.getAwardBtn_ = cc.ui.UIPushButton.new({normal = "tasks/get_normal.png",pressed = "tasks/get_selected.png",disabled = "tasks/get_enabled.png"})
		:scale(0.7)
        :align(display.CENTER,cellFrame:getContentSize().width * 0.83,cellFrame:getContentSize().height * 0.30)
        :onButtonClicked(function()
            self:getAwardCallBack_()
        end)
        :addTo(cellFrame,1)
    if DataUtils.getDailyTaskCompleted(self.dailyTaskId_) then
        self.getAwardBtn_:hide()
        self.completedTip_:show()
	else
		if self.currentData_ < self.totalData_ then
			self.getAwardBtn_:setButtonEnabled(false)
		else
			self.getAwardBtn_:setButtonEnabled(true)
		end
    end    
end

function DailyTaskIcon:getAwardCallBack_()
	local currScene = display.getRunningScene()
    local ac = AlertConnection.new(CONNECTION_DAILY_TASK_FINISH,self.dailyTaskId_)
    currScene:addChild(ac,100,12346)

    self.scheduleD_ = self:schedule(function() 
        if not currScene:getChildByTag(12346) then
            self:stopAction(self.scheduleD_)

            if CloudData.ERR_CODE == 36 then
            	local toast = WSToast.new("不满足任务领取条件,请重新刷新该界面")
            	currScene:addChild(toast, 100)

        	elseif CloudData.ERR_CODE == 0 then
        		self.getAwardBtn_:hide()
	            self.completedTip_:show()
	            
	            DataUtils.setDailyTaskCompleted(self.dailyTaskId_)

	            if self.rewardType_ == EXP then
		            local layer = AlertAchievement.new(REWARD_TYPE_EXP,self.rewardQuantity_)
		            currScene:addChild(layer,20)
		            
		            --数据更新
		            CloudData.EXP = CloudData.EXP + self.rewardQuantity_
	        	elseif self.rewardType_ == ENERGY then
		            local layer = AlertAchievement.new(REWARD_TYPE_ENERGY,self.rewardQuantity_)
		            currScene:addChild(layer,20)
		            
		            --数据更新
		            CloudData.ENERGY = CloudData.ENERGY + self.rewardQuantity_
	            end

	            --DataEye统计任务
		        if USE_DATAEYE then
		            DCTask.begin(self.dailyTaskId_ .. "", DC_Daily)
		            DCTask.complete(self.dailyTaskId_ .. "")          
		        end
            end
        end
    end,0.1)
end

return DailyTaskIcon
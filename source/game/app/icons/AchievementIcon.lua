--
--成就相关数据
--

local AlertAchievement  = import("layers.AlertAchievement")
local AlertConnection   = import("customs.AlertConnection")

local AchievementIcon  =  class("AchievementIcon", function()
	return display.newNode()
end)

--成就奖励的种类
PEACH        = "peach"
BUDDHA       = "buddha"
EXP          = "exp"
GINSENGFRUIT = "ginsengfruit"
SWEEP        = "sweep"
ESSENCE      = "essence"

function AchievementIcon:ctor(achievementModel)

	self.iconFrame_ = display.newSprite("tasks/cell_frame.png")
		:addTo(self)
	self.iconFrame_:setAnchorPoint(cc.p(0,0))

	--初始化成就数据
	self:initData(achievementModel)

	--初始化icon内容
	self:initContent()

	self:setContentSize(self.iconFrame_:getContentSize())
end

function AchievementIcon:initData( achievementModel )
	self.achievementId_   = tonumber(achievementModel.achievementId_)
	self.achievementName_ = achievementModel.achievementName_
	self.achievementDes1_ = achievementModel.achievementDes1_
	self.achievementDes2_ = achievementModel.achievementDes2_
	self.rewardType_      = achievementModel.rewardType_
	self.rewardNum_       = tonumber(achievementModel.rewardNum_)
	self.achievementData_ = tonumber(achievementModel.achievementData_)
	self.currentData_     = tonumber(achievementModel.currentData_)
	self.rewardQuantity_  = tonumber(achievementModel.rewardQuantity_)
	self.achievementType_ = achievementModel.achievementType_

	-- print("-----------------achievementId_:"..self.achievementId_)
	-- print("-----------------achievementName_:"..self.achievementName_)
	-- print("-----------------rewardType_:"..self.rewardType_)
	-- print("-----------------rewardNum_:"..self.rewardNum_)
	-- print("-----------------achievementData_:"..self.achievementData_)
	-- print("-----------------currentData_:"..self.currentData_)
	-- print("-----------------rewardQuantity_:"..self.rewardQuantity_)	
end

function AchievementIcon:initContent()
	--完成成就的奖励
	local awardFrame = display.newSprite("sign/signk.png",self.iconFrame_:getContentSize().width * 0.15,self.iconFrame_:getContentSize().height * 0.5)
		:scale(0.9)
		:addTo(self.iconFrame_)
		--奖励图标
	local awardPic = display.newSprite("sign/pantao.png",awardFrame:getContentSize().width * 0.5,awardFrame:getContentSize().height * 0.5)
		:addTo(awardFrame)	
	local labelText = nil
	if self.rewardType_ == PEACH then
		awardPic:setTexture("sign/pantao.png")
		labelText = string.format("蟠桃x"..self.rewardQuantity_)
	elseif self.rewardType_ == BUDDHA then
		awardPic:setTexture(string.format("buddha_icon/buddha"..self.rewardQuantity_..".png"))
		awardPic:setScale(105/95)
		labelText = string.format("神仙x1")
	elseif self.rewardType_ == EXP then
		awardPic:setTexture("sign/exp.png")
		labelText = string.format("经验x"..self.rewardQuantity_)
	elseif self.rewardType_ == GINSENGFRUIT then
		awardPic:setTexture("sign/renshen.png")
		labelText = string.format("人参果x"..self.rewardQuantity_)
	elseif self.rewardType_ == SWEEP then 
		awardPic:setTexture("sign/saodang.png")
		labelText = string.format("扫荡券x"..self.rewardQuantity_)
	else
		awardPic:setTexture("summon_scene/essence_pic.png")
		awardPic:setScale(105/95)
		labelText = string.format("精华石x"..self.rewardQuantity_)
	end

	--成就名称
	self.achievementNamePic_ = display.newSprite("tasks/achievement/achievement"..self.achievementId_..".png",
		self.iconFrame_:getContentSize().width * 0.36,self.iconFrame_:getContentSize().height * 0.72)
		:scale(0.8)
		:addTo(self.iconFrame_)
	
	--成就奖励
	local taskRewardPic = display.newSprite("tasks/reward.png",self.iconFrame_:getContentSize().width * 0.3,self.iconFrame_:getContentSize().height * 0.45)
		:addTo(self.iconFrame_)
	self.rewardNumLabel_ = cc.ui.UILabel.new({UILabelType = 2, text = labelText,font = GameManager.FONTNAME_TTF,size = 20,color = cc.c3b(35,5,0)})
		:align(display.CENTER,taskRewardPic:getPositionX() + taskRewardPic:getContentSize().width * 0.55,self.iconFrame_:getContentSize().height * 0.45)
		:addTo(self.iconFrame_)
	self.rewardNumLabel_:setAnchorPoint(0,0.5)

	--成就描述●●
	self.des2Label_ = cc.ui.UILabel.new({UILabelType = 2, text = string.format(self.achievementDes2_), size = 24,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
	self.des2Label_:setAnchorPoint(cc.p(1,0.5))
	self.des2Label_:setPosition(cc.p(self.iconFrame_:getContentSize().width * 0.95,self.iconFrame_:getContentSize().height * 0.72))
	self.iconFrame_:addChild(self.des2Label_)

	self.dataLabel_ = cc.ui.UILabel.new({UILabelType = 2, text = self.achievementData_, size = 24,color = display.COLOR_RED,font = GameManager.FONTNAME_TTF})
	self.dataLabel_:setAnchorPoint(cc.p(1,0.5))
	self.dataLabel_:setPosition(cc.p(self.iconFrame_:getContentSize().width * 0.95 - self.des2Label_:getContentSize().width,self.iconFrame_:getContentSize().height * 0.72));
	self.iconFrame_:addChild(self.dataLabel_)

	self.des1Label_ = cc.ui.UILabel.new({UILabelType = 2, text = string.format(self.achievementDes1_),size = 24,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
	self.des1Label_:setAnchorPoint(cc.p(1,0.5))
	self.des1Label_:setPosition(cc.p(self.dataLabel_:getPositionX() - self.dataLabel_:getContentSize().width,self.iconFrame_:getContentSize().height * 0.72))
	self.iconFrame_:addChild(self.des1Label_)

	--成就完成度(精度条表示)
	 	--计算进度值
	local totalNum      = self.achievementData_     --成就总任务度
	local currNum       = self.currentData_         --当前完成度    
	local progressValue = currNum / totalNum * 100
    --	local taskProgressPic = display.newSprite("tasks/progress1.png",self.iconFrame_:getContentSize().width * 0.39,self.iconFrame_:getContentSize().height * 0.25)
    --		:addTo(self.iconFrame_)
	-- self.progressLabel_ = cc.ui.UILabel.new({UILabelType = 1, text = string.format("%d/%d",currNum,totalNum),font = "fonts/greenNum.fnt"})
	-- 	:scale(0.5)
	-- 	:align(display.CENTER,taskProgressPic:getPositionX() + taskProgressPic:getContentSize().width * 0.55,self.iconFrame_:getContentSize().height * 0.25)
	-- 	:addTo(self.iconFrame_)
        --进度条显示
    local barBg = display.newSprite("tasks/progress_bar1.png",self.iconFrame_:getContentSize().width * 0.45,self.iconFrame_:getContentSize().height * 0.25)
        :addTo(self.iconFrame_)
    self.progressTimer_ = display.newProgressTimer("tasks/progress_bar2.png", display.PROGRESS_TIMER_BAR)
        :pos(barBg:getContentSize().width * 0.5,barBg:getContentSize().height * 0.5)
        :addTo(barBg)
    self.progressTimer_:setMidpoint(cc.p(0,0))
    self.progressTimer_:setBarChangeRate(cc.p(1,0))
    self.progressTimer_:setPercentage(progressValue)
        --数值显示
    self.progressLabel_ = cc.ui.UILabel.new({UILabelType = 1, text = string.format("%d/%d",currNum,totalNum),font = "fonts/whiteNum.fnt"})
        :scale(0.5)
        :align(display.CENTER,barBg:getContentSize().width * 0.5,barBg:getContentSize().height * 0.5)
        :addTo(barBg,1)
--	self.progressLabel_:setAnchorPoint(0,0.5)
--	if currNum >= 10000 then
--		self.progressLabel_:setString(string.format("%d万/%d",currNum/10000,totalNum))
--	end
--	if totalNum >= 10000 then
--		self.progressLabel_:setString(string.format("%d/%d万",currNum,totalNum/10000))
--	end
--	if currNum >= 10000 and totalNum >= 10000 then
--		self.progressLabel_:setString(string.format("%d万/%d万",currNum/10000,totalNum/10000))
--	end
		

    --已完成图标
    self.completedTip_ = display.newSprite("tasks/completed.png",self.iconFrame_:getContentSize().width * 0.85,self.iconFrame_:getContentSize().height * 0.40)
		:hide()
    	:addTo(self.iconFrame_)
	--领取奖励按钮
	self.getAwardBtn_ = cc.ui.UIPushButton.new({normal = "tasks/get_normal.png",pressed = "tasks/get_selected.png",disabled = "tasks/get_enabled.png"})
		:scale(0.7)
        :align(display.CENTER,self.iconFrame_:getContentSize().width * 0.85,self.iconFrame_:getContentSize().height * 0.33)
        :onButtonClicked(function()
            self:getAwardCallBack_()
        end)
        :addTo(self.iconFrame_,1)
    local achievementLevel = tonumber(DataUtils.getAchievementLevel(self.achievementId_))    
    if achievementLevel <= self.rewardNum_ then
    	if currNum < totalNum then
    		self.getAwardBtn_:setButtonEnabled(false)
    	end
	else
		self.achievementNamePic_:setTexture(string.format("tasks/achievement/achievement"..self.achievementId_.."_h.png"))
		self.getAwardBtn_:hide()
        self.completedTip_:show()
    end
end

function AchievementIcon:getAwardCallBack_()
	--todo
	local currScene = display.getRunningScene()
	local ac = AlertConnection.new(CONNECTION_ACHIEVEMENT_STEP,self.achievementId_,DataUtils.getAchievementLevel(self.achievementId_))
    currScene:addChild(ac,100,12345)
    --网络监测0.1s
    self.scheduleUpgrade_ = self:schedule(function()
    	if not currScene:getChildByTag(12345) then
            self:stopAction(self.scheduleUpgrade_)

            --领取成就,弹窗提示
            self:receiveReward_()
        end
    end,0.1)
end
--领取成就,弹窗提示
function AchievementIcon:receiveReward_()
	local currScene = display.getRunningScene()
	if self.rewardType_ == PEACH then
		local layer = AlertAchievement.new(REWARD_TYPE_PEACH,self.rewardQuantity_)
		currScene:addChild(layer,20)

		--数据更新
		CloudData.PEACH = CloudData.PEACH + self.rewardQuantity_
		--DataEye统计蟠桃产出
        if USE_DATAEYE then  
            DCCoin.gain("achievement", "peach", self.rewardQuantity_, CloudData.PEACH)              
        end

	elseif self.rewardType_ == BUDDHA then
		local layer = AlertAchievement.new(REWARD_TYPE_BUDDHA,self.rewardQuantity_)
		currScene:addChild(layer,20)

		--数据更新
		DataUtils.setNewBuddhaCloudData(self.rewardQuantity_)

	elseif self.rewardType_ == EXP then
		local layer = AlertAchievement.new(REWARD_TYPE_EXP,self.rewardQuantity_)
		currScene:addChild(layer,20)

		--数据更新
		CloudData.EXP = CloudData.EXP + self.rewardQuantity_

	elseif self.rewardType_ == GINSENGFRUIT then
		local layer = AlertAchievement.new(REWARD_TYPE_GINSENGFRUIT,self.rewardQuantity_)
		currScene:addChild(layer,20)

		--数据更新
		CloudData.GINSENG_FRUIT = CloudData.GINSENG_FRUIT + self.rewardQuantity_

	elseif self.rewardType_ == SWEEP then
		local layer = AlertAchievement.new(REWARD_TYPE_SWEEP,self.rewardQuantity_)
		currScene:addChild(layer,20)

		--数据更新
		CloudData.SWEEP = CloudData.SWEEP + self.rewardQuantity_
	else
		local layer = AlertAchievement.new(REWARD_TYPE_ESSENCE,self.rewardQuantity_)
		currScene:addChild(layer,20)

		--数据更新
		CloudData.ESSENCE = CloudData.ESSENCE + self.rewardQuantity_
	end	
	--刷新数据
	self:updateAchievementData_()
end

function AchievementIcon:updateAchievementData_()
	local achievementStep = tonumber(DataUtils.getAchievementLevel(self.achievementId_)) 
	--DataEye统计任务
    if USE_DATAEYE then  
        DCTask.complete(self.achievementType_ .. achievementStep)  
        if achievementStep < self.rewardNum_ then
        	local num = achievementStep + 1
        	DCTask.begin(self.achievementType_ .. num, DC_Other)
        end         
    end
	--print("m_nAchievementId : "..self.achievementId_.."achievementStep : "..achievementStep)
	DataUtils.setAchievementLevel(self.achievementId_,achievementStep + 1)
	if achievementStep < self.rewardNum_ then
		
		local achievementModel = DataUtils.getAchievementModel(self.achievementId_)
		self:initData(achievementModel)

		--奖励更新
		if self.rewardType_ == PEACH then
			self.rewardNumLabel_:setString(string.format("蟠桃x"..self.rewardQuantity_))
		elseif self.rewardType_ == EXP then
			self.rewardNumLabel_:setString(string.format("经验x"..self.rewardQuantity_))
		elseif self.rewardType_ == GINSENGFRUIT then
			self.rewardNumLabel_:setString(string.format("人参果x"..self.rewardQuantity_))
		elseif self.rewardType_ == SWEEP then
			self.rewardNumLabel_:setString(string.format("扫荡券x"..self.rewardQuantity_))
		elseif self.rewardType_ == ESSENCE then
			self.rewardNumLabel_:setString(string.format("精华石x"..self.rewardQuantity_))
		end

		--进度更新
		local progressValue = self.currentData_ / self.achievementData_ * 100
		self.progressLabel_:setString(string.format(self.currentData_.."/"..self.achievementData_))
		self.progressTimer_:setPercentage(progressValue)
--		if self.currentData_ >= 10000 then
--			self.progressLabel_:setString(string.format("%d万/%d",self.currentData_/10000,self.achievementData_))
--		end
--		if self.achievementData_ >= 10000 then
--			self.progressLabel_:setString(string.format("%d/%d万",self.currentData_,self.achievementData_/10000))
--		end
--		if self.currentData_ >= 10000 and self.achievementData_ >= 10000 then
--			self.progressLabel_:setString(string.format("%d万/%d万",self.currentData_/10000,self.achievementData_/10000))
--		end

		--描述更新
		self.dataLabel_:setString(self.achievementData_)
		self.des1Label_:setPositionX(self.dataLabel_:getPositionX() - self.dataLabel_:getContentSize().width)

		--按钮状态更新
		if self.currentData_ < self.achievementData_ then        
			self.getAwardBtn_:setButtonEnabled(false)
		end
	else
		self.achievementNamePic_:setTexture(string.format("achievement/achievement"..self.achievementId_.."_h.png"))
		self.getAwardBtn_:hide()
        self.completedTip_:show()
	end
end

function AchievementIcon:getMyBoundingBox()
	--转换世界坐标系
	local point = cc.p(self:getPositionX(),self:getPositionY())
	local worldpoint = self:getParent():convertToWorldSpace(point)
	local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5,
		worldpoint.y - self:getContentSize().height * 0.5,
		self:getContentSize().width,
		self:getContentSize().height);
	return rect;
end

return AchievementIcon
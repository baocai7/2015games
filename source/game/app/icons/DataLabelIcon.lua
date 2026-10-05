--
--游戏数据（精力，经验，蟠桃，精华等）的文字标签
--
local BuyEnergyLayer  = import("layers.BuyEnergyLayer")
--local BuyExpLayer   = import("layers.BuyExpLayer")
local PaymentLayer    = import("layers.PaymentLayer")
local WSToast         = import("utils.WSToast")

local DataLabelIcon  =  {} 
DataLabelIcon = class("DataLabelIcon", function()
	return display.newNode()
end)

DataLabelIcon.LABEL_TYPE_ENERGY         = 1
DataLabelIcon.LABEL_TYPE_EXP            = 2
DataLabelIcon.LABEL_TYPE_PEACH          = 3
DataLabelIcon.LABEL_TYPE_ESSENCE        = 4

function DataLabelIcon:ctor(labelType,isEnabled)

	self.type_ = labelType

	--边框
	local labelFrame = display.newSprite():addTo(self)

	--标签背景的路径,数据的数值
	local dataNumber = 0
	if self.type_ == DataLabelIcon.LABEL_TYPE_ENERGY then
		dataNumber = CloudData.ENERGY
		local maxEnergyNum = CloudData.MAX_ENERGY
		self.maxEnergy_ = CloudData.MAX_ENERGY
		labelFrame:setTexture("chapter/energy_bg.png")
		      
        local lev = DataUtils.getPropertyLevel(10)
        
        if lev < 20 then
            self.energyNumLabel_ = cc.ui.UILabel.new({
                UILabelType = 1,text = string.format(dataNumber),font = "fonts/whiteNum.fnt"})
                :scale(0.8)
                :align(display.CENTER_RIGHT,labelFrame:getContentSize().width * 0.52,labelFrame:getContentSize().height * 0.5)
                :addTo(labelFrame,2)
        else
            self.energyNumLabel_ = cc.ui.UILabel.new({
                UILabelType = 1,text = string.format(dataNumber),font = "fonts/bulefonts.fnt"})
                :scale(0.8)
                :align(display.CENTER_RIGHT,labelFrame:getContentSize().width * 0.52,labelFrame:getContentSize().height * 0.5)
                :addTo(labelFrame,2)
        end
        
		--标签
--        self.energyNumLabel_ = cc.ui.UILabel.new({
--            UILabelType = 1,text = string.format(dataNumber),font = "fonts/whiteNum.fnt"})
--            :scale(0.8)
--            :align(display.CENTER_RIGHT,labelFrame:getContentSize().width * 0.52,labelFrame:getContentSize().height * 0.5)
--            :addTo(labelFrame,2)
            
		self.maxEnergyNumLabel_ = cc.ui.UILabel.new({
            UILabelType = 1,text = string.format("/"..maxEnergyNum),font = "fonts/bulefonts.fnt"})
            :scale(0.8)
            :align(display.CENTER_LEFT,labelFrame:getContentSize().width * 0.52,labelFrame:getContentSize().height * 0.5)
            :addTo(labelFrame,2)

		--加载进度条
--		self.progress = display.newProgressTimer("chapter/energy_bar.png", display.PROGRESS_TIMER_BAR)
--	        :pos(labelFrame:getContentSize().width * 0.56,labelFrame:getContentSize().height * 0.5)
--	        :addTo(labelFrame,1)
--		self.progress:setMidpoint(cc.p(0,0))
--		self.progress:setBarChangeRate(cc.p(1,0))
--		local progressValue = dataNumber / maxEnergyNum * 100
--		self.progress:setPercentage(progressValue)

	elseif self.type_ == DataLabelIcon.LABEL_TYPE_EXP then
		dataNumber = CloudData.EXP
		labelFrame:setTexture("common_ui/exp_bg.png")
		--标签
		self.expNumLabel_ = cc.ui.UILabel.new({
	        UILabelType = 1,text = string.format(dataNumber),font = "fonts/whiteNum.fnt"})
            :scale(0.8)
	        :align(display.CENTER,labelFrame:getContentSize().width * 0.52,labelFrame:getContentSize().height * 0.5)
	        :addTo(labelFrame,2)

	elseif self.type_ == DataLabelIcon.LABEL_TYPE_PEACH then
		dataNumber = CloudData.PEACH
		labelFrame:setTexture("common_ui/peach_bg.png")
		--标签
		self.peachNumLabel_ = cc.ui.UILabel.new({
            UILabelType = 1,text = string.format(dataNumber),font = "fonts/whiteNum.fnt"})
            :scale(0.8)
	        :align(display.CENTER,labelFrame:getContentSize().width * 0.52,labelFrame:getContentSize().height * 0.5)
	        :addTo(labelFrame,2)

	else
		dataNumber = CloudData.ESSENCE
		labelFrame:setTexture("common_ui/essence_bg.png")
		--标签
		self.essenceNumLabel_ = cc.ui.UILabel.new({
            UILabelType = 1,text = string.format(dataNumber),font = "fonts/whiteNum.fnt"})
            :scale(0.8)
	        :align(display.CENTER,labelFrame:getContentSize().width * 0.52,labelFrame:getContentSize().height * 0.5)
	        :addTo(labelFrame,2)
	end

	--记录此时数量为上一次的值（便于刷新的时候判断）
	self.historyDataNum_ = dataNumber
	
	--添加点击事件
	if isEnabled then
		labelFrame:setTouchEnabled(true)
		labelFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            		return self:onTouch(event.name,event.x,event.y)
        		end)
	end

	self:setContentSize(cc.size(labelFrame:getContentSize().width,labelFrame:getContentSize().height))

	--更新标签
	self.schedule_ = self:schedule(function()
		self:updateDataLabel_()
	end, 0.1)
end

function DataLabelIcon:onTouch(event,x,y)
	if event == "began" then
		self.touchBeginPoint_ = {x = x,y = y}
		return true
	end

	if event == "moved" then
       
	end

	if event == "ended" then
		local touchEndedPoint = {x = x,y = y}
		if math.abs(self.touchBeginPoint_.x - touchEndedPoint.x) < 20 and math.abs(self.touchBeginPoint_.y - touchEndedPoint.y) < 20 
		    	and cc.rectContainsPoint(self:getMyBoundingBox(),touchEndedPoint) then
				self:touchLabelIcon_(self.type_)
		end
    end
end

function DataLabelIcon:touchLabelIcon_(labelType)
	local currScene = display.getRunningScene()
	if self.type_ == DataLabelIcon.LABEL_TYPE_ENERGY then
		printf("LABEL_TYPE_ENERGY")
		local ene = BuyEnergyLayer.new()
		ene:setAnchorPoint(0.5,0.5)
		ene:setPosition(self:getParent():getContentSize().width * 0.5,self:getParent():getContentSize().height * 0.5)
		currScene:addChild(ene, 100)

	elseif self.type_ == DataLabelIcon.LABEL_TYPE_EXP then
		printf("LABEL_TYPE_EXP")
		if CloudData.STAGE_PROGRESS < 6 then
			local t = WSToast.new("商店第6关以后开启！")
			currScene:addChild(t, 100)
		else
			display.replaceScene(require("scenes.ShopScene1").new(SHOP_TYPE_EXP_MALL))
		end	
		--[[local exp = BuyExpLayer.new()
			exp:setAnchorPoint(0.5,0.5)
			exp:setPosition(self:getParent():getContentSize().width * 0.5,self:getParent():getContentSize().height * 0.5)
			self:getParent():addChild(exp, 20)--]]

	elseif self.type_ == DataLabelIcon.LABEL_TYPE_PEACH then
		printf("LABEL_TYPE_PEACH")
		if tonumber(CloudData.PEACH) and tonumber(CloudData.PEACH) >= 100000000 then
			local toast = WSToast.new("蟠桃无限，无需充值")
			currScene:addChild(toast, 100)
			return
		end
		--新
		local layer = PaymentLayer.new()
		currScene:addChild(layer,100)
	else
		printf("LABEL_TYPE_ESSENCE")
		if CloudData.STAGE_PROGRESS < 6 then
			local t = WSToast.new("商店第6关以后开启！")
			currScene:addChild(t, 100)
		else
			display.replaceScene(require("scenes.ShopScene1").new(SHOP_TYPE_MYSTERY_BUSINESSMAN))
		end
	end
end

--数据更新
function DataLabelIcon:updateDataLabel_()
	if self.type_ == DataLabelIcon.LABEL_TYPE_ENERGY then
		if self.historyDataNum_ ~= CloudData.ENERGY or self.maxEnergy_ ~= CloudData.MAX_ENERGY then
			self.energyNumLabel_:setString(string.format(CloudData.ENERGY))
			self.maxEnergyNumLabel_:setString(string.format("/"..CloudData.MAX_ENERGY))
			--local progressValue = CloudData.ENERGY / CloudData.MAX_ENERGY * 100
			--self.progress:setPercentage(progressValue)

			--重置上一次的值
			self.historyDataNum_ = CloudData.ENERGY
			self.maxEnergy_ = CloudData.MAX_ENERGY
		end

	elseif self.type_ == DataLabelIcon.LABEL_TYPE_EXP then
		if self.historyDataNum_ ~= CloudData.EXP then
			self.expNumLabel_:setString(string.format(CloudData.EXP))
			--重置上一次的值
			self.historyDataNum_ = CloudData.EXP
		end

	elseif self.type_ == DataLabelIcon.LABEL_TYPE_PEACH then
		if self.historyDataNum_ ~= CloudData.PEACH then
			self.peachNumLabel_:setString(string.format(CloudData.PEACH))
			--重置上一次的值
			self.historyDataNum_ = CloudData.PEACH
		end
		
	else
		if self.historyDataNum_ ~= CloudData.ESSENCE then
			self.essenceNumLabel_:setString(string.format(CloudData.ESSENCE))
			--重置上一次的值
			self.historyDataNum_ = CloudData.ESSENCE
		end
		
	end
end

function DataLabelIcon:getMyBoundingBox()
	local rect = cc.rect(self:getPositionX() - self:getContentSize().width * 0.5,
		self:getPositionY() - self:getContentSize().height * 0.5,
		self:getContentSize().width,
		self:getContentSize().height);

	return rect;
end

return DataLabelIcon

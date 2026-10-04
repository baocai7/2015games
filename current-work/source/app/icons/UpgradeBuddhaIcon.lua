--
--升级界面“神仙”
--

local UpgradeBuddhaIcon = class("UpgradeBuddhaIcon", function()
	return display.newNode()
end)

function UpgradeBuddhaIcon:ctor(buddhaModel)

	--获取兵种model
	self.model_ = buddhaModel
	buddhaModel = nil

	--初始化兵种数据
	self:initData()
	
	--底层背景
	self.underlyingBg_ = display.newSprite("upgrade/component.png")
	self.underlyingBg_:setAnchorPoint(cc.p(0,0))
	self:setContentSize(cc.size(self.underlyingBg_:getContentSize().width,self.underlyingBg_:getContentSize().height))
	self:addChild(self.underlyingBg_)
	if self.buddhaState_ ~= 1 then
		self.underlyingBg_:setTexture("upgrade/gray.png")
	end

	--兵种图标
	self.buddhaPic_ = nil
	if self.buddhaState_ == 1 then
		self.buddhaPic_ = display.newSprite(string.format(self.model_.icon_),
			self.underlyingBg_:getContentSize().width * 0.2,self.underlyingBg_:getContentSize().height * 0.5)
			:addTo(self.underlyingBg_)
	else
		local __filters, __params = unpack({"GRAY",{0.2, 0.3, 0.5, 0.1}})
		self.buddhaPic_ = display.newFilteredSprite(string.format(self.model_.icon_), __filters, __params):addTo(self.underlyingBg_)
		self.buddhaPic_:setPosition(cc.p(self.underlyingBg_:getContentSize().width * 0.2,self.underlyingBg_:getContentSize().height * 0.5))
	end

	--兵种头像边框
	self.buddhaPicFrame_ = nil
	if self.buddhaState_ ~= 1 then
		self.buddhaPicFrame_ = display.newSprite("upgrade/lockq.png",
			self.underlyingBg_:getContentSize().width * 0.2,self.underlyingBg_:getContentSize().height * 0.5)
			:addTo(self.underlyingBg_)
	else
		self.buddhaPicFrame_ = display.newSprite(string.format("upgrade/q"..(self.quality_ + 1)..".png"),
			self.underlyingBg_:getContentSize().width * 0.2,self.underlyingBg_:getContentSize().height * 0.5)
			:addTo(self.underlyingBg_)
	end

	--石头剪刀布标识
	self.restrainMark_ = nil
	local buddhaRestrainType = tonumber(self.model_.restrainType_)
	if buddhaRestrainType > 0 and buddhaRestrainType < 4 then
		if self.buddhaState_ ~= 1 then
			local __filters, __params = unpack({"GRAY",{0.2, 0.3, 0.5, 0.1}})
			self.restrainMark_ = display.newFilteredSprite(string.format("buddha_icon/restrain_icon"..buddhaRestrainType..".png"), __filters, __params):addTo(self.underlyingBg_,1)
			self.restrainMark_:setPosition(cc.p(self.underlyingBg_:getContentSize().width * 0.2,self.underlyingBg_:getContentSize().height * 0.5))
		else
			self.restrainMark_ = display.newSprite(string.format("buddha_icon/restrain_icon"..buddhaRestrainType..".png"))
				:pos(self.underlyingBg_:getContentSize().width * 0.2,self.underlyingBg_:getContentSize().height * 0.5)
				:addTo(self.underlyingBg_,1)
		end
	end

	--兵种名字
	self.buddhaNameLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = self.name_,size = 25,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.underlyingBg_:getContentSize().width * 0.65,self.underlyingBg_:getContentSize().height * 0.68)
        :addTo(self.underlyingBg_)

    --召唤所消耗的灵气
    self.spiritFrame_ = display.newSprite("upgrade/lingqi.png",
    	self.underlyingBg_:getContentSize().width * 0.2 - 4,self.underlyingBg_:getContentSize().height * 0.23)
    	:hide()
    	:addTo(self.underlyingBg_,1)
	self.spiritNumLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = tonumber(self.model_.costValue_),size = 18,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.spiritFrame_:getContentSize().width * 0.55,self.spiritFrame_:getContentSize().height * 0.37)
        :addTo(self.spiritFrame_)

    --锁
    self.lock_ = display.newSprite("common_ui/upgradelock.png",
		self.underlyingBg_:getContentSize().width * 0.80,self.underlyingBg_:getContentSize().height * 0.25)
		:addTo(self.underlyingBg_)
	if self.buddhaState_ == 1 then
		self.spiritFrame_:show()
		self.lock_:setVisible(false)
	else
		if self.isRebel_ == 1 then
			local summonPieceId = tonumber(self.model_.summonPieceId_)
    		local monsterPiecemodel = DataUtils.getMonsterPieceModel(summonPieceId)
    		if tonumber(self.model_.summonNum_) <= tonumber(monsterPiecemodel.currentNum_) then
				self.lock_:setTexture("upgrade/cancall.png")  --此时显示可召唤
			end
		end	
	end
	
	--兵种等级
    self.buddhaLevelLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = string.format("LV."..self.currentlevel_),size = 25,color = cc.c3b(100,47,5),font = GameManager.FONTNAME_TTF})
    	:hide()
        :align(display.CENTER,self.underlyingBg_:getContentSize().width * 0.48,self.underlyingBg_:getContentSize().height * 0.28)
        :addTo(self.underlyingBg_)
    --兵种突破等级
    self.buddhaAddtionalLevelLabel_ = cc.ui.UILabel.new({
        UILabelType = 1,text = string.format("+"..self.addtionalLevel_),font = "fonts/greenNum.fnt"})
    	:scale(0.7)
    	:hide()
        :align(display.CENTER,self.underlyingBg_:getContentSize().width * 0.70,self.underlyingBg_:getContentSize().height * 0.28)
        :addTo(self.underlyingBg_)

    --妖怪兵种与神仙兵种的区别
    if self.isRebel_ == 1 then
		self.buddhaPic_:setScaleX(-1)
		if self.buddhaState_ == 1 then
			--兵种突破等级
		    self.buddhaAddtionalLevelLabel_:show()  
		end
	else
		if self.buddhaState_ == 1 then
			--兵种等级
		    self.buddhaLevelLabel_:show()
		    if self.currentlevel_ == 20 then
		    	--兵种突破等级
			    self.buddhaAddtionalLevelLabel_:show()        
		    end  
		end  
	end
end

function UpgradeBuddhaIcon:initData(index)
	--当前兵种状态(0:未解锁  1:已解锁  2:已拥有)
	self.buddhaState_ = tonumber(self.model_.buddhaState_)
	--是否为妖怪叛变来的兵种(降妖) 0：不是 1：是
	self.isRebel_ = tonumber(self.model_.isRebel_)
	--兵种品质: 白 绿 蓝 紫 金
	self.quality_ = tonumber(self.model_.quality_)
	--兵种名字
	self.name_ = self.model_.name_
	--兵种当前等级
	self.currentlevel_ = self.model_.level_
	--兵种突破等级
	self.addtionalLevel_ = self.model_.addLevel_
end

function UpgradeBuddhaIcon:setNormal()
	self.underlyingBg_:setTexture("upgrade/component.png")
end

function UpgradeBuddhaIcon:setSelected()
	self.underlyingBg_:setTexture("upgrade/component_h.png")
end

function UpgradeBuddhaIcon:setLocked()
	self.underlyingBg_:setTexture("upgrade/gray.png")
end

--等级显示
function UpgradeBuddhaIcon:showLevel(buddhaModel)
	if self.isRebel_ == 1 then
		if buddhaModel.buddhaState_ == 1 then
			self.buddhaAddtionalLevelLabel_:show()
			self.buddhaAddtionalLevelLabel_:setString(string.format("+"..tonumber(buddhaModel.addLevel_)))
		end
	else
		if buddhaModel.buddhaState_ == 1 then
			self.buddhaLevelLabel_:show()
			self.buddhaLevelLabel_:setString(string.format("LV."..tonumber(buddhaModel.level_)))
			if tonumber(buddhaModel.level_) == 20 then
				self.buddhaAddtionalLevelLabel_:show()
				self.buddhaAddtionalLevelLabel_:setString(string.format("+"..tonumber(buddhaModel.addLevel_)))
			end
		end
	end
end

--十级后头像更新,名字更新,灵气值更新
function UpgradeBuddhaIcon:updateIcon(buddhaModel)
	self.buddhaPicFrame_:setTexture(string.format("upgrade/q"..(buddhaModel.quality_ + 1)..".png"))
	self.buddhaPic_:setTexture(buddhaModel.icon_)
	self.buddhaNameLabel_:setString(buddhaModel.name_)
	self.spiritNumLabel_:setString(tonumber(buddhaModel.costValue_))
end

--召唤成功后的界面更新
function UpgradeBuddhaIcon:updateUI(buddhaModel)
	--边框,头像变为彩色
	self.buddhaPic_ = display.newSprite(string.format(buddhaModel.icon_),
		self.underlyingBg_:getContentSize().width * 0.2,self.underlyingBg_:getContentSize().height * 0.5)
		:addTo(self.underlyingBg_)
	--self.buddhaPic_:setTexture(string.format(buddhaModel.icon_))
	self.buddhaPic_:setScaleX(-1)
	self.buddhaPicFrame_:setTexture(string.format("upgrade/q"..(self.quality_ + 1)..".png"))
	--剪刀石头布标识变为彩色
	local buddhaRestrainType = tonumber(buddhaModel.restrainType_)
	if buddhaRestrainType > 0 and buddhaRestrainType < 4 then
		if self.restrainMark_ ~= nil then
			self.restrainMark_:removeSelf()
			self.restrainMark_ = nil
		end
		self.restrainMark_ = display.newSprite(string.format("buddha_icon/restrain_icon"..buddhaRestrainType..".png"))
			:pos(self.underlyingBg_:getContentSize().width * 0.2,self.underlyingBg_:getContentSize().height * 0.5)
			:addTo(self.underlyingBg_,1)
	end
	
	--突破等级显示
	self.buddhaAddtionalLevelLabel_:show()
	self.buddhaAddtionalLevelLabel_:setString(string.format("+"..tonumber(buddhaModel.addLevel_)))
	--灵气显示
	self.spiritFrame_:show()
	--可召唤图标消失
	self.lock_:setVisible(false)
end

function UpgradeBuddhaIcon:getMyBoundingBox()
	--转换世界坐标系
	local point = cc.p(self:getPositionX(),self:getPositionY())
	local worldpoint = self:getParent():convertToWorldSpace(point)
	local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5,
		worldpoint.y - self:getContentSize().height * 0.5,
		self:getContentSize().width,
		self:getContentSize().height)
	return rect
end

return UpgradeBuddhaIcon
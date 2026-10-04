--
--兵种图标（WikiScene）
--

local MonsterIcon  =  class("MonsterIcon", function()
	return display.newNode()
end)

function MonsterIcon:ctor(MonsterModel)
	--读取兵种相关信息
	local MonsterIcon    = MonsterModel.icon_
	self.buddhaQuality_ = MonsterModel.quality_ + 1
	self.buddhaId_      = tonumber(MonsterModel.npcId_) 
	self.isOnTeam_      = false
	self.isSelectedInWiki_ = false

	--兵种头像外框
	local iconFrame = display.newSprite("upgrade/q"..self.buddhaQuality_..".png"):addTo(self)

	--兵种头像
	self.icon_ = display.newSprite(MonsterIcon,iconFrame:getContentSize().width * 0.5,iconFrame:getContentSize().height * 0.5)
		:addTo(iconFrame)

	--石头剪刀布标识
	local monsterRestrainType = tonumber(MonsterModel.restrainType_)
	if monsterRestrainType > 0 and monsterRestrainType < 4 then
		local pMark = display.newSprite(string.format("buddha_icon/restrain_icon"..monsterRestrainType..".png"))
			:pos(iconFrame:getContentSize().width * 0.5,iconFrame:getContentSize().height * 0.5)
			:addTo(iconFrame)
	end

	--self:setTouchEnabled(true)   
	--self:setContentSize(cc.size(iconFrame:getContentSize().width,iconFrame:getContentSize().height))
	
	--图鉴中被选中的标识
	self.beSelectedInWiki_ = display.newSprite("wiki/frame_tp_s.png",iconFrame:getContentSize().width * 0.5,iconFrame:getContentSize().height * 0.5)
		:addTo(iconFrame,2)
	self.beSelectedInWiki_:setVisible(false)
end

function MonsterIcon:onClicked()
	local seq = transition.sequence({cc.ScaleTo:create(0.1,1.1),cc.ScaleTo:create(0.1,1.0)})
	self:runAction(seq)
end

function MonsterIcon:setOnTeam(isOnTeam)
	if isOnTeam then
		self.onTeamMark_:setVisible(true)
	else
		self.onTeamMark_:setVisible(false)
	end
	self.isOnTeam_ = isOnTeam
end

function MonsterIcon:getOnTeam()
	return self.isOnTeam_
end

function MonsterIcon:getMyBoundingBox()
	--转换世界坐标系
	local point = cc.p(self:getPositionX(),self:getPositionY())
	local worldpoint = self:getParent():convertToWorldSpace(point)
	local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5,
		worldpoint.y - self:getContentSize().height * 0.5,
		self:getContentSize().width,
		self:getContentSize().height);
	return rect;
end

function MonsterIcon:selectedInWiki(isSelected)
	if isSelected then
		self.beSelectedInWiki_:setVisible(true)
	else
		self.beSelectedInWiki_:setVisible(false)
	end
	self.isSelectedInWiki_ = isSelected
end

return MonsterIcon
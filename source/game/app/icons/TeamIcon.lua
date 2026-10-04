--
--队伍界面上方阵形格子图标（TeamScene）
--
local BuddhaIcon     = import("icons.BuddhaIcon")

local TeamIcon  =  class("TeamIcon", function()
	return display.newNode()
end)

function TeamIcon:ctor(isUnlocked)
	--isUnlocked:标识当前格子是否解锁，true->解锁，false->未解锁

	--当前格子上是否有兵种（默认为false）
	self.isHaveBuddha_ = false

	--获取图标文件名
	local fileName
	local bottom
	if isUnlocked then
		fileName = "common_ui/touicon.png"
		bottom = "team/bottom.png"
	else
		fileName = "common_ui/touiconlock.png"
		bottom = "team/bottom_lock.png"
	end

	--阵形格子图标
	self.icon_ = display.newSprite(fileName)
		:scale(0.85)
		:addTo(self)

	self:setTouchEnabled(true)   
	self:setContentSize(cc.size(self.icon_:getContentSize().width * 0.9,self.icon_:getContentSize().height * 0.9))
	
	self.iconBottom_ = display.newSprite(bottom,self.icon_:getContentSize().width * 0.5, -self.icon_:getContentSize().height * 0.12)
		:scale(1.35)
		:addTo(self.icon_)
end

--设置当前格子的上阵情况
function TeamIcon:setBuddhaOn(isHaveBuddha)
	self.isHaveBuddha_ = isHaveBuddha
end
--获取当前格子的上阵情况
function TeamIcon:getBuddhaOn()
	return self.isHaveBuddha_
end

--兵种上阵时添加兵种图标
function TeamIcon:addBuddhaPic(buddhaId)
	local buddhaModel = DataUtils.getBuddhaModel(buddhaId)
	
	self.buddhaPic_ = BuddhaIcon.new(buddhaModel)
		self.buddhaPic_:setScale(1.4)
        self.buddhaPic_:setPosition(self.icon_:getContentSize().width * 0.5,self.icon_:getContentSize().height * 0.5)
        --self.buddhaPic_:setTouchSwallowEnabled(false)
        self.icon_:addChild(self.buddhaPic_)
	
	self.buddhaId_ = buddhaId
	--self.buddhaPic_ = display.newSprite(buddhaModel.icon_,self.icon_:getContentSize().width * 0.5,self.icon_:getContentSize().height * 0.5)
	--	:scale(1.4)
	--	:addTo(self.icon_)
	--石头剪刀布标识
	--[[local buddhaRestrainType = tonumber(buddhaModel.restrainType_)
	if buddhaRestrainType > 0 and buddhaRestrainType < 4 then
		local pMark = display.newSprite(string.format("buddha_icon/restrain_icon"..buddhaRestrainType..".png"))
			:pos(self.buddhaPic_:getContentSize().width * 0.5,self.buddhaPic_:getContentSize().height * 0.5)
			:addTo(self.buddhaPic_)
	end	--]]
end
--兵种下阵时移除兵种图标
function TeamIcon:removeBuddhaPic()
	self.buddhaPic_:removeFromParent()
	self.buddhaId_ = nil
end

--解锁格子时调用
function TeamIcon:iconUnlock()
	self.icon_:setTexture("common_ui/touicon.png")
	self.iconBottom_:setTexture("team/bottom.png")
end
function TeamIcon:onClicked()
	local seq = transition.sequence({cc.ScaleTo:create(0.1,0.94),cc.ScaleTo:create(0.1,0.85)})
	self:runAction(seq)
end

function TeamIcon:getMyBoundingBox()
	--转换世界坐标系
	local point = cc.p(self:getPositionX(),self:getPositionY())
	local worldpoint = self:getParent():convertToWorldSpace(point)
	local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5,
		worldpoint.y - self:getContentSize().height * 0.5,
		self:getContentSize().width,
		self:getContentSize().height)
	return rect
end

return TeamIcon
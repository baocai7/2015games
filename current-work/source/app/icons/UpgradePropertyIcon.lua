--
--升级界面唐僧属性，宝塔属性
--

local UpgradePropertyIcon = class("UpgradePropertyIcon", function()
	return display.newNode()
end)

function UpgradePropertyIcon:ctor(propertyModel)

	--获取属性model
	self.model_ = propertyModel
	buddhaModel = nil

	--初始化各项属性数据
	self:initData()
	
	--底层背景
	self.underlyingBg_ = display.newSprite("upgrade/component.png")
	self.underlyingBg_:setAnchorPoint(cc.p(0,0))
	self:setContentSize(cc.size(self.underlyingBg_:getContentSize().width,self.underlyingBg_:getContentSize().height))
	self:addChild(self.underlyingBg_)

	--属性图标
	local propertyPic = display.newSprite(string.format(self.model_.icon_),
		self.underlyingBg_:getContentSize().width * 0.2,self.underlyingBg_:getContentSize().height * 0.5)
		:addTo(self.underlyingBg_)
	--属性图标边框
	local propertyPicFrame = display.newSprite("common_ui/tou.png",
		self.underlyingBg_:getContentSize().width * 0.2,self.underlyingBg_:getContentSize().height * 0.5)
		:addTo(self.underlyingBg_)
	--属性名称
	self.propertyNameLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = self.name_,size = 25,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.underlyingBg_:getContentSize().width * 0.65,self.underlyingBg_:getContentSize().height * 0.68)
        :addTo(self.underlyingBg_)
    --属性等级
    self.propertyLevelLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = string.format("LV."..self.level_),size = 25,color = cc.c3b(100,47,5),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.underlyingBg_:getContentSize().width * 0.48,self.underlyingBg_:getContentSize().height * 0.28)
        :addTo(self.underlyingBg_)

    --满级状态
    self.maxLevelPic_ = display.newSprite("upgrade/maxlevel.png",
		self.underlyingBg_:getContentSize().width * 0.8,self.underlyingBg_:getContentSize().height * 0.25)
    	:hide()
		:addTo(self.underlyingBg_)
    if tonumber(self.level_) == 20 then
    	self.maxLevelPic_:show()
    end 
end

function UpgradePropertyIcon:initData()
	self.icon_  = self.model_.icon_              --属性图标
	self.name_  = self.model_.cnName_            --属性名称
	self.level_ = self.model_.level_             --属性等级
end

function UpgradePropertyIcon:setNormal()
	self.underlyingBg_:setTexture("upgrade/component.png")
end

function UpgradePropertyIcon:setSelected()
	self.underlyingBg_:setTexture("upgrade/component_h.png")
end

--等级显示
function UpgradePropertyIcon:showLevel(propertyModel)
	self.propertyLevelLabel_:setString("LV."..tonumber(propertyModel.level_))
	if tonumber(propertyModel.level_) == 20 then
		self.maxLevelPic_:show()
	end
end

function UpgradePropertyIcon:getMyBoundingBox()
	--转换世界坐标系
	local point = cc.p(self:getPositionX(),self:getPositionY())
	local worldpoint = self:getParent():convertToWorldSpace(point)
	local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5,
		worldpoint.y - self:getContentSize().height * 0.5,
		self:getContentSize().width,
		self:getContentSize().height)
	return rect
end

return UpgradePropertyIcon
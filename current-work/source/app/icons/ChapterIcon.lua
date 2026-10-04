local ChapterIcon  =  class("ChapterIcon", function()
	return display.newNode()
end)

function ChapterIcon:ctor(index,chapterNum)
	--index:1为解锁,2为未解锁
	--chapterNum:章节编号

	self.index_ = index

	if index == 1 then
		self.icon = display.newSprite("chapter/stage_icon"..chapterNum..".png")
		self.isUnlock = true
	elseif index == 2 then
		-- self.icon = display.newSprite("chapter/stage_icon"..chapterNum.."_h.png")
        -- local __filters, __params = unpack({"GRAY",{0.2, 0.3, 0.5, 0.1}})
        -- self.icon = display.newFilteredSprite("chapter/stage_icon"..chapterNum..".png",__filters, __params)
        self.icon = display.newGraySprite("chapter/stage_icon"..chapterNum..".png",{0.2, 0.3, 0.5, 0.1})
		self.isUnlock = false
	end

	self:setContentSize(cc.size(self.icon:getContentSize().width,self.icon:getContentSize().height))
	self:addChild(self.icon)
end

function ChapterIcon:addTouchListener(listener)
	self.icon:setTouchEnabled(true)
	self.icon:setTouchSwallowEnabled(true)
	self.icon:addNodeEventListener(cc.NODE_TOUCH_EVENT,listener)
end

function ChapterIcon:getMyBoundingBox()
	--转换世界坐标系
	local point = cc.p(self:getPositionX(),self:getPositionY())
	local worldpoint = self:getParent():convertToWorldSpace(point)
	local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5,
		worldpoint.y - self:getContentSize().height * 0.5,
		self:getContentSize().width,
		self:getContentSize().height);
	return rect;
end

return ChapterIcon

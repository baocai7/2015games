local SceneIcon = {} 
SceneIcon = class("SceneIcon", function()
	return display.newNode()
end)

function SceneIcon:ctor(index)
	self.icon_ = nil
	if index == 1 then
		self.icon_ = display.newSprite("chapter/team.png")
	elseif index == 2 then
		self.icon_ = display.newSprite("chapter/upgrade.png")
	elseif index == 3 then
		self.icon_ = display.newSprite("chapter/summon.png")
	elseif index == 4 then
		self.icon_ = display.newSprite("chapter/treasure.png")
	elseif index == 5 then
		self.icon_ = display.newSprite("chapter/achievement.png")
	elseif index == 6 then
		self.icon_ = display.newSprite("chapter/shop.png")
	end

	self.mark_ = display.newSprite("common_ui/new.png",self.icon_:getContentSize().width * 0.75,self.icon_:getContentSize().height * 0.86)
		:hide()
		:addTo(self.icon_,1)

	self:setContentSize(cc.size(self.icon_:getContentSize().width,self.icon_:getContentSize().height))
	self:addChild(self.icon_)
end

function SceneIcon:addTouchListener(listener)
	self.icon_:setTouchEnabled(true)
	self.icon_:setTouchSwallowEnabled(true)
	self.icon_:addNodeEventListener(cc.NODE_TOUCH_EVENT,listener)
end

--"new"标识提示
function SceneIcon:setMarkVisible(flag)
	if flag then
		self.mark_:setVisible(true)
		local seq = transition.sequence({cc.FadeOut:create(0.5),cc.FadeIn:create(0.5)})
		self.mark_:runAction(cc.RepeatForever:create(seq))
	else
		self.mark_:setVisible(false)
	end
end

function SceneIcon:getMyBoundingBox()
	local rect = cc.rect(self:getPositionX() - self:getContentSize().width * 0.5,
		self:getPositionY() - self:getContentSize().height * 0.5,
		self:getContentSize().width,
		self:getContentSize().height);

	return rect;
end

return SceneIcon

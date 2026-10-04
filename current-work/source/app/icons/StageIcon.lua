local StageIcon  =  class("StageIcon", function()
	return display.newNode()
end)

function StageIcon:ctor(stageModel)
	--初始化model
	self.stageModel_ = stageModel

	--关卡图标（正常，被选择，未解锁）
	self.normalIcon_ = display.newSprite("stage/stage_normal.png"):addTo(self)
	self.selectedIcon_ = display.newSprite("stage/stage_selected.png"):addTo(self)
	self.lockIcon_ = display.newSprite("stage/stage_locked.png"):addTo(self)
	self.normalIcon_:setVisible(false)
	self.selectedIcon_:setVisible(false)
	self.lockIcon_:setVisible(false)

	self:setContentSize(cc.size(self.normalIcon_:getContentSize().width,self.normalIcon_:getContentSize().height))
end

function StageIcon:addTouchListener(listener)
	local icons = {self.normalIcon_,self.selectedIcon_,self.lockIcon_}
	for _,icon in ipairs(icons) do
		icon:setTouchEnabled(true)
		icon:setTouchSwallowEnabled(true)
		icon:addNodeEventListener(cc.NODE_TOUCH_EVENT,listener)
	end
end

function StageIcon:setNormal()
	self.normalIcon_:setVisible(true)
	self.selectedIcon_:setVisible(false)
	self.lockIcon_:setVisible(false)
end

function StageIcon:setSelected()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch.%s",GameManager.POSTFIX))
	end
	self.normalIcon_:setVisible(true)
	self.selectedIcon_:setVisible(true)
	self.lockIcon_:setVisible(false)
end

function StageIcon:setLocked()
	self.normalIcon_:setVisible(false)
	self.selectedIcon_:setVisible(false)
	self.lockIcon_:setVisible(true)
end

function StageIcon:getMyBoundingBox()
	--转换世界坐标系
	local point = cc.p(self:getPositionX(),self:getPositionY())
	local worldpoint = self:getParent():convertToWorldSpace(point)
	local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5,
		worldpoint.y - self:getContentSize().height * 0.5,
		self:getContentSize().width,
		self:getContentSize().height);
	return rect;
end

return StageIcon

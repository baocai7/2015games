--
--宝物碎片
--

TAG_TREASURE_PIECE_LAYER = 1

local TreasurePieceInfoLayer = import("layers.TreasurePieceInfoLayer")
local NoviceGuide            = import("utils.NoviceGuide")
local AlertConnection        = import("customs.AlertConnection")

local TreasurePieceIcon  =  class("TreasurePieceIcon", function()
	return display.newNode()
end)

function TreasurePieceIcon:ctor(treasurePieceModel)
	--碎片id
	self.id_ = tonumber(treasurePieceModel.treasurePieceId_) 
	self.selectedId_ = 0
	--碎片品质
	local treasurePieceQuality = tonumber(treasurePieceModel.treasurePieceQuality_) 

	--碎片边框
	local pieceFrame = display.newSprite("treasure/frame_tp.png"):addTo(self)
	--碎片图标
	display.newSprite(string.format("treasure/q"..treasurePieceQuality..".png"),
		pieceFrame:getContentSize().width * 0.5,pieceFrame:getContentSize().height * 0.5)
		:addTo(pieceFrame)

	--选中时的边框
	self.selectedIcon_ = display.newSprite("treasure/piece_selected.png"):addTo(self)
	self.selectedIcon_:setVisible(false)

	--添加点击事件
	pieceFrame:setTouchEnabled(true)
	pieceFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name,event.x,event.y)
    end)
	self:setContentSize(pieceFrame:getContentSize())

	--检测弹窗是否存在
	self.schedule_ = self:schedule(function()
		self:updateLayer_()
	end, 0.1)
end

function TreasurePieceIcon:onTouch(event,x,y)
	if event == "began" then
		self.touchBeginPoint_ = {x = x,y = y}
		return true
	end

	if event == "moved" then
       
	end

	if event == "ended" then
		local touchEndedPoint = {x = x,y = y}
		if math.abs(self.touchBeginPoint_.x - touchEndedPoint.x) < 10 and math.abs(self.touchBeginPoint_.y - touchEndedPoint.y) < 10 
		    	and cc.rectContainsPoint(self:getMyBoundingBox(),touchEndedPoint) then
			self:touchPieceIcon_()
		end
    end
end

--点击碎片弹出碎片相关信息
function TreasurePieceIcon:touchPieceIcon_()
	self.selectedId_ = self.id_
	local layer = TreasurePieceInfoLayer.new(self.id_)
    display.getRunningScene():addChild(layer,20,TAG_TREASURE_PIECE_LAYER)
end

--检测弹窗是否存在
function TreasurePieceIcon:updateLayer_()
	if display.getRunningScene():getChildByTag(TAG_TREASURE_PIECE_LAYER) then
		if self.selectedId_ == self.id_ then
			self.selectedIcon_:setVisible(true)
			self.selectedId_ = 0
		end
	else
		self.selectedIcon_:setVisible(false)
	end
end

function TreasurePieceIcon:getMyBoundingBox()
	--转换世界坐标系
	local point = cc.p(self:getPositionX(),self:getPositionY())
	local worldpoint = self:getParent():convertToWorldSpace(point)
	local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5,
		worldpoint.y - self:getContentSize().height * 0.5,
		self:getContentSize().width,
		self:getContentSize().height);
	return rect;
end

return TreasurePieceIcon
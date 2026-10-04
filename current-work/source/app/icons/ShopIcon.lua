
local AlertConnection = import("customs.AlertConnection")
local ShopIconDetailLayer = import("layers.ShopIconDetailLayer")

local ShopIcon  =  class("ShopIcon", function()
	return display.newNode()
end)

function ShopIcon:ctor(content, index)
	dump(content)
	self:initData(content, index)
end

function ShopIcon:initData(content, index)
--	print("***********************")
	self.no_ = index
	self.costType_ = content.goods.costType    --self.shopInfo_.data[index].costType
	self.desc_ = content.goods.desc    --self.shopInfo_.data[index].desc
	self.discount_ = content.goods.discount    --self.shopInfo_.data[index].discount
	self.goodsId_ = content.goods.goodsId    --self.shopInfo_.data[index].goodsId
	self.goodsName_ = content.goods.goodsName    --self.shopInfo_.data[index].goodsName
	self.itemId_ = content.goods.itemId    --self.shopInfo_.data[index].itemId
	self.num_ = content.goods.num    --self.shopInfo_.data[index].num
	self.pic_ = content.goods.pic    --self.shopInfo_.data[index].pic
	self.price_ = content.goods.price    --self.shopInfo_.data[index].price
	self.type_ = content.goods.type    --self.shopInfo_.data[index].type
	self.isBought_ = content.flag	
--[[	print("costType_ = " .. self.costType_)
	print("desc_ = " .. self.desc_)
	print(self.discount_)
	print("goodsId_ = " .. self.goodsId_)
	print("goodsName_ = " .. self.goodsName_)
	print("itemId_ = " .. self.itemId_)
	print("num_ = " .. self.num_)
	print("pic_ = " .. self.pic_)
	print("price_ = " .. self.price_)
	print("type_ = " .. self.type_)
	print("isBought_ = " .. self.isBought_)
	print("***********************")--]]
	
	self:initContent(content)
end

function ShopIcon:initContent(content)
	self.icon = display.newSprite("shop/shopkuang.png")
		self.icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
				return self:buyPropCallBack_(content, self.no_)
			end)
		self.icon:setTouchEnabled(true)
	self:setContentSize(cc.size(self.icon:getContentSize().width,self.icon:getContentSize().height))
	self:addChild(self.icon)
	
	cc.ui.UILabel.new({UILabelType = 2,text = self.goodsName_,size = 26,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.icon:getContentSize().width * 0.5,self.icon:getContentSize().height * 0.8)
        :addTo(self.icon)
	
	local sca = 1
	if self.type_ == "buddha" then
		local BuddhaModel = DataUtils.getBuddhaModel(self.itemId_)
		local quality = tonumber(BuddhaModel.quality_) + 1
		print("buddhaModel.quality_ = " .. quality)
		local buddhaFrame_ = display.newSprite("upgrade/q"..quality..".png", self.icon:getContentSize().width * 0.5,
			self.icon:getContentSize().height * 0.5 - 5)
			:scale(0.75)
			:addTo(self.icon)
		sca = 0.75
	end	
	
    local buddhaIcon_ = display.newSprite(self.pic_, self.icon:getContentSize().width * 0.5,
			self.icon:getContentSize().height * 0.5 - 5)
		:scale(sca)
        :addTo(self.icon)
	
	cc.ui.UILabel.newBMFontLabel_({text = self.num_, font = "fonts/yellowNum.fnt"})	
		:scale(0.6)
        :align(display.CENTER,buddhaIcon_:getPositionX() + 60,
            buddhaIcon_:getPositionY() - buddhaIcon_:getContentSize().height * 0.32)
        :addTo(self.icon)
	
	local img_, sca , x, y
	if self.costType_ == 1 then
		img_ = "shop/shopprice1.png"
		sca = 0.7
		x = 40
		y = 0
	else
		img_ = "shop/shopprice.png"
		sca = 0.8
		x = 10
		y = 3
	end
	
    local priceSprite_ = display.newSprite(img_, self.icon:getContentSize().width * 0.5, 
			self.icon:getContentSize().height * 0.15)
        :addTo(self.icon)
	
	cc.ui.UILabel.newBMFontLabel_({text = self.price_, font = "fonts/whiteNum.fnt"})	
    --cc.ui.UILabel.new({UILabelType = 2,text = self.price_, size = 30,})
		:scale(sca)
        :align(display.CENTER,priceSprite_:getPositionX() + x,priceSprite_:getPositionY() + y)
        :addTo(self.icon)
		
	if self.isBought_ ~= 0 then
		display.newSprite("shop/soldout.png", self.icon:getContentSize().width * 0.5,self.icon:getContentSize().height * 0.5)
			:addTo(self.icon)
	elseif self.discount_ then
		display.newSprite("shop/promotion.png", self.icon:getContentSize().width * 0.24,self.icon:getContentSize().height * 0.84)
			:addTo(self.icon)
	end
end

function ShopIcon:buyPropCallBack_(content, index)
	if self.isBought_ == 0 then
		print("To Buy------")
		local detail = ShopIconDetailLayer.new(content, index)
		display.getRunningScene():addChild(detail,20)
	end
end

function ShopIcon:soldOut()
	print("soldOut")
	self.isBought_ = 1
	display.newSprite("shop/soldout.png", self.icon:getContentSize().width * 0.5,self.icon:getContentSize().height * 0.5)
		:addTo(self.icon, 100)
end

return ShopIcon
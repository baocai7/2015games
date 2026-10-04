
local AlertConnection = import("customs.AlertConnection")
local WSToast = import("utils.WSToast")

local ShopIconDetailLayer =  class("ShopIconDetailLayer", function()
	return display.newNode()
end)

function ShopIconDetailLayer:ctor(content, index)
	--添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150))
		:addTo(self,-1)
	
	--初始化基础节点	
	self.emptyNode_ = display.newNode()
		:scale(0)
		:pos(display.cx, display.cy)
		:addTo(self,1)
	
	--弹出效果	
	local popupLayer = transition.sequence(
			{cc.ScaleTo:create(0.2, 1.1),
			cc.ScaleTo:create(0.1, 1.0)})
		self.emptyNode_:runAction(popupLayer)
			
	local ac = AlertConnection.new(CONNECTION_SHOP_INIT)
    self:addChild(ac, 100, 12345)
	
    self.scheduleResult_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)
            self.shopInfo_ = CloudData.SHOP_INFO
            --dump(self.shopInfo_)
			self:initData(content, index)
        end
    end,0.1)
end

function ShopIconDetailLayer:initData(content, index)
	print("***********************")
	self.no_ = index
	self.costType_ = tonumber(content.goods.costType)    --self.shopInfo_.data[index].costType
	self.desc_ = content.goods.desc    --self.shopInfo_.data[index].desc
	self.discount_ = content.goods.discount    --self.shopInfo_.data[index].discount
	self.goodsId_ = content.goods.goodsId    --self.shopInfo_.data[index].goodsId
	self.goodsName_ = content.goods.goodsName    --self.shopInfo_.data[index].goodsName
	self.itemId_ = content.goods.itemId    --self.shopInfo_.data[index].itemId
	self.num_ = content.goods.num    --self.shopInfo_.data[index].num
	self.pic_ = content.goods.pic    --self.shopInfo_.data[index].pic
	self.price_ = content.goods.price    --self.shopInfo_.data[index].price
	self.type_ = content.goods.type    --self.shopInfo_.data[index].type
--[[	print("costType_ = " .. self.costType_)
	print("desc_ = " .. self.desc_)
	print(self.discount_)
	print("goodsId_ = " .. self.goodsId_)
	print("goodsName_ = " .. self.goodsName_)
	print("itemId_ = " .. self.itemId_)
	print("num_ = " .. self.num_)
	print("pic_ = " .. self.pic_)
	print("price_ = " .. self.price_)
	print("type_ = " .. self.type_)--]]
	print("***********************")
	self:initContent()
end

function ShopIconDetailLayer:initContent()
	self.bg_ = display.newSprite("shop/tips.png")
		:addTo(self.emptyNode_)
	
	cc.ui.UILabel.new({UILabelType = 2,text = self.goodsName_,size = 25,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.63,self.bg_:getContentSize().height * 0.88)
        :addTo(self.bg_)
	
	local sca = 1
	if self.type_ == "buddha" then
		local BuddhaModel = DataUtils.getBuddhaModel(self.itemId_)
		local quality = tonumber(BuddhaModel.quality_) + 1
		print("buddhaModel.quality_ = " .. quality)
		local buddhaFrame_ = display.newSprite("upgrade/q"..quality..".png", self.bg_:getContentSize().width * 0.2,
			self.bg_:getContentSize().height * 0.86)
			:scale(0.75)
			:addTo(self.bg_)
		sca = 0.7
	end	
	
	local buddhaIcon_ = display.newSprite(self.pic_, self.bg_:getContentSize().width * 0.2,
			self.bg_:getContentSize().height * 0.86)
		:scale(sca)
        :addTo(self.bg_) 
		
	cc.ui.UILabel.newBMFontLabel_({text = self.num_, font = "fonts/yellowNum.fnt"})	
		:scale(0.6)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.38,
			self.bg_:getContentSize().height * 0.8)
        :addTo(self.bg_)
	
	cc.ui.UILabel.new({text = self.desc_,size = 25,color = display.COLOR_BLACK, dimensions = cc.size(250,85),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.62)
        :addTo(self.bg_)
	
	local img_, sca , x, y
	print("**********************self.costType_ = " .. self.costType_)
	if self.costType_ == 1 then
		img_ = "shop/needexp.png"
		sca = 0.65
		x = 85
	else
		img_ = "shop/needpeach.png"
		sca = 0.8
		x = 65
	end
	
    local priceSprite_ = display.newSprite(img_, self.bg_:getContentSize().width * 0.5, 
			self.bg_:getContentSize().height * 0.3)
        :addTo(self.bg_)
	
	cc.ui.UILabel.newBMFontLabel_({text = self.price_, font = "fonts/whiteNum.fnt"})	
		:scale(sca)
        :align(display.CENTER,priceSprite_:getPositionX() + x,priceSprite_:getPositionY())
        :addTo(self.bg_)
		
	cc.ui.UIPushButton.new({normal = "shop/buy_normal_special.png",pressed = "shop/buy_selected_special.png"})
		:onButtonClicked(function()
				self:buyPropCallBack_()
			end)
		:scale(0.8)
		:align(display.CENTER,self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.15)
		:addTo(self.bg_)
		
	cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
		:onButtonClicked(function()
				self:closeCallBack_()
			end)
		:scale(0.8)
		:align(display.CENTER,self.bg_:getContentSize().width * 0.95,self.bg_:getContentSize().height * 0.95)
		:addTo(self.bg_)
end

function ShopIconDetailLayer:buyPropCallBack_()
    print("Confirm To Buy------" .. self.goodsName_)	
	if self.costType_ == 0 then
		local num = CloudData.PEACH
		if num < self.price_ then
			local t = WSToast.new("蟠桃不足",1.0)
			self:addChild(t,100)
			return
		end
	else
		local num = CloudData.EXP
		if num < self.price_ then
			local t = WSToast.new("经验不足",1.0)
			self:addChild(t,100)
			return
		end
	end
		
	local ac = AlertConnection.new(CONNECTION_SHOP_BUY,self.no_ - 1)
    self:addChild(ac, 100, 12345)
    
    self.scheduleResult_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)           
			self:addThings()
        end
    end,0.1)	
end

function ShopIconDetailLayer:addThings()
    if self.costType_ == 0 then
		CloudData.PEACH = CloudData.PEACH - self.price_
	else
		CloudData.EXP = CloudData.EXP - self.price_
	end
	
	if self.type_ == "exp" then
		CloudData.EXP = CloudData.EXP + self.num_
	elseif self.type_ == "buddha" then
		DataUtils.setNewBuddhaCloudData(self.itemId_)
	elseif self.type_ == "piece" then
		CloudData.MONSTER_PIECE_INFO[self.itemId_] = CloudData.MONSTER_PIECE_INFO[self.itemId_] + self.num_
	else
		CloudData.SWEEP = CloudData.SWEEP + self.num_
	end
	
	local t = WSToast.new("购买成功",1.0)
		self:addChild(t,100)
	
	self:closeCallBack_()
		
	display.getRunningScene().iconsTable_[self.no_]:soldOut()	
end

function ShopIconDetailLayer:closeCallBack_()
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.emptyNode_:runAction(popupLayer)
end

return ShopIconDetailLayer
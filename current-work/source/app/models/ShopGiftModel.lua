
local ShopGiftModel = class("ShopGiftModel")

function ShopGiftModel:ctor()
    --goodsXType为商品类型:   exp(经验)   sweep(扫荡券)  pieceY(碎片 Y代表碎片ID)  
	--goodsXNum为对应商品数量
	
	self.id_         = 0
	self.goods1Type_ = ""
	self.goods1Num_  = 0
	self.goods2Type_ = ""
	self.goods2Num_  = 0
	self.goods3Type_ = ""
	self.goods3Num_  = 0
	self.goods4Type_ = ""
	self.goods4Num_  = 0
	self.goods5Type_ = ""
	self.goods5Num_  = 0 
end

return ShopGiftModel

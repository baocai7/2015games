
local GoodsModel = class("GoodsModel")

function GoodsModel:ctor()
    self.goodsId_    = 0          --商品id
    self.goodsName_  = ""         --商品名称
    self.goodsType_  = ""         --对应商品类型:1扫荡券（伏魔令）2经验礼包 3神秘钥匙 4碎片
    self.goodsPic_   = ""         --商品图标
    self.goodsDesc_  = ""         --商品描述
    self.num_        = 0         
    self.price_      = 0         
    self.costType_   = ""          
    self.isDiscount_ = 0          --是否打折：0 不打  1 打折
    self.isBought_   = false      --是否被购买
end

return GoodsModel

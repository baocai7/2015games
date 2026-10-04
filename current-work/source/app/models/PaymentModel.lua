--
--充值界面数值
--

local PaymentModel = class("PaymentModel")

function PaymentModel:ctor()
    self.id_             = 0            --商品Id
    self.type_           = 0            --充值类型(1:不同卡;2:首次双倍;3:普通)
    self.price_          = 0            --充值金额
    self.peachNum_       = 0            --购买的蟠桃数
    self.addedNum_       = 0            --额外赠送的蟠桃数
    self.dailyGet_       = 0            --每天可领取的蟠桃数
    self.validTime_      = 0            --不同的卡效果持续时间(-1为永久,0为没有效果)
    self.title_          = ""           --标题
    self.desc_           = ""           --描述
    self.picPath_        = ""           --图片路径
end

return PaymentModel



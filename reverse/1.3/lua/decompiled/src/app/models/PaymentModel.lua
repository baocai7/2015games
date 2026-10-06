local PaymentModel = class("PaymentModel")

function PaymentModel:ctor()
  self.id_ = 0
  self.type_ = 0
  self.price_ = 0
  self.peachNum_ = 0
  self.addedNum_ = 0
  self.dailyGet_ = 0
  self.validTime_ = 0
  self.title_ = ""
  self.desc_ = ""
  self.picPath_ = ""
end

return PaymentModel

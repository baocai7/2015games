
local SignRewardModel = class("SignRewardModel")

function SignRewardModel:ctor()
	self.id_         = 0
    self.rewardPic_  = ""				 --奖品图片
	self.rewardPicH_ = ""
	self.rewardNum_  = 0				 --奖品的数量
	self.rewardDes_  = ""				 --奖品描述
	self.isGot_      = false			 --奖品是否已得到
end

return SignRewardModel

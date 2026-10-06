local SignRewardModel = class("SignRewardModel")

function SignRewardModel:ctor()
  self.id_ = 0
  self.rewardPic_ = ""
  self.rewardPicH_ = ""
  self.rewardNum_ = 0
  self.rewardDes_ = ""
  self.isGot_ = false
end

return SignRewardModel

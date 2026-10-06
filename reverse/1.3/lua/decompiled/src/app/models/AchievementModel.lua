local AchievementModel = class("AchievementModel")

function AchievementModel:ctor()
  self.achievementId_ = 0
  self.achievementName_ = ""
  self.achievementType_ = ""
  self.achievementDes1_ = ""
  self.achievementDes2_ = ""
  self.rewardType_ = ""
  self.rewardNum_ = 0
  self.achievementData_ = 0
  self.currentData_ = 0
  self.rewardQuantity_ = 0
end

return AchievementModel

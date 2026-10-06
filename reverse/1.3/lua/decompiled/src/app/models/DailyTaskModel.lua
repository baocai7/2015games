local DailyTaskModel = class("DailyTaskModel")

function DailyTaskModel:ctor()
  self.dailyTaskId_ = 0
  self.dailyTaskDesc_ = ""
  self.rewardType_ = ""
  self.totalData_ = 0
  self.currentData_ = 0
  self.rewardQuantity_ = 0
  self.stageLevel_ = 0
end

return DailyTaskModel

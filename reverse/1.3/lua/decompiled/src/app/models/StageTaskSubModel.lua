local StageTaskSubModel = class("StageTaskSubModel")

function StageTaskSubModel:ctor()
  self.subId_ = 0
  self.periodicNum_ = 0
  self.taskDesc_ = ""
  self.totalData_ = 0
  self.currData_ = 0
  self.rewardType_ = ""
  self.rewardNum_ = 0
end

return StageTaskSubModel

local StageTaskModel = class("StageTaskModel")

function StageTaskModel:ctor()
  self.stageTaskId_ = 0
  self.totalData_ = 0
  self.currentData_ = 0
  self.rewardQuantity_ = 0
end

return StageTaskModel

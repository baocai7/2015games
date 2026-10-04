--
--阶段任务
--

local StageTaskModel = class("StageTaskModel")

function StageTaskModel:ctor()
    self.stageTaskId_      = 0          --任务ID:1~10
    self.totalData_        = 0          --完成当前任务需要达到的数值
    self.currentData_      = 0.0        --已完成的数值，当前进度       currentData / totalData
    self.rewardQuantity_   = 0          --奖励数量
end

return StageTaskModel

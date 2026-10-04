--
--阶段子任务
--

local StageTaskSubModel = class("StageTaskSubModel")

function StageTaskSubModel:ctor()
    self.subId_                = 0                 --子任务id
    self.periodicNum_          = 0                 --当前所处的阶段数
    self.taskDesc_             = ""                --任务描述
    self.totalData_            = 0                 --当前任务总目标数
    self.currData_             = 0                 --当前完成任务的目标数
    self.rewardType_           = ""                --完成任务所得奖励的类型(经验,蟠桃...)
    self.rewardNum_            = 0                 --完成任务所得奖励的数量
end

return StageTaskSubModel

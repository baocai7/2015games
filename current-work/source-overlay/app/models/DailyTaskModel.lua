--
--日常任务
--

local DailyTaskModel = class("DailyTaskModel")

function DailyTaskModel:ctor()
    self.dailyTaskId_      = 0          --任务ID:1~10
    self.dailyTaskDesc_    = ""         --任务描述
    self.rewardType_       = ""         --奖励的类型，peach是奖励蟠桃，exp是奖励经验，ginsengfruit是奖励人参果，buddha是奖励兵种
    self.totalData_        = 0          --完成当前任务需要达到的数值
    self.currentData_      = 0.0        --已完成的数值，当前进度       currentData / totalData
    self.rewardQuantity_   = 0          --奖励数量
    self.stageLevel_       = 0          --根据关卡进度来更新奖励数量
end

return DailyTaskModel

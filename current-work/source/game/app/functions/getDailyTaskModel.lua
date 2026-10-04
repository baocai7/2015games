--
--解析DailyTaskModel
--

local DailyTaskModel = import("models.DailyTaskModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
-- 读第1行，获得各属性所在的列index
local _dailyTaskIdColumn   = nil
local _dailyTaskDescColumn = nil
local _rewardTypeColumn    = nil
local _totalDataColumn     = nil

function DataUtils.getDailyTaskModel( id )

    local dailyTaskInfo = DataRetainer.DAILYTASK_INFO

    -- 读第1行，获得各属性所在的列index
    _dailyTaskIdColumn   = _dailyTaskIdColumn or dailyTaskInfo:findIndexOfValueFromRow(1,"Dtask")
    _dailyTaskDescColumn = _dailyTaskDescColumn or dailyTaskInfo:findIndexOfValueFromRow(1,"DtaskDesc")
    _rewardTypeColumn    = _rewardTypeColumn or dailyTaskInfo:findIndexOfValueFromRow(1,"rewardType")
    _totalDataColumn     = _totalDataColumn or dailyTaskInfo:findIndexOfValueFromRow(1,"totalData")

    --查找 id 所在的行
    local _idRow = dailyTaskInfo:findIndexOfValueFromColumn(_dailyTaskIdColumn, id.."")

    --读出 id 对应行的所有数据
    local dailyTaskId   = dailyTaskInfo:getData(_idRow,_dailyTaskIdColumn)
    local dailyTaskDesc = dailyTaskInfo:getData(_idRow,_dailyTaskDescColumn)
    local rewardType    = dailyTaskInfo:getData(_idRow,_rewardTypeColumn)
    local totalData     = dailyTaskInfo:getData(_idRow,_totalDataColumn)


    --读取rewardQuantity,stageLevel
    local taskCountLevel = 0
    if CloudData.STAGE_PROGRESS >= 5 and CloudData.STAGE_PROGRESS < 15 then
        taskCountLevel = 1
    elseif CloudData.STAGE_PROGRESS < 30 then
        taskCountLevel = 2
    elseif CloudData.STAGE_PROGRESS < 45 then
        taskCountLevel = 3
    elseif CloudData.STAGE_PROGRESS < 60 then
        taskCountLevel = 4
    elseif CloudData.STAGE_PROGRESS < 70 then
        taskCountLevel = 5
    else
        taskCountLevel = 6
    end

    local _rewardQuantityColumn  = dailyTaskInfo:findIndexOfValueFromRow(1,string.format("rewardQuantity"..taskCountLevel))
    local rewardQuantity         = dailyTaskInfo:getData(_idRow,_rewardQuantityColumn)

    local _stageLevelColumn      = dailyTaskInfo:findIndexOfValueFromRow(1,string.format("stageLevel"..taskCountLevel))
    local stageLevel             = dailyTaskInfo:getData(_idRow,_stageLevelColumn)

    --读取currentData(具体计算后续读数据)
    local currentData = DataUtils.getDailyTaskCurrData(tonumber(dailyTaskId))

    --生成dailyTaskModel
    local dailyTaskModel = DailyTaskModel.new()
    dailyTaskModel.dailyTaskId_    = dailyTaskId
    dailyTaskModel.dailyTaskDesc_  = dailyTaskDesc
    dailyTaskModel.rewardType_     = rewardType
    dailyTaskModel.totalData_      = totalData
    dailyTaskModel.currentData_    = currentData
    dailyTaskModel.rewardQuantity_ = rewardQuantity
    dailyTaskModel.stageLevel_     = stageLevel

    return dailyTaskModel
end

function DataUtils.getDailyTaskCurrData( dailyTaskId )
    return CloudData.DAILY_TASK_INFO[dailyTaskId]
end

function DataUtils.setDailyTaskCompleted(dailyTaskId)
    --存储
    CloudData.DAILY_TASK_INFO[dailyTaskId] = -1
end

function DataUtils.getDailyTaskCompleted(dailyTaskId)
    if CloudData.DAILY_TASK_INFO[dailyTaskId] == -1 then
        return true
    else
        return false
    end
end

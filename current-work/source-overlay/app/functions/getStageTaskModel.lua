--
--解析StageTaskModel
--

local StageTaskModel = import("models.StageTaskModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
local _stageTaskIdColumn    = nil
local _totalDataColumn      = nil
local _rewardQuantityColumn = nil

function DataUtils.getStageTaskModel( id )

    local stageTaskInfo = DataRetainer.STAGETASK_INFO

    -- 读第1行，获得各属性所在的列index
    _stageTaskIdColumn    = _stageTaskIdColumn or stageTaskInfo:findIndexOfValueFromRow(1,"stageID")
    _totalDataColumn      = _totalDataColumn or stageTaskInfo:findIndexOfValueFromRow(1,"task_num")
    _rewardQuantityColumn = _rewardQuantityColumn or stageTaskInfo:findIndexOfValueFromRow(1,"rewardNum")

    --查找 id 所在的行
    local _idRow = stageTaskInfo:findIndexOfValueFromColumn(_stageTaskIdColumn, id.."")

    --读出 id 对应行的所有数据
    local stageTaskId    = stageTaskInfo:getData(_idRow,_stageTaskIdColumn)
    local totalData      = stageTaskInfo:getData(_idRow,_totalDataColumn)
    local rewardQuantity = stageTaskInfo:getData(_idRow,_rewardQuantityColumn)

    --读取currentData(具体计算后续读数据)
    local currentData = DataUtils.getStageTaskCurrData(tonumber(stageTaskId))

    --生成dailyTaskModel
    local stageTaskModel = StageTaskModel.new()
    stageTaskModel.stageTaskId_    = stageTaskId
    stageTaskModel.totalData_      = totalData
    stageTaskModel.currentData_    = currentData
    stageTaskModel.rewardQuantity_ = rewardQuantity

    return stageTaskModel
end

function DataUtils.getStageTaskCurrData( stageTaskId )
    return CloudData.CHAPTER_TASK_INFO[stageTaskId]
end

function DataUtils.setStageTaskCompleted(stageTaskId)
    CloudData.CHAPTER_TASK_INFO[stageTaskId] = -1
end

function DataUtils.getStageTaskCompleted(stageTaskId)
    if CloudData.CHAPTER_TASK_INFO[stageTaskId] == -1 then
        return true
    else
        return false
    end
end
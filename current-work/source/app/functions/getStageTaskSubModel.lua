--
--解析阶段任务的子任务数据
--

local StageTaskSubModel = import("models.StageTaskSubModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
-- 读第1行，获得各属性所在的列index
local _subIdColumn         = nil
local _stageNumColumn      = nil
local _taskDescColumn      = nil
local _rewardTypeColumn    = nil
local _totalDataColumn     = nil
local _rewardNumColumn     = nil

function DataUtils.getStageTaskSubModel(periodicNum, id )
    local stageTaskSubInfo = DataRetainer.STAGETASK_SUB_INFO[periodicNum]

    -- 读第1行，获得各属性所在的列index
    _subIdColumn         = _subIdColumn or stageTaskSubInfo:findIndexOfValueFromRow(1,"taskID")
    _stageNumColumn      = _stageNumColumn or stageTaskSubInfo:findIndexOfValueFromRow(1,"stageNum")
    _taskDescColumn      = _taskDescColumn or stageTaskSubInfo:findIndexOfValueFromRow(1,"description1")
    _rewardTypeColumn    = _rewardTypeColumn or stageTaskSubInfo:findIndexOfValueFromRow(1,"rewardType")
    _totalDataColumn     = _totalDataColumn or stageTaskSubInfo:findIndexOfValueFromRow(1,"param")
    _rewardNumColumn     = _rewardNumColumn or stageTaskSubInfo:findIndexOfValueFromRow(1,"rewardNum")

    --查找 id 所在的行
    local _idRow = stageTaskSubInfo:findIndexOfValueFromColumn(_subIdColumn, id.."")

    --读出 id 对应行的所有数据
    local subId         = stageTaskSubInfo:getData(_idRow,_subIdColumn)
    local stageNum      = stageTaskSubInfo:getData(_idRow,_stageNumColumn)
    local taskDesc      = stageTaskSubInfo:getData(_idRow,_taskDescColumn)
    local rewardType    = stageTaskSubInfo:getData(_idRow,_rewardTypeColumn)
    local totalData     = stageTaskSubInfo:getData(_idRow,_totalDataColumn)
    local rewardNum     = stageTaskSubInfo:getData(_idRow,_rewardNumColumn)

    --读取currentData(具体计算后续读数据)
    local currentData = DataUtils.getStageTaskSubCurrData(tonumber(subId))

    --生成stageTaskSubModel
    local stageTaskSubModel = StageTaskSubModel.new()
    stageTaskSubModel.subId_       = subId
    stageTaskSubModel.periodicNum_ = stageNum
    stageTaskSubModel.taskDesc_    = taskDesc
    stageTaskSubModel.totalData_   = totalData
    stageTaskSubModel.currData_    = currentData
    stageTaskSubModel.rewardType_  = rewardType
    stageTaskSubModel.rewardNum_   = rewardNum

    return stageTaskSubModel
end

function DataUtils.getStageTaskSubCurrData( subId )
    return CloudData.STAGE_TASK_SUB_INFO[subId]
end

function DataUtils.setStageTaskSubCompleted(subId)
    --存储
    CloudData.STAGE_TASK_SUB_INFO[subId] = -1
end

function DataUtils.getStageTaskSubCompleted(subId)
    if CloudData.STAGE_TASK_SUB_INFO[subId] == -1 then
        return true
    else
        return false
    end
end

function DataUtils.getStageTaskSubModelTable(periodicNum)
    local stageTaskSubInfo = DataRetainer.STAGETASK_SUB_INFO[periodicNum]
    local total = stageTaskSubInfo:getTotalRows() - 1
    local modelTable = {}
    for i=1,total do
        local model = DataUtils.getStageTaskSubModel(periodicNum,i)
        table.insert(modelTable,model)
    end
    return modelTable
end

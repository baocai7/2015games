local StageTaskModel = require("app.models.StageTaskModel")
local _stageTaskIdColumn, _totalDataColumn, _rewardQuantityColumn

function DataUtils.getStageTaskModel(id)
  local stageTaskInfo = DataRetainer.STAGETASK_INFO
  _stageTaskIdColumn = _stageTaskIdColumn or stageTaskInfo:findIndexOfValueFromRow(1, "stageID")
  _totalDataColumn = _totalDataColumn or stageTaskInfo:findIndexOfValueFromRow(1, "task_num")
  _rewardQuantityColumn = _rewardQuantityColumn or stageTaskInfo:findIndexOfValueFromRow(1, "rewardNum")
  local _idRow = stageTaskInfo:findIndexOfValueFromColumn(_stageTaskIdColumn, id .. "")
  local stageTaskId = stageTaskInfo:getData(_idRow, _stageTaskIdColumn)
  local totalData = stageTaskInfo:getData(_idRow, _totalDataColumn)
  local rewardQuantity = stageTaskInfo:getData(_idRow, _rewardQuantityColumn)
  local currentData = DataUtils.getStageTaskCurrData(tonumber(stageTaskId))
  local stageTaskModel = StageTaskModel.new()
  stageTaskModel.stageTaskId_ = stageTaskId
  stageTaskModel.totalData_ = totalData
  stageTaskModel.currentData_ = currentData
  stageTaskModel.rewardQuantity_ = rewardQuantity
  return stageTaskModel
end

function DataUtils.getStageTaskCurrData(stageTaskId)
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

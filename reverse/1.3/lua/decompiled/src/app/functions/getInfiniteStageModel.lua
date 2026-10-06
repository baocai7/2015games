local InfiniteStageModel = require("app.models.InfiniteStageModel")
local _stageId, _waveId, _towerDistance, _monsterPieceId, _monsterPieceNum, _rewardSweepNum, _rewardEssenceNum, _monsterIdsTotal, _monsterTowerLife

local function getTotalMonsterIds(waveIdTable)
  local tempTable = {}
  for k, v in pairs(waveIdTable) do
    local tempModel = DataUtils.getMonsterWaveModel(tonumber(v))
    local totalIdsTable = tempModel.totalIdsTable_
    for m, n in pairs(totalIdsTable) do
      tempTable[n] = 1
    end
  end
  return tempTable
end

function DataUtils.getInfiniteStageModel(id)
  local infiniteStageInfo = DataRetainer.INFINITE_STAGE_INFO
  _stageId = _stageId or infiniteStageInfo:findIndexOfValueFromRow(1, "stageId")
  _waveId = _waveId or infiniteStageInfo:findIndexOfValueFromRow(1, "waveId")
  _towerDistance = _towerDistance or infiniteStageInfo:findIndexOfValueFromRow(1, "distance")
  _monsterPieceId = _monsterPieceId or infiniteStageInfo:findIndexOfValueFromRow(1, "monsterPieceId")
  _monsterPieceNum = _monsterPieceNum or infiniteStageInfo:findIndexOfValueFromRow(1, "num")
  _rewardSweepNum = _rewardSweepNum or infiniteStageInfo:findIndexOfValueFromRow(1, "sweep")
  _rewardEssenceNum = _rewardEssenceNum or infiniteStageInfo:findIndexOfValueFromRow(1, "essence")
  _monsterIdsTotal = _monsterIdsTotal or infiniteStageInfo:findIndexOfValueFromRow(1, "totalIds")
  _monsterTowerLife = _monsterTowerLife or infiniteStageInfo:findIndexOfValueFromRow(1, "life")
  local _idRow = infiniteStageInfo:findIndexOfValueFromColumn(_stageId, id .. "")
  local datas = infiniteStageInfo:getDatas(_idRow)
  if not datas then
    printError(DYLang.getString("S214", ""), id)
    return
  end
  local stageId = datas[_stageId]
  local waveIdTable = split(datas[_waveId], ";")
  local towerDistance = datas[_towerDistance]
  local monsterPieceId = datas[_monsterPieceId]
  local monsterPieceNum = datas[_monsterPieceNum]
  local rewardSweepNum = datas[_rewardSweepNum]
  local rewardEssenceNum = datas[_rewardEssenceNum]
  local monsterIdsTotalTable = split(datas[_monsterIdsTotal], ";")
  local monsterTowerLife = datas[_monsterTowerLife]
  local infiniteStageModel = InfiniteStageModel.new()
  infiniteStageModel.stageId_ = tonumber(stageId)
  infiniteStageModel.waveIdTable_ = waveIdTable
  infiniteStageModel.towerDistance_ = tonumber(towerDistance)
  infiniteStageModel.monsterPieceId_ = tonumber(monsterPieceId)
  infiniteStageModel.monsterPieceNum_ = tonumber(monsterPieceNum)
  infiniteStageModel.rewardSweepNum_ = tonumber(rewardSweepNum)
  infiniteStageModel.rewardEssenceNum_ = tonumber(rewardEssenceNum)
  infiniteStageModel.monsterIdsTotalTable_ = getTotalMonsterIds(waveIdTable)
  infiniteStageModel.monsterTowerLife_ = tonumber(monsterTowerLife)
  return infiniteStageModel
end

function DataUtils.getInfiniteStageTotalNum()
  local infiniteStageInfo = DataRetainer.INFINITE_STAGE_INFO
  local totalNum = infiniteStageInfo:getTotalRows() - 1
  return totalNum
end

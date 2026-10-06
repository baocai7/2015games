local _levelSpiritGrowSpeedColumn, _spiritCostBasicColumn

function DataUtils.getSpiritCostBasic(levelProperty5)
  local spiritCostBasicInfo = DataRetainer.SPIRIT_COST_BASIC_INFO
  _levelSpiritGrowSpeedColumn = _levelSpiritGrowSpeedColumn or spiritCostBasicInfo:findIndexOfValueFromRow(1, "levelSpiritGrowSpeed")
  _spiritCostBasicColumn = _spiritCostBasicColumn or spiritCostBasicInfo:findIndexOfValueFromRow(1, "spiritCostBasic")
  local _levelSpiritGrowSpeedRow = spiritCostBasicInfo:findIndexOfValueFromColumn(_levelSpiritGrowSpeedColumn, levelProperty5 .. "")
  local basic = spiritCostBasicInfo:getData(_levelSpiritGrowSpeedRow, _spiritCostBasicColumn)
  return tonumber(basic)
end

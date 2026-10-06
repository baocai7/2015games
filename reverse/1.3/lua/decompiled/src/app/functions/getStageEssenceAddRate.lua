function DataUtils.getStageEssenceAddRate(stageId)
  local rate = 0
  
  local tm = DataUtils.getTreasureIncRate(1)
  rate = tm / 100
  return rate
end

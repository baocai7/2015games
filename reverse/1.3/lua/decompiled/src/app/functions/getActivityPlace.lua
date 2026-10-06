function DataUtils.getActivityPlaceRank(id)
  local actualInfo = DYCommon.getDataByTag(DataRetainer.NIAN_ACTUAL_INFO, "id", tostring(id))[1]
  
  if not actualInfo then
    DDERROR("actual id : %d with error data", tonumber(id))
    return
  end
  local actualData = {}
  actualData.actualId = tonumber(actualInfo.id)
  actualData.minNum = tonumber(actualInfo.min)
  actualData.maxNum = tonumber(actualInfo.max)
  actualData.things = split(actualInfo.things, ";")
  actualData.counts = split(actualInfo.counts, ";")
  if actualData.minNum < 4 then
    actualData.honorIcon = "pvp_ol/gi_rank" .. actualData.minNum .. ".png"
  end
  return actualData
end

function DataUtils.getActivityPlaceHurt(id)
  local actualInfo = DYCommon.getDataByTag(DataRetainer.NIAN_HURT_INFO, "id", tostring(id))[1]
  if not actualInfo then
    DDERROR("actual id : %d with error data", tonumber(id))
    return
  end
  local actualData = {}
  actualData.actualId = tonumber(actualInfo.id)
  actualData.hurt = tonumber(actualInfo.hurt)
  actualData.itemIds = split(actualInfo.things, ";")
  actualData.itemNums = split(actualInfo.counts, ";")
  return actualData
end

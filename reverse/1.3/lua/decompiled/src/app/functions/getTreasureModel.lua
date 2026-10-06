function DataUtils.getTreasureModel(treasureId)
  local treasureInfo = DYCommon.getDataByTag(DataRetainer.TREASURE_INFO, "treasureId", tostring(treasureId))[1]
  
  if not treasureInfo then
    DDERROR("treasure id : %d with error data", tonumber(treasureId))
    return
  end
  local sumTreasurePieceQuality = 0
  local bIsTreasureEffective = true
  local tFunc = {
    [0] = 0,
    [1] = 0.3,
    [2] = 0.5,
    [3] = 1
  }
  for i = 1, 10 do
    local treasurePieceId = tonumber(treasureInfo[string.format("treasurePieceId" .. i)])
    local treasurePieceModel = DataUtils.getTreasurePieceModel(treasurePieceId)
    local treasurePieceQuality = tonumber(treasurePieceModel.treasurePieceQuality_)
    sumTreasurePieceQuality = sumTreasurePieceQuality + tFunc[treasurePieceQuality]
    if treasurePieceQuality == 0 then
      bIsTreasureEffective = false
    end
  end
  local effectIncreaseRate = sumTreasurePieceQuality
  local treasureModel = {}
  treasureModel.treasureId_ = tonumber(treasureInfo.treasureId)
  treasureModel.treasureName_ = treasureInfo.treasureName
  treasureModel.treasureDesc_ = treasureInfo.treasureDesc
  treasureModel.treasureIconPath_ = treasureInfo.treasureIconPath
  treasureModel.attribIconPath_ = treasureInfo.attribIconPath
  treasureModel.attribNamePath_ = treasureInfo.attribNamePath
  treasureModel.treasureEffect_ = treasureInfo.treasureEffect
  treasureModel.isTreasureEffective_ = bIsTreasureEffective
  treasureModel.effectIncreaseRate_ = effectIncreaseRate
  return treasureModel
end

function DataUtils.getTreasureIncRate(treasureId, treasureList)
  local treasureInfo = DYCommon.getDataByTag(DataRetainer.TREASURE_INFO, "treasureId", tostring(treasureId))[1]
  if not treasureInfo then
    DDERROR("treasure id : %d with error data", tonumber(treasureId))
    return
  end
  local sumTreasurePieceQuality = 0
  local tFunc = {
    [0] = 0,
    [1] = 0.3,
    [2] = 0.5,
    [3] = 1
  }
  for i = 1, 10 do
    local treasurePieceQuality = 0
    if treasureList then
      local pieceId = (treasureId - 1) * 10 + i
      treasurePieceQuality = treasureList[tostring(pieceId)] or 0
    else
      local treasurePieceId = tonumber(treasureInfo[string.format("treasurePieceId" .. i)])
      local treasurePieceModel = DataUtils.getTreasurePieceModel(treasurePieceId)
      treasurePieceQuality = tonumber(treasurePieceModel.treasurePieceQuality_)
    end
    if treasurePieceQuality == 0 then
      sumTreasurePieceQuality = 0
      break
    end
    sumTreasurePieceQuality = sumTreasurePieceQuality + tFunc[treasurePieceQuality]
  end
  local effectIncreaseRate = sumTreasurePieceQuality
  return effectIncreaseRate
end

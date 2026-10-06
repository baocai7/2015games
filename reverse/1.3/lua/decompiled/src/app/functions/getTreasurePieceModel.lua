function DataUtils.getTreasurePieceQuality(treasurePieceId)
  return CloudData.TREASURE_PIECE_INFO[treasurePieceId] or 0
end

function DataUtils.getTreasurePieceModel(pieceId)
  local treasurePieceInfo = DYCommon.getDataByTag(DataRetainer.TREASURE_PIECE_INFO, "treasurePieceId", tostring(pieceId))[1]
  if not treasurePieceInfo then
    DDERROR("treasurePiece id : %d with error data", tonumber(pieceId))
    return
  end
  local treasurePieceModel = {}
  treasurePieceModel.treasurePieceId_ = tonumber(treasurePieceInfo.treasurePieceId)
  treasurePieceModel.treasurePieceName_ = treasurePieceInfo.treasurePieceName
  treasurePieceModel.treasurePieceDesc_ = treasurePieceInfo.treasurePieceDesc
  treasurePieceModel.treasurePieceQuality_ = DataUtils.getTreasurePieceQuality(tonumber(pieceId))
  return treasurePieceModel
end

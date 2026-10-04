
local TreasurePieceModel = import("models.TreasurePieceModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
local _treasurePieceIdColumn   = nil
local _treasurePieceNameColumn = nil
local _treasurePieceDescColumn = nil


-- function DataUtils.setTreasurePieceQuality(treasurePieceId,quality)
--     treasurePieceQuality_ = 2
-- end

function DataUtils.getTreasurePieceQuality(treasurePieceId)
    return CloudData.TREASURE_PIECE_INFO[treasurePieceId]
end

function DataUtils.getTreasurePieceModel( pieceId )

    local treasurePieceInfo = DataRetainer.TREASURE_PIECE_INFO

    --读第1行，获得各属性所在的列index
    _treasurePieceIdColumn   = _treasurePieceIdColumn or treasurePieceInfo:findIndexOfValueFromRow(1,"treasurePieceId")
    _treasurePieceNameColumn = _treasurePieceNameColumn or treasurePieceInfo:findIndexOfValueFromRow(1,"treasurePieceName")
    _treasurePieceDescColumn = _treasurePieceDescColumn or treasurePieceInfo:findIndexOfValueFromRow(1,"treasurePieceDesc")

    --查找 _treasurePieceId所在的行
    local _treasurePieceIdRow = treasurePieceInfo:findIndexOfValueFromColumn(_treasurePieceIdColumn, pieceId.."")

    local datas = treasurePieceInfo:getDatas(_treasurePieceIdRow)
    
    --读出 id 对应行的所有数据
    local treasurePieceId   = datas[_treasurePieceIdColumn] -- treasurePieceInfo:getData(_treasurePieceIdRow,_treasurePieceIdColumn)
    local treasurePieceName = datas[_treasurePieceNameColumn] -- treasurePieceInfo:getData(_treasurePieceIdRow,_treasurePieceNameColumn)
    local treasurePieceDesc = datas[_treasurePieceDescColumn] -- treasurePieceInfo:getData(_treasurePieceIdRow,_treasurePieceDescColumn)

    local treasurePieceQuality = DataUtils.getTreasurePieceQuality(tonumber(treasurePieceId))

    --生成MonsterModel
    local treasurePieceModel = TreasurePieceModel.new()
    
    treasurePieceModel.treasurePieceId_      = tonumber(treasurePieceId)
    treasurePieceModel.treasurePieceName_    = treasurePieceName
    treasurePieceModel.treasurePieceDesc_    = treasurePieceDesc
    treasurePieceModel.treasurePieceQuality_ = treasurePieceQuality
    
    return treasurePieceModel
end

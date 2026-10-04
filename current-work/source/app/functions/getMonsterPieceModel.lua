
local MonsterPieceModel = import("models.MonsterPieceModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
--读第1行，获得各属性所在的列index
local _monsterPieceIdColumn         = nil
local _monsterPieceNameColumn       = nil
local _monsterPieceQualityColumn    = nil
local _monsterPieceDescColumn       = nil
local _monsterPieceIconPathColumn   = nil
local _monsterPieceLootStageColumn1 = nil
local _monsterPieceLootStageColumn2 = nil
local _monsterPieceLootStageColumn3 = nil
local _monsterPieceLootStageColumn4 = nil
local _monsterPieceLootStageColumn5 = nil


function DataUtils.getMonsterPieceModel( pieceId )

    local monsterPieceInfo = DataRetainer.MONSTER_PIECE_INFO

    --读第1行，获得各属性所在的列index
    _monsterPieceIdColumn         = _monsterPieceIdColumn or monsterPieceInfo:findIndexOfValueFromRow(1,"monsterPieceID")
    _monsterPieceNameColumn       = _monsterPieceNameColumn or monsterPieceInfo:findIndexOfValueFromRow(1,"monsterPieceName")
    _monsterPieceQualityColumn    = _monsterPieceQualityColumn or monsterPieceInfo:findIndexOfValueFromRow(1,"quality")
    _monsterPieceDescColumn       = _monsterPieceDescColumn or monsterPieceInfo:findIndexOfValueFromRow(1,"monsterPieceDesc")
    _monsterPieceIconPathColumn   = _monsterPieceIconPathColumn or monsterPieceInfo:findIndexOfValueFromRow(1,"pieceIconPath")
    _monsterPieceLootStageColumn1 = _monsterPieceLootStageColumn1 or monsterPieceInfo:findIndexOfValueFromRow(1,"lootStage1")
    _monsterPieceLootStageColumn2 = _monsterPieceLootStageColumn2 or monsterPieceInfo:findIndexOfValueFromRow(1,"lootStage2")
    _monsterPieceLootStageColumn3 = _monsterPieceLootStageColumn3 or monsterPieceInfo:findIndexOfValueFromRow(1,"lootStage3")
    _monsterPieceLootStageColumn4 = _monsterPieceLootStageColumn4 or monsterPieceInfo:findIndexOfValueFromRow(1,"lootStage4")
    _monsterPieceLootStageColumn5 = _monsterPieceLootStageColumn5 or monsterPieceInfo:findIndexOfValueFromRow(1,"lootStage5")

    --查找 _monsterPieceId所在的行
    local _monsterPieceIdRow = monsterPieceInfo:findIndexOfValueFromColumn(_monsterPieceIdColumn, pieceId.."")

    local datas = monsterPieceInfo:getDatas(_monsterPieceIdRow)
    
    --读出 id 对应行的所有数据
    local monsterPieceId         = datas[_monsterPieceIdColumn] -- monsterPieceInfo:getData(_monsterPieceIdRow,_monsterPieceIdColumn)
    local monsterPieceName       = datas[_monsterPieceNameColumn] -- monsterPieceInfo:getData(_monsterPieceIdRow,_monsterPieceNameColumn)
    local monsterPieceQuality    = datas[_monsterPieceQualityColumn] -- monsterPieceInfo:getData(_monsterPieceIdRow,_monsterPieceQualityColumn)
    local monsterPieceDesc       = datas[_monsterPieceDescColumn] -- monsterPieceInfo:getData(_monsterPieceIdRow,_monsterPieceDescColumn)
    local monsterPieceIconPath   = datas[_monsterPieceIconPathColumn] -- monsterPieceInfo:getData(_monsterPieceIdRow,_monsterPieceIconPathColumn)
    local monsterPieceLootStage1 = datas[_monsterPieceLootStageColumn1] -- monsterPieceInfo:getData(_monsterPieceIdRow,_monsterPieceLootStageColumn1)
    local monsterPieceLootStage2 = datas[_monsterPieceLootStageColumn2] -- monsterPieceInfo:getData(_monsterPieceIdRow,_monsterPieceLootStageColumn2)
    local monsterPieceLootStage3 = datas[_monsterPieceLootStageColumn3] -- monsterPieceInfo:getData(_monsterPieceIdRow,_monsterPieceLootStageColumn3)
    local monsterPieceLootStage4 = datas[_monsterPieceLootStageColumn4] -- monsterPieceInfo:getData(_monsterPieceIdRow,_monsterPieceLootStageColumn4)
    local monsterPieceLootStage5 = datas[_monsterPieceLootStageColumn5] -- monsterPieceInfo:getData(_monsterPieceIdRow,_monsterPieceLootStageColumn5)

    --生成MonsterPieceModel
    local monsterPieceModel = MonsterPieceModel.new()

    monsterPieceModel.monsterPieceID_   = monsterPieceId
    monsterPieceModel.monsterPieceName_ = monsterPieceName
    monsterPieceModel.quality_          = monsterPieceQuality
    monsterPieceModel.monsterPieceDesc_ = monsterPieceDesc
    monsterPieceModel.pieceIconPath_    = monsterPieceIconPath
    monsterPieceModel.pieceLootStage1_    = tonumber(monsterPieceLootStage1)
    monsterPieceModel.pieceLootStage2_    = tonumber(monsterPieceLootStage2)
    monsterPieceModel.pieceLootStage3_    = tonumber(monsterPieceLootStage3)
    monsterPieceModel.pieceLootStage4_    = tonumber(monsterPieceLootStage4)
    monsterPieceModel.pieceLootStage5_    = tonumber(monsterPieceLootStage5)

    monsterPieceModel.currentNum_       = CloudData.MONSTER_PIECE_INFO[pieceId]

    return monsterPieceModel
end

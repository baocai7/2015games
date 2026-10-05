
local TreasureModel = import("models.TreasureModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
--读第1行，获得各属性所在的列index
local _treasureIdColumn       = nil
local _treasureNameColumn     = nil
local _treasureDescColumn     = nil
local _treasureIconPathColumn = nil
local _attribIconPathColumn   = nil
local _attribNamePathColumn   = nil

local _treasureInfoColumns    = nil

function DataUtils.getTreasureModel( pieceId )
    pieceId = tonumber(pieceId) or 0
    local treasureInfo = DataRetainer.TREASURE_INFO

    --读第1行，获得各属性所在的列index
    _treasureIdColumn       = _treasureIdColumn or treasureInfo:findIndexOfValueFromRow(1,"treasureId")
    _treasureNameColumn     = _treasureNameColumn or treasureInfo:findIndexOfValueFromRow(1,"treasureName")
    _treasureDescColumn     = _treasureDescColumn or treasureInfo:findIndexOfValueFromRow(1,"treasureDesc")
    _treasureIconPathColumn = _treasureIconPathColumn or treasureInfo:findIndexOfValueFromRow(1,"treasureIconPath")
    _attribIconPathColumn   = _attribIconPathColumn or treasureInfo:findIndexOfValueFromRow(1,"attribIconPath")
    _attribNamePathColumn   = _attribNamePathColumn or treasureInfo:findIndexOfValueFromRow(1,"attribNamePath")

    --查找 _treasurePieceId所在的行
    local _treasureIdRow = treasureInfo:findIndexOfValueFromColumn(_treasureIdColumn, pieceId.."")

    local datas = treasureInfo:getDatas(_treasureIdRow) or {}
    
    --读出 id 对应行的所有数据
    local treasureId       = datas[_treasureIdColumn] -- treasureInfo:getData(_treasureIdRow,_treasureIdColumn)
    local treasureName     = datas[_treasureNameColumn] -- treasureInfo:getData(_treasureIdRow,_treasureNameColumn)
    local treasureDesc     = datas[_treasureDescColumn] -- treasureInfo:getData(_treasureIdRow,_treasureDescColumn)
    local treasureIconPath = datas[_treasureIconPathColumn] -- treasureInfo:getData(_treasureIdRow,_treasureIconPathColumn)
    local attribIconPath   = datas[_attribIconPathColumn] -- treasureInfo:getData(_treasureIdRow,_attribIconPathColumn)
    local attribNamePath   = datas[_attribNamePathColumn] -- treasureInfo:getData(_treasureIdRow,_attribNamePathColumn)

    --判断宝物是否生效及提升效率
    local sumTreasurePieceQuality = 0            --宝藏品质和
    local bIsTreasureEffective    = true         --宝藏已生效 = true

    -- 缓存一次columns
    if(_treasureInfoColumns==nil) then
        _treasureInfoColumns = {}
        for i=1,10 do 
            _treasureInfoColumns[i] = treasureInfo:findIndexOfValueFromRow(1,string.format("treasurePieceId"..i))
        end
    end

    for i=1,10 do
        --local _treasurePieceIdColumn = treasureInfo:findIndexOfValueFromRow(1,string.format("treasurePieceId"..i))
        local _treasurePieceIdColumn = _treasureInfoColumns[i]
        local treasurePieceId = treasureInfo:getData(_treasureIdRow,_treasurePieceIdColumn)

        local treasurePieceModel   = DataUtils.getTreasurePieceModel(treasurePieceId)
        local treasurePieceQuality = tonumber(treasurePieceModel.treasurePieceQuality_) or 0

        sumTreasurePieceQuality = sumTreasurePieceQuality + treasurePieceQuality

        if treasurePieceQuality == 0 then
            bIsTreasureEffective = false       --任一宝藏碎片未获得时，宝藏都不生效
        end
    end

    local effectIncreaseRate = sumTreasurePieceQuality / (10 * 3)     --3是"金银铜"3种品质
    
    --生成MonsterModel
    local treasureModel = TreasureModel.new()
    
    treasureModel.treasureId_          = treasureId             --宝物id
    treasureModel.treasureName_        = treasureName           --宝物名字
    treasureModel.treasureDesc_        = treasureDesc           --宝物描述
    treasureModel.treasureIconPath_    = treasureIconPath       --中间的大宝物的路径
    treasureModel.attribIconPath_      = attribIconPath         --属性图标的路径
    treasureModel.attribNamePath_      = attribNamePath         --属性说明图片的路径

    treasureModel.isTreasureEffective_ = bIsTreasureEffective   --宝物是否生效
    treasureModel.effectIncreaseRate_  = effectIncreaseRate     --效果提升率33%~100%
   
    return treasureModel

end

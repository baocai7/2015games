
-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
--读第1行，获得各属性所在的列index
local _levelSpiritGrowSpeedColumn = nil
local _spiritCostBasicColumn = nil


function DataUtils.getSpiritCostBasic( levelProperty5 )

    levelProperty5 = tonumber(levelProperty5) or 1

    --csv
    local spiritCostBasicInfo = DataRetainer.SPIRIT_COST_BASIC_INFO

    --读第1行，获得各属性所在的列index
    _levelSpiritGrowSpeedColumn = _levelSpiritGrowSpeedColumn or spiritCostBasicInfo:findIndexOfValueFromRow(1,"levelSpiritGrowSpeed")
    _spiritCostBasicColumn = _spiritCostBasicColumn or spiritCostBasicInfo:findIndexOfValueFromRow(1,"spiritCostBasic")

    --查找 levelProperty5 所在的行
    local _levelSpiritGrowSpeedRow = spiritCostBasicInfo:findIndexOfValueFromColumn(_levelSpiritGrowSpeedColumn, levelProperty5.."")

    --读出 levelProperty5 对应行的所有数据
    local basic = spiritCostBasicInfo:getData(_levelSpiritGrowSpeedRow,_spiritCostBasicColumn)

    -- Some archived accounts do not contain the old cost table row.  Keep the
    -- original first-level cost so the battle HUD can still be constructed.
    return tonumber(basic) or 40
end

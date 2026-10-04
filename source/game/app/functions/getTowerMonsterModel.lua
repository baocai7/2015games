
local TowerMonsterModel = import("models.TowerMonsterModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
--读第1行，获得 strategyId 和 intervalTime 属性所在的列index
local _strategyIdColumn = nil         --col : 1
local _intervalTimeColumn = nil      --col : 12


--读取策略刷怪间隔时间
local function getIntervalTimeInStrategy( strategyId )

    if ( strategyId == "0" ) then  --策略ID为0表示此时不需要任何策略，返回间隔时间 1
        return 1
    end

    --csv
    local strategyInfo = DataRetainer.STRATEGY_INFO

    --读第1行，获得 strategyId 和 intervalTime 属性所在的列index
    _strategyIdColumn = _strategyIdColumn or strategyInfo:findIndexOfValueFromRow(1,"strategyId")          --col : 1
    _intervalTimeColumn = _intervalTimeColumn or strategyInfo:findIndexOfValueFromRow(1,"intervalTime")      --col : 12

    --查找  strategyId 所在的行
    local _strategyIdRow = strategyInfo:findIndexOfValueFromColumn(_strategyIdColumn, strategyId.."")

    --读出 strategy 对应的 interval Time
    local intervalTime = strategyInfo:getData(_strategyIdRow,_intervalTimeColumn)

    return intervalTime
end


-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
local _strategyIdColumn = nil

--读取策略包含怪物Id Table
local function getTableMonsterIdInStrategy( strategyId )

    local monsterIDs = {}

    if ( strategyId == "0" ) then  -- 策略ID为0表示此时不需要任何策略，返回1个 monsterId 0
        monsterIDs[#monsterIDs + 1] = 0
        return monsterIDs
    end

    --csv
    local strategyInfo = DataRetainer.STRATEGY_INFO
    --读第1行，获得 strategyId 属性所在的列index
    _strategyIdColumn = _strategyIdColumn or strategyInfo:findIndexOfValueFromRow(1,"strategyId")          --col : 1
    --查找  strategyId 所在的行
    local _strategyIdRow = strategyInfo:findIndexOfValueFromColumn(_strategyIdColumn, strategyId.."")

    for i = 1, 10 do
        local monsterId = string.format("monsterID%d",i)
        local monsterIdColumn = strategyInfo:findIndexOfValueFromRow(1, monsterId)
        --读出 id
        local id = strategyInfo:getData(_strategyIdRow, monsterIdColumn)
        if tonumber(id) > 0 then
            table.insert(monsterIDs,id)
        end
    end

    return monsterIDs;
end

local function contains(table, value)

    for i,v in pairs(table) do
        if ( v == value ) then
            return true
        end
    end

    return false
end

--计算本关所有策略出现的所有 MonsterId 供 Loading加载骨骼动画
local function calculateMonsterIdsAllTogether( s1, s2, s3, rp1, rp2, s99, s50, s20,sc)

    local monsterIds = {}

    for i,v in pairs(s1) do
        if not( contains(monsterIds, v) ) then
            table.insert(monsterIds, v)
        end
    end

    for i,v in pairs(s2) do
        if not( contains(monsterIds, v) ) then
            table.insert(monsterIds, v)
        end
    end

    for i,v in pairs(s3) do
        if not( contains(monsterIds, v) ) then
            table.insert(monsterIds, v)
        end
    end

    for i,v in pairs(rp1) do
        if not( contains(monsterIds, v) ) then
            table.insert(monsterIds, v)
        end
    end

    for i,v in pairs(rp2) do
        if not( contains(monsterIds, v) ) then
            table.insert(monsterIds, v)
        end
    end

    for i,v in pairs(s99) do
        if not( contains(monsterIds, v) ) then
            table.insert(monsterIds, v)
        end
    end

    for i,v in pairs(s50) do
        if not( contains(monsterIds, v) ) then
            table.insert(monsterIds, v)
        end
    end

    for i,v in pairs(s20) do
        if not( contains(monsterIds, v) ) then
            table.insert(monsterIds, v)
        end
    end

    for i,v in pairs(sc) do
        if not( contains(monsterIds, v) ) then
            table.insert(monsterIds, v)
        end
    end

    return monsterIds

end



function DataUtils.getTowerMonsterModel( towerId , mode )

    --print(towerId .. "   " ..mode)

    local towerMonsterInfo = DataRetainer.MONSTER_TOWER_INFO

    if mode == "CHALLENGE" then
        towerMonsterInfo = DataRetainer.MONSTER_TOWER_INFO_CHALLENGE
    elseif mode == "DIARY" then
        towerMonsterInfo = DataRetainer.MONSTER_TOWER_INFO_DIARY
    elseif mode == "ACTIVITY" then
        towerMonsterInfo = DataRetainer.MONSTER_TOWER_INFO_DIARY
    end

    --读第1行，获得各属性所在的列index
    local _towerIdColumn = towerMonsterInfo:findIndexOfValueFromRow(1,"towerId")
    local _typeColumn = towerMonsterInfo:findIndexOfValueFromRow(1,"type")
    local _strategyId1Column = towerMonsterInfo:findIndexOfValueFromRow(1,"strategyId1")
    local _strategyId2Column = towerMonsterInfo:findIndexOfValueFromRow(1,"strategyId2")
    local _strategyId3Column = towerMonsterInfo:findIndexOfValueFromRow(1,"strategyId3")
    local _repeatStrategyId1Column = towerMonsterInfo:findIndexOfValueFromRow(1,"repeatStrategyId1")
    local _repeatStrategyId2Column = towerMonsterInfo:findIndexOfValueFromRow(1,"repeatStrategyId2")
    local _strategy_99Column = towerMonsterInfo:findIndexOfValueFromRow(1,"strategy_99")
    local _strategy_50Column = towerMonsterInfo:findIndexOfValueFromRow(1,"strategy_50")
    local _strategy_20Column = towerMonsterInfo:findIndexOfValueFromRow(1,"strategy_20")
    local _lifeColumn = towerMonsterInfo:findIndexOfValueFromRow(1,"life")
    local _monsterNumLimitColumn = towerMonsterInfo:findIndexOfValueFromRow(1,"monsterNumLimit")
    local _cleanTime = towerMonsterInfo:findIndexOfValueFromRow(1,"cleantime")
    --local _monsterIdsColumn = towerMonsterInfo:findIndexOfValueFromRow(1,"monsterIdType")

    --查找  towerId 所在的行
    local _towerIdRow = towerMonsterInfo:findIndexOfValueFromColumn(_towerIdColumn, towerId.."")

    --读出  towerId 对应行的所有数据
    local towerId = towerMonsterInfo:getData(_towerIdRow,_towerIdColumn)
    local towerType = towerMonsterInfo:getData(_towerIdRow,_typeColumn)
    local strategyId1 = towerMonsterInfo:getData(_towerIdRow,_strategyId1Column)
    local strategyId2 = towerMonsterInfo:getData(_towerIdRow,_strategyId2Column)
    local strategyId3 = towerMonsterInfo:getData(_towerIdRow,_strategyId3Column)
    local repeatStrategyId1 = towerMonsterInfo:getData(_towerIdRow,_repeatStrategyId1Column)
    local repeatStrategyId2 = towerMonsterInfo:getData(_towerIdRow,_repeatStrategyId2Column)
    local strategy_99 = towerMonsterInfo:getData(_towerIdRow,_strategy_99Column)
    local strategy_50 = towerMonsterInfo:getData(_towerIdRow,_strategy_50Column)
    local strategy_20 = towerMonsterInfo:getData(_towerIdRow,_strategy_20Column)
    local life = towerMonsterInfo:getData(_towerIdRow,_lifeColumn)
    local monsterNumLimit = towerMonsterInfo:getData(_towerIdRow,_monsterNumLimitColumn)
    local cleanTime = towerMonsterInfo:getData(_towerIdRow,_cleanTime)
    --local monsterIds = towerMonsterInfo:getData(_towerIdRow,_monsterIdsColumn)

    --生成 TowerMonsterModel
    local towerMonsterModel = TowerMonsterModel.new()

    towerMonsterModel.towerId_   = towerId
    towerMonsterModel.towerType_ = towerType
    towerMonsterModel.life_      = life

    towerMonsterModel.monsterNumLimit_ = monsterNumLimit
    towerMonsterModel.cleanTime_       = cleanTime
    --    towerMonsterModel.monsterIds_  = monsterIds


    --读 strategy.csv 得到各策略间隔时间 和 妖怪敌兵信息
    towerMonsterModel.intervalTimeStrategy1_ = getIntervalTimeInStrategy( strategyId1 )
    towerMonsterModel.intervalTimeStrategy2_ = getIntervalTimeInStrategy( strategyId2 )
    towerMonsterModel.intervalTimeStrategy3_ = getIntervalTimeInStrategy( strategyId3 )
    towerMonsterModel.intervalTimeRP1_ = getIntervalTimeInStrategy( repeatStrategyId1 )
    towerMonsterModel.intervalTimeRP2_ = getIntervalTimeInStrategy( repeatStrategyId2 )
    towerMonsterModel.intervalTime99_ = getIntervalTimeInStrategy( strategy_99 )
    towerMonsterModel.intervalTime50_ = getIntervalTimeInStrategy( strategy_50 )
    towerMonsterModel.intervalTime20_ = getIntervalTimeInStrategy( strategy_20 )
    towerMonsterModel.intervalTimeClean_ = getIntervalTimeInStrategy( 366 )

    towerMonsterModel.monsterIdsTable1_ = getTableMonsterIdInStrategy( strategyId1 )
    towerMonsterModel.monsterIdsTable2_ = getTableMonsterIdInStrategy( strategyId2 )
    towerMonsterModel.monsterIdsTable3_ = getTableMonsterIdInStrategy( strategyId3 )
    towerMonsterModel.monsterIdsTableRepeat1_ = getTableMonsterIdInStrategy( repeatStrategyId1 )
    towerMonsterModel.monsterIdsTableRepeat2_ = getTableMonsterIdInStrategy( repeatStrategyId2 )
    towerMonsterModel.monsterIdsTable99_ = getTableMonsterIdInStrategy( strategy_99 )
    towerMonsterModel.monsterIdsTable50_ = getTableMonsterIdInStrategy( strategy_50 )
    towerMonsterModel.monsterIdsTable20_ = getTableMonsterIdInStrategy( strategy_20 )

    towerMonsterModel.cleanMonsterIdsTable_ = getTableMonsterIdInStrategy( 366 )

    towerMonsterModel.monsterIdsTable_ = calculateMonsterIdsAllTogether( towerMonsterModel.monsterIdsTable1_,
        towerMonsterModel.monsterIdsTable2_,
        towerMonsterModel.monsterIdsTable3_,
        towerMonsterModel.monsterIdsTableRepeat1_,
        towerMonsterModel.monsterIdsTableRepeat2_,
        towerMonsterModel.monsterIdsTable99_,
        towerMonsterModel.monsterIdsTable50_,
        towerMonsterModel.monsterIdsTable20_,
        towerMonsterModel.cleanMonsterIdsTable_)

    return towerMonsterModel
end


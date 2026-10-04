
--[[=============================================================================
#     FileName: getMonsterWaveModel.lua
#         Desc: 读取无尽模式当前层的波次数据信息
#       Author: Hoo
#   LastChange: 2015-03-23 
#      History:
=============================================================================]]

local MonsterWaveModel = import("models.MonsterWaveModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
-- 读第1行，获得各属性所在的列index
local _waveId           = nil
local _strategyId1      = nil
local _strategyId2      = nil
local _strategyId3      = nil
local _strategyId4      = nil
local _strategyId5      = nil
local _strategyId6      = nil
local _strategyId7      = nil
local _monsterNumLimit  = nil
local _waveTime         = nil
local _monsterIdsTotal_ = nil

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
--读第1行，获得 strategyId 和 intervalTime 属性所在的列index
local _strategyIdColumn = nil         --col : 1
local _intervalTimeColumn = nil      --col : 12

-- 读取策略刷怪间隔时间
local function getIntervalTimeInStrategy( strategyId )

    if ( strategyId == 0 ) then  --策略ID为0表示此时不需要任何策略，返回间隔时间 1
        return 1
    end

    --csv
    local strategyInfo = DataRetainer.INFINITE_STRATEGY_INFO

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
-- 读取策略包含怪物Id Table
local function getTableMonsterIdInStrategy( strategyId )
    local monsterIDs = {}

    if ( strategyId == 0 ) then  -- 策略ID为0表示此时不需要任何策略，返回1个 monsterId 0
        monsterIDs[#monsterIDs + 1] = 0
        return monsterIDs
    end

    --csv
    local strategyInfo = DataRetainer.INFINITE_STRATEGY_INFO
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

    return monsterIDs
end

-- 计算所有策略包含的妖怪id
local function getTotalIdsTable(s1,s2,s3,s4,s5,s6,s7)
    local totalMonsterIdsTable = {}

    if s1[1] ~= 0  then
        table.insertto(totalMonsterIdsTable,s1)
    end

    if s2[1] ~= 0  then
        table.insertto(totalMonsterIdsTable,s2)
    end

    if s3[1] ~= 0  then
        table.insertto(totalMonsterIdsTable,s3)
    end

    if s4[1] ~= 0  then
        table.insertto(totalMonsterIdsTable,s4)
    end

    if s5[1] ~= 0  then
        table.insertto(totalMonsterIdsTable,s5)
    end

    if s6[1] ~= 0  then
        table.insertto(totalMonsterIdsTable,s6)
    end

    if s7[1] ~= 0  then
        table.insertto(totalMonsterIdsTable,s7)
    end
    
    return table.unique(totalMonsterIdsTable)
end 

function DataUtils.getMonsterWaveModel( id )

    local monsterWaveInfo = DataRetainer.MONSTER_WAVE_INFO

    -- 读第1行，获得各属性所在的列index
    _waveId           = _waveId or monsterWaveInfo:findIndexOfValueFromRow(1,"waveId")
    _strategyId1      = _strategyId1 or monsterWaveInfo:findIndexOfValueFromRow(1,"strategyId1")
    _strategyId2      = _strategyId2 or monsterWaveInfo:findIndexOfValueFromRow(1,"strategyId2")
    _strategyId3      = _strategyId3 or monsterWaveInfo:findIndexOfValueFromRow(1,"strategyId3")
    _strategyId4      = _strategyId4 or monsterWaveInfo:findIndexOfValueFromRow(1,"strategyId4")
    _strategyId5      = _strategyId5 or monsterWaveInfo:findIndexOfValueFromRow(1,"strategyId5")
    _strategyId6      = _strategyId6 or monsterWaveInfo:findIndexOfValueFromRow(1,"strategyId6")
    _strategyId7      = _strategyId7 or monsterWaveInfo:findIndexOfValueFromRow(1,"strategyId7")
    _monsterNumLimit  = _monsterNumLimit or monsterWaveInfo:findIndexOfValueFromRow(1,"monsterNumLimit")
    _waveTime         = _waveTime or monsterWaveInfo:findIndexOfValueFromRow(1,"time")
    _monsterIdsTotal  = _monsterIdsTotal or monsterWaveInfo:findIndexOfValueFromRow(1,"totalIds")

    --查找 id 所在的行
    local _idRow = monsterWaveInfo:findIndexOfValueFromColumn(_waveId, id.."")
    
    -- 获取所在行的所有数据（PS:虽然data已经是复数形式了，加个s，只为标记）
    local datas = monsterWaveInfo:getDatas(_idRow)

    --读出 id 对应行的所有数据
    local waveId           = datas[_waveId] 
    local strategyId1      = datas[_strategyId1] 
    local strategyId2      = datas[_strategyId2] 
    local strategyId3      = datas[_strategyId3] 
    local strategyId4      = datas[_strategyId4] 
    local strategyId5      = datas[_strategyId5] 
    local strategyId6      = datas[_strategyId6] 
    local strategyId7      = datas[_strategyId7] 
    local monsterNumLimit  = datas[_monsterNumLimit] 
    local waveTime         = datas[_waveTime] 
    -- local totalIdsTable    = split(datas[_monsterIdsTotal],"+") 

    --生成InfiniteStageModel
    local monsterWaveModel = MonsterWaveModel.new()
    monsterWaveModel.waveId_           = tonumber(waveId)               -- 波次Id
    monsterWaveModel.strategyId1_      = tonumber(strategyId1)          -- 策略1
    monsterWaveModel.strategyId2_      = tonumber(strategyId2)          -- 策略2
    monsterWaveModel.strategyId3_      = tonumber(strategyId3)          -- 策略3
    monsterWaveModel.strategyId4_      = tonumber(strategyId4)          -- 策略4
    monsterWaveModel.strategyId5_      = tonumber(strategyId5)          -- 策略5
    monsterWaveModel.strategyId6_      = tonumber(strategyId6)          -- 策略6
    monsterWaveModel.strategyId7_      = tonumber(strategyId7)          -- 策略7
    monsterWaveModel.monsterNumLimit_  = tonumber(monsterNumLimit)      -- 场上妖怪数量上限
    monsterWaveModel.waveTime_         = tonumber(waveTime)             -- 当前波次的持续时间
    -- monsterWaveModel.totalIdsTable_    = totalIdsTable

    monsterWaveModel.monsterIdsTable1_      = getTableMonsterIdInStrategy( monsterWaveModel.strategyId1_ )  
    monsterWaveModel.monsterIdsTable2_      = getTableMonsterIdInStrategy( monsterWaveModel.strategyId2_ )    
    monsterWaveModel.monsterIdsTable3_      = getTableMonsterIdInStrategy( monsterWaveModel.strategyId3_ )   
    monsterWaveModel.monsterIdsTable4_      = getTableMonsterIdInStrategy( monsterWaveModel.strategyId4_ )   
    monsterWaveModel.monsterIdsTable5_      = getTableMonsterIdInStrategy( monsterWaveModel.strategyId5_ )    
    monsterWaveModel.monsterIdsTable6_      = getTableMonsterIdInStrategy( monsterWaveModel.strategyId6_ )    
    monsterWaveModel.monsterIdsTable7_      = getTableMonsterIdInStrategy( monsterWaveModel.strategyId7_ )   

    monsterWaveModel.intervalTimeStrategy1_ = getIntervalTimeInStrategy( monsterWaveModel.strategyId1_ )    
    monsterWaveModel.intervalTimeStrategy2_ = getIntervalTimeInStrategy( monsterWaveModel.strategyId2_ ) 
    monsterWaveModel.intervalTimeStrategy3_ = getIntervalTimeInStrategy( monsterWaveModel.strategyId3_ ) 
    monsterWaveModel.intervalTimeStrategy4_ = getIntervalTimeInStrategy( monsterWaveModel.strategyId4_ ) 
    monsterWaveModel.intervalTimeStrategy5_ = getIntervalTimeInStrategy( monsterWaveModel.strategyId5_ ) 
    monsterWaveModel.intervalTimeStrategy6_ = getIntervalTimeInStrategy( monsterWaveModel.strategyId6_ ) 
    monsterWaveModel.intervalTimeStrategy7_ = getIntervalTimeInStrategy( monsterWaveModel.strategyId7_ ) 

    -- 当前波次的所有妖怪的ID
    monsterWaveModel.totalIdsTable_         = getTotalIdsTable(monsterWaveModel.monsterIdsTable1_,monsterWaveModel.monsterIdsTable2_,
                                                               monsterWaveModel.monsterIdsTable3_,monsterWaveModel.monsterIdsTable4_,
                                                               monsterWaveModel.monsterIdsTable5_,monsterWaveModel.monsterIdsTable6_,
                                                               monsterWaveModel.monsterIdsTable7_)                                                                        

    return monsterWaveModel
end

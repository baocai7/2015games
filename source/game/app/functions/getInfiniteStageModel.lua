
--[[=============================================================================
#     FileName: getInfiniteStageModel.lua
#         Desc: 读取无尽模式个各层数有关的配置信息
#       Author: Hoo
#   LastChange: 2015-03-23 
#      History:
=============================================================================]]

local InfiniteStageModel = import("models.InfiniteStageModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
-- 读第1行，获得各属性所在的列index
local _stageId          = nil
local _waveId           = nil
local _towerDistance    = nil
local _monsterPieceId   = nil
local _monsterPieceNum  = nil
local _rewardSweepNum   = nil
local _rewardEssenceNum = nil
local _monsterIdsTotal  = nil
local _monsterTowerLife = nil

-- 获取当前层所有妖怪的ID
local function getTotalMonsterIds(waveIdTable)
    local tempTable = {}
    for k,v in pairs(waveIdTable) do
        local tempModel    = DataUtils.getMonsterWaveModel(tonumber(v))
        local totalIdsTable = tempModel.totalIdsTable_
        for m,n in pairs(totalIdsTable) do
            tempTable[n] = 1
        end
        -- print("========================= waveId : "..v)
        -- dump(totalIdsTable)
        -- table.insertto(tempTable,totalIdsTable)
        -- print("========================= key : "..k)
        -- dump(tempTable)
    end
    -- print("=========================================")
    -- dump(tempTable)

    -- local monsterIdsTotalTable = table.unique(tempTable)

    return tempTable
end 

function DataUtils.getInfiniteStageModel( id )

    local infiniteStageInfo = DataRetainer.INFINITE_STAGE_INFO

    -- 读第1行，获得各属性所在的列index
    _stageId           = _stageId or infiniteStageInfo:findIndexOfValueFromRow(1,"stageId")
    _waveId            = _waveId or infiniteStageInfo:findIndexOfValueFromRow(1,"waveId")
    _towerDistance     = _towerDistance or infiniteStageInfo:findIndexOfValueFromRow(1,"distance")
    _monsterPieceId    = _monsterPieceId or infiniteStageInfo:findIndexOfValueFromRow(1,"monsterPieceId")
    _monsterPieceNum   = _monsterPieceNum or infiniteStageInfo:findIndexOfValueFromRow(1,"num")
    _rewardSweepNum    = _rewardSweepNum or infiniteStageInfo:findIndexOfValueFromRow(1,"sweep")
    _rewardEssenceNum  = _rewardEssenceNum or infiniteStageInfo:findIndexOfValueFromRow(1,"essence")
    _monsterIdsTotal   = _monsterIdsTotal or infiniteStageInfo:findIndexOfValueFromRow(1,"totalIds")
    _monsterTowerLife  = _monsterTowerLife or infiniteStageInfo:findIndexOfValueFromRow(1,"life")

    --查找 id 所在的行
    local _idRow = infiniteStageInfo:findIndexOfValueFromColumn(_stageId, id.."")
    
    -- 获取所在行的所有数据（PS:虽然data已经是复数形式了，加个s，只为标记）
    local datas = infiniteStageInfo:getDatas(_idRow)

    --读出 id 对应行的所有数据
    local stageId              = datas[_stageId] 
    local waveIdTable          = split(datas[_waveId],";") 
    local towerDistance        = datas[_towerDistance] 
    local monsterPieceId       = datas[_monsterPieceId] 
    local monsterPieceNum      = datas[_monsterPieceNum] 
    local rewardSweepNum       = datas[_rewardSweepNum] 
    local rewardEssenceNum     = datas[_rewardEssenceNum] 
    local monsterIdsTotalTable = split(datas[_monsterIdsTotal],";") 
    local monsterTowerLife     = datas[_monsterTowerLife] 

    --生成InfiniteStageModel
    local infiniteStageModel = InfiniteStageModel.new()
    infiniteStageModel.stageId_              = tonumber(stageId)                -- 层数ID
    infiniteStageModel.waveIdTable_          = waveIdTable                      -- 当前层的波次消耗
    infiniteStageModel.towerDistance_        = tonumber(towerDistance)          -- 塔间距
    infiniteStageModel.monsterPieceId_       = tonumber(monsterPieceId)         -- 妖怪碎片id(奖励)
    infiniteStageModel.monsterPieceNum_      = tonumber(monsterPieceNum)        -- 碎片数量
    infiniteStageModel.rewardSweepNum_       = tonumber(rewardSweepNum)         -- 扫荡券数量(奖励)
    infiniteStageModel.rewardEssenceNum_     = tonumber(rewardEssenceNum)       -- 精华石数量(奖励)
    infiniteStageModel.monsterIdsTotalTable_ = getTotalMonsterIds(waveIdTable)  -- 当前层所包含的所有妖怪ID
    infiniteStageModel.monsterTowerLife_     = tonumber(monsterTowerLife)       -- 当前层敌方塔生命值

    return infiniteStageModel
end









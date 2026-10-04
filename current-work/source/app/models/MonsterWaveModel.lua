
--[[=============================================================================
#     FileName: MonsterWaveModel.lua
#         Desc: 无尽模式当前层的波次数据信息
#       Author: Hoo
#   LastChange: 2015-03-23 
#      History:
=============================================================================]]

local MonsterWaveModel = class("MonsterWaveModel")

function MonsterWaveModel:ctor()
    self.waveId_           = 0          -- 波次ID
    self.strategyId1_      = 0          -- 策略1ID
    self.strategyId2_      = 0          -- 策略2ID
    self.strategyId3_      = 0          -- 策略3ID
    self.strategyId4_      = 0          -- 策略4ID
    self.strategyId5_      = 0          -- 策略5ID
    self.strategyId6_      = 0          -- 策略6ID
    self.strategyId7_      = 0          -- 策略7ID
    self.monsterNumLimit_  = 0          -- 场上妖怪数量上限
    self.waveTime_         = 0          -- 当前波次的持续时间
    self.totalIdsTable_    = {}         -- 当前波次的所有妖怪的ID

    self.monsterIdsTable1_      = {}    -- 策略1所包含的妖怪ID
    self.monsterIdsTable2_      = {}    -- 策略2所包含的妖怪ID
    self.monsterIdsTable3_      = {}    -- 策略3所包含的妖怪ID
    self.monsterIdsTable4_      = {}    -- 策略4所包含的妖怪ID
    self.monsterIdsTable5_      = {}    -- 策略5所包含的妖怪ID
    self.monsterIdsTable6_      = {}    -- 策略6所包含的妖怪ID
    self.monsterIdsTable7_      = {}    -- 策略7所包含的妖怪ID

    self.intervalTimeStrategy1_ = 0     -- 策略1出兵的间隔时间
    self.intervalTimeStrategy2_ = 0     -- 策略2出兵的间隔时间
    self.intervalTimeStrategy3_ = 0     -- 策略3出兵的间隔时间
    self.intervalTimeStrategy4_ = 0     -- 策略4出兵的间隔时间
    self.intervalTimeStrategy5_ = 0     -- 策略5出兵的间隔时间
    self.intervalTimeStrategy6_ = 0     -- 策略6出兵的间隔时间
    self.intervalTimeStrategy7_ = 0     -- 策略7出兵的间隔时间
end

return MonsterWaveModel

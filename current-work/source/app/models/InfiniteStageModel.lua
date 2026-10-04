
--[[=============================================================================
#     FileName: InfiniteStageModel.lua
#         Desc: 无尽模式个各层数有关的配置信息
#       Author: Hoo
#   LastChange: 2015-03-23 
#      History:
=============================================================================]]

local InfiniteStageModel = class("InfiniteStageModel")

function InfiniteStageModel:ctor()
    self.stageId_              = 0          -- 层数ID
    self.waveIdTable_          = {}          -- 当前层的波次消耗
    self.towerDistance_        = 0          -- 塔间距
    self.monsterPieceId_       = 0          -- 妖怪碎片id(奖励)
    self.monsterPieceNum_      = 0          -- 碎片数量
    self.rewardSweepNum_       = 0          -- 扫荡券数量(奖励)
    self.rewardEssenceNum_     = 0          -- 精华石数量(奖励)
    self.monsterIdsTotalTable_ = {}         -- 当前层所包含的所有妖怪ID
    self.monsterTowerLife_     = 0          -- 当前层敌方塔生命值
end

return InfiniteStageModel

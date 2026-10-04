
local StageModel = class("StageModel")

function StageModel:ctor()
    self.stageId_              = 0          --关卡ID
    self.energyCost_           = 0          --精力消耗
    self.expAward_             = 0          --关卡经验值奖励
    self.addtionalExp_         = 0          --加成经验(唐僧属性升级,宝物加成)
    self.treasurePieceId_      = 0          --宝物碎片ID
    self.towerDistance_        = 0          --塔间距
    self.monsterPieceId_       = 0          --妖怪碎片id
    self.maxRollTimes_         = 0          --最大随机次数
    self.probability_          = 0.0        --单次几率
    self.advancedPieceId_      = 0          --高级妖怪碎片id
    self.advancedMaxRollTimes_ = 0          --高级最大随机次数
    self.advancedProbability_  = 0.0        --高级单次几率
    
    self.isGrooveMode_         = 0          --是否为卡槽关
    self.grooveModeInterval_   = 0          --卡槽关出卡间隔时常
end

return StageModel

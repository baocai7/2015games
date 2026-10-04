
local BuddhaModel = class("BuddhaModel")

function BuddhaModel:ctor()
    self.npcId_           = 0                   --兵种编号
    self.name_            = ""                  --兵种名称
    self.icon_            = ""                  --兵种图标
    self.defaultLevel_    = 0                   --兵种默认等级
    self.maxLevel_        = 0                   --兵种最大等级
    self.costValue_       = 0                   --制造该兵种所消耗灵气
    self.basicCdTime_     = 0.0                 --兵种基础cd时间（配置表里所填）
    self.cdTime_          = 0.0                 --制造该兵种的冷却时间
    self.advancedGuardID_ = 0                   --进阶兵种的ID，0表示升级到满级后不能进阶
    self.restrainType_    = 0                   --约束类型 0 1 2 3 无 石头 剪刀 布
    self.attackTime_      = 0.0                 --新增：准确的攻击动作时间
    self.quality_         = 0                   --兵种品质: 白 绿 蓝 紫 金
    self.isRebel_         = 0                   --是否为妖怪叛变来的兵种(降妖) 0：不是 1：是
    self.balance_         = 0.0                 --战斗力修正参数(队伍界面计算战力时用到)

    self.lifeParamK_   = 0.0                    --兵种生命值成长系数
    self.lifeParamB_   = 0.0                    --兵种生命值成长幅度
    self.attackParamK_ = 0.0                    --兵种攻击力成长系数
    self.attackParamB_ = 0.0                    --兵种攻击力成长幅度

    self.lifeParamKAdd_   = 0.0                 --兵种突破生命成长系数
    self.lifeParamBAdd_   = 0.0                 --兵种突破生长成长幅度
    self.attackParamKAdd_ = 0.0                 --兵种突破攻击力成长系数
    self.attackParamBAdd_ = 0.0                 --兵种突破攻击力成长幅度

    self.attackFrequencyK_ = 0.0                --兵种攻击频率成长系数
    self.attackFrequencyB_ = 0.0                --兵种攻击频率成长幅度
    self.runSpeed_         = 0.0                --兵种移动速度成长幅度
    self.attackDistance_   = 0.0                --兵种攻击距离

    self.essenceValue_  = 0                     --兵种转化的精华数(抽到已有兵种时)
    self.essenceParamK_ = 0                     --兵种突破所需精华数成长系数
    self.essenceParamB_ = 0                     --兵种突破所需精华数成长幅度

    self.hasBulletAnim_     = false
    self.bulletAnimId_      = 0
    self.waitTime_          = 0.0               --释法延迟时间
    self.isAreaDamage_      = false             --是否范围伤害
    self.haveSpecialEffect_ = false             --是否有特殊效果
    self.effectID_          = 0                 --特殊效果ID
    self.backParam_         = 0.0               --每下降百分之几的血量播放一次HurtFrame
    self.backLength_        = 0.0
    self.summonPieceId_     = 0                 --召唤类型:召唤碎片消耗id
    self.summonNum_         = 0                 --召唤消耗
    self.standFrame_        = ""                --待机动画
    self.hurtFrame_         = ""                --被攻击到一定血量的后退动画
    self.soundFile_         = ""                --声音文件
    self.attackFrame_       = ""                --攻击动画
    self.npcDesc_           = ""                --兵种（神仙）的描述
    self.adaptScale_        = 0.0               --缩放适应比例系数
    self.upMove_            = 0.0               --上移距离

    self.level_    = 0                          --兵种等级
    self.addLevel_ = 0                          --兵种突破等级
    self.expCost_         = 0                   --兵种升级所需经验
    self.buddhaState_     = 0                   --当前兵种状态   0:未解锁  1:已解锁  2:已拥有
    self.buddhaIsActive_  = false               --当前兵种是否处于活动状态（队伍界面允许玩家切换回兵种的初级形态）
    self.manualPriority_  = 0                   --追加：操作优先级（用于图鉴等界面中兵种强弱优先级判定）
    self.sizeInBattle_    = 0.0                 --战斗中大小

    self.tag1_ = 0                              --兵种特效标签:扛得住
    self.tag2_ = 0                              --兵种特效标签:揍一群
    self.tag3_ = 0                              --兵种特效标签:跑得快

    self.life_   = 0                            --兵种血量(计算所得)
    self.attack_ = 0                            --兵种攻击(计算所得)
    
    self.essenceCost_ = 0

    self.currPieceNum_ = 0                      --妖怪兵种现有碎片
end

return BuddhaModel

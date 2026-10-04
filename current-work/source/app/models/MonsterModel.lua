
local MonsterModel = class("MonsterModel")

function MonsterModel:ctor()
    self.npcId_           = 0                   --妖怪编号
    self.name_            = ""                  --妖怪名称
    self.icon_            = ""                  --妖怪图标
    self.defaultLevel_    = 0                   --妖怪默认等级
    self.value_           = 0                   --妖怪死亡后所转化的灵气数量
    self.restrainType_    = 0                   --约束类型 0 1 2 3 无 石头 剪刀 布
    self.quality_         = 0                   --兵种品质: 白 绿 蓝 紫 金
    self.life_            = 0                   --妖怪的生命值
    self.attackParam_     = 0                   --妖怪的攻击力
    self.attackFrequency_ = 0.0                 --妖怪的攻击频率
    self.runSpeed_        = 0.0                 --妖怪的移动速度
    self.attackDistance_  = 0                   --妖怪的攻击距离
    self.attackTime_      = 0.0                 --攻击动作时间

    self.hasBulletAnim_     = false
    self.bulletAnimId_      = 0
    self.waitTime_          = 0.0               --释法延迟时间
    self.isAreaDamage_      = false             --是否范围伤害
    self.haveSpecialEffect_ = false             --是否有特殊效果
    self.effectID_          = 0                 --特殊效果ID
    self.backParam_         = 0.0               --每下降百分之几的血量播放一次HurtFrame
    self.backLength_        = 0.0
    self.isBoss_            = false             --是否为Boss怪
    self.isElite_           = false             --是否为精英怪
    self.standFrame_        = ""                --待机动画
    self.hurtFrame_         = ""                --被攻击到一定血量的后退动画
    self.soundFile_         = ""                --声音文件
    self.attackFrame_       = ""                --攻击动画
    self.npcDesc_           = ""                --兵种（妖怪）的描述
    self.adaptScale_        = 0.0               --缩放适应比例系数

    self.firstTurnUp_     = 0.0                 --追加:此怪物第一次出现关数：用于图鉴界面
    self.manualPriority_  = 0                   --追加：操作优先级（用于图鉴等界面中兵种强弱优先级判定）
    self.sizeInBattle_    = 0.0                 --战斗中大小
    self.morphId_         = 0

    -- 无尽模式新增(第N关第N层为boss)
    self.isBossS_         = 0     
    self.isBossW_         = 0
end

return MonsterModel


local AchievementModel = class("AchievementModel")

function AchievementModel:ctor()
    self.achievementId_    = 0          --成就ID:1~13
    self.achievementName_  = ""         --成就Name:“西游大师”. ... .“分享达人”
    self.achievementType_  = ""         --成就的数值类型:
    self.achievementDes1_  = ""         --成就描述1
    self.achievementDes2_  = ""         --成就描述2
    self.rewardType_       = ""         --奖励的类型，peach是奖励蟠桃，exp是奖励经验，ginsengfruit是奖励人参果，buddha是奖励兵种
    self.rewardNum_        = 0          --成就奖励次数！完成一次玩家领取后 n++，当CCUserDefault中存储的数值 = rewardNum时，认为该成就已完成
    self.achievementData_  = 0          --完成当前成就的需要达到的数值
    self.currentData_      = 0.0        --已完成的数值，当前进度       currentData / achievementData
    self.rewardQuantity_   = 0          --奖励数量
end

-- stage_progress：完成的关卡数
-- sign_num：累积签到的次数
-- recharge：累计充值金额
-- peach_used_num：累计消耗蟠桃数
-- unlock_buddha_num：解锁兵种数量 1~16
-- level10_buddha_num：10级兵种数量
-- treasure_num：激活的宝物数量
-- level20_buddha_num：20级兵种数量
-- exp_buy：累计购买经验数量
-- level10_tower_property_num：防御塔10级能力数量
-- lose_num：累计失败次数
-- success_share_num：累计分享次数

return AchievementModel

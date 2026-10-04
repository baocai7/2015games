
local SkillItemModel = class("StageModel")

function SkillItemModel:ctor()

    self.itemId_         = 0            --技能道具id 1～6
    self.itemName_       = ""           --技能道具名字（不是真实名字，是一张图片对应的路径）
    self.itemIcon_       = ""           --icon图片路径
    self.itemIconBig_    = ""
    self.itemNameColon_  = ""
    self.itemConsumable_ = 0            --是否可消耗（同一场战斗中可以多次使用）
    self.itemDesc_       = ""           --描述
    self.itemPrice_      = 0            --价格(蟠桃）
    
end

return SkillItemModel



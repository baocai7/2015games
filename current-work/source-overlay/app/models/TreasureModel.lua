
local TreasureModel = class("TreasureModel")

function TreasureModel:ctor()
    self.treasureId_          = 0          --宝物id
    self.treasureName_        = ""         --宝物名字
    self.treasureDesc_        = ""         --宝物描述
    self.treasureIconPath_    = ""         --中间的大宝物的路径
    self.attribIconPath_      = ""         --属性图标的路径
    self.attribNamePath_      = ""         --属性说明图片的路径
    self.isTreasureEffective_ = false      --宝物是否生效
    self.effectIncreaseRate_  = 0.0        --效果提升率33%~100%
end

return TreasureModel

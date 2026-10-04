
local UpgradePropertyModel = class("UpgradePropertyModel")

function UpgradePropertyModel:ctor()

    self.id_     = 0          --属性id
    self.cnName_ = ""         --属性名称
    self.icon_   = ""         --属性图标
    self.desc_   = ""         --属性描述

    self.level_     = 0        --当前等级
    self.expCost_   = 0        --升级所消耗经验
	self.param_     = 0.0
	self.paramInit_ = 0.0
    self.paramCurr_ = 0.0
	self.paramNext_ = 0.0

	self.propertyType_ = 0    --拆分类型：1.宝塔 2.唐僧
end

return UpgradePropertyModel

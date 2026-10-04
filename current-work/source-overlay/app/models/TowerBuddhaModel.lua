
local TowerBuddhaModel = class("TowerBuddhaModel")

function TowerBuddhaModel:ctor() 
	self.attack_          = 0.0			
	self.life_            = 0.0
	self.rechargeTime_    = 0.0
	self.range_           = 0.0       
	self.spiritGrowSpeed_ = 0.0

	self.spiritStorageLimit_  = 0
	self.expIncreaseParam_    = 0.0
	self.cdTimeDecreaseParam_ = 0.0
	self.spiritIncreaseParam_ = 0.0
	self.energyStorageBasic_  = 0.0
	
    -- ray 手动计算1项防御塔升级属性等级合，供防御塔形态判断
	self.towerPropertyLevelTotal_ = 0

	-- hoo 手动计算3项降妖杖属性总等级,供降妖杖外形判断
	self.wandPropertyLevelTotal_ = 0
end

return TowerBuddhaModel

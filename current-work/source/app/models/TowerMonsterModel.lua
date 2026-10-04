
local TowerMonsterModel = class("TowerMonsterModel")

function TowerMonsterModel:ctor()
    self.towerId_   = 0
	self.towerType_ = ""			--新增：敌塔类型：0～9
	self.life_      = 0
	self.cleanTime_ = 0             --清场怪出场时间 
	
	self.monsterNumLimit_ = 0       --本关最大敌兵数量
	self.monsterIdsTable_ = {}          --新增：本塔刷出敌怪全部字符串id，用"+"连接

	--读 strategy.csv 得到各策略间隔时间 和 妖怪敌兵信息
	self.intervalTimeStrategy1_ = 0.0
	self.intervalTimeStrategy2_ = 0.0
	self.intervalTimeStrategy3_ = 0.0
	self.intervalTimeRP1_ = 0.0
	self.intervalTimeRP2_ = 0.0
	self.intervalTime99_ = 0.0
	self.intervalTime50_ = 0.0
	self.intervalTime20_ = 0.0
	self.intervalTimeClean_ = {}

    self.monsterIdsTable1_ = {}
    self.monsterIdsTable2_ = {}
    self.monsterIdsTable3_ = {}
    self.monsterIdsTableRepeat1_ = {}
    self.monsterIdsTableRepeat2_ = {}
    self.monsterIdsTable99_ = {}
    self.monsterIdsTable50_ = {}
    self.monsterIdsTable20_ = {}

    self.cleanMonsterIdsTable_ = {}
end

return TowerMonsterModel

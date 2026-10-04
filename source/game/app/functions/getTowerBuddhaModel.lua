
local TowerBuddhaModel = import("models.TowerBuddhaModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
--先读第1行 ，获取“id”所在列号
local _idColumn = nil

function DataUtils.getTowerBuddhaModel()

	local expIncreaseLv = DataUtils.getPropertyLevel(1)
	if expIncreaseLv > 20 then
		expIncreaseLv = 1
	end
    local attackLv = DataUtils.getPropertyLevel(2)
    if attackLv > 20 then
    	attackLv = 1
    end
    local rechargeTimeLv = DataUtils.getPropertyLevel(3)
    if rechargeTimeLv > 20 then
    	rechargeTimeLv = 1
    end
    local rangeLv = DataUtils.getPropertyLevel(4)
    if rangeLv > 20 then
    	rangeLv = 1
    end
    local spiritGrowSpeedLv = DataUtils.getPropertyLevel(5)
    if spiritGrowSpeedLv > 20 then
    	spiritGrowSpeedLv = 1
    end
    local spiritStorageLv = DataUtils.getPropertyLevel(6)
    if spiritStorageLv > 20 then
    	spiritStorageLv = 20
    end
    local lifeLv = DataUtils.getPropertyLevel(7)
    if lifeLv > 20 then
    	lifeLv = 1
    end
    local cdTimeDecreaseLv = DataUtils.getPropertyLevel(8)
    if cdTimeDecreaseLv > 20 then
    	cdTimeDecreaseLv = 1
    end
    local spiritIncreaseLv = DataUtils.getPropertyLevel(9)
    if spiritIncreaseLv > 20 then
    	spiritIncreaseLv = 1
    end
    local energyStorageBasicLv = DataUtils.getPropertyLevel(10)
    if energyStorageBasicLv > 20 then
    	energyStorageBasicLv = 1
    end
    
    -- ray 手动计算4项防御塔升级属性等级合，供防御塔形态判断
    local towerPropertyLevelTotal = lifeLv

    -- hoo 手动计算3项降妖杖属性总等级,供降妖杖外形判断
	local wandPropertyLevelTotal = attackLv + rechargeTimeLv + rangeLv

	-- csv
	local upgradePropertyInfo = DataRetainer.UPGRADE_PROPERTIES_INFO

	--先读第1行 ，获取“id”所在列号
    _idColumn = _idColumn or upgradePropertyInfo:findIndexOfValueFromRow(1, "id")

	--读"id"所在列，获取各id对应行号
	local _expIncreaseRow = upgradePropertyInfo:findIndexOfValueFromColumn(_idColumn,"1")
	local _attackRow = upgradePropertyInfo:findIndexOfValueFromColumn(_idColumn,"2")
	local _rechargeTimeRow = upgradePropertyInfo:findIndexOfValueFromColumn(_idColumn,"3")
	local _rangeRow = upgradePropertyInfo:findIndexOfValueFromColumn(_idColumn,"4")
	local _spiritGrowSpeedRow = upgradePropertyInfo:findIndexOfValueFromColumn(_idColumn,"5")
	local _spiritStorageRow = upgradePropertyInfo:findIndexOfValueFromColumn(_idColumn,"6")
	local _lifeRow = upgradePropertyInfo:findIndexOfValueFromColumn(_idColumn,"7")
	local _cdTimeDecreaseRow = upgradePropertyInfo:findIndexOfValueFromColumn(_idColumn,"8")
	local _spiritIncreaseRow = upgradePropertyInfo:findIndexOfValueFromColumn(_idColumn,"9")
	local _energyStorageBasicRow = upgradePropertyInfo:findIndexOfValueFromColumn(_idColumn,"10")

	--再读第1行，获取对应level%dParam对应列号
	local _expIncreaseColumn = upgradePropertyInfo:findIndexOfValueFromRow(1,string.format("level%dParam",expIncreaseLv))
	local _attackColumn = upgradePropertyInfo:findIndexOfValueFromRow(1,string.format("level%dParam",attackLv))
	local _rechargeTimeColumn = upgradePropertyInfo:findIndexOfValueFromRow(1,string.format("level%dParam",rechargeTimeLv))
	local _rangeColumn = upgradePropertyInfo:findIndexOfValueFromRow(1,string.format("level%dParam",rangeLv))
	local _spiritGrowSpeedColumn = upgradePropertyInfo:findIndexOfValueFromRow(1,string.format("level%dParam",spiritGrowSpeedLv))
	local _spiritStorageColumn = upgradePropertyInfo:findIndexOfValueFromRow(1,string.format("level%dParam",spiritStorageLv))
	local _lifeColumn = upgradePropertyInfo:findIndexOfValueFromRow(1,string.format("level%dParam",lifeLv))
	local _cdTimeDecreaseColumn = upgradePropertyInfo:findIndexOfValueFromRow(1,string.format("level%dParam",cdTimeDecreaseLv))
	local _spiritIncreaseColumn = upgradePropertyInfo:findIndexOfValueFromRow(1,string.format("level%dParam",spiritIncreaseLv))
	local _energyStorageBasicColumn = upgradePropertyInfo:findIndexOfValueFromRow(1,string.format("level%dParam",energyStorageBasicLv))

	--读取实际参数
	local expIncrease = upgradePropertyInfo:getData(_expIncreaseRow,_expIncreaseColumn)
	local attack = upgradePropertyInfo:getData(_attackRow,_attackColumn)
	local rechargeTime = upgradePropertyInfo:getData(_rechargeTimeRow,_rechargeTimeColumn)
	local range = upgradePropertyInfo:getData(_rangeRow,_rangeColumn)
	local spiritGrowSpeed = upgradePropertyInfo:getData(_spiritGrowSpeedRow,_spiritGrowSpeedColumn)
	local spiritStorage = upgradePropertyInfo:getData(_spiritStorageRow,_spiritStorageColumn)

	local life = upgradePropertyInfo:getData(_lifeRow,_lifeColumn)
	--宝物加成
	local tm = DataUtils.getTreasureModel(7)
    if tm.isTreasureEffective_ then
        life = tonumber(life * (1 + tm.effectIncreaseRate_ * 0.5))
    end

	local cdTimeDecrease = upgradePropertyInfo:getData(_cdTimeDecreaseRow,_cdTimeDecreaseColumn)
	local spiritIncrease = upgradePropertyInfo:getData(_spiritIncreaseRow,_spiritIncreaseColumn)
	local energyStorageBasic = upgradePropertyInfo:getData(_energyStorageBasicRow,_energyStorageBasicColumn)

    -- 返回对象
    local towerBuddhaModel = TowerBuddhaModel.new()
    towerBuddhaModel.attack_ = attack
    towerBuddhaModel.life_ = life
    towerBuddhaModel.rechargeTime_ = rechargeTime
    towerBuddhaModel.range_ = range
    towerBuddhaModel.spiritGrowSpeed_ = spiritGrowSpeed
    towerBuddhaModel.spiritStorageLimit_ = spiritStorage
    towerBuddhaModel.expIncreaseParam_ = expIncrease
    towerBuddhaModel.cdTimeDecreaseParam_ = cdTimeDecrease
    towerBuddhaModel.spiritIncreaseParam_ = spiritIncrease
    towerBuddhaModel.energyStorageBasic_ = energyStorageBasic
    towerBuddhaModel.towerPropertyLevelTotal_ = towerPropertyLevelTotal
    towerBuddhaModel.wandPropertyLevelTotal_  = wandPropertyLevelTotal
    
    return towerBuddhaModel
end

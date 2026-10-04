
local CSVParser = import("utils.CSVParser")

DataRetainer = {}

-- 是否使用lua字符串
local csvToLua = true

if csvToLua then
	--成就相关数据
	local str = import("profiles.achievement")
	DataRetainer.ACHIEVEMENT_INFO = CSVParser.new(str, true)

	--日常任务相关数据
	local str = import("profiles.task_daily")
	DataRetainer.DAILYTASK_INFO = CSVParser.new(str, true)

	--阶段任务相关数据
	local str = import("profiles.task_stage.task_stage")
	DataRetainer.STAGETASK_INFO = CSVParser.new(str, true)

	--阶段任务的子任务相关数据
	local str = {import("profiles.task_stage.task_stage1"),import("profiles.task_stage.task_stage2"),
				 import("profiles.task_stage.task_stage3"),import("profiles.task_stage.task_stage4"),
				 import("profiles.task_stage.task_stage5"),import("profiles.task_stage.task_stage6"),
				 import("profiles.task_stage.task_stage7"),import("profiles.task_stage.task_stage8")}
	DataRetainer.STAGETASK_SUB_INFO = {CSVParser.new(str[1], true),CSVParser.new(str[2], true),
									   CSVParser.new(str[3], true),CSVParser.new(str[4], true),
									   CSVParser.new(str[5], true),CSVParser.new(str[6], true),
									   CSVParser.new(str[7], true),CSVParser.new(str[8], true)}

	--buddha相关数据
	local str = import("profiles.buddha")
	DataRetainer.BUDDHA_INFO = CSVParser.new(str, true)

	--buddha升级消耗经验数据
	local str = import("profiles.buddha_exp_cost")
	DataRetainer.BUDDHA_EXP_COST_INFO = CSVParser.new(str, true)

	--monster相关数据
	local str = import("profiles.monster")
	DataRetainer.MONSTER_INFO = CSVParser.new(str, true)

	--monster碎片相关数据
	local str = import("profiles.monster_piece")
	DataRetainer.MONSTER_PIECE_INFO = CSVParser.new(str, true)

	--monsterTower相关数据
	local str = import("profiles.monster_tower")
	DataRetainer.MONSTER_TOWER_INFO = CSVParser.new(str, true)
	local str = import("profiles.c_monster_tower")
	DataRetainer.MONSTER_TOWER_INFO_CHALLENGE = CSVParser.new(str, true)
	local str = import("profiles.d_monster_tower")
	DataRetainer.MONSTER_TOWER_INFO_DIARY = CSVParser.new(str, true)

	--商店刷新礼包数据信息
	local str = import("profiles.goods_info")
	DataRetainer.GOODS_INFO = CSVParser.new(str, true)

	--shopInfo
	local str = import("profiles.shop_info")
	DataRetainer.SHOP_INFO = CSVParser.new(str, true)

	--礼包相关数据
	local str = import("profiles.gift")
	DataRetainer.GIFT_INFO = CSVParser.new(str, true)

	--地图上章节图标位置
	local str = import("profiles.chapter_location")
	DataRetainer.CHAPTER_LOCATION_INFO = CSVParser.new(str, true)

	--itempool相关数据
	local str = import("profiles.itempool_info")
	DataRetainer.ITEM_POOL_INFO = CSVParser.new(str, true)

	--灵气消耗数据信息
	local str = import("profiles.spirit_cost_basic")
	DataRetainer.SPIRIT_COST_BASIC_INFO = CSVParser.new(str, true)

	--关卡数据信息
	local str = import("profiles.stage")
	DataRetainer.STAGE_INFO = CSVParser.new(str, true)
	
	--出兵策略数据信息
	local str = import("profiles.strategy")
	DataRetainer.STRATEGY_INFO = CSVParser.new(str, true)

	--宝物相关数据
	local str = import("profiles.treasure")
	DataRetainer.TREASURE_INFO = CSVParser.new(str, true)

	--宝物碎片相关数据
	local str = import("profiles.treasure_piece")
	DataRetainer.TREASURE_PIECE_INFO = CSVParser.new(str, true)

	--属性升级数据信息
	local str = import("profiles.upgrade_properties")
	DataRetainer.UPGRADE_PROPERTIES_INFO = CSVParser.new(str, true)

	--战斗界面skill道具
	local str = import("profiles.skill_item")
	DataRetainer.SKILL_ITEM_INFO = CSVParser.new(str, true)

	--失败界面的小tip提示
	local str = import("profiles.lose_tips")
	DataRetainer.LOSE_TIP_INFO = CSVParser.new(str, true)

	--充值相关数据
	local str = import("profiles.recharge")
	DataRetainer.RECHARGE_INFO = CSVParser.new(str, true)

	--新充值界面相关数据
	local str = import("profiles.payment")
	DataRetainer.PAYMENT_INFO = CSVParser.new(str, true)
	local str = import("profiles.payment_ios")
	DataRetainer.PAYMENT_IOS_INFO = CSVParser.new(str, true)

	--新商店仙宫杂货相关数据
	local str = import("profiles.shop_normal")
	DataRetainer.SHOPGOODS_INFO = CSVParser.new(str, true)

	--新商店经验商城相关数据
	local str = import("profiles.shop_exp")
	DataRetainer.SHOPEXP_INFO = CSVParser.new(str, true)

	--幸运大转盘数据
	local str = import("profiles.fortune_wheel")
	DataRetainer.FORTUNE_WHEEL_INFO = CSVParser.new(str, true)

	-- 无尽模式层数数据
	local str = import("profiles.stage_infinite")
	DataRetainer.INFINITE_STAGE_INFO = CSVParser.new(str, true)

	-- 无尽当前层数的波次数据
	local str = import("profiles.monster_wave")
	DataRetainer.MONSTER_WAVE_INFO = CSVParser.new(str, true)

	-- 无尽模式monster相关数据
	local str = import("profiles.monster_infinite")
	DataRetainer.INFINITE_MONSTER_INFO = CSVParser.new(str, true)

	-- 无尽模式出兵策略相关数据
	local str = import("profiles.strategy_infinite")
	DataRetainer.INFINITE_STRATEGY_INFO = CSVParser.new(str, true)

	-- 活动关卡数据(UI界面)
	local str = import("profiles.activity_stage")
	DataRetainer.ACTIVITY_STAGE_INFO = CSVParser.new(str, true)

	-- 活动商品兑换
	local str = import("profiles.shop_activity")
	DataRetainer.ACTIVITY_SHOP_INFO = CSVParser.new(str, true)
else
	--成就相关数据
	DataRetainer.ACHIEVEMENT_INFO = CSVParser.new("profiles/achievement.csv")

	--日常任务相关数据
	DataRetainer.DAILYTASK_INFO = CSVParser.new("profiles/task_daily.csv")

	--阶段任务相关数据
	DataRetainer.STAGETASK_INFO = CSVParser.new("profiles/task_stage/task_stage.csv")

	--阶段任务的子任务相关数据
	DataRetainer.STAGETASK_SUB_INFO = {CSVParser.new("profiles/task_stage/task_stage1.csv"),CSVParser.new("profiles/task_stage/task_stage2.csv"),
									   CSVParser.new("profiles/task_stage/task_stage3.csv"),CSVParser.new("profiles/task_stage/task_stage4.csv"),
									   CSVParser.new("profiles/task_stage/task_stage5.csv"),CSVParser.new("profiles/task_stage/task_stage6.csv"),
									   CSVParser.new("profiles/task_stage/task_stage7.csv"),CSVParser.new("profiles/task_stage/task_stage8.csv")}

	--buddha相关数据
	DataRetainer.BUDDHA_INFO = CSVParser.new("profiles/buddha.csv")

	--buddha升级消耗经验数据
	DataRetainer.BUDDHA_EXP_COST_INFO = CSVParser.new("profiles/buddha_exp_cost.csv")

	--monster相关数据
	DataRetainer.MONSTER_INFO = CSVParser.new("profiles/monster.csv")

	--monster碎片相关数据
	DataRetainer.MONSTER_PIECE_INFO = CSVParser.new("profiles/monster_piece.csv")

	--monsterTower相关数据
	DataRetainer.MONSTER_TOWER_INFO = CSVParser.new("profiles/monster_tower.csv")
	DataRetainer.MONSTER_TOWER_INFO_CHALLENGE = CSVParser.new("profiles/c_monster_tower.csv")
	DataRetainer.MONSTER_TOWER_INFO_DIARY = CSVParser.new("profiles/d_monster_tower.csv")

	--商店刷新礼包数据信息
	DataRetainer.GOODS_INFO = CSVParser.new("profiles/goods_info.csv")

	--shopInfo
	DataRetainer.SHOP_INFO = CSVParser.new("profiles/shop_info.csv")

	--礼包相关数据
	DataRetainer.GIFT_INFO = CSVParser.new("profiles/gift.csv")

	--地图上章节图标位置
	DataRetainer.CHAPTER_LOCATION_INFO = CSVParser.new("profiles/chapter_location.csv")

	--itempool相关数据
	DataRetainer.ITEM_POOL_INFO = CSVParser.new("profiles/itempool_info.csv")

	--灵气消耗数据信息
	DataRetainer.SPIRIT_COST_BASIC_INFO = CSVParser.new("profiles/spirit_cost_basic.csv")

	--关卡数据信息
	DataRetainer.STAGE_INFO = CSVParser.new("profiles/stage.csv")

	--出兵策略数据信息
	DataRetainer.STRATEGY_INFO = CSVParser.new("profiles/strategy.csv")

	--宝物相关数据
	DataRetainer.TREASURE_INFO = CSVParser.new("profiles/treasure.csv")

	--宝物碎片相关数据
	DataRetainer.TREASURE_PIECE_INFO = CSVParser.new("profiles/treasure_piece.csv")

	--属性升级数据信息
	DataRetainer.UPGRADE_PROPERTIES_INFO = CSVParser.new("profiles/upgrade_properties.csv")

	--战斗界面skill道具
	DataRetainer.SKILL_ITEM_INFO = CSVParser.new("profiles/skill_item.csv")

	--失败界面的小tip提示
	DataRetainer.LOSE_TIP_INFO = CSVParser.new("profiles/lose_tips.csv")

	--充值相关数据
	DataRetainer.RECHARGE_INFO = CSVParser.new("profiles/recharge.csv")

	--新充值界面相关数据
	DataRetainer.PAYMENT_INFO     = CSVParser.new("profiles/payment.csv")
	DataRetainer.PAYMENT_IOS_INFO = CSVParser.new("profiles/payment_ios.csv")

	--新商店仙宫杂货相关数据
	DataRetainer.SHOPGOODS_INFO = CSVParser.new("profiles/shop_normal.csv")

	--新商店经验商城相关数据
	DataRetainer.SHOPEXP_INFO = CSVParser.new("profiles/shop_exp.csv")

	--幸运大转盘数据
	DataRetainer.FORTUNE_WHEEL_INFO = CSVParser.new("profiles/fortune_wheel.csv")

	-- 无尽模式层数数据
	DataRetainer.INFINITE_STAGE_INFO = CSVParser.new("profiles/stage_infinite.csv")

	-- 无尽当前层数的波次数据
	DataRetainer.MONSTER_WAVE_INFO = CSVParser.new("profiles/monster_wave.csv")

	-- 无尽模式monster相关数据
	DataRetainer.INFINITE_MONSTER_INFO = CSVParser.new("profiles/monster_infinite.csv")

	-- 无尽模式出兵策略相关数据
	DataRetainer.INFINITE_STRATEGY_INFO = CSVParser.new("profiles/strategy_infinite.csv")

	-- 活动关卡数据(UI界面)
	DataRetainer.ACTIVITY_STAGE_INFO = CSVParser.new("profiles/activity_stage.csv")

	-- 活动商品兑换
	DataRetainer.ACTIVITY_SHOP_INFO = CSVParser.new("profiles/shop_activity.csv")
end



print("load csv done.....")


--全局云端存档本地内存值
CloudData = {}

CloudData.IS_GUEST = false

CloudData.TOKEN = ""              -- 服务器占位符
CloudData.SIGN = ""               -- 服务器签名
CloudData.USERNAME = "username"   -- 用户名,DataEye要求不能为空串
CloudData.TEMP_TOKEN = ""         -- 战斗前的临时token，防止战斗前消耗精力作弊

CloudData.DELTA_TIME = 0      -- 服务器时间与本地时间的时间差 
CloudData.HAS_ENERGY = true   -- 是否有精力

CloudData.ESSENCE = 0
CloudData.ENERGY = 0
CloudData.MAX_ENERGY = 0
CloudData.EXP = 0
CloudData.PEACH = 0
CloudData.STAGE_PROGRESS = 0
CloudData.SWEEP = 0
CloudData.GINSENG_FRUIT = 0
CloudData.ACTIVITY_COINS = 0        -- 活动关卡奖励的代币

-- 登录 playerInfoNew 完整解析并恢复本地快照后才允许写入快照。
-- 防止启动阶段的默认 0 覆盖已经保存的账号数据。
CloudData.PLAYER_DATA_READY = false

-- 关卡活动相关
CloudData.ACTIVITY_STAGE_STATUS = 0         -- 当前是否有活动关卡（0：没有；1：有）
CloudData.ACTIVITY_STAGE_INFO_TABLE = {}    -- 活动关卡信息
CloudData.ACTIVITY_COINS_ADD_NUM = 0        -- 关卡奖励的代币数量
CloudData.ACTIVITY_SHOP_INFO_TABLE = {}     -- 活动商品兑换

CloudData.SIGN_ACCUMULATION = 0
CloudData.RECHARGE_ACCUMULATION = 0
CloudData.PEACH_USED_ACCUMULATION = 0
CloudData.EXP_BOUGHT_ACCUMULATION = 0
CloudData.LOSE_GAME_ACCUMULATION = 0
CloudData.SHARE_ACCUMULATION = 0

-- 无尽模式胜利时返回的奖励数据
CloudData.INFINITE_GOODS_TYPE        = ""       -- 随机奖励的类型
CloudData.INFINITE_GOODS_ITEM_ID     = 0        -- 随机奖励的物品的ID
CloudData.INFINITE_GOODS_NUM         = 0        -- 随机奖励的物品的数量
CloudData.INFINITE_ESSENCE_NUM       = 0        -- 精华石的数量
CloudData.INFINITE_MONSTER_PIECE_ID  = 0        -- 妖怪碎片的ID
CloudData.INFINITE_MONSTER_PIECE_NUM = 0        -- 妖怪碎片的数量

CloudData.INFINITE_STAGE_PROGRESS    = 1        -- 无尽模式关卡最大层数
CloudData.INFINITE_WAVES_PROGRESS    = 0        -- 无尽模式关卡最大波数

-- 修改用户昵称
CloudData.CHANGE_NICKNAME_ERRORCODE  = 0        -- 服务器返回错误编码
CloudData.CHANGE_NICKNAME_ERRORMSG   = ""       -- 服务器返回错误信息            
CloudData.NICK_NAME                  = ""       -- 用户昵称


--时间信息
CloudData.TIME_SERVER = 0
CloudData.NEXT_FREESUMMON_TIME_EXP = 0
CloudData.NEXT_FREESUMMON_TIME_PEACH = 0
CloudData.FREE_SUMMON_NUM_EXP = 0

--扭蛋价格信息
CloudData.EXP_SINGLE_COST = 0
CloudData.EXP_CONTINUE_COST = 0
CloudData.PEACH_SINGLE_COST = 0
CloudData.PEACH_CONTINUE_COST = 0

--抽奖相关数据
CloudData.DRAW_NUM            = 0      --当前抽奖次数
CloudData.CRIT_NUM            = 1      --抽奖暴击倍数
CloudData.AWARD_ID            = 0      --奖品id
CloudData.AWARD_ITEM_ID       = 0      --若奖品为道具,则记录道具id
CloudData.AWARD_NUM           = 0      --奖品数量

CloudData.CREATE_TIME_SECONDS = 0
CloudData.FIRST_PURCHASE_STATE = 0						-- 0:没有首充  1:已经首充没领奖励  2:已经首充已经领取奖励

CloudData.PAYMENT_ITEM_STATE = {0,0,0,0,0,0}        --充值界面商品的状态 0:没购买 1:已购买但没领取 2:过期了 -1:已领取 (前3种可以领取蟠桃)

CloudData.TEAM_UNLOCKGRID_NUM = 3                       --队伍界面解锁的格子数

CloudData.NPC_INFO = {}									-- NPC 信息 升级界面中神仙和妖怪页共用
CloudData.TREASURE_PIECE_INFO = {}				        -- 宝物碎片信息: key__1__ 对应 treasurePiece__1__Quality品质 : 0123
CloudData.MONSTER_PIECE_INFO = {}					    -- 妖怪碎片信息：key__1__ 对应 monsterPiece__1__Num数量 : 0～
CloudData.UPGRADE_PROPERTY_INFO = {}			        -- 塔和唐僧“属性”升级信息：
CloudData.ACHIEVEMENT_INFO = {}					        -- 成就信息：id 1～14 对应 step 1~n
CloudData.SKILL_ITEM_INFO = {}							-- 战斗界面道具信息：index 1~6 对应item数量 0~X
CloudData.SHOP_INFO = {}

CloudData.DAILY_TASK_INFO = {0,0,0,0,0,0,0,0,0,0,0,0,0}                    --日常任务的完成信息
CloudData.STAGE_TASK_INFO = {}                                             --阶段任务的完成信息
CloudData.STAGE_TASK_SUB_INFO = {0,0,0,0,0,0,0,0,0,0}                      --阶段任务子任务的完成信息
CloudData.CHAPTER_TASK_INFO   = {0,0,0,0,0,0,0,0}

CloudData.GUIDE_INFO = {}

CloudData.URL_UPDATE = ""
CloudData.PATH_DLC = ""
CloudData.MISSED_ARMATURE_RES = {}

CloudData.SUMMON_RESULT_NPCID_TABLE = {}
CloudData.SUMMON_RESULT_ESSENCE_TABLE = {}

CloudData.CHAPTER_UNLOCK_ANIMATION_PLAYED  = {1,0,0,0,0,0,0,0}          -- 标记章节是否播放过解锁动画,存储1~8
CloudData.SCENE_UNLOCK_ANIMATION_PLAYED    = {0,0,0,0,0,0}              -- 标记下方六个场景入口是否播放过解锁动画,存储1~6
CloudData.TREASURE_UNLOCK_ANIMATION_PLAYED = {0,0,0,0,0,0,0,0}          -- 标记宝物收集完全时是否播放过解锁动画,存储1~8
CloudData.IS_TREASURE_EFFECTIVE            = {0,0,0,0,0,0,0,0}          -- 标记宝物是否收集完全

--网络信息错误返回
CloudData.ERR_CODE = 0

CloudData.OPENNING_COMIC_PLAYED           = 0                           --标记开场漫画是否播放过

CloudData.ITEM1_UNLOCK                    = 0
CloudData.ITEM2_UNLOCK                    = 0
CloudData.ITEM3_UNLOCK                    = 0
CloudData.ITEM4_UNLOCK                    = 0
CloudData.ITEM5_UNLOCK                    = 0
CloudData.ITEM6_UNLOCK                    = 0


--引导部分数据
CloudData.GUIDE_STEP_STAGE0_1             = 0
CloudData.GUIDE_STEP_STAGE0_2             = 0
CloudData.GUIDE_STEP_STAGE0_3             = 0
CloudData.GUIDE_STEP_SELECT_CHAPTER       = 0
CloudData.GUIDE_STEP_GAME_START           = 0
CloudData.GUIDE_STEP_SWIPE                = 0
CloudData.GUIDE_STEP_MAKE_BUDDHA          = 0
CloudData.GUIDE_STEP_UPGRADE_SPIRIT       = 0
CloudData.GUIDE_STEP_FIRE                 = 0
CloudData.GUIDE_STEP_ENTER_TEAMSCENE      = 0
CloudData.GUIDE_STEP_TIANJIANG_ON_TEAM    = 0
CloudData.GUIDE_STEP_SCREEN_ZOOM          = 0
CloudData.GUIDE_STEP_ENTER_UPGRADESCENE   = 0
CloudData.GUIDE_STEP_UPGRADE_BUDDHA       = 0
CloudData.GUIDE_STEP_UPGRADE_PROPERTY     = 0
CloudData.GUIDE_STEP_ENTER_SUMMONSCENE    = 0
CloudData.GUIDE_STEP_SUMMON1              = 0
CloudData.GUIDE_STEP_SUMMON2              = 0
CloudData.GUIDE_STEP_SHASENG_ON_TEAM      = 0
CloudData.GUIDE_STEP_ENTER_TREASURESCENE  = 0
CloudData.GUIDE_STEP_TREASURE1            = 0
CloudData.GUIDE_STEP_TREASURE2            = 0
CloudData.GUIDE_STEP_OPEN_ACHIEVEMENT     = 0
CloudData.GUIDE_STEP_ACHIEVEMENT          = 0
CloudData.GUIDE_STEP_UNLOCK_MONSTER1      = 0
CloudData.GUIDE_STEP_UNLOCK_MONSTER2      = 0
CloudData.GUIDE_STEP_UNLOCK_MONSTER3      = 0
CloudData.GUIDE_STEP_LOSE_TIP1            = 0
CloudData.GUIDE_STEP_LOSE_TIP2            = 0
CloudData.GUIDE_STEP_ITEM1                = 0
CloudData.GUIDE_STEP_ITEM2                = 0
CloudData.GUIDE_STEP_DAILY                = 0
CloudData.GUIDE_STEP_CHALLENGE            = 0

--剧情对话数据
CloudData.DIALOGUE_STAGE0_1               = 0
CloudData.DIALOGUE_STAGE0_2               = 0
CloudData.DIALOGUE_STAGE0_3               = 0
CloudData.DIALOGUE_STAGE0_4               = 0
CloudData.DIALOGUE_STAGE0_5               = 0
CloudData.DIALOGUE_STAGE0_6               = 0
CloudData.DIALOGUE_STAGE0_7               = 0
CloudData.DIALOGUE_STAGE0_8               = 0
CloudData.DIALOGUE_TIANJIANG_UNLOCK       = 0
CloudData.DIALOGUE_UPGRADE                = 0
CloudData.DIALOGUE_TREASURE               = 0

--是否已显示公告
CloudData.NOTICE_SHOWED = false
--今天的日期
CloudData.CUR_DATE 		= 20150401


--排行榜列表
CloudData.CHART_TABLE = {}
--排行榜我的排名
CloudData.CHART_MYRANK = 9999999
--排行榜下次刷新时间
CloudData.CHART_REFRESH_INTERVAL = 60000

--限时充值界面是否显示  0-不显示，1-显示
CloudData.SHOW_LIMITED_TIME_RECHARGE = 0
--限时充值活动剩余时间
CloudData.LAST_TIME_FOR_RECHARGE_ACTIVITY = 0

--仅检测用户名是否合法
CloudData.CHECK_ACCOUNT_ONLY = false

--玩家选择的服务器id
CloudData.USER_SERVER_ID = 0
--玩家选择的服务器ip
CloudData.USER_SERVER_IP = ""
--在选定服务器是否已有角色 0-没有  1--有
CloudData.GOT_ROLE = 0
--已有角色的服务器分区
CloudData.REGIONS = nil
--服务器列表
CloudData.SERVERS_TABLE = {}

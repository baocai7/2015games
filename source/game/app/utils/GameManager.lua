
GameManager = {}

-- 玩家当前选择关卡
GameManager.STAGE_NUM = 0
GameManager.STAGE_NUM_CHALLENGE = 0
GameManager.STAGE_NUM_DIARY = 0

-- 无尽模式
GameManager.INFINITE_MODE = false

-- 无尽模式的层数
GameManager.INFINITE_STAGE_NUM = 1

-- 当前关唐僧等级
GameManager.TANGMONK_LEVEL = 0
-- 当前灵气值
GameManager.CURRENT_SPIRIT = 0

-- 将灵气分为两个部分，通过操作获取真正的灵气
GameManager.CURRENT_SPIRIT_FACTOR = math.random(13,10001)

-- 商
GameManager.CURRENT_SPIRIT_A = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

-- 余
GameManager.CURRENT_SPIRIT_B = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

-- 索引数
GameManager.CURRENT_SPIRIT_INDEX = 1

local function resetSpiritIndex()
    -- 重新使用新地址
    GameManager.CURRENT_SPIRIT_A = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    GameManager.CURRENT_SPIRIT_B = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

    GameManager.CURRENT_SPIRIT_INDEX = math.random(1,20)
    GameManager.CURRENT_SPIRIT_FACTOR = math.random(13,10001)
    GameManager.CURRENT_SPIRIT_A[GameManager.CURRENT_SPIRIT_INDEX] = 0
    GameManager.CURRENT_SPIRIT_B[GameManager.CURRENT_SPIRIT_INDEX] = 0
end
GameManager.resetSpiritIndex = resetSpiritIndex

-- 获取灵气值
local function getCurrentSpirit()
    local factor = tonumber(GameManager.CURRENT_SPIRIT_FACTOR) or 1
    local index = tonumber(GameManager.CURRENT_SPIRIT_INDEX) or 1
    local a = tonumber(GameManager.CURRENT_SPIRIT_A[index]) or 0
    local b = tonumber(GameManager.CURRENT_SPIRIT_B[index]) or 0
    local currentSpirit = a * factor + b

    return -currentSpirit
end
GameManager.getCurrentSpirit = getCurrentSpirit

-- 设置欺骗值
local function setCheatValue()
    local step = math.random(5,11)
    local value = GameManager.CURRENT_SPIRIT_FACTOR + step*77
    for i=1,20,step do
        if(i~=GameManager.CURRENT_SPIRIT_INDEX) then
            value = value/2
            GameManager.CURRENT_SPIRIT_A[i] = value
            value = value/2
            GameManager.CURRENT_SPIRIT_B[i] = value
        end
    end
end

-- 设置灵气值
local function setCurrentSpirit(count)
    count = tonumber(count) or 0
    setCheatValue()
    
    GameManager.CURRENT_SPIRIT = count -- 迷惑作弊玩家
    local a = math.floor(count/GameManager.CURRENT_SPIRIT_FACTOR)
    local b = count-a*GameManager.CURRENT_SPIRIT_FACTOR

    GameManager.CURRENT_SPIRIT_A[GameManager.CURRENT_SPIRIT_INDEX] = -a
    GameManager.CURRENT_SPIRIT_B[GameManager.CURRENT_SPIRIT_INDEX] = -b
end
GameManager.setCurrentSpirit = setCurrentSpirit

-- 增加灵气值
local function addCurrentSpirit(num)
    setCurrentSpirit(getCurrentSpirit() + (tonumber(num) or 0))
end
GameManager.addCurrentSpirit = addCurrentSpirit




-- 战斗中的塔间距(暂时日常，试炼，活动关卡用到)
GameManager.TOWER_DISTANCE = 0

-- 活动关卡难度(1:简单；2:普通；3:困难)
GameManager.ACTIVITY_STAGE_TYPE = 0 

-- ChapterIcon按钮编号(章节)：0～7
GameManager.CHAPTER_ICON_TAG = 0

-- 签到状态:0表示今天未签到  1表示今天已经签到 -1表示未知
GameManager.SIGNED_STATE = 0

--召唤弹窗是否关闭
GameManager.IS_SUMMONLAYER_CLOSED = false

--新兵种出现界面是否关闭
GameManager.IS_NEWFELLOW_CLOSED   = false

--宝物碎片信息展示界面是否关闭
GameManager.IS_TREASURE_PIECE_LAYER_CLOSED   = false

--领取成就奖励页面是否关闭
GameManager.IS_ALERT_ACHIEVEMENT_CLOSED   = false
--成就页面是否关闭
GameManager.IS_ACHIEVEMENT_LAYER_CLOSED   = false

--充值界面是否关闭
GameManager.IS_PAYMENT_LAYER_CLOSED   = false

-- 活动兑换商品界面是否关闭
GameManager.IS_EXCHANGE_LAYER_CLOSED = false

--是否有新兵种解锁(章节界面"new"提示)
GameManager.IS_HAVE_NEW_BUDDHA   = false

--第五关道具解锁动画完成后接道具引导
GameManager.ITEM1_ANIMATION_SHOWED_STAGE5 = false
GameManager.ITEM2_ANIMATION_SHOWED_STAGE5 = false


--预加载升级界面的四个table
GameManager.BUDDHA_MODEL_TABLE  = {}
GameManager.MONSTER_MODEL_TABLE = {}
GameManager.TOWER_MODEL_TABLE   = {}
GameManager.TANG_MODEL_TABLE    = {}

--成就,日常,阶段任务是否有小红点提示
GameManager.IS_ACHIEVEMENT_NEW         = false
GameManager.IS_DAILY_TASK_NEW          = false
GameManager.IS_STAGE_TASK_NEW          = false

--ios商品是否初始化
GameManager.IS_STORE_INIT = false

if device.platform == "android" or device.platform == "ios" then
    GameManager.ACCOUNT_SERVER_IP = IP
    GameManager.DEFAULT_VERSION = DEFAULT_VERSION
elseif device.platform == "windows" or device.platform == "mac" then
    --GameManager.ACCOUNT_SERVER_IP = "125.88.152.21"    --正式服
    GameManager.ACCOUNT_SERVER_IP = "123.58.130.157:8080"  -- 测试服
    GameManager.DEFAULT_VERSION = "1.1.1"
end

-- ios debug 调试开关
if DEBUG_IOS then
    require("channelConfig")
    GameManager.ACCOUNT_SERVER_IP = IP
    GameManager.DEFAULT_VERSION = DEFAULT_VERSION
end

-- 声音或者音乐后缀，[ogg, mp3]，硬件一般同时只能硬解码一个音乐，多音乐或者声音会造成性能影响
GameManager.POSTFIX = ""

-- 如果是精减版，不使用字体
if(LITE) then
    GameManager.FONTNAME_TTF = nil -- 这句相当于 GameManager.FONTNAME_TTF 不存在
else
    GameManager.FONTNAME_TTF = "fonts/DFYuanW7-GB2312.ttf"
end

-- 扩展包里存在的骨骼名称
GameManager.RES_MISSED_ARMATURE = {"dadaomuguai","daerlangshen","dafuhu","dahouyi","dajiguanren","dalongnv","dapeng","dashikeng","dawanshenglong","dawugang",
                                   "daxiang","daxianglong","daxiangzi","daxingtian","daxuangui","dayuguai","dizangseng","dizangwang","dongdongdawang","heibaiwuchang",
                                   "heiwuchang","honghama","huaihou","jichenezha","jinjiaoyinjiao","jinluowang","laoshuguai","pibajing","shizi","shotouguai",
                                   "taishanglaolaojun","tieshan","xiaocaishen","xiaoerlangshen","xiaofuhu","xiaohouyi","xiaojiguanren","xiaonuozha","xiaotaishanglaojun","xiaowugang",
                                   "xiaowukong","xiaoxianglong","xiaoxingtian","xiaoxuanwu","zhongdaomuguai","zhongxiangzi","bianshenwutian","zixia","zixiaxianzi","xiaolongnv",
                                   "gaojiwukong"}

-- 完全版与精减版，使用不同的扩展包
if(LITE) then
    GameManager.URL_MISSED_ARMATURE = "http://125.88.152.25/dbxy/lite_p.zip"
else
    GameManager.URL_MISSED_ARMATURE = "http://125.88.152.25/dbxy/beta_p.zip"
end

-- 缺失的骨骼是否下载完成
GameManager.IS_ARMATURE_DOWNLOADED = false

-- 消息服IP
GameManager.MSG_SERVER_IP = GameManager.ACCOUNT_SERVER_IP

-- 游戏内交易 产品号 PVE实时战斗用
GameManager.PRODUCT_RELIVE = 20 -- 复活
--GameManager.PRODUCT_ITEM1  = "19" -- 老君金丹  -- 1
--GameManager.PRODUCT_ITEM2  = "18" -- 金钢质   -- 2
--GameManager.PRODUCT_ITEM3  = "17" -- 芭蕉扇   -- 3
--GameManager.PRODUCT_ITEM4  = "16" -- 金钟罩   -- 4
--GameManager.PRODUCT_ITEM5  = "15" -- 万字符   -- 5
--GameManager.PRODUCT_ITEM6  = "14" -- 献宝令   -- 6

-- 游戏配置内存快照
GameManager.MUSIC_SWITCH_ON = true  -- 用户音乐开头(缺省为开)
GameManager.SOUND_SWITCH_ON = true  -- 用户声音开头(缺省为开)
GameManager.SHOW_NOTICE     = true  -- 用户公告开关（缺省为显示公告）

-- 动画后缀
GameManager.ANIM_POSTFIX = ".csb"

--初始化玩家服务器分区IP
-- Use the channel-configured account server until the selected region
-- response supplies its own ip/port in LoginScene.
GameManager.IP = IP or "192.168.31.225:18080"

-- PC端测试的账号和密码
GameManager.USER_NAME = "hoo001"
GameManager.PASSWORD  = "123"

-- 图片公告下载资源需要的版本文件地址（为了能多次下载同一资源，该地址返回服务器当前的时间戳）
GameManager.GET_TIME_SECOND_URL = string.format("http://%s/server/timesecond", GameManager.IP)

-- 是否是从设置里返回登录界面
GameManager.IS_BACK_FROM_SETLAYER = false







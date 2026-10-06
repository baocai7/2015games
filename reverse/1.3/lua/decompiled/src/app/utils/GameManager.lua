local M = {}
M.STAGE_NUM = 0
M.STAGE_NUM_CHALLENGE = 0
M.STAGE_NUM_DIARY = 0
M.ELITE_STAGE_NUM = 0
M.STAGE_ID = 0
M.MODE = 0
M.RESULT_SHOWED = false
M.ENERGY_COST = 0
M.FRAME_SEC = 24
M.PVP_TEAM_ATTACK = {}
M.PVP_TEAM_GUARD = {}
M.INFINITE_MODE = false
M.INFINITE_STAGE_NUM = 1
M.CHAPTER_ICON_TAG = 0
M.SIGNED_STATE = 0
M.IS_SUMMONLAYER_CLOSED = false
M.IS_NEWFELLOW_CLOSED = false
M.IS_TREASURE_PIECE_LAYER_CLOSED = false
M.IS_ALERT_ACHIEVEMENT_CLOSED = false
M.IS_ACHIEVEMENT_LAYER_CLOSED = false
M.IS_PAYMENT_LAYER_CLOSED = false
M.IS_EXCHANGE_LAYER_CLOSED = false
M.IS_MAIL_LAYER_CLOSED = false
M.IS_SIGN_LAYER_CLOSED = false
M.IS_SPIN_LAYER_CLOSED = false
M.NEW_BUDDHA_ID = {}
M.ITEM1_ANIMATION_SHOWED_STAGE5 = false
M.ITEM2_ANIMATION_SHOWED_STAGE5 = false
M.BUDDHA_MODEL_TABLE = {}
M.MONSTER_MODEL_TABLE = {}
M.TOWER_MODEL_TABLE = {}
M.TANG_MODEL_TABLE = {}
M.IS_ACHIEVEMENT_NEW = false
M.IS_DAILY_TASK_NEW = false
M.IS_STAGE_TASK_NEW = false
M.CHAT_TARGET = 0
M.NEW_CHAT_RECEIVER = {}
M.IS_ATTACKED_IN_PVP = false
M.USER_ICON_PATH = "buddha_icon/buddha"
M.IS_STORE_INIT = false
M.BG_POINT_X = 1920 - display.width
if device.platform == "android" or device.platform == "ios" then
  M.ACCOUNT_SERVER_IP = IP
elseif device.platform == "windows" or device.platform == "mac" then
  M.ACCOUNT_SERVER_IP = "123.58.130.157:8080"
end
M.DEFAULT_VERSION = DYUtils.gameVer()
if DEBUG_IOS then
  require("channelConfig")
  M.ACCOUNT_SERVER_IP = IP
end
M.POSTFIX = ""
if LITE then
  M.FONTNAME_TTF = nil
else
  M.FONTNAME_TTF = "fonts/DFYuanW7-GB2312.ttf"
end
M.RES_MISSED_ARMATURE = {
  "dadaomuguai",
  "daerlangshen",
  "dafuhu",
  "dahouyi",
  "dajiguanren",
  "dalongnv",
  "dapeng",
  "dashikeng",
  "dawanshenglong",
  "dawugang",
  "daxiang",
  "daxianglong",
  "daxiangzi",
  "daxingtian",
  "daxuangui",
  "dayuguai",
  "dizangseng",
  "dizangwang",
  "dongdongdawang",
  "heibaiwuchang",
  "heiwuchang",
  "honghama",
  "huaihou",
  "jichenezha",
  "jinjiaoyinjiao",
  "jinluowang",
  "laoshuguai",
  "pibajing",
  "shizi",
  "shotouguai",
  "taishanglaolaojun",
  "tieshan",
  "xiaocaishen",
  "xiaoerlangshen",
  "xiaofuhu",
  "xiaohouyi",
  "xiaojiguanren",
  "xiaonuozha",
  "xiaotaishanglaojun",
  "xiaowugang",
  "xiaowukong",
  "xiaoxianglong",
  "xiaoxingtian",
  "xiaoxuanwu",
  "zhongdaomuguai",
  "zhongxiangzi",
  "bianshenwutian",
  "zixia",
  "zixiaxianzi",
  "xiaolongnv",
  "gaojiwukong"
}
if LITE then
  M.URL_MISSED_ARMATURE = "http://125.88.152.25/dbxy/lite_p.zip"
else
  M.URL_MISSED_ARMATURE = "http://125.88.152.25/dbxy/online_res.zip"
end
M.IS_ARMATURE_DOWNLOADED = false
M.MSG_SERVER_IP = "125.88.152.19"
M.PRODUCT_RELIVE = 20
M.MUSIC_SWITCH_ON = true
M.SOUND_SWITCH_ON = true
M.SHOW_NOTICE = true
M.ANIM_POSTFIX = ".csb"
M.IP = "123.58.130.157:8080"
M.GET_TIME_SECOND_URL = string.format("http://%s/server/millis", M.IP)
M.IS_BACK_FROM_SETLAYER = false
M.IS_FIRST_LOGIN = true
M.IS_CHAT_LOGIN_OK = false
M.LAST_CHAT_TIME = 0
M.IS_USER_BUSY = 0
M.IS_FRIEND_PK = 0
M.IS_REVENGE = 0
M.IS_PVPOL_RANK = 0
M.IS_BABEL_GRAB = 0
M.BABEL_ENEMY_INFO = {}
M.AWAKE_LEARN_PROMPT = 1
M.RELICS_LIST = {}
M.ENEMY_RELICS_LIST = {}
M.EQUIP_LIST = {}

function M.generateEquipmentData(ueid, data)
  local data1 = data or {}
  local data2 = DataUtils.getEquipmentModel(data1.equipmentId)
  data2.ueid = ueid
  data2.level = data1.level
  data2.star = #data1.starProps
  data2.leftExp = data1.ironOverflow
  data2.buddhaId = data1.buddhaId
  data2.potential = data1.potential
  data2.shenbing = data1.shenbing
  data2.isQuenching = data1.quenching
  for i = 1, #data2.growNums do
    data2.growNums[i] = data2.growNums[i] * (1 + data1.quenchingRate / 100)
  end
  if data2.isQuenching then
    data2.name = "\231\129\181\194\183" .. data2.name
    data2.quality = 7
  end
  if data2.shenbing then
    data2.quality = 8
  end
  data2.mainPropertyIds = {}
  data2.mainPropertyNums = {}
  for i = 1, #data1.baseProps do
    local baseData = data1.baseProps[i]
    table.insert(data2.mainPropertyIds, tonumber(baseData.type))
    table.insert(data2.mainPropertyNums, tonumber(baseData.value))
  end
  data2.randomPropertyIds = {}
  data2.randomPropertyNums = {}
  for i = 1, #data1.bornProps do
    local bornData = data1.bornProps[i]
    table.insert(data2.randomPropertyIds, tonumber(bornData.type))
    table.insert(data2.randomPropertyNums, tonumber(bornData.value))
  end
  data2.starPropertyIds = {}
  data2.starPropertyNums = {}
  data2.starPropertyQuas = {}
  for i = 1, #data1.starProps do
    local starData = data1.starProps[i]
    table.insert(data2.starPropertyIds, tonumber(starData.type))
    table.insert(data2.starPropertyNums, tonumber(starData.value))
    table.insert(data2.starPropertyQuas, tonumber(starData.quality))
  end
  data2.quenchingPropertyIds = {}
  data2.quenchingPropertyNums = {}
  for i = 1, #data1.quenchingProps do
    local quenchingData = data1.quenchingProps[i]
    table.insert(data2.quenchingPropertyIds, tonumber(quenchingData.type))
    table.insert(data2.quenchingPropertyNums, tonumber(quenchingData.value))
  end
  return data2
end

return M

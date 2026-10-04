Protocol = {}

-- 心跳包
Protocol.REQUEST_KEEPLIVE                   = 0x00010000

-- 请求登录
Protocol.REQUEST_LOGIN                      = 0x00010001
Protocol.RESPONSE_LOGIN_SUCCESS             = 0x00010002
Protocol.RESPONSE_LOGIN_FAILED              = 0x00010003

-- 获取pvp列表[进入大厅]
Protocol.REQUEST_PVP_LIST                   = 0x00020001
Protocol.RESPONSE_PVP_LIST_SUCCESS          = 0x00020002
Protocol.RESPONSE_PVP_LIST_FAILED           = 0x00020003

-- 请求撮合[服务器推送]
Protocol.REQUEST_FIGHT_MATCH                = 0x00020004
Protocol.RESPONSE_FIGHT_MATCH_SUCCESS       = 0x00020005
Protocol.RESPONSE_FIGHT_MATCH_FAILED        = 0x00020006

-- 请求战斗已准备
Protocol.REQUEST_FIGHT_READY                = 0x00020007
Protocol.RESPONSE_FIGHT_READY_SUCCESS       = 0x00020008
Protocol.RESPONSE_FIGHT_READY_FAILED        = 0x00020009

-- 战斗开始
Protocol.REQUEST_FIGHT_START                = 0x0002000A
Protocol.RESPONSE_FIGHT_START_SUCCESS       = 0x0002000B
Protocol.RESPONSE_FIGHT_START_FAILED        = 0x0002000C

-- 出兵
Protocol.REQUEST_TRAIN                      = 0x0002000D
Protocol.RESPONSE_TRAIN_SUCCESS             = 0x0002000E
Protocol.RESPONSE_TRAIN_FAILED              = 0x0002000F

-- 请求发送战斗结果[本地]
Protocol.REQUEST_SEND_FIGHT_RESULT          = 0x00020011
Protocol.RESPONSE_SEND_FIGHT_RESULT_SUCCESS = 0x00020012
Protocol.RESPONSE_SEND_FIGHT_RESULT_FAILED  = 0x00020013

-- 战斗结果 [服务器推送]
Protocol.REQUEST_FIGHT_RESULT               = 0x00020014
Protocol.RESPONSE_FIGHT_RESULT_SUCCESS      = 0x00020015
Protocol.RESPONSE_FIGHT_RESULT_FAILED       = 0x00020016





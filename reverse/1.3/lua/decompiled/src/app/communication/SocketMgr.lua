local DYClass = "SocketMgr"
local M = class(DYClass)
local SocketTCP = require("framework.cc.net.init").SocketTCP
local ErrorCodeLayer = require("app.layers.ErrorCodeLayer")
local zlib = require("zlib")
local funcCompress = zlib.deflate()
local funcDecompress = zlib.inflate()

function M:defineCommands()
  self.__params = {}
  self.__commands = {
    CMD_LOGIN = function(reqCode, respCode)
      return handler(self, self.login)
    end,
    CMD_READY = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CANCEL_READY = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_FIGHT = function(reqCode, respCode)
      return nil
    end,
    CMD_FIGHT_READY = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_UPDATE_TICK = function(reqCode, respCode)
      return nil
    end,
    CMD_COMMIT_RESULT = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_FIGHT_RESULT = function(reqCode, respCode)
      return nil
    end,
    CMD_GIVE_UP = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_COMMIT_BUDDHA = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_COMMIT_CIMELIA = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_COMMIT_RELICS = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_COMMIT_CHAT = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_UPGRADE_SPIRIT = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_RETRANS_MISSION = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CACHE_MSG_LIST = function(reqCode, respCode)
      return nil
    end,
    CMD_UPDATE_TEAM = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_REQUEST_LOST = function(reqCode, respCode)
      return handler(self, self.requestLostMsg)
    end,
    CMD_KEEP_ALIVE = function(reqCode, respCode)
      return handler(self, self.startKeepAlive)
    end,
    CMD_RECONNECT = function(reqCode, respCode)
      return handler(self, self.login)
    end,
    CMD_KICKED_OFF = function(reqCode, respCode)
      return nil
    end,
    CMD_PVP_INIT_DATA = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_RESET_DATA = function(reqCode, respCode)
      return nil
    end,
    CMD_MATCH_STATUS = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_COMPETE_STATUS = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_ENTER_COMPETE = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_LEAVE_COMPETE = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_REFRESH_COMPETE_DATA = function(reqCode, respCode)
      return nil
    end,
    CMD_COMPETE_ALERT = function(reqCode, respCode)
      return nil
    end,
    CMD_AUTO_ADVANCED = function(reqCode, respCode)
      return nil
    end,
    CMD_SEND_CHAT_WORLD = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_SEND_CHAT_GOSSIP = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_GET_FRIEND_LIST = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_GET_FRIEND_APPLY_LIST = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_FRIEND_RECOMMEND = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_FRIEND_PK_APPLY = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_FRIEND_PK_CANCEL = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_FRIEND_PK_RECEIVE = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_FRIEND_PK_REFUSE = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_FRIEND_PK_CALL = function(reqCode, respCode)
      return nil
    end,
    CMD_STATUS_CHECK = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID,
        userStatus = GameManager.IS_USER_BUSY
      })
    end,
    CMD_FRIEND_TO_ADD = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_FRIEND_ADD_AGREE = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_FRIEND_DELETE = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_FRIEND_ADD_REFUSE = function(reqCode, respCode)
      return self:genCommandFunc(reqCode, {
        uid = CloudData.UID
      })
    end,
    CMD_UNION_LIST = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_UNION_ID = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CREATE_UNION = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_APPLY_UNION = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_APPLY_CANCEL = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_APPLY_ONEKEY = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_UNION_INFO = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CONSTRUCT = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_DEAL_APPLY = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_MODIFY_NOTICE = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_EXPEL_MEMBER = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_APPOINT_MEMBER = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_ABDICATE_LEADER = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_RESIGN_MANAGER = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CONSTRUCT_REWARD = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_QUIT_UNION = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_DISBAND_UNION = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CLAN_SHOP_DATA = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_BUY_CLAN_SHOP = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_USE_CLAN_GIFT = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CLAN_BOSS_GET_DATA = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_FEED_CLAN_BOSS = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_OPEN_CLAN_BOSS = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_RESET_CLAN_BOSS = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_TRAIN_CLAN_BOSS = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_ACTIVATE_CLAN_BOSS = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_GET_CLAN_COMPETE_DATA = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_GET_CUR_COMPETE_DATA = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CLAN_COMPETE_SIGN_UP = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_SET_CLAN_COMPETE_TEAM = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_RECOVER_IMMEDIATLY = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CLAN_COMPETE_FIGHT_READY = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CLAN_COMPETE_CANCLE_READY = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CLAN_COMPETE_FIGHT = function(reqCode, respCode)
      return nil
    end,
    CMD_CLAN_COMPETE_FIGHT_RESULT = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CLAN_COMPETE_BOSS_FIGHT = function(reqCode, respCode)
      return nil
    end,
    CMD_CLAN_COMPETE_BOSS_FIGHT_RESULT = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_LEAVE_COMPETE_WAIT_PANEL = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CLAN_COMPETE_BOSS_SYNC = function(reqCode, respCode)
      return nil
    end,
    CMD_CLAN_LOG_LIST = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_LEAVE_LOG_PANEL = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_GET_CLAN_NEW_LOG = function(reqCode, respCode)
      return nil
    end,
    CMD_CLAN_RANK_ATTACK = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CLAN_RANK_GUARD = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CLAN_ALLOCATE_BOX = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CLAN_COMPETE_RECORD_FIGHT_DATA = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_CHAT_MSG_LIST = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_SEND_CHAT_MSG = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_GET_CHAT_MSG = function(reqCode, respCode)
      return nil
    end,
    CMD_GET_FRIEND_MSG = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_SEND_FRIEND_MSG = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_REQ_OFFLINE_MSG = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_GET_OFFLINE_MSG = function(reqCode, respCode)
      return nil
    end,
    CMD_SEEK_PLAYER = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_SEEK_PLAYERS = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end,
    CMD_BUG_TEST = function(reqCode, respCode)
      return self:genCommandFunc(reqCode)
    end
  }
end

function M:loadCommands()
  local null
  self:loadCommand("CMD_LOGIN", 1001, 1002)
  self:loadCommand("CMD_READY", 1003, null)
  self:loadCommand("CMD_CANCEL_READY", 1004, 1018)
  self:loadCommand("CMD_FIGHT", null, 1005)
  self:loadCommand("CMD_FIGHT_READY", 1006, null)
  self:loadCommand("CMD_UPDATE_TICK", null, 1007)
  self:loadCommand("CMD_COMMIT_RESULT", 1008, null)
  self:loadCommand("CMD_FIGHT_RESULT", null, 1009)
  self:loadCommand("CMD_GIVE_UP", 1010, null)
  self:loadCommand("CMD_COMMIT_BUDDHA", 1011, null)
  self:loadCommand("CMD_COMMIT_CIMELIA", 1012, null)
  self:loadCommand("CMD_COMMIT_RELICS", 1038, null)
  self:loadCommand("CMD_COMMIT_CHAT", 1013, null)
  self:loadCommand("CMD_UPGRADE_SPIRIT", 1014, null)
  self:loadCommand("CMD_RETRANS_MISSION", 1015, null)
  self:loadCommand("CMD_CACHE_MSG_LIST", null, 1016)
  self:loadCommand("CMD_UPDATE_TEAM", 1017, null)
  self:loadCommand("CMD_REQUEST_LOST", 1019, null)
  self:loadCommand("CMD_KEEP_ALIVE", 1020, null)
  self:loadCommand("CMD_RECONNECT", 1021, null)
  self:loadCommand("CMD_KICKED_OFF", null, 1022)
  self:loadCommand("CMD_PVP_INIT_DATA", 1023, 1023)
  self:loadCommand("CMD_RESET_DATA", null, 1024)
  self:loadCommand("CMD_MATCH_STATUS", 1025, 1026)
  self:loadCommand("CMD_COMPETE_STATUS", 1030, 1031)
  self:loadCommand("CMD_ENTER_COMPETE", 1032, null)
  self:loadCommand("CMD_LEAVE_COMPETE", 1033, null)
  self:loadCommand("CMD_REFRESH_COMPETE_DATA", null, 1034)
  self:loadCommand("CMD_COMPETE_ALERT", null, 1035)
  self:loadCommand("CMD_AUTO_ADVANCED", null, 1036)
  self:loadCommand("CMD_SEND_CHAT_WORLD", 2001, 2001)
  self:loadCommand("CMD_SEND_CHAT_GOSSIP", 2002, 2002)
  self:loadCommand("CMD_GET_FRIEND_LIST", 2010, 2010)
  self:loadCommand("CMD_GET_FRIEND_APPLY_LIST", 2011, 2011)
  self:loadCommand("CMD_FRIEND_RECOMMEND", 2012, 2012)
  self:loadCommand("CMD_FRIEND_PK_APPLY", 2013, 2013)
  self:loadCommand("CMD_FRIEND_PK_CANCEL", 2014, 2014)
  self:loadCommand("CMD_FRIEND_PK_RECEIVE", 2015, 2015)
  self:loadCommand("CMD_FRIEND_PK_REFUSE", 2016, 2016)
  self:loadCommand("CMD_FRIEND_PK_CALL", null, 2017)
  self:loadCommand("CMD_STATUS_CHECK", 2018, 2018)
  self:loadCommand("CMD_FRIEND_TO_ADD", 2019, 2019)
  self:loadCommand("CMD_FRIEND_ADD_AGREE", 2020, 2020)
  self:loadCommand("CMD_FRIEND_DELETE", 2021, 2021)
  self:loadCommand("CMD_FRIEND_ADD_REFUSE", 2022, 2022)
  self:loadCommand("CMD_UNION_LIST", 1078, 1079)
  self:loadCommand("CMD_UNION_ID", 1080, 1081)
  self:loadCommand("CMD_CREATE_UNION", 1052, 1053)
  self:loadCommand("CMD_APPLY_UNION", 1054, 1055)
  self:loadCommand("CMD_APPLY_CANCEL", 1056, 1057)
  self:loadCommand("CMD_APPLY_ONEKEY", 1058, 1059)
  self:loadCommand("CMD_UNION_INFO", 1050, 1051)
  self:loadCommand("CMD_CONSTRUCT", 1060, 1061)
  self:loadCommand("CMD_DEAL_APPLY", 1062, 1063)
  self:loadCommand("CMD_MODIFY_NOTICE", 1064, 1065)
  self:loadCommand("CMD_EXPEL_MEMBER", 1066, 1067)
  self:loadCommand("CMD_APPOINT_MEMBER", 1068, 1069)
  self:loadCommand("CMD_ABDICATE_LEADER", 1070, 1071)
  self:loadCommand("CMD_RESIGN_MANAGER", 1072, 1073)
  self:loadCommand("CMD_CONSTRUCT_REWARD", 1074, 1075)
  self:loadCommand("CMD_QUIT_UNION", 1076, 1077)
  self:loadCommand("CMD_DISBAND_UNION", 1082, 1083)
  self:loadCommand("CMD_CLAN_SHOP_DATA", 1084, 1085)
  self:loadCommand("CMD_BUY_CLAN_SHOP", 1086, 1087)
  self:loadCommand("CMD_USE_CLAN_GIFT", 1088, 1089)
  self:loadCommand("CMD_CLAN_BOSS_GET_DATA", 1100, 1101)
  self:loadCommand("CMD_FEED_CLAN_BOSS", 1102, 1103)
  self:loadCommand("CMD_OPEN_CLAN_BOSS", 1104, 1105)
  self:loadCommand("CMD_RESET_CLAN_BOSS", 1106, 1107)
  self:loadCommand("CMD_TRAIN_CLAN_BOSS", 1108, 1109)
  self:loadCommand("CMD_ACTIVATE_CLAN_BOSS", 1110, 1111)
  self:loadCommand("CMD_GET_CLAN_COMPETE_DATA", 1200, 1201)
  self:loadCommand("CMD_GET_CUR_COMPETE_DATA", 1202, 1203)
  self:loadCommand("CMD_CLAN_COMPETE_SIGN_UP", 1204, 1205)
  self:loadCommand("CMD_SET_CLAN_COMPETE_TEAM", 1206, 1207)
  self:loadCommand("CMD_RECOVER_IMMEDIATLY", 1208, 1209)
  self:loadCommand("CMD_CLAN_COMPETE_FIGHT_READY", 1210, 1211)
  self:loadCommand("CMD_CLAN_COMPETE_CANCLE_READY", 1212, 1213)
  self:loadCommand("CMD_CLAN_COMPETE_FIGHT", null, 1215)
  self:loadCommand("CMD_CLAN_COMPETE_FIGHT_RESULT", 1216, 1219)
  self:loadCommand("CMD_CLAN_COMPETE_BOSS_FIGHT", null, 1217)
  self:loadCommand("CMD_CLAN_COMPETE_BOSS_FIGHT_RESULT", 1218, 1219)
  self:loadCommand("CMD_LEAVE_COMPETE_WAIT_PANEL", 1230, null)
  self:loadCommand("CMD_CLAN_COMPETE_BOSS_SYNC", null, 1231)
  self:loadCommand("CMD_CLAN_LOG_LIST", 1220, 1221)
  self:loadCommand("CMD_LEAVE_LOG_PANEL", 1222, null)
  self:loadCommand("CMD_GET_CLAN_NEW_LOG", null, 1223)
  self:loadCommand("CMD_CLAN_RANK_ATTACK", 1224, 1225)
  self:loadCommand("CMD_CLAN_RANK_GUARD", 1226, 1227)
  self:loadCommand("CMD_CLAN_ALLOCATE_BOX", 1228, 1229)
  self:loadCommand("CMD_CLAN_COMPETE_RECORD_FIGHT_DATA", 1232, null)
  self:loadCommand("CMD_CHAT_MSG_LIST", 2050, 2051)
  self:loadCommand("CMD_SEND_CHAT_MSG", 2052, null)
  self:loadCommand("CMD_GET_CHAT_MSG", null, 2053)
  self:loadCommand("CMD_SEND_FRIEND_MSG", 2054, null)
  self:loadCommand("CMD_GET_FRIEND_MSG", null, 2055)
  self:loadCommand("CMD_REQ_OFFLINE_MSG", 2056, null)
  self:loadCommand("CMD_GET_OFFLINE_MSG", null, 2057)
  self:loadCommand("CMD_SEEK_PLAYER", 2058, 2058)
  self:loadCommand("CMD_SEEK_PLAYERS", 2059, 2059)
  self:loadCommand("CMD_BUG_TEST", 1037, null)
end

function M:initEvents()
  self.__events = {}
  local tCommandEvents = {
    CMD_LOGIN = function(msg)
      self.mFlagLogin = true
    end,
    CMD_STATUS_CHECK = function(msg)
      self:checkStatus(msg)
    end,
    CMD_KICKED_OFF = function(msg)
      self:logout()
      local pLayer = ErrorCodeLayer.new(0, DYLang.getString("S196", ""))
      display.getRunningScene():addChild(pLayer, 600)
    end
  }
  
  local function bindCommandEvent(cmd)
    local respCode = self:listenCommon(cmd)
    self.__events[respCode] = tCommandEvents[cmd]
  end
  
  bindCommandEvent("CMD_LOGIN")
  bindCommandEvent("CMD_STATUS_CHECK")
  bindCommandEvent("CMD_KICKED_OFF")
end

function M:requestCommon(cmd, param)
  local tParam = self.__params[cmd]
  if not tParam then
    DDERROR("requestCommon ERROR, LOAD [%s] in [loadCommand] FIRST!!!", cmd)
    return
  end
  if tParam.func then
    tParam.func(param)
  end
  return tParam.resp
end

function M:listenCommon(cmd)
  local tParam = self.__params[cmd]
  if not tParam then
    DDERROR("listenCommon ERROR, LOAD [%s] in [loadCommand] FIRST!!!", cmd)
    return
  end
  return tParam.resp
end

local S_KEEP_ALIVE_SEC = 10
local S_MIN_RECONNECT_DELAY = 1
local S_MAX_RECONNECT_DELAY = 20
local HASH_KEY = "e3ee59bcba317d96"

function M:ctor(host, port)
  DDLOG(DYClass .. ": onCreate")
  self.mSocket = nil
  self.mBufferRecv = ""
  self.mBufferSend = ""
  self.mSeqIdC = 1
  self.mSeqIdS = 1
  self.mCachedMsg = {}
  self.mFuncKeepAlive = nil
  self.mFuncForceQuit = nil
  self.mFlagLogin = false
  self.mReconnectDelay = S_MIN_RECONNECT_DELAY
  self.mHost = host
  self.mPort = port
  self:initCommands()
end

function M:initCommands()
  self:defineCommands()
  self:loadCommands()
  self:initEvents()
end

function M:genCommandFunc(pid, paramEx)
  return function(param)
    param = param or {}
    param.mid = pid
    if paramEx then
      table.walk(paramEx, function(v, k)
        param[k] = v
      end)
    end
    self:onPreSend(param)
  end
end

function M:loadCommand(cmd, reqCode, respCode)
  local tFunc = self.__commands[cmd]
  if not tFunc then
    DDERROR("DEFINE [%s] IN [defineCommands] FIRST!!!", cmd)
    return
  end
  self.__params[cmd] = {
    cmd = cmd,
    req = reqCode,
    resp = respCode,
    func = tFunc(reqCode, respCode)
  }
end

function M:login(param)
  local host = self.mHost
  local port = self.mPort
  param = param or {}
  
  local function tFuncLogin()
    DDLOG("Will try login ... ")
    self.mBufferRecv = ""
    self.mBufferSend = ""
    if not self.mFlagLogin then
      param.mid = 1001
    else
      param.mid = 1021
    end
    param.uid = CloudData.UID
    param.token = CloudData.TOKEN or ""
    param.server_id = CloudData.USER_SERVER_ID
    self:onSendData(json.encode(param))
    self:startKeepAlive()
  end
  
  local function tFuncConnected()
    tFuncLogin()
    self.mReconnectDelay = S_MIN_RECONNECT_DELAY
    self.mSocket:setReconnTime(self.mReconnectDelay)
  end
  
  local function tFuncConnectFail()
    self.mReconnectDelay = self.mReconnectDelay * 2
    if self.mReconnectDelay > S_MAX_RECONNECT_DELAY then
      self.mReconnectDelay = S_MAX_RECONNECT_DELAY
    end
    self.mSocket:setReconnTime(self.mReconnectDelay)
    DDLOG("Network error detected, reset conn delay")
  end
  
  if self.mSocket == nil then
    local socket = SocketTCP.new()
    self.mSocket = socket
    socket:addEventListener(SocketTCP.EVENT_CONNECTED, tFuncConnected)
    socket:addEventListener(SocketTCP.EVENT_CLOSE, handler(self, self.onStatus))
    socket:addEventListener(SocketTCP.EVENT_CLOSED, handler(self, self.onStatus))
    socket:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, tFuncConnectFail)
    socket:addEventListener(SocketTCP.EVENT_DATA, handler(self, self.onRecvData))
    socket:connect(host, port, true)
  elseif not self.mSocket.isConnected then
    local socket = self.mSocket
    socket:addEventListener(SocketTCP.EVENT_CONNECTED, tFuncConnected)
    socket:connect(host, port, true)
  else
    tFuncLogin()
  end
end

function M:startKeepAlive()
  if self.mFuncKeepAlive then
    return
  end
  
  local function tFuncKeepAlive()
    local tp = {}
    tp.mid = 1020
    tp.max_sid = self.mSeqIdC
    self:onSendData(json.encode(tp))
  end
  
  self.mFuncKeepAlive = DYUtils.schedule(tFuncKeepAlive, S_KEEP_ALIVE_SEC, -1)
end

function M:isConnected()
  return self.mSocket.isConnected
end

function M:logout()
  if not self.mSocket then
    return
  end
  self.mSocket:close()
  self.mSocket:disconnect()
  self.mSocket:removeAllEventListeners()
  self.mSocket = nil
  self.mSeqIdC = 1
  self.mSeqIdS = 1
  self.mCachedMsg = {}
  if self.mFuncKeepAlive then
    DYUtils.unschedule(self.mFuncKeepAlive)
    self.mFuncKeepAlive = nil
  end
  if self.mFuncForceQuit then
    DYUtils.unschedule(self.mFuncForceQuit)
    self.mFuncForceQuit = nil
  end
  self.mBufferRecv = ""
  self.mBufferSend = ""
end

function M:checkStatus(param)
  param = param or {}
  param.sender = param.sender
  param.receiver = param.receiver
  param.nick = param.nick
  param.userStatus = GameManager.IS_USER_BUSY
  param.uid = CloudData.UID
  param.mid = 2018
  self:onPreSend(param)
end

function M:onStatus(event)
end

function M:onRecvData(event)
  if type(event) ~= "table" or type(event.data) ~= "string" then
    DDERROR("EVENT is not table!!!")
    return
  end
  local data = event.data
  self.mBufferRecv = self.mBufferRecv .. data
  local pos = string.find(self.mBufferRecv, "}{")
  local flag = false
  if pos and 0 < pos then
    local strLen = #self.mBufferRecv
    local strMsg = string.sub(self.mBufferRecv, 0, pos)
    flag = self:onPreRecv(strMsg)
    if flag then
      self.mBufferRecv = string.sub(self.mBufferRecv, pos + 1, strLen)
    end
  elseif 0 < string.len(self.mBufferRecv) then
    local strMsg = self.mBufferRecv
    flag = self:onPreRecv(strMsg)
    if flag then
      self.mBufferRecv = ""
    end
  end
  if flag and 0 < string.len(self.mBufferRecv) then
    DYUtils.schedule(function()
      self:onRecvData({data = ""})
    end, 0, 1)
  end
end

function M:onSendData(data)
  if data and string.len(data) > 0 then
    local strBase = crypto.encodeBase64(data)
    local strHash = crypto.md5(string.format("%s%s", strBase, HASH_KEY))
    data = string.format("{%s%s}", strBase, strHash)
  end
  self.mBufferSend = self.mBufferSend .. data
  if self.mSocket and self.mSocket.isConnected and 0 < string.len(self.mBufferSend) then
    local lenTotal = string.len(self.mBufferSend)
    local lenSend = self.mSocket:send(self.mBufferSend) or 0
    self.mBufferSend = string.sub(self.mBufferSend, lenSend + 1, lenTotal)
  end
  if 0 < string.len(self.mBufferSend) then
    DDLOG("ON_SEND_DATA Cached: " .. self.mBufferSend)
    DYUtils.schedule(function()
      self:onSendData("")
    end, 1, 1)
  end
end

function M:onProcess(msg)
  if not msg or not msg.mid then
    return
  end
  local funcProto = self.__events[checknumber(msg.mid)]
  if funcProto then
    funcProto(msg)
  end
  local kProto = string.format(DY_KEY.kSocketProto, checkstring(msg.mid))
  DYNotification.post(kProto, msg)
end

function M:resetData(sidClient, sidServer)
  self.mSeqIdC = sidClient
  self.mSeqIdS = sidServer
  self.mCachedMsg = {}
end

function M:onPreSend(param)
  param.sid = self:genClientSeqId()
  table.insert(self.mCachedMsg, clone(param))
  self:onSendData(json.encode(param))
end

function M:onPreRecv(param)
  if not param or string.sub(param, string.len(param), -1) ~= "}" then
    return false
  end
  local lenParam = string.len(param)
  local strHash = string.sub(param, lenParam - 32, lenParam - 1)
  local strData = string.sub(param, 2, lenParam - 32 - 1)
  local strHashMe = crypto.md5(string.format("%s%s", strData, HASH_KEY))
  if strHashMe ~= strHash then
    DDERROR("Check hash failed, data:" .. strData .. ", hash:" .. strHash .. ", hashMe:" .. strHashMe)
    return true
  end
  strData = crypto.decodeBase64(strData)
  local msg = json.decode(strData)
  if not msg or not msg.mid then
    DDERROR("Ignore invalid message, " .. strData)
    return true
  end
  if msg.mid == 1019 then
    self:resendCachedMsg(msg.max_sid)
    return true
  end
  if msg.mid == 1020 then
    if msg.max_sid and msg.max_sid > self.mSeqIdS then
      DDLOG("Detect lost msg by KEEP_ALIVE: %s,", strData)
      self:requestLostMsg(self.mSeqIdS)
    end
    return true
  end
  if msg.mid == 1024 then
    DDLOG("Detect RESET_DATA: %s,", strData)
    self:resetData(msg.recv_sid, msg.send_sid)
    return true
  end
  if msg.mid == 1022 then
    self:logout()
    local pLayer = ErrorCodeLayer.new(0, DYLang.getString("S196", ""))
    display.getRunningScene():addChild(pLayer, 600)
    return true
  end
  if msg.sid == self.mSeqIdS then
    self.mSeqIdS = self.mSeqIdS + 1
    self:onProcess(msg)
  elseif msg.sid > self.mSeqIdS then
    DDLOG("Request lost msg for: %s,", strData)
    self:requestLostMsg(self.mSeqIdS)
  else
    DDLOG("Ignore old message: %s, should already processed", strData)
  end
  return true
end

function M:requestLostMsg(maxSid)
  local tp = {}
  tp.mid = 1019
  tp.max_sid = self.mSeqIdS
  local msg = json.encode(tp)
  self:onSendData(msg)
  DDLOG("requestLostMsg: " .. msg)
end

function M:resendCachedMsg(maxSid)
  for i = 1, #self.mCachedMsg do
    local msg = self.mCachedMsg[i]
    if maxSid <= msg.sid then
      local strCached = json.encode(msg)
      self:onSendData(strCached)
      DDLOG("resendCachedMsg: " .. strCached)
    end
  end
end

function M:genClientSeqId()
  local sid = self.mSeqIdC
  self.mSeqIdC = self.mSeqIdC + 1
  return sid
end

return M

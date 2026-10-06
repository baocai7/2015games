local DYClass = "SocketAIMgr"
local M = class(DYClass)
local SocketTCP = require("framework.cc.net.init").SocketTCP
local ErrorCodeLayer = require("app.layers.ErrorCodeLayer")
local zlib = require("zlib")
local funcCompress = zlib.deflate()
local funcDecompress = zlib.inflate()
M.EVENT_LOGIN_OK = "EVENT_LOGIN_OK"
M.EVENT_FIGHT = "EVENT_FIGHT"
M.EVENT_CREATE_BUDDHA = "EVENT_CREATE_BUDDHA"
M.EVENT_CREATE_MONSTER = "EVENT_CREATE_MONSTER"
M.EVENT_CIMELIA_BUDDHA = "EVENT_CIMELIA_BUDDHA"
M.EVENT_CIMELIA_MONSTER = "EVENT_CIMELIA_MONSTER"
M.EVENT_CHAT = "EVENT_CHAT"
M.EVENT_UPDATE_TICK = "EVENT_UPDATE_TICK"
M.EVENT_FIGHT_RESULT = "EVENT_FIGHT_RESULT"
M.EVENT_CACHE_MSG_LIST = "EVENT_CACHE_MSG_LIST"
M.EVENT_CANCEL_READY_OK = "EVENT_CANCEL_READY_OK"
M.EVENT_GET_MATCH_STATUS = "EVENT_GET_MATCH_STATUS"
M.EVENT_CACHE_CHAT_MSG = "EVENT_CACHE_CHAT_MSG"
M.EVENT_GET_FRIEND_LIST = "EVENT_GET_FRIEND_LIST"
M.EVENT_GET_FRIEND_APPLY_LIST = "EVENT_GET_FRIEND_APPLY_LIST"
M.EVENT_GET_FRIEND_RECOMMENDS = "EVENT_GET_FRIEND_RECOMMENDS"
M.EVENT_FRIEND_PK_APPLY = "EVENT_FRIEND_PK_APPLY"
M.EVENT_CANCEL_PK_APPLY = "EVENT_CANCEL_PK_APPLY"
M.EVENT_CANCEL_PK_RECEIVE = "EVENT_CANCEL_PK_RECEIVE"
M.EVENT_CANCEL_PK_REFUSE = "EVENT_CANCEL_PK_REFUSE"
M.EVENT_FRIEND_PK_CALL = "EVENT_FRIEND_PK_CALL"
M.EVENT_STATUS_CHECK = "EVENT_STATUS_CHECK"
M.EVENT_FRIEND_TO_ADD = "EVENT_FRIEND_TO_ADD"
M.EVENT_FRIEND_ADD_AGREE = "EVENT_FRIEND_ADD_AGREE"
M.EVENT_FRIEND_ADD_REFUSE = "EVENT_FRIEND_ADD_REFUSE"
M.EVENT_FRIEND_DELETE = "EVENT_FRIEND_DELETE"
M.EVENT_PVP_INIT_DATA = "EVENT_PVP_INIT_DATA"
M.EVENT_GET_COMPETE_STATUS = "EVENT_GET_COMPETE_STATUS"
M.EVENT_REFRESH_COMPETE_DATA = "EVENT_REFRESH_COMPETE_DATA"
M.EVENT_COMPETE_ALERT = "EVENT_COMPETE_ALERT"
M.EVENT_AUTO_ADVANCED = "EVENT_AUTO_ADVANCED"
M.EVENT_CLAN_BOSS_GET_DATA_RES = "EVENT_CLAN_BOSS_GET_DATA_RES"
M.EVENT_FEED_CLAN_BOSS_RES = "EVENT_FEED_CLAN_BOSS_RES"
M.EVENT_OPEN_CLAN_BOSS_RES = "EVENT_OPEN_CLAN_BOSS_RES"
M.EVENT_RESET_CLAN_BOSS_RES = "EVENT_RESET_CLAN_BOSS_RES"
M.EVENT_TRAIN_CLAN_BOSS_RES = "EVENT_TRAIN_CLAN_BOSS_RES"
M.EVENT_ACTIVATE_CLAN_BOSS_RES = "EVENT_ACTIVATE_CLAN_BOSS_RES"
M.EVENT_GET_UNION_LIST = "EVENT_GET_UNION_LIST"
M.EVENT_GET_UNION_ID = "EVENT_GET_UNION_ID"
M.EVENT_GET_CREATE_UNION = "EVENT_GET_CREATE_UNION"
M.EVENT_GET_APPLY_UNION = "EVENT_GET_APPLY_UNION"
M.EVENT_GET_APPLY_CANCEL = "EVENT_GET_APPLY_CANCEL"
M.EVENT_GET_APPLY_ONEKEY = "EVENT_GET_APPLY_ONEKEY"
M.EVENT_GET_UNION_INFO = "EVENT_GET_UNION_INFO"
M.EVENT_GET_DEAL_APPLY = "EVENT_GET_DEAL_APPLY"
M.EVENT_GET_EXPEL_MEMBER = "EVENT_GET_EXPEL_MEMBER"
M.EVENT_GET_QUIT_UNION = "EVENT_GET_QUIT_UNION"
M.EVENT_GET_APPOINT_MEMBER = "EVENT_GET_APPOINT_MEMBER"
M.EVENT_GET_ABDICATE_LEADER = "EVENT_GET_ABDICATE_LEADER"
M.EVENT_GET_RESIGN_MANAGER = "EVENT_GET_RESIGN_MANAGER"
M.EVENT_GET_MODIFY_NOTICE = "EVENT_GET_MODIFY_NOTICE"
M.EVENT_GET_DISBAND_UNION = "EVENT_GET_DISBAND_UNION"
M.EVENT_GET_CONSTRUCT = "EVENT_GET_CONSTRUCT"
M.EVENT_GET_CONSTRUCT_REWARD = "EVENT_GET_CONSTRUCT_REWARD"
M.EVENT_GET_CLAN_SHOP_DATA_RES = "EVENT_GET_CLAN_SHOP_DATA_RES"
M.EVENT_BUY_CLAN_SHOP_RES = "EVENT_BUY_CLAN_SHOP_RES"
M.EVENT_GET_USE_CLAN_GIFT = "EVENT_GET_USE_CLAN_GIFT"
M.EVENT_GET_CHAT_MSG_LIST = "EVENT_GET_CHAT_MSG_LIST"
M.EVENT_GET_CHAT_MSG = "EVENT_GET_CHAT_MSG"
local S_KEEP_ALIVE_SEC = 10
local S_MIN_RECONNECT_DELAY = 1
local S_MAX_RECONNECT_DELAY = 20
local HASH_KEY = "e3ee59bcba317d96"

function M:ctor(host, port)
  DDLOG(DYClass .. ": onCreate")
  cc(self):addComponent("framework.cc.components.behavior.EventProtocol"):exportMethods()
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
  self:initEventListen()
end

function M:initEventListen()
  self.mEventList = {
    [Proto.PID_LOGIN_OK] = function(msg)
      self.mFlagLogin = true
      self:dispatchEvent({
        name = M.EVENT_LOGIN_OK,
        param = msg
      })
    end,
    [Proto.PID_FIGHT] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_FIGHT,
        param = msg
      })
    end,
    [Proto.PID_CANCEL_READY_OK] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_CANCEL_READY_OK,
        param = msg
      })
    end,
    [Proto.PID_UPDATE_TICK] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_UPDATE_TICK,
        param = msg
      })
    end,
    [Proto.PID_FIGHT_RESULT] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_FIGHT_RESULT,
        param = msg
      })
    end,
    [Proto.PID_GET_MATCH_STATUS] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_MATCH_STATUS,
        param = msg
      })
    end,
    [Proto.PID_CACHE_MSG_LIST] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_CACHE_MSG_LIST,
        param = msg
      })
    end,
    [Proto.PID_PVP_INIT_DATA] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_PVP_INIT_DATA,
        param = msg
      })
    end,
    [Proto.PID_SEND_CHAT_WORLD] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_CACHE_CHAT_MSG,
        param = msg
      })
    end,
    [Proto.PID_SEND_CHAT_GOSSIP] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_CACHE_CHAT_MSG,
        param = msg
      })
    end,
    [Proto.PID_GET_FRIEND_LIST] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_FRIEND_LIST,
        param = msg
      })
    end,
    [Proto.PID_GET_FRIEND_APPLY_LIST] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_FRIEND_APPLY_LIST,
        param = msg
      })
    end,
    [Proto.PID_FRIEND_RECOMMEND] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_FRIEND_RECOMMENDS,
        param = msg
      })
    end,
    [Proto.PID_FRIEND_PK_APPLY] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_FRIEND_PK_APPLY,
        param = msg
      })
    end,
    [Proto.PID_FRIEND_PK_CANCEL] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_CANCEL_PK_APPLY,
        param = msg
      })
    end,
    [Proto.PID_FRIEND_PK_RECEIVE] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_CANCEL_PK_RECEIVE,
        param = msg
      })
    end,
    [Proto.PID_FRIEND_PK_REFUSE] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_CANCEL_PK_REFUSE,
        param = msg
      })
    end,
    [Proto.PID_FRIEND_PK_CALL] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_FRIEND_PK_CALL,
        param = msg
      })
    end,
    [Proto.PID_STATUS_CHECK] = function(msg)
      self:checkStatus(msg)
    end,
    [Proto.PID_FRIEND_TO_ADD] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_FRIEND_TO_ADD,
        param = msg
      })
    end,
    [Proto.PID_FRIEND_ADD_AGREE] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_FRIEND_ADD_AGREE,
        param = msg
      })
    end,
    [Proto.PID_FRIEND_ADD_REFUSE] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_FRIEND_ADD_REFUSE,
        param = msg
      })
    end,
    [Proto.PID_FRIEND_DELETE] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_FRIEND_DELETE,
        param = msg
      })
    end,
    [Proto.PID_KICKED_OFF] = function(msg)
      self:logout()
      local pLayer = ErrorCodeLayer.new(0, DYLang.getString("S196", ""))
      display.getRunningScene():addChild(pLayer, 600)
      return
    end,
    [Proto.PID_GET_COMPETE_STATUS] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_COMPETE_STATUS,
        param = msg
      })
    end,
    [Proto.PID_REFRESH_COMPETE_DATA] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_REFRESH_COMPETE_DATA,
        param = msg
      })
    end,
    [Proto.PID_COMPETE_ALERT] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_COMPETE_ALERT,
        param = msg
      })
    end,
    [Proto.PID_AUTO_ADVANCED] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_AUTO_ADVANCED,
        param = msg
      })
    end,
    [Proto.PID_CLAN_BOSS_GET_DATA_RES] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_CLAN_BOSS_GET_DATA_RES,
        param = msg
      })
    end,
    [Proto.PID_FEED_CLAN_BOSS_RES] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_FEED_CLAN_BOSS_RES,
        param = msg
      })
    end,
    [Proto.PID_OPEN_CLAN_BOSS_RES] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_OPEN_CLAN_BOSS_RES,
        param = msg
      })
    end,
    [Proto.PID_TRAIN_CLAN_BOSS_RES] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_TRAIN_CLAN_BOSS_RES,
        param = msg
      })
    end,
    [Proto.PID_ACTIVATE_CLAN_BOSS_RES] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_ACTIVATE_CLAN_BOSS_RES,
        param = msg
      })
    end,
    [Proto.PID_RESET_CLAN_BOSS_RES] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_RESET_CLAN_BOSS_RES,
        param = msg
      })
    end,
    [Proto.PID_GET_UNION_LIST] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_UNION_LIST,
        param = msg
      })
    end,
    [Proto.PID_GET_UNION_ID] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_UNION_ID,
        param = msg
      })
    end,
    [Proto.PID_GET_CREATE_UNION] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_CREATE_UNION,
        param = msg
      })
    end,
    [Proto.PID_GET_APPLY_UNION] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_APPLY_UNION,
        param = msg
      })
    end,
    [Proto.PID_GET_APPLY_CANCEL] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_APPLY_CANCEL,
        param = msg
      })
    end,
    [Proto.PID_GET_APPLY_ONEKEY] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_APPLY_ONEKEY,
        param = msg
      })
    end,
    [Proto.PID_GET_UNION_INFO] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_UNION_INFO,
        param = msg
      })
    end,
    [Proto.PID_GET_DEAL_APPLY] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_DEAL_APPLY,
        param = msg
      })
    end,
    [Proto.PID_GET_EXPEL_MEMBER] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_EXPEL_MEMBER,
        param = msg
      })
    end,
    [Proto.PID_GET_QUIT_UNION] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_QUIT_UNION,
        param = msg
      })
    end,
    [Proto.PID_GET_APPOINT_MEMBER] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_APPOINT_MEMBER,
        param = msg
      })
    end,
    [Proto.PID_GET_ABDICATE_LEADER] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_ABDICATE_LEADER,
        param = msg
      })
    end,
    [Proto.PID_GET_RESIGN_MANAGER] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_RESIGN_MANAGER,
        param = msg
      })
    end,
    [Proto.PID_GET_MODIFY_NOTICE] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_MODIFY_NOTICE,
        param = msg
      })
    end,
    [Proto.PID_GET_DISBAND_UNION] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_DISBAND_UNION,
        param = msg
      })
    end,
    [Proto.PID_GET_CONSTRUCT] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_CONSTRUCT,
        param = msg
      })
    end,
    [Proto.PID_GET_CONSTRUCT_REWARD] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_CONSTRUCT_REWARD,
        param = msg
      })
    end,
    [Proto.PID_GET_CLAN_SHOP_DATA] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_CLAN_SHOP_DATA_RES,
        param = msg
      })
    end,
    [Proto.PID_GET_BUY_CLAN_SHOP] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_BUY_CLAN_SHOP_RES,
        param = msg
      })
    end,
    [Proto.PID_GET_USE_CLAN_GIFT] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_USE_CLAN_GIFT,
        param = msg
      })
    end,
    [Proto.PID_GET_CHAT_MSG_LIST] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_CHAT_MSG_LIST,
        param = msg
      })
    end,
    [Proto.PID_GET_CHAT_MSG] = function(msg)
      self:dispatchEvent({
        name = M.EVENT_GET_CHAT_MSG,
        param = msg
      })
    end
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
      param.mid = Proto.PID_LOGIN
    else
      param.mid = Proto.PID_RECONNECT
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
    tp.mid = Proto.PID_KEEP_ALIVE
    tp.max_sid = self.mSeqIdC
    self:onSendData(json.encode(tp))
  end
  
  self.mFuncKeepAlive = DYUtils.schedule(tFuncKeepAlive, S_KEEP_ALIVE_SEC, -1)
end

function M:ready(param)
  param = param or {}
  param.mid = Proto.PID_READY
  self:onPreSend(param)
end

function M:isConnected()
  return self.mSocket.isConnected
end

function M:commitUpdateTeam(param)
  param = param or {}
  param.mid = Proto.PID_UPDATE_TEAM
  self:onPreSend(param)
end

function M:commitFightReady()
  param = param or {}
  param.mid = Proto.PID_FIGHT_READY
  self:onPreSend(param)
end

function M:commitBuddha(param)
  param = param or {}
  param.mid = Proto.PID_COMMIT_BUDDHA
  self:onPreSend(param)
end

function M:commitCimelia(param)
  param = param or {}
  param.mid = Proto.PID_COMMIT_CIMELIA
  self:onPreSend(param)
end

function M:commitFightResult(param)
  param = param or {}
  param.mid = Proto.PID_COMMIT_RESULT
  self:onPreSend(param)
end

function M:commitReadyCancel(param)
  param = param or {}
  param.mid = Proto.PID_CANCEL_READY
  self:onPreSend(param)
end

function M:commitChat(param)
  param = param or {}
  param.mid = Proto.PID_COMMIT_CHAT
  self:onPreSend(param)
end

function M:commitGiveUp(param)
  param = param or {}
  param.mid = Proto.PID_GIVE_UP
  self:onPreSend(param)
end

function M:commitUpgradeSpirit(param)
  param = param or {}
  param.mid = Proto.PID_UPGRADE_SPIRIT
  self:onPreSend(param)
end

function M:commitRetransMission(param)
  param = param or {}
  param.mid = Proto.PID_RETRANS_MISSION
  self:onPreSend(param)
end

function M:initPvpData(param)
  param = param or {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_PVP_INIT_DATA
  self:onPreSend(param)
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

function M:sendChatMsgWorld(param)
  param = param or {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_SEND_CHAT_WORLD
  self:onPreSend(param)
end

function M:sendChatMsgGossip(param)
  param = param or {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_SEND_CHAT_GOSSIP
  self:onPreSend(param)
end

function M:getFriendList()
  param = {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_GET_FRIEND_LIST
  self:onPreSend(param)
end

function M:getFriendApplyList()
  param = {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_GET_FRIEND_APPLY_LIST
  self:onPreSend(param)
end

function M:getFriendRecommends()
  param = {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_FRIEND_RECOMMEND
  self:onPreSend(param)
end

function M:sendPkApply(param)
  param = param or {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_FRIEND_PK_APPLY
  self:onPreSend(param)
end

function M:cancelPkApply(param)
  param = param or {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_FRIEND_PK_CANCEL
  self:onPreSend(param)
end

function M:receivePkApply(param)
  param = param or {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_FRIEND_PK_RECEIVE
  self:onPreSend(param)
end

function M:refusePkApply(param)
  param = param or {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_FRIEND_PK_REFUSE
  self:onPreSend(param)
end

function M:checkStatus(param)
  param = param or {}
  param.sender = param.sender
  param.receiver = param.receiver
  param.nick = param.nick
  param.userStatus = GameManager.IS_USER_BUSY
  param.uid = CloudData.UID
  param.mid = Proto.PID_STATUS_CHECK
  self:onPreSend(param)
end

function M:toAddFriend(param)
  param = param or {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_FRIEND_TO_ADD
  self:onPreSend(param)
end

function M:addFriendAgree(param)
  param = param or {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_FRIEND_ADD_AGREE
  self:onPreSend(param)
end

function M:addFriendRefuse(param)
  param = param or {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_FRIEND_ADD_REFUSE
  self:onPreSend(param)
end

function M:deleteFriend(param)
  param = param or {}
  param.uid = CloudData.UID
  param.mid = Proto.PID_FRIEND_DELETE
  self:onPreSend(param)
end

function M:requestMatchStatus(param)
  param = param or {}
  param.mid = Proto.PID_REQ_MATCH_STATUS
  self:onPreSend(param)
end

function M:requestCompeteStatus(param)
  param = param or {}
  param.mid = Proto.PID_REQ_COMPETE_STATUS
  self:onPreSend(param)
end

function M:enterCompete(param)
  param = param or {}
  param.mid = Proto.PID_ENTER_COMPETE
  self:onPreSend(param)
end

function M:leaveCompete(param)
  param = param or {}
  param.mid = Proto.PID_LEAVE_COMPETE
  self:onPreSend(param)
end

function M:clanBossGetData(param)
  param = param or {}
  param.mid = Proto.PID_CLAN_BOSS_GET_DATA
  self:onPreSend(param)
end

function M:feedClanBoss(param)
  param = param or {}
  param.mid = Proto.PID_FEED_CLAN_BOSS
  self:onPreSend(param)
end

function M:openClanBoss(param)
  param = param or {}
  param.mid = Proto.PID_OPEN_CLAN_BOSS
  self:onPreSend(param)
end

function M:resetClanBoss(param)
  param = param or {}
  param.mid = Proto.PID_RESET_CLAN_BOSS
  self:onPreSend(param)
end

function M:trainClanBoss(param)
  param = param or {}
  param.mid = Proto.PID_TRAIN_CLAN_BOSS
  self:onPreSend(param)
end

function M:activateClanBoss(param)
  param = param or {}
  param.mid = Proto.PID_ACTIVATE_CLAN_BOSS
  self:onPreSend(param)
end

function M:requsetUnionList(param)
  param = param or {}
  param.mid = Proto.PID_REQ_UNION_LIST
  self:onPreSend(param)
end

function M:requestUnionId(param)
  param = param or {}
  param.mid = Proto.PID_REQ_UNION_ID
  self:onPreSend(param)
end

function M:requsetCreateUnion(param)
  param = param or {}
  param.mid = Proto.PID_REQ_CREATE_UNION
  self:onPreSend(param)
end

function M:requsetApplyUnion(param)
  param = param or {}
  param.mid = Proto.PID_REQ_APPLY_UNION
  self:onPreSend(param)
end

function M:requsetApplyCancel(param)
  param = param or {}
  param.mid = Proto.PID_REQ_APPLY_CANCEL
  self:onPreSend(param)
end

function M:requsetApplyOnekey(param)
  param = param or {}
  param.mid = Proto.PID_REQ_APPLY_ONEKEY
  self:onPreSend(param)
end

function M:requsetUnionInfo(param)
  param = param or {}
  param.mid = Proto.PID_REQ_UNION_INFO
  self:onPreSend(param)
end

function M:requsetDealApply(param)
  param = param or {}
  param.mid = Proto.PID_REQ_DEAL_APPLY
  self:onPreSend(param)
end

function M:requestExpelMember(param)
  param = param or {}
  param.mid = Proto.PID_REQ_EXPEL_MEMBER
  self:onPreSend(param)
end

function M:requestQuitUnion(param)
  param = param or {}
  param.mid = Proto.PID_REQ_QUIT_UNION
  self:onPreSend(param)
end

function M:requestAppointMember(param)
  param = param or {}
  param.mid = Proto.PID_REQ_APPOINT_MEMBER
  self:onPreSend(param)
end

function M:requestAbdicateLeader(param)
  param = param or {}
  param.mid = Proto.PID_REQ_ABDICATE_LEADER
  self:onPreSend(param)
end

function M:requestResignManager(param)
  param = param or {}
  param.mid = Proto.PID_REQ_RESIGN_MANAGER
  self:onPreSend(param)
end

function M:requestModifyNotice(param)
  param = param or {}
  param.mid = Proto.PID_REQ_MODIFY_NOTICE
  self:onPreSend(param)
end

function M:requestDisbandUnion(param)
  param = param or {}
  param.mid = Proto.PID_REQ_DISBAND_UNION
  self:onPreSend(param)
end

function M:requestUnionContribute(param)
  param = param or {}
  param.mid = Proto.PID_REQ_CONSTRUCT
  self:onPreSend(param)
end

function M:requestGetContributeReward(param)
  param = param or {}
  param.mid = Proto.PID_REQ_CONSTRUCT_REWARD
  self:onPreSend(param)
end

function M:requsetUnionShopInfo(param)
  param = param or {}
  param.mid = Proto.PID_REQ_CLAN_SHOP_DATA
  self:onPreSend(param)
end

function M:requsetBuyUnionShop(param)
  param = param or {}
  param.mid = Proto.PID_REQ_BUY_CLAN_SHOP
  self:onPreSend(param)
end

function M:requsetUseClanGift(param)
  param = param or {}
  param.mid = Proto.PID_REQ_USE_CLAN_GIFT
  self:onPreSend(param)
end

function M:requestChatMsgList(param)
  param = param or {}
  param.mid = Proto.PID_REQ_CHAT_MSG_LIST
  self:onPreSend(param)
end

function M:requestSendChatMsg(param)
  param = param or {}
  param.mid = Proto.PID_REQ_SEND_CHAT_MSG
  self:onPreSend(param)
end

function M:commitBugTest(param)
  param = param or {}
  param.mid = Proto.PID_BUG_TEST
  self:onPreSend(param)
end

function M:regOnceRequest(pid, pid_res, param, cb)
  param = param or {}
  param.mid = pid
  self:onPreSend(param)
  if pid_res ~= nil then
    local function tFunc(msg)
      self.mEventList[pid_res] = nil
      
      cb(msg)
    end
    
    self.mEventList[pid_res] = tFunc
  end
end

function M:regRequest(pid, pid_res, param, cb)
  param = param or {}
  param.mid = pid
  self:onPreSend(param)
  
  local function tFunc(msg)
    cb(msg)
  end
  
  self.mEventList[pid_res] = tFunc
end

function M:addRequestListener(pid_res, cb)
  local function tFunc(msg)
    cb(msg)
  end
  
  self.mEventList[pid_res] = tFunc
end

function M:removeRequest(pid_res)
  self.mEventList[pid_res] = nil
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
  local funcProto = self.mEventList[tonumber(msg.mid)]
  if funcProto then
    funcProto(msg)
  end
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
  if msg.mid == Proto.PID_REQUEST_LOST then
    self:resendCachedMsg(msg.max_sid)
    return true
  end
  if msg.mid == Proto.PID_KEEP_ALIVE then
    if msg.max_sid and msg.max_sid > self.mSeqIdS then
      DDLOG("Detect lost msg by KEEP_ALIVE: %s,", strData)
      self:requestLostMsg(self.mSeqIdS)
    end
    return true
  end
  if msg.mid == Proto.PID_RESET_DATA then
    DDLOG("Detect RESET_DATA: %s,", strData)
    self:resetData(msg.recv_sid, msg.send_sid)
    return true
  end
  if msg.mid == Proto.PID_KICKED_OFF then
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
  tp.mid = Proto.PID_REQUEST_LOST
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

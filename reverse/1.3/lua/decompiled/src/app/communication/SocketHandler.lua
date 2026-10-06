local LayerCompeteAlert = require("app.pvponline.LayerCompeteAlert")
local DYClass = "SocketHandler"
local M = class(DYClass)
local TAG_EVENT_LOGIN_OK = "tag_event_login_ok_h"
local TAG_CACHE_CHAT_MSG = "tag_cache_chat_msg_h"
local TAG_FRIENDS_PK_APPLY = "tag_friends_pk_apply_h"

function M:ctor()
  app:addEventListener(cc.mvc.AppBase.APP_ENTER_BACKGROUND_EVENT, function(event)
    if SocketMgr then
      SocketMgr:logout()
      GameManager.IS_FIRST_LOGIN = true
      GameManager.IS_CHAT_LOGIN_OK = false
    end
  end, app.TAG_EVENT_BACKGROUND)
  app:addEventListener(cc.mvc.AppBase.APP_ENTER_FOREGROUND_EVENT, function(event)
    SocketMgr = require("app.communication.SocketMgr").new(CloudData.USER_SERVER_INFO.interIp, CloudData.USER_SERVER_INFO.interPort)
    self:connectScocekChat(display.getRunningScene())
  end, app.TAG_EVENT_FOREGROUND)
end

function M:connectScocekChat()
  if not self.mTarget then
    self.mTarget = display.newNode():addTo(DYUtils.getTopNode())
  end
  if GameManager.IS_FIRST_LOGIN and not GameManager.IS_CHAT_LOGIN_OK then
    local function tFuncEvent(param)
      DDLOG("==================== LOGIN_OK")
      
      CloudData.UNION_ID = param.clan_data.clan_id
      CloudData.UNION_BOSS_LEVEL = param.clan_data.boss_level
      GameManager.IS_FIRST_LOGIN = false
      GameManager.IS_CHAT_LOGIN_OK = true
      self:updateMsg()
      self:receivePkApply()
      self:friendApplyListener()
      self:friendMsgListener()
      self:cancelPkApply()
      self:addFriendDelListener()
      self:addOfflineMsgListener()
      self:competeAlert()
      local currScene = display.getRunningScene()
      if currScene.class and currScene.class.__cname == "LayerCompeteInfo" then
        display.replaceScene(require("app.pvponline.LayerCompeteInfo").new())
      end
    end
    
    self.mTarget:safeSocketRequest("CMD_LOGIN", nil, tFuncEvent)
  end
end

function M:updateMsg()
  local function tFuncEvent(param)
    dump(param, "msg update : ")
    
    CloudData.CHAT_MSG_UPDATE = param
    if 2 == CloudData.CHAT_MSG_UPDATE.channel then
      CloudData.IS_NEW_UNION_CHAT = true
      if GameManager.CHAT_BTN and not GameManager.CHAT_BTN.newMark:isVisible() then
        GameManager.CHAT_BTN.newMark:show()
      end
    end
    DYNotification.postNotification(DY_KEY.kUpdateChatMsg)
  end
  
  self.mTarget:safeSocketListen("CMD_GET_CHAT_MSG", tFuncEvent)
end

function M:receivePkApply()
  local function tFuncEvent(param)
    local errorCode = tonumber(param.errorCode) or 1
    
    if errorCode ~= 0 then
      local errorMsg = param.errorMsg or "UNKNOWN"
      local t = WSToast.new(errorMsg)
      display.getRunningScene():addChild(t, 250)
      return
    end
    CloudData.PK_APPLY_INFO = param
    CloudData.NEW_PK_APPLY = true
    CloudData.NEW_PK_TIME = os.time()
    local target = display.getRunningScene().mPkBubble
    if target then
      target:updatePos()
    end
  end
  
  self.mTarget:safeSocketListen("CMD_FRIEND_PK_CALL", tFuncEvent)
end

function M:cancelPkApply()
  local function tFuncEvent(param)
    local errorCode = tonumber(param.errorCode) or 0
    
    if errorCode ~= 0 then
      local errorMsg = param.errorMsg or "UNKNOWN"
      local t = WSToast.new(errorMsg)
      display.getRunningScene():addChild(t, 250)
      return
    end
    DYNotification.postNotification(DY_KEY.kPkApplyCancel)
    CloudData.NEW_PK_APPLY = false
    local target = display.getRunningScene().mPkBubble
    if target then
      target:updatePos()
    end
  end
  
  self.mTarget:safeSocketListen("CMD_FRIEND_PK_CANCEL", tFuncEvent)
end

function M:competeAlert()
  local function tFuncEvent(param)
    DDLOG(" ================ COMPETE_ALERT !!!!!!!")
    
    if not GameManager.IS_ON_COMPETING then
      LayerCompeteAlert.new(param.left_time):addTo(display.getRunningScene(), 1000)
    end
  end
  
  self.mTarget:safeSocketListen("CMD_COMPETE_ALERT", tFuncEvent)
end

function M:friendApplyListener()
  local function tFuncEvent(param)
    local sender = checknumber(param.sender)
    
    local errorCode = checknumber(param.errorCode)
    if checknumber(CloudData.UID) == sender then
      if errorCode ~= 0 then
        local msg = param.errorMsg or "UNKNOWN"
        local toast = WSToast.new(msg, 2)
        display.getRunningScene():addChild(toast, 20)
      else
        local msg = DYLang.getString("S1231", "")
        local toast = WSToast.new(msg, 2)
        display.getRunningScene():addChild(toast, 20)
      end
    else
      CloudData.NEW_FRIEND_APPLY = 1
      DYNotification.postNotification(DY_KEY.kFriendAddApply)
    end
  end
  
  self.mTarget:safeSocketListen("CMD_FRIEND_TO_ADD", tFuncEvent)
end

function M:friendMsgListener()
  local function tFuncEvent(param)
    local sender = checknumber(param.uid)
    
    local errorCode = checknumber(param.errorCode)
    if sender then
      local uid = checkstring(sender)
      CloudData.CHAT_NEW_LIST[uid] = 1
      local msgInfo = {
        content = checkstring(param.content),
        time = math.ceil(checknumber(param.time) / 1000)
      }
      DataUtils.newLocalChatInfo(uid, msgInfo)
      DataUtils.newRecentItem(uid)
      DYNotification.postNotification(DY_KEY.kFriendMsg)
    end
  end
  
  self.mTarget:safeSocketListen("CMD_GET_FRIEND_MSG", tFuncEvent)
end

function M:addFriendDelListener()
  local function tFuncEvent(param)
    if checknumber(param.sender) == checknumber(CloudData.UID) then
      DataUtils.setLocalChatInfo(checknumber(param.receiver), nil)
      
      DataUtils.removeRecentItem(param.receiver)
      DYNotification.postNotification(DY_KEY.kFriendDelete, checknumber(param.receiver))
    else
      DataUtils.setLocalChatInfo(checknumber(param.sender), nil)
      DataUtils.removeRecentItem(param.sender)
      DYNotification.postNotification(DY_KEY.kFriendDelete, checknumber(param.sender))
    end
  end
  
  self.mTarget:safeSocketListen("CMD_FRIEND_DELETE", tFuncEvent)
end

function M:addOfflineMsgListener()
  local function tFuncEvent(param)
    local content = param.contents or {}
    
    local users = param.users or {}
    for k, v in pairs(content) do
      CloudData.CHAT_NEW_LIST[checkstring(k)] = 1
      local msgLog = DataUtils.getLocalChatInfo(k)
      for i = 1, #v do
        local msgInfo = {
          content = checkstring(v[i].content),
          time = math.ceil(checknumber(v[i].time) / 1000)
        }
        table.insert(msgLog, msgInfo)
      end
      DataUtils.setLocalChatInfo(k, msgLog)
      DataUtils.newRecentItem(uid)
      DYNotification.postNotification(DY_KEY.kFriendMsg)
    end
  end
  
  self.mTarget:safeSocketListen("CMD_GET_OFFLINE_MSG", tFuncEvent, true)
  self.mTarget:safeSocketRequest("CMD_REQ_OFFLINE_MSG", {
    uid = CloudData.UID
  })
end

return M

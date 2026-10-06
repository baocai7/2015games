local IconFriendPanel = require("app.friend.IconFriendPanel")
local IconAddPanel = require("app.friend.IconAddPanel")
local IconPkBubble = require("app.icons.IconPkBubble")
local DYClass = "LayerFriends"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
M.TAG_SCENE = false

function M.scene(cb, param1, param2)
  local scene = display.newScene()
  scene:addChild(M.new(cb, param1, param2))
  M.TAG_SCENE = true
  local pkBubble = IconPkBubble.new()
  scene:addChild(pkBubble, 900)
  scene.mPkBubble = pkBubble
  return scene
end

M.FRIEND = 1
M.ADD = 2

function M:ctor(callback, param1, param2)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callback
  self.mParam1 = param1 or 1
  self.mParam2 = param2 or {}
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mInfo = {}
  self.mCanBeClicked = false
  self:initUI()
  self:requestData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  display.newSprite("common_ui/common_bg.png", 0, 0):addTo(self.mNode)
  local bg = display.newSprite("friends/img_friend_bottom.png", 33, 0):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 503, 300):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mNode)
  self.mFriendBtn = cc.ui.UIPushButton.new({
    normal = "friends/tab_friend.png",
    disabled = "friends/tab_friend1.png"
  }):onButtonClicked(function(event)
    self:showFriend()
  end):align(display.CENTER, -497, 195):addTo(self.mNode)
  self.mFriendBtn.newMark = display.newSprite("common_ui/red_point.png", -10, 35):hide():addTo(self.mFriendBtn)
  self.mAddBtn = cc.ui.UIPushButton.new({
    normal = "friends/tab_add.png",
    disabled = "friends/tab_add1.png"
  }):onButtonClicked(function()
    self:showAdd()
  end):align(display.CENTER, -497, 24):addTo(self.mNode)
  self.mAddBtn.newMark = display.newSprite("common_ui/red_point.png", -10, 35):hide():addTo(self.mAddBtn)
  for k, v in pairs(CloudData.CHAT_NEW_LIST) do
    if v == 1 then
      self.mFriendBtn.newMark:show()
      break
    end
  end
  if CloudData.NEW_FRIEND_APPLY == 1 then
    self.mAddBtn.newMark:show()
  end
  self:addPostListener()
end

function M:initPkBubble()
  local pkBubble = IconPkBubble.new()
  self:addChild(pkBubble, 900)
  display.getRunningScene().mPkBubble = pkBubble
end

function M:addPostListener()
  local function tFuncNewApply()
    if CloudData.NEW_FRIEND_APPLY == 1 then
      self.mAddBtn.newMark:show()
    else
      self.mAddBtn.newMark:hide()
    end
  end
  
  DYNotification.registerScriptObserver(self, tFuncNewApply, DY_KEY.kFriendAddApply)
  
  local function tFuncNewMsg()
    if table.nums(CloudData.CHAT_NEW_LIST) > 0 then
      self.mFriendBtn.newMark:show()
    else
      self.mFriendBtn.newMark:hide()
    end
  end
  
  DYNotification.registerScriptObserver(self, tFuncNewMsg, DY_KEY.kFriendMsg)
  
  local function tFuncDelFriend(key, uid)
    print("tFuncDelFriend in LayerFriend")
    local index = DataUtils.getKeyIndex(CloudData.FRIENDS_LIST, "uid", uid)
    if 0 < index then
      table.remove(CloudData.FRIENDS_LIST, index)
    end
    local index1 = DataUtils.getKeyIndex(self.mInfo, "uid", uid)
    if 0 < index1 then
      table.remove(self.mInfo, index1)
    end
  end
  
  DYNotification.registerScriptObserver(self, tFuncDelFriend, DY_KEY.kFriendDelete)
end

function M:requestData()
  local function tFuncEvent(event)
    local errorCode = checknumber(event.errorCode)
    
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif errorCode ~= 0 then
      local msg = event.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
      return
    end
    local info = event.data or {}
    local recentInfo = DataUtils.getRecentList()
    local uids = ""
    for i = 1, #recentInfo do
      local uid = recentInfo[i]
      recentInfo[i] = {}
      recentInfo[i].uid = uid
      if info[checkstring(uid)] then
        recentInfo[i] = info[checkstring(uid)]
        recentInfo[i].strange = 0
      else
        recentInfo[i].strange = 1
        if uids == "" then
          uids = uids .. checkstring(uid)
        else
          uids = uids .. ";" .. checkstring(uid)
        end
      end
    end
    CloudData.FRIENDS_LIST = {}
    DataUtils.getOrderFriendList(info)
    self:getRecentData(recentInfo, uids)
    self:addFriendAddListener()
  end
  
  self:safeSocketRequest("CMD_GET_FRIEND_LIST", {
    uid = CloudData.UID
  }, tFuncEvent)
end

function M:getRecentData(recentInfo, uids)
  local function tFuncEvent(event)
    local errorCode = checknumber(event.errorCode)
    
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif errorCode ~= 0 then
      local msg = event.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
      return
    end
    local data = event.data
    for i = 1, #recentInfo do
      if data[checkstring(recentInfo[i].uid)] then
        local strange = recentInfo[i].strange
        recentInfo[i] = data[checkstring(recentInfo[i].uid)]
        recentInfo[i].strange = strange
      end
    end
    self:initData(recentInfo)
  end
  
  if uids == "" then
    self:initData(recentInfo)
  else
    local param = {
      uid = CloudData.UID,
      uids = uids
    }
    self:safeSocketRequest("CMD_SEEK_PLAYERS", param, tFuncEvent)
  end
end

function M:addFriendAddListener()
  local function tFuncEvent(event)
    local errorCode = checknumber(event.errorCode)
    
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif errorCode ~= 0 then
      local msg = event.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
      return
    else
      local info = event.data or {}
      DataUtils.insertToFriendList(info)
      local str = DYLang.getString("STR_NEW_FRIEND", "") .. checkstring(info.nick)
      local toast = WSToast.new(str, 1)
      self:addChild(toast, 20)
      local index = DataUtils.getKeyIndex(self.mInfo, "uid", info.uid)
      if 0 < index then
        self.mInfo[index].strange = 0
      end
      DYNotification.postNotification(DY_KEY.kFriendAddAgree, info, index)
    end
  end
  
  self:safeSocketListen("CMD_FRIEND_ADD_AGREE", tFuncEvent)
end

function M:initData(info)
  self.mInfo = info or {}
  if self.mParam1 == 2 then
    self:showAdd(true)
  else
    self:showFriend(true, self.mParam2)
    self.mParam2 = nil
  end
  self.mCanBeClicked = true
  local contact = {}
  for i = 1, #CloudData.FRIENDS_LIST do
    local uid = CloudData.FRIENDS_LIST[i].uid
    contact[checkstring(uid)] = 1
  end
  for i = 1, #self.mInfo do
    local uid = self.mInfo[i].uid
    contact[checkstring(uid)] = 1
  end
  DataUtils.sortChatInfo(contact)
end

function M:showFriend(silent, param)
  if not silent then
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
  end
  self.mFriendBtn:setButtonEnabled(false)
  self.mAddBtn:setButtonEnabled(true)
  if self.mPanel then
    self.mPanel:hide()
    self.mPanel = nil
  end
  self.mPanel = IconFriendPanel.new(self.mInfo, handler(self, self.friendCallback), param):pos(517, 330):addTo(self.mBg)
end

function M:showAdd(silent)
  if not silent then
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
  end
  self.mFriendBtn:setButtonEnabled(true)
  self.mAddBtn:setButtonEnabled(false)
  if self.mPanel then
    self.mPanel:hide()
    self.mPanel = nil
  end
  self.mPanel = IconAddPanel.new(handler(self, self.addPanelCallback)):pos(517, 330):addTo(self.mBg)
end

function M:friendCallback(tag, param)
  if tag == IconFriendPanel.REFRESH_RECENT then
    self.mInfo = param
  elseif tag == IconFriendPanel.NEW_MARK then
    if param then
      self.mFriendBtn.newMark:show()
    else
      self.mFriendBtn.newMark:hide()
    end
  end
end

function M:addPanelCallback(tag, param)
  if tag == IconAddPanel.APPLY_NEW then
    if param then
      self.mAddBtn.newMark:show()
      CloudData.NEW_FRIEND_APPLY = 1
    else
      self.mAddBtn.newMark:hide()
      CloudData.NEW_FRIEND_APPLY = 0
    end
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  CloudData.FRIENDS_LIST = {}
  if M.TAG_SCENE then
    M.TAG_SCENE = false
    local scene = require("scenes.ChapterScene").new()
    display.replaceScene(scene, "FADEDOWN", 0.5)
  else
    self:runAction(cc.RemoveSelf:create())
    if self.mCallback then
      self.mCallback()
    end
  end
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYNotification.removeAllObservers(self)
  self:removeAllChildren()
end

return M

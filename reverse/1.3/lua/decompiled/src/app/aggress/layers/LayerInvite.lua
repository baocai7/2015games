local DYClass = "LayerInvite"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M.scene(param, cb)
  local scene = display.newScene()
  scene:addChild(M.new(param, cb))
  return scene
end

function M:ctor(param, callback)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mInfo = {}
  self.mBg = nil
  self.mCanBeClicked = false
  self.mSelectedUid = {}
  self.mBossLv = checknumber(param and param.level)
  self.mBossName = checkstring(param and param.name)
  self:initUI()
  self:requestData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("aggress/img_boss_pop_02.png", 0, 0):addTo(self.mNode)
  self.mBg = bg
  display.newSprite("aggress/title_invite.png", 213, 594):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, 134, 106):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S567", ""),
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0),
    lineWidth = 2
  })):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, 297, 106):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("AGGRESS_INVITE", ""),
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0),
    lineWidth = 2
  })):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:toInvite()
  end):addTo(bg)
end

function M:toInvite()
  local ids = ""
  for k, v in pairs(self.mSelectedUid) do
    if ids ~= "" then
      ids = ids .. ";"
    end
    ids = ids .. k
  end
  if ids == "" then
    local toast = WSToast.new(DYLang.getString("AGGRESS_INVITE_LEAST", ""), 1)
    self:addChild(toast, 10)
  else
    local function tFuncListener(resp)
      if resp.errorCode ~= 0 then
        WSToast.new(resp.errorMsg, 2):addTo(display.getRunningScene(), 200)
      else
        WSToast.new(DYLang.getString("AGGRESS_INVITE_OK", ""), 2):addTo(display.getRunningScene(), 200)
        self:sendFriendMsg()
      end
      self:closeCallBack()
    end
    
    self:safeHttpRequest("aggressInviteFriend", tFuncListener, {uids = ids})
  end
end

function M:sendFriendMsg()
  local time = os.time()
  local str = string.format(DYLang.getString("STR_AGGRESS_INVITE", ""), self.mBossLv, self.mBossName)
  for k, v in pairs(self.mSelectedUid) do
    local params = {
      content = str,
      receiver = k,
      uid = CloudData.UID
    }
    self:safeSocketRequest("CMD_SEND_FRIEND_MSG", params)
    local info = {
      content = str,
      time = time,
      uid = CloudData.UID
    }
    DataUtils.newLocalChatInfo(k, info)
  end
end

function M:requestData()
  local tTag = DYCommon.genGlobalTag()
  
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
    CloudData.FRIENDS_LIST = {}
    DataUtils.getOrderFriendList(info)
    self:initData(CloudData.FRIENDS_LIST)
  end
  
  self:safeSocketRequest("CMD_GET_FRIEND_LIST", {
    uid = CloudData.UID
  }, tFuncEvent)
end

function M:initData(info)
  if not info or type(info) ~= "table" then
    return
  end
  self.mInfo = {}
  for i = 1, #info do
    if info[i].level >= Const.FUNC_UNLOCK.aggress then
      local item = clone(info[i])
      item.state = item.time <= 0 and 1 or 0
      item.uid = checkstring(item.uid)
      item.invited = 0
      table.insert(self.mInfo, item)
    end
  end
  if #self.mInfo > 0 then
    local function tFuncListener(resp)
      if not self or self.__cname ~= DYClass then
        return
      end
      if resp.errorCode ~= 0 then
        local toast = WSToast.new(resp.errorMsg, 2):addTo(self, 20)
        return
      end
      for i = 1, #self.mInfo do
        local item = self.mInfo[i]
        item.invited = resp.data.friends[item.uid] and 1 or 0
      end
      self:loadFriendInfo()
      self.mCanBeClicked = true
    end
    
    self:safeHttpRequest("aggressFriendInvited", tFuncListener)
  end
end

local function newFriendIcon(info, index, self)
  local frame = display.newSprite("aggress/img_boss_friend.png", 0, 0)
  frame:setTouchEnabled(false)
  frame:setTouchSwallowEnabled(false)
  local uid = checkstring(info.uid)
  if uid == "" then
    return
  end
  local invited = false
  local isSelected = false
  local selectedFrame
  if info.icon then
    local img = GameManager.USER_ICON_PATH .. info.icon .. ".png"
    if checknumber(info.state) == 1 then
      display.newSprite(img):scale(0.6):pos(42, 38):addTo(frame)
    else
      display.newGraySprite(img):scale(0.6):pos(42, 38):addTo(frame)
    end
  end
  cc.ui.UILabel.new({
    text = checkstring(info.nick),
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 93, 50):addTo(frame)
  cc.ui.UILabel.new({
    text = "LV." .. checkstring(info.level),
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 93, 22):addTo(frame)
  if checknumber(info.invited) == 1 then
    display.newSprite("aggress/img_invited.png"):pos(274, 34):addTo(frame)
    invited = true
  else
    frame:setTouchEnabled(true)
  end
  
  local function selected()
    if invited then
      return
    end
    if selectedFrame then
      selectedFrame:runAction(cc.RemoveSelf:create())
      selectedFrame = nil
    end
    selectedFrame = display.newSprite("aggress/img_boss_friends_chosen.png"):pos(153, 38):addTo(frame)
    isSelected = true
    self.mSelectedUid[uid] = 1
  end
  
  local function unSelected()
    isSelected = false
    self.mSelectedUid[uid] = nil
    if selectedFrame then
      selectedFrame:runAction(cc.RemoveSelf:create())
      selectedFrame = nil
    end
  end
  
  local beginPos = cc.p(0, 0)
  
  local function onTouchIcon(event)
    if invited then
      return false
    elseif "began" == event.name then
      beginPos = cc.p(event.x, event.y)
      return true
    elseif "ended" == event.name then
      local pos = cc.p(event.x, event.y)
      if math.abs(pos.x - beginPos.x) < 30 and math.abs(pos.y - beginPos.y) < 30 then
        if isSelected then
          unSelected()
        else
          selected()
        end
      end
    end
  end
  
  frame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return onTouchIcon(event)
  end)
  return frame
end

function M:loadFriendInfo()
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(50, 150, 330, 390),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  self.mListView = list
  local info = {}
  for i = 1, #self.mInfo do
    if checknumber(self.mInfo[i].state) ~= 1 then
      table.insert(info, self.mInfo[i])
    else
      local item = list:newItem()
      local content = newFriendIcon(self.mInfo[i], i, self)
      item:addContent(content)
      item:setItemSize(310, 77)
      list:addItem(item)
    end
  end
  for i = 1, #info do
    local item = list:newItem()
    local content = newFriendIcon(info[i], i, self)
    item:addContent(content)
    item:setItemSize(310, 77)
    list:addItem(item)
  end
  list:reload()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  CloudData.FRIENDS_LIST = {}
  self:runAction(cc.RemoveSelf:create())
  if self.mCallback then
    self.mCallback()
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
end

return M

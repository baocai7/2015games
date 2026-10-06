local IconFriendItem = require("app.friend.IconFriendItem")
local IconChatPanel = require("app.friend.IconChatPanel")
local LayerToAddFriend = require("app.friend.LayerToAddFriend")
local DYClass = "IconFriendPanel"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)
M.REFRESH_RECENT = 2
M.NEW_MARK = 3

function M:ctor(param, cb, param1)
  self:setNodeEventEnabled(true)
  self.mCallback = cb
  self.mTabs = {}
  self.mList = nil
  self.mInfo = {}
  self.mInfo[1] = CloudData.FRIENDS_LIST
  self.mInfo[2] = param or {}
  self.mCurIndex = param1 and param1.index or 1
  if not self.mInfo[self.mCurIndex] then
    self.mCurIndex = 1
  end
  self.mItems = {}
  self.mSeclectItem = 0
  self.mChatPanel = nil
  self.mFoldNumLab = {}
  self:layoutUI()
  local uid = param1 and param1.uid or 0
  self:reselect(uid)
  self:addPostListener()
end

function M:layoutUI()
  local bg = display.newNode():addTo(self)
  bg:setContentSize(932, 556)
  bg:setAnchorPoint(0.5, 0.5)
  self.mBg = bg
  local friendList = display.newScale9Sprite("friends/img_bottom_01.png", 0, 0, cc.size(346, 556), cc.rect(43, 43, 1, 1)):pos(173, 278):addTo(bg)
  local str = {
    string.format(DYLang.getString("FRIEND_LIST", ""), #self.mInfo[1], Const.FRIEND_MAX),
    string.format(DYLang.getString("FRIEND_RECENT_LIST", ""), #self.mInfo[2], Const.FRIEND_RECENT_MAX)
  }
  for i = 1, #str do
    local y = 521
    if 1 < i then
      y = (#str - i) * 60 + 34
    end
    local btn = cc.ui.UIPushButton.new("friends/img_fold.png"):align(display.CENTER, 173, y):onButtonClicked(function()
      self:clickTab(i)
    end):addTo(friendList)
    self.mTabs[i] = btn
    local tagIcon = display.newSprite("friends/img_fold_02.png", -136, 0):addTo(btn)
    local lab = cc.ui.UILabel.new({
      text = str[i],
      size = 20,
      color = cc.c3b(151, 105, 87),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, -100, 0):addTo(btn)
    self.mFoldNumLab[i] = lab
    btn.isOpen = false
    
    function btn.open()
      btn.isOpen = true
      tagIcon:setTexture("friends/img_fold_01.png")
      if 1 < i then
        btn:setPositionY(581 - 60 * i)
      end
    end
    
    function btn.fold()
      btn.isOpen = false
      tagIcon:setTexture("friends/img_fold_02.png")
      if 1 < i then
        btn:setPositionY(y)
      end
    end
  end
  self.mChatPanel = IconChatPanel.new(handler(self, self.chatCallback)):pos(644, 278):addTo(self.mBg)
end

function M:addPostListener()
  local function tFuncNewMsg()
    if not (self and self.mInfo) or not self.mInfo[self.mCurIndex] then
      return
    end
    local uid = self.mInfo[self.mCurIndex][self.mSeclectItem] and self.mInfo[self.mCurIndex][self.mSeclectItem].uid
    if CloudData.CHAT_NEW_LIST[checkstring(uid)] then
      CloudData.CHAT_NEW_LIST[checkstring(uid)] = nil
      self:showChatPanel()
      self:newRecentInfo(self.mInfo[self.mCurIndex][self.mSeclectItem])
    end
    local tag = false
    if table.nums(CloudData.CHAT_NEW_LIST) > 0 then
      tag = true
    end
    if self.mCallback then
      self.mCallback(M.NEW_MARK, tag)
    end
    local uids = ""
    for k, v in pairs(CloudData.CHAT_NEW_LIST) do
      local appendInfo
      local index = DataUtils.getKeyIndex(self.mInfo[self.mCurIndex], "uid", k)
      if 0 < index then
        self.mItems[index]:markNew()
        appendInfo = self.mInfo[self.mCurIndex][index]
        appendInfo.strange = checknumber(appendInfo.strange)
        self:newRecentInfo(appendInfo)
        return
      elseif self.mCurIndex == 1 then
        local appendIndex = DataUtils.getKeyIndex(self.mInfo[2], "uid", k)
        if 0 < appendIndex then
          appendInfo = self.mInfo[2][appendIndex]
          appendInfo.strange = 1
        end
      elseif self.mCurIndex == 2 then
        local appendIndex = DataUtils.getKeyIndex(self.mInfo[1], "uid", k)
        if 0 < appendIndex then
          appendInfo = self.mInfo[1][appendIndex]
          appendInfo.strange = 0
        end
      end
      if not appendInfo then
        if uids == "" then
          uids = uids .. checkstring(k)
        else
          uids = uids .. ";" .. checkstring(k)
        end
        appendInfo = {
          uid = checkstring(k),
          strange = 1
        }
      end
      self:newRecentInfo(appendInfo)
    end
    self:reGetRecentInfo(uids)
  end
  
  DYNotification.registerScriptObserver(self, tFuncNewMsg, DY_KEY.kFriendMsg)
  
  local function tFuncAddFriend(key, info, index)
    if not (self and self.mInfo) or not self.mInfo[self.mCurIndex] then
      return
    end
    local uid = self.mInfo[self.mCurIndex][self.mSeclectItem] and self.mInfo[self.mCurIndex][self.mSeclectItem].uid
    self.mInfo[1] = CloudData.FRIENDS_LIST
    self.mFoldNumLab[1]:setString(string.format(DYLang.getString("FRIEND_LIST", ""), #self.mInfo[1], Const.FRIEND_MAX))
    local index = DataUtils.getKeyIndex(self.mInfo[2], "uid", info.uid)
    if 0 < index then
      self.mInfo[2][index].strange = 0
    end
    if self.mCurIndex == 1 then
      self:reselect(uid)
    end
  end
  
  DYNotification.registerScriptObserver(self, tFuncAddFriend, DY_KEY.kFriendAddAgree)
  
  local function tFuncDelFriend(key, uid)
    print("prepare to do tFuncDelFriend in iconFriend")
    if not (self and self.mInfo) or not self.mInfo[self.mCurIndex] then
      return
    end
    print("tFuncDelFriend in iconFriend")
    local selectUid = self.mInfo[self.mCurIndex][self.mSeclectItem] and self.mInfo[self.mCurIndex][self.mSeclectItem].uid
    local index = DataUtils.getKeyIndex(CloudData.FRIENDS_LIST, "uid", uid)
    if 0 < index then
      table.remove(CloudData.FRIENDS_LIST, index)
    end
    self.mInfo[1] = CloudData.FRIENDS_LIST
    local index1 = DataUtils.getKeyIndex(self.mInfo[2], "uid", uid)
    if 0 < index1 then
      table.remove(self.mInfo[2], index1)
    end
    self.mFoldNumLab[1]:setString(string.format(DYLang.getString("FRIEND_LIST", ""), #self.mInfo[1], Const.FRIEND_MAX))
    self.mFoldNumLab[2]:setString(string.format(DYLang.getString("FRIEND_RECENT_LIST", ""), #self.mInfo[2], Const.FRIEND_RECENT_MAX))
    self:reselect(selectUid)
  end
  
  DYNotification.registerScriptObserver(self, tFuncDelFriend, DY_KEY.kFriendDelete)
end

function M:reGetRecentInfo(uids)
  if checkstring(uids) == "" then
    if self.mCallback then
      self.mCallback(M.REFRESH_RECENT, self.mInfo[2])
    end
    return
  end
  
  local function tFuncEvent(event)
    dump(event)
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
    for i = 1, #self.mInfo[2] do
      if data[checkstring(self.mInfo[2][i].uid)] then
        local strange = self.mInfo[2][i].strange
        self.mInfo[2][i] = data[checkstring(self.mInfo[2][i].uid)]
        self.mInfo[2][i].strange = strange
      end
    end
    if self.mCallback then
      self.mCallback(M.REFRESH_RECENT, self.mInfo[2])
    end
    if self.mCurIndex == 2 then
      self.mSeclectItem = 0
      self:showList(self.mCurIndex)
    end
  end
  
  local param = {
    uid = CloudData.UID,
    uids = uids
  }
  self:safeSocketRequest("CMD_SEEK_PLAYERS", param, tFuncEvent)
end

function M:chatCallback(tag, params)
  if tag == IconChatPanel.CHAT then
    self:newRecentInfo(params)
  elseif tag == IconChatPanel.DELETE then
    local str = string.format(DY_KEY.kPrivateChatMsg, tostring(CloudData.USER_SERVER_ID), tostring(params.uid), tostring(CloudData.UID))
    DYStat.setValueStr(str, "")
    local index = DataUtils.getKeyIndex(self.mInfo[1], "uid", params)
    if 0 < index then
      table.remove(self.mInfo[2], index)
    end
    local index1 = DataUtils.getKeyIndex(self.mInfo[2], "uid", params)
    if 0 < index1 then
      table.remove(self.mInfo[2], index1)
    end
    self.mFoldNumLab[1]:setString(string.format(DYLang.getString("FRIEND_LIST", ""), #self.mInfo[1], Const.FRIEND_MAX))
    self.mFoldNumLab[2]:setString(string.format(DYLang.getString("FRIEND_RECENT_LIST", ""), #self.mInfo[2], Const.FRIEND_RECENT_MAX))
    self:showList(self.mCurIndex)
  end
end

function M:newRecentInfo(params)
  DataUtils.newRecentItem(params.uid)
  table.insert(self.mInfo[2], 1, params)
  for i = 2, #self.mInfo[2] do
    if self.mInfo[2][i].uid == params.uid then
      table.remove(self.mInfo[2], i)
      break
    end
  end
  if #self.mInfo[2] > Const.FRIEND_RECENT_MAX then
    local uid = self.mInfo[2][#self.mInfo[2]].uid
    local strange = self.mInfo[2][#self.mInfo[2]].strange
    table.remove(self.mInfo[2], #self.mInfo[2])
    if checknumber(strange) ~= 0 then
      DataUtils.setLocalChatInfo(uid, nil)
    end
  end
  self.mFoldNumLab[2]:setString(string.format(DYLang.getString("FRIEND_RECENT_LIST", ""), #self.mInfo[2], Const.FRIEND_RECENT_MAX))
  if self.mCallback then
    self.mCallback(M.REFRESH_RECENT, self.mInfo[2])
  end
end

function M:clickTab(index)
  if not self.mTabs or not self.mTabs[index] then
    return
  end
  if self.mTabs[index].isOpen then
    self.mTabs[index]:fold()
    self.mCurIndex = 0
    self.mChatPanel:hide()
    if self.mList then
      self.mList:runAction(cc.RemoveSelf:create())
      self.mList = nil
    end
    self.mItems = {}
  else
    self:showList(index)
  end
end

function M:showList(index)
  self.mCurIndex = index
  local tabSum = #self.mTabs
  for i = 1, tabSum do
    if i ~= index then
      self.mTabs[i]:fold()
    else
      self.mTabs[i]:open()
    end
  end
  if self.mList then
    self.mList:runAction(cc.RemoveSelf:create())
    self.mList = nil
  end
  self.mItems = {}
  self.mFoldNumLab[1]:setString(string.format(DYLang.getString("FRIEND_LIST", ""), #self.mInfo[1], Const.FRIEND_MAX))
  self.mFoldNumLab[2]:setString(string.format(DYLang.getString("FRIEND_RECENT_LIST", ""), #self.mInfo[2], Const.FRIEND_RECENT_MAX))
  local y = (tabSum - index) * 60 + 10 - 5
  local h = 546 - tabSum * 60
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(5, y, 336, h),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  self.mList = list
  if not self.mInfo[index] or #self.mInfo[index] == 0 then
    self.mChatPanel:hide()
    return
  end
  local infoArr = self.mInfo[index]
  local row = #infoArr
  for i = 1, row do
    local item = list:newItem()
    local info = infoArr[i]
    if checknumber(info.strange) == 0 then
      if checknumber(info.enegyDraw) == 1 then
        info.btnImg = "friends/img_energy_gather.png"
      elseif checknumber(info.enegySend) == 1 then
        info.btnImg = "friends/img_energy_get.png"
      else
        info.btnImg = "friends/img_energy_send.png"
      end
    elseif index ~= 1 then
      info.btnImg = "friends/img_friend_add.png"
    end
    if checknumber(CloudData.CHAT_NEW_LIST[checkstring(info.uid)]) == 1 and i ~= self.mSeclectItem then
      info.new = 1
    else
      info.new = 0
    end
    local content = IconFriendItem.new(info, i, handler(self, self.clickItem))
    content:setPosition(168, 62)
    item:addContent(content)
    item:setItemSize(336, 124)
    list:addItem(item)
    self.mItems[i] = content
  end
  list:reload()
  self:clickItem(IconFriendItem.ITEM, self.mSeclectItem)
end

function M:showChatPanel()
  if #self.mInfo[self.mCurIndex] == 0 then
    self.mChatPanel:hide()
  end
  local info = self.mInfo[self.mCurIndex][self.mSeclectItem]
  if info then
    info.index = self.mSeclectItem
    self.mChatPanel:refresh(info)
  else
    self.mChatPanel:hide()
  end
end

function M:clickItem(tag, index)
  if tag == IconFriendItem.ITEM then
    if self.mItems[self.mSeclectItem] then
      self.mItems[self.mSeclectItem]:unselect()
    end
    if self.mItems[index] then
      self.mSeclectItem = index
      self.mItems[self.mSeclectItem]:select()
      self:showChatPanel()
    elseif self.mItems[1] then
      self.mSeclectItem = 1
      self.mItems[self.mSeclectItem]:select()
      self:showChatPanel()
    else
      self.mSeclectItem = 0
      self:showChatPanel()
    end
    local uid = self.mInfo[self.mCurIndex][self.mSeclectItem] and self.mInfo[self.mCurIndex][self.mSeclectItem].uid
    if CloudData.CHAT_NEW_LIST[checkstring(uid)] then
      CloudData.CHAT_NEW_LIST[checkstring(uid)] = nil
      self.mItems[self.mSeclectItem]:removeNew()
    end
    local tag = false
    for k, v in pairs(CloudData.CHAT_NEW_LIST) do
      tag = true
    end
    if self.mCallback then
      self.mCallback(M.NEW_MARK, tag)
    end
  elseif tag == IconFriendItem.BTN then
    local info = self.mInfo[self.mCurIndex][index]
    if not info then
      return
    end
    
    local function tFuncCallback(tag, self)
      local img
      if tag == 1 and checknumber(info.enegyDraw) == 1 then
        img = "friends/img_energy_gather.png"
        info.enegySend = 1
      elseif tag == 2 and checknumber(info.enegySend) ~= 1 then
        img = "friends/img_energy_send.png"
        info.enegyDraw = 0
      else
        img = "friends/img_energy_get.png"
        info.enegyDraw = 0
        info.enegySend = 1
      end
      if self.mItems[index] then
        self.mItems[index]:setBtnImg(img)
      end
      if self.mCurIndex == 1 then
        CloudData.FRIENDS_LIST[index].enegyDraw = info.enegyDraw
        CloudData.FRIENDS_LIST[index].enegySend = info.enegySend
        self.mInfo[1] = CloudData.FRIENDS_LIST
        local index1 = DataUtils.getKeyIndex(self.mInfo[2], "uid", info.uid)
        if 0 < index1 then
          self.mInfo[2][index1].enegyDraw = info.enegyDraw
          self.mInfo[2][index1].enegySend = info.enegySend
          if self.mCallback then
            self.mCallback(M.REFRESH_RECENT, self.mInfo[2])
          end
        end
      elseif self.mCurIndex == 2 then
        self.mInfo[2][index].enegyDraw = info.enegyDraw
        self.mInfo[2][index].enegySend = info.enegySend
        if checknumber(self.mInfo[2][index].strange) == 0 then
          local index1 = DataUtils.getKeyIndex(self.mInfo[1], "uid", info.uid)
          if 0 < index1 then
            self.mInfo[1][index1].enegyDraw = info.enegyDraw
            self.mInfo[1][index1].enegySend = info.enegySend
            CloudData.FRIENDS_LIST[index1].enegyDraw = info.enegyDraw
            CloudData.FRIENDS_LIST[index1].enegySend = info.enegySend
          end
        end
      end
    end
    
    if checknumber(info.strange) ~= 0 and self.mCurIndex ~= 1 then
      self:add(info.uid)
    elseif checknumber(info.enegyDraw) == 1 then
      self:getEnergy(info.uid, info.nick, tFuncCallback)
    elseif checknumber(info.enegySend) ~= 1 then
      self:sendEnergy(info.uid, info.nick, tFuncCallback)
    end
  end
end

function M:add(uid)
  LayerToAddFriend.new(uid):addTo(display.getRunningScene(), 20)
end

function M:sendEnergy(uid, nick, func)
  local function tFuncListener(event)
    local errorCode = checknumber(event.errorCode)
    
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif errorCode ~= 0 then
      local msg = event.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      display.getRunningScene():addChild(toast, 20)
      return
    else
      WSToast.new(DYLang.getString("STR_ENERGY_SEND_SECC", ""), 2):addTo(display.getRunningScene(), 20)
      func(1, self)
    end
  end
  
  DYHttpMgr.sendFriendEnergy(tFuncListener, {friendUid = uid})
end

function M:getEnergy(uid, nick, func)
  local function tFuncListener(event)
    dump(event)
    
    local errorCode = checknumber(event.errorCode)
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif errorCode ~= 0 then
      local msg = event.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      display.getRunningScene():addChild(toast, 20)
      return
    else
      for id, sum in pairs(event.data) do
        DataUtils.updateItemNum(id, sum)
      end
      WSToast.new(DYLang.getString("STR_ENERGY_GET_SECC", ""), 2):addTo(display.getRunningScene(), 20)
      func(2, self)
    end
  end
  
  DYHttpMgr.getFriendEnergy(tFuncListener, {friendUid = uid})
end

function M:reselect(uid)
  local index = DataUtils.getKeyIndex(self.mInfo[self.mCurIndex], "uid", uid)
  if 0 < index then
    self.mSeclectItem = index
  else
    self.mSeclectItem = 0
  end
  self:showList(self.mCurIndex)
end

function M:hide()
  self:runAction(cc.RemoveSelf:create())
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYNotification.removeAllObservers(self)
end

return M

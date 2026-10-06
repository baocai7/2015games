local IconFriendItem = require("app.friend.IconFriendItem")
local IconChatPanel = require("app.friend.IconChatPanel")
local LayerToAddFriend = require("app.friend.LayerToAddFriend")
local DYClass = "IconAddPanel"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)
M.APPLY_NEW = 1

function M:ctor(cb)
  self:setNodeEventEnabled(true)
  self.mCallback = cb
  self.mRecommendList = nil
  self.mApplyList = nil
  self.mCurIndex = 0
  self.mRecommendLab = nil
  self.mItems = {}
  self.mSeclectItem = 0
  self.mRecommend = {}
  self.mApply = {}
  self:layoutUI()
  self:addPostListener()
end

function M:layoutUI()
  local bg = display.newNode():addTo(self)
  bg:setContentSize(932, 556)
  bg:setAnchorPoint(0.5, 0.5)
  self.mBg = bg
  local friendList = display.newScale9Sprite("friends/img_bottom_01.png", 0, 0, cc.size(346, 486), cc.rect(43, 43, 1, 1)):pos(173, 313):addTo(bg)
  local title = display.newSprite("friends/img_fold.png", 173, 451):addTo(friendList)
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_FRIEND_RECOMMEND", ""),
    size = 20,
    color = cc.c3b(151, 105, 87),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 167, 30):addTo(title)
  display.newScale9Sprite("friends/img_bottom_01.png", 0, 0, cc.size(576, 486), cc.rect(43, 43, 1, 1)):pos(644, 313):addTo(bg)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, 844, 33):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("STR_FIND", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3),
    lineWidth = 2
  })):onButtonClicked(function()
    self:clickFind()
  end):addTo(bg)
  self.mRecommendLab = cc.ui.UILabel.new({
    text = DYLang.getString("STR_NO_RECOMMEND", ""),
    size = 30,
    color = cc.c3b(151, 105, 87),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 173, 380):addTo(friendList):hide()
  self:getRecommendData()
  self:getApplyData()
  self:addEditbox()
end

function M:addPostListener()
  local function tFuncNewApply()
    self:getApplyData()
  end
  
  DYNotification.registerScriptObserver(self, tFuncNewApply, DY_KEY.kFriendAddApply)
  
  local function tFuncAddFriend(key, info, index)
    if not self or not self.mApply then
      return
    end
    local index = DataUtils.getKeyIndex(self.mApply, "uid", info.uid)
    if 0 < index then
      table.remove(self.mApply, index)
      self:showApplyList()
      if self.mCallback then
        self.mCallback(M.APPLY_NEW, #self.mApply > 0)
      end
    end
  end
  
  DYNotification.registerScriptObserver(self, tFuncAddFriend, DY_KEY.kFriendAddAgree)
end

function M:getRecommendData()
  local function tFuncEvent(event)
    self.mRecommend = {}
    
    local info = event.data or {}
    for k, v in pairs(info) do
      table.insert(self.mRecommend, v)
    end
    self:showRecommendList()
  end
  
  self:safeSocketRequest("CMD_FRIEND_RECOMMEND", param, tFuncEvent)
end

function M:getApplyData()
  local function tFuncEvent(event)
    self.mApply = {}
    
    local info = event.data or {}
    for k, v in pairs(info) do
      table.insert(self.mApply, v)
    end
    self:showApplyList()
  end
  
  self:safeSocketRequest("CMD_GET_FRIEND_APPLY_LIST", param, tFuncEvent)
end

function M:showRecommendList()
  if self.mRecommendList then
    self.mRecommendList:runAction(cc.RemoveSelf:create())
    self.mRecommendList = nil
  end
  self.mItems = {}
  if self.mRecommendLab then
    self.mRecommendLab:hide()
  end
  local listInfo = self.mRecommend
  if not listInfo or #listInfo == 0 then
    if self.mRecommendLab then
      self.mRecommendLab:show()
    end
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(5, 75, 336, 416),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  self.mRecommendList = list
  for i = 1, #listInfo do
    local item = list:newItem()
    local info = listInfo[i]
    info.btnImg = "friends/img_friend_add.png"
    local content = IconFriendItem.new(info, i, handler(self, self.clickItem))
    content:setPosition(168, 62)
    item:addContent(content)
    item:setItemSize(336, 124)
    list:addItem(item)
    self.mItems[i] = content
  end
  list:reload()
end

function M:newApplyIcon(info)
  local icon = display.newSprite("friends/img_add_bottom.png")
  local head = display.newSprite("friends/img_friend_box.png", 44, 42):scale(0.6):addTo(icon)
  self.mChatIcon = display.newSprite(GameManager.USER_ICON_PATH .. checkstring(info.icon) .. ".png"):pos(59, 59):addTo(head)
  cc.ui.UILabel.new({
    text = info.nick,
    size = 20,
    color = cc.c3b(63, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 87, 62):addTo(icon)
  local timeStr
  if info.time > Const.FRIEND_OFFLINE_TIME_MAX * 3600 * 24 then
    timeStr = "7" .. DYLang.getString("TIME_DAY", "") .. DYLang.getString("STR_BEFORE", "")
  else
    timeStr = DataUtils.timeStrLeast(info.time) .. DYLang.getString("STR_BEFORE", "")
  end
  cc.ui.UILabel.new({
    text = timeStr,
    size = 20,
    color = cc.c3b(63, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 385, 62):addTo(icon)
  local descLab = cc.ui.UILabel.new({
    text = info.desc,
    size = 20,
    color = cc.c3b(151, 105, 87),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 87, 22):addTo(icon)
  descLab:setDimensions(300, 30)
  local btnInfo = {
    {
      img = "union/btn_pass.png",
      x = 438,
      func = function()
        self:clickAgree(info.index)
      end
    },
    {
      img = "union/btn_pass_no.png",
      x = 522,
      func = function()
        self:clickDeny(info.index)
      end
    }
  }
  for i = 1, #btnInfo do
    local btn = cc.ui.UIPushButton.new(btnInfo[i].img):align(display.CENTER, btnInfo[i].x, 42):onButtonClicked(function()
      btnInfo[i].func()
    end):addTo(icon)
    btn:setTouchSwallowEnabled(false)
  end
  return icon
end

function M:clickAgree(index)
  if #CloudData.FRIENDS_LIST >= Const.FRIEND_MAX then
    local msg = DYLang.getString("S672", "")
    local toast = WSToast.new(msg, 2)
    display.getRunningScene():addChild(toast, 20)
    return
  elseif not self.mApply[index] then
    return
  end
  local param = {
    receiver = self.mApply[index].uid,
    uid = CloudData.UID
  }
  self:safeSocketRequest("CMD_FRIEND_ADD_AGREE", param)
  table.remove(self.mApply, index)
  self:showApplyList()
  if self.mCallback then
    self.mCallback(M.APPLY_NEW, #self.mApply > 0)
  end
end

function M:clickDeny(index)
  local param = {
    receiver = self.mApply[index].uid,
    uid = CloudData.UID
  }
  self:safeSocketRequest("CMD_FRIEND_ADD_REFUSE", param)
  table.remove(self.mApply, index)
  self:showApplyList()
  if self.mCallback then
    self.mCallback(M.APPLY_NEW, #self.mApply > 0)
  end
end

function M:isFriends(text)
  local str = checkstring(text)
  for i = 1, #CloudData.FRIENDS_LIST do
    local info = CloudData.FRIENDS_LIST[i]
    if checkstring(info.nick) == str or checkstring(info.uid) == str then
      return true
    end
  end
  return false
end

function M:clickFind()
  local text = self.mNickInput:getText()
  if text == nil or text == "" then
    local t = WSToast.new(DYLang.getString("S698", ""))
    display.getRunningScene():addChild(t, 20)
    return
  elseif text == CloudData.UID or text == CloudData.USER_NAME then
    local t = WSToast.new(DYLang.getString("S699", ""))
    display.getRunningScene():addChild(t, 20)
    return
  elseif self:isFriends(text) then
    local t = WSToast.new(text .. DYLang.getString("S700", ""))
    display.getRunningScene():addChild(t, 20)
    return
  end
  local param = {
    player = text,
    uid = CloudData.UID
  }
  self:safeSocketRequest("CMD_SEEK_PLAYER", param, function(event)
    self:showFindResult(event)
  end)
end

function M:showFindResult(event)
  self.mNickInput:setText("")
  local errorCode = checknumber(event.errorCode)
  if errorCode ~= 0 then
    local msg = event.errorMsg or "UNKNOWN"
    local toast = WSToast.new(msg, 2)
    display.getRunningScene():addChild(toast, 20)
  else
    local data = event.data or {}
    local info = {}
    for k, v in pairs(data) do
      table.insert(info, v)
    end
    if #info == 0 then
      WSToast.new(DYLang.getString("STR_NULL_PLAYER", ""), 2):addTo(display.getRunningScene(), 20)
    else
      self.mRecommend = info
      self:showRecommendList()
    end
  end
end

function M:showApplyList()
  if self.mApplyList then
    self.mApplyList:runAction(cc.RemoveSelf:create())
    self.mApplyList = nil
  end
  if not self.mApply or #self.mApply == 0 then
    if self.mCallback then
      self.mCallback(M.APPLY_NEW, false)
    end
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(360, 76, 570, 476),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  self.mApplyList = list
  for i = 1, #self.mApply do
    local item = list:newItem()
    local info = self.mApply[i]
    info.index = i
    local content = self:newApplyIcon(info)
    content:setPosition(283, 42)
    item:addContent(content)
    item:setItemSize(566, 84)
    list:addItem(item)
  end
  list:reload()
end

function M:addEditbox()
  display.newScale9Sprite("friends/img_input.png", 383, 33, cc.size(766, 66), cc.rect(33, 33, 1, 1)):addTo(self.mBg)
  local input = cc.ui.UIInput.new({
    image = "common_ui/img_square.png",
    size = cc.size(720, 40),
    x = 383,
    y = 33,
    listener = function(event, editbox)
      if event == "ended" then
        self:onEditBoxEnded(editbox)
      end
    end
  })
  input:setColor(cc.c3b(255, 246, 220))
  input:setPlaceHolder(DYLang.getString("S685", ""))
  input:setPlaceholderFontColor(cc.c3b(151, 105, 87))
  input:setPlaceholderFontName(GameManager.FONTNAME_TTF)
  input:setPlaceholderFontSize(24)
  input:setFontColor(cc.c3b(80, 30, 0))
  input:setFontName(GameManager.FONTNAME_TTF)
  input:setFontSize(24)
  input:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  self.mNickInput = input
  self.mBg:addChild(input)
end

function M:onEditBoxEnded(editbox)
end

function M:clickItem(tag, index)
  if tag == IconFriendItem.ITEM then
    if self.mItems[self.mSeclectItem] then
      self.mItems[self.mSeclectItem]:unselect()
    end
    self.mSeclectItem = index
    if self.mItems[self.mSeclectItem] then
      self.mItems[self.mSeclectItem]:select()
    end
  elseif tag == IconFriendItem.BTN then
    local info = self.mRecommend[index]
    if not info then
      return
    end
    LayerToAddFriend.new(info.uid, handler(self, self.toAddFriend), index):addTo(display.getRunningScene(), 20)
    self.mNickInput:setEnabled(false)
  end
end

function M:toAddFriend(tag)
  if tag then
    if self.mRecommend[tag] then
      table.remove(self.mRecommend, tag)
    end
    self:showRecommendList()
  end
  self.mNickInput:setEnabled(true)
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

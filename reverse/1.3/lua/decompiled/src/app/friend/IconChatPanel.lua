local LayerDeleteFriend = require("app.friend.LayerDeleteFriend")
local LayerFriendTeam = require("app.friend.LayerFriendTeam")
local LayerWaitPkApply = require("app.layers.LayerWaitPkApply")
local M = {}
M = class("IconChatPanel", function()
  return display.newNode()
end)
M.PK = 1
M.TEAM = 2
M.DELETE = 3
M.CHAT = 4

function M:ctor(cb, param)
  self.mCallback = cb
  self.mData = param
  self.mFriendUid = 1
  self.mFriendIcon = ""
  self.mFriendNick = ""
  self.mTabs = {}
  self.mList = nil
  self.mInfo = {}
  self.mIndex = 0
  self.mMsg = {}
  self.mChatList = nil
  self.mChatIcon = nil
  self.mChatNick = nil
  self.mNickInput = nil
  self.mClanName = nil
  self:layoutUI()
end

function M:layoutUI()
  local bg = display.newNode():addTo(self)
  bg:setContentSize(576, 556)
  bg:setAnchorPoint(0.5, 0.5)
  self.mBg = bg
  local head = display.newSprite("friends/img_friend_box.png", 48, 515):scale(0.6):addTo(bg)
  self.mChatIcon = display.newSprite():pos(59, 59):addTo(head)
  self.mChatNick = cc.ui.UILabel.new({
    text = self.mFriendNick,
    size = 20,
    color = cc.c3b(63, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 92, 533):addTo(bg)
  self.mClanName = cc.ui.UILabel.new({
    text = "",
    size = 20,
    color = cc.c3b(24, 120, 240),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 82, 500):addTo(bg)
  local chatBg = display.newScale9Sprite("friends/img_bottom_01.png", 0, 0, cc.size(576, 403), cc.rect(43, 43, 1, 1)):pos(288, 272):addTo(bg)
  local info = {
    {
      img = "friends/btn_fight.png",
      x = 341,
      y = 515
    },
    {
      img = "union/btn_team.png",
      x = 432,
      y = 515
    },
    {
      img = "union/bnt_delete.png",
      x = 524,
      y = 515
    },
    {
      img = {
        normal = "common_ui/btn_normal1.png",
        pressed = "common_ui/btn_pressed1.png"
      },
      x = 504,
      y = 33,
      str = ""
    }
  }
  for i = 1, #info do
    local btn = cc.ui.UIPushButton.new(info[i].img):align(display.CENTER, info[i].x, info[i].y):onButtonPressed(function(event)
      event.target:setScale(0.9)
    end):onButtonRelease(function(event)
      event.target:setScale(1)
    end):onButtonClicked(function()
      self:clickBtn(i)
    end):addTo(bg)
    if info[i].str then
      btn:setButtonLabel("normal", DYLabelTTF.new({
        text = DYLang.getString("S574", ""),
        size = 30,
        color = cc.c3b(255, 240, 0),
        font = GameManager.FONTNAME_TTF
      }, {
        lineColor = cc.c3b(25, 30, 3),
        lineWidth = 2
      }))
    end
  end
  display.newScale9Sprite("friends/img_input.png", 213, 33, cc.size(426, 66), cc.rect(33, 33, 1, 1)):addTo(bg)
  local input = cc.ui.UIInput.new({
    image = "common_ui/img_square.png",
    size = cc.size(400, 40),
    x = 213,
    y = 33,
    listener = function(event)
    end
  })
  input:setColor(cc.c3b(255, 246, 220))
  input:setFontColor(cc.c3b(80, 30, 0))
  input:setFontName(GameManager.FONTNAME_TTF)
  input:setFontSize(24)
  input:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  self.mNickInput = input
  bg:addChild(input)
  self.mNickInput:setMaxLength(600)
end

function M:showChatList()
  if self.mChatList then
    self.mChatList:runAction(cc.RemoveSelf:create())
    self.mChatList = nil
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 74, 552, 395),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  self.mChatList = list
  local infoArr = self.mMsg
  if not infoArr or 0 == #infoArr then
    return
  end
  local saveInfo = {}
  local markTime = os.time() - 86400 * Const.FRIEND_CHAT_SAVE_TIME
  local reSave = false
  for i = 1, #infoArr do
    local msgInfo = infoArr[i]
    local time = checknumber(msgInfo.time)
    if markTime < time then
      self:newChatItem(msgInfo)
      table.insert(saveInfo, msgInfo)
    else
      reSave = true
    end
  end
  list:reload()
  if reSave then
    DataUtils.setLocalChatInfo(self.mFriendUid, saveInfo)
  end
  if self.mChatList.size.height > self.mChatList:getViewRect().height then
    self.mChatList.container:setPositionY(0)
  end
end

local function getChatTimeStr(t)
  local time = checknumber(t)
  if time == 0 then
    return "--"
  end
  local curTime = os.time()
  local d1 = os.date("%d", time)
  local d2 = os.date("%d", curTime)
  if d2 ~= d1 then
    return os.date("%Y/%m/%d %H:%M:%S", time)
  else
    return os.date("%H:%M:%S", time)
  end
end

function M:getSelfMsgContent(msgInfo)
  local bubbleW = 78
  local bubbleH = 48
  local maxTextW = 336
  local fontSize = 24
  local contentH = 89
  local content = display.newNode()
  local msgLabel = cc.ui.UILabel.new({
    text = checkstring(msgInfo.content),
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.TOP_RIGHT, 0, 0)
  local w, h = msgLabel:getContentSize().width, msgLabel:getContentSize().height
  local wid = w + (bubbleW - fontSize)
  local hei = bubbleH
  if fontSize >= w then
    wid = bubbleW
  elseif maxTextW < w then
    msgLabel:setDimensions(maxTextW, 0)
    maxTextW = msgLabel:getContentSize().width
    local heiCur = msgLabel:getContentSize().height
    wid = maxTextW + (bubbleW - fontSize)
    hei = heiCur + (bubbleH - fontSize)
  end
  msgLabel:setPosition(wid - 33, hei - 12)
  contentH = contentH - bubbleH + hei
  content:setContentSize(552, contentH)
  local head = display.newSprite("friends/img_friend_box.png", 503, contentH - 36):scale(0.6):addTo(content)
  display.newSprite(CloudData.USER_ICON):pos(59, 59):addTo(head)
  local str = getChatTimeStr(checknumber(msgInfo.time))
  DYLabelTTF.new({
    text = str .. "   " .. CloudData.USER_NAME,
    size = 16,
    color = cc.c3b(151, 105, 87),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }):pos(head:getPositionX() - 50, head:getPositionY() + 25):addTo(content)
  local msgFrame = display.newScale9Sprite("friends/img_talk_02.png", 0, 0, cc.size(wid, hei), cc.rect(35, 32, 1, 1)):align(display.TOP_RIGHT, head:getPositionX() - 35, head:getPositionY() + 12):addTo(content)
  msgLabel:addTo(msgFrame)
  return content, contentH
end

function M:getOtherMsgContent(msgInfo)
  local bubbleW = 78
  local bubbleH = 48
  local maxTextW = 336
  local fontSize = 24
  local contentH = 89
  local content = display.newNode()
  local msgLabel = cc.ui.UILabel.new({
    text = msgInfo.content,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.TOP_LEFT, 0, 0)
  local w, h = msgLabel:getContentSize().width, msgLabel:getContentSize().height
  local wid = w + (bubbleW - fontSize)
  local hei = bubbleH
  if fontSize >= w then
    wid = bubbleW
  elseif maxTextW < w then
    msgLabel:setDimensions(maxTextW, 0)
    maxTextW = msgLabel:getContentSize().width
    local heiCur = msgLabel:getContentSize().height
    wid = maxTextW + (bubbleW - fontSize)
    hei = heiCur + (bubbleH - fontSize)
  end
  msgLabel:setPosition(33, hei - 12)
  contentH = contentH - bubbleH + hei
  content:setContentSize(552, contentH)
  local head = display.newSprite("friends/img_friend_box.png", 49, contentH - 36):scale(0.6):addTo(content)
  display.newSprite(self.mFriendIcon):pos(59, 59):addTo(head)
  local str = getChatTimeStr(checknumber(msgInfo.time))
  DYLabelTTF.new({
    text = self.mFriendNick .. "   " .. checkstring(str),
    size = 16,
    color = cc.c3b(151, 105, 87),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(head:getPositionX() + 50, head:getPositionY() + 25):addTo(content)
  local msgFrame = display.newScale9Sprite("friends/img_talk_01.png", 0, 0, cc.size(wid, hei), cc.rect(35, 32, 1, 1)):align(display.TOP_LEFT, head:getPositionX() + 35, head:getPositionY() + 12):addTo(content)
  msgLabel:addTo(msgFrame)
  return content, contentH
end

function M:newChatItem(msgInfo, log, refresh)
  local item = self.mChatList:newItem()
  local content
  if msgInfo.uid == CloudData.UID then
    content, h = self:getSelfMsgContent(msgInfo)
  else
    content, h = self:getOtherMsgContent(msgInfo)
  end
  item:addContent(content)
  item:setItemSize(552, h + 6)
  self.mChatList:addItem(item)
  table.insert(self.mMsg, msgInfo)
  if log then
    local value = DataUtils.setLocalChatInfo(self.mFriendUid, self.mMsg)
  end
  if refresh then
    local y = self.mChatList.container:getPositionY()
    self.mChatList:reload()
    if self.mChatList.size.height > self.mChatList:getViewRect().height then
      if -10 < y then
        self.mChatList.container:setPositionY(0)
      else
        self.mChatList.container:setPositionY(y - (h + 6))
      end
    end
    if self.mCallback then
      self.mCallback(M.CHAT, self.mInfo)
    end
  end
end

function M:clickBtn(i)
  local info = {
    [1] = function()
      self:pk()
    end,
    [2] = function()
      self:team()
    end,
    [3] = function()
      self:delete()
    end,
    [4] = function()
      self:chat()
    end
  }
  info[i]()
end

function M:pk()
  local time = os.time() - CloudData.SEND_PK_TIME
  if time < CloudData.PK_ACTIVE_TIME then
    local t = CloudData.PK_ACTIVE_TIME - time
    local msg = DYLang.getString("S706", "") .. t .. DYLang.getString("S707", "")
    local toast = WSToast.new(msg, 2)
    self:addChild(toast, 20)
    return
  elseif GameManager.IS_USER_BUSY == 1 then
    local msg = DYLang.getString("S708", "")
    local toast = WSToast.new(msg, 2)
    self:addChild(toast, 20)
    return
  end
  
  local function tFuncEvent(event)
    dump(event)
    local errorCode = tonumber(event.errorCode) or 1
    if errorCode ~= 0 then
      local msg = event.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      display.getRunningScene():addChild(toast, 20)
      GameManager.IS_USER_BUSY = 0
    else
      GameManager.IS_USER_BUSY = 1
      LayerWaitPkApply.new(self.mInfo):addTo(display.getRunningScene(), 20)
    end
  end
  
  local param = {
    receiver = tonumber(self.mInfo.uid),
    nick = CloudData.USER_NAME,
    uid = CloudData.UID
  }
  self:safeSocketRequest("CMD_FRIEND_PK_APPLY", param, tFuncEvent)
end

function M:team()
  LayerFriendTeam.new(self.mInfo.team, handler(self, self.closeChildWindow)):addTo(display.getRunningScene(), 20)
  self.mNickInput:setEnabled(false)
end

function M:findUid(info, uid)
  if not info or #info == 0 then
    return 0
  end
  for i = 1, #info do
    if checknumber(info[i].uid) == checknumber(uid) then
      return i
    end
  end
  return 0
end

function M:delete()
  if checknumber(self.mInfo.strange) == 0 then
    self.mInfo.text = DYLang.getString("STR_DELETE_FRIEND", "")
  else
    self.mInfo.text = DYLang.getString("STR_REMOVE_CONTACT", "")
  end
  local la = LayerDeleteFriend.new(self.mInfo, handler(self, self.deleteCallback))
  display.getRunningScene():addChild(la, 20)
  self.mNickInput:setEnabled(false)
end

function M:closeChildWindow()
  self.mNickInput:setEnabled(true)
end

function M:deleteCallback(tag)
  print("deleteCallback __________ " .. checknumber(tag))
  if checknumber(tag) == 1 then
    self:hide()
  else
    self.mNickInput:setEnabled(true)
  end
end

function M:chat()
  local text = self.mNickInput:getText()
  if text == nil or text == "" then
    local t = WSToast.new(DYLang.getString("S582", ""), 2)
    display.getRunningScene():addChild(t, 250)
    return
  elseif not DataUtils.isChatLegal(text) then
    local t = WSToast.new(DYLang.getString("S583", ""), 2)
    display.getRunningScene():addChild(t, 250)
    return
  end
  self.mNickInput:setText("")
  local params = {
    content = text,
    receiver = self.mFriendUid,
    uid = CloudData.UID
  }
  self:safeSocketRequest("CMD_SEND_FRIEND_MSG", params)
  print(text)
  self:newChatItem({
    content = text,
    time = os.time(),
    uid = CloudData.UID
  }, true, true)
end

function M:refresh(info)
  if not info then
    self:hide()
    return
  else
    self:show()
  end
  self.mInfo = info
  self.mFriendIcon = GameManager.USER_ICON_PATH .. checkstring(info.icon) .. ".png"
  self.mFriendNick = checkstring(info.nick)
  self.mFriendUid = checkstring(info.uid)
  self.mIndex = checknumber(info.index)
  self.mChatIcon:setTexture(self.mFriendIcon)
  self.mChatNick:setString(self.mFriendNick)
  self.mClanName:setString(checkstring(self.mInfo.clanName))
  if checkstring(self.mInfo.clanName) ~= "" then
    self.mClanName:setString("\227\128\144" .. checkstring(self.mInfo.clanName) .. "\227\128\145")
  else
    self.mClanName:setString("")
  end
  self.mMsg = DataUtils.getLocalChatInfo(self.mFriendUid)
  self:showChatList()
end

return M

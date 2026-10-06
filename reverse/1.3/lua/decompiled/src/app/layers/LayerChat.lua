local LayerChatOperate = require("app.layers.LayerChatOperate")
local TAG_SEND_MAG = "tag_send_msg"
local TAG_GET_FRIENDS_LIST = "tag_get_friends_list"
local CLASS_NAME = "LayerChat"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.WORLD = 0
M.GOSSIP = 1
M.CHANNEL_WORLD = 1
M.CHANNEL_UNION = 2
M.CHANNEL_CROSS = 3
M.CHANNEL_SYSTEM = 4
M.CHANNEL_BTN = {
  "friends/name_selected.png",
  "friends/name_union.png",
  "friends/name_battle.png",
  "friends/name_normal.png"
}
M.CHANNEL_TAGS = {
  "friends/tag_world.png",
  nil,
  nil,
  "friends/img_sys_title.png"
}
M.CHAT_LEVEL = 20

function M:ctor(channelType, params, callback)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mCallback = callback
  self.editBox = nil
  self.editMask = nil
  self.mEditBg = nil
  self.mParams = params
  self:initData(channelType)
end

local function getLocalMsgInfo(targetId)
  local str = string.format(DY_KEY.kPrivateChatMsg, tostring(CloudData.USER_SERVER_ID), tostring(targetId), tostring(CloudData.UID))
  local value = DYStat.getValueStr(str, "")
  local msgInfo = json.decode(value) or {}
  return msgInfo
end

local function saveLocalMsgInfo(targetId, msgInfo)
  if 20 < #msgInfo then
    table.remove(msgInfo, 1)
  end
  local str = string.format(DY_KEY.kPrivateChatMsg, tostring(CloudData.USER_SERVER_ID), tostring(targetId), tostring(CloudData.UID))
  local value = json.encode(msgInfo)
  DYStat.setValueStr(str, value)
end

function M:initData(channelType)
  local function tFuncEvent(param)
    DDLOG(" ================ CHAT_MSG_LIST !!!!!!!")
    
    local data = param
    self.mWorldMsgList = data.world_msg_list
    self.mUnionMsgList = data.clan_msg_list
    self.mCrossMsgList = data.clan_compete_msg_list
    self.mTotalMsgList = {
      self.mWorldMsgList,
      self.mUnionMsgList,
      self.mCrossMsgList,
      clone(CloudData.SYSTEM_MSG_LOG)
    }
    self.mChannel = channelType or M.CHANNEL_WORLD
    self.mSelectedChannel = nil
    self.mIndex = 0
    self.mChannelBtns = {}
    self.mMsgInfo = {}
    if self.initUI then
      self:initUI()
    end
  end
  
  self:safeSocketRequest("CMD_CHAT_MSG_LIST", {
    uid = CloudData.UID
  }, tFuncEvent)
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(1055, 695), cc.rect(299, 256, 1, 1)):align(display.CENTER_LEFT, -display.cx - 1120, 0):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "friends/bt_left.png"
  }):align(display.CENTER_LEFT, self.mBg:getContentSize().width, self.mBg:getContentSize().height * 0.5):addTo(self.mBg, 2):onButtonClicked(function()
    self:closeCallBack()
  end)
  local msgBg = display.newScale9Sprite("friends/img_sys_bottom.png", 0, 0, cc.size(730, 530), cc.rect(55, 39, 1, 1)):pos(643, 385):addTo(bg)
  self.mMsgFrame = msgBg
  self.mEditBg = display.newScale9Sprite("friends/img_input.png", 564, 80, cc.size(560, 57), cc.rect(33, 33, 1, 1)):addTo(bg)
  self.editBox = cc.ui.UIInput.new({
    image = "common_ui/img_square.png",
    size = cc.size(530, 40),
    x = 564,
    y = 80,
    listener = function(event, editbox)
      if event == "began" then
        self:onEditBoxBegan(editbox)
      end
    end
  })
  self.editBox:setColor(cc.c3b(255, 246, 220))
  self.editBox:setFontName(GameManager.FONTNAME_TTF)
  self.editBox:setFontSize(35)
  self.editBox:setFontColor(cc.c3b(47, 17, 8))
  self.editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  self.mBg:addChild(self.editBox)
  self.editBox:setMaxLength(60)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S574", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3),
    lineWidth = 2
  })):onButtonClicked(function()
    self:enterCallBack()
  end):align(display.CENTER, 650, 26):addTo(self.mEditBg)
  self.editMask = display.newScale9Sprite("friends/img_sys_bottom.png", 0, 0, cc.size(685, 65), cc.rect(55, 39, 1, 1)):pos(643, 84):addTo(bg):hide()
  DYLabelTTF.new({
    text = DYLang.getString("STR_CHAT_FORBID", ""),
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(140, 100, 60),
    lineWidth = 2
  }):pos(342, 32):addTo(self.editMask)
  self:initTabList()
  self:updateMsg()
  self:updateSystemMsg()
  self.mBg:moveTo(0.2, -display.cx, 0)
end

function M:initTabList()
  local listBg = display.newSprite("friends/name_list_bg.png"):pos(160, 345):addTo(self.mBg)
  self.mListBg = listBg
  local btnStrs = {
    DYLang.getString("S575", ""),
    DYLang.getString("S576", ""),
    DYLang.getString("S577", ""),
    DYLang.getString("STR_SYSTEM", "")
  }
  for i = 1, #btnStrs do
    local btn = cc.ui.UIPushButton.new({
      normal = M.CHANNEL_BTN[i]
    }):pos(listBg:getContentSize().width * 0.5, 556 - i * 50):addTo(listBg):setButtonLabel("normal", cc.ui.UILabel.new({
      text = btnStrs[i],
      size = 25,
      color = cc.c3b(80, 40, 1),
      font = GameManager.FONTNAME_TTF
    })):onButtonClicked(function()
      self:onEventChannel(i)
    end)
    if i == M.CHANNEL_SYSTEM then
      btn:setPosition(listBg:getContentSize().width * 0.5, 556)
    end
    btn.selected = display.newSprite("friends/name_sel.png", 0, 0):hide():addTo(btn)
    btn.redPoint = display.newSprite("common_ui/red_point.png", 78.5, 0):hide():scale(0.75):addTo(btn)
    if i == self.mChannel then
      GameManager.CHAT_TARGET = i
      self.mIndex = i
      self.mSelectedChannel = btn
      btn.selected:show()
      self.mMsgInfo = self.mTotalMsgList[i]
      self:loadMsgList()
    end
    if 2 == i and GameManager.CHAT_TARGET ~= 2 and CloudData.IS_NEW_UNION_CHAT then
      btn.redPoint:show()
    end
    table.insert(self.mChannelBtns, btn)
  end
end

function M:onEventChannel(idx)
  if self.mIndex == idx then
    return
  elseif 2 == idx then
    if not CloudData.UNION_ID or -1 == CloudData.UNION_ID then
      WSToast.new(DYLang.getString("S578", "")):addTo(display.getRunningScene(), 200)
      return
    end
  elseif 3 == idx and not CloudData.IS_UNION_BATTLE_OPEN then
    WSToast.new(DYLang.getString("S579", "")):addTo(display.getRunningScene(), 200)
    return
  end
  if idx == M.CHANNEL_SYSTEM then
    self.editMask:show()
    self.mEditBg:hide()
    self.editBox:hide()
  else
    self.editMask:hide()
    self.mEditBg:show()
    self.editBox:show()
  end
  self.mIndex = idx
  DDLOG("self.mIndex : %d", self.mIndex)
  if self.mSelectedChannel ~= nil then
    self.mSelectedChannel.selected:hide()
  end
  local btn = self.mChannelBtns[idx]
  self.mSelectedChannel = btn
  btn.selected:show()
  self.mChannel = idx
  self.mMsgInfo = self.mTotalMsgList[idx] or {}
  GameManager.CHAT_TARGET = idx
  if 2 == self.mChannel and btn.redPoint:isVisible() then
    CloudData.IS_NEW_UNION_CHAT = false
    btn.redPoint:hide()
  end
  self:loadMsgList()
end

function M:loadMsgList()
  if self.mListView then
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
  end
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(13, 13, 704, 504),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mMsgFrame)
  if not self.mMsgInfo or 0 == #self.mMsgInfo then
    return
  end
  for i = 1, #self.mMsgInfo do
    local msgInfo = self.mMsgInfo[i]
    local item = self.mListView:newItem()
    local content
    local h = 140
    if self.mChannel == M.CHANNEL_SYSTEM then
      content, h = self:getSystemMsgContent(msgInfo)
    elseif msgInfo.uid == CloudData.UID then
      content = self:getSelfMsgContent(msgInfo)
    else
      content = self:getOtherMsgContent(msgInfo)
    end
    item:addContent(content)
    item:setItemSize(704, h)
    self.mListView:addItem(item)
  end
  self.mListView:reload()
  self:adjustListView()
end

function M:getSelfMsgContent(msgInfo)
  local content = display.newNode()
  content:setContentSize(700, 130)
  content:setAnchorPoint(0.5, 0.5)
  local chatType = display.newSprite(M.CHANNEL_TAGS[self.mChannel]):align(display.TOP_RIGHT, content:getContentSize().width - 5, content:getContentSize().height):addTo(content)
  DYLabelTTF.new({
    text = DYLang.getString("S580", ""),
    size = 24,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "TOP_RIGHT"
  }):pos(chatType:getPositionX() - chatType:getContentSize().width - 3, chatType:getPositionY() - 5):addTo(content)
  local iconFrame = display.newSprite("friends/img_friend_box.png"):scale(0.75):align(display.CENTER_RIGHT, content:getContentSize().width, content:getContentSize().height * 0.35):addTo(content)
  display.newSprite(CloudData.USER_ICON):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  local msgLabel = cc.ui.UILabel.new({
    text = msgInfo.content,
    size = 22,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.TOP_RIGHT, 0, 0)
  local bubbleW = 78
  local bubbleH = 48
  local maxTextW = 506
  local fontSize = 22
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
  local msgFrame = display.newScale9Sprite("friends/img_talk_02.png", 0, 0, cc.size(wid, hei), cc.rect(35, 32, 1, 1)):align(display.TOP_RIGHT, iconFrame:getPositionX() - 94, 82):addTo(content)
  msgLabel:addTo(msgFrame)
  return content
end

function M:getOtherMsgContent(msgInfo)
  local content = display.newNode()
  content:setContentSize(700, 130)
  content:setAnchorPoint(0.5, 0.5)
  local server = ""
  local union = ""
  local pos = 0
  if 2 == self.mChannel then
    pos = msgInfo.clan_rank
  end
  if 3 == self.mChannel then
    server = msgInfo.server_name
    union = msgInfo.clan_name
    pos = msgInfo.clan_rank
  end
  local chatType = display.newSprite(M.CHANNEL_TAGS[self.mChannel]):align(display.TOP_LEFT, 5, content:getContentSize().height):addTo(content)
  local lb1 = DYLabelTTF.new({
    text = server,
    size = 21,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "TOP_LEFT"
  }, {}):pos(chatType:getContentSize().width + 9, chatType:getPositionY() - 5):addTo(content, 1)
  local lb2 = DYLabelTTF.new({
    text = msgInfo.nick,
    size = 22,
    color = cc.c3b(207, 0, 220),
    font = GameManager.FONTNAME_TTF,
    dyalign = "TOP_LEFT"
  }):pos(lb1:getPositionX() + lb1:getContentSize().width, lb1:getPositionY()):addTo(content)
  if server ~= "" then
    display.newSprite("friends/lb_frame.png"):align(display.CENTER_LEFT, -8, lb1:getPositionY() - 12):addTo(content, 0)
    lb2:setPositionX(lb1:getPositionX() + lb1:getContentSize().width + 12)
  end
  local lb3 = DYLabelTTF.new({
    text = union,
    size = 22,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "TOP_LEFT"
  }, {}):pos(lb2:getPositionX() + lb2:getContentSize().width, lb1:getPositionY()):addTo(content)
  local tb = {
    " [\230\136\144\229\145\152] ",
    " [\233\149\191\232\128\129] ",
    " [\228\187\153\229\176\138] "
  }
  local textStr = tb[pos] or ""
  local lb4 = DYLabelTTF.new({
    text = textStr,
    size = 22,
    color = cc.c3b(250, 237, 31),
    font = GameManager.FONTNAME_TTF,
    dyalign = "TOP_LEFT"
  }, {}):pos(lb3:getPositionX() + lb3:getContentSize().width, lb1:getPositionY()):addTo(content)
  DYLabelTTF.new({
    text = DYLang.getString("S581", ""),
    size = 24,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "TOP_LEFT"
  }):pos(lb4:getPositionX() + lb4:getContentSize().width, lb1:getPositionY()):addTo(content)
  local iconFrame = display.newSprite("friends/img_friend_box.png"):scale(0.75):align(display.CENTER_LEFT, 0, content:getContentSize().height * 0.35):addTo(content)
  display.newSprite(GameManager.USER_ICON_PATH .. msgInfo.icon .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  local params = {
    nick = msgInfo.nick,
    level = msgInfo.level,
    icon = msgInfo.icon,
    uid = msgInfo.uid,
    isOnline = msgInfo.is_online,
    channel = self.mChannel
  }
  iconFrame:setTouchEnabled(true)
  iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if "began" == event.name then
      LayerChatOperate.new(params, handler(self, self.onEventOperateListener)):addTo(self, 20)
      return true
    end
  end)
  local msgLabel = cc.ui.UILabel.new({
    text = msgInfo.content,
    size = 22,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.TOP_LEFT, 0, 0)
  local bubbleW = 78
  local bubbleH = 48
  local maxTextW = 506
  local fontSize = 22
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
  local msgFrame = display.newScale9Sprite("friends/img_talk_01.png", 0, 0, cc.size(wid, hei), cc.rect(35, 32, 1, 1)):align(display.TOP_LEFT, iconFrame:getPositionX() + 94, 82):addTo(content)
  msgLabel:addTo(msgFrame)
  return content
end

function M:getSystemMsgContent(msgInfo)
  local maxTextW = 576
  local dimenTextW = 660
  local contentH = 50
  local content = display.newNode()
  content:setAnchorPoint(0.5, 0.5)
  local str = "              " .. checkstring(msgInfo)
  local msgLabel = cc.ui.UILabel.new({
    text = str,
    size = 24,
    color = cc.c3b(140, 100, 60),
    font = GameManager.FONTNAME_TTF
  }):align(display.TOP_LEFT, 0, 0)
  local w, h = msgLabel:getContentSize().width, msgLabel:getContentSize().height
  if maxTextW < w then
    msgLabel:setDimensions(dimenTextW, 0)
    dimenTextW = msgLabel:getContentSize().width
    local hei = msgLabel:getContentSize().height
    contentH = hei + 26
  end
  msgLabel:setPosition(18, contentH - 15)
  content:setContentSize(700, contentH)
  local msgFrame = display.newScale9Sprite("friends/img_sys_box.png", 0, 0, cc.size(700, contentH), cc.rect(25, 25, 1, 1)):align(display.CENTER, 350, contentH / 2):addTo(content)
  msgLabel:addTo(msgFrame)
  display.newSprite(M.CHANNEL_TAGS[self.mChannel]):align(display.TOP_LEFT, 12, contentH - 10):addTo(content)
  return content, contentH + 3
end

function M:addMsgItem(msgInfo)
  local listView = self.mListView
  local item = listView:newItem()
  local content
  local h = 140
  if self.mChannel == M.CHANNEL_SYSTEM then
    content, h = self:getSystemMsgContent(msgInfo)
  elseif msgInfo.uid == CloudData.UID then
    content = self:getSelfMsgContent(msgInfo)
  else
    content = self:getOtherMsgContent(msgInfo)
  end
  content:setAnchorPoint(0, 0)
  item:addContent(content)
  item:setItemSize(704, h)
  listView:addItem(item)
  local y = listView.container:getPositionY()
  listView:reload()
  if listView.size.height > listView:getViewRect().height then
    if -10 < y then
      listView.container:setPositionY(0)
    else
      listView.container:setPositionY(y - h)
    end
  end
  table.insert(self.mMsgInfo, msgInfo)
end

function M:onEventOperateListener(params)
end

function M:adjustListView()
  if self.mListView.size.height > self.mListView:getViewRect().height then
    self.mListView.container:setPositionY(0)
  end
end

function M:updateMsg()
  local function tFuncUpdate()
    DDLOG("=========== MSG UPDATE")
    
    local channel = CloudData.CHAT_MSG_UPDATE.channel
    if channel == self.mChannel then
      self:addMsgItem(CloudData.CHAT_MSG_UPDATE)
      if channel == M.CHANNEL_UNION then
        CloudData.IS_NEW_UNION_CHAT = false
      end
    elseif self.mTotalMsgList[channel] then
      table.insert(self.mTotalMsgList[channel], CloudData.CHAT_MSG_UPDATE)
    end
  end
  
  DYNotification.registerScriptObserver(self, tFuncUpdate, DY_KEY.kUpdateChatMsg)
end

function M:updateSystemMsg()
  local function tFuncUpdate(key, str)
    if self.mChannel == M.CHANNEL_SYSTEM then
      self:addMsgItem(str)
    end
    self.mTotalMsgList[M.CHANNEL_SYSTEM] = clone(CloudData.SYSTEM_MSG_LOG)
  end
  
  DYNotification.registerScriptObserver(self, tFuncUpdate, DY_KEY.kUpdateSystemMsg)
end

function M:onEditBoxBegan(editbox)
  self.editBox:setText("")
end

function M:enterCallBack()
  if CloudData.USER_LEVEL < M.CHAT_LEVEL then
    WSToast.new(string.format("\229\189\147\229\137\141\233\162\145\233\129\147\231\173\137\231\186\167\233\156\128\229\136\176\232\190\190%d\231\186\167\230\137\141\232\131\189\229\143\145\232\168\128", M.CHAT_LEVEL)):addTo(display.getRunningScene(), 200)
    return
  end
  local text = self.editBox:getText()
  if text == nil or text == "" then
    local t = WSToast.new(DYLang.getString("S582", ""), 2)
    display.getRunningScene():addChild(t, 250)
    return
  elseif not DataUtils.isChatLegal(text) then
    local t = WSToast.new(DYLang.getString("S583", ""), 2)
    display.getRunningScene():addChild(t, 250)
    return
  else
    self:sendMsg(text)
  end
end

function M:sendMsg(text)
  self.editBox:setText("")
  local msgInfo = {
    uid = CloudData.UID,
    content = text
  }
  local receiverId = 0
  local params = {
    content = text,
    channel = self.mChannel,
    receiver = receiverId
  }
  self:safeSocketRequest("CMD_SEND_CHAT_MSG", params)
  self:addMsgItem(msgInfo)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if not self.mBg then
    if self then
      self:runAction(cc.RemoveSelf:create())
    end
    return
  end
  self.mBg:runAction(transition.sequence({
    cc.MoveTo:create(0.2, cc.p(-display.cx - 1120, 0)),
    cc.CallFunc:create(function()
      GameManager.CHAT_TARGET = 0
      if self.mCallback then
        self.mCallback()
      end
      self:runAction(cc.RemoveSelf:create())
    end)
  }))
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYNotification.removeAllObservers(self)
end

return M

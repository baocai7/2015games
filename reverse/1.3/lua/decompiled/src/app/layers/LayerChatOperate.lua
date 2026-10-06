local LayerWaitPkApply = require("app.layers.LayerWaitPkApply")
local LayerFriends = require("app.friend.LayerFriends")
local LayerToAddFriend = require("app.friend.LayerToAddFriend")
local CLASS_NAME = "LayerChatOperate"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(params, callback)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self.mCallback = callback
  self:initData(params)
  self:initUI()
end

function M:initData(params)
  self.mParams = params
  self.mName = params.nick
  self.mLevel = params.level
  self.mIcon = GameManager.USER_ICON_PATH .. params.icon .. ".png"
end

function M:initUI()
  local bg = display.newSprite("friends/func_frame.png"):addTo(self.mNode)
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):pos(90, bg:getContentSize().height * 0.5):addTo(bg)
  display.newSprite(self.mIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  DYLabelTTF.new({
    text = "Lv." .. self.mLevel,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "BOTTOM_RIGHT"
  }, {}):pos(iconFrame:getContentSize().width, 0):addTo(iconFrame)
  DYLabelTTF.new({
    text = self.mName,
    size = 30,
    color = cc.c3b(73, 44, 10),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(100 + iconFrame:getContentSize().width * 0.5, 122):addTo(bg)
  local btnImg = {
    "friends/btn_fight.png",
    "friends/btn_add.png",
    "union/btn_chat.png"
  }
  for i = 1, #btnImg do
    local btn = cc.ui.UIPushButton.new({
      normal = btnImg[i],
      pressed = btnImg[i]
    }):pos(200 + 94 * (i - 1), 57):onButtonPressed(function(event)
      event.target:setScale(0.9)
    end):onButtonRelease(function(event)
      event.target:setScale(1)
    end):onButtonClicked(function()
      self:buttonListener(i)
    end):addTo(bg)
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.7):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.97, bg:getContentSize().height * 0.94):addTo(bg, 2)
end

function M:onEventListenerPK()
  local time = os.time() - CloudData.SEND_PK_TIME
  if time < CloudData.PK_ACTIVE_TIME then
    local t = CloudData.PK_ACTIVE_TIME - time
    local msg = DYLang.getString("S1715", "") .. t .. DYLang.getString("S1716", "")
    local toast = WSToast.new(msg, 2)
    self:addChild(toast, 20)
    return
  elseif GameManager.IS_USER_BUSY == 1 then
    local msg = DYLang.getString("S1717", "")
    local toast = WSToast.new(msg, 2)
    self:addChild(toast, 20)
    return
  end
  
  local function tFuncEvent(param)
    local errorCode = tonumber(param.errorCode) or 1
    if errorCode ~= 0 then
      local msg = param.errorMsg or "UNKNOWN"
      WSToast.new(msg):addTo(display.getRunningScene(), 100)
      GameManager.IS_USER_BUSY = 0
    else
      GameManager.IS_USER_BUSY = 1
      LayerWaitPkApply.new(self.mParams):addTo(display.getRunningScene(), 20)
    end
  end
  
  local param = {
    receiver = self.mParams.uid,
    nick = CloudData.USER_NAME,
    uid = CloudData.UID
  }
  self:safeSocketRequest("CMD_FRIEND_PK_APPLY", param, tFuncEvent)
end

function M:onEventListenerFriend()
  LayerToAddFriend.new(self.mParams.uid, nil):addTo(display.getRunningScene(), 20)
end

function M:onEventListenerChat()
  local uid = self.mParams.uid
  DataUtils.newRecentItem(uid)
  local nextScene = LayerFriends.scene(nil, 1, {index = 2, uid = uid})
  display.replaceScene(nextScene)
end

function M:buttonListener(tag)
  if CloudData.USER_LEVEL < Const.FUNC_UNLOCK.friend then
    WSToast.new(DYLang.getString("STR_FUNC_FRIEND", "") .. Const.FUNC_UNLOCK.friend .. DYLang.getString("S1211", "")):addTo(self, 50)
    return
  end
  local tFunc = {
    [1] = function()
      self:onEventListenerPK()
    end,
    [2] = function()
      self:onEventListenerFriend()
    end,
    [3] = function()
      self:onEventListenerChat()
    end
  }
  tFunc[tag]()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:runAction(cc.RemoveSelf:create())
    end)
  })
  self.mNode:runAction(popupLayer)
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
end

return M

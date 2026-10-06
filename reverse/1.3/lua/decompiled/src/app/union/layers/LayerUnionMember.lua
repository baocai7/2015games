local LayerCommon = require("app.union.layers.LayerCommon")
local PanelMember = require("app.union.panel.PanelMember")
local LayerWaitPkApply = require("app.layers.LayerWaitPkApply")
local LayerFriends = require("app.friend.LayerFriends")
local TAG_SEND_FRIENDS_PK_APPLY = "tag_send_friends_pk_apply"
local CLASS_NAME = "LayerUnionMember"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.EVENT_CHAT = 1
M.EVENT_PK = 2
M.EVENT_TEAM = 3
M.EVENT_APPOINT = 4
M.EVENT_DISMISS = 5
M.EVENT_ABDICATE = 6
M.EVENT_RESIGN = 7
M.EVENT_EXPEL = 8
M.EVENT_QUIT = 9

function M:ctor(params, callback)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mEmptyNode = display.newNode()
  self.mEmptyNode:setPosition(display.cx, display.cy)
  self:addChild(self.mEmptyNode)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newScale9Sprite("pvp_ol/bg_competeInfo.png", 0, -20, cc.size(1080, 680), cc.rect(400, 300, 1, 1)):addTo(self.mEmptyNode)
  self.mBg = bg
  local titleFrame = display.newSprite("common_ui/title_frame.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height - 15):addTo(bg)
  display.newSprite("union/title_member.png"):pos(titleFrame:getContentSize().width * 0.5, titleFrame:getContentSize().height * 0.55):addTo(titleFrame)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.96, bg:getContentSize().height * 0.96):addTo(bg, 2)
  local listFrame = display.newScale9Sprite("union/common_frame.png", 537, 315, cc.size(970, 522), cc.rect(40, 40, 1, 1)):addTo(self.mBg)
  self.mListFrame = listFrame
  local curNum = CloudData.UNION_INFO.cur_count
  local maxNum = CloudData.UNION_INFO.max_count
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S1710", ""),
    size = 24,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "TOP_LEFT"
  }):pos(15, 550):addTo(listFrame)
  self.mCountLabel = DYLabelTTF.new({
    text = curNum .. "/" .. maxNum,
    size = 24,
    color = cc.c3b(30, 255, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "TOP_LEFT"
  }, {}):pos(lb1:getPositionX() + lb1:getContentSize().width, lb1:getPositionY()):addTo(listFrame)
  self:loadMemberList()
end

function M:loadMemberList()
  self.node = nil
  local memberList = CloudData.UNION_MEMBERS
  table.sort(memberList, function(v1, v2)
    if v1.online == v2.online then
      if v1.rank == v2.rank then
        if v1.level == v2.level then
          return v1.vip > v2.vip
        else
          return v1.level > v2.level
        end
      else
        return v1.rank > v2.rank
      end
    else
      return v1.online > v2.online
    end
  end)
  if self.mListView then
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
  end
  local listView = cc.ui.UIListView.new({
    async = true,
    viewRect = cc.rect(15, 11, 940, 500),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mListFrame)
  self.mListView = listView
  
  local function tFuncDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
      return #memberList
    else
      if cc.ui.UIListView.CELL_TAG == tag then
        local item = listView:dequeueItem()
        local content
        if not item then
          item = listView:newItem()
        else
          content = item:getContent()
          content:removeFromParent()
        end
        content = PanelMember.new(self, memberList[idx], handler(self, self.funcEventListener))
        item:addContent(content)
        item:setItemSize(940, 155)
        return item
      else
      end
    end
  end
  
  listView:setDelegate(tFuncDelegate)
  listView:reload()
end

function M:funcEventListener(tag, params)
  local tFunc = {
    [1] = function()
      self:chatCallback(params)
    end,
    [2] = function()
      self:pkCallback(params)
    end,
    [3] = function()
      self:teamCallback(params)
    end,
    [4] = function()
      self:onEventAppointMember(params)
    end,
    [5] = function()
      self:onEventDismissManager(params)
    end,
    [6] = function()
      self:onEventAbdicateLeader(params)
    end,
    [7] = function()
      self:onEventResignManager(params)
    end,
    [8] = function()
      self:onEventExpelMember(params)
    end,
    [9] = function()
      self:onEventQuitUnion(params)
    end
  }
  tFunc[tag]()
end

function M:chatCallback(params)
  DDLOG("=========== \232\129\138\229\164\169")
  if CloudData.USER_LEVEL < 10 then
    WSToast.new(DYLang.getString("S1711", "")):addTo(self, 20)
    return
  end
  if CloudData.UID == tonumber(params.uid) then
    WSToast.new(DYLang.getString("S1712", "")):addTo(self, 20)
    return
  end
  if CloudData.USER_LEVEL < Const.FUNC_UNLOCK.friend then
    WSToast.new(DYLang.getString("STR_FUNC_FRIEND", "") .. Const.FUNC_UNLOCK.friend .. DYLang.getString("S1211", "")):addTo(self, 50)
    return
  end
  local uid = params.uid
  DataUtils.newRecentItem(uid)
  LayerFriends.new(nil, 1, {index = 2, uid = uid}):addTo(display.getRunningScene(), 20)
end

function M:pkCallback(params)
  DDLOG("=========== \229\136\135\231\163\139")
  if CloudData.UID == tonumber(params.uid) then
    WSToast.new(DYLang.getString("S1714", "")):addTo(self, 20)
    return
  end
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
    dump(param)
    local errorCode = tonumber(param.errorCode) or 1
    if errorCode ~= 0 then
      local msg = param.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
      GameManager.IS_USER_BUSY = 0
    else
      GameManager.IS_USER_BUSY = 1
      LayerWaitPkApply.new(params):addTo(self, 20)
    end
  end
  
  local param = {
    receiver = params.uid,
    nick = CloudData.USER_NAME,
    uid = CloudData.UID
  }
  self:safeSocketRequest("CMD_FRIEND_PK_APPLY", param, tFuncEvent)
end

function M:teamCallback(params)
  DDLOG("=========== \230\159\165\231\156\139\233\152\159\228\188\141\228\191\161\230\129\175")
  local teamInfo = json.decode(params.team)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  local pMaskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 20)
  local bg = display.newSprite("ranking/bg_team.png", display.cx, display.cy):scale(0):addTo(self, 21)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  bg:runAction(popupLayer)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0, 1),
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        pMaskLayer:removeSelf()
        bg:removeSelf()
      end)
    })
    bg:runAction(popupLayer)
  end):align(display.CENTER, bg:getContentSize().width * 0.96, bg:getContentSize().height * 0.95):addTo(bg)
  if teamInfo == nil or #teamInfo == 0 then
    return
  end
  for i = 1, #teamInfo do
    local buddhaInfo = teamInfo[i]
    local buddhaModel = DataUtils.getOtherPlayerTeamInfo(buddhaInfo)
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality)):scale(0.95):pos(bg:getContentSize().width * (0.15 * i - 0.1) + 55, bg:getContentSize().height * 0.55):addTo(bg)
    local icon = display.newSprite(buddhaModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    if 0 == buddhaModel.isRebel then
      icon:setScaleX(-1)
    end
    DYLabelTTF.new({
      text = "LV." .. buddhaModel.level,
      size = 24,
      color = cc.c3b(101, 58, 8),
      font = GameManager.FONTNAME_TTF
    }):pos(iconFrame:getPositionX(), iconFrame:getPositionY() - 70):addTo(bg)
    display.newSprite(string.format("upgrade/star%d.png", buddhaModel.starLevel)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame)
  end
end

function M:onEventAppointMember(params)
  DDLOG("=========== \228\187\187\229\145\189")
  
  local function onEventAppoint()
    local function tFuncEvent(param)
      DDLOG(" ================ APPOINT_MEMBER !!!!!!!")
      
      if 0 == param.ret_code then
        params.rank = 2
        self:loadMemberList()
      else
        local errMsg = param.err_msg or "UNKNOWN"
        WSToast.new(errMsg):addTo(self, 20)
      end
    end
    
    self:safeSocketRequest("CMD_APPOINT_MEMBER", {
      new_rank = 2,
      target_id = params.uid
    }, tFuncEvent)
  end
  
  local title = "union/title_appoint.png"
  local text = string.format(DYLang.getString("S1718", ""), params.nick)
  LayerCommon.new({title = title, text = text}, onEventAppoint):addTo(self, 20)
end

function M:onEventDismissManager(params)
  DDLOG("=========== \231\189\162\229\133\141")
  
  local function onEventDismiss()
    local function tFuncEvent(param)
      DDLOG(" ================ DISMISS_MEMBER !!!!!!!")
      
      if 0 == param.ret_code then
        params.rank = 1
        self:loadMemberList()
      else
        local errMsg = param.err_msg or "UNKNOWN"
        WSToast.new(errMsg):addTo(self, 20)
      end
    end
    
    self:safeSocketRequest("CMD_APPOINT_MEMBER", {
      new_rank = 1,
      target_id = params.uid
    }, tFuncEvent)
  end
  
  local title = "union/title_appoint.png"
  local text = string.format(DYLang.getString("S1719", ""), params.nick)
  LayerCommon.new({title = title, text = text}, onEventDismiss):addTo(self, 20)
end

function M:onEventAbdicateLeader(params)
  DDLOG("=========== \232\189\172\232\174\169\228\187\153\229\176\138")
  
  local function onEventAbdicate()
    local function tFuncEvent(param)
      DDLOG(" ================ ABDICATE_LEADER !!!!!!!")
      
      dump(param, "event \239\188\154", 5)
      if 0 == param.ret_code then
        CloudData.UNION_POS = 1
        params.rank = 3
        self:loadMemberList()
      else
        local errMsg = param.err_msg or "UNKNOWN"
        WSToast.new(errMsg):addTo(self, 20)
      end
    end
    
    self:safeSocketRequest("CMD_ABDICATE_LEADER", {
      target_id = params.uid
    }, tFuncEvent)
  end
  
  local title = "union/title_appoint.png"
  local text = string.format(DYLang.getString("S1720", ""), params.nick)
  LayerCommon.new({title = title, text = text}, onEventAbdicate):addTo(self, 20)
end

function M:onEventResignManager(params)
  DDLOG("=========== \229\137\175\228\187\153\229\176\138\232\190\158\232\129\140")
  
  local function onEventResign()
    local function tFuncEvent(param)
      DDLOG(" ================ RESIGN_MANAGER !!!!!!!")
      
      if 0 == param.ret_code then
        CloudData.UNION_POS = 1
        params.rank = 1
        self:loadMemberList()
      else
        local errMsg = param.err_msg or "UNKNOWN"
        WSToast.new(errMsg):addTo(self, 20)
      end
    end
    
    self:safeSocketRequest("CMD_RESIGN_MANAGER", nil, tFuncEvent)
  end
  
  local title = "union/title_appoint.png"
  local text = string.format(DYLang.getString("S1721", ""))
  LayerCommon.new({title = title, text = text}, onEventResign):addTo(self, 20)
end

function M:onEventExpelMember(params)
  DDLOG("=========== \229\137\148\233\153\164\230\136\144\229\145\152")
  
  local function onEventExpel()
    local function tFuncEvent(param)
      DDLOG(" ================ EXPEL_MEMBER !!!!!!!")
      
      if 0 == param.ret_code then
        table.removebyvalue(CloudData.UNION_MEMBERS, params)
        CloudData.UNION_INFO.cur_count = CloudData.UNION_INFO.cur_count - 1
        self.mCountLabel:setString(CloudData.UNION_INFO.cur_count .. "/" .. CloudData.UNION_INFO.max_count)
        self:loadMemberList()
      else
        local errMsg = param.err_msg or "UNKNOWN"
        WSToast.new(errMsg):addTo(self, 20)
      end
    end
    
    self:safeSocketRequest("CMD_EXPEL_MEMBER", {
      target_id = params.uid
    }, tFuncEvent)
  end
  
  local title = "union/title_quit.png"
  local text = string.format(DYLang.getString("S1722", ""), params.nick)
  LayerCommon.new({title = title, text = text}, onEventExpel):addTo(self, 20)
end

function M:onEventQuitUnion(params)
  DDLOG("=========== \233\128\128\229\135\186\228\187\153\229\186\156")
  
  local function onEventQuit()
    local function tFuncEvent(param)
      DDLOG(" ================ QUIT_UNION !!!!!!!")
      
      if 0 == param.ret_code then
        CloudData.UNION_ID = -1
        CloudData.UNION_BOSS_LEVEL = {}
        display.replaceScene(require("app.scenes.ChapterScene").new(), "fade", 0.2)
      else
        local errMsg = param.err_msg or "UNKNOWN"
        WSToast.new(errMsg):addTo(self, 20)
      end
    end
    
    self:safeSocketRequest("CMD_QUIT_UNION", nil, tFuncEvent)
  end
  
  local title = "union/title_quit.png"
  local text = string.format(DYLang.getString("S1723", ""))
  LayerCommon.new({title = title, text = text}, onEventQuit):addTo(self, 20)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
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

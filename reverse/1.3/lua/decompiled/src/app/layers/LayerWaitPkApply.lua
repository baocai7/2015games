local CLASS_NAME = "LayerWaitPkApply"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local TAG_PK_CANCEL_SENDER = "tag_pk_cancel_sender"
local TAG_PK_RESPOND_SENDER = "tag_pk_respond_sender"
local TAG_EVENT_FIGHT_SENDER = "tag_event_fight_sender"
local TAG_PK_REFUSE_SENDER = "tag_pk_refuse_sender"

function M:ctor(info)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mWidget = nil
  self.mPanelRoot = nil
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mInfo = info or {}
  self.mFriendName = self.mInfo.nick or "  "
  self.mFriendUid = self.mInfo.uid
  self:layoutUI()
  self:waitRespondAgree()
  self:waitRespondFefuse()
  self:readyForFight()
  self:addRegister()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:layoutUI()
  self:addWidget()
  self:startCountDown()
end

function M:addWidget()
  local node = self.mNode
  local widget = cc.uiloader:load("ui/LayerFriendPkApply.csb")
  widget:addTo(node)
  self.mWidget = widget
  local panelRoot = cc.uiloader:seekNodeByName(widget, "PanelRoot")
  panelRoot:setPosition(dy.p(0, 0))
  self.mPanelRoot = panelRoot
  local panelMask = cc.uiloader:seekNodeByName(widget, "PanelMask")
  panelMask:setPosition(dy.p(-640, -360))
  local textStr = cc.uiloader:seekNodeByName(widget, "TextStr")
  textStr:setString(DYLang.getString("S1044", "") .. self.mFriendName .. DYLang.getString("S1045", ""))
  self.mButtonCancel = cc.uiloader:seekNodeByName(widget, "Button1")
  self.mButtonCancel:setPositionX(299)
  self.mButtonCancel:addTouchEventListener(handler(self, self.buttonListener))
  local textCancel = cc.uiloader:seekNodeByName(widget, "TextButton1")
  textCancel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  textCancel:setString(DYLang.getString("S1046", ""))
  local button2 = cc.uiloader:seekNodeByName(widget, "Button2")
  button2:runAction(cc.RemoveSelf:create())
  local btnClose = cc.uiloader:seekNodeByName(widget, "ButtonClose")
  btnClose:runAction(cc.RemoveSelf:create())
  self.mTimeLabel = cc.ui.UILabel.new({
    text = "",
    size = 20,
    color = cc.c3b(16, 250, 60),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 105, -125):addTo(panelRoot)
  self.mTimeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:buttonListener(sender, eventType)
  if ccui.TouchEventType.began == eventType then
    sender:setScale(0.95)
  elseif ccui.TouchEventType.ended == eventType then
    sender:setScale(1)
    if sender == self.mButtonCancel then
      self:cancelCallback()
    end
  elseif ccui.TouchEventType.canceled == eventType then
    sender:setScale(1)
  end
end

function M:cancelCallback()
  self.mButtonCancel:setEnabled(false)
  self:safeSocketRequest("CMD_FRIEND_PK_CANCEL", {
    receiver = self.mFriendUid,
    uid = CloudData.UID
  })
end

function M:cancelPk()
  GameManager.IS_USER_BUSY = 0
  self:safeSocketCancel("CMD_FRIEND_PK_RECEIVE")
  self:safeSocketCancel("CMD_FRIEND_PK_REFUSE")
  self:safeSocketCancel("CMD_FIGHT")
  self:closeCallBack()
end

function M:addRegister()
  DYNotification.registerScriptObserver(self, handler(self, self.cancelPk), DY_KEY.kPkApplyCancel)
end

function M:waitRespondAgree()
  local function tFuncEvent(param)
    dump(param)
    
    local errorCode = tonumber(param.errorCode) or 1
    if errorCode ~= 0 then
      local errorMsg = param.errorMsg or "UNKNOWN"
      local t = WSToast.new(errorMsg)
      display.getRunningScene():addChild(t, 250)
      GameManager.IS_USER_BUSY = 0
    end
    self:closeCallBack()
  end
  
  self:safeSocketListen("CMD_FRIEND_PK_RECEIVE", tFuncEvent, true)
end

function M:waitRespondFefuse()
  local function tFuncEvent(param)
    dump(param)
    
    GameManager.IS_USER_BUSY = 0
    local errorCode = tonumber(param.errorCode) or 1
    if errorCode ~= 0 then
      local errorMsg = param.errorMsg or "UNKNOWN"
      local t = WSToast.new(errorMsg)
      display.getRunningScene():addChild(t, 250)
    else
      local msg = DYLang.getString("S1047", "")
      local t = WSToast.new(msg)
      display.getRunningScene():addChild(t, 250)
    end
    self:closeCallBack()
  end
  
  self:safeSocketListen("CMD_FRIEND_PK_REFUSE", tFuncEvent, true)
end

function M:readyForFight()
  local function tFuncEvent(param)
    DDLOG(" ================ on Fight !!!!!!!")
    
    GameManager.MODE = 6
    GameManager.IS_FRIEND_PK = 1
    CloudData.COMPETE_MODE = 1
    local buddhaData = param.self_user_data
    local enemyData = param.enemy_user_data
    CloudData.FIGHT_SEED = param.fight_seed
    CloudData.FIGHT_PRIORITY = param.priority
    CloudData.ENEMY_INFO = {
      icon = GameManager.USER_ICON_PATH .. enemyData.icon .. ".png",
      userName = enemyData.nick,
      pvpData = param.enemy_pvp_data
    }
    local cimeliaAtk = buddhaData.attackCimelia
    local cimeliaDef = buddhaData.defenseCimelia
    local buddhaList = buddhaData.buddhaList
    local treasureList = buddhaData.treasureList
    CloudData.BUDDHA_CIMELIA_INFO = {atkCimelia = cimeliaAtk, defCimelia = cimeliaDef}
    CloudData.BUDDHA_ATTACK_TEAM = buddhaData.attackTeam
    CloudData.BUDDHA_ASSIST_TEAM = buddhaData.helpTeam
    CloudData.BUDDHA_EQUIPMENTS = buddhaData.equipmentMap
    CloudData.BUDDHA_TREASURE_INFO = {}
    CloudData.BUDDHA_NPC_INFO = {}
    for k, v in pairs(treasureList) do
      CloudData.BUDDHA_TREASURE_INFO[v.treasureId] = v.quality
    end
    for k, v in pairs(buddhaList) do
      CloudData.BUDDHA_NPC_INFO[tostring(v.id)] = {
        level = v.level,
        id = v.id,
        status = v.status,
        star = v.star,
        realStar = v.real_star,
        skills = v.skills,
        realLevel = v.real_level,
        arousals = v.arousals,
        equipments = v.equipments
      }
    end
    local cimeliaAtk = enemyData.attackCimelia
    local cimeliaDef = enemyData.defenseCimelia
    local buddhaList = enemyData.buddhaList
    local treasureList = enemyData.treasureList
    CloudData.ENEMY_CIMELIA_INFO = {atkCimelia = cimeliaAtk, defCimelia = cimeliaDef}
    CloudData.ENEMY_ATTACK_TEAM = enemyData.attackTeam
    CloudData.ENEMY_ASSIST_TEAM = enemyData.helpTeam
    CloudData.ENEMY_EQUIPMENTS = enemyData.equipmentMap or {}
    CloudData.ENEMY_TREASURE_INFO = {}
    CloudData.ENEMY_NPC_INFO = {}
    for k, v in pairs(treasureList) do
      CloudData.ENEMY_TREASURE_INFO[v.treasureId] = v.quality
    end
    for k, v in pairs(buddhaList) do
      CloudData.ENEMY_NPC_INFO[tostring(v.id)] = {
        level = v.level,
        id = v.id,
        status = v.status,
        star = v.star,
        realStar = v.real_star,
        skills = v.skills,
        realLevel = v.real_level,
        arousals = v.arousals,
        equipments = v.equipments
      }
    end
    CloudData.BUDDHA_UNION_BOSS = buddhaData.m_boss_level
    CloudData.ENEMY_UNION_BOSS = enemyData.m_boss_level
    self:performWithDelay(function()
      display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE", "NORMAL"))
      DYAnalyze.event.onEvent("start_pk_0", DYLang.getString("S1049", ""))
    end, 0.2)
  end
  
  self:safeSocketListen("CMD_FIGHT", tFuncEvent, true)
end

function M:startCountDown()
  self.mLastTime = CloudData.PK_ACTIVE_TIME
  self.schedule = self:schedule(function()
    self.mTimeLabel:setString(string.format("(%d)", self.mLastTime))
    self:updateSecond()
  end, 1)
end

function M:updateSecond()
  if self.mLastTime > 0 then
    self.mLastTime = self.mLastTime - 1
    self.mTimeLabel:setString(string.format("(%d)", self.mLastTime))
  else
    self:countdownOver()
  end
end

function M:countdownOver()
  self:stopAction(self.schedule)
  GameManager.IS_USER_BUSY = 0
  self:cancelCallback()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:cancelCallback()
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

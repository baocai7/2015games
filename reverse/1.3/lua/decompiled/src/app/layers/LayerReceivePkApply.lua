local CLASS_NAME = "LayerReceivePkApply"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local TAG_PK_AGREE_RECEIVER = "tag_pk_agree_receiver"
local TAG_PK_REFUSE_RECEIVER = "tag_pk_refuse_receiver"
local TAG_EVENT_FIGHT_RECEIVER = "tag_event_fight_receiver"

function M:ctor(info)
  GameManager.IS_USER_BUSY = 1
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mWidget = nil
  self.mPanelRoot = nil
  self.mLastTime = 0
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mInfo = info or {}
  self.mFriendName = self.mInfo.nick or "  "
  self.mTouchEnabled = true
  self:layoutUI()
  self:readyForFight()
  self:addRegister()
  self:startCountDown()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:layoutUI()
  self:addWidget()
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
  textStr:setString(self.mFriendName .. DYLang.getString("S865", ""))
  self.mBtnAgree = cc.uiloader:seekNodeByName(widget, "Button1")
  self.mBtnAgree:addTouchEventListener(handler(self, self.buttonListener))
  local textAgree = cc.uiloader:seekNodeByName(widget, "TextButton1")
  textAgree:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  self.mBtnRefuse = cc.uiloader:seekNodeByName(widget, "Button2")
  self.mBtnRefuse:addTouchEventListener(handler(self, self.buttonListener))
  local textRefuse = cc.uiloader:seekNodeByName(widget, "TextButton2")
  textRefuse:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  self.mBtnClose = cc.uiloader:seekNodeByName(widget, "ButtonClose")
  self.mBtnClose:addTouchEventListener(handler(self, self.buttonListener))
  self.mTimeLabel = cc.ui.UILabel.new({
    text = "",
    size = 20,
    color = cc.c3b(16, 250, 60),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 225, -125):addTo(panelRoot)
  self.mTimeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:buttonListener(sender, eventType)
  if ccui.TouchEventType.began == eventType then
    sender:setScale(0.95)
  elseif ccui.TouchEventType.ended == eventType then
    sender:setScale(1)
    self.mBtnAgree:setEnabled(false)
    self.mBtnRefuse:setEnabled(false)
    if sender == self.mBtnAgree then
      self:agreeCallback()
      self.mTouchEnabled = false
      CloudData.NEW_PK_APPLY = false
      local target = display.getRunningScene().mPkBubble
      if target then
        target:updatePos()
      end
    elseif sender == self.mBtnRefuse then
      self:refuseCallback()
      self.mTouchEnabled = false
      CloudData.NEW_PK_APPLY = false
      local target = display.getRunningScene().mPkBubble
      if target then
        target:updatePos()
      end
    elseif sender == self.mBtnClose then
      self:closeCallBack()
    end
  elseif ccui.TouchEventType.canceled == eventType then
    sender:setScale(1)
  end
end

function M:agreeCallback()
  local function tFuncEvent(param)
    dump(param)
    
    local errorCode = tonumber(param.errorCode) or 1
    if errorCode ~= 0 then
      local errorMsg = param.errorMsg or "UNKNOWN"
      local t = WSToast.new(errorMsg)
      display.getRunningScene():addChild(t, 250)
      GameManager.IS_USER_BUSY = 0
    end
    self:safeSocketCancel("CMD_FIGHT")
    self:safeSocketCancel("CMD_FRIEND_PK_REFUSE")
    self:closeCallBack()
  end
  
  local param = self.mInfo
  param.uid = CloudData.UID
  self:safeSocketRequest("CMD_FRIEND_PK_RECEIVE", param, tFuncEvent)
end

function M:refuseCallback()
  local function tFuncEvent(param)
    dump(param)
    
    GameManager.IS_USER_BUSY = 0
    local errorCode = tonumber(param.errorCode) or 1
    if errorCode ~= 0 then
      local errorMsg = param.errorMsg or "UNKNOWN"
      local t = WSToast.new(errorMsg)
      display.getRunningScene():addChild(t, 250)
    end
    self:safeSocketCancel("CMD_FIGHT")
    self:safeSocketCancel("CMD_FRIEND_PK_RECEIVE")
    self:closeCallBack()
  end
  
  local param = self.mInfo
  param.uid = CloudData.UID
  self:safeSocketRequest("CMD_FRIEND_PK_REFUSE", param, tFuncEvent)
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
      DYAnalyze.event.onEvent("start_pk_0", DYLang.getString("S866", ""))
    end, 0.2)
    self:safeSocketCancel("CMD_FRIEND_PK_RECEIVE")
    self:safeSocketCancel("CMD_FRIEND_PK_REFUSE")
  end
  
  self:safeSocketListen("CMD_FIGHT", tFuncEvent, true)
end

function M:cancelPk()
  GameManager.IS_USER_BUSY = 0
  local msg = DYLang.getString("S867", "")
  local t = WSToast.new(msg)
  display.getRunningScene():addChild(t, 250)
  self:safeSocketCancel("CMD_FRIEND_PK_RECEIVE")
  self:safeSocketCancel("CMD_FRIEND_PK_REFUSE")
  self:safeSocketCancel("CMD_FIGHT")
  self:closeCallBack()
end

function M:addRegister()
  DYNotification.registerScriptObserver(self, handler(self, self.cancelPk), DY_KEY.kPkApplyCancel)
end

function M:startCountDown()
  local time = os.time()
  self.mLastTime = CloudData.PK_ACTIVE_TIME - (os.time() - CloudData.NEW_PK_TIME)
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
  self.mTouchEnabled = false
  CloudData.NEW_PK_APPLY = false
  GameManager.IS_USER_BUSY = 0
  local target = display.getRunningScene().mPkBubble
  if target then
    target:updatePos()
  end
  if self.mTouchEnabled then
    self:refuseCallback()
  else
    self:closeCallBack()
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
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

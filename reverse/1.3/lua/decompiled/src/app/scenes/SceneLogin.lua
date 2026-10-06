local DYClass = "SceneLogin"
local M = {}
M = class(DYClass, function()
  return display.newScene(DYClass)
end)
local WSToast = require("app.utils.WSToast")
local ForceUpdateLayer = require("app.layers.ForceUpdateLayer")
local SetAccountLayer = require("app.layers.LayerAccountShow")
local LayerServers = require("app.layers.LayerServers")
local LayerMaintain = require("app.layers.LayerMaintain")
local LayerUpdate = require("app.layers.LayerUpdate")
local IS_SERVER_IN_MAINTAINING = false

function M:ctor()
  DDLOG(DYClass .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mLabelVersion = nil
  self.mBtnStart = nil
  self.mNodeTencent = nil
  self.mBtnWX = nil
  self.mBtnQQ = nil
  self.mBtnServer = nil
  self.mBtnUserCenter = nil
  self.mFileInfo = {}
  self:layoutUI()
  self:addUnit("app.component.RelicsUnit")
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
  DYSoundMgr.playMusic(DY_SND.bgm_theme_night)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYNotification.removeAllObservers(self)
  DYRes.unloadFileInfo(self.mFileInfo)
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    local flag = self.mBtnServer and self.mBtnServer:hideServers()
    if not flag then
      DYCommon.tryQuit(false, function(et)
        if et.event == dy.quit.EVENT_IGNORE then
          local layer = require("app.layers.LayerQuit").new()
          layer:show()
        end
      end)
    end
    return true
  end
  return false
end

function M:layoutUI()
  self:addBg()
  self:addContent()
  self:tryUpdate()
  
  local function tFuncLogout(event)
    if event.event == dy.login.EVENT_LOGOUT_SUCC then
      DYUtils.schedule(function()
        if SocketMgr then
          SocketMgr:logout()
        end
        app:removeEventListenersByTag(app.TAG_EVENT_BACKGROUND)
        app:removeEventListenersByTag(app.TAG_EVENT_FOREGROUND)
        GameManager.IS_REGISTE_EVENT = false
        DYStat.setValueBool(DY_KEY.kIsUserLogin, false)
        DYStat.setValueStr(DY_KEY.kLoginParams, json.encode({}))
        DYSoundMgr.stopMusic()
        DYUtils.restartGame()
      end, 0.2)
    end
  end
  
  DYLoginMgr.regLogout(nil, tFuncLogout)
end

function M:addBg()
  display.newSprite("login_scene/login_bg.png", display.cx, display.cy):addTo(self)
  local logo = display.newSprite(Game.LOGO_PATH, display.width * 0.15, display.height * 0.85):scale(0.5):addTo(self, 2)
  self:addClickEvent(logo)
  display.newSprite("login_scene/game_tip.png", display.width * 0.87, display.height * 0.82):addTo(self, 2)
  display.newSprite("login_scene/game_ver.png", display.width * 0.13, display.height * 0.18):addTo(self, 2)
  local fn = "dengludonghua"
  local fi = string.format("login_scene/%s/%s.csb", fn, fn)
  DYRes.loadFileInfo(fi, self.mFileInfo)
  local armature = ccs.Armature:create(fn)
  armature:setPosition(display.width * 0.53, display.height * 0.36)
  armature:setScale(0.7)
  armature:getAnimation():play(fn)
  self:addChild(armature, 1)
  local EffectMgr = require("app.utils.EffectMgr")
  
  local function tFuncAddButterfly(px, py, delay, px0, py0)
    local anim = EffectMgr.createButterfly()
    anim:setPosition(px0, py0)
    anim:play()
    self:addChild(anim, 1)
    anim:runAction(cc.JumpTo:create(delay, cc.p(px, py), 50, 1))
  end
  
  local function tFuncAddDust(px, py, delay)
    self:performWithDelay(function()
      local psq = cc.ParticleSystemQuad:create("effects/fencheng.plist")
      psq:setRotation(90)
      psq:setOpacity(128)
      psq:setPosition(px, py)
      self:addChild(psq)
    end, delay)
  end
  
  tFuncAddButterfly(display.width * 0.2, display.height * 0.6, 12, display.width * -0.1, display.height * 0.6)
  tFuncAddButterfly(display.width * 0.9, display.height * 0.3, 10, display.width * 1.1, display.height * 0.3)
  tFuncAddDust(display.cx, display.height + 100, 0)
end

function M:addContent()
  self.mLabelVersion = cc.ui.UILabel.new({
    text = "",
    size = 24,
    font = GameManager.FONTNAME_TTF,
    color = cc.c3b(248, 234, 8)
  }):align(display.CENTER_LEFT, 10, 30):addTo(self, 2)
  self.mBtnServers = cc.ui.UIPushButton.new({
    normal = "login_scene/server_selected.png",
    pressed = "login_scene/server_selected.png"
  }):align(display.CENTER, display.width * 0.5, display.height * 0.6):addTo(self, 1):onButtonClicked(handler(self, self.buttonListener))
  self.mBtnServers.label = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 28,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, -180, 0):addTo(self.mBtnServers, 1)
  display.newSprite("login_scene/btn_change_reg.png"):align(display.CENTER_RIGHT, 180, 0):addTo(self.mBtnServers, 1)
  self.mBtnServers:setVisible(false)
  self.mBtnStart = cc.ui.UIPushButton.new({
    normal = "login_scene/start_long.png",
    pressed = "login_scene/start_long1.png"
  }):align(display.CENTER, display.width * 0.5, display.height * 0.45):addTo(self, 1):onButtonClicked(handler(self, self.buttonListener))
  self.mBtnStart:setVisible(false)
  self.mBtnUserCenter = cc.ui.UIPushButton.new({
    normal = "login_scene/user_center.png",
    pressed = "login_scene/user_center1.png"
  }):align(display.CENTER, display.width * 0.9, display.height * 0.12):addTo(self, 1):onButtonClicked(handler(self, self.buttonListener))
  self.mBtnUserCenter:setVisible(false)
  self.mBtnQQ = cc.ui.UIPushButton.new({
    normal = "login_scene/login_qq.png",
    pressed = "login_scene/login_qq1.png"
  }):align(display.CENTER, display.width * 0.65, display.height * 0.42):addTo(self, 1):onButtonClicked(handler(self, self.buttonListener))
  self.mBtnWeChat = cc.ui.UIPushButton.new({
    normal = "login_scene/login_wechat.png",
    pressed = "login_scene/login_wechat1.png"
  }):align(display.CENTER, display.width * 0.35, display.height * 0.42):addTo(self, 1):onButtonClicked(handler(self, self.buttonListener))
  self.mBtnQQ:setVisible(false)
  self.mBtnWeChat:setVisible(false)
  self.mBtnLogout = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\230\179\168    \233\148\128",
    size = 30,
    color = cc.c3b(255, 234, 200),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(143, 78, 1)
  })):setButtonLabel("pressed", DYLabelTTF.new({
    text = "\230\179\168    \233\148\128",
    size = 28,
    color = cc.c3b(255, 234, 200),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(143, 78, 1)
  })):onButtonClicked(function()
    DYStat.setValueStr(DY_KEY.kUserName, "")
    DYStat.setValueStr(DY_KEY.kPassWord, "")
    DYStat.setValueBool(DY_KEY.kIsUserLogin, false)
    DYSoundMgr.stopMusic()
    self:performWithDelay(function()
      DYLoginMgr.logout()
    end, 0.2)
  end):align(display.CENTER, display.width * 0.9, display.height * 0.12):addTo(self, 1)
  self.mBtnLogout:setVisible(false)
end

function M:tryUpdate()
  local toast = WSToast.new(DYLang.getString("S1315", "")):addTo(self, 10)
  toast:setPosition(display.cx, display.height * 0.9)
  local ver = DYUtils.getVersionName()
  if ver == "" then
    ver = DYUtils.gameVer()
  end
  self.mLabelVersion:setString(string.format(DYLang.getString("S1316", ""), ver))
  local loginParam = json.decode(DYStat.getValueStr(DY_KEY.kLoginParams, json.encode({})))
  self:tryLogin(loginParam, handler(self, self.onLoginCallback))
end

function M:tryLogin(param, cb)
  self.mLoginParam = param
  self.mLoginHandler = cb
  if DYStat.getValueBool(DY_KEY.kIsUserLogin, false) then
    self:tryLoginAgain()
  elseif DYCommon.needShowTencentButton() then
    self.mBtnQQ:setVisible(true)
    self.mBtnWeChat:setVisible(true)
  else
    self:tryLoginAgain()
  end
end

function M:tryLoginAgain()
  DYLoginMgr.login(self.mLoginParam, self.mLoginHandler)
end

function M:onLoginCallback(et)
  local event = et.event
  local param = et.param or {}
  if event == dy.login.EVENT_LOGIN_FAIL then
    DYHttpMgr.checkLoginPoint("4_platform_login_failed")
    if DYCommon.needShowTencentButton() then
      self.mBtnQQ:setButtonEnabled(true)
      self.mBtnWeChat:setButtonEnabled(true)
    else
      local toast = WSToast.new(DYLang.getString("S1314", "")):addTo(self, 10)
      self:performWithDelay(handler(self, self.tryLoginAgain), 0.2)
    end
    return
  end
  
  local function tFuncListener(loginInfo)
    if checknumber(loginInfo.errorCode) ~= 0 then
      DDTRACE("SceneLogin.onLoginCallback dygame login failed! ", string.format("errorCode: %s, errorMsg: %s", checkstring(loginInfo.errorCode), checkstring(loginInfo.errorMsg)))
      DYHttpMgr.checkLoginPoint("5_dygame_login_failed")
      return
    end
    CloudData.SERVERS_TABLE = loginInfo.data.regions
    CloudData.HISTORY_SERVERS = loginInfo.data.login_regions or {}
    CloudData.REGIONS = loginInfo.data.account.regions or ""
    CloudData.TOKEN = loginInfo.data.account.token or ""
    CloudData.ACCOUNT_ID = loginInfo.data.account.accountId
    CloudData.USER_TYPE = loginInfo.data.account.userType or ""
    CloudData.BIND_PHONE = loginInfo.data.account.telephone or ""
    CloudData.LOGIN_KEY = loginInfo.data.loginKey
    DYHttpMgr.checkLoginPoint("5_dygame_login_ok")
    DYStat.setValueStr(DY_KEY.kUserName, loginInfo.data.account.username)
    DYStat.setValueStr(DY_KEY.kPassWord, loginInfo.data.account.password)
    DYStat.setValueBool(DY_KEY.kIsUserLogin, true)
    DYMem.set(DY_KEY.kLoginMethod, checkstring(loginInfo.data.loginMethod))
    DYMem.set(DY_KEY.kIsCDKeyShow, checkstring(loginInfo.data.isCDKeyShow))
    self:showServerButton()
    self:onEventRefreshServers()
    if DYCommon.needShowUserCenter() then
      self.mBtnUserCenter:setVisible(true)
    end
    if DYCommon.needShowTencentButton() then
      self.mBtnLogout:setVisible(true)
    end
  end
  
  param.id = param.id or DYUtils.uniqueID()
  param.name = param.name or DYStat.getValueStr(DY_KEY.kUserName, "")
  param.token = param.token or DYStat.getValueStr(DY_KEY.kPassWord, "")
  param.game = DYUtils.gameId()
  DYHttpMgr.requestLogin(tFuncListener, param)
  DYHttpMgr.checkLoginPoint("4_platform_login_ok")
end

function M:showServerButton()
  self:parseServerTable()
  self:onEventLayerServers()
  self.mBtnQQ:setVisible(false)
  self.mBtnWeChat:setVisible(false)
  self.mBtnServers:setVisible(true)
  self.mBtnStart:setVisible(true)
end

function M:buttonListener(param)
  if param.target == self.mBtnStart then
    self.mBtnStart:setTouchEnabled(false)
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
    local info = CloudData.USER_SERVER_INFO
    if info.status == LayerServers.ST_MAINTAIN then
      local layer = LayerMaintain.new()
      self:addChild(layer, 10)
      self.mBtnStart:setTouchEnabled(true)
      return
    end
    DYStat.setValueInt(DY_KEY.kUserServer, CloudData.USER_SERVER_ID)
    DYHttpMgr.setLogicURL(CloudData.USER_SERVER_INFO.ip, CloudData.USER_SERVER_INFO.port, CloudData.USER_SERVER_INFO.base)
    SocketMgr = require("app.communication.SocketMgr").new(CloudData.USER_SERVER_INFO.interIp, CloudData.USER_SERVER_INFO.interPort)
    SocketHandler = require("app.communication.SocketHandler").new()
    self:getUserInfo()
  elseif param.target == self.mBtnServers then
    local layer = LayerServers.new(handler(self, self.onEventLayerServers))
    self:addChild(layer, 2)
  elseif param.target == self.mBtnUserCenter then
    local lastUser = DYStat.getValueStr(DY_KEY.kUserName, "")
    DDLOG("lastUser = " .. lastUser)
    local account = SetAccountLayer.new()
    self:addChild(account, 20)
  elseif param.target == self.mBtnQQ then
    self:onEveneQQLogin()
  elseif param.target == self.mBtnWeChat then
    self:onEveneWeChatLogin()
  end
end

function M:addClickEvent(obj)
  local lastTime, currTime, times = 0, 0, 0
  obj:setTouchEnabled(true)
  obj:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      local delta = currTime - lastTime
      if delta <= 0.5 then
        times = times + 1
        if 5 <= times then
          local str = string.format("\230\184\184\230\136\143\231\137\136\230\156\172\229\143\183\239\188\154%s", DYUtils.gameVer())
          WSToast.new(str, 3):addTo(self, 20)
          times = 0
        end
      else
        times = 0
      end
      lastTime = currTime
      return true
    end
  end)
  self:schedule(function()
    currTime = currTime + 0.02
  end, 0.02)
end

function M:onEveneQQLogin()
  self.mBtnQQ:setButtonEnabled(false)
  self.mBtnWeChat:setButtonEnabled(false)
  self.mLoginParam = {channel = "QQ"}
  DYStat.setValueStr(DY_KEY.kLoginParams, json.encode(self.mLoginParam))
  DYLoginMgr.login(self.mLoginParam, self.mLoginHandler)
end

function M:onEveneWeChatLogin()
  self.mBtnQQ:setButtonEnabled(false)
  self.mBtnWeChat:setButtonEnabled(false)
  self.mLoginParam = {channel = "WeChat"}
  DYStat.setValueStr(DY_KEY.kLoginParams, json.encode(self.mLoginParam))
  DYLoginMgr.login(self.mLoginParam, self.mLoginHandler)
end

function M:onEventLayerServers()
  local info = CloudData.USER_SERVER_INFO
  self.mBtnServers.label:setString(info.name)
  self.mBtnServers.label:setColor(LayerServers.STATUS_COLOR[info.status])
end

function M:onEventRefreshServers()
  local function tFuncUpdate()
    for i = 1, #CloudData.HISTORY_SERVERS do
      local regionId = CloudData.HISTORY_SERVERS[i].regionId
      
      for j = 1, #CloudData.SERVERS_ARRAY do
        local info = CloudData.SERVERS_ARRAY[j]
        if regionId == info.id then
          CloudData.HISTORY_SERVERS[i].name = info.name
          CloudData.HISTORY_SERVERS[i].index = j
        end
      end
      if regionId == CloudData.USER_SERVER_ID then
        CloudData.HISTORY_SERVERS[i], CloudData.HISTORY_SERVERS[1] = CloudData.HISTORY_SERVERS[1], CloudData.HISTORY_SERVERS[i]
      end
    end
  end
  
  DYNotification.registerScriptObserver(self, tFuncUpdate, DY_KEY.kRefreshServerInfo)
end

function M:getUserInfo()
  local function tFuncListener(userInfo)
    self:parseLoginJsonToCloudData(userInfo)
    
    DYHttpMgr.checkLoginPoint("6_game_start")
    local serverInfo = string.format("%s:%s/%s", checkstring(CloudData.USER_SERVER_INFO.ip), checkstring(CloudData.USER_SERVER_INFO.port), checkstring(CloudData.USER_SERVER_INFO.base))
    DYAnalyze.account.login(CloudData.ACCOUNT_ID, serverInfo)
    DYAnalyze.account.setGameServer(checkstring(CloudData.USER_SERVER_INFO.name))
    DYAnalyze.account.setLevel(CloudData.USER_LEVEL)
    local serverInfo = {
      regionId = tostring(CloudData.USER_SERVER_INFO.id),
      regionName = tostring(CloudData.USER_SERVER_INFO.name),
      roleId = tostring(CloudData.UID),
      roleName = tostring(CloudData.USER_NAME),
      roleLevel = tostring(CloudData.USER_LEVEL),
      roleVipLevel = tostring(CloudData.VIP_LEVEL),
      logicUrl = DYHttpMgr.getLogicURL(),
      loginUrl = DYHttpMgr.getLoginURL(),
      hotfixUrl = DYHttpMgr.getHotfixURL(),
      paymentUrl = DYHttpMgr.getPaymentURL(),
      roleCTime = tostring(CloudData.ROLE_C_TIME),
      roleLevelMTime = tostring(userInfo.data.levelTime)
    }
    DYLoginMgr.enter(serverInfo)
    self:performWithDelay(function()
      self:toScene()
    end, 0.2)
  end
  
  local param = {}
  param.channel = DYUtils.channelName()
  param.loginKey = CloudData.LOGIN_KEY
  param.accountId = CloudData.ACCOUNT_ID
  DYHttpMgr.getPlayerInfo(tFuncListener, param)
end

function M:toScene()
  DYSoundMgr.stopMusic(true)
  if CloudData.OPENNING_COMIC_PLAYED == 0 and not Const.SKIP_GUIDE then
    display.replaceScene(require("app.scenes.OpeningComicScene").new())
  else
    display.replaceScene(require("app.scenes.LoadingScene").new())
  end
end

function M:parseServerTable()
  local data = CloudData.SERVERS_TABLE
  local dataArr = {}
  table.walk(data, function(v, k)
    table.insert(dataArr, v)
  end)
  table.sort(dataArr, function(ta, tb)
    return tonumber(ta.priority) > tonumber(tb.priority) or tonumber(ta.priority) == tonumber(tb.priority) and tonumber(ta.id) > tonumber(tb.id)
  end)
  CloudData.SERVERS_ARRAY = dataArr
  local serverId
  CloudData.USER_SERVER_ID = DYStat.getValueInt(DY_KEY.kUserServer, 0)
  serverId = CloudData.USER_SERVER_ID
  if serverId == nil or serverId == 0 or data[checkstring(serverId)] == nil then
    serverId = dataArr[1].id
  end
  for i = 1, #CloudData.HISTORY_SERVERS do
    local regionId = CloudData.HISTORY_SERVERS[i].regionId
    for j = 1, #CloudData.SERVERS_ARRAY do
      local info = CloudData.SERVERS_ARRAY[j]
      if regionId == info.id then
        CloudData.HISTORY_SERVERS[i].name = info.name
        CloudData.HISTORY_SERVERS[i].index = j
      end
    end
    if regionId == CloudData.USER_SERVER_ID then
      CloudData.HISTORY_SERVERS[i], CloudData.HISTORY_SERVERS[1] = CloudData.HISTORY_SERVERS[1], CloudData.HISTORY_SERVERS[i]
    end
  end
  CloudData.USER_SERVER_ID = tonumber(serverId)
  CloudData.USER_SERVER_INFO = data[checkstring(serverId)]
end

function M:parseLoginJsonToCloudData(jsonValue)
  if not jsonValue then
    printError("error login msg")
    return
  end
  CloudData.UID = jsonValue.data.uid
  CloudData.TOKEN = jsonValue.data.token or ""
  CloudData.ROLE_C_TIME = jsonValue.data.createTime
  CloudData.GOT_PHONE_AWARD = checknumber(jsonValue.data.telephoneAward)
  local team = jsonValue.data.commonTeam
  if team.attackTeam == nil or #team.attackTeam == 0 then
    team.attackTeam = {"1003"}
  end
  DataUtils.setBuddhaTableOnTeam(team.attackTeam)
  DataUtils.setBuddhaTableOnAssist(team.helpTeam)
  local purgatoryTeam = jsonValue.data.purgatoryTeam
  if purgatoryTeam.attackTeam == nil or #purgatoryTeam.attackTeam == 0 then
    purgatoryTeam.attackTeam = {""}
  end
  DataUtils.setBuddhaTableOnTeam(purgatoryTeam.attackTeam, 3)
  DataUtils.setBuddhaTableOnAssist(purgatoryTeam.helpTeam, 3)
  CloudData.PEACH_BUY_COUNT = jsonValue.data.peachBuy
  CloudData.MAIN_STAGE_PROGRESS = tonumber(jsonValue.data.reachMainDungeonId) % 10000
  CloudData.ELITE_STAGE_PROGRESS = tonumber(jsonValue.data.reachEliteDungeonId) % 20000
  CloudData.PURGATORY_STAGE_PROGRESS = tonumber(jsonValue.data.reachPurgatoryId)
  CloudData.MONEY = jsonValue.data.money or 0
  CloudData.MAX_ENERGY = jsonValue.data.maxEnergy
  CloudData.FIRST_RECHARGE_STATE = tonumber(jsonValue.data.firstPay)
  CloudData.RECHARGE_REWARD = jsonValue.data.payAward
  CloudData.IS_SIGNED_TODAY = jsonValue.data.signedToday
  CloudData.SIGN_COUNT = jsonValue.data.signTotal
  CloudData.INFINITE_MAX_STAGE = tonumber(jsonValue.data.reachTowerStage)
  CloudData.INFINITE_MAX_WAVE = tonumber(jsonValue.data.reachTowerWave)
  CloudData.INFINITE_CUR_STAGE = tonumber(jsonValue.data.currentTowerStage)
  CloudData.INFINITE_MAX_RESET_TIMES = tonumber(jsonValue.data.towerTotalTimes)
  CloudData.INFINITE_CUR_RESET_TIMES = tonumber(jsonValue.data.towerLeftTimes)
  CloudData.DELTA_TIME = jsonValue.time - os.time()
  CloudData.USER_ICON = GameManager.USER_ICON_PATH .. jsonValue.data.icon .. ".png" or ""
  CloudData.USER_NAME = jsonValue.data.nick or ""
  CloudData.USER_LEVEL = jsonValue.data.level or 1
  DYAnalyze.account.addTag(DYLang.getString("S1322", ""), CloudData.USER_LEVEL)
  CloudData.VIP_LEVEL = tonumber(jsonValue.data.vip) or 0
  DYAnalyze.account.addTag("VIP", CloudData.VIP_LEVEL)
  CloudData.IS_ACTIVITY_SEVEN_OPEN = jsonValue.data.isActivitySevenOn
  CloudData.IS_RANKING_AWARD_OPEN = jsonValue.data.isSevenRankOn
  CloudData.FESTIVAL_ACT_TYPE = jsonValue.data.festival.type
  CloudData.FESTIVAL_ACT_LIST = jsonValue.data.festival.list
  CloudData.IS_ACT_BUDDHA_OPEN = jsonValue.data.isAskGodOn
  CloudData.ACT_BUDDHA_ICON = string.format("activity_buddha/icon_%d.png", tonumber(jsonValue.data.askGodBuddhaId))
  CloudData.NEW_BUDDHA_ICON = string.format("activity_buddha/icon_%d.png", tonumber(jsonValue.data.newBuddhaId))
  CloudData.MINING_NUM = tonumber(jsonValue.data.miningTimes) or 0
  CloudData.GINSEN_BUY_TIME = tonumber(jsonValue.data.ginsenBuyCount) or 0
  CloudData.UPDATE_NICK_COST = tonumber(jsonValue.data.updateNickCost) or 0
  CloudData.AWAKE_LEARN_COUNT = jsonValue.data.arousal.fullCount
  CloudData.AWAKE_LEARN_LEFT = jsonValue.data.arousal.leftCount
  local friendTag = tonumber(jsonValue.data.friendForbidden) or 0
  if friendTag == 0 then
    CloudData.FRIEND_ADD_TAG = true
  else
    CloudData.FRIEND_ADD_TAG = false
  end
  local pkTag = tonumber(jsonValue.data.challengeForbidden) or 0
  if pkTag == 0 then
    CloudData.FRIEND_PK_TAG = true
  else
    CloudData.FRIEND_PK_TAG = false
  end
  local cimeliaAtk = tonumber(jsonValue.data.attackCimelia) or 0
  local cimeliaDef = tonumber(jsonValue.data.defenceCimelia) or 0
  CloudData.CIMELIA_EQUIPED = {cimeliaAtk, cimeliaDef}
  CloudData.CIMELIA_LIST = {}
  for k, v in pairs(jsonValue.data.cimeliaList) do
    local ucid = v.id or 0
    CloudData.CIMELIA_LIST[ucid] = v
  end
  CloudData.EQUIPMENT_INFO = jsonValue.data.equipmentList
  for k, v in pairs(CloudData.EQUIPMENT_INFO) do
    local data = GameManager.generateEquipmentData(k, v)
    GameManager.EQUIP_LIST[k] = data
  end
  CloudData.SUMMON_NORMAL_POOL = jsonValue.data.summon.commonPool
  CloudData.SUMMON_ADVANCE_POOL = jsonValue.data.summon.advancePool
  CloudData.SUMMON_VIP_POOL = jsonValue.data.summon.hongmengPool
  if DYStat.getValueBool(DY_KEY.kSkipOpenComic, false) or CloudData.MAIN_STAGE_PROGRESS >= 1 then
    CloudData.OPENNING_COMIC_PLAYED = 1
  end
  CloudData.GAME_ITEM_INFO = {}
  for k, v in pairs(jsonValue.data.things) do
    DataUtils.updateItemNum(k, v)
  end
  for i, v in pairs(jsonValue.data.npcList) do
    local npcId = v.id or 0
    CloudData.NPC_INFO[npcId] = v
  end
  for i = 1, 120 do
    CloudData.TREASURE_PIECE_INFO[i] = 0
  end
  for i, v in pairs(jsonValue.data.treasureList) do
    CloudData.TREASURE_PIECE_INFO[v.treasureId] = v.quality
  end
end

return M

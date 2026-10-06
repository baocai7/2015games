local LayerUpdatePassword = require("app.layers.LayerUpdatePassword")
local LayerBindPhone = require("app.layers.LayerBindPhone")
local CLASS_NAME = "LayerAccountLogin"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mBg = nil
  self.mWarningNode = nil
  self.mName = nil
  self.mPassword = nil
  self:initUI()
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("login_scene/frame.png"):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UILabel.new({
    text = DYLang.getString("S426", ""),
    size = 30,
    color = cc.c3b(74, 41, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 164, 315):addTo(bg)
  self.mName = cc.ui.UIInput.new({
    image = "login_scene/input_bg.png",
    size = cc.size(378, 46),
    x = 354,
    y = 308,
    listener = function(event)
      if event == "began" then
        self:onEditBoxBegan(self.mName)
        self.mWarningNode:hideMsg()
      end
    end
  })
  self.mName:setPlaceHolder("5-16\228\189\141\230\149\176\229\173\151\227\128\129\229\173\151\230\175\141\231\187\132\229\144\136")
  self.mName:setPlaceholderFontColor(cc.c3b(211, 197, 171))
  self.mName:setPlaceholderFontName(GameManager.FONTNAME_TTF)
  self.mName:setPlaceholderFontSize(24)
  self.mName:setFontColor(cc.c3b(254, 245, 231))
  self.mName:setFontName(GameManager.FONTNAME_TTF)
  self.mName:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  bg:addChild(self.mName)
  cc.ui.UILabel.new({
    text = DYLang.getString("S427", ""),
    size = 30,
    color = cc.c3b(74, 41, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 164, 243):addTo(bg)
  self.mPassword = cc.ui.UIInput.new({
    image = "login_scene/input_bg.png",
    size = cc.size(378, 46),
    x = 354,
    y = 238,
    listener = function(event)
      if event == "began" then
        self:onEditBoxBegan(self.mPassword)
        self.mWarningNode:hideMsg()
      end
    end
  })
  self.mPassword:setPlaceHolder("4-16\228\189\141(\233\153\164\231\169\186\230\160\188\227\128\129\233\128\151\229\143\183\227\128\129\229\141\149\229\143\140\229\188\149\229\143\183)")
  self.mPassword:setPlaceholderFontColor(cc.c3b(211, 197, 171))
  self.mPassword:setPlaceholderFontName(GameManager.FONTNAME_TTF)
  self.mPassword:setPlaceholderFontSize(24)
  self.mPassword:setFontColor(cc.c3b(254, 245, 231))
  self.mPassword:setFontName(GameManager.FONTNAME_TTF)
  self.mPassword:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  self.mPassword:setInputFlag(0)
  bg:addChild(self.mPassword)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 748, 438):onButtonClicked(function()
    self:buttonListener("CLOSE")
  end):addTo(bg)
  local info = {
    [1] = {
      text = DYLang.getString("S428", ""),
      x = 653,
      y = 243,
      func = function()
        self:buttonListener("PASSWORD")
      end
    },
    [2] = {
      text = DYLang.getString("S429", ""),
      x = 387,
      y = 104,
      func = function()
        self:buttonListener("LOGIN")
      end
    }
  }
  if "player" ~= CloudData.USER_TYPE then
    info[2].x = 262
    info[3] = {
      text = DYLang.getString("S430", ""),
      x = 517,
      y = 104,
      func = function()
        self:buttonListener("REGISTER")
      end
    }
  end
  for i = 1, #info do
    local str = DYLabelTTF.new({
      text = info[i].text,
      size = 30,
      color = cc.c3b(253, 231, 196),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER"
    }, {
      lineWidth = 1,
      lineColor = cc.c3b(143, 78, 1)
    })
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }):align(display.CENTER, info[i].x, info[i].y):setButtonLabel("normal", str):onButtonClicked(function()
      info[i].func()
    end):addTo(bg)
  end
  self:addWarningNode()
end

function M:addWarningNode()
  local node = display.newNode():pos(392, 390):addTo(self.mBg, 1)
  self.mWarningNode = node
  display.newSprite("login_scene/warning.png"):pos(-280, 0):addTo(node)
  local label = DYLabel.new({
    text = "",
    size = 24,
    color = display.COLOR_RED,
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    valign = cc.ui.TEXT_VALIGN_CENTER
  })
  label:setAnchorPoint(cc.p(0, 0.5))
  label:setPosition(cc.p(-260, 0))
  label:addTo(node)
  
  function node:showMsg(msg)
    node:setVisible(true)
    label:setString(msg)
  end
  
  function node:hideMsg()
    node:setVisible(false)
  end
  
  node:hideMsg()
end

function M:buttonListener(tag)
  if tag == "REGISTER" then
    self:toRegister()
  elseif tag == "LOGIN" then
    self:toLogin()
  elseif tag == "CLOSE" then
    self:closeCallBack()
  elseif tag == "PASSWORD" then
    self:forgetPassword()
  end
end

function M:toRegister()
  if "player" == CloudData.USER_TYPE then
    self.mWarningNode:showMsg(DYLang.getString("S431", ""))
    return
  end
  local userName = string.trim(checkstring(self.mName:getText()))
  local password = string.trim(checkstring(self.mPassword:getText()))
  if userName == "" then
    self.mWarningNode:showMsg(DYLang.getString("S432", ""))
    return
  elseif password == "" then
    self.mWarningNode:showMsg(DYLang.getString("S433", ""))
    return
  end
  
  local function tFuncListener(jsonTable)
    local msg = jsonTable.errorMsg
    if not self.class or self.class.__cname ~= CLASS_NAME then
      return
    end
    if jsonTable.errorCode ~= 0 then
      if not msg or msg == "" then
        msg = string.format(DYLang.getString("S434", ""), jsonTable.errorCode)
      end
      self.mWarningNode:showMsg(msg)
      return
    end
    CloudData.USER_TYPE = jsonTable.data.userType or ""
    CloudData.BIND_PHONE = jsonTable.data.telephone or ""
    CloudData.TOKEN = jsonTable.data.token or ""
    CloudData.ACCOUNT_ID = jsonTable.data.accountId or ""
    DYStat.setValueStr(DY_KEY.kUserName, jsonTable.data.username or "")
    DYStat.setValueStr(DY_KEY.kPassWord, jsonTable.data.password or "")
    if not msg or msg == "" or msg == "ok" then
      self.mWarningNode:showMsg(userName .. DYLang.getString("S435", ""))
      self.mWarningNode:performWithDelay(function()
        LayerBindPhone.new():addTo(display.getRunningScene(), 20)
        self:closeCallBack()
      end, 0.2)
    else
      self.mWarningNode:showMsg(msg)
    end
  end
  
  local params = {}
  params.oldUsername = DYStat.getValueStr(DY_KEY.kUserName, "")
  params.oldPassword = DYStat.getValueStr(DY_KEY.kPassWord, "")
  params.newUsername = userName
  params.newPassword = password
  params.uuid = DYUtils.uniqueID()
  DYHttpMgr.accountBinding(tFuncListener, params)
end

function M:toLogin()
  local userName = string.trim(checkstring(self.mName:getText()))
  local password = string.trim(checkstring(self.mPassword:getText()))
  if userName == "" then
    self.mWarningNode:showMsg(DYLang.getString("S432", ""))
    return
  elseif password == "" then
    self.mWarningNode:showMsg(DYLang.getString("S433", ""))
    return
  end
  
  local function tFuncListener(jsonTable)
    local msg = jsonTable.errorMsg
    if not self.class or self.class.__cname ~= CLASS_NAME then
      return
    end
    if jsonTable.errorCode ~= 0 then
      if not msg or msg == "" then
        msg = string.format(DYLang.getString("S434", ""), jsonTable.errorCode)
      end
      self.mWarningNode:showMsg(msg)
      return
    end
    CloudData.USER_TYPE = jsonTable.data.account.userType or ""
    CloudData.BIND_PHONE = jsonTable.data.account.telephone or ""
    CloudData.TOKEN = jsonTable.data.account.token or ""
    CloudData.ACCOUNT_ID = jsonTable.data.account.accountId or ""
    CloudData.LOGIN_KEY = jsonTable.data.loginKey or ""
    CloudData.HISTORY_SERVERS = jsonTable.data.login_regions or {}
    DYStat.setValueStr(DY_KEY.kUserName, jsonTable.data.account.username or "")
    DYStat.setValueStr(DY_KEY.kPassWord, jsonTable.data.account.password or "")
    if not msg or msg == "" or msg == "ok" then
      self.mWarningNode:showMsg(userName .. DYLang.getString("S439", ""))
      DYNotification.postNotification(DY_KEY.kRefreshServerInfo)
      self.mWarningNode:performWithDelay(function()
        self:closeCallBack()
      end, 0.2)
    else
      self.mWarningNode:showMsg(msg)
    end
  end
  
  local params = {}
  params.username = userName
  params.password = password
  params.uuid = DYUtils.uniqueID()
  DYHttpMgr.accountChange(tFuncListener, params)
end

function M:forgetPassword()
  local userName = string.trim(checkstring(self.mName:getText()))
  if userName == "" then
    self.mWarningNode:showMsg(DYLang.getString("S432", ""))
    return
  end
  
  local function tFuncListener(jsonTable)
    local msg = jsonTable.errorMsg
    if not self.class or self.class.__cname ~= CLASS_NAME then
      return
    end
    if jsonTable.errorCode ~= 0 then
      if not msg or msg == "" then
        msg = string.format(DYLang.getString("S434", ""), jsonTable.errorCode)
      end
      self.mWarningNode:showMsg(msg)
      return
    end
    local phone = jsonTable.data.telephone
    if phone and phone ~= "" then
      LayerUpdatePassword.new(userName, phone):addTo(display.getRunningScene(), 20)
      self:closeCallBack()
    else
      self.mWarningNode:showMsg(DYLang.getString("S442", ""))
    end
  end
  
  local params = {}
  params.username = userName
  DYHttpMgr.forgetPassword(tFuncListener, params)
end

function M:onEditBoxBegan(editbox)
  editbox:setText("")
end

function M:closeCallBack()
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
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

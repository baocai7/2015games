local CLASS_NAME = "LayerUpdatePassword"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(userName, phone)
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mBg = nil
  self.mPhone = nil
  self.mPassword = nil
  self.mVerification = nil
  self.mTimelabel = nil
  self.mUserName = userName or ""
  self.mTelephone = phone or ""
  self.mCdTime = 60
  self:initUI()
  self:setNodeEventEnabled(true)
end

local function getPhoneNumber(telephone)
  local phone = ""
  if telephone and 4 < #telephone then
    local sum = #telephone
    local tail = string.sub(telephone, sum - 3, sum) or ""
    phone = "*******" .. tail
  end
  return phone
end

function M:initUI()
  local bg = display.newSprite("login_scene/frame.png"):addTo(self.mNode)
  self.mBg = bg
  local phone = getPhoneNumber(self.mTelephone)
  cc.ui.UILabel.new({
    text = DYLang.getString("S992", "") .. phone,
    size = 25,
    color = cc.c3b(74, 41, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 392, 370):addTo(bg)
  cc.ui.UILabel.new({
    text = DYLang.getString("S993", ""),
    size = 28,
    color = cc.c3b(74, 41, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 330, 315):addTo(bg)
  self.mPhone = cc.ui.UIInput.new({
    image = "login_scene/input_bg.png",
    size = cc.size(378, 46),
    x = 520,
    y = 308,
    listener = function(event)
      if event == "began" then
        self:onEditBoxBegan(self.mPhone)
        self.mWarningNode:hideMsg()
      end
    end
  })
  self.mPhone:setFontColor(cc.c3b(254, 245, 231))
  self.mPhone:setFontName(GameManager.FONTNAME_TTF)
  self.mPhone:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  bg:addChild(self.mPhone)
  cc.ui.UILabel.new({
    text = DYLang.getString("S994", ""),
    size = 28,
    color = cc.c3b(74, 41, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 330, 243):addTo(bg)
  self.mPassword = cc.ui.UIInput.new({
    image = "login_scene/input_bg.png",
    size = cc.size(378, 46),
    x = 520,
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
  cc.ui.UILabel.new({
    text = DYLang.getString("S995", ""),
    size = 28,
    color = cc.c3b(74, 41, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 330, 185):addTo(bg)
  self.mVerification = cc.ui.UIInput.new({
    image = "login_scene/input_bg.png",
    size = cc.size(378, 46),
    x = 520,
    y = 180,
    listener = function(event)
      if event == "began" then
        self:onEditBoxBegan(self.mVerification)
        self.mWarningNode:hideMsg()
      end
    end
  })
  self.mVerification:setFontColor(cc.c3b(254, 245, 231))
  self.mVerification:setFontName(GameManager.FONTNAME_TTF)
  self.mVerification:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  bg:addChild(self.mVerification)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 748, 438):onButtonClicked(function()
    self:buttonListener("CLOSE")
  end):addTo(bg)
  local info = {
    {
      text = DYLang.getString("S996", ""),
      x = 212,
      y = 104,
      func = function(event)
        self:buttonListener("VERIFICATION", event.target)
      end
    },
    {
      text = DYLang.getString("S997", ""),
      x = 567,
      y = 104,
      func = function()
        self:buttonListener("UPDATE")
      end
    }
  }
  for i = 1, #info do
    local str = DYLabelTTF.new({
      text = info[i].text,
      size = 28,
      color = cc.c3b(253, 231, 196),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER"
    }, {
      lineWidth = 1,
      lineColor = cc.c3b(143, 78, 1)
    })
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png",
      disabled = "common_ui/btn_disabled.png"
    }):align(display.CENTER, info[i].x, info[i].y):setButtonLabel("normal", str):onButtonClicked(function(event)
      info[i].func(event)
    end):addTo(bg)
  end
  self:addWarningNode()
end

function M:addWarningNode()
  local node = display.newNode():pos(392, 410):addTo(self.mBg, 1)
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

function M:buttonListener(tag, target)
  if tag == "VERIFICATION" then
    self:sendVerification(target)
  elseif tag == "UPDATE" then
    self:updatePassword()
  elseif tag == "CLOSE" then
    self:closeCallBack()
  end
end

function M:sendVerification(target)
  local phone = string.trim(checkstring(self.mPhone:getText()))
  if phone == "" then
    self.mWarningNode:showMsg(DYLang.getString("S998", ""))
    return
  elseif tostring(phone) ~= tostring(self.mTelephone) then
    self.mWarningNode:showMsg(DYLang.getString("S999", ""))
    return
  end
  if target then
    self.mCdTime = 60
    self:startCountDown(target)
  end
  
  local function tFuncListener(jsonTable)
    local msg = jsonTable.errorMsg
    if jsonTable.errorCode == 181 then
      local time = checknumber(msg)
      if time < 1 then
        time = 1
      end
      msg = string.format(DYLang.getString("S1000", ""), time)
      self.mWarningNode:showMsg(msg)
      self.mCdTime = time
    elseif jsonTable.errorCode ~= 0 then
      if not msg or msg == "" then
        msg = string.format(DYLang.getString("S1001", ""), jsonTable.errorCode)
      end
      self.mWarningNode:showMsg(msg)
    else
      self.mWarningNode:showMsg(DYLang.getString("S1002", ""))
    end
  end
  
  local game = DYUtils.gameId()
  local msgType = 2
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&game=%s&telephone=%s&type=%s", strAppSecret .. "", game .. "", phone .. "", msgType .. "")
  local params = {}
  params.telephone = phone
  params.game = game
  params.type = msgType
  params.sign = crypto.md5(strSign, false)
  DYHttpMgr.sendVerification(tFuncListener, params)
end

function M:updatePassword()
  local phone = string.trim(checkstring(self.mPhone:getText()))
  local password = string.trim(checkstring(self.mPassword:getText()))
  local verification = string.trim(checkstring(self.mVerification:getText()))
  if password == "" then
    self.mWarningNode:showMsg(DYLang.getString("S1003", ""))
    return
  elseif verification == "" then
    self.mWarningNode:showMsg(DYLang.getString("S1004", ""))
    return
  end
  
  local function tFuncListener(jsonTable)
    local msg = jsonTable.errorMsg
    if jsonTable.errorCode ~= 0 then
      if not msg or msg == "" then
        msg = string.format(DYLang.getString("S1001", ""), jsonTable.errorCode)
      end
      self.mWarningNode:showMsg(msg)
      return
    end
    DYStat.setValueStr(DY_KEY.kUserName, self.mUserName)
    local password = jsonTable.data.newPassword or ""
    DYStat.setValueStr(DY_KEY.kPassWord, password)
    self.mWarningNode:showMsg(DYLang.getString("S1006", ""))
    self:toLogin()
  end
  
  local game = DYUtils.gameId()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&game=%s&IdentifyCode=%s&password=%s&telephone=%s&username=%s", strAppSecret .. "", game .. "", verification .. "", password .. "", phone .. "", self.mUserName .. "")
  local params = {}
  params.telephone = phone
  params.game = game
  params.IdentifyCode = verification
  params.password = password
  params.username = self.mUserName
  params.sign = crypto.md5(strSign, false)
  DYHttpMgr.updatePassword(tFuncListener, params)
end

function M:toLogin()
  local function tFuncListener(loginInfo)
    CloudData.SERVERS_TABLE = loginInfo.data.regions
    
    CloudData.HISTORY_SERVERS = loginInfo.data.login_regions or {}
    CloudData.REGIONS = loginInfo.data.account.regions or ""
    CloudData.TOKEN = loginInfo.data.account.token or ""
    CloudData.ACCOUNT_ID = loginInfo.data.account.accountId
    CloudData.USER_TYPE = loginInfo.data.account.userType or ""
    CloudData.BIND_PHONE = loginInfo.data.account.telephone or ""
    CloudData.LOGIN_KEY = loginInfo.data.loginKey
    DYStat.setValueStr(DY_KEY.kUserName, loginInfo.data.account.username)
    DYStat.setValueStr(DY_KEY.kPassWord, loginInfo.data.account.password)
    self:closeCallBack()
  end
  
  local param = {}
  param.id = DYUtils.uniqueID()
  param.name = DYStat.getValueStr(DY_KEY.kUserName, "")
  param.token = DYStat.getValueStr(DY_KEY.kPassWord, "")
  DYHttpMgr.requestLogin(tFuncListener, param)
end

function M:onEditBoxBegan(editbox)
  editbox:setText("")
end

function M:startCountDown(target)
  target:setButtonEnabled(false)
  local time = tonumber(self.mCdTime) or 60
  self.mTimelabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = time,
    font = "fonts/greenNum.fnt"
  }):scale(0.8):align(display.CENTER, 280, 90):addTo(self.mBg, 2)
  self.mScheduleRefresh = self:schedule(function()
    self:updateTime(target)
  end, 1)
end

function M:updateTime(target)
  self.mCdTime = self.mCdTime - 1
  if self.mCdTime > 0 then
    self.mTimelabel:setString(self.mCdTime)
  else
    self:stopAction(self.mScheduleRefresh)
    self.mTimelabel:runAction(cc.RemoveSelf:create())
    self.mTimelabel = nil
    target:setButtonEnabled(true)
  end
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

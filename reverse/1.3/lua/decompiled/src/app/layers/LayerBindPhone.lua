local CLASS_NAME = "LayerBindPhone"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(cb)
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mCallback = cb
  self.mBg = nil
  self.mPhone = nil
  self.mVerification = nil
  self.mTimelabel = nil
  self.mCdTime = 60
  self:initUI()
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("login_scene/frame.png"):addTo(self.mNode)
  self.mBg = bg
  local str = DYLang.getString("S494", "")
  cc.ui.UILabel.new({
    text = str,
    size = 28,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(500, 85),
    color = cc.c3b(74, 41, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 392, 325):addTo(bg)
  cc.ui.UILabel.new({
    text = DYLang.getString("S495", ""),
    size = 25,
    color = cc.c3b(74, 41, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 230, 248):addTo(bg)
  self.mPhone = cc.ui.UIInput.new({
    image = "login_scene/input_bg.png",
    size = cc.size(378, 46),
    x = 420,
    y = 243,
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
    text = DYLang.getString("S496", ""),
    size = 25,
    color = cc.c3b(74, 41, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 230, 185):addTo(bg)
  self.mVerification = cc.ui.UIInput.new({
    image = "login_scene/input_bg.png",
    size = cc.size(378, 46),
    x = 420,
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
  local info = {
    {
      text = DYLang.getString("S497", ""),
      x = 151,
      y = 88,
      func = function(event)
        self:buttonListener("VERIFICATION", event.target)
      end
    },
    {
      text = DYLang.getString("S498", ""),
      x = 392,
      y = 88,
      func = function()
        self:buttonListener("BIND")
      end
    },
    {
      text = DYLang.getString("S499", ""),
      x = 639,
      y = 88,
      func = function()
        self:buttonListener("CLOSE")
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
  elseif tag == "BIND" then
    self:bindPhone()
  elseif tag == "CLOSE" then
    self:closeCallBack()
  end
end

local function isPhoneLegal(textStr)
  if not textStr or textStr == "" then
    return false
  end
  local i = 1
  while i <= #textStr do
    if string.byte(textStr, i) < 48 or string.byte(textStr, i) > 57 then
      return false
    end
    i = i + 1
  end
  return true
end

function M:sendVerification(target)
  local phone = string.trim(checkstring(self.mPhone:getText()))
  if phone == "" then
    self.mWarningNode:showMsg(DYLang.getString("S500", ""))
    return
  elseif not isPhoneLegal(phone) then
    self.mWarningNode:showMsg(DYLang.getString("S501", ""))
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
      msg = string.format(DYLang.getString("S502", ""), time)
      self.mWarningNode:showMsg(msg)
      self.mCdTime = time
    elseif jsonTable.errorCode ~= 0 then
      if not msg or msg == "" then
        msg = string.format(DYLang.getString("S503", ""), jsonTable.errorCode)
      end
      self.mWarningNode:showMsg(msg)
    else
      self.mWarningNode:showMsg(DYLang.getString("S504", ""))
    end
  end
  
  local game = DYUtils.gameId()
  local msgType = 1
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&game=%s&telephone=%s&type=%s", strAppSecret .. "", game .. "", phone .. "", msgType .. "")
  local params = {}
  params.telephone = phone
  params.game = game
  params.type = msgType
  params.sign = crypto.md5(strSign, false)
  DYHttpMgr.sendVerification(tFuncListener, params)
end

function M:bindPhone()
  local phone = string.trim(checkstring(self.mPhone:getText()))
  local verification = string.trim(checkstring(self.mVerification:getText()))
  if phone == "" then
    self.mWarningNode:showMsg(DYLang.getString("S500", ""))
    return
  elseif not isPhoneLegal(phone) then
    self.mWarningNode:showMsg(DYLang.getString("S501", ""))
    return
  elseif verification == "" then
    self.mWarningNode:showMsg(DYLang.getString("S507", ""))
    return
  end
  
  local function tFuncListener(jsonTable)
    local msg = jsonTable.errorMsg
    if jsonTable.errorCode ~= 0 then
      if not msg or msg == "" then
        msg = string.format(DYLang.getString("S503", ""), jsonTable.errorCode)
      end
      self.mWarningNode:showMsg(msg)
      return
    end
    self.mWarningNode:showMsg(DYLang.getString("S509", ""))
    CloudData.BIND_PHONE = phone
    if self.mCallback then
      self.mCallback()
    end
    self.mWarningNode:performWithDelay(function()
      self:closeCallBack()
    end, 0.2)
  end
  
  local game = DYUtils.gameId()
  local username = DYStat.getValueStr(DY_KEY.kUserName, "") or ""
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&game=%s&IdentifyCode=%s&telephone=%s&username=%s", strAppSecret .. "", game .. "", verification .. "", phone .. "", username .. "")
  local params = {}
  params.telephone = phone
  params.game = game
  params.IdentifyCode = verification
  params.username = username
  params.sign = crypto.md5(strSign, false)
  DYHttpMgr.accountBindPhone(tFuncListener, params)
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
  }):scale(0.8):align(display.CENTER, 217, 73):addTo(self.mBg, 2)
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

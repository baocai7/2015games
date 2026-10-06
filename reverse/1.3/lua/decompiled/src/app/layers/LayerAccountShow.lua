local LayerAccountLogin = require("app.layers.LayerAccountLogin")
local LayerBindPhone = require("app.layers.LayerBindPhone")
local CLASS_NAME = "LayerAccountShow"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mInfo = {}
  self.mBg = nil
  self:layoutUI()
  self:setNodeEventEnabled(true)
end

function M:layoutUI()
  self:addWidget()
  self:initData()
  self:addContent()
end

function M:addWidget()
  local bg = display.newSprite("login_scene/frame.png"):addTo(self.mNode)
  self.mBg = bg
end

function M:initData()
  if "player" == CloudData.USER_TYPE then
    self.mInfo.account = DYStat.getValueStr(DY_KEY.kUserName, "") or ""
    self.mInfo.button1 = {
      text = DYLang.getString("S443", ""),
      func = function()
        self:buttonListener("CHANGE")
      end
    }
    self.mInfo.button2 = {
      text = DYLang.getString("S444", ""),
      func = function()
        self:buttonListener("BIND")
      end
    }
  else
    self.mInfo.account = DYLang.getString("S445", "")
    self.mInfo.button1 = {
      text = DYLang.getString("S446", ""),
      func = function()
        self:buttonListener("CHANGE")
      end
    }
    self.mInfo.button2 = {
      text = DYLang.getString("S443", ""),
      func = function()
        self:buttonListener("CHANGE")
      end
    }
  end
end

function M:addContent()
  local rankStr = cc.ui.UILabel.new({
    text = DYLang.getString("S448", "") .. self.mInfo.account,
    size = 36,
    color = cc.c3b(74, 41, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.7):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 748, 438):onButtonClicked(function()
    self:buttonListener("CLOSE")
  end):addTo(self.mBg)
  local normalLabel = DYLabelTTF.new({
    text = self.mInfo.button1.text,
    size = 32,
    color = cc.c3b(255, 234, 200),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER"
  }, {
    lineWidth = 1,
    lineColor = cc.c3b(143, 78, 1)
  })
  local pressLabel = DYLabelTTF.new({
    text = self.mInfo.button1.text,
    size = 30,
    color = cc.c3b(255, 234, 200),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER"
  }, {
    lineWidth = 1,
    lineColor = cc.c3b(143, 78, 1)
  })
  local btnChange = cc.ui.UIPushButton.new({
    normal = "login_scene/button.png",
    pressed = "login_scene/button_h.png"
  }):setButtonLabel("normal", normalLabel):setButtonLabel("pressed", pressLabel):onButtonClicked(function()
    self.mInfo.button1.func()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  local normalLabel = DYLabelTTF.new({
    text = self.mInfo.button2.text,
    size = 32,
    color = cc.c3b(255, 234, 200),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER"
  }, {
    lineWidth = 1,
    lineColor = cc.c3b(143, 78, 1)
  })
  local pressLabel = DYLabelTTF.new({
    text = self.mInfo.button2.text,
    size = 30,
    color = cc.c3b(255, 234, 200),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER"
  }, {
    lineWidth = 1,
    lineColor = cc.c3b(143, 78, 1)
  })
  local btnBinding = cc.ui.UIPushButton.new({
    normal = "login_scene/button.png",
    pressed = "login_scene/button_h.png"
  }):setButtonLabel("normal", normalLabel):setButtonLabel("pressed", pressLabel):onButtonClicked(function()
    self.mInfo.button2.func()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.3):addTo(self.mBg)
  if "player" == CloudData.USER_TYPE then
    rankStr:setPositionY(self.mBg:getContentSize().height * 0.82)
    btnChange:setPositionY(self.mBg:getContentSize().height * 0.65)
    btnBinding:setPositionY(self.mBg:getContentSize().height * 0.45)
    cc.ui.UIPushButton.new({
      normal = "login_scene/button.png",
      pressed = "login_scene/button_h.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = "\230\179\168      \233\148\128",
      size = 32,
      color = cc.c3b(255, 234, 200),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(143, 78, 1)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = "\230\179\168      \233\148\128",
      size = 30,
      color = cc.c3b(255, 234, 200),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(143, 78, 1)
    })):onButtonClicked(function()
      self:unRegisterUser()
    end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.25):addTo(self.mBg)
  end
  self:addWarningNode()
end

function M:unRegisterUser()
  DYStat.setValueStr(DY_KEY.kUserName, "")
  DYStat.setValueStr(DY_KEY.kPassWord, "")
  DYStat.setValueBool(DY_KEY.kIsUserLogin, false)
  DYSoundMgr.stopMusic()
  self:performWithDelay(function()
    DYLoginMgr.logout()
  end, 0.2)
end

function M:addWarningNode()
  local node = display.newNode():pos(392, 400):addTo(self.mBg, 1)
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
  if tag == "CHANGE" then
    self:changeAccount()
  elseif tag == "BIND" then
    self:bindPhone()
  elseif tag == "CLOSE" then
    self:closeCallBack()
  end
end

function M:changeAccount()
  LayerAccountLogin.new():addTo(display.getRunningScene(), 20)
  self:closeCallBack()
end

function M:bindPhone()
  if "player" == CloudData.USER_TYPE and CloudData.BIND_PHONE and CloudData.BIND_PHONE ~= "" then
    self.mWarningNode:showMsg(DYLang.getString("S449", ""))
  else
    LayerBindPhone.new():addTo(display.getRunningScene(), 20)
    self:closeCallBack()
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

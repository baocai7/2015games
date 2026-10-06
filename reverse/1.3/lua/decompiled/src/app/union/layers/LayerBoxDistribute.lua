local CLASS_NAME = "LayerBoxDistribute"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(params)
  DDLOG(CLASS_NAME .. ": onCreate")
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mInfo = params.info
  if not self.mInfo then
    return
  end
  self.mIndex = checknumber(params.index)
  self.cb = params.cb
  self.mNum = checknumber(self.mInfo.box_count)
  self.mMax = checknumber(params.num)
  self.mNumLabel = nil
  self.mSumLabel = nil
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:initBg()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initBg()
  local bg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(598, 468), cc.rect(598, 125, 5, 5)):addTo(self.mNode)
  local iconFrame = display.newSprite("common_ui/frame4.png"):pos(200, 373):addTo(bg)
  if checkstring(self.mInfo.icon) ~= "" then
    display.newSprite(GameManager.USER_ICON_PATH .. self.mInfo.icon .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  end
  DYLabelTTF.new({
    text = "LV." .. checknumber(self.mInfo.level),
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "BOTTOM_RIGHT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(iconFrame:getContentSize().width * 0.94, iconFrame:getContentSize().height * 0.05):addTo(iconFrame, 1)
  if 0 < checknumber(self.mInfo.vip) then
    local vipFrame = display.newSprite("ranking/bg_vip.png"):align(display.CENTER_RIGHT, iconFrame:getContentSize().width, iconFrame:getContentSize().height):addTo(iconFrame)
    DYLabelTTF.new({
      text = self.mInfo.vip,
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(111, 47, 2)
    }):pos(vipFrame:getContentSize().width * 0.72, vipFrame:getContentSize().height * 0.32):addTo(vipFrame)
  end
  local nameBg = display.newScale9Sprite("common_ui/num_bg.png", 0, 0, cc.size(208, 42), cc.rect(50, 17, 1, 1)):pos(373, 396):addTo(bg)
  DYLabelTTF.new({
    text = self.mInfo.nick,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(nameBg:getContentSize().width * 0.5, nameBg:getContentSize().height * 0.5):addTo(nameBg)
  DYLabelTTF.new({
    text = DYLang.getString("S1631", ""),
    size = 26,
    color = cc.c3b(249, 241, 6),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(400, 342):addTo(bg)
  self.mSumLabel = DYLabelTTF.new({
    text = self.mMax,
    size = 26,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(405, 342):addTo(bg)
  local numBg = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(475, 121), cc.rect(50, 50, 2, 2)):pos(300, 230):addTo(bg)
  self.mNumLabel = DYLabelTTF.new({
    text = self.mNum,
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):align(display.CENTER, numBg:getContentSize().width * 0.5, numBg:getContentSize().height * 0.5):addTo(numBg)
  local decBtn = cc.ui.UIPushButton.new({
    normal = "package/btn_add.png"
  }):align(display.CENTER, numBg:getContentSize().width * 0.25, numBg:getContentSize().height * 0.5):addTo(numBg, 2):onButtonClicked(function()
    self:toSubtract()
  end)
  decBtn:setScaleX(-1)
  cc.ui.UIPushButton.new({
    normal = "package/btn_add.png"
  }):align(display.CENTER, numBg:getContentSize().width * 0.75, numBg:getContentSize().height * 0.5):addTo(numBg, 2):onButtonClicked(function()
    self:toAdd()
  end)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, 150, 90):addTo(bg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1632", ""),
    size = 32,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:confirm()
  end)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, 450, 90):addTo(bg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1633", ""),
    size = 32,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallBack()
  end)
end

function M:toSubtract()
  if self.mNum > 0 then
    self.mMax = self.mMax + 1
    self.mNum = self.mNum - 1
    self.mSumLabel:setString(self.mMax)
    self.mNumLabel:setString(self.mNum)
  else
    self.mNum = 0
    local toast = WSToast.new(DYLang.getString("S1634", ""))
    self:addChild(toast, 5)
  end
end

function M:toAdd()
  if self.mMax > 0 then
    self.mMax = self.mMax - 1
    self.mNum = self.mNum + 1
    self.mSumLabel:setString(self.mMax)
    self.mNumLabel:setString(self.mNum)
  else
    self.mMax = 0
    local toast = WSToast.new(DYLang.getString("S1635", ""))
    self:addChild(toast, 5)
  end
end

function M:confirm()
  if self.cb then
    self.cb({
      index = self.mIndex,
      num = self.mNum
    })
  end
  self:closeCallBack()
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

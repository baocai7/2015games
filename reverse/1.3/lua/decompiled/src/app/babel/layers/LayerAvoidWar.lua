local CLASS_NAME = "LayerAvoidWar"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(cb)
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mPeachCost = 0
  self.mTime = 0
  self.cb = cb
  self:initData()
  self:initBg()
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mPeachCost = checknumber(CloudData.BabelInfo.safeCost)
  self.mTime = 8
end

function M:initBg()
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  self.mBg = bg
  self:addContent()
  self:addButton()
end

function M:addContent()
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(514, 150), cc.rect(50, 50, 2, 2)):pos(self.mBg:getContentSize().width * 0.5, 218):addTo(self.mBg)
  cc.ui.UILabel.new({
    text = DYLang.getString("S101", ""),
    size = 25,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 211, 218):addTo(self.mBg)
  local peachIcon = display.newSprite("item_icon/pic_peach.png"):scale(0.75):align(display.CENTER, 238, 218):addTo(self.mBg)
  local lab1 = DYLabelTTF.new({
    text = self.mPeachCost,
    size = 25,
    color = cc.c3b(0, 255, 54),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, peachIcon:getPositionX() + 35, peachIcon:getPositionY()):addTo(self.mBg)
  local lab2 = cc.ui.UILabel.new({
    text = "\239\188\140\229\188\128\229\144\175",
    size = 25,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, lab1:getPositionX() + lab1:getContentSize().width + 5, lab1:getPositionY()):addTo(self.mBg)
  local lab3 = DYLabelTTF.new({
    text = self.mTime .. DYLang.getString("S102", ""),
    size = 25,
    color = cc.c3b(0, 255, 54),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, lab2:getPositionX() + lab2:getContentSize().width + 5, lab2:getPositionY()):addTo(self.mBg)
  local lab4 = cc.ui.UILabel.new({
    text = DYLang.getString("S103", ""),
    size = 25,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, lab3:getPositionX() + lab3:getContentSize().width + 5, lab3:getPositionY()):addTo(self.mBg)
end

function M:addButton()
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, 183, 79):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S104", ""),
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
  }):align(display.CENTER, 423, 79):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S105", ""),
    size = 32,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallBack()
  end)
end

function M:confirm()
  if CloudData.PEACH < self.mPeachCost then
    WSToast.new(DYLang.getString("S106", "")):addTo(self, 20)
    return
  end
  
  local function tFuncListener(info)
    if info.errorCode > 0 then
      local errMsg = info.errorMsg or "UNKONWN"
      WSToast.new(errMsg):addTo(self, 20)
    else
      self:peaceSucc(info.data)
    end
  end
  
  DYHttpMgr.babelAvoidWar(tFuncListener)
end

function M:peaceSucc(info)
  DataUtils.updateItemNum(1, checknumber(info.peachLeft))
  if self.cb then
    self.cb(checknumber(info.leftTime))
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

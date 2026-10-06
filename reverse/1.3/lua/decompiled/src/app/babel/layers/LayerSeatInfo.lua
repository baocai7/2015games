local IconItem = require("app.icons.IconItem")
local CLASS_NAME = "LayerSeatInfo"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(cb, params)
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.cb = cb
  self.mInfo = params
  self.mSeatIncome = {}
  self.mMySeatIncome = {}
  self.mSeatTag = false
  self:requestData()
  self:setNodeEventEnabled(true)
end

function M:requestData()
  local function tFuncListener(info)
    if info.errorCode > 0 then
      local errMsg = info.errorMsg or "UNKONWN"
      
      WSToast.new(errMsg):addTo(display.getRunningScene(), 20)
      self:closeCallBack()
    else
      self:initData(info.data)
      self:initBg()
    end
  end
  
  local params = {
    stageId = checknumber(self.mInfo.floor),
    seatId = checknumber(self.mInfo.seatId)
  }
  DYHttpMgr.babelSeatIncome(tFuncListener, params)
end

function M:initData(info)
  self.mSeatIncome = info.newIncome or {}
  self.mMySeatIncome = info.originIncome or {}
  for k, v in pairs(self.mMySeatIncome) do
    self.mSeatTag = true
    break
  end
end

function M:initBg()
  local h = 392
  if self.mSeatTag then
    h = 640
  end
  local bg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(660, h), cc.rect(299, 256, 1, 1)):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):align(display.CENTER, 183, 83):addTo(bg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S149", ""),
    size = 32,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:confirm()
  end)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):align(display.CENTER, 473, 83):addTo(bg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S150", ""),
    size = 32,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallBack()
  end)
  self:showMyIncome()
  self:showOtherIncome()
end

function M:showMyIncome()
  if not self.mSeatTag then
    return
  end
  local floor = checknumber(self.mInfo.myFloor)
  local seat = checkstring(self.mInfo.mySeat)
  local lab1 = DYLabelTTF.new({
    text = DYLang.getString("S151", ""),
    size = 23,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 77, 573):addTo(self.mBg)
  local str = string.format(DYLang.getString("S152", ""), floor, seat)
  local lab2 = DYLabelTTF.new({
    text = str,
    size = 23,
    color = cc.c3b(255, 213, 17),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, lab1:getPositionX() + lab1:getContentSize().width + 5, lab1:getPositionY()):addTo(self.mBg)
  DYLabelTTF.new({
    text = DYLang.getString("S153", ""),
    size = 23,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, lab2:getPositionX() + lab2:getContentSize().width + 5, lab2:getPositionY()):addTo(self.mBg)
  local frame = display.newScale9Sprite("babel/bg_gray.png", 0, 0, cc.size(550, 153), cc.rect(26, 21, 2, 2)):pos(self.mBg:getContentSize().width * 0.5, 467):addTo(self.mBg)
  local seatLab = DYLabelTTF.new({
    text = "\227\128\144" .. seat .. "\227\128\145",
    size = 21,
    color = cc.c3b(255, 213, 17),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):pos(6, 129):addTo(frame)
  display.newSprite("babel/profit_time.png"):align(display.CENTER_LEFT, seatLab:getPositionX() + seatLab:getContentSize().width, seatLab:getPositionY()):addTo(frame)
  local info = self.mMySeatIncome
  if not info then
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 10, 530, 103),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(frame)
  for k, v in pairs(self.mMySeatIncome) do
    local item = list:newItem()
    local content = IconItem.new(k, v)
    content:showItemTip()
    content:setScale(0.75)
    item:addContent(content)
    item:setItemSize(118, 100)
    list:addItem(item)
  end
  list:reload()
end

function M:showOtherIncome()
  local str1 = DYLang.getString("S154", "")
  local str2 = DYLang.getString("S155", "")
  if not self.mSeatTag then
    str1 = DYLang.getString("S156", "")
    str2 = DYLang.getString("S153", "")
  end
  local floor = checknumber(self.mInfo.floor)
  local seat = checkstring(self.mInfo.seat)
  local lab1 = DYLabelTTF.new({
    text = str1,
    size = 23,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 77, 334):addTo(self.mBg)
  local str = string.format(DYLang.getString("S152", ""), floor, seat)
  local lab2 = DYLabelTTF.new({
    text = str,
    size = 23,
    color = cc.c3b(255, 213, 17),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):pos(lab1:getPositionX() + lab1:getContentSize().width + 5, lab1:getPositionY()):addTo(self.mBg)
  DYLabelTTF.new({
    text = str2,
    size = 23,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, lab2:getPositionX() + lab2:getContentSize().width + 5, lab2:getPositionY()):addTo(self.mBg)
  local frame = display.newScale9Sprite("babel/bg_gray.png", 0, 0, cc.size(550, 153), cc.rect(26, 21, 2, 2)):pos(self.mBg:getContentSize().width * 0.5, 231):addTo(self.mBg)
  local seatLab = DYLabelTTF.new({
    text = "\227\128\144" .. seat .. "\227\128\145",
    size = 21,
    color = cc.c3b(255, 213, 17),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):pos(6, 129):addTo(frame)
  display.newSprite("babel/profit_time.png"):align(display.CENTER_LEFT, seatLab:getPositionX() + seatLab:getContentSize().width, seatLab:getPositionY()):addTo(frame)
  local info = self.mMySeatIncome
  if not info then
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 10, 530, 103),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(frame)
  for k, v in pairs(self.mSeatIncome) do
    local item = list:newItem()
    local content = IconItem.new(k, v)
    content:showItemTip()
    content:setScale(0.75)
    item:addContent(content)
    item:setItemSize(118, 100)
    list:addItem(item)
  end
  list:reload()
end

function M:confirm()
  if self.cb then
    self.cb(self.mInfo.index)
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

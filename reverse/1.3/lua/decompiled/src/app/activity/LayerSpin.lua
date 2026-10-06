local LayerSpinAward = require("app.activity.LayerSpinAward")
local LayerRecord = require("app.activity.LayerRecord")
local DataLabelIcon = require("app.icons.DataLabelIcon")
local DYClass = "LayerSpin"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M:ctor(cb)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  DYRes.loadSheet("animation/circle_tx.plist")
  DYRes.loadSheet("animation/pointer_tx.plist")
  self.mBg = nil
  self.mSpinInfo = {}
  self.mCallback = cb
  self.mDuration = ""
  self.mNeedUpdated = false
  self:initUI()
  self:requestData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("union/bg_inner.png"):addTo(self.mNode)
  self.mBg = bg
  local circle = display.newSprite("spin/circle.png", 874, 340):addTo(self.mBg)
  self.mCircleBg = circle
  self.mDisk = display.newSprite("spin/disk.png"):pos(circle:getContentSize().width * 0.5, circle:getContentSize().height * 0.475):addTo(circle)
  self.mPointer = display.newSprite("spin/pointer.png"):pos(circle:getContentSize().width * 0.5, circle:getContentSize().height * 0.81):addTo(circle)
  self.mStartBtn = cc.ui.UIPushButton.new({
    normal = "spin/start.png",
    pressed = "spin/start_h.png",
    disabled = "spin/start_u.png"
  }):pos(self.mDisk:getPositionX(), self.mDisk:getPositionY()):onButtonClicked(function()
    self:startCallBack()
  end):addTo(circle, 2)
  self.mStartBtn:setButtonEnabled(false)
  self.mStopBtn = cc.ui.UIPushButton.new({
    normal = "spin/stop.png",
    pressed = "spin/stop_h.png"
  }):pos(self.mDisk:getPositionX(), self.mDisk:getPositionY()):onButtonClicked(function()
    self:stopSpin(false)
  end):addTo(circle, 2)
  self.mStopBtn:setTouchSwallowEnabled(true)
  self.mStopBtn:setButtonEnabled(false)
  self.mStopBtn:setVisible(false)
  local timeStr = display.newSprite("spin/str.png"):align(display.CENTER_LEFT, 135, 80):addTo(bg)
  self.mFreeTimesText = cc.ui.UILabel.new({
    UILabelType = 1,
    text = "",
    font = "fonts/greenNum.fnt"
  }):scale(0.7):align(display.CENTER_LEFT, 175, 117):addTo(timeStr)
  self.mPayTimesText = cc.ui.UILabel.new({
    UILabelType = 1,
    text = "",
    font = "fonts/greenNum.fnt"
  }):scale(0.7):align(display.CENTER_LEFT, 175, 70):addTo(timeStr)
  self.mCostIcon = display.newSprite():scale(0.8):align(display.CENTER_LEFT, 175, 23):addTo(timeStr)
  self.mCostText = cc.ui.UILabel.new({
    UILabelType = 1,
    text = "",
    font = "fonts/greenNum.fnt"
  }):scale(0.7):align(display.CENTER_LEFT, 225, 23):addTo(timeStr)
  local descBg = display.newSprite("spin/desc_bg.png"):align(display.CENTER_LEFT, 105, 540):addTo(bg)
  self.mDurationLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 21,
    color = cc.c3b(0, 255, 42),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 87, 172):addTo(descBg)
  self.mDurationLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local awardPool = display.newSprite("spin/img_jackpot.png"):align(display.CENTER_LEFT, 105, 280):addTo(bg)
  self.mPoolPeachLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = 0,
    font = "fonts/award_num.fnt"
  }):align(display.CENTER, awardPool:getContentSize().width * 0.5, 100):addTo(awardPool)
  self:addTopPanel()
  cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):align(display.CENTER, display.width * 0.05, display.height * 0.95):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self, 1)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, display.width - 90, 40):setButtonLabel("normal", DYLabelTTF.new({
    text = "\232\142\183\229\165\150\232\174\176\229\189\149",
    size = 25,
    color = cc.c3b(238, 255, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(62, 73, 12),
    lineWidth = 2
  })):setButtonLabel("pressed", DYLabelTTF.new({
    text = "\232\142\183\229\165\150\232\174\176\229\189\149",
    size = 22,
    color = cc.c3b(238, 255, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(62, 73, 12),
    lineWidth = 2
  })):onButtonClicked(function()
    self:recordCallback()
  end):addTo(self, 1)
end

function M:addTopPanel()
  local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH, true)
  peachLabel:setPosition(cc.p(display.width * 0.85, display.height * 0.96))
  self:addChild(peachLabel, 15)
end

function M:requestData()
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local msg = info.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      self:initData(info.data)
      self:refreshUI()
    end
  end
  
  DYHttpMgr.spinInit(tFuncListener)
end

function M:initData(info)
  CloudData.SPIN_INFO = checknumber(info.leftFreeTimes)
  self.mFreeTimes = CloudData.SPIN_INFO
  self.mPayTimes = checknumber(info.leftPayTimes)
  self.mFinance = checknumber(info.finance)
  self.mCost = checknumber(info.cost)
  self.mPoolPeachNum = checknumber(info.peachPool)
  local beginTime = checknumber(info.beginTime)
  local endTime = checknumber(info.endTime)
  if 0 < beginTime and 0 < endTime then
    local m1 = os.date("%m", beginTime)
    local d1 = os.date("%d", beginTime)
    local m2 = os.date("%m", endTime)
    local d2 = os.date("%d", endTime)
    self.mDuration = string.format("%d\230\156\136%d\230\151\165 - %d\230\156\136%d\230\151\165", m1, d1, m2, d2)
  end
end

function M:refreshUI()
  if self.mFreeTimes > 0 or 0 < self.mPayTimes then
    self.mStartBtn:setButtonEnabled(true)
  else
    self.mStartBtn:setButtonEnabled(false)
  end
  self.mDisk:setRotation(0)
  self.mFreeTimesText:setString(self.mFreeTimes)
  self.mPayTimesText:setString(self.mPayTimes)
  self.mCostText:setString(self.mCost)
  local img = DataUtils.getCoinPic(self.mFinance)
  self.mCostIcon:setTexture(img)
  self.mDurationLabel:setString(self.mDuration)
  self.mPoolPeachLabel:setString(self.mPoolPeachNum)
end

function M:startCallBack()
  local money = checknumber(CloudData.GAME_ITEM_INFO[tostring(self.mFinance)])
  if money < self.mCost then
    local info = DataUtils.getItemModel(self.mFinance)
    local str = checkstring(info.itemName) .. DYLang.getString("S39", "")
    local toast = WSToast.new(str, 1.5)
    self:addChild(toast, 5)
    return
  end
  self.mStartBtn:setButtonEnabled(false)
  self.mStopBtn:setButtonEnabled(false)
  self.mStopBtn:setVisible(true)
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode ~= 0 then
      local msg = jsonTable.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
      self.mStopBtn:setVisible(false)
    else
      self.mSpinInfo = jsonTable.data
      self.mNeedUpdated = true
      self.mStopBtn:setButtonEnabled(true)
      self:spinSuccess()
    end
  end
  
  DYHttpMgr.drawLottery(tFuncListener)
end

function M:spinSuccess()
  if self.mCost > 0 then
    DYAnalyze.item.consume(self.mFinance, "PEACH", self.mCost, "SPIN")
  end
  local index = checknumber(self.mSpinInfo.id)
  local popupLayer = transition.sequence({
    cc.RotateBy:create(0.5 + 0.08333333333333333 * (1 - (index - 1) / 8), 2160 + (360 - (index - 1) * 45)),
    cc.RotateBy:create(0.5, 1800),
    cc.RotateBy:create(0.5, 1440),
    cc.RotateBy:create(0.5, 1080),
    cc.RotateBy:create(0.5, 720),
    cc.RotateBy:create(0.5, 360),
    cc.RotateBy:create(1, 360),
    cc.RotateBy:create(1, 180),
    cc.RotateBy:create(1, 90),
    cc.RotateBy:create(0.75, 45),
    cc.RotateBy:create(1, 45),
    cc.CallFunc:create(function()
      self:stopSpin(true)
    end)
  })
  self.mDisk:runAction(popupLayer)
  local frames = display.newFrames("circle%d.png", 1, 4)
  local animation = display.newAnimation(frames, 0.03)
  self.mCircleBg:playAnimationForever(animation)
end

function M:stopSpin(aniEnded)
  self.mStopBtn:setVisible(false)
  self.mDisk:stopAllActions()
  self.mCircleBg:stopAllActions()
  if aniEnded then
    self:awardInfoShow(self.mSpinInfo)
  else
    local index = checknumber(self.mSpinInfo.id)
    local popupLayer = transition.sequence({
      cc.RotateTo:create(0, 0),
      cc.RotateBy:create(0.3, 360 - (index - 1) * 45),
      cc.DelayTime:create(0.2),
      cc.CallFunc:create(function()
        self:awardInfoShow(self.mSpinInfo)
      end)
    })
    self.mDisk:runAction(popupLayer)
  end
  local frames = display.newFrames("pointer%d.png", 1, 2)
  local animation = display.newAnimation(frames, 0.05)
  local animate = cc.Animate:create(animation)
  self.mPointer:runAction(cc.Repeat:create(animate, 10))
end

function M:awardInfoShow()
  if self.mSpinInfo and self.mSpinInfo.id then
    LayerSpinAward.new(self.mSpinInfo, handler(self, self.refreshData)):addTo(self, 20)
  end
end

function M:refreshData()
  local itemId = checknumber(self.mSpinInfo.thingId)
  local itemNum = checknumber(self.mSpinInfo.count)
  local financeCount = checknumber(self.mSpinInfo.financeCount)
  local thingCount = checknumber(CloudData.GAME_ITEM_INFO[tostring(itemId)])
  thingCount = thingCount + itemNum
  DataUtils.updateItemNum(itemId, thingCount)
  DataUtils.updateItemNum(self.mFinance, financeCount)
  CloudData.SPIN_INFO = checknumber(self.mSpinInfo.leftFreeTimes)
  self.mFreeTimes = CloudData.SPIN_INFO
  self.mPayTimes = checknumber(self.mSpinInfo.leftPayTimes)
  self.mFinance = checknumber(self.mSpinInfo.finance)
  self.mCost = checknumber(self.mSpinInfo.cost)
  self.mPoolPeachNum = checknumber(self.mSpinInfo.peachPool)
  self.mNeedUpdated = false
  self:refreshUI()
end

function M:recordCallback()
  LayerRecord.new():addTo(self, 20)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mNeedUpdated and self.mSpinInfo then
    self:refreshData()
  end
  if self.mCallback then
    self.mCallback()
  end
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
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYRes.unloadSheet("animation/circle_tx.plist")
  DYRes.unloadSheet("animation/pointer_tx.plist")
end

return M

local IconItem = require("app.icons.IconItem")
local LayerLog = require("app.babel.layers.LayerLog")
local LayerTip = require("app.babel.layers.LayerTip")
local LayerAvoidWar = require("app.babel.layers.LayerAvoidWar")
local CLASS_NAME = "LayerRewardShow"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(cb)
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mInfo = {}
  self.mLevel = ""
  self.mTitle = ""
  self.mIsPay = 0
  self.mPeachCost = 0
  self.mCurProfit = 0
  self.mMaxProfit = 0
  self.mRewardInfo = {}
  self.mMsgNum = 0
  self.mInPeace = 0
  self.mSitTimeTip = ""
  self.cb = cb
  self.mPeachBtn = nil
  self.mPeaceBtn = nil
  self.mLogBtn = nil
  self.mRewardBtn = nil
  self.mProgress = nil
  self.mProLab = nil
  self.mProFreLab = nil
  self.mPeachTip = nil
  self.mPeachTimeLab = nil
  self.mRewardList = nil
  self.mSitTimeLab = nil
  self:requestData()
  self:setNodeEventEnabled(true)
end

function M:requestData()
  local function tFuncListener(info)
    if info.errorCode > 0 then
      local errMsg = info.errorMsg or "UNKONWN"
      
      WSToast.new(errMsg):addTo(self, M.Layers)
    else
      self.mInfo = info.data or {}
      self:initData(info.time)
      self:initBg()
    end
  end
  
  DYHttpMgr.babelReward(tFuncListener)
end

function M:initData(time)
  self.mLevel = DYLang.getString("S45", "") .. checknumber(CloudData.BabelInfo.currentStage) .. DYLang.getString("S130", "")
  self.mTitle = checkstring(CloudData.BabelInfo.seatName)
  self.mIsPay = checknumber(self.mInfo.accelerateLeftTime)
  self.mPeachCost = checknumber(self.mInfo.accelerateCost)
  self.mCurProfit = checknumber(self.mInfo.currentIncomeCount)
  self.mMaxProfit = checknumber(self.mInfo.totalIncomeCount)
  self.mRewardInfo = self.mInfo.income or {}
  self.mInPeace = checknumber(CloudData.BabelInfo.safeLeftTime)
  local sitTime = checknumber(self.mInfo.sitTime)
  local h = math.floor(sitTime / 3600)
  sitTime = sitTime % 3600
  local m = math.floor(sitTime / 60)
  if 0 < h then
    self.mSitTimeTip = h .. DYLang.getString("S131", "")
  end
  if 0 < m then
    self.mSitTimeTip = self.mSitTimeTip .. m .. DYLang.getString("S132", "")
  elseif h <= 0 then
    self.mSitTimeTip = self.mSitTimeTip .. "1\229\136\134\233\146\159"
  end
  CloudData.BabelLog = self.mInfo.fightLog or {}
  CloudData.BabelLog.time = checknumber(time)
  local regionId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kBabelLogId, regionId, CloudData.UID)
  local lastLogId = DYStat.getValueInt(str, 0)
  self.mMsgNum = 0
  local logInfo = CloudData.BabelLog or {}
  for i = 1, #logInfo do
    local id = checknumber(logInfo[i].id)
    local attack = checknumber(logInfo[i].selfUid) == CloudData.UID and 1 or 0
    if lastLogId < id and attack ~= 1 then
      self.mMsgNum = self.mMsgNum + 1
    elseif lastLogId >= id then
      break
    end
  end
end

function M:initBg()
  local bg = display.newSprite("pvp_ol/bg_rankInfo.png"):pos(0, -20):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, bg:getContentSize().width + 5, bg:getContentSize().height):addTo(bg):onButtonClicked(function()
    self:closeCallBack()
  end)
  local titleBg = display.newSprite("common_ui/title_frame.png"):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height - 33):addTo(self.mBg)
  display.newSprite("babel/title.png"):align(display.CENTER, titleBg:getContentSize().width * 0.5, titleBg:getContentSize().height * 0.5):addTo(titleBg)
  self:addContent()
  self:addButton()
  self:addReward()
end

function M:addContent()
  display.newSprite("babel/adorn.png"):align(display.CENTER_RIGHT, 362, 545):addTo(self.mBg)
  local adorn = display.newSprite("babel/adorn.png"):align(display.CENTER_RIGHT, 721, 545):addTo(self.mBg)
  adorn:setScaleX(-1)
  local title = self.mLevel .. "\194\183" .. self.mTitle
  DYLabelTTF.new({
    text = title,
    size = 30,
    color = cc.c3b(255, 200, 53),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, 550, 548):addTo(self.mBg)
  cc.ui.UILabel.new({
    text = DYLang.getString("S133", ""),
    size = 25,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 560, 488):addTo(self.mBg)
  self.mSitTimeLab = DYLabelTTF.new({
    text = self.mSitTimeTip,
    size = 25,
    color = cc.c3b(0, 255, 54),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 560, 488):addTo(self.mBg)
  local str = DYLang.getString("S134", "")
  if 0 < self.mIsPay then
    str = DYLang.getString("S135", "")
  end
  DYLabelTTF.new({
    text = str,
    size = 30,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 90, 445):addTo(self.mBg)
  local profitStr = display.newSprite("babel/profit_left.png"):align(display.CENTER, 318, 445):addTo(self.mBg)
  local progressFrame = display.newSprite("user_center/bar_bg.png", 545, 445):addTo(self.mBg)
  local progressBar = display.newProgressTimer("user_center/bar_pro.png", display.PROGRESS_TIMER_BAR):pos(progressFrame:getContentSize().width * 0.5, progressFrame:getContentSize().height * 0.5):addTo(progressFrame)
  progressBar:setMidpoint(cc.p(0, 0))
  progressBar:setBarChangeRate(cc.p(1, 0))
  self.mProgress = progressBar
  local rate = 0
  if 0 < self.mMaxProfit then
    rate = self.mCurProfit / self.mMaxProfit * 100
  end
  progressBar:setPercentage(rate)
  self.mProLab = DYLabelTTF.new({
    text = self.mCurProfit .. "/" .. self.mMaxProfit,
    size = 22,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, progressFrame:getContentSize().width * 0.5, progressFrame:getContentSize().height * 0.5):addTo(progressFrame, 1)
  self.mProFreLab = DYLabelTTF.new({
    text = "1\228\187\189/\229\176\143\230\151\182",
    size = 20,
    color = cc.c3b(0, 255, 54),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, 545, 405):addTo(self.mBg)
  if 0 < self.mIsPay then
    self.mProFreLab:setString("2\228\187\189/\229\176\143\230\151\182")
  end
end

function M:addButton()
  if self.mIsPay > 0 then
    self.mPeachTip = display.newSprite("babel/peach_meditation_str.png"):align(display.CENTER, 885, 445):addTo(self.mBg)
    local timeBg = display.newSprite("babel/name_bg.png"):align(display.CENTER, 110, -25):addTo(self.mPeachTip)
    self.mPeachTimeLab = DYLabelTTF.new({
      text = "",
      size = 25,
      color = cc.c3b(0, 255, 6),
      dyalign = "CENTER",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER, timeBg:getContentSize().width * 0.5, timeBg:getContentSize().height * 0.5):addTo(timeBg)
    self:startCountDown()
  else
    self:addPeachButton()
  end
  if 0 < self.mMsgNum then
    self.mLogBtn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }):scale(0.8):align(display.CENTER, 360, 130):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("S136", ""),
      size = 30,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(147, 78, 1)
    })):onButtonClicked(function()
      self:getRecord()
    end)
    local alertIcon = display.newSprite("babel/alert.png"):scale(1.25):align(display.CENTER, -330, 0):addTo(self.mLogBtn)
    cc.ui.UILabel.new({
      text = DYLang.getString("S137", "") .. self.mMsgNum .. DYLang.getString("S138", ""),
      size = 20,
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, alertIcon:getContentSize().width * 0.5 + 18, alertIcon:getContentSize().height * 0.5):addTo(alertIcon)
  end
  if self.mInPeace == 0 then
    self.mPeaceBtn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }):scale(0.8):align(display.CENTER, 908, 130):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("S139", ""),
      size = 30,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(147, 78, 1)
    })):onButtonClicked(function()
      self:keepPeace()
    end)
  else
    local avoidWarStr = display.newSprite("babel/war_avoid.png", 827, 130):addTo(self.mBg)
    for i = 1, 3 do
      display.newSprite("babel/point.png", 111 + i * 25, 20):addTo(avoidWarStr)
    end
  end
  for k, v in pairs(self.mRewardInfo) do
    self.mRewardBtn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }):scale(0.8):align(display.CENTER, 908, 259):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("S3", ""),
      size = 30,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(147, 78, 1)
    })):onButtonClicked(function()
      self:getReward()
    end)
    break
  end
end

function M:addPeachButton()
  self.mPeachBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.8):align(display.CENTER, 907, 445):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S141", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(147, 78, 1)
  })):onButtonClicked(function()
    self:clickPeachSeat()
  end)
  local peachIcon = display.newSprite("item_icon/pic_peach.png"):align(display.CENTER, -180, 0):addTo(self.mPeachBtn)
  DYLabelTTF.new({
    text = self.mPeachCost,
    size = 28,
    color = cc.c3b(0, 255, 54),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, peachIcon:getPositionX() + 25, peachIcon:getPositionY() - 5):addTo(self.mPeachBtn)
  local tipIcon = display.newSprite("babel/alert.png"):scale(1.25):align(display.CENTER, -90, -70):addTo(self.mPeachBtn)
  local lab1 = DYLabelTTF.new({
    text = "8",
    size = 23,
    color = cc.c3b(0, 255, 54),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, tipIcon:getPositionX() + 26, tipIcon:getPositionY()):addTo(self.mPeachBtn)
  local lab2 = cc.ui.UILabel.new({
    text = DYLang.getString("S142", ""),
    size = 23,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, lab1:getPositionX() + lab1:getContentSize().width + 5, lab1:getPositionY()):addTo(self.mPeachBtn)
  local lab3 = DYLabelTTF.new({
    text = "X2",
    size = 23,
    color = cc.c3b(0, 255, 54),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, lab2:getPositionX() + lab2:getContentSize().width + 5, lab2:getPositionY()):addTo(self.mPeachBtn)
end

function M:addReward()
  display.newSprite("babel/profit_gain.png"):align(display.CENTER_LEFT, 77, 328):addTo(self.mBg)
  if not self.mRewardInfo then
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(85, 210, 740, 104),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(self.mBg)
  self.mRewardList = list
  for k, v in pairs(self.mRewardInfo) do
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

function M:clickPeachSeat()
  LayerTip.new(DYLang.getString("S143", "") .. self.mPeachCost .. DYLang.getString("S144", ""), handler(self, self.toPeachSeat)):addTo(self, 20)
end

function M:toPeachSeat()
  if CloudData.PEACH < self.mPeachCost then
    WSToast.new(DYLang.getString("S145", "")):addTo(self, 20)
    return
  end
  
  local function tFuncListener(info)
    if info.errorCode > 0 then
      local errMsg = info.errorMsg or "UNKONWN"
      WSToast.new(errMsg):addTo(self, 20)
    else
      self:getPeachSeat(info.data)
    end
  end
  
  DYHttpMgr.babelPeachMeditation(tFuncListener)
end

function M:getPeachSeat(info)
  DataUtils.updateItemNum(1, checknumber(info.peachLeft))
  self.mIsPay = checknumber(info.leftTime)
  if self.mPeachBtn then
    self.mPeachBtn:runAction(cc.RemoveSelf:create())
    self.mPeachBtn = nil
    self.mProFreLab:setString("2\228\187\189/\229\176\143\230\151\182")
    self.mPeachTip = display.newSprite("babel/peach_meditation_str.png"):align(display.CENTER, 885, 445):addTo(self.mBg)
    local timeBg = display.newSprite("babel/name_bg.png"):align(display.CENTER, 110, -25):addTo(self.mPeachTip)
    self.mPeachTimeLab = DYLabelTTF.new({
      text = "",
      size = 25,
      color = cc.c3b(0, 255, 6),
      dyalign = "CENTER",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER, timeBg:getContentSize().width * 0.5, timeBg:getContentSize().height * 0.5):addTo(timeBg)
    self:startCountDown()
  end
end

function M:getRecord()
  LayerLog.new(handler(self, self.logCallback)):addTo(self, 20)
end

function M:logCallback()
  self.mMsgNum = 0
  if self.mLogBtn then
    self.mLogBtn:runAction(cc.RemoveSelf:create())
    self.mLogBtn = nil
  end
end

function M:keepPeace()
  LayerAvoidWar.new(handler(self, self.peaceCallback)):addTo(self, 20)
end

function M:peaceCallback(time)
  self.mInPeace = checknumber(time)
  if self.mPeaceBtn then
    self.mPeaceBtn:runAction(cc.RemoveSelf:create())
    self.mPeaceBtn = nil
    local avoidWarStr = display.newSprite("babel/war_avoid.png", 827, 130):addTo(self.mBg)
    for i = 1, 3 do
      display.newSprite("babel/point.png", 111 + i * 25, 20):addTo(avoidWarStr)
    end
  end
end

function M:getReward()
  DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
  
  local function tFuncListener(info)
    if info.errorCode > 0 then
      local errMsg = info.errorMsg or "UNKONWN"
      WSToast.new(errMsg):addTo(display.getRunningScene(), 20)
      if info.errorCode == 294 then
        self:loseSeat()
      end
    else
      WSToast.new(DYLang.getString("S146", "")):addTo(self, 20)
      self:getRewardSucc(info.data)
    end
  end
  
  DYHttpMgr.getBabelReward(tFuncListener)
end

function M:getRewardSucc(info)
  local award = info.award or {}
  for k, v in pairs(award) do
    DataUtils.updateItemNum(k, v)
  end
  self.mCurProfit = 0
  self.mRewardInfo = {}
  if self.mRewardList then
    self.mRewardList:runAction(cc.RemoveSelf:create())
    self.mRewardList = nil
  end
  if self.mRewardBtn then
    self.mRewardBtn:runAction(cc.RemoveSelf:create())
    self.mRewardBtn = nil
  end
  self.mProgress:setPercentage(0)
  self.mProLab:setString("0/" .. self.mMaxProfit)
  self.mSitTimeTip = ""
  local sitTime = checknumber(info.sitTime)
  local h = math.floor(sitTime / 3600)
  sitTime = sitTime % 3600
  local m = math.floor(sitTime / 60)
  if 0 < h then
    self.mSitTimeTip = h .. DYLang.getString("S131", "")
  end
  if 0 < m then
    self.mSitTimeTip = self.mSitTimeTip .. m .. DYLang.getString("S132", "")
  elseif h <= 0 then
    self.mSitTimeTip = self.mSitTimeTip .. "1\229\136\134\233\146\159"
  end
  self.mSitTimeLab:setString(self.mSitTimeTip)
end

function M:startCountDown()
  if not self.mPeachTimeLab then
    return
  end
  local time = self.mIsPay
  self.mHours = math.floor(time / 3600)
  time = time % 3600
  self.mMinutes = math.floor(time / 60)
  self.mSeconds = math.floor(time % 60)
  self.mPeachTimeLab:setString(string.format("%02d:%02d:%02d", self.mHours, self.mMinutes, self.mSeconds))
  self.schedule = self:schedule(function()
    self:updateSecond()
  end, 1)
end

function M:updateSecond()
  self.mIsPay = self.mIsPay - 1
  if self.mSeconds > 0 then
    self.mSeconds = self.mSeconds - 1
  elseif 0 < self.mMinutes then
    self.mMinutes = self.mMinutes - 1
    self.mSeconds = 59
  elseif 0 < self.mHours then
    self.mHours = self.mHours - 1
    self.mMinutes = 59
    self.mSeconds = 59
  else
    self:countdownOver()
  end
  if self.mPeachTimeLab then
    self.mPeachTimeLab:setString(string.format("%02d:%02d:%02d", self.mHours, self.mMinutes, self.mSeconds))
  end
end

function M:countdownOver()
  self:stopAction(self.schedule)
  self.mPeachTip:runAction(cc.RemoveSelf:create())
  self.mPeachTip = nil
  self:addPeachButton()
end

function M:loseSeat()
  if self.cb then
    self.cb("LOSESEAT")
  end
  self:runAction(cc.RemoveSelf:create())
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.cb then
    self.cb("UPDATE", self.mInPeace, self.mMsgNum, self.mCurProfit)
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

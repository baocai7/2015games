local FramePrivilege = require("app.icons.FramePrivilege")
local FrameRecharge = require("app.icons.FrameRecharge")
local CLASS_NAME = "LayerRecharge"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.RECHARGE = 1
M.PRIVILEGE = 2

function M:ctor(mType)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mBg = nil
  self.mRechargeBg = nil
  self.mPrivilegeBg = nil
  self.mTitleImg = nil
  self.mSwitchLabel = nil
  self.mCurVipIcon = nil
  self.mNextVipIcon = nil
  self.mProgressBar = nil
  self.mProgressLabel = nil
  self.mType = mType or M.RECHARGE
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initBg()
  self:requestData()
end

function M:initBg()
  self.mBg = display.newSprite("purgatory/bg.png"):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.96, self.mBg:getContentSize().height * 0.94):addTo(self.mBg):onButtonClicked(function()
    self:closeCallBack()
  end)
  self.mTitleImg = display.newSprite("recharge/recharge_icon.png", self.mBg:getContentSize().width * 0.13, self.mBg:getContentSize().height * 0.8):addTo(self.mBg)
  self.mSwitchLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S869", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  self.mSwitchLabel:enableOutline(cc.c4b(147, 78, 1, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.74 + 92, self.mBg:getContentSize().height * 0.8):addTo(self.mBg, 2):setButtonLabel("normal", self.mSwitchLabel):onButtonClicked(function()
    self:switchUI()
  end)
  self.mCurVipIcon = display.newSprite():pos(self.mBg:getContentSize().width * 0.23 + 38, self.mBg:getContentSize().height * 0.84):addTo(self.mBg)
  self.mNextVipIcon = display.newSprite():pos(self.mBg:getContentSize().width * 0.61 + 30, self.mBg:getContentSize().height * 0.84):addTo(self.mBg)
  local progressFrame = display.newSprite("recharge/progress_bg.png", self.mBg:getContentSize().width * 0.42 + 40, self.mBg:getContentSize().height * 0.76):addTo(self.mBg)
  self.mProgressBar = display.newProgressTimer("recharge/progress_bar.png", display.PROGRESS_TIMER_BAR):pos(progressFrame:getContentSize().width * 0.5, progressFrame:getContentSize().height * 0.5):addTo(progressFrame)
  self.mProgressBar:setMidpoint(cc.p(0, 0))
  self.mProgressBar:setBarChangeRate(cc.p(1, 0))
  self.mProgressBar:setPercentage(0)
  self.mProgressLabel = cc.ui.UILabel.new({
    text = "",
    size = 22,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, progressFrame:getContentSize().width * 0.5, progressFrame:getContentSize().height * 0.5):addTo(progressFrame, 5)
  self.mProgressLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:requestData()
  local function tFuncListener(signInfo)
    local info = signInfo.data.paymentMap
    
    CloudData.PAYMENT_INFO_TABLE = DataUtils.getSortedPaymentInfo(info)
    CloudData.VIP_PACKAGE_STATUS_INFO = signInfo.data.packageStatus
    if CloudData.VIP_PACKAGE_STATUS_INFO == nil then
      CloudData.VIP_PACKAGE_STATUS_INFO = {}
    end
    if self.showVipInfo then
      self:showVipInfo()
    else
      return
    end
    if self.mType and self.mType == M.PRIVILEGE and self.showPrivilegeUI then
      self:showPrivilegeUI()
    elseif self.showRechargeUI then
      self:showRechargeUI()
    end
    self.mType = nil
  end
  
  DYHttpMgr.getPaymentList(tFuncListener)
end

function M:showVipInfo(vipLevel)
  local vip = tonumber(CloudData.VIP_LEVEL)
  if vip > #DataRetainer.VIP_PRIVILEGE_INFO - 2 then
    CloudData.VIP_LEVEL = 0
    vip = 0
  end
  if not vipLevel or tonumber(vipLevel) <= vip + 1 then
    vipLevel = vip + 1
  end
  self.mCurVipIcon:setTexture("recharge/vip" .. vip .. ".png")
  self.mCurVipIcon:removeAllChildren()
  local curCostNum = CloudData.PEACH_BUY_COUNT / 10
  local totalNum = 1
  local progressMsg = ""
  if vip == #DataRetainer.VIP_PRIVILEGE_INFO - 2 then
    self.mCurVipIcon:setPositionX(self.mBg:getContentSize().width * 0.42 + 40)
    totalNum = curCostNum
    if self.mNextVipIcon then
      self.mNextVipIcon:setVisible(false)
    end
  else
    local nextVip = tonumber(vipLevel)
    self.mNextVipIcon:setTexture("recharge/vip" .. nextVip .. ".png")
    totalNum = DataUtils.getVipCountPeach(nextVip) / 10
    if nextVip == 1 then
      local tipLabel = cc.ui.UILabel.new({
        text = DYLang.getString("S870", ""),
        size = 20,
        color = cc.c3b(7, 255, 25),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER_LEFT, self.mCurVipIcon:getContentSize().width + 35, self.mCurVipIcon:getContentSize().height * 0.5):addTo(self.mCurVipIcon)
      tipLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    else
      local tipLabel1 = cc.ui.UILabel.new({
        text = DYLang.getString("S871", ""),
        size = 20,
        color = cc.c3b(7, 255, 25),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER_LEFT, self.mCurVipIcon:getContentSize().width + 15, self.mCurVipIcon:getContentSize().height * 0.5):addTo(self.mCurVipIcon)
      tipLabel1:enableOutline(cc.c4b(0, 0, 0, 255), 2)
      local num = totalNum - curCostNum
      local tipLabel2 = cc.ui.UILabel.new({
        text = num,
        size = 20,
        color = cc.c3b(243, 10, 16),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER_LEFT, tipLabel1:getPositionX() + tipLabel1:getContentSize().width + 5, tipLabel1:getPositionY()):addTo(self.mCurVipIcon)
      local tipLabel3 = cc.ui.UILabel.new({
        text = DYLang.getString("S872", ""),
        size = 20,
        color = cc.c3b(7, 255, 25),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER_LEFT, tipLabel2:getPositionX() + tipLabel2:getContentSize().width + 5, tipLabel2:getPositionY()):addTo(self.mCurVipIcon)
      tipLabel3:enableOutline(cc.c4b(0, 0, 0, 255), 2)
      progressMsg = curCostNum .. "/" .. totalNum
    end
  end
  self.mProgressBar:setPercentage(curCostNum / totalNum * 100)
  self.mProgressLabel:setString(progressMsg)
end

function M:switchUI()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self:showVipInfo()
  if self.mRechargeBg then
    self.mRechargeBg:runAction(cc.RemoveSelf:create())
    self.mRechargeBg = nil
    self:showPrivilegeUI()
  elseif self.mPrivilegeBg then
    self.mPrivilegeBg:runAction(cc.RemoveSelf:create())
    self.mPrivilegeBg = nil
    self:showRechargeUI()
  end
end

function M:showRechargeUI()
  self.mTitleImg:setTexture("recharge/recharge_icon.png")
  self.mSwitchLabel:setString(DYLang.getString("S869", ""))
  self.mRechargeBg = FrameRecharge.new(handler(self, self.refreshVipInfo))
  self.mRechargeBg:setPosition(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.39)
  self.mBg:addChild(self.mRechargeBg)
end

function M:showPrivilegeUI()
  self.mTitleImg:setTexture("recharge/vip_icon.png")
  self.mSwitchLabel:setString(DYLang.getString("S874", ""))
  self.mPrivilegeBg = FramePrivilege.new(handler(self, self.showVipInfo))
  self.mPrivilegeBg:setPosition(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.39)
  self.mBg:addChild(self.mPrivilegeBg)
end

function M:refreshVipInfo()
  if self.mRechargeBg then
    self.mRechargeBg:runAction(cc.RemoveSelf:create())
    self.mRechargeBg = nil
  end
  self:requestData()
  local widget = display.getRunningScene().mUserVipLevel
  if widget then
    widget:setTexture(string.format("recharge/vip%d.png", CloudData.VIP_LEVEL))
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  CloudData.PAYMENT_INFO_TABLE = {}
  CloudData.VIP_PACKAGE_STATUS_INFO = {}
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
  end
  return true
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

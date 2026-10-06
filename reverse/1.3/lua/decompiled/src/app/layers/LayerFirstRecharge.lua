local LayerRecharge = require("app.layers.LayerRecharge")
local IconItem = require("app.icons.IconItem")
local LayerBoxShow = require("app.layers.LayerBoxShow")
local CLASS_NAME = "LayerFirstRecharge"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(cb)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCallback = cb
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  DYRes.loadSheet("animation/first_recharge.plist")
  self:initData()
  self:initUI()
end

function M:initData()
  if not CloudData.RECHARGE_REWARD then
    return
  end
  self.mStatus = 0
  self.mRechargeNum = CloudData.RECHARGE_REWARD.money
  self.mRewardIds = split(CloudData.RECHARGE_REWARD.things, ";")
  self.mRewardNums = split(CloudData.RECHARGE_REWARD.counts, ";")
  if CloudData.MONEY >= self.mRechargeNum then
    self.mStatus = 1
  end
end

function M:initUI()
  self.mBg = display.newSprite("recharge/first_recharge_bg.png"):addTo(self.mNode)
  self.mTitle = display.newSprite("recharge/label1.png"):align(display.CENTER_LEFT, 215, 345):addTo(self.mBg)
  self.mRechargeLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = self.mRechargeNum,
    font = "fonts/activity_num.fnt"
  }):hide():align(display.CENTER_LEFT, 485, 390):addTo(self.mBg)
  if CloudData.RECHARGE_REWARD.isFirst ~= 1 then
    self.mTitle:setTexture("recharge/label2.png")
    self.mRechargeLabel:show()
  end
  self:loadRewardItem()
  self.mAwardBtn = cc.ui.UIPushButton.new({
    normal = "recharge/get.png",
    pressed = "recharge/get1.png"
  }):onButtonClicked(function()
    self:buttonClicked()
  end):align(display.CENTER, 547, 113):addTo(self.mBg)
  if 0 == self.mStatus then
    self.mAwardBtn:setButtonImage("normal", "recharge/recharge.png")
    self.mAwardBtn:setButtonImage("pressed", "recharge/recharge1.png")
  end
  cc.ui.UIPushButton.new({
    normal = "recharge/close.png",
    pressed = "recharge/close1.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, 702, 422):addTo(self.mBg, 2)
end

function M:loadRewardItem()
  if self.mFrame then
    self.mFrame:removeSelf()
    self.mFrame = nil
  end
  self.mFrame = display.newNode():addTo(self.mBg)
  self.mFrame:setPosition(460, 230)
  self.mFrame:setContentSize(472, 118)
  self.mFrame:setAnchorPoint(0.5, 0.5)
  for i = 1, #self.mRewardIds do
    local id = self.mRewardIds[i]
    local num = tonumber(self.mRewardNums[i])
    if 10000 < num then
      num = math.floor(num / 10000)
      num = num .. DYLang.getString("S42", "")
    end
    local icon = IconItem.new(id)
    icon:setScale(0.7)
    icon:setPosition(59 + (i - 1) * 118, 59)
    self.mFrame:addChild(icon)
    icon:showItemTip()
    DYLabelTTF.new({
      text = "X" .. num,
      size = 24,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF,
      dyalign = "BOTTOM_RIGHT"
    }, {}):pos(40, -45):addTo(icon)
    local model = DataUtils.getItemModelWithColor(id)
    DYLabelTTF.new({
      text = model.name,
      size = 24,
      color = model.color,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_TOP"
    }, {}):pos(icon:getContentSize().width * 0.5, -66):addTo(icon)
    local frames = display.newFrames("first_recharge%d.png", 1, 16)
    local animation = display.newAnimation(frames, 0.04)
    local emptySp = display.newSprite():scale(1.4285714285714286):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):addTo(icon, 2)
    emptySp:playAnimationForever(animation)
  end
end

function M:buttonClicked()
  if self.mStatus == 1 then
    self:toGetGift()
  else
    local layer = LayerRecharge.new()
    display.getRunningScene():addChild(layer, 20)
    self:closeCallBack()
  end
end

function M:toGetGift()
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local errMsg = info.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(info.errorMsg, 2)
      self:addChild(toast, 20)
    else
      self:getGiftSuccess(info.data)
    end
  end
  
  DYHttpMgr.getRechargeReward(tFuncListener)
end

function M:getGiftSuccess(info)
  local award = {}
  for k, v in pairs(info.rewardGain) do
    local info = {
      id = tonumber(k),
      num = tonumber(v)
    }
    table.insert(award, info)
  end
  local awardTable = {boxInfo = award}
  local tip = LayerBoxShow.new(awardTable, LayerBoxShow.AWARD_GET)
  display.getRunningScene():addChild(tip, 20)
  for id, num in pairs(info.reward) do
    DataUtils.updateItemNum(id, num)
  end
  CloudData.RECHARGE_REWARD = info.payAward
  self:initData()
  self:updateUI()
end

function M:updateUI()
  if not CloudData.RECHARGE_REWARD then
    self.mAwardBtn:hide()
    self.mAwardBtn:setButtonEnabled(false)
    return
  end
  if CloudData.RECHARGE_REWARD.isFirst ~= 1 then
    self.mTitle:setTexture("recharge/label2.png")
    self.mRechargeLabel:show()
    self.mRechargeLabel:setString(self.mRechargeNum)
  end
  self:loadRewardItem()
  if 0 == self.mStatus then
    self.mAwardBtn:setButtonImage("normal", "recharge/recharge.png")
    self.mAwardBtn:setButtonImage("pressed", "recharge/recharge1.png")
  elseif 1 == self.mStatus then
    self.mAwardBtn:setButtonImage("normal", "recharge/get.png")
    self.mAwardBtn:setButtonImage("pressed", "recharge/get1.png")
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:runAction(cc.RemoveSelf:create())
    end)
  })
  self.mNode:runAction(popupLayer)
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
  DYRes.unloadSheet("animation/first_recharge.plist")
end

return M

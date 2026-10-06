local WSToast = require("app.utils.WSToast")
local LayerBoxShow = require("app.layers.LayerBoxShow")
local CLASS_NAME = "LayerBuyVipGift"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(info)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mBg = nil
  self.mPrice = tonumber(info.price) or 0
  self.mVipLevel = info.vip or 0
  self.cb = info.cb
  self.mAward = info.award
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):scale(0):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self:initBg()
end

function M:initBg()
  local tip = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(523, 160), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.54):addTo(tip)
  local str = DYLang.getString("S554", "") .. self.mPrice .. DYLang.getString("S555", "") .. self.mVipLevel .. DYLang.getString("S556", "")
  cc.ui.UILabel.new({
    text = str,
    size = 25,
    color = cc.c3b(66, 49, 29),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.54):addTo(tip)
  local cancelLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S557", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  cancelLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):align(display.CENTER, tip:getContentSize().width * 0.3, tip:getContentSize().height * 0.2):addTo(tip, 2):setButtonLabel("normal", cancelLabel):onButtonClicked(function()
    self:closeCallBack()
  end)
  local confirmLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S558", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  confirmLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):align(display.CENTER, tip:getContentSize().width * 0.7, tip:getContentSize().height * 0.2):addTo(tip, 2):setButtonLabel("normal", confirmLabel):onButtonClicked(function()
    self:toBuyGift()
  end)
end

function M:toBuyGift()
  if CloudData.PEACH < self.mPrice then
    local toast = WSToast.new(DYLang.getString("S559", ""), 2)
    self:addChild(toast, 20)
    return
  end
  
  local function tFuncListener(response)
    if response.errorCode ~= 0 then
      local toast = WSToast.new(response.errorMsg, 2)
      self:addChild(toast, 20)
    else
      self:giftBuySuccessed(response.data)
    end
  end
  
  local params = {}
  params.packageId = self.mVipLevel
  DYHttpMgr.buyVipGift(tFuncListener, params)
end

function M:giftBuySuccessed(info)
  local awardTable = {
    boxInfo = self.mAward
  }
  local tip = LayerBoxShow.new(awardTable, LayerBoxShow.AWARD_GET)
  display.getRunningScene():addChild(tip, 20)
  DYAnalyze.item.consume(1, "PEACH", self.mPrice, "BUY_VIP_GIFT")
  CloudData.VIP_PACKAGE_STATUS_INFO[tostring(self.mVipLevel)] = 1
  CloudData.PEACH = tonumber(info.peach)
  CloudData.GAME_ITEM_INFO["1"] = CloudData.PEACH
  local awardInfo = info.reward or {}
  for id, num in pairs(awardInfo) do
    DataUtils.updateItemNum(id, num)
  end
  if self.cb then
    self.cb()
  end
  self:closeCallBack()
end

function M:closeCallBack()
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.mNode:runAction(popupLayer)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:removeSelf()
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

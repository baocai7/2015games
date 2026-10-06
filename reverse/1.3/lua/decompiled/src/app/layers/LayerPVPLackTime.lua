local WSToast = require("app.utils.WSToast")
local CLASS_NAME = "LayerPVPLackTime"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mCostPeachNum = 0
  self.mTag = false
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self:initData()
  self:initUI()
end

local function getBuyTimes()
  local vipModel = DataUtils.getVipPrivilege(CloudData.VIP_LEVEL)
  return tonumber(vipModel.pvpResetCount) or 0
end

local function getCost(time)
  local costInfo = DYCommon.getDataByTag(DataRetainer.PVP_COUNT_CONSUME, "id", tostring(time))[1]
  if not costInfo then
    DDERROR("pvp countConsume: %d with error data", tonumber(time))
    return 0
  end
  return tonumber(costInfo.pvpBuyPeach) or 0
end

function M:initData()
  local maxTime = getBuyTimes()
  local boughtTime = tonumber(CloudData.PVP_INFO.hasBuyFightCount)
  if maxTime <= boughtTime then
    self.mTag = false
  else
    self.mTag = true
    self.mCostPeachNum = getCost(boughtTime + 1)
  end
end

function M:initUI()
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.TOP_RIGHT, bg:getContentSize().width, bg:getContentSize().height):addTo(bg)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(502, 181), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.55):addTo(bg)
  local str = DYLang.getString("S799", "")
  cc.ui.UILabel.new({
    text = str,
    size = 25,
    color = cc.c3b(84, 52, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.65):addTo(bg)
  local strLabel = cc.ui.UILabel.new({
    text = "",
    size = 25,
    dimensions = cc.size(430, 90),
    align = cc.ui.TEXT_ALIGN_CENTER,
    color = cc.c3b(84, 52, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.45):addTo(bg)
  if self.mTag then
    strLabel:setString(DYLang.getString("S800", "") .. self.mCostPeachNum .. DYLang.getString("S801", ""))
  else
    strLabel:setString(DYLang.getString("S802", ""))
  end
  local newLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S38", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  newLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", newLabel):onButtonClicked(function()
    self:confirmCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.19):addTo(bg)
end

function M:confirmCallBack()
  if not self.mTag then
    self:closeCallBack()
  elseif CloudData.PEACH < self.mCostPeachNum then
    local t = WSToast.new(DYLang.getString("S804", ""), 1)
    self:addChild(t, 100)
    self:closeCallBack()
  else
    local teamStr = json.encode(GameManager.PVP_BUDDHA_INFO.team)
    
    local function tFuncListener(jsonTable)
      if jsonTable.errorCode ~= 0 then
        local toast = WSToast.new(jsonTable.errorMsg, 2)
        self:addChild(toast, 20)
      else
        CloudData.PEACH = tonumber(jsonTable.data.peach) or 0
        self:continue()
      end
    end
    
    local params = {}
    params.AttackTeam = teamStr
    DYHttpMgr.costPVPRaceNum(tFuncListener, params)
  end
end

function M:continue()
  self:closeCallBack()
  display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE"))
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

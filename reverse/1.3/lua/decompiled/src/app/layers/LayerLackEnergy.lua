local WSToast = require("app.utils.WSToast")
local LayerLackPeach = require("app.layers.LayerLackPeach")
local LayerRecharge = require("app.layers.LayerRecharge")
local IconItem = require("app.icons.IconItem")
local CLASS_NAME = "LayerLackEnergy"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mPeachCost = 0
  self.mGinsenNum = CloudData.GINSENG_FRUIT
  self.mGinsenLabel = nil
  self.mCostLabel = nil
  self.mCanBuy = false
  self.mTipLayer = nil
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self:initData()
end

local function getBuyTimes()
  local vipModel = DataUtils.getVipPrivilege(CloudData.VIP_LEVEL)
  return tonumber(vipModel.purchaseEnergyCount) or 0
end

local function getCost(time)
  local costInfo = DYCommon.getDataByTag(DataRetainer.PVP_COUNT_CONSUME, "id", tostring(time))[1]
  if not costInfo then
    DDERROR("pvp countConsume: %d with error data", tonumber(time))
    return 0
  end
  return tonumber(costInfo.ginsenBuyPeach) or 0
end

function M:initData()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode ~= 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    CloudData.GINSEN_BUY_TIME = jsonTable.data.ginsenBuyTimes
    self:initUI()
    self:refreshControls()
  end
  
  DYHttpMgr.initGinsen(tFuncListener)
end

function M:initUI()
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  self.mBg = bg
  local frame1 = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(260, 190), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.27, bg:getContentSize().height * 0.54):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, bg:getContentSize().width + 11, bg:getContentSize().height + 11):addTo(bg, 2):onButtonClicked(function()
    self:closeCallBack()
  end)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S715", ""),
    size = 18,
    color = cc.c3b(66, 49, 29),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, frame1:getContentSize().width * 0.1, frame1:getContentSize().height * 0.9):addTo(frame1)
  local icon = IconItem.new(2005)
  icon:setPosition(frame1:getContentSize().width * 0.5, frame1:getContentSize().height * 0.5)
  frame1:addChild(icon)
  icon:showItemTip()
  self.mGinsenStr = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S716", ""),
    size = 22,
    color = cc.c3b(66, 49, 29),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, frame1:getContentSize().width * 0.1, frame1:getContentSize().height * 0.1):addTo(frame1)
  self.mGinsenLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 22,
    color = cc.c3b(0, 255, 0),
    font = GameManager.FONTNAME_TTF
  }, {}):align(display.CENTER_LEFT, self.mGinsenStr:getContentSize().width + self.mGinsenStr:getPositionX() + 10, self.mGinsenStr:getPositionY()):addTo(frame1)
  self.mGinsenLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  local frame2 = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(260, 190), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.73, bg:getContentSize().height * 0.54):addTo(bg)
  local str = DYLang.getString("S717", "")
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = str,
    size = 18,
    color = cc.c3b(66, 49, 29),
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(220, 132)
  }):align(display.CENTER, frame2:getContentSize().width * 0.5, frame2:getContentSize().height * 0.48):addTo(frame2)
  local textLabel = cc.ui.UILabel.new({
    text = "        \232\180\173\228\185\176",
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  textLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  local buyBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):setButtonLabel("normal", textLabel):onButtonClicked(function()
    self:buyCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.19):addTo(bg)
  display.newSprite("item_icon/pic_peach.png", -55, 0):scale(0.6):addTo(buyBtn)
  self.mCostLabel = cc.ui.UILabel.new({
    text = "",
    size = 22,
    color = cc.c3b(255, 235, 12),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, -15, 0):addTo(buyBtn)
  self.mCostLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S718", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:useCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.19):addTo(bg)
end

function M:refreshControls()
  self.mGinsenNum = CloudData.GINSENG_FRUIT
  local currNum = tonumber(self.mGinsenLabel:getString())
  if currNum ~= self.mGinsenNum then
    local ac = transition.sequence({
      cc.ScaleTo:create(0.15, 1.5),
      cc.ScaleTo:create(0.15, 1),
      DYRollnum:create(0.5, currNum, self.mGinsenNum)
    })
    self.mGinsenLabel:runAction(ac)
  end
  local boughtTime = CloudData.GINSEN_BUY_TIME
  self.mPeachCost = getCost(boughtTime + 1)
  currNum = tonumber(self.mCostLabel:getString())
  if currNum ~= self.mPeachCost then
    local ac1 = transition.sequence({
      cc.ScaleTo:create(0.15, 1.5),
      cc.ScaleTo:create(0.15, 1),
      DYRollnum:create(0.5, currNum, self.mPeachCost)
    })
    self.mCostLabel:runAction(ac1)
  end
  local maxTime = getBuyTimes()
  if boughtTime >= maxTime then
    self.mCanBuy = false
  else
    self.mCanBuy = true
  end
end

function M:buyCallBack()
  if CloudData.PEACH >= self.mPeachCost and self.mCanBuy then
    local function tFuncListener(info)
      if info.errorCode ~= 0 then
        local toast = WSToast.new(info.errorMsg, 2)
        
        self:addChild(toast, 20)
      else
        DYSoundMgr.playEffect(DY_SND.sfx_item_sell)
        CloudData.GINSEN_BUY_TIME = CloudData.GINSEN_BUY_TIME + 1
        CloudData.GINSENG_FRUIT = tonumber(info.data.ginsen)
        CloudData.PEACH = tonumber(info.data.peach)
        CloudData.GAME_ITEM_INFO["1"] = CloudData.PEACH
        CloudData.GAME_ITEM_INFO["2005"] = CloudData.GINSENG_FRUIT
        local ginsenGet = CloudData.GINSENG_FRUIT - self.mGinsenNum
        DYAnalyze.item.consume(1, "PEACH", self.mPeachCost, "BUY_GINSEN")
        DYAnalyze.item.get(2005, "GINSEN", ginsenGet, "BUY_GINSEN")
        self:refreshControls()
      end
    end
    
    DYHttpMgr.buyGinsen(tFuncListener)
  elseif self.mCanBuy then
    local tip = LayerLackPeach.new()
    self:addChild(tip, 5)
  else
    self:buyTimeOut()
  end
end

function M:useCallBack()
  if self.mGinsenNum > 0 then
    local function tFuncListener(info)
      if info.errorCode ~= 0 then
        local toast = WSToast.new(info.errorMsg, 2)
        
        self:addChild(toast, 20)
      elseif self.mGinsenNum then
        DYSoundMgr.playEffect(DY_SND.sfx_item_use)
        CloudData.ENERGY = tonumber(info.data.energy)
        CloudData.GINSENG_FRUIT = tonumber(info.data.ginsen)
        CloudData.GAME_ITEM_INFO["3"] = CloudData.ENERGY
        CloudData.GAME_ITEM_INFO["2005"] = CloudData.GINSENG_FRUIT
        local ginsenCost = checknumber(self.mGinsenNum) - CloudData.GINSENG_FRUIT
        DYAnalyze.item.consume(2005, "GINSEN", ginsenCost, "BUY_ENERGY")
        local getEnergy = tonumber(info.data.energyGain)
        if getEnergy then
          DYAnalyze.item.get(3, "ENERGY", getEnergy, "BUY_ENERGY")
          self:numberAction(getEnergy)
        end
        self.mGinsenNum = CloudData.GINSENG_FRUIT
        local currNum = tonumber(self.mGinsenLabel:getString())
        if currNum == self.mGinsenNum then
          return
        end
        local ac = transition.sequence({
          cc.ScaleTo:create(0.15, 1.5),
          cc.ScaleTo:create(0.15, 1),
          DYRollnum:create(0.5, currNum, self.mGinsenNum)
        })
        self.mGinsenLabel:runAction(ac)
      end
    end
    
    local params = {times = 1}
    DYHttpMgr.useGinsen(tFuncListener, params)
  else
    local tip = WSToast.new(DYLang.getString("S720", ""), 1)
    self:addChild(tip, 200)
  end
end

function M:numberAction(num)
  local lb = DYLabelTTF.new({
    text = "+" .. num .. DYLang.getString("S721", ""),
    size = 30,
    color = cc.c3b(47, 253, 255),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.25):opacity(0):addTo(self.mBg, 5)
  local moveTo = cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.8))
  local spawn1 = cc.Spawn:create(moveTo, cc.FadeIn:create(0.5))
  lb:runAction(transition.sequence({
    spawn1,
    cc.DelayTime:create(0.25),
    cc.FadeOut:create(0.25),
    cc.CallFunc:create(function()
      lb:runAction(cc.RemoveSelf:create())
    end)
  }))
end

function M:buyTimeOut()
  if self.mTipLayer then
    self.mTipLayer:runAction(cc.RemoveSelf:create())
    self.mTipLayer = nil
  end
  self.mTipLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 5)
  local bg = display.newSprite("common_ui/common_dialog.png", display.cx, display.cy):scale(0):addTo(self.mTipLayer)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  bg:runAction(popupLayer)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(490, 170), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.55):addTo(bg)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S722", ""),
    size = 25,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(450, 150),
    color = cc.c3b(66, 49, 29),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.55):addTo(bg)
  local textLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S723", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  textLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):setButtonLabel("normal", textLabel):onButtonClicked(function()
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0, 1),
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        self.mTipLayer:runAction(cc.RemoveSelf:create())
        self.mTipLayer = nil
      end)
    })
    bg:runAction(popupLayer)
  end):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.19):addTo(bg)
  textLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S724", ""),
    size = 22,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  textLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):setButtonLabel("normal", textLabel):onButtonClicked(function()
    self.mTipLayer:runAction(cc.RemoveSelf:create())
    self.mTipLayer = nil
    local layer = LayerRecharge.new()
    display.getRunningScene():addChild(layer, 100)
  end):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.19):addTo(bg)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
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
    if self.mTipLayer then
      self.mTipLayer:runAction(cc.RemoveSelf:create())
      self.mTipLayer = nil
    else
      self:runAction(cc.RemoveSelf:create())
    end
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

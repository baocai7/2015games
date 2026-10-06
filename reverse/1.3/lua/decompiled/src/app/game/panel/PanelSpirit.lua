local M = {}
M = class("PanelSpirit", function()
  return display.newNode()
end)

function M:ctor(handler_)
  self.mCallback = handler_
  GameData.SPIRIT_MAX_LEVEL = #DataRetainer.SPIRIT_INFO - 1
  self:initData(handler_)
  self:initUI()
  self:setNodeEventEnabled(true)
  GameData.SpiritPanel = self
end

function M:initData()
  self.mSpiritModel = DataUtils.getSpiritModel(GameData.SPIRIT_LEVEL)
  self.mCostNum = self.mSpiritModel.costNum
  self.mMaxSpirit = self.mSpiritModel.limitNum
  self.mIsReady = false
end

function M:initUI()
  self.mSpiritBtn = display.newSprite("gamescene/upgrade_spirit1.png", 0, -25):addTo(self)
  self.mSpiritBtn:setTouchEnabled(true)
  self.mSpiritBtn:setTouchSwallowEnabled(true)
  self.mSpiritBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name = event.name
    if name == "began" then
      self:upgradeSpirit()
      return true
    end
  end)
  self.mGrayIcon = display.newSprite("gamescene/iconshadow.png"):hide():pos(self.mSpiritBtn:getContentSize().width * 0.5 + 1, self.mSpiritBtn:getContentSize().height * 0.5):addTo(self.mSpiritBtn, 3)
  if 1 == GameData.GAME_TYPE then
    self.mSpiritBtn:setTexture("gamescene/spirit_lv.png")
    self.mCostLabel = cc.ui.UILabel.new({
      UILabelType = 1,
      text = GameData.SPIRIT_LEVEL,
      font = "fonts/yellowNum.fnt"
    }):align(display.CENTER, 87, 66):addTo(self.mSpiritBtn, 1)
  else
    self.mCostLabel = cc.ui.UILabel.new({
      UILabelType = 1,
      text = self.mCostNum,
      font = "fonts/whiteNum.fnt"
    }):scale(0.5):align(display.CENTER, self.mSpiritBtn:getContentSize().width * 0.5, self.mSpiritBtn:getContentSize().height * 0.3):addTo(self.mSpiritBtn, 1)
  end
  local spiritIcon = display.newSprite("gamescene/spirit.png"):pos(-self.mSpiritBtn:getContentSize().width * 0.5 - 30, 0):addTo(self)
  self.mSpiritIcon = spiritIcon
  self.mHicon = display.newSprite("gamescene/spirit1.png"):pos(-self.mSpiritBtn:getContentSize().width * 0.5 - 30, 0):hide():addTo(self, 1)
  self.mNumLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("%d/%d", 0, 0),
    font = "fonts/whiteNum.fnt"
  }):scale(0.75):align(display.CENTER_RIGHT, spiritIcon:getPositionX() - spiritIcon:getContentSize().width * 0.55, 0):addTo(self)
  self.mSchedule = self:schedule(function()
    self:updateSpirit()
  end, 0.1)
end

function M:reInit()
  if self.mSchedule then
    self:stopAction(self.mSchedule)
  end
  self:initData()
  if GameData.SPIRIT_LEVEL >= self.mSpiritModel.maxLevel then
    self.mCostLabel:removeSelf()
    self.mSpiritBtn:setTexture("gamescene/spirit_max.png")
    self.mIsReady = false
    self.mGrayIcon:hide()
  elseif 1 == GameData.GAME_TYPE then
    self.mCostLabel:setString(string.format("%d", GameData.SPIRIT_LEVEL))
    local ac = transition.sequence({
      cc.ScaleTo:create(0.2, 1.6),
      cc.ScaleTo:create(0.2, 1)
    })
    self.mCostLabel:runAction(ac)
  else
    self.mCostLabel:setString(string.format("%d", self.mCostNum))
  end
  self.mSchedule = self:schedule(function()
    self:updateSpirit()
  end, 0.1)
end

function M:upgradeSpirit()
  if 1 == GameData.GAME_TYPE then
    return
  end
  if self.mIsReady and not GameData.IS_ON_CREATING_BUDDHA then
    GameData.IS_ON_CREATING_BUDDHA = true
    local ac = transition.sequence({
      cc.ScaleTo:create(0.2, 1.2),
      cc.ScaleTo:create(0.2, 0.75)
    })
    self.mNumLabel:runAction(ac)
    self.mCallback(self.mCostNum)
    self:performWithDelay(function()
      GameData.IS_ON_CREATING_BUDDHA = false
    end, 0.2)
  end
end

function M:updateSpirit()
  local currSpirit = GameData.getCurrentSpirit()
  if currSpirit < self.mMaxSpirit + GameData.getSpiritLimit() then
    currSpirit = currSpirit + self.mSpiritModel.growSpeed
    GameData.setCurrentSpirit(currSpirit)
  else
    currSpirit = self.mMaxSpirit + Const.MaxSpirit + GameData.getSpiritLimit()
    GameData.setCurrentSpirit(currSpirit)
  end
  self.mNumLabel:setString(string.format("%d/%d", currSpirit, self.mMaxSpirit + GameData.getSpiritLimit()))
  if GameData.SPIRIT_LEVEL >= self.mSpiritModel.maxLevel then
    self.mSpiritBtn:setTexture("gamescene/spirit_max.png")
    self.mSpiritBtn:stopAllActions()
    self.mHicon:hide()
    self.mHicon:stopAllActions()
    self.mGrayIcon:hide()
    return
  end
  if 1 == GameData.GAME_TYPE then
    return
  end
  if currSpirit >= self.mCostNum then
    if not self.mIsReady then
      local function func1()
        self.mSpiritBtn:setTexture("gamescene/upgrade_spirit2.png")
      end
      
      local function func2()
        self.mSpiritBtn:setTexture("gamescene/upgrade_spirit1.png")
      end
      
      local seq = transition.sequence({
        cc.DelayTime:create(0.15),
        cc.CallFunc:create(func1),
        cc.DelayTime:create(0.15),
        cc.CallFunc:create(func2)
      })
      self.mSpiritBtn:runAction(cc.RepeatForever:create(seq))
      self.mHicon:show()
      local seq1 = transition.sequence({
        cc.FadeOut:create(0.8),
        cc.FadeIn:create(0.8)
      })
      self.mHicon:runAction(cc.RepeatForever:create(seq1))
      self.mGrayIcon:hide()
      self.mIsReady = true
    end
  else
    self.mSpiritBtn:setTexture("gamescene/upgrade_spirit1.png")
    self.mSpiritBtn:stopAllActions()
    self.mHicon:hide()
    self.mHicon:stopAllActions()
    self.mGrayIcon:show()
    self.mIsReady = false
  end
end

function M:setMaxSpirit()
  GameData.SPIRIT_LEVEL = self.mSpiritModel.maxLevel
  self.mSpiritModel = DataUtils.getSpiritModel(GameData.SPIRIT_LEVEL)
  self.mMaxSpirit = self.mSpiritModel.limitNum
  GameData.setCurrentSpirit(self.mMaxSpirit)
end

function M:setMaxSpiritNum()
  GameData.setCurrentSpirit(self.mMaxSpirit)
end

function M:getSpiritIconPos()
  return cc.p(self:getPositionX() - self.mSpiritBtn:getContentSize().width * 0.5 - 39, self:getPositionY())
end

function M:scaleSpirit()
  local sequence = transition.sequence({
    cc.ScaleTo:create(0.2, 1.2),
    cc.ScaleTo:create(0.2, 1)
  })
  self.mSpiritIcon:runAction(sequence)
end

function M:updateSpiritLevel(deltaLevel)
  if 1 == GameData.SPIRIT_LEVEL and deltaLevel < 0 then
    return
  end
  if self.mSpiritModel.maxLevel == GameData.SPIRIT_LEVEL and 0 < deltaLevel then
    return
  end
  GameData.SPIRIT_LEVEL = GameData.SPIRIT_LEVEL + deltaLevel
  if 1 >= GameData.SPIRIT_LEVEL then
    GameData.SPIRIT_LEVEL = 1
  end
  if GameData.SPIRIT_LEVEL >= self.mSpiritModel.maxLevel then
    GameData.SPIRIT_LEVEL = self.mSpiritModel.maxLevel
  end
  self.mSpiritModel = DataUtils.getSpiritModel(GameData.SPIRIT_LEVEL)
  self.mCostNum = self.mSpiritModel.costNum
  self.mMaxSpirit = self.mSpiritModel.limitNum
  if 1 == GameData.GAME_TYPE then
    self.mCostLabel:setString(string.format("%d", GameData.SPIRIT_LEVEL))
  else
    self.mCostLabel:setString(string.format("%d", self.mCostNum))
  end
  local currentSpirit = GameData.getCurrentSpirit()
  if currentSpirit > self.mMaxSpirit then
    currentSpirit = self.mMaxSpirit
    GameData.setCurrentSpirit(currentSpirit)
  end
end

function M:updateSpiritValue(deltaValue)
  local currentSpirit = GameData.getCurrentSpirit()
  GameData.setCurrentSpirit(currentSpirit + deltaValue)
end

function M:onNotify(name, param)
  if name == DY_KEY.kUpdateSpiritLevel then
    if param.isBuddha then
      self:updateSpiritLevel(param.delta)
    end
  elseif name == DY_KEY.kUpdateSpiritValue and param.isBuddha then
    self:updateSpiritValue(param.delta)
  end
end

function M:onEnter()
  DDLOG("PanelSpirit" .. ": onEnter")
  DYNotification.registerScriptObserver(self, handler(self, self.onNotify), DY_KEY.kUpdateSpiritLevel)
  DYNotification.registerScriptObserver(self, handler(self, self.onNotify), DY_KEY.kUpdateSpiritValue)
end

function M:onExit()
  DDLOG("PanelSpirit" .. ": onExit")
  if self.mSchedule then
    self:stopAction(self.mSchedule)
  end
  DYNotification.removeAllObservers(self)
end

return M

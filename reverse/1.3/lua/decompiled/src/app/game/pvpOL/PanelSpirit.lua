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
  self.mCount = 0
  self.mIsReady = false
  self.mIsCanBeClicked = true
end

function M:initUI()
  self.mSpiritBtn = display.newSprite("gamescene/upgrade_spirit1.png", 0, -25):addTo(self, 1)
  self.mSpiritBtn:setTouchEnabled(true)
  self.mSpiritBtn:setTouchSwallowEnabled(true)
  self.mSpiritBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name = event.name
    if name == "began" then
      self:upgradeCallBack()
      return true
    end
  end)
  self.mGrayIcon = display.newSprite("gamescene/iconshadow.png"):hide():pos(self.mSpiritBtn:getContentSize().width * 0.5 + 1, self.mSpiritBtn:getContentSize().height * 0.5):addTo(self.mSpiritBtn, 3)
  self.mCostLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = self.mCostNum,
    font = "fonts/whiteNum.fnt"
  }):scale(0.5):align(display.CENTER, self.mSpiritBtn:getContentSize().width * 0.5, self.mSpiritBtn:getContentSize().height * 0.3):addTo(self.mSpiritBtn, 2)
  local spiritFrame = display.newSprite("#info_spirit.png"):align(display.CENTER_RIGHT, self.mSpiritBtn:getPositionX() + 5, -30):addTo(self)
  local spiritIcon = display.newSprite("#spirit.png", 120, 42):addTo(spiritFrame)
  self.mNumLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("%d/%d", 0, 0),
    font = "fonts/whiteNum.fnt"
  }):scale(0.65):align(display.CENTER, 245, 44):addTo(spiritFrame)
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):scale(0.7):align(display.CENTER_LEFT, 15, spiritFrame:getContentSize().height * 0.5 + 7):addTo(spiritFrame)
  self.mIconFrame = iconFrame
  display.newSprite(CloudData.USER_ICON):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  iconFrame:setTouchEnabled(true)
  iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      self:clickUserIcon(iconFrame)
      return true
    end
  end)
end

function M:reInit()
  self:initData()
  if GameData.SPIRIT_LEVEL >= self.mSpiritModel.maxLevel then
    self.mCostLabel:hide()
    self.mSpiritBtn:setTexture("gamescene/spirit_max.png")
    self.mIsReady = false
    self.mGrayIcon:hide()
  else
    self.mCostLabel:setString(string.format("%d", self.mCostNum))
  end
end

function M:upgradeCallBack()
  if self.mIsCanBeClicked and self.mIsReady and not GameData.IS_ON_CREATING_BUDDHA then
    self.mIsReady = false
    self.mIsCanBeClicked = false
    GameData.IS_ON_CREATING_BUDDHA = true
    self.mCallback()
  end
end

function M:upgradeSpirit()
  DYSoundMgr.playEffect(DY_SND.sfx_lq_upgrade)
  local currentSpirit = GameData.getCurrentSpirit()
  GameData.setCurrentSpirit(currentSpirit - self.mCostNum)
  GameData.SPIRIT_LEVEL = GameData.SPIRIT_LEVEL + 1
  self:reInit()
  GameData.IS_ON_CREATING_BUDDHA = false
  self.mIsCanBeClicked = true
  self.mSpiritBtn:stopAllActions()
  local ac = transition.sequence({
    cc.ScaleTo:create(0.2, 1),
    cc.ScaleTo:create(0.2, 0.65)
  })
  self.mNumLabel:runAction(ac)
end

function M:updateSpirit()
  self.mCount = self.mCount + 1
  if 3 == self.mCount then
    self.mCount = 0
    local currSpirit = GameData.getCurrentSpirit() + Const.MaxSpirit
    if currSpirit < self.mMaxSpirit + GameData.getSpiritLimit() then
      currSpirit = currSpirit + self.mSpiritModel.growSpeed * 1.25
      GameData.setCurrentSpirit(currSpirit)
    else
      currSpirit = self.mMaxSpirit + Const.MaxSpirit + GameData.getSpiritLimit()
      GameData.setCurrentSpirit(currSpirit)
    end
    self.mNumLabel:setString(string.format("%d/%d", currSpirit, self.mMaxSpirit + GameData.getSpiritLimit()))
    if GameData.SPIRIT_LEVEL >= self.mSpiritModel.maxLevel then
      self.mSpiritBtn:setTexture("gamescene/spirit_max.png")
      self.mSpiritBtn:stopAllActions()
      self.mGrayIcon:hide()
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
        self.mGrayIcon:hide()
        self.mIsReady = true
      end
    else
      self.mSpiritBtn:setTexture("gamescene/upgrade_spirit1.png")
      self.mSpiritBtn:stopAllActions()
      self.mGrayIcon:show()
      self.mIsReady = false
    end
  end
end

function M:setMaxSpirit()
  GameData.SPIRIT_LEVEL = self.mSpiritModel.maxLevel
  self.mSpiritModel = DataUtils.getSpiritModel(GameData.SPIRIT_LEVEL)
  self.mMaxSpirit = self.mSpiritModel.limitNum
  GameData.setCurrentSpirit(self.mMaxSpirit)
end

function M:clickUserIcon(iconFrame)
  if self.mChatFrame then
    local spawn = cc.Spawn:create(cc.MoveBy:create(0.25, cc.p(0, 180)), cc.ScaleTo:create(0.25, 0))
    self.mChatFrame:runAction(spawn)
    self.mChatFrame = nil
    return
  end
  self.mChatFrame = self:getChatFrame()
  self.mChatFrame:setPosition(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5)
  self.mChatFrame:addTo(iconFrame, 2)
  local spawn = cc.Spawn:create(cc.MoveBy:create(0.25, cc.p(0, -180)), cc.ScaleTo:create(0.25, 1.4285714285714286))
  self.mChatFrame:runAction(spawn)
end

function M:getChatFrame()
  local pNode = display.newNode()
  pNode:setScale(0)
  pNode:setAnchorPoint(0.5, 0.5)
  local btnText = {
    DYLang.getString("S274", ""),
    DYLang.getString("S275", ""),
    DYLang.getString("S276", ""),
    DYLang.getString("S277", "")
  }
  local count = #btnText
  pNode:setContentSize(100 * count, 150)
  for i = 1, count + 1 do
    local btn
    if i < count + 1 then
      btn = cc.ui.UIPushButton.new({
        normal = "#btn_bubble1.png",
        pressed = "#btn_bubble2.png"
      }):setButtonLabel("normal", DYLabelTTF.new({
        text = btnText[i],
        size = 22,
        color = cc.c3b(78, 47, 6),
        font = GameManager.FONTNAME_TTF
      })):align(display.CENTER, 100 * i - 50, 110):onButtonClicked(function()
        self:chatCallBack(i)
      end):addTo(pNode)
    else
      btn = cc.ui.UIPushButton.new({
        normal = "#btn_escape1.png",
        pressed = "#btn_escape2.png"
      }):align(display.CENTER, pNode:getContentSize().width * 0.5, 50):onButtonClicked(function()
        self:giveUpCallBack()
      end):addTo(pNode)
    end
    local seq = transition.sequence({
      cc.DelayTime:create(0.26),
      cc.ScaleTo:create(0.1, 0.9),
      cc.ScaleTo:create(0.1, 1.25),
      cc.ScaleTo:create(0.1, 1)
    })
    btn:runAction(seq)
  end
  return pNode
end

function M:chatCallBack(index)
  local randomNum = math.random(1, 3)
  self:safeSocketRequest("CMD_COMMIT_CHAT", {chat_id = index, content_id = randomNum})
  self:chatContent({chat_id = index, content_id = randomNum})
end

function M:giveUpCallBack()
  if 6 == GameManager.MODE then
    self:safeSocketRequest("CMD_GIVE_UP")
    return
  end
  local params = {
    is_win = 0,
    ai_rank_data = CloudData.ENEMY_INFO.pvpData,
    fight_type = 2
  }
  self:safeSocketRequest("CMD_GIVE_UP", params)
end

function M:chatContent(params)
  if self.mChatFrame then
    local spawn = cc.Spawn:create(cc.MoveBy:create(0.25, cc.p(0, 180)), cc.ScaleTo:create(0.25, 0))
    self.mChatFrame:runAction(spawn)
    self.mChatFrame = nil
  end
  local chatFrame = display.newSprite("#text_frame.png"):align(display.CENTER_RIGHT, -10, self.mIconFrame:getContentSize().height * 0.2):scale(0):addTo(self.mIconFrame, 2)
  local textStr = Const.CHAT_CONTENT[params.chat_id][params.content_id]
  local textLabel = DYLabelTTF.new({
    text = textStr,
    size = 22,
    color = cc.c3b(78, 47, 6),
    font = GameManager.FONTNAME_TTF
  }):pos(chatFrame:getContentSize().width * 0.5, chatFrame:getContentSize().height * 0.45):addTo(chatFrame)
  textLabel:setScaleX(-1)
  local spwan = cc.Spawn:create(cc.MoveBy:create(0.25, cc.p(0, -120)), cc.ScaleTo:create(0.25, -1.4285714285714286, 1.4285714285714286))
  local seq = transition.sequence({
    cc.DelayTime:create(0.3),
    spwan,
    cc.DelayTime:create(3),
    cc.CallFunc:create(function()
      chatFrame:removeSelf()
    end)
  })
  chatFrame:runAction(seq)
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
  if GameData.SPIRIT_LEVEL >= self.mSpiritModel.maxLevel then
    self.mCostLabel:hide()
  else
    self.mCostLabel:show()
    self.mSpiritBtn:setTexture("gamescene/upgrade_spirit1.png")
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
  currentSpirit = currentSpirit + deltaValue
  if currentSpirit <= 0 then
    currentSpirit = 0
  end
  GameData.setCurrentSpirit(currentSpirit)
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

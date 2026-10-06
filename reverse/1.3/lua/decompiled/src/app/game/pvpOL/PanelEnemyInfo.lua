local M = {}
M = class("PanelEnemyInfo", function()
  return display.newNode()
end)

function M:ctor(handler_)
  self.mCallback = handler_
  self:initData()
  self:initUI()
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mDefCimeliaInfo = DataUtils.getDefCimeliaInfo(CloudData.ENEMY_CIMELIA_INFO.defCimelia, CloudData.ENEMY_TREASURE_INFO)
  self.mMaxHP = math.floor(self.mDefCimeliaInfo.towerHP * Const.PVPOL_TOWER_HP_RATIO)
  self.mCurHP = self.mMaxHP
  self.mSpiritLevel = 1
end

function M:initUI()
  local levelFrame = display.newSprite("#spirit_level.png", 0, -25):addTo(self, 1)
  self.mLevelLabel = DYLabelTTF.new({
    text = "LV.1",
    size = 24,
    color = cc.c3b(255, 0, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = display.COLOR_WHITE
  }):pos(levelFrame:getContentSize().width * 0.5, 39):addTo(levelFrame)
  local lifeFrame = display.newSprite("#info_tower.png"):align(display.CENTER_LEFT, levelFrame:getPositionX() - 5, -30):addTo(self)
  self.mHpLabel = DYLabelTTF.new({
    text = self.mCurHP .. "/" .. self.mMaxHP,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):pos(176, 43):addTo(lifeFrame)
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):scale(0.7):align(display.CENTER_RIGHT, lifeFrame:getContentSize().width - 15, lifeFrame:getContentSize().height * 0.5 + 7):addTo(lifeFrame)
  self.mIconFrame = iconFrame
  display.newSprite(CloudData.ENEMY_INFO.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  iconFrame:setTouchEnabled(true)
  iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      self:clickUserIcon()
      return true
    end
  end)
end

function M:upgradeSpirit()
  self.mSpiritLevel = self.mSpiritLevel + 1
  self.mLevelLabel:setString(string.format("LV.%d", self.mSpiritLevel))
end

function M:updateSpiritLevel(deltaLevel)
  self.mSpiritLevel = self.mSpiritLevel + deltaLevel
  if self.mSpiritLevel <= 1 then
    self.mSpiritLevel = 1
  end
  if self.mSpiritLevel >= 8 then
    self.mSpiritLevel = 8
  end
  self.mLevelLabel:setString(string.format("LV.%d", self.mSpiritLevel))
end

function M:updateTowerBlood(currHp)
  if currHp < 0 then
    currHp = 0
  end
  self.mHpLabel:setString(currHp .. "/" .. self.mMaxHP)
end

function M:clickUserIcon()
  DDLOG("CLICK ICON")
end

function M:chatContent(params)
  local chatFrame = display.newSprite("#text_frame.png"):align(display.CENTER_RIGHT, self.mIconFrame:getContentSize().width + 10, self.mIconFrame:getContentSize().height * 0.2):scale(0):addTo(self.mIconFrame, 2)
  local randomNum = math.random(1, 3)
  local textStr = Const.CHAT_CONTENT[params.chat_id][params.content_id]
  local textLabel = DYLabelTTF.new({
    text = textStr,
    size = 22,
    color = cc.c3b(78, 47, 6),
    font = GameManager.FONTNAME_TTF
  }):pos(chatFrame:getContentSize().width * 0.5, chatFrame:getContentSize().height * 0.45):addTo(chatFrame)
  local spwan = cc.Spawn:create(cc.MoveBy:create(0.25, cc.p(0, -120)), cc.ScaleTo:create(0.25, 1.4285714285714286, 1.4285714285714286))
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

function M:onNotify(name, param)
  if name == DY_KEY.kUpdateSpiritLevel and not param.isBuddha then
    self:updateSpiritLevel(param.delta)
  end
end

function M:onEnter()
  DDLOG("PanelSpirit" .. ": onEnter")
  DYNotification.registerScriptObserver(self, handler(self, self.onNotify), DY_KEY.kUpdateSpiritLevel)
end

function M:onExit()
  DDLOG("PanelSpirit" .. ": onExit")
  if self.mSchedule then
    self:stopAction(self.mSchedule)
  end
  DYNotification.removeAllObservers(self)
end

return M

local M = {}
M = class("PanelCard", function()
  return display.newNode()
end)
M.SPIRIT_NUM = 1001
M.BUDDHA_CARD = 1002
M.WAND_SKILL = 1003
M.TOWER_SKILL = 1004

function M:ctor(cardInfo, callback)
  self:initData(callback)
  self:initUI(cardInfo)
end

function M:initData(callback)
  self.mCallback = callback
  self.mLeftPoint = display.width * 0.5 - 330 - 60
  self.mPointX = 0
  self.mPointY = 0
  self.mIsReady = true
end

function M:initUI(cardInfo)
  self.mType = cardInfo.cardType
  self.mData = cardInfo
  self.mFrame = display.newSprite(string.format("gamescenegroove/frame%d.png", self.mData.quality)):addTo(self)
  self.mFrame:setTouchEnabled(true)
  self.mFrame:setTouchSwallowEnabled(true)
  self.mFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      self.mPointX, self.mPointY = x, y
      return true
    end
    if name == "ended" then
      self:onPressed()
    end
  end)
  if M.SPIRIT_NUM == self.mType then
    self:spiritNumCard()
  elseif M.BUDDHA_CARD == self.mType then
    self:buddhaCard()
  elseif M.WAND_SKILL == self.mType then
    self:wandSkillCard()
  elseif M.TOWER_SKILL == self.mType then
    self:towerSkillCard()
  end
end

function M:updateLogic()
  for i, card in pairs(GameData.CARD_TABLE) do
    if card ~= self and cc.rectIntersectsRect(self:getMyBoundingBox(true), card:getMyBoundingBox(false)) then
      return
    end
  end
  if self:getPositionX() > self.mLeftPoint then
    self:setPosition(cc.pAdd(cc.p(self:getPosition()), cc.p(-3, 0)))
  end
end

function M:spiritNumCard()
  local iconType = 2
  local nameStr = DYLang.getString("S271", "")
  self.mSpiritNum = self.mData.value
  local icon = display.newSprite(string.format("gamescenegroove/spirit%d.png", iconType)):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame, -1)
  local label = cc.ui.UILabel.new({
    text = nameStr,
    size = 16,
    font = GameManager.FONTNAME_TTF,
    color = display.COLOR_WHITE
  }):align(display.CENTER, self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.16):addTo(self.mFrame)
end

function M:buddhaCard()
  self.mBuddhaModel = self.mData
  local icon = display.newSprite(self.mData.npcIcon):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame, -2)
  if 0 == self.mData.isRebel then
    icon:setScaleX(-1)
  end
  self.mShadow = display.newSprite("gamescene/buddha_shadow.png"):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):scale(0.8):hide():addTo(icon)
  self.mSpiritFrame = display.newSprite("gamescene/spirit_icon.png"):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.44):addTo(self.mFrame)
  self.mSpiritNum = self.mData.consume
  self.mSpiritCostLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = self.mSpiritNum,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mSpiritFrame:getContentSize().width * 0.55, self.mSpiritFrame:getContentSize().height * 0.16):addTo(self.mSpiritFrame)
  self.mSpiritSchedule = self:schedule(function()
    self:updateSpirit()
  end, 0.1)
  self.mIsReady = false
end

function M:wandSkillCard()
  local icon = display.newSprite("gamescenegroove/wand.png"):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame, -1)
  self.mShadow = display.newSprite("gamescene/buddha_shadow.png"):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):scale(0.8):hide():addTo(icon)
  self.mSpiritNum = self.mData.value
  self.mSpiritFrame = display.newSprite("gamescene/spirit_icon.png"):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.44):addTo(self.mFrame)
  local label = cc.ui.UILabel.new({
    UILabelType = 2,
    text = self.mSpiritNum,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mSpiritFrame:getContentSize().width * 0.55, self.mSpiritFrame:getContentSize().height * 0.16):addTo(self.mSpiritFrame)
  self.mSpiritSchedule = self:schedule(function()
    self:updateSpirit()
  end, 0.1)
  self.mIsReady = false
end

function M:towerSkillCard()
  self.mSpiritNum = self.mData.value
  local icon = display.newSprite("gamescenegroove/tower_pvp.png"):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame, -1)
  self.mSpiritFrame = display.newSprite("gamescene/spirit_icon.png"):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.44):addTo(self.mFrame)
  local label = cc.ui.UILabel.new({
    UILabelType = 2,
    text = self.mSpiritNum,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mSpiritFrame:getContentSize().width * 0.55, self.mSpiritFrame:getContentSize().height * 0.16):addTo(self.mSpiritFrame)
  self.mShadow = display.newSprite("gamescene/buddha_shadow.png"):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):scale(0.8):hide():addTo(icon)
  self.mSpiritSchedule = self:schedule(function()
    self:updateSpirit()
  end, 0.1)
  self.mIsReady = false
end

function M:updateSpirit()
  local currentSpirit = GameData.getCurrentSpirit()
  if currentSpirit >= self.mSpiritNum then
    self.mShadow:hide()
    self.mIsReady = true
  else
    self.mShadow:show()
    self.mIsReady = false
  end
end

function M:onPressed()
  if not self.mIsReady then
    return
  end
  if BMgrOL._sumFrame - BMgrOL._lastClickFrame < Const.CommonCD then
    DDLOG("\231\130\185\229\135\187\229\164\170\229\191\171")
    return
  end
  BMgrOL._lastClickFrame = BMgrOL._sumFrame
  local params = {}
  params.type = self.mType
  if M.UPGRADE_SPIRIT == self.mType then
  elseif M.SPIRIT_NUM == self.mType then
    params.spiritNum = self.mSpiritNum
  elseif M.BUDDHA_CARD == self.mType then
    params.buddhaModel = self.mBuddhaModel
    params.isReady = self.mIsReady
  elseif M.WAND_SKILL == self.mType then
    params.costSpirit = self.mSpiritNum
  elseif M.TOWER_SKILL == self.mType then
    params.costSpirit = self.mSpiritNum
  end
  if self.mCallback then
    self.mCallback(params)
  end
  table.insert(GameData.NEW_CARD_ARRAY, self.mData)
  table.removebyvalue(GameData.CARD_TABLE, self, false)
  self:removeSelf()
end

function M:getMyBoundingBox(flag)
  local distance = 0
  if flag then
    distance = 10
  end
  local position = cc.p(self:getPosition())
  local size = self.mFrame:getContentSize()
  local rect = cc.rect(position.x - size.width / 2 - distance, position.y - size.height / 2, size.width, size.height)
  return rect
end

return M

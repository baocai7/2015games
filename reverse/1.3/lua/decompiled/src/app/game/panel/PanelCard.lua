local M = {}
M = class("PanelCard", function()
  return display.newNode()
end)
M.UPGRADE_SPIRIT = 101
M.SPIRIT_NUM = 102
M.BUDDHA_CARD = 103
M.WAND_SKILL = 104
M.TOWER_SKILL = 105

function M:ctor(cardType, handler_)
  self:initData(handler_)
  self:initUI(cardType)
end

function M:initData(handler_)
  self.mCallback = handler_
  self.mLeftPoint = display.width * 0.5 - 440 - 30 - 5 + 55
  self.mIsInDeleted = false
  self.mPointX = 0
  self.mPointY = 0
  self.mIsReady = true
end

function M:initUI(cardType)
  self.mType = cardType
  self.mFrame = display.newSprite("gamescenegroove/frame1.png"):addTo(self)
  self.mFrame:setTouchEnabled(true)
  self.mFrame:setTouchSwallowEnabled(true)
  self.mFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      self.mPointX, self.mPointY = x, y
      return true
    end
    local touchInSprite = cc.rectContainsPoint(self.mFrame:getCascadeBoundingBox(), cc.p(x, y))
    if name == "moved" then
      local offsetY = y - self.mPointY
      if 100 < offsetY and not self.mIsInDeleted then
        self:removeCard()
      end
    else
      if name == "ended" and touchInSprite then
        self:onPressed()
      else
      end
    end
  end)
  if M.UPGRADE_SPIRIT == cardType then
    self:upgradeSpiritCard()
  elseif M.SPIRIT_NUM == cardType then
    self:spiritNumCard()
  elseif M.BUDDHA_CARD == cardType then
    self:buddhaCard()
  elseif M.WAND_SKILL == cardType then
    self:wandSkillCard()
  elseif M.TOWER_SKILL == cardType then
    self:towerSkillCard()
  end
  self.mMoveSchedule = self:schedule(function()
    self:updateLogic()
  end, 0.05)
end

function M:updateLogic()
  for i, card in pairs(GameData.CARD_TABLE) do
    if card ~= self and cc.rectIntersectsRect(self:getMyBoundingBox(true), card:getMyBoundingBox(false)) then
      return
    end
  end
  if self:getPositionX() > self.mLeftPoint and not self.mIsInDeleted then
    self:setPosition(cc.pAdd(cc.p(self:getPosition()), cc.p(-5, 0)))
  end
end

function M:upgradeSpiritCard()
  self.mFrame:setTexture("gamescenegroove/frame3.png")
  local icon = display.newSprite("gamescenegroove/upgrade.png"):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame, -1)
  local label = cc.ui.UILabel.new({
    text = DYLang.getString("S250", ""),
    size = 18,
    font = GameManager.FONTNAME_TTF,
    color = display.COLOR_WHITE
  }):align(display.CENTER, self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.16):addTo(self.mFrame)
end

function M:spiritNumCard()
  local randomNum = math.random(1, 100)
  local iconType = 1
  local nameStr = ""
  if randomNum <= 70 then
    self.mSpiritNum = 100
    iconType = 1
    nameStr = DYLang.getString("S251", "")
    self.mFrame:setTexture("gamescenegroove/frame3.png")
  elseif 70 < randomNum and randomNum <= 100 then
    self.mSpiritNum = 500
    iconType = 2
    nameStr = DYLang.getString("S252", "")
    self.mFrame:setTexture("gamescenegroove/frame4.png")
  end
  local icon = display.newSprite(string.format("gamescenegroove/spirit%d.png", iconType)):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame, -1)
  local label = cc.ui.UILabel.new({
    text = nameStr,
    size = 16,
    font = GameManager.FONTNAME_TTF,
    color = display.COLOR_WHITE
  }):align(display.CENTER, self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.16):addTo(self.mFrame)
end

function M:buddhaCard()
  local weightNum = {
    50,
    30,
    30,
    20,
    20
  }
  local teamTable = DataUtils.getBuddhaTableOnTeam()
  local buddhaTable = {
    {},
    {},
    {},
    {},
    {}
  }
  for k, v in pairs(teamTable) do
    local buddhaModel
    if 6 == GameManager.MODE or 9 == GameManager.MODE then
      buddhaModel = DataUtils.getModelForPVPOnline("buddha", v)
    else
      buddhaModel = DataUtils.getBuddhaModel(v)
    end
    for i = 1, 5 do
      if i == buddhaModel.buddhaType then
        table.insert(buddhaTable[i], buddhaModel)
      end
    end
  end
  local countWeight = 0
  for i = 1, #buddhaTable do
    if #buddhaTable[i] ~= 0 then
      countWeight = countWeight + weightNum[i]
    else
      weightNum[i] = 0
    end
  end
  local buddhaModel
  local randomNum = math.random(1, countWeight)
  if #buddhaTable[1] ~= 0 and randomNum <= weightNum[1] then
    local randomNum1 = math.random(1, #buddhaTable[1])
    buddhaModel = buddhaTable[1][randomNum1]
  elseif #buddhaTable[2] ~= 0 and randomNum <= weightNum[1] + weightNum[2] then
    local randomNum1 = math.random(1, #buddhaTable[2])
    buddhaModel = buddhaTable[2][randomNum1]
  elseif #buddhaTable[3] ~= 0 and randomNum <= weightNum[1] + weightNum[2] + weightNum[3] then
    local randomNum1 = math.random(1, #buddhaTable[3])
    buddhaModel = buddhaTable[3][randomNum1]
  elseif #buddhaTable[4] ~= 0 and randomNum <= weightNum[1] + weightNum[2] + weightNum[3] + weightNum[4] then
    local randomNum1 = math.random(1, #buddhaTable[4])
    buddhaModel = buddhaTable[4][randomNum1]
  elseif #buddhaTable[5] ~= 0 and randomNum <= weightNum[1] + weightNum[2] + weightNum[3] + weightNum[4] + weightNum[5] then
    local randomNum1 = math.random(1, #buddhaTable[5])
    buddhaModel = buddhaTable[5][randomNum1]
  end
  self.mBuddhaModel = buddhaModel
  self.mFrame:setTexture(string.format("gamescenegroove/frame%d.png", buddhaModel.quality))
  local icon = display.newSprite(buddhaModel.npcIcon):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame, -2)
  if 0 == buddhaModel.isRebel then
    icon:setScaleX(-1)
  end
  self.mShadow = display.newSprite("gamescene/buddha_shadow.png"):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):scale(0.8):hide():addTo(icon)
  self.mSpiritFrame = display.newSprite("gamescene/spirit_icon.png"):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.44):addTo(self.mFrame)
  self.mSpiritNum = buddhaModel.consume
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
  local cimeliaModel = DataUtils.getAtkCimeliaInfo()
  self.mFrame:setTexture(string.format("gamescenegroove/frame%d.png", cimeliaModel.quality))
  local label = cc.ui.UILabel.new({
    text = cimeliaModel.name,
    size = 16,
    font = GameManager.FONTNAME_TTF,
    color = display.COLOR_WHITE
  }):align(display.CENTER, self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.16):addTo(self.mFrame)
end

function M:towerSkillCard()
  local icon = display.newSprite("gamescenegroove/tawer.png"):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame, -1)
  local cimeliaModel = DataUtils.getDefCimeliaInfo()
  self.mFrame:setTexture(string.format("gamescenegroove/frame%d.png", cimeliaModel.quality))
  local label = cc.ui.UILabel.new({
    text = cimeliaModel.name,
    size = 16,
    font = GameManager.FONTNAME_TTF,
    color = display.COLOR_WHITE
  }):align(display.CENTER, self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.16):addTo(self.mFrame)
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

function M:removeCard()
  self.mIsInDeleted = true
  local spawn = cc.Spawn:create(cc.MoveBy:create(0.6, cc.p(0, 100)), cc.FadeOut:create(0.6))
  self:runAction(transition.sequence({
    spawn,
    cc.CallFunc:create(function()
      table.removebyvalue(GameData.CARD_TABLE, self, false)
      self:removeSelf()
    end)
  }))
end

function M:onPressed()
  if not self.mIsReady then
    return
  end
  local params = {}
  params.type = self.mType
  if M.UPGRADE_SPIRIT == self.mType then
  elseif M.SPIRIT_NUM == self.mType then
    params.spiritNum = self.mSpiritNum
  elseif M.BUDDHA_CARD == self.mType then
    params.buddhaModel = self.mBuddhaModel
    params.isReady = self.mIsReady
  elseif M.WAND_SKILL == self.mType then
  elseif M.TOWER_SKILL == self.mType then
  end
  if self.mCallback then
    self.mCallback(params)
  end
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

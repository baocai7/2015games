local M = {}
M = class("UpgradeBuddhaIcon", function()
  return display.newNode()
end)

function M:ctor(buddhaModel)
  if not buddhaModel then
    return
  end
  self:initData(buddhaModel)
  self:initUI()
end

function M:initData(buddhaModel)
  self.mNpcId = buddhaModel.npcId
  self.mBuddhaState = buddhaModel.buddhaState
  self.mIcon = buddhaModel.npcIcon
  self.mQuality = buddhaModel.quality
  self.mName = buddhaModel.npcName
  self.mCurrentlevel = buddhaModel.level
  self.mCurrStarLevel = buddhaModel.starLevel
  self.mCostNum = buddhaModel.consume
  self.mCurrPieceNum = buddhaModel.currPieceNum
  self.mCostPieceNum = buddhaModel.summonCostNum
  self.mAdvanceNum = buddhaModel.advanceCostNum
  self.mModelId = buddhaModel.npcModelId
  self.mIsRebel = buddhaModel.isRebel
end

function M:initUI()
  if 0 == self.mBuddhaState then
    self:buddhaIconGray()
  else
    self:buddhaIconNormal()
  end
  self.mSelectedFrame = display.newScale9Sprite("common_ui/frame_selected.png", 0, 0, cc.size(376, 165), cc.rect(45, 30, 2, 2)):hide():addTo(self, 1)
end

function M:buddhaIconGray()
  local params = {
    0.2,
    0.3,
    0.5,
    0.1
  }
  self.mBg = display.newSprite("upgrade/icon_frame1.png"):addTo(self)
  self.mIconFrame = display.newGraySprite(string.format("common_ui/frame%d.png", self.mQuality), params):pos(self.mBg:getContentSize().width * 0.2, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  self.mBuddhaIcon = display.newGraySprite(self.mIcon, params):pos(self.mIconFrame:getContentSize().width * 0.5, self.mIconFrame:getContentSize().height * 0.5):addTo(self.mIconFrame)
  if 0 == self.mIsRebel then
    self.mBuddhaIcon:setScaleX(-1)
  end
  self.mBuddhaNameLabel = DYLabelTTF.new({
    UILabelType = 2,
    text = self.mName,
    size = 25,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):align(display.CENTER, self.mBg:getContentSize().width * 0.66, self.mBg:getContentSize().height * 0.73):addTo(self.mBg)
  local barBg = display.newSprite("upgrade/bar_bg.png"):pos(self.mBg:getContentSize().width * 0.65, self.mBg:getContentSize().height * 0.24):addTo(self.mBg)
  local progressTimer = cc.ProgressTimer:create(display.newSprite("upgrade/bar_pro.png")):addTo(barBg)
  progressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  progressTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  progressTimer:setMidpoint(cc.p(0, 0))
  progressTimer:setBarChangeRate(cc.p(1, 0))
  progressTimer:setPercentage(self.mCurrPieceNum / self.mCostPieceNum * 100)
  self.mPieceLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("%d/%d", self.mCurrPieceNum, self.mCostPieceNum),
    font = "fonts/whiteNum.fnt"
  }):scale(0.6):align(display.CENTER, barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  if self.mCurrPieceNum >= self.mCostPieceNum then
    self.mPieceLabel:hide()
    local tip1 = display.newSprite("upgrade/tip1.png", barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
    local redFrame = display.newSprite("upgrade/frame_red.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5):addTo(self.mBg, 5)
    local seq = transition.sequence({
      cc.FadeOut:create(0.25),
      cc.FadeIn:create(0.25)
    })
    redFrame:runAction(cc.RepeatForever:create(seq))
  end
end

function M:buddhaIconNormal()
  self.mBg = display.newSprite("upgrade/icon_frame.png"):addTo(self)
  self.mIconFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mQuality)):pos(self.mBg:getContentSize().width * 0.2, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  self.mBuddhaIcon = display.newSprite(self.mIcon):pos(self.mIconFrame:getContentSize().width * 0.5, self.mIconFrame:getContentSize().height * 0.5):addTo(self.mIconFrame)
  if 0 == self.mIsRebel then
    self.mBuddhaIcon:setScaleX(-1)
  end
  local nameColor = DataUtils.getBuddhaNameColor(self.mQuality)
  self.mBuddhaNameLabel = DYLabelTTF.new({
    UILabelType = 2,
    text = self.mName,
    size = 25,
    color = nameColor,
    font = GameManager.FONTNAME_TTF
  }, {}):align(display.CENTER, self.mBg:getContentSize().width * 0.66, self.mBg:getContentSize().height * 0.73):addTo(self.mBg)
  self.levelNumLabel = DYLabelTTF.new({
    UILabelType = 2,
    text = string.format("LV.%d", self.mCurrentlevel),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {}):pos(self.mIconFrame:getContentSize().width - 5, 15):addTo(self.mIconFrame)
  local spirit = DYLabelTTF.new({
    UILabelType = 2,
    text = DYLang.getString("S417", ""),
    size = 26,
    color = cc.c3b(255, 243, 142),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(64, 41, 15)
  }):pos(self.mBg:getContentSize().width * 0.48, self.mBg:getContentSize().height * 0.45):addTo(self.mBg)
  self.mSpiritNumLabel = DYLabelTTF.new({
    UILabelType = 2,
    text = self.mCostNum,
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(spirit:getPositionX() + spirit:getContentSize().width * 0.5 + 10, self.mBg:getContentSize().height * 0.45):addTo(self.mBg)
  local star = DYLabelTTF.new({
    UILabelType = 2,
    text = DYLang.getString("S418", ""),
    size = 26,
    color = cc.c3b(255, 243, 142),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(64, 41, 15)
  }):pos(self.mBg:getContentSize().width * 0.48, self.mBg:getContentSize().height * 0.19):addTo(self.mBg)
  self.mStarPic = display.newSprite(string.format("upgrade/level%d.png", self.mCurrStarLevel)):align(display.CENTER_LEFT, star:getPositionX() + star:getContentSize().width * 0.51, self.mBg:getContentSize().height * 0.19):addTo(self.mBg)
  local team = DataUtils.getBuddhaTableOnTeam()
  local index = table.indexof(team, tostring(self.mNpcId))
  if index then
    local mark1 = display.newSprite("upgrade/mark.png"):scale(0.7):align(display.CENTER_BOTTOM, self.mBg:getContentSize().width * 0.85, self.mBg:getContentSize().height * 0.37):addTo(self.mBg)
    local mark2 = display.newSprite("upgrade/mark.png"):scale(0.7):align(display.CENTER_BOTTOM, self.mBg:getContentSize().width * 0.94, self.mBg:getContentSize().height * 0.37):addTo(self.mBg)
    local action1 = transition.sequence({
      cc.RotateBy:create(0.2, 40),
      cc.DelayTime:create(0.5),
      cc.RotateBy:create(0.2, -40)
    })
    local action2 = transition.sequence({
      cc.RotateBy:create(0.2, -40),
      cc.DelayTime:create(0.5),
      cc.RotateBy:create(0.2, 40)
    })
    mark1:runAction(cc.RepeatForever:create(action1))
    mark2:runAction(cc.RepeatForever:create(action2))
  end
  if self.mCurrPieceNum >= self.mAdvanceNum and 5 > self.mCurrStarLevel then
    self.mRedPoint = display.newSprite("common_ui/red_point.png"):pos(self.mBg:getContentSize().width * 0.94, self.mBg:getContentSize().height * 0.85):addTo(self.mBg, 5)
  end
end

function M:setSelected(flag)
  if flag then
    self.mSelectedFrame:show()
  else
    self.mSelectedFrame:hide()
  end
end

function M:showLevel(buddhaModel)
  self.mBuddhaLevelLabel:show()
  self.mBuddhaLevelLabel:setString(string.format("LV." .. self.mCurrentlevel))
end

function M:updateUI(buddhaModel)
  if self.mBuddhaState < buddhaModel.buddhaState then
    self.mBg:removeSelf()
    self.mBg = nil
    self:initData(buddhaModel)
    self:buddhaIconNormal()
    return
  end
  if self.mCurrentlevel < buddhaModel.level then
    self.levelNumLabel:setString(string.format("LV.%d", buddhaModel.level))
  end
  if self.mModelId ~= buddhaModel.npcModelId then
    self.mBuddhaIcon:setTexture(buddhaModel.npcIcon)
    self.mBuddhaNameLabel:setString(buddhaModel.npcName)
  end
  if self.mCurrStarLevel < buddhaModel.starLevel then
    self.mStarPic:setTexture(string.format("upgrade/level%d.png", buddhaModel.starLevel))
    if self.mRedPoint then
      local currPieceNum = buddhaModel.currPieceNum
      local advanceNum = buddhaModel.advanceCostNum
      if currPieceNum < advanceNum or buddhaModel.starLevel >= 5 then
        self.mRedPoint:removeSelf()
        self.mRedPoint = nil
      end
    end
  end
end

return M

local M = {}
M = class("GameDialogue", function()
  return display.newLayer()
end)

function M:ctor(dType, handler_)
  self.mHandler = handler_
  self:initFileData(dType)
  self:initUI()
  self:setNodeEventEnabled(true)
end

function M:initFileData(dType)
  self.mDialogueList = DYCommon.getDataByTag(DataRetainer.DIALOGUE_INFO, "type", dType)
  self.mIndex = 1
  self.mIsPlayText = false
  self.mIsDialogueEnd = false
end

function M:initUI()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mBg = display.newSprite("dialogue/dialogue_frame.png", display.cx, display.height * 0.05):addTo(self)
  self.mLeftRole = display.newSprite():align(display.CENTER_BOTTOM, self.mBg:getContentSize().width * 0.2, self.mBg:getContentSize().height):addTo(self.mBg, 1)
  self.mRightRole = display.newSprite():align(display.CENTER_BOTTOM, self.mBg:getContentSize().width * 0.8, self.mBg:getContentSize().height):addTo(self.mBg, 1)
  self.mLeftNameFrame = display.newSprite("dialogue/name_frame.png", self.mBg:getContentSize().width * 0.2, self.mBg:getContentSize().height * 0.95):flipX(true):addTo(self.mBg, 2)
  self.mLeftNameLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 30,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mLeftNameFrame:getContentSize().width * 0.5, self.mLeftNameFrame:getContentSize().height * 0.5):addTo(self.mLeftNameFrame)
  self.mRightNameFrame = display.newSprite("dialogue/name_frame.png", self.mBg:getContentSize().width * 0.8, self.mBg:getContentSize().height * 0.95):addTo(self.mBg, 2)
  self.mRightNameLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 30,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mRightNameFrame:getContentSize().width * 0.5, self.mRightNameFrame:getContentSize().height * 0.5):addTo(self.mRightNameFrame)
  self.mTextLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 30,
    color = cc.c3b(63, 31, 4),
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(940, 210),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.22):addTo(self.mBg)
  self:setTouchEnabled(true)
  self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouch_(event.name, event.x, event.y)
  end)
  self:nextDialogue()
end

function M:nextDialogue()
  local totalNum = #self.mDialogueList
  if self.mDialogueList ~= nil then
    if totalNum < self.mIndex then
      self.mIsDialogueEnd = true
      self:setTouchEnabled(false)
      local blackLayer = cc.LayerColor:create(cc.c4b(0, 0, 0.255))
      blackLayer:setOpacity(0)
      self:addChild(blackLayer, 10)
      blackLayer:runAction(transition.sequence({
        cc.FadeIn:create(0.01),
        cc.CallFunc:create(function()
          self:endEvent()
          self:removeSelf()
        end)
      }))
      return
    end
    local dataInfo = self.mDialogueList[self.mIndex]
    local textContent = dataInfo.text
    local roleIcon = dataInfo.roleIcon
    local roleName = dataInfo.roleName
    local direction = tonumber(dataInfo.direction)
    if 1 == direction then
      self.mLeftRole:setVisible(true)
      self.mLeftNameFrame:setVisible(true)
      self.mRightRole:setVisible(false)
      self.mRightNameFrame:setVisible(false)
      self.mLeftRole:setTexture(roleIcon)
      self.mLeftNameLabel:setString(roleName)
    elseif 2 == direction then
      self.mRightRole:setVisible(true)
      self.mRightNameFrame:setVisible(true)
      self.mLeftRole:setVisible(false)
      self.mLeftNameFrame:setVisible(false)
      self.mRightRole:setTexture(roleIcon)
      self.mRightNameLabel:setString(roleName)
    end
    self.mWordsList = WordsTool.getVariableWordsTable(textContent)
    self.mCountNum = 0
    self.mSchedule = self:schedule(function()
      self:updateText()
    end, 0.2)
    self.mIndex = self.mIndex + 1
  end
end

function M:updateText()
  self.mCountNum = self.mCountNum + 1
  if self.mCountNum <= #self.mWordsList then
    local textStr = self.mWordsList[self.mCountNum]
    self.mTextLabel:setString(textStr)
    self.mIsPlayText = true
  else
    self.mCountNum = 0
    self:stopAction(self.mSchedule)
    self.mIsPlayText = false
  end
end

function M:blink()
  self.mNextPic = display.newSprite("dialogue/next.png", self.mBg:getContentSize().width * 0.88, self.mBg:getContentSize().height * 0.45):addTo(self.mBg, 2)
  local fadeOut_ = cc.FadeOut:create(0.2)
  local fadeIn_ = cc.FadeIn:create(0.2)
  local seq = transition.sequence({fadeOut_, fadeIn_})
  self.mNextPic:runAction(cc.RepeatForever:create(seq))
end

function M:onTouch_(event, x, y)
  if event == "began" then
    if self.mIsPlayText then
      local textStr = self.mWordsList[#self.mWordsList]
      self.mTextLabel:setString(textStr)
      self.mCountNum = #self.mWordsList
      self:stopAllActions()
      self:updateText()
      self.mIsPlayText = false
      return
    else
      if self.mNextPic ~= nil then
        self.mNextPic:removeSelf()
        self.mNextPic = nil
      end
      self:nextDialogue()
    end
    return true
  end
end

function M:endEvent()
  if self.mHandler then
    self.mHandler()
  end
end

function M:onEnter()
end

function M:onExit()
end

return M

local M = {}
M = class("PanelTimer", function()
  return display.newNode()
end)

function M:ctor(cleanTime, handler_)
  self.mCallback = handler_
  self:initData(cleanTime)
  self:initUI()
end

function M:initData(cleanTime)
  self.mCleanTime = cleanTime
  self.mCountTime = 0
  self.mMinutes = math.floor(cleanTime / 60)
  self.mSeconds = math.floor(cleanTime - self.mMinutes * 60)
  self.mStarTable = {}
  self.mProgressTable = {}
end

function M:initUI()
  local timeFrame = display.newSprite("gamescene/label_frame3.png"):addTo(self)
  if 0 == GameManager.MODE then
    for i = 1, 3 do
      local star = display.newSprite("gamescene/star2.png"):pos(timeFrame:getContentSize().width * 0.8 + i * 18, timeFrame:getContentSize().height * 0.5):addTo(timeFrame, i + 3)
      table.insert(self.mStarTable, star)
      local progressTimer = display.newProgressTimer("gamescene/label_frame" .. i .. ".png", display.PROGRESS_TIMER_BAR):pos(timeFrame:getContentSize().width * 0.5, timeFrame:getContentSize().height * 0.5):addTo(timeFrame, 4 - i)
      progressTimer:setMidpoint(cc.p(0, 0))
      progressTimer:setBarChangeRate(cc.p(1, 0))
      progressTimer:setPercentage(0)
      table.insert(self.mProgressTable, progressTimer)
    end
  else
    display.newSprite("gamescene/timer.png"):pos(timeFrame:getContentSize().width * 0.95, timeFrame:getContentSize().height * 0.5):addTo(timeFrame)
  end
  self.mTimeLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("%02d:%02d", self.mMinutes, self.mSeconds),
    font = "fonts/yellowNum.fnt"
  }):scale(0.75):align(display.CENTER_LEFT, timeFrame:getContentSize().width * 0.1, timeFrame:getContentSize().height * 0.52):addTo(timeFrame, 4)
  self:startCountDown_(self.mCleanTime)
end

function M:startCountDown_(time)
  if time == 0 then
    self:countdownOver_()
  else
    self.mMinutes = math.floor(time / 60)
    self.mSeconds = math.floor(time - self.mMinutes * 60)
  end
end

function M:updateTimer()
  self.mCountTime = self.mCountTime + 1
  if self.mCountTime >= GameData.PVE_FRAME then
    self.mCountTime = 0
    self:updateTime_()
  end
end

function M:updateUnionFightTimer()
  self.mCountTime = self.mCountTime + 1
  if self.mCountTime >= 24 then
    self.mCountTime = 0
    self:updateTime_()
  end
end

function M:updateTime_()
  GameData.BATTLE_TIME = GameData.BATTLE_TIME + 1
  if self.mSeconds > 0 then
    self.mSeconds = self.mSeconds - 1
  elseif 0 < self.mMinutes then
    self.mSeconds = 59
    self.mMinutes = self.mMinutes - 1
  else
    self:countdownOver_()
  end
  self.mTimeLabel:setString(string.format("%02d:%02d", self.mMinutes, self.mSeconds))
  if 0 == GameManager.MODE then
    local totalTime = 0
    local currTime = 0
    if GameData.BATTLE_TIME <= tonumber(GameData.STAR_TIME[2]) then
      totalTime = tonumber(GameData.STAR_TIME[2])
      currTime = GameData.BATTLE_TIME
      local progressTimer = self.mProgressTable[1]
      progressTimer:setPercentage(currTime / totalTime * 100)
      if GameData.BATTLE_TIME == totalTime then
        self:starAction(1)
        progressTimer:removeFromParent()
      end
    elseif GameData.BATTLE_TIME <= tonumber(GameData.STAR_TIME[1]) then
      totalTime = tonumber(GameData.STAR_TIME[1]) - tonumber(GameData.STAR_TIME[2])
      currTime = GameData.BATTLE_TIME - tonumber(GameData.STAR_TIME[2])
      local progressTimer = self.mProgressTable[2]
      progressTimer:setPercentage(currTime / totalTime * 100)
      if GameData.BATTLE_TIME == tonumber(GameData.STAR_TIME[1]) then
        self:starAction(2)
        progressTimer:removeFromParent()
      end
    end
  end
end

function M:countdownOver_()
  self:stopAction(self.scheduleTime_)
  if self.mCallback then
    self.mCallback()
  end
end

function M:starAction(index)
  local star = self.mStarTable[index]
  local star1 = display.newSprite("gamescene/star1.png"):pos(star:getPositionX(), star:getPositionY()):opacity(0):addTo(star:getParent(), index)
  star:runAction(transition.sequence({
    cc.FadeOut:create(0.15),
    cc.FadeIn:create(0.15),
    cc.FadeOut:create(0.15),
    cc.FadeIn:create(0.15),
    cc.FadeOut:create(0.15),
    cc.FadeIn:create(0.15),
    cc.CallFunc:create(function()
      star:setTexture("gamescene/star1.png")
    end)
  }))
  star1:runAction(transition.sequence({
    cc.FadeIn:create(0.15),
    cc.FadeOut:create(0.15),
    cc.FadeIn:create(0.15),
    cc.FadeOut:create(0.15),
    cc.FadeIn:create(0.15),
    cc.FadeOut:create(0.15),
    cc.CallFunc:create(function()
      star1:removeSelf()
    end)
  }))
end

return M

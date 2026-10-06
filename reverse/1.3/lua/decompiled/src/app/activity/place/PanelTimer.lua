local M = {}
M = class("PanelTimer", function()
  return display.newNode()
end)

function M:ctor(cleanTime, handler_)
  self.mCallback = handler_
  self.mCleanTime = cleanTime
  if 3600 <= cleanTime then
  else
    self:initData(cleanTime)
    self:initUI()
  end
end

function M:initData(cleanTime)
  self.mMinutes = math.floor(cleanTime / 60)
  self.mSeconds = math.floor(cleanTime - self.mMinutes * 60)
  self.mStarTable = {}
  self.mProgressTable = {}
end

function M:initUI()
  local timeFrame = display.newSprite("gamescene/label_frame3.png"):addTo(self)
  display.newSprite("gamescene/timer.png"):pos(timeFrame:getContentSize().width * 0.95, timeFrame:getContentSize().height * 0.5):addTo(timeFrame)
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
    self.scheduleTime_ = self:schedule(function()
      self:updateTime_()
    end, 1)
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
end

function M:countdownOver_()
  self:stopAction(self.scheduleTime_)
  if self.mCallback then
    self.mCallback()
  end
end

return M

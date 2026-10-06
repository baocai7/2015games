local M = {}
M = class("PanelTimer", function()
  return display.newNode()
end)

function M:ctor(cleanTime, handler_)
  self.mCallback = handler_
  self:initData(cleanTime)
  self:initUI()
end

function M:initData()
  self.mCount = 0
  self.mMinutes = 10
  self.mSeconds = 0
  self.mStarTable = {}
end

function M:initUI()
  local timeFrame = display.newSprite("#time_frame.png"):addTo(self)
  self.mTimeLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("%02d:%02d", self.mMinutes, self.mSeconds),
    font = "fonts/yellowNum.fnt"
  }):scale(0.7):align(display.CENTER, timeFrame:getContentSize().width * 0.5, timeFrame:getContentSize().height * 0.27):addTo(timeFrame)
  self:startCountDown_(600)
end

function M:startCountDown_(time)
  if time == 0 then
    self:countdownOver_()
  else
  end
end

function M:updateTime()
  self.mCount = self.mCount + 1
  if GameData.FRAME_PER_SECOND == self.mCount then
    self.mCount = 0
    GameData.BATTLE_TIME = GameData.BATTLE_TIME + 1
    if 0 < self.mSeconds then
      self.mSeconds = self.mSeconds - 1
    elseif 0 < self.mMinutes then
      self.mSeconds = 59
      self.mMinutes = self.mMinutes - 1
    else
      self:countdownOver_()
    end
    self.mTimeLabel:setString(string.format("%02d:%02d", self.mMinutes, self.mSeconds))
  end
end

function M:countdownOver_()
  if self.mCallback then
    self.mCallback()
  end
end

return M

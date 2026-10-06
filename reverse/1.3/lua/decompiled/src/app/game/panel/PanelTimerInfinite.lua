local M = {}
M = class("PanelTimerInfinite", function()
  return display.newNode()
end)

function M:ctor(handler_)
  self:initData(handler_)
  self:initUI()
  self:checkStrategy()
end

function M:initData(handler_)
  self.mCallback = handler_
  GameData.WAVE_OVER = false
  self.mWaveCountNum = DataUtils.getInfiniteWaveCount(GameManager.STAGE_ID)
  self.mWaveData = DataUtils.getInfiniteWaveData(GameManager.STAGE_ID, GameData.WAVE_NUM)
  self.mMinutes = math.floor(self.mWaveData.waveTime / 60)
  self.mSeconds = math.floor(self.mWaveData.waveTime - self.mMinutes * 60)
end

function M:initUI()
  local timeFrame = display.newSprite("game_infinite/time_frame.png"):addTo(self)
  self.mTimeFrame = timeFrame
  self.mTimeLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("%02d:%02d", self.mMinutes, self.mSeconds),
    font = "fonts/yellowNum.fnt"
  }):scale(0.75):align(display.CENTER, timeFrame:getContentSize().width * 0.75, timeFrame:getContentSize().height * 0.5):addTo(timeFrame)
  self:startCountDown_(self.mWaveData.waveTime)
end

function M:checkStrategy()
  local normalIds = self.mWaveData.normalIds
  local cycleIds = self.mWaveData.cycleIds
  local normalIdx = 1
  
  local function tNormalEnd()
    normalIdx = normalIdx + 1
    if normalIdx <= #normalIds then
      local strategyId = normalIds[normalIdx]
      self:performWithDelay(function()
        self:triggerStrategyTo(strategyId, tNormalEnd)
      end, 0)
    end
  end
  
  local strategyId = normalIds[normalIdx]
  self:triggerStrategyTo(strategyId, tNormalEnd)
  local cycleIdx = 1
  
  local function tCycleEnd()
    local strategyId
    if 1 == #cycleIds then
      strategyId = cycleIds[1]
    else
      cycleIdx = cycleIdx + 1
      strategyId = cycleIds[cycleIdx]
      if cycleIdx == #cycleIds then
        cycleIdx = 0
      end
    end
    self:performWithDelay(function()
      self:triggerStrategyTo(strategyId, tCycleEnd)
    end, 0)
  end
  
  local strategyId = cycleIds[cycleIdx]
  self:triggerStrategyTo(strategyId, tCycleEnd)
end

function M:triggerStrategyTo(strategyId_, handler_)
  if not strategyId_ or 0 == tonumber(strategyId_) then
    if handler_ then
      handler_()
    end
    return
  end
  print("strategyId_ : " .. strategyId_)
  local sData = DataUtils.getStrategyData(GameManager.MODE, strategyId_)
  dump(sData, "sData : ")
  
  local function tFuncTryCreate(monsterId)
    if #BMgr.getMonsterList() >= GameData.MAX_MONSTER_NUM then
      self:performWithDelay(function()
        tFuncTryCreate(monsterId)
      end, 0.5)
    else
      BMgr.createMonster(GameData.BG, monsterId, nil, 1, false)
    end
  end
  
  local function tFuncCreateMonster(tb, num)
    for i = 1, #tb do
      for j = 1, tonumber(num[i]) do
        self:performWithDelay(function()
          tFuncTryCreate(tonumber(tb[i]))
        end, 0.5 * (j - 1))
      end
    end
  end
  
  local function tFuncCreateMonsterEx(tb, num)
    tFuncCreateMonster(tb, num)
    if handler_ then
      handler_()
    end
  end
  
  for i = 1, sData.waves do
    local readyTime = sData.strategy[i].readyTime
    local monsterIds = sData.strategy[i].monsterIds
    local monsterNum = sData.strategy[i].monsterNum
    if i == sData.waves then
      self:performWithDelay(function()
        tFuncCreateMonsterEx(monsterIds, monsterNum)
      end, readyTime)
    else
      self:performWithDelay(function()
        tFuncCreateMonster(monsterIds, monsterNum)
      end, readyTime)
    end
  end
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
  GameData.WAVE_NUM = GameData.WAVE_NUM + 1
  DDLOG("========== \231\172\172%d\230\179\162", GameData.WAVE_NUM)
  if GameData.WAVE_NUM > self.mWaveCountNum then
    GameData.WAVE_OVER = true
    return
  end
  self.mWaveData = DataUtils.getInfiniteWaveData(GameManager.STAGE_ID, GameData.WAVE_NUM)
  self:checkStrategy()
  self:startCountDown_(self.mWaveData.waveTime)
  self.mCallback()
  if GameData.WAVE_NUM == self.mWaveCountNum then
    self.mTimeLabel:setVisible(false)
    self.mTimeFrame:setTexture("game_infinite/last_wave.png")
  end
end

return M

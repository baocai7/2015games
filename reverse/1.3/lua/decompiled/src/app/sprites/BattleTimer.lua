local Monster = require("app.sprites.Monster")
local BattleTimer = {}
BattleTimer = class("BattleTimer", function()
  return display.newNode()
end)

function BattleTimer:ctor()
  self:initData_()
  self:initUI_()
  self:schedule(function()
    self:update()
  end, 0.1)
end

function BattleTimer:initData_()
  self.infiniteStageModel_ = DataUtils.getInfiniteStageModel(CloudData.INFINITE_STAGE_PROGRESS)
  self.waveIdTable_ = self.infiniteStageModel_.waveIdTable_
  self.monsterWaveModel_ = DataUtils.getMonsterWaveModel(self.waveIdTable_[Game.ROUND_NUM])
  self.minutes_ = 0
  self.seconds_ = 0
  self.canMakeMonster_ = true
  self.strategyInWave_ = 1
  self.indexInStrategy_ = 1
  self:changeStrategyTo("strategy1")
end

function BattleTimer:initUI_()
  self.timeFrame_ = display.newSprite("game_infinite/time_frame.png", 0, 0):addTo(self)
  self.timeLabel_ = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("%02d:%02d", self.minutes_, self.seconds_),
    font = "fonts/yellowNum.fnt"
  }):scale(0.75):align(display.CENTER, self.timeFrame_:getContentSize().width * 0.75, self.timeFrame_:getContentSize().height * 0.5):addTo(self.timeFrame_)
  self:startCountDown_(self.monsterWaveModel_.waveTime_)
end

function BattleTimer:update()
  if self.canMakeMonster_ and self.strategyInWave_ <= 7 then
    self.canMakeMonster_ = false
    print("--------------after : " .. self.curIntervalTime_)
    self:performWithDelay(function()
      self:makeMonster()
    end, self.curIntervalTime_)
  end
end

function BattleTimer:changeStrategyTo(strategyName)
  self.curStrategy_ = strategyName
  if "strategy1" == strategyName then
    print(DYLang.getString("S1491", ""))
    self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable1_
    self.curIntervalTime_ = self.monsterWaveModel_.intervalTimeStrategy1_
  elseif "strategy2" == strategyName then
    print(DYLang.getString("S1492", ""))
    self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable2_
    self.curIntervalTime_ = self.monsterWaveModel_.intervalTimeStrategy2_
  elseif "strategy3" == strategyName then
    print(DYLang.getString("S1493", ""))
    self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable3_
    self.curIntervalTime_ = self.monsterWaveModel_.intervalTimeStrategy3_
  elseif "strategy4" == strategyName then
    print(DYLang.getString("S1494", ""))
    self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable4_
    self.curIntervalTime_ = self.monsterWaveModel_.intervalTimeStrategy4_
  elseif "strategy5" == strategyName then
    print(DYLang.getString("S1495", ""))
    self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable5_
    self.curIntervalTime_ = self.monsterWaveModel_.intervalTimeStrategy5_
  elseif "strategy6" == strategyName then
    print(DYLang.getString("S1496", ""))
    self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable6_
    self.curIntervalTime_ = self.monsterWaveModel_.intervalTimeStrategy6_
  elseif "strategy7" == strategyName then
    print(DYLang.getString("S1497", ""))
    self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable7_
    self.curIntervalTime_ = self.monsterWaveModel_.intervalTimeStrategy7_
  end
end

function BattleTimer:makeMonster()
  if #Game.MONSTER_TABLE > self.monsterWaveModel_.monsterNumLimit_ then
    print("=========== full!!! ===========")
    self.canMakeMonster_ = false
    return
  end
  local monsterId = tonumber(self.curMonsterIdsTable_[self.indexInStrategy_])
  print("monsterId : " .. monsterId)
  if 0 < monsterId then
    print(self.curStrategy_ .. "    " .. self.indexInStrategy_ .. " \229\135\186\229\133\181 \239\188\154 " .. monsterId)
    local monsterModel = DataUtils.getInfiniteMonsterModel(monsterId)
    local monster = Monster.new(monsterModel, cc.p(Game.TOWER_MONSTER:getPositionX() + 70, display.height * 0.2))
    Game.BG1:addChild(monster, monster.zOrder_)
    Game.MONSTER_TABLE[#Game.MONSTER_TABLE + 1] = monster
  end
  self.indexInStrategy_ = self.indexInStrategy_ + 1
  if monsterId <= 0 or self.indexInStrategy_ > #self.curMonsterIdsTable_ then
    self.strategyInWave_ = self.strategyInWave_ + 1
    self.indexInStrategy_ = 1
    if self.strategyInWave_ == 2 then
      self:changeStrategyTo("strategy2")
    elseif self.strategyInWave_ == 3 then
      self:changeStrategyTo("strategy3")
    elseif self.strategyInWave_ == 4 then
      self:changeStrategyTo("strategy4")
    elseif self.strategyInWave_ == 5 then
      self:changeStrategyTo("strategy5")
    elseif self.strategyInWave_ == 6 then
      self:changeStrategyTo("strategy6")
    elseif self.strategyInWave_ == 7 then
      self:changeStrategyTo("strategy7")
    else
      self:countdownOver_()
    end
  end
  self.canMakeMonster_ = true
end

function BattleTimer:startCountDown_(time)
  if time == 0 then
    self:countdownOver_()
  else
    self.minutes_ = math.floor(time / 60)
    self.seconds_ = math.floor(time - self.minutes_ * 60)
    self.scheduleTime_ = self:schedule(function()
      self:updateTime_()
    end, 1)
  end
end

function BattleTimer:updateTime_()
  if self.seconds_ > 0 then
    self.seconds_ = self.seconds_ - 1
  elseif 0 < self.minutes_ then
    self.seconds_ = 59
    self.minutes_ = self.minutes_ - 1
  else
    self:countdownOver_()
  end
  self.timeLabel_:setString(string.format("%02d:%02d", self.minutes_, self.seconds_))
end

function BattleTimer:countdownOver_()
  self:stopAction(self.scheduleTime_)
  Game.ROUND_NUM = Game.ROUND_NUM + 1
  print(string.format("==========\231\172\172%d\230\179\162===========", Game.ROUND_NUM))
  if Game.ROUND_NUM > #self.waveIdTable_ then
    Game.MONSTER_WAVE_OVER = true
    return
  end
  self:getParent().roundNumLabel_:setString(Game.ROUND_NUM)
  self.monsterWaveModel_ = DataUtils.getMonsterWaveModel(self.waveIdTable_[Game.ROUND_NUM])
  self:changeStrategyTo("strategy1")
  self:startCountDown_(self.monsterWaveModel_.waveTime_)
  if Game.ROUND_NUM == #self.waveIdTable_ then
    self.timeLabel_:setVisible(false)
    self.timeFrame_:setTexture("game_infinite/last_wave.png")
  end
  self:getParent():waveAction()
  self.strategyInWave_ = 1
  self.indexInStrategy_ = 1
end

return BattleTimer

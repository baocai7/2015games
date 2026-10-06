local M = {}
M = class("PanelBossBar", function()
  return display.newNode()
end)

function M:ctor(index)
  self:initData()
  self:initUI()
  self:setNodeEventEnabled(true)
end

function M:onEnter()
  DYNotification.registerScriptObserver(self, handler(self, self.updateBlood), DY_KEY.kMonsterBossBlood)
end

function M:onExit()
  DYNotification.removeAllObservers(self)
end

function M:initData()
  local monsterModel = DataUtils.getMonsterBaseInfo(GameData.BOSS_ID)
  self.mBossIcon = monsterModel.npcIcon
  self.mBossHp = monsterModel.life
  self.mCurrHp = self.mBossHp
  if GameManager.MODE == 3 then
    self.mCurrHp = CloudData.PURGATORY_BOSS_LEFT_HP
  elseif GameManager.MODE == 10 then
    self.mCurrHp = CloudData.AGGRESS_BOSS_LEFT_HP
  end
  self.mIsRebel = monsterModel.isRebel
  self.mPerCount = self.mBossHp / 9
  self.mProgressTable = {}
end

function M:initUI()
  local frame = display.newSprite("purgatory/boss.png"):align(display.CENTER_LEFT, 0, 0):addTo(self)
  local icon = display.newSprite(self.mBossIcon, 68, 60):addTo(frame, -1)
  if 1 == self.mIsRebel then
    icon:setScaleX(-1)
  end
  local barBg = display.newSprite("purgatory/bar_bg.png"):align(display.CENTER_LEFT, 128, 60):addTo(frame)
  for i = 1, 9 do
    local progressTimer = display.newProgressTimer("purgatory/bar_pro" .. i .. ".png", display.PROGRESS_TIMER_BAR):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 9 - i)
    progressTimer:setMidpoint(cc.p(0, 0))
    progressTimer:setBarChangeRate(cc.p(1, 0))
    local currPercent = self.mCurrHp - self.mPerCount * (9 - i)
    if currPercent <= 0 then
      currPercent = 0
    end
    progressTimer:setPercentage(currPercent / self.mPerCount * 100)
    table.insert(self.mProgressTable, progressTimer)
  end
  local idx = math.ceil(self.mCurrHp / self.mPerCount)
  self.mLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    size = string.format("*%d", idx),
    font = "fonts/bossHp.fnt"
  }):align(display.TOP_LEFT, barBg:getContentSize().width * 0.8, barBg:getContentSize().height + 30):addTo(barBg)
  self:updateBlood("init", self.mCurrHp)
end

function M:updateBlood(eventname, cupHp)
  for i = 1, #self.mProgressTable do
    local progressTimer = self.mProgressTable[i]
    local currPercent = cupHp - self.mPerCount * (9 - i)
    if currPercent <= 0 then
      currPercent = 0
    end
    progressTimer:setPercentage(currPercent / self.mPerCount * 100)
  end
  local idx = math.ceil(cupHp / self.mPerCount)
  if idx < 0 then
    idx = 0
  end
  self.mLabel:setString(string.format("*%d", idx))
end

return M

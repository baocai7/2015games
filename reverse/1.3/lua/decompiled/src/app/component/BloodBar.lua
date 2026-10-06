local DYClass = "BloodBar"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)

local function initData(flag, monsterType)
  local bgPath, barPath, visible
  local offsetX = 0
  local monsterType = monsterType or 1
  if 1 == flag then
    bgPath = "gamescene/bar_hp_bg.png"
    barPath = "gamescene/bar_hp_buddha.png"
    visible = false
  elseif 2 == flag then
    if 1 == monsterType then
      bgPath = "gamescene/bar_hp_bg.png"
      barPath = "gamescene/bar_hp_monster.png"
      visible = false
    elseif 2 == monsterType then
      bgPath = "gamescene/bar_hp_bg_elite.png"
      barPath = "gamescene/bar_hp_boss.png"
      offsetX = 22
      visible = true
    elseif 3 == monsterType then
      bgPath = "gamescene/bar_hp_bg_boss.png"
      barPath = "gamescene/bar_hp_boss.png"
      offsetX = 22
      visible = true
    end
  end
  return bgPath, barPath, offsetX, visible
end

function M:ctor(flag, monsterType)
  local bgPath, barPath, offsetX, visible = initData(flag, monsterType)
  self.mMonsterType = monsterType
  self._barBg = display.newSprite(bgPath):addTo(self)
  self._progressTimer = cc.ProgressTimer:create(display.newSprite(barPath)):addTo(self._barBg)
  self._progressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self._progressTimer:setPosition(self._barBg:getContentSize().width / 2 + offsetX, self._barBg:getContentSize().height / 2)
  self._progressTimer:setMidpoint(cc.p(0, 0))
  self._progressTimer:setBarChangeRate(cc.p(1, 0))
  self._progressTimer:setPercentage(100)
  self:setVisible(visible)
end

function M:setHp(value, maxvalue)
  if value < maxvalue then
    self:setVisible(true)
  end
  self:setVisible(true)
  self._progressTimer:setPercentage(value / maxvalue * 100)
end

function M:setHideForever()
  self:setVisible(false)
  
  function self.setVisible()
    return true
  end
end

function M:changeBloodColor(flag)
  local bgPath, barPath, offsetX, visible = initData(flag, self.mMonsterType)
  self._barBg = display.newSprite(bgPath):addTo(self)
  self._progressTimer = cc.ProgressTimer:create(display.newSprite(barPath)):addTo(self._barBg)
  self._progressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self._progressTimer:setPosition(self._barBg:getContentSize().width / 2 + offsetX, self._barBg:getContentSize().height / 2)
  self._progressTimer:setMidpoint(cc.p(0, 0))
  self._progressTimer:setBarChangeRate(cc.p(1, 0))
  self._progressTimer:setPercentage(100)
  self:hide()
end

return M

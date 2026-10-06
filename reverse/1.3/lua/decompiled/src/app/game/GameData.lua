local M = {}
M.MODE = 0
M.BG = nil
M.TEAM_ICON = {}
M.TOWER_DISTANCE = 0
M.CLEAN_TIME = 0
M.BATTLE_TIME = 0
M.GAME_TYPE = 0
M.BOSS_ID = 0
M.MAX_MONSTER_NUM = 0
M.PVE_FRAME = 24
M.WAVE_NUM = 1
M.SPIRIT_LEVEL = 1
M.CURRENT_SPIRIT = 0
M.CURRENT_SPIRIT_FACTOR = math.random(13, 10001)
M.CURRENT_SPIRIT_A = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
}
M.CURRENT_SPIRIT_B = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
}
M.CURRENT_SPIRIT_INDEX = 1
M.S_FILE_INFO = {}
M.CURRENT_TOWER_HP = 0

local function resetSpiritIndex()
  M.CURRENT_SPIRIT_A = {
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  }
  M.CURRENT_SPIRIT_B = {
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  }
  M.CURRENT_SPIRIT_INDEX = math.random(1, 20)
  M.CURRENT_SPIRIT_FACTOR = math.random(13, 10001)
  M.CURRENT_SPIRIT_A[M.CURRENT_SPIRIT_INDEX] = 0
  M.CURRENT_SPIRIT_B[M.CURRENT_SPIRIT_INDEX] = 0
end

M.resetSpiritIndex = resetSpiritIndex

local function getCurrentSpirit()
  local currentSpirit = M.CURRENT_SPIRIT_A[M.CURRENT_SPIRIT_INDEX] * M.CURRENT_SPIRIT_FACTOR + M.CURRENT_SPIRIT_B[M.CURRENT_SPIRIT_INDEX]
  return -currentSpirit
end

M.getCurrentSpirit = getCurrentSpirit

local function setCheatValue()
  local step = math.random(5, 11)
  local value = M.CURRENT_SPIRIT_FACTOR + step * 77
  for i = 1, 20, step do
    if i ~= M.CURRENT_SPIRIT_INDEX then
      value = value / 2
      M.CURRENT_SPIRIT_A[i] = value
      value = value / 2
      M.CURRENT_SPIRIT_B[i] = value
    end
  end
end

local function setCurrentSpirit(count)
  setCheatValue()
  M.CURRENT_SPIRIT = count
  local a = math.floor(count / M.CURRENT_SPIRIT_FACTOR)
  local b = count - a * M.CURRENT_SPIRIT_FACTOR
  M.CURRENT_SPIRIT_A[M.CURRENT_SPIRIT_INDEX] = -a
  M.CURRENT_SPIRIT_B[M.CURRENT_SPIRIT_INDEX] = -b
end

M.setCurrentSpirit = setCurrentSpirit

local function updateSpirit(num)
  setCurrentSpirit(getCurrentSpirit() + num)
end

M.updateSpirit = updateSpirit
M.spiritLimitNum = 0

local function setSpiritLimit(value)
  M.spiritLimitNum = M.spiritLimitNum + value
end

M.setSpiritLimit = setSpiritLimit

local function getSpiritLimit()
  return M.spiritLimitNum
end

M.getSpiritLimit = getSpiritLimit
M.CURRENT_HP_FACTOR = math.random(13, 10001)
M.CURRENT_HP_A = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
}
M.CURRENT_HP_B = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
}
M.CURRENT_HP_INDEX = 1

local function resetHPIndex()
  M.CURRENT_HP_A = {
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  }
  M.CURRENT_HP_B = {
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  }
  M.CURRENT_HP_INDEX = math.random(1, 20)
  M.CURRENT_HP_FACTOR = math.random(13, 10001)
  M.CURRENT_HP_A[M.CURRENT_HP_INDEX] = 0
  M.CURRENT_HP_B[M.CURRENT_HP_INDEX] = 0
end

M.resetHPIndex = resetHPIndex

local function getMonsterTowerHP()
  local currentHP = M.CURRENT_HP_A[M.CURRENT_HP_INDEX] * M.CURRENT_HP_FACTOR + M.CURRENT_HP_B[M.CURRENT_HP_INDEX]
  return -currentHP
end

local function setMonsterTowerHP(count)
  setCheatValue()
  M.CURRENT_TOWER_HP = count
  local a = math.floor(count / M.CURRENT_HP_FACTOR)
  local b = count - a * M.CURRENT_HP_FACTOR
  M.CURRENT_HP_A[M.CURRENT_HP_INDEX] = -a
  M.CURRENT_HP_B[M.CURRENT_HP_INDEX] = -b
end

M.setMonsterTowerHP = setMonsterTowerHP
M.getMonsterTowerHP = getMonsterTowerHP

local function resetBuddhaCDTime()
  for k, v in pairs(M.TEAM_ICON) do
    if v.mIsInCD then
      v:removeProTimer()
    end
  end
end

M.resetBuddhaCDTime = resetBuddhaCDTime
M.SCENE_ELEMENT_BUDDHA = {
  0,
  0,
  0,
  0,
  0
}
M.SCENE_ELEMENT_MONSTER = {
  0,
  0,
  0,
  0,
  0
}

function M.reset()
  M.MODE = 0
  M.SPIRIT_LEVEL = 1
  M.BG = nil
  M.TOWER_DISTANCE = 0
  M.CLEAN_TIME = 0
  M.BATTLE_TIME = 0
  M.MAX_MONSTER_NUM = 0
  M.GAME_TYPE = 0
  M.WAVE_NUM = 1
  M.spiritLimitNum = 0
  M.SpiritPanel = nil
  M.TEAM_ICON = {}
  M.resetSpiritIndex()
  M.setCurrentSpirit(0)
  M.resetHPIndex()
  M.climeliaRangeTrip = nil
  M.SKIP_BATTLE = false
  M.SCENE_ELEMENT_BUDDHA = {
    0,
    0,
    0,
    0,
    0
  }
  M.SCENE_ELEMENT_MONSTER = {
    0,
    0,
    0,
    0,
    0
  }
end

return M

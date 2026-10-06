local M = class("AIManager")
M.EVENT_UPGRADE_SPIRIT = "upgrade_spirit"
M.EVENT_CREATE_CARD = "create_card"
M.EVENT_CIMELIA_ATTACK = "cimelia_attack"
M.EVENT_CIMELIA_DEFENCE = "cimelia_defence"
M.SPIRIT_NUM = 1001
M.BUDDHA_CARD = 1002
M.WAND_SKILL = 1003
M.TOWER_SKILL = 1004
M.FIGHT_MODE_NORMAL = 1
M.FIGHT_MODE_KACAO = 2
M.COLD_TIME = 500

function M:ctor(data)
  cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
  self:initData(data)
end

function M:initData(data)
  self.mStrategy = nil
  self.mActionSeries = {}
  self.mColdTime = 0
  self.mFightData = nil
  self.mStaticFightData = data.towerData
  self.mTick = data.tick * 1000
  self.mFightMode = data.fightMode
  self.mTowerDis = data.towerDis
  self.mActionData = data.action
  self.mActionSeriesData = data.actionSeries
  self.mStrategyData = data.strategy
  self.mSid = 0
end

function M:calDeltaForce()
  local fightData = self.mFightData
  local selfCharacter = 0
  local enemyCharacter = 0
  local selfTower = fightData.selfTower.hp / self.mStaticFightData.selfTower.totalHp * 5
  local enemyTower = fightData.enemyTower.hp / self.mStaticFightData.enemyTower.totalHp * 5
  for k, character in pairs(fightData.self) do
    selfCharacter = selfCharacter + character.force * character.dis / self.mTowerDis
  end
  for k, character in pairs(fightData.enemy) do
    enemyCharacter = enemyCharacter + character.force * character.dis / self.mTowerDis
  end
  return selfCharacter - enemyCharacter + selfTower - enemyTower
end

function M:fetchStrategy()
  local fightData = self.mFightData
  local deltaForce = self:calDeltaForce()
  local strategys = self.mStrategyData
  local condition
  for index, strategy in pairs(strategys) do
    local flag = true
    condition = strategy.Condition1
    if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
      local items = string.split(condition, ";")
      if deltaForce < tonumber(items[1]) or deltaForce > tonumber(items[2]) then
        flag = false
      end
    end
    condition = strategy.Condition2
    if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
      local items = string.split(condition, ";")
      if fightData.spirit.value < tonumber(items[1]) or fightData.spirit.value > tonumber(items[2]) then
        flag = false
      end
    end
    condition = strategy.Condition3
    if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
      local items = string.split(condition, ";")
      if fightData.spirit.level < tonumber(items[1]) or fightData.spirit.level > tonumber(items[2]) then
        flag = false
      end
    end
    condition = strategy.Condition4
    if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
      local items = string.split(condition, ";")
      if fightData.cimelia.selfAttack.cd < tonumber(items[1]) or fightData.cimelia.selfAttack.cd > tonumber(items[2]) then
        flag = false
      end
    end
    condition = strategy.Condition5
    if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
      local items = string.split(condition, ";")
      if fightData.cimelia.selfDefence.cd < tonumber(items[1]) or fightData.cimelia.selfDefence.cd > tonumber(items[2]) then
        flag = false
      end
    end
    condition = strategy.Condition6
    if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
      local items = string.split(condition, ";")
      local towerRate = fightData.selfTower.hp / self.mStaticFightData.selfTower.totalHp * 100
      if towerRate < tonumber(items[1]) or towerRate > tonumber(items[2]) then
        flag = false
      end
    end
    condition = strategy.Condition7
    if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
      local items = string.split(condition, ";")
      local towerRate = fightData.enemyTower.hp / self.mStaticFightData.enemyTower.totalHp * 100
      if towerRate < tonumber(items[1]) or towerRate > tonumber(items[2]) then
        flag = false
      end
    end
    condition = strategy.Condition8
    if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
      local items = string.split(condition, ";")
      local selfCount = table.nums(fightData.self)
      if selfCount < tonumber(items[1]) or selfCount > tonumber(items[2]) then
        flag = false
      end
    end
    condition = strategy.Condition9
    if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
      local items = string.split(condition, ";")
      local enemyCount = table.nums(fightData.enemy)
      if enemyCount < tonumber(items[1]) or enemyCount > tonumber(items[2]) then
        flag = false
      end
    end
    condition = strategy.Condition10
    if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
      local items = string.split(condition, ";")
      if fightData.cimelia.enemyAttack.cd < tonumber(items[1]) or fightData.cimelia.enemyAttack.cd > tonumber(items[2]) then
        flag = false
      end
    end
    condition = strategy.Condition11
    if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
      local items = string.split(condition, ";")
      if fightData.cimelia.enemyDefence.cd < tonumber(items[1]) or fightData.cimelia.enemyDefence.cd > tonumber(items[2]) then
        flag = false
      end
    end
    if flag then
      self.mStrategy = strategy
      return
    end
  end
end

function M:fetchActionSeries()
  if not self.mStrategy then
    return
  end
  local weight = 0
  local actionSerieses = {}
  for i = 1, 15 do
    local actionSeriesItem = self.mStrategy["ActionSeries" .. i]
    if actionSeriesItem == nil or actionSeriesItem == "" then
      break
    end
    local actionSeriesItems = string.split(actionSeriesItem, "-")
    if self:checkActionSeries(actionSeriesItems[1]) then
      weight = weight + tonumber(actionSeriesItems[2])
      table.insert(actionSerieses, {
        id = actionSeriesItems[1],
        weight = weight
      })
    end
  end
  if weight == 0 then
    return
  end
  local actionSeriesId
  local shakePoint = math.random(1, weight)
  for index, value in pairs(actionSerieses) do
    if shakePoint <= value.weight then
      actionSeriesId = value.id
      break
    end
  end
  local actionSeries = self.mActionSeriesData[tostring(actionSeriesId)]
  local actionIds = string.split(actionSeries.ActionIds, ";")
  for k, actionId in pairs(actionIds) do
    local action = self.mActionData[tostring(actionId)]
    table.insert(self.mActionSeries, action)
  end
end

function M:doAction(action)
  if not self:checkAction(action) then
    return
  end
  local cardType = tostring(action.CardType)
  local fightData = self.mFightData
  if self.mFightMode == M.FIGHT_MODE_NORMAL then
    if cardType == "1" or cardType == "2" or cardType == "3" then
      self:dispatchEvent({
        name = M.EVENT_CIMELIA_ATTACK,
        params = {}
      })
    elseif cardType == "4" or cardType == "5" or cardType == "6" then
      self:dispatchEvent({
        name = M.EVENT_CIMELIA_DEFENCE,
        params = {}
      })
    elseif cardType == "7" then
      self.mColdTime = M.COLD_TIME
      self:dispatchEvent({
        name = M.EVENT_UPGRADE_SPIRIT,
        params = {}
      })
    elseif cardType == "8" then
      self.mColdTime = tonumber(action.ConsumeType) * 1000
    elseif cardType == "9" then
      return
    elseif cardType == "10" then
      for index, card in ipairs(fightData.team) do
        if card.isReady and card.cost <= fightData.spirit.value then
          self.mColdTime = M.COLD_TIME
          self:dispatchEvent({
            name = M.EVENT_CREATE_CARD,
            params = {cardIndex = index}
          })
          return
        end
      end
    else
      local values = string.split(action.ConsumeType, ";")
      for index, card in ipairs(fightData.team) do
        if card.isReady and string.match(card.aiTags, cardType) and card.cost >= tonumber(values[1]) and card.cost <= tonumber(values[2]) and card.cost <= fightData.spirit.value then
          self.mColdTime = M.COLD_TIME
          self:dispatchEvent({
            name = M.EVENT_CREATE_CARD,
            params = {cardIndex = index}
          })
          return
        end
      end
    end
  elseif self.mFightMode == M.FIGHT_MODE_KACAO then
    if cardType == "1" or cardType == "2" or cardType == "3" then
      for index, card in pairs(fightData.team) do
        if card.tag == M.WAND_SKILL and card.isReady and string.match(card.aiTags, cardType) and card.cost <= fightData.spirit.value then
          self.mColdTime = M.COLD_TIME
          self:dispatchEvent({
            name = M.EVENT_CREATE_CARD,
            params = {cardIndex = index}
          })
          return
        end
      end
    elseif cardType == "4" or cardType == "5" or cardType == "6" then
      for index, card in pairs(fightData.team) do
        if card.tag == M.TOWER_SKILL and card.isReady and string.match(card.aiTags, cardType) and card.cost <= fightData.spirit.value then
          self.mColdTime = M.COLD_TIME
          self:dispatchEvent({
            name = M.EVENT_CREATE_CARD,
            params = {cardIndex = index}
          })
          return
        end
      end
    elseif cardType == "7" then
      self.mColdTime = M.COLD_TIME
      self:dispatchEvent({
        name = M.EVENT_UPGRADE_SPIRIT,
        params = {}
      })
    elseif cardType == "8" then
      self.mColdTime = tonumber(action.ConsumeType) * 1000
    elseif cardType == "9" then
      for index, card in pairs(fightData.team) do
        if card.tag == M.SPIRIT_NUM and card.isReady then
          self.mColdTime = M.COLD_TIME
          self:dispatchEvent({
            name = M.EVENT_CREATE_CARD,
            params = {cardIndex = index}
          })
          return
        end
      end
    elseif cardType == "10" then
      for index, card in ipairs(fightData.team) do
        if card.isReady and card.cost <= fightData.spirit.value then
          self.mColdTime = M.COLD_TIME
          self:dispatchEvent({
            name = M.EVENT_CREATE_CARD,
            params = {cardIndex = index}
          })
          return
        end
      end
    else
      local values = string.split(action.ConsumeType, ";")
      for index, card in ipairs(fightData.team) do
        if card.isReady and string.match(card.aiTags, cardType) and card.cost >= tonumber(values[1]) and card.cost <= tonumber(values[2]) and card.cost <= fightData.spirit.value then
          self.mColdTime = M.COLD_TIME
          self:dispatchEvent({
            name = M.EVENT_CREATE_CARD,
            params = {cardIndex = index}
          })
          return
        end
      end
    end
  end
end

function M:isStrategyBroken()
  local fightData = self.mFightData
  if table.nums(self.mActionSeries) <= 0 then
    return true
  end
  if not self.mStrategy then
    return true
  end
  local condition = self.mStrategy.ExitStrategy1
  if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
    local deltaForce = self:calDeltaForce()
    local items = string.split(condition, ";")
    if deltaForce < tonumber(items[1]) or deltaForce > tonumber(items[2]) then
      return true
    end
  end
  condition = self.mStrategy.ExitStrategy2
  if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
    if tonumber(condition) == 1 then
      if fightData.spirit.isValueFull then
        return true
      end
    elseif tonumber(condition) == 0 and not fightData.spirit.isValueFull then
      return true
    end
  end
  condition = self.mStrategy.ExitStrategy3
  if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
    if tonumber(condition) == 1 then
      if fightData.spirit.isLevelFull then
        return true
      end
    elseif tonumber(condition) == 0 and not fightData.spirit.isLevelFull then
      return true
    end
  end
  condition = self.mStrategy.ExitStrategy4
  if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
    if tonumber(condition) == 1 then
      if 0 >= fightData.cimelia.selfAttack.cd then
        return true
      end
    elseif tonumber(condition) == 0 and 0 < fightData.cimelia.selfAttack.cd then
      return true
    end
  end
  condition = self.mStrategy.ExitStrategy5
  if condition ~= nil and condition ~= "" and tostring(condition) ~= "-1" then
    if tonumber(condition) == 1 then
      if 0 >= fightData.cimelia.selfDefence.cd then
        return true
      end
    elseif tonumber(condition) == 0 and 0 < fightData.cimelia.selfDefence.cd then
      return true
    end
  end
  return false
end

function M:doStrategyBroken()
  self.mStrategy = nil
  self.mActionSeries = {}
  self.mColdTime = 0
  self:fetchStrategy()
  self:fetchActionSeries()
end

function M:checkActionSeries(actionSeriesId)
  local actionSeries = self.mActionSeriesData[tostring(actionSeriesId)]
  local actionIds = string.split(actionSeries.ActionIds, ";")
  for k, item in pairs(actionIds) do
    if not self:checkAction(self.mActionData[tostring(item)]) then
      return false
    end
  end
  return true
end

function M:checkAction(action)
  local fightData = self.mFightData
  local cardType = tostring(action.CardType)
  if self.mFightMode == M.FIGHT_MODE_NORMAL then
    if cardType == "1" then
      return string.match(fightData.cimelia.selfAttack.tags, cardType) and fightData.cimelia.selfAttack.cd <= 0 and fightData.cimelia.selfAttack.isValid
    elseif cardType == "2" then
      return string.match(fightData.cimelia.selfAttack.tags, cardType) and fightData.cimelia.selfAttack.cd <= 0 and fightData.cimelia.selfAttack.isValid
    elseif cardType == "3" then
      return string.match(fightData.cimelia.selfAttack.tags, cardType) and fightData.cimelia.selfAttack.cd <= 0 and fightData.cimelia.selfAttack.isValid
    elseif cardType == "4" then
      return string.match(fightData.cimelia.selfDefence.tags, cardType) and 0 >= fightData.cimelia.selfDefence.cd
    elseif cardType == "5" then
      return string.match(fightData.cimelia.selfDefence.tags, cardType) and 0 >= fightData.cimelia.selfDefence.cd
    elseif cardType == "6" then
      return string.match(fightData.cimelia.selfDefence.tags, cardType) and 0 >= fightData.cimelia.selfDefence.cd
    elseif cardType == "7" then
      return fightData.spirit.canUpgrade
    elseif cardType == "8" then
      return true
    elseif cardType == "9" then
      return false
    elseif cardType == "10" then
      for k, card in pairs(fightData.team) do
        if card.isReady and card.cost <= fightData.spirit.value then
          return true
        end
      end
      return false
    else
      local values = string.split(action.ConsumeType, ";")
      for k, card in pairs(fightData.team) do
        if card.isReady and string.match(card.aiTags, cardType) and card.cost >= tonumber(values[1]) and card.cost <= tonumber(values[2]) and card.cost <= fightData.spirit.value then
          return true
        end
      end
      return false
    end
  elseif self.mFightMode == M.FIGHT_MODE_KACAO then
    if cardType == "1" or cardType == "2" or cardType == "3" then
      for k, card in pairs(fightData.team) do
        if card.tag == M.WAND_SKILL and card.isReady and string.match(card.aiTags, cardType) and card.cost <= fightData.spirit.value then
          return true
        end
      end
      return false
    elseif cardType == "4" or cardType == "5" or cardType == "6" then
      for k, card in pairs(fightData.team) do
        if card.tag == M.TOWER_SKILL and card.isReady and string.match(card.aiTags, cardType) and card.cost <= fightData.spirit.value then
          return true
        end
      end
      return false
    elseif cardType == "7" then
      return fightData.spirit.canUpgrade
    elseif cardType == "8" then
      return true
    elseif cardType == "9" then
      for k, card in pairs(fightData.team) do
        if card.tag == M.SPIRIT_NUM and card.isReady then
          return true
        end
      end
      return false
    elseif cardType == "10" then
      for k, card in pairs(fightData.team) do
        if card.isReady and card.cost <= fightData.spirit.value then
          return true
        end
      end
      return false
    else
      local values = string.split(action.ConsumeType, ";")
      for k, card in pairs(fightData.team) do
        if card.tag == M.BUDDHA_CARD and card.isReady and string.match(card.aiTags, cardType) and card.cost >= tonumber(values[1]) and card.cost <= tonumber(values[2]) and card.cost <= fightData.spirit.value then
          return true
        end
      end
      return false
    end
  end
end

function M:heartbeat(fightData)
  self.mSid = self.mSid + 1
  self.mFightData = fightData
  if self.mFightData.isOnEvent then
    return
  end
  local sss = self.mStrategy or {}
  local out = "sid = " .. self.mSid
  out = out .. ", sl = " .. fightData.spirit.level
  out = out .. ", sv = " .. fightData.spirit.value
  out = out .. ", force = " .. self:calDeltaForce()
  out = out .. ", strategy = " .. (self.mStrategy and self.mStrategy.ID or "nil")
  out = out .. ", team = "
  for k, v in pairs(fightData.team) do
    out = out .. (v.buddhaId or "nil") .. ";"
  end
  out = out .. ", as = "
  for k, v in pairs(self.mActionSeries) do
    out = out .. v.ID .. "-" .. v.CardType .. ";"
  end
  out = out .. ", spiritValueIsfull = " .. (fightData.spirit.isValueFull and 1 or 0)
  out = out .. ", spiritLevelIsfull = " .. (fightData.spirit.isLevelFull and 1 or 0)
  out = out .. ", spiritCanUpgrade = " .. (fightData.spirit.canUpgrade and 1 or 0)
  if self:isStrategyBroken() then
    self:doStrategyBroken()
    return
  end
  self.mColdTime = self.mColdTime - self.mTick
  if 0 < self.mColdTime then
    return
  end
  self:doAction(self.mActionSeries[1])
  table.remove(self.mActionSeries, 1)
end

return M

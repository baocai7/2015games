local SpecialArea = require("app.sprites.SpecialArea")
local DYClass = "Skill"
local table = table
local M = {}
M = class(DYClass)

function M:ctor(source, id, skillLv)
  self.mSource = source
  self.mID = id
  self.mData = {}
  if tonumber(self.mID) == 0 then
    return nil
  end
  self:initData(id, self.mSource.model_.npcId, skillLv or 1)
  if 1 > tonumber(self.mData.skillLevel) then
    return nil
  end
  self:initFunc()
  self.mTriggerType = tonumber(self.mData.checkType)
  self.isColding = false
  if 0 < self.mData.prepareTime then
    self.isColding = true
    self.mSource:performWithDelay(function()
      self.isColding = falses
    end, self.mData.prepareTime)
  end
  self.mTriCount = 0
  self.ColdTime = tonumber(self.mData.cdTime)
  self.maxCount = tonumber(self.mData.skillTimes)
  if self.maxCount == -1 then
    self.maxCount = 9999
  end
  self.Probable = tonumber(self.mData.checkNum1)
  self.Probable1 = tonumber(self.mData.checkNum2)
  self.mParam = self.mData.skillParam
  self.mBuffValue = self.mData.buffValue
  self.mBuffTime = self.mData.buffTime
  self.mBuffPerTime = self.mData.buffPerTime
end

function M:getSomeMonster(number, dis)
  local tmpSource = self.mSource
  local tmpFlag = tmpSource.mFlag
  local tmpList
  local tmpdis = dis or self.mData.skillDistance
  if tmpFlag == 1 then
    tmpList = clone(BMgr.getMonsterList())
    local tmpTower = clone(BMgr.getMonsterTower())
    table.insert(tmpList, tmpTower)
  else
    tmpList = clone(BMgr.getBuddhaList())
    local tmpTower = clone(BMgr.getBuddhaTower())
    table.insert(tmpList, tmpTower)
  end
  if #tmpList == 0 then
    return nil
  end
  local rtnList = {}
  for k, v in pairs(tmpList) do
    local tarX = v:getPositionX()
    while true do
      if tmpFlag == 2 then
        if tarX < tmpSource:getPositionX() or v.mCantAttack then
          break
        end
      elseif tarX > tmpSource:getPositionX() or v.mCantAttack then
        break
      end
      if math.abs(tmpSource:getPositionX() - tarX) > (tmpdis + 300) * Const.Zoom0 then
        break
      end
      table.insert(rtnList, v)
      break
    end
  end
  if tmpFlag == 1 then
    table.sort(rtnList, function(a, b)
      return a:getPositionX() > b:getPositionX()
    end)
  elseif tmpFlag == 2 then
    table.sort(rtnList, function(a, b)
      return a:getPositionX() < b:getPositionX()
    end)
  end
  return {
    unpack(rtnList, 1, number)
  }
end

function M:getSomeAlly(number)
  local tmpSource = self.mSource
  local tmpFlag = tmpSource.mFlag
  local tmpList
  if tmpFlag == 1 or tmpFlag == 10 then
    tmpList = clone(BMgr.getBuddhaList())
  elseif tmpFlag == 2 or tmpFlag == 9 then
    tmpList = clone(BMgr.getMonsterList())
  end
  if #tmpList == 0 then
    return nil
  end
  table.sort(tmpList, function(a, b)
    return a.curHp_ / a.maxHp_ < b.curHp_ / b.maxHp_
  end)
  if number > #tmpList then
    number = #tmpList
  end
  return {
    unpack(tmpList, 1, number)
  }
end

function M:getMonsterByTag(number, tag, dis)
  local tmpSource = self.mSource
  local tmpFlag = tmpSource.mFlag
  local tmpList
  local tmpdis = dis or self.mData.skillDistance
  number = 1
  if tmpFlag == 1 then
    tmpList = clone(BMgr.getMonsterList())
    local tmpTower = clone(BMgr.getMonsterTower())
  else
    tmpList = clone(BMgr.getBuddhaList())
    local tmpTower = clone(BMgr.getBuddhaTower())
  end
  if #tmpList == 0 then
    return nil
  end
  local rtnList = {}
  for _, v in pairs(tmpList) do
    local vx = v:getPositionX()
    while true do
      if tmpdis < math.abs(tmpSource:getPositionX() - vx) then
        break
      end
      if v:getActorType() ~= tag then
        break
      end
      table.insert(rtnList, v)
      break
    end
  end
  if tmpFlag == 1 then
    table.sort(rtnList, function(a, b)
      return a:getPositionX() < b:getPositionX()
    end)
  elseif tmpFlag == 2 then
    table.sort(rtnList, function(a, b)
      return a:getPositionX() > b:getPositionX()
    end)
  end
  if number > #rtnList then
    number = #rtnList
  end
  return {
    unpack(rtnList, 1, number)
  }
end

function M:getAllActor()
  local tmpList1 = clone(BMgr.getBuddhaList())
  local tmpList2 = clone(BMgr.getMonsterList())
  return table.insert(tmpList1, tmpList2)
end

function M:getEnemyTower()
  if self.mSource.mFlag == 1 or self.mSource.mFlag == 10 then
    return BMgr.getMonsterTower()
  elseif self.mSource.mFlag == 2 or self.mSource.mFlag == 9 then
    return BMgr.getBuddhaTower()
  end
end

function M:getAllyTower()
  if self.mSource.mFlag == 1 or self.mSource.mFlag == 10 then
    return BMgr.getBuddhaTower()
  elseif self.mSource.mFlag == 2 or self.mSource.mFlag == 9 then
    return BMgr.getMonsterTower()
  end
end

function M:getNeedTarget()
  local tFunc = {
    ["1"] = function(num)
      return {
        self.mSource
      }
    end,
    ["2"] = function(num)
      return {
        self.mSource.mTarget
      }
    end,
    ["3"] = function(num)
      return self:getSomeAlly(1)
    end,
    ["4"] = function(num)
      return self:getSomeMonster(num)
    end,
    ["5"] = function(num)
      return self:getSomeAlly(num)
    end,
    ["6"] = function(num)
      return self:getSomeAlly(1)
    end,
    ["7"] = function(num)
      return {
        self:getEnemyTower()
      }
    end,
    ["8"] = function(num, tag)
      return self:getMonsterByTag(num, tag)
    end,
    ["9"] = function()
      return self:getAllActor()
    end,
    ["10"] = function(num)
      return {
        self:getAllyTower()
      }
    end
  }
  local param = tostring(self.mData.targetBuff)
  local num = tonumber(self.mData.attTargetMaxNum)
  local tag = self.Probable1
  return tFunc[param](num, tag)
end

function M:chooseSkillType()
  local tFunc = {
    ["1"] = function()
      return handler(self, self.passiveSkill)
    end,
    ["2"] = function()
      return handler(self, self.attackSkill)
    end,
    ["3"] = function()
      return handler(self, self.attackSkill)
    end,
    ["4"] = function()
      return handler(self, self.healSkill)
    end,
    ["5"] = function()
      return handler(self, self.certainHarmSkill)
    end,
    ["6"] = function()
      return handler(self, self.buffSkill)
    end,
    ["8"] = function()
      return handler(self, self.auraSkill)
    end,
    ["9"] = function()
      return handler(self, M["S" .. self.mData.skillId])
    end,
    ["10"] = function()
      return handler(self, self.strengthenSkill)
    end,
    ["11"] = function()
      return handler(self, self.spriteSkill)
    end,
    ["12"] = function()
      return handler(self, self.flashSkill)
    end,
    ["13"] = function()
      return handler(self, self.reliveSkill)
    end,
    ["14"] = function()
      return handler(self, self.areaSkill)
    end,
    ["15"] = function()
      return handler(self, self.summonSkill)
    end,
    ["16"] = function()
      return handler(self, self.mirrorSkill)
    end
  }
  local skillType = tostring(self.mData.attackType)
  return tFunc[skillType]()
end

function M:initFunc()
  self.mFunc = self:chooseSkillType()
end

function M:passiveSkill()
  local target = self.target[1]
  local i, iParam
  if not target.mBUFF[self.mData.skillId] then
    target.mBUFF[self.mData.skillId] = 1
    for i, iParam in pairs(self.mParam) do
      target:setAddABLY(iParam.type, iParam.value)
    end
  end
  return true
end

function M:attackSkill()
  local tmpSource = self.mSource
  local tmpTarget = self.target
  for i, iParam in pairs(self.mParam) do
    tmpSource:setTmpABLY(iParam.type, iParam.value)
  end
  if not self.target then
    return
  end
  for i, iActor in pairs(tmpTarget) do
    if iActor and not iActor.mState ~= "Died" then
      if self.mData.buffID ~= 0 then
        iActor:addBuff(iActor, self.mData.buffID, self.mBuffPerTime, self.mBuffTime, self.mBuffValue)
      end
      local realATK, realType = tmpSource:calculateDamage(tmpSource, iActor)
      iActor:underAttack(tmpSource, realATK, realType)
    end
  end
end

function M:healSkill()
  local tmpSource = self.mSource
  local tmpTarget = self.target
  local healA = display.newFrames("jiaxue%d.png", 1, 8)
  local animation = display.newAnimation(healA, 0.125)
  local sp1 = display.newSprite()
  sp1:setAnchorPoint(cc.p(0.5, 0.5))
  sp1:setPositionY(30)
  sp1:setScale(1)
  tmpSource.mAnimator:addChild(sp1, 50)
  sp1:playAnimationOnce(animation, true)
  local healB = display.newFrames("shouxue%d.png", 1, 6)
  local animation = display.newAnimation(healB, 0.125)
  for i, iActor in pairs(tmpTarget) do
    if iActor and not iActor.mState ~= "Died" then
      local realHeal = self.mParam[1].value
      local sp2 = display.newSprite()
      sp2:setAnchorPoint(cc.p(0.5, 0))
      sp2:setScale(1.5)
      iActor:increaseHP(realHeal)
      iActor.mAnimator:addChild(sp2, 50)
      sp2:playAnimationOnce(animation, true)
    end
  end
  tmpSource.mState = "Idle"
end

function M:buffSkill()
  local tmpTarget = self.target
  for i, iActor in pairs(tmpTarget) do
    if iActor and not iActor.mState ~= "Died" and self.mData.buffID ~= 0 then
      iActor:addBuff(iActor, self.mData.buffID, self.mBuffPerTime, self.mBuffTime, self.mBuffValue)
    end
  end
end

function M:certainHarmSkill()
  local tmpSource = self.mSource
  local tmpTarget = self.target
  for i, iActor in pairs(tmpTarget) do
    if iActor and not iActor.mState ~= "Died" then
      if self.mData.buffID ~= 0 then
        iActor:addBuff(iActor, self.mData.buffID, self.mBuffPerTime, self.mBuffTime, self.mBuffValue)
      end
      local realATK = self.mParam[1].value
      iActor:underAttack(tmpSource, realATK)
    end
  end
end

function M:auraSkill()
  local target = self.mData.targetBuff
  local flag = 1
  if target == 4 then
    flag = 2
  else
    flag = 1
  end
  for i, iParam in pairs(self.mParam) do
    BMgr.setAuraSkillData(flag, iParam.type, iParam.value)
  end
end

function M:strengthenSkill()
  local tmpTarget = self.target
  for i, iActor in pairs(tmpTarget) do
    if iActor and not iActor.mState ~= "Died" then
      for i, iParam in pairs(self.mParam) do
        iActor:setAddABLY(iParam.type, iParam.value)
      end
    end
  end
end

function M:onTrigger()
  self.target = self:getNeedTarget()
  DDLOG(self.mData.skillName)
  if self.target then
    self:mFunc()
    self.mTriCount = self.mTriCount + 1
    if self.ColdTime > 0 then
      self.isColding = true
      self.mSource:performWithDelay(function()
        self.isColding = false
      end, self.ColdTime)
    end
  end
end

function M:spriteSkill()
  if self.mSource.mFlag == 1 or self.mSource.mFlag == 10 then
    for i, iParam in pairs(self.mParam) do
      if iParam.type == 3003 then
        GameData.updateSpirit(iParam.value)
      elseif iParam.type == 3007 then
        GameData.setSpiritLimit(iParam.value)
      end
    end
  end
end

function M:reliveSkill()
  local target = self.mSource
  DDLOG(DYLang.getString("S1486", ""))
  target.mState = "Reliving"
  target.mAnimator:setVisible(false)
  local frames = display.newFrames("lianhua%d.png", 1, 10)
  local animation = display.newAnimation(frames, 0.05)
  local sp = display.newSprite()
  sp:setAnchorPoint(cc.p(0.5, 0))
  sp:setScale(target:getScale() * Const.Zoom0)
  target:addChild(sp)
  sp:playAnimationOnce(animation, true, function()
    target:relive(self.mParam[1].value)
  end)
end

function M:flashSkill()
  local source = self.mSource
  local target = self.target
  if not target or #target < 1 then
    return
  end
  target = target[1]
  DDLOG(DYLang.getString("S1487", ""))
  if source.mFlag == 1 then
    source:setPositionX(target:getPositionX() + 50)
  else
    source:setPositionX(target:getPositionX() - 50)
  end
  if self.mData.buffID ~= 0 then
    source:addBuff(source, self.mData.buffID, self.mBuffPerTime, self.mBuffTime, self.mBuffValue)
  end
end

function M:areaSkill()
  local source = self.mSource
  local target = self.target[1]
  if not target then
    return
  end
  local pos = cc.p(target:getPosition())
  local area = SpecialArea.new(source.mFlag, pos.x, self.mData.buffID, self.mBuffPerTime, self.mBuffTime, self.mBuffValue)
  area:setPosition(cc.p(pos.x, pos.y))
  area:addTo(source:getParent(), 0)
  BMgr.insertArea(area)
end

function M:summonSkill()
  local source = self.mSource
  local target = self.target[1]
  local buddhaId = self.mParam[1].value
  local count = self.mParam[2].value
  for i = 1, count do
    local pos = cc.p(source:getPosition())
    pos.x = pos.x + source.mFlag * math.random(0, 20)
    pos.y = pos.y + math.random(-10, 10)
    if source.mFlag == 1 then
      BMgr.createDemoBuddha(buddhaId, pos):addTo(GameData.BG)
    elseif source.mFlag == 2 then
      BMgr.createSummonMonster(buddhaId, pos):addTo(GameData.BG)
    end
  end
end

function M:mirrorSkill()
  local source = self.mSource
end

function M:checkTrigger(parma, tarType)
  local function tFunc(self, parma, tarType)
    if self.isColding or self.mTriCount >= self.maxCount or self.mSource.canCastSkill == false then
      return false
    end
    local tmpType = self.mTriggerType
    if tmpType == 7 or tmpType == 9 or tmpType == 10 or tmpType == 5 then
      if parma >= self.Probable then
        if self.Probable1 == 0 then
          return true
        elseif tarType and tarType == self.Probable1 then
          return true
        elseif self.mData.buffID == 1004 then
          local c = self.mSource.mTarget.mFlag <= 2 and self.mSource.mTarget.model_.level < self.mParam[1].value
          if not c then
            self.mTriCount = self.mTriCount + 1
          end
          DDLOG(c)
          return c
        else
          return true
        end
      else
        return false
      end
    elseif tmpType == 2 or tmpType == 3 or tmpType == 4 or tmpType == 8 or tmpType == 6 then
      if parma <= self.Probable then
        return true
      else
        return false
      end
    end
  end
  
  local tTrigger = tFunc(self, parma, tarType)
  if tTrigger and self.mData then
    if self.mData.aniIndex > 3 and self.mSource.model_.soundSkillFile then
      DYSoundMgr.playEffect(self.mSource.model_.soundSkillFile[self.mData.aniIndex - 3])
    else
    end
    return true
  else
    return false
  end
end

function M:initData(id, index, skillLv)
  if self.mSource.mFlag == 1 then
    self.mData = DataUtils.getBuddhaSkillModel(id, index)
  else
    self.mData = DataUtils.getMonsterSkillModel(id, skillLv)
  end
end

function M:endSkill()
  local target = self.mSource
  if self.mData.attackType == 3 then
    for i, iParam in pairs(self.mParam) do
      target:setTmpABLY(iParam.type, -iParam.value)
    end
  elseif self.mData.attackType == 8 then
    for i, iParam in pairs(self.mParam) do
      BMgr.setAuraSkillData(target.mFlag, iParam.type, 0)
    end
  end
  return true
end

function M:getDelayTime()
  return tonumber(self.mData.preCD)
end

function M:S203501()
  local tmpTarget = self.mSource.mTarget
  local tmpSource = self.mSource
  local realATK = tmpSource:calculateDamage(tmpSource, tmpTarget)
  tmpTarget:underAttack(tmpSource, realATK)
  self:spriteSkill()
end

function M:S200603()
  local tmpSource = self.mSource
  local tmpTarget = self:getSomeMonster(10, 9999)
  if tmpSource.mFlag == 1 then
    table.removebyvalue(tmpTarget, BMgr.getMonsterTower(), false)
  elseif tmpSource.mFlag == 2 then
    table.removebyvalue(tmpTarget, BMgr.getBuddhaTower(), false)
  end
  tmpSource.mAnimator:changeArmatureStateTo("SKILL")
  if tmpTarget ~= nil then
    for i, iParam in pairs(self.mParam) do
      tmpSource:setTmpABLY(iParam.type, iParam.value)
    end
    for i, iActor in pairs(tmpTarget) do
      if iActor and not iActor.mState ~= "Died" then
        local realATK, realType = tmpSource:calculateDamage(tmpSource, iActor)
        iActor:underAttack(tmpSource, realATK, realType)
      end
    end
    for i, iParam in pairs(self.mParam) do
      tmpSource:setTmpABLY(iParam.type, -iParam.value)
    end
  end
  tmpTarget = self:getSomeAlly(10)
  if tmpTarget ~= nil then
    for i, iActor in pairs(tmpTarget) do
      if iActor and not iActor.mState ~= "Died" and self.mData.buffID ~= "0" then
        iActor:addBuff(iActor, self.mData.buffID, self.mBuffPerTime, self.mBuffTime, self.mBuffValue)
      end
    end
  end
end

return M

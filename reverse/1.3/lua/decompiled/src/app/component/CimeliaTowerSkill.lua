local DYClass = "CimeliaTowerSkill"
local M = {}
local M = class(DYClass)
local math = clone(math)
local initTargetType, initOnCast

function M:ctor()
  self.mExportMethod = {
    "initCimData",
    "castTowerSkill"
  }
  
  function math.random(m, n)
    local rnd = BMgr.RANDOM:random(m, n)
    return rnd
  end
end

function M:initCimData(parm)
  self.mData = DataUtils.getCimeliaSkillModel(parm.skillId)
  self.mFaceTo = parm.faceTo
  self.mFlag = parm.flag
  initTargetType(self, self.mData.target)
  self.onCast = initOnCast(self.mData.attackType, self)
end

local function dispelSkill(self, target)
  if target == nil then
    return
  end
  for _, v in pairs(target) do
    DDLOG(DYLang.getString("S201", ""))
    if #self.mData.buff > 0 then
      for _, sv in pairs(self.mData.buff) do
        if sv.Prob > math.random(0, 99) then
          v:addBuff(v, sv.ID, sv.CheckTime, sv.Time, sv.Value)
        end
      end
    end
  end
end

local function buffSkill(self, target)
  if target == nil then
    return
  end
  for _, v in pairs(target) do
    DDLOG(DYLang.getString("S202", ""))
    if #self.mData.buff > 0 then
      for _, sv in pairs(self.mData.buff) do
        if sv.Prob > math.random(0, 99) then
          v:addBuff(v, sv.ID, sv.CheckTime, sv.Time, sv.Value)
        end
      end
    end
  end
end

local function healSkill(self, target)
  if target == nil then
    return
  end
  for _, v in pairs(target) do
    v:increaseHP(0, self.mData.skillParam[1].value)
    if 0 < #self.mData.buff then
      for _, sv in pairs(self.mData.buff) do
        if sv.Prob > math.random(0, 99) then
          v:addBuff(v, sv.ID, sv.CheckTime, sv.Time, sv.Value)
        end
      end
    end
  end
end

function initOnCast(typeSkill, self)
  local tFunc = {
    [3] = function()
      return healSkill
    end,
    [5] = function()
      return buffSkill
    end,
    [6] = function()
      return dispelSkill
    end,
    [8] = function()
      return handler(self, self[self.mData.name])
    end
  }
  return tFunc[typeSkill]()
end

local function getSomeAlly(flag, number)
  local tmpFlag = flag
  local tmpList
  if tmpFlag == FLAG_TOWER_BUDDHA then
    tmpList = clone(BMgr.getBuddhaList())
  elseif tmpFlag == FLAG_TOWER_MONSTER then
    tmpList = clone(BMgr.getMonsterList())
  end
  if #tmpList == 0 then
    return nil
  end
  table.sort(tmpList, function(a, b)
    return a.curHp_ / a.maxHp_ < b.curHp_ / b.maxHp_
  end)
  if number == -1 then
    number = 15
  end
  if number > #tmpList then
    number = #tmpList
  end
  return {
    unpack(tmpList, 1, number)
  }
end

local function getSomeEnemy(flag, number)
  local tmpFlag = flag
  local tmpList
  if tmpFlag == FLAG_TOWER_BUDDHA then
    tmpList = clone(BMgr.getMonsterList())
  elseif tmpFlag == FLAG_TOWER_MONSTER then
    tmpList = clone(BMgr.getBuddhaList())
  end
  if #tmpList == 0 then
    return nil
  end
  if number == -1 then
    number = 15
  end
  if number > #tmpList then
    number = #tmpList
  end
  return {
    unpack(tmpList, 1, number)
  }
end

function initTargetType(self, tarType)
  if 1 == tarType then
    self.findTarget = getSomeEnemy
  elseif 2 == tarType then
    self.findTarget = getSomeAlly
  end
end

function M:castTowerSkill()
  DDLOG(DYLang.getString("S203", ""), self.mFlag)
  local targets = self.findTarget(self.mFlag, self.mData.attTargetMaxNum)
  DYSoundMgr.playEffect("sounds/cimelia_buffdef.mp3")
  self:onCast(targets)
end

function M:hanyuta()
  DDLOG(DYLang.getString("S204", ""))
  GameData.resetBuddhaCDTime()
  local targets = self.findTarget(self.mFlag, self.mData.attTargetMaxNum)
  dispelSkill(self, targets)
end

return M

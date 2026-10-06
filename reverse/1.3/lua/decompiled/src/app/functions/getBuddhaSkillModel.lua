function DataUtils.getBuddhaSkillModel(skillId, buddhaId, sLevel)
  local buddhaSkillInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_SKILL_INFO, "ID", tostring(skillId))[1]
  
  if not buddhaSkillInfo then
    DDERROR("skill id : %d with error data", tonumber(skillId))
    return
  end
  local buddhaSkillData = {}
  buddhaSkillData.skillId = tonumber(buddhaSkillInfo.ID)
  buddhaSkillData.skillName = buddhaSkillInfo.Name
  buddhaSkillData.skillIcon = buddhaSkillInfo.Icon
  buddhaSkillData.skillDesc = buddhaSkillInfo.Description
  buddhaSkillData.needLevel = tonumber(buddhaSkillInfo.NeedLevel)
  buddhaSkillData.levelStep = tonumber(buddhaSkillInfo.LevelStep)
  buddhaSkillData.maxLevel = tonumber(buddhaSkillInfo.MaxLevel)
  buddhaSkillData.consume = tonumber(buddhaSkillInfo.Consume)
  buddhaSkillData.checkType = tonumber(buddhaSkillInfo.CheckType)
  buddhaSkillData.checkNum1 = tonumber(buddhaSkillInfo.CheckNum1)
  buddhaSkillData.checkNum2 = tonumber(buddhaSkillInfo.CheckNum2)
  buddhaSkillData.skillTimes = tonumber(buddhaSkillInfo.SkillTimes)
  buddhaSkillData.attackType = tonumber(buddhaSkillInfo.AttackType)
  buddhaSkillData.cdTime = tonumber(buddhaSkillInfo.CD)
  buddhaSkillData.prepareTime = tonumber(buddhaSkillInfo.PrepareTime)
  buddhaSkillData.preCD = tonumber(buddhaSkillInfo.Pre_CD)
  buddhaSkillData.targetBuff = tonumber(buddhaSkillInfo.TargetBuff)
  buddhaSkillData.attTargetMaxNum = tonumber(buddhaSkillInfo.AttTargetMaxNum)
  buddhaSkillData.aniIndex = tonumber(buddhaSkillInfo.aniIndex)
  buddhaSkillData.buffList = {}
  local buffId = split(buddhaSkillInfo.BuffID, ";")
  local buffValueBase = split(buddhaSkillInfo.BuffValueBase, ";")
  local buffValueAdd = split(buddhaSkillInfo.BuffValueAdd, ";")
  local buffTimeBase = split(buddhaSkillInfo.BuffTimeBase, ";")
  local buffTimeAdd = split(buddhaSkillInfo.BuffTimeAdd, ";")
  local buffPerTime = split(buddhaSkillInfo.BuffPerTime, ";")
  local buffPerTimeAdd = split(buddhaSkillInfo.BuffPerTimeAdd, ";")
  local skillLevel = 0
  if sLevel then
    skillLevel = tonumber(sLevel)
  elseif buddhaId and CloudData.NPC_INFO[tonumber(buddhaId)] then
    skillLevel = tonumber(CloudData.NPC_INFO[tonumber(buddhaId)].skills[tostring(skillId)] or 0)
  end
  DDLOG("buddhaSkillData.maxLevel : " .. buddhaSkillData.maxLevel)
  DDLOG("skillLevel : " .. skillLevel)
  if skillLevel > buddhaSkillData.maxLevel then
    skillLevel = buddhaSkillData.maxLevel
  end
  buddhaSkillData.skillLevel = skillLevel
  buddhaSkillData.skillParam = {}
  for i = 1, 3 do
    if buddhaSkillInfo["ParamType" .. i] ~= "0" then
      local param = {}
      param.type = tonumber(buddhaSkillInfo["ParamType" .. i])
      param.value = tonumber(buddhaSkillInfo["ParamB" .. i]) + skillLevel * tonumber(buddhaSkillInfo["ParamAdd" .. i])
      table.insert(buddhaSkillData.skillParam, param)
    end
  end
  buddhaSkillData.costNum = math.floor(((8 + skillLevel * buddhaSkillData.consume) ^ 5 / 3000 + 490) / 10) * 10
  local paramB = split(buddhaSkillInfo.DetectionB, ";")
  local paramAdd = split(buddhaSkillInfo.DetectionK, ";")
  buddhaSkillData.effectTable = {}
  buddhaSkillData.effectNextTable = {}
  for i = 1, #paramB do
    local e1 = paramB[i] + skillLevel * paramAdd[i]
    local e2 = e1 + paramAdd[i]
    table.insert(buddhaSkillData.effectTable, e1)
    table.insert(buddhaSkillData.effectNextTable, e2)
  end
  for i = 1, #buffId do
    local tmpBuff = {}
    tmpBuff.buffId = tonumber(buffId[i])
    tmpBuff.buffValue = tonumber(buffValueBase[i]) + skillLevel * tonumber(buffValueAdd[i])
    tmpBuff.buffTime = tonumber(buffTimeBase[i]) + skillLevel * tonumber(buffTimeAdd[i])
    tmpBuff.buffPerTime = tonumber(buffPerTime[i]) + skillLevel * tonumber(buffPerTimeAdd[i])
    table.insert(buddhaSkillData.buffList, tmpBuff)
  end
  buddhaSkillData.buffID = tonumber(buddhaSkillData.buffList[1].buffId)
  buddhaSkillData.buffValue = buddhaSkillData.buffList[1].buffValue
  buddhaSkillData.buffTime = buddhaSkillData.buffList[1].buffTime
  buddhaSkillData.buffPerTime = buddhaSkillData.buffList[1].buffPerTime
  buddhaSkillData.skillDistance = tonumber(buddhaSkillInfo.skillDistance)
  return buddhaSkillData
end

function DataUtils.getAwakeSkillModel(skillId, buddhaId, skillLevel)
  local skillInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_SKILL_INFO, "ID", tostring(skillId))[1]
  if not skillInfo then
    DDERROR("skill id : %d with error data", tonumber(skillId))
    return
  end
  local skillData = {}
  skillData.skillId = tonumber(skillInfo.ID)
  skillData.skillName = skillInfo.Name
  skillData.skillIcon = skillInfo.Icon
  skillData.skillDesc = skillInfo.Description
  skillData.maxLevel = tonumber(skillInfo.MaxLevel)
  local level = skillLevel
  level = level or CloudData.NPC_INFO[tonumber(buddhaId)].arousals[tostring(skillId)].level or 1
  level = tonumber(level)
  if level > skillData.maxLevel then
    level = skillData.maxLevel
  end
  skillData.skillLevel = level
  local temp1 = level - math.floor(skillInfo.MaxLevel / 2)
  local temp2 = 0 < temp1 and temp1 or 0
  skillData.costNum = math.floor((level + temp2) * skillInfo.Consume)
  local paramB = split(skillInfo.DetectionB, ";")
  local paramAdd = split(skillInfo.DetectionK, ";")
  skillData.effectTable = {}
  skillData.effectNextTable = {}
  for i = 1, #paramB do
    local e1 = paramB[i] + level * paramAdd[i]
    local e2 = e1 + paramAdd[i]
    table.insert(skillData.effectTable, e1)
    table.insert(skillData.effectNextTable, e2)
  end
  local awakeInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_AWAKE_INFO, "skillId", tostring(skillId))[1]
  if not awakeInfo then
    DDERROR("awake skill id : %d with error data", tonumber(skillId))
    return
  end
  skillData.quality = tonumber(awakeInfo.quality)
  skillData.skillType = tonumber(awakeInfo.type)
  skillData.priority = tonumber(awakeInfo.order)
  skillData.valuePoints = tonumber(awakeInfo.wuxingdian)
  return skillData
end

function DataUtils.getAwakeSkillBaseData(skillId)
  local skillInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_SKILL_INFO, "ID", tostring(skillId))[1]
  if not skillInfo then
    DDERROR("skill id : %d with error data", tonumber(skillId))
    return
  end
  local skillData = {}
  skillData.skillId = tonumber(skillInfo.ID)
  skillData.skillName = skillInfo.Name
  skillData.skillIcon = skillInfo.Icon
  local awakeInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_AWAKE_INFO, "skillId", tostring(skillId))[1]
  if not awakeInfo then
    DDERROR("awake skill id : %d with error data", tonumber(skillId))
    return
  end
  skillData.quality = tonumber(awakeInfo.quality)
  skillData.skillType = tonumber(awakeInfo.type)
  return skillData
end

function DataUtils.getPropertiesOfSkillAdd(skillId, buddhaId, sLevel)
  local buddhaSkillInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_SKILL_INFO, "ID", tostring(skillId))[1]
  if not buddhaSkillInfo then
    DDERROR("skill id : %d with error data", tonumber(skillId))
    return
  end
  local skillLevel = 0
  if sLevel then
    skillLevel = tonumber(sLevel)
  else
    skillLevel = tonumber(CloudData.NPC_INFO[tonumber(buddhaId)].skills[tostring(skillId)]) or 0
  end
  if skillLevel > tonumber(buddhaSkillInfo.MaxLevel) then
    skillLevel = tonumber(buddhaSkillInfo.MaxLevel)
  end
  local skillType = tonumber(buddhaSkillInfo.CheckType)
  local typeTable1 = {
    life = 0,
    attack = 0,
    phyDef = 0,
    magDef = 0,
    phyDefIgnore = 0,
    magDefIgnore = 0,
    atkSpeed = 0,
    runSpeed = 0,
    hit = 0,
    miss = 0,
    crit = 0,
    decrit = 0,
    critHarm = 0,
    decritHarm = 0,
    resBack = 0,
    resStun = 0,
    resStone = 0,
    resRebel = 0,
    resChange = 0,
    resPalsy = 0,
    resFreeze = 0,
    resBurn = 0,
    resPoison = 0,
    resSilence = 0,
    resAll = 0,
    harmAdd = 0,
    harmReduce = 0
  }
  local typeTable2 = {
    life = 0,
    attack = 0,
    phyDef = 0,
    magDef = 0,
    phyDefIgnore = 0,
    magDefIgnore = 0,
    atkSpeed = 0,
    runSpeed = 0,
    harmAdd = 0,
    harmReduce = 0
  }
  if 1 ~= skillType or 0 == skillLevel then
    return typeTable1, typeTable2
  end
  local tFuncAdd = {
    [1] = function(addNum)
      typeTable1.life = addNum
    end,
    [2] = function(addNum)
      typeTable1.attack = addNum
    end,
    [3] = function(addNum)
      typeTable1.phyDef = addNum
    end,
    [4] = function(addNum)
      typeTable1.magDef = addNum
    end,
    [5] = function(addNum)
      typeTable1.atkSpeed = addNum
    end,
    [10] = function(addNum)
      typeTable1.runSpeed = addNum
    end,
    [11] = function(addNum)
      typeTable1.harmAdd = addNum
    end,
    [13] = function(addNum)
      typeTable1.phyDefIgnore = addNum
    end,
    [15] = function(addNum)
      typeTable1.harmReduce = addNum
    end,
    [22] = function(addNum)
      typeTable1.magDefIgnore = addNum
    end,
    [120] = function(addNum)
      typeTable1.hit = addNum
    end,
    [121] = function(addNum)
      typeTable1.miss = addNum
    end,
    [122] = function(addNum)
      typeTable1.crit = addNum
    end,
    [123] = function(addNum)
      typeTable1.decrit = addNum
    end,
    [126] = function(addNum)
      typeTable1.critHarm = addNum
    end,
    [127] = function(addNum)
      typeTable1.decritHarm = addNum
    end,
    [2001] = function(addNum)
      typeTable1.resBack = addNum
    end,
    [2002] = function(addNum)
      typeTable1.resStun = addNum
    end,
    [2003] = function(addNum)
      typeTable1.resStone = addNum
    end,
    [2004] = function(addNum)
      typeTable1.resRebel = addNum
    end,
    [2005] = function(addNum)
      typeTable1.resChange = addNum
    end,
    [2006] = function(addNum)
      typeTable1.resPalsy = addNum
    end,
    [2007] = function(addNum)
      typeTable1.resFreeze = addNum
    end,
    [2008] = function(addNum)
      typeTable1.resBurn = addNum
    end,
    [2009] = function(addNum)
      typeTable1.resAll = addNum
    end,
    [2010] = function(addNum)
      typeTable1.resPoison = addNum
    end,
    [2018] = function(addNum)
      typeTable1.resSilence = addNum
    end,
    [101] = function(addNum)
      typeTable2.life = addNum
    end,
    [102] = function(addNum)
      typeTable2.attack = addNum
    end,
    [103] = function(addNum)
      typeTable2.phyDef = addNum
    end,
    [104] = function(addNum)
      typeTable2.magDef = addNum
    end,
    [105] = function(addNum)
      typeTable2.atkSpeed = addNum
    end,
    [110] = function(addNum)
      typeTable2.runSpeed = addNum
    end,
    [111] = function(addNum)
      typeTable2.harmAdd = addNum
    end,
    [124] = function(addNum)
      typeTable2.harmReduce = addNum
    end,
    [128] = function(addNum)
      typeTable2.phyDefIgnore = addNum
    end,
    [129] = function(addNum)
      typeTable2.magDefIgnore = addNum
    end
  }
  for i = 1, 3 do
    if buddhaSkillInfo["ParamType" .. i] ~= "0" then
      local typeNum = tonumber(buddhaSkillInfo["ParamType" .. i])
      local addNum = tonumber(buddhaSkillInfo["ParamB" .. i]) + skillLevel * tonumber(buddhaSkillInfo["ParamAdd" .. i])
      tFuncAdd[typeNum](addNum)
    end
  end
  return typeTable1, typeTable2
end

function DataUtils.getSkillCE(skillIdTable, buddhaId, sLevelTable)
  local sum = 0
  for i = 1, #skillIdTable do
    local skillId = skillIdTable[i]
    local buddhaSkillInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_SKILL_INFO, "ID", tostring(skillId))[1]
    if not buddhaSkillInfo then
      DDERROR("buddhaId : %d ===== buddha skill id : %d with error data", tonumber(buddhaId), tonumber(skillId))
    end
    local pow = tonumber(buddhaSkillInfo.Pow)
    local maxLevel = tonumber(buddhaSkillInfo.MaxLevel)
    local skillLevel = 0
    if sLevelTable then
      skillLevel = tonumber(sLevelTable[i])
    else
      skillLevel = tonumber(CloudData.NPC_INFO[tonumber(buddhaId)].skills[tostring(skillId)]) or 0
    end
    if maxLevel < skillLevel then
      skillLevel = maxLevel
    end
    sum = sum + pow * skillLevel
  end
  return math.round(sum)
end

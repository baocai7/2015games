function DataUtils.getMonsterSkillModel(skillId, skillLv)
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
  buddhaSkillData.preCD = tonumber(buddhaSkillInfo.Pre_CD)
  buddhaSkillData.buffID = tonumber(buddhaSkillInfo.BuffID)
  buddhaSkillData.targetBuff = tonumber(buddhaSkillInfo.TargetBuff)
  buddhaSkillData.attTargetMaxNum = tonumber(buddhaSkillInfo.AttTargetMaxNum)
  buddhaSkillData.aniIndex = tonumber(buddhaSkillInfo.aniIndex)
  buddhaSkillData.prepareTime = tonumber(buddhaSkillInfo.PrepareTime)
  buddhaSkillData.buffValue = 0
  buddhaSkillData.buffTime = 0
  buddhaSkillData.buffPerTime = 0
  buddhaSkillData.skillDistance = tonumber(buddhaSkillInfo.skillDistance)
  buddhaSkillData.buffList = {}
  local buffId = split(buddhaSkillInfo.BuffID, ";")
  local buffValueBase = split(buddhaSkillInfo.BuffValueBase, ";")
  local buffValueAdd = split(buddhaSkillInfo.BuffValueAdd, ";")
  local buffTimeBase = split(buddhaSkillInfo.BuffTimeBase, ";")
  local buffTimeAdd = split(buddhaSkillInfo.BuffTimeAdd, ";")
  local buffPerTime = split(buddhaSkillInfo.BuffPerTime, ";")
  local buffPerTimeAdd = split(buddhaSkillInfo.BuffPerTimeAdd, ";")
  local skillLevel = skillLv or 1
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
  return buddhaSkillData
end

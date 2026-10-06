function DataUtils.getCimeliaSkillModel(index)
  local cimeliaSkillInfo
  
  cimeliaSkillInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_SKILL_INFO, "ID", tostring(index))[1]
  local CimeliaSkillData = {}
  CimeliaSkillData.range = tonumber(cimeliaSkillInfo.range)
  CimeliaSkillData.target = tonumber(cimeliaSkillInfo.Target)
  CimeliaSkillData.attackType = tonumber(cimeliaSkillInfo.AttackType)
  CimeliaSkillData.attTargetMaxNum = tonumber(cimeliaSkillInfo.AttTargetMaxNum)
  CimeliaSkillData.name = cimeliaSkillInfo.name
  CimeliaSkillData.description = cimeliaSkillInfo.Description
  CimeliaSkillData.soundFile = tostring(cimeliaSkillInfo.soundFile)
  local buffProb = tonumber(cimeliaSkillInfo.BuffProb)
  local buffID = split(cimeliaSkillInfo.BuffID, ";")
  local buffTime = split(cimeliaSkillInfo.BuffTime, ";")
  local buffValue = split(cimeliaSkillInfo.BuffValue, ";")
  local buffCheckTime = split(cimeliaSkillInfo.BuffCheckTime, ";")
  CimeliaSkillData.skillParam = {}
  for i = 1, 3 do
    local param = {}
    param.type = tonumber(cimeliaSkillInfo["ParamType" .. i]) or 0
    param.value = tonumber(cimeliaSkillInfo["ParamNum" .. i]) or 0
    table.insert(CimeliaSkillData.skillParam, param)
  end
  CimeliaSkillData.buff = {}
  for i = 1, #buffID do
    local buff = {}
    buff.ID = tonumber(buffID[i])
    buff.Prob = tonumber(buffProb)
    buff.Time = tonumber(buffTime[i])
    buff.Value = tonumber(buffValue[i])
    buff.CheckTime = tonumber(buffCheckTime[i])
    table.insert(CimeliaSkillData.buff, buff)
  end
  return CimeliaSkillData
end

function DataUtils.getCimeliaSkillBaseModel(skillId)
  local skillInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_SKILL_INFO, "ID", tostring(skillId))[1]
  if not skillInfo then
    DDERROR("cimelia skill id : %d with error data", tonumber(skillId))
    return
  end
  local skillData = {}
  skillData.skillIcon = skillInfo.icon
  skillData.skillName = skillInfo.SkillName
  skillData.skillDesc = skillInfo.Description
  return skillData
end

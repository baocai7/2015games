local tmpNameList = {
  DYLang.getString("S228", ""),
  DYLang.getString("S229", ""),
  DYLang.getString("S230", ""),
  DYLang.getString("S231", ""),
  DYLang.getString("S232", ""),
  DYLang.getString("S233", "")
}
local tmpSkillDecp = {
  DYLang.getString("S234", ""),
  DYLang.getString("S235", ""),
  DYLang.getString("S236", ""),
  DYLang.getString("S237", ""),
  DYLang.getString("S238", ""),
  ""
}
local tmpSkillNum = {
  {
    0.5,
    1,
    1.5,
    2.5,
    3.5,
    5,
    6.5,
    8,
    10,
    12
  },
  {
    0.5,
    1,
    1.5,
    2,
    3,
    4,
    5,
    6.5,
    8,
    10
  },
  {
    0.5,
    1,
    1.5,
    2.5,
    3.5,
    5,
    6.5,
    8,
    10,
    12
  },
  {
    0.5,
    1,
    1.5,
    2.5,
    3.5,
    5,
    6.5,
    8,
    10,
    12
  },
  {
    1,
    2,
    3,
    4,
    5.5,
    7,
    9,
    11,
    13,
    16
  },
  {
    1,
    2,
    3,
    4,
    5.5,
    7,
    9,
    11,
    13,
    16
  }
}
local tmpAnimatureList = {
  "linglu1",
  "qinglong1",
  "penglaigui1",
  "nianshou1",
  "yelong1",
  "chiyou1"
}

function DataUtils.getUnionBossData(id)
  local bossId = tonumber(id)
  local bossData = {}
  if bossId > #tmpNameList then
    DDERROR("Union bossId :%d with error data", bossId)
    return bossData
  end
  CloudData.UNION_BOSS_LEVEL = CloudData.UNION_BOSS_LEVEL or {}
  local bossLevel = CloudData.UNION_BOSS_LEVEL[tostring(bossId)] or 0
  if bossLevel > #tmpSkillNum[1] then
    DDERROR("Union bossLevel :%d with error data", bossLevel)
    return bossData
  end
  bossData.bossName = tmpNameList[bossId]
  bossData.skillDesc = tmpSkillDecp[bossId]
  bossData.bossLevel = bossLevel
  bossData.skillAddNum = tmpSkillNum[bossId][bossLevel] or 0
  bossData.animature = tmpAnimatureList[bossId]
  return bossData
end

function DataUtils.getUnionBossModel(id, level)
  DDLOG(DYLang.getString("S239", "") .. id .. DYLang.getString("S240", "") .. level)
  local bossId = tostring(id)
  local bossLevel = level or CloudData.UNION_BOSS_LEVEL[tostring(bossId)] or 1
  local monsterId = 400000 + id * 100 + bossLevel
  local model = DataUtils.getMonsterModel(monsterId)
  return model
end

function DataUtils.getUnionBossSkillAdd(bossId, bossInfo)
  local tempNum = 0
  if 5 == GameManager.MODE then
    return tempNum
  end
  local bossId = bossId
  local bossLevel = 0
  if bossInfo then
    bossLevel = bossInfo.boss_level[tostring(bossId)] or 0
  else
    CloudData.UNION_BOSS_LEVEL = CloudData.UNION_BOSS_LEVEL or {}
    bossLevel = CloudData.UNION_BOSS_LEVEL[tostring(bossId)] or 0
  end
  if not bossLevel or bossLevel <= 0 then
    return tempNum
  end
  if tonumber(bossId) > #tmpNameList then
    DDERROR("Union bossId :%d with error data", bossId)
    return tempNum
  end
  if bossLevel > #tmpSkillNum[1] then
    DDERROR("Union bossLevel :%d with error data", bossLevel)
    return tempNum
  end
  tempNum = tmpSkillNum[tonumber(bossId)][bossLevel]
  return tempNum
end

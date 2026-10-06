function DataUtils.getSpiritModel(spiritLevel)
  local spiritInfo = DYCommon.getDataByTag(DataRetainer.SPIRIT_INFO, "level", tostring(spiritLevel))[1]
  
  if not spiritInfo then
    DDERROR("spirit level : %d with error data", tonumber(spiritLevel))
    return
  end
  local spiritData = {}
  spiritData.maxLevel = #DataRetainer.SPIRIT_INFO - 1
  spiritData.limitNum = tonumber(spiritInfo.limitNum)
  spiritData.costNum = tonumber(spiritInfo.costNum)
  spiritData.growSpeed = tonumber(spiritInfo.growSpeed) / 10
  if GameData.CIMELIA_DEF then
    spiritData.limitNum = spiritData.limitNum + GameData.CIMELIA_DEF.spiritLimit
    spiritData.growSpeed = spiritData.growSpeed + GameData.CIMELIA_DEF.spiritSpeed / 10
  end
  local treasureSpeedAdd = DataUtils.getTreasureIncRate(2)
  local treasureLimitAdd = DataUtils.getTreasureIncRate(3)
  local bossSpeedAdd = DataUtils.getUnionBossSkillAdd(1)
  spiritData.limitNum = spiritData.limitNum * (1 + treasureLimitAdd / 100)
  spiritData.growSpeed = spiritData.growSpeed * (1 + (treasureSpeedAdd + bossSpeedAdd) / 100)
  return spiritData
end

function DataUtils.getSpiritModelForAI(spiritLevel)
  local spiritInfo = DYCommon.getDataByTag(DataRetainer.SPIRIT_INFO, "level", tostring(spiritLevel))[1]
  if not spiritInfo then
    DDERROR("spirit level : %d with error data", tonumber(spiritLevel))
    return
  end
  local spiritData = {}
  spiritData.maxLevel = #DataRetainer.SPIRIT_INFO - 1
  spiritData.limitNum = tonumber(spiritInfo.limitNum)
  spiritData.costNum = tonumber(spiritInfo.costNum)
  spiritData.growSpeed = tonumber(spiritInfo.growSpeed) / 10
  if GameData.CIMELIA_DEF_ENEMY then
    spiritData.limitNum = spiritData.limitNum + GameData.CIMELIA_DEF_ENEMY.spiritLimit
    spiritData.growSpeed = spiritData.growSpeed + GameData.CIMELIA_DEF_ENEMY.spiritSpeed / 10
  end
  local treasureSpeedAdd = DataUtils.getTreasureIncRate(2, CloudData.ENEMY_TREASURE_INFO)
  local treasureLimitAdd = DataUtils.getTreasureIncRate(3, CloudData.ENEMY_TREASURE_INFO)
  local bossSpeedAdd = DataUtils.getUnionBossSkillAdd(1, CloudData.ENEMY_UNION_BOSS)
  spiritData.limitNum = spiritData.limitNum * (1 + treasureLimitAdd / 100)
  spiritData.growSpeed = spiritData.growSpeed * (1 + (treasureSpeedAdd + bossSpeedAdd) / 100)
  return spiritData
end

function DataUtils.getMaxSP(level)
  local spInfo = DYCommon.getDataByTag(DataRetainer.PVP_SPIRIT_INFO, "lv", tostring(level))[1]
  if not spInfo then
    DDERROR("spirit level : %d with error data", tonumber(level))
    return 0
  end
  return tonumber(spInfo.spirit)
end

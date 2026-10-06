function DataUtils.getStageModel(mode, stageNum)
  local stageInfo
  
  local stageData = {}
  if 0 == mode or 1 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.STAGE_INFO, "stageNum", tostring(stageNum))[1]
  elseif 2 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_STAGE_INFO, "id", tostring(stageNum))[1]
  elseif 3 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.PURGATORY_STAGE_INFO, "id", tostring(stageNum))[1]
  elseif 4 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TRAVEL_STAGE_INFO, "id", tostring(stageNum))[1]
  elseif 7 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TOWER_STAGE_INFO, "stageNum", tostring(stageNum))[1]
  end
  if not stageInfo then
    DDTRACE("DataUtils.getStageModel() : ", string.format(" stage ID : %s with error data", checkstring(stageId)))
    return stageData
  end
  if 0 == mode or 1 == mode then
    stageData.stageId = tonumber(stageInfo.id)
    stageData.stageNum = tonumber(stageInfo.stageNum)
    stageData.stageType = tonumber(stageInfo.type)
    stageData.energyCost = tonumber(stageInfo.energyCost)
    stageData.essenceAward = tonumber(stageInfo.essenceAward)
    stageData.awardIdList = split(stageInfo.awardIdList, ";")
    stageData.monsterId = tonumber(stageInfo.monsterId)
    stageData.chapterId = tonumber(stageInfo.chapterId)
    stageData.challengeTimes = tonumber(stageInfo.challengeTimes)
    stageData.gameMode = tonumber(stageInfo.gameMode)
  elseif 3 == mode then
    stageData.stageId = tonumber(stageInfo.id)
    stageData.monsterId = tonumber(stageInfo.monsterId)
    stageData.awardIdList = split(stageInfo.awardIdList, ";")
  elseif 4 == mode then
    stageData.stageId = tonumber(stageInfo.id)
    stageData.stageType = tonumber(stageInfo.type)
    stageData.stageIcon = tonumber(stageInfo.icon)
    stageData.stageDegree = tonumber(stageInfo.degree)
    stageData.requireLv = tonumber(stageInfo.requireLv)
    stageData.monsterId = tonumber(stageInfo.monsterId)
    stageData.awardIdList = split(stageInfo.awardIdList, ";")
  elseif 7 == mode then
    stageData.stageId = tonumber(stageInfo.id)
    stageData.stageNum = tonumber(stageInfo.stageNum)
    stageData.desc = checkstring(stageInfo.desc)
    stageData.name = checkstring(stageInfo.name)
    stageData.awardIdList = split(stageInfo.awardIdList, ";")
    stageData.awardNumList = split(stageInfo.awardNum, ";")
    stageData.recommendLv = checknumber(stageInfo.recommendLevel)
  end
  return stageData
end

function DataUtils.getMonsterIdInStage(mode, stageId)
  local stageInfo
  local monsterIdTable = {}
  if 0 == mode or 1 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.STAGE_INFO, "id", tostring(stageId))[1]
  elseif 2 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 3 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.PURGATORY_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 4 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TRAVEL_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 7 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TOWER_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 10 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.AGGRESS_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 5 <= mode then
    stageInfo = {}
  end
  if not stageInfo then
    DDTRACE("DataUtils.getMonsterIdInStage() : ", string.format(" stage ID : %s with error data", checkstring(stageId)))
    return monsterIdTable
  end
  if 2 == mode then
    local AIIds = split(stageInfo.AIId, ";")
    for i = 1, #AIIds do
      local AIId = tonumber(AIIds[i])
      local AIInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_AI, "iD", tostring(AIId))[1]
      local strategyIdTable = {}
      local tb1 = split(AIInfo.normalTroops, ";")
      local tb2 = split(AIInfo.cycleTroops, ";")
      table.insertto(tb1, tb2)
      strategyIdTable = table.unique(tb1)
      for k, v in pairs(strategyIdTable) do
        if tonumber(v) ~= 0 then
          local strategyInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_STRATEGY, "strategyID", tostring(v))[1]
          if not strategyInfo then
            DDERROR("strategy id : %d with error data", tonumber(v))
          end
          local waveNum = strategyInfo.waves
          for i = 1, waveNum do
            local monsterIds = split(strategyInfo["monsterId" .. i], ";")
            for k, v in pairs(monsterIds) do
              table.insert(monsterIdTable, v)
            end
          end
        end
      end
    end
    monsterIdTable = table.unique(monsterIdTable)
  elseif 5 <= mode and mode ~= 7 and mode ~= 10 then
    monsterIdTable = stageInfo
  else
    local AIId = tonumber(stageInfo.AIId)
    local AIInfo = DYCommon.getDataByTag(DataRetainer.AI_INFO, "iD", tostring(AIId))[1]
    dump(AIInfo, "AIInfo : ")
    local strategyIdTable = {}
    local tb1 = split(AIInfo.normalTroops, ";")
    local tb2 = split(AIInfo.cycleTroops, ";")
    local tb3 = {}
    local actionType = split(AIInfo.actionType, ";")
    local actionID = split(AIInfo.actionID, ";")
    for k, v in pairs(actionType) do
      if 1 == tonumber(v) then
        table.insert(tb3, actionID[k])
      end
    end
    table.insertto(tb1, tb2)
    table.insertto(tb1, tb3)
    strategyIdTable = table.unique(tb1)
    for k, v in pairs(strategyIdTable) do
      if tonumber(v) ~= 0 then
        local strategyInfo = DYCommon.getDataByTag(DataRetainer.STRATEGY_INFO, "strategyID", tostring(v))[1]
        if not strategyInfo then
          DDERROR("strategy id : %d with error data", tonumber(v))
        end
        local waveNum = strategyInfo.waves
        for i = 1, waveNum do
          local monsterIds = split(strategyInfo["monsterId" .. i], ";")
          for k, v in pairs(monsterIds) do
            table.insert(monsterIdTable, v)
          end
        end
      end
    end
    monsterIdTable = table.unique(monsterIdTable)
  end
  return monsterIdTable
end

function DataUtils.getMonsterTowerInfo(mode, stageId)
  local stageInfo
  local towerData = {}
  if 0 == mode or 1 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.STAGE_INFO, "id", tostring(stageId))[1]
  elseif 2 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 3 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.PURGATORY_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 4 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TRAVEL_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 7 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TOWER_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 10 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.AGGRESS_STAGE_INFO, "id", tostring(stageId))[1]
  end
  if not stageInfo then
    DDTRACE("DataUtils.getMonsterTowerInfo() : ", string.format(" stage ID : %s with error data", checkstring(stageId)))
    return towerData
  end
  towerData.towerType = tonumber(stageInfo.towerType)
  towerData.towerHP = tonumber(stageInfo.towerHP)
  towerData.phyAtk = tonumber(stageInfo.phyAtk)
  towerData.magAtk = tonumber(stageInfo.magAtk)
  towerData.maxMonsterNum = tonumber(stageInfo.maxNum)
  towerData.element = tonumber(stageInfo.element) or 1
  towerData.propGold = tonumber(stageInfo.gold) or 0
  towerData.propWood = tonumber(stageInfo.wood) or 0
  towerData.propWater = tonumber(stageInfo.water) or 0
  towerData.propFire = tonumber(stageInfo.fire) or 0
  towerData.propEarth = tonumber(stageInfo.earth) or 0
  towerData.propAllElements = 0
  return towerData
end

function DataUtils.getStageInfo(mode, stageId)
  local stageInfo
  local stageData = {}
  if 0 == mode or 1 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.STAGE_INFO, "id", tostring(stageId))[1]
  elseif 2 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 3 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.PURGATORY_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 4 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TRAVEL_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 7 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TOWER_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 10 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.AGGRESS_STAGE_INFO, "id", tostring(stageId))[1]
  end
  if not stageInfo then
    DDTRACE("DataUtils.getStageInfo() : ", string.format(" stage ID : %s with error data", checkstring(stageId)))
    return stageData
  end
  stageData.towerDistance = tonumber(stageInfo.distance)
  stageData.cleanTime = tonumber(stageInfo.cleanTime)
  stageData.maxNum = tonumber(stageInfo.maxNum)
  if mode < 2 then
    stageData.gameType = tonumber(stageInfo.gameMode)
    stageData.intervalTime = tonumber(stageInfo.grooveModeInterval)
    stageData.starTime = split(stageInfo.starTime, ";")
  end
  if 3 == mode or 10 == mode then
    stageData.bossId = tonumber(stageInfo.monsterId)
  end
  return stageData
end

function DataUtils.getStageAIData(mode, stageId)
  local stageInfo
  local AIData = {}
  if 0 == mode or 1 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.STAGE_INFO, "id", tostring(stageId))[1]
  elseif 2 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 3 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.PURGATORY_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 4 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TRAVEL_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 7 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TOWER_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 10 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.AGGRESS_STAGE_INFO, "id", tostring(stageId))[1]
  end
  if not stageInfo then
    DDTRACE("DataUtils.getStageAIData() : ", string.format(" stage ID : %s with error data", checkstring(stageId)))
    return AIData
  end
  if 2 ~= mode then
    local AIId = tonumber(stageInfo.AIId)
    local AIInfo = DYCommon.getDataByTag(DataRetainer.AI_INFO, "iD", tostring(AIId))[1]
    AIData.normalId = split(AIInfo.normalTroops, ";")
    AIData.cycleId = split(AIInfo.cycleTroops, ";")
    AIData.actionId = split(AIInfo.actionID, ";")
    AIData.checkType = split(AIInfo.checkType, ";")
    AIData.checkNum = split(AIInfo.checkNum, ";")
    AIData.actionType = split(AIInfo.actionType, ";")
    AIData.actionTimes = split(AIInfo.actionTimes, ";")
    AIData.isWarning = split(AIInfo.isWarning, ";")
  else
    AIData.normalId = {0}
    AIData.cycleId = {0}
    AIData.actionId = split(stageInfo.actionId, ";")
    AIData.checkType = split(stageInfo.checkType, ";")
    AIData.checkNum = split(stageInfo.checkNum, ";")
    AIData.actionType = split(stageInfo.actionType, ";")
    AIData.actionTimes = {1}
    AIData.isWarning = {0}
  end
  return AIData
end

function DataUtils.getStrategyData(mode, strategyId)
  if tonumber(strategyId) == 0 then
    return
  end
  local strategyInfo
  if 2 ~= mode then
    strategyInfo = DYCommon.getDataByTag(DataRetainer.STRATEGY_INFO, "strategyID", tostring(strategyId))[1]
  else
    strategyInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_STRATEGY, "strategyID", tostring(strategyId))[1]
  end
  if not strategyInfo then
    DDTRACE("DataUtils.getStrategyData() : ", string.format(" strategy ID : %s with error data", checkstring(strategyId)))
    return
  end
  local strategyData = {}
  strategyData.waves = tonumber(strategyInfo.waves)
  strategyData.strategy = {}
  for i = 1, strategyData.waves do
    local tb = {}
    tb.readyTime = tonumber(strategyInfo["readyTime" .. i])
    tb.monsterIds = split(strategyInfo["monsterId" .. i], ";")
    tb.monsterNum = split(strategyInfo["monsterNum" .. i], ";")
    table.insert(strategyData.strategy, tb)
  end
  return strategyData
end

function DataUtils.getMonsterCimeliaSkill(mode, stageId)
  local stageInfo
  if 0 == mode or 1 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.STAGE_INFO, "id", tostring(stageId))[1]
  elseif 3 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.PURGATORY_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 4 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TRAVEL_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 7 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.TOWER_STAGE_INFO, "id", tostring(stageId))[1]
  elseif 10 == mode then
    stageInfo = DYCommon.getDataByTag(DataRetainer.AGGRESS_STAGE_INFO, "id", tostring(stageId))[1]
  end
  if not stageInfo then
    DDERROR("stage ID : %d with error data", tonumber(stageId))
    return
  end
  local AIId = tonumber(stageInfo.AIId)
  local AIInfo = DYCommon.getDataByTag(DataRetainer.AI_INFO, "iD", tostring(AIId))[1]
  local actionTypes = split(AIInfo.actionType, ";")
  local actionIds = split(AIInfo.actionID, ";")
  local skillIds = {}
  for i = 1, #actionTypes do
    local idx = tonumber(actionTypes[i])
    if 3 == idx then
      local skillId = tonumber(actionIds[i])
      table.insert(skillIds, skillId)
    end
  end
  return skillIds
end

function DataUtils.getInfiniteWaveCount(stageId)
  local stageInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_STAGE_INFO, "id", tostring(stageId))[1]
  if not stageInfo then
    DDERROR("stage ID : %d with error data", tonumber(stageId))
    return
  end
  local AIIds = split(stageInfo.AIId, ";")
  local countNum = #AIIds
  return countNum
end

function DataUtils.getMonsterIdsInWave(stageId, waveId)
  local stageInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_STAGE_INFO, "id", tostring(stageId))[1]
  if not stageInfo then
    DDERROR("stage ID : %d with error data", tonumber(stageId))
    return
  end
  local AIIds = split(stageInfo.AIId, ";")
  local AIId = tonumber(AIIds[waveId])
  local AIInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_AI, "iD", tostring(AIId))[1]
  if not AIInfo then
    DDERROR("AIInfo ID : %d with error data", tonumber(AIId))
    return
  end
  local strategyIdTable = {}
  local tb1 = split(AIInfo.normalTroops, ";")
  local tb2 = split(AIInfo.cycleTroops, ";")
  table.insertto(tb1, tb2)
  strategyIdTable = table.unique(tb1)
  local monsterIdTable = {}
  for k, v in pairs(strategyIdTable) do
    if tonumber(v) ~= 0 then
      local strategyInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_STRATEGY, "strategyID", tostring(v))[1]
      if not strategyInfo then
        DDERROR("strategy id : %d with error data", tonumber(v))
      end
      local waveNum = strategyInfo.waves
      for i = 1, waveNum do
        local monsterIds = split(strategyInfo["monsterId" .. i], ";")
        for k, v in pairs(monsterIds) do
          table.insert(monsterIdTable, v)
        end
      end
    end
  end
  monsterIdTable = table.unique(monsterIdTable)
  monsterIdTable = table.toarray(monsterIdTable)
  return monsterIdTable
end

function DataUtils.getInfiniteWaveData(stageId, waveId)
  local stageInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_STAGE_INFO, "id", tostring(stageId))[1]
  if not stageInfo then
    DDERROR("stage ID : %d with error data", tonumber(stageId))
    return
  end
  local AIIds = split(stageInfo.AIId, ";")
  local AIId = AIIds[waveId]
  local AIInfo = DYCommon.getDataByTag(DataRetainer.INFINITE_AI, "iD", tostring(AIId))[1]
  local AIData = {}
  AIData.normalIds = split(AIInfo.normalTroops, ";")
  AIData.cycleIds = split(AIInfo.cycleTroops, ";")
  AIData.waveTime = tonumber(AIInfo.time)
  return AIData
end

local function getStarSum(info, index)
  local sum = 0
  if not info or not index then
    return sum
  end
  local stage = 10000 + (index - 1) * 10
  for i = stage + 1, stage + 10 do
    local star = tonumber(info[tostring(i)]) or 0
    sum = sum + star
  end
  return sum
end

local function getBoxRequireStar(chapter, index)
  local info = DYCommon.getDataByTag(DataRetainer.MAIN_CHAPTER_INFO, "id", tostring(chapter))[1]
  if not info then
    DDERROR("chapterInfo index : %d with error data", tonumber(chapter))
    return 30
  end
  local stars = tonumber(info["starCount" .. index])
  return stars
end

function DataUtils.newStageBox(info)
  local eliteInfo = info.elite or {}
  for k, v in pairs(eliteInfo) do
    local chapter = string.sub(k, 22)
    if tonumber(v) == 0 and CloudData.ELITE_STAGE_PROGRESS >= tonumber(chapter) * 4 then
      return true
    end
  end
  local mainInfo = info.main
  if not mainInfo then
    return false
  end
  local chapterInfo = mainInfo.chapterInfo or {}
  for k, v in pairs(chapterInfo) do
    for i = 1, 3 do
      local boxState = tonumber(v[tostring(i)]) or 0
      local starNum = getStarSum(mainInfo.stageInfo, tonumber(k))
      local requireStar = getBoxRequireStar(k, i)
      if boxState == 0 and starNum >= requireStar then
        return true
      end
    end
  end
  return false
end

function DataUtils.stageMainBoxInfo(info)
  local boxTable = {}
  local mainInfo = info.main
  if not mainInfo then
    return boxTable
  end
  local chapterInfo = mainInfo.chapterInfo or {}
  for k, v in pairs(chapterInfo) do
    local sum = 0
    for i = 1, 3 do
      local boxState = tonumber(v[tostring(i)]) or 0
      local starNum = getStarSum(mainInfo.stageInfo, tonumber(k))
      local requireStar = getBoxRequireStar(k, i)
      if boxState == 0 and starNum >= requireStar then
        sum = sum + 1
      end
    end
    if 0 < sum then
      boxTable[tostring(k)] = sum
    end
  end
  return boxTable
end

function DataUtils.stageEliteBoxInfo(info)
  local boxTable = {}
  local eliteInfo = info.elite or {}
  for k, v in pairs(eliteInfo) do
    local chapter = string.sub(k, 22)
    if tonumber(v) == 0 and CloudData.ELITE_STAGE_PROGRESS >= tonumber(chapter) * 4 then
      boxTable[tostring(chapter)] = 1
    end
  end
  return boxTable
end

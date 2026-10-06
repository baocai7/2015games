function DataUtils.getEquipmentModel(eid)
  local info = DYCommon.getDataByTag(DataRetainer.EQUIPMENT_INFO, "id", tostring(eid))[1]
  
  if not info then
    DDTRACE("DataUtils.getEquipmentModel() : ", string.format(" equipment id : %s with error data", checkstring(eid)))
    return {}
  end
  local equipmentData = {}
  equipmentData.id = tonumber(info.id)
  equipmentData.name = info.name
  equipmentData.icon = info.icon
  equipmentData.tag = tonumber(info.tag)
  equipmentData.spirit = tonumber(info.spirit)
  equipmentData.quality = tonumber(info.quality)
  equipmentData.grade = tonumber(info.grade)
  equipmentData.maxStar = tonumber(info.starMax)
  equipmentData.suitId = tonumber(info.suit)
  equipmentData.ironValue = tonumber(info.ironValue)
  equipmentData.uniqueId = tonumber(info.buddhaId)
  equipmentData.skillId = tonumber(info.skillId)
  equipmentData.relicsParam = split(info.shenbingParam, ";")
  equipmentData.relatedIds = split(info.relatedIds, ";")
  equipmentData.growNums = {
    tonumber(info.param1Grow),
    tonumber(info.param2Grow)
  }
  equipmentData.levelPropertyIds = {}
  equipmentData.levelPropertyNums = {}
  for i = 1, 9 do
    equipmentData.levelPropertyIds[i] = tonumber(info["lvPropType" .. i])
    equipmentData.levelPropertyNums[i] = tonumber(info["lvPropNum" .. i])
  end
  equipmentData.canQuenching = 1
  local quenchingIds = split(info.quenchingIds, ";")
  if 1 == #quenchingIds and -1 == tonumber(quenchingIds[1]) then
    equipmentData.canQuenching = 0
  end
  return equipmentData
end

function DataUtils.getRelicsSkillModel(skillId)
  local info = DYCommon.getDataByTag(DataRetainer.RELICS_SKILL_INFO, "id", tostring(skillId))[1]
  if not info then
    DDTRACE("DataUtils.getRelicsSkillModel() : ", string.format(" relics Skill id : %s with error data", checkstring(skillId)))
    return {}
  end
  local data = {
    name = info.name,
    icon = info.icon,
    intro = info.description,
    preCD = tonumber(info.preCD),
    endCD = tonumber(info.endCD),
    attackType = tonumber(info.attackType),
    skillTimes = tonumber(info.skillTimes),
    cdTime = tonumber(info.cd),
    prepareTime = tonumber(info.prepareTime),
    durationTime = tonumber(info.duration),
    paramType1 = tonumber(info.paramType1),
    paramNum1 = tonumber(info.paramB1),
    targetBuff = tonumber(info.targetBuff)
  }
  return data
end

function DataUtils.getEquipmentUpgradeCost(level, quality)
  if quality == 7 then
    quality = 5
  end
  if quality == 8 then
    quality = 6
  end
  if 0 == level or 160 < level then
    return 0
  end
  local info = DYCommon.getDataByTagEx(DataRetainer.EQUIPMENT_EXP_INFO, {"id", "quality"}, {
    tostring(level),
    tostring(quality)
  })[1]
  if not info then
    DDTRACE("DataUtils.getEquipmentUpgradeCost() : ", string.format(" level : %s, quality : %s, with error data", checkstring(level), checkstring(quality)))
    return {}
  end
  local exp = tonumber(info.iron)
  return exp
end

function DataUtils.getEquipmentCountCostToLevel(level, quality)
  if quality == 7 then
    quality = 5
  end
  if quality == 8 then
    quality = 6
  end
  if 0 == level or 160 < level then
    return 0
  end
  local info = DYCommon.getDataByTagEx(DataRetainer.EQUIPMENT_EXP_INFO, {"id", "quality"}, {
    tostring(level),
    tostring(quality)
  })[1]
  if not info then
    DDTRACE("DataUtils.getEquipmentUpgradeCost() : ", string.format(" level : %s, quality : %s, with error data", checkstring(level), checkstring(quality)))
    return {}
  end
  local expSum = tonumber(info.ironSum)
  return expSum
end

function DataUtils.getEquipmentUpstarCost(starLevel)
  local info = DYCommon.getDataByTag(DataRetainer.EQUIPMENT_UPSTAR_COST, "id", tostring(starLevel))[1]
  if not info then
    DDTRACE("DataUtils.getEquipmentUpstarCost() : ", string.format(" starLevel : %s, with error data", checkstring(starLevel)))
    return {}
  end
  local data = {}
  data.level = tonumber(info.level)
  data.costNums = {
    tonumber(info.dan),
    tonumber(info.extra)
  }
  return data
end

function DataUtils.getEquipmentPropIds(eid)
  local info = DYCommon.getDataByTag(DataRetainer.EQUIPMENT_INFO, "id", tostring(eid))[1]
  if not info then
    DDTRACE("DataUtils.getEquipmentModel() : ", string.format(" equipment id : %s with error data", checkstring(eid)))
    return {}
  end
  local range1 = tonumber(info.param1Min) .. "~" .. tonumber(info.param1Max)
  local range2 = tonumber(info.param2Min) .. "~" .. tonumber(info.param2Max)
  local propIds = {
    tonumber(info.param1Type),
    tonumber(info.param2Type)
  }
  local propRanges = {range1, range2}
  local bornIds = split(info.bornRandom, ";")
  local propDatas = {}
  for i = 1, #bornIds do
    local propData = DataUtils.getEquipmentPropsData(bornIds[i])
    if propData.id > 10 and propData.id < 21 then
      propData.minNum = string.format("%d%%", propData.minNum)
      propData.maxNum = string.format("%d%%", propData.maxNum)
    end
    local range = propData.minNum .. "~" .. propData.maxNum
    table.insert(propIds, propData.id)
    table.insert(propRanges, range)
  end
  return propIds, propRanges
end

function DataUtils.getEquipmentPropsData(propId)
  local info = DYCommon.getDataByTag(DataRetainer.EQUIPMENT_PROP_INFO, "id", tostring(propId))[1]
  if not info then
    DDTRACE("DataUtils.getEquipmentPropsData() : ", string.format(" propId : %s, with error data", checkstring(propId)))
    return {}
  end
  local data = {
    id = tonumber(info.type),
    minNum = tonumber(info.min),
    maxNum = tonumber(info.max),
    quality = tonumber(info.quality)
  }
  return data
end

function DataUtils.getEquipmentSuitData(suitId)
  local info = DYCommon.getDataByTag(DataRetainer.EQUIPMENT_SUIT_INFO, "id", tostring(suitId))[1]
  if not info then
    DDTRACE("DataUtils.getEquipmentSuitData() : ", string.format(" equipment suitId : %s with error data", checkstring(suitId)))
    return {}
  end
  local data = {
    name = info.name,
    props = {}
  }
  for i = 1, 4 do
    local param = "number" .. i
    local t = split(info[param], ";")
    if 1 < #t then
      local prop = {
        count = i,
        id = tonumber(t[1]),
        num = tonumber(t[2])
      }
      table.insert(data.props, prop)
    end
  end
  return data
end

function DataUtils.getEquipmentSuitAdd(equipList, npcEquipments)
  local data = {
    life = 0,
    attack = 0,
    phyDef = 0,
    magDef = 0,
    gold = 0,
    wood = 0,
    water = 0,
    fire = 0,
    earth = 0,
    allElements = 0,
    critRate = 0,
    decritRate = 0,
    critHarmRate = 0,
    decritHarmRate = 0,
    hit = 0,
    miss = 0,
    harmReduce = 0
  }
  local suitStatus = {}
  
  local function checkSuitStatus(eid)
    local eData
    if npcEquipments then
      eData = npcEquipments[eid]
    else
      eData = CloudData.EQUIPMENT_INFO[eid]
    end
    if not eData then
      return
    end
    local id = tostring(eData.suit)
    if "-1" == id then
      return
    end
    if suitStatus[id] then
      suitStatus[id] = suitStatus[id] + 1
    else
      suitStatus[id] = 1
    end
  end
  
  for i = 1, #equipList do
    checkSuitStatus(tostring(equipList[i]))
  end
  local tFunc = {
    [1] = function(param)
      data.life = data.life + param
    end,
    [2] = function(param)
      data.attack = data.attack + param
    end,
    [3] = function(param)
      data.phyDef = data.phyDef + param
    end,
    [4] = function(param)
      data.magDef = data.magDef + param
    end,
    [5] = function(param)
      data.gold = data.gold + param
    end,
    [6] = function(param)
      data.wood = data.wood + param
    end,
    [7] = function(param)
      data.water = data.water + param
    end,
    [8] = function(param)
      data.fire = data.fire + param
    end,
    [9] = function(param)
      data.earth = data.earth + param
    end,
    [10] = function(param)
      data.allElements = data.allElements + param
    end,
    [11] = function(param)
      lifeRate = lifeRate + param
    end,
    [12] = function(param)
      attackRate = attackRate + param
    end,
    [13] = function(param)
      phyDefRate = phyDefRate + param
    end,
    [14] = function(param)
      magDefRate = magDefRate + param
    end,
    [15] = function(param)
      data.critRate = data.critRate + param
    end,
    [16] = function(param)
      data.decritRate = data.decritRate + param
    end,
    [17] = function(param)
      data.critHarmRate = data.critHarmRate + param
    end,
    [18] = function(param)
      data.decritHarmRate = data.decritHarmRate + param
    end,
    [19] = function(param)
      data.hit = data.hit + param
    end,
    [20] = function(param)
      data.miss = data.miss + param
    end,
    [21] = function(param)
      data.harmReduce = data.harmReduce + param
    end
  }
  for k, v in pairs(suitStatus) do
    local propData = DataUtils.getEquipmentSuitData(k)
    for i = 1, #propData do
      local currData = propData[i]
      if v >= currData.count then
        tFunc[currData.id](currData.num)
      end
    end
  end
  return data
end

function DataUtils.getEquipmentDataAdd(ueid, equipmentList)
  local data = {
    life = 0,
    attack = 0,
    phyDef = 0,
    magDef = 0,
    gold = 0,
    wood = 0,
    water = 0,
    fire = 0,
    earth = 0,
    allElements = 0,
    critRate = 0,
    decritRate = 0,
    critHarmRate = 0,
    decritHarmRate = 0,
    hit = 0,
    miss = 0,
    harmReduce = 0
  }
  if 0 == tonumber(ueid) then
    return data
  end
  local eData
  if equipmentList then
    eData = equipmentList[tostring(ueid)]
  else
    eData = CloudData.EQUIPMENT_INFO[tostring(ueid)]
  end
  if not eData then
    return data
  end
  local lifeRate = 0
  local attackRate = 0
  local phyDefRate = 0
  local magDefRate = 0
  local tFunc = {
    [1] = function(param)
      data.life = data.life + param
    end,
    [2] = function(param)
      data.attack = data.attack + param
    end,
    [3] = function(param)
      data.phyDef = data.phyDef + param
    end,
    [4] = function(param)
      data.magDef = data.magDef + param
    end,
    [5] = function(param)
      data.gold = data.gold + param
    end,
    [6] = function(param)
      data.wood = data.wood + param
    end,
    [7] = function(param)
      data.water = data.water + param
    end,
    [8] = function(param)
      data.fire = data.fire + param
    end,
    [9] = function(param)
      data.earth = data.earth + param
    end,
    [10] = function(param)
      data.allElements = data.allElements + param
    end,
    [11] = function(param)
      lifeRate = lifeRate + param
    end,
    [12] = function(param)
      attackRate = attackRate + param
    end,
    [13] = function(param)
      phyDefRate = phyDefRate + param
    end,
    [14] = function(param)
      magDefRate = magDefRate + param
    end,
    [15] = function(param)
      data.critRate = data.critRate + param
    end,
    [16] = function(param)
      data.decritRate = data.decritRate + param
    end,
    [17] = function(param)
      data.critHarmRate = data.critHarmRate + param
    end,
    [18] = function(param)
      data.decritHarmRate = data.decritHarmRate + param
    end,
    [19] = function(param)
      data.hit = data.hit + param
    end,
    [20] = function(param)
      data.miss = data.miss + param
    end,
    [21] = function(param)
      data.harmReduce = data.harmReduce + param
    end
  }
  for i = 1, #eData.baseProps do
    local baseData = eData.baseProps[i]
    local id, num = baseData.type, baseData.value
    local addNum = eData.grow[tostring(id)]
    tFunc[tonumber(id)](num + addNum * eData.level)
  end
  for i = 1, #eData.bornProps do
    local bornData = eData.bornProps[i]
    local id, num = bornData.type, bornData.value
    tFunc[tonumber(id)](num)
  end
  for i = 1, #eData.starProps do
    local starData = eData.starProps[i]
    local id, num = starData.type, starData.value
    tFunc[tonumber(id)](num)
  end
  for i = 1, #eData.quenchingProps do
    local quenchingData = eData.quenchingProps[i]
    local id, num = quenchingData.type, quenchingData.value
    tFunc[tonumber(id)](num)
  end
  data.life = data.life * (1 + lifeRate / 100)
  data.attack = data.attack * (1 + attackRate / 100)
  data.phyDef = data.phyDef * (1 + phyDefRate / 100)
  data.magDef = data.magDef * (1 + magDefRate / 100)
  local levelActive = {
    15,
    30,
    45,
    60,
    90,
    120,
    150
  }
  for i = 1, #levelActive do
    if eData.level >= levelActive[i] then
      local id, num = eData.lvPropTypes[i], eData.lvPropValues[i]
      tFunc[tonumber(id)](num)
    end
  end
  return data
end

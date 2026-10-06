function DataUtils.getCimeliaBaseInfo(id)
  id = tonumber(id)
  
  local cimeliaId = CloudData.CIMELIA_LIST[id].cid
  if not CloudData.CIMELIA_LIST[id] then
    DDTRACE("DataUtils.getCimeliaBaseInfo() : ", string.format(" cimelia ucid : %s with error data", checkstring(id)))
    return {}
  end
  local cimeliaInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_INFO, "id", tostring(cimeliaId))[1]
  if not cimeliaInfo then
    DDERROR("cimelia id : %d with error data", tonumber(cimeliaId))
    return
  end
  local cimeliaData = {}
  cimeliaData.ucid = id
  cimeliaData.id = tonumber(cimeliaInfo.id)
  cimeliaData.name = cimeliaInfo.name
  cimeliaData.type = tonumber(cimeliaInfo.category)
  cimeliaData.stage = tonumber(cimeliaInfo.stage)
  cimeliaData.icon = cimeliaInfo.icon
  cimeliaData.picture = cimeliaInfo.picture
  cimeliaData.element = tonumber(cimeliaInfo.key)
  cimeliaData.level = CloudData.CIMELIA_LIST[id].level
  cimeliaData.excessExp = CloudData.CIMELIA_LIST[id].excessExp
  cimeliaData.quality = CloudData.CIMELIA_LIST[id].quality
  cimeliaData.qualityRate = CloudData.CIMELIA_LIST[id].rate
  cimeliaData.proType = split(cimeliaInfo.type, ";")
  cimeliaData.proBaseNum = split(cimeliaInfo.basic, ";")
  cimeliaData.proAddNum = split(cimeliaInfo.add, ";")
  cimeliaData.desc = cimeliaInfo.Description
  cimeliaData.attackType = tonumber(cimeliaInfo.attackType)
  cimeliaData.grade = CloudData.CIMELIA_LIST[id].aptitude
  cimeliaData.recastProps = CloudData.CIMELIA_LIST[id].props
  cimeliaData.propGold = cimeliaInfo.gold
  cimeliaData.propWood = cimeliaInfo.wood
  cimeliaData.propWater = cimeliaInfo.water
  cimeliaData.propFire = cimeliaInfo.fire
  cimeliaData.propEarth = cimeliaInfo.earth
  cimeliaData.propAllElements = 0
  cimeliaData.phyDef = 0
  cimeliaData.magDef = 0
  cimeliaData.phyDefIgnore = 0
  cimeliaData.magDefIgnore = 0
  cimeliaData.hitRate = 115
  cimeliaData.critRate = 0
  cimeliaData.decritRate = 0
  cimeliaData.critHarmRate = 150
  cimeliaData.decritHarmRate = 0
  cimeliaData.harmAdd = 0
  cimeliaData.harmAddRate = 0
  cimeliaData.harmReduce = 0
  cimeliaData.harmReduceRate = 0
  local recastDataAdd = DataUtils.getCimeliaRecastAdd(CloudData.CIMELIA_LIST[id])
  cimeliaData.propGold = cimeliaData.propGold + recastDataAdd.gold
  cimeliaData.propWood = cimeliaData.propWood + recastDataAdd.wood
  cimeliaData.propWater = cimeliaData.propWater + recastDataAdd.water
  cimeliaData.propFire = cimeliaData.propFire + recastDataAdd.fire
  cimeliaData.propEarth = cimeliaData.propEarth + recastDataAdd.earth
  cimeliaData.phyDef = cimeliaData.phyDef + recastDataAdd.phyDef
  cimeliaData.magDef = cimeliaData.magDef + recastDataAdd.magDef
  cimeliaData.phyDefIgnore = cimeliaData.phyDefIgnore + recastDataAdd.phyDefIgnore
  cimeliaData.magDefIgnore = cimeliaData.magDefIgnore + recastDataAdd.magDefIgnore
  cimeliaData.critRate = cimeliaData.critRate + recastDataAdd.critRate
  cimeliaData.decritRate = cimeliaData.decritRate + recastDataAdd.decritRate
  cimeliaData.critHarmRate = cimeliaData.critHarmRate + recastDataAdd.critHarmRate
  cimeliaData.decritHarmRate = cimeliaData.decritHarmRate + recastDataAdd.decritHarmRate
  cimeliaData.hitRate = cimeliaData.hitRate + recastDataAdd.hit
  cimeliaData.harmReduceRate = cimeliaData.harmReduceRate + recastDataAdd.harmReduceRate
  local rate = cimeliaData.quality < 3 and 3 or cimeliaData.quality
  cimeliaData.expValue = tonumber(cimeliaInfo.expValue) + DataUtils.getExpCountNumToLevel(cimeliaData.level) * rate + cimeliaData.excessExp
  cimeliaData.proNum = {}
  for i = 1, #cimeliaData.proType do
    local proAddNum = tonumber(cimeliaData.proAddNum[i])
    local num = tonumber(cimeliaData.proBaseNum[i]) + proAddNum * cimeliaData.level
    if tonumber(cimeliaData.proType[i]) <= 2 then
      num = math.round(num * cimeliaData.qualityRate)
      cimeliaData.proAddNum[i] = math.round(proAddNum * cimeliaData.qualityRate)
      if 1 == tonumber(cimeliaData.proType[i]) then
        local treasureAdd = DataUtils.getTreasureIncRate(7)
        num = math.round(num * (1 + treasureAdd / 100) + recastDataAdd.life)
        cimeliaData.proAddNum[i] = math.round(cimeliaData.proAddNum[i] * (1 + treasureAdd / 100))
      end
      if 2 == tonumber(cimeliaData.proType[i]) then
        num = math.round(num + recastDataAdd.attack)
      end
    end
    table.insert(cimeliaData.proNum, num)
  end
  local skillIds = split(cimeliaInfo.skill, ";")
  local skillId = tonumber(skillIds[cimeliaData.quality - 1]) or 0
  if skillId ~= 0 then
    local skillInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_SKILL_INFO, "ID", tostring(skillId))[1]
    if not skillInfo then
      DDERROR("cimelia skill id : %d with error data", tonumber(skillId))
      return
    end
    cimeliaData.skillIcon = skillInfo.icon
    cimeliaData.skillName = skillInfo.SkillName
    cimeliaData.skillDesc = skillInfo.Description
  end
  return cimeliaData
end

function DataUtils.getCimeliaTabelForWiki(cimeliaId)
  local cimeliaInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_INFO, "id", tostring(cimeliaId))[1]
  if not cimeliaInfo then
    DDERROR("cimelia id : %d with error data", tonumber(cimeliaId))
    return
  end
  local cimeliaData = {}
  cimeliaData.name = cimeliaInfo.name
  cimeliaData.type = tonumber(cimeliaInfo.category)
  cimeliaData.key = tonumber(cimeliaInfo.key)
  cimeliaData.icon = cimeliaInfo.icon
  cimeliaData.picture = cimeliaInfo.picture
  local skillIds = split(cimeliaInfo.skill, ";")
  local skillId = tonumber(skillIds[5]) or 0
  if skillId ~= 0 then
    local skillInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_SKILL_INFO, "ID", tostring(skillId))[1]
    if not skillInfo then
      DDERROR("cimelia skill id : %d with error data", tonumber(skillId))
      return
    end
    cimeliaData.skillIcon = skillInfo.icon
    cimeliaData.skillName = skillInfo.SkillName
    cimeliaData.skillDesc = skillInfo.Description
  end
  return cimeliaData
end

function DataUtils.getAtkCimeliaInfo(cData)
  local tempData
  if cData then
    tempData = cData
  else
    local ucid = CloudData.CIMELIA_EQUIPED[1]
    tempData = CloudData.CIMELIA_LIST[ucid]
  end
  local cimeliaId = tempData.cid
  local level = tempData.level
  local rate = tempData.rate
  local quality = tempData.quality or 2
  local cimeliaInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_INFO, "id", tostring(cimeliaId))[1]
  if not cimeliaInfo then
    DDERROR("cimelia id : %d with error data", tonumber(cimeliaId))
    return
  end
  local cimeliaData = {}
  local proType = split(cimeliaInfo.type, ";")
  local proBaseNum = split(cimeliaInfo.basic, ";")
  local proAddNum = split(cimeliaInfo.add, ";")
  cimeliaData.name = cimeliaInfo.name
  cimeliaData.wandIcon = cimeliaInfo.picture
  cimeliaData.ballIcon = cimeliaInfo.icon
  cimeliaData.aiTags = cimeliaInfo.aiType
  cimeliaData.attackType = tonumber(cimeliaInfo.attackType)
  cimeliaData.element = tonumber(cimeliaInfo.key)
  cimeliaData.quality = quality
  cimeliaData.atkNum = 0
  cimeliaData.atkDistance = 0
  cimeliaData.spiritValue = 0
  cimeliaData.skillCDTime = 0
  cimeliaData.propGold = cimeliaInfo.gold
  cimeliaData.propWood = cimeliaInfo.wood
  cimeliaData.propWater = cimeliaInfo.water
  cimeliaData.propFire = cimeliaInfo.fire
  cimeliaData.propEarth = cimeliaInfo.earth
  cimeliaData.propAllElements = 0
  cimeliaData.phyDef = 0
  cimeliaData.magDef = 0
  cimeliaData.phyDefIgnore = 0
  cimeliaData.magDefIgnore = 0
  cimeliaData.hitRate = 115
  cimeliaData.critRate = 0
  cimeliaData.decritRate = 0
  cimeliaData.critHarmRate = 150
  cimeliaData.decritHarmRate = 0
  cimeliaData.harmAdd = 0
  cimeliaData.harmAddRate = 0
  cimeliaData.harmReduce = 0
  cimeliaData.harmReduceRate = 0
  local recastDataAdd = DataUtils.getCimeliaRecastAdd(tempData)
  cimeliaData.propGold = cimeliaData.propGold + recastDataAdd.gold
  cimeliaData.propWood = cimeliaData.propWood + recastDataAdd.wood
  cimeliaData.propWater = cimeliaData.propWater + recastDataAdd.water
  cimeliaData.propFire = cimeliaData.propFire + recastDataAdd.fire
  cimeliaData.propEarth = cimeliaData.propEarth + recastDataAdd.earth
  cimeliaData.phyDef = cimeliaData.phyDef + recastDataAdd.phyDef
  cimeliaData.magDef = cimeliaData.magDef + recastDataAdd.magDef
  cimeliaData.phyDefIgnore = cimeliaData.phyDefIgnore + recastDataAdd.phyDefIgnore
  cimeliaData.magDefIgnore = cimeliaData.magDefIgnore + recastDataAdd.magDefIgnore
  cimeliaData.critRate = cimeliaData.critRate + recastDataAdd.critRate
  cimeliaData.decritRate = cimeliaData.decritRate + recastDataAdd.decritRate
  cimeliaData.critHarmRate = cimeliaData.critHarmRate + recastDataAdd.critHarmRate
  cimeliaData.decritHarmRate = cimeliaData.decritHarmRate + recastDataAdd.decritHarmRate
  cimeliaData.hitRate = cimeliaData.hitRate + recastDataAdd.hit
  cimeliaData.harmReduceRate = cimeliaData.harmReduceRate + recastDataAdd.harmReduceRate
  local skillIds = split(cimeliaInfo.skill, ";")
  local skillId = tonumber(skillIds[quality - 1]) or 0
  cimeliaData.skillId = skillId
  if skillId ~= 0 then
    local skillInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_SKILL_INFO, "ID", tostring(skillId))[1]
    if not skillInfo then
      DDERROR("cimelia skill id : %d with error data", tonumber(skillId))
      return
    end
    cimeliaData.skillIcon = skillInfo.icon
    cimeliaData.skillType = skillInfo.range
    cimeliaData.skillName = skillInfo.name
  end
  for i = 1, #proType do
    local num = tonumber(proBaseNum[i]) + tonumber(proAddNum[i]) * level
    if tonumber(proType[i]) == 2 then
      cimeliaData.atkNum = math.round(num * rate) + recastDataAdd.attack
    end
    if tonumber(proType[i]) == 6 then
      cimeliaData.atkDistance = num
    end
    if tonumber(proType[i]) == 8 then
      cimeliaData.spiritValue = num
    end
    if tonumber(proType[i]) == 5 then
      cimeliaData.skillCDTime = num
    end
  end
  return cimeliaData
end

function DataUtils.getDefCimeliaInfo(cData, treasureList)
  local tempData
  if cData then
    tempData = cData
  else
    local ucid = CloudData.CIMELIA_EQUIPED[2]
    tempData = CloudData.CIMELIA_LIST[ucid]
  end
  local cimeliaId = tempData.cid
  local level = tempData.level
  local rate = tempData.rate
  local quality = tempData.quality or 2
  local cimeliaInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_INFO, "id", tostring(cimeliaId))[1]
  if not cimeliaInfo then
    DDERROR("cimelia id : %d with error data", tonumber(cimeliaId))
    return
  end
  local cimeliaData = {}
  local proType = split(cimeliaInfo.type, ";")
  local proBaseNum = split(cimeliaInfo.basic, ";")
  local proAddNum = split(cimeliaInfo.add, ";")
  cimeliaData.name = cimeliaInfo.name
  cimeliaData.towerArmature = cimeliaInfo.towerArmature
  cimeliaData.aiTags = cimeliaInfo.aiType
  cimeliaData.attackType = tonumber(cimeliaInfo.attackType)
  cimeliaData.element = tonumber(cimeliaInfo.key)
  cimeliaData.quality = quality
  cimeliaData.towerHP = 0
  cimeliaData.spiritLimit = 0
  cimeliaData.spiritSpeed = 0
  cimeliaData.buddhaCDtime = 0
  cimeliaData.skillCDTime = 0
  cimeliaData.propGold = cimeliaInfo.gold
  cimeliaData.propWood = cimeliaInfo.wood
  cimeliaData.propWater = cimeliaInfo.water
  cimeliaData.propFire = cimeliaInfo.fire
  cimeliaData.propEarth = cimeliaInfo.earth
  cimeliaData.propAllElements = 0
  cimeliaData.phyDef = 0
  cimeliaData.magDef = 0
  cimeliaData.phyDefIgnore = 0
  cimeliaData.magDefIgnore = 0
  cimeliaData.hitRate = 115
  cimeliaData.critRate = 0
  cimeliaData.decritRate = 0
  cimeliaData.critHarmRate = 150
  cimeliaData.decritHarmRate = 0
  cimeliaData.harmAdd = 0
  cimeliaData.harmAddRate = 0
  cimeliaData.harmReduce = 0
  cimeliaData.harmReduceRate = 0
  local recastDataAdd = DataUtils.getCimeliaRecastAdd(tempData)
  cimeliaData.propGold = cimeliaData.propGold + recastDataAdd.gold
  cimeliaData.propWood = cimeliaData.propWood + recastDataAdd.wood
  cimeliaData.propWater = cimeliaData.propWater + recastDataAdd.water
  cimeliaData.propFire = cimeliaData.propFire + recastDataAdd.fire
  cimeliaData.propEarth = cimeliaData.propEarth + recastDataAdd.earth
  cimeliaData.phyDef = cimeliaData.phyDef + recastDataAdd.phyDef
  cimeliaData.magDef = cimeliaData.magDef + recastDataAdd.magDef
  cimeliaData.phyDefIgnore = cimeliaData.phyDefIgnore + recastDataAdd.phyDefIgnore
  cimeliaData.magDefIgnore = cimeliaData.magDefIgnore + recastDataAdd.magDefIgnore
  cimeliaData.critRate = cimeliaData.critRate + recastDataAdd.critRate
  cimeliaData.decritRate = cimeliaData.decritRate + recastDataAdd.decritRate
  cimeliaData.critHarmRate = cimeliaData.critHarmRate + recastDataAdd.critHarmRate
  cimeliaData.decritHarmRate = cimeliaData.decritHarmRate + recastDataAdd.decritHarmRate
  cimeliaData.hitRate = cimeliaData.hitRate + recastDataAdd.hit
  cimeliaData.harmReduceRate = cimeliaData.harmReduceRate + recastDataAdd.harmReduceRate
  local skillIds = split(cimeliaInfo.skill, ";")
  local skillId = tonumber(skillIds[quality - 1]) or 0
  cimeliaData.skillId = skillId
  if skillId ~= 0 then
    local skillInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_SKILL_INFO, "ID", tostring(skillId))[1]
    if not skillInfo then
      DDERROR("cimelia skill id : %d with error data", tonumber(skillId))
      return
    end
    cimeliaData.skillIcon = skillInfo.icon
  end
  for i = 1, #proType do
    local num = tonumber(proBaseNum[i]) + tonumber(proAddNum[i]) * level
    if tonumber(proType[i]) == 1 then
      cimeliaData.towerHP = math.round(num * rate)
    end
    if tonumber(proType[i]) == 3 then
      cimeliaData.spiritLimit = num
    end
    if tonumber(proType[i]) == 4 then
      cimeliaData.spiritSpeed = num
    end
    if tonumber(proType[i]) == 7 then
      cimeliaData.buddhaCDtime = num
    end
    if tonumber(proType[i]) == 5 then
      cimeliaData.skillCDTime = num
    end
  end
  local treasureAdd = DataUtils.getTreasureIncRate(7, treasureList)
  cimeliaData.towerHP = math.round(cimeliaData.towerHP * (1 + treasureAdd / 100)) + recastDataAdd.life
  return cimeliaData
end

function DataUtils.getBuddhaCimeliaSkill()
  local ucid = CloudData.CIMELIA_EQUIPED[1]
  local cimeliaId = CloudData.CIMELIA_LIST[ucid].cid
  local quality = CloudData.CIMELIA_LIST[ucid].quality
  local cimeliaInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_INFO, "id", tostring(cimeliaId))[1]
  if not cimeliaInfo then
    DDERROR("cimelia id : %d with error data", tonumber(cimeliaId))
    return
  end
  local skills = split(cimeliaInfo.skill, ";")
  local skillId = tonumber(skills[quality - 1]) or 0
  return skillId
end

function DataUtils.getExpCostCurrLevel(level)
  local expInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_EXP_INFO, "level", tostring(level))[1]
  if not expInfo then
    DDERROR("cimelia level id : %d exp cost with error data", tonumber(level))
    return
  end
  local costNum = tonumber(expInfo.exp)
  return costNum
end

function DataUtils.getExpCountNumToLevel(level)
  local expInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_EXP_INFO, "level", tostring(level))[1]
  if not expInfo then
    DDERROR("cimelia level id : %d exp cost with error data", tonumber(level))
    return
  end
  local countNum = tonumber(expInfo.expSum)
  return countNum
end

function DataUtils.getCimeliaInfoWithId(id, params)
  local cimeliaInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_INFO, "id", tostring(id))[1]
  if not cimeliaInfo then
    DDERROR("cimelia id : %d with error data", tonumber(id))
    return
  end
  local cimeliaData = {}
  cimeliaData.name = cimeliaInfo.name
  cimeliaData.icon = cimeliaInfo.icon
  cimeliaData.proType = split(cimeliaInfo.type, ";")
  cimeliaData.proBaseNum = split(cimeliaInfo.basic, ";")
  cimeliaData.proAddNum = split(cimeliaInfo.add, ";")
  cimeliaData.proNum = {}
  for i = 1, #cimeliaData.proType do
    local num = tonumber(cimeliaData.proBaseNum[i]) + tonumber(cimeliaData.proAddNum[i])
    if tonumber(cimeliaData.proType[i]) <= 2 then
      num = math.round(num * params.rate)
    end
    table.insert(cimeliaData.proNum, num)
  end
  local skillIds = split(cimeliaInfo.skill, ";")
  local skillId = tonumber(skillIds[params.quality - 1])
  if skillId ~= 0 then
    local skillInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_SKILL_INFO, "ID", tostring(skillId))[1]
    if not skillInfo then
      DDERROR("cimelia skill id : %d with error data", tonumber(skillId))
      return
    end
    cimeliaData.skillName = skillInfo.SkillName
    cimeliaData.skillDesc = skillInfo.Description
  end
  return cimeliaData
end

function DataUtils.getCimeliaNameColor(quality)
  local tFunc = {
    [2] = cc.c3b(35, 255, 51),
    [3] = cc.c3b(25, 231, 255),
    [4] = cc.c3b(233, 45, 255),
    [5] = cc.c3b(255, 152, 6),
    [6] = cc.c3b(255, 48, 48)
  }
  return tFunc[quality]
end

function DataUtils.getCimeliaQualityRate(quality)
  local weightData = DYCommon.getDataByTag(DataRetainer.CIMELIA_QUALITY_INFO, "quality", tostring(quality))[1]
  if not weightData then
    DDERROR("cimelia quality : %d with error data", tonumber(quality))
    return
  end
  local weights = split(weightData.weights, ";")
  return weights
end

function DataUtils.getCimeliaRecastCost(id)
  local costInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_RECAST_COST, "id", tostring(id))[1]
  local data = {
    itemIds = split(costInfo.itemId, ";"),
    costNums = split(costInfo.costNum, ";"),
    limitLevel = tonumber(costInfo.limitLevel)
  }
  return data
end

function DataUtils.getCimeliaGradeUpCost(id)
  local costInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_GRADE_UP, "id", tostring(id))[1]
  local data = {
    itemIds = split(costInfo.itemId, ";"),
    costNums = split(costInfo.costNum, ";")
  }
  return data
end

function DataUtils.getCimeliaRecastPropPool(id, tag, attackType)
  local costInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_RECAST_COST, "id", tostring(id))[1]
  local poolIds = {}
  if 1 == tag then
    if 1 == attackType then
      poolIds = split(costInfo.phyStaffProps, ";")
    else
      poolIds = split(costInfo.magStaffProps, ";")
    end
  else
    poolIds = split(costInfo.towerProps, ";")
  end
  local propData = {}
  for i = 1, #poolIds do
    local propInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_PROP_INFO, "id", tostring(poolIds[i]))[1]
    local propId = tonumber(propInfo.type)
    local minNum = tonumber(propInfo.min)
    local maxNum = tonumber(propInfo.max)
    local quality = id
    local propStr = string.format("%d-%d", minNum, maxNum)
    if 12 <= propId then
      propStr = string.format("%d%%-%d%%", minNum, maxNum)
    end
    table.insert(propData, {
      propId = propId,
      propStr = propStr,
      quality = quality
    })
  end
  return propData
end

function DataUtils.getCimeliaRecastAdd(cimeliaData)
  local data = {
    life = 0,
    attack = 0,
    phyDef = 0,
    magDef = 0,
    phyDefIgnore = 0,
    magDefIgnore = 0,
    gold = 0,
    wood = 0,
    water = 0,
    fire = 0,
    earth = 0,
    critRate = 0,
    decritRate = 0,
    critHarmRate = 0,
    decritHarmRate = 0,
    hit = 0,
    harmReduceRate = 0
  }
  if not cimeliaData or not cimeliaData.props then
    return data
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
      data.phyDefIgnore = data.phyDefIgnore + param
    end,
    [6] = function(param)
      data.magDefIgnore = data.magDefIgnore + param
    end,
    [7] = function(param)
      data.gold = data.gold + param
    end,
    [8] = function(param)
      data.wood = data.wood + param
    end,
    [9] = function(param)
      data.water = data.water + param
    end,
    [10] = function(param)
      data.fire = data.fire + param
    end,
    [11] = function(param)
      data.earth = data.earth + param
    end,
    [12] = function(param)
      data.critRate = data.critRate + param
    end,
    [13] = function(param)
      data.decritRate = data.decritRate + param
    end,
    [14] = function(param)
      data.critHarmRate = data.critHarmRate + param
    end,
    [15] = function(param)
      data.decritHarmRate = data.decritHarmRate + param
    end,
    [16] = function(param)
      data.hit = data.hit + param
    end,
    [17] = function(param)
      data.harmReduceRate = data.harmReduceRate + param
    end
  }
  for i = 1, #cimeliaData.props do
    local recastData = cimeliaData.props[i]
    if recastData.type then
      local id, num = tonumber(recastData.type), tonumber(recastData.value)
      if tFunc[id] then
        tFunc[id](num)
      end
    end
  end
  return data
end

function DataUtils.getCimeliaCE()
  local countCE = 0
  for i = 1, 2 do
    local ucid = CloudData.CIMELIA_EQUIPED[i]
    if ucid == nil then
      DDERROR("no cimelia!")
      return 0
    end
    local cimeliaId = CloudData.CIMELIA_LIST[ucid].cid
    if not CloudData.CIMELIA_LIST[ucid] then
      DDTRACE("DataUtils.getCimeliaCE() : ", string.format(" cimelia ucid : %s with error data", checkstring(ucid)))
      return 0
    end
    local cimeliaInfo = DYCommon.getDataByTag(DataRetainer.CIMELIA_INFO, "id", tostring(cimeliaId))[1]
    if not cimeliaInfo then
      DDERROR("cimelia id : %d with error data", tonumber(cimeliaId))
      return 0
    end
    local power = tonumber(cimeliaInfo.power)
    local level = CloudData.CIMELIA_LIST[ucid].level
    local rate = CloudData.CIMELIA_LIST[ucid].rate
    countCE = countCE + power * level * rate
  end
  return math.round(countCE)
end

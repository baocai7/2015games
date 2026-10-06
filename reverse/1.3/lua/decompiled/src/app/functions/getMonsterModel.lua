function DataUtils.getMonsterModel(monsterId_)
  local monsterInfo = DYCommon.getDataByTag(DataRetainer.MONSTER_INFO, "monsterID", tostring(monsterId_))[1]
  
  if not monsterInfo then
    DDERROR("monsterId : %d with error data", tonumber(monsterId_))
    return
  end
  local monsterDataTable = {}
  monsterDataTable.npcId = tonumber(monsterInfo.monsterID)
  monsterDataTable.modelID = tonumber(monsterInfo.modelId)
  monsterDataTable.npcSkill = split(monsterInfo.skill, ";")
  monsterDataTable.skillLv = split(monsterInfo.skillLv, ";")
  monsterDataTable.hitNum = tonumber(monsterInfo.hitNum)
  monsterDataTable.life = tonumber(monsterInfo.life)
  monsterDataTable.attack = tonumber(monsterInfo.attackParam)
  monsterDataTable.phyDefence = tonumber(monsterInfo.phyDefenceParam)
  monsterDataTable.magDefence = tonumber(monsterInfo.magDefenceParam)
  monsterDataTable.runSpeed = tonumber(monsterInfo.runSpeedB)
  monsterDataTable.backParam = tonumber(monsterInfo.backParam)
  monsterDataTable.backLength = tonumber(monsterInfo.backLength)
  monsterDataTable.restrainType = tonumber(monsterInfo.restrainType)
  monsterDataTable.attackType = tonumber(monsterInfo.attackType)
  monsterDataTable.level = tonumber(monsterInfo.Level)
  monsterDataTable.force = tonumber(monsterInfo.force) or 1
  monsterDataTable.element = tonumber(monsterInfo.element)
  monsterDataTable.consume = tonumber(monsterInfo.Consume)
  monsterDataTable.propGold = tonumber(monsterInfo.gold)
  monsterDataTable.propWood = tonumber(monsterInfo.wood)
  monsterDataTable.propWater = tonumber(monsterInfo.water)
  monsterDataTable.propFire = tonumber(monsterInfo.fire)
  monsterDataTable.propEarth = tonumber(monsterInfo.earth)
  monsterDataTable.propAllElements = 0
  monsterDataTable.phyDefIgnore = 0
  monsterDataTable.magDefIgnore = 0
  monsterDataTable.hitRate = 100
  monsterDataTable.missRate = 0
  monsterDataTable.critRate = 0
  monsterDataTable.decritRate = 0
  monsterDataTable.critHarmRate = 150
  monsterDataTable.decritHarmRate = 0
  monsterDataTable.harmAdd = 0
  monsterDataTable.harmAddRate = 0
  monsterDataTable.harmReduce = 0
  monsterDataTable.harmReduceRate = 0
  monsterDataTable.resBack = 0
  monsterDataTable.resStun = 0
  monsterDataTable.resStone = 0
  monsterDataTable.resRebel = 0
  monsterDataTable.resChange = 0
  monsterDataTable.resPalsy = 0
  monsterDataTable.resFreeze = 0
  monsterDataTable.resBurn = 0
  monsterDataTable.resPoison = 0
  monsterDataTable.resSilence = 0
  monsterDataTable.resAll = 0
  monsterDataTable.value = tonumber(monsterInfo.value) or 0
  monsterDataTable.monsterType = tonumber(monsterInfo.monsterType)
  monsterDataTable.totalSkills = split(monsterInfo.skill, ";")
  monsterDataTable.skillLevels = split(monsterInfo.skillLv, ";")
  local cimeliaData = DataUtils.getAtkCimeliaInfo()
  local treasureAdd = DataUtils.getTreasureIncRate(6)
  if cimeliaData then
    monsterDataTable.value = math.round(monsterDataTable.value * (cimeliaData.spiritValue + treasureAdd) / 100)
  end
  local skillAddNum = {
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
  local skillAddRate = {
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
  for i = 1, #monsterDataTable.npcSkill do
    local skillLevel = tonumber(monsterDataTable.skillLv[i]) or 0
    if 0 < skillLevel then
      local skillAddTable1, skillAddTable2 = DataUtils.getPropertiesOfSkillAdd(monsterDataTable.npcSkill[i], monsterDataTable.npcId, skillLevel)
      for m, n in pairs(skillAddTable1) do
        if m and n ~= 0 then
          skillAddNum[m] = skillAddNum[m] + n
        end
      end
      for i, j in pairs(skillAddTable2) do
        if i and j ~= 0 then
          skillAddRate[i] = skillAddRate[i] + j
        end
      end
    end
  end
  monsterDataTable.hitRate = monsterDataTable.hitRate + skillAddNum.hit
  monsterDataTable.missRate = monsterDataTable.missRate + skillAddNum.miss
  monsterDataTable.critRate = monsterDataTable.critRate + skillAddNum.crit
  monsterDataTable.decritRate = monsterDataTable.decritRate + skillAddNum.decrit
  monsterDataTable.critHarmRate = monsterDataTable.critHarmRate + skillAddNum.critHarm
  monsterDataTable.decritHarmRate = monsterDataTable.decritHarmRate + skillAddNum.decritHarm
  monsterDataTable.phyDefIgnore = math.round((monsterDataTable.phyDefIgnore + skillAddNum.phyDefIgnore) * (100 + skillAddRate.phyDefIgnore) / 100)
  monsterDataTable.magDefIgnore = math.round((monsterDataTable.magDefIgnore + skillAddNum.magDefIgnore) * (100 + skillAddRate.magDefIgnore) / 100)
  monsterDataTable.harmAdd = math.round(monsterDataTable.harmAdd + skillAddNum.harmAdd)
  monsterDataTable.harmAddRate = skillAddRate.harmAdd
  monsterDataTable.harmReduce = math.round(monsterDataTable.harmReduce + skillAddNum.harmReduce)
  monsterDataTable.harmReduceRate = skillAddRate.harmReduce
  monsterDataTable.resBack = monsterDataTable.resBack + skillAddNum.resBack
  monsterDataTable.resStun = monsterDataTable.resStun + skillAddNum.resStun
  monsterDataTable.resStone = monsterDataTable.resStone + skillAddNum.resStone
  monsterDataTable.resRebel = monsterDataTable.resRebel + skillAddNum.resRebel
  monsterDataTable.resChange = monsterDataTable.resChange + skillAddNum.resChange
  monsterDataTable.resPalsy = monsterDataTable.resPalsy + skillAddNum.resPalsy
  monsterDataTable.resFreeze = monsterDataTable.resFreeze + skillAddNum.resFreeze
  monsterDataTable.resBurn = monsterDataTable.resBurn + skillAddNum.resBurn
  monsterDataTable.resPoison = monsterDataTable.resPoison + skillAddNum.resPoison
  monsterDataTable.resSilence = monsterDataTable.resSilence + skillAddNum.resSilence
  monsterDataTable.resAll = monsterDataTable.resAll + skillAddNum.resAll
  local buddhaModelInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_MODEL_INFO, "id", tostring(monsterDataTable.modelID))[1]
  if not buddhaModelInfo then
    DDERROR("monsterId : %d,modeId : %d with error data", monsterDataTable.npcId, monsterDataTable.modelID)
    return
  end
  monsterDataTable.npcName = buddhaModelInfo.Name
  monsterDataTable.npcIcon = buddhaModelInfo.icon
  monsterDataTable.npcDesc = buddhaModelInfo.npcDesc
  monsterDataTable.armatureFile = buddhaModelInfo.hurtFrame
  monsterDataTable.standFrame = buddhaModelInfo.standFrame
  monsterDataTable.attackFrequency = tonumber(buddhaModelInfo.attackFrequencyB)
  monsterDataTable.attackDistance = tonumber(buddhaModelInfo.AttackDistance)
  monsterDataTable.attackTime = tonumber(buddhaModelInfo.attackTime)
  monsterDataTable.soundFile = buddhaModelInfo.soundFile
  monsterDataTable.soundSkillFile = split(buddhaModelInfo.skillsound, ";")
  monsterDataTable.upMove = tonumber(buddhaModelInfo.upMove)
  monsterDataTable.orignWidth = tonumber(buddhaModelInfo.orignWidth)
  monsterDataTable.orignHeight = tonumber(buddhaModelInfo.orignHeight)
  monsterDataTable.sizeInBattle = tonumber(buddhaModelInfo.sizeInBattle)
  monsterDataTable.zoomMultiple = tonumber(buddhaModelInfo.zoomMultiple)
  monsterDataTable.isRebel = tonumber(buddhaModelInfo.isRebel)
  monsterDataTable.hurtspeed = tonumber(buddhaModelInfo.hurtspeed)
  monsterDataTable.tagType = tonumber(buddhaModelInfo.isShooter)
  monsterDataTable.orignWidth = tonumber(buddhaModelInfo.orignWidth)
  monsterDataTable.orignHeight = tonumber(buddhaModelInfo.orignHeight)
  monsterDataTable.attackPreTime = tonumber(buddhaModelInfo.attackPreTime)
  monsterDataTable.attackColdTime = tonumber(buddhaModelInfo.attackColdTime)
  monsterDataTable.hurtColdTime = tonumber(buddhaModelInfo.hurtColdTime)
  monsterDataTable.skillTimeParam = {}
  for i = 1, 4 do
    local param = {}
    param.preTime = tonumber(buddhaModelInfo["skillPreTime" .. i] or 0) or 0
    local completeTime = tonumber(buddhaModelInfo["skillColdTime" .. i] or 0)
    param.coldTime = completeTime - param.preTime
    table.insert(monsterDataTable.skillTimeParam, param)
  end
  return monsterDataTable
end

function DataUtils.getMonsterBaseInfo(monsterId_)
  local monsterInfo = DYCommon.getDataByTag(DataRetainer.MONSTER_INFO, "monsterID", tostring(monsterId_))[1]
  if not monsterInfo then
    DDERROR("monsterId : %d with error data", tonumber(monsterId_))
    return
  end
  local modelId = tonumber(monsterInfo.modelId)
  local buddhaModelInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_MODEL_INFO, "id", tostring(modelId))[1]
  if not buddhaModelInfo then
    DDERROR("monsterId : %d,modeId : %d with error data", monsterDataTable.npcId, monsterDataTable.modelID)
    return
  end
  local monsterDataTable = {}
  monsterDataTable.life = tonumber(monsterInfo.life)
  monsterDataTable.npcName = buddhaModelInfo.Name
  monsterDataTable.npcIcon = buddhaModelInfo.icon
  monsterDataTable.npcDesc = buddhaModelInfo.npcDesc
  monsterDataTable.armatureFile = buddhaModelInfo.hurtFrame
  monsterDataTable.isRebel = tonumber(buddhaModelInfo.isRebel)
  monsterDataTable.quality = checknumber(monsterInfo.quality)
  monsterDataTable.level = checknumber(monsterInfo.Level)
  return monsterDataTable
end

function DataUtils.getPVPMonsterModel(buddhaId)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(buddhaId))[1]
  if not buddhaInfo then
    DDERROR("buddhaInfo index : %s with error data", checkstring(buddhaId))
    DDTRACE("DataUtils.getPVPMonsterModel() -- 1 : ", string.format("buddhaInfo index :%s", checkstring(buddhaId)))
    return
  end
  local buddhaDataTable = {}
  buddhaDataTable.tag1 = tonumber(buddhaInfo.tag1)
  buddhaDataTable.tag2 = tonumber(buddhaInfo.tag2)
  buddhaDataTable.tag3 = tonumber(buddhaInfo.tag3)
  buddhaDataTable.npcId = tonumber(buddhaInfo.buddhaID)
  buddhaDataTable.modelID = split(buddhaInfo.ModelId, ";")
  buddhaDataTable.consume = tonumber(buddhaInfo.Consume)
  buddhaDataTable.hitNum = tonumber(buddhaInfo.hitNum)
  buddhaDataTable.lifeParamB = tonumber(buddhaInfo.lifeParamB)
  buddhaDataTable.lifeParamK = tonumber(buddhaInfo.lifeParamK)
  buddhaDataTable.attackParamB = tonumber(buddhaInfo.attackParamB)
  buddhaDataTable.attackParamK = tonumber(buddhaInfo.attackParamK)
  buddhaDataTable.phyDefenceParamB = tonumber(buddhaInfo.DefenceParamB)
  buddhaDataTable.phyDefenceParamK = tonumber(buddhaInfo.DefenceParamK)
  buddhaDataTable.magDefenceParamB = tonumber(buddhaInfo.MagDefenceParamB)
  buddhaDataTable.magDefenceParamK = tonumber(buddhaInfo.MagDefenceParamK)
  buddhaDataTable.runSpeed = tonumber(buddhaInfo.RunSpeedB)
  buddhaDataTable.backParam = tonumber(buddhaInfo.backParam)
  buddhaDataTable.backLength = tonumber(buddhaInfo.backLength)
  buddhaDataTable.restrainType = tonumber(buddhaInfo.restrainType)
  buddhaDataTable.monsterType = nil
  buddhaDataTable.quality = tonumber(buddhaInfo.quality)
  buddhaDataTable.attackType = tonumber(buddhaInfo.AttackType)
  buddhaDataTable.element = tonumber(buddhaInfo.element)
  buddhaDataTable.attackFrequency = 0
  buddhaDataTable.phyDefIgnore = 0
  buddhaDataTable.magDefIgnore = 0
  buddhaDataTable.hitRate = 100
  buddhaDataTable.missRate = 0
  buddhaDataTable.critRate = 0
  buddhaDataTable.decritRate = 0
  buddhaDataTable.critHarmRate = 150
  buddhaDataTable.decritHarmRate = 0
  buddhaDataTable.harmAdd = 0
  buddhaDataTable.harmAddRate = 0
  buddhaDataTable.harmReduce = 0
  buddhaDataTable.harmReduceRate = 0
  buddhaDataTable.resBack = 0
  buddhaDataTable.resStun = 0
  buddhaDataTable.resStone = 0
  buddhaDataTable.resRebel = 0
  buddhaDataTable.resChange = 0
  buddhaDataTable.resPalsy = 0
  buddhaDataTable.resFreeze = 0
  buddhaDataTable.resBurn = 0
  buddhaDataTable.resPoison = 0
  buddhaDataTable.resSilence = 0
  buddhaDataTable.resAll = 0
  buddhaDataTable.propGold = 0
  buddhaDataTable.propWood = 0
  buddhaDataTable.propWater = 0
  buddhaDataTable.propFire = 0
  buddhaDataTable.propEarth = 0
  buddhaDataTable.propAllElements = 0
  local tBuddhaId = tostring(buddhaId)
  if not CloudData.ENEMY_NPC_INFO or not CloudData.ENEMY_NPC_INFO[tBuddhaId] then
    DDERROR("CloudData.ENEMY_NPC_INFO error with buddhaId: %s", tBuddhaId)
    DDTRACE("DataUtils.getPVPMonsterModel() -- 2 : ", string.format("tBuddhaId is :%s", tBuddhaId))
    return
  end
  buddhaDataTable.level = CloudData.ENEMY_NPC_INFO[tostring(buddhaId)].level
  buddhaDataTable.starLevel = CloudData.ENEMY_NPC_INFO[tostring(buddhaId)].star
  buddhaDataTable.equipmentList = CloudData.ENEMY_NPC_INFO[tostring(buddhaId)].equipments or {
    0,
    0,
    0,
    0
  }
  local userEquipments = CloudData.ENEMY_EQUIPMENTS
  buddhaDataTable.npcSkill = {}
  buddhaDataTable.totalSkills = {}
  buddhaDataTable.skillLevels = {}
  local skillInfo = CloudData.ENEMY_NPC_INFO[tostring(buddhaId)].skills
  local awakeSkills = CloudData.ENEMY_NPC_INFO[tostring(buddhaId)].arousals
  for k, v in pairs(skillInfo) do
    table.insert(buddhaDataTable.npcSkill, tostring(k))
    table.insert(buddhaDataTable.totalSkills, tostring(k))
    table.insert(buddhaDataTable.skillLevels, tonumber(v))
  end
  for k, v in pairs(awakeSkills) do
    table.insert(buddhaDataTable.totalSkills, tostring(k))
    table.insert(buddhaDataTable.skillLevels, v.level)
  end
  local teamInfo = {}
  for k, v in pairs(CloudData.ENEMY_NPC_INFO) do
    table.insert(teamInfo, checkstring(k))
  end
  local breakLevel = 10
  local breakBata = 3
  local l = buddhaDataTable.level
  local n = math.floor(l / 10)
  local g = buddhaDataTable.starLevel
  local life = buddhaInfo.lifeParamB + buddhaInfo.lifeParamK * (breakLevel + breakBata) * (n + 1) * n / 2 + (l - n * breakLevel) * (n + 1) * buddhaInfo.lifeParamK + g ^ 2 * 15 * buddhaInfo.lifeParamK
  local attack = buddhaInfo.attackParamB + buddhaInfo.attackParamK * (breakLevel + breakBata) * (n + 1) * n / 2 + (l - n * breakLevel) * (n + 1) * buddhaInfo.attackParamK + g ^ 2 * 15 * buddhaInfo.attackParamK
  local phyDefence = buddhaInfo.DefenceParamB + buddhaInfo.DefenceParamK * (breakLevel + breakBata) * (n + 1) * n / 2 + (l - n * breakLevel) * (n + 1) * buddhaInfo.DefenceParamK + g ^ 2 * 15 * buddhaInfo.DefenceParamK
  local magDefence = buddhaInfo.MagDefenceParamB + buddhaInfo.MagDefenceParamK * (breakLevel + breakBata) * (n + 1) * n / 2 + (l - n * breakLevel) * (n + 1) * buddhaInfo.MagDefenceParamK + g ^ 2 * 15 * buddhaInfo.MagDefenceParamK
  local braakData = DataUtils.getBreakPropertyAdd(buddhaDataTable.npcId, buddhaDataTable.level)
  local teamStarAdd = DataUtils.getTeamStarFateAdd(buddhaDataTable.npcId, teamInfo, CloudData.ENEMY_NPC_INFO)
  local skillAddNum = {
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
  local skillAddRate = {
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
  for i = 1, #buddhaDataTable.skillLevels do
    local skillLevel = buddhaDataTable.skillLevels[i]
    if 0 < skillLevel then
      local skillAddTable1, skillAddTable2 = DataUtils.getPropertiesOfSkillAdd(buddhaDataTable.totalSkills[i], buddhaDataTable.npcId, skillLevel)
      for m, n in pairs(skillAddTable1) do
        if m and n ~= 0 then
          skillAddNum[m] = skillAddNum[m] + n
        end
      end
      for i, j in pairs(skillAddTable2) do
        if i and j ~= 0 then
          skillAddRate[i] = skillAddRate[i] + j
        end
      end
    end
  end
  local treasureList = CloudData.ENEMY_TREASURE_INFO
  local treasureLifeAdd = DataUtils.getTreasureIncRate(5, treasureList)
  local treasureAttackAdd = DataUtils.getTreasureIncRate(8, treasureList)
  local treasureMagAtkAdd = DataUtils.getTreasureIncRate(9, treasureList)
  local treasurePhyDefAdd = DataUtils.getTreasureIncRate(10, treasureList)
  local treasurePhyAtkAdd = DataUtils.getTreasureIncRate(11, treasureList)
  local treasureMagDefAdd = DataUtils.getTreasureIncRate(12, treasureList)
  local treasureHitAdd = DataUtils.getTreasureIncRate(13, treasureList)
  local unionBossAttackAdd = DataUtils.getUnionBossSkillAdd(2, nil)
  local unionBossLifeAdd = DataUtils.getUnionBossSkillAdd(3, nil)
  local unionBossHarmReduceAdd = DataUtils.getUnionBossSkillAdd(4, nil)
  local unionBossHarmAddAdd = DataUtils.getUnionBossSkillAdd(5, nil)
  life = math.round((life + skillAddNum.life + teamStarAdd.life) * (100 + skillAddRate.life + treasureLifeAdd + unionBossLifeAdd) / 100)
  attack = math.round((attack + skillAddNum.attack + teamStarAdd.attack) * (100 + skillAddRate.attack + treasureAttackAdd + unionBossAttackAdd) / 100)
  phyDefence = math.round((phyDefence + skillAddNum.phyDef + teamStarAdd.phyDef) * (100 + skillAddRate.phyDef + treasurePhyDefAdd) / 100)
  magDefence = math.round((magDefence + skillAddNum.magDef + teamStarAdd.magDef) * (100 + skillAddRate.magDef + treasureMagDefAdd) / 100)
  buddhaDataTable.hitRate = math.round(buddhaDataTable.hitRate + skillAddNum.hit + braakData.hit + treasureHitAdd)
  buddhaDataTable.missRate = math.round(buddhaDataTable.missRate + skillAddNum.miss + braakData.miss)
  buddhaDataTable.critRate = math.round(buddhaDataTable.critRate + skillAddNum.crit + braakData.crit)
  buddhaDataTable.decritRate = math.round(buddhaDataTable.decritRate + skillAddNum.decrit + braakData.decrit)
  buddhaDataTable.critHarmRate = math.round(buddhaDataTable.critHarmRate + skillAddNum.critHarm + braakData.critHarm)
  buddhaDataTable.decritHarmRate = math.round(buddhaDataTable.decritHarmRate + skillAddNum.decritHarm + braakData.decritHarm)
  buddhaDataTable.phyDefIgnore = math.round((buddhaDataTable.phyDefIgnore + skillAddNum.phyDefIgnore) * (100 + skillAddRate.phyDefIgnore) / 100)
  buddhaDataTable.magDefIgnore = math.round((buddhaDataTable.magDefIgnore + skillAddNum.magDefIgnore) * (100 + skillAddRate.magDefIgnore) / 100)
  buddhaDataTable.harmAdd = math.round(buddhaDataTable.harmAdd + skillAddNum.harmAdd)
  buddhaDataTable.harmAddRate = skillAddRate.harmAdd + unionBossHarmAddAdd
  buddhaDataTable.harmReduce = math.round(buddhaDataTable.harmReduce + skillAddNum.harmReduce)
  buddhaDataTable.harmReduceRate = skillAddRate.harmReduce + unionBossHarmReduceAdd
  buddhaDataTable.resBack = buddhaDataTable.resBack + skillAddNum.resBack
  buddhaDataTable.resStun = buddhaDataTable.resStun + skillAddNum.resStun
  buddhaDataTable.resStone = buddhaDataTable.resStone + skillAddNum.resStone
  buddhaDataTable.resRebel = buddhaDataTable.resRebel + skillAddNum.resRebel
  buddhaDataTable.resChange = buddhaDataTable.resChange + skillAddNum.resChange
  buddhaDataTable.resPalsy = buddhaDataTable.resPalsy + skillAddNum.resPalsy
  buddhaDataTable.resFreeze = buddhaDataTable.resFreeze + skillAddNum.resFreeze
  buddhaDataTable.resBurn = buddhaDataTable.resBurn + skillAddNum.resBurn
  buddhaDataTable.resPoison = buddhaDataTable.resPoison + skillAddNum.resPoison
  buddhaDataTable.resSilence = buddhaDataTable.resSilence + skillAddNum.resSilence
  buddhaDataTable.resAll = buddhaDataTable.resAll + skillAddNum.resAll
  local equipmentDataAdd1 = DataUtils.getEquipmentDataAdd(buddhaDataTable.equipmentList[1], userEquipments)
  local equipmentDataAdd2 = DataUtils.getEquipmentDataAdd(buddhaDataTable.equipmentList[2], userEquipments)
  local equipmentDataAdd3 = DataUtils.getEquipmentDataAdd(buddhaDataTable.equipmentList[3], userEquipments)
  local equipmentDataAdd4 = DataUtils.getEquipmentDataAdd(buddhaDataTable.equipmentList[4], userEquipments)
  local equipmentDataAdd = {
    equipmentDataAdd1,
    equipmentDataAdd2,
    equipmentDataAdd3,
    equipmentDataAdd4
  }
  for i = 1, #equipmentDataAdd do
    local data = equipmentDataAdd[i]
    life = math.round(life + data.life)
    attack = math.round(attack + data.attack)
    phyDefence = math.round(phyDefence + data.phyDef)
    magDefence = math.round(magDefence + data.magDef)
    buddhaDataTable.propGold = buddhaDataTable.propGold + data.gold
    buddhaDataTable.propWood = buddhaDataTable.propWood + data.wood
    buddhaDataTable.propWater = buddhaDataTable.propWater + data.water
    buddhaDataTable.propFire = buddhaDataTable.propFire + data.fire
    buddhaDataTable.propEarth = buddhaDataTable.propEarth + data.earth
    buddhaDataTable.propAllElements = buddhaDataTable.propAllElements + data.allElements
    buddhaDataTable.critRate = buddhaDataTable.critRate + data.critRate
    buddhaDataTable.decritRate = buddhaDataTable.decritRate + data.decritRate
    buddhaDataTable.critHarmRate = buddhaDataTable.critHarmRate + data.critHarmRate
    buddhaDataTable.decritHarmRate = buddhaDataTable.decritHarmRate + data.decritHarmRate
    buddhaDataTable.hitRate = buddhaDataTable.hitRate + data.hit
    buddhaDataTable.missRate = buddhaDataTable.missRate + data.miss
    buddhaDataTable.harmReduce = buddhaDataTable.harmReduce + data.harmReduce
  end
  local suitDataAdd = DataUtils.getEquipmentSuitAdd(buddhaDataTable.equipmentList, userEquipments)
  life = math.round(life + suitDataAdd.life)
  attack = math.round(attack + suitDataAdd.attack)
  phyDefence = math.round(phyDefence + suitDataAdd.phyDef)
  magDefence = math.round(magDefence + suitDataAdd.magDef)
  buddhaDataTable.propGold = buddhaDataTable.propGold + suitDataAdd.gold
  buddhaDataTable.propWood = buddhaDataTable.propWood + suitDataAdd.wood
  buddhaDataTable.propWater = buddhaDataTable.propWater + suitDataAdd.water
  buddhaDataTable.propFire = buddhaDataTable.propFire + suitDataAdd.fire
  buddhaDataTable.propEarth = buddhaDataTable.propEarth + suitDataAdd.earth
  buddhaDataTable.propAllElements = buddhaDataTable.propAllElements + suitDataAdd.allElements
  buddhaDataTable.critRate = buddhaDataTable.critRate + suitDataAdd.critRate
  buddhaDataTable.decritRate = buddhaDataTable.decritRate + suitDataAdd.decritRate
  buddhaDataTable.critHarmRate = buddhaDataTable.critHarmRate + suitDataAdd.critHarmRate
  buddhaDataTable.decritHarmRate = buddhaDataTable.decritHarmRate + suitDataAdd.decritHarmRate
  buddhaDataTable.hitRate = buddhaDataTable.hitRate + suitDataAdd.hit
  buddhaDataTable.missRate = buddhaDataTable.missRate + suitDataAdd.miss
  buddhaDataTable.harmReduce = buddhaDataTable.harmReduce + suitDataAdd.harmReduce
  local skillCE = DataUtils.getSkillCE(buddhaDataTable.totalSkills, buddhaDataTable.npcId, buddhaDataTable.skillLevels)
  local num1 = life * 0.1 + attack + (phyDefence + magDefence) * 4
  local num2 = buddhaDataTable.phyDefIgnore + buddhaDataTable.magDefIgnore
  local num3 = (buddhaDataTable.hitRate - 100 + buddhaDataTable.missRate + buddhaDataTable.critRate + buddhaDataTable.decritRate + buddhaDataTable.critHarmRate + buddhaDataTable.decritHarmRate - 150) * 10
  buddhaDataTable.attackAssessment = math.round(num1 + num2 + num3) + skillCE
  buddhaDataTable.life = life
  buddhaDataTable.attack = attack
  buddhaDataTable.phyDefence = phyDefence
  buddhaDataTable.magDefence = magDefence
  local cdTime = tonumber(buddhaInfo.CD)
  local cimeliaData = DataUtils.getDefCimeliaInfo(CloudData.ENEMY_CIMELIA_INFO.defCimelia)
  if cimeliaData then
    cdTime = cdTime * (1 + cimeliaData.buddhaCDtime / 100)
  end
  buddhaDataTable.cdTime = cdTime > tonumber(buddhaInfo.MinCD) and cdTime or tonumber(buddhaInfo.MinCD)
  
  local function getModelId(str)
    local tb = {}
    tb.lv = split(str, ",")[1]
    tb.modelId = split(str, ",")[2]
    return tb
  end
  
  local modelId
  for i = 1, #buddhaDataTable.modelID do
    local tb = getModelId(buddhaDataTable.modelID[i])
    if buddhaDataTable.level >= tonumber(tb.lv) then
      modelId = tb.modelId
    end
  end
  local buddhaModelInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_MODEL_INFO, "id", tostring(modelId))[1]
  if not buddhaModelInfo then
    DDERROR("buddhaId : %d,modeId : %d with error data", buddhaDataTable.npcId, modelId)
    return
  end
  buddhaDataTable.npcModelId = modelId
  buddhaDataTable.npcName = buddhaModelInfo.Name
  buddhaDataTable.npcIcon = buddhaModelInfo.icon
  buddhaDataTable.npcDesc = buddhaModelInfo.npcDesc
  buddhaDataTable.armatureFile = buddhaModelInfo.hurtFrame
  buddhaDataTable.standFrame = buddhaModelInfo.standFrame
  buddhaDataTable.attackFrequency = buddhaDataTable.attackFrequency + tonumber(buddhaModelInfo.attackFrequencyB)
  buddhaDataTable.attackDistance = tonumber(buddhaModelInfo.AttackDistance)
  buddhaDataTable.attackTime = tonumber(buddhaModelInfo.attackTime)
  buddhaDataTable.soundFile = buddhaModelInfo.soundFile
  buddhaDataTable.upMove = tonumber(buddhaModelInfo.upMove)
  buddhaDataTable.sizeInBattle = tonumber(buddhaModelInfo.sizeInBattle)
  buddhaDataTable.zoomMultiple = tonumber(buddhaModelInfo.zoomMultiple)
  buddhaDataTable.isRebel = tonumber(buddhaModelInfo.isRebel)
  buddhaDataTable.hurtSpeed = tonumber(buddhaModelInfo.hurtspeed)
  buddhaDataTable.tagType = tonumber(buddhaModelInfo.isShooter)
  buddhaDataTable.orignWidth = tonumber(buddhaModelInfo.orignWidth)
  buddhaDataTable.orignHeight = tonumber(buddhaModelInfo.orignHeight)
  buddhaDataTable.sizeInBattle = tonumber(buddhaModelInfo.sizeInBattle)
  buddhaDataTable.zoomMultiple = tonumber(buddhaModelInfo.zoomMultiple)
  buddhaDataTable.isRebel = tonumber(buddhaModelInfo.isRebel)
  buddhaDataTable.hurtSpeed = tonumber(buddhaModelInfo.hurtspeed)
  buddhaDataTable.tagType = tonumber(buddhaModelInfo.isShooter)
  buddhaDataTable.orignWidth = tonumber(buddhaModelInfo.orignWidth)
  buddhaDataTable.orignHeight = tonumber(buddhaModelInfo.orignHeight)
  buddhaDataTable.attackPreTime = tonumber(buddhaModelInfo.attackPreTime)
  buddhaDataTable.attackColdTime = tonumber(buddhaModelInfo.attackColdTime)
  buddhaDataTable.hurtColdTime = tonumber(buddhaModelInfo.hurtColdTime)
  buddhaDataTable.skillTimeParam = {}
  for i = 1, 4 do
    local param = {}
    param.preTime = tonumber(buddhaModelInfo["skillPreTime" .. i] or 0) or 0
    local completeTime = tonumber(buddhaModelInfo["skillColdTime" .. i] or 0)
    param.coldTime = completeTime - param.preTime
    table.insert(buddhaDataTable.skillTimeParam, param)
  end
  return buddhaDataTable
end

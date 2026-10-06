function DataUtils.getBuddhaModel(index, isIndex)
  local buddhaInfo
  
  if isIndex then
    buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "id", tostring(index))[1]
  else
    buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(index))[1]
  end
  if not buddhaInfo then
    DDLOG("buddhaInfo index : %d with error data", tonumber(index))
    return
  end
  local buddhaDataTable = {}
  buddhaDataTable.npcId = tonumber(buddhaInfo.buddhaID)
  buddhaDataTable.modelID = split(buddhaInfo.ModelId, ";")
  buddhaDataTable.npcSkill = split(buddhaInfo.Skill, ";")
  buddhaDataTable.awakeSkill = split(buddhaInfo.arousalSkill, ";")
  buddhaDataTable.npcFate = split(buddhaInfo.fateId, ";")
  buddhaDataTable.manualPriority = tonumber(buddhaInfo.manualPriority)
  buddhaDataTable.consume = tonumber(buddhaInfo.Consume)
  buddhaDataTable.baseCD = tonumber(buddhaInfo.CD)
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
  buddhaDataTable.tag1 = tonumber(buddhaInfo.tag1)
  buddhaDataTable.tag2 = tonumber(buddhaInfo.tag2)
  buddhaDataTable.tag3 = tonumber(buddhaInfo.tag3)
  buddhaDataTable.balance = tonumber(buddhaInfo.balance)
  buddhaDataTable.restrainType = tonumber(buddhaInfo.restrainType)
  buddhaDataTable.buddhaType = tonumber(buddhaInfo.buddhaType)
  buddhaDataTable.quality = tonumber(buddhaInfo.quality)
  buddhaDataTable.attackType = tonumber(buddhaInfo.AttackType)
  buddhaDataTable.symbol = tonumber(buddhaInfo.symbol)
  buddhaDataTable.element = tonumber(buddhaInfo.element)
  buddhaDataTable.sex = tonumber(buddhaInfo.sex)
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
  local baseStar = tonumber(buddhaInfo.BornStar)
  if not CloudData.NPC_INFO[buddhaDataTable.npcId] then
    local param = {}
    for i = 1, #buddhaDataTable.npcSkill do
      param[buddhaDataTable.npcSkill[i]] = 0
    end
    CloudData.NPC_INFO[buddhaDataTable.npcId] = {
      level = 1,
      id = 0,
      status = 0,
      star = 0,
      skills = param,
      arousals = {},
      equipments = {
        0,
        0,
        0,
        0
      }
    }
  end
  buddhaDataTable.level = CloudData.NPC_INFO[buddhaDataTable.npcId].level
  buddhaDataTable.buddhaState = CloudData.NPC_INFO[buddhaDataTable.npcId].status
  buddhaDataTable.starLevel = CloudData.NPC_INFO[buddhaDataTable.npcId].star
  buddhaDataTable.skillInfoTable = CloudData.NPC_INFO[buddhaDataTable.npcId].skills
  buddhaDataTable.arousalsInfoTable = CloudData.NPC_INFO[buddhaDataTable.npcId].arousals
  buddhaDataTable.equipmentList = CloudData.NPC_INFO[buddhaDataTable.npcId].equipments or {
    0,
    0,
    0,
    0
  }
  buddhaDataTable.inTask = CloudData.NPC_INFO[buddhaDataTable.npcId].inTask or 0
  if tonumber(buddhaDataTable.level) > Const.MAX_LEVEL then
    buddhaDataTable.level = Const.MAX_LEVEL
  end
  if tonumber(buddhaDataTable.starLevel) > Const.MAX_STAR then
    buddhaDataTable.starLevel = Const.MAX_STAR
  end
  local pieceData = DataUtils.getItemModel(buddhaInfo.PieceID)
  buddhaDataTable.pieceID = tonumber(buddhaInfo.PieceID)
  buddhaDataTable.pieceQuality = pieceData.quality
  buddhaDataTable.pieceIcon = pieceData.itemIcon
  buddhaDataTable.currPieceNum = pieceData.currNum
  local summonNum = {
    10,
    30,
    60,
    110,
    190,
    340
  }
  local advanceNum = {
    20,
    30,
    50,
    80,
    150
  }
  buddhaDataTable.summonCostNum = summonNum[baseStar + 1]
  buddhaDataTable.advanceCostNum = advanceNum[buddhaDataTable.starLevel + 1] or 0
  local totalSkills = {}
  local skillLevels = {}
  for k, v in pairs(buddhaDataTable.skillInfoTable) do
    table.insert(totalSkills, k)
    table.insert(skillLevels, tonumber(v))
  end
  for k, v in pairs(buddhaDataTable.arousalsInfoTable) do
    table.insert(totalSkills, k)
    table.insert(skillLevels, v.level)
  end
  buddhaDataTable.totalSkills = totalSkills
  buddhaDataTable.skillLevels = skillLevels
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
  local fateAdd1, fateAdd2 = DataUtils.getFatePropertyAdd(buddhaDataTable.npcId, buddhaDataTable.npcFate)
  local teamStarAdd = DataUtils.getTeamStarFateAdd(buddhaDataTable.npcId)
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
  for k, v in pairs(buddhaDataTable.skillInfoTable) do
    if v and tonumber(v) > 0 then
      local skillAddTable1, skillAddTable2 = DataUtils.getPropertiesOfSkillAdd(k, buddhaDataTable.npcId)
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
  for k, v in pairs(buddhaDataTable.arousalsInfoTable) do
    local skillAddTable1, skillAddTable2 = DataUtils.getPropertiesOfSkillAdd(k, nil, v.level)
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
  local treasureLifeAdd = DataUtils.getTreasureIncRate(5)
  local treasureAttackAdd = DataUtils.getTreasureIncRate(8)
  local treasureMagAtkAdd = DataUtils.getTreasureIncRate(9)
  local treasurePhyDefAdd = DataUtils.getTreasureIncRate(10)
  local treasurePhyAtkAdd = DataUtils.getTreasureIncRate(11)
  local treasureMagDefAdd = DataUtils.getTreasureIncRate(12)
  local treasureHitAdd = DataUtils.getTreasureIncRate(13)
  local unionBossAttackAdd = DataUtils.getUnionBossSkillAdd(2)
  local unionBossLifeAdd = DataUtils.getUnionBossSkillAdd(3)
  local unionBossHarmReduceAdd = DataUtils.getUnionBossSkillAdd(4)
  local unionBossHarmAddAdd = DataUtils.getUnionBossSkillAdd(5)
  life1 = math.round((life + skillAddNum.life + teamStarAdd.life) * (100 + skillAddRate.life + treasureLifeAdd + unionBossLifeAdd) / 100)
  attack1 = math.round((attack + skillAddNum.attack + teamStarAdd.attack) * (100 + skillAddRate.attack + treasureAttackAdd + unionBossAttackAdd) / 100)
  phyDefence1 = math.round((phyDefence + skillAddNum.phyDef + teamStarAdd.phyDef) * (100 + skillAddRate.phyDef + treasurePhyDefAdd) / 100)
  magDefence1 = math.round((magDefence + skillAddNum.magDef + teamStarAdd.magDef) * (100 + skillAddRate.magDef + treasureMagDefAdd) / 100)
  buddhaDataTable.hitRate1 = math.round(buddhaDataTable.hitRate + skillAddNum.hit + braakData.hit + treasureHitAdd)
  buddhaDataTable.missRate1 = math.round(buddhaDataTable.missRate + skillAddNum.miss + braakData.miss)
  buddhaDataTable.critRate1 = math.round(buddhaDataTable.critRate + skillAddNum.crit + braakData.crit)
  buddhaDataTable.decritRate1 = math.round(buddhaDataTable.decritRate + skillAddNum.decrit + braakData.decrit)
  buddhaDataTable.critHarmRate1 = math.round(buddhaDataTable.critHarmRate + skillAddNum.critHarm + braakData.critHarm)
  buddhaDataTable.decritHarmRate1 = math.round(buddhaDataTable.decritHarmRate + skillAddNum.decritHarm + braakData.decritHarm)
  life = math.round((life + fateAdd1.life + skillAddNum.life + teamStarAdd.life) * (100 + fateAdd2.life + skillAddRate.life + treasureLifeAdd + unionBossLifeAdd) / 100)
  attack = math.round((attack + fateAdd1.atk + skillAddNum.attack + teamStarAdd.attack) * (100 + fateAdd2.atk + skillAddRate.attack + treasureAttackAdd + unionBossAttackAdd) / 100)
  phyDefence = math.round((phyDefence + fateAdd1.phyDef + skillAddNum.phyDef + teamStarAdd.phyDef) * (100 + fateAdd2.phyDef + skillAddRate.phyDef + treasurePhyDefAdd) / 100)
  magDefence = math.round((magDefence + fateAdd1.magDef + skillAddNum.magDef + teamStarAdd.magDef) * (100 + fateAdd2.magDef + skillAddRate.magDef + treasureMagDefAdd) / 100)
  buddhaDataTable.hitRate = math.round(buddhaDataTable.hitRate + fateAdd2.hit + skillAddNum.hit + braakData.hit + treasureHitAdd)
  buddhaDataTable.missRate = math.round(buddhaDataTable.missRate + fateAdd2.miss + skillAddNum.miss + braakData.miss)
  buddhaDataTable.critRate = math.round(buddhaDataTable.critRate + fateAdd2.crit + skillAddNum.crit + braakData.crit)
  buddhaDataTable.decritRate = math.round(buddhaDataTable.decritRate + fateAdd2.decrit + skillAddNum.decrit + braakData.decrit)
  buddhaDataTable.critHarmRate = math.round(buddhaDataTable.critHarmRate + fateAdd2.critHarm + skillAddNum.critHarm + braakData.critHarm)
  buddhaDataTable.decritHarmRate = math.round(buddhaDataTable.decritHarmRate + fateAdd2.decritHarm + skillAddNum.decritHarm + braakData.decritHarm)
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
  local equipmentDataAdd1 = DataUtils.getEquipmentDataAdd(buddhaDataTable.equipmentList[1])
  local equipmentDataAdd2 = DataUtils.getEquipmentDataAdd(buddhaDataTable.equipmentList[2])
  local equipmentDataAdd3 = DataUtils.getEquipmentDataAdd(buddhaDataTable.equipmentList[3])
  local equipmentDataAdd4 = DataUtils.getEquipmentDataAdd(buddhaDataTable.equipmentList[4])
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
  local suitDataAdd = DataUtils.getEquipmentSuitAdd(buddhaDataTable.equipmentList)
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
  local num4 = buddhaDataTable.propGold + buddhaDataTable.propWood + buddhaDataTable.propWater + buddhaDataTable.propFire + buddhaDataTable.propEarth + buddhaDataTable.propAllElements * 5
  buddhaDataTable.attackAssessment = math.round(num1 + num2 + num3 + num4) + skillCE
  local num11 = life1 * 0.1 + attack1 + (phyDefence1 + magDefence1) * 4
  local num21 = buddhaDataTable.phyDefIgnore + buddhaDataTable.magDefIgnore
  local num31 = (buddhaDataTable.hitRate1 - 100 + buddhaDataTable.missRate1 + buddhaDataTable.critRate1 + buddhaDataTable.decritRate1 + buddhaDataTable.critHarmRate1 + buddhaDataTable.decritHarmRate1 - 150) * 10
  local CE1 = math.round(num11 + num21 + num31 + num4) + skillCE
  buddhaDataTable.fateCE = buddhaDataTable.attackAssessment - CE1
  buddhaDataTable.life = life
  buddhaDataTable.attack = attack
  buddhaDataTable.phyDefence = phyDefence
  buddhaDataTable.magDefence = magDefence
  local breakTimes = math.ceil((buddhaDataTable.level + 1) / 10)
  buddhaDataTable.addLife = buddhaDataTable.lifeParamK * breakTimes
  buddhaDataTable.addAttack = buddhaDataTable.attackParamK * breakTimes
  buddhaDataTable.addPhyDefence = buddhaDataTable.phyDefenceParamK * breakTimes
  buddhaDataTable.addMagDefence = buddhaDataTable.magDefenceParamK * breakTimes
  buddhaDataTable.upgradeCostNum = math.floor(((31 + buddhaDataTable.level) ^ 4 / 3000 + 500) / 50) * 50
  local cdTime = tonumber(buddhaInfo.CD)
  local cimeliaData = DataUtils.getDefCimeliaInfo()
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
  buddhaDataTable.soundSkillFile = split(buddhaModelInfo.skillsound, ";")
  buddhaDataTable.buddhaSound = buddhaModelInfo.buddhaSound
  buddhaDataTable.upMove = tonumber(buddhaModelInfo.upMove)
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

function DataUtils.getModelForPVPOnline(modelType, npcId)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(npcId))[1]
  if not buddhaInfo then
    DDLOG("buddhaInfo index : %d with error data", tonumber(npcId))
    return
  end
  local buddhaDataTable = {}
  buddhaDataTable.npcId = tonumber(buddhaInfo.buddhaID)
  buddhaDataTable.modelID = split(buddhaInfo.ModelId, ";")
  buddhaDataTable.npcFate = split(buddhaInfo.fateId, ";")
  buddhaDataTable.consume = tonumber(buddhaInfo.Consume)
  buddhaDataTable.baseCD = tonumber(buddhaInfo.CD)
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
  buddhaDataTable.buddhaType = tonumber(buddhaInfo.buddhaType)
  buddhaDataTable.quality = tonumber(buddhaInfo.quality)
  buddhaDataTable.attackType = tonumber(buddhaInfo.AttackType)
  buddhaDataTable.spiritByKill = tonumber(buddhaInfo.Spirit)
  buddhaDataTable.force = tonumber(buddhaInfo.force)
  buddhaDataTable.attackFrequency = 0
  buddhaDataTable.symbol = tonumber(buddhaInfo.symbol)
  buddhaDataTable.element = tonumber(buddhaInfo.element)
  buddhaDataTable.sex = tonumber(buddhaInfo.sex)
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
  local npcInfo = {}
  local treasureList, cimeliaDef, teamInfo, unionBossInfo, userEquipments
  if "buddha" == modelType then
    npcInfo = CloudData.BUDDHA_NPC_INFO
    treasureList = CloudData.BUDDHA_TREASURE_INFO
    cimeliaAtk = CloudData.BUDDHA_CIMELIA_INFO.atkCimelia
    cimeliaDef = CloudData.BUDDHA_CIMELIA_INFO.defCimelia
    teamInfo = {
      mainTeam = CloudData.BUDDHA_ATTACK_TEAM,
      assistTeam = CloudData.BUDDHA_ASSIST_TEAM
    }
    unionBossInfo = CloudData.BUDDHA_UNION_BOSS
    userEquipments = CloudData.BUDDHA_EQUIPMENTS
  else
    npcInfo = CloudData.ENEMY_NPC_INFO
    treasureList = CloudData.ENEMY_TREASURE_INFO
    cimeliaAtk = CloudData.ENEMY_CIMELIA_INFO.atkCimelia
    cimeliaDef = CloudData.ENEMY_CIMELIA_INFO.defCimelia
    teamInfo = {
      mainTeam = CloudData.ENEMY_ATTACK_TEAM,
      assistTeam = CloudData.ENEMY_ASSIST_TEAM
    }
    unionBossInfo = CloudData.ENEMY_UNION_BOSS
    userEquipments = CloudData.ENEMY_EQUIPMENTS
  end
  if not npcInfo[tostring(npcId)] then
    dump(CloudData.BUDDHA_NPC_INFO)
    dump(CloudData.ENEMY_NPC_INFO)
    DDERROR("%s : %d with error data", modelType, tonumber(npcId))
    return
  end
  buddhaDataTable.level = npcInfo[tostring(npcId)].level
  buddhaDataTable.starLevel = npcInfo[tostring(npcId)].star
  buddhaDataTable.equipmentList = npcInfo[tostring(npcId)].equipments or {
    0,
    0,
    0,
    0
  }
  buddhaDataTable.npcSkill = {}
  buddhaDataTable.totalSkills = {}
  buddhaDataTable.skillLevels = {}
  local realLevel = npcInfo[tostring(npcId)].realLevel or buddhaDataTable.level
  local skillInfo = npcInfo[tostring(npcId)].skills
  local awakeSkills = npcInfo[tostring(npcId)].arousals
  for k, v in pairs(skillInfo) do
    table.insert(buddhaDataTable.npcSkill, tostring(k))
    table.insert(buddhaDataTable.totalSkills, tostring(k))
    table.insert(buddhaDataTable.skillLevels, tonumber(v))
  end
  for k, v in pairs(awakeSkills) do
    table.insert(buddhaDataTable.totalSkills, tostring(k))
    table.insert(buddhaDataTable.skillLevels, v.level)
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
  local teamStarAdd = DataUtils.getTeamStarFateAdd(buddhaDataTable.npcId, teamInfo, npcInfo)
  local fateAdd1, fateAdd2 = DataUtils.getFatePropertyAdd(buddhaDataTable.npcId, buddhaDataTable.npcFate, teamInfo, npcInfo)
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
  local treasureLifeAdd = DataUtils.getTreasureIncRate(5, treasureList)
  local treasureAttackAdd = DataUtils.getTreasureIncRate(8, treasureList)
  local treasureMagAtkAdd = DataUtils.getTreasureIncRate(9, treasureList)
  local treasurePhyDefAdd = DataUtils.getTreasureIncRate(10, treasureList)
  local treasurePhyAtkAdd = DataUtils.getTreasureIncRate(11, treasureList)
  local treasureMagDefAdd = DataUtils.getTreasureIncRate(12, treasureList)
  local treasureHitAdd = DataUtils.getTreasureIncRate(13, treasureList)
  local unionBossAttackAdd = DataUtils.getUnionBossSkillAdd(2, unionBossInfo)
  local unionBossLifeAdd = DataUtils.getUnionBossSkillAdd(3, unionBossInfo)
  local unionBossHarmReduceAdd = DataUtils.getUnionBossSkillAdd(4, unionBossInfo)
  local unionBossHarmAddAdd = DataUtils.getUnionBossSkillAdd(5, unionBossInfo)
  life = math.round((life + fateAdd1.life + skillAddNum.life + teamStarAdd.life) * (100 + fateAdd2.life + skillAddRate.life + treasureLifeAdd + unionBossLifeAdd) / 100)
  attack = math.round((attack + fateAdd1.atk + skillAddNum.attack + teamStarAdd.attack) * (100 + fateAdd2.atk + skillAddRate.attack + treasureAttackAdd + unionBossAttackAdd) / 100)
  phyDefence = math.round((phyDefence + fateAdd1.phyDef + skillAddNum.phyDef + teamStarAdd.phyDef) * (100 + fateAdd2.phyDef + skillAddRate.phyDef + treasurePhyDefAdd) / 100)
  magDefence = math.round((magDefence + fateAdd1.magDef + skillAddNum.magDef + teamStarAdd.magDef) * (100 + fateAdd2.magDef + skillAddRate.magDef + treasureMagDefAdd) / 100)
  buddhaDataTable.hitRate = math.round(buddhaDataTable.hitRate + fateAdd2.hit + skillAddNum.hit + braakData.hit + treasureHitAdd)
  buddhaDataTable.missRate = math.round(buddhaDataTable.missRate + fateAdd2.miss + skillAddNum.miss + braakData.miss)
  buddhaDataTable.critRate = math.round(buddhaDataTable.critRate + fateAdd2.crit + skillAddNum.crit + braakData.crit)
  buddhaDataTable.decritRate = math.round(buddhaDataTable.decritRate + fateAdd2.decrit + skillAddNum.decrit + braakData.decrit)
  buddhaDataTable.critHarmRate = math.round(buddhaDataTable.critHarmRate + fateAdd2.critHarm + skillAddNum.critHarm + braakData.critHarm)
  buddhaDataTable.decritHarmRate = math.round(buddhaDataTable.decritHarmRate + fateAdd2.decritHarm + skillAddNum.decritHarm + braakData.decritHarm)
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
  if 9 == GameManager.MODE and "enemy" == modelType and CloudData.AI_ENHANCE_PARAMS then
    life = life * CloudData.AI_ENHANCE_PARAMS.life
    attack = attack * CloudData.AI_ENHANCE_PARAMS.attack
    phyDefence = phyDefence * CloudData.AI_ENHANCE_PARAMS.physicalDef
    magDefence = magDefence * CloudData.AI_ENHANCE_PARAMS.magicDef
    local tFunc = {
      [1] = function(param)
        buddhaDataTable.propGold = buddhaDataTable.propGold + param
      end,
      [2] = function(param)
        buddhaDataTable.propWood = buddhaDataTable.propWood + param
      end,
      [3] = function(param)
        buddhaDataTable.propWater = buddhaDataTable.propWater + param
      end,
      [4] = function(param)
        buddhaDataTable.propFire = buddhaDataTable.propFire + param
      end,
      [5] = function(param)
        buddhaDataTable.propEarth = buddhaDataTable.propEarth + param
      end
    }
    tFunc[buddhaDataTable.element](CloudData.AI_ENHANCE_PARAMS.mainWuxing)
    buddhaDataTable.propAllElements = buddhaDataTable.propAllElements + CloudData.AI_ENHANCE_PARAMS.elseWuxing
    buddhaDataTable.critRate = buddhaDataTable.critRate + CloudData.AI_ENHANCE_PARAMS.critRate
    buddhaDataTable.critHarmRate = buddhaDataTable.critHarmRate + CloudData.AI_ENHANCE_PARAMS.critHurt
    buddhaDataTable.hitRate = buddhaDataTable.hitRate + CloudData.AI_ENHANCE_PARAMS.hitRate
    buddhaDataTable.missRate = buddhaDataTable.missRate + CloudData.AI_ENHANCE_PARAMS.dodge
    buddhaDataTable.decritRate = buddhaDataTable.decritRate + CloudData.AI_ENHANCE_PARAMS.critMiss
    buddhaDataTable.decritHarmRate = buddhaDataTable.decritHarmRate + CloudData.AI_ENHANCE_PARAMS.critReduce
    buddhaDataTable.harmReduce = buddhaDataTable.harmReduce + CloudData.AI_ENHANCE_PARAMS.hurtReduce
  end
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
  local cimeliaData = DataUtils.getDefCimeliaInfo(cimeliaDef)
  if cimeliaData then
    cdTime = cdTime * (1 + cimeliaData.buddhaCDtime / 100)
  end
  buddhaDataTable.cdTime = cdTime > tonumber(buddhaInfo.MinCD) and cdTime or tonumber(buddhaInfo.MinCD)
  local cimeliaDataAtk = DataUtils.getAtkCimeliaInfo(cimeliaAtk)
  local treasureAdd = DataUtils.getTreasureIncRate(5, treasureList)
  if cimeliaDataAtk then
    buddhaDataTable.spiritByKill = math.round(buddhaDataTable.spiritByKill * (cimeliaDataAtk.spiritValue + treasureAdd) / 100)
  end
  
  local function getModelId(str)
    local tb = {}
    tb.lv = split(str, ",")[1]
    tb.modelId = split(str, ",")[2]
    return tb
  end
  
  local modelId
  for i = 1, #buddhaDataTable.modelID do
    local tb = getModelId(buddhaDataTable.modelID[i])
    if realLevel >= tonumber(tb.lv) then
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
  buddhaDataTable.armatureFile = buddhaModelInfo.hurtFrame
  buddhaDataTable.standFrame = buddhaModelInfo.standFrame
  buddhaDataTable.attackFrequency = buddhaDataTable.attackFrequency + tonumber(buddhaModelInfo.attackFrequencyB)
  buddhaDataTable.attackDistance = tonumber(buddhaModelInfo.AttackDistance)
  buddhaDataTable.attackTime = tonumber(buddhaModelInfo.attackTime)
  buddhaDataTable.soundFile = buddhaModelInfo.soundFile
  buddhaDataTable.soundSkillFile = split(buddhaModelInfo.skillsound, ";")
  buddhaDataTable.buddhaSound = buddhaModelInfo.buddhaSound
  buddhaDataTable.upMove = tonumber(buddhaModelInfo.upMove)
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

function DataUtils.getBuddhaModelForAI(buddhaId)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(buddhaId))[1]
  if not buddhaInfo then
    DDLOG("buddhaInfo index : %d with error data", tonumber(index))
    return
  end
  local data = {}
  data.buddhaId = tonumber(buddhaInfo.buddhaID)
  data.aiTags = buddhaInfo.aiType
  data.cost = tonumber(buddhaInfo.Consume)
  local cdTime = tonumber(buddhaInfo.CD)
  if GameData.CIMELIA_DEF_ENEMY then
    cdTime = cdTime * (1 + GameData.CIMELIA_DEF_ENEMY.buddhaCDtime / 100)
  end
  data.cdTime = cdTime > tonumber(buddhaInfo.MinCD) and cdTime or tonumber(buddhaInfo.MinCD)
  return data
end

function DataUtils.getBuddhaModelBaseInfo(buddhaId_, buddhaLevel_)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(buddhaId_))[1]
  local modelIdTable = split(buddhaInfo.ModelId, ";")
  local modelId = 0
  local buddhaData = {}
  local npcSkill = split(buddhaInfo.Skill, ";")
  local buddhaLevel = 0
  if not CloudData.NPC_INFO[tonumber(buddhaId_)] then
    local param = {}
    for i = 1, #npcSkill do
      param[npcSkill[i]] = 0
    end
    CloudData.NPC_INFO[tonumber(buddhaId_)] = {
      level = 1,
      id = tonumber(buddhaId_),
      status = 0,
      star = 0,
      skills = param,
      arousals = {}
    }
  end
  if buddhaLevel_ then
    buddhaLevel = buddhaLevel_
  else
    buddhaLevel = CloudData.NPC_INFO[tonumber(buddhaId_)].level
  end
  
  local function getModelId(str)
    local tb = {}
    tb.lv = split(str, ",")[1]
    tb.modelId = split(str, ",")[2]
    return tb
  end
  
  for i = 1, #modelIdTable do
    local tb = getModelId(modelIdTable[i])
    if buddhaLevel >= tonumber(tb.lv) then
      modelId = tb.modelId
    end
  end
  local buddhaModelInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_MODEL_INFO, "id", tostring(modelId))[1]
  if not buddhaModelInfo then
    DDERROR("buddha model id : %d with error data", tonumber(modelId))
  end
  buddhaData.name = buddhaModelInfo.Name
  buddhaData.icon = buddhaModelInfo.icon
  buddhaData.state = CloudData.NPC_INFO[tonumber(buddhaId_)].status or 0
  buddhaData.quality = tonumber(buddhaInfo.quality)
  buddhaData.isRebel = tonumber(buddhaModelInfo.isRebel)
  return buddhaData
end

function DataUtils.getBuddhaInfoForWiki(index)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "id", tostring(index))[1]
  if not buddhaInfo then
    DDLOG("buddhaInfo index : %d with error data", tonumber(index))
    return
  end
  local buddhaModelTable = {}
  local npcId = tonumber(buddhaInfo.buddhaID)
  local modelID = split(buddhaInfo.ModelId, ";")
  local skillTable = split(buddhaInfo.Skill, ";")
  
  local function getModelInfo(modelId, modelLevel)
    local buddhaModelInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_MODEL_INFO, "id", tostring(modelId))[1]
    if not buddhaModelInfo then
      DDERROR("buddhaId : %d,modeId : %d with error data", npcId, modelId)
      return
    end
    local buddhaDataTable = {}
    if not CloudData.NPC_INFO[npcId] then
      local param = {}
      for i = 1, #skillTable do
        param[skillTable[i]] = 0
      end
      CloudData.NPC_INFO[npcId] = {
        level = 1,
        id = 0,
        status = 0,
        star = 0,
        skills = param,
        arousals = {}
      }
    end
    local level = CloudData.NPC_INFO[npcId].level
    buddhaDataTable.npcId = npcId
    buddhaDataTable.starLevel = CloudData.NPC_INFO[npcId].star
    buddhaDataTable.status = 0
    buddhaDataTable.tag1 = tonumber(buddhaInfo.tag1)
    buddhaDataTable.tag2 = tonumber(buddhaInfo.tag2)
    buddhaDataTable.tag3 = tonumber(buddhaInfo.tag3)
    buddhaDataTable.quality = tonumber(buddhaInfo.quality)
    buddhaDataTable.element = tonumber(buddhaInfo.element)
    if 0 < CloudData.NPC_INFO[npcId].status and level >= tonumber(modelLevel) then
      buddhaDataTable.status = 1
    end
    buddhaDataTable.npcName = buddhaModelInfo.Name
    buddhaDataTable.npcIcon = buddhaModelInfo.icon
    buddhaDataTable.npcDesc = buddhaModelInfo.npcDesc
    buddhaDataTable.armatureFile = buddhaModelInfo.hurtFrame
    buddhaDataTable.attackTime = tonumber(buddhaModelInfo.attackTime)
    buddhaDataTable.upMove = tonumber(buddhaModelInfo.upMove)
    buddhaDataTable.zoomMultiple = tonumber(buddhaModelInfo.zoomMultiple)
    buddhaDataTable.isRebel = tonumber(buddhaModelInfo.isRebel)
    buddhaDataTable.buddhaSound = buddhaModelInfo.buddhaSound
    buddhaDataTable.modelId = modelId
    return buddhaDataTable
  end
  
  local function getModelId(str)
    local tb = {}
    tb.lv = split(str, ",")[1]
    tb.modelId = split(str, ",")[2]
    return tb
  end
  
  for i = 1, #modelID do
    local model = getModelId(modelID[i])
    buddhaModelTable[#buddhaModelTable + 1] = getModelInfo(model.modelId, model.lv)
  end
  return buddhaModelTable
end

function DataUtils.getBuddhaBaseData(buddhaId)
  local id = tonumber(buddhaId)
  local buddhaData = {}
  if not CloudData.NPC_INFO[id] then
    buddhaData.level = 1
    buddhaData.starLevel = 0
    return buddhaData
  end
  buddhaData.level = CloudData.NPC_INFO[id].level
  buddhaData.starLevel = CloudData.NPC_INFO[id].star
  return buddhaData
end

function DataUtils.getBuddhaIdsTableTeamScene()
  local tableNpc = {}
  for i, npcInfo in pairs(CloudData.NPC_INFO) do
    if 0 ~= npcInfo.status then
      tableNpc[#tableNpc + 1] = npcInfo.id
    end
  end
  
  local function tFuncComp(ta, tb)
    local lv1 = CloudData.NPC_INFO[ta].level
    local lv2 = CloudData.NPC_INFO[tb].level
    if lv1 < lv2 then
      return false
    elseif lv1 == lv2 then
      local buddhaInfo1 = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(ta))[1]
      local buddhaInfo2 = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(tb))[1]
      if tonumber(buddhaInfo1.manualPriority) <= tonumber(buddhaInfo2.manualPriority) then
        return false
      end
    end
    return true
  end
  
  table.sort(tableNpc, tFuncComp)
  return tableNpc
end

function DataUtils.getBuddhaInfoTableUpgradeScene()
  local tableNpcModel = {}
  local npcNumTotal = #DataRetainer.BUDDHA_INFO - 1
  local teamInfo = DataUtils.getBuddhaTableOnTeam()
  for id = 1, npcNumTotal do
    local model = DataUtils.getBuddhaModel(id, true)
    model.isOnTeam = 0
    local index = table.indexof(teamInfo, tostring(model.npcId))
    if index then
      model.isOnTeam = 1
    end
    tableNpcModel[#tableNpcModel + 1] = model
  end
  local tempTable1 = {}
  local tempTable2 = {}
  local tempTable3 = {}
  for i = 1, #tableNpcModel do
    local npcModel = tableNpcModel[i]
    if 0 == npcModel.buddhaState and npcModel.currPieceNum >= npcModel.summonCostNum then
      table.insert(tempTable1, npcModel)
    elseif 1 == npcModel.buddhaState or 2 == npcModel.buddhaState then
      table.insert(tempTable2, npcModel)
    else
      table.insert(tempTable3, npcModel)
    end
  end
  table.sort(tempTable1, function(v1, v2)
    return v1.manualPriority < v2.manualPriority
  end)
  table.sort(tempTable2, function(v1, v2)
    if v1.isOnTeam == v2.isOnTeam then
      if v1.level == v2.level then
        return v1.manualPriority < v2.manualPriority
      else
        return v1.level > v2.level
      end
    else
      return v1.isOnTeam > v2.isOnTeam
    end
  end)
  table.sort(tempTable3, function(v1, v2)
    if v1.currPieceNum == v2.currPieceNum then
      return v1.manualPriority < v2.manualPriority
    else
      return v1.currPieceNum > v2.currPieceNum
    end
  end)
  table.insertto(tempTable1, tempTable2)
  table.insertto(tempTable1, tempTable3)
  tableNpcModel = tempTable1
  return tableNpcModel
end

function DataUtils.getBuddhaIdsTableWikiScene()
  local tableNpcModel = {}
  local npcNumTotal = #DataRetainer.BUDDHA_INFO - 1
  for id = 1, npcNumTotal do
    local tb = DataUtils.getBuddhaInfoForWiki(id)
    table.insertto(tableNpcModel, tb)
  end
  return tableNpcModel
end

function DataUtils.getBuddhaListForEquipment()
  local tableNpc = {}
  local teamInfo = DataUtils.getBuddhaTableOnTeam()
  for i, npcInfo in pairs(CloudData.NPC_INFO) do
    if 0 ~= npcInfo.status then
      tableNpc[#tableNpc + 1] = npcInfo.id
    end
  end
  local tempList = {}
  for _, id in pairs(tableNpc) do
    local model = DataUtils.getBuddhaModel(id)
    model.isOnTeam = 0
    local index = table.indexof(teamInfo, tostring(id))
    if index then
      model.isOnTeam = 1
    end
    tempList[#tempList + 1] = model
  end
  table.sort(tempList, function(v1, v2)
    if v1.isOnTeam == v2.isOnTeam then
      if v1.level == v2.level then
        return v1.manualPriority < v2.manualPriority
      else
        return v1.level > v2.level
      end
    else
      return v1.isOnTeam > v2.isOnTeam
    end
  end)
  return tempList
end

function DataUtils.getBuddhaCostValue(buddhaId)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(buddhaId))[1]
  if not buddhaInfo then
    DDLOG("buddhaInfo index : %d with error data", tonumber(index))
    return
  end
  local costValue = tonumber(buddhaInfo.Consume)
  return costValue
end

function DataUtils.getBuddhaIdForFate(buddhaId)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(buddhaId))[1]
  if not buddhaInfo then
    DDLOG("buddhaInfo index : %d with error data", tonumber(index))
    return
  end
  local fateIds = split(buddhaInfo.fateId, ";")
  local buddhaIdTable = {}
  for i = 1, #fateIds do
    local fateId = fateIds[i]
    local fateInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_FATE_INFO, "fateId", tostring(fateId))[1]
    if not fateInfo then
      DDERROR("fate id : %d with error data", tonumber(fateId))
      return
    end
    if 1 == tonumber(fateInfo.fateType) then
      local buddhaIds = split(fateInfo.cond, ";")
      table.insertto(buddhaIdTable, buddhaIds)
    end
  end
  return buddhaIdTable
end

function DataUtils.getBuddhaFeatureInfo(buddhaId, level)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(buddhaId))[1]
  if not buddhaInfo then
    DDLOG("buddhaInfo index : %d with error data", tonumber(index))
    return
  end
  local buddhaDataTable = {}
  buddhaDataTable.tag1 = tonumber(buddhaInfo.tag1)
  buddhaDataTable.tag2 = tonumber(buddhaInfo.tag2)
  buddhaDataTable.tag3 = tonumber(buddhaInfo.tag3)
  buddhaDataTable.quality = tonumber(buddhaInfo.quality)
  local modelIDs = split(buddhaInfo.ModelId, ";")
  local modelId
  local buddhaLevel = checknumber(level)
  if buddhaLevel == 0 then
    buddhaLevel = 1
    if CloudData.NPC_INFO[tonumber(buddhaId)] then
      buddhaLevel = CloudData.NPC_INFO[tonumber(buddhaId)].level
    end
  end
  
  local function getModelId(str)
    local tb = {}
    tb.lv = split(str, ",")[1]
    tb.modelId = split(str, ",")[2]
    return tb
  end
  
  for i = 1, #modelIDs do
    local tb = getModelId(modelIDs[i])
    if buddhaLevel >= tonumber(tb.lv) then
      modelId = tb.modelId
    end
  end
  local buddhaModelInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_MODEL_INFO, "id", tostring(modelId))[1]
  if not buddhaModelInfo then
    DDERROR("buddhaId : %d,modeId : %d with error data", buddhaDataTable.npcId, modelId)
    return
  end
  buddhaDataTable.npcName = buddhaModelInfo.Name
  buddhaDataTable.npcIcon = buddhaModelInfo.icon
  buddhaDataTable.isRebel = tonumber(buddhaModelInfo.isRebel)
  return buddhaDataTable
end

function DataUtils.getAlreadyHaveNpcId(flag)
  local npcIdTable = DataUtils.getBuddhaIdsTableTeamScene()
  local countNum = 0
  for i, npcId in pairs(npcIdTable) do
    local buddhaModel = DataUtils.getBuddhaModel(npcId)
    if "BUDDHA" == flag then
      if buddhaModel.isRebel_ == "0" then
        countNum = countNum + 1
      end
    else
      if "MONSTER" == flag and buddhaModel.isRebel_ == "1" then
        countNum = countNum + 1
      else
      end
    end
  end
  return countNum
end

function DataUtils.getBuddhaModelPVP(buddhaId)
  local buddhaInfo = DataUtils.getBuddhaModel(buddhaId)
  local buddhaData = {}
  buddhaData.buddhaId = tonumber(buddhaId)
  buddhaData.cdTime = buddhaInfo.cdTime
  buddhaData.npcIcon = buddhaInfo.npcIcon
  buddhaData.quality = buddhaInfo.quality
  buddhaData.isRebel = buddhaInfo.isRebel
  buddhaData.level = buddhaInfo.level
  buddhaData.starLevel = buddhaInfo.starLevel
  buddhaData.consume = buddhaInfo.consume
  buddhaData.buddhaType = buddhaInfo.buddhaType
  buddhaData.attackType = buddhaInfo.attackType
  buddhaData.attackAssessment = buddhaInfo.attackAssessment
  buddhaData.fateCE = buddhaInfo.fateCE
  buddhaData.npcModelId = buddhaInfo.npcModelId
  buddhaData.buddhaSound = buddhaInfo.buddhaSound
  buddhaData.inTask = buddhaInfo.inTask or 0
  buddhaData.symbol = checknumber(buddhaInfo.symbol)
  return buddhaData
end

function DataUtils.getBuddhaModelPatrol(index, isIndex, level, star)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(index))[1]
  if not buddhaInfo then
    DDLOG("buddhaInfo index : %d with error data", checknumber(index))
    return
  end
  local buddhaDataTable = {}
  buddhaDataTable.npcId = checknumber(buddhaInfo.buddhaID)
  buddhaDataTable.consume = checknumber(buddhaInfo.Consume)
  buddhaDataTable.quality = checknumber(buddhaInfo.quality)
  buddhaDataTable.element = checknumber(buddhaInfo.element)
  buddhaDataTable.symbol = checknumber(buddhaInfo.symbol)
  buddhaDataTable.sex = checknumber(buddhaInfo.sex)
  local cloudInfo = CloudData.NPC_INFO[buddhaDataTable.npcId]
  buddhaDataTable.level = level or cloudInfo and cloudInfo.level or 1
  buddhaDataTable.starLevel = star or cloudInfo and cloudInfo.star or 0
  buddhaDataTable.inTask = cloudInfo and cloudInfo.inTask or 0
  if checknumber(buddhaDataTable.level) > Const.MAX_LEVEL then
    buddhaDataTable.level = Const.MAX_LEVEL
  end
  if checknumber(buddhaDataTable.starLevel) > Const.MAX_STAR then
    buddhaDataTable.starLevel = Const.MAX_STAR
  end
  
  local function getModelId(str)
    local tb = {}
    tb.lv = split(str, ",")[1]
    tb.modelId = split(str, ",")[2]
    return tb
  end
  
  local modelId
  local modelIDs = split(buddhaInfo.ModelId, ";")
  for i = 1, #modelIDs do
    local tb = getModelId(modelIDs[i])
    if buddhaDataTable.level >= checknumber(tb.lv) then
      modelId = tb.modelId
    end
  end
  local buddhaModelInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_MODEL_INFO, "id", tostring(modelId))[1]
  if not buddhaModelInfo then
    DDERROR("buddhaId : %d,modeId : %d with error data", buddhaDataTable.npcId, modelId)
    return
  end
  buddhaDataTable.npcIcon = buddhaModelInfo.icon
  buddhaDataTable.isRebel = checknumber(buddhaModelInfo.isRebel)
  buddhaDataTable.property = {}
  if buddhaDataTable.sex == 4 then
    buddhaDataTable.property["101"] = 1
    buddhaDataTable.property["102"] = 1
  elseif buddhaDataTable.sex == 1 or buddhaDataTable.sex == 2 then
    buddhaDataTable.property[checkstring(100 + buddhaDataTable.sex)] = 1
  end
  buddhaDataTable.property[checkstring(200 + buddhaDataTable.isRebel)] = 1
  buddhaDataTable.property[checkstring(300 + buddhaDataTable.element)] = 1
  buddhaDataTable.property[checkstring(400 + buddhaDataTable.symbol)] = 1
  local info = {
    ["100"] = "501",
    ["200"] = "502",
    ["300"] = "503",
    ["500"] = "504",
    ["800"] = "505",
    ["1350"] = "506"
  }
  local spirit = checkstring(info[checkstring(buddhaDataTable.consume)])
  buddhaDataTable.property[spirit] = 1
  buddhaDataTable.property["6"] = checkstring(600 + buddhaDataTable.quality)
  buddhaDataTable.property["7"] = checkstring(700 + buddhaDataTable.starLevel)
  buddhaDataTable.property["8"] = checkstring(800 + buddhaDataTable.level)
  return buddhaDataTable
end

function DataUtils.getBuddhaPropertyIcon(property)
  local pro = checknumber(property)
  if pro == 0 then
    return
  end
  local typeInfo = {
    [1] = "sex",
    [2] = "rebel",
    [3] = "element",
    [4] = "symbol",
    [5] = "consume",
    [6] = "quality",
    [7] = "star",
    [8] = "level"
  }
  local proType = math.floor(pro / 100)
  local proIndex = pro % 100
  local img = checkstring(typeInfo[proType])
  if img == "" then
    return
  end
  local icon = display.newSprite()
  icon.selected = false
  img = "union/patrol/property/" .. img
  if proType == 7 or proType == 8 then
    icon:setTexture(img .. "_01.png")
    local lab = DYLabelTTF.new({
      text = proIndex,
      size = 24,
      color = cc.c3b(224, 173, 171),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(120, 50, 50)
    }):align(display.CENTER, 23, 23):addTo(icon)
    icon.lab = lab
    if proType == 7 then
      lab:setPosition(33, 23)
    end
  else
    icon:setTexture(img .. proIndex .. "_01.png")
  end
  
  function icon.select()
    icon.selected = true
    if proType == 7 or proType == 8 then
      icon:setTexture(img .. "_02.png")
    else
      icon:setTexture(img .. proIndex .. "_02.png")
    end
    if icon.lab then
      icon.lab:setColor(cc.c3b(255, 255, 255))
    end
  end
  
  function icon.unselect()
    icon.selected = false
    if proType == 7 or proType == 8 then
      icon:setTexture(img .. "_01.png")
    else
      icon:setTexture(img .. proIndex .. "_01.png")
    end
    if icon.lab then
      icon.lab:setColor(cc.c3b(224, 173, 171))
    end
  end
  
  return icon
end

function DataUtils.getUserCountCE()
  local countCE = 0
  local buddhaCE = 0
  local teamInfo = DataUtils.getBuddhaTableOnTeam()
  for i = 1, #teamInfo do
    local id = teamInfo[i]
    if id ~= "" and id ~= nil then
      local buddhaModel = DataUtils.getBuddhaModel(id)
      buddhaCE = buddhaCE + buddhaModel.attackAssessment
    end
  end
  local cimeliaCE = DataUtils.getCimeliaCE()
  local countCE = buddhaCE + cimeliaCE
  return countCE
end

function DataUtils.getOtherPlayerTeamInfo(npcInfo)
  local buddhaId = npcInfo.buddhaId
  local level = npcInfo.level or 1
  local starLevel = npcInfo.star or 0
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(buddhaId))[1]
  if not buddhaInfo then
    DDLOG("buddhaInfo index : %d with error data", tonumber(index))
    return
  end
  local buddhaData = {}
  local modelIdTable = split(buddhaInfo.ModelId, ";")
  
  local function getModelId(str)
    local tb = {}
    tb.lv = split(str, ",")[1]
    tb.modelId = split(str, ",")[2]
    return tb
  end
  
  for i = 1, #modelIdTable do
    local tb = getModelId(modelIdTable[i])
    if level >= tonumber(tb.lv) then
      modelId = tb.modelId
    end
  end
  local buddhaModelInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_MODEL_INFO, "id", tostring(modelId))[1]
  if not buddhaModelInfo then
    DDERROR("buddha model id : %d with error data", tonumber(modelId))
  end
  buddhaData.name = buddhaModelInfo.Name
  buddhaData.icon = buddhaModelInfo.icon
  buddhaData.level = level
  buddhaData.starLevel = starLevel
  buddhaData.quality = tonumber(buddhaInfo.quality)
  buddhaData.isRebel = tonumber(buddhaModelInfo.isRebel)
  return buddhaData
end

function DataUtils.getBuddhaNameColor(quality)
  local tFunc = {
    [1] = cc.c3b(255, 255, 255),
    [2] = cc.c3b(35, 255, 51),
    [3] = cc.c3b(25, 231, 255),
    [4] = cc.c3b(233, 45, 255),
    [5] = cc.c3b(255, 152, 6),
    [6] = cc.c3b(255, 48, 48)
  }
  return tFunc[quality]
end

function DataUtils.getUnlockBuddhaList()
  if GameManager.UNLOCK_BUDDHA_ID ~= nil then
    return GameManager.UNLOCK_BUDDHA_ID
  end
  GameManager.UNLOCK_BUDDHA_ID = {}
  local npcNumTotal = #DataRetainer.BUDDHA_INFO - 1
  for id = 1, npcNumTotal do
    local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "id", tostring(id))[1]
    if not buddhaInfo then
      DDLOG("buddhaInfo index : %d with error data", tonumber(id))
      return
    end
    local buddhaId = tonumber(buddhaInfo.buddhaID)
    local buddhaState = 0
    if CloudData.NPC_INFO[buddhaId] then
      buddhaState = CloudData.NPC_INFO[buddhaId].status
    end
    if 0 == buddhaState then
      table.insert(GameManager.UNLOCK_BUDDHA_ID, buddhaId)
    end
  end
  return GameManager.UNLOCK_BUDDHA_ID
end

function DataUtils.getUnlockBuddhaPieceInfo(buddhaId)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(buddhaId))[1]
  if not buddhaInfo then
    DDLOG("buddhaInfo buddhaId : %d with error data", tonumber(buddhaId))
    return
  end
  local buddhaData = {}
  local baseStar = tonumber(buddhaInfo.BornStar)
  local pieceData = DataUtils.getItemModel(buddhaInfo.PieceID)
  buddhaData.currPieceNum = pieceData.currNum
  local summonNum = {
    10,
    30,
    60,
    110,
    190,
    340
  }
  buddhaData.summonCostNum = summonNum[baseStar + 1]
  return buddhaData
end

local TowerBuddha = require("app.sprites.TowerBuddha")
local Actor = require("app.sprites.pvp.SpriteActorModel")
local TowerMonster = require("app.sprites.TowerMonster")
local TowerBuddhaES = require("app.sprites.TowerBuddhaES")
local TowerMonsterES = require("app.sprites.TowerMonsterES")
local MonsterBoss = require("app.sprites.MonsterBoss")
local Monster = require("app.sprites.Monster")
local FLAG_BUDDHA = 1
local FLAG_MONSTER = 2
local FLAG_LEFT = -1
local FLAG_RIGHT = 1
local TAG_TOWER_CUR_HP = 2
local TAG_USE_SPIRIT = 3
local TAG_CREATE_BUDDHA = 4
local TAG_CIM_DAMAGE = 5
local TAG_KILL_MONSTER = 6
local M = {}
M.EVENT_NAME = {
  CastSkill = "CastSkill",
  UnderAttack = "UnderAttack",
  AddBuff = "AddBuff",
  HaveHeal = "HaveHeal"
}

function M.init()
  M._BuddhaList = {}
  M._MonsterList = {}
  M._buddhaTower = nil
  M._monsterTower = nil
  M._buddhaPos = nil
  M._monsterPos = nil
  M._auraSkillData = {}
  M._auraSkillData[1] = {}
  M._auraSkillData[2] = {}
  M._areaSkill = {}
  M._relicsSkill = {}
  M._lastClickFrame = 0
  M._sumFrame = 0
  M._buddhaTowerHP = 0
  M._enemyTowerHP = 0
  M._isPause = false
  M._battleStartTime = os.time()
  M._harmSum = {}
  M._harmSum[FLAG_BUDDHA] = {}
  M._harmSum[FLAG_MONSTER] = {}
  M._battleCount = {}
  M._battleCount[FLAG_BUDDHA] = {
    0,
    0,
    0,
    0,
    0,
    0,
    1
  }
  M._battleCount[FLAG_MONSTER] = {
    0,
    0,
    0,
    0,
    0,
    0,
    1
  }
  M.RANDOM = DYRandomSeq.new(1)
end

function table.copy(t)
  local u = {}
  for k, v in pairs(t) do
    u[k] = v
  end
  return setmetatable(u, getmetatable(t))
end

function M.initRandomSeed(randomSeed)
  M.RANDOM = DYRandomSeq.new(randomSeed)
end

function M.createPVPBuddha(id, position)
  local model = DataUtils.getModelForPVPOnline("buddha", id)
  local pos = position or cc.p(M._buddhaTower:getPosition()) or cc.p(900, 130)
  local buddha = Actor.new(model, pos, FLAG_BUDDHA)
  buddha:setAnimationSpeed(2)
  M.AddBattleCount(FLAG_BUDDHA, TAG_USE_SPIRIT, model.consume)
  M.AddBattleCount(FLAG_BUDDHA, TAG_CREATE_BUDDHA, 1)
  table.insert(M._BuddhaList, buddha)
end

function M.createPVPMonster(id, position)
  local model = DataUtils.getModelForPVPOnline("enemy", id)
  local pos = position or cc.p(M._monsterTower:getPosition()) or cc.p(900, 130)
  local monster = Actor.new(model, pos, FLAG_MONSTER)
  monster:setAnimationSpeed(2)
  M.AddBattleCount(FLAG_MONSTER, TAG_USE_SPIRIT, model.consume)
  M.AddBattleCount(FLAG_MONSTER, TAG_CREATE_BUDDHA, 1)
  table.insert(M._MonsterList, monster)
end

function M.createSummon(flag, id, position)
  local model = DataUtils.getMonsterModel(tostring(id))
  local pos = position or M._monsterPos
  local actor
  if flag == FLAG_BUDDHA then
    actor = Actor.new(model, pos, FLAG_BUDDHA)
    actor.IS_SUMMON = true
    table.insert(M._BuddhaList, actor)
  else
    actor = Actor.new(model, pos, FLAG_MONSTER)
    actor.IS_SUMMON = true
    table.insert(M._MonsterList, actor)
  end
end

function M.insertPVPBuddha(actor)
  table.insert(M._BuddhaList, actor)
end

function M.insertPVPMonster(actor)
  table.insert(M._MonsterList, actor)
end

function M.createBuddha(parent, id, position, num)
  if not parent or not id then
    error("too short")
  end
  local id = tostring(id)
  local model = DataUtils.getBuddhaModel(id)
  local pos = position or cc.p(M._buddhaPos) or cc.p(900, 130)
  local buddha = Actor.new(model, pos, FLAG_BUDDHA)
  table.insert(M._BuddhaList, buddha)
  DYNotification.postNotification(DY_KEY.kBuddhaCreateNum, #M._BuddhaList)
  if num and tonumber(num) > 1 then
    M.createBuddha(parent, id, postion, num - 1)
  end
  return buddha
end

function M.createMonster(parent, id, position, num)
  local id = tostring(id)
  local pos = position or cc.p(M._monsterTower:getPosition()) or cc.p(300, 120)
  pos.x = pos.x + 20
  local model
  DDLOG("monster ID" .. id)
  if 5 == GameManager.MODE or 8 == GameManager.MODE then
    model = DataUtils.getPVPMonsterModel(id)
  else
    model = DataUtils.getMonsterModel(id)
  end
  local monster
  monster = Actor.new(model, pos, FLAG_MONSTER)
  table.insert(M._MonsterList, monster)
  DYNotification.postNotification(DY_KEY.kMonsterCreateNum, #M._MonsterList)
  if num and tonumber(num) > 1 then
    M.createMonster(parent, id, postion, num - 1)
  end
  return monster
end

function M.createGuideBuddha(id)
  local model = DataUtils.getMonsterModel(id)
  local pos = cc.p(M._buddhaTower:getPosition())
  local buddha = Actor.new(model, pos, FLAG_BUDDHA)
  table.insert(M._BuddhaList, buddha)
  return buddha
end

function M.createDemoBuddha(id, locPos)
  local model = DataUtils.getMonsterModel(tostring(id))
  local pos = locPos or cc.p(M._buddhaTower:getPosition())
  local buddha = Actor.new(model, pos, FLAG_BUDDHA)
  table.insert(M._BuddhaList, buddha)
  buddha.mFlag = 2
  buddha:initMonsterSkill(buddha.model_.npcSkill, buddha.model_.skillLv)
  buddha.mFlag = 1
  return buddha
end

function M.createTowerMonster(STAGE_ID, mode)
  local towerMonster
  if 2 == GameManager.MODE then
    local towerMonsterInfo = DataUtils.getMonsterTowerInfo(GameManager.MODE, STAGE_ID)
    towerMonster = TowerMonster.new(towerMonsterInfo, "infiniteMode")
  elseif 0 == GameManager.MODE or 1 == GameManager.MODE then
    local towerMonsterInfo = DataUtils.getMonsterTowerInfo(GameManager.MODE, STAGE_ID)
    if mode == "escort" then
      towerMonster = TowerMonsterES.new(towerMonsterInfo)
    else
      towerMonster = TowerMonster.new(towerMonsterInfo)
    end
  elseif 5 == GameManager.MODE or 8 == GameManager.MODE then
    towerMonster = TowerMonster.new(nil, "pvp")
  else
    local towerMonsterInfo = DataUtils.getMonsterTowerInfo(GameManager.MODE, STAGE_ID)
    towerMonster = TowerMonster.new(towerMonsterInfo)
  end
  return towerMonster
end

function M.createMonsterBoss(parent, id, position, num)
  local id = tostring(id)
  local pos = position or cc.p(M._monsterTower:getPosition()) or cc.p(300, 120)
  local model = DataUtils.getMonsterModel(id)
  local monster
  monster = MonsterBoss.new(model, pos)
  table.insert(M._MonsterList, monster)
  DYNotification.postNotification(DY_KEY.kMonsterCreateNum, #M._MonsterList)
  if num and tonumber(num) > 1 then
    M.createMonster(parent, id, postion, num - 1)
  end
end

function M.createTowerBuddha(mode)
  local towerBuddha
  if mode == "escort" then
    towerBuddha = TowerBuddhaES.new()
  else
    towerBuddha = TowerBuddha.new()
  end
  return towerBuddha
end

function M.setPurgatoryBoss(obj)
  M.purgatoryBoss = obj
end

function M.getPurgatoryBoss()
  return M.purgatoryBoss
end

function M.createBuddhaPlace(parent, id, position, num)
  if not parent or not id then
    error("too short")
  end
  local id = tostring(id)
  local model = DataUtils.getBuddhaModel(id)
  local pos = position or cc.p(M._buddhaPos) or cc.p(900, 130)
  local buddha = require("app.sprites.pvp.SpriteActorPlace").new(model, pos, FLAG_BUDDHA)
  table.insert(M._BuddhaList, buddha)
  DYNotification.postNotification(DY_KEY.kBuddhaCreateNum, #M._BuddhaList)
  if num and tonumber(num) > 1 then
    M.createBuddha(parent, id, postion, num - 1)
  end
  return buddha
end

function M.createDefenceBoss(id, level, position)
  local id = tonumber(id)
  DDLOG(id)
  local model = DataUtils.getUnionBossModel(id, level)
  local pos = position or cc.p(M._monsterPos) or cc.p(900, 130)
  local monster
  monster = MonsterBoss.new(model, pos)
  table.insert(M._MonsterList, monster)
  return monster
end

function M.getRemindBuddha()
  local remindTeam = {}
  for k, v in pairs(BMgrOL.getBuddhaList()) do
    if v.IS_SUMMON ~= true then
      local id = tostring(v.model_.npcId)
      remindTeam[id] = remindTeam[id] or 0
      remindTeam[id] = remindTeam[id] + 1
    end
  end
  return remindTeam
end

function M.getRemindMonster()
  local remindTeam = {}
  for k, v in pairs(BMgrOL.getMonsterList()) do
    if v.IS_SUMMON ~= true then
      local id = tostring(v.model_.npcId)
      remindTeam[id] = remindTeam[id] or 0
      remindTeam[id] = remindTeam[id] + 1
    end
  end
  return remindTeam
end

function M.setBuddhaTower(tower)
  M._buddhaTower = tower
end

function M.setMonsterTower(tower)
  M._monsterTower = tower
end

function M.setBuddhaPos(pos)
  M._buddhaPos = {}
  M._buddhaPos.x = pos.x
  M._buddhaPos.y = pos.y
end

function M.setMonsterPos(pos)
  M._monsterPos = pos
end

function M.setAuraSkillData(flag, index, value)
  M._auraSkillData[flag][index] = M._auraSkillData[flag][index] or value
end

function M.setBuddhaTowerHp(value)
  if value < 0 then
    value = 0
  end
  M._buddhaTowerHP = value
end

function M.setEnemyTowerHp(value)
  if value < 0 then
    value = 0
  end
  M._enemyTowerHP = value
end

function M.insertArea(area)
  table.insert(M._areaSkill, area)
end

function M.removeArea(area)
  table.removebyvalue(M._areaSkill, area, false)
end

function M.insertRelics(relics)
  table.insert(M._relicsSkill, relics)
end

function M.removeRelics(relics)
  table.removebyvalue(M._relicsSkill, relics)
end

function M.getBuddhaPos()
  return M._buddhaPos
end

function M.getMonsterPos()
  return M._monsterPos
end

function M.getAuraSkillData(flag, index)
  return M._auraSkillData[flag][index] or 0
end

function M.getBuddhaTower()
  if not M._buddhaTower then
    return nil
  else
    return M._buddhaTower
  end
end

function M.getMonsterTower()
  if not M._monsterTower then
    return nil
  else
    return M._monsterTower
  end
end

function M.removeActor(value)
  if value.mFlag == FLAG_BUDDHA then
    if value.IS_SUMMON ~= true then
      M.AddBattleCount(FLAG_MONSTER, TAG_KILL_MONSTER, 1)
    end
    table.removebyvalue(M._BuddhaList, value, false)
  elseif value.mFlag == FLAG_MONSTER then
    if value.IS_SUMMON ~= true then
      M.AddBattleCount(FLAG_BUDDHA, TAG_KILL_MONSTER, 1)
    end
    table.removebyvalue(M._MonsterList, value, false)
  end
end

function M.removeBuddha(value)
  local number = table.removebyvalue(M._BuddhaList, value, false)
  return number
end

function M.removeMonster(value)
  local number = table.removebyvalue(M._MonsterList, value, false)
  return number
end

function M.getBuddhaList()
  return table.copy(M._BuddhaList)
end

function M.getMonsterList()
  return table.copy(M._MonsterList)
end

function M.getBuddhaListCount()
  local i = 0
  for _, v in pairs(M._BuddhaList) do
    if v.IS_SUMMON ~= true then
      i = i + 1
    end
  end
  return i
end

function M.getCurFrame()
  return M._sumFrame
end

function M.getBuddhaTowerHP()
  return M._buddhaTowerHP
end

function M.getEnemyTowerHP()
  return M._enemyTowerHP
end

function M.checkBattleTime(gameTime)
  local lastTime = os.time() - M._battleStartTime
  local rtnBool = true
  DDLOG(DYLang.getString("S1503", ""), lastTime, gameTime)
  if gameTime > lastTime * 2.5 then
    rtnBool = false
  end
  return rtnBool
end

function M.calcuteBattleRest()
  for k, v in pairs(BMgrOL.getBuddhaList()) do
    DDLOG(DYLang.getString("S1504", ""), v.mName, v:getCurABLY(LIFE_CUR))
  end
  for k, v in pairs(BMgrOL.getMonsterList()) do
    DDLOG(DYLang.getString("S1505", ""), v.mName, v:getCurABLY(LIFE_CUR))
  end
end

function M.update()
  if M._isPause then
    return
  end
  if CloudData.FIGHT_PRIORITY == 0 then
    local list = M._MonsterList
    for _, item in pairs(list) do
      item:doThings()
    end
    local list = M._BuddhaList
    for _, item in pairs(list) do
      item:doThings()
    end
  else
    local list = M._BuddhaList
    for _, item in pairs(list) do
      item:doThings()
    end
    local list = M._MonsterList
    for _, item in pairs(list) do
      item:doThings()
    end
  end
  for _, v in pairs(M._areaSkill) do
    v:update()
  end
  for _, v in pairs(M._relicsSkill) do
    v:doThings()
  end
  M._sumFrame = M._sumFrame + 1
end

function M.calculateDamage(Source, Target)
  local source = Source
  local target = Target
  local realType = 1
  local realDamage = 0
  local HitR = source:getCurABLY(HIT_RATE) - target:getCurABLY(MISS_RATE)
  if HitR < 25 then
    HitR = 25
  end
  if HitR < M.RANDOM:random(0, 100) then
    realType = 3
    return realDamage, realType
  end
  local CriHarmR = 100
  local CriR = source:getCurABLY(CRIT_RATE) - target:getCurABLY(RES_CRIT_RATE)
  if CriR > M.RANDOM:random(0, 100) then
    CriHarmR = source:getCurABLY(CRIT_HARM_RATE)
    realType = 2
  end
  CriHarmR = CriHarmR * 0.01
  local dmgR = M.RANDOM:random(90, 110) * 0.01
  local attackType = source:getATKType()
  local defBase, defIncr, defDeV
  if attackType == 2 then
    defBase = target:getCurABLY(MAG_DEF)
    defIncr = target:getCurABLY(MAG_DEF_RATE)
    defDeV = source:getCurABLY(MAG_DEF_IGNORE)
  else
    defBase = target:getCurABLY(PHY_DEF)
    defIncr = target:getCurABLY(PHY_DEF_RATE)
    defDeV = source:getCurABLY(PHY_DEF_IGNORE)
  end
  local Harm = source:getCurABLY(ADD_HARM)
  local DeHarmV = target:getCurABLY(REDUCE_HARM)
  local SklHarmR = source.tmpABLY[SKILL_HARM_RATE] ~= 0 and source.tmpABLY[SKILL_HARM_RATE] or source.initABLY[SKILL_HARM_RATE]
  local DeHarmR = target:getCurABLY(REDUCE_HARM_RATE)
  local AddHarmR = target:getCurABLY(ADD_HARM_RATE)
  local tmpAttack = source:getCurABLY(ATK) * source:getCurABLY(ATK_RATE) * 0.01
  local tmpDefence = (defBase - defDeV) * defIncr * 0.01
  local tmpH = math.floor(tmpAttack - tmpDefence + Harm - DeHarmV)
  if tmpH < tmpAttack * 0.1 then
    tmpH = tmpAttack * 0.1
  end
  realDamage = math.floor(tmpH * SklHarmR * 0.01 * (100 - DeHarmR) * (100 + AddHarmR) * 1.0E-4 * dmgR * CriHarmR)
  if realDamage < 1 then
    realDamage = 1
  end
  local elementType1, elementType2 = source:getElementType(), target:getElementType()
  local restrainType1, restrainType2 = Const.ELEMENT_RELATED[elementType2], Const.ELEMENT_RELATED[elementType1]
  local ratio = Const.ELEMENT_RATIO[elementType1][elementType2]
  local restrainValue1, restrainValue2 = source:getElementValue(restrainType1), target:getElementValue(restrainType2)
  local tempRatio = 1 + restrainValue1 * 2.0E-4 - restrainValue2 * 2.0E-4
  tempRatio = tempRatio < 0.1 and 0.1 or tempRatio
  realDamage = math.round(realDamage * ratio * tempRatio + source:getElementValue(elementType1) * ratio)
  M.countActorDamage(source.mFlag, source.model_.npcId, realDamage)
  if source.mName and target.mName then
    DDLOG(source.mName .. DYLang.getString("S1506", "") .. target.mName .. DYLang.getString("S1507", "") .. realDamage)
  end
  return realDamage, realType
end

function M.cimeliaDemage(params, target)
  local realDamage, realType = 0, 1
  local HitR = params.hitRate - target:getCurABLY(MISS_RATE)
  if HitR < 25 then
    HitR = 25
  end
  if HitR < M.RANDOM:random(0, 100) then
    realType = 3
    return realDamage, realType
  end
  local CriHarmR = 100
  local CriR = params.hitRate - target:getCurABLY(RES_CRIT_RATE)
  if CriR > M.RANDOM:random(0, 100) then
    CriHarmR = params.critHarmRate - target:getCurABLY(RES_CRIT_HARM_RATE)
    realType = 2
  end
  CriHarmR = CriHarmR * 0.01
  local dmgR = 1
  local attackType = params.attackType
  local defBase, defIncr, defDeV
  if attackType == 2 then
    defBase = target:getCurABLY(MAG_DEF)
    defIncr = target:getCurABLY(MAG_DEF_RATE)
    defDeV = params.magDefIgnore
  else
    defBase = target:getCurABLY(PHY_DEF)
    defIncr = target:getCurABLY(PHY_DEF_RATE)
    defDeV = params.phyDefIgnore
  end
  local cimeliaATK = params.atkNum
  local Harm = params.harmNum
  local DeHarmV = target:getCurABLY(REDUCE_HARM)
  local SklHarmR = 100
  local DeHarmR = target:getCurABLY(REDUCE_HARM_RATE)
  local AddHarmR = target:getCurABLY(ADD_HARM_RATE)
  local tmpAttack = cimeliaATK
  local tmpDefence = (defBase - defDeV) * defIncr * 0.01
  local tmpH = math.floor(tmpAttack - tmpDefence + Harm - DeHarmV)
  if tmpH < tmpAttack * 0.1 then
    tmpH = tmpAttack * 0.1
  end
  realDamage = math.floor(tmpH * SklHarmR * 0.01 * (100 - DeHarmR) * (100 + AddHarmR) * 1.0E-4 * dmgR * CriHarmR)
  if realDamage < 1 then
    realDamage = 1
  end
  
  local function getSourceElement(element)
    local tFunc = {
      [1] = 3,
      [2] = 4,
      [3] = 1,
      [4] = 2,
      [5] = 5
    }
    return tFunc[element]
  end
  
  local elementType1, elementType2 = getSourceElement(params.element), target:getElementType()
  local restrainType1, restrainType2 = Const.ELEMENT_RELATED[elementType2], Const.ELEMENT_RELATED[elementType1]
  local ratio = Const.ELEMENT_RATIO[elementType1][elementType2]
  local restrainValue1, restrainValue2 = params.elementValue[restrainType1], target:getElementValue(restrainType2)
  local tempRatio = 1 + restrainValue1 * 2.0E-4 - restrainValue2 * 2.0E-4
  tempRatio = tempRatio < 0.1 and 0.1 or tempRatio
  realDamage = math.round(realDamage * ratio * tempRatio + params.elementValue[elementType1] * ratio)
  if params.flag then
    M.AddBattleCount(params.flag, TAG_CIM_DAMAGE, realDamage)
  end
  return realDamage, 5
end

function M.cimeliaDemage1(params, target)
  local cimeliaATK = params.atkNum
  local harm = params.harmNum
  local attackType = params.attackType
  local reduceHarmV = target:getCurABLY(REDUCE_HARM)
  local reduceHarmR = target:getCurABLY(REDUCE_HARM_RATE)
  local defBase = target:getCurABLY(MAG_DEF)
  local defIncr = target:getCurABLY(MAG_DEF_RATE) or 100
  local tmpDefence = defBase * defIncr * 0.01
  local baseHarm = math.floor(cimeliaATK - tmpDefence + harm - reduceHarmV)
  if baseHarm < cimeliaATK * 0.1 then
    baseHarm = cimeliaATK * 0.1
  end
  local realDamage = math.floor(baseHarm * (100 - reduceHarmR) * 0.01)
  if params.flag then
    M.AddBattleCount(params.flag, TAG_CIM_DAMAGE, realDamage)
  end
  return realDamage, 5
end

function M.countActorDamage(flag, actorId, damage)
  M._harmSum[flag][actorId] = M._harmSum[flag][actorId] or 0
  M._harmSum[flag][actorId] = M._harmSum[flag][actorId] + damage
end

function M.getDamageSum()
  return M._harmSum
end

function M.GetBattleCount()
  M._battleCount[FLAG_BUDDHA][TAG_TOWER_CUR_HP] = M._buddhaTower.hpCur_ > 0 and math.floor(M._buddhaTower.hpCur_ / M._buddhaTower.hpMax_ * 100) or 0
  M._battleCount[FLAG_MONSTER][TAG_TOWER_CUR_HP] = 0 < M._monsterTower.hpCur_ and math.floor(M._monsterTower.hpCur_ / M._monsterTower.hpMax_ * 100) or 0
  return M._battleCount
end

function M.AddBattleCount(flag, index, count)
  M._battleCount[flag][index] = M._battleCount[flag][index] or 0
  M._battleCount[flag][index] = M._battleCount[flag][index] + count
end

function M.setUnionBattleCount(ally, enemy)
  if ally.hpRate ~= nil then
    M._battleCount[FLAG_BUDDHA][TAG_TOWER_CUR_HP] = ally.hpRate
  end
  if enemy.hpRate ~= nil then
    M._battleCount[FLAG_MONSTER][TAG_TOWER_CUR_HP] = enemy.hpRate
  end
  if enemy.tmpDesc ~= nil then
    M._battleCount.tmpDesc = DYLang.getString("S1508", "")
  else
    M._battleCount.tmpDesc = DYLang.getString("S1509", "")
  end
  M._battleCount[FLAG_BUDDHA].union_name = ally.union_name
  M._battleCount[FLAG_MONSTER].union_name = enemy.union_name
  M._battleCount[FLAG_BUDDHA].mCoin = ally.add_score
  M._battleCount[FLAG_MONSTER].mCoin = enemy.add_score
end

function M.getUnionBattleCount()
  return M._battleCount
end

function M.resume()
  for _, v in pairs(M._BuddhaList) do
    v:resume()
  end
  for _, v in pairs(M._MonsterList) do
    v:resume()
  end
  M._isPause = false
  M._buddhaTower:resume()
  M._monsterTower:resume()
end

function M.pause()
  for _, v in pairs(M._BuddhaList) do
    v:pause()
  end
  for _, v in pairs(M._MonsterList) do
    v:pause()
  end
  M._isPause = true
  M._buddhaTower:pause()
  M._monsterTower:pause()
end

function M.setKillBuddha(num)
  DYNotification.postNotification(DY_KEY.kBuddhaDeadNum, M._killBuddha)
end

function M.showNotice()
  DDLOG(DYLang.getString("S1510", ""))
end

return M

local Buddha = require("app.sprites.Buddha")
local Monster = require("app.sprites.Monster")
local TowerBuddha = require("app.sprites.TowerBuddha")
local TowerMonster = require("app.sprites.TowerMonster")
local TowerBuddhaES = require("app.sprites.TowerBuddhaES")
local TowerMonsterES = require("app.sprites.TowerMonsterES")
local MonsterBoss = require("app.sprites.MonsterBoss")
local BuffView = require("app.skill.BuffView")
local M = {}

function M.init()
  M._BuddhaList = {}
  M._MonsterList = {}
  M.dmg = {}
  M.count = {}
  M._killBuddha = 0
  M._killMonster = 0
  M._buddhaTower = nil
  M._monsterTower = nil
  M._buddhaPos = nil
  M._monsterPos = nil
  M._auraSkillData = {}
  M._auraSkillData[1] = {}
  M._auraSkillData[2] = {}
  M._areaSkill = {}
  M.RANDOM = DYRandomSeq.new(math.random(1, 1000))
end

function M.initRandomSeed(randomSeed)
  M.RANDOM = DYRandomSeq.new(randomSeed)
end

function M.createBuddha(parent, id, position, num)
  if not parent or not id then
    error("too short")
  end
  local id = tostring(id)
  local model = DataUtils.getBuddhaModel(id)
  local pos = position or M._buddhaPos or cc.p(900, 130)
  local buddha = Buddha.new(model, pos)
  M.countNum(model.npcId)
  table.insert(M._BuddhaList, buddha)
  parent:addChild(buddha)
  DYNotification.postNotification(DY_KEY.kBuddhaCreateNum, #M._BuddhaList)
  if num and tonumber(num) > 1 then
    M.createBuddha(parent, id, postion, num - 1)
  end
end

function M.createBuddhaByModel(parent, model, position)
  local buddha = Buddha.new(model, position)
  table.insert(M._BuddhaList, buddha)
  parent:addChild(buddha)
  return buddha
end

function M.createMonsterByModel(parent, model, position)
  local monster = Monster.new(model, position)
  table.insert(M._MonsterList, monster)
  parent:addChild(monster)
  return monster
end

function M.createGuideBuddha(id)
  local model = DataUtils.getMonsterModel(id)
  local pos = M._buddhaPos
  local buddha = Buddha.new(model, pos)
  table.insert(M._BuddhaList, buddha)
  return buddha
end

function M.createDemoBuddha(id, locPos)
  local model = DataUtils.getMonsterModel(tostring(id))
  local pos = locPos or M._buddhaPos
  local buddha = Buddha.new(model, pos)
  table.insert(M._BuddhaList, buddha)
  buddha.mFlag = 2
  buddha:initMonsterSkill(buddha.model_.npcSkill, buddha.model_.skillLv)
  buddha.mFlag = 1
  return buddha
end

function M.createSummonMonster(id, locPos)
  local model = DataUtils.getMonsterModel(tostring(id))
  local pos = locPos or M._monsterPos
  local monster = Monster.new(model, pos)
  table.insert(M._MonsterList, monster)
  return monster
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
  elseif 5 == GameManager.MODE then
    towerMonster = TowerMonster.new(nil, "pvp")
  else
    local towerMonsterInfo = DataUtils.getMonsterTowerInfo(GameManager.MODE, STAGE_ID)
    towerMonster = TowerMonster.new(towerMonsterInfo)
  end
  return towerMonster
end

function M.createMonster(parent, id, position, num)
  local id = tostring(id)
  local pos = position or M._monsterPos or cc.p(300, 120)
  local model = DataUtils.getMonsterModel(id)
  if 5 == GameManager.MODE or 6 == GameManager.MODE or 9 == GameManager.MODE then
    model = DataUtils.getPVPMonsterModel(id)
  end
  local monster
  monster = Monster.new(model, pos)
  table.insert(M._MonsterList, monster)
  parent:addChild(monster)
  DYNotification.postNotification(DY_KEY.kMonsterCreateNum, #M._MonsterList)
  if num and tonumber(num) > 1 then
    M.createMonster(parent, id, postion, num - 1)
  end
  return monster
end

function M.createMonsterBoss(parent, id, position, num)
  local id = tostring(id)
  local pos = position or M._monsterPos or cc.p(300, 120)
  local model = DataUtils.getMonsterModel(id)
  local monster
  monster = MonsterBoss.new(model, pos)
  table.insert(M._MonsterList, monster)
  parent:addChild(monster)
  DYNotification.postNotification(DY_KEY.kMonsterCreateNum, #M._MonsterList)
  if num and tonumber(num) > 1 then
    M.createMonster(parent, id, postion, num - 1)
  end
end

function M.createMonster2(parent, id, position, num)
  local id = tostring(id)
  local pos = position or cc.p(900, 120)
  pos.x = pos.x + math.random(0, 10)
  pos.y = pos.y + math.random(0, 20)
  local model = DataUtils.getBuddhaModel(id)
  local monster = Monster.new(model, pos)
  table.insert(M._MonsterList, monster)
  parent:addChild(monster)
  if num and tonumber(num) > 1 then
    M.createMonster(parent, id, postion, num - 1)
  end
  DYNotification.postNotification(DY_KEY.kMonsterCreateNum, #M._MonsterList)
end

function M.removeBuddha(value)
  local number = table.removebyvalue(M._BuddhaList, value, false)
  return number
end

function M.removeMonster(value)
  local number = table.removebyvalue(M._MonsterList, value, false)
  return number
end

function M.setBuddhaTower(tower)
  M._buddhaTower = tower
end

function M.setMonsterTower(tower)
  M._monsterTower = tower
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

function M.insertBuddha(buddha)
  table.insert(M._BuddhaList, buddha)
end

function M.insertMonster(monster)
  table.insert(M._MonsterList, monster)
end

function M.getBuddhaList()
  return M._BuddhaList
end

function M.getMonsterList()
  return M._MonsterList
end

function M.getBuddhaPos()
  return M._buddhaPos
end

function M.getMonsterPos()
  return M._monsterPos
end

function M.setBuddhaPos(pos)
  M._buddhaPos = pos
end

function M.setMonsterPos(pos)
  M._monsterPos = pos
end

function M.setAuraSkillData(flag, index, value)
  M._auraSkillData[flag][index] = value
end

function M.getAuraSkillData(flag, index)
  return M._auraSkillData[flag][index] or 0
end

function M.insertArea(area)
  table.insert(M._areaSkill, area)
end

function M.removeArea(area)
  table.removebyvalue(M._areaSkill, area, false)
end

function M.resume()
  local tmpList = M._BuddhaList
  for k, v in pairs(tmpList) do
    v:kResume()
  end
  local tmpList = M._MonsterList
  for k, v in pairs(tmpList) do
    v:kResume()
  end
  for _, v in pairs(M._areaSkill) do
    v:resume()
  end
  M._buddhaTower:resume()
  M._monsterTower:resume()
end

function M.pause()
  DDLOG("pause")
  local tmpList = M._BuddhaList
  for k, v in pairs(tmpList) do
    v:tPause()
  end
  local tmpList = M._MonsterList
  for k, v in pairs(tmpList) do
    v:tPause()
  end
  for _, v in pairs(M._areaSkill) do
    v:pause()
  end
  M._buddhaTower:pause()
  M._monsterTower:pause()
end

function M.killSelf()
  DYMem.set("BattleManager", nil)
end

function M.createBuffView(buffView)
  return BuffView[buffView]()
end

function M.setKillBuddha(num)
  M._killBuddha = M._killBuddha + num
  DYNotification.postNotification(DY_KEY.kBuddhaDeadNum, M._killBuddha)
end

function M.setKillMonster(num)
  M._killMonster = M._killMonster + num
  DYNotification.postNotification(DY_KEY.kMonsterDeadNum, M._killMonster)
end

function M.countDamage(id, damage)
  M.count[tostring(id)] = M.count[tostring(id)] or {}
  M.count[tostring(id)].dmg = M.count[tostring(id)].dmg or 0
  M.count[tostring(id)].dmg = M.count[tostring(id)].dmg + damage
end

function M.countNum(id)
  M.count[tostring(id)] = M.count[tostring(id)] or {}
  M.count[tostring(id)].num = M.count[tostring(id)].num or 0
  M.count[tostring(id)].num = M.count[tostring(id)].num + 1
end

function M.countHit(id)
  M.count[tostring(id)] = M.count[tostring(id)] or {}
  M.count[tostring(id)].Hit = M.count[tostring(id)].Hit or 0
  M.count[tostring(id)].Hit = M.count[tostring(id)].Hit + 1
end

function M.outDamage()
  local s = json.encode(M.count)
  io.writefile("filename", s)
end

function M.cimeliaDemage(params, target)
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
  return realDamage
end

function M.showNotice()
  DDLOG(DYLang.getString("S200", ""))
end

return M

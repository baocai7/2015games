local TowerMonsterLogic = require("app.sprites.pvp.TowerMonsterModel")
local TowerBuddhaLogic = require("app.sprites.pvp.TowerBuddhaModel")
local M = {}
M.NORMAL = 1
M.BOSS = 2

function M.init(pTag, bossId, time)
  M.pTag = pTag
  M.result = nil
  M.maxTime = time
  M.allyInfo = CloudData.ALLY_INFO
  M.enemyInfo = CloudData.ENEMY_INFO
  dump(M.allyInfo)
  dump(M.enemyInfo)
  M.bossId = M.enemyInfo.bossId
  M.bossHp = M.enemyInfo.cur_hp
  M.bossMaxHp = M.enemyInfo.max_hp
  M.boosLevel = M.enemyInfo.level
  local monsterTower = TowerMonsterLogic.new(cc.p(140, 10), M.pTag):addTo(display.getRunningScene())
  local buddhaTower = TowerBuddhaLogic.new(cc.p(1140, 10)):addTo(display.getRunningScene())
  local buddha_left_hp = M.allyInfo.left_hp
  local monster_left_hp = M.enemyInfo.left_hp
  if buddha_left_hp ~= -1 then
    buddhaTower.hpCur_ = buddha_left_hp
  end
  if monster_left_hp ~= -1 then
    monsterTower.hpCur_ = monster_left_hp
    GameData.setMonsterTowerHP(monsterTower.hpCur_)
  end
  BMgrOL.setMonsterTower(monsterTower)
  BMgrOL.setBuddhaTower(buddhaTower)
  BMgrOL.setBuddhaPos(cc.p(1140, 10))
  BMgrOL.setMonsterPos(cc.p(140, 10))
  BMgrOL.SKIP_BATTLE = true
  BMgrOL.initRandomSeed(CloudData.FIGHT_SEED)
  M.initData()
  M.initEventList(time)
  M.skip()
  if M.pTag == M.NORMAL then
    M.submitNormalResult()
  elseif M.pTag == M.BOSS then
    M.submitBossResult(M.result)
  end
  BMgrOL.init()
  BMgrOL.initRandomSeed(CloudData.FIGHT_SEED)
end

function M.initData()
  M.mBuddhaTeam = {}
  M.mBuddhaNum = {}
  M.mEnemyTeam = {}
  M.mEnemyNum = {}
  M.mEventList = {}
  M.mNpcCountNum = 0
  M.mCurrNpcNum = 0
  M.mBuddhaTeam = {}
  M.mEnemyTeam = {}
  for k, v in pairs(CloudData.UNINO_BUDDHA_CUR_TEAM) do
    local buddhaModel = DataUtils.getModelForPVPOnline("buddha", k)
    local actor = {}
    actor.mId = k
    actor.mCount = tonumber(v)
    actor.realCDTime = buddhaModel.cdTime
    actor.mType = "buddha"
    table.insert(M.mBuddhaTeam, actor)
    M.mNpcCountNum = M.mNpcCountNum + v
  end
  for k, v in pairs(CloudData.UNINO_ENEMY_CUR_TEAM) do
    local buddhaModel = DataUtils.getModelForPVPOnline("enemy", k)
    local actor = {}
    actor.mId = k
    actor.mCount = tonumber(v)
    actor.realCDTime = buddhaModel.cdTime
    actor.mType = "monster"
    table.insert(M.mEnemyTeam, actor)
    M.mNpcCountNum = M.mNpcCountNum + v
  end
  if M.pTag == M.BOSS then
    DDLOG(DYLang.getString("S1561", ""), M.bossId, M.bossHp)
    BMgrOL.getMonsterTower().mCantAttack = true
    M.monster = BMgrOL.createDefenceBoss(M.bossId, M.boosLevel)
    M.monster.initABLY[LIFE_CUR] = M.bossHp
    M.monster.initABLY[LIFE] = M.bossMaxHp
    M.mCurrNpcNum = M.mCurrNpcNum + 1
  end
end

function M.initEventList(time)
  M.mCurTick = 0
  local totalTeam = {}
  if CloudData.FIGHT_PRIORITY == 0 then
    table.insertto(totalTeam, M.mEnemyTeam)
    table.insertto(totalTeam, M.mBuddhaTeam)
  else
    table.insertto(totalTeam, M.mBuddhaTeam)
    table.insertto(totalTeam, M.mEnemyTeam)
  end
  for i = 1, #totalTeam do
    local aTeamMember = totalTeam[i]
    for k = 1, tonumber(aTeamMember.mCount) do
      local tick = math.floor(((k - 1) * 0.5 + aTeamMember.realCDTime) * 24)
      M.mEventList[tick] = M.mEventList[tick] or {}
      table.insert(M.mEventList[tick], aTeamMember)
    end
  end
  local tick = time * 24
  M.mEventList[tick] = {
    {mType = "time_up"}
  }
end

function M.update()
  M.mCurTick = M.mCurTick + 1
  if M.mEventList[M.mCurTick] then
    for _, v in pairs(M.mEventList[M.mCurTick]) do
      if v.mType == "buddha" then
        BMgrOL.createPVPBuddha(v.mId, cc.p(1140, 10))
      elseif v.mType == "time_up" then
        DDLOG(DYLang.getString("S1562", ""))
        if M.allyInfo.flag == Const.UNION_FIGHT_DEFENCE then
          M.result = Const.BATTLE_RESULT.WIN
        else
          M.result = Const.BATTLE_RESULT.LOSE
        end
      else
        BMgrOL.createPVPMonster(v.mId, cc.p(140, 10))
      end
      M.mCurrNpcNum = M.mCurrNpcNum + 1
    end
  end
end

function M.skip()
  while M.result == nil do
    BMgrOL.update()
    M.update()
    local buddhaTower = BMgrOL.getBuddhaTower()
    local monsterTower = BMgrOL.getMonsterTower()
    if buddhaTower:getHp() <= 0 then
      M.result = Const.BATTLE_RESULT.LOSE
    elseif monsterTower:getHp() <= 0 then
      M.result = Const.BATTLE_RESULT.WIN
    elseif M.monster and 0 >= M.monster:getCurABLY(LIFE_CUR) then
      M.result = Const.BATTLE_RESULT.WIN
    end
  end
  DDLOG(DYLang.getString("S1563", ""), BMgrOL.getBuddhaTower():getHp(), BMgrOL.getMonsterTower():getHp(), BMgrOL.getCurFrame(), BMgrOL.getBuddhaTower().hpMax_, BMgrOL.getMonsterTower().hpMax_)
end

function M.addScore(event)
  DDLOG(DYLang.getString("S1564", ""))
  dump(event)
  M.win_score = event.win_add_score
  M.lose_score = event.lost_add_score
  M.add_score = event.add_score or 0
end

function M.submitNormalResult()
  local result = {
    fight_index = M.allyInfo.fight_index,
    fight_duration = math.floor(BMgrOL.getCurFrame() / 24 / 2 * 1000)
  }
  local self_data = {
    uid = CloudData.ALLY_INFO.uid,
    left_hp = BMgrOL.getBuddhaTower():getLastHp(),
    team = BMgrOL.getRemindBuddha(),
    kill_count = BMgrOL.getUnionBattleCount()[Const.FLAG_BUDDHA][Const.TAG_BATTLE_COUNT.KILL_MONSTER],
    winner = nil,
    loser = nil
  }
  local enemy_data = {
    uid = CloudData.ENEMY_INFO.uid,
    left_hp = BMgrOL.getMonsterTower():getLastHp(),
    team = BMgrOL.getRemindMonster(),
    kill_count = BMgrOL.getUnionBattleCount()[Const.FLAG_MONSTER][Const.TAG_BATTLE_COUNT.KILL_MONSTER],
    winner = nil,
    loser = nil
  }
  for i = M.mCurTick + 1, 7200 do
    if M.mEventList[i] then
      for _, v in pairs(M.mEventList[i]) do
        if v.mType == "buddha" then
          self_data.team[v.mId] = self_data.team[v.mId] or 0
          self_data.team[v.mId] = self_data.team[v.mId] + 1
        elseif v.mType == "time_up" then
          DDLOG(DYLang.getString("S1565", ""))
          break
        else
          enemy_data.team[v.mId] = enemy_data.team[v.mId] or 0
          enemy_data.team[v.mId] = enemy_data.team[v.mId] + 1
        end
      end
    end
  end
  if M.result == Const.BATTLE_RESULT.WIN then
    result.winner = self_data
    result.loser = enemy_data
  elseif M.result == Const.BATTLE_RESULT.LOSE then
    result.winner = enemy_data
    result.loser = self_data
    result.loser.left_hp = 0
  end
  dump(result)
  local pNode = display.newNode():addTo(display.getRunningScene(), -1)
  pNode:setNodeEventEnabled(true)
  pNode:safeSocketRequest("CMD_CLAN_COMPETE_FIGHT_RESULT", result, function(event)
    M.addScore(event)
  end)
end

function M.submitBossResult(fight_res)
  local rtn_result = {
    fight_index = M.allyInfo.fight_index,
    fight_duration = math.floor(BMgrOL.getCurFrame() / 24 / 2 * 1000),
    boss_id = CloudData.ENEMY_INFO.bossId,
    damage = M.bossHp - M.monster:getCurABLY(LIFE_CUR),
    team = BMgrOL.getRemindBuddha(),
    left_hp = BMgrOL.getBuddhaTower():getLastHp(),
    boss_left_hp = M.monster:getCurABLY(LIFE_CUR)
  }
  for i = M.mCurTick + 1, 7200 do
    if M.mEventList[i] then
      DDLOG("somethings")
      for _, v in pairs(M.mEventList[i]) do
        if v.mType == "buddha" then
          DDLOG("add new buddha %s", v.mId)
          rtn_result.team[v.mId] = rtn_result.team[v.mId] or 0
          rtn_result.team[v.mId] = rtn_result.team[v.mId] + 1
        end
      end
    end
  end
  if fight_res == Const.BATTLE_RESULT.LOSE then
    rtn_result.left_hp = 0
  end
  dump(rtn_result)
  local pNode = display.newNode():addTo(display.getRunningScene(), -1)
  pNode:setNodeEventEnabled(true)
  pNode:safeSocketRequest("CMD_CLAN_COMPETE_BOSS_FIGHT_RESULT", rtn_result, function(event)
    M.addScore(event)
  end)
end

return M

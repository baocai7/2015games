local PanelBG = require("app.game.panel.PanelBG")
local PanelTimer = require("app.game.panel.PanelTimer")
local PanelSpiritPVP = require("app.game.panel.PanelSpiritPVP")
local PanelGame = require("app.game.panel.PanelGame")
local PanelTeamPVP = require("app.game.panel.PanelUnionTeam")
local LayerWarResult = require("app.layers.LayerPVPOlResult")
local Skip = require("app.sprites.pvp.SkipUnionBattle")
local PanelRelics = require("app.game.panel.PanelRelics")
local CLASS_NAME = "LayerUnionFight"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.NORMAL = 1
M.BOSS = 2
M.BATTLE_TIME = 300

function M:ctor(mTag)
  self.mTag = GameManager.UNION_FIGHT_MODE or 1
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  cc.Director:getInstance():getScheduler():setTimeScale(2)
  if self.mTag == Const.UNION_FIGHT_TYPE.BOSS then
    M.BATTLE_TIME = 100
  else
    M.BATTLE_TIME = 300
  end
  self.mGamePanel = nil
  self.mBgPanel = nil
  self.buddhaInfo = CloudData.ALLY_INFO
  self.enemyInfo = CloudData.ENEMY_INFO
  self.mWarResult = nil
  GameManager.PVP_BUDDHA_INFO = {}
  GameManager.PVP_ENEMY_INFO = {}
  GameManager.PVP_BUDDHA_INFO.nick = self.buddhaInfo.userName
  GameManager.PVP_ENEMY_INFO.nick = self.enemyInfo.userName
  self:initData()
  self:initUI()
  self:initMode()
  self:setNodeEventEnabled(true)
end

function M:initData()
  GameData.CIMELIA_DEF = DataUtils.getDefCimeliaInfo()
  GameData.CIMELIA_ATK = DataUtils.getAtkCimeliaInfo()
  GameData.TOWER_DISTANCE = 1000
  GameData.CLEAN_TIME = M.BATTLE_TIME
  GameData.FRAME_PER_SECOND = 24
  GameData.TEAM_ICON = {}
  DYSoundMgr.setMusicOn(false)
  Skip.init(self.mTag, nil, M.BATTLE_TIME)
  BMgrOL.SKIP_BATTLE = false
  DYSoundMgr.setMusicOn(true)
  self.mUpdateSch = self:performWithDelay(function()
    self:schedule(function()
      self:update()
    end, 1 / GameData.FRAME_PER_SECOND * 2)
  end, 0.5)
  self.mPanelTable = {}
end

function M:initMode()
  local buddha_left_hp = self.buddhaInfo.left_hp
  local monster_left_hp = self.enemyInfo.left_hp
  local buddhaTower = BMgrOL.getBuddhaTower()
  local monsterTower = BMgrOL.getMonsterTower()
  if buddha_left_hp ~= -1 then
    buddhaTower.hpCur_ = buddha_left_hp
    buddhaTower:refreshProgress(buddha_left_hp)
  end
  if monster_left_hp ~= -1 then
    monsterTower.hpCur_ = monster_left_hp
    monsterTower:refreshProgress(monster_left_hp)
  end
  if self.mTag == M.BOSS then
    self.bossId = self.enemyInfo.bossId
    self.bossHp = self.enemyInfo.cur_hp
    self.bossLevel = self.enemyInfo.level
    self.bossMaxHp = self.enemyInfo.max_hp
    monsterTower.hpCur_ = 999999999
    monsterTower.mCantAttack = true
    monsterTower:hide()
    self.mDefBoss = BMgrOL.createDefenceBoss(self.bossId, self.bossLevel)
    self.mDefBoss.initABLY[LIFE_CUR] = self.bossHp
    self.mDefBoss.initABLY[LIFE] = self.bossMaxHp
    self.mDefBoss.mView:updateBlood({
      rCurHp = self.bossHp,
      rMaxHp = self.bossMaxHp
    })
  end
end

function M:initUI()
  self.mBgPanel = PanelBG.new(GameData.TOWER_DISTANCE):pos(0, 0):addTo(self)
  self.mGamePanel = PanelGame.new():addTo(self, 2)
  table.insert(self.mPanelTable, self.mGamePanel)
  local timerPanel = PanelTimer.new(GameData.CLEAN_TIME, handler(self, self.onEventPanelTimer)):align(display.CENTER, display.width * 0.35, display.height * 0.93):addTo(self, 1)
  table.insert(self.mPanelTable, timerPanel)
  self.mTimePanel = timerPanel
  self.mTeamPanel = PanelTeamPVP.new(handler(self, self.onEventPanelTeam)):align(display.CENTER_BOTTOM, display.cx, 0):addTo(self, 1)
  table.insert(self.mPanelTable, self.mTeamPanel)
end

function M:update()
  local i = 0
  while i < 2 do
    if self.mWarResult ~= nil then
      self:stopAction(self.mUpdateSch)
      self:onEventPanelGame()
      return
    end
    BMgrOL.update()
    self.mTeamPanel:update()
    self.mTimePanel:updateUnionFightTimer()
    local buddhaTower = BMgrOL.getBuddhaTower()
    local monsterTower = BMgrOL.getMonsterTower()
    if 0 >= buddhaTower:getHp() then
      self.mWarResult = Const.BATTLE_RESULT.LOSE
    elseif 0 >= monsterTower:getHp() then
      self.mWarResult = Const.BATTLE_RESULT.WIN
    elseif self.mDefBoss and 0 >= self.mDefBoss:getCurABLY(LIFE_CUR) then
      self.mWarResult = Const.BATTLE_RESULT.WIN
    end
    if self.mTeamPanel.mCurrNpcNum == self.mTeamPanel.mNpcCountNum then
      local buddhaList = BMgr.getBuddhaList()
      local monsterList = BMgr.getMonsterList()
      if 0 == #buddhaList and 0 == #monsterList then
        DDLOG(DYLang.getString("S247", ""))
        self.mWarResult = self:unionDefenceWin()
      end
    end
    i = i + 1
  end
end

function M:unionDefenceWin()
  local result = Const.BATTLE_RESULT.LOSE
  if self.buddhaInfo.flag == Const.UNION_FIGHT_DEFENCE then
    result = Const.BATTLE_RESULT.WIN
  end
  return result
end

function M:onEventPanelGame(tag, param)
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  self:gamePause()
  local warResult = self.mWarResult
  CloudData.PVP_ONLINE_RESULT = {}
  CloudData.PVP_ONLINE_RESULT.is_win = warResult
  BMgrOL.getBuddhaTower():getLastHp()
  BMgrOL.getMonsterTower():getLastHp()
  local ally = {
    hpRate = BMgrOL.getBuddhaTower():getHpRate(),
    union_name = self.buddhaInfo.clan_name,
    server_name = self.buddhaInfo.server_name,
    add_score = 0
  }
  local enemy = {
    hpRate = BMgrOL.getMonsterTower():getHpRate(),
    union_name = self.enemyInfo.clan_name,
    server_name = self.enemyInfo.server_name,
    add_score = 0
  }
  local enemyUid = CloudData.ENEMY_INFO.uid
  if self.mTag == Const.UNION_FIGHT_TYPE.BOSS then
    enemyUid = 0
  end
  local msg = {
    fight_index = CloudData.ALLY_INFO.fight_index,
    winner,
    loser
  }
  if warResult == Const.BATTLE_RESULT.LOSE then
    ally.hpRate = 0
    ally.add_score = Skip.lose_score or 0
    enemy.add_score = Skip.win_score or 0
    msg.winner = enemyUid
    msg.loser = CloudData.ALLY_INFO.uid
  else
    ally.add_score = Skip.win_score or 0
    enemy.add_score = Skip.lose_score or 0
    msg.winner = CloudData.ALLY_INFO.uid
    msg.loser = enemyUid
  end
  if self.mTag == Const.UNION_FIGHT_TYPE.BOSS then
    ally.add_score = Skip.add_score
    enemy.add_score = 0
    enemy.tmpDesc = DYLang.getString("S248", "")
    local rate = math.floor(self.mDefBoss:getCurABLY(LIFE_CUR) / self.mDefBoss:getCurABLY(LIFE) * 100)
    if rate < 0 then
      rate = 0
    end
    enemy.hpRate = rate
  end
  BMgrOL.setUnionBattleCount(ally, enemy)
  local enemyUid = CloudData.ENEMY_INFO.uid
  if self.mTag == Const.UNION_FIGHT_TYPE.BOSS then
    enemyUid = 0
  end
  self:safeSocketRequest("CMD_CLAN_COMPETE_RECORD_FIGHT_DATA", msg)
  LayerWarResult.new():addTo(self, 50)
  DDLOG(DYLang.getString("S249", ""), BMgrOL.getBuddhaTower():getHp(), BMgrOL.getMonsterTower():getHp(), BMgrOL.getCurFrame())
end

function M:onEventPanelSpeed(param)
end

function M:onEventPanelTimer(param)
  self.mWarResult = self:unionDefenceWin()
  self:onEventPanelGame(result)
end

function M:onEventButtonSpirit(param)
end

function M:onEventPanelTeam(params)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == 77 then
    DDLOG("\232\183\179\232\191\135\230\136\152\230\150\151")
    BMgrOL.SKIP_BATTLE = true
  end
  return true
end

function M:gamePause()
  for k, v in pairs(self.mPanelTable) do
    if v.pauseEx then
      v:pauseEx()
    end
    v:pause()
  end
  self:pause()
end

function M:gameResume()
  for k, v in pairs(self.mPanelTable) do
    if v.resumeEx then
      v:resumeEx()
    end
    v:resume()
  end
  self:resume()
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

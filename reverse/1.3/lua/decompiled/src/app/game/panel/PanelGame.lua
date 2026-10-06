local CimeliaRangeTrips = require("app.sprites.CimeliaRangeTips")
local CLASS_NAME = "PanelGame"
local M = {}
M = class(CLASS_NAME, function()
  return display.newNode(CLASS_NAME)
end)
M.TAG_TOWER_MONSTER_DEAD = 1000
M.TAG_TOWER_BUDDHA_DEAD = 1001
M.TAG_TOWER_BUDDHA_REACH_POINT = 1002
M.TAG_MONSTER_BOSS_DEAD = 1003
M.TAG_TOWER_BUDDHA_UNDERATTACK = 1005

function M:ctor(cb)
  self.mBG = GameData.BG
  self.mCallback = cb
  self.mCoreNode = nil
  self.mtype = GameData.GAME_TYPE
  self:init()
  self:layoutUI()
  self:setNodeEventEnabled(true)
  self:setKeypadEnabled(true)
end

function M:layoutUI()
  local towerBuddha, towerMonster
  if 6 == GameManager.MODE then
    towerBuddha = BMgr.createTowerBuddha()
    local PanelEnemyTower = require("app.game.pvpOL.PanelEnemyTower")
    towerMonster = PanelEnemyTower.new()
  elseif self.mtype == 0 or self.mtype == 1 then
    towerBuddha = BMgr.createTowerBuddha()
    towerMonster = BMgr.createTowerMonster(GameManager.STAGE_ID)
  elseif self.mtype == 3 then
    DDLOG(DYLang.getString("S255", ""))
    towerBuddha = BMgr.createTowerBuddha()
    towerMonster = BMgr.createTowerMonster(GameManager.STAGE_ID)
    towerMonster:setVisible(false)
    self:createTrainBoss()
  elseif self.mtype == 2 then
    towerBuddha = BMgr.createTowerBuddha("escort")
    towerMonster = BMgr.createTowerMonster(GameManager.STAGE_ID, "escort")
    towerBuddha:addEventListener("REACH_POINT", function()
      self:invokeCallback(M.TAG_TOWER_MONSTER_DEAD)
    end)
  end
  BMgr.setBuddhaTower(towerBuddha)
  BMgr.setMonsterTower(towerMonster)
  local x = GameData.BG:getContentSize().width / 2 - self.mTowerDistance / 2
  towerBuddha:setPosition(cc.p(x + self.mTowerDistance, display.height * 0.015))
  towerMonster:setPosition(cc.p(x, display.height * 0.015))
  local buddhaPosX, buddhaPosY = towerBuddha:getPosition()
  local monsterPosX, monsterPosY = towerMonster:getPosition()
  BMgr.setBuddhaPos(cc.p(buddhaPosX, buddhaPosY))
  BMgr.setMonsterPos(cc.p(monsterPosX, monsterPosY))
  DDLOG(DYLang.getString("S256", ""), buddhaPosX, buddhaPosY)
  DDLOG(DYLang.getString("S257", ""), monsterPosX, monsterPosY)
  towerMonster:addEventListener("GAME_WIN", function()
    self:invokeCallback(M.TAG_TOWER_MONSTER_DEAD)
  end)
  towerMonster:addEventListener("GAME_ES_TOWER_BOOM", function()
    towerMonster:pause()
    towerBuddha:runSpeedUp()
  end)
  towerMonster:addEventListener("BOSS_DEAD", function()
    self:invokeCallback(M.TAG_MONSTER_BOSS_DEAD)
  end)
  towerBuddha:addEventListener("GAME_LOSE", function()
    self:invokeCallback(M.TAG_TOWER_BUDDHA_DEAD)
  end)
  self.cimeliaRangeTrips = CimeliaRangeTrips.new()
  self.cimeliaRangeTrips:setPosition(cc.p(0, 15))
  GameData.climeliaRangeTrip = self.cimeliaRangeTrips
  self.mBG:addChild(self.cimeliaRangeTrips, 1)
  self.mBG:addChild(towerBuddha, 3)
  self.mBG:addChild(towerMonster, 2)
end

function M:createTrainBoss()
  DDLOG(DYLang.getString("S258", "") .. GameManager.DEFENCE_BOSS_ID)
  local monster = BMgrOL.createDefenceBoss(GameManager.DEFENCE_BOSS_ID, GameManager.DEFENCE_BOSS_LEVEL, cc.p(400, 0))
  monster.mView:setScale(1.5)
  monster.mView:setLocalZOrder(50)
  monster.initABLY[LIFE] = 999999999999
  monster.initABLY[LIFE_CUR] = monster.initABLY[LIFE]
  monster.mView:hideBlood()
  monster.mMoveAble = false
  monster.mAttackAble = false
  GameData.DEFENCE_BOSS = monster
end

function M:mode2()
  local towerBuddha = BMgr.createTowerBuddha()
end

function M:init()
  self.mTowerDistance = GameData.TOWER_DISTANCE
end

function M:pause()
  BMgr.pause()
end

function M:resume()
  BMgr.resume()
end

function M:invokeCallback(tag, param)
  DDLOG(CLASS_NAME .. ": invokeCallback, tag = %d", tag)
  BMgr.pause()
  if self.mCallback then
    self.mCallback(tag, param)
  end
end

function M:onNotify(name, param)
  if name == DY_KEY.kUpdateTowerRatio then
    if param.isBuddha then
      local buddhaTower = BMgrOL.getBuddhaTower()
      buddhaTower:updateHpRatio(param.delta)
    else
      local monsterTower = BMgrOL.getMonsterTower()
      monsterTower:updateHpRatio(param.delta)
    end
  end
end

function M:onEnter()
  DYNotification.registerScriptObserver(self, handler(self, self.onNotify), DY_KEY.kUpdateTowerRatio)
end

function M:onExit()
  DYNotification.removeAllObservers(self)
end

return M

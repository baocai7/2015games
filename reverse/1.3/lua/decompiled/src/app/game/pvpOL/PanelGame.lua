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
  local towerBuddha = BMgrOL.createTowerBuddha()
  local PanelEnemyTower = require("app.game.pvpOL.PanelEnemyTower")
  local towerMonster = PanelEnemyTower.new()
  BMgrOL.setBuddhaTower(towerBuddha)
  BMgrOL.setMonsterTower(towerMonster)
  BMgrOL.setBuddhaTowerHp(towerBuddha.hpMax_)
  BMgrOL.setEnemyTowerHp(towerMonster.hpMax_)
  local x = GameData.BG:getContentSize().width / 2 - self.mTowerDistance / 2
  towerBuddha:setPosition(cc.p(x + self.mTowerDistance, display.height * 0.015))
  towerMonster:setPosition(cc.p(x, display.height * 0.015))
  BMgrOL.setBuddhaPos(cc.p(towerBuddha:getPosition()))
  BMgrOL.setMonsterPos(cc.p(towerMonster:getPosition()))
  towerMonster:addEventListener("GAME_WIN", function()
    self:invokeCallback(M.TAG_TOWER_MONSTER_DEAD)
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

function M:mode2()
  local towerBuddha = BMgrOL.createTowerBuddha()
end

function M:init()
  self.mTowerDistance = GameData.TOWER_DISTANCE
end

function M:pause()
  BMgrOL.pause()
end

function M:resume()
  BMgrOL.resume()
end

function M:invokeCallback(tag, param)
  DDLOG(CLASS_NAME .. ": invokeCallback, tag = %d", tag)
  BMgrOL.pause()
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

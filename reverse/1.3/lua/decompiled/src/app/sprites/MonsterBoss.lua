local Actor = require("app.sprites.pvp.SpriteActorModel")
local DYClass = "MonsterBoss"
local FLAG_BUDDHA = 1
local FLAG_MONSTER = 2
local M = {}
M = class(DYClass, Actor)

function M:ctor(monsterModel, position)
  M.super.ctor(self, monsterModel, position, FLAG_MONSTER)
  print("I' BOSS")
  self.mView:dispatchEvent({
    name = "HIDE_BLOOD_BAR"
  })
  self.initABLY[LIFE_CUR] = CloudData.PURGATORY_BOSS_LEFT_HP
  if GameManager.MODE == 10 then
    self.initABLY[LIFE_CUR] = CloudData.AGGRESS_BOSS_LEFT_HP
  end
  self.mTag = "BOSS"
  self.model_.monsterType = 3
  self.isMonsterBoss = true
  BMgrOL.setPurgatoryBoss(self)
end

function M:increaseHP(hp, isRation)
  M.super.increaseHP(self, hp, isRation)
  local cupHp = self:getCurABLY(LIFE_CUR)
  DYNotification.postNotification(DY_KEY.kMonsterBossBlood, cupHp)
end

function M:decreaseHP(hp)
  M.super.decreaseHP(self, hp)
  local cupHp = self:getCurABLY(LIFE_CUR)
  DYNotification.postNotification(DY_KEY.kMonsterBossBlood, cupHp)
end

function M:onDied()
  M.super.onDied(self)
  BMgr.getMonsterTower():dispatchEvent({name = "GAME_WIN"})
end

function M:changeModel()
end

return M

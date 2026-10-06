local M = {}
M = class("TowerBuddha", function()
  return display.newNode()
end)

function M:ctor(pos)
  cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
  self.hpMax_ = GameData.CIMELIA_DEF.towerHP
  self.hpCur_ = self.hpMax_
  DYComponent.getTable(self, "battleData.baseData")
  self.mFlag = 10
  self.mCantAttack = false
  self.mPos = pos
end

function M:underAttack(source, loseHp)
  loseHp = Const.TowerBuddhaLoseHp or loseHp
  DDLOG(" \230\136\145\230\150\185\229\161\148\230\142\137\232\161\128" .. loseHp)
  self.hpCur_ = self.hpCur_ - loseHp
  if self.hpCur_ <= 0 then
    DDLOG(DYLang.getString("S1588", ""))
    self:dead()
    return
  end
end

function M:increaseHP(hp)
  self.hpCur_ = self.hpCur_ + hp
  if self.hpCur_ > self.hpMax_ then
    self.hpCur_ = self.hpMax_
  end
end

function M:dead()
  self:dispatchEvent({name = "GAME_LOSE"})
end

function M:getMyBoundingBox()
  local tmpWidth = 0
  local size = {}
  size.width = 130
  local tmpX = self:getPositionX()
  local tmpWidth = tmpX - size.width / 20
  return tmpWidth
end

function M:getContentSize()
  return self.towerArmature_:getContentSize()
end

function M:getActorType()
  return 1
end

function M:getCurABLY(index)
  return self.initABLY[index] + self.addABLY[index] + self.tmpABLY[index]
end

function M:addBuff()
  return nil
end

function M:getHp()
  return self.hpCur_
end

function M:getLastHp()
  self.hpCur_ = self.hpCur_ - math.floor(self.hpMax_ * 0.15)
  if self.hpCur_ < 0 then
    self.hpCur_ = 0
  end
  return self.hpCur_
end

function M:getPosition()
  return self.mPos
end

function M:getPositionX()
  return self.mPos.x
end

function M:getPositionY()
  return self.mPos.y
end

function M:setPosition(pos)
  self.mPos.x = pos.x
  self.mPos.y = pos.y
end

function M:setPositionX(x)
  self.mPos.x = x
end

return M

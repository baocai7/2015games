local Actor = require("app.sprites.Actor")
local DYClass = "Buddha"
local M = {}
M = class(DYClass, Actor)

function M:ctor(buddhaModel, position)
  self.mFaceTo = -1
  self.mFlag = 1
  M.super.ctor(self, buddhaModel, position)
  if self.model_.isRebel == 0 then
    self.mAnimator.armature_:setScaleX(-1 * self.mAnimator.armature_:getScaleX())
  end
end

function M:updateLogic()
  M.super.updateLogic(self)
end

function M:canAttack()
  if self.mTarget and self.mTarget.mState ~= "Died" then
    local tmpdis = 9999
    tmpdis = self:dis(cc.p(self:getPosition()), cc.p(self.mTarget:getMyBoundingBox(false), self.mTarget:getPositionY()))
    if tmpdis < self.model_.attackDistance * Const.Zoom0 * self.model_.sizeInBattle then
      return true
    end
  end
  return false
end

function M:onAttack()
  if self.mTarget.mCantAttack then
    self:onIdle()
    return
  end
  M.super.onAttack(self)
end

function M:onMove()
  M.super.onMove(self)
end

function M:onDead()
  M.super.onDead(self)
  if self.mState ~= "Died" then
    return
  end
  BMgr.removeBuddha(self)
  BMgr.setKillBuddha(1)
  self:performWithDelay(function()
    self:removeSelf()
  end, 3)
end

function M:findTarget()
  local mTargetList = clone(BMgr.getMonsterList())
  local tmpTower = clone(BMgr.getMonsterTower())
  local tmpRtnList = {}
  table.insert(mTargetList, tmpTower)
  local maxDis = 9999
  local tmpNearset
  for i, tmpEnemy in pairs(mTargetList) do
    while true do
      if tmpEnemy.mBUFF and tmpEnemy.mBUFF["1012"] == 1 then
        break
      end
      if tmpEnemy:getPositionX() > self:getPositionX() then
        break
      end
      local tmpdis = self:dis(cc.p(self:getPosition()), cc.p(tmpEnemy:getMyBoundingBox(false), tmpEnemy:getPositionY()))
      if maxDis > tmpdis then
        maxDis = tmpdis
        tmpNearset = tmpEnemy
      end
      break
    end
  end
  return tmpNearset
end

return M

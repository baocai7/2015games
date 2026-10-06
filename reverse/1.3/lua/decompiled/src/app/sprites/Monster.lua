local Actor = require("app.sprites.Actor")
local DYClass = "Monster"
local M = {}
M = class(DYClass, Actor)

function M:ctor(monsterModel, position)
  self.mFaceTo = 1
  self.mFlag = 2
  M.super.ctor(self, monsterModel, position)
  if self.model_.isRebel == 1 then
    self.mAnimator.armature_:setScaleX(-1 * self.mAnimator.armature_:getScaleX())
    local ziBone = self.mAnimator.armature_:getBone("zi")
    if ziBone then
      ziBone:setScaleX(-1)
    end
  end
  if self.model_.monsterType == 2 then
    self.initABLY[RES_REBEL] = 50
  elseif self.model_.monsterType == 3 then
    self.initABLY[RES_REBEL] = 100
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

function M:onDead()
  M.super.onDead(self)
  if self.mState ~= "Died" then
    return
  end
  self.model_.value = self.model_.value or 0
  DDLOG(DYLang.getString("S1499", "") .. self.model_.value)
  if GameData.SpiritPanel and GameData.SpiritPanel.getSpiritIconPos then
    local frames = display.newFrames("lingqi%d.png", 1, 2)
    local animation = display.newAnimation(frames, 0.1)
    local spirit = display.newSprite()
    spirit:playAnimationForever(animation)
    spirit:setPosition(self:getPositionX() - self.model_.backLength * 0.4 * self.model_.sizeInBattle, self:getPositionY() + self.sprite_:getContentSize().height)
    display.getRunningScene():addChild(spirit)
    local points = {
      cc.p(150, 0),
      cc.p(-150, 0),
      cc.p(0, 0)
    }
    local b = cc.BezierBy:create(1, points)
    local m = cc.MoveTo:create(1, cc.p(GameData.SpiritPanel:getSpiritIconPos()))
    local seq = transition.sequence({b, m})
    transition.execute(spirit, seq, {
      onComplete = function()
        GameData.updateSpirit(self.model_.value)
        GameData.SpiritPanel:scaleSpirit()
        spirit:removeSelf()
      end
    })
  end
  BMgr.removeMonster(self)
  self:performWithDelay(function()
    self:removeSelf()
  end, 3)
end

function M:findTarget()
  local mTargetList = clone(BMgr.getBuddhaList())
  local tmpTower = clone(BMgr.getBuddhaTower())
  table.insert(mTargetList, tmpTower)
  local maxDis = 9999
  local tmpNearset
  for i, tmpEnemy in pairs(mTargetList) do
    while true do
      if tmpEnemy.mBUFF and tmpEnemy.mBUFF["1012"] == 1 then
        break
      end
      if tmpEnemy:getPositionX() < self:getPositionX() then
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

function M:flyUp()
  if self.mState ~= "Died" then
    return
  end
  self.isFlying_ = true
  self.actionFlyUp_ = cc.Spawn:create(cc.MoveBy:create(0.5, cc.p(-100, 1000)), cc.RotateBy:create(0.5, 3600))
  self:runAction(self.actionFlyUp_)
end

function M:fallDown()
  local towerPos = BMgr.getMonsterPos()
  self:stopAction(self.actionFlyUp_)
  self:setPosition(towerPos.x, towerPos.y + 1000)
  local spawn = cc.Spawn:create(cc.MoveTo:create(2.5, cc.p(towerPos)), cc.RotateBy:create(2.5, 3600))
  local seq = transition.sequence({
    spawn,
    cc.CallFunc:create(function()
      self:setRotation(0)
      self.isInHurt_ = true
      self.mAnimator:changeArmatureStateTo("HURT")
      self.isFlying_ = false
    end)
  })
  self:runAction(seq)
end

return M

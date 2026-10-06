local BloodBar = require("app.component.BloodBar")
local BuffNotice = require("app.sprites.BuffNotice")
local EVENT_NAME = {
  CastSkill = "CastSkill",
  UnderAttack = "UnderAttack",
  AddBuff = "AddBuff",
  HaveHeal = "HaveHeal",
  AttackComplete = "AttackComplete",
  HurtComplete = "HurtComplete"
}
local LAYER = {
  BLOOD = 10,
  ANIMATOR = 5,
  BUFF_NOTICE = 20
}
local AniState = {
  idle = 0,
  walk = 1,
  atk = 2,
  hurt = 3,
  s1_atk = 4,
  s2_atk = 5,
  s3_atk = 6,
  s4_atk = 7,
  dead = 100
}
local DYClass = "SpriteActorView"
local M = class(DYClass, function()
  return display.newNode()
end)

function M:ctor(model, position, flag)
  cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
  if flag == 1 then
    self.mFaceTo = -1
  else
    self.mFaceTo = 1
  end
  self.mFlag = flag
  self.mAnimator = SpriteViewMgr.createBoneView(model.armatureFile):addTo(self, LAYER.ANIMATOR)
  self.mAnimator:setScale(Const.Zoom0 * model.sizeInBattle)
  self.mAnimator:setCascadeColorEnabled(true)
  self.mAnimator:setCascadeOpacityEnabled(true)
  self.mAnimator:setSpeed(1)
  if self.mFaceTo == 1 and model.isRebel == 1 or self.mFaceTo == -1 and model.isRebel == 0 then
    self.mAnimator:setScaleX(-1 * self.mAnimator:getScaleX())
    local ziBone = self.mAnimator:getBone("zi")
    if ziBone then
      ziBone:setScaleX(-1)
    end
  end
  self:setPosition(position.x, position.y)
  self:addTo(GameData.BG, 5)
  self.mAttackEffect = model.soundFile
  if self.mFaceTo == -1 then
    self.mFlag = 1
  else
    self.mFlag = 2
  end
  self.mLastState = nil
  self.mLastPos = nil
  self.mHitEffectCount = 0
  self.mOrignWidth = model.orignWidth * model.sizeInBattle
  self.mOrignHeight = model.orignHeight * model.sizeInBattle
  self.mSizeInBattle = model.sizeInBattle
  self:size(self.mOrignWidth, self.mOrignHeight)
  self:initUI(self.mFlag, model.monsterType or 1)
  self:initEvent()
end

function M:initUI(flag, monsterType)
  self.bloodBar = BloodBar.new(flag, monsterType):addTo(self, LAYER.BLOOD)
  self.bloodBar:setScale(Const.Zoom0)
  self.bloodBar:setPositionY(self.mOrignHeight * 1.1 * Const.Zoom0)
  if actorType == 1 then
    self.bloodBar:hide()
  end
  self.buffNotice = BuffNotice.new():pos(0, self.mOrignHeight * 1.2):addTo(self.mAnimator, LAYER.BUFF_NOTICE)
  self.buffNotice:setAnchorPoint(1, 0.5)
end

function M:initEvent()
  self:addEventListener(EVENT_NAME.CastSkill, handler(self, self.castSkillView))
  self:addEventListener(EVENT_NAME.UnderAttack, handler(self, self.underAttack))
  self:addEventListener("ADD_BUFF", handler(self, self.addBuffView))
  self:addEventListener("REMOVE_BUFF", handler(self, self.removeBuffView))
  self:addEventListener("UNDATE_BLOOD", handler(self, self.updateBlood))
  self:addEventListener("REBEL", handler(self, self.onRebel))
  self:addEventListener("SHOW_NOTICE", handler(self, self.showNotice))
  self:addEventListener("RE_LIVE", handler(self, self.inRelive))
  self:addEventListener("OUT_RE_LIVE", handler(self, self.outRelive))
  self:addEventListener("HIDE_BLOOD_BAR", handler(self, self.hideBlood))
  self:addEventListener("KillByWutian", handler(self, self.killByWutian))
  self:addEventListener("TAG_PAUSE", handler(self, self.pauseEX))
  self:addEventListener("TAG_RESUME", handler(self, self.resumeEX))
  self.mAnimator:addEventListener("ATTACK_COMPLETE", handler(self, self.attackComplete))
  self.mAnimator:addEventListener("HURT_COMPLETE", handler(self, self.hurtComplete))
end

function M:attackComplete()
  self.mAnimator.changeArmatureStateTo(AniState.idle)
end

function M:hurtComplete()
  self.mAnimator.changeArmatureStateTo(AniState.idle)
end

function M:setAnimationSpeed(value)
  self.mAnimator:setSpeed(value)
end

function M:update(state, pos)
  if state == AniState.dead then
    self:killSelf()
    return false
  end
  if self.mLastState ~= state then
    if state == AniState.atk then
      DYSoundMgr.playEffect(self.mAttackEffect)
    end
    self.mAnimator.changeArmatureStateTo(state)
  end
  self.mLastState = state
  self:setLocalZOrder(9999 - pos.y)
  self:setPosition(pos)
end

function M:castSkillView()
  display.addSpriteFrames("buff/wandPic.plist", "buff/wandPic.png")
  local frames = display.newFrames("wandPicCast%d.png", 1, 7)
  local animation = display.newAnimation(frames, 0.1)
  local sp = display.newSprite()
  local rect = self:getContentSize()
  sp:setAnchorPoint(cc.p(0.5, 0.5))
  sp:setPositionY(rect.height / 4)
  sp:setScale((rect.width / 1.4 + rect.height / 1.4) / 350)
  self:addChild(sp, 50)
  sp:playAnimationOnce(animation, true)
end

function M:showDamage(hpLose, damageType)
  local tmpNode = SpriteViewMgr.showDamage(hpLose, damageType)
  tmpNode:setScale(Const.Zoom0)
  tmpNode:setPosition(0, self.mOrignHeight * Const.Zoom0 * self.mSizeInBattle)
  tmpNode:setCascadeOpacityEnabled(true)
  local spawn = cc.Spawn:create(cc.MoveBy:create(1.2, cc.p(0, 120)), cc.FadeOut:create(1.2))
  tmpNode:runAction(transition.sequence({
    spawn,
    cc.CallFunc:create(function()
      tmpNode:removeSelf()
    end)
  }))
  self:addChild(tmpNode, 50)
end

function M:showNotice(event)
  self.buffNotice:PlayBuffNotice(event.x, event.y)
end

function M:underAttack(event)
  SpriteViewMgr.hurtEffect(self)
end

function M:inRelive()
  self.mAnimator:setVisible(false)
  self.bloodBar:setVisible(false)
  if not self.mInRelive then
    self.mInRelive = true
    self.relive = SpriteViewMgr.createBuffView("fuhuo", self.mOrignHeight, self.mOrignWidth):scale(0.5):addTo(self)
    local m1 = cc.MoveBy:create(0.5, cc.p(0, -10))
    local m2 = cc.MoveBy:create(0.5, cc.p(0, 10))
    self.relive:runAction(cc.RepeatForever:create(transition.sequence({m1, m2})))
  end
end

function M:outRelive()
  self.mAnimator:setVisible(true)
  self.bloodBar:setVisible(true)
  self.mInRelive = false
  if self.relive then
    self.relive:runAction(cc.RemoveSelf:create())
    self.relive = nil
  end
end

function M:updateBlood(event)
  if event.rCurHp and event.rMaxHp then
    self.bloodBar:setHp(event.rCurHp, event.rMaxHp)
  end
  if event.rHplose and event.rType then
    self:showDamage(event.rHplose, event.rType)
  end
end

function M:addBuffView(event)
  if event.tBuffName == nil then
    return
  end
  if event.tBuffName == "steal" then
    self:inStealView()
  elseif event.tBuffName == "stone" then
    self:inStoneView()
  elseif event.tBuffName == "poison" then
    self:inPoisonView()
  elseif event.tBuffName == "freeze" then
    self:inFreezeView()
  elseif event.tBuffName == "blurry" then
    self:inBlurry()
  else
    local sp, zOrder = SpriteViewMgr.createBuffView(event.tBuffName, self.mOrignHeight, self.mOrignWidth)
    zOrder = zOrder or 50
    sp:addTo(self.mAnimator, zOrder, tonumber(event.tBuffId))
  end
end

function M:removeBuffView(event)
  if event.tBuffName == "steal" then
    self:outStealView()
  elseif event.tBuffName == "stone" then
    self:outStoneView()
  elseif event.tBuffName == "poison" then
    self:outPoisonView()
  elseif event.tBuffName == "freeze" then
    self:outFreezeView()
  elseif event.tBuffName == "blurry" then
    self:outBlurry()
  end
  if self.mAnimator:getChildByTag(event.tBuffId) then
    self.mAnimator:removeChildByTag(tonumber(event.tBuffId))
  end
end

function M:inStealView()
  transition.fadeTo(self.mAnimator, {opacity = 60, time = 1})
end

function M:outStealView()
  transition.fadeTo(self.mAnimator, {opacity = 255, time = 1})
end

function M:inStoneView()
  self.mAnimator:setColor(cc.c3b(30, 30, 30))
  self.isInTint_ = true
  self.mAnimator:getAnimation():pause()
end

function M:outStoneView()
  self.mAnimator:setColor(cc.c3b(255, 255, 255))
  self.isInTint_ = false
  self.mAnimator:getAnimation():resume()
end

function M:inPoisonView()
  self.mAnimator:setColor(cc.c3b(136, 21, 234))
  self.isInTint_ = true
end

function M:outPoisonView()
  self.mAnimator:setColor(cc.c3b(255, 255, 255))
  self.isInTint_ = false
end

function M:inFreezeView()
  self.mAnimator:setColor(cc.c3b(52, 161, 230))
  self.isInTint_ = true
end

function M:outFreezeView()
  self.mAnimator:setColor(cc.c3b(255, 255, 255))
  self.isInTint_ = false
end

function M:inBlurry()
  local sequence = transition.sequence({
    cc.FadeTo:create(0.5, 128),
    cc.FadeTo:create(0.5, 255)
  })
  local action = cc.RepeatForever:create(sequence)
  self.mAction = action
  self.mAnimator:runAction(action)
end

function M:outBlurry()
  self.mAnimator:stopAction(self.mAction)
  transition.fadeTo(self.mAnimator, {opacity = 255, time = 0})
end

function M:killSelf()
  self.bloodBar:setVisible(false)
  self.mAnimator:setVisible(false)
  self:stopAllActions()
  DYSoundMgr.playEffect(DY_SND.sfx_siwang2)
  local frames = display.newFrames("wofangsiwangyan%d.png", 1, 7)
  local animation = display.newAnimation(frames, 0.15)
  local smoke = display.newSprite()
  smoke:setAnchorPoint(cc.p(0.5, 0))
  smoke:setScale(Const.Zoom0)
  self:addChild(smoke)
  smoke:playAnimationOnce(animation, true, function()
    local frames = display.newFrames("siwanglinghun%d.png", 1, 3)
    local animation = display.newAnimation(frames, 0.15)
    local soul = display.newSprite()
    soul:setAnchorPoint(cc.p(0.5, 0.5))
    soul:setScale(Const.Zoom0)
    soul:playAnimationForever(animation)
    soul:setPosition(self:getPosition())
    self:getParent():addChild(soul, 5)
    transition.execute(soul, cc.MoveBy:create(4, cc.p(0, 300)), {
      onComplete = function()
        soul:removeSelf()
        self:removeFromParent()
      end
    })
  end)
  if self.mFlag == 2 and (GameManager.MODE ~= 5 or GameManager.MODE ~= 8) and GameData.SpiritPanel and GameManager.STAGE_NUM ~= 0 then
    self:SpiritCover()
  end
end

function M:SpiritCover()
  if GameData.SpiritPanel and GameData.SpiritPanel.getSpiritIconPos then
    local frames = display.newFrames("lingqi%d.png", 1, 2)
    local animation = display.newAnimation(frames, 0.1)
    local spirit = display.newSprite()
    spirit:playAnimationForever(animation)
    spirit:setPosition(cc.p(self:getPositionX(), self:getPositionY() + self.mOrignHeight))
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
        GameData.SpiritPanel:scaleSpirit()
        spirit:removeSelf()
      end
    })
  end
end

function M:hideBlood()
  self.bloodBar:setHideForever()
end

function M:getAniBoundingBox()
  return self.mAnimator:getAniBoundingBox()
end

function M:onRebel()
  if self.mFlag == 1 then
    self.mFlag = 2
  else
    self.mFlag = 1
  end
  self.mAnimator:setScaleX(-1 * self.mAnimator:getScaleX())
  self.bloodBar:changeBloodColor(self.mFlag)
  if not self.mAnimator:getChildByTag(1004) then
    local sp = SpriteViewMgr.createBuffView("rebel", self.mOrignHeight, self.mOrignWidth)
    sp:addTo(self.mAnimator, 50, 1004)
  end
end

function M:killByWutian(event)
  local frames = display.newFrames("lingqi%d.png", 1, 2)
  local animation = display.newAnimation(frames, 0.1)
  local spirit = display.newSprite()
  spirit:playAnimationForever(animation)
  spirit:setPosition(cc.p(self:getPositionX(), self:getPositionY() + self.mOrignHeight))
  display.getRunningScene():addChild(spirit)
  local ranfY = math.random(1, 20)
  local movUp = cc.MoveTo:create(0.3, cc.p(spirit:getPositionX(), spirit:getPositionY() + ranfY))
  local movDown = cc.MoveTo:create(0.3, cc.p(spirit:getPositionX(), spirit:getPositionY() - ranfY))
  local point = self:getParent():convertToWorldSpace(event.tPos)
  local moveTo = cc.MoveTo:create(0.5, cc.p(point.x, point.y + 200))
  local seq = transition.sequence({
    movUp,
    movDown,
    movUp,
    movDown,
    movUp,
    movDown,
    movUp,
    movDown,
    moveTo
  })
  transition.execute(spirit, seq, {
    onComplete = function()
      spirit:removeSelf()
    end
  })
  self:setVisible(false)
  self:performWithDelay(function()
    self:removeSelf()
  end, 1)
end

function M:pauseEX()
  self.mAnimator:getAnimation():pause()
end

function M:resumeEX()
  self.mAnimator:getAnimation():resume()
end

return M

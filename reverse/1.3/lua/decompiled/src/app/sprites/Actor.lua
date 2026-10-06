local Skill = require("app.skill.Skill")
local Animator = require("app.component.DYAnimator")
local Buff = require("app.skill.Buff")
local BloodBar = require("app.component.BloodBar")
local BuffNotice = require("app.sprites.BuffNotice")
local MaxMoveSpeed = Const.MaxMoveSpeed
local DYClass = "Actor"
local M = {}
local deltaTime = 0
M = class(DYClass, function()
  return display.newNode()
end)

function M:ctor(buddhaModel, position)
  cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
  DYComponent.getTable(self, "battleData.baseData")
  self:initData(buddhaModel)
  self:initExtra(position)
  self:initEvent()
  self.mState = "Idle"
  self:schedule(function()
    self:updateLogic()
  end, 0.05)
  self.isAttackCoolDown_ = false
  self.canCastSkill = true
  self.mTarget = nil
  if self.skill[TRIGGER_ON_ONBATTLE] then
    for _, v in pairs(self.skill[TRIGGER_ON_ONBATTLE]) do
      v:checkTrigger(0)
      self:performWithDelay(function()
        v:onTrigger()
      end, 0.5)
    end
  end
end

function M:initData(buddhaModel)
  self.mAttackCount = 0
  self.mDefenceCount = 0
  self.mDamageFrom = nil
  self.isDead_ = false
  self.isInHurt_ = false
  self.model_ = buddhaModel
  self.skill = {}
  self.mBUFF = {}
  local skillId = self.model_.npcSkill
  local skillLv = self.model_.skillLv or {}
  if self.mFlag == 1 then
    self:initSkill(skillId)
  else
    self:initMonsterSkill(skillId, skillLv)
  end
  self.initABLY[LIFE] = buddhaModel.life
  self.initABLY[ATK] = buddhaModel.attack
  self.initABLY[PHY_DEF] = buddhaModel.phyDefence
  self.initABLY[MAG_DEF] = buddhaModel.magDefence
  self.initABLY[ATK_SPED] = buddhaModel.attackFrequency
  self.initABLY[MOV_SPED] = buddhaModel.runSpeed
  self.initABLY[HIT_RATE] = buddhaModel.phyDefIgnore
  self.initABLY[MISS_RATE] = buddhaModel.magDefIgnore
  self.initABLY[HIT_RATE] = buddhaModel.hitRate
  self.initABLY[MISS_RATE] = buddhaModel.missRate
  self.initABLY[CRIT_RATE] = buddhaModel.critRate
  self.initABLY[RES_CRIT_RATE] = buddhaModel.decritRate
  self.initABLY[CRIT_HARM_RATE] = buddhaModel.critHarmRate
  self.initABLY[REDUCE_HARM_RATE] = buddhaModel.decritHarmRate
  self.initABLY[ADD_HARM] = buddhaModel.harmAdd
  self.initABLY[REDUCE_HARM] = buddhaModel.harmReduce
  self.initABLY[RES_BACK] = buddhaModel.resBack
  self.initABLY[RES_STUN] = buddhaModel.resStun
  self.initABLY[RES_STONE] = buddhaModel.resStone
  self.initABLY[RES_REBEL] = buddhaModel.resRebel
  self.initABLY[RES_CHANGE] = buddhaModel.resChange
  self.initABLY[RES_PALSY] = buddhaModel.resPalsy
  self.initABLY[RES_FREEZE] = buddhaModel.resFreeze
  self.initABLY[RES_BURN] = buddhaModel.resBurn
  self.initABLY[RES_ALL] = buddhaModel.resAll
  self.initABLY[RES_POISON] = buddhaModel.resPoison
  self.maxHp_ = self:getCurABLY(LIFE)
  self.curHp_ = self.maxHp_
  self.lostHpAccum_ = 0
  self.mHitEffectCount = 0
end

function M:initEvent()
  self.mAnimator:addEventListener("ATTACK_COMPLETE", handler(self, self.attackComplete))
  self.mAnimator:addEventListener("HURT_COMPLETE", handler(self, self.hurtComplete))
end

function M:initSkill(index)
  local tmpSkill
  for i = 1, #index do
    while true do
      tmpSkill = Skill.new(self, index[i])
      if tmpSkill.mTriggerType == nil then
        break
      end
      local TriggerType = tonumber(tmpSkill.mTriggerType)
      self.skill[TriggerType] = self.skill[TriggerType] or {}
      table.insert(self.skill[TriggerType], tmpSkill)
      break
    end
  end
end

function M:initMonsterSkill(skillId, skillLv)
  local tmpSkill
  if not skillId or not skillLv then
    return
  end
  for i = 1, #skillId do
    while true do
      tmpSkill = Skill.new(self, skillId[i], tonumber(skillLv[i]))
      if tmpSkill.mTriggerType == nil then
        break
      end
      local TriggerType = tonumber(tmpSkill.mTriggerType)
      self.skill[TriggerType] = self.skill[TriggerType] or {}
      table.insert(self.skill[TriggerType], tmpSkill)
      break
    end
  end
end

function M:attackComplete()
  self:onIdle()
end

function M:hurtComplete()
  self.isInHurt_ = false
  self.mAnimator:setSpeed(1)
  self:onIdle()
end

function M:initExtra(position)
  self.mAnimator = Animator.new(self.model_.armatureFile)
  self.mAnimator:setScale(Const.Zoom0 * self.model_.sizeInBattle)
  self.mAnimator:addTo(self, 1)
  self.mAnimator:setCascadeColorEnabled(true)
  self.mAnimator:setCascadeOpacityEnabled(true)
  self:setPosition(cc.p(position.x, position.y))
  self.sprite_ = display.newSprite(self.model_.standFrame)
  self.sprite_:setAnchorPoint(cc.p(0.5, 0))
  self.sprite_:addTo(self)
  self.sprite_:setScale(Const.Zoom0 * self.model_.sizeInBattle)
  local size = self.sprite_:getContentSize()
  self.sprite_:size(size.width * self.model_.sizeInBattle, size.height * self.model_.sizeInBattle)
  self.mLayIndex = 0
  self.zOrder_ = math.random(-10, 50)
  self.yOffset_ = position.y + self.zOrder_
  self.bloodBar = BloodBar.new(self.mFlag, self.model_.monsterType)
  self.bloodBar:setPositionY(size.height * 1.1)
  self.mAnimator:addChild(self.bloodBar, 10)
  self.buffNotice = BuffNotice.new():pos(0, size.height * 1.2):addTo(self.mAnimator, 20)
  self.buffNotice:setAnchorPoint(1, 0.5)
end

function M:updateLogic()
  if self.mState == "Died" or self.mState == "Stone" or self.mState == "Reliving" then
    return
  end
  deltaTime = deltaTime + 0.05
  self:setLocalZOrder(9999 - self:getPositionY())
  if self.skill[TRIGGER_ON_LIVE] and self.skill[TRIGGER_ON_LIVE][1]:checkTrigger(deltaTime) then
    self.skill[TRIGGER_ON_LIVE][1]:onTrigger()
    deltaTime = 0
  end
  if self:getBuff(1002) then
    self:onIdle()
    return
  end
  self.mTarget = self:findTarget()
  if self:getBuff(1012) then
    if (self.mTarget.mFlag == 9 or self.mTarget.mFlag == 10) and self:canAttack() then
      self:getBuff(1012):killSelf()
    end
    self:onMove()
    return
  end
  if self:getBuff(1020) then
    if (self.mTarget.mFlag == 9 or self.mTarget.mFlag == 10) and self:canAttack() then
      self:getBuff(1020):killSelf()
      return
    end
    self:onMove()
  end
  if self.mTarget == nil then
    self:onIdle()
    return
  end
  if self.mState == "Idle" or self.mState == "Move" then
    if self:canAttack() then
      self:onAttack()
    elseif not self:getBuff(1007) then
      self:onMove()
    else
      self:onIdle()
    end
  end
end

function M:findTarget()
end

function M:canAttack()
end

function M:onAttack()
  if self.isAttackCoolDown_ or self:getBuff(1006) then
    self:onIdle()
    return
  end
  self.isAttackCoolDown_ = true
  local attackType = false
  self.mState = "Attack"
  if self.skill[TRIGGER_ON_ATKCOUNT] then
    for _, k in pairs(self.skill[TRIGGER_ON_ATKCOUNT]) do
      attackType = k:checkTrigger(self.mAttackCount + Const.Skill.TRIGGER7, self.mTarget:getActorType())
      if attackType then
        self:playCommonSkillEffect()
        self.mAnimator:changeArmatureStateTo("SKILL", k.mData.aniIndex)
        self:performWithDelay(function()
          k:onTrigger()
          k:endSkill()
          self.mAttackCount = 0
          self:performWithDelay(function()
            self.isAttackCoolDown_ = false
            self.mState = "Idle"
          end, self.model_.attackFrequency)
        end, k:getDelayTime())
        return
      end
    end
  end
  if self.skill[TRIGGER_ON_ATK] then
    attackType = self.skill[TRIGGER_ON_ATK][1]:checkTrigger(math.random(0, 100) + Const.Skill.TRIGGER2)
  end
  if not attackType then
    DYSoundMgr.playEffect(self.model_.soundFile)
    self.mAttackCount = self.mAttackCount + 1
    self.mAnimator:changeArmatureStateTo("ATTACK")
    self:performWithDelay(function()
      self:attack()
    end, self.model_.attackTime)
  else
    self:playCommonSkillEffect()
    self.mAnimator:changeArmatureStateTo("SKILL", self.skill[TRIGGER_ON_ATK][1].mData.aniIndex)
    self:performWithDelay(function()
      self.skill[TRIGGER_ON_ATK][1]:onTrigger()
      self.skill[TRIGGER_ON_ATK][1]:endSkill()
    end, self.skill[TRIGGER_ON_ATK][1]:getDelayTime())
  end
  self:performWithDelay(function()
    self.isAttackCoolDown_ = false
  end, self.model_.attackFrequency)
end

function M:onMove()
  self.mState = "Move"
  self.mAnimator:changeArmatureStateTo("RUN")
  local speed = self:getCurABLY(MOV_SPED) * self:getCurABLY(MOV_SPED_RATE) / 100
  if speed > MaxMoveSpeed then
    speed = MaxMoveSpeed
  end
  if self:getPositionY() < self.yOffset_ then
    self:setPosition(cc.pAdd(cc.p(self:getPosition()), cc.p(Const.Zoom0 * self.mFaceTo * speed / 20 / 1.4, 0)))
    return
  end
  self:setPosition(cc.pAdd(cc.p(self:getPosition()), cc.p(Const.Zoom0 * self.mFaceTo * speed / 20 / 1.4, -0.15)))
end

function M:getSomeMonster(number, dis)
  local tmpSource = self
  local tmpFlag = tmpSource.mFlag
  local tmpList
  local tmpdis = dis
  if tmpFlag == 1 then
    tmpList = clone(BMgr.getMonsterList())
    local tmpTower = clone(BMgr.getMonsterTower())
    table.insert(tmpList, tmpTower)
  else
    tmpList = clone(BMgr.getBuddhaList())
    local tmpTower = clone(BMgr.getBuddhaTower())
    table.insert(tmpList, tmpTower)
  end
  local rtnList = {}
  for k, v in pairs(tmpList) do
    local tarX = v:getMyBoundingBox(false)
    while true do
      if tmpFlag == 2 then
        if tarX < tmpSource:getPositionX() or v.mCantAttack then
          break
        end
      elseif tarX > tmpSource:getPositionX() or v.mCantAttack then
        break
      end
      if math.abs(tmpSource:getPositionX() - tarX) > tmpdis * Const.Zoom0 then
        break
      end
      table.insert(rtnList, v)
      break
    end
  end
  if tmpFlag == 1 then
    table.sort(rtnList, function(a, b)
      return a:getPositionX() > b:getPositionX()
    end)
  elseif tmpFlag == 2 then
    table.sort(rtnList, function(a, b)
      return a:getPositionX() < b:getPositionX()
    end)
  end
  return {
    unpack(rtnList, 1, number)
  }
end

function M:attack()
  if self.mTarget and not self.mTarget.mState ~= "Died" and self:canAttack() then
    if self.model_.hitNum > 1 then
      self.mTarget = self:getSomeMonster(self.model_.hitNum, self.model_.attackDistance * self.model_.sizeInBattle)
      for _, v in pairs(self.mTarget) do
        local realATK, realType = self:calculateDamage(self, v)
        v:underAttack(self, realATK, realType)
      end
    else
      local realATK, realType = self:calculateDamage(self, self.mTarget)
      self.mTarget:underAttack(self, realATK, realType)
    end
  end
end

function M:calculateDamage(Source, Target)
  local source = Source
  local target = Target
  local realType = 1
  local realDamage = 0
  local HitR = source:getCurABLY(HIT_RATE) - target:getCurABLY(MISS_RATE)
  if HitR < math.random(0, 100) then
    realType = 3
    return realDamage, realType
  end
  local CriHarmR = 100
  local CriR = source:getCurABLY(CRIT_RATE) - target:getCurABLY(RES_CRIT_RATE)
  if CriR > math.random(0, 100) then
    CriHarmR = source:getCurABLY(CRIT_HARM_RATE)
    realType = 2
  end
  CriHarmR = CriHarmR * 0.01
  local dmgR = math.random(90, 110) * 0.01
  local attackType = source:getATKType()
  local defBase, defIncr, defDeV
  if attackType == 2 then
    defBase = target:getCurABLY(MAG_DEF)
    defIncr = target:getCurABLY(MAG_DEF_RATE)
    defDeV = source:getCurABLY(MAG_DEF_IGNORE)
  else
    defBase = target:getCurABLY(PHY_DEF)
    defIncr = target:getCurABLY(PHY_DEF_RATE)
    defDeV = source:getCurABLY(PHY_DEF_IGNORE)
  end
  local Harm = source:getCurABLY(ADD_HARM)
  local DeHarmV = target:getCurABLY(REDUCE_HARM)
  local SklHarmR = source.tmpABLY[SKILL_HARM_RATE] ~= 0 and source.tmpABLY[SKILL_HARM_RATE] or source.initABLY[SKILL_HARM_RATE]
  local DeHarmR = target:getCurABLY(REDUCE_HARM_RATE)
  local AddHarmR = source:getCurABLY(ADD_HARM_RATE)
  local tmpAttack = source:getCurABLY(ATK) * source:getCurABLY(ATK_RATE) * 0.01
  local tmpDefence = (defBase - defDeV) * defIncr * 0.01
  local tmpH = math.floor(tmpAttack - tmpDefence + Harm - DeHarmV)
  if tmpH < tmpAttack * 0.1 then
    tmpH = tmpAttack * 0.1
  end
  realDamage = math.floor(tmpH * SklHarmR * 0.01 * (100 - DeHarmR) * (100 + AddHarmR) * 1.0E-4 * dmgR * CriHarmR)
  if realDamage < 1 then
    realDamage = 1
  end
  return realDamage, realType
end

function M:showDamage(hpLose, damageType)
  local showType = damageType or 1
  if hpLose < 0 then
    showType = 10
  end
  local tmpNode = display.newNode():addTo(self, 50)
  local font
  if 2 == showType then
    font = cc.ui.UILabel.newBMFontLabel_({
      text = string.format("%d", hpLose),
      font = "fonts/critBattle.fnt"
    }):addTo(tmpNode)
    local sp = display.newSprite("#crit.png")
    sp:setAnchorPoint(1, 0.7)
    sp:setScale(1)
    sp:addTo(tmpNode)
    font:setAnchorPoint(0, 0.5)
    tmpNode:setLocalZOrder(9999)
    tmpNode:setScale(Const.Zoom0)
    tmpNode:setPosition(0, self.sprite_:getContentSize().height * Const.Zoom0 * self.model_.sizeInBattle)
    tmpNode:setCascadeOpacityEnabled(true)
    local sequence = transition.sequence({
      cc.ScaleTo:create(0.3, 0.5),
      cc.ScaleTo:create(0.3, 0.4),
      cc.DelayTime:create(0.3),
      cc.FadeOut:create(0.2),
      cc.CallFunc:create(function()
        tmpNode:removeSelf()
      end)
    })
    tmpNode:runAction(sequence)
    return true
  elseif 1 == showType then
    font = cc.ui.UILabel.newBMFontLabel_({
      text = string.format("-%d", hpLose),
      font = "fonts/battle_red.fnt"
    }):addTo(tmpNode)
  elseif 3 == showType then
    local sp = display.newSprite("#miss.png"):addTo(tmpNode)
  elseif 4 == showType then
    local sp = display.newSprite("#dikang.png"):addTo(tmpNode)
  elseif 10 == showType then
    font = cc.ui.UILabel.newBMFontLabel_({
      text = string.format("+%d", math.abs(hpLose)),
      font = "fonts/battle_blue.fnt"
    }):addTo(tmpNode)
  end
  tmpNode:setScale(Const.Zoom0)
  tmpNode:setPosition(0, self.sprite_:getContentSize().height * Const.Zoom0 * self.model_.sizeInBattle)
  tmpNode:setCascadeOpacityEnabled(true)
  local spawn = cc.Spawn:create(cc.MoveBy:create(3, cc.p(0, 300)), cc.FadeOut:create(1))
  tmpNode:runAction(transition.sequence({
    spawn,
    cc.CallFunc:create(function()
      tmpNode:removeSelf()
    end)
  }))
end

function M:decreaseHP(hpLose, damageType)
  local damageType = damageType or 1
  if self.mState == "Died" then
    return
  end
  self.curHp_ = self.curHp_ - hpLose
  self.lostHpAccum_ = self.lostHpAccum_ + hpLose
  self.curHpPrecent = self.curHp_ / self.maxHp_ * 100
  self.bloodBar:setHp(self.curHp_, self.maxHp_)
  self:showDamage(hpLose, damageType)
  if self.curHp_ <= 0 then
    self.bloodBar:setVisible(false)
    self.isDead_ = true
    self:onDead()
    return
  end
  local triggerFlag = false
  local loseHpPercent = self.lostHpAccum_ / self.maxHp_
  if self.skill[TRIGGER_ON_LIFE] then
    triggerFlag = self.skill[TRIGGER_ON_LIFE][1]:checkTrigger(self.curHpPrecent)
    if triggerFlag then
      self.skill[TRIGGER_ON_LIFE][1]:onTrigger()
    end
  elseif loseHpPercent > tonumber(self.model_.backParam) then
    self.isInHurt_ = true
    self.lostHpAccum_ = 0
    local backLength = self:getPositionX() - self.mFaceTo * self.model_.backLength * Const.Zoom0 * self.model_.sizeInBattle
    if backLength < BMgr.getMonsterPos().x then
      backLength = BMgr.getMonsterPos().x + 10
    elseif backLength > BMgr.getBuddhaPos().x then
      backLength = BMgr.getBuddhaPos().x - 10
    end
    self:setPositionX(backLength)
    self.mAnimator:changeArmatureStateTo("HURT")
    self.mAnimator:setSpeed(self.model_.hurtSpeed or 1)
    self.mState = "Hurt"
  end
end

function M:increaseHP(hp, maxHpPercent)
  if self.isDead_ == true then
    return
  end
  local addHp = 0
  if maxHpPercent then
    addHp = maxHpPercent * 0.01 * self.maxHp_ + hp
  else
    addHp = hp
  end
  self.curHp_ = self.curHp_ + addHp
  if self.curHp_ > self.maxHp_ then
    self.curHp_ = self.maxHp_
  end
  self.bloodBar:setHp(self.curHp_, self.maxHp_)
  self:showDamage(-addHp)
end

function M:underAttack(source, hpLose, realType)
  if self.IsInvincible_ then
    hpLose = 0
  end
  self.mDamageFrom = source
  self:hurtEffect()
  self:decreaseHP(hpLose, realType)
  self.mDefenceCount = self.mDefenceCount + 1
  if self.skill[TRIGGER_ON_DEFCOUNT] then
    local triggerType = self.skill[TRIGGER_ON_DEFCOUNT][1]:checkTrigger(self.mDefenceCount)
    if triggerType then
      self:playCommonSkillEffect()
      self.skill[TRIGGER_ON_DEFCOUNT][1]:onTrigger()
      self.mDefenceCount = 0
      return
    end
  end
  if self.skill[TRIGGER_ON_DEF] then
    local triggerType = self.skill[TRIGGER_ON_DEF][1]:checkTrigger(math.random(0, 100))
    if triggerType then
      self:playCommonSkillEffect()
      self.skill[TRIGGER_ON_DEF][1]:onTrigger()
      return
    end
  end
end

function M:hurtEffect()
  if not self.isInTint_ then
    self.isInTint_ = true
    local tint = cc.TintTo:create(0, 243, 83, 7)
    local tintBack = cc.TintTo:create(0, 255, 255, 255)
    local dt = cc.DelayTime:create(0.4)
    self.mAnimator:runAction(transition.sequence({
      tint,
      dt,
      tintBack,
      cc.CallFunc:create(function()
        self.isInTint_ = false
      end)
    }))
  end
  if not self.isInShake_ then
    self.isInShake_ = true
    local m1 = cc.MoveBy:create(0.1, cc.p(5, 0))
    local m2 = cc.MoveBy:create(0.1, cc.p(-5, 0))
    self.mAnimator:runAction(transition.sequence({
      m1,
      m2,
      m1,
      m2,
      cc.CallFunc:create(function()
        self.isInShake_ = false
      end)
    }))
  end
  if self.mHitEffectCount < 4 then
    local frames = display.newFrames("dadouyanwu%d.png", 1, 7)
    local animation = display.newAnimation(frames, 0.07)
    local sp = display.newSprite()
    sp:setAnchorPoint(cc.p(0.5, 0))
    local rect = self:getContentSize()
    sp:setScale((rect.width / 1.4 + rect.height / 1.4) / 200)
    self:addChild(sp, 11)
    sp:playAnimationOnce(animation, true, function()
      self.mHitEffectCount = self.mHitEffectCount - 1
    end)
  end
  if self.mHitEffectCount > 6 then
    self.mHitEffectCount = 0
  end
  self.mHitEffectCount = self.mHitEffectCount + 1
end

function M:onIdle()
  if self.mState ~= "Idle" then
    self.mState = "Idle"
    self.mAnimator:changeArmatureStateTo("STAND")
  end
end

function M:onDead()
  if self.mState == "Died" or self.mState == "Reliving" then
    return
  end
  if self.skill[TRIGGER_ON_DEATH] then
    local triggerFlag = self.skill[TRIGGER_ON_DEATH][1]:checkTrigger(0)
    if triggerFlag then
      self.skill[TRIGGER_ON_DEATH][1]:onTrigger(0)
      if self.mState == "Reliving" or self.mState == "Invincible" then
        return
      end
    end
  end
  self.mState = "Died"
  DYSoundMgr.playEffect(DY_SND.sfx_siwang2)
  self.mAnimator:setVisible(false)
  if self.mDamageFrom ~= nil and self.mDamageFrom.curHp_ and 0 < self.mDamageFrom.curHp_ and self.mDamageFrom.killActor then
    self.mDamageFrom:killActor()
  end
  self:stopAllActions()
  local frames = display.newFrames("wofangsiwangyan%d.png", 1, 7)
  local animation = display.newAnimation(frames, 0.15)
  local smoke = display.newSprite()
  smoke:setPosition(self.sprite_:getContentSize().width, self.sprite_:getContentSize().height)
  self.sprite_:addChild(smoke)
  smoke:playAnimationOnce(animation, true, function()
    local frames = display.newFrames("siwanglinghun%d.png", 1, 3)
    local animation = display.newAnimation(frames, 0.15)
    local soul = display.newSprite()
    soul:setAnchorPoint(cc.p(0.5, 0.5))
    soul:setScale(Const.Zoom0)
    soul:playAnimationForever(animation)
    soul:setPosition(self:getPosition())
    self:getParent():addChild(soul)
    transition.execute(soul, cc.MoveBy:create(4, cc.p(0, 300)), {
      onComplete = function()
        soul:removeSelf()
      end
    })
  end)
  if self.skill[TRIGGER_ON_LIVE] then
    self.skill[TRIGGER_ON_LIVE][1]:endSkill()
    self.skill[TRIGGER_ON_LIVE] = nil
  end
  if self.skill[TRIGGER_ON_ONBATTLE] then
    self.skill[TRIGGER_ON_ONBATTLE][1]:endSkill()
    self.skill[TRIGGER_ON_ONBATTLE] = nil
  end
end

function M:onKillByWutian(pos)
  if self.mFlag == 1 then
    BMgr.removeBuddha(self)
  else
    BMgr.removeMonster(self)
  end
  local frames = display.newFrames("wofangsiwangyan%d.png", 1, 7)
  local animation = display.newAnimation(frames, 0.15)
  local smoke = display.newSprite()
  smoke:setPosition(self.sprite_:getContentSize().width, self.sprite_:getContentSize().height)
  self.sprite_:addChild(smoke)
  smoke:playAnimationOnce(animation, true, function()
    local frames = display.newFrames("siwanglinghun%d.png", 1, 3)
    local animation = display.newAnimation(frames, 0.15)
    local soul = display.newSprite()
    soul:setAnchorPoint(cc.p(0.5, 0.5))
    soul:setScale(Const.Zoom0)
    soul:playAnimationForever(animation)
    soul:setPosition(self:getPosition())
    self:getParent():addChild(soul)
    transition.execute(soul, cc.MoveBy:create(4, cc.p(0, 300)), {
      onComplete = function()
        soul:removeSelf()
      end
    })
  end)
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
  local m = cc.MoveTo:create(1, pos)
  local seq = transition.sequence({b, m})
  transition.execute(spirit, seq, {
    onComplete = function()
      spirit:removeSelf()
    end
  })
  self:setVisible(false)
  self:performWithDelay(function()
    self:removeSelf()
  end, 3)
end

function M:killActor()
  if self.skill[TRIGGER_ON_KILL] and self.skill[TRIGGER_ON_KILL][1]:checkTrigger(0) then
    self.mAnimator:changeArmatureStateTo("SKILL", self.skill[TRIGGER_ON_KILL][1].mData.aniIndex)
    self.skill[TRIGGER_ON_KILL][1]:onTrigger()
  end
end

function M:playCommonSkillEffect()
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

function M:addBuff(parent, buffid, dt, time, effect)
  if self.mState == "Died" then
    return
  end
  local res = self:getRes(buffid)
  local tmpRnd = math.random(0, 100)
  if res >= tmpRnd then
    self:showDamage(0, 4)
    return
  end
  local preBuff = self.mAnimator:getChildByTag(buffid)
  if preBuff then
    if preBuff.isDeBuff ~= preBuff.isDeBuff then
      preBuff:killSelf()
      local tmpBuff = Buff.new(parent, buffid, dt, time, effect + preBuff.mEffectValue)
      self.mAnimator:addChild(tmpBuff, 20, buffid)
    elseif math.abs(preBuff.mEffectValue) <= math.abs(effect) then
      local tmpBuff = Buff.new(parent, buffid, dt, time, effect)
      self.mAnimator:addChild(tmpBuff, 20, buffid)
    end
  else
    local tmpBuff = Buff.new(parent, buffid, dt, time, effect)
    self.mAnimator:addChild(tmpBuff, 20, buffid)
  end
end

function M:setAddABLY(index, value)
  self.addABLY[index] = self.addABLY[index] + value
end

function M:setTmpABLY(index, value)
  self.tmpABLY[index] = self.tmpABLY[index] + value
end

function M:getCurABLY(index)
  return self.initABLY[index] + self.addABLY[index] + self.tmpABLY[index] + BMgr.getAuraSkillData(self.mFlag, index)
end

function M:getATKType()
  return self.model_.attackType
end

function M:tPause()
  self.isInHurt_ = false
  self:pause()
  self.mAnimator:tPause()
end

function M:tResume()
  self:onIdle()
  self:resume()
  self.mAnimator:tResume()
end

function M:kPause()
  self:pause()
  self.mAnimator:tPause()
end

function M:kResume()
  self:resume()
  self.mAnimator:tResume()
end

function M:getMyBoundingBox(isAttacking)
  local tmpWidth = 0
  local size = cc.size(self.sprite_:getContentSize().width * Const.Zoom0 * self.model_.sizeInBattle, self.sprite_:getContentSize().height * Const.Zoom0 * self.model_.sizeInBattle)
  local tmpX = self:getPositionX()
  if isAttacking then
    tmpWidth = tmpX + self.mFaceTo * self.model_.attackDistance
  else
    tmpWidth = tmpX + self.mFaceTo * size.width / 2
  end
  return tmpWidth
end

function M:rebel()
  local actor
  if self.mFlag == 1 then
    self:performWithDelay(function()
      BMgr.removeBuddha(self)
    end, 0.1)
    actor = BMgr.createMonsterByModel(self:getParent(), self.model_, cc.p(self:getPosition()))
  else
    self:performWithDelay(function()
      BMgr.removeMonster(self)
    end, 0.1)
    actor = BMgr.createBuddhaByModel(self:getParent(), self.model_, cc.p(self:getPosition()))
  end
  actor.curHp_ = self.curHp_
  actor.bloodBar:setHp(actor.curHp_, actor.maxHp_)
  local frames = display.newFrames("shoumeihuo%d.png", 1, 14)
  local animation = display.newAnimation(frames, 0.1)
  local sp = display.newSprite()
  sp:setAnchorPoint(cc.p(0.5, 0.5))
  local rect = self:getContentSize()
  sp:setPosition(cc.p(0, rect.height))
  sp:setScale((rect.height + rect.width) / 400)
  actor.mAnimator:addChild(sp)
  sp:playAnimationForever(animation, true)
  actor.skill = clone(self.skill)
  for k, v in pairs(actor.skill) do
    for _, iSkill in pairs(v) do
      iSkill.mSource = actor
      iSkill:initFunc()
      iSkill.mDesc = DYLang.getString("S1490", "")
    end
  end
  self.mState = "Died"
  self:setVisible(false)
  self:performWithDelay(function()
    self:removeSelf()
  end, 2)
end

function M:relive(rate)
  self.isDead_ = false
  self.isInHurt_ = false
  self:increaseHP(self.maxHp_ * rate * 0.01)
  self.lostHpAccum_ = 0
  self.bloodBar:setHp(self.maxHp_ * rate * 0.01, self.maxHp_)
  self.mBUFF = {}
  self.mAnimator:setVisible(true)
  self.mState = "Idle"
end

function M:getContentSize()
  return self.sprite_:getContentSize()
end

function M:getBoundingBox()
  return self.sprite_:getBoundingBox()
end

function M:getAniBoundingBox()
  return self.mAnimator:getAniBoundingBox()
end

function M:getRes(value)
  local res = 0
  if value < CAUSE_BACK or value > CAUSE_BURN and (value ~= CAUSE_POISON or value ~= CAUSE_SILENCE) then
    res = 0
  else
    res = self:getCurABLY(value + 1000) + self:getCurABLY(RES_ALL)
  end
  return res
end

function M:getBuff(value)
  return self.mAnimator:getChildByTag(value)
end

function M:getActorType()
  return self.model_.tagType
end

function M:dis(pos1, pos2)
  local deltaX = math.abs(pos1.x - pos2.x)
  local deltaY = 0
  return deltaX + deltaY
end

function M:onKillByWutian(pos)
  self.mState = "Died"
  BMgr.removeMonster(self)
  local frames = display.newFrames("lingqi%d.png", 1, 2)
  local animation = display.newAnimation(frames, 0.1)
  local spirit = display.newSprite()
  spirit:playAnimationForever(animation)
  spirit:setPosition(self:getPositionX() - self.model_.backLength * 0.4 * self.model_.sizeInBattle, self:getPositionY() + self.sprite_:getContentSize().height + math.random(1, 100))
  display.getRunningScene():addChild(spirit)
  local ranfY = math.random(1, 20)
  local movUp = cc.MoveTo:create(0.5, cc.p(spirit:getPositionX(), spirit:getPositionY() + ranfY))
  local movDown = cc.MoveTo:create(0.5, cc.p(spirit:getPositionX(), spirit:getPositionY() - ranfY))
  local point = self:getParent():convertToWorldSpace(pos)
  local moveTo = cc.MoveTo:create(1, cc.p(point.x, point.y + 200))
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
  end, 2)
end

return M

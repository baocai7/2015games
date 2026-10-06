local View = require("app.sprites.pvp.SpriteActorView")
local Skill = require("app.sprites.pvp.SkillModel")
local BuffModel = require("app.sprites.pvp.BuffModel")
local EVENT_NAME = {
  CastSkill = "CastSkill",
  UnderAttack = "UnderAttack",
  AddBuff = "AddBuff",
  HaveHeal = "HaveHeal",
  AttackComplete = "AttackComplete",
  HurtComplete = "HurtComplete"
}
local FRAME_SEC = GameManager.FRAME_SEC
local FLAG_BUDDHA = 1
local FLAG_MONSTER = 2
local FLAG_NOMAL_MODE = 1
local FLAG_LOGIC_MODE = 2
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
local lFunc = {}
local DYClass = "SpriteActor"
local M = {}
M = class(DYClass)

function M:ctor(buddhaModel, pos, flag, workMode)
  cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
  self.mFlag = flag
  if self.mFlag == 1 then
    self.mFaceTo = -1
  else
    self.mFaceTo = 1
  end
  self.mWorkMode = workMode or FLAG_NOMAL_MODE
  self:initData(buddhaModel, pos)
  self:initUI(buddhaModel, pos)
  self.mState = "Idle"
  if self.skill[TRIGGER_ON_ONBATTLE] then
    for _, v in pairs(self.skill[TRIGGER_ON_ONBATTLE]) do
      if v.mData.attackType == 8 then
        v:onTrigger()
      else
        self.mNextCastSkill = v
        self.mView:dispatchEvent({
          name = EVENT_NAME.CastSkill
        })
        self.mState = "CastPre"
      end
    end
  end
end

function M:initData(buddhaModel, pos)
  self.mAttackCount = 0
  self.mDefenceCount = 0
  self.mDamageFrom = nil
  self.model_ = buddhaModel
  DYComponent.getTable(self, "battleData.baseData")
  self.initABLY[LIFE] = buddhaModel.life
  self.initABLY[ATK] = buddhaModel.attack
  self.initABLY[PHY_DEF] = buddhaModel.phyDefence
  self.initABLY[MAG_DEF] = buddhaModel.magDefence
  self.initABLY[ATK_SPED] = buddhaModel.attackFrequency
  self.initABLY[MOV_SPED] = buddhaModel.runSpeed
  self.initABLY[PHY_DEF_IGNORE] = buddhaModel.phyDefIgnore
  self.initABLY[MAG_DEF_IGNORE] = buddhaModel.magDefIgnore
  self.initABLY[HIT_RATE] = buddhaModel.hitRate
  self.initABLY[MISS_RATE] = buddhaModel.missRate
  self.initABLY[CRIT_RATE] = buddhaModel.critRate
  self.initABLY[RES_CRIT_RATE] = buddhaModel.decritRate
  self.initABLY[CRIT_HARM_RATE] = buddhaModel.critHarmRate
  self.initABLY[ADD_HARM] = buddhaModel.harmAdd
  self.initABLY[REDUCE_HARM] = buddhaModel.harmReduce
  self.initABLY[ADD_HARM_RATE] = buddhaModel.harmAddRate
  self.initABLY[REDUCE_HARM_RATE] = buddhaModel.harmReduceRate
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
  self.mWidth = buddhaModel.orignWidth
  self.skill = {}
  self.mBuffList = {}
  local skillId = self.model_.totalSkills
  local skillLv = self.model_.skillLevels or {}
  if self.mFlag == FLAG_BUDDHA then
    self:initSkill(skillId, skillLv)
  else
    self:initMonsterSkill(skillId, skillLv)
  end
  self.initABLY[LIFE_CUR] = self.initABLY[LIFE]
  self.mName = self.model_.npcName
  self.mAttackPreTime = buddhaModel.attackPreTime
  self.mAttackColdTime = buddhaModel.attackColdTime - buddhaModel.attackPreTime
  self.mAttackFreTime = buddhaModel.attackFrequency * FRAME_SEC - self.mAttackColdTime
  self.mAttackPreCount = 0
  self.mAttackColdCount = 0
  self.mAttackFreCount = 0
  self.mNextCastSkill = nil
  self.mCastPreCount = 0
  self.mCastColdCount = 0
  self.mCastColdTime = 2
  self.mHurtCount = 0
  self.mHurtTime = FRAME_SEC
  self.mDeadTime = 20
  self.mAniStateIndex = nil
  self.lostHpAccum_ = 0
  self.mAttackAble = true
  self.mMoveAble = true
  self.mUpdateAble = true
  self.mInvincible = false
  self.mCanUnderAttack = true
  self.mReliveCount = 0
  self.mReliveTime = 5 * FRAME_SEC
  self.mIsPlayEffect = nil
  self.IS_SUMMON = false
  self.mPos = pos
  if 0 >= self:getCurABLY(MOV_SPED) then
    self.mMoveAble = false
  end
end

function M:initUI(model, pos)
  self.zOrder_ = BMgrOL.RANDOM:random(-10, 50)
  self.yOffset_ = pos.y + self.zOrder_
  self.mView = {}
  cc.GameObject.extend(self.mView):addComponent("components.behavior.EventProtocol"):exportMethods()
  if not BMgrOL.SKIP_BATTLE then
    self.mView = View.new(model, pos, self.mFlag)
  end
end

function M:initSkill(index, skillLv)
  local tmpSkill
  for i = 1, #index do
    while true do
      tmpSkill = Skill.new(self, index[i], skillLv[i])
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

function M:tunInLogicMode()
  self.mWorkMode = FLAG_LOGIC_MODE
  self.mView = {}
  
  function self.mView.update()
    return true
  end
  
  cc.GameObject.extend(self.mView):addComponent("components.behavior.EventProtocol"):exportMethods()
end

function M:doThings()
  if self:getCurABLY(LIFE_CUR) < 0 and self.mState ~= "Died" and self.mState ~= "Relive" then
    self.mState = "DiePre"
    self.mUpdateAble = true
  end
  if (self.mUpdateAble or self.mState == "Died" or self.mState == "DiePre") and self["on" .. self.mState] then
    self["on" .. self.mState](self)
  end
  local list = self.mBuffList
  for _, item in pairs(list) do
    item:update()
  end
  if BMgrOL.SKIP_BATTLE and self.mWorkMode == FLAG_NOMAL_MODE then
    self:tunInLogicMode()
  end
  self.mView:update(self.mAniStateIndex, self.mPos)
end

function M:onIdle()
  self.mAniStateIndex = AniState.idle
  self.mTarget = self:findTarget()
  self.mAttackFreCount = self.mAttackFreCount - 1
  if self.mTarget ~= nil then
    if lFunc.canAttack(lFunc.dis(self.mTarget:getMyBoundingBox(false), self:getPositionX()), self.model_.attackDistance * self.model_.sizeInBattle) then
      self.mState = "AttackOrSkill"
    else
      self.mState = "Move"
    end
  end
end

function M:onStun()
  self.mAniStateIndex = AniState.idle
end

function M:onStone()
end

function M:onAttackOrSkill()
  if not self.mAttackAble then
    self.mState = "Idle"
    return
  end
  self.mAniStateIndex = AniState.idle
  if self.mAttackFreCount > 0 then
    self.mAttackFreCount = self.mAttackFreCount - 1
    return
  end
  if self.skill[TRIGGER_ON_ATKCOUNT] then
    for _, v in pairs(self.skill[TRIGGER_ON_ATKCOUNT]) do
      if v:checkTrigger(self.mAttackCount, self.mTarget:getActorType()) then
        self.mNextCastSkill = v
        self.mAttackCount = 0
        self.mView:dispatchEvent({
          name = EVENT_NAME.CastSkill
        })
        self.mAttackFreCount = self.mAttackFreTime
        self.mState = "CastPre"
        return true
      end
    end
  end
  if self.skill[TRIGGER_ON_ATK] then
    for _, v in pairs(self.skill[TRIGGER_ON_ATK]) do
      if v:checkTrigger(BMgrOL.RANDOM:random(0, 100)) then
        self.mNextCastSkill = v
        self.mState = "CastPre"
        self.mView:dispatchEvent({
          name = EVENT_NAME.CastSkill
        })
        self.mAttackFreCount = self.mAttackFreTime
        return true
      end
    end
  end
  self.mState = "AttackPre"
end

function M:onMove()
  self.mAttackFreCount = self.mAttackFreCount - 1
  self.mTarget = self:findTarget()
  if not self.mMoveAble or not self.mTarget then
    self.mState = "Idle"
    return
  end
  local speed = self:getCurABLY(MOV_SPED) * self:getCurABLY(MOV_SPED_RATE) * 0.01 / 84
  if speed < 0 then
    speed = 0
  end
  self.mAniStateIndex = AniState.walk
  if self.mFlag == FLAG_BUDDHA then
    self.mPos.x = self.mPos.x - speed
  elseif self.mFlag == FLAG_MONSTER then
    self.mPos.x = self.mPos.x + speed
  end
  if self:getPositionY() < self.yOffset_ then
    self:setPosition(cc.pAdd(cc.p(self:getPosition()), cc.p(Const.Zoom0 * self.mFaceTo * speed / 20 / 1.4, 0)))
  else
    self:setPosition(cc.pAdd(cc.p(self:getPosition()), cc.p(Const.Zoom0 * self.mFaceTo * speed / 20 / 1.4, -0.15)))
  end
  if lFunc.canAttack(lFunc.dis(self.mTarget:getMyBoundingBox(false), self:getPositionX()), self.model_.attackDistance * self.model_.sizeInBattle) then
    self.mState = "AttackOrSkill"
  end
end

function M:onAttackPre()
  self.mAniStateIndex = AniState.atk
  self.mAniComplete = false
  if self.mTarget and self.mTarget.mState ~= "Died" then
    self.mAttackPreCount = self.mAttackPreCount + 1
    if self.mAttackPreCount >= self.mAttackPreTime then
      self.mState = "Attacking"
      self.mAttackPreCount = 0
    end
  else
    self.mState = "Idle"
  end
end

function M:onAttacking()
  if self.mTarget and not self.mTarget.mState ~= "Died" then
    if self.model_.hitNum > 1 then
      self.mTarget = self:getSomeMonster(self.model_.hitNum, self.model_.attackDistance * self.model_.sizeInBattle)
      for _, v in pairs(self.mTarget) do
        local realDamage, realType = BMgrOL.calculateDamage(self, v)
        v:underAttack(self, realDamage, realType)
      end
    else
      local realDamage, realType = BMgrOL.calculateDamage(self, self.mTarget)
      self.mTarget:underAttack(self, realDamage, realType)
    end
  end
  self.mAttackCount = self.mAttackCount + 1
  self.mState = "AttackCold"
end

function M:onAttackCold()
  self.mAttackColdCount = self.mAttackColdCount + 1
  if self.mAniComplete then
    self.mAniStateIndex = AniState.idle
  end
  if self.mAttackColdCount >= self.mAttackColdTime then
    self.mAttackColdCount = 0
    self.mAttackFreCount = self.mAttackFreTime
    self.mState = "Idle"
  end
end

function M:onCastPre()
  self.mAniStateIndex = self.mNextCastSkill.mData.aniIndex or AniState.atk
  self.mCastPreCount = self.mCastPreCount + 1
  if self.mAniStateIndex > 3 then
    self.mCastColdTime = self.model_.skillTimeParam[self.mNextCastSkill.mData.aniIndex - 3].coldTime
  else
    self.mCastColdTime = self.mAttackColdTime
  end
  if self.mCastPreCount >= self.mNextCastSkill:getDelayTime() then
    self.mState = "Casting"
    self.mCastPreCount = 0
  end
end

function M:onCasting()
  self.mNextCastSkill:onTrigger()
  self.mNextCastSkill:endSkill()
  self.mNextCastSkill = nil
  if self.mState == "Casting" then
    self.mState = "CastCold"
  end
end

function M:onCastCold()
  self.mCastColdCount = self.mCastColdCount + 1
  if self.mCastColdCount >= self.mCastColdTime then
    self.mCastColdCount = 0
    self.mState = "Idle"
  end
end

function M:onCover()
  self.mAniStateIndex = AniState.idle
  self.mNextCastSkill = nil
  self.mAttackPreCount = 0
  self.mAttackColdCount = 0
  self.mCastPreCount = 0
  self.mState = "Idle"
end

function M:onHurt()
  self.mAniStateIndex = AniState.hurt
  self.mHurtCount = self.mHurtCount + 1
  if self.mHurtCount >= self.mHurtTime then
    self.mHurtCount = 0
    self.mState = "Idle"
  end
end

function M:onRelive()
  self.mView:dispatchEvent({name = "RE_LIVE"})
  self.mInvincible = true
  self:setTmpABLY(RES_ALL, 100)
  self.mReliveCount = self.mReliveCount + 1
  if self.mReliveCount >= self.mReliveTime then
    self.mReliveCount = 0
    self.mInvincible = false
    self:setTmpABLY(RES_ALL, -100)
    self.initABLY[LIFE_CUR] = 1
    self:increaseHP(self.mReliveLife)
    self.mState = "Cover"
    self.mView:dispatchEvent({
      name = "OUT_RE_LIVE"
    })
    self.mReliveLife = 0
    self.lostHpAccum_ = 0
    self.mBuffList = {}
  end
end

function M:onStealth()
  if not self.mMoveAble then
    return
  end
  local speed = self:getCurABLY(MOV_SPED) * self:getCurABLY(MOV_SPED_RATE) * 0.01 / 28 / 3
  if self.mFlag == FLAG_BUDDHA then
    self.mPos.x = self.mPos.x - speed
    self.mTarget = BMgrOL.getMonsterTower()
  elseif self.mFlag == FLAG_MONSTER then
    self.mPos.x = self.mPos.x + speed
    self.mTarget = BMgrOL.getBuddhaTower()
  end
  if self:getPositionY() < self.yOffset_ then
    self:setPosition(cc.pAdd(cc.p(self:getPosition()), cc.p(Const.Zoom0 * self.mFaceTo * speed / 20 / 1.4, 0)))
  else
    self:setPosition(cc.pAdd(cc.p(self:getPosition()), cc.p(Const.Zoom0 * self.mFaceTo * speed / 20 / 1.4, -0.15)))
  end
  if lFunc.canAttack(lFunc.dis(self.mTarget:getMyBoundingBox(false), self:getPositionX()), self.model_.attackDistance * self.model_.sizeInBattle) and (self.mTarget.mFlag == 9 or self.mTarget.mFlag == 10) then
    self.mState = "AttackOrSkill"
  end
  self.mAniStateIndex = AniState.walk
end

function M:onUnderGround()
  if not self.mMoveAble then
    return
  end
  local speed = self:getCurABLY(MOV_SPED) * self:getCurABLY(MOV_SPED_RATE) * 0.01 / 28 / 3
  if self.mFlag == FLAG_BUDDHA then
    self.mPos.x = self.mPos.x - speed
    self.mTarget = BMgrOL.getMonsterTower()
  elseif self.mFlag == FLAG_MONSTER then
    self.mPos.x = self.mPos.x + speed
    self.mTarget = BMgrOL.getBuddhaTower()
  end
  if self:getPositionY() < self.yOffset_ then
    self:setPosition(cc.pAdd(cc.p(self:getPosition()), cc.p(Const.Zoom0 * self.mFaceTo * speed / 20 / 1.4, 0)))
  else
    self:setPosition(cc.pAdd(cc.p(self:getPosition()), cc.p(Const.Zoom0 * self.mFaceTo * speed / 20 / 1.4, -0.15)))
  end
  self.mTarget = self:findTarget()
  if not self.mTarget then
    return
  end
  if lFunc.canAttack(lFunc.dis(self.mTarget:getMyBoundingBox(false), self:getPositionX()), self.model_.attackDistance * self.model_.sizeInBattle) then
    if self.mTarget.mFlag == 9 or self.mTarget.mFlag == 10 then
      self.mState = "AttackOrSkill"
    elseif self.mLastTarget ~= self.mTarget then
      local realDamage, realType = BMgrOL.calculateDamage(self, self.mTarget)
      self.mTarget:underAttack(self, realDamage, realType)
      self.mLastTarget = self.mTarget
    end
  end
  self.mAniStateIndex = AniState.walk
end

function M:onDiePre()
  local list = self.mBuffList
  for _, item in pairs(list) do
    self:removeBuff(item)
  end
  if self.skill[TRIGGER_ON_DEATH] then
    local triggerFlag = self.skill[TRIGGER_ON_DEATH][1]:checkTrigger(0)
    if triggerFlag then
      self.skill[TRIGGER_ON_DEATH][1]:onTrigger(0)
    end
  end
  if self.mState == "DiePre" then
    self.mState = "Died"
  end
end

function M:onFlyUP()
end

function M:onDied()
  DDLOG(self.mName .. DYLang.getString("S1574", ""))
  if self.mDamageFrom and self.mDamageFrom.mState ~= "Died" and self.mDamageFrom.killActor then
    self.mDamageFrom:killActor()
  end
  if self.skill[TRIGGER_ON_LIVE] then
    self.skill[TRIGGER_ON_LIVE][1]:endSkill()
    self.skill[TRIGGER_ON_LIVE] = nil
  end
  if self.skill[TRIGGER_ON_ONBATTLE] then
    self.skill[TRIGGER_ON_ONBATTLE][1]:endSkill()
    self.skill[TRIGGER_ON_ONBATTLE] = nil
  end
  if self.mFlag == FLAG_MONSTER then
    local spiritCover = 0
    if 6 ~= GameManager.MODE and 8 ~= GameManager.MODE and 9 ~= GameManager.MODE then
      spiritCover = self.model_.value or 0
    else
      spiritCover = self.model_.spiritByKill or 0
    end
    GameData.updateSpirit(spiritCover)
  end
  BMgrOL.removeActor(self)
  self.mAniStateIndex = AniState.dead
end

function M:underAttack(source, damage, realType)
  if self.mState == "Died" or self.mState == "DiePre" then
    return
  end
  self.mDamageFrom = source
  self.mDefenceCount = self.mDefenceCount + 1
  self:decreaseHP(damage, realType)
  self.mView:dispatchEvent({
    name = EVENT_NAME.UnderAttack
  })
  if self:getCurABLY(LIFE_CUR) < 0 then
    return
  end
  if self.skill[TRIGGER_ON_DEFCOUNT] then
    for _, v in pairs(self.skill[TRIGGER_ON_DEFCOUNT]) do
      if v:checkTrigger(self.mDefenceCount) then
        self.mNextCastSkill = v
        self.mState = "CastPre"
        return true
      end
    end
  end
  if self.skill[TRIGGER_ON_DEF] then
    for _, v in pairs(self.skill[TRIGGER_ON_DEF]) do
      if v:checkTrigger(BMgrOL.RANDOM:random(0, 100)) then
        self.mNextCastSkill = v
        self.mState = "CastPre"
        return true
      end
    end
  end
end

function M:decreaseHP(hpLose, damageType)
  local damageType = damageType or 1
  if self.mInvincible == true then
    hpLose = 0
  end
  if self.mState == "Died" then
    return
  end
  self:setInitABLY(LIFE_CUR, -hpLose)
  local curHp = self:getCurABLY(LIFE_CUR)
  local maxHp = self:getCurABLY(LIFE)
  self.mView:dispatchEvent({
    name = "UNDATE_BLOOD",
    rHplose = hpLose,
    rType = damageType,
    rMaxHp = maxHp,
    rCurHp = curHp
  })
  self.lostHpAccum_ = self.lostHpAccum_ + hpLose
  local curHpPrecent = curHp / maxHp * 100
  local loseHpPercent = self.lostHpAccum_ / maxHp
  if self.skill[TRIGGER_ON_LIFE] and self.skill[TRIGGER_ON_LIFE][1]:checkTrigger(curHpPrecent) then
    self.skill[TRIGGER_ON_LIFE][1]:onTrigger()
  end
  if loseHpPercent > tonumber(self.model_.backParam) then
    self.lostHpAccum_ = 0
    self:beatBack(self.model_.backLength)
  end
end

function M:beatBack(length)
  local backLength = self:getPositionX() - self.mFaceTo * length * self.model_.sizeInBattle * Const.Zoom0
  local monsterTowerX = BMgrOL.getMonsterTower():getPositionX()
  local buddhaTowerX = BMgrOL.getBuddhaTower():getPositionX()
  if backLength < monsterTowerX then
    backLength = monsterTowerX + 10
  elseif buddhaTowerX < backLength then
    backLength = buddhaTowerX - 10
  end
  self:setPositionX(backLength)
  self.mState = "Hurt"
end

function M:increaseHP(value, isRation)
  local maxHp = self:getCurABLY(LIFE)
  if isRation == true then
    value = value * maxHp * 0.01
  end
  self:setInitABLY(LIFE_CUR, value)
  local curHp = self:getCurABLY(LIFE_CUR)
  if maxHp < curHp then
    self.initABLY[LIFE_CUR] = self.initABLY[LIFE]
  end
  self.mView:dispatchEvent({
    name = "UNDATE_BLOOD",
    rHplose = value,
    rType = 10,
    rMaxHp = maxHp,
    rCurHp = curHp
  })
end

function M:killActor()
  if self.skill[TRIGGER_ON_KILL] and self.skill[TRIGGER_ON_KILL][1]:checkTrigger(0) then
    self.mNextCastSkill = self.skill[TRIGGER_ON_KILL][1]
    self.mState = "CastPre"
  end
end

function M:findTarget(number)
  local mTargetList, tmpTower
  if self.mFlag == FLAG_MONSTER then
    mTargetList = BMgrOL.getBuddhaList()
    tmpTower = BMgrOL.getBuddhaTower()
  elseif self.mFlag == FLAG_BUDDHA then
    mTargetList = BMgrOL.getMonsterList()
    tmpTower = BMgrOL.getMonsterTower()
  end
  table.insert(mTargetList, tmpTower)
  local maxDis = 9999
  local tmpNearset
  for i, tmpEnemy in pairs(mTargetList) do
    while true do
      if tmpEnemy.mState == "Stealth" or tmpEnemy.mState == "Relive" or tmpEnemy.mState == "UnderGround" or tmpEnemy.mCantAttack then
        break
      end
      if self.mFlag == FLAG_BUDDHA and tmpEnemy:getPositionX() > self:getPositionX() then
        break
      end
      if self.mFlag == FLAG_MONSTER and tmpEnemy:getPositionX() < self:getPositionX() then
        break
      end
      local tmpdis = lFunc.dis(self:getPositionX(), tmpEnemy:getMyBoundingBox(false))
      if maxDis > tmpdis then
        maxDis = tmpdis
        tmpNearset = tmpEnemy
      end
      break
    end
  end
  return tmpNearset
end

function M:getSomeMonster(number, dis)
  local tmpSource = self
  local tmpFlag = tmpSource.mFlag
  local tmpList
  local tmpdis = dis * Const.Zoom0
  if tmpFlag == FLAG_BUDDHA then
    tmpList = BMgrOL.getMonsterList()
    local tmpTower = BMgrOL.getMonsterTower()
    table.insert(tmpList, tmpTower)
  elseif tmpFlag == FLAG_MONSTER then
    tmpList = BMgrOL.getBuddhaList()
    local tmpTower = BMgrOL.getBuddhaTower()
    table.insert(tmpList, tmpTower)
  end
  local rtnList = {}
  for k, v in pairs(tmpList) do
    local tarX = v:getMyBoundingBox(false)
    while true do
      if tmpFlag == FLAG_MONSTER then
        if tarX < tmpSource:getPositionX() or v.mCantAttack then
          break
        end
      elseif tarX > tmpSource:getPositionX() or v.mCantAttack then
        break
      end
      if tmpdis < math.abs(tmpSource:getPositionX() - tarX) then
        break
      end
      table.insert(rtnList, v)
      break
    end
  end
  if tmpFlag == FLAG_BUDDHA then
    table.sort(rtnList, function(a, b)
      return a:getPositionX() > b:getPositionX()
    end)
  elseif tmpFlag == FLAG_MONSTER then
    table.sort(rtnList, function(a, b)
      return a:getPositionX() < b:getPositionX()
    end)
  end
  return {
    unpack(rtnList, 1, number)
  }
end

function M:relive(rate)
  self.mState = "Relive"
  self.mInvincible = true
  local maxHp = self:getCurABLY(LIFE)
  self.mReliveLife = maxHp * rate * 0.01
end

function M:rebel()
  BMgrOL.removeActor(self)
  if self.mFlag == 1 then
    self.mFlag = 2
    self.mFaceTo = 1
    BMgrOL.insertPVPMonster(self)
  else
    self.mFlag = 1
    self.mFaceTo = -1
    BMgrOL.insertPVPBuddha(self)
  end
  self.mView:dispatchEvent({name = "REBEL"})
  self.mState = "Cover"
end

function M:addBuff(parent, buffid, dt, time, effect)
  if self.mState == "Died" or self.mState == "Relive" then
    return
  end
  local res = self:getRes(buffid)
  local tmpRnd = BMgrOL.RANDOM:random(1, 100)
  if res >= tmpRnd then
    self.mView:dispatchEvent({
      name = "UNDATE_BLOOD",
      rHplose = 0,
      rType = 4
    })
    return true
  end
  local preBuff = self.mBuffList[buffid]
  local tmpBuff
  if not preBuff then
    tmpBuff = BuffModel.new(parent, buffid, dt, time, effect)
  elseif 0 > preBuff.mEffectValue * effect then
    preBuff:killSelf()
    tmpBuff = BuffModel.new(parent, buffid, dt, time, effect + preBuff.mEffectValue)
  elseif math.abs(preBuff.mEffectValue) <= math.abs(effect) then
    preBuff:killSelf()
    tmpBuff = BuffModel.new(parent, buffid, dt, time, effect)
  end
  if tmpBuff then
    self.mBuffList[buffid] = tmpBuff
    local buffViewName = tmpBuff:getBuffView()
    self.mView:dispatchEvent({
      name = "ADD_BUFF",
      tBuffId = buffid,
      tBuffName = buffViewName
    })
  end
end

function M:removeBuff(buff)
  self.mBuffList[buff.mBuffid] = nil
  self.mView:dispatchEvent({
    name = "REMOVE_BUFF",
    tBuffId = buff.mBuffid,
    tBuffName = buff.mBuffViewName
  })
end

function M:showBuffNotice(isStrengthen, buffID)
  self.mView:dispatchEvent({
    name = "SHOW_NOTICE",
    x = isStrengthen,
    y = buffID
  })
end

function M:flyUp()
  local pos = {}
  if self.mFlag == FLAG_BUDDHA then
    pos.x = BMgrOL.getBuddhaTower():getPositionX()
    pos.y = BMgrOL.getBuddhaTower():getPositionY()
  elseif self.mFlag == FLAG_MONSTER then
    pos.x = BMgrOL.getMonsterTower():getPositionX()
    pos.y = BMgrOL.getMonsterTower():getPositionY()
  end
  self:setPosition(pos)
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

function M:getState()
  return self.mState
end

function M:getATKType()
  return self.model_.attackType
end

function M:getActorType()
  return self.model_.tagType
end

function M:getMyBoundingBox(isAttacking)
  local tmpWidth = 0
  local tmpX = self:getPositionX()
  if isAttacking then
    tmpWidth = tmpX + self.mFaceTo * self.model_.attackDistance * Const.Zoom0 * self.model_.sizeInBattle
  else
    tmpWidth = tmpX + self.mFaceTo * self.mWidth * 0.5 * Const.Zoom0 * self.model_.sizeInBattle
  end
  return tmpWidth
end

function lFunc.dis(pos1, pos2)
  return math.abs(pos1 - pos2)
end

function lFunc.canAttack(distance, attDis)
  if distance < attDis * Const.Zoom0 then
    return true
  else
    return false
  end
end

function M:setInitABLY(index, value)
  self.initABLY[index] = self.initABLY[index] + value
  return self.initABLY[index]
end

function M:setAddABLY(index, value)
  self.addABLY[index] = self.addABLY[index] + value
  return self.addABLY[index]
end

function M:setTmpABLY(index, value)
  self.tmpABLY[index] = self.tmpABLY[index] + value
  return self.tmpABLY[index]
end

function M:getInitABLY(index)
  return self.initABLY[index]
end

function M:getCurABLY(index)
  return self.initABLY[index] + self.addABLY[index] + self.tmpABLY[index] + BMgrOL.getAuraSkillData(self.mFlag, index)
end

function M:getRes(value)
  local res = 0
  value = tonumber(value)
  if value == CAUSE_SILENCE then
    res = self:getCurABLY(RES_SILENCE) + self:getCurABLY(RES_ALL)
  elseif value == CAUSE_POISON then
    res = self:getCurABLY(RES_POISON) + self:getCurABLY(RES_ALL)
  elseif value < CAUSE_BACK or value > CAUSE_BURN then
    res = 0
  else
    res = self:getCurABLY(value + 1000) + self:getCurABLY(RES_ALL)
  end
  return res
end

function M:getElementType()
  return self.model_.element
end

function M:getElementValue(element)
  local tempList1, tempList2
  if 1 == self.mFlag then
    tempList1 = GameData.SCENE_ELEMENT_BUDDHA
    tempList2 = GameData.RELICS_ELEMENT_PROPS_BUDDHA
  else
    tempList1 = GameData.SCENE_ELEMENT_MONSTER
    tempList2 = GameData.RELICS_ELEMENT_PROPS_MONSTER
  end
  local res = 0
  local tFunc = {
    [1] = self.model_.propGold + tempList1[1] + tempList2[1],
    [2] = self.model_.propWood + tempList1[2] + tempList2[2],
    [3] = self.model_.propWater + tempList1[3] + tempList2[3],
    [4] = self.model_.propFire + tempList1[4] + tempList2[4],
    [5] = self.model_.propEarth + tempList1[5] + tempList2[5]
  }
  res = tFunc[element] + self.model_.propAllElements
  return res
end

function M:setAnimationSpeed(value)
  if self.mView and self.mView.setAnimationSpeed then
    self.mView:setAnimationSpeed(value)
  end
end

function M:setLocalZOrder(value)
  self.mView:setLocalZOrder(value)
end

function M:getBuddhaId()
  return self.model_.npcId
end

function M:getBuddhaForce()
  return self.model_.force
end

function M:onKillByWutian(pos)
  self.mState = "Died"
  self.mView:dispatchEvent({
    name = "KillByWutian",
    tPos = pos
  })
end

function M:onWutianSpell()
  self.mState = "AnimationPlay"
end

function M:onAnimationPlay()
  self.mAniStateIndex = AniState.atk
end

function M:hide()
  self.mView:hide()
end

function M:pause()
  self.mView:dispatchEvent({name = "TAG_PAUSE"})
end

function M:resume()
  self.mView:dispatchEvent({name = "TAG_RESUME"})
end

return M

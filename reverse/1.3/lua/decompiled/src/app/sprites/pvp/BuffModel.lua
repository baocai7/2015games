local DYClass = "BuffModel"
local FRAME_SEC = GameManager.FRAME_SEC
local TAG = {
  ADD_BUFF = 1,
  DE_BUFF = 0,
  PHY_ATK = 1,
  PHY_DEF = 2,
  MAG_ATK = 3,
  MAG_DEF = 4,
  CRIT = 5,
  DE_HARM = 6,
  SPD_ATK = 7,
  LIFE = 8,
  SPEED = 9
}
local M = {}
M = class(DYClass)

function M:ctor(parent, buffid, dt, time, effectValue)
  self.mParent = parent
  self.mBuffid = buffid
  self.mTimeCount = 0
  self.mDurationTime = time * FRAME_SEC
  self.mDetalTime = dt * FRAME_SEC
  self.mEffectValue = effectValue
  self.mBuffViewName = nil
  self.mIsActive = false
  self:createFuc()
  self.addValueRate = 0
  if effectValue < 0 then
    self.isDeBuff = true
  else
    self.isDeBuff = false
  end
end

function M:createFuc()
  if not self["B" .. self.mBuffid] then
    self.trgFuc = self.commonBegin
    self.endFuc = self.commonEnd
  else
    self.trgFuc = self["B" .. self.mBuffid]
    self.endFuc = self["E" .. self.mBuffid]
  end
  local buffViewName = self:trgFuc()
  return buffViewName
end

function M:killSelf()
  DDLOG("buff\231\167\187\233\153\164\228\186\134")
  self.endFuc(self)
  self.mParent:removeBuff(self)
  self = nil
end

function M:getBuffView()
  return self.mBuffViewName
end

function M:commonBegin()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
end

function M:commonEnd()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:update()
  self.mTimeCount = self.mTimeCount + 1
  if self.mTimeCount == self.mDetalTime then
    self:trgFuc()
    self.mTimeCount = 0
  end
  self.mDurationTime = self.mDurationTime - 1
  if 0 >= self.mDurationTime then
    self:killSelf()
  end
end

function M:B1()
  self.mParent:setInitABLY(LIFE, self.mEffectValue)
  self.mParent:increaseHP(self.mEffectValue)
  if not self.mIsPlay then
    self.mIsPlay = true
    if self.mEffectValue >= 0 then
      self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.LIFE)
      self.mBuffViewName = "lifeMaxAdd"
    else
      self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.LIFE)
    end
  end
end

function M:E1()
  self.mParent:setInitABLY(LIFE, -self.mEffectValue)
  if self.mParent:getCurABLY(LIFE_CUR) > self.mParent:getCurABLY(LIFE) then
    self.mParent.initABLY[LIFE_CUR] = self.mParent.initABLY[LIFE]
  end
end

function M:B2()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue >= 0 then
    if self.mParent.model_.attackType == 1 then
      self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.PHY_ATK)
      self.mBuffViewName = "phyAtkAdd"
    else
      self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.MAG_ATK)
      self.mBuffViewName = "magAtkAdd"
    end
  elseif self.mParent.model_.attackType == 1 then
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.PHY_ATK)
    self.mBuffViewName = "phyAtkSub"
  else
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.MAG_ATK)
    self.mBuffViewName = "magAtkSub"
  end
end

function M:E2()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B3()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue >= 10000 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.PHY_DEF)
    self.mBuffViewName = "phyResist"
  elseif self.mEffectValue >= 0 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.PHY_DEF)
    self.mBuffViewName = "phyDefAdd"
  else
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.PHY_DEF)
    self.mBuffViewName = "phyDefSub"
  end
end

function M:E3()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B4()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue >= 10000 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.MAG_DEF)
    self.mBuffViewName = "magResist"
  elseif self.mEffectValue >= 0 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.MAG_DEF)
    self.mBuffViewName = "magDefAdd"
  else
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.MAG_DEF)
    self.mBuffViewName = "magDefSub"
  end
end

function M:E4()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B5()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue >= 0 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.SPD_ATK)
    self.mBuffViewName = "atkSpeedAdd"
  else
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.SPD_ATK)
    self.mBuffViewName = "atkSpeedAdd"
  end
end

function M:E5()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B10()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue >= 0 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.SPEED)
    self.mBuffViewName = "moveSpeedAdd"
  else
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.SPEED)
    self.mBuffViewName = "moveSpeedSub"
  end
end

function M:E10()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B19()
  local tmpHpAdd = self.mEffectValue
  self.mParent:increaseHP(tmpHpAdd)
end

function M:E19()
end

function M:B101()
  if self.mEffectValue >= 0 then
    self.addRateValue = self.mParent:getCurABLY(LIFE) * self.mEffectValue * 0.01
    local maxHp = self.mParent:setInitABLY(LIFE, self.addRateValue)
    local curHp = self.mParent:getCurABLY(LIFE_CUR)
    if maxHp < curHp then
      self.mParent.initABLY[LIFE_CUR] = maxHp
    end
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.LIFE)
    self.mBuffViewName = "lifeMaxAdd"
    self.mParent:increaseHP(self.addRateValue)
  elseif self.mParent.isMonsterBoss ~= true then
    self.addRateValue = self.mParent:getCurABLY(LIFE) * self.mEffectValue * 0.01
    local maxHp = self.mParent:setInitABLY(LIFE, self.addRateValue)
    local curHp = self.mParent:getCurABLY(LIFE_CUR)
    if maxHp < curHp then
      self.mParent.initABLY[LIFE_CUR] = maxHp
    end
    self.mParent.mView:dispatchEvent({
      name = "UNDATE_BLOOD",
      rMaxHp = maxHp,
      rCurHp = curHp,
      rHplose = -self.addRateValue,
      rType = 1
    })
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.LIFE)
  end
  self.addRateValue = self.addRateValue or 0
end

function M:E101()
  local curMaxHp = self.mParent:setInitABLY(LIFE, -self.addRateValue)
  local curHp = self.mParent:getCurABLY(LIFE_CUR)
  if curMaxHp < curHp then
    self.mParent.initABLY[LIFE_CUR] = curMaxHp
  end
  self.mParent.mView:dispatchEvent({
    name = "UNDATE_BLOOD",
    rMaxHp = curMaxHp,
    rCurHp = curHp
  })
end

function M:B201()
  if self.mEffectValue >= 0 then
    self.addRateValue = self.mParent:getInitABLY(LIFE) * self.mEffectValue * 0.01
    local maxHp = self.mParent:getCurABLY(LIFE)
    local curHp = self.mParent:setInitABLY(LIFE, self.addRateValue)
    if maxHp < curHp then
      self.mParent.initCurABLY[LIFE_CUR] = maxHp
    end
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.LIFE)
    self.mBuffViewName = "lifeMaxAdd"
    self.mParent:increaseHP(self.addRateValue)
  elseif self.mParent.isMonsterBoss ~= true then
    self.addRateValue = self.mParent:getInitABLY(LIFE) * self.mEffectValue * 0.01
    local maxHp = self.mParent:getCurABLY(LIFE)
    local curHp = self.mParent:setInitABLY(LIFE_CUR, self.addRateValue)
    self.mParent.mView:dispatchEvent({
      name = "UNDATE_BLOOD",
      rMaxHp = maxHp,
      rCurHp = curHp,
      rHplose = -self.addRateValue,
      rType = 1
    })
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.LIFE)
  end
  self.addRateValue = self.addRateValue or 0
end

function M:E201()
  return
end

function M:B102()
  DDLOG(DYLang.getString("S1511", ""))
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue >= 0 then
    if self.mParent.model_.attackType == 1 then
      self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.PHY_ATK)
      self.mBuffViewName = "phyAtkAdd"
    else
      self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.MAG_ATK)
      self.mBuffViewName = "magAtkAdd"
    end
  elseif self.mParent.model_.attackType == 1 then
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.PHY_ATK)
    self.mBuffViewName = "phyAtkSub"
  else
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.MAG_ATK)
    self.mBuffViewName = "magAtkSub"
  end
end

function M:E102()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B103()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue >= 10000 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.PHY_DEF)
    self.mBuffViewName = "phyResist"
  elseif self.mEffectValue >= 0 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.PHY_DEF)
    self.mBuffViewName = "phyDefAdd"
  else
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.PHY_DEF)
    self.mBuffViewName = "phyDefSub"
  end
end

function M:E103()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B104()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue >= 10000 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.MAG_DEF)
    self.mBuffViewName = "magResist"
  elseif self.mEffectValue >= 0 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.MAG_DEF)
    self.mBuffViewName = "magDefAdd"
  else
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.MAG_DEF)
    self.mBuffViewName = "magDefSub"
  end
end

function M:E104()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B105()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue >= 0 then
    self.mBuffViewName = "atkSpeedAdd"
  else
    self.mBuffViewName = "atkSpeedAdd"
  end
  DDLOG(DYLang.getString("S1512", ""))
end

function M:E105()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B110()
  DDLOG(DYLang.getString("S1513", ""))
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue >= 0 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.SPEED)
    self.mBuffViewName = "moveSpeedAdd"
  else
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.SPEED)
    self.mBuffViewName = "moveSpeedSub"
  end
end

function M:E110()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B119()
  DDLOG(DYLang.getString("S1514", ""))
  local addHp = self.mParent:getCurABLY(LIFE) * self.mEffectValue * 0.01
  self.mParent:increaseHP(addHp)
  self.mBuffViewName = "lifeRecovey"
end

function M:E119()
end

function M:B120()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
end

function M:E120()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B121()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  self.mBuffViewName = "blurry"
end

function M:E121()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B122()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  DDLOG(DYLang.getString("S1515", ""))
  if self.mEffectValue >= 0 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.CRIT)
    self.mBuffViewName = "critAdd"
  else
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.CRIT)
  end
end

function M:E122()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B124()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  DDLOG(DYLang.getString("S1516", ""))
  if self.mEffectValue >= 0 then
    self.mParent:showBuffNotice(TAG.ADD_BUFF, TAG.DE_HARM)
    self.mBuffViewName = "harmDecrese"
  else
    self.mParent:showBuffNotice(TAG.DE_BUFF, TAG.DE_HARM)
  end
end

function M:E124()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B125()
  DDLOG(DYLang.getString("S1517", ""))
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue < 0 then
    self.isDeBuff = false
  else
    self.isDeBuff = true
  end
end

function M:E125()
  DDLOG(DYLang.getString("S1518", ""))
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B126()
  DDLOG(DYLang.getString("S1519", ""))
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
end

function M:E126()
  DDLOG(DYLang.getString("S1520", ""))
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B1001()
  DDLOG(DYLang.getString("S1521", ""))
  self.mParent:beatBack(self.mEffectValue)
end

function M:E1001()
end

function M:B1002()
  DDLOG(DYLang.getString("S1522", ""))
  self.mParent.isDDOG = true
  self.mParent.mUpdateAble = false
  self.mParent.mState = "Stun"
  self.mBuffViewName = "stun"
  self.isDeBuff = true
end

function M:E1002()
  DDLOG(DYLang.getString("S1523", ""))
  self.mParent.mUpdateAble = true
  self.mParent.isDDOG = false
  self.mParent.mState = "Cover"
end

function M:B1003()
  self.mParent.mUpdateAble = false
  self.mParent.mState = "Stone"
  self.mBuffViewName = "stone"
  self.isDeBuff = true
end

function M:E1003()
  self.mParent.mUpdateAble = true
  self.mParent.mState = "Cover"
end

function M:B1004()
  DDLOG(DYLang.getString("S1524", ""))
  if self.mParent.mTag == "BOSS" or self.mParent.model_.monsterType == 3 then
    return false
  end
  self.mIsActive = true
  self.mParent:rebel()
  self.mParent.IS_SUMMON = true
  self.mBuffViewName = "meihuo"
end

function M:E1004()
  DDLOG(DYLang.getString("S1525", ""))
  if self.mIsActive then
    self.mParent:rebel()
  end
end

function M:B1005()
end

function M:E1005()
end

function M:B1006()
  DDLOG(DYLang.getString("S1526", ""))
  self.mParent.mAttackAble = false
  self.mParent.mState = "Idle"
  self.mBuffViewName = "palsy"
  self.isDeBuff = true
end

function M:E1006()
  DDLOG(DYLang.getString("S1527", ""))
  self.mParent.mAttackAble = true
end

function M:B1007()
  self.mParent.mMoveAble = false
  self.mBuffViewName = "freeze"
  self.isDeBuff = true
end

function M:E1007()
  self.mParent.mMoveAble = true
end

function M:B1008()
  self.mParent:decreaseHP(self.mEffectValue)
  self.mBuffViewName = "burn"
  self.isDeBuff = true
end

function M:E1008()
end

function M:B1009()
  DDLOG(DYLang.getString("S1528", ""))
  self.mParent.mInvincible = true
  self.isDeBuff = false
  self.mBuffViewName = "wudi"
  local curHp = self.mParent:getCurABLY(LIFE_CUR)
  if curHp < 0 then
    self.mParent.mState = "Cover"
    self.mParent:increaseHP(math.abs(curHp) + 10)
  end
end

function M:E1009()
  DDLOG(DYLang.getString("S1529", ""))
  self.mParent.mInvincible = false
end

function M:B1012()
  self.isDeBuff = false
  self.mParent.mState = "Stealth"
  self.mBuffViewName = "steal"
end

function M:E1012()
  self.mParent.mState = "Idle"
end

function M:B1013()
  DDLOG(DYLang.getString("S1530", ""))
  self.mParent:decreaseHP(self.mEffectValue)
end

function M:E1013()
end

function M:B1014()
  DDLOG(DYLang.getString("S1531", ""))
  self.mBuffViewName = "poison"
  self.isDeBuff = true
  self.mParent:decreaseHP(self.mEffectValue)
end

function M:E1014()
  DDLOG(DYLang.getString("S1532", ""))
end

function M:B1015()
  self.mParent:flyUp()
end

function M:E1015()
end

function M:B1016()
  if self.mParent.mTag ~= "BOSS" and self.mParent.model_.monsterType ~= 3 then
    self.mParent:decreaseHP(self.mParent:getCurABLY(LIFE_CUR) + 1)
  end
end

function M:E1016()
end

function M:B1017()
  DDLOG(DYLang.getString("S1533", ""))
  for _, v in pairs(self.mParent.mBuffList) do
    print(v.isDeBuff)
    if (v.mBuffid > 1008 or v.mBuffid < 1001) and v.mBuffid ~= 1017 and v.isDeBuff == false then
      v:killSelf()
    end
  end
end

function M:E1017()
  DDLOG(DYLang.getString("S1534", ""))
end

function M:B1018()
  DDLOG(DYLang.getString("S1535", ""))
  self.mParent.canCastSkill = false
  self.isDeBuff = true
  self.mBuffViewName = "chenmo"
end

function M:E1018()
  DDLOG(DYLang.getString("S1536", ""))
  self.mParent.canCastSkill = true
end

function M:B1019()
  DDLOG(DYLang.getString("S1537", ""))
  self.mBuffViewName = "qushan"
  self.mDurationTime = 1 * FRAME_SEC
  for _, v in pairs(self.mParent.mBuffList) do
    if v.isDeBuff == false then
      v:killSelf()
    end
  end
end

function M:E1019()
  DDLOG(DYLang.getString("S1538", ""))
end

function M:B1020()
  self.isDeBuff = false
  self.mParent.mState = "UnderGround"
  self.mBuffViewName = "steal"
end

function M:E1020()
  self.mParent.mState = "Cover"
end

function M:B2009()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if self.mEffectValue > 0 then
    self.mBuffViewName = "resist"
  end
end

function M:E2009()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B3001()
  DDLOG(DYLang.getString("S1539", ""))
end

function M:E3001()
  DDLOG(DYLang.getString("S1540", ""))
end

function M:B3002()
  DDLOG(DYLang.getString("S1541", ""))
end

function M:E3002()
  DDLOG(DYLang.getString("S1542", ""))
end

function M:B3003()
  DDLOG(DYLang.getString("S1543", ""))
end

function M:E3003()
  DDLOG(DYLang.getString("S1544", ""))
end

function M:B3004()
  DDLOG(DYLang.getString("S1545", ""))
end

function M:E3004()
  DDLOG(DYLang.getString("S1546", ""))
end

function M:B3005()
  DDLOG(DYLang.getString("S1547", ""))
end

function M:E3005()
  DDLOG(DYLang.getString("S1548", ""))
end

function M:B3006()
  DDLOG(DYLang.getString("S1549", ""))
end

function M:E3006()
  DDLOG(DYLang.getString("S1550", ""))
end

function M:B3007()
  DDLOG(DYLang.getString("S1551", ""))
end

function M:E3007()
  DDLOG(DYLang.getString("S1552", ""))
end

function M:B3008()
  DDLOG(DYLang.getString("S1553", ""))
end

function M:E3008()
  DDLOG(DYLang.getString("S1554", ""))
end

function M:B3100()
  DDLOG(DYLang.getString("S1555", ""))
end

function M:E3100()
  DDLOG(DYLang.getString("S1556", ""))
end

function M:B4002()
  local target
  if self.mParent.mFlag == 1 then
    target = BMgrOL.getMonsterTower()
  elseif self.mParent.mFlag == 2 then
    target = BMgrOL.getBuddhaTower()
  end
  target:underAttack(target.mParent, self.mEffectValue)
end

function M:E4002()
end

return M

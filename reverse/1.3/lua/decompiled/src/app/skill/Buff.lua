local DYClass = "Buff"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)
local MAX_SCALE = 2.5

function M:ctor(parent, buffid, dt, time, effectValue)
  self.mParent = parent
  self.mBuffid = buffid
  self.mEffectValue = effectValue
  self:createFuc()
  self.addValueRate = 0
  if 0 < dt then
    self:schedule(function()
      self:trgFuc()
    end, dt)
  end
  if 0 < time then
    self:performWithDelay(function()
      self:killSelf()
    end, time)
  end
  local faceTo = self.mParent.model_.isRebel
  if effectValue < 0 then
    self.isDeBuff = true
  else
    self.isDeBuff = false
  end
  if faceTo == 0 then
    self:setScaleX(-1)
  else
    self:setScaleX(1)
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
  self:trgFuc()
end

function M:commonBegin()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
end

function M:commonEnd()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:killSelf()
  self.endFuc(self)
  self:removeFromParent()
end

function M:calSize(tmpScale)
  local mScale = tmpScale or 100
  local rect = self.mParent:getContentSize()
  local tmpSize = (rect.width / 1.4 + rect.height / 1.4) / mScale
  if tmpSize > MAX_SCALE then
    tmpSize = MAX_SCALE
  end
  return tmpSize > MAX_SCALE and MAX_SCALE or tmpSize
end

function M:B1()
  self.mParent.maxHp_ = self.mParent.maxHp_ + self.mEffectValue
  self.mParent:increaseHP(self.mEffectValue)
  if not self.mIsPlay then
    self.mIsPlay = true
    if self.mEffectValue > 0 then
      self.mParent.buffNotice:PlayBuffNotice(1, 8)
      local frames = display.newFrames("shengmshu%d.png", 1, 16)
      local animation = display.newAnimation(frames, 0.08)
      local sp = display.newSprite()
      local tmpSize = self:calSize()
      sp:setPositionY(self.mParent:getContentSize().height / 2)
      sp:setScale(tmpSize)
      sp:playAnimationOnce(animation, false)
      self:addChild(sp)
    else
      self.mParent.buffNotice:PlayBuffNotice(0, 8)
      local frames = display.newFrames("shengmshu%d.png", 1, 16, true)
      local animation = display.newAnimation(frames, 0.08)
      local sp = display.newSprite()
      local tmpSize = self:calSize()
      sp:setPositionY(self.mParent:getContentSize().height / 2)
      sp:setScale(tmpSize)
      sp:playAnimationOnce(animation, false)
      self:addChild(sp)
    end
  end
end

function M:E1()
  self.mParent.maxHp_ = self.mParent.maxHp_ - self.mEffectValue
  if self.mParent.curHp_ > self.mParent.maxHp_ then
    self.mParent.curHp_ = self.mParent.maxHp_
  end
end

function M:B2()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp
    if self.mEffectValue >= 0 then
      if self.mParent.model_.attackType == 1 then
        self.mParent.buffNotice:PlayBuffNotice(1, 1)
        sp = BMgr.createBuffView("phyAtkAdd")
      else
        self.mParent.buffNotice:PlayBuffNotice(1, 1)
        sp = BMgr.createBuffView("magAtkAdd")
      end
    elseif self.mParent.model_.attackType == 1 then
      self.mParent.buffNotice:PlayBuffNotice(0, 1)
      sp = BMgr.createBuffView("phyAtkSub")
    else
      self.mParent.buffNotice:PlayBuffNotice(0, 1)
      sp = BMgr.createBuffView("magAtkSub")
    end
    local size = self:calSize()
    sp:setScale(size)
    sp:setPositionY(self.mParent:getContentSize().height / 2)
    self:addChild(sp)
  end
end

function M:E2()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B3()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp
    if self.mEffectValue >= 0 then
      self.mParent.buffNotice:PlayBuffNotice(1, 2)
      sp = BMgr.createBuffView("phyDefAdd")
    else
      self.mParent.buffNotice:PlayBuffNotice(0, 2)
      sp = BMgr.createBuffView("phyDefSub")
    end
    local size = self:calSize(200)
    sp:setScale(size)
    sp:setPositionY(self.mParent:getContentSize().height / 2)
    self:addChild(sp)
  end
end

function M:E3()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B4()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp
    if self.mEffectValue >= 0 then
      self.mParent.buffNotice:PlayBuffNotice(1, 2)
      sp = BMgr.createBuffView("magDefAdd")
    else
      self.mParent.buffNotice:PlayBuffNotice(0, 2)
      sp = BMgr.createBuffView("magDefSub")
    end
    local size = self:calSize(200)
    sp:setScale(size)
    sp:setPositionY(self.mParent:getContentSize().height / 2)
    self:addChild(sp)
  end
end

function M:E4()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B5()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
end

function M:E5()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B10()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
end

function M:E10()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B15()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if not self.mIsPlay then
    self.mIsPlay = true
    local frames = display.newFrames("tugd%d.png", 1, 8)
    local animation = display.newAnimation(frames, 0.08)
    local sp = display.newSprite()
    local rect = self.mParent:getAniBoundingBox()
    local tmpSize = self:calSize(80)
    sp:setAnchorPoint(cc.p(0.5, 0.5))
    sp:setPositionY(rect.height * 0.5)
    sp:setScale(tmpSize)
    self:addChild(sp)
    sp:playAnimationForever(animation, true)
  end
end

function M:E15()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B19()
  DDLOG(DYLang.getString("S1439", ""))
  local tmpHpAdd = self.mEffectValue
  self.mParent:increaseHP(tmpHpAdd)
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp = BMgr.createBuffView("lifeRecovey")
    local rect = self.mParent:getAniBoundingBox()
    local tmpSize = self:calSize()
    sp:setPositionY(rect.height / 2)
    sp:setScale(tmpSize)
    self:addChild(sp)
  end
end

function M:E19()
end

function M:B101()
  if self.mEffectValue < 0 and self.mParent.isMonsterBoss == true then
    return false
  end
  self.addRateValue = self.mParent.maxHp_ * self.mEffectValue * 0.01
  self.mParent.maxHp_ = self.mParent.maxHp_ + self.addRateValue
  self.mParent:increaseHP(self.addRateValue)
  DDLOG(DYLang.getString("S1440", ""), self.mParent.maxHp_)
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp
    if self.mEffectValue >= 0 then
      self.mParent.buffNotice:PlayBuffNotice(1, 8)
      sp = BMgr.createBuffView("lifeMaxAdd")
      local rect = self.mParent:getContentSize()
      local tmpScale = self:calSize()
      sp:setPositionY(rect.height * 0.5)
      sp:setScale(tmpScale)
      self:addChild(sp)
    else
      self.mParent.buffNotice:PlayBuffNotice(0, 8)
    end
  end
end

function M:E101()
  self.mParent.maxHp_ = self.mParent.maxHp_ - self.addRateValue
  if self.mParent.curHp_ > self.mParent.maxHp_ then
    self.mParent.curHp_ = self.mParent.maxHp_
  end
  self.mParent.bloodBar:setHp(self.mParent.curHp_, self.mParent.maxHp_)
  DDLOG(DYLang.getString("S1441", ""), self.mParent.curHp_)
end

function M:B102()
  DDLOG(DYLang.getString("S1442", ""))
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp
    if self.mEffectValue >= 0 then
      if self.mParent.model_.attackType == 1 then
        self.mParent.buffNotice:PlayBuffNotice(1, 1)
        sp = BMgr.createBuffView("phyAtkAdd")
      else
        self.mParent.buffNotice:PlayBuffNotice(1, 1)
        sp = BMgr.createBuffView("magAtkAdd")
      end
    elseif self.mParent.model_.attackType == 1 then
      self.mParent.buffNotice:PlayBuffNotice(0, 1)
      sp = BMgr.createBuffView("phyAtkSub")
    else
      self.mParent.buffNotice:PlayBuffNotice(0, 1)
      sp = BMgr.createBuffView("magAtkSub")
    end
    local size = self:calSize()
    sp:setScale(size)
    sp:setPositionY(self.mParent:getContentSize().height / 2)
    self:addChild(sp)
  end
end

function M:E102()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B103()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp
    if self.mEffectValue >= 0 then
      self.mParent.buffNotice:PlayBuffNotice(1, 2)
      sp = BMgr.createBuffView("phyDefAdd")
    else
      self.mParent.buffNotice:PlayBuffNotice(0, 2)
      sp = BMgr.createBuffView("phyDefSub")
    end
    local size = self:calSize(200)
    sp:setScale(size)
    sp:setPositionY(self.mParent:getContentSize().height / 2)
    self:addChild(sp)
  end
end

function M:E103()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B104()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp
    if self.mEffectValue >= 0 then
      self.mParent.buffNotice:PlayBuffNotice(1, 2)
      sp = BMgr.createBuffView("magDefAdd")
    else
      self.mParent.buffNotice:PlayBuffNotice(0, 2)
      sp = BMgr.createBuffView("magDefSub")
    end
    local size = self:calSize(200)
    sp:setScale(size)
    sp:setPositionY(self.mParent:getContentSize().height / 2)
    self:addChild(sp)
  end
end

function M:E104()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B105()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  DDLOG(DYLang.getString("S1443", ""))
  self.mParent.mAnimator:setSpeed(self.mParent:getCurABLY(ATK_SPED_RATE) * 0.01)
end

function M:E105()
  self.mParent.mAnimator:setSpeed(1)
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B110()
  DDLOG(DYLang.getString("S1444", ""))
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if not self.mIsPlay then
    self.mIsPlay = true
    if self.mEffectValue >= 0 then
      self.mParent.buffNotice:PlayBuffNotice(1, 9)
      local frames = display.newFrames("suliu%d.png", 1, 9)
      local animation = display.newAnimation(frames, 0.07)
      local sp = display.newSprite()
      local rect = self.mParent:getContentSize()
      sp:setAnchorPoint(cc.p(0.5, 0))
      sp:setPositionX(rect.width / 4)
      sp:setPositionY(0)
      sp:setScale((rect.width / 1.4 + rect.height / 1.4) / 140)
      self:addChild(sp)
      sp:playAnimationForever(animation, true)
    else
      self.mParent.buffNotice:PlayBuffNotice(0, 9)
    end
  end
end

function M:E110()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B119()
  DDLOG(DYLang.getString("S1445", ""))
  local tmpHpAdd = self.mParent.maxHp_ * self.mEffectValue * 0.01
  self.mParent:increaseHP(tmpHpAdd)
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp = BMgr.createBuffView("lifeRecovey")
    local rect = self.mParent:getAniBoundingBox()
    local tmpSize = self:calSize()
    sp:setPositionY(rect.height / 2)
    sp:setScale(tmpSize)
    self:addChild(sp)
  end
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
  local sequence = transition.sequence({
    cc.FadeTo:create(0.5, 128),
    cc.FadeTo:create(0.5, 255)
  })
  local action = cc.RepeatForever:create(sequence)
  self.mAction = action
  self.mParent.mAnimator:runAction(action)
end

function M:E121()
  DDLOG(DYLang.getString("S1446", ""))
  self.mParent:stopAction(self.mAction)
  transition.fadeTo(self.mParent.mAnimator.armature_, {opacity = 255, time = 0})
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B122()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  DDLOG(DYLang.getString("S1447", ""))
  if not self.mIsPlay then
    self.mIsPlay = true
    if self.mEffectValue >= 0 then
      self.mParent.buffNotice:PlayBuffNotice(1, 5)
      local sp = BMgr.createBuffView("critAdd"):addTo(self.mParent.mAnimator, -1)
      local rect = self.mParent:getAniBoundingBox()
      local tmpScale = self:calSize()
      sp:setScale(tmpScale)
      sp:setAnchorPoint(cc.p(0.5, 0.5))
      sp:setPositionY(0.5 * rect.height)
      self.sp = sp
    else
      self.mParent.buffNotice:PlayBuffNotice(0, 5)
    end
  end
end

function M:E122()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
  if self.sp then
    self.sp:removeFromParent()
  end
end

function M:B124()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  DDLOG(DYLang.getString("S1448", ""))
  if not self.mIsPlay then
    self.mIsPlay = true
    local frames = display.newFrames("tugd%d.png", 1, 8)
    local animation = display.newAnimation(frames, 0.08)
    local sp = display.newSprite()
    local rect = self.mParent:getAniBoundingBox()
    local tmpSize = self:calSize(80)
    sp:setAnchorPoint(cc.p(0.5, 0.5))
    sp:setPositionY(rect.height * 0.5)
    sp:setScale(tmpSize)
    self:addChild(sp)
    sp:playAnimationForever(animation, true)
  end
end

function M:E124()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B125()
  DDLOG(DYLang.getString("S1449", ""))
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
end

function M:E125()
  DDLOG(DYLang.getString("S1450", ""))
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B126()
  DDLOG(DYLang.getString("S1451", ""))
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
end

function M:E126()
  DDLOG(DYLang.getString("S1452", ""))
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B1001()
  DDLOG(DYLang.getString("S1453", ""))
  self.mParent.mAnimator:changeArmatureStateTo("HURT")
  self.mParent:setPositionX(self.mParent:getPositionX() - self.mParent.mFaceTo * self.mEffectValue * Const.Zoom0)
  local x = self.mParent:getPositionX()
  if x < BMgr.getMonsterPos().x then
    x = BMgr.getMonsterPos().x
  elseif x > BMgr.getBuddhaPos().x then
    x = BMgr.getBuddhaPos().x
  end
  self.mParent:setPositionX(x)
end

function M:E1001()
end

function M:B1002()
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp = BMgr.createBuffView("stun")
    sp:setPositionY(self.mParent:getContentSize().height)
    sp:setScale(2)
    self:addChild(sp)
  end
  self.mParent.mBUFF["1002"] = 1
end

function M:E1002()
  self.mParent.mBUFF["1002"] = nil
end

function M:B1003()
  self.mParent.mBUFF["1003"] = 1
  self.mParent:tPause()
  self.mParent.mState = "Stone"
  self.mParent.isInHurt_ = false
  self.mParent.mAnimator.armature_:setColor(cc.c3b(30, 30, 30))
end

function M:E1003()
  self.mParent.mBUFF["1003"] = nil
  self.mParent:tResume()
  self.mParent.mAnimator.armature_:setColor(cc.c3b(255, 255, 255))
end

function M:B1004()
  DDLOG(DYLang.getString("S1454", ""))
  if self.mParent.mTag == "BOSS" or self.mParent.model_.monsterType == 3 then
    return false
  end
  self.mParent:rebel()
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp = BMgr.createBuffView("meihuo")
    sp:setPositionY(self.mParent:getAniBoundingBox().height)
    sp:setScale(1)
    self:addChild(sp)
  end
  self.mParent.mBUFF["1004"] = 1
end

function M:E1004()
  self.mParent.mBUFF["1004"] = nil
end

function M:B1005()
end

function M:E1005()
end

function M:B1006()
  DDLOG(DYLang.getString("S1455", ""))
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp = BMgr.createBuffView("palsy")
    sp:setPositionY(self.mParent:getContentSize().height / 2)
    local tmpScale = self:calSize()
    sp:setScale(1)
    self:addChild(sp)
  end
  self.mParent.mBUFF["1006"] = 1
end

function M:E1006()
  DDLOG(DYLang.getString("S1456", ""))
  self.mParent.mBUFF["1006"] = nil
end

function M:B1007()
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp = BMgr.createBuffView("freeze")
    local rect = self.mParent:getAniBoundingBox()
    sp:setPositionY(rect.height * 0.2)
    sp:setAnchorPoint(cc.p(0.5, 0.5))
    local tmpScale = self:calSize(300)
    sp:setScale(tmpScale)
    self:addChild(sp)
    local tint = cc.TintTo:create(0, 52, 161, 230)
    self.mParent.mAnimator:runAction(tint)
  end
  self.mParent.mBUFF["1007"] = 1
end

function M:E1007()
  self.mParent.mBUFF["1007"] = nil
  local tint = cc.TintTo:create(0, 255, 255, 255)
  self.mParent.mAnimator:runAction(tint)
end

function M:B1008()
  if not self.mIsPlay then
    self.mIsPlay = true
    local frames = display.newFrames("shaoshang%d.png", 1, 8)
    local animation = display.newAnimation(frames, 0.05)
    local sp = display.newSprite()
    sp:setAnchorPoint(cc.p(0.5, 0))
    local tmpSize = self:calSize(500)
    sp:setScale(tmpSize)
    sp:playAnimationForever(animation, true)
    self:addChild(sp)
  end
  self.mParent:decreaseHP(self.mEffectValue)
end

function M:E1008()
end

function M:B1009()
  DDLOG(DYLang.getString("S1457", ""))
  if not self.mIsPlay then
    self.mIsPlay = true
  end
  self.mParent.IsInvincible_ = true
  if self.mParent.curHp_ < 0 then
    self.mParent.curHp_ = 1
  end
  self.mParent.mState = "Invincible"
end

function M:E1009()
  DDLOG(DYLang.getString("S1458", ""))
  self.mParent.IsInvincible_ = false
  self.mParent.mState = "Idle"
end

function M:B1012()
  self.mParent.mBUFF["1012"] = 1
  if not self.mIsPlay then
    self.mIsPlay = true
    transition.fadeTo(self.mParent.mAnimator.armature_, {opacity = 60, time = 1.5})
  end
end

function M:E1012()
  self.mParent.mBUFF["1012"] = nil
  transition.fadeTo(self.mParent.mAnimator.armature_, {opacity = 255, time = 1})
end

function M:B1013()
  DDLOG(DYLang.getString("S1459", ""))
  self.mParent:decreaseHP(self.mEffectValue)
end

function M:E1013()
end

function M:B1014()
  DDLOG(DYLang.getString("S1460", ""))
  self.mParent:decreaseHP(self.mEffectValue)
  local tint = cc.TintTo:create(0, 136, 21, 234)
  self.mParent.mAnimator:runAction(tint)
end

function M:E1014()
  DDLOG(DYLang.getString("S1461", ""))
  local tint = cc.TintTo:create(0, 255, 255, 255)
  self.mParent.mAnimator:runAction(tint)
end

function M:B1015()
  self.mParent.mBUFF["1013"] = 1
  self.mParent:flyUp()
  self.mParent:performWithDelay(function()
    self.mParent:fallDown()
  end, 1)
end

function M:E1015()
  self.mParent.mBUFF["1013"] = nil
end

function M:B1016()
  if self.mParent.mTag ~= "BOSS" or self.mParent.model_.monsterType ~= 3 then
    self.mParent:decreaseHP(self.mParent.maxHp_ + 1)
  end
end

function M:E1016()
end

function M:B1017()
  DDLOG(DYLang.getString("S1462", ""))
  if not self.mIsPlay then
    self.mIsPlay = true
    local frames = display.newFrames("qusat%d.png", 1, 10)
    local animation = display.newAnimation(frames, 0.1)
    local sp = display.newSprite()
    sp:setAnchorPoint(cc.p(0.5, 0.5))
    local rect = self.mParent:getContentSize()
    sp:setPositionY(self.mParent:getContentSize().height * 0.8)
    sp:setScale((rect.width / 1.4 + rect.height / 1.4) / 140)
    self:addChild(sp)
    sp:playAnimationOnce(animation, true)
  end
end

function M:E1017()
  DDLOG(DYLang.getString("S1463", ""))
end

function M:B1018()
  DDLOG(DYLang.getString("S1464", ""))
  self.mParent.canCastSkill = false
  if not self.mIsPlay then
    self.mIsPlay = true
    local sp = BMgr.createBuffView("chenmo")
    local rect = self.mParent:getAniBoundingBox()
    sp:setPosition(cc.p(rect.width / 2, rect.height))
    local tmpSize = self:calSize(550)
    sp:setScale(tmpSize)
    self:addChild(sp)
  end
end

function M:E1018()
  DDLOG(DYLang.getString("S1465", ""))
  self.mParent.canCastSkill = true
end

function M:B1019()
  DDLOG(DYLang.getString("S1466", ""))
  if not self.mIsPlay then
    self.mIsPlay = true
    local frames = display.newFrames("qusat%d.png", 1, 11)
    local animation = display.newAnimation(frames, 0.07)
    local sp = display.newSprite()
    local rect = self.mParent:getContentSize()
    sp:setAnchorPoint(cc.p(0.5, 0.5))
    sp:setPositionY(rect.height * 0.8)
    sp:setScale((rect.width / 1.4 + rect.height / 1.4) / 160)
    self:addChild(sp)
    sp:playAnimationOnce(animation, true)
  end
  for i = 1001, 1008 do
    local tmpBuff = self.mParent.mAnimator:getChildByTag(i)
    if tmpBuff then
      tmpBuff:killSelf()
    end
  end
end

function M:E1019()
  DDLOG(DYLang.getString("S1467", ""))
end

function M:B1020()
  self.mParent.mBUFF["1012"] = 1
  if not self.mIsPlay then
    self.mIsPlay = true
    transition.fadeTo(self.mParent.mAnimator.armature_, {opacity = 60, time = 1.5})
  end
end

function M:E1020()
  self.mParent.mBUFF["1012"] = nil
  transition.fadeTo(self.mParent.mAnimator.armature_, {opacity = 255, time = 1})
end

function M:B2009()
  self.mParent:setAddABLY(self.mBuffid, self.mEffectValue)
  if not self.mIsPlay then
    self.mIsPlay = true
    if self.mEffectValue > 0 then
      local sp = BMgr.createBuffView("resist")
      local rect = self.mParent:getAniBoundingBox()
      sp:setPosition(cc.p(0, rect.height / 2))
      local tmpSize = self:calSize()
      sp:setScale(tmpSize * 2)
      self:addChild(sp)
    end
  end
end

function M:E2009()
  self.mParent:setAddABLY(self.mBuffid, -self.mEffectValue)
end

function M:B3001()
  DDLOG(DYLang.getString("S1468", ""))
end

function M:E3001()
  DDLOG(DYLang.getString("S1469", ""))
end

function M:B3002()
  DDLOG(DYLang.getString("S1470", ""))
end

function M:E3002()
  DDLOG(DYLang.getString("S1471", ""))
end

function M:B3003()
  DDLOG(DYLang.getString("S1472", ""))
end

function M:E3003()
  DDLOG(DYLang.getString("S1473", ""))
end

function M:B3004()
  DDLOG(DYLang.getString("S1474", ""))
end

function M:E3004()
  DDLOG(DYLang.getString("S1475", ""))
end

function M:B3005()
  DDLOG(DYLang.getString("S1476", ""))
end

function M:E3005()
  DDLOG(DYLang.getString("S1477", ""))
end

function M:B3006()
  DDLOG(DYLang.getString("S1478", ""))
end

function M:E3006()
  DDLOG(DYLang.getString("S1479", ""))
end

function M:B3007()
  DDLOG(DYLang.getString("S1480", ""))
end

function M:E3007()
  DDLOG(DYLang.getString("S1481", ""))
end

function M:B3008()
  DDLOG(DYLang.getString("S1482", ""))
end

function M:E3008()
  DDLOG(DYLang.getString("S1483", ""))
end

function M:B3100()
  DDLOG(DYLang.getString("S1484", ""))
end

function M:E3100()
  DDLOG(DYLang.getString("S1485", ""))
end

function M:B4002()
  local target
  if self.mParent.mFlag == 1 then
    target = BMgr.getMonsterTower()
  elseif self.mParent.mFlag == 2 then
    target = BMgr.getBuddhaTower()
  end
  target:underAttack(target.mParent, self.mEffectValue)
end

function M:E4002()
end

return M

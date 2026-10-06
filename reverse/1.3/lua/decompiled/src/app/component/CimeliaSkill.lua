local DYClass = "CimeliaSkill"
local M = {}
local M = class(DYClass)
local ResCim = require("app.profiles.resouceCim")
local table = table
local math = clone(math)

function M:ctor()
  self.mExportMethod = {
    "initCimData",
    "castSkill"
  }
  self.BG = GameData.BG
  
  function math.random(m, n)
    local rnd = BMgr.RANDOM:random(m, n)
    return rnd
  end
end

function M:initCimData(parm)
  self.mFaceTo = parm.faceTo
  self.mFlag = parm.flag
  self.mData = DataUtils.getCimeliaSkillModel(parm.skillId)
  self.cimeliaATK = parm.atk
  self.attackType = parm.atkType
  self.attackDistance = parm.atkDis * Const.Zoom0
  self.res = ResCim[self.mData.name]
  display.addSpriteFrames(tostring(self.res.path1), tostring(self.res.path2))
  self:initTargetType(self.mData.target)
  self.onCast = self[self.mData.name]
  self.targets = {}
  GameData.CIMELIA_ATK.skillType = self.mData.range
end

function M:castSkill()
  local BGPrent = self.BG:getParent()
  self.tmpBgScale = BGPrent.mZoomRatio
  self:initCastPos(self.mData.range)
  DYSoundMgr.playEffect(self.mData.soundFile)
  self.tmpCurBGPos = cc.p(self.BG:getPosition())
  BGPrent:setBgScale(0.3, 0)
  self.mTimeScale = cc.Director:getInstance():getScheduler():getTimeScale()
  cc.Director:getInstance():getScheduler():setTimeScale(1.3)
  self:onCast()
end

local function getNearstEnemy(flag, number)
  local tmpFlag = flag
  local tmpList
  if tmpFlag == FLAG_TOWER_BUDDHA then
    tmpList = clone(BMgr.getMonsterList())
  elseif FLAG_TOWER_MONSTER == tmpFlag then
    tmpList = clone(BMgr.getBuddhaList())
  end
  if #tmpList == 0 then
    return {nil}
  end
  table.sort(tmpList, function(a, b)
    if tmpFlag == FLAG_TOWER_MONSTER then
      return a:getPositionX() < b:getPositionX()
    elseif tmpFlag == FLAG_TOWER_BUDDHA then
      return a:getPositionX() > b:getPositionX()
    end
  end)
  if number > #tmpList then
    number = #tmpList
  end
  return {
    unpack(tmpList, 1, number)
  }
end

function M:initCastPos(location)
  local tFunc = {
    [1] = {
      [FLAG_TOWER_MONSTER] = function()
        local actor = getNearstEnemy(FLAG_TOWER_MONSTER, 1)[1]
        if actor then
          return cc.p(actor:getPosition())
        else
          return BMgr.getBuddhaPos()
        end
      end,
      [FLAG_TOWER_BUDDHA] = function()
        local actor = getNearstEnemy(FLAG_TOWER_BUDDHA, 1)[1]
        if actor then
          return cc.p(actor:getPosition())
        else
          return BMgr.getMonsterPos()
        end
      end
    },
    [2] = {
      [FLAG_TOWER_MONSTER] = function()
        return BMgr.getMonsterPos()
      end,
      [FLAG_TOWER_BUDDHA] = function()
        return BMgr.getBuddhaPos()
      end
    },
    [3] = {
      [FLAG_TOWER_MONSTER] = function()
        return cc.p(display.cx, display.cy)
      end,
      [FLAG_TOWER_BUDDHA] = function()
        return cc.p(display.cx, display.cy)
      end
    }
  }
  local param = tonumber(location)
  self.castPos = tFunc[param][self.mFlag]()
end

function M:getSomeMonster(flag, number)
  local tmpFlag = flag
  local tmpList
  local rtnList = {}
  if tmpFlag == FLAG_TOWER_BUDDHA then
    tmpList = clone(BMgr.getMonsterList())
  elseif FLAG_TOWER_MONSTER == tmpFlag then
    tmpList = clone(BMgr.getBuddhaList())
  end
  if #tmpList == 0 then
    return {nil}
  end
  if self.mData.range == 3 then
    rtnList = tmpList
  else
    for _, v in pairs(tmpList) do
      if math.abs(v:getPositionX() - self.castPos.x) < self.attackDistance then
        table.insert(rtnList, v)
      end
    end
  end
  if number > #rtnList then
    number = #rtnList
  end
  return {
    unpack(rtnList, 1, number)
  }
end

local function getSomeAlly(flag, number)
  local tmpFlag = flag
  local tmpList
  if tmpFlag == FLAG_TOWER_BUDDHA then
    tmpList = clone(BMgr.getBuddhaList())
  elseif tmpFlag == FLAG_TOWER_MONSTER then
    tmpList = clone(BMgr.getMonsterList())
  end
  if #tmpList == 0 then
    return nil
  end
  table.sort(tmpList, function(a, b)
    return a.curHp_ / a.maxHp_ < b.curHp_ / b.maxHp_
  end)
  if number > #tmpList then
    number = #tmpList
  end
  return {
    unpack(tmpList, 1, number)
  }
end

function M:initTargetType(tarType)
  if 1 == tarType then
    self.findTarget = self.getSomeMonster
  elseif 2 == tarType then
    self.findTarget = getSomeAlly
  end
end

function M:calDamage()
  local number = self.mData.attTargetMaxNum
  if number == -1 then
    number = 20
  end
  local tmpList = self:findTarget(self.mFlag, number)
  if not tmpList then
    return
  end
  local tmpAttack = self.cimeliaATK * self.mData.skillParam[1].value / 100
  local Harm = self.mData.skillParam[2].value
  local attackType = self.attackType
  local defBase, defIncr
  for k, v in pairs(tmpList) do
    local DeHarmV = v:getCurABLY(REDUCE_HARM)
    local DeHarmR = v:getCurABLY(REDUCE_HARM_RATE)
    defBase = v:getCurABLY(MAG_DEF)
    defIncr = v:getCurABLY(MAG_DEF) or 100
    local tmpDefence = defBase * defIncr * 0.01
    local tmpH = math.floor(tmpAttack - tmpDefence + Harm - DeHarmV)
    if tmpH < tmpAttack * 0.1 then
      tmpH = tmpAttack * 0.1
    end
    local realDamage = math.floor(tmpH * (100 - DeHarmR) * 0.01)
    v:decreaseHP(realDamage)
    if #self.mData.buff > 0 then
      for _, sv in pairs(self.mData.buff) do
        if sv.Prob > math.random(0, 99) then
          v:addBuff(v, sv.ID, sv.CheckTime, sv.Time, sv.Value)
        end
      end
    end
  end
  self.BG:performWithDelay(function()
    self.BG:getParent():setBgScale(0.4, self.tmpBgScale)
    self.BG:getParent():setBgMove(0.5, self.tmpCurBGPos)
    local speed = DYStat.getValueInt(DY_KEY.kGameSpeed, 1)
    if speed == 2 then
      cc.Director:getInstance():getScheduler():setTimeScale(2)
      self.mTimeScale = 2
    else
      cc.Director:getInstance():getScheduler():setTimeScale(1.3)
      self.mTimeScale = 1.3
    end
  end, 1)
end

function M:lineType()
  local frames = display.newFrames(self.res.frameName .. "%d.png", self.res.frame1, self.res.frame2)
  local animation = display.newAnimation(frames, self.res.frameDelta)
  local count
  if self.res.aniOffsetX ~= 0 then
    count = math.ceil(self.attackDistance / math.abs(self.res.aniOffsetX))
  else
    count = self.res.aniCount
  end
  
  local function tFunc(x)
    if x == math.ceil(count / 2) then
      self:calDamage()
    end
  end
  
  local sprites = {}
  for i = 1, count do
    local sp = display.newSprite()
    local x = self.castPos.x + self.res.aniOffsetX * (i - 1) * self.mFaceTo
    local y = self.castPos.y + self.res.aniOffsetY
    sp:setAnchorPoint(cc.p(self.res.aniAnchorX, self.res.aniAnchorY))
    sp:setScale(self.res.aniScale)
    sp:setScaleX(self.mFaceTo * self.res.aniScale)
    sp:setPosition(cc.p(x, y))
    sprites[#sprites + 1] = sp
    self.BG:addChild(sprites[i], 9999)
    sprites[i]:playAnimationOnce(animation, true, function()
      tFunc(i)
    end, self.res.aniDelta * (i - 1))
  end
end

function M:pointType()
  local frames = display.newFrames(self.res.frameName .. "%d.png", self.res.frame1, self.res.frame2)
  local animation = display.newAnimation(frames, self.res.frameDelta)
  local count
  if self.res.aniOffsetX ~= 0 then
    count = math.ceil(self.attackDistance / math.abs(self.res.aniOffsetX))
    if 6 < count then
      count = 6
    end
  else
    count = self.res.aniCount
  end
  
  local function tFunc(x)
    if x == math.ceil(count / 2) then
      self:calDamage()
    end
  end
  
  local sprites = {}
  for i = 1, count do
    local sp = display.newSprite()
    local x = self.castPos.x + self.res.aniOffsetX * (i - 1) * self.mFaceTo
    local y = self.castPos.y + self.res.aniOffsetY
    sp:setAnchorPoint(cc.p(self.res.aniAnchorX, self.res.aniAnchorY))
    sp:setScale(self.res.aniScale)
    sp:setScaleX(self.mFaceTo * sp:getScaleX())
    sp:setPosition(cc.p(x, y))
    sprites[#sprites + 1] = sp
    self.BG:addChild(sprites[i], 9999)
    sprites[i]:playAnimationOnce(animation, true, function()
      tFunc(i)
    end, self.res.aniDelta * (i - 1))
  end
end

function M:fullScreenType()
  local tmpLayer = display.newLayer():addTo(cc.Director:getInstance():getRunningScene())
  local frames = display.newFrames(self.res.frameName .. "%d.png", self.res.frame1, self.res.frame2)
  local animation = display.newAnimation(frames, self.res.frameDelta)
  tmpLayer:setTouchSwallowEnabled(false)
  
  local function tFunc(x)
    if x == self.res.aniCount then
      self:calDamage()
      tmpLayer:removeFromParent()
    end
  end
  
  local sprites = {}
  for i = 1, self.res.aniCount do
    local sp = display.newSprite()
    local x = display.cx + self.mFaceTo * self.res.aniOffsetX
    local y = display.cy + self.res.aniOffsetY
    sp:setAnchorPoint(cc.p(self.res.aniAnchorX, self.res.aniAnchorY))
    sp:setScale(self.res.aniScale)
    sp:setScaleX(self.mFaceTo * sp:getScaleX())
    sp:setPosition(cc.p(x, y))
    sprites[#sprites + 1] = sp
    tmpLayer:addChild(sprites[i], 9999)
    sprites[i]:playAnimationOnce(animation, true, function()
      tFunc(i)
    end, self.res.aniDelta * (i - 1))
  end
end

local function shakeVertical()
  local curScene = cc.Director:getInstance():getRunningScene()
  local m1 = cc.MoveBy:create(0.1, cc.p(0, -10))
  local m2 = cc.MoveBy:create(0.1, cc.p(0, 10))
  local m3 = cc.MoveBy:create(0.1, cc.p(0, -5))
  local m4 = cc.MoveBy:create(0.1, cc.p(0, 5))
  curScene:runAction(transition.sequence({
    m1,
    m2,
    m3,
    m4
  }))
end

local function shakeHorizon()
  local curScene = cc.Director:getInstance():getRunningScene()
  local m1 = cc.MoveBy:create(0.1, cc.p(-10, 0))
  local m2 = cc.MoveBy:create(0.1, cc.p(10, 0))
  local m3 = cc.MoveBy:create(0.1, cc.p(-5, 0))
  local m4 = cc.MoveBy:create(0.1, cc.p(5, 0))
  curScene:runAction(transition.sequence({
    m1,
    m2,
    m3,
    m4
  }))
end

function M:meihuozhang()
  self:fullScreenType()
end

function M:yanjingzhang()
  self:lineType()
end

function M:leimuruyi()
  self:lineType()
end

function M:yunnizhang()
  local frames = display.newFrames(self.res.frameName .. "%d.png", self.res.frame1, self.res.frame2)
  local animation = display.newAnimation(frames, self.res.frameDelta)
  local count
  if self.res.aniOffsetX ~= 0 then
    count = math.ceil(self.attackDistance / math.abs(self.res.aniOffsetX))
    if 6 < count then
      count = 6
    end
  else
    count = self.res.aniCount
  end
  
  local function tFunc(x)
    if x == math.ceil(count / 2) then
      self:calDamage()
    end
  end
  
  local sprites = {}
  for i = 1, count do
    local sp = display.newSprite()
    local x = self.castPos.x + self.res.aniOffsetX * (i - 1) * self.mFaceTo
    local y = self.castPos.y + self.res.aniOffsetY
    sp:setAnchorPoint(cc.p(self.res.aniAnchorX, self.res.aniAnchorY))
    sp:setScale(self.res.aniScale)
    sp:setPosition(cc.p(x, y))
    sprites[#sprites + 1] = sp
    self.BG:addChild(sprites[i], 9999)
    sprites[i]:playAnimationOnce(animation, true, function()
      tFunc(i)
    end, self.res.aniDelta * (i - 1))
  end
end

function M:xishazhang()
  self:lineType()
end

function M:ximingzhang()
  self:lineType()
end

function M:ruoshuizhang()
  self:lineType()
end

function M:shenshuizhang()
  self:lineType()
end

function M:ruishizhang()
  self:pointType()
  shakeVertical()
end

function M:pofengzhang()
  self:pointType()
end

function M:wutongzhang()
  self:fullScreenType()
end

function M:nvwazhang()
  self:fullScreenType()
end

function M:jinjizhang()
  self:fullScreenType()
end

function M:chimangzhang()
  self:fullScreenType()
end

function M:jinjin()
  self:fullScreenType()
end

function M:diaokezhang()
  self:fullScreenType()
end

function M:shengunzhang()
  self:lineType()
end

function M:pengmuzhang()
  local frames = display.newFrames(self.res.frameName .. "%d.png", self.res.frame1, self.res.frame2)
  local animation = display.newAnimation(frames, self.res.frameDelta)
  local count
  if self.res.aniOffsetX ~= 0 then
    count = math.ceil(self.attackDistance / math.abs(self.res.aniOffsetX))
  else
    count = self.res.aniCount
  end
  local sprites = {}
  
  local function tFunc(x, sprites)
    if x == math.ceil(count / 2) then
      self:calDamage()
    elseif x == count then
      for _, v in pairs(sprites) do
        local sequence = transition.sequence({
          cc.FadeOut:create(1),
          cc.CallFunc:create(function()
            v:removeSelf()
          end)
        })
        v:runAction(sequence)
      end
    end
  end
  
  for i = 1, count do
    local randomNum = math.random(-25, 5)
    local sp = display.newSprite()
    local x = self.castPos.x + self.res.aniOffsetX * (i - 1) * self.mFaceTo
    local y = self.castPos.y + self.res.aniOffsetY + randomNum
    sp:setAnchorPoint(cc.p(self.res.aniAnchorX, self.res.aniAnchorY))
    sp:setScale(self.res.aniScale)
    sp:setPosition(cc.p(x, y))
    sprites[#sprites + 1] = sp
    self.BG:addChild(sprites[i], 2000 - 300 * randomNum)
    sprites[i]:playAnimationOnce(animation, false, function()
      tFunc(i, sprites)
    end, self.res.aniDelta * (i - 1))
  end
end

function M:dianbing()
  local frames = display.newFrames(self.res.frameName .. "%d.png", self.res.frame1, self.res.frame2)
  local animation = display.newAnimation(frames, self.res.frameDelta)
  self.res.aniCount = (BMgr.getBuddhaTower():getPositionX() - BMgr.getMonsterTower():getPositionX()) / self.res.aniOffsetX
  
  local function tFunc(x)
    if x == math.floor(self.res.aniCount / 3) then
      self:calDamage()
    end
  end
  
  local bbpos = cc.p(BMgr.getMonsterTower():getPosition())
  local sprites = {}
  for i = 1, self.res.aniCount do
    local sp = display.newSprite()
    local tmpRand = math.random(-40, 0)
    local x = bbpos.x + self.res.aniOffsetX * (i - 1) + tmpRand + 20
    local y = bbpos.y + tmpRand
    sp:setPosition(cc.p(x, y))
    sp:setAnchorPoint(cc.p(self.res.aniAnchorX, self.res.aniAnchorY))
    sp:setScale(self.res.aniScale - tmpRand / 80)
    sprites[#sprites + 1] = sp
    self.BG:addChild(sprites[i], 9999)
    sprites[i]:playAnimationOnce(animation, true, function()
      tFunc(i)
    end, self.res.aniDelta * (i - 1) - tmpRand / 80)
  end
end

function M:lietianzhang()
  local frames = display.newFrames(self.res.frameName .. "%d.png", self.res.frame1, self.res.frame2)
  local animation = display.newAnimation(frames, self.res.frameDelta)
  local sprites = {}
  local sp = display.newSprite()
  local x = self.castPos.x + self.res.aniOffsetX * self.mFaceTo
  local y = self.castPos.y + self.res.aniOffsetY
  sp:setAnchorPoint(cc.p(self.res.aniAnchorX, self.res.aniAnchorY))
  sp:setScale(self.res.aniScale)
  sp:setPosition(cc.p(x, y))
  self.BG:addChild(sp, 9999)
  sp:playAnimationOnce(animation, true)
  sp:performWithDelay(function()
    shakeVertical()
  end, 0.3)
  sp:performWithDelay(function()
    self:calDamage()
  end, self.res.damageTime)
end

function M:huoyuzhang()
  local frames = display.newFrames(self.res.frameName1 .. "%d.png", self.res.frame1B, self.res.frame1E)
  local frames1 = display.newFrames(self.res.frameName2 .. "%d.png", self.res.frame2B, self.res.frame2E)
  local frames2 = display.newFrames(self.res.frameName3 .. "%d.png", self.res.frame3B, self.res.frame3E)
  local animation = display.newAnimation(frames, self.res.frame1Delta)
  local animation1 = display.newAnimation(frames1, self.res.frame2Delta)
  local animation2 = display.newAnimation(frames2, self.res.frame3Delta)
  local sp1 = display.newSprite()
  local sp2 = display.newSprite()
  local sp3 = display.newSprite()
  sp1:setAnchorPoint(cc.p(0.5, 0.5))
  sp1:setScale(2)
  self.castPos = BMgr.getBuddhaPos()
  local x = self.castPos.x
  local y = self.castPos.y + 100
  sp1:setPosition(x, y)
  sp2:setPosition(x, y)
  sp3:setPosition(display.cx, y)
  self.BG:addChild(sp1, 9999)
  self.BG:addChild(sp2, 9998)
  self.BG:addChild(sp3, 9999)
  sp1:playAnimationForever(animation, 0)
  sp1:performWithDelay(function()
    sp1:removeFromParent()
    sp2:moveTo(1, 0, y)
  end, 1.5)
  sp2:playAnimationForever(animation2, 1.5)
  sp2:setScale(2)
  sp2:performWithDelay(function()
    sp2:removeFromParent()
  end, 3)
  sp3:setScale(2)
  sp3:setScaleX(4)
  sp3:playAnimationOnce(animation1, true, nil, 1.5)
  sp3:performWithDelay(function()
    self:calDamage()
  end, self.res.damageTime)
end

function M:muhuozhang()
  local frames1 = display.newFrames(self.res.frameName1 .. "%d.png", self.res.frame1B, self.res.frame1E)
  local frames2 = display.newFrames(self.res.frameName2 .. "%d.png", self.res.frame2B, self.res.frame2E)
  local animation1 = display.newAnimation(frames1, self.res.frame1Delta)
  local animation2 = display.newAnimation(frames2, self.res.frame2Delta)
  local sp1 = display.newSprite()
  local sp2 = display.newSprite()
  local sp3 = display.newSprite()
  local sp4 = display.newSprite()
  local speed = 700
  local runTime = self.attackDistance / speed
  local x = self.castPos.x
  local y = self.castPos.y
  sp1:setPosition(cc.p(x, y + 15))
  sp1:setAnchorPoint(cc.p(0, 0.5))
  sp1:playAnimationForever(animation1, 0)
  sp2:setPosition(cc.p(x, y + 30))
  sp2:setScale(0.8)
  sp2:setAnchorPoint(cc.p(0, 0.5))
  sp2:playAnimationForever(animation1, 0)
  sp3:setPosition(cc.p(x, y + 45))
  sp3:setScale(0.7)
  sp3:setAnchorPoint(cc.p(0, 0.5))
  sp3:playAnimationForever(animation1, 0)
  local tarpos = clone(self.castPos)
  tarpos.x = tarpos.x - self.mFaceTo * self.attackDistance
  sp4:setScale(1.5)
  sp4:setPosition(cc.p(tarpos.x, tarpos.y))
  sp4:setAnchorPoint(cc.p(0.3, 0))
  sp1:setScaleX(self.mFaceTo * sp1:getScaleX())
  sp2:setScaleX(self.mFaceTo * sp2:getScaleX())
  sp3:setScaleX(self.mFaceTo * sp3:getScaleX())
  sp4:setScaleX(self.mFaceTo * sp4:getScaleX())
  self.BG:addChild(sp1, 9999)
  self.BG:addChild(sp2, 9998)
  self.BG:addChild(sp3, 9997)
  self.BG:addChild(sp4, 9999)
  sp1:moveTo(runTime, tarpos.x, y + 15)
  sp2:moveTo(runTime, tarpos.x, y + 30)
  sp3:moveTo(runTime, tarpos.x, y + 45)
  sp1:performWithDelay(function()
    sp1:removeFromParent()
  end, runTime)
  sp2:performWithDelay(function()
    sp2:removeFromParent()
  end, runTime)
  sp3:performWithDelay(function()
    sp3:removeFromParent()
  end, runTime)
  sp4:playAnimationOnce(animation2, true, nil, runTime)
  sp4:performWithDelay(function()
    shakeHorizon()
    self:calDamage()
  end, runTime)
end

function M:tuyunzhang()
  local frames2 = display.newFrames(self.res.frameName2 .. "%d.png", self.res.frame2B, self.res.frame2E)
  local sp1 = display.newSprite("skillcimelia/tasyds.png")
  local sp2 = display.newSprite()
  local tarPos = self.castPos
  sp1:setAnchorPoint(1, 0)
  sp1:setPosition(tarPos.x, display.cy)
  sp1:setScale(1.5)
  sp2:setAnchorPoint(1, 0)
  sp2:setScale(2)
  
  local function sp2Play()
    local animation2 = display.newAnimation(frames2, self.res.frame2Delta)
    local x, y = sp1:getPosition()
    sp2:setPosition(cc.p(x, y))
    sp2:playAnimationOnce(animation2, true)
  end
  
  local action = {
    cc.MoveTo:create(0.3, cc.p(tarPos.x, tarPos.y - 50)),
    cc.CallFunc:create(function()
      shakeVertical()
    end),
    cc.CallFunc:create(function()
      sp2Play()
    end),
    cc.DelayTime:create(0.5),
    cc.CallFunc:create(function()
      sp1:removeFromParent()
    end)
  }
  local sequence = transition.sequence(action)
  sp1:runAction(sequence)
  self.BG:addChild(sp1, 9999)
  self.BG:addChild(sp2, 9999)
  sp2:performWithDelay(function()
    self:calDamage()
  end, 0.8)
end

function M:wugouzhang()
  self:fullScreenType()
end

function M:jumangzhang()
  local frames1 = display.newFrames(self.res.frameName1 .. "%d.png", self.res.frame1B, self.res.frame1E)
  local frames2 = display.newFrames(self.res.frameName2 .. "%d.png", self.res.frame2B, self.res.frame2E)
  local animation1 = display.newAnimation(frames1, self.res.frame1Delta)
  local animation2 = display.newAnimation(frames2, self.res.frame2Delta)
  local sp1 = display.newSprite()
  local sp2 = display.newSprite()
  local sp3 = display.newSprite()
  local sp4 = display.newSprite()
  self.BG:addChild(sp1)
  self.BG:addChild(sp2)
  self.BG:addChild(sp3)
  self.BG:addChild(sp4)
  sp1:setAnchorPoint(cc.p(0.5, 0.5))
  sp2:setAnchorPoint(cc.p(0.5, 0.5))
  sp3:setAnchorPoint(cc.p(0.5, 0.5))
  sp4:setAnchorPoint(cc.p(0.5, 0.5))
  sp1:setScale(0.6)
  sp2:setScale(1.2)
  sp3:setScale(0.4)
  sp4:setScale(0.8)
  local x = self.castPos.x
  local y = self.castPos.y + 100
  sp1:setPosition(x, y)
  sp2:setPosition(x, y)
  local tarPos = cc.p(x - self.mFaceTo * self.attackDistance, y)
  local speed = 2500
  local runTime = self.attackDistance / speed
  sp1:playAnimationOnce(animation1, true)
  sp2:performWithDelay(function()
    sp2:moveTo(runTime, tarPos.x, tarPos.y)
    sp2:performWithDelay(function()
      sp2:removeFromParent()
    end, runTime)
  end, 0.8)
  sp2:playAnimationForever(animation2, true, nil, 0.8)
  sp2:performWithDelay(function()
    self:calDamage()
  end, runTime + 0.8)
end

function M:xingfengzhang()
  local frames = display.newFrames(self.res.frameName .. "%d.png", self.res.frame1, self.res.frame2)
  local animation = display.newAnimation(frames, self.res.frameDelta)
  local sp1 = display.newSprite()
  sp1:setAnchorPoint(cc.p(self.res.aniAnchorX, self.res.aniAnchorY))
  sp1:setPosition(self.castPos.x, self.castPos.y + self.res.aniOffsetY)
  self.BG:addChild(sp1)
  local tarPos = clone(self.castPos)
  tarPos.x = tarPos.x - self.attackDistance
  local speed = 600
  local runTime = self.attackDistance / speed
  local animate = cc.Animate:create(animation)
  sp1:playAnimationForever(animation)
  transition.moveTo(sp1, {
    x = tarPos.x,
    time = runTime
  })
  transition.scaleTo(sp1, {scale = 3, time = 2})
  sp1:performWithDelay(function()
    self:calDamage()
    sp1:removeFromParent()
  end, runTime)
end

function M:monsterCastSkillMeihuo()
  local tmpLayer = display.newLayer():addTo(cc.Director:getInstance():getRunningScene())
  tmpLayer:setTouchSwallowEnabled(false)
  self.mFileInfo = {}
  DYRes.loadFileInfo("skillcimelia/tajinengdonghua/tajinengdonghua.csb", self.mFileInfo)
  local armature = ccs.Armature:create("tajinengdonghua")
  armature:addTo(tmpLayer, 1)
  armature:getAnimation():playWithIndex(1)
  armature:setPosition(cc.p(display.cx, display.cy))
  tmpLayer:performWithDelay(function()
    self:calDamage()
    self:removeFromParent()
  end, 1)
end

function M:monsterCastSkill(aniIndex)
  local tmpLayer = display.newLayer():addTo(cc.Director:getInstance():getRunningScene())
  tmpLayer:setTouchSwallowEnabled(false)
  self.mFileInfo = {}
  DYRes.loadFileInfo("skillcimelia/tajinengdonghua/tajinengdonghua.csb", self.mFileInfo)
  local armature = ccs.Armature:create("tajinengdonghua")
  armature:addTo(tmpLayer, 1)
  armature:getAnimation():playWithIndex(aniIndex)
  armature:setPosition(cc.p(display.cx, display.cy))
  tmpLayer:performWithDelay(function()
    self:calDamage()
    tmpLayer:removeFromParent()
  end, 1)
end

function M:monsterMeihuo(aniIndex)
  self:monsterCastSkill(self.res.aniIndex)
end

function M:monsterQiuku(aniIndex)
  self:monsterCastSkill(self.res.aniIndex)
end

function M:monsterYaofeng(aniIndex)
  self:monsterCastSkill(self.res.aniIndex)
end

return M

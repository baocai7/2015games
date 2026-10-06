local CimeliaSkill = require("app.sprites.pvp.CimeliaSkillModel")
local M = {}
M = class("PanelCimelia", function()
  return display.newNode()
end)

function M:ctor(handler_)
  self.mCallback = handler_
  self.mIsPause = false
  self:initData()
  self:initUI()
  local cimeliaAtkParam = {
    cimeliaType = "atk",
    atk = {
      flag = FLAG_TOWER_BUDDHA,
      skillId = Const.CIMELIA_SKILL or GameData.CIMELIA_ATK.skillId,
      atk = GameData.CIMELIA_ATK.atkNum,
      aktType = GameData.CIMELIA_ATK.atkType,
      atkDis = GameData.CIMELIA_ATK.atkDistance,
      hitRate = GameData.CIMELIA_ATK.hitRate,
      critRate = GameData.CIMELIA_ATK.critRate,
      critHarmRate = GameData.CIMELIA_ATK.critHarmRate,
      magDefIgnore = GameData.CIMELIA_ATK.magDefIgnore,
      phyDefIgnore = GameData.CIMELIA_ATK.phyDefIgnore,
      element = GameData.CIMELIA_ATK.element,
      elementValue = {
        [1] = GameData.CIMELIA_ATK.propGold + GameData.CIMELIA_ATK.propAllElements,
        [2] = GameData.CIMELIA_ATK.propWood + GameData.CIMELIA_ATK.propAllElements,
        [3] = GameData.CIMELIA_ATK.propWater + GameData.CIMELIA_ATK.propAllElements,
        [4] = GameData.CIMELIA_ATK.propFire + GameData.CIMELIA_ATK.propAllElements,
        [5] = GameData.CIMELIA_ATK.propEarth + GameData.CIMELIA_ATK.propAllElements
      }
    }
  }
  self.mAtkCimelia = CimeliaSkill.new(cimeliaAtkParam)
end

function M:initData()
  self.mIsInCD = true
end

function M:initUI()
  self.mIcon = display.newSprite("gamescene/icon_cimelia.png"):addTo(self)
  self.mIcon:setTouchEnabled(true)
  self.mIcon:setTouchSwallowEnabled(true)
  self.mIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name = event.name
    if name == "began" then
      self:iconClicked()
      return true
    end
  end)
  display.newSprite(GameData.CIMELIA_ATK.skillIcon):pos(self.mIcon:getContentSize().width * 0.5, self.mIcon:getContentSize().height * 0.5):addTo(self.mIcon)
  self:initProgressTimer()
end

function M:initProgressTimer()
  self.mProgressTimer = display.newProgressTimer("gamescene/iconshadow.png", display.PROGRESS_TIMER_BAR):pos(self.mIcon:getContentSize().width * 0.5, self.mIcon:getContentSize().height * 0.5):addTo(self.mIcon)
  self.mProgressTimer:setMidpoint(cc.p(0, 1))
  self.mProgressTimer:setBarChangeRate(cc.p(0, 1))
  self.mProgressTimer:setPercentage(100)
  self.mCurrCDTime = GameData.CIMELIA_ATK.skillCDTime
end

function M:updateCimeAtk()
  if not self.mIsInCD or self.mIsPause then
    return
  end
  self.mCurrCDTime = self.mCurrCDTime - 1 / GameData.PVE_FRAME
  self.mProgressTimer:setPercentage(self.mCurrCDTime / GameData.CIMELIA_ATK.skillCDTime * 100)
  if self.mCurrCDTime <= 0 then
    self:removeProTimer()
  end
end

function M:removeProTimer()
  if not self.mIsInCD then
    return
  end
  DYSoundMgr.playEffect(DY_SND.sfx_gun_cooldown)
  self.mIsInCD = false
  if self.mProgressTimer then
    self.mProgressTimer:removeSelf()
    self.mProgressTimer = nil
  end
  self.mFireIcon = display.newSprite("gamescene/icon_fire1.png"):pos(self.mIcon:getContentSize().width * 0.5, self.mIcon:getContentSize().height * 0.5):addTo(self.mIcon, 1)
  
  local function func1()
    self.mFireIcon:setTexture("gamescene/icon_fire2.png")
  end
  
  local function func2()
    self.mFireIcon:setTexture("gamescene/icon_fire1.png")
  end
  
  local seq = transition.sequence({
    cc.DelayTime:create(0.15),
    cc.CallFunc:create(func1),
    cc.DelayTime:create(0.15),
    cc.CallFunc:create(func2)
  })
  self.mFireIcon:runAction(cc.RepeatForever:create(seq))
  GameData.climeliaRangeTrip:startTips()
end

function M:iconClicked()
  if self.mIsInCD then
    return
  end
  if self.mFireIcon then
    self.mFireIcon:stopAllActions()
    self.mFireIcon:removeSelf()
    self.mFireIcon = nil
  end
  self.mIsInCD = true
  self:initProgressTimer()
  self:skillOnCast()
  GameData.climeliaRangeTrip:endTips()
end

function M:skillOnCast()
  self.mBgScale = GameData.BG:getParent().mZoomRatio
  self.mTimeScale = cc.Director:getInstance():getScheduler():getTimeScale()
  self.mBGPoint = cc.p(GameData.BG:getPosition())
  GameData.BG:setTouchEnabled(false)
  GameData.BG:getParent():setBgScale(0.3, 0)
  cc.Director:getInstance():getScheduler():setTimeScale(1.3)
  self.mAtkCimelia:castSkill()
  local delayTime = GameData.SKILL_DELAY or 0.5
  self:performWithDelay(function()
    self.mAtkCimelia:updateNpcBlood()
  end, delayTime)
  self:performWithDelay(function()
    GameData.BG:getParent():setBgScale(0.4, self.mBgScale)
    GameData.BG:getParent():setBgMove(0.5, self.mBGPoint)
    cc.Director:getInstance():getScheduler():setTimeScale(self.mTimeScale)
  end, 1 + delayTime)
  self:performWithDelay(function()
    GameData.BG:setTouchEnabled(true)
  end, 1.5 + delayTime)
end

function M:pause()
  if self.mProgressTimer then
    self.mIsPause = true
  end
end

function M:resume()
  if self.mProgressTimer then
    self.mIsPause = false
  end
end

return M

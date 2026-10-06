local CimeliaSkill = require("app.sprites.pvp.CimeliaSkillModel")
local TAG_EVENT_CIMELIA_BUDDHA = "tag_event_cimelia_buddha"
local M = {}
M = class("PanelCimelia", function()
  return display.newNode()
end)

function M:ctor(handler_)
  self.mCallback = handler_
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
  self.mIsCanBeClicked = true
  self.mCurrCDTime = Const.CimeliaColdTime1 or GameData.CIMELIA_ATK.skillCDTime * 2
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
end

function M:updateAtkCimeliaPro()
  if not self.mIsCanBeClicked or not self.mIsInCD then
    return
  end
  self.mCurrCDTime = self.mCurrCDTime - 1 / GameData.FRAME_PER_SECOND
  self.mProgressTimer:setPercentage(self.mCurrCDTime / (GameData.CIMELIA_ATK.skillCDTime * 2) * 100)
  if self.mCurrCDTime <= 0 then
    self.mCurrCDTime = 0
    self:removeProTimer()
  end
  if self.mIsSkillPlay then
    self.mCountTick = self.mCountTick + 1
    local delayTime = GameData.SKILL_DELAY or 0.5
    if delayTime <= self.mCountTick / GameData.FRAME_PER_SECOND then
      self.mCountTick = 0
      self.mIsSkillPlay = false
      self.mAtkCimelia:updateNpcBlood()
    end
  end
end

function M:removeProTimer()
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
  if not self.mIsCanBeClicked or self.mIsInCD then
    return
  end
  self.mIsCanBeClicked = false
  local params = {
    cimeliaType = "atk",
    skillId = GameData.CIMELIA_ATK.skillId,
    atkNum = GameData.CIMELIA_ATK.atkNum,
    atkType = GameData.CIMELIA_ATK.attackType,
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
  self.mCallback(params)
end

function M:playCimeliaSkill()
  if self.mFireIcon then
    self.mFireIcon:stopAllActions()
    self.mFireIcon:removeSelf()
    self.mFireIcon = nil
  end
  self.mIsInCD = true
  self.mCurrCDTime = Const.CimeliaColdTime1 or GameData.CIMELIA_ATK.skillCDTime * 2
  self.mIsCanBeClicked = true
  GameData.climeliaRangeTrip:endTips()
  self:initProgressTimer()
  self.mAtkCimelia:castSkill()
  self.mIsSkillPlay = true
  self.mCountTick = 0
end

function M:getCurrCDTime()
  return self.mCurrCDTime
end

function M:getDataForAI()
  local t = {
    cd = self.mCurrCDTime,
    tags = GameData.CIMELIA_ATK.aiTags
  }
  return t
end

function M:pause()
  if self.mProgressTimer then
    self.mProgressTimer:pause()
  end
end

function M:resume()
  if self.mProgressTimer then
    self.mProgressTimer:resume()
  end
end

return M

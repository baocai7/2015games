local CimeliaSkill = require("app.sprites.pvp.CimeliaSkillModel")
local M = {}
M = class("PanelSkill", function()
  return display.newNode()
end)

function M:ctor(handler_)
  self.mCallback = handler_
  self.mIsPause = false
  self:initData()
  self:initUI()
  local cimeliaDefParam = {
    cimeliaType = "def",
    def = {
      flag = FLAG_TOWER_BUDDHA,
      skillId = Const.CIMELIA_DEF_SKILL or GameData.CIMELIA_DEF.skillId,
      atk = 0,
      aktType = 1,
      atkDis = -1
    }
  }
  self.mDefCimelia = CimeliaSkill.new(cimeliaDefParam)
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
  display.newSprite(GameData.CIMELIA_DEF.skillIcon):pos(self.mIcon:getContentSize().width * 0.5, self.mIcon:getContentSize().height * 0.5):addTo(self.mIcon)
  self:initProgressTimer()
end

function M:initProgressTimer()
  self.mProgressTimer = display.newProgressTimer("gamescene/iconshadow.png", display.PROGRESS_TIMER_BAR):pos(self.mIcon:getContentSize().width * 0.5, self.mIcon:getContentSize().height * 0.5):addTo(self.mIcon, 1)
  self.mProgressTimer:setMidpoint(cc.p(0, 1))
  self.mProgressTimer:setBarChangeRate(cc.p(0, 1))
  self.mProgressTimer:setPercentage(100)
  self.mCurrCDTime = GameData.CIMELIA_DEF.skillCDTime
end

function M:updateCimeDEF()
  if not self.mIsInCD or self.mIsPause then
    return
  end
  self.mCurrCDTime = self.mCurrCDTime - 1 / GameData.PVE_FRAME
  self.mProgressTimer:setPercentage(self.mCurrCDTime / GameData.CIMELIA_DEF.skillCDTime * 100)
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
  self.mFireIcon = display.newSprite("gamescene/icon_fire1.png"):pos(self.mIcon:getContentSize().width * 0.5, self.mIcon:getContentSize().height * 0.5):addTo(self.mIcon, 2)
  
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
end

function M:skillOnCast()
  self.mDefCimelia:castSkillTower()
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

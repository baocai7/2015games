local TowerBuddha = require("app.sprites.TowerBuddha")
local TowerBuddhaES = {}
TowerBuddhaES = class("TowerBuddhaES", TowerBuddha)

function TowerBuddhaES:ctor(towerBuddhaModel)
  cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
  self.hpMax_ = GameData.CIMELIA_DEF.towerHP
  self.hpCur_ = GameData.CIMELIA_DEF.towerHP
  self.hpShield_ = GameData.CIMELIA_DEF.towerHP
  self.towerLevel_ = 1
  self.wandLevel_ = 1
  self.mElement = GameData.CIMELIA_DEF.element
  DYComponent.getTable(self, "battleData.baseData")
  local barPosRatio = 0
  local wandPosRatio = 0
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("armature/tangseng/tangseng.csb")
  self.towerArmature_ = ccs.Armature:create("tangseng")
  barPosRatio = 1
  wandPosRatio = -60
  self:changeArmatureStateTo("WALK")
  self.towerArmature_:setAnchorPoint(0.5, 0)
  self.towerArmature_:setScale(0.3)
  self:addChild(self.towerArmature_)
  self.barBg_ = display.newSprite("gamescene/bar_bg_tower_b.png", 0, self.towerArmature_:getContentSize().height * barPosRatio):addTo(self.towerArmature_)
  self.progressTimer_ = cc.ProgressTimer:create(display.newSprite("gamescene/bar_hp_tower_b1.png")):addTo(self.barBg_)
  self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.progressTimer_:setPosition(self.barBg_:getContentSize().width / 2, self.barBg_:getContentSize().height / 2)
  self.progressTimer_:setMidpoint(cc.p(0, 0))
  self.progressTimer_:setBarChangeRate(cc.p(1, 0))
  self.progressTimer_:setPercentage(self.hpCur_ / self.hpMax_ * 100)
  self.towerBloodLabel_ = cc.ui.UILabel.new({
    UILabelType = 2,
    text = string.format("%d/%d", self.hpCur_, self.hpMax_),
    size = 20
  }):align(display.CENTER, self.barBg_:getContentSize().width / 2, self.barBg_:getContentSize().height / 2):addTo(self.barBg_, 1)
  if Game.MODE == "NORMAL" then
    local stageModel = DataUtils.getStageModel(GameManager.STAGE_NUM)
    if 1 == tonumber(stageModel.isGrooveMode_) then
      self:wandInCD()
    end
  end
  self.mFlag = 10
  self.mHitEffectCount = 0
  self.mSpeed = Const.TowerBuddhaSpeed
  self:schedule(function()
    self:updateLogic()
  end, 0.05)
  self.mCanMove = true
  self.mNoramlTime = 3
  self.mCountTime = 0
  self.mCantAttack = false
  self:addEventListener("GAME_ES_TANG_RUN", handler(self, self.runSpeed))
end

function TowerBuddhaES:changeArmatureStateTo(state)
  if state == "WALK" then
    if self.curArmatureState_ ~= "WALK" then
      self.curArmatureState_ = "WALK"
      self.towerArmature_:getAnimation():playWithIndex(1)
    end
  elseif state == "HURT" and self.curArmatureState_ ~= "HURT" then
    self.curArmatureState_ = "HURT"
    self.towerArmature_:getAnimation():playWithIndex(0)
  end
end

function TowerBuddhaES:underAttack(source, loseHp)
  TowerBuddhaES.super.underAttack(self, source, loseHp)
  self:changeArmatureStateTo("HURT")
  self.mCountTime = 0
  self.mCanMove = false
end

function TowerBuddhaES:updateLogic()
  self.mReachPosX = BMgr.getMonsterPos().x
  if self.mCanMove then
    self:setPosition(cc.pAdd(cc.p(self:getPosition()), cc.p(Const.Zoom0 * self.mSpeed / 20 / 1.4, 0)))
  end
  local tmpX = self:getPositionX()
  if tmpX <= self.mReachPosX + 100 then
    self.mSpeed = 0
    if self.isReached then
      self:dispatchEvent({
        name = "REACH_POINT"
      })
    end
  end
  self.mCountTime = self.mCountTime + 0.05
  if self.mCountTime >= self.mNoramlTime then
    self.mCanMove = true
    self.mCountTime = 0
    self:changeArmatureStateTo("WALK")
  end
end

function TowerBuddhaES:getMyBoundingBox()
  local tmpWidth = 0
  local size = cc.size(self.towerArmature_:getContentSize().width * Const.Zoom0, self.towerArmature_:getContentSize().height * Const.Zoom0)
  local tmpX = self:getPositionX()
  local tmpWidth = tmpX
  return tmpWidth
end

function TowerBuddhaES:runSpeedUp()
  DDLOG(DYLang.getString("S1502", ""))
  self.mSpeed = -100
  self.isReached = true
end

return TowerBuddhaES

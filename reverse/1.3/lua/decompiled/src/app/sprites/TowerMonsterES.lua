local TowerMonster = require("app.sprites.TowerMonster")
local TowerMonsterES = {}
TowerMonsterES = class("TowerMonsterES", TowerMonster)

function TowerMonsterES:ctor(towerMonsterModel)
  TowerMonsterES.super.ctor(self, towerMonsterModel)
  self.mCantAttack = false
  if self.backBg_ then
    self.backBg_:setVisible(false)
  end
  if self.door_ then
    self.door_:setVisible(false)
  end
  if self.door1_ then
    self.door1_:setVisible(false)
  end
  if self.barBg then
    self.barBg:setVisible(false)
  end
  self.towerArmature_ = self.towerBg_
  self.towerArmature_:setScale(0.4)
  self.towerArmature_:setPositionX(0)
  self.towerArmature_:setVisible(true)
  self.mAniState = true
  local barBg = display.newSprite("gamescene/bar_bg_tower_m.png", self.towerBg_:getContentSize().width * 0.5, self.towerBg_:getContentSize().height * 1.15):addTo(self.towerBg_)
  self.progressTimer_ = cc.ProgressTimer:create(display.newSprite("gamescene/bar_hp_tower_m.png")):addTo(barBg)
  self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.progressTimer_:setPosition(barBg:getContentSize().width / 2, barBg:getContentSize().height / 2)
  self.progressTimer_:setMidpoint(cc.p(0, 0))
  self.progressTimer_:setBarChangeRate(cc.p(1, 0))
  self.progressTimer_:setPercentage(100)
  self.barBg = barBg
  self.towerBloodLabel_ = cc.ui.UILabel.new({
    UILabelType = 2,
    text = string.format("%d/%d", GameData.getMonsterTowerHP(), self.hpMax_),
    size = 20
  }):align(display.CENTER, barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  self:schedule(function()
    self:changeArmatureStateTo()
  end, 5)
end

function TowerMonsterES:initTowerImageFigure()
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("armature/lakenvyao/lakenvyao.csb")
  self.towerBg_ = ccs.Armature:create("lakenvyao")
  self.towerBg_:getAnimation():playWithIndex(0)
  self.towerBg_:setAnchorPoint(0.5, 0)
  self.towerBg_:setScale(-0.4, 0.4)
  self:addChild(self.towerBg_)
end

function TowerMonsterES:changeArmatureStateTo()
  if self.mAniState then
    self.towerArmature_:getAnimation():playWithIndex(1)
    self.mAniState = false
  else
    self.towerArmature_:getAnimation():playWithIndex(0)
    self.mAniState = true
  end
end

function TowerMonsterES:onDead()
  self.mCantAttack = true
  self.barBg:hide()
  local towerBg = self.towerBg_:getBone("muzhu")
  local kaozi = self.towerBg_:getBone("kaozi")
  if towerBg then
    towerBg:getDisplayManager():setVisible(false)
    kaozi:getDisplayManager():setVisible(false)
  end
  self:dispatchEvent({
    name = "GAME_ES_TOWER_BOOM"
  })
end

function TowerMonsterES:hurtEffect()
  local towerBg = self.towerBg_:getBone("muzhu")
  if not self.isInTint_ then
    self.isInTint_ = true
    local tint = cc.TintTo:create(0, 243, 83, 7)
    local tintBack = cc.TintTo:create(0, 255, 255, 255)
    local dt = cc.DelayTime:create(0.4)
    towerBg:runAction(transition.sequence({
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
    local m1 = cc.MoveBy:create(0.1, cc.p(-3, 0))
    local m2 = cc.MoveBy:create(0.1, cc.p(3, 0))
    towerBg:runAction(transition.sequence({
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
    local frames = display.newFrames("shouji%d.png", 1, 4)
    local animation = display.newAnimation(frames, 0.07)
    local sp = display.newSprite()
    sp:setAnchorPoint(cc.p(0.5, 0))
    local rect = self:getContentSize()
    local tmpScale = (rect.width / 1.4 + rect.height / 1.4) / 300
    local tmpRand = math.random(-10, 10)
    sp:setScale(tmpScale - tmpRand / 50)
    towerBg:addChild(sp, 11)
    sp:playAnimationOnce(animation, true, function()
      self.mHitEffectCount = self.mHitEffectCount - 1
    end)
  end
  if self.mHitEffectCount > 6 then
    self.mHitEffectCount = 0
  end
  self.mHitEffectCount = self.mHitEffectCount + 1
end

function TowerMonsterES:getMyBoundingBox()
  local tmpWidth = 0
  local size = cc.size(self.towerBg_:getContentSize().width * Const.Zoom0, self.towerBg_:getContentSize().height * Const.Zoom0)
  local tmpX = self:getPositionX()
  local tmpWidth = tmpX + size.width / 10
  return tmpWidth
end

return TowerMonsterES

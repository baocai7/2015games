local NIANSHOU_ID = 100
local BgWidth = 882
local BgHeight = 332
local M = {}
M = class("LayerPlaceBattle", function()
  return display.newSprite()
end)

function M:ctor(params)
  self.mType = params.type
  local tFunc = {
    nian = function()
      self:loadNianUI()
    end,
    duanwu = function()
      self:loadDuanwuUI()
    end
  }
  tFunc[self.mType]()
  self.mArmatureFiles = {}
  self:init()
  self:loadAnimationAsyn()
end

function M:loadNianUI()
  self.mBgLayer = display.newSprite("new_year/place/place_bg1.png"):addTo(self)
  self.mOutSideFrm = display.newSprite("new_year/place/outside.png"):pos(self.mBgLayer:getContentSize().width * 0.5, self.mBgLayer:getContentSize().height * 0.5):addTo(self.mBgLayer, 2)
end

function M:loadDuanwuUI()
  self.mBg1 = display.newSprite("new_year/place/duanwu_bg1.png"):addTo(self)
  local clipNode = cc.ClippingRectangleNode:create()
  clipNode:setClippingRegion(cc.rect(-441, -165, 882, 332))
  self:addChild(clipNode)
  self.mMoveBg = display.newSprite("new_year/place/duanwu_bg2.png"):pos(0, 0):addTo(clipNode)
  display.newSprite("new_year/place/duanwu_bg2.png"):pos(-441, 165):addTo(self.mMoveBg)
  self.mBgLayer = display.newSprite("new_year/place/duanwu_bg3.png"):addTo(self)
  self.mOutSideFrm = display.newSprite("new_year/place/outside.png"):addTo(self)
end

function M:init()
  GameData = require("app.game.GameData")
  GameData.reset()
  DYComponent = DYComponent or require("app.component.ComponetMgr")
  BMgrOL = BMgrOL or require("app.sprites.pvp.BattleMgrOL")
  BMgr = BMgrOL
  SpriteViewMgr = require("app.sprites.pvp.SpriteViewMgr")
  BMgrOL.init()
  GameData.BG = self.mBgLayer
  self.buddhaOnTeam = DataUtils.getBuddhaTableOnTeam()
  if self.mType == "duanwu" then
    self.mMoveSpeed = 5
    local animation = M.createAnimation("longzhou", cb)
    animation:setPosition(450, 180)
    animation:addTo(self.mBgLayer, -1)
    animation:getAnimation():playWithIndex(0)
    self.mBgLayer:setPositionY(-3)
    local move1 = cc.MoveBy:create(1, cc.p(0, 10))
    local move2 = cc.MoveBy:create(1, cc.p(0, -10))
    local SequenceAction = cc.Sequence:create(move1, move2)
    transition.execute(self.mBgLayer, cc.RepeatForever:create(SequenceAction))
    self:schedule(function()
      self.animation1 = M.createAnimation("longzhou", cb)
      self.animation1:setPosition(600, 180)
      self.animation1:addTo(self.mBgLayer, 3)
      self.animation1:setScale(1)
      self.animation1:getAnimation():playWithIndex(2)
    end, 2)
    self:schedule(function()
      self:moveBg()
    end, 0.041666666666666664)
  end
end

function M:moveBg()
  local x = self.mMoveBg:getPositionX()
  if x + self.mMoveSpeed >= 882 then
    x = 0
  else
    x = x + self.mMoveSpeed
  end
  self.mMoveBg:setPositionX(x)
end

function M:createMonsterBoss()
  local monster = BMgrOL.createMonster(GameData.BG, NIANSHOU_ID, cc.p(200, 80))
  
  function monster.mView.showDamage()
    return
  end
  
  monster.mView:setScale(2)
  monster.mView:setLocalZOrder(100)
  monster.mView:hideBlood()
  monster.mMoveAble = false
  if self.mType == "nian" then
    function monster.addBuff()
    end
  else
    monster.mInvincible = true
    monster.mView:hide()
    
    function monster.doThings()
    end
    
    monster.mState = "Died"
    self:performWithDelay(function()
      monster.mCantAttack = true
    end, 10)
  end
  self.mBoss = monster
end

function M:spwnBuddha()
  if #BMgrOL.getBuddhaList() >= 10 then
    return
  end
  local buddhaId = self.buddhaOnTeam[math.random(1, #self.buddhaOnTeam)]
  local buddha = BMgrOL.createBuddhaPlace(GameData.BG, buddhaId, cc.p(800, 80))
  buddha.skill = {}
  
  function buddha.mView.killSelf()
    buddha.mView.bloodBar:setVisible(false)
    buddha.mView.mAnimator:setVisible(false)
    buddha.mView:stopAllActions()
  end
  
  buddha.mView:hideBlood()
  
  function buddha.beatBack()
    return
  end
  
  function buddha.mView.showDamage()
    return
  end
end

function M:loadAnimationAsyn()
  local monsterModel = DataUtils.getMonsterModel(NIANSHOU_ID)
  local file = string.format("armature/%s/%s.csb", monsterModel.armatureFile, monsterModel.armatureFile)
  table.insert(self.mArmatureFiles, file)
  for i, buddhaId in pairs(self.buddhaOnTeam) do
    if buddhaId ~= "" then
      local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
      local file = string.format("armature/%s/%s.csb", buddhaModel.armatureFile, buddhaModel.armatureFile)
      table.insert(self.mArmatureFiles, file)
    end
  end
  
  local function dataLoaded(percent)
    if 1 <= percent then
      self:battleBegin()
    end
  end
  
  for i = 1, #self.mArmatureFiles do
    local file = self.mArmatureFiles[i]
    print("armature file : " .. file)
    DYRes.loadFileInfoAsync(file, GameData.S_FILE_INFO, dataLoaded)
    print("=============== load success")
  end
end

function M:battleBegin()
  self:schedule(function()
    self:spwnBuddha()
  end, 1)
  self:schedule(function()
    BMgrOL.update()
  end, 0.041666666666666664)
  self:createMonsterBoss()
end

function M:addATKBuff()
end

function M:onSpeedUp()
  self.mMoveSpeed = 30
  if not self.mSpeedUpanimation then
    self.mSpeedUpanimation = M.createAnimation("longzhou", cb)
    self.mSpeedUpanimation:setPosition(450, 165)
    self.mSpeedUpanimation:addTo(self.mBgLayer, 2)
    self.mSpeedUpanimation:getAnimation():playWithIndex(1)
  else
    self.mSpeedUpanimation:show()
  end
  self:performWithDelay(function()
    self:onSpeedEnd()
  end, 4)
end

function M:onSpeedEnd()
  self.mMoveSpeed = 5
  self.mSpeedUpanimation:hide()
end

function M.createAnimation(modelName, cb)
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb", modelName, modelName))
  local armature = ccs.Armature:create(modelName)
  
  local function animationEvent(armatureBack, movementType, movementID)
    local id = movementID
    if movementType == ccs.MovementEventType.complete then
      armature:removeFromParent()
      if cb then
        cb()
      end
    end
  end
  
  armature:getAnimation():setMovementEventCallFunc(animationEvent)
  return armature
end

return M

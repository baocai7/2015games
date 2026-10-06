local M = {}
M = class("PanelTeam", function()
  return display.newNode()
end)

function M:ctor(buddhaModel_, handler_)
  self:initData(buddhaModel_, handler_)
  self:initUI()
end

function M:initData(buddhaModel_, handler_)
  self.mBuddhaModel = buddhaModel_
  self.mCallback = handler_
  self.mIdx = 0
  self.mIsReady = false
  self.mIsInCD = false
  self.mIsAuto = false
  GameData.IS_BUDDHA_LIMIT = false
end

function M:initUI()
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):addTo(self)
  self.mAutoBar = display.newSprite("gamescene/auto.png"):pos(iconFrame:getContentSize().width * 0.5, -10):hide():addTo(iconFrame, -1)
  local filePath = string.format("armature/%s/%s.csb", "juesekuangtexiao", "juesekuangtexiao")
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  self.armature = ccs.Armature:create("juesekuangtexiao"):addTo(self, 3)
  self.armature:setPosition(10, 10)
  self.armature:hide()
  self.armature:setScale(2)
  iconFrame:setTouchEnabled(true)
  iconFrame:setTouchSwallowEnabled(true)
  iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      self.x_ = x
      self.y_ = y
      return true
    end
    local touchInSprite = cc.rectContainsPoint(iconFrame:getCascadeBoundingBox(), cc.p(x, y))
    if name == "moved" then
      local offsetY = y - self.y_
      self:changeAutoMode(offsetY)
    elseif name == "ended" and touchInSprite then
      self:onPressed()
    end
  end)
  local icon = display.newSprite(self.mBuddhaModel.npcIcon):addTo(self)
  if 0 == self.mBuddhaModel.isRebel then
    icon:setScaleX(-1)
  end
  self.mShadow = display.newSprite("gamescene/buddha_shadow.png"):hide():addTo(self, 2)
  self.mSpiritFrame = display.newSprite("gamescene/spirit_icon.png", 0, 0):addTo(self, 2)
  local spiritNum = self.mBuddhaModel.consume
  self.spiritCostLabel_ = cc.ui.UILabel.new({
    UILabelType = 2,
    text = spiritNum,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mSpiritFrame:getContentSize().width * 0.55, self.mSpiritFrame:getContentSize().height * 0.16):addTo(self.mSpiritFrame)
  self.mSchedule = self:schedule(function()
    self:updateSpirit()
  end, 0.02)
end

function M:changeAutoMode(offsetY)
  if 50 < offsetY and not self.mIsAuto then
    self.mIsAuto = true
    self.mAutoBar:setVisible(true)
    self:runAction(cc.MoveBy:create(0.3, cc.p(0, 30)))
  end
  if offsetY < -50 and self.mIsAuto then
    self.mIsAuto = false
    self.mAutoBar:setVisible(false)
    self:runAction(cc.MoveBy:create(0.3, cc.p(0, -30)))
  end
end

function M:updateSpirit()
  local currentSpirit = GameData.getCurrentSpirit()
  if not self.mIsInCD and currentSpirit >= self.mBuddhaModel.consume then
    self.mShadow:setVisible(false)
    self.mIsReady = true
    if self.mIsAuto then
      self:performWithDelay(function()
        self:onPressed()
      end, 0.2)
    end
  else
    self.mShadow:setVisible(true)
    self.mIsReady = false
  end
end

function M:onPressed()
  if not self.mIsReady or GameData.IS_ON_CREATING_BUDDHA or GameData.IS_BUDDHA_LIMIT then
    return
  end
  GameData.IS_ON_CREATING_BUDDHA = true
  DYSoundMgr.playEffect(DY_SND.sfx_buddha_makeup)
  local currentSpirit = GameData.getCurrentSpirit()
  currentSpirit = currentSpirit - self.mBuddhaModel.consume
  GameData.setCurrentSpirit(currentSpirit)
  if 0 == GameManager.MODE and 0 == GameManager.STAGE_NUM then
    BMgr.createDemoBuddha(self.mBuddhaModel.npcId)
  else
    BMgr.createBuddha(GameData.BG, self.mBuddhaModel.npcId, nil, 1)
  end
  self:pressEffect()
  self:cooldown()
end

function M:pressEffect()
  self.armature:show()
  self.armature:getAnimation():playWithIndex(0)
  self.armature:getAnimation():setSpeedScale(1)
end

function M:cooldown()
  self.mIsReady = false
  self.mIsInCD = true
  self:performWithDelay(function()
    GameData.IS_ON_CREATING_BUDDHA = false
  end, 0.2)
  self.mShadow:setVisible(true)
  self.mSpiritFrame:setVisible(false)
  self.mProgressTimer = display.newProgressTimer("gamescene/bar_green.png", display.PROGRESS_TIMER_BAR):pos(0, -40):addTo(self, 2)
  self.mProgressTimer:setMidpoint(cc.p(0, 0))
  self.mProgressTimer:setBarChangeRate(cc.p(1, 0))
  self.mProgressTimer:setPercentage(0)
  local realCDTime = self.mBuddhaModel.cdTime or 30
  local progressTo = cc.ProgressTo:create(realCDTime, 100)
  transition.execute(self.mProgressTimer, progressTo, {
    onComplete = function()
      self:removeProTimer()
    end
  })
end

function M:removeProTimer()
  DYSoundMgr.playEffect(DY_SND.sfx_buddha_cooldown)
  if self.mProgressTimer ~= nil then
    self.mProgressTimer:removeFromParent()
    self.mProgressTimer = nil
  end
  self.mSpiritFrame:setVisible(true)
  self.mIsInCD = false
end

local function fingerEffect()
  local guideFinger = display.newNode()
  local finger = display.newSprite("novice_guide/finger.png"):addTo(guideFinger)
  finger:setScale(0.8)
  finger:setPosition(50, -50)
  local moveBy1 = cc.MoveBy:create(0.5, cc.p(-20, 20))
  local moveBy2 = cc.MoveBy:create(0.5, cc.p(20, -20))
  local seq1 = transition.sequence({moveBy1, moveBy2})
  finger:runAction(cc.RepeatForever:create(seq1))
  return guideFinger
end

function M:addFingerEffect()
  if not self.mFinger then
    self.mFinger = fingerEffect():addTo(self, 4)
  end
end

function M:removeFingerEffect()
  if self.mFinger then
    self.mFinger:removeFromParent()
    self.mFinger = nil
  end
end

function M:pauseEx()
  if self.mProgressTimer then
    self.mProgressTimer:pause()
  end
  self:pause()
end

function M:resumeEx()
  if self.mProgressTimer then
    self.mProgressTimer:resume()
  end
  self:resume()
end

return M

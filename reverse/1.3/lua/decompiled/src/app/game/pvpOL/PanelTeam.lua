local TAG_SOCKET_EVENT = 10001
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
  self.mCountCD = self.mBuddhaModel.cdTime or 30
  self.mCurrCDTime = 0
  self.mIdx = 0
  self.mIsReady = false
  self.mIsInCD = false
  self.mIsAuto = false
  self.mIsCanBeClicked = true
  self.mCount = 0
  GameData.IS_BUDDHA_LIMIT = false
end

function M:initUI()
  local filePath = string.format("armature/%s/%s.csb", "juesekuangtexiao", "juesekuangtexiao")
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  self.armature = ccs.Armature:create("juesekuangtexiao"):addTo(self, 3)
  self.armature:setPosition(10, 10)
  self.armature:hide()
  self.armature:setScale(2)
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):addTo(self)
  self.mAutoBar = display.newSprite("gamescene/auto.png"):pos(iconFrame:getContentSize().width * 0.5, -10):hide():addTo(iconFrame, -1)
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

function M:pressEffect()
  self.armature:show()
  self.armature:getAnimation():playWithIndex(0)
  self.armature:getAnimation():setSpeedScale(2)
end

function M:updateSpirit()
  self.mCount = self.mCount + 1
  if 3 == self.mCount then
    self.mCount = 0
    local currentSpirit = GameData.getCurrentSpirit()
    if not self.mIsInCD and currentSpirit >= self.mBuddhaModel.consume then
      self.mShadow:setVisible(false)
      self.mIsReady = true
      if self.mIsAuto then
        self:performWithDelay(function()
          self:onPressed()
        end, 0.1)
      end
    else
      self.mShadow:setVisible(true)
      self.mIsReady = false
    end
  end
end

function M:onPressed()
  if not (self.mIsCanBeClicked and self.mIsReady) or GameData.IS_ON_CREATING_BUDDHA or GameData.IS_BUDDHA_LIMIT then
    return
  end
  self:pressEffect()
  GameData.IS_ON_CREATING_BUDDHA = true
  self.mIsCanBeClicked = false
  self.mCallback({
    buddha_id = self.mBuddhaModel.npcId
  })
end

function M:createBuddha(buddhaId)
  DYSoundMgr.playEffect(DY_SND.sfx_buddha_makeup)
  local currentSpirit = GameData.getCurrentSpirit()
  currentSpirit = currentSpirit - self.mBuddhaModel.consume
  GameData.setCurrentSpirit(currentSpirit)
  BMgrOL.createPVPBuddha(buddhaId)
  self:cooldown()
end

function M:cooldown()
  self.mIsInCD = true
  self.mIsReady = false
  self:performWithDelay(function()
    GameData.IS_ON_CREATING_BUDDHA = false
  end, 0.2)
  self.mIsCanBeClicked = true
  self.mShadow:setVisible(true)
  self.mSpiritFrame:setVisible(false)
  self.mProgressTimer = display.newProgressTimer("gamescene/bar_green.png", display.PROGRESS_TIMER_BAR):pos(0, -40):addTo(self, 2)
  self.mProgressTimer:setMidpoint(cc.p(0, 0))
  self.mProgressTimer:setBarChangeRate(cc.p(1, 0))
  self.mProgressTimer:setPercentage(0)
end

function M:updateTeamPro()
  if not self.mIsInCD then
    return
  end
  self.mCurrCDTime = self.mCurrCDTime + 1 / GameData.FRAME_PER_SECOND
  self.mProgressTimer:setPercentage(self.mCurrCDTime / self.mCountCD * 100)
  if self.mCurrCDTime >= self.mCountCD then
    self:removeProTimer()
  end
end

function M:removeProTimer()
  DYSoundMgr.playEffect(DY_SND.sfx_buddha_cooldown)
  if self.mProgressTimer ~= nil then
    self.mProgressTimer:removeFromParent()
    self.mProgressTimer = nil
  end
  self.mSpiritFrame:setVisible(true)
  self.mIsInCD = false
  self.mCurrCDTime = 0
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

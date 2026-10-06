local M = {}
M = class("GridIcon", function()
  return display.newNode()
end)
M.MAIN_GRID = 1
M.ASSIST_GRID = 2

function M:ctor(idx_, type_)
  self:initData(idx_, type_)
  self:initUI()
  self:setTouchEnabled(true)
end

function M:initData(idx_, type_)
  local girdInfo = DYCommon.getDataByTag(DataRetainer.TEAM_GRID_INFO, "id", tostring(idx_))[1]
  if not girdInfo then
    DDERROR("team gird id : %d with error data", tonumber(idx_))
  end
  self.mType = type_
  if M.MAIN_GRID == type_ then
    self.mUnlockLevel = tonumber(girdInfo.mainTeamLevel)
  elseif M.ASSIST_GRID == type_ then
    self.mUnlockLevel = tonumber(girdInfo.assistTeamLevel)
  end
  self.mIsBuddhaOn = false
  self.mIsUnlock = true
end

function M:initUI()
  self.mFrame = display.newSprite("team/grid_frame.png"):addTo(self)
  if CloudData.USER_LEVEL < self.mUnlockLevel then
    self.mFrame:setTexture("team/grid_frame1.png")
    local lb = cc.ui.UILabel.new({
      text = string.format("%d\231\186\167\232\167\163\233\148\129", self.mUnlockLevel),
      size = 22,
      color = cc.c3b(112, 255, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.3):addTo(self.mFrame)
    self.mIsUnlock = false
  end
end

function M:setBuddhaOn(isHaveBuddha)
  self.mIsBuddhaOn = isHaveBuddha
end

function M:getBuddhaOn()
  return self.mIsBuddhaOn
end

function M:addBuddhaPic(buddhaId)
  if self.mBuddhaPic then
    self:removeBuddhaPic()
  end
  local buddhaModel = DataUtils.getBuddhaModel(buddhaId)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality)):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.55):addTo(self.mFrame)
  local icon = display.newSprite(buddhaModel.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 == buddhaModel.isRebel then
    icon:setScaleX(-1)
  end
  local starPic = display.newSprite(string.format("upgrade/star%d.png", buddhaModel.starLevel)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.95):addTo(iconFrame)
  self.mBuddhaPic = iconFrame
  self.mBuddhaId = buddhaModel.npcId
  if M.MAIN_GRID == self.mType then
    local activeNum = DataUtils.getFateActiveNum(buddhaModel.npcId)
    for i = 1, activeNum do
      display.newSprite("team/fate_icon.png"):pos(10 * i, 10):addTo(iconFrame)
    end
  end
end

function M:removeBuddhaPic()
  if self.mBuddhaPic then
    self.mBuddhaPic:removeFromParent()
    self.mBuddhaPic = nil
  end
  self.mBuddhaId = nil
  self.mIsBuddhaOn = false
end

function M:getMyBoundingBox()
  local point = cc.p(self:getPositionX(), self:getPositionY())
  local worldpoint = self:getParent():convertToWorldSpace(point)
  local rect = cc.rect(worldpoint.x - self.mFrame:getContentSize().width * 0.5, worldpoint.y - self.mFrame:getContentSize().height * 0.5, self.mFrame:getContentSize().width, self.mFrame:getContentSize().height)
  return rect
end

return M

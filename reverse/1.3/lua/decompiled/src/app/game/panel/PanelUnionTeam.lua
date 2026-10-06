local M = {}
M = class("PanelUnionTeam", function()
  return display.newNode()
end)

function M:ctor(handler_)
  self.mEventList = {}
  self.mCallback = handler_
  self:initData()
  self:initUI()
  self:initEventList()
end

function M:initData()
  self.mBuddhaTeam = {}
  self.mBuddhaNum = {}
  self.mEnemyTeam = {}
  self.mEnemyNum = {}
  self.mAllyName = CloudData.ALLY_INFO.userName
  self.mEnemyName = CloudData.ENEMY_INFO.userName
  self.mNpcCountNum = 0
  self.mCurrNpcNum = 0
  for k, v in pairs(CloudData.UNINO_BUDDHA_CUR_TEAM) do
    table.insert(self.mBuddhaTeam, tonumber(k))
    table.insert(self.mBuddhaNum, tonumber(v))
    self.mNpcCountNum = self.mNpcCountNum + v
  end
  for k, v in pairs(CloudData.UNINO_ENEMY_CUR_TEAM) do
    table.insert(self.mEnemyTeam, tonumber(k))
    table.insert(self.mEnemyNum, tonumber(v))
    self.mNpcCountNum = self.mNpcCountNum + v
  end
end

function M:initUI()
  self.mFrame = display.newScale9Sprite("gamescene/team_frame.png", 0, 0, cc.size(1280, 95), cc.rect(50, 30, 2, 2)):align(display.CENTER_BOTTOM, 0, 0):addTo(self)
  local nameFrame = display.newSprite("gamescene/name_label.png"):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height - 20):addTo(self.mFrame)
  cc.ui.UILabel.new({
    text = self.mAllyName,
    size = 20,
    color = cc.c3b(56, 254, 30),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, nameFrame:getContentSize().width * 0.5 + 60, nameFrame:getContentSize().height * 0.84):addTo(nameFrame)
  cc.ui.UILabel.new({
    text = self.mEnemyName,
    size = 20,
    color = cc.c3b(255, 0, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, nameFrame:getContentSize().width * 0.5 - 60, nameFrame:getContentSize().height * 0.85):addTo(nameFrame)
  for i = 1, #self.mBuddhaTeam do
    local icon = self:initIcon("buddha", self.mBuddhaTeam[i], self.mBuddhaNum[i])
    icon:setPosition(self.mFrame:getContentSize().width * 0.5 + 45 + 80 * (i - 1), self.mFrame:getContentSize().height * 0.5)
    table.insert(GameData.TEAM_ICON, icon)
  end
  for i = 1, #self.mEnemyTeam do
    local icon = self:initIcon("enemy", self.mEnemyTeam[i], self.mEnemyNum[i])
    icon:setPosition(self.mFrame:getContentSize().width * 0.5 - 45 - 80 * (i - 1), self.mFrame:getContentSize().height * 0.5)
    table.insert(GameData.TEAM_ICON, icon)
  end
end

function M:initIcon(iconType, buddhaId, buddhaNum)
  local buddhaModel
  if "buddha" == iconType then
    buddhaModel = DataUtils.getModelForPVPOnline("buddha", buddhaId)
  else
    buddhaModel = DataUtils.getModelForPVPOnline("enemy", buddhaId)
  end
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):scale(0.6779661016949152):addTo(self.mFrame)
  if "buddha" == iconType then
    iconFrame:setAnchorPoint(0, 0.5)
  else
    iconFrame:setAnchorPoint(1, 0.5)
  end
  iconFrame.buddhaId = buddhaId
  iconFrame.iconType = iconType
  iconFrame.buddhaNum = buddhaNum
  local icon = display.newSprite(buddhaModel.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if "buddha" == iconType and 0 == buddhaModel.isRebel then
    icon:setScaleX(-1)
  elseif "enemy" == iconType and 1 == buddhaModel.isRebel then
    icon:setScaleX(-1)
  end
  iconFrame.numLabel = cc.ui.UILabel.new({
    text = buddhaNum,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, iconFrame:getContentSize().width * 0.5, 0):addTo(iconFrame, 2)
  iconFrame.shadowPic = display.newSprite("gamescene/buddha_shadow.png"):hide():pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame, 1)
  iconFrame.isOK = false
  iconFrame.spiritNum = buddhaModel.consume
  iconFrame.currCDTime = 0
  iconFrame.realCDTime = buddhaModel.cdTime
  iconFrame.mProgressTimer = display.newProgressTimer("gamescene/bar_green.png", display.PROGRESS_TIMER_BAR):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.12):addTo(iconFrame, 2)
  iconFrame.mProgressTimer:setMidpoint(cc.p(0, 0))
  iconFrame.mProgressTimer:setBarChangeRate(cc.p(1, 0))
  iconFrame.mProgressTimer:setPercentage(0)
  return iconFrame
end

function M:initEventList()
  self.mCurTick = 0
  for i = 1, #GameData.TEAM_ICON do
    local aTeamMember = GameData.TEAM_ICON[i]
    local actorType = aTeamMember.iconType
    for k = 1, aTeamMember.buddhaNum do
      local tick = math.floor(((k - 1) * 0.5 + aTeamMember.realCDTime) * GameData.FRAME_PER_SECOND)
      self.mEventList[tick] = self.mEventList[tick] or {}
      table.insert(self.mEventList[tick], aTeamMember)
    end
  end
end

function M:updateTeamPro(target)
  if target.isOK then
    return
  end
  target.currCDTime = target.currCDTime + 1 / GameData.FRAME_PER_SECOND
  target.mProgressTimer:setPercentage(target.currCDTime / target.realCDTime * 100)
  if target.currCDTime >= target.realCDTime then
    self:removeProTimer(target)
  end
end

function M:removeProTimer(tar)
  DYSoundMgr.playEffect(DY_SND.sfx_buddha_cooldown)
  local iconFrame = tar
  if iconFrame.mProgressTimer ~= nil then
    iconFrame.mProgressTimer:removeFromParent()
    iconFrame.mProgressTimer = nil
  end
  iconFrame.isOK = true
  iconFrame.shadowPic:show()
  iconFrame.numLabel:setString(0)
  local costSpirit = iconFrame.spiritNum * iconFrame.buddhaNum
  if "buddha" == iconFrame.iconType then
  else
  end
  if self.mCallback then
    self.mCallback(iconFrame.iconType)
  end
end

function M:update()
  self.mCurTick = self.mCurTick + 1
  if self.mEventList[self.mCurTick] then
    for _, v in pairs(self.mEventList[self.mCurTick]) do
      if v.iconType == "buddha" then
        BMgrOL.createPVPBuddha(v.buddhaId, cc.p(1140, 10))
      else
        BMgrOL.createPVPMonster(v.buddhaId, cc.p(140, 10))
      end
      self.mCurrNpcNum = self.mCurrNpcNum + 1
    end
  end
  for i = 1, #GameData.TEAM_ICON do
    local icon = GameData.TEAM_ICON[i]
    self:updateTeamPro(icon)
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

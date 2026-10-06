local TeamIcon = require("app.icons.TeamIcon")
local GridIcon = require("app.icons.GridIcon")
local TeamFateIcon = require("app.icons.TeamFateIcon")
local M = {}
M = class("LayerTeamAssist", function()
  return display.newLayer()
end)

function M:ctor(teamType, handler_)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mCallback = handler_
  self:initData(teamType)
  self:initUI()
end

local function toarray(tb)
  local tempTable = {}
  for k, v in pairs(tb) do
    if v then
      tempTable[#tempTable + 1] = v
    end
  end
  return tempTable
end

local function getBuddhaModel(teamInfo)
  local buddhaIds = {}
  for i = 1, #teamInfo do
    local tb = DataUtils.getBuddhaIdForFate(teamInfo[i])
    table.insertto(buddhaIds, tb)
  end
  buddhaIds = table.unique(buddhaIds)
  buddhaIds = toarray(buddhaIds)
  for i = 1, #teamInfo do
    local index = table.indexof(buddhaIds, teamInfo[i])
    if index then
      table.removebyvalue(buddhaIds, teamInfo[i], true)
    end
  end
  local buddhaModelTable = {}
  for k, v in pairs(buddhaIds) do
    local buddhaModel = DataUtils.getBuddhaModel(v)
    if 0 ~= buddhaModel.buddhaState then
      table.insert(buddhaModelTable, buddhaModel)
    end
  end
  return buddhaModelTable
end

function M:initData(teamType)
  self.mTeamType = teamType or 1
  self.mMainTeam = DataUtils.getBuddhaTableOnTeam()
  self.mAssistTeam = DataUtils.getBuddhaTableOnAssist()
  self.mBuddhaModelTable = getBuddhaModel(self.mMainTeam)
  self.mTeamIconTable = {}
  self.mGridIconTable = {}
  self.mBuddhaOnAssist = {}
  self.mFateIconTable = {}
  self.mUnlockGridNum = 0
  self.mTabIconTable = {}
  self.mTabTag = 1
end

function M:initUI()
  self.mBg = display.newSprite("team/assist_bg.png", 0, 75):addTo(self.mNode)
  self:initBuddhaList(self.mBuddhaModelTable)
  self:initFateList()
  self:initTeamPanel()
  self:buddhaCEShow()
  self:initTeamInfo()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:confirmAssistInfo()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.97, self.mBg:getContentSize().height * 0.95):addTo(self.mBg, 2)
end

function M:initBuddhaList(tb)
  local listBg = display.newScale9Sprite("common_ui/dialog_bg.png", 0, 0, cc.size(500, 485), cc.rect(50, 50, 5, 5)):opacity(0):pos(self.mBg:getContentSize().width * 0.71, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  if 0 == #tb then
    return
  end
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(10, 10, 480, 465),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(listBg)
  local tb_count = #tb
  local totalNum = tb_count < 16 and 16 or tb_count
  local row = math.ceil(totalNum / 4)
  local endNum = 4
  for i = 1, row do
    local item = listView:newItem()
    local content = display.newNode()
    for count = 1, endNum do
      local buddhaModel = tb[(i - 1) * 4 + count]
      local teamIcon
      if buddhaModel then
        teamIcon = TeamIcon.new(TeamIcon.TYPE_ASSIST, buddhaModel)
        table.insert(self.mTeamIconTable, teamIcon)
      else
        teamIcon = TeamIcon.new(TeamIcon.TYPE_ASSIST)
      end
      teamIcon:setPosition(120 * count - 60, 63)
      content:addChild(teamIcon)
    end
    content:setContentSize(480, 126)
    item:addContent(content)
    item:setItemSize(480, 126)
    listView:addItem(item)
  end
  listView:reload()
end

function M:initFateList()
  local listBg = display.newScale9Sprite("common_ui/dialog_bg.png", 0, 0, cc.size(420, 485), cc.rect(50, 50, 5, 5)):opacity(0):pos(self.mBg:getContentSize().width * 0.25, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(10, 10, 400, 465),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener1)):addTo(listBg)
  for i = 1, #self.mMainTeam do
    local item = self.mListView:newItem()
    local icon = TeamFateIcon.new(self.mMainTeam[i])
    local content = icon
    item:addContent(content)
    item:setItemSize(400, icon.mHeight + 20)
    table.insert(self.mFateIconTable, icon)
    self.mListView:addItem(item)
  end
  self.mListView:reload()
end

function M:initTeamPanel()
  local panel = display.newSprite("team/team_panel.png"):align(display.CENTER_TOP, self.mBg:getContentSize().width * 0.44, -self.mBg:getContentSize().height * 0.02):addTo(self.mBg)
  for i = 1, 6 do
    local icon = GridIcon.new(i, GridIcon.ASSIST_GRID):pos(panel:getContentSize().width * (0.16 * i - 0.06), panel:getContentSize().height * 0.5):addTo(panel)
    if icon.mIsUnlock then
      self.mUnlockGridNum = self.mUnlockGridNum + 1
    end
    icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onTouchGrid(event.name, event.x, event.y, i)
    end)
    table.insert(self.mGridIconTable, icon)
  end
end

function M:buddhaCEShow()
  local sum = 0
  for k, v in pairs(self.mMainTeam) do
    local buddhaModel = DataUtils.getBuddhaModel(v)
    sum = sum + buddhaModel.attackAssessment
  end
  local frame = display.newSprite("team/ce_frame.png"):align(display.CENTER_TOP, self.mBg:getContentSize().width * 0.94, -self.mBg:getContentSize().height * 0.01):addTo(self.mBg, 1)
  self.mCELabel = cc.ui.UILabel.new({
    text = sum,
    size = 30,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.3):addTo(frame)
end

function M:initTeamInfo()
  for k, v in pairs(self.mAssistTeam) do
    local buddhaId = tonumber(v)
    local gridIcon = self.mGridIconTable[k]
    gridIcon:addBuddhaPic(buddhaId)
    gridIcon:setBuddhaOn(true)
    for i = 1, #self.mTeamIconTable do
      local teamIcon = self.mTeamIconTable[i]
      if teamIcon.mBuddhaId == buddhaId and not teamIcon.mInTask then
        teamIcon:setOnTeam(true)
        table.insert(self.mBuddhaOnAssist, teamIcon)
      end
    end
  end
end

function M:updateTeam()
  if 1 == self.mTeamType then
    DataUtils.setBuddhaTableOnAssist(self.mAssistTeam)
  elseif 2 == self.mTeamType then
    DataUtils.setBuddhaTableOnAssist(self.mAssistTeam, 3)
  end
  for i = 1, self.mUnlockGridNum do
    local gridIcon = self.mGridIconTable[i]
    if gridIcon:getBuddhaOn() then
      gridIcon:removeBuddhaPic()
    end
  end
  for k, v in pairs(self.mAssistTeam) do
    local buddhaId = tonumber(v)
    local gridIcon = self.mGridIconTable[k]
    gridIcon:addBuddhaPic(buddhaId)
    gridIcon:setBuddhaOn(true)
  end
  for i = 1, #self.mFateIconTable do
    local icon = self.mFateIconTable[i]
    icon:updateUI()
  end
  self:updateCE()
end

function M:updateCE()
  local sum = 0
  for k, v in pairs(self.mMainTeam) do
    local buddhaModel = DataUtils.getBuddhaModel(v)
    sum = sum + buddhaModel.attackAssessment
  end
  self.mCELabel:setString(sum)
end

function M:putBuddhaOnTeam(idx)
  local teamIcon = self.mTeamIconTable[idx]
  if teamIcon.mIsOnTeam or teamIcon.mInTask then
    return
  end
  if self.mSound then
    DYSoundMgr.stopEffect(self.mSound)
  end
  self.mSound = DYSoundMgr.playEffect(teamIcon.mBuddhaModel.buddhaSound)
  for i = 1, self.mUnlockGridNum do
    local gridIcon = self.mGridIconTable[i]
    if not gridIcon.mIsBuddhaOn then
      teamIcon:iconClicked()
      teamIcon:setOnTeam(true)
      table.insert(self.mBuddhaOnAssist, teamIcon)
      table.insert(self.mAssistTeam, tostring(teamIcon.mBuddhaId))
      self:updateTeam()
      return
    end
  end
end

function M:putBuddhaDownTeam(idx)
  local gridIcon = self.mGridIconTable[idx]
  if not gridIcon.mIsBuddhaOn or not gridIcon.mBuddhaId then
    return
  end
  table.removebyvalue(self.mAssistTeam, tostring(gridIcon.mBuddhaId), true)
  for i = 1, #self.mBuddhaOnAssist do
    local teamIcon = self.mBuddhaOnAssist[i]
    if teamIcon.mBuddhaId == gridIcon.mBuddhaId then
      teamIcon:setOnTeam(false)
      table.removebyvalue(self.mBuddhaOnAssist, teamIcon, true)
      break
    end
  end
  self:updateTeam()
end

function M:touchListener(event)
  if "clicked" == event.name then
    local column = math.ceil(event.point.x / 120)
    local idx = (event.itemPos - 1) * 4 + column
    DDLOG("idx : %d", idx)
    if idx > #self.mTeamIconTable then
      return
    end
    self:putBuddhaOnTeam(idx)
  elseif "began" == event.name then
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:touchListener1(event)
  local lv = event.listView
  if "clicked" == event.name then
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  elseif "began" == event.name then
  end
end

function M:onTouchGrid(name, x, y, tag)
  if name == "began" then
    self:putBuddhaDownTeam(tag)
    return true
  end
  if name == "ended" then
  end
end

function M:confirmAssistInfo()
  if 1 == self.mTeamType then
    DataUtils.setBuddhaTableOnAssist(self.mAssistTeam)
  elseif 2 == self.mTeamType then
    DataUtils.setBuddhaTableOnAssist(self.mAssistTeam, 3)
  end
  self:performWithDelay(function()
    if self.closeCallBack then
      self:closeCallBack()
    end
  end, 0)
end

function M:closeCallBack()
  if self.mSound then
    DYSoundMgr.stopEffect(self.mSound)
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      if self.mCallback then
        self.mCallback()
      end
      self:removeSelf()
    end)
  })
  self.mNode:runAction(popupLayer)
end

return M

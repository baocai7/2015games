local TeamIcon = require("app.icons.TeamIcon")
local GridIcon = require("app.icons.GridIcon")
local WSToast = require("app.utils.WSToast")
local LayerTeamAssist = require("app.layers.LayerTeamAssist")
local LayerTeamStar = require("app.layers.LayerTeamStar")
local NoviceGuide = require("app.utils.NoviceGuide")
local M = {}
M = class("LayerTeam", function()
  return display.newLayer()
end)
M.TEAM_NORMAL = 1
M.TEAM_PURGATORY = 2

function M:ctor(type_, cb)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.cb = cb
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:initData(type_)
  self:initUI()
  self:dealUserGuide()
  self:setNodeEventEnabled(true)
end

local function getTeamInfo(teamInfo)
  for i = 1, #teamInfo do
    for j = 1, #teamInfo - 1 do
      local value1 = DataUtils.getBuddhaCostValue(teamInfo[j])
      local value2 = DataUtils.getBuddhaCostValue(teamInfo[j + 1])
      if value1 > value2 then
        teamInfo[j], teamInfo[j + 1] = teamInfo[j + 1], teamInfo[j]
      end
    end
  end
  return teamInfo
end

function M:createBuddhaList()
  self.mBuddhaModelTable = {
    {},
    {},
    {},
    {}
  }
  local buddhaIds = DataUtils.getBuddhaIdsTableTeamScene()
  for k, v in pairs(buddhaIds) do
    local buddhaModel = DataUtils.getBuddhaModel(v)
    table.insert(self.mBuddhaModelTable[1], buddhaModel)
    for i = 1, 3 do
      if i == buddhaModel.buddhaType then
        table.insert(self.mBuddhaModelTable[i + 1], buddhaModel)
      end
    end
  end
end

function M:initData(type_)
  self.mTeamType = type_ or M.TEAM_NORMAL
  self:createBuddhaList()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  if stageProgress == 1 and DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE1_UPGRADELAY") and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE1_TEAMLAY") then
    local buddhaModel1 = self.mBuddhaModelTable[1][1]
    for i = 1, #self.mBuddhaModelTable[1] do
      local buddhaModel = self.mBuddhaModelTable[1][i]
      if 1002 == buddhaModel.npcId then
        self.mBuddhaModelTable[1][i] = buddhaModel1
        self.mBuddhaModelTable[1][1] = buddhaModel
      end
    end
  end
  if stageProgress == 5 then
    local buddhaModel1 = self.mBuddhaModelTable[1][1]
    for i = 1, #self.mBuddhaModelTable[1] do
      local buddhaModel = self.mBuddhaModelTable[1][i]
      if 1005 == buddhaModel.npcId then
        self.mBuddhaModelTable[1][i] = buddhaModel1
        self.mBuddhaModelTable[1][1] = buddhaModel
      end
    end
  end
  self.mTeamInfo = DataUtils.getBuddhaTableOnTeam()
  self.mAssistTeam = DataUtils.getBuddhaTableOnAssist()
  self.mHurtBuddhaNum = 0
  if M.TEAM_PURGATORY == self.mTeamType then
    for k, v in pairs(self.mBuddhaModelTable[1]) do
      if 2 == v.buddhaState then
        self.mHurtBuddhaNum = self.mHurtBuddhaNum + 1
      end
    end
  end
  self.mTeamIconTable = {}
  self.mGridIconTable = {}
  self.mBuddhaOnTeam = {}
  self.mFreshingTeam = true
  self.mUnlockGridNum = 0
  self.mTabIconTable = {}
  self.mTabTag = 1
end

function M:initUI()
  self.mBg = display.newSprite("team/bg.png", 40, 70):addTo(self.mNode)
  self:initTabBtn()
  self:initBuddhaList(self.mBuddhaModelTable[1])
  self:initTeamPanel()
  self:buddhaCEShow()
  self:teamStarFate()
  self:initAssistTeam()
  self:addHurtBuddhaInfo()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:confirmTeamInfo(handler(self, self.closeCallBack))
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.95, self.mBg:getContentSize().height * 0.95):addTo(self.mBg, 2)
end

function M:initTabBtn()
  local btnImgTable = {
    {
      normal = "team/btn_all2.png",
      pressed = "team/btn_all2.png",
      disabled = "team/btn_all1.png"
    },
    {
      normal = "team/btn_front2.png",
      pressed = "team/btn_front2.png",
      disabled = "team/btn_front1.png"
    },
    {
      normal = "team/btn_mid2.png",
      pressed = "team/btn_mid2.png",
      disabled = "team/btn_mid1.png"
    },
    {
      normal = "team/btn_back2.png",
      pressed = "team/btn_back2.png",
      disabled = "team/btn_back1.png"
    }
  }
  for i = 1, #btnImgTable do
    local btn = cc.ui.UIPushButton.new(btnImgTable[i]):align(display.CENTER_LEFT, -90, self.mBg:getContentSize().height * (1 - i * 0.15)):onButtonClicked(function()
      self:funcChange(i)
    end):addTo(self.mBg)
    table.insert(self.mTabIconTable, btn)
    if 1 == i then
      btn:setButtonEnabled(false)
    end
  end
end

function M:initBuddhaList(tb)
  if 0 == #tb then
    return
  end
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(70, 110, 850, 420),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener1)):addTo(self.mBg)
  local totalNum = #tb
  local row = math.ceil(totalNum / 5)
  local column = totalNum % 5
  local endNum = 5
  local idx = 1
  
  local function tFuncAddItem()
    if idx <= row then
      if idx == row and column ~= 0 then
        endNum = column
      end
      local item = self.mListView:newItem()
      local content = display.newNode()
      for count = 1, endNum do
        local buddhaModel = tb[(idx - 1) * 5 + count]
        local teamIcon = TeamIcon.new(TeamIcon.TYPE_MAIN, buddhaModel)
        teamIcon:setPosition(170 * count - 85, 95)
        content:addChild(teamIcon)
        local index = table.indexof(self.mAssistTeam, tostring(teamIcon.mBuddhaId))
        if index then
          teamIcon:setOnAssist(true)
        else
          teamIcon:setOnAssist(false)
        end
        if M.TEAM_PURGATORY == self.mTeamType and 2 == buddhaModel.buddhaState then
          teamIcon:setHurtState(true)
        end
        table.insert(self.mTeamIconTable, teamIcon)
      end
      content:setContentSize(850, 190)
      item:addContent(content)
      item:setItemSize(850, 190)
      self.mListView:addItem(item)
    end
    self.mListView:reload()
    if idx < row then
      idx = idx + 1
      self:performWithDelay(tFuncAddItem, 0)
    else
      self:initTeamInfo()
    end
  end
  
  self:performWithDelay(tFuncAddItem, 0)
end

function M:initBuddhaList2(tb)
  if 0 == #tb then
    return
  end
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(70, 110, 850, 420),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener1)):addTo(self.mBg)
  local totalNum = #tb
  local row = math.ceil(totalNum / 5)
  local column = totalNum % 5
  local endNum = 5
  for i = 1, row do
    if i == row and column ~= 0 then
      endNum = column
    end
    local item = self.mListView:newItem()
    local content = display.newNode()
    for count = 1, endNum do
      local buddhaModel = tb[(i - 1) * 5 + count]
      local teamIcon = TeamIcon.new(TeamIcon.TYPE_MAIN, buddhaModel)
      teamIcon:setPosition(170 * count - 85, 95)
      content:addChild(teamIcon)
      local index = table.indexof(self.mAssistTeam, tostring(teamIcon.mBuddhaId))
      if index then
        teamIcon:setOnAssist(true)
      else
        teamIcon:setOnAssist(false)
      end
      if M.TEAM_PURGATORY == self.mTeamType and 2 == buddhaModel.buddhaState then
        teamIcon:setHurtState(true)
      end
      table.insert(self.mTeamIconTable, teamIcon)
    end
    content:setContentSize(850, 190)
    item:addContent(content)
    item:setItemSize(850, 190)
    self.mListView:addItem(item)
  end
  self.mListView:reload()
end

function M:initTeamPanel()
  local panel = display.newSprite("team/team_panel.png"):align(display.CENTER_TOP, self.mBg:getContentSize().width * 0.4, -self.mBg:getContentSize().height * 0.02):addTo(self.mBg)
  for i = 1, 6 do
    local icon = GridIcon.new(i, GridIcon.MAIN_GRID):pos(panel:getContentSize().width * (0.16 * i - 0.06), panel:getContentSize().height * 0.5):addTo(panel)
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
  if M.TEAM_PURGATORY == self.mTeamType then
    return
  end
  local sum = 0
  local fateSum = 0
  for k, v in pairs(self.mTeamInfo) do
    local buddhaModel = DataUtils.getBuddhaModel(v)
    sum = sum + buddhaModel.attackAssessment
    fateSum = fateSum + buddhaModel.fateCE
  end
  local frame = display.newSprite("team/ce_panel.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.09):addTo(self.mBg, 1)
  self.mCELabel = cc.ui.UILabel.new({
    text = sum - fateSum,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 75, frame:getContentSize().height * 0.5 - 5):addTo(frame)
  self.mFateCELabel = cc.ui.UILabel.new({
    text = "+" .. fateSum,
    size = 24,
    color = display.COLOR_GREEN,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mCELabel:getPositionX() + self.mCELabel:getContentSize().width, frame:getContentSize().height * 0.5 - 5):addTo(frame)
end

function M:teamStarFate()
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S936", ""),
    size = 25,
    color = cc.c3b(253, 231, 192),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(self.mBg:getContentSize().width * 0.7, self.mBg:getContentSize().height * 0.09):addTo(self.mBg, 1)
  display.addSpriteFrames("team/star_tx.plist", "team/star_tx.png")
  local frames = display.newFrames("star%d.png", 1, 18)
  local animation = display.newAnimation(frames, 0.05)
  local starBtn = display.newSprite():align(display.CENTER_LEFT, lb:getPositionX() + lb:getContentSize().width, lb:getPositionY() + 2):addTo(self.mBg, 1)
  starBtn:playAnimationForever(animation, 0)
  starBtn:setTouchEnabled(true)
  starBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      return true
    end
    if event.name == "ended" then
      LayerTeamStar.new():addTo(self, 20)
    end
  end)
end

function M:initAssistTeam()
  if M.TEAM_PURGATORY == self.mTeamType then
    return
  end
  local girdInfo = DYCommon.getDataByTag(DataRetainer.TEAM_GRID_INFO, "id", "1")[1]
  if not girdInfo then
    DDERROR("team gird id : %d with error data", tonumber(idx_))
  end
  local unlockLevel = tonumber(girdInfo.assistTeamLevel)
  if unlockLevel > CloudData.USER_LEVEL then
    cc.ui.UIPushButton.new({
      normal = "team/assist1.png",
      pressed = "team/assist1.png"
    }):onButtonClicked(function()
      local toast = WSToast.new(string.format(DYLang.getString("S938", ""), unlockLevel), 1.5)
      self:addChild(toast, 20)
    end):align(display.CENTER_TOP, self.mBg:getContentSize().width * 0.94, -self.mBg:getContentSize().height * 0.01):addTo(self.mBg, 2)
    return
  end
  cc.ui.UIPushButton.new({
    normal = "team/assist.png",
    pressed = "team/assist.png"
  }):onButtonClicked(function()
    local function tfunListener()
      self.mAssistTeam = DataUtils.getBuddhaTableOnAssist()
      
      for i = 1, #self.mTeamIconTable do
        local teamIcon = self.mTeamIconTable[i]
        local index = table.indexof(self.mAssistTeam, tostring(teamIcon.mBuddhaId))
        if index then
          teamIcon:setOnAssist(true)
        else
          teamIcon:setOnAssist(false)
        end
      end
      self:updateTeam()
    end
    
    local pLayer = LayerTeamAssist.new(M.TEAM_NORMAL, tfunListener)
    self:addChild(pLayer, 20)
  end):align(display.CENTER_TOP, self.mBg:getContentSize().width * 0.94, -self.mBg:getContentSize().height * 0.01):addTo(self.mBg, 2)
end

function M:addHurtBuddhaInfo()
  if M.TEAM_NORMAL == self.mTeamType then
    return
  end
  local costNum = CloudData.PURGATORY_RECOVER_COST
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(150, 70):align(display.CENTER, self.mBg:getContentSize().width * 0.15, self.mBg:getContentSize().height * 0.09):onButtonClicked(function()
    self:buddhaRecover()
  end):addTo(self.mBg, 2)
  self.mRecoverBtn = btn
  display.newSprite("item_icon/pic_peach.png", -50, 0):scale(0.75):addTo(btn)
  self.mRecoverCost = DYLabelTTF.new({
    text = costNum,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):align(display.CENTER, -15, 0):addTo(btn)
  cc.ui.UILabel.new({
    text = DYLang.getString("S941", ""),
    size = 28,
    color = cc.c3b(255, 234, 174),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 35, 0):addTo(btn)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", cc.ui.UILabel.new({
    text = DYLang.getString("S939", ""),
    size = 25,
    color = cc.c3b(240, 212, 180),
    font = GameManager.FONTNAME_TTF
  })):onButtonClicked(function()
    local function tfunListener()
      self.mAssistTeam = DataUtils.getBuddhaTableOnAssist()
      
      for i = 1, #self.mTeamIconTable do
        local teamIcon = self.mTeamIconTable[i]
        local index = table.indexof(self.mAssistTeam, tostring(teamIcon.mBuddhaId))
        if index then
          teamIcon:setOnAssist(true)
        else
          teamIcon:setOnAssist(false)
        end
      end
      self:updateTeam()
    end
    
    local pLayer = LayerTeamAssist.new(M.TEAM_PURGATORY, tfunListener)
    self:addChild(pLayer, 20)
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.09):addTo(self.mBg, 2)
  cc.ui.UIPushButton.new({
    normal = "purgatory/fight_btn.png",
    pressed = "purgatory/fight_btn.png"
  }):onButtonClicked(function()
    self:fightCallBack()
  end):align(display.CENTER_TOP, self.mBg:getContentSize().width * 0.94, -self.mBg:getContentSize().height * 0.01):addTo(self.mBg, 2)
end

function M:buddhaRecover()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  if 0 == self.mHurtBuddhaNum then
    WSToast.new(DYLang.getString("S946", "")):addTo(self, 20)
    return
  elseif tonumber(CloudData.PURGATORY_RECOVER_COST) > CloudData.PEACH then
    local toast = WSToast.new(DYLang.getString("S947", ""))
    self:addChild(toast, 20)
    return
  end
  
  local function tFuncListener(jsonTable)
    if 0 ~= jsonTable.errorCode then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
    else
      for k, v in pairs(self.mTeamIconTable) do
        if v.mIsHurt then
          CloudData.NPC_INFO[v.mBuddhaId].status = 1
          v:setHurtState(false)
        end
      end
      self:createBuddhaList()
      self.mHurtBuddhaNum = 0
      CloudData.PURGATORY_RECOVER_COST = jsonTable.data.recoverCost
      self.mRecoverCost:setString(CloudData.PURGATORY_RECOVER_COST)
      if 0 == CloudData.PURGATORY_RECOVER_COST then
        self.mRecoverBtn:hide()
      end
    end
  end
  
  DYHttpMgr.buddhaRecovery(tFuncListener)
end

function M:initTeamInfo()
  local teamInfo = getTeamInfo(self.mTeamInfo)
  for k, v in pairs(teamInfo) do
    local buddhaId = tonumber(v)
    local gridIcon = self.mGridIconTable[k]
    if gridIcon then
      gridIcon:addBuddhaPic(buddhaId)
      gridIcon:setBuddhaOn(true)
      for i = 1, #self.mTeamIconTable do
        local teamIcon = self.mTeamIconTable[i]
        if teamIcon.mBuddhaId == buddhaId and not teamIcon.mInTask then
          teamIcon:setOnTeam(true)
          table.insert(self.mBuddhaOnTeam, teamIcon)
        end
      end
    end
  end
  self.mFreshingTeam = false
end

function M:updateTeam()
  if M.TEAM_NORMAL == self.mTeamType then
    DataUtils.setBuddhaTableOnTeam(self.mTeamInfo)
  elseif M.TEAM_PURGATORY == self.mTeamType then
    DataUtils.setBuddhaTableOnTeam(self.mTeamInfo, 3)
  end
  local teamInfo = getTeamInfo(self.mTeamInfo)
  for i = 1, self.mUnlockGridNum do
    local gridIcon = self.mGridIconTable[i]
    if gridIcon:getBuddhaOn() then
      gridIcon:removeBuddhaPic()
    end
  end
  for k, v in pairs(teamInfo) do
    local buddhaId = tonumber(v)
    local gridIcon = self.mGridIconTable[k]
    gridIcon:addBuddhaPic(buddhaId)
    gridIcon:setBuddhaOn(true)
  end
  self:updateCE()
end

function M:updateCE()
  if M.TEAM_PURGATORY == self.mTeamType then
    return
  end
  local sum = 0
  local fateSum = 0
  for k, v in pairs(self.mTeamInfo) do
    local buddhaModel = DataUtils.getBuddhaModel(v)
    sum = sum + buddhaModel.attackAssessment
    fateSum = fateSum + buddhaModel.fateCE
  end
  self.mCELabel:setString(sum - fateSum)
  self.mFateCELabel:setString(string.format("+%d", fateSum))
  self.mFateCELabel:setPositionX(self.mCELabel:getPositionX() + self.mCELabel:getContentSize().width)
end

function M:funcChange(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mTabTag = index
  for i = 1, #self.mTabIconTable do
    local icon = self.mTabIconTable[i]
    if index == i then
      icon:setButtonEnabled(false)
    else
      icon:setButtonEnabled(true)
    end
  end
  if self.mListView then
    self.mListView:removeAllItems()
    self.mListView = nil
    self.mTeamIconTable = {}
    self.mBuddhaOnTeam = {}
    self.mFreshingTeam = true
  end
  self:initBuddhaList(self.mBuddhaModelTable[index])
  self:initTeamInfo()
end

function M:putBuddhaOnTeam(idx)
  if self.mFreshingTeam then
    return
  end
  local teamIcon = self.mTeamIconTable[idx]
  if not teamIcon then
    return
  end
  if teamIcon.mIsOnTeam or teamIcon.mIsOnAssist or teamIcon.mIsHurt or teamIcon.mInTask then
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
      table.insert(self.mBuddhaOnTeam, teamIcon)
      table.insert(self.mTeamInfo, tostring(teamIcon.mBuddhaId))
      self:updateTeam()
      return
    end
  end
end

function M:putBuddhaDownTeam(idx)
  if self.mFreshingTeam then
    return
  end
  local gridIcon = self.mGridIconTable[idx]
  if not gridIcon.mIsBuddhaOn or not gridIcon.mBuddhaId then
    return
  end
  table.removebyvalue(self.mTeamInfo, tostring(gridIcon.mBuddhaId), true)
  for i = 1, #self.mBuddhaOnTeam do
    local teamIcon = self.mBuddhaOnTeam[i]
    if teamIcon.mBuddhaId == gridIcon.mBuddhaId then
      teamIcon:setOnTeam(false)
      table.removebyvalue(self.mBuddhaOnTeam, teamIcon, true)
      break
    end
  end
  self:updateTeam()
end

function M:touchListener(event)
  local lv = event.listView
  if "clicked" == event.name then
    if self.mTabTag == event.itemPos then
      return
    end
    self.mTabTag = event.itemPos
    self:funcChange(event.itemPos)
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  elseif "began" == event.name then
    for i = 1, #self.mTabIconTable do
      local content = self.mTabIconTable[i]
      if i == event.itemPos then
        content:setTexture("common_ui/btn_red.png")
        content.label:setColor(cc.c3b(255, 255, 255))
      else
        content:setTexture("common_ui/btn_normal.png")
        content.label:setColor(cc.c3b(255, 224, 186))
      end
    end
  end
end

function M:touchListener1(event)
  if "clicked" == event.name then
    local column = math.ceil(event.point.x / 170)
    if event.itemPos then
      local idx = (event.itemPos - 1) * 5 + column
      DDLOG("idx : %d", idx)
      self:putBuddhaOnTeam(idx)
    end
  elseif "began" == event.name then
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:onTouchGrid(name, x, y, tag)
  if name == "began" then
    print("gridTag : " .. tag)
    self:putBuddhaDownTeam(tag)
    return true
  end
  if name == "ended" then
  end
end

function M:confirmTeamInfo(callback)
  local mainTeam = self.mTeamInfo
  local assistTeam = DataUtils.getBuddhaTableOnAssist()
  if #self.mTeamInfo == 0 then
    local toast = WSToast.new(DYLang.getString("S948", ""), 1.5)
    self:addChild(toast, 50)
    return
  end
  if M.TEAM_PURGATORY == self.mTeamType then
    local function tFuncListener(teamInfo)
      DataUtils.setBuddhaTableOnTeam(mainTeam, 3)
      
      DataUtils.setBuddhaTableOnAssist(assistTeam, 3)
      self:performWithDelay(function()
        callback()
      end, 0)
    end
    
    local params = {}
    params.attackTeam = json.encode(mainTeam)
    params.helpTeam = json.encode(assistTeam)
    DYHttpMgr.updatePurgatoryTeam(tFuncListener, params)
    return
  end
  
  local function tFuncListener(teamInfo)
    if teamInfo.errorCode > 0 then
      local errMsg = teamInfo.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DataUtils.setBuddhaTableOnTeam(mainTeam)
    DataUtils.setBuddhaTableOnAssist(assistTeam)
    self:performWithDelay(function()
      if self.cb then
        self.cb(mainTeam, assistTeam)
      end
      callback()
    end, 0.02)
  end
  
  local params = {}
  params.attackTeam = json.encode(mainTeam)
  params.helpTeam = json.encode(assistTeam)
  params.power = DataUtils.getUserCountCE()
  DYHttpMgr.updateCommonTeam(tFuncListener, params)
end

function M:fightCallBack()
  if #self.mTeamInfo == 0 then
    local toast = WSToast.new(DYLang.getString("S948", ""), 1.5)
    self:addChild(toast, 50)
  else
    local mainTeam = self.mTeamInfo
    local assistTeam = DataUtils.getBuddhaTableOnAssist()
    
    local function tFuncListener(teamInfo)
      local pData = teamInfo.data
      CloudData.PVE_ATK_CIMELIA_DATA = pData.attackCimelia
      CloudData.PVE_DEF_CIMELIA_DATA = pData.defenceCimelia
      for k, info in pairs(pData.teamList) do
        local npcId = info.id or 0
        CloudData.NPC_INFO[tonumber(npcId)] = info
      end
      DataUtils.setBuddhaTableOnTeam(mainTeam, 3)
      DataUtils.setBuddhaTableOnAssist(assistTeam, 3)
      display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE"))
      local id = GameManager.STAGE_NUM or 0
    end
    
    local params = {}
    params.attackTeam = json.encode(mainTeam)
    params.helpTeam = json.encode(assistTeam)
    DYHttpMgr.updatePurgatoryTeam(tFuncListener, params)
  end
end

function M:closeCallBack()
  if self.mSound then
    DYSoundMgr.stopEffect(self.mSound)
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local seq = transition.sequence({
    cc.RemoveSelf:create()
  })
  self:runAction(seq)
end

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  if stageProgress == 1 and DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE1_UPGRADELAY") and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE1_TEAMLAY") then
    local guide = NoviceGuide.new("GUDIE_STAGE1_TEAMLAY"):addTo(self, 50)
  end
  local guide = not (stageProgress == 5 and DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_CHAPTERSCN")) or DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_TEAMLAY") or NoviceGuide.new("GUDIE_STAGE6_TEAMLAY", function()
    local scene = require("app.scenes.ChapterScene").new()
    display.replaceScene(scene, "FADETR", 1)
  end):addTo(self, 50)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:confirmTeamInfo(handler(self, self.closeCallBack))
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

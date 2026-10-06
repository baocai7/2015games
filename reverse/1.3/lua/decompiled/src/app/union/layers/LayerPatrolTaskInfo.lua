local IconItem = require("app.icons.IconItem")
local LayerBoxShow = require("app.layers.LayerBoxShow")
local LayerLackPeach = require("app.layers.LayerLackPeach")
local LayerTip = require("app.babel.layers.LayerTip")
local DYClass = "LayerPatrolTaskInfo"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M.scene(cb)
  local scene = display.newScene()
  scene:addChild(M.new(cb))
  return scene
end

function M:ctor(param, index, callback)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mFile = {}
  self.mId = checknumber(param.task and param.task.taskId)
  self.mIndex = checknumber(index)
  self.mState = checknumber(param.task and param.task.status)
  local time = os.time() + CloudData.DELTA_TIME
  if self.mState == 2 and param.task.beginTime and time >= math.floor(checknumber(param.task.beginTime) / 1000) then
    self.mState = 3
  end
  local info = DataUtils.getPatrolTaskModel(self.mId)
  self.mIntegral = info.attribute
  self.mPatrolTime = info.timeCost
  self.mUnionTeam = {}
  self.mBasicAward = info.baseAward
  self.mBasicAwardNum = info.baseAwardNum
  self.mExtraAward = info.extraAward
  self.mExtraAwardNum = info.extraAwardNum
  self.mExtraCondition = info.extraAwardCon
  self.mProperties = info.tag
  self.mTeamModel = {}
  self.mTeamIcons = {}
  self.mPeachCost = math.ceil(self.mPatrolTime) * 20
  self.mTaskName = info.name
  self.mBuddhaInfo = {}
  self.mUBuddhaInfo = {}
  self.mRentModel = nil
  self.mPatrolAni = nil
  self.mIdInRent = 0
  self.mIdInTeam = {}
  self.mCanChangeTeam = false
  self.mCanBeClicked = false
  self.mProFitCount = 0
  self.mRentUsers = {}
  self.mBg = nil
  self.mTimeLab = nil
  self.mProBar = nil
  self.mProNumLab = {}
  self.mProgress = nil
  self.mGrids = {}
  self.mPropertyIcons = {}
  self.mFuncBtns = {}
  local strKeys = {
    DY_KEY.kBuddhaOnTeam,
    DY_KEY.kTeamPurgatory,
    DY_KEY.kAssistPurgatory,
    DY_KEY.kBuddhaOnAssist
  }
  for i = 1, #strKeys do
    local stringBuddhaIds = DYStat.getValueStr(strKeys[i], "")
    local tempTable = explode(",", stringBuddhaIds)
    for k, v in pairs(tempTable) do
      if "" ~= v then
        table.insert(self.mIdInTeam, v)
      end
    end
  end
  self:initUI()
  self:requestData(param)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("union/patrol/img_detail_bottom_02.png", 0, 0):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 1078, 663):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg, 1)
  self:loadTeam()
  self:addContent()
end

function M:addButtons()
  for i = 1, #self.mFuncBtns do
    if self.mFuncBtns[i] then
      self.mFuncBtns[i]:runAction(cc.RemoveSelf:create())
      self.mFuncBtns[i] = nil
    end
  end
  local info = {}
  if self.mState == 1 then
    info = {
      [1] = {
        str = DYLang.getString("STR_START_PATROL", ""),
        func = function()
          self:startPatrol()
        end
      },
      [2] = {
        str = DYLang.getString("STR_RECOMMEND_BUDDHA", ""),
        func = function()
          self:recommend()
        end
      }
    }
  elseif self.mState == 2 then
    info = {
      [1] = {
        str = DYLang.getString("STR_TASK_GIVEUP", ""),
        func = function()
          self:toGiveup()
        end
      }
    }
  elseif self.mState == 3 then
    info = {
      [1] = {
        str = DYLang.getString("STR_TASK_FINISH", ""),
        func = function()
          self:finish()
        end
      }
    }
  end
  for i = 1, #info do
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = info[i].str,
      size = 30,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):onButtonClicked(function()
      if self.mCanBeClicked then
        self.mCanBeClicked = false
        info[i].func()
        self.mCanBeClicked = true
      end
    end):align(display.CENTER, 1155 - i * 200, 78):addTo(self.mBg)
    if #info == 1 then
      btn:setPosition(855, 78)
    end
    self.mFuncBtns[i] = btn
  end
  self.mCanBeClicked = true
end

local function newBuddhaIcon(buddhaModel)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality))
  local icon = display.newSprite(buddhaModel.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 == buddhaModel.isRebel then
    icon:setScaleX(-1)
  end
  local starPic = display.newSprite(string.format("upgrade/star%d.png", buddhaModel.starLevel)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame, 1)
  return iconFrame
end

local function newListIcon(buddhaModel, self, tag)
  local teamIcon = display.newScale9Sprite("common_ui/common_frame4.png", 0, 0, cc.size(122, 187), cc.rect(40, 35, 2, 2))
  teamIcon:setOpacity(0)
  teamIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouchIcon(event, buddhaModel, tag)
  end)
  teamIcon:setTouchEnabled(true)
  teamIcon:setTouchSwallowEnabled(false)
  local icon = newBuddhaIcon(buddhaModel)
  icon:setPosition(61, 127)
  teamIcon:addChild(icon)
  DYLabelTTF.new({
    text = DYLang.getString("STR_LV", "") .. buddhaModel.level,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "BOTTOM_RIGHT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):align(display.BOTTOM_RIGHT, icon:getContentSize().width * 0.91, icon:getContentSize().height * 0.02):addTo(icon)
  local spiritFrame = display.newSprite("union/patrol/img_stone.png"):pos(61, 42):addTo(teamIcon)
  cc.ui.UILabel.new({
    text = buddhaModel.consume,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, spiritFrame:getContentSize().width * 0.63, spiritFrame:getContentSize().height * 0.4):addTo(spiritFrame)
  local pTypePic = display.newSprite(string.format("team/symbol%d.png", buddhaModel.symbol)):pos(59, 59):addTo(icon)
  local mask
  
  function teamIcon.select()
    teamIcon:setTouchEnabled(false)
    if mask then
      mask:runAction(cc.RemoveSelf:create())
      mask = nil
    end
    mask = display.newSprite("union/patrol/img_icon_fighting.png"):pos(59, 59):addTo(icon, 2)
  end
  
  function teamIcon.unselect()
    teamIcon:setTouchEnabled(true)
    if mask then
      mask:runAction(cc.RemoveSelf:create())
      mask = nil
    end
  end
  
  function teamIcon.disable(target, str)
    teamIcon:setTouchEnabled(false)
    if mask then
      mask:runAction(cc.RemoveSelf:create())
      mask = nil
    end
    mask = display.newSprite("union/patrol/img_icon_inf.png"):pos(59, 59):addTo(icon, 1)
    DYLabelTTF.new({
      text = str,
      size = 24,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER"
    }, {
      lineColor = cc.c3b(90, 30, 50)
    }):align(display.CENTER, 59, 57):addTo(mask)
  end
  
  function teamIcon.matchPros(target, pros)
    local myPro = clone(buddhaModel.property)
    local matchNum = 0
    for i = 1, #pros do
      local proI = checknumber(pros[i])
      local proType = math.floor(proI / 100)
      if 6 <= proType then
        if proI <= checknumber(myPro[checkstring(proType)]) then
          matchNum = matchNum + 1
          myPro[checkstring(proType)] = nil
        end
      elseif checknumber(myPro[checkstring(proI)]) == 1 then
        matchNum = matchNum + 1
        if proType == 1 then
          myPro["101"] = nil
          myPro["102"] = nil
        else
          myPro[checkstring(proI)] = nil
        end
      end
    end
    return matchNum
  end
  
  function teamIcon.getModel()
    return buddhaModel
  end
  
  function teamIcon.getProperty()
    return buddhaModel.property
  end
  
  if buddhaModel.inTask ~= 0 then
    teamIcon:disable(DYLang.getString("STR_IN_PATROL", ""))
  end
  return teamIcon
end

function M:loadBuddha()
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_OWN_BUDDHA", ""),
    size = 24,
    color = cc.c3b(180, 120, 80),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 642, 610):addTo(self.mBg)
  local buddhaIds = DataUtils.getBuddhaIdsTableTeamScene()
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(380, 152, 527, 445),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  local totalNum = #buddhaIds
  local row = math.ceil(totalNum / 4)
  local column = totalNum % 4
  local endNum = 4
  for i = 1, row do
    if i == row and column ~= 0 then
      endNum = column
    end
    local item = list:newItem()
    local content = display.newNode()
    for count = 1, endNum do
      local index = (i - 1) * 4 + count
      local id = buddhaIds[index]
      local buddhaModel = DataUtils.getBuddhaModelPatrol(id)
      buddhaModel.tag = 0
      local teamIcon = newListIcon(buddhaModel, self, 0)
      teamIcon:setPosition(130 * count - 65, 80)
      content:addChild(teamIcon)
      if buddhaModel.inTask == 0 or checknumber(self.mIdInRent) == checknumber(id) then
        self.mBuddhaInfo[checkstring(id)] = teamIcon
      end
    end
    content:setContentSize(520, 187)
    item:addContent(content)
    item:setItemSize(520, 187)
    list:addItem(item)
  end
  list:reload()
  for i = 1, #self.mIdInTeam do
    local id = checkstring(self.mIdInTeam[i])
    if self.mBuddhaInfo[id] then
      self.mBuddhaInfo[id]:disable(DYLang.getString("STR_IN_TEAM", ""))
      self.mBuddhaInfo[id] = nil
    end
  end
end

function M:unableBuddha()
  local rentID = checkstring(self.mIdInRent)
  if self.mBuddhaInfo[rentID] then
    self.mBuddhaInfo[rentID]:disable(DYLang.getString("STR_IN_RENT", ""))
    self.mBuddhaInfo[rentID] = nil
  end
end

function M:loadTeam()
  for i = 1, 4 do
    local icon = display.newSprite("common_ui/frame0.png"):pos(129 * i, 78):addTo(self.mBg)
    self.mGrids[i] = icon
    icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onTouchGrid(event, i)
    end)
    icon:setTouchEnabled(true)
    display.newSprite("wiki/q0.png"):pos(59, 59):addTo(icon)
  end
end

function M:loadUnionBuddha()
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_UNION_BUDDHA", ""),
    size = 24,
    color = cc.c3b(255, 240, 210),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 1003, 610):addTo(self.mBg)
  local buddhaIds = self.mUnionTeam
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(933, 152, 138, 445),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  for i = 1, #buddhaIds do
    local item = list:newItem()
    local id = buddhaIds[i].id
    local level = checknumber(buddhaIds[i].level)
    local star = checknumber(buddhaIds[i].star)
    local buddhaModel = DataUtils.getBuddhaModelPatrol(id, false, level, star)
    buddhaModel.tag = 1
    buddhaModel.level = level
    buddhaModel.starLevel = star
    buddhaModel.uid = checknumber(buddhaIds[i].uid)
    buddhaModel.inTask = 0
    local content = display.newNode()
    local teamIcon = newListIcon(buddhaModel, self, 1)
    teamIcon:setPosition(61, 80)
    content:addChild(teamIcon)
    item:addContent(content)
    if self.mRentUsers[checkstring(buddhaIds[i].uid)] then
      buddhaIds[i].state = 0
    else
      buddhaIds[i].state = 1
    end
    local index = DataUtils.getKeyIndex(self.mTeamModel, "uid", buddhaModel.uid)
    if checknumber(buddhaIds[i].state) == 0 and (index <= 0 or checknumber(self.mTeamModel[index].npcId) ~= id) then
      local endTime = checknumber(self.mRentUsers[checkstring(buddhaIds[i].uid)])
      local curTime = os.time() + CloudData.DELTA_TIME
      local time = math.floor(endTime / 1000) - curTime
      if 0 < time then
        local str = DataUtils.timeStrHSM(time)
        teamIcon:disable(str)
      else
        self.mUBuddhaInfo[checkstring(buddhaModel.uid)] = teamIcon
      end
    else
      self.mUBuddhaInfo[checkstring(buddhaModel.uid)] = teamIcon
    end
    content:setContentSize(122, 187)
    item:setItemSize(122, 187)
    list:addItem(item)
  end
  list:reload()
end

function M:onTouchIcon(event, buddhaModel, tag)
  if "began" == event.name then
    self.mBeginPos = cc.p(event.x, event.y)
    return true
  elseif "ended" == event.name then
    local pos = cc.p(event.x, event.y)
    if math.abs(pos.x - self.mBeginPos.x) < 50 and math.abs(pos.y - self.mBeginPos.y) < 50 then
      self:putBuddhaOnTeam(buddhaModel, tag)
    end
  end
end

local function propertyFit(proConmmend, properties)
  if checknumber(proConmmend) == 0 or not properties then
    return false, properties
  end
  local pros = clone(properties)
  local proType = math.floor(proConmmend / 100)
  if 600 <= proConmmend then
    if proConmmend <= checknumber(pros[checkstring(proType)]) then
      pros[checkstring(proType)] = nil
      return true, pros
    end
  elseif checknumber(pros[checkstring(proConmmend)]) == 1 then
    if proType == 1 then
      pros["101"] = nil
      pros["102"] = nil
    else
      pros[checkstring(proConmmend)] = nil
    end
    return true, pros
  end
  return false, pros
end

function M:putBuddhaOnTeam(buddhaModel, tag)
  if not buddhaModel or #self.mTeamModel >= 4 or tag == 1 and self.mRentModel or not self.mCanChangeTeam then
    return
  end
  if self.mSound then
    DYSoundMgr.stopEffect(self.mSound)
  end
  self.mSound = DYSoundMgr.playEffect(buddhaModel.buddhaSound)
  local index = #self.mTeamModel + 1
  local icon = newBuddhaIcon(buddhaModel)
  icon:setPosition(self.mGrids[index]:getContentSize().width * 0.5, self.mGrids[index]:getContentSize().height * 0.53)
  self.mGrids[index]:addChild(icon)
  self.mGrids[index].icon = icon
  table.insert(self.mTeamModel, buddhaModel)
  local id = checkstring(buddhaModel.npcId)
  if buddhaModel.tag == 0 then
    if self.mBuddhaInfo[id] then
      self.mBuddhaInfo[id]:select()
    end
  else
    self.mRentModel = buddhaModel
    if self.mUBuddhaInfo[checkstring(buddhaModel.uid)] then
      self.mUBuddhaInfo[checkstring(buddhaModel.uid)]:select()
    end
  end
  local pros = clone(buddhaModel.property)
  for i = 1, #self.mProperties do
    if not self.mPropertyIcons[i].selected then
      local isFit, clonePro = propertyFit(checknumber(self.mProperties[i]), pros)
      if isFit then
        self.mPropertyIcons[i]:select()
        pros = clonePro
        self.mProFitCount = self.mProFitCount + 1
      end
    end
  end
  self:showBoxPro()
end

function M:onTouchGrid(event, index)
  if "began" == event.name then
    return true
  elseif "ended" == event.name then
    self:putBuddhaDownTeam(index)
  end
end

function M:putBuddhaDownTeam(index)
  if not self.mTeamModel[index] or not self.mCanChangeTeam then
    return
  end
  local model = self.mTeamModel[index]
  table.remove(self.mTeamModel, index)
  local id = checkstring(model.npcId)
  if model.tag == 0 then
    if self.mBuddhaInfo[id] then
      self.mBuddhaInfo[id]:unselect()
    end
  else
    self.mRentModel = nil
    if self.mUBuddhaInfo[checkstring(model.uid)] then
      self.mUBuddhaInfo[checkstring(model.uid)]:unselect()
    end
  end
  self:showTeam()
end

function M:showTeam()
  for i = 1, 4 do
    if self.mGrids[i].icon then
      self.mGrids[i].icon:runAction(cc.RemoveSelf:create())
      self.mGrids[i].icon = nil
    end
  end
  self.mRentModel = nil
  for i = 1, #self.mProperties do
    self.mPropertyIcons[i]:unselect()
  end
  self.mProFitCount = 0
  for i = 1, #self.mTeamModel do
    local buddhaModel = self.mTeamModel[i]
    local icon = newBuddhaIcon(buddhaModel)
    icon:setPosition(59, 59)
    self.mGrids[i]:addChild(icon)
    self.mGrids[i].icon = icon
    local id = checkstring(buddhaModel.npcId)
    if buddhaModel.tag == 0 then
      if self.mBuddhaInfo[id] then
        self.mBuddhaInfo[id]:select()
      end
    else
      self.mRentModel = buddhaModel
      if self.mUBuddhaInfo[checkstring(buddhaModel.uid)] then
        self.mUBuddhaInfo[checkstring(buddhaModel.uid)]:select()
      end
    end
    local pros = clone(buddhaModel.property)
    for j = 1, #self.mProperties do
      if not self.mPropertyIcons[j].selected then
        local isFit, clonePro = propertyFit(checknumber(self.mProperties[j]), pros)
        if isFit then
          self.mProFitCount = self.mProFitCount + 1
          self.mPropertyIcons[j]:select()
          pros = clonePro
        end
      end
    end
  end
  self:showBoxPro()
end

function M:showBoxPro()
  local mark = 6
  local num = self.mProFitCount
  local rate = (num - mark) / (10 - mark) * 100
  rate = 0 < rate and rate or 0
  rate = rate <= 100 and rate or 100
  self.mProgress:setPercentage(rate)
  local info = self.mExtraCondition
  for i = 1, #info do
    if self.mProNumLab[i] then
      self.mProNumLab[i]:runAction(cc.RemoveSelf:create())
      self.mProNumLab[i] = nil
    end
    local x = i == #info and 0.9 or 0.4 * i - 0.3
    if num < checknumber(info[i]) then
      self.mProNumLab[i] = cc.ui.UILabel.new({
        text = info[i],
        size = 20,
        color = cc.c3b(80, 30, 0),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER, self.mProBar:getContentSize().width * x, -37):addTo(self.mProBar)
    else
      self.mProNumLab[i] = display.newSprite("union/patrol/img_detail_satisfy.png"):align(display.CENTER, self.mProBar:getContentSize().width * x, -37):addTo(self.mProBar)
    end
  end
end

function M:addContent()
  cc.ui.UILabel.new({
    text = self.mTaskName,
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 192, 652):addTo(self.mBg)
  local integral = self.mIntegral
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_MISSION_INTEGRAL", "") .. integral,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 92, 588):addTo(self.mBg)
  local time = self.mPatrolTime .. DYLang.getString("TIME_HOUR", "")
  self.mTimeLab = cc.ui.UILabel.new({
    text = DYLang.getString("STR_PATROL_TIME", "") .. time,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 92, 557):addTo(self.mBg)
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_BASIC_AWARD", ""),
    size = 20,
    color = cc.c3b(180, 120, 80),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 53, 510):addTo(self.mBg)
  for i = 1, #self.mBasicAward do
    local frame = IconItem.new(self.mBasicAward[i])
    frame:showItemTip()
    frame:setPosition(80 * i + 12, 457)
    frame:setScale(0.6)
    self.mBg:addChild(frame)
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = checknumber(self.mBasicAwardNum[i]),
      font = "fonts/whiteNum.fnt"
    }):align(display.BOTTOM_RIGHT, 50, -45):scale(1):addTo(frame, 1)
  end
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_EXTRA_AWARD", ""),
    size = 20,
    color = cc.c3b(180, 120, 80),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 53, 389):addTo(self.mBg)
  local barBg = display.newSprite("union/patrol/img_detail_bar_01.png"):pos(184, 337):addTo(self.mBg)
  self.mProBar = barBg
  local pro = cc.ProgressTimer:create(display.newSprite("union/patrol/img_detail_bar_02.png")):addTo(barBg)
  pro:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  pro:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  pro:setMidpoint(cc.p(0, 0))
  pro:setBarChangeRate(cc.p(1, 0))
  pro:setPercentage(0)
  self.mProgress = pro
  local info = self.mExtraCondition
  for i = 1, #info do
    local img = "union/patrol/img_detail_" .. i * 2 + 3 .. ".png"
    local x = 0.4 * i - 0.3
    if i == #info then
      img = "union/patrol/img_detail_9.png"
      x = 0.9
    end
    local frame = cc.ui.UIPushButton.new(img):align(display.CENTER, barBg:getContentSize().width * x, barBg:getContentSize().height * 0.5):onButtonPressed(function(event)
      event.target:setScale(0.9)
    end):onButtonRelease(function(event)
      event.target:setScale(1)
    end):onButtonClicked(function()
      local awardTable = {
        {
          id = checknumber(self.mExtraAward[i]),
          num = checknumber(self.mExtraAwardNum[i])
        }
      }
      LayerBoxShow.new({boxInfo = awardTable}, LayerBoxShow.BOX_SHOW):addTo(self, 20)
    end):addTo(barBg)
    self.mProNumLab[i] = cc.ui.UILabel.new({
      text = info[i],
      size = 20,
      color = cc.c3b(80, 30, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, barBg:getContentSize().width * x, -37):addTo(barBg)
  end
  for i = 1, 10 do
    local frame = display.newSprite("union/patrol/img_task_icon.png"):pos((i - 1) % 5 * 50 + 95, 288 - math.ceil(i / 5) * 49):addTo(self.mBg)
  end
  for i = 1, #self.mProperties do
    local pro = checknumber(self.mProperties[i])
    local frame = DataUtils.getBuddhaPropertyIcon(pro):pos((i - 1) % 5 * 50 + 95, 288 - math.ceil(i / 5) * 49):addTo(self.mBg)
    self.mPropertyIcons[i] = frame
  end
end

function M:getTeamProCount(team)
  local count = 0
  for i = 1, #team do
    local pros = team[i].pro
    for j = 1, #self.mProperties do
      if not self.mPropertyIcons[j].selected then
        local isFit, clonePro = propertyFit(checknumber(self.mProperties[j]), pros)
        if isFit then
          count = count + 1
          self.mPropertyIcons[j].selected = true
          pros = clonePro
        end
      end
    end
  end
  for i = 1, #self.mProperties do
    self.mPropertyIcons[i].selected = false
  end
  return count
end

function M:recommend()
  for i = 1, #self.mTeamModel do
    local model = self.mTeamModel[i]
    local id = checkstring(model.npcId)
    if model.tag == 0 then
      if self.mBuddhaInfo[id] then
        self.mBuddhaInfo[id]:unselect()
      end
    else
      self.mRentModel = nil
      if self.mUBuddhaInfo[checkstring(model.uid)] then
        self.mUBuddhaInfo[checkstring(model.uid)]:unselect()
      end
    end
  end
  self.mTeamModel = {}
  self.mRentModel = nil
  for i = 1, #self.mProperties do
    self.mPropertyIcons[i]:unselect()
  end
  self.mProFitCount = 0
  local sortInfo = {}
  local mark = -1
  local sum = 0
  
  local function add(num, info)
    if 3 < #sortInfo then
      return
    end
    local added = false
    for i = 1, #sortInfo do
      if num > sortInfo[i].num then
        table.insert(sortInfo, i, info)
        added = true
        break
      end
    end
    if not added then
      table.insert(sortInfo, #sortInfo + 1, info)
    end
    mark = sortInfo[#sortInfo].num
  end
  
  local function getSortedInfo(info)
    local team = {}
    for k, v in pairs(info) do
      local num = v:matchPros(self.mProperties)
      local tag = false
      local teamInfo = {
        id = checknumber(k),
        num = num,
        pro = clone(v:getProperty()),
        model = v:getModel()
      }
      for i = 1, #team do
        if num > team[i].num then
          table.insert(team, i, teamInfo)
          tag = true
          break
        end
      end
      if not tag then
        table.insert(team, #team + 1, teamInfo)
      end
    end
    return team
  end
  
  local team = getSortedInfo(self.mBuddhaInfo)
  for i = 1, #team do
    if #sortInfo < 4 then
      sortInfo[i] = team[i]
      if #sortInfo == 4 then
        sum = self:getTeamProCount(sortInfo)
      end
    else
      local save = sortInfo[4]
      sortInfo[4] = team[i]
      local compSum = self:getTeamProCount(sortInfo)
      if sum < compSum then
        print("__sum changed __" .. sum .. " _______ " .. compSum .. "___key: " .. team[i].id)
        sum = compSum
      else
        sortInfo[4] = save
      end
    end
  end
  local infoSave, tempUBud
  local index = #sortInfo
  if 4 <= index then
    index = 4
    infoSave = sortInfo[4]
    sortInfo[4] = nil
  else
    index = index + 1
  end
  for k, v in pairs(self.mUBuddhaInfo) do
    local compPros = v:matchPros(self.mProperties)
    local buddhaPros = clone(v:getProperty())
    local bModel = v:getModel()
    sortInfo[index] = {
      id = checknumber(bModel.npcId),
      num = compPros,
      pro = buddhaPros,
      model = bModel
    }
    local compSum = self:getTeamProCount(sortInfo)
    if sum < compSum or not infoSave then
      sum = compSum
      infoSave = sortInfo[index]
      sortInfo[index] = nil
    end
  end
  sortInfo[index] = infoSave
  for i = 1, #sortInfo do
    self.mTeamModel[i] = sortInfo[i].model
  end
  self:showTeam()
end

function M:startPatrol()
  if #self.mTeamModel < 4 then
    WSToast.new(DYLang.getString("STR_TASK_TEAM_TIP", "")):addTo(self, 20)
    return
  end
  local buddhaIds = ""
  local rentUid = 0
  for i = 1, #self.mTeamModel do
    local model = self.mTeamModel[i]
    if model.tag == 1 then
      rentUid = checknumber(model.uid)
    elseif buddhaIds == "" then
      buddhaIds = buddhaIds .. model.npcId
    else
      buddhaIds = buddhaIds .. ";" .. model.npcId
    end
  end
  
  local function tFuncListener(json)
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif checknumber(json.errorCode) ~= 0 then
      local msg = json.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      self.mState = 2
      self.mCanChangeTeam = false
      for i = 1, #self.mTeamModel do
        local id = self.mTeamModel[i].npcId
        if CloudData.NPC_INFO[id] and checknumber(self.mTeamModel[i].tag) == 0 then
          CloudData.NPC_INFO[id].inTask = 1
        end
      end
      self:addButtons()
      self:showPatrolAni()
    end
  end
  
  local params = {
    index = self.mIndex,
    clanId = CloudData.UNION_INFO.id,
    buddhaIds = buddhaIds,
    rentUid = rentUid,
    matchCount = self.mProFitCount
  }
  DYHttpMgr.patrolTaskStart(tFuncListener, params)
end

function M:toGiveup()
  LayerTip.new(DYLang.getString("TIP_PATROL_GIVEUP", ""), handler(self, self.giveup)):addTo(self, 20)
end

function M:giveup()
  local function tFuncListener(json)
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif checknumber(json.errorCode) ~= 0 then
      local msg = json.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      self.mState = 1
      for i = 1, #self.mTeamModel do
        local id = self.mTeamModel[i].npcId
        if CloudData.NPC_INFO[id] then
          CloudData.NPC_INFO[id].inTask = 0
        end
      end
      self:closeCallBack()
    end
  end
  
  local params = {
    index = self.mIndex,
    clanId = CloudData.UNION_INFO.id
  }
  DYHttpMgr.patrolTaskGiveup(tFuncListener, params)
end

function M:peachFinish()
  local peach = CloudData.PEACH
  if peach < self.mPeachCost then
    local tip = LayerLackPeach.new()
    self:addChild(tip, 20)
    return
  end
  local str = string.format(DYLang.getString("TIP_PATROL_PEACH", ""), self.mPeachCost)
  LayerTip.new(str, handler(self, self.finish)):addTo(self, 20)
end

function M:finish()
  local function tFuncListener(json)
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif checknumber(json.errorCode) ~= 0 then
      local msg = json.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      self.mState = 1
      self:showPatrolAni()
      local info = json.data or {}
      self:getReward(info)
      for i = 1, #self.mTeamModel do
        local id = self.mTeamModel[i].npcId
        if CloudData.NPC_INFO[id] then
          CloudData.NPC_INFO[id].inTask = 0
        end
      end
    end
  end
  
  local params = {
    index = self.mIndex,
    clanId = CloudData.UNION_INFO.id,
    clanLevel = CloudData.UNION_INFO.level
  }
  DYHttpMgr.patrolTaskGetAward(tFuncListener, params)
end

function M:getReward(info)
  local drop = info.drop or {}
  for id, sum in pairs(drop) do
    DataUtils.updateItemNum(id, sum)
  end
  local dropGain = info.dropGain or {}
  local awardInfo = {}
  for k, v in pairs(dropGain) do
    table.insert(awardInfo, {
      id = checknumber(k),
      num = checknumber(v)
    })
  end
  LayerBoxShow.new({boxInfo = awardInfo}, LayerBoxShow.AWARD_GET, handler(self, self.closeCallBack)):addTo(self, 20)
end

function M:requestData(info)
  self:initData(info)
end

function M:initData(info)
  if not info or type(info) ~= "table" then
    return
  end
  self.mUnionTeam = info.union or {}
  self.mRentUsers = info.rentUsers or {}
  self.mIdInRent = info.rent
  if self.mState == 2 then
    local beginTime = checknumber(info.task and info.task.beginTime) / 1000
    self.mPatrolTime = math.floor(beginTime) - os.time() - CloudData.DELTA_TIME
    self.mPeachCost = math.ceil(self.mPatrolTime / 3600) * 20
  end
  local teamId = info.buddha or {}
  if self.mState == 1 then
    teamId = {}
  end
  for i = 1, #teamId do
    local state = checknumber(teamId[i].state)
    local level = checknumber(teamId[i].level)
    local star = checknumber(teamId[i].star)
    local model
    if state == 1 then
      model = DataUtils.getBuddhaModelPatrol(teamId[i].id, false, level, star)
    else
      model = DataUtils.getBuddhaModelPatrol(teamId[i].id)
    end
    model.starLevel = star
    model.level = level
    model.tag = state
    model.uid = checknumber(teamId[i].uid)
    self.mTeamModel[i] = model
  end
  self:loadBuddha()
  self:refreshContent()
  self:addButtons()
  self:loadUnionBuddha()
  self:unableBuddha()
  self:showTeam()
  self:showPatrolAni()
end

function M:refreshContent()
  local timeStr = DYLang.getString("STR_PATROL_TIME", "")
  if self.mState == 2 then
    self.mCanChangeTeam = false
    local str = DataUtils.timeToStr(self.mPatrolTime)
    self.mTimeLab:setString(timeStr .. str)
  elseif self.mState == 3 then
    self.mCanChangeTeam = false
    self.mTimeLab:setString(timeStr .. "0" .. DYLang.getString("TIME_HOUR", ""))
  else
    self.mCanChangeTeam = true
  end
end

function M:showPatrolAni()
  if self.mPatrolAni then
    self.mPatrolAni:runAction(cc.RemoveSelf:create())
    self.mPatrolAni = nil
  end
  if self.mState ~= 2 then
    return
  end
  local bg = display.newSprite("common_ui/img_square.png"):pos(571, 370):addTo(self.mBg, 5)
  bg:setColor(cc.c3b(0, 0, 0))
  bg:setOpacity(0)
  self.mPatrolAni = bg
  self.mFile = {}
  DYRes.loadFileInfo("armature/shujing1/shujing1.csb", self.mFile)
  DYRes.loadFileInfo("armature/zhizhong/zhizhong.csb", self.mFile)
  local clock = ccs.Armature:create("zhizhong")
  clock:setOpacity(0)
  clock:setPosition(bg:getContentSize().width * 0.5, -90)
  bg:addChild(clock)
  clock:getAnimation():playWithIndex(0)
  clock:runAction(cc.FadeIn:create(1))
  local armature = ccs.Armature:create("shujing1")
  armature:setOpacity(0)
  armature:setPosition(bg:getContentSize().width * 0.5, -90)
  bg:addChild(armature)
  armature:getAnimation():playWithIndex(1)
  armature:runAction(cc.FadeIn:create(1))
end

function M:closeCallBack()
  if self.mSound then
    DYSoundMgr.stopEffect(self.mSound)
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYRes.unloadFileInfo(self.mFile)
  self.mFile = {}
end

function M:recommendTemp()
  local infoArr = {}
  for i = 1, 11 do
    infoArr[i] = {}
  end
  local team = {}
  for k, v in pairs(self.mBuddhaInfo) do
    team[#team + 1] = v
  end
  if #team < 4 then
    print("\229\133\181\231\167\141\229\164\170\229\176\145")
    return
  end
  for i = 1, #self.mProperties do
    self.mPropertyIcons[i].selected = false
  end
  
  local function getPros(j)
    local json = clone(j)
    local result = {}
    for i = 1, #json do
      local pros = json[i]
      for j = 1, #self.mProperties do
        if not self.mPropertyIcons[j].selected then
          local isFit, clonePro = propertyFit(checknumber(self.mProperties[j]), pros)
          if isFit then
            table.insert(result, self.mProperties[j])
            self.mPropertyIcons[j].selected = true
            pros = clonePro
          end
        end
      end
    end
    for i = 1, #self.mProperties do
      self.mPropertyIcons[i].selected = false
    end
    return result
  end
  
  local selectTPro = {}
  for i = 1, #team - 3 do
    local model1 = team[i]:getModel().npcId
    local pro1 = clone(team[i]:getProperty())
    selectTPro[1] = pro1
    for j = i + 1, #team - 2 do
      local model2 = team[j]:getModel().npcId
      local pro2 = clone(team[j]:getProperty())
      selectTPro[2] = pro2
      for k = j + 1, #team - 1 do
        local model3 = team[k]:getModel().npcId
        local pro3 = clone(team[k]:getProperty())
        selectTPro[3] = pro3
        for m = k + 1, #team do
          local model4 = team[m]:getModel().npcId
          local pro4 = clone(team[m]:getProperty())
          selectTPro[4] = pro4
          local pros = getPros({
            pro1,
            pro2,
            pro3,
            pro4
          })
          local t1 = {
            model1,
            model2,
            model3,
            model4
          }
          table.insert(infoArr[#pros + 1], {model = t1, pro = pros})
        end
      end
    end
  end
  local bg = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(1280, 720), cc.rect(45, 45, 2, 2)):pos(0, 0):addTo(self.mNode, 20)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 1200, 680):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    bg:runAction(cc.RemoveSelf:create())
  end):addTo(bg, 1)
  local list
  
  local function addItems(info)
    if list then
      list:runAction(cc.RemoveSelf:create())
      list = nil
    end
    list = cc.ui.UIListView.new({
      bgColor = cc.c4b(0, 0, 0, 150),
      viewRect = cc.rect(140, 20, 1000, 680),
      direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
    }):addTo(bg)
    for count = 1, #info do
      local model = info[count].model
      local pro = info[count].pro
      local item = list:newItem()
      local content = display.newNode()
      content:setContentSize(1000, 100)
      local h = 50
      DYLabelTTF.new({
        text = count,
        size = 20,
        color = cc.c3b(255, 0, 0),
        font = GameManager.FONTNAME_TTF
      }, {}):pos(28, h):addTo(content)
      for k = 1, #model do
        local id = model[k]
        local buddhaModel = DataUtils.getBuddhaModelPatrol(id)
        buddhaModel.tag = 0
        local icon = newBuddhaIcon(buddhaModel)
        icon:setScale(0.7)
        icon:setPosition(100 * k, h)
        content:addChild(icon)
        DYLabelTTF.new({
          text = id,
          size = 30,
          color = cc.c3b(255, 255, 255),
          font = GameManager.FONTNAME_TTF
        }, {}):pos(59, -10):addTo(icon, 1)
      end
      for k = 1, #pro do
        local icon = DataUtils.getBuddhaPropertyIcon(pro[k])
        icon:setPosition(450 + 55 * k, h)
        content:addChild(icon)
        DYLabelTTF.new({
          text = pro[k],
          size = 20,
          color = cc.c3b(255, 255, 255),
          font = GameManager.FONTNAME_TTF
        }, {}):pos(23, -20):addTo(icon)
      end
      item:addContent(content)
      item:setItemSize(1000, 100)
      list:addItem(item)
    end
    list:reload()
  end
  
  for i = 1, 11 do
    local index = 12 - i
    local str = index - 1 .. "-" .. #infoArr[index]
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = str,
      size = 40,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):onButtonClicked(function()
      addItems(infoArr[index])
    end):align(display.CENTER, 70, 710 - 60 * i):addTo(bg)
  end
end

return M

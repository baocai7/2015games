local LayerPatrolMission = require("app.union.layers.LayerPatrolMission")
local LayerPatrolRent = require("app.union.layers.LayerPatrolRent")
local LayerPatrolGoal = require("app.union.layers.LayerPatrolGoal")
local LayerRule = require("app.layers.LayerRule")
local DYClass = "LayerPatrol"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M.scene(cb)
  local scene = display.newScene()
  scene:addChild(M.new(cb))
  return scene
end

local UNION_MAX_LEVEL = 10

function M:ctor(callback)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mMissions = {}
  self.mRentCount = 0
  self.mRentIntegral = 0
  self.mGoalIntegralSum = 0
  self.mGoalIntegralMax = 1
  self.mMyIntegral = 0
  self.mGoalRank = 0
  self.mGoalTimeLeft = 0
  self.mRendId = 0
  self.mMaxDistri = 0
  self.mCanBeClicked = false
  self.mShowTaskNew = false
  self.mShowGoalNew = false
  self.mBg = nil
  self.mTaskIcon = {}
  self.mRentFrame = nil
  self.mProgressLab = nil
  self.mIntegralLab = nil
  self.mRankLab = nil
  self.mTimeLab = nil
  self.mTaskNewIcon = nil
  self.mGoalNewIcon = nil
  self.mScheduler = nil
  self.mRentCountLab = nil
  self.mRentInteLab = nil
  self:initUI()
  self:requestData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("union/patrol/img_patrol_background.jpg", 0, 0):addTo(self.mNode)
  self.mBg = bg
  LayerRule.newRuleIcon(LayerRule.PATROL):align(display.CENTER_RIGHT, display.width - 170, display.height * 0.94):addTo(self, 2)
  cc.ui.UIPushButton.new({
    normal = "union/btn_back.png",
    pressed = "union/btn_back.png"
  }):align(display.CENTER_RIGHT, display.width - 5, display.height * 0.935):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self, 2)
  self:loadUnionInfo()
  self:loadPatrolUI()
  self:addButtons()
end

function M:loadUnionInfo()
  local unionIcon = display.newSprite("union/icon_union.png", 0, 0):align(display.CENTER_LEFT, 35, display.height * 0.945):addTo(self, 2)
  self.mLevelLabel = DYLabelTTF.new({
    text = string.format("LV.%d", CloudData.UNION_INFO.level),
    size = 24,
    color = cc.c3b(255, 194, 9),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(115, unionIcon:getPositionY() + 15):addTo(self, 2)
  DYLabelTTF.new({
    text = CloudData.UNION_INFO.name,
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(270, unionIcon:getPositionY() + 15):addTo(self, 2)
  local barBg = display.newSprite("user_center/bar_bg.png"):align(display.CENTER_LEFT, 110, unionIcon:getPositionY() - 20):addTo(self, 2)
  local currExp = CloudData.UNION_INFO.exp
  local needExp = CloudData.UNION_INFO.upgrade_exp
  self.mExpLabel = DYLabelTTF.new({
    text = currExp .. "/" .. needExp,
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  self.mExpPro = cc.ProgressTimer:create(display.newSprite("user_center/bar_pro.png")):addTo(barBg)
  self.mExpPro:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.mExpPro:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  self.mExpPro:setMidpoint(cc.p(0, 0))
  self.mExpPro:setBarChangeRate(cc.p(1, 0))
  self.mExpPro:setPercentage(currExp / needExp * 100)
  if CloudData.UNION_INFO.level >= UNION_MAX_LEVEL then
    self.mExpLabel:setString("max")
    self.mExpPro:setPercentage(100)
  end
  local sp = display.newSprite("union/contributions.png", 0, 0):align(display.CENTER_LEFT, 140 + barBg:getContentSize().width, barBg:getPositionY()):addTo(self, 2)
  local lbFrame = display.newSprite("union/lb_contri.png", 0, 0):align(display.CENTER_LEFT, sp:getPositionX() + sp:getContentSize().width, sp:getPositionY()):addTo(self, 2)
  self.mContriLabel = DYLabelTTF.new({
    text = CloudData.UNION_CONTRI_NUM,
    size = 22,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):pos(lbFrame:getContentSize().width * 0.6, lbFrame:getContentSize().height * 0.5):addTo(lbFrame, 1)
end

local function newTaskIcon(self)
  local icon = display.newSprite("union/patrol/img_patrol_task_locked.png")
  
  function icon.refresh(target, task, index)
    icon:removeAllChildren()
    if checknumber(task.status) == 0 then
      icon:setTexture("union/patrol/img_patrol_task_locked.png")
    elseif checknumber(task.status) == 4 then
      icon:setTexture("union/patrol/img_patrol_task_gray.png")
      local lab = cc.ui.UILabel.new({
        text = "",
        size = 24,
        color = cc.c3b(255, 255, 255),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER, 130, 38):addTo(icon)
      local time = os.time()
      self:startCountdown(lab, checknumber(task.giveupTime) / 1000 - time - CloudData.DELTA_TIME)
    else
      local info = DataUtils.getPatrolTaskModel(task.taskId)
      if info.quality == 2 then
        icon:setTexture("union/patrol/img_patrol_task_epic.png")
      else
        icon:setTexture("union/patrol/img_patrol_task_normal.png")
      end
      local img
      if checknumber(task.status) == 3 then
        self.mShowTaskNew = true
        img = "union/patrol/img_task_finish.png"
        str = DYLang.getString("U_P_M_COMPLETE", "")
      elseif checknumber(task.status) == 1 then
        img = "union/patrol/img_task_nostart.png"
        str = DYLang.getString("U_P_M_UNDO", "")
      else
        img = "union/patrol/img_task_patrol.png"
        local time = checknumber(task.beginTime) / 1000 - os.time() - CloudData.DELTA_TIME
        str = DataUtils.timeToStr(time, 0, 0)
      end
      display.newSprite(img, 37, 38):scale(0.7):addTo(icon)
      cc.ui.UILabel.new({
        text = str,
        size = 24,
        color = cc.c3b(80, 30, 0),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER, 163, 38):addTo(icon)
    end
  end
  
  return icon
end

function M:loadPatrolUI()
  for i = 1, 3 do
    local bg = display.newSprite("union/patrol/img_patrol_bottom_01.png"):pos(362 * i - 85, 333):addTo(self.mBg)
    display.newSprite("union/patrol/img_patrol_title" .. i .. ".png"):pos(175, 515):addTo(bg)
  end
  for i = 1, 4 do
    local icon = newTaskIcon(self)
    icon:setPosition(276, 550 - 84 * i)
    self.mBg:addChild(icon)
    self.mTaskIcon[i] = icon
  end
  local icon = display.newSprite("common_ui/frame0.png"):pos(638, 441):addTo(self.mBg)
  display.newSprite("wiki/q0.png"):pos(59, 59):addTo(icon)
  local iconFrame = display.newSprite("union/patrol/img_patrol_bottom_02.png"):pos(638, 264):addTo(self.mBg)
  local lab1 = cc.ui.UILabel.new({
    text = DYLang.getString("U_P_R_COUNT", ""),
    size = 24,
    color = cc.c3b(180, 120, 80),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 18, 155):addTo(iconFrame)
  self.mRentCountLab = cc.ui.UILabel.new({
    text = "",
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 25 + lab1:getContentSize().width, 155):addTo(iconFrame)
  local lab2 = cc.ui.UILabel.new({
    text = DYLang.getString("U_P_R_INTEGRAL", ""),
    size = 24,
    color = cc.c3b(180, 120, 80),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 18, 125):addTo(iconFrame)
  self.mRentInteLab = cc.ui.UILabel.new({
    text = "",
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 25 + lab2:getContentSize().width, 125):addTo(iconFrame)
  display.newSprite("union/patrol/img_patrol_aim_pic.png"):pos(1000, 441):addTo(self.mBg)
  local iconFrame1 = display.newSprite("union/patrol/img_patrol_bottom_02.png"):pos(1000, 264):addTo(self.mBg)
  local lab3 = cc.ui.UILabel.new({
    text = DYLang.getString("STR_CUR_PROGRESS", ""),
    size = 24,
    color = cc.c3b(180, 120, 80),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 18, 155):addTo(iconFrame1)
  self.mProgressLab = cc.ui.UILabel.new({
    text = "",
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 23 + lab3:getContentSize().width, 155):addTo(iconFrame1)
  local lab4 = cc.ui.UILabel.new({
    text = DYLang.getString("STR_MY_INTEGRAL", ""),
    size = 24,
    color = cc.c3b(180, 120, 80),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 18, 125):addTo(iconFrame1)
  self.mIntegralLab = cc.ui.UILabel.new({
    text = "",
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 23 + lab4:getContentSize().width, 125):addTo(iconFrame1)
  local lab5 = cc.ui.UILabel.new({
    text = DYLang.getString("STR_NY_RANK", ""),
    size = 24,
    color = cc.c3b(180, 120, 80),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 18, 95):addTo(iconFrame1)
  self.mRankLab = cc.ui.UILabel.new({
    text = "",
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 23 + lab5:getContentSize().width, 95):addTo(iconFrame1)
  local timeStr = DataUtils.timeToStr(self.mGoalTimeLeft, 1, 1)
  local lab6 = cc.ui.UILabel.new({
    text = DYLang.getString("STR_LAST_TIME", ""),
    size = 24,
    color = cc.c3b(180, 120, 80),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 18, 65):addTo(iconFrame1)
  self.mTimeLab = cc.ui.UILabel.new({
    text = "",
    size = 24,
    color = cc.c3b(80, 30, 0),
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(140, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.TOP_LEFT, 23 + lab6:getContentSize().width, 77):addTo(iconFrame1)
end

function M:addButtons()
  local str = {
    "U_P_DETAIL_MISSION",
    "U_P_DETAIL_RENT",
    "U_P_DETAIL_GOAL"
  }
  for i = 1, 3 do
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png",
      disabled = "common_ui/btn_disabled.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString(str[i], ""),
      size = 30,
      color = cc.c3b(255, 246, 102),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(113, 43, 0)
    })):onButtonClicked(function(event)
      self:getDetail(i)
    end):align(display.CENTER, 362 * i - 85, 120):addTo(self.mBg)
  end
end

function M:requestData()
  local function tFuncListener(json)
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif checknumber(json.errorCode) ~= 0 then
      local msg = json.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      self.mMarkTime = checknumber(json.time)
      self:initData(json.data)
    end
  end
  
  local params = {
    clanId = CloudData.UNION_INFO.id,
    clanLevel = CloudData.UNION_INFO.level
  }
  DYHttpMgr.patrolInit(tFuncListener, params)
end

function M:initData(info)
  if not info or type(info) ~= "table" then
    return
  end
  self.mMissions = {}
  for i = 1, 4 do
    self.mMissions[i] = info.patrol and info.patrol["slot" .. i] or {}
    local time = os.time() + CloudData.DELTA_TIME
    if self.mMissions[i].status == 2 and self.mMissions[i].beginTime and time >= math.floor(checknumber(self.mMissions[i].beginTime) / 1000) then
      self.mMissions[i].status = 3
    end
    self.mMissions[i].index = i
  end
  self.mRentCount = checknumber(info.patrol and info.patrol.rentCount)
  self.mRentIntegral = checknumber(info.patrol and info.patrol.rentScore)
  self.mGoalIntegralSum = checknumber(info.totalScore)
  self.mMyIntegral = checknumber(info.patrol and info.patrol.score)
  self.mGoalRank = checknumber(info.rank)
  self.mGoalTimeLeft = checknumber(info.leftTime)
  self.mGoalIntegralMax = DataUtils.getMaxPatrolGoal()
  self.mMaxDistri = checknumber(info.maxScore)
  self.mGoalBox = info.patrol and info.patrol.goalDraw or {}
  self.mRendId = checknumber(info.patrol and info.patrol.buddhaId)
  self:reloadTaskUi()
  self:reloadRentUi()
  self:reloadGoalUi()
  self.mCanBeClicked = true
end

function M:reloadTaskUi()
  if DataUtils.getPatrolTaskUnlocked(4) then
    local temp = self.mMissions[4]
    if not DataUtils.getPatrolTaskUnlocked(2) then
      self.mMissions[4] = self.mMissions[3]
      self.mMissions[3] = self.mMissions[2]
      self.mMissions[2] = temp
    elseif not DataUtils.getPatrolTaskUnlocked(3) then
      self.mMissions[4] = self.mMissions[3]
      self.mMissions[3] = temp
    end
  end
  self.mShowTaskNew = false
  for i = 1, 4 do
    self.mTaskIcon[i]:refresh(self.mMissions[i], i)
  end
  if self.mTaskNewIcon then
    self.mTaskNewIcon:runAction(cc.RemoveSelf:create())
    self.mTaskNewIcon = nil
  end
  if self.mShowTaskNew then
    self.mTaskNewIcon = display.newSprite("common_ui/red_point.png", 346, 138):addTo(self.mBg)
  end
end

function M:reloadRentUi()
  if self.mRentFrame then
    self.mRentFrame:runAction(cc.RemoveSelf:create())
    self.mRentFrame = nil
  end
  if self.mRendId ~= 0 then
    local buddhaModel = DataUtils.getBuddhaModel(self.mRendId)
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality)):pos(638, 441):addTo(self.mBg)
    self.mRentFrame = iconFrame
    local icon = display.newSprite(buddhaModel.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    if 0 == buddhaModel.isRebel then
      icon:setScaleX(-1)
    end
  end
  self.mRentCountLab:setString(self.mRentCount)
  self.mRentInteLab:setString(self.mRentIntegral)
end

function M:reloadGoalUi()
  self.mIntegralLab:setString(self.mMyIntegral)
  if self.mGoalRank > 0 then
    self.mRankLab:setString(self.mGoalRank)
  else
    self.mRankLab:setString(DYLang.getString("S762", ""))
  end
  self.mTimeLab:setString(DataUtils.timeToStr(self.mGoalTimeLeft, 1, 1))
  self.mShowGoalNew = false
  local sum = DataUtils.getPatrolGoalSum()
  local mark = false
  for i = 2, sum do
    local info = DataUtils.getPatrolGoal(i - 1)
    if 0 < info.integral and self.mGoalIntegralSum >= info.integral and checknumber(self.mGoalBox[checkstring(i)]) == 0 then
      self.mShowGoalNew = true
    end
    if not mark and (self.mGoalIntegralSum < info.integral or i == sum) then
      mark = true
      self.mGoalIntegralMax = info.integral
    end
  end
  self.mProgressLab:setString(string.format("%d/%d", self.mGoalIntegralSum, self.mGoalIntegralMax))
  if self.mGoalNewIcon then
    self.mGoalNewIcon:runAction(cc.RemoveSelf:create())
    self.mGoalNewIcon = nil
  end
  if self.mShowGoalNew then
    self.mGoalNewIcon = display.newSprite("common_ui/red_point.png", 1076, 138):addTo(self.mBg)
  end
end

function M:getDetail(idx)
  if not self.mCanBeClicked then
    return
  end
  self.mCanBeClicked = false
  local tFunc = {
    [1] = function()
      self:countdownOver()
      LayerPatrolMission.new(self.mMissions, handler(self, self.updateMissionState)):addTo(self, 20)
    end,
    [2] = function()
      local info = {
        id = self.mRendId
      }
      LayerPatrolRent.new(info, handler(self, self.updateRentState)):addTo(self, 20)
    end,
    [3] = function()
      local info = {
        maxDistri = self.mMaxDistri,
        curPro = self.mGoalIntegralSum,
        maxPro = self.mGoalIntegralMax,
        integral = self.mMyIntegral,
        rank = self.mGoalRank,
        time = DataUtils.timeToStr(self.mGoalTimeLeft, 1, 1),
        box = self.mGoalBox
      }
      LayerPatrolGoal.new(info, handler(self, self.updateGoalState)):addTo(self, 20)
    end
  }
  tFunc[idx]()
  self:performWithDelay(function()
    self.mCanBeClicked = true
  end, 1)
end

function M:updateMissionState(info)
  self:initData(info)
end

function M:updateRentState(id)
  if self.mRentFrame then
    self.mRentFrame:runAction(cc.RemoveSelf:create())
    self.mRentFrame = nil
  end
  self.mRendId = checknumber(id)
  if self.mRendId ~= 0 then
    local buddhaModel = DataUtils.getBuddhaModel(self.mRendId)
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality)):pos(638, 441):addTo(self.mBg)
    self.mRentFrame = iconFrame
    local icon = display.newSprite(buddhaModel.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    if 0 == buddhaModel.isRebel then
      icon:setScaleX(-1)
    end
  end
end

function M:updateGoalState(info, showNew)
  self.mGoalBox = info
  if self.mGoalNewIcon then
    self.mGoalNewIcon:runAction(cc.RemoveSelf:create())
    self.mGoalNewIcon = nil
  end
  self.mShowGoalNew = showNew
  if self.mShowGoalNew then
    self.mGoalNewIcon = display.newSprite("common_ui/red_point.png", 1076, 138):addTo(self.mBg)
  end
end

function M:startCountdown(lab, time)
  if not (lab and lab.setString) or not (checknumber(time) > 0) then
    return
  end
  local t = checknumber(time)
  local h = math.floor(t / 3600)
  t = t % 3600
  local m = math.floor(t / 60)
  local s = math.floor(t % 60)
  lab:setString(string.format("%02d:%02d:%02d", h, m, s))
  self.mScheduler = self:schedule(function()
    lab:setString(string.format("%02d:%02d:%02d", h, m, s))
    if 0 < s then
      s = s - 1
    elseif 0 < m then
      m = m - 1
      s = 59
    elseif 0 < h then
      h = h - 1
      m = 59
      s = 59
    else
      self:countdownOver()
    end
  end, 1)
end

function M:countdownOver()
  if self.mScheduler then
    self:stopAction(self.mScheduler)
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:countdownOver()
  local scene = require("union.scenes.SceneUnion").new()
  display.replaceScene(scene, "FADEDOWN", 0.5)
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
  self:removeAllChildren()
end

return M

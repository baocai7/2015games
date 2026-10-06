local IconItem = require("app.icons.IconItem")
local LayerPatrolTaskInfo = require("app.union.layers.LayerPatrolTaskInfo")
local LayerRule = require("app.layers.LayerRule")
local LayerLackPeach = require("app.layers.LayerLackPeach")
local LayerTip = require("app.babel.layers.LayerTip")
local DYClass = "LayerPatrolMission"
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

function M:ctor(info, callback)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mInfo = info or {}
  self.mTotalInfo = {}
  self.mSelected = 0
  self.mDescLab = nil
  self.mBg = nil
  self.mSelectRing = nil
  self.mTangIcon = nil
  self.mTaskIcons = {}
  self.mScheduler = nil
  self.mRefreshCost = 0
  self.mRefreshLab = nil
  self.mRefreshIcon = nil
  self.mCanBeClicked = false
  self:initUI()
  self:requestData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("union/patrol/img_task_background.jpg", 0, 0):addTo(self.mNode)
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
  self:addContent()
end

function M:addContent()
  local bg = display.newSprite("union/patrol/img_task_tips.png", 401, 60):addTo(self.mBg)
  self.mDescLab = cc.ui.UILabel.new({
    text = "",
    size = 24,
    color = cc.c3b(80, 30, 0),
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(465, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.TOP_LEFT, 45, 95):addTo(bg)
  local strRecom = DYLang.getString("STR_CHECK_DETAIL", "")
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = strRecom,
    size = 30,
    color = cc.c3b(255, 246, 102),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(113, 43, 0)
  })):onButtonClicked(function()
    self:detail()
  end):align(display.CENTER, 1055, 97):addTo(self.mBg)
  self.mSelectRing = display.newSprite("union/patrol/img_task_chosen.png", 0, 0):hide():addTo(self.mBg, 1)
  self.mTangIcon = display.newSprite("stage/mark.png", 0, 0):align(display.CENTER_BOTTOM, 0, 0):hide():addTo(self.mBg)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):onButtonClicked(function()
    self:toRefresh()
  end):align(display.CENTER, 830, 97):addTo(self.mBg)
  self.mRefreshIcon = display.newSprite("item_icon/pic_peach.png", 32, 0):scale(0.6):addTo(btn)
  local str = DYLang.getString("STR_REFRESH", "")
  DYLabelTTF.new({
    text = str,
    size = 30,
    color = cc.c3b(255, 246, 102),
    dyalign = "CENTER_RIGHT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(113, 43, 0)
  }):scale(1.6666666666666667):align(display.CENTER_RIGHT, -10, 27):addTo(self.mRefreshIcon)
  self.mRefreshLab = cc.ui.UILabel.new({
    text = self.mRefreshCost,
    size = 20,
    color = cc.c3b(160, 255, 0),
    font = GameManager.FONTNAME_TTF
  }):scale(1.6666666666666667):align(display.CENTER_LEFT, 57, 27):addTo(self.mRefreshIcon)
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

function M:detail()
  if not self.mCanBeClicked then
    return
  end
  self.mCanBeClicked = false
  if not self.mInfo[self.mSelected] then
    WSToast.new(DYLang.getString("STR_TASK_NULL", "")):addTo(self.mBg, 20)
    self.mCanBeClicked = true
    return
  end
  self:countdownOver()
  local info = {}
  info.task = self.mInfo[self.mSelected]
  info.buddha = info.task.buddhas or {}
  info.rent = checknumber(self.mTotalInfo.patrol and self.mTotalInfo.patrol.buddhaId)
  info.union = self.mTotalInfo.clanList or {}
  for i = 1, #info.union do
    if checknumber(info.union[i].uid) == checknumber(CloudData.UID) then
      table.remove(info.union, i)
      break
    end
  end
  info.rentUsers = self.mTotalInfo.patrol.rentUsers or {}
  local index = checknumber(self.mInfo[self.mSelected] and self.mInfo[self.mSelected].index)
  LayerPatrolTaskInfo.new(info, index, handler(self, self.reloadTaskIcon)):addTo(self, 20)
  self.mCanBeClicked = true
end

function M:toRefresh()
  if not self.mCanBeClicked then
    return
  end
  self.mCanBeClicked = false
  LayerTip.new(DYLang.getString("TIP_PATROL_REFRESH", ""), handler(self, self.refresh)):addTo(self, 20)
  self.mCanBeClicked = true
end

function M:refresh()
  local peach = CloudData.PEACH
  if peach < self.mRefreshCost then
    local tip = LayerLackPeach.new()
    self:addChild(tip, 20)
    return
  end
  
  local function tFuncListener(json)
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif checknumber(json.errorCode) ~= 0 then
      local msg = json.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      dump(json.data)
      DataUtils.updateItemNum(1, checknumber(json.data and json.data.peachLeft))
      self:reloadRefreshData(json.data)
    end
  end
  
  local params = {
    clanId = CloudData.UNION_INFO.id,
    clanLevel = CloudData.UNION_INFO.level
  }
  DYHttpMgr.patrolTaskInit(tFuncListener, params)
end

function M:reloadRefreshData(info)
  if not info or type(info) ~= "table" then
    return
  end
  self:refreshUI()
  self.mInfo = {}
  for i = 1, 4 do
    self.mInfo[i] = info.patrol and info.patrol["slot" .. i] or {}
    local time = os.time() + CloudData.DELTA_TIME
    if self.mInfo[i].status == 2 and self.mInfo[i].beginTime and time >= math.floor(checknumber(self.mInfo[i].beginTime) / 1000) then
      self.mInfo[i].status = 3
    end
    self.mInfo[i].index = i
  end
  self.mTotalInfo.patrol = info.patrol
  if DataUtils.getPatrolTaskUnlocked(4) then
    local temp = self.mInfo[4]
    if not DataUtils.getPatrolTaskUnlocked(2) then
      self.mInfo[4] = self.mInfo[3]
      self.mInfo[3] = self.mInfo[2]
      self.mInfo[2] = temp
    elseif not DataUtils.getPatrolTaskUnlocked(3) then
      self.mInfo[4] = self.mInfo[3]
      self.mInfo[3] = temp
    end
  end
  self.mRefreshCost = checknumber(info.refreshCost)
  self.mRefreshLab:setString(self.mRefreshCost)
  local w = self.mRefreshLab:getContentSize().width
  self.mRefreshIcon:setPositionX(32 - w / 2)
  self:addTasks()
end

function M:reloadTaskIcon()
  self:refreshUI()
  self:requestData()
end

function M:refreshUI()
  for i = 1, 4 do
    if self.mTaskIcons[i] then
      self.mTaskIcons[i]:runAction(cc.RemoveSelf:create())
      self.mTaskIcons[i] = nil
    end
  end
  self.mSelected = 0
  self.mDescLab:setString("")
  self.mSelectRing:setPosition(0, 0)
  self.mSelectRing:hide()
  self.mTangIcon:setPosition(0, 0)
  self.mTangIcon:hide()
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
  self.mInfo = {}
  for i = 1, 4 do
    self.mInfo[i] = info.patrol and info.patrol["slot" .. i] or {}
    local time = os.time() + CloudData.DELTA_TIME
    if self.mInfo[i].status == 2 and self.mInfo[i].beginTime and time >= math.floor(checknumber(self.mInfo[i].beginTime) / 1000) then
      self.mInfo[i].status = 3
    end
    self.mInfo[i].index = i
  end
  self.mTotalInfo = info
  if DataUtils.getPatrolTaskUnlocked(4) then
    local temp = self.mInfo[4]
    if not DataUtils.getPatrolTaskUnlocked(2) then
      self.mInfo[4] = self.mInfo[3]
      self.mInfo[3] = self.mInfo[2]
      self.mInfo[2] = temp
    elseif not DataUtils.getPatrolTaskUnlocked(3) then
      self.mInfo[4] = self.mInfo[3]
      self.mInfo[3] = temp
    end
  end
  self.mRefreshCost = checknumber(info.refreshCost)
  self.mRefreshLab:setString(self.mRefreshCost)
  local w = self.mRefreshLab:getContentSize().width
  self.mRefreshIcon:setPositionX(32 - w / 2)
  self:addTasks()
  self.mCanBeClicked = true
end

function M:addTasks()
  for i = 1, 4 do
    local frame
    local task = self.mInfo[i]
    if checknumber(task.status) == 0 then
      frame = display.newSprite("union/patrol/img_task_locked.jpg", 931, 692 - 122 * i):addTo(self.mBg)
      local unlockTip = DataUtils.getPatrolTaskLockedTip(task.index)
      cc.ui.UILabel.new({
        text = unlockTip,
        size = 24,
        color = cc.c3b(80, 30, 0),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER, 236, 87):addTo(frame)
    elseif checknumber(task.status) == 4 then
      frame = display.newSprite("union/patrol/img_task_gray.jpg", 931, 692 - 122 * i):addTo(self.mBg)
      local lab = cc.ui.UILabel.new({
        text = "",
        size = 24,
        color = cc.c3b(255, 255, 255),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER, 231, 61):addTo(frame)
      local time = os.time()
      self:startCountdown(lab, checknumber(task.giveupTime) / 1000 - time - CloudData.DELTA_TIME)
    else
      local info = DataUtils.getPatrolTaskModel(task.taskId)
      self.mInfo[i].info = info
      if info.quality == 2 then
        frame = cc.ui.UIPushButton.new("union/patrol/img_task_epic.jpg")
      else
        frame = cc.ui.UIPushButton.new("union/patrol/img_task_normal.jpg")
      end
      frame:onButtonClicked(function()
        self:selectTask(i)
      end)
      frame:align(display.CENTER, 931, 692 - 122 * i)
      frame:addTo(self.mBg)
      local rate = 0
      if checknumber(task.status) == 3 then
        display.newSprite("union/patrol/img_task_finish.png", -183, -1):addTo(frame)
        rate = 100
      elseif checknumber(task.status) == 1 then
        display.newSprite("union/patrol/img_task_nostart.png", -183, -1):addTo(frame)
        cc.ui.UILabel.new({
          text = info.timeStr,
          size = 24,
          color = cc.c3b(77, 32, 3),
          font = GameManager.FONTNAME_TTF
        }):align(display.CENTER_RIGHT, 221, -26):addTo(frame)
        rate = 0
      else
        display.newSprite("union/patrol/img_task_patrol.png", -183, -1):addTo(frame)
        local beginTime = checknumber(task.beginTime) / 1000
        local time = math.floor(beginTime) - os.time() - CloudData.DELTA_TIME
        local timeStr = DataUtils.timeToStr(time)
        cc.ui.UILabel.new({
          text = timeStr,
          size = 24,
          color = cc.c3b(200, 0, 0),
          font = GameManager.FONTNAME_TTF
        }):align(display.CENTER_RIGHT, 221, -26):addTo(frame)
        local timeSum = info.timeCost * 3600
        rate = math.floor((timeSum - time) * 100 / timeSum)
        rate = 0 < rate and rate or 0
        rate = rate < 100 and rate or 100
      end
      cc.ui.UILabel.new({
        text = info.name,
        size = 24,
        color = cc.c3b(180, 120, 80),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER_LEFT, -124, 38):addTo(frame)
      cc.ui.UILabel.new({
        text = DYLang.getString("STR_MISSION_INTEGRAL", "") .. info.attribute,
        size = 20,
        color = cc.c3b(80, 30, 0),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER_LEFT, 90, 38):addTo(frame)
      for j = 1, #info.baseAward do
        local icon = IconItem.new(info.baseAward[j])
        icon:setPosition(52 * j + 78 - 231, -23)
        icon:setScale(0.4)
        frame:addChild(icon)
      end
      local barBg = display.newSprite("union/patrol/img_task_bar_01.png"):pos(47, 14):addTo(frame)
      local pro = cc.ProgressTimer:create(display.newSprite("union/patrol/img_task_bar_02.png")):addTo(barBg)
      pro:setType(cc.PROGRESS_TIMER_TYPE_BAR)
      pro:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
      pro:setMidpoint(cc.p(0, 0))
      pro:setBarChangeRate(cc.p(1, 0))
      pro:setPercentage(rate)
      DYLabelTTF.new({
        text = rate .. "%",
        size = 18,
        color = cc.c3b(255, 255, 255),
        font = GameManager.FONTNAME_TTF
      }, {
        lineColor = cc.c3b(0, 0, 0)
      }):align(display.CENTER, barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg)
    end
    self.mTaskIcons[i] = frame
  end
end

function M:selectTask(i)
  if not self.mInfo[i] then
    return
  end
  local info = self.mInfo[i].info or {}
  local str = checkstring(info.desc)
  self.mDescLab:setString(str)
  self.mSelectRing:setPosition(931, 692 - 122 * i)
  self.mSelectRing:show()
  self.mTangIcon:setPosition(checknumber(info.x), checknumber(info.y))
  self.mTangIcon:show()
  self.mSelected = i
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
  if self.mCallback then
    self.mCallback(self.mTotalInfo)
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
end

return M

local NoviceGuide = require("app.utils.NoviceGuide")
local IconActivitySeven = require("app.icons.IconActivitySeven")
local M = {}
M = class("LayerActivitySeven", function()
  return display.newLayer()
end)

local function sortByID(tb)
  for i = 1, #tb do
    for j = 1, #tb - 1 do
      local v1, v2 = tb[j], tb[j + 1]
      if v1.activeId > v2.activeId then
        tb[j], tb[j + 1] = v2, v1
      end
    end
  end
  return tb
end

local function getTimeText(time)
  local day = math.floor(time / 24 / 3600)
  local hour = math.floor((time - day * 24 * 3600) / 3600)
  local minutes = math.floor((time - day * 24 * 3600 - hour * 3600) / 60)
  local seconds = time - day * 24 * 3600 - hour * 3600 - minutes * 60
  local isNeedCountdown = false
  local textStr = ""
  if 0 < day then
    textStr = string.format("%d\229\164\169%d\229\176\143\230\151\182", day, hour)
  elseif 0 < hour then
    textStr = string.format("%02d:%02d", hour, minutes)
  else
    textStr = string.format("%02d:%02d", minutes, seconds)
    isNeedCountdown = true
  end
  return textStr, isNeedCountdown
end

function M:ctor(handler_)
  self.mCallback = handler_
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mBg = display.newSprite("activity/bg_seven.png"):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.94, self.mBg:getContentSize().height * 0.85):addTo(self.mBg, 2)
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  local function tFuncListener(jsonTable)
    self.mModelTable = {}
    
    for k, v in pairs(jsonTable.data.list) do
      local pModel = DataUtils.getSevenActivityModel(k)
      pModel.taskStatus = v
      table.insert(self.mModelTable, pModel)
    end
    self.mModelTable = sortByID(self.mModelTable)
    self.mCloseTime = jsonTable.data.closeTime
    self.mAwardTime = jsonTable.data.awardTime
    self.mDayTime = jsonTable.data.day
    if self.mDayTime > 7 then
      self.mDayTime = 7
    end
    self.mActiviModel = self.mModelTable[self.mDayTime]
    self.mNumList = self:getActiveTaskNum()
    self.mTabIconTable = {}
    self.mTaskTab = {}
    self.mTabTag = self.mDayTime
    self.mTaskTag = 1
    self:initUI()
    self:dealUserProgress()
  end
  
  local countCE = DataUtils.getUserCountCE()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&power=%s&token=%s&uid=%s", strAppSecret .. "", countCE .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.sign = crypto.md5(strSign, false)
  params.power = countCE
  DYHttpMgr.sevenActivityInit(tFuncListener, params)
end

function M:initUI()
  if self.mAwardTime > 0 then
    local textStr, isNeedCountdown = getTimeText(self.mAwardTime)
    self.mTimeLabel2 = DYLabelTTF.new({
      text = textStr,
      size = 21,
      color = cc.c3b(0, 255, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(800, 570):addTo(self.mBg)
    if isNeedCountdown then
      self:startCountDown_(self.mTimeLabel2, self.mAwardTime)
    end
  end
  self:initTabBtn()
  self:layoutActivityUI()
end

function M:initTabBtn()
  for i = 1, #self.mModelTable do
    local btnText = cc.ui.UILabel.new({
      text = self.mModelTable[i].aName,
      size = 30,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    })
    btnText:enableOutline(cc.c4b(66, 29, 5, 255), 2)
    local btn = cc.ui.UIPushButton.new({
      normal = "activity/btn_normal.png",
      pressed = "activity/btn_pressed.png",
      disabled = "activity/btn_pressed.png"
    }):setButtonLabel("normal", btnText):onButtonClicked(function()
      self:funcChange(i)
    end):align(display.CENTER, 188, self.mBg:getContentSize().height * (0.83 - 0.09 * i)):addTo(self.mBg)
    local buddhaId = self.mModelTable[i].buddhaId
    if 0 < buddhaId and i > self.mDayTime then
      local buddhaModel = DataUtils.getBuddhaModelBaseInfo(buddhaId, 1)
      btn.bubble = display.newSprite("activity/bubble.png", -130, 25):addTo(btn)
      local iconFrame = display.newSprite("common_ui/frame" .. buddhaModel.quality .. ".png", 41, 38):scale(0.4):addTo(btn.bubble)
      local icon = display.newSprite(buddhaModel.icon, 59, 59):addTo(iconFrame)
      if 1 == buddhaModel.isRebel then
        icon:setScaleX(-1)
      end
    end
    if self.mDayTime == i then
      btn:setButtonEnabled(false)
    end
    table.insert(self.mTabIconTable, btn)
    if CloudData.ACTIVITY_SEVEN_INFO then
      local index = table.indexof(CloudData.ACTIVITY_SEVEN_INFO, i)
      if index and i <= self.mDayTime then
        btn.newMark = display.newSprite("common_ui/new.png", 70, 20):scale(0.8):addTo(btn)
        btn.newMark:runAction(cc.RepeatForever:create(transition.sequence({
          cc.FadeOut:create(0.5),
          cc.FadeIn:create(0.5)
        })))
      end
    end
  end
end

function M:layoutActivityUI()
  self.mFrame = display.newSprite("activity/frame1.png", 620, 300):addTo(self.mBg)
  self:initTaskTab()
  self.mTaskList = self.mActiviModel.taskIds[1]
  self:initTaskList()
end

function M:initTaskTab()
  local textStr = {
    DYLang.getString("S478", ""),
    DYLang.getString("S479", ""),
    DYLang.getString("S480", ""),
    DYLang.getString("S481", ""),
    DYLang.getString("S482", ""),
    DYLang.getString("S483", ""),
    DYLang.getString("S484", "")
  }
  for i = 1, #self.mActiviModel.aGroup do
    local group = tonumber(self.mActiviModel.aGroup[i])
    local btnText1 = cc.ui.UILabel.new({
      text = textStr[group],
      size = 26,
      color = cc.c3b(255, 223, 175),
      font = GameManager.FONTNAME_TTF
    })
    local btnText2 = cc.ui.UILabel.new({
      text = textStr[group],
      size = 30,
      color = cc.c3b(255, 235, 9),
      font = GameManager.FONTNAME_TTF
    })
    btnText1:enableOutline(cc.c4b(150, 97, 15, 255), 2)
    btnText2:enableOutline(cc.c4b(150, 97, 15, 255), 2)
    local btn = cc.ui.UIPushButton.new({
      normal = "activity/tab_btn1.png",
      pressed = "activity/tab_btn1.png",
      disabled = "activity/tab_btn2.png"
    }):setButtonLabel("normal", btnText1):setButtonLabel("disabled", btnText2):onButtonClicked(function()
      self:taskChange(i)
      if i == 2 then
      end
    end):align(display.CENTER, self.mFrame:getContentSize().width * (0.22 * i - 0.06), self.mFrame:getContentSize().height + 22):addTo(self.mFrame, 1)
    if self.mNumList[i + 1] > 0 then
      btn.redPoint = display.newSprite("common_ui/red_point.png", 55, 10):scale(0.7):addTo(btn)
    end
    if 1 == i then
      self:performWithDelay(function()
        if btn and btn.setButtonEnabled then
          btn:setButtonEnabled(false)
        end
        if btn and btn.redPoint then
          btn.redPoint:setPosition(55, 18)
        end
      end, 0)
    end
    table.insert(self.mTaskTab, btn)
  end
end

function M:initTaskList()
  local countNum = #self.mTaskList
  
  local function sortTable(tb)
    local tb1 = {}
    local tb2 = {}
    for i = 1, #tb do
      local id = tb[i]
      local status = self.mActiviModel.taskStatus[tostring(id)]
      if status == 2 then
        table.insert(tb1, id)
      else
        table.insert(tb2, id)
      end
    end
    table.insertto(tb2, tb1)
    return tb2
  end
  
  self.mTaskList = sortTable(self.mTaskList)
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 10, 588, 380),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchTaskIcon)):addTo(self.mFrame)
  for i = 1, countNum do
    local item = self.mListView:newItem()
    local taskId = self.mTaskList[i]
    local status = self.mActiviModel.taskStatus[tostring(taskId)]
    local icon = IconActivitySeven.new(taskId, status, handler(self, self.onEventActivityTask))
    local content = icon
    item:addContent(content)
    item:setItemSize(582, 150)
    self.mListView:addItem(item)
  end
  self.mListView:reload()
end

function M:funcChange(index)
  if index > self.mDayTime then
    WSToast.new(DYLang.getString("S486", "")):addTo(self, 20)
    return
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mTabTag = index
  self.mTaskTag = 1
  for i = 1, #self.mTabIconTable do
    local icon = self.mTabIconTable[i]
    if index == i then
      icon:setButtonEnabled(false)
    else
      icon:setButtonEnabled(true)
    end
  end
  if self.mFrame then
    self.mFrame:runAction(cc.RemoveSelf:create())
    self.mFrame = nil
    self.mTaskTab = {}
  end
  self.mActiviModel = self.mModelTable[index]
  self.mNumList = self:getActiveTaskNum()
  self:layoutActivityUI()
end

function M:taskChange(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mTaskTag = index
  for i = 1, #self.mTaskTab do
    local icon = self.mTaskTab[i]
    if index == i then
      icon:setButtonEnabled(false)
      if icon.redPoint then
        icon.redPoint:setPosition(55, 18)
      end
    else
      icon:setButtonEnabled(true)
      if icon.redPoint then
        icon.redPoint:setPosition(55, 10)
      end
    end
  end
  if self.mListView then
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
  end
  self.mTaskList = self.mActiviModel.taskIds[index]
  self:initTaskList()
end

function M:getActiveTaskNum()
  local countList = {}
  local sum = 0
  for i = 1, #self.mActiviModel.taskIds do
    local num = 0
    local taskIds = self.mActiviModel.taskIds[i]
    for j = 1, #taskIds do
      local taskId = taskIds[j]
      if 1 == self.mActiviModel.taskStatus[taskId] then
        num = num + 1
        sum = sum + 1
      end
    end
    table.insert(countList, num)
  end
  table.insert(countList, 1, sum)
  return countList
end

function M:onEventActivityTask(params)
  if 0 == params.loadTo then
    local function tFuncListener(jsonTable)
      dump(jsonTable, " jsonTable : ")
      
      if jsonTable.errorCode > 0 then
        local errMsg = jsonTable.errorMsg
        WSToast.new(errMsg):addTo(self, 20)
        return
      end
      DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
      self.mModelTable[self.mTabTag].taskStatus[tostring(params.taskId)] = 2
      params.tar:setButtonEnabled(false)
      self.mNumList[self.mTaskTag + 1] = self.mNumList[self.mTaskTag + 1] - 1
      self.mNumList[1] = self.mNumList[1] - 1
      if 0 == self.mNumList[self.mTaskTag + 1] then
        local taskTab = self.mTaskTab[self.mTaskTag]
        if taskTab.redPoint then
          taskTab.redPoint:runAction(cc.RemoveSelf:create())
          taskTab.redPoint = nil
        end
      end
      if 0 == self.mNumList[1] then
        local activityTab = self.mTabIconTable[self.mTabTag]
        if activityTab.newMark then
          activityTab.newMark:runAction(cc.RemoveSelf:create())
          activityTab.newMark = nil
          table.removebyvalue(CloudData.ACTIVITY_SEVEN_INFO, self.mTabTag)
        end
      end
      local text = DYLang.getString("S24", "")
      for k, v in pairs(jsonTable.data.drop) do
        DataUtils.updateItemNum(k, v)
        local itemModel = DataUtils.getItemModel(k)
        local itemName = itemModel.itemName
        local itemNum = jsonTable.data.dropGain[k]
        text = text .. itemName .. "X" .. itemNum .. "  "
        DYAnalyze.item.get(k, "", itemNum, "7_Activity_reward")
      end
      WSToast.new(text):addTo(self, 20)
    end
    
    local param = {}
    param.taskId = params.taskId
    DYHttpMgr.getSevenActivityAward(tFuncListener, param)
  else
    self:layerTransition(params.loadTo)
  end
end

function M:layerTransition(type_)
  local tFunc = {
    [1] = function()
      require("app.layers.LayerRecharge").new():addTo(self, 20)
    end,
    [2] = function()
      display.replaceScene(require("app.scenes.SceneStage").new())
    end,
    [3] = function()
      require("app.layers.LayerRecharge").new():addTo(self, 20)
    end,
    [4] = function()
      display.replaceScene(require("app.scenes.UpgradeScene").new())
    end
  }
  return tFunc[type_]()
end

function M:touchTabTtn(event)
  local lv = event.listView
  if "clicked" == event.name then
    local idx = event.itemPos
    DDLOG("idx : %d", idx)
    self:funcChange(idx)
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:touchTaskIcon(event)
  local lv = event.listView
  if "clicked" == event.name then
    local idx = event.itemPos
    DDLOG("TaskIcon idx : %d", idx)
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:startCountDown_(target, time)
  if time_ == 0 then
    self:countdownOver_(target)
  else
    target.mMinutes = math.floor(time / 60)
    target.mSeconds = math.floor(time - target.mMinutes * 60)
    target.scheduleTime_ = self:schedule(function()
      self:updateTime_(target)
    end, 1)
  end
end

function M:updateTime_(target)
  if target.mSeconds > 0 then
    target.mSeconds = target.mSeconds - 1
  elseif 0 < target.mMinutes then
    target.mSeconds = 59
    target.mMinutes = target.mMinutes - 1
  else
    self:countdownOver_(target)
  end
  target:setString(string.format("%02d:%02d", target.mMinutes, target.mSeconds))
end

function M:countdownOver_(target)
  self:stopAction(target.scheduleTime_)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
  self:removeSelf()
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
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

function M:dealUserProgress()
end

return M

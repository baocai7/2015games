local IconActivityTask = require("app.icons.IconActivityTask")
local IconActivityBuy = require("app.icons.IconActivityBuy")
local LayerRecharge = require("app.layers.LayerRecharge")
local M = {}
M = class("LayerActivityVIP", function()
  return display.newLayer()
end)
local M_TAB_IMG = {
  [5] = {
    normal = "activity/vip/btn_vip_gift1.png",
    disabled = "activity/vip/btn_vip_gift2.png"
  },
  [6] = {
    normal = "activity/vip/btn_week_gift1.png",
    disabled = "activity/vip/btn_week_gift2.png"
  },
  [7] = {
    normal = "activity/vip/btn_gift1.png",
    disabled = "activity/vip/btn_gift2.png"
  }
}

local function sortByPriority(tb)
  table.sort(tb, function(v1, v2)
    return v1.priority < v2.priority
  end)
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
    textStr = string.format("%d\229\176\143\230\151\182%d\229\136\134", hour, minutes)
  else
    textStr = string.format("%d\229\136\134%d\231\167\146", minutes, seconds)
    isNeedCountdown = true
  end
  return textStr, isNeedCountdown
end

function M:ctor(callback)
  self.mCallback = callback
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initUI()
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  local function tFuncListener(jsonTable)
    self.mModelTable = {}
    
    local activityList = jsonTable.data.list
    for k, v in pairs(activityList) do
      local pModel = {}
      pModel.activeId = v.id
      pModel.priority = v.index
      pModel.aType = v.type
      pModel.closeTime = v.closeTimeSeconds or 0
      pModel.awardTime = v.awardTimeSeconds or 0
      pModel.taskIds = split(v.taskIds, ";") or {}
      pModel.name = v.name or ""
      table.insert(self.mModelTable, pModel)
    end
    self.mModelTable = sortByPriority(self.mModelTable)
    self.mActivityProArr = jsonTable.data.currentProgress
    self.mActiviModel = self.mModelTable[1]
    self.mCountTime = 0
    self.mTabIconTable = {}
    self.mTabTag = 1
    if self.initTabBtn then
      self:initTabBtn()
    end
    if self.layoutActivityUI then
      self:layoutActivityUI()
    end
    self.mSchedule = self:schedule(function()
      self:updateCountTime()
    end, 1)
  end
  
  local countCE = DataUtils.getUserCountCE()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&power=%s&token=%s&uid=%s", strAppSecret .. "", countCE .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.sign = crypto.md5(strSign, false)
  params.power = countCE
  DYHttpMgr.activityVIPList(tFuncListener, params)
end

function M:initUI()
  self.mBg = display.newSprite("activity/vip/bg.png"):addTo(self.mNode)
  display.newSprite("activity/vip/title_vip.png"):pos(self.mBg:getContentSize().width * 0.52, self.mBg:getContentSize().height * 0.89):addTo(self.mBg)
  display.newSprite("activity/vip/pic_vip.png"):pos(self.mBg:getContentSize().width * 0.16, self.mBg:getContentSize().height * 0.24):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.94, self.mBg:getContentSize().height * 0.85):addTo(self.mBg, 2)
end

function M:initTabBtn()
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(92, 300, 230, 245),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchTabTtn)):addTo(self.mBg, 1)
  for i = 1, #self.mModelTable do
    local item = listView:newItem()
    local pModel = self.mModelTable[i]
    local icon = display.newSprite(M_TAB_IMG[pModel.priority].normal)
    if 1 == i then
      icon:setTexture(M_TAB_IMG[pModel.priority].disabled)
    end
    table.insert(self.mTabIconTable, icon)
    local content = icon
    item:addContent(content)
    item:setItemSize(230, 80)
    listView:addItem(item)
    if CloudData.ACTIVITY_VIP_INFO then
      local index = table.indexof(CloudData.ACTIVITY_VIP_INFO, pModel.activeId)
      if index then
        icon.redPoint = display.newSprite("common_ui/red_point.png", 20, 50):addTo(icon)
      end
    end
  end
  listView:reload()
end

function M:layoutActivityUI()
  local tFunc = {
    [5] = function()
      self:activityBuyUI()
    end,
    [6] = function()
      self:activityTaskUI()
    end,
    [7] = function()
      self:activityBuyUI()
    end
  }
  local aType = self.mActiviModel.aType
  tFunc[aType]()
end

function M:activityTaskUI()
  self.mActiveNum = 0
  local activityId = self.mActiviModel.activeId
  local activityData = self.mActivityProArr[tostring(activityId)]
  self.mFrame = display.newSprite("activity/frame.png", 619, 324):addTo(self.mBg)
  if 0 < self.mActiviModel.closeTime then
    local frame = display.newSprite("activity/label4.png"):align(display.CENTER_LEFT, 0, self.mFrame:getContentSize().height + 20):addTo(self.mFrame)
    local textStr, isNeedCountdown = getTimeText(self.mActiviModel.closeTime - self.mCountTime)
    self.mTimeLabel1 = DYLabelTTF.new({
      text = textStr,
      size = 21,
      color = cc.c3b(0, 255, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(frame:getPositionX() + frame:getContentSize().width, frame:getPositionY()):addTo(self.mFrame)
    if isNeedCountdown then
      self:startCountDown_(self.mTimeLabel1, self.mActiviModel.closeTime - self.mCountTime)
    end
  end
  if 0 < self.mActiviModel.awardTime then
    local frame = display.newSprite("activity/label5.png"):align(display.CENTER_LEFT, 360, self.mFrame:getContentSize().height + 20):addTo(self.mFrame)
    local textStr, isNeedCountdown = getTimeText(self.mActiviModel.awardTime - self.mCountTime)
    self.mTimeLabel2 = DYLabelTTF.new({
      text = textStr,
      size = 21,
      color = cc.c3b(0, 255, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(frame:getPositionX() + frame:getContentSize().width, frame:getPositionY()):addTo(self.mFrame)
    if isNeedCountdown then
      self:startCountDown_(self.mTimeLabel2, self.mActiviModel.awardTime - self.mCountTime)
    end
  end
  local countNum = #self.mActiviModel.taskIds
  
  local function sortTable(tb)
    local tb1 = {}
    local tb2 = {}
    for i = 1, #tb do
      local id = tb[i]
      local status = activityData[tostring(id)].isDraw
      if 0 < status then
        table.insert(tb1, id)
      else
        table.insert(tb2, id)
      end
    end
    table.insertto(tb2, tb1)
    return tb2
  end
  
  self.mActiviModel.taskIds = sortTable(self.mActiviModel.taskIds)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 5, 588, 460),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchTaskIcon)):addTo(self.mFrame)
  for i = 1, countNum do
    local item = listView:newItem()
    local taskId = self.mActiviModel.taskIds[i]
    local taskInfo = activityData[tostring(taskId)]
    local params = {taskId = taskId, taskInfo = taskInfo}
    local icon = IconActivityTask.new(params, handler(self, self.onEventActivityTask))
    local content = icon
    item:addContent(content)
    item:setItemSize(582, 150)
    listView:addItem(item)
    if icon.mIsActive then
      self.mActiveNum = self.mActiveNum + 1
    end
  end
  listView:reload()
end

function M:activityBuyUI()
  self.mFrame = display.newSprite("activity/frame.png", 619, 324):addTo(self.mBg)
  if self.mActiviModel.closeTime > 0 then
    local frame = display.newSprite("activity/label4.png"):align(display.CENTER_LEFT, 360, self.mFrame:getContentSize().height + 20):addTo(self.mFrame)
    local textStr, isNeedCountdown = getTimeText(self.mActiviModel.closeTime - self.mCountTime)
    self.mTimeLabel1 = DYLabelTTF.new({
      text = textStr,
      size = 21,
      color = cc.c3b(0, 255, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(frame:getPositionX() + frame:getContentSize().width, frame:getPositionY()):addTo(self.mFrame)
    if isNeedCountdown then
      self:startCountDown_(self.mTimeLabel1, self.mActiviModel.closeTime - self.mCountTime)
    end
  end
  local countNum = #self.mActiviModel.taskIds
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 5, 588, 460),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchTaskIcon)):addTo(self.mFrame)
  for i = 1, countNum do
    local item = listView:newItem()
    local activityId = self.mActiviModel.activeId
    local taskId = self.mActiviModel.taskIds[i]
    local taskInfo = self.mActivityProArr[tostring(activityId)][tostring(taskId)]
    local params = {taskId = taskId, taskInfo = taskInfo}
    local icon = IconActivityBuy.new(params, handler(self, self.onEventActivityBuy))
    local content = icon
    item:addContent(content)
    item:setItemSize(582, 150)
    listView:addItem(item)
  end
  listView:reload()
end

function M:funcChange(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mTabTag = index
  for i = 1, #self.mModelTable do
    local pModel = self.mModelTable[i]
    local icon = self.mTabIconTable[i]
    if index == i then
      icon:setTexture(M_TAB_IMG[pModel.priority].disabled)
    else
      icon:setTexture(M_TAB_IMG[pModel.priority].normal)
    end
  end
  if self.mTimeLabel1 and self.mTimeLabel1.scheduleTime_ then
    self:stopAction(self.mTimeLabel1.scheduleTime_)
  end
  if self.mTimeLabel2 and self.mTimeLabel2.scheduleTime_ then
    self:stopAction(self.mTimeLabel2.scheduleTime_)
  end
  if self.mFrame then
    self.mFrame:runAction(cc.RemoveSelf:create())
    self.mFrame = nil
  end
  self.mActiviModel = self.mModelTable[index]
  self:layoutActivityUI()
  local id = self.mActiviModel.activeId or 0
end

function M:onEventActivityTask(params)
  if 0 == params.loadTo then
    local function tFuncListener(jsonTable)
      if jsonTable.errorCode > 0 then
        local errMsg = jsonTable.errorMsg
        
        WSToast.new(errMsg):addTo(self, 20)
        return
      end
      DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
      local activityId = tostring(self.mActiviModel.activeId)
      local taskId = tostring(params.taskId)
      self.mActivityProArr[activityId][taskId].isDraw = 1
      params.tar:setButtonEnabled(false)
      self.mActiveNum = self.mActiveNum - 1
      if 0 == self.mActiveNum then
        self:updateActivityStatus()
      end
      local text = DYLang.getString("S24", "")
      for k, v in pairs(jsonTable.data.drop) do
        DataUtils.updateItemNum(k, v)
        local itemModel = DataUtils.getItemModel(k)
        local itemName = itemModel.itemName
        local itemNum = jsonTable.data.dropGain[k]
        text = text .. itemName .. "X" .. itemNum .. "  "
        DYAnalyze.item.get(k, "", itemNum, "Activity_reward")
      end
      WSToast.new(text):addTo(self, 20)
    end
    
    local param = {}
    param.activityId = self.mActiviModel.activeId
    param.taskId = params.taskId
    DYHttpMgr.getTaskActivityAward(tFuncListener, param)
  else
    self:layerTransition(params.loadTo)
  end
end

function M:onEventActivityBuy(params)
  local function tFuncListener(jsonTable)
    dump(jsonTable, " jsonTable : ")
    
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
    local buyTimes = jsonTable.data.buyTimes
    local limitTimes = jsonTable.data.limitTimes
    DataUtils.updateItemNum(tostring(params.thingId), jsonTable.data.thingLeft)
    local activityId = tostring(self.mActiviModel.activeId)
    local taskId = tostring(params.taskId)
    self.mActivityProArr[activityId][taskId].isDraw = buyTimes
    if buyTimes >= limitTimes or jsonTable.data.thingLeft < params.thingNum then
      params.tar:setButtonEnabled(false)
    end
    params.text:setString(string.format("%d/%d", limitTimes - buyTimes, limitTimes))
    local text = DYLang.getString("S24", "")
    for k, v in pairs(jsonTable.data.drop) do
      DataUtils.updateItemNum(k, v)
      local itemModel = DataUtils.getItemModel(k)
      local itemName = itemModel.itemName
      local itemNum = jsonTable.data.dropGain[k]
      text = text .. itemName .. "X" .. itemNum .. "  "
      DYAnalyze.item.get(k, "", itemNum, "Activity_buy")
    end
    WSToast.new(text):addTo(self, 20)
  end
  
  local param = {}
  param.activityId = self.mActiviModel.activeId
  param.taskId = params.taskId
  DYHttpMgr.getBuyActivityAward(tFuncListener, param)
end

function M:updateActivityStatus()
  local tabIcon = self.mTabIconTable[self.mTabTag]
  if tabIcon.redPoint then
    tabIcon.redPoint:runAction(cc.RemoveSelf:create())
    tabIcon.redPoint = nil
    table.removebyvalue(CloudData.ACTIVITY_VIP_INFO, self.mActiviModel.activeId)
  end
end

function M:layerTransition(type_)
  local tFunc = {
    [1] = function()
      require("app.layers.LayerRecharge").new():addTo(self, 20)
    end,
    [3] = function()
      require("app.layers.LayerRecharge").new():addTo(self, 20)
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

function M:updateCountTime()
  self.mCountTime = self.mCountTime + 1
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
  target:setString(string.format("%d\229\136\134%d\231\167\146", target.mMinutes, target.mSeconds))
end

function M:countdownOver_(target)
  self:stopAction(target.scheduleTime_)
end

function M:closeCallBack()
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
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYRes.unloadSheet("activity/food_tx1.plist")
  DYRes.unloadSheet("activity/food_tx2.plist")
end

return M

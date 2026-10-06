local IconActivityTask = require("app.icons.IconActivityTask")
local IconActivityBuy = require("app.icons.IconActivityBuy")
local IconActivityShare = require("app.icons.IconActivityShare")
local IconActivityCard = require("app.icons.IconActivityCard")
local LayerRecharge = require("app.layers.LayerRecharge")
local M = {}
local CLASS_NAME = "LayerActivity"
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local M_TAB_IMG = {
  [1] = {
    normal = "activity/btn_normal17.png",
    disabled = "activity/btn_disabled17.png"
  },
  [2] = {
    normal = "activity/btn_normal23.png",
    disabled = "activity/btn_disabled23.png"
  },
  [3] = {
    normal = "activity/btn_normal1.png",
    disabled = "activity/btn_disabled1.png"
  },
  [4] = {
    normal = "activity/btn_normal2.png",
    disabled = "activity/btn_disabled2.png"
  },
  [8] = {
    normal = "activity/btn_normal5.png",
    disabled = "activity/btn_disabled5.png"
  },
  [9] = {
    normal = "activity/btn_normal6.png",
    disabled = "activity/btn_disabled6.png"
  },
  [10] = {
    normal = "activity/btn_normal7.png",
    disabled = "activity/btn_disabled7.png"
  },
  [11] = {
    normal = "activity/btn_normal14.png",
    disabled = "activity/btn_disabled14.png"
  },
  [12] = {
    normal = "activity/btn_normal8.png",
    disabled = "activity/btn_disabled8.png"
  },
  [13] = {
    normal = "activity/btn_normal9.png",
    disabled = "activity/btn_disabled9.png"
  },
  [14] = {
    normal = "activity/btn_normal10.png",
    disabled = "activity/btn_disabled10.png"
  },
  [15] = {
    normal = "activity/btn_normal13.png",
    disabled = "activity/btn_disabled13.png"
  },
  [16] = {
    normal = "activity/btn_normal12.png",
    disabled = "activity/btn_disabled12.png"
  },
  [17] = {
    normal = "activity/btn_normal15.png",
    disabled = "activity/btn_disabled15.png"
  },
  [18] = {
    normal = "activity/btn_normal16.png",
    disabled = "activity/btn_disabled16.png"
  },
  [19] = {
    normal = "activity/btn_normal18.png",
    disabled = "activity/btn_disabled18.png"
  },
  [20] = {
    normal = "activity/btn_normal20.png",
    disabled = "activity/btn_disabled20.png"
  },
  [22] = {
    normal = "activity/btn_normal19.png",
    disabled = "activity/btn_disabled19.png"
  }
}

local function sortByPriority(tb)
  for i = 1, #tb do
    for j = 1, #tb - 1 do
      local v1, v2 = tb[j], tb[j + 1]
      if v1.priority > v2.priority then
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
    textStr = string.format("%d\229\176\143\230\151\182%d\229\136\134", hour, minutes)
  else
    textStr = string.format("%d\229\136\134%d\231\167\146", minutes, seconds)
    isNeedCountdown = true
  end
  return textStr, isNeedCountdown
end

function M:ctor(handler_)
  self.mCallback = handler_
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  DYRes.loadSheet("activity/food_tx1.plist")
  DYRes.loadSheet("activity/food_tx2.plist")
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
      pModel.taskStatus = v.taskStatus or {}
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
  DYHttpMgr.activityList(tFuncListener, params)
end

function M:initUI()
  self.mBg = display.newSprite("activity/bg.png"):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.94, self.mBg:getContentSize().height * 0.85):addTo(self.mBg, 2)
end

function M:initTabBtn()
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(92, 112, 230, 428),
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
    if CloudData.ACTIVITY_INFO then
      local index = table.indexof(CloudData.ACTIVITY_INFO, pModel.activeId)
      if index then
        icon.redPoint = display.newSprite("common_ui/red_point.png", 20, 50):addTo(icon)
      end
    end
  end
  listView:reload()
end

function M:layoutActivityUI()
  local tFunc = {
    [1] = function()
      self:activityTaskUI()
    end,
    [2] = function()
      self:activityBuyUI()
    end,
    [3] = function()
      self:monthCardUI()
    end,
    [4] = function()
      self:mealUI()
    end,
    [5] = function()
      self:activityBuyUI()
    end,
    [6] = function()
      self:activityTaskUI()
    end,
    [7] = function()
      self:activityTaskUI()
    end,
    [8] = function()
      self:shareGiftUI()
    end,
    [9] = function()
      self:activityTaskUI()
    end,
    [10] = function()
      self:activityBuyUI()
    end,
    [11] = function()
      self:activityTaskUI()
    end,
    [12] = function()
      self:doubleAwardsUI()
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

function M:monthCardUI()
  self.mFrame = display.newSprite("activity/frame.png", 619, 324):addTo(self.mBg)
  self.mCardList = {}
  self.mCardActiveNum = 0
  local activityId = self.mActiviModel.activeId
  local activityData = self.mActivityProArr[tostring(activityId)]
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 10, 588, 450),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(self.mFrame)
  for i = 1, 3 do
    local item = listView:newItem()
    local content = IconActivityCard.new(i, activityData, handler(self, self.onEventMonthCard))
    item:addContent(content)
    item:setItemSize(240, 450)
    listView:addItem(item)
    if content.mIsActive == true then
      self.mCardActiveNum = self.mCardActiveNum + 1
    end
    table.insert(self.mCardList, content)
  end
  listView:reload()
end

function M:mealUI()
  local activityId = self.mActiviModel.activeId
  local activityData = self.mActivityProArr[tostring(activityId)]
  local status = activityData.rice.isDraw
  local isValid = activityData.rice.finishedValue
  local params = {status = status, isValid = isValid}
  self.isClicked = false
  self.mFrame = display.newSprite("activity/frame.png", 619, 324):addTo(self.mBg)
  local bg = display.newSprite("activity/energy.png"):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame)
  self.mFoodBg = bg
  self.mFoodPic = display.newSprite("activity/food.png", 274, 86):addTo(bg)
  self.mFoodPic:setTouchEnabled(true)
  self.mFoodPic:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      return true
    end
    if name == "ended" then
      self:onEventDailyFood(params)
    end
  end)
  if 0 == status and 1 == isValid then
    local frames = display.newFrames("zhaifanxingxing%d.png", 1, 19)
    local animation = display.newAnimation(frames, 0.1)
    local emptyPic = display.newSprite():pos(self.mFoodPic:getContentSize().width * 0.5 - 10, self.mFoodPic:getContentSize().height * 0.56):addTo(self.mFoodPic, 1)
    emptyPic:playAnimationForever(animation, 0)
    self.mFinger = display.newSprite("activity/finger.png", 280, 180):addTo(bg, 1)
    local point1 = cc.p(280, 150)
    local point2 = cc.p(280, 180)
    self.mFinger:runAction(cc.RepeatForever:create(transition.sequence({
      cc.MoveTo:create(0.6, point1),
      cc.MoveTo:create(0.6, point2)
    })))
  end
end

function M:premiumGiftUI()
  self.mFrame = display.newSprite("activity/frame.png", 619, 324):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "activity/pic_gift.png",
    pressed = "activity/pic_gift.png"
  }):onButtonClicked(function()
    require("app.layers.LayerRecharge").new(2):addTo(self, 20)
  end):align(display.CENTER, self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame)
end

function M:shareGiftUI()
  self.mActiveNum = 0
  local activityId = self.mActiviModel.activeId
  local activityData = self.mActivityProArr[tostring(activityId)]
  self.mFrame = display.newSprite("activity/frame.png", 619, 324):addTo(self.mBg)
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
    local icon = IconActivityShare.new(params, handler(self, self.onEventShareTask))
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

function M:doubleAwardsUI()
  local descStrs = {
    [1] = DYLang.getString("S466", ""),
    [2] = DYLang.getString("S467", ""),
    [3] = DYLang.getString("S468", "")
  }
  local transitionTypes = {
    8,
    5,
    4
  }
  local tType = transitionTypes[tonumber(CloudData.DOUBLE_ACTIVITY.type)]
  self.mFrame = display.newSprite("activity/frame.png", 619, 324):addTo(self.mBg)
  local btn = cc.ui.UIPushButton.new({
    normal = "activity/pic_double.png",
    pressed = "activity/pic_double.png"
  }):onButtonClicked(function()
    self:layerTransition(tType)
  end):align(display.CENTER, self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame)
  DYLabelTTF.new({
    text = CloudData.DOUBLE_ACTIVITY.openTime,
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(32, -27):addTo(btn)
  local desc = descStrs[tonumber(CloudData.DOUBLE_ACTIVITY.type)]
  DYLabelTTF.new({
    text = desc,
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "TOP_LEFT",
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(235, 90)
  }):pos(32, -50):addTo(btn)
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

function M:onEventMonthCard(params)
  if params.leftDays <= 0 then
    LayerRecharge.new():addTo(self, 20)
    return
  end
  local tFunc = {
    [1] = function()
      self:cardListener1(params)
    end,
    [2] = function()
      self:cardListener2(params)
    end,
    [3] = function()
      self:cardListener3(params)
    end
  }
  tFunc[params.taskId]()
end

function M:cardListener1(params)
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKONWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
    local activityId = tostring(self.mActiviModel.activeId)
    local taskId = tostring(params.taskId)
    self.mActivityProArr[activityId][taskId].finishedValue = jsonTable.data.leftDays
    self.mActivityProArr[activityId][taskId].isDraw = 1
    local card = self.mCardList[tonumber(taskId)]
    card:updateUI({
      leftDays = jsonTable.data.leftDays
    })
    CloudData.PEACH = jsonTable.data.peach
    self.mCardActiveNum = self.mCardActiveNum - 1
    if 0 == self.mCardActiveNum then
      self:updateActivityStatus()
    end
  end
  
  DYHttpMgr.getWeekCardAward(tFuncListener)
end

function M:cardListener2(params)
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKONWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
    local activityId = tostring(self.mActiviModel.activeId)
    local taskId = tostring(params.taskId)
    self.mActivityProArr[activityId][taskId].finishedValue = jsonTable.data.leftDays
    self.mActivityProArr[activityId][taskId].isDraw = 1
    local card = self.mCardList[tonumber(taskId)]
    card:updateUI({
      leftDays = jsonTable.data.leftDays
    })
    CloudData.PEACH = jsonTable.data.peach
    self.mCardActiveNum = self.mCardActiveNum - 1
    if 0 == self.mCardActiveNum then
      self:updateActivityStatus()
    end
  end
  
  DYHttpMgr.getMonthCardAward(tFuncListener)
end

function M:cardListener3(params)
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKONWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    local activityId = tostring(self.mActiviModel.activeId)
    local taskId = tostring(params.taskId)
    self.mActivityProArr[activityId][taskId].isDraw = 1
    local card = self.mCardList[tonumber(taskId)]
    card:updateUI({})
    CloudData.PEACH = jsonTable.data.peach
    self.mCardActiveNum = self.mCardActiveNum - 1
    if 0 == self.mCardActiveNum then
      self:updateActivityStatus()
    end
  end
  
  DYHttpMgr.getWelfareAward(tFuncListener)
end

function M:onEventDailyFood(params)
  if 0 == params.isValid or 1 == params.status or self.isClicked then
    return
  end
  self.isClicked = true
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKONWN"
      WSToast.new(errMsg):addTo(self, 20)
      self.isClicked = false
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_dinner)
    local frames = display.newFrames("xing%d.png", 1, 16)
    local animation = display.newAnimation(frames, 0.1)
    local emptyPic = display.newSprite():pos(270, 80):addTo(self.mFoodBg, 1)
    emptyPic:playAnimationOnce(animation, true)
    self.mFoodPic:runAction(transition.sequence({
      cc.FadeOut:create(1),
      cc.CallFunc:create(function()
        self.mFoodPic:removeSelf()
        self.isClicked = false
      end)
    }))
    self.mFinger:runAction(transition.sequence({
      cc.FadeOut:create(1),
      cc.CallFunc:create(function()
        self.mFinger:removeSelf()
      end)
    }))
    local activityId = tostring(self.mActiviModel.activeId)
    self.mActivityProArr[activityId].rice.isDraw = 1
    self:updateActivityStatus()
    local rewardList = {}
    for k, v in pairs(jsonTable.data.rewardGain) do
      local itemId = tonumber(k)
      local rewardNum = tonumber(v)
      local tb = {itemId = itemId, rewardNum = rewardNum}
      table.insert(rewardList, tb)
    end
    for id, num in pairs(jsonTable.data.reward) do
      DataUtils.updateItemNum(id, num)
    end
    for i = 1, #rewardList do
      local tb = rewardList[i]
      local pic = display.newSprite("item_icon/pic_energy.png", 270, 120):opacity(0):scale(0):addTo(self.mFoodBg, 1)
      local label = DYLabelTTF.new({
        text = "+" .. tb.rewardNum,
        size = 30,
        color = display.COLOR_GREEN,
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }, {}):pos(pic:getContentSize().width + 10, pic:getContentSize().height * 0.5):addTo(pic)
      if 1 == tb.itemId then
        pic:setTexture("item_icon/pic_peach.png")
      end
      local spawn1 = cc.Spawn:create(cc.FadeIn:create(0.5), cc.ScaleTo:create(0.5, 1))
      local spawn2 = cc.Spawn:create(cc.MoveTo:create(0.5, cc.p(270, 220)), cc.FadeOut:create(0.5))
      pic:runAction(transition.sequence({
        cc.DelayTime:create(i - 0.5),
        spawn1,
        cc.DelayTime:create(0.5),
        spawn2,
        cc.CallFunc:create(function()
          pic:removeSelf()
        end)
      }))
    end
  end
  
  DYHttpMgr.getDailyFood(tFuncListener)
end

function M:onEventShareTask(params)
  if 0 < params.loadTo then
    self:layerTransition(params.loadTo)
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    if not self.class or self.class.__cname ~= CLASS_NAME then
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
end

function M:updateActivityStatus()
  local tabIcon = self.mTabIconTable[self.mTabTag]
  if tabIcon.redPoint then
    tabIcon.redPoint:runAction(cc.RemoveSelf:create())
    tabIcon.redPoint = nil
    table.removebyvalue(CloudData.ACTIVITY_INFO, self.mActiviModel.activeId)
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
    end,
    [5] = function()
      if not GameManager.IS_CHAT_LOGIN_OK then
        WSToast.new("PVP\229\136\157\229\167\139\229\140\150\230\156\170\229\174\140\230\136\144"):addTo(self, 100)
      else
        require("app.layers.LayerPVPEntrance").new():addTo(self, 20)
      end
    end,
    [6] = function()
      require("app.layers.LayerSign").new():addTo(self, 20)
    end,
    [7] = function()
      if CloudData.USER_LEVEL >= Const.FUNC_UNLOCK.summon then
        display.replaceScene(require("app.scenes.SceneSummon").new())
      else
        local str = DYLang.getString("S474", "") .. Const.FUNC_UNLOCK.summon .. DYLang.getString("S475", "")
        WSToast.new(str):addTo(self, 50)
      end
    end,
    [8] = function()
      require("app.layers.LayerDungeon").new():addTo(self, 20)
    end,
    [9] = function()
      if CloudData.USER_LEVEL >= Const.FUNC_UNLOCK.cimelia then
        display.replaceScene(require("app.cimelia.scenes.SceneCimelia").new())
      else
        local str = DYLang.getString("S474", "") .. Const.FUNC_UNLOCK.cimelia .. DYLang.getString("S475", "")
        WSToast.new(str):addTo(self, 50)
      end
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

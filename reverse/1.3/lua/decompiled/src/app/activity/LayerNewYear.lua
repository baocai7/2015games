local IconActivity = require("app.activity.IconActivity")
local LayerRule = require("app.layers.LayerRule")
local M = {}
M = class("LayerNewYear", function()
  return display.newLayer()
end)
local M_TAB_IMG = {
  {
    normal = "#btn_normal1.png",
    disabled = "#btn_disabled1.png"
  },
  {
    normal = "#btn_normal3.png",
    disabled = "#btn_disabled3.png"
  }
}

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

local function getSkillTip(skillModel)
  local frame = display.newScale9Sprite("common_ui/toast.png", 0, 0, cc.size(375, 150), cc.rect(40, 30, 1, 1))
  local skillFrame = display.newSprite("common_ui/frame1.png"):scale(0.85):pos(frame:getContentSize().width * 0.17, frame:getContentSize().height * 0.5):addTo(frame)
  local skillIcon = display.newSprite(skillModel.skillIcon):pos(skillFrame:getContentSize().width * 0.5, skillFrame:getContentSize().height * 0.5):addTo(skillFrame)
  local skillName = DYLabelTTF.new({
    text = skillModel.skillName,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(103, 70, 22)
  }):pos(frame:getContentSize().width * 0.31, frame:getContentSize().height * 0.72):addTo(frame)
  DYLabelTTF.new({
    text = string.format(skillModel.skillDesc, unpack(skillModel.effectTable)),
    size = 20,
    color = cc.c3b(255, 216, 5),
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(240, 75),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(frame:getContentSize().width * 0.31, frame:getContentSize().height * 0.36):addTo(frame)
  return frame
end

function M:ctor(handler_)
  self.mCallback = handler_
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initData()
  self.mCountTime = 0
  self.mSchedule = self:schedule(function()
    self:updateCountTime()
  end, 1)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  DYRes.loadSheet("new_year/ui_new_year.plist")
  
  local function tFuncListener(jsonTable)
    local activityData = jsonTable.data
    self.mActivityCloseTime = activityData.closeTimeSeconds
    self.mAwardCloseTime = activityData.awardTimeSeconds
    self.mActivityList = {
      activityData.cssl,
      activityData.dlhl
    }
    self.mLoginDays = activityData.days
    self.mCountMoney = activityData.money
    self.mTabIconTable = {}
    self.mActiveNum = 0
    self.mTabTag = 1
    self:initUI()
    self:initTabBtn()
    self.mActivityModel = self.mActivityList[1]
    self:activityUI1()
  end
  
  DYHttpMgr.initNewYearActivity(tFuncListener)
end

function M:initUI()
  local bg = display.newSprite("new_year/bg_newyear.png"):addTo(self.mNode)
  self.mBg = bg
  display.newSprite("#title_newyear.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.94):addTo(bg)
  display.newSprite("#tang_pic.png"):pos(bg:getContentSize().width * 0.16, bg:getContentSize().height * 0.2):addTo(bg)
  local frame = display.newSprite("activity/label4.png"):align(display.CENTER_LEFT, bg:getContentSize().width * 0.32, bg:getContentSize().height * 0.82):addTo(bg)
  local textStr, isNeedCountdown = getTimeText(self.mActivityCloseTime - self.mCountTime)
  self.mTimeLabel1 = DYLabelTTF.new({
    text = textStr,
    size = 21,
    color = cc.c3b(0, 255, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(frame:getPositionX() + frame:getContentSize().width, frame:getPositionY()):addTo(bg)
  if isNeedCountdown then
    self:startCountDown_(self.mTimeLabel1, self.mActivityCloseTime - self.mCountTime)
  end
  local frame = display.newSprite("activity/label5.png"):align(display.CENTER_LEFT, bg:getContentSize().width * 0.64, bg:getContentSize().height * 0.82):addTo(bg)
  local textStr, isNeedCountdown = getTimeText(self.mAwardCloseTime - self.mCountTime)
  self.mTimeLabel2 = DYLabelTTF.new({
    text = textStr,
    size = 21,
    color = cc.c3b(0, 255, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(frame:getPositionX() + frame:getContentSize().width, frame:getPositionY()):addTo(bg)
  if isNeedCountdown then
    self:startCountDown_(self.mTimeLabel2, self.mAwardCloseTime - self.mCountTime)
  end
  LayerRule.newRuleIcon(LayerRule.NEWYEAR):align(display.CENTER, self.mBg:getContentSize().width * 0.07, self.mBg:getContentSize().height * 0.87):addTo(self.mBg, 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.96, self.mBg:getContentSize().height * 0.92):addTo(self.mBg, 2)
end

function M:initTabBtn()
  local frame = display.newScale9Sprite("#frame_tab.png", 0, 0, cc.size(190, 290), cc.rect(40, 40, 1, 1)):pos(self.mBg:getContentSize().width * 0.18, self.mBg:getContentSize().height * 0.58):addTo(self.mBg)
  for i = 1, #M_TAB_IMG do
    local btn = cc.ui.UIPushButton.new(M_TAB_IMG[i]):onButtonClicked(function()
      self:funcChange(i)
    end):align(display.CENTER, frame:getContentSize().width * 0.5, frame:getContentSize().height * (1.1 - 0.3 * i)):addTo(frame)
    if 1 == i then
      btn:setButtonEnabled(false)
    end
    local index = table.indexof(CloudData.ACTIVITY_NEW_YEAR, i)
    if index then
      btn.redPoint = display.newSprite("common_ui/red_point.png", 72, 18):addTo(btn)
    end
    table.insert(self.mTabIconTable, btn)
  end
end

function M:layoutActivityUI(idx)
  local tFunc = {
    [1] = function()
      self:activityUI1()
    end,
    [2] = function()
      self:activityUI3()
    end
  }
  tFunc[idx]()
end

function M:activityUI1()
  self.mFrame = display.newScale9Sprite("#frame.png", 0, 0, cc.size(680, 454), cc.rect(40, 40, 1, 1)):pos(self.mBg:getContentSize().width * 0.595, self.mBg:getContentSize().height * 0.46):addTo(self.mBg)
  table.sort(self.mActivityModel, function(v1, v2)
    return v1.id < v2.id
  end)
  
  local function sortTable(tb)
    local tb1 = {}
    local tb2 = {}
    for i = 1, #tb do
      local data = tb[i]
      if 2 == data.status then
        table.insert(tb1, data)
      else
        table.insert(tb2, data)
      end
    end
    table.insertto(tb2, tb1)
    return tb2
  end
  
  self.mActivityModel = sortTable(self.mActivityModel)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 10, 650, 434),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mFrame)
  for i = 1, #self.mActivityModel do
    local params = self.mActivityModel[i]
    params.type = 1
    params.currNum = self.mCountMoney
    local item = listView:newItem()
    local icon = IconActivity.new(params, handler(self, self.onEventActivity1))
    local content = icon
    item:addContent(content)
    item:setItemSize(645, 148)
    listView:addItem(item)
    if icon.mIsActive then
      self.mActiveNum = self.mActiveNum + 1
    end
  end
  listView:reload()
end

function M:activityUI2()
  self.mFrame = display.newScale9Sprite("#frame.png", 0, 0, cc.size(680, 454), cc.rect(40, 40, 1, 1)):pos(self.mBg:getContentSize().width * 0.595, self.mBg:getContentSize().height * 0.46):addTo(self.mBg)
  local buddhaId = 1066
  local buddhaModel = DataUtils.getBuddhaModel(buddhaId)
  local pArmatureFile = string.format("armature/%s/%s.csb", buddhaModel.armatureFile, buddhaModel.armatureFile)
  DYRes.loadFileInfo(pArmatureFile, {})
  local armature = ccs.Armature:create(buddhaModel.armatureFile)
  armature:setPosition(self.mFrame:getContentSize().width * 0.26, self.mFrame:getContentSize().height * 0.15 + buddhaModel.upMove)
  armature:setScale(buddhaModel.zoomMultiple)
  armature:getAnimation():playWithIndex(1)
  self.mFrame:addChild(armature)
  display.newSprite(string.format("buddha_tag/%d.png", buddhaModel.tag1)):pos(self.mFrame:getContentSize().width * 0.1, self.mFrame:getContentSize().height * 0.9):addTo(self.mFrame, 1)
  display.newSprite(string.format("buddha_tag/%d.png", buddhaModel.tag2)):pos(self.mFrame:getContentSize().width * 0.1, self.mFrame:getContentSize().height * 0.78):addTo(self.mFrame, 1)
  local bottomFrame = display.newSprite("#bottom.png"):align(display.LEFT_BOTTOM, 0, 0):addTo(self.mFrame, 5)
  for i = 1, #buddhaModel.npcSkill do
    local skillModel = DataUtils.getBuddhaSkillModel(buddhaModel.npcSkill[i], buddhaId)
    local frame = display.newSprite("common_ui/frame1.png"):scale(0.5338983050847458):pos(bottomFrame:getContentSize().width * (0.3 * i - 0.1), bottomFrame:getContentSize().height * 0.5):addTo(bottomFrame)
    local skillIcon = display.newSprite(skillModel.skillIcon):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
    local pLayer
    frame:setTouchEnabled(true)
    frame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
      if name == "began" then
        if not pLayer then
          pLayer = getSkillTip(skillModel):pos(bottomFrame:getContentSize().width * 0.5, bottomFrame:getContentSize().height * 1.6):addTo(bottomFrame, 5)
        end
        return true
      elseif name == "moved" then
        pLayer:show()
      elseif name == "ended" then
        pLayer:removeSelf()
        pLayer = nil
      end
    end)
  end
  table.sort(self.mActivityModel, function(v1, v2)
    return v1.id < v2.id
  end)
  local listFrame = display.newScale9Sprite("#frame_view.png", 0, 0, cc.size(298, 454), cc.rect(50, 50, 1, 1)):align(display.CENTER_RIGHT, self.mFrame:getContentSize().width, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame, 2)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(4, 10, 290, 434),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(listFrame)
  for i = 1, #self.mActivityModel do
    local params = self.mActivityModel[i]
    params.type = 2
    params.currNum = self.mCountMoney
    local item = listView:newItem()
    local icon = IconActivity.new(params, handler(self, self.onEventActivity2))
    local content = icon
    item:addContent(content)
    item:setItemSize(290, 108)
    listView:addItem(item)
    if icon.mIsActive then
      self.mActiveNum = self.mActiveNum + 1
    end
  end
  listView:reload()
end

function M:activityUI3()
  self.mFrame = display.newScale9Sprite("#frame.png", 0, 0, cc.size(680, 454), cc.rect(40, 40, 1, 1)):pos(self.mBg:getContentSize().width * 0.595, self.mBg:getContentSize().height * 0.46):addTo(self.mBg)
  table.sort(self.mActivityModel, function(v1, v2)
    return v1.id < v2.id
  end)
  
  local function sortTable(tb)
    local tb1 = {}
    local tb2 = {}
    for i = 1, #tb do
      local data = tb[i]
      if 1 == data.status then
        table.insert(tb1, data)
      else
        table.insert(tb2, data)
      end
    end
    table.insertto(tb2, tb1)
    return tb2
  end
  
  self.mActivityModel = sortTable(self.mActivityModel)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 10, 650, 434),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mFrame)
  for i = 1, #self.mActivityModel do
    local params = self.mActivityModel[i]
    params.type = 3
    params.currNum = self.mLoginDays
    local item = listView:newItem()
    local icon = IconActivity.new(params, handler(self, self.onEventActivity3))
    local content = icon
    item:addContent(content)
    item:setItemSize(645, 110)
    listView:addItem(item)
    if icon.mIsActive then
      self.mActiveNum = self.mActiveNum + 1
    end
  end
  listView:reload()
end

function M:funcChange(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mTabTag = index
  for i = 1, #self.mTabIconTable do
    local btn = self.mTabIconTable[i]
    if index == i then
      btn:setButtonEnabled(false)
    else
      btn:setButtonEnabled(true)
    end
  end
  if self.mFrame then
    self.mFrame:runAction(cc.RemoveSelf:create())
    self.mFrame = nil
  end
  self.mActiveNum = 0
  self.mActivityModel = self.mActivityList[index]
  self:layoutActivityUI(index)
end

function M:onEventActivity1(params)
  if 1 == params.loadTo then
    self:layerTransition(params.loadTo)
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKONWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
    self.mActivityList[1][params.taskId].status = jsonTable.data.status
    params.tar:setButtonEnabled(false)
    self.mActiveNum = self.mActiveNum - 1
    if 0 == self.mActiveNum then
      self:updateActivityStatus()
    end
    self:loadRewardTip(jsonTable.data)
  end
  
  local param = {}
  param.taskId = params.taskId
  DYHttpMgr.getGiftReward(tFuncListener, param)
end

function M:onEventActivity2(params)
  if 1 == params.loadTo then
    self:layerTransition(params.loadTo)
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKONWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
    self.mActivityList[2][params.taskId].status = 1
    params.tar:setButtonEnabled(false)
    self.mActiveNum = self.mActiveNum - 1
    if 0 == self.mActiveNum then
      self:updateActivityStatus()
    end
    self:loadRewardTip(jsonTable.data)
  end
  
  local param = {}
  param.taskId = params.taskId
  DYHttpMgr.getWishReward(tFuncListener, param)
end

function M:onEventActivity3(params)
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKONWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
    self.mActivityList[2][params.taskId].status = 1
    params.tar:setButtonEnabled(false)
    self.mActiveNum = self.mActiveNum - 1
    if 0 == self.mActiveNum then
      self:updateActivityStatus()
    end
    self:loadRewardTip(jsonTable.data)
  end
  
  local param = {}
  param.taskId = params.taskId
  DYHttpMgr.getLoginReward(tFuncListener, param)
end

function M:loadRewardTip(info)
  local text = DYLang.getString("S24", "")
  for k, v in pairs(info.drop) do
    DataUtils.updateItemNum(k, v)
    local itemModel = DataUtils.getItemModel(k)
    local itemName = itemModel.itemName
    local itemNum = info.dropGain[k]
    text = text .. itemName .. "X" .. itemNum .. "  "
    DYAnalyze.item.get(k, "", itemNum, "Activity_reward")
  end
  WSToast.new(text):addTo(self, 20)
end

function M:updateActivityStatus()
  local tabIcon = self.mTabIconTable[self.mTabTag]
  if tabIcon.redPoint then
    tabIcon.redPoint:runAction(cc.RemoveSelf:create())
    tabIcon.redPoint = nil
    table.removebyvalue(CloudData.ACTIVITY_NEW_YEAR, self.mTabTag)
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
  DYRes.unloadSheet("new_year/ui_new_year.plist")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

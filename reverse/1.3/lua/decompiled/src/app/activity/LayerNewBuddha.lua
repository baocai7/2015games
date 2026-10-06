local IconBuddhaTask = require("app.activity.IconBuddhaTask")
local M = {}
M = class("LayerNewBuddha", function()
  return display.newLayer()
end)

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

function M:ctor(callback)
  self.mCallback = callback
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initUI()
  self:initData()
  self.mCountTime = 0
  self.mSchedule = self:schedule(function()
    self:updateCountTime()
  end, 1)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  local function tFuncListener(jsonTable)
    local pData = jsonTable.data
    
    local list = pData.list[1]
    self.mActivityModel = {}
    self.mActivityModel.activeId = list.id
    self.mActivityModel.priority = list.index
    self.mActivityModel.aType = list.type
    self.mActivityModel.closeTime = list.closeTimeSeconds or 0
    self.mActivityModel.awardTime = list.awardTimeSeconds or 0
    self.mActivityModel.taskIds = split(list.taskIds, ";") or {}
    self.mActivityModel.name = list.name or ""
    self.mActivityModel.newBuddhaId = list.param
    self.mActivityProArr = pData.currentProgress[tostring(self.mActivityModel.activeId)]
    self.mActiveNum = 0
    self:buddhaShow()
    self:loadActivityTask()
  end
  
  local countCE = DataUtils.getUserCountCE()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&power=%s&token=%s&uid=%s", strAppSecret .. "", countCE .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.sign = crypto.md5(strSign, false)
  params.power = countCE
  DYHttpMgr.activityBuddha(tFuncListener, params)
end

function M:initUI()
  self.mBg = display.newSprite("activity/vip/bg.png"):addTo(self.mNode)
  display.newSprite("new_year/title_buddha.png"):pos(self.mBg:getContentSize().width * 0.52, self.mBg:getContentSize().height * 0.89):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.94, self.mBg:getContentSize().height * 0.85):addTo(self.mBg, 2)
end

function M:buddhaShow()
  local frame = display.newSprite("new_year/frame1.png"):pos(self.mBg:getContentSize().width * 0.25, self.mBg:getContentSize().height * 0.45):addTo(self.mBg)
  local buddhaId = self.mActivityModel.newBuddhaId
  local buddhaModel = DataUtils.getBuddhaModel(buddhaId)
  local pArmatureFile = string.format("armature/%s/%s.csb", buddhaModel.armatureFile, buddhaModel.armatureFile)
  DYRes.loadFileInfo(pArmatureFile, {})
  local armature = ccs.Armature:create(buddhaModel.armatureFile)
  armature:setPosition(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.2 + buddhaModel.upMove)
  armature:setScale(buddhaModel.zoomMultiple)
  armature:getAnimation():playWithIndex(1)
  frame:addChild(armature)
  display.newSprite(string.format("buddha_tag/%d.png", buddhaModel.tag1)):pos(frame:getContentSize().width * 0.78, frame:getContentSize().height * 0.9):addTo(frame, 1)
  display.newSprite(string.format("buddha_tag/%d.png", buddhaModel.tag2)):pos(frame:getContentSize().width * 0.78, frame:getContentSize().height * 0.78):addTo(frame, 1)
  display.newSprite(string.format("buddha_tag/%d.png", buddhaModel.tag3)):pos(frame:getContentSize().width * 0.78, frame:getContentSize().height * 0.56):addTo(frame, 1)
  local bottomFrame = display.newSprite("new_year/frame3.png"):align(display.CENTER_BOTTOM, frame:getContentSize().width * 0.5, 15):addTo(frame, 5)
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
end

function M:loadActivityTask()
  local listFrame = display.newSprite("new_year/frame4.png"):pos(self.mBg:getContentSize().width * 0.67, self.mBg:getContentSize().height * 0.45):addTo(self.mBg)
  if self.mActivityModel.closeTime > 0 then
    local frame = display.newSprite("activity/label4.png"):align(display.CENTER_LEFT, 125, 565):addTo(self.mBg, 1)
    local textStr, isNeedCountdown = getTimeText(self.mActivityModel.closeTime - self.mCountTime)
    self.mTimeLabel1 = DYLabelTTF.new({
      text = textStr,
      size = 21,
      color = cc.c3b(0, 255, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(frame:getPositionX() + frame:getContentSize().width + 5, frame:getPositionY()):addTo(self.mBg)
    if isNeedCountdown then
      self:startCountDown_(self.mTimeLabel1, self.mActivityModel.closeTime - self.mCountTime)
    end
  end
  if 0 < self.mActivityModel.awardTime then
    local frame = display.newSprite("activity/label5.png"):align(display.CENTER_LEFT, 680, 565):addTo(self.mBg)
    local textStr, isNeedCountdown = getTimeText(self.mActivityModel.awardTime - self.mCountTime)
    self.mTimeLabel2 = DYLabelTTF.new({
      text = textStr,
      size = 21,
      color = cc.c3b(0, 255, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(frame:getPositionX() + frame:getContentSize().width + 5, frame:getPositionY()):addTo(self.mBg)
    if isNeedCountdown then
      self:startCountDown_(self.mTimeLabel2, self.mActivityModel.awardTime - self.mCountTime)
    end
  end
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(5, 10, 500, 420),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(listFrame)
  for i = 1, #self.mActivityModel.taskIds do
    local item = listView:newItem()
    local taskId = self.mActivityModel.taskIds[i]
    local taskInfo = self.mActivityProArr[tostring(taskId)]
    local params = {taskId = taskId, taskInfo = taskInfo}
    local icon = IconBuddhaTask.new(params, handler(self, self.onEventGetAward))
    local content = icon
    item:addContent(content)
    item:setItemSize(500, 150)
    listView:addItem(item)
    if icon.mIsActive then
      self.mActiveNum = self.mActiveNum + 1
    end
  end
  listView:reload()
end

function M:onEventGetAward(params)
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
    self.mActivityProArr[tostring(params.taskId)].isDraw = 1
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
  param.activityId = self.mActivityModel.activeId
  param.taskId = params.taskId
  DYHttpMgr.getTaskActivityAward(tFuncListener, param)
end

function M:updateActivityStatus()
  if 0 == self.mActiveNum then
    CloudData.NEW_BUDDHA_INFO = 0
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
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

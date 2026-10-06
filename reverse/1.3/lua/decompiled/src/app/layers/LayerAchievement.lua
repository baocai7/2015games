local WSToast = require("app.utils.WSToast")
local IconItem = require("app.icons.IconItem")
local LayerBoxShow = require("app.layers.LayerBoxShow")
local IconBox = require("app.icons.IconBox")
local LayerPVPEntrance = require("app.layers.LayerPVPEntrance")
local LayerLackEssence = require("app.layers.LayerLackEssence")
local LayerCommon = require("app.union.layers.LayerCommon")
local CLASS_NAME = "LayerAchievement"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(cb)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mBg = nil
  self.mAchieveBtn = nil
  self.mTaskBtn = nil
  self.mAchieveRed = nil
  self.mTaskRed = nil
  self.mBoxIcons = {}
  self.mVitality = 0
  self.mMaxVitality = 1
  self.cb = cb
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mEmptyNode = display.newNode()
  self.mEmptyNode:setPosition(display.cx, display.cy)
  self:addChild(self.mEmptyNode)
  self:initBg()
  self:requestData()
end

function M:initBg()
  self.mBg = display.newSprite("task/bg.png", 30, 0)
  self.mEmptyNode:addChild(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.TOP_RIGHT, self.mBg:getContentSize().width, self.mBg:getContentSize().height):addTo(self.mBg, 1)
  self.mTaskBtn = cc.ui.UIPushButton.new({
    normal = "task/tag_task.png",
    disabled = "task/tag_task1.png"
  }):onButtonClicked(function(event)
    self:showTasks()
  end):align(display.CENTER_RIGHT, self.mBg:getContentSize().width * 0.063, self.mBg:getContentSize().height * 0.75):addTo(self.mBg)
  self:performWithDelay(function()
    self.mTaskBtn:setButtonEnabled(false)
  end, 0)
  self.mAchieveBtn = cc.ui.UIPushButton.new({
    normal = "task/tag_achieve.png",
    disabled = "task/tag_achieve1.png"
  }):onButtonClicked(function()
    self:showAchievements()
  end):align(display.CENTER_RIGHT, self.mBg:getContentSize().width * 0.063, self.mBg:getContentSize().height * 0.55 + 42):addTo(self.mBg)
  self.mTaskRed = display.newSprite("common_ui/red_point.png", -105, 30):addTo(self.mTaskBtn)
  self.mTaskRed:setVisible(false)
  self.mAchieveRed = display.newSprite("common_ui/red_point.png", -105, 30):addTo(self.mAchieveBtn)
  self.mAchieveRed:setVisible(false)
end

local function getTitleFrame(textStr)
  local width = math.ceil(#textStr / 3) * 30 + 20
  local frame = display.newScale9Sprite("activity/text_frame.png", 0, 0, cc.size(width, 44), cc.rect(40, 20, 1, 1))
  return frame
end

function M:requestData()
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local msg = info.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      CloudData.DAILY_TASK_INFO = info.data.task
      CloudData.ACHIEVEMENT_INFO = info.data.achievement
      if self.initData then
        self:initData()
      end
    end
  end
  
  local countCE = DataUtils.getUserCountCE()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&power=%s&token=%s&uid=%s", strAppSecret .. "", countCE .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.sign = crypto.md5(strSign, false)
  params.power = countCE
  DYHttpMgr.chapterInfoNew(tFuncListener, params)
end

function M:initData()
  self.mVitality = tonumber(CloudData.DAILY_TASK_INFO.vitality)
  self.mMaxVitality = 0
  self.mTaskInfo = {}
  self.mTaskInfo.table1 = {}
  self.mTaskInfo.table2 = {}
  self.mTaskInfo.table3 = {}
  for id, value in pairs(CloudData.DAILY_TASK_INFO.done) do
    local info = DataUtils.getDailyTaskModel(id)
    if info.state == 1 then
      table.insert(self.mTaskInfo.table1, info)
    elseif info.state == -1 then
      table.insert(self.mTaskInfo.table3, info)
    else
      table.insert(self.mTaskInfo.table2, info)
    end
    self.mMaxVitality = self.mMaxVitality + info.vitality
  end
  self.mAchieveInfo = {}
  self.mAchieveInfo.table1 = {}
  self.mAchieveInfo.table2 = {}
  self.mAchieveInfo.table3 = {}
  for id, value in pairs(CloudData.ACHIEVEMENT_INFO) do
    local info = DataUtils.getAchievementModel(id)
    if info.state == 1 then
      table.insert(self.mAchieveInfo.table1, info)
    elseif info.state == -1 then
      table.insert(self.mAchieveInfo.table3, info)
    else
      table.insert(self.mAchieveInfo.table2, info)
    end
  end
  self.mBoxInfo = {
    {},
    {},
    {},
    {}
  }
  for id, value in pairs(CloudData.DAILY_TASK_INFO.box) do
    local info = DataUtils.getBoxInfo(id)
    self.mBoxInfo[tonumber(id)] = info or {}
  end
  self.mTaskBtn:setButtonEnabled(false)
  self.mAchieveBtn:setButtonEnabled(true)
  self:showTaskList()
  self:showTaskBoxes()
  local boxActive = false
  for i = 1, 4 do
    if self.mBoxInfo[i] and self.mBoxInfo[i].state == 1 then
      boxActive = true
      break
    end
  end
  if boxActive or 0 < #self.mTaskInfo.table1 then
    self.mTaskRed:setVisible(true)
  else
    self.mTaskRed:setVisible(false)
  end
  if 0 < #self.mAchieveInfo.table1 then
    self.mAchieveRed:setVisible(true)
  else
    self.mAchieveRed:setVisible(false)
  end
end

function M:showTasks()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mTaskBtn:setButtonEnabled(false)
  self.mAchieveBtn:setButtonEnabled(true)
  local boxActive = false
  for i = 1, 4 do
    if self.mBoxInfo[i] and self.mBoxInfo[i].state == 1 then
      boxActive = true
      break
    end
  end
  if boxActive or #self.mTaskInfo.table1 > 0 then
    self.mTaskRed:setVisible(true)
  else
    self.mTaskRed:setVisible(false)
  end
  self:showTaskList()
  self:showTaskBoxes()
end

local function layerTransition(self, fromNum, param)
  local tFunc = {
    ["4"] = function()
      display.replaceScene(require("app.scenes.SceneSummon").new())
    end,
    ["6"] = function()
      display.replaceScene(require("app.scenes.SceneTravel").new())
    end,
    ["7"] = function()
      display.replaceScene(require("app.scenes.SceneStage").new(2))
    end,
    ["8"] = function()
      display.replaceScene(require("app.scenes.SceneStage").new())
    end,
    ["9"] = function()
      display.replaceScene(require("app.scenes.ScenePurgatory").new())
    end,
    ["10"] = function()
      display.replaceScene(require("app.cimelia.scenes.SceneCimelia").new())
    end,
    ["11"] = function()
      if not GameManager.IS_CHAT_LOGIN_OK then
        WSToast.new("PVP\229\136\157\229\167\139\229\140\150\230\156\170\229\174\140\230\136\144"):addTo(display.getRunningScene(), 100)
      else
        LayerPVPEntrance.new():addTo(display.getRunningScene(), 20)
      end
    end,
    ["12"] = function()
      display.replaceScene(require("app.scenes.UpgradeScene").new())
    end,
    ["13"] = function()
      LayerLackEssence.new():addTo(display.getRunningScene(), 20)
    end,
    ["14"] = function()
      self:shareCallback(param)
    end
  }
  if tFunc[tostring(fromNum)] then
    return tFunc[tostring(fromNum)]()
  end
end

local function getTaskIcon(self, info, index)
  local content = display.newScale9Sprite("activity/icon.png", 0, 0, cc.size(821, 140), cc.rect(250, 65, 5, 5))
  local titleFrame = getTitleFrame(info.description):align(display.CENTER_LEFT, content:getContentSize().width * 0, content:getContentSize().height * 0.72):addTo(content)
  local name = string.format(info.description, info.targetValue)
  cc.ui.UILabel.new({
    text = name,
    size = 25,
    color = cc.c3b(253, 255, 27),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 15, titleFrame:getContentSize().height * 0.5):addTo(titleFrame)
  display.newSprite("task/active.png"):align(display.CENTER, titleFrame:getContentSize().width + 50, titleFrame:getContentSize().height * 0.5):addTo(titleFrame)
  local activeLabel = cc.ui.UILabel.new({
    text = "+" .. info.vitality,
    size = 25,
    color = cc.c3b(62, 255, 10),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, titleFrame:getContentSize().width + 110, titleFrame:getContentSize().height * 0.5):addTo(titleFrame)
  activeLabel:enableOutline(cc.c4b(7, 7, 7, 255), 2)
  
  local function func()
    self:getTaskAward(index)
  end
  
  local w = info.state == 0 and 465 or 620
  display.newScale9Sprite("activity/label_frame.png", 0, 0, cc.size(w, 47), cc.rect(100, 21, 240, 1)):align(display.CENTER_LEFT, 18, content:getContentSize().height * 0.28):addTo(content)
  cc.ui.UILabel.new({
    text = info.rewardDesc,
    size = 25,
    color = cc.c3b(86, 53, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, content:getContentSize().width * 0.05, content:getContentSize().height * 0.28):addTo(content)
  local str = string.format("%d/%d", checknumber(info.curValue), checknumber(info.targetValue))
  if checknumber(info.curValue) >= checknumber(info.targetValue) or info.state == -1 then
    str = DYLang.getString("S451", "")
  end
  local progressLabel = cc.ui.UILabel.new({
    text = str,
    size = 25,
    color = cc.c3b(62, 255, 10),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, content:getContentSize().width * 0.98, content:getContentSize().height * 0.77):addTo(content)
  progressLabel:enableOutline(cc.c4b(7, 7, 7, 255), 2)
  display.newSprite("task/progress.png"):align(display.CENTER_RIGHT, progressLabel:getPositionX() - progressLabel:getContentSize().width - 10, content:getContentSize().height * 0.77):addTo(content)
  local btnNormalText = cc.ui.UILabel.new({
    text = DYLang.getString("S3", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  btnNormalText:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  local btnDisabledText = cc.ui.UILabel.new({
    text = DYLang.getString("S3", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  })
  btnDisabledText:enableOutline(cc.c4b(40, 40, 40, 255), 2)
  if info.state == 1 then
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }):align(display.CENTER, content:getContentSize().width * 0.89, content:getContentSize().height * 0.32):addTo(content):setButtonLabel("normal", btnNormalText):onButtonClicked(function()
      func()
    end)
  elseif info.state == -1 then
    display.newSprite("task/got.png"):align(display.CENTER, content:getContentSize().width * 0.9, content:getContentSize().height * 0.34):addTo(content)
  else
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }):align(display.CENTER, content:getContentSize().width * 0.89, content:getContentSize().height * 0.32):addTo(content):setButtonLabel("normal", DYLabelTTF.new({
      text = info.text,
      size = 30,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(25, 30, 3)
    })):onButtonClicked(function(event)
      if info.isOpen == 1 then
        local param = {info = info}
        layerTransition(self, info.fromNum, param)
      else
        WSToast.new(DYLang.getString("S454", "")):addTo(self, 20)
      end
    end)
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_orange_n.png",
      pressed = "common_ui/btn_orange_p.png"
    }):align(display.CENTER, content:getContentSize().width * 0.69, content:getContentSize().height * 0.32):addTo(content):setButtonLabel("normal", DYLabelTTF.new({
      text = "\231\171\139\229\141\179\229\174\140\230\136\144",
      size = 22,
      color = cc.c3b(255, 234, 100),
      font = GameManager.FONTNAME_TTF
    }, {})):setButtonLabelOffset(0, 15):onButtonClicked(function(event)
      self:finishTaskWithPeach(info, index)
    end)
    local mark = display.newSprite("activity/img_brackets.png", 0, -12):addTo(btn)
    display.newSprite("common_ui/icon_peach.png", 25, 11):addTo(mark)
    DYLabelTTF.new({
      text = info.peachCost,
      size = 22,
      color = cc.c3b(255, 234, 100),
      font = GameManager.FONTNAME_TTF
    }, {}):pos(55, 11):addTo(mark)
  end
  return content
end

local function getAchievementIcon(self, info, index)
  local content = display.newScale9Sprite("activity/icon.png", 0, 0, cc.size(821, 140), cc.rect(250, 65, 5, 5))
  local titleFrame = getTitleFrame(info.name):align(display.CENTER_LEFT, content:getContentSize().width * 0, content:getContentSize().height * 0.72):addTo(content)
  cc.ui.UILabel.new({
    text = info.name,
    size = 25,
    color = cc.c3b(253, 255, 27),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 15, titleFrame:getContentSize().height * 0.5):addTo(titleFrame)
  cc.ui.UILabel.new({
    text = info.description,
    size = 25,
    color = cc.c3b(18, 154, 44),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, titleFrame:getContentSize().width + 20, titleFrame:getContentSize().height * 0.5):addTo(titleFrame)
  
  local function func()
    self:getAchieveAward(index)
  end
  
  display.newScale9Sprite("activity/label_frame.png", content:getContentSize().width * 0.405, content:getContentSize().height * 0.28, cc.size(636, 47), cc.rect(100, 21, 240, 1)):addTo(content)
  cc.ui.UILabel.new({
    text = info.rewardDesc,
    size = 25,
    color = cc.c3b(86, 53, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, content:getContentSize().width * 0.05, content:getContentSize().height * 0.28):addTo(content)
  local str = string.format("%d/%d", checknumber(info.curValue), checknumber(info.targetValue))
  if checknumber(info.curValue) >= checknumber(info.targetValue) or info.state == -1 then
    str = DYLang.getString("S451", "")
  end
  local progressLabel = cc.ui.UILabel.new({
    text = str,
    size = 25,
    color = cc.c3b(62, 255, 10),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, content:getContentSize().width * 0.98, content:getContentSize().height * 0.77):addTo(content)
  progressLabel:enableOutline(cc.c4b(7, 7, 7, 255), 2)
  display.newSprite("task/progress.png"):align(display.CENTER_RIGHT, progressLabel:getPositionX() - progressLabel:getContentSize().width - 10, content:getContentSize().height * 0.77):addTo(content)
  local btnNormalText = cc.ui.UILabel.new({
    text = DYLang.getString("S3", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  btnNormalText:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  local btnDisabledText = cc.ui.UILabel.new({
    text = DYLang.getString("S3", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  })
  btnDisabledText:enableOutline(cc.c4b(40, 40, 40, 255), 2)
  if info.state == 1 then
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }):align(display.CENTER, content:getContentSize().width * 0.89, content:getContentSize().height * 0.32):addTo(content):setButtonLabel("normal", btnNormalText):onButtonClicked(function()
      func()
    end)
  elseif info.state == -1 then
    display.newSprite("task/got.png"):align(display.CENTER, content:getContentSize().width * 0.9, content:getContentSize().height * 0.34):addTo(content)
  else
    cc.ui.UIPushButton.new("common_ui/btn_disabled1.png"):align(display.CENTER, content:getContentSize().width * 0.89, content:getContentSize().height * 0.32):addTo(content):setButtonLabel("normal", btnDisabledText)
  end
  return content
end

function M:showTaskList()
  if self.mListBg then
    self.mListBg:runAction(cc.RemoveSelf:create())
    self.mListBg = nil
  end
  self.mListBg = display.newScale9Sprite("task/item_bg.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.42, cc.size(842, 371), cc.rect(80, 55, 5, 5)):addTo(self.mBg, 2)
  if self.mList then
    self.mList:runAction(cc.RemoveSelf:create())
    self.mList = nil
  end
  self.mList = cc.ui.UIListView.new({
    async = true,
    viewRect = cc.rect(89, 117, 825, 364),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  local count1 = #self.mTaskInfo.table1
  local count2 = #self.mTaskInfo.table2
  local count3 = #self.mTaskInfo.table3
  local sum = count1 + count2 + count3
  
  local function tFuncDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
      return sum
    else
      if cc.ui.UIListView.CELL_TAG == tag then
        local info
        if idx <= count1 then
          info = self.mTaskInfo.table1[idx]
        elseif idx <= count1 + count2 then
          info = self.mTaskInfo.table2[idx - count1]
        else
          info = self.mTaskInfo.table3[idx - count1 - count2]
        end
        local item = self.mList:newItem()
        local content = getTaskIcon(self, info, idx)
        item:addContent(content)
        item:setItemSize(821, 147)
        return item
      else
      end
    end
  end
  
  self.mList:setDelegate(tFuncDelegate)
  self.mList:reload()
end

function M:showTaskBoxes()
  if self.mProgressFrame then
    self.mProgressFrame:runAction(cc.RemoveSelf:create())
    self.mProgressFrame = nil
  end
  self.mProgressFrame = display.newSprite("task/progress_bg.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.82 - 70):addTo(self.mBg)
  self.mProgressBar = display.newProgressTimer("task/progress_bar.png", display.PROGRESS_TIMER_BAR):pos(self.mProgressFrame:getContentSize().width * 0.5, self.mProgressFrame:getContentSize().height * 0.5):addTo(self.mProgressFrame)
  self.mProgressBar:setMidpoint(cc.p(0, 0))
  self.mProgressBar:setBarChangeRate(cc.p(1, 0))
  self.mProgressBar:setPercentage(self.mVitality / self.mMaxVitality * 100)
  local title = display.newSprite("task/active_title.png"):align(display.BOTTOM_LEFT, 10, 95):addTo(self.mProgressFrame)
  local activeLabel = cc.ui.UILabel.new({
    text = self.mVitality,
    size = 25,
    color = cc.c3b(62, 255, 10),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, title:getContentSize().width * 1.1, title:getContentSize().height * 0.45):addTo(title)
  activeLabel:enableOutline(cc.c4b(7, 7, 7, 255), 2)
  display.newSprite("task/tip_text.png"):align(display.BOTTOM_RIGHT, self.mProgressFrame:getContentSize().width * 0.99, 95):addTo(self.mProgressFrame)
  self.mBoxIconTable = {}
  for i = 1, 4 do
    local progress = self.mBoxInfo[i].vitality / self.mMaxVitality
    local pNode = display.newNode():pos(self.mProgressFrame:getContentSize().width * progress, 2):addTo(self.mProgressFrame, 1)
    pNode:setAnchorPoint(0.5, 0)
    pNode:setContentSize(85, 85)
    pNode:setTouchEnabled(true)
    pNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      if event.name == "began" then
        return true
      elseif event.name == "ended" then
        self:showBox(i)
      end
    end)
    local aniIndex = i == 4 and 5 or i
    local boxState = 0
    local posY = 53
    if self.mBoxInfo[i].state == 1 then
      boxState = 1
      posY = 32
    elseif self.mBoxInfo[i].state == -1 then
      boxState = 2
      posY = 32
    end
    local box = IconBox.new(aniIndex, boxState, "task/box" .. i .. ".png")
    box:setPosition(self.mProgressFrame:getContentSize().width * progress, posY)
    self.mProgressFrame:addChild(box)
    table.insert(self.mBoxIconTable, box)
  end
end

function M:showAchievements()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mTaskBtn:setButtonEnabled(true)
  self.mAchieveBtn:setButtonEnabled(false)
  if self.mProgressFrame then
    self.mProgressFrame:runAction(cc.RemoveSelf:create())
    self.mProgressFrame = nil
  end
  self:showAchieveList()
end

function M:showAchieveList()
  if self.mListBg then
    self.mListBg:runAction(cc.RemoveSelf:create())
    self.mListBg = nil
  end
  if self.mList then
    self.mList:runAction(cc.RemoveSelf:create())
    self.mList = nil
  end
  if #self.mAchieveInfo.table1 > 0 then
    self.mAchieveRed:setVisible(true)
  else
    self.mAchieveRed:setVisible(false)
  end
  self.mListBg = display.newScale9Sprite("task/item_bg.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.51, cc.size(839, 517), cc.rect(80, 55, 5, 5)):addTo(self.mBg, 2)
  self.mList = cc.ui.UIListView.new({
    async = true,
    viewRect = cc.rect(88, 108, 825, 508),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  local count1 = #self.mAchieveInfo.table1
  local count2 = #self.mAchieveInfo.table2
  local count3 = #self.mAchieveInfo.table3
  local sum = count1 + count2 + count3
  
  local function tFuncDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
      return sum
    else
      if cc.ui.UIListView.CELL_TAG == tag then
        local info
        if idx <= count1 then
          info = self.mAchieveInfo.table1[idx]
        elseif idx <= count1 + count2 then
          info = self.mAchieveInfo.table2[idx - count1]
        else
          info = self.mAchieveInfo.table3[idx - count1 - count2]
        end
        local item = self.mList:newItem()
        local content = getAchievementIcon(self, info, idx)
        item:addContent(content)
        item:setItemSize(821, 147)
        return item
      else
      end
    end
  end
  
  self.mList:setDelegate(tFuncDelegate)
  self.mList:reload()
end

function M:getTaskAward(index)
  local taskId = self.mTaskInfo.table1[index].id
  
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local toast = WSToast.new(info.errorMsg, 2)
      self:addChild(toast, 20)
    elseif self.addTaskAwards then
      self:addTaskAwards(info.data, index, taskId)
    end
  end
  
  local params = {}
  params.taskId = taskId
  DYHttpMgr.getDailyTaskAward(tFuncListener, params)
end

function M:addTaskAwards(awardInfo, index, taskId)
  DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
  CloudData.DAILY_TASK_INFO.vitality = tonumber(awardInfo.vitality)
  CloudData.DAILY_TASK_INFO.done[tostring(taskId)] = -1
  self.mVitality = tonumber(awardInfo.vitality)
  local info = self.mTaskInfo.table1[index]
  for i = 1, #self.mBoxInfo do
    if self.mVitality >= self.mBoxInfo[i].vitality and self.mBoxInfo[i].state == 0 then
      self.mBoxInfo[i].state = 1
    end
  end
  info.state = -1
  table.insert(self.mTaskInfo.table3, info)
  table.remove(self.mTaskInfo.table1, index)
  self:showTasks()
  for id, num in pairs(awardInfo.total) do
    DataUtils.updateItemNum(tonumber(id), tonumber(num))
  end
  for i = 1, #info.reward do
    DYAnalyze.item.get(info.reward[i].id, "", info.reward[i].num, "DAILY_TASK")
  end
  local awardTable = {
    boxInfo = info.reward
  }
  local tip = LayerBoxShow.new(awardTable, LayerBoxShow.AWARD_GET)
  self:addChild(tip, 5)
end

function M:getAchieveAward(index)
  local achievementId = self.mAchieveInfo.table1[index] and self.mAchieveInfo.table1[index].id or 0
  
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local toast = WSToast.new(info.errorMsg, 2)
      self:addChild(toast, 20)
    else
      self:addAchieveAwards(info.data, index, achievementId)
    end
  end
  
  local params = {}
  params.achievementId = achievementId
  params.type = self.mAchieveInfo.table1[index] and self.mAchieveInfo.table1[index].type or 0
  DYHttpMgr.getAchieveAward(tFuncListener, params)
end

function M:addAchieveAwards(awardInfo, index, achievementId)
  DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
  local curInfo = self.mAchieveInfo.table1[index]
  CloudData.ACHIEVEMENT_INFO[tostring(curInfo.type)] = {
    id = achievementId,
    value = tonumber(awardInfo.value)
  }
  local newInfo = DataUtils.getAchievementModel(curInfo.type)
  if newInfo.state == -1 then
    table.insert(self.mAchieveInfo.table3, newInfo)
    table.remove(self.mAchieveInfo.table1, index)
  elseif newInfo.state == 1 then
    self.mAchieveInfo.table1[index] = newInfo
  else
    table.insert(self.mAchieveInfo.table2, newInfo)
    table.remove(self.mAchieveInfo.table1, index)
  end
  self:showAchieveList()
  for id, num in pairs(awardInfo.total) do
    DataUtils.updateItemNum(tonumber(id), tonumber(num))
  end
  for i = 1, #curInfo.reward do
    DYAnalyze.item.get(curInfo.reward[i].id, "", curInfo.reward[i].num, "ACHIEVEMENT")
  end
  local awardTable = {
    boxInfo = curInfo.reward
  }
  local tip = LayerBoxShow.new(awardTable, LayerBoxShow.AWARD_GET)
  self:addChild(tip, 5)
end

function M:showBox(index)
  if self.mBoxInfo[index].state == -1 or not self.mBoxIconTable[index] then
    return
  elseif self.mBoxInfo[index].state == 0 then
    local info = {
      boxInfo = self.mBoxInfo[index].reward
    }
    self.mBoxIconTable[index]:showBox(info)
  else
    self:clickBoxCallback(index)
  end
end

function M:finishTaskWithPeach(info, index)
  local taskId, peachCost = info.id, info.peachCost
  if peachCost > CloudData.PEACH then
    WSToast.new("\232\159\160\230\161\131\228\184\141\232\182\179\239\188\129"):addTo(self, 20)
    return
  end
  
  local function tFuncListener()
    local function tFuncListener(jsonTable)
      if jsonTable.errorCode ~= 0 then
        local msg = jsonTable.errorMsg or "UNKNOWN"
        
        WSToast.new(msg, 2):addTo(self, 20)
        return
      end
      info.state = 1
      info.curValue = jsonTable.data.value
      CloudData.DAILY_TASK_INFO.done[tostring(taskId)] = jsonTable.data.value
      CloudData.PEACH = jsonTable.data.peachLeft
      local count1 = #self.mTaskInfo.table1
      table.remove(self.mTaskInfo.table2, index - count1)
      table.insert(self.mTaskInfo.table1, info)
      self:showTasks()
    end
    
    DYHttpMgr.taskFinish(tFuncListener, {taskId = taskId})
  end
  
  local textStr = "\231\161\174\232\174\164\232\138\177\232\180\185" .. peachCost .. "\232\159\160\230\161\131\231\155\180\230\142\165\229\174\140\230\136\144\228\187\187\229\138\161\229\144\151\239\188\159"
  LayerCommon.new({text = textStr}, tFuncListener):addTo(self, 20)
end

function M:clickBoxCallback(index)
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local toast = WSToast.new(info.errorMsg, 2)
      
      self:addChild(toast, 20)
    else
      self:getBox(index, info.data)
    end
  end
  
  local params = {}
  params.boxId = index
  DYHttpMgr.getTaskBox(tFuncListener, params)
end

function M:getBox(index, info)
  self.mBoxInfo[index].reward = {}
  for id, num in pairs(info.gain) do
    table.insert(self.mBoxInfo[index].reward, {
      id = tonumber(id),
      num = tonumber(num)
    })
    DYAnalyze.item.get(id, "", num, "DAILY_TASK_BOX")
  end
  CloudData.DAILY_TASK_INFO.box[tostring(index)] = 1
  self.mBoxInfo[index].state = -1
  if self.mBoxIconTable[index] then
    self.mBoxIconTable[index]:openBox({
      boxInfo = self.mBoxInfo[index].reward
    })
  end
  for id, num in pairs(info.total) do
    DataUtils.updateItemNum(tonumber(id), tonumber(num))
  end
  local boxActive = false
  for i = 1, 4 do
    if self.mBoxInfo[i] and self.mBoxInfo[i].state == 1 then
      boxActive = true
      break
    end
  end
  if boxActive or #self.mTaskInfo.table1 > 0 then
    self.mTaskRed:setVisible(true)
  else
    self.mTaskRed:setVisible(false)
  end
  local delay = cc.DelayTime:create(1.9)
  local func = cc.CallFunc:create(function()
    self:showTaskBoxes()
  end)
  self:runAction(transition.sequence({delay, func}))
end

function M:shareCallback(param)
  local function tFuncListener(event)
    if dy.share.EVENT_SHARE_SUCC == event.event then
      local function tFunc(jsonValue)
        if not self or self.__cname ~= CLASS_NAME then
          return
        end
        local errorCode = jsonValue.errorCode
        if 0 < errorCode then
          local errMsg = jsonValue.errorMsg or "UNKNOWN"
          WSToast.new(errMsg):addTo(self, 20)
          return
        end
        param.info.state = 1
        table.insert(self.mTaskInfo.table1, param.info)
        table.removebyvalue(self.mTaskInfo.table2, param.info)
        self:showTaskList()
      end
      
      DYHttpMgr.dailyShare(tFunc)
    elseif dy.share.EVENT_SHARE_FAIL == event.event then
      local errMsg = event.param.error or DYLang.getString("S352", "")
      WSToast.new(errMsg, 2):addTo(self, 20)
    end
  end
  
  local res = "app/share/11.jpeg"
  local path = cc.FileUtils:getInstance():fullPathForFilename(res)
  local params = {
    method = "weixin",
    title = "",
    content = DYLang.getString("S460", ""),
    imgpath = path
  }
  DYShareMgr.share(params, tFuncListener)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.cb then
    self.cb()
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

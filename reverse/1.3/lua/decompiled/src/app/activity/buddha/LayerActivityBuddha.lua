local LayerRankScore = require("app.activity.buddha.LayerRankScore")
local LayerSummon = require("app.layers.LayerSummon")
local LayerRule = require("app.layers.LayerRule")
local LayerCommon = require("app.union.layers.LayerCommon")
local M = {}
M = class("LayerActivityBuddha", function()
  return display.newLayer()
end)
M.TAG_FREE_TIME = 1
M.TAG_CLOSE_TIME = 2

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

local function parseTime(time)
  local hour = math.floor(time / 3600)
  local mins = math.floor((time - hour * 3600) / 60)
  local secs = time - hour * 3600 - mins * 60
  return hour, mins, secs
end

local function M_filePath(name)
  return string.format("activity_buddha/%s.png", name)
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
    if not self or self.__cname ~= "LayerActivityBuddha" then
      return
    end
    self.mBuddhaId = jsonTable.data.buddhaId
    self.mCloseTime = jsonTable.data.actTimeLeft
    self.mFreeTime = jsonTable.data.freeTimeLeft
    self.mScore = jsonTable.data.score
    self.mRankNum = jsonTable.data.rank
    self.mRankList = jsonTable.data.rankList
    self.mCostNum = {
      jsonTable.data.askGod1Cost,
      jsonTable.data.askGod10Cost
    }
    self.mBuddhaData = DataUtils.getBuddhaModel(self.mBuddhaId)
    self.mPieceData = DataUtils.getItemModel(self.mBuddhaId)
    self.mIsSummonFree = false
    self:buddhaShow()
    self:loadSummonBtn()
    self:loadRankInfo()
    self:loadCloseTime()
    self:loadFuncBtn()
  end
  
  DYHttpMgr.buddhaActivityInit(tFuncListener)
end

function M:initUI()
  self.mBg = display.newSprite("activity/vip/bg.png"):addTo(self.mNode)
  display.newSprite(M_filePath("title")):pos(self.mBg:getContentSize().width * 0.52, self.mBg:getContentSize().height * 0.89):addTo(self.mBg)
  display.newSprite(M_filePath("line_vertical")):pos(self.mBg:getContentSize().width * 0.43, self.mBg:getContentSize().height * 0.45):addTo(self.mBg)
  LayerRule.newRuleIcon(LayerRule.ACTIVITY_BUDDHA):align(display.CENTER, self.mBg:getContentSize().width * 0.06, self.mBg:getContentSize().height * 0.85):addTo(self.mBg, 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.94, self.mBg:getContentSize().height * 0.85):addTo(self.mBg, 2)
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

function M:buddhaShow()
  local frame = display.newSprite(M_filePath("frame")):pos(self.mBg:getContentSize().width * 0.25, self.mBg:getContentSize().height * 0.52):addTo(self.mBg, 1)
  local buddhaData = self.mBuddhaData
  local pArmatureFile = string.format("armature/%s/%s.csb", buddhaData.armatureFile, buddhaData.armatureFile)
  DYRes.loadFileInfo(pArmatureFile, {})
  local armature = ccs.Armature:create(buddhaData.armatureFile)
  armature:setPosition(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.12 + buddhaData.upMove)
  armature:setScale(buddhaData.zoomMultiple)
  armature:getAnimation():playWithIndex(1)
  frame:addChild(armature)
  DYLabelTTF.new({
    text = buddhaData.npcName,
    size = 24,
    color = cc.c3b(87, 54, 11),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(30, 340):addTo(frame)
  display.newSprite(string.format("buddha_tag/%d.png", buddhaData.tag1)):pos(frame:getContentSize().width * 0.78, frame:getContentSize().height * 0.9):addTo(frame, 1)
  display.newSprite(string.format("buddha_tag/%d.png", buddhaData.tag2)):pos(frame:getContentSize().width * 0.78, frame:getContentSize().height * 0.75):addTo(frame, 1)
  display.newSprite(string.format("buddha_tag/%d.png", buddhaData.tag3)):pos(frame:getContentSize().width * 0.78, frame:getContentSize().height * 0.6):addTo(frame, 1)
  for i = 1, 4 do
    local frame = display.newSprite("common_ui/frame_loading.png"):scale(0.5932203389830508):pos(137 + 79 * (i - 1), 140):addTo(self.mBg)
    if i <= #buddhaData.npcSkill then
      frame:setTexture("common_ui/frame_battle.png")
      local skillModel = DataUtils.getBuddhaSkillModel(buddhaData.npcSkill[i], self.mBuddhaId)
      local skillIcon = display.newSprite(skillModel.skillIcon):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
      local pLayer
      frame:setTouchEnabled(true)
      frame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y = event.name, event.x, event.y
        if name == "began" then
          if not pLayer then
            pLayer = getSkillTip(skillModel):pos(self.mBg:getContentSize().width * 0.25, self.mBg:getContentSize().height * 0.36):addTo(self.mBg, 2)
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
end

function M:loadSummonBtn()
  local btnImg = {
    {
      normal = M_filePath("btn_single1"),
      pressed = M_filePath("btn_single2")
    },
    {
      normal = M_filePath("btn_mutiple1"),
      pressed = M_filePath("btn_mutiple2")
    }
  }
  for i = 1, #btnImg do
    local btn = cc.ui.UIPushButton.new(btnImg[i]):onButtonClicked(function()
      self:onEventButtonListener(i)
    end):align(display.CENTER, 610 + 200 * (i - 1), 490):addTo(self.mBg)
    local costFrame = display.newSprite(M_filePath("frame_cost")):pos(btn:getPositionX(), btn:getPositionY() - 85):addTo(self.mBg, 1)
    DYLabelTTF.new({
      text = self.mCostNum[i],
      size = 24,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {}):pos(costFrame:getContentSize().width * 0.6, costFrame:getContentSize().height * 0.5):addTo(costFrame)
    if 1 == i then
      self.mCostFrame = costFrame
      self.mFreeTip = display.newSprite("summon_scene/free_tip.png", btn:getPositionX(), btn:getPositionY() - 85):hide():addTo(self.mBg, 1)
      local timeStr = string.format("%02d:%02d:%02d", parseTime(self.mFreeTime))
      self.mFreeTimeLabel = DYLabelTTF.new({
        text = timeStr,
        size = 20,
        color = cc.c3b(60, 255, 0),
        font = GameManager.FONTNAME_TTF
      }, {}):pos(btn:getPositionX(), btn:getPositionY() + 48):addTo(self.mBg, 1)
      self.mFreeTimeLabel.tag = M.TAG_FREE_TIME
      self:startCountDown(self.mFreeTimeLabel, self.mFreeTime)
    end
  end
  display.newSprite(M_filePath("tip"), 710, 575):addTo(self.mBg, 1)
end

function M:singleSummon()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    local summonData = jsonTable.data
    self.mFreeTime = summonData.freeTimeLeft
    self.mScore = summonData.score
    self.mRankNum = summonData.rank
    CloudData.PEACH = summonData.peachLeft
    local itemList, itemNumList = {}, {}
    for k, v in pairs(summonData.dropGain) do
      table.insert(itemList, v.id)
      table.insert(itemNumList, v.num)
    end
    if 0 < self.mFreeTime then
      CloudData.ACTIVITY_BUDDHA = 0
    end
    
    local function tCallback(isRepeat)
      for k, v in pairs(summonData.drop) do
        DataUtils.updateItemNum(tonumber(k), v)
      end
      if isRepeat then
        self:onEventButtonListener(1)
      end
      self:updateUI()
      self.mScoreLabel:setString(self.mScore)
      self.mRankLabel:setString(self.mRankNum)
    end
    
    LayerSummon.new(1, itemList, itemNumList, tCallback):addTo(self, 20)
  end
  
  DYHttpMgr.buddhaSummon(tFuncListener)
end

function M:mutipleSummon()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    local summonData = jsonTable.data
    self.mScore = summonData.score
    self.mRankNum = summonData.rank
    CloudData.PEACH = summonData.peachLeft
    local itemList, itemNumList = {}, {}
    for k, v in pairs(summonData.dropGain) do
      table.insert(itemList, v.id)
      table.insert(itemNumList, v.num)
    end
    
    local function tCallback(isRepeat)
      for k, v in pairs(summonData.drop) do
        DataUtils.updateItemNum(tonumber(k), v)
      end
      if isRepeat then
        self:onEventButtonListener(2)
      end
      self.mScoreLabel:setString(self.mScore)
      self.mRankLabel:setString(self.mRankNum)
    end
    
    LayerSummon.new(2, itemList, itemNumList, tCallback):addTo(self, 20)
  end
  
  DYHttpMgr.buddhaSummon10(tFuncListener)
end

function M:updateUI()
  if self.mFreeTime <= 0 then
    self.mCostFrame:hide()
    self.mFreeTip:show()
    self.mFreeTimeLabel:hide()
    self.mIsSummonFree = true
    return
  end
  self.mCostFrame:show()
  self.mFreeTip:hide()
  self.mFreeTimeLabel:show()
  self.mIsSummonFree = false
  if self.mFreeTimeLabel.schedule then
    return
  end
  self:startCountDown(self.mFreeTimeLabel, self.mFreeTime)
end

function M:loadRankInfo()
  local frame = display.newSprite(M_filePath("frame_rank"), 710, 255):addTo(self.mBg)
  self.mScoreLabel = DYLabelTTF.new({
    text = self.mScore,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(frame:getContentSize().width * 0.33, frame:getContentSize().height * 0.92):addTo(frame)
  self.mRankLabel = DYLabelTTF.new({
    text = self.mRankNum,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(frame:getContentSize().width * 0.8, frame:getContentSize().height * 0.92):addTo(frame)
  
  local function getRankPanel(rank, data)
    local pNode = display.newNode()
    pNode:setAnchorPoint(0.5, 0.5)
    pNode:setContentSize(475, 50)
    pNode.rank = display.newSprite("ranking/rank" .. rank .. ".png", 36, 27):scale(0.6):addTo(pNode)
    pNode.name = DYLabelTTF.new({
      text = data.nick,
      size = 20,
      color = cc.c3b(87, 54, 11),
      font = GameManager.FONTNAME_TTF
    }):pos(155, 25):addTo(pNode)
    pNode.score = DYLabelTTF.new({
      text = data.score,
      size = 20,
      color = cc.c3b(87, 54, 11),
      font = GameManager.FONTNAME_TTF
    }):pos(285, 25):addTo(pNode)
    local frame = display.newSprite("common_ui/frame_battle.png", 405, 28):scale(0.4):addTo(pNode)
    display.newSprite(data.pieceIcon, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
    DYLabelTTF.new({
      text = "X" .. data.award,
      size = 36,
      color = cc.c3b(87, 54, 11),
      font = GameManager.FONTNAME_TTF,
      dyalign = "LEFT_BOTTOM"
    }):pos(frame:getContentSize().width, 0):addTo(frame)
    return pNode
  end
  
  for i = 1, 3 do
    local data = self.mRankList[i]
    if data then
      data.pieceIcon = self.mPieceData.itemIcon
      local panel = getRankPanel(i, data):pos(frame:getContentSize().width * 0.5, 135 - 55 * (i - 1)):addTo(frame)
    end
  end
end

function M:loadCloseTime()
  local lb = DYLabelTTF.new({
    text = "\230\180\187\229\138\168\231\187\147\230\157\159\230\151\182\233\151\180\239\188\154",
    size = 20,
    color = cc.c3b(60, 255, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(500, 105):addTo(self.mBg, 1)
  local timeStr, ret = getTimeText(self.mCloseTime)
  self.mCloseTimeLabel = DYLabelTTF.new({
    text = timeStr,
    size = 20,
    color = cc.c3b(60, 255, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(lb:getPositionX() + lb:getContentSize().width, lb:getPositionY()):addTo(self.mBg, 1)
  self.mCloseTimeLabel.tag = M.TAG_CLOSE_TIME
  if ret then
    self:startCountDown(self.mCloseTimeLabel, self.mCloseTime)
  end
end

function M:loadFuncBtn()
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):scale(0.75):setButtonLabel("normal", DYLabelTTF.new({
    text = "\230\155\180\229\164\154\230\142\146\229\144\141",
    size = 30,
    color = cc.c3b(253, 255, 52),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(66, 78, 9)
  })):onButtonClicked(function()
    LayerRankScore.new({
      list = self.mRankList,
      pieceData = self.mPieceData
    }):addTo(self, 20)
  end):align(display.CENTER, 875, 105):addTo(self.mBg, 1)
end

function M:startCountDown(node, time)
  if time <= 0 then
    node.schedule = false
    self:countdownOver(node)
    return
  end
  node.hour, node.mins, node.secs = parseTime(time)
  node.schedule = self:schedule(function()
    self:updateTime(node)
  end, 1)
end

function M:updateTime(node)
  local function updateLabel()
    local timeStr
    
    if M.TAG_FREE_TIME == node.tag then
      timeStr = string.format("%02d:%02d:%02d", node.hour, node.mins, node.secs)
    else
      timeStr = string.format("%d\229\136\134%d\231\167\146", node.mins, node.secs)
    end
    node:setString(timeStr)
  end
  
  if node.secs > 0 then
    node.secs = node.secs - 1
  elseif 0 < node.mins then
    node.secs = 59
    node.mins = node.mins - 1
  elseif 0 < node.hour then
    node.secs, node.mins = 59, 59
    node.hour = node.hour - 1
  else
    self:countdownOver(node)
  end
  updateLabel()
end

function M:countdownOver(node)
  if node.schedule then
    self:stopAction(node.schedule)
  end
  if M.TAG_FREE_TIME == node.tag then
    self.mCostFrame:hide()
    self.mFreeTip:show()
    self.mFreeTimeLabel:hide()
    self.mIsSummonFree = true
    CloudData.ACTIVITY_BUDDHA = 1
  end
end

function M:onEventButtonListener(tag)
  local costNum = self.mCostNum[tag]
  if 1 == tag and self.mIsSummonFree then
    costNum = 0
  end
  if costNum > CloudData.PEACH then
    WSToast.new("\232\159\160\230\161\131\228\184\141\232\182\179\239\188\129"):addTo(self, 20)
    return
  end
  local tFunc = {
    [1] = function()
      self:singleSummon()
    end,
    [2] = function()
      self:mutipleSummon()
    end
  }
  local textStr = {
    "\231\161\174\229\174\154\232\138\177\232\180\185%d\232\159\160\230\161\131\232\175\183\231\165\158\228\184\128\230\172\161\229\144\151\239\188\159",
    "\231\161\174\229\174\154\232\138\177\232\180\185%d\232\159\160\230\161\131\232\175\183\231\165\158\229\141\129\230\172\161\229\144\151\239\188\159"
  }
  if 0 < costNum then
    LayerCommon.new({
      type = 1,
      text = string.format(textStr[tag], costNum)
    }, function()
      tFunc[tag]()
    end):addTo(self, 20)
    return
  end
  tFunc[1]()
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
end

return M

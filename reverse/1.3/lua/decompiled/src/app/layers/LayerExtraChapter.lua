local IconExtraStage = require("app.icons.IconExtraStage")
local LayerExtraStageInfo = require("app.layers.LayerExtraStageInfo")
local IconBox = require("app.icons.IconBox")
local CLASS_NAME = "LayerExtraChapter"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local box_limited = 0
local box_got = 1
local box_active = 2

function M:ctor(chapterNum, stageNum)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mBg = nil
  self.mChapterNum = chapterNum
  self.mIconPosTable = {}
  self.mSelectedRing = nil
  self.mTimes = 5
  self.mTitles = ""
  self.mDescTable = {}
  self.mDescLabel = nil
  self.mSelectedStage = stageNum or 0
  self.mBoxState = box_limited
  self.mBoxInfo = {}
  self.mBox = nil
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mEmptyNode = display.newNode()
  self.mEmptyNode:setPosition(display.cx, display.cy)
  self:addChild(self.mEmptyNode)
  self.mEmptyNode:setScale(0)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mEmptyNode:runAction(popupLayer)
  GameManager.INFINITE_MODE = false
  self:initData()
  self:initBg()
end

function M:initData()
  local chapterInfo = DYCommon.getDataByTag(DataRetainer.ELITE_CHAPTER_INFO, "id", tostring(self.mChapterNum))[1]
  if not chapterInfo then
    DDERROR("eliteChapterInfo index : %d with error data", tonumber(self.mChapterNum))
    return
  end
  self.mTitles = chapterInfo.name
  for i = 1, 4 do
    self.mDescTable[i] = chapterInfo["desc" .. i] or ""
  end
  self.mTimes = checknumber(CloudData.CHAPTER_INFO_TABLE.elite.challengeTimes)
  local idTable = split(chapterInfo.awardId, ";")
  local numTable = split(chapterInfo.awardNum, ";")
  self.mBoxInfo = {}
  for i = 1, #idTable do
    self.mBoxInfo[i] = {
      id = checknumber(idTable[i]),
      num = checknumber(numTable[i])
    }
  end
  self.mBoxState = checknumber(CloudData.CHAPTER_INFO_TABLE.elite.chapterInfo["eliteChapterBoxStatus" .. self.mChapterNum]) or 0
  if self.mBoxState == 0 then
    local stageNum = self.mChapterNum * 4
    local progress = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.stageId) % 20000
    if stageNum <= progress then
      self.mBoxState = box_active
    end
  end
end

function M:initBg()
  self.mBg = display.newSprite("stage/bg_elite.png")
  self.mEmptyNode:addChild(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.TOP_RIGHT, self.mBg:getContentSize().width, self.mBg:getContentSize().height + 15):addTo(self.mBg, 1)
  local title = display.newSprite("stage/title.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.975 - 20):addTo(self.mBg)
  local chapterNo = display.newSprite(string.format("stage/chapter" .. self.mChapterNum .. ".png"), title:getContentSize().width * 0.25, title:getContentSize().height * 0.55):scale(1):addTo(title)
  display.newSprite("stage/titles/elite_" .. self.mChapterNum .. ".png"):align(display.CENTER_LEFT, chapterNo:getContentSize().width + 10, chapterNo:getContentSize().height * 0.5):addTo(chapterNo)
  if self.mBoxState ~= box_got then
    self.mAwardPic = display.newSprite("stage/award_str.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.135, self.mBg:getContentSize().height * 0.85):addTo(self.mBg, 2)
    local pNode = display.newNode():pos(self.mAwardPic:getContentSize().width + 45, self.mAwardPic:getContentSize().height * 0.7 - 6):addTo(self.mAwardPic, 1)
    pNode:setAnchorPoint(0.5, 0.5)
    pNode:setContentSize(85, 85)
    pNode:setTouchEnabled(true)
    pNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      if event.name == "began" then
        return true
      elseif event.name == "ended" then
        self:showBox()
      end
    end)
    local boxState = 0
    if self.mBoxState == box_active then
      boxState = 1
    else
      local p = display.newSprite("stage/box_shadow.png"):align(display.CENTER, self.mAwardPic:getContentSize().width + 45, self.mAwardPic:getContentSize().height * 0.7 - 6):addTo(self.mAwardPic, -1)
      local seq = transition.sequence({
        cc.FadeOut:create(0.4),
        cc.FadeIn:create(0.4)
      })
      p:runAction(cc.RepeatForever:create(seq))
    end
    local box = IconBox.new(4, boxState, nil, handler(self, self.removeBox))
    box:setPosition(self.mAwardPic:getContentSize().width + 45, self.mAwardPic:getContentSize().height * 0.7 - 6)
    self.mAwardPic:addChild(box)
    self.mBox = box
  end
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(828, 103, 185, 266),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  self:addStageIcon()
end

function M:addStageIcon()
  for i = 1, 4 do
    local posX = i * 0.175 - 0.04
    local posY = 0.46
    local stageIcon = IconExtraStage.new((self.mChapterNum - 1) * 4 + i)
    stageIcon:setPosition(self.mBg:getContentSize().width * posX, self.mBg:getContentSize().height * posY + 7)
    self.mBg:addChild(stageIcon, 1)
    stageIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onTouch(event, i)
    end)
    stageIcon:setTouchEnabled(true)
    self.mIconPosTable[i] = {
      x = posX,
      y = posY + 7
    }
  end
  local stageNum = (self.mChapterNum - 1) * 4
  local index
  local progress = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.stageId) % 20000
  if self.mSelectedStage > 0 and stageNum + self.mSelectedStage <= progress + 1 then
    index = self.mSelectedStage
  elseif stageNum <= progress and progress < stageNum + 4 then
    index = progress - stageNum + 1
    self.mSelectedStage = 0
  else
    index = 4
    self.mSelectedStage = 0
  end
  self.mSelectedRing = display.newSprite("stage/elite_select.png"):pos(self.mBg:getContentSize().width * self.mIconPosTable[index].x, self.mBg:getContentSize().height * self.mIconPosTable[index].y):addTo(self.mBg)
  self:showStageDesc(index)
  if self.mSelectedStage > 0 then
    self:showStageInfo(index)
    self.mSelectedStage = 0
  end
end

function M:onTouch(event, index)
  if event.name == "began" then
    self.mBeginPoint = cc.p(event.x, event.y)
    return true
  elseif event.name == "ended" and math.abs(event.x - self.mBeginPoint.x) < 20 and math.abs(event.y - self.mBeginPoint.y) < 20 then
    self:showStageInfo(index)
  end
end

function M:showStageInfo(index)
  local progress = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.stageId) % 20000
  local stageNum = (self.mChapterNum - 1) * 4 + index
  if stageNum <= progress + 1 then
    self.mSelectedRing:setPosition(self.mBg:getContentSize().width * self.mIconPosTable[index].x, self.mBg:getContentSize().height * self.mIconPosTable[index].y)
    self:showStageDesc(index)
    local info = LayerExtraStageInfo.new(stageNum)
    self:addChild(info, 5)
  end
end

function M:showStageDesc(index)
  local str = self.mDescTable[index]
  local num = math.ceil(#str / 3) / 8
  self.mListView:removeAllItems()
  local item = self.mListView:newItem()
  local content = display.newNode()
  content:setContentSize(175, 260)
  cc.ui.UILabel.new({
    text = str,
    size = 20,
    dimensions = cc.size(170, num * 23 + 200),
    align = cc.ui.TEXT_ALIGN_LEFT,
    color = cc.c3b(70, 38, 4),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_TOP, content:getContentSize().width * 0.5, content:getContentSize().height * 0.95):addTo(content)
  item:addContent(content)
  item:setItemSize(175, 260)
  self.mListView:addItem(item)
  self.mListView:reload()
end

function M:showBox()
  if self.mBoxState == box_active then
    self:clickBoxCallback()
  else
    local info = {
      tip = DYLang.getString("S631", ""),
      boxInfo = self.mBoxInfo
    }
    if self.mBox then
      self.mBox:showBox(info)
    end
  end
end

function M:clickBoxCallback()
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local errMsg = info.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(info.errorMsg, 2)
      self:addChild(toast, 20)
    else
      self:getBox(info.data)
      DYNotification.postNotification(DY_KEY.kUpdateUserExp)
      DYNotification.postNotification(DY_KEY.kGotStageBox)
    end
  end
  
  local params = {}
  params.chapterId = self.mChapterNum
  DYHttpMgr.getEliteBox(tFuncListener, params)
end

function M:getBox(info)
  CloudData.CHAPTER_INFO_TABLE.elite.chapterInfo["eliteChapterBoxStatus" .. self.mChapterNum] = box_got
  if CloudData.DUNGEON_ELITE_BOX_NUM[tostring(self.mChapterNum)] then
    CloudData.DUNGEON_ELITE_BOX_NUM[tostring(self.mChapterNum)] = nil
  end
  if self.mBox then
    self.mBox:openBox({
      boxInfo = self.mBoxInfo
    }, 295, -180)
  end
  for i = 1, #self.mBoxInfo do
    DYAnalyze.item.get(self.mBoxInfo.id, "", self.mBoxInfo.num, "ELITE_STAGE_BOX")
  end
  for id, num in pairs(info) do
    DataUtils.updateItemNum(id, num)
  end
end

function M:removeBox()
  if self.mAwardPic then
    self.mAwardPic:runAction(cc.RemoveSelf:create())
    self.mAwardPic = nil
    self.mBox = nil
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.mEmptyNode:runAction(popupLayer)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:removeSelf()
  end
  return true
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

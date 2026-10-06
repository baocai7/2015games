local IconStage = require("app.icons.IconStage")
local LayerStageInfo = require("app.layers.LayerStageInfo")
local WSToast = require("app.utils.WSToast")
local IconBox = require("app.icons.IconBox")
local NoviceGuide = require("app.utils.NoviceGuide")
local GameDialogue = require("app.utils.GameDialogue")
local CLASS_NAME = "LayerChapter"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(chapterNum, stageNum)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mBg = nil
  self.mChapterNum = chapterNum
  self.mStageIconTable = {}
  self.mBoxIconTable = {}
  self.mStars = 0
  self.mChapterInfo = {}
  self.mTitles = ""
  self.mBoxInfoTable = {}
  self.mSelectedStage = stageNum or 0
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
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
  self:dealUserGuide()
end

function M:initData()
  self.mChapterInfo = DYCommon.getDataByTag(DataRetainer.MAIN_CHAPTER_INFO, "id", tostring(self.mChapterNum))[1]
  if not self.mChapterInfo then
    DDERROR("chapterInfo index : %d with error data", tonumber(self.mChapterNum))
    return
  end
  self.mTitles = self.mChapterInfo.name
  self.mBoxInfoTable = {
    {
      stars = tonumber(self.mChapterInfo.starCount1),
      state = 0,
      boxInfo = {}
    },
    {
      stars = tonumber(self.mChapterInfo.starCount2),
      state = 0,
      boxInfo = {}
    },
    {
      stars = tonumber(self.mChapterInfo.starCount3),
      state = 0,
      boxInfo = {}
    }
  }
  local boxTable = CloudData.CHAPTER_INFO_TABLE.main.chapterInfo[tostring(self.mChapterNum)]
  for i = 1, 3 do
    local boxInfo = {}
    local awardList = self.mChapterInfo["awardId" .. i]
    local awardTable = split(awardList, ";")
    local numList = self.mChapterInfo["awardNum" .. i]
    local numTable = split(numList, ";")
    for i = 1, #awardTable do
      boxInfo[i] = {
        id = tonumber(awardTable[i]),
        num = tonumber(numTable[i])
      }
    end
    self.mBoxInfoTable[i].boxInfo = boxInfo
    if boxTable ~= nil and boxTable[tostring(i)] ~= nil then
      self.mBoxInfoTable[i].state = tonumber(boxTable[tostring(i)])
    end
  end
  local info = CloudData.CHAPTER_INFO_TABLE.main.stageInfo
  local stage = self.mChapterNum * 10 - 9 + 10000
  for i = stage, stage + 9 do
    if info[tostring(i)] ~= nil and 0 < tonumber(info[tostring(i)].starCount) then
      self.mStars = self.mStars + tonumber(info[tostring(i)].starCount)
    end
  end
end

function M:initBg()
  self.mBg = display.newScale9Sprite("stage/chapter.png", 0, -20, cc.size(1065, 652), cc.rect(500, 230, 2, 2))
  self.mEmptyNode:addChild(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.TOP_RIGHT, self.mBg:getContentSize().width, self.mBg:getContentSize().height + 25):addTo(self.mBg, 1)
  local title = display.newSprite("stage/title.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.985):addTo(self.mBg)
  local chapterNo = display.newSprite(string.format("stage/chapter" .. self.mChapterNum .. ".png")):scale(0.8):align(display.CENTER_RIGHT, title:getContentSize().width * 0.41, title:getContentSize().height * 0.55):addTo(title)
  display.newSprite("stage/titles/main_" .. self.mChapterNum .. ".png"):align(display.CENTER_LEFT, title:getContentSize().width * 0.41 + 5, title:getContentSize().height * 0.55):addTo(title)
  self:addStageIcon()
  self:addBox()
end

function M:addBox()
  local boxBg = display.newSprite("stage/box_progress.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.11):addTo(self.mBg)
  display.newSprite("stage/box_bar.png"):pos(boxBg:getContentSize().width * 0.5, boxBg:getContentSize().height * 0.5):addTo(boxBg)
  local location = {
    0.1,
    0.5,
    0.99
  }
  local color = {
    cc.c3b(255, 255, 255),
    cc.c3b(10, 255, 0),
    cc.c3b(255, 0, 255)
  }
  for i = 1, 3 do
    local pNode = display.newNode():pos(boxBg:getContentSize().width * location[i], boxBg:getContentSize().height * 0.5):addTo(boxBg, 2)
    pNode:setAnchorPoint(0.5, 0.5)
    pNode:setContentSize(85, 85)
    pNode:setTouchEnabled(true)
    pNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      if event.name == "began" then
        return true
      elseif event.name == "ended" then
        self:showBox(i)
      end
    end)
    local boxState = 2
    if self.mBoxInfoTable[i].state == 0 and self.mStars < self.mBoxInfoTable[i].stars then
      boxState = 0
      local numLabel = cc.ui.UILabel.new({
        text = self.mBoxInfoTable[i].stars,
        size = 22,
        color = color[i],
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER, 30, 17):addTo(pNode)
      numLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    elseif self.mBoxInfoTable[i].state == 0 then
      boxState = 1
    end
    local box = IconBox.new(i, boxState, "stage/box_normal" .. i .. ".png")
    box:setPosition(boxBg:getContentSize().width * location[i], boxBg:getContentSize().height * 0.5)
    boxBg:addChild(box)
    table.insert(self.mBoxIconTable, box)
  end
end

function M:addStageIcon()
  for i = 1, 10 do
    local posX = ((i - 1) % 5 + 1) * 0.19 - 0.07
    local posY = 1.09 - math.ceil(i / 5) * 0.36
    local stageNum = (self.mChapterNum - 1) * 10 + i
    local stageIcon = IconStage.new(stageNum)
    stageIcon:setPosition(self.mBg:getContentSize().width * posX, self.mBg:getContentSize().height * posY)
    self.mBg:addChild(stageIcon)
    stageIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onTouch(event, i)
    end)
    stageIcon:setTouchEnabled(true)
    table.insert(self.mStageIconTable, stageIcon)
  end
  local stageNum = (self.mChapterNum - 1) * 10
  local index
  local progress = tonumber(CloudData.CHAPTER_INFO_TABLE.main.stageId) % 10000
  if self.mSelectedStage > 0 and stageNum + self.mSelectedStage <= progress + 1 then
    index = self.mSelectedStage
  elseif stageNum <= progress and progress < stageNum + 10 then
    index = progress - stageNum + 1
    self.mSelectedStage = 0
  else
    index = 10
    self.mSelectedStage = 0
  end
  self.mStageIconTable[index]:setSelected()
  
  local function tFuncUpdate(key, index)
    self.mStageIconTable[index]:updateTreasure()
  end
  
  DYNotification.registerScriptObserver(self, tFuncUpdate, DY_KEY.kUpdateStageTreasure)
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
  local stageNum = (self.mChapterNum - 1) * 10 + index
  local progress = tonumber(CloudData.CHAPTER_INFO_TABLE.main.stageId) % 10000
  if stageNum <= progress + 1 then
    for i = 1, 10 do
      self.mStageIconTable[i]:setNormal()
    end
    self.mStageIconTable[index]:setSelected()
    local info = LayerStageInfo.new(stageNum)
    self:addChild(info, 5)
  end
end

function M:showBox(index)
  local stars = self.mBoxInfoTable[index].stars
  if self.mBoxInfoTable[index].state == 1 or not self.mBoxIconTable[index] then
    return
  elseif stars <= self.mStars then
    self:clickBoxCallback(index)
  else
    local info = {
      tip = "(\229\136\176\232\190\190" .. stars .. DYLang.getString("S573", ""),
      boxInfo = self.mBoxInfoTable[index].boxInfo
    }
    self.mBoxIconTable[index]:showBox(info)
  end
end

function M:clickBoxCallback(index)
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local errMsg = info.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(errMsg, 2)
      self:addChild(toast, 20)
    else
      self:getBox(index, info.data)
      DYNotification.postNotification(DY_KEY.kUpdateUserExp)
      DYNotification.postNotification(DY_KEY.kGotStageBox)
    end
  end
  
  local params = {}
  params.chapterId = self.mChapterNum
  params.index = index
  DYHttpMgr.getChapterBox(tFuncListener, params)
end

function M:getBox(index, info)
  self.mBoxInfoTable[index].state = 1
  if CloudData.CHAPTER_INFO_TABLE.main.chapterInfo[tostring(self.mChapterNum)] then
    CloudData.CHAPTER_INFO_TABLE.main.chapterInfo[tostring(self.mChapterNum)][tostring(index)] = 1
  end
  local num = CloudData.DUNGEON_MAIN_BOX_NUM[tostring(self.mChapterNum)] or 0
  num = num - 1
  if 0 < num then
    CloudData.DUNGEON_MAIN_BOX_NUM[tostring(self.mChapterNum)] = num
  else
    CloudData.DUNGEON_MAIN_BOX_NUM[tostring(self.mChapterNum)] = nil
  end
  local boxInfo = self.mBoxInfoTable[index] and self.mBoxInfoTable[index].boxInfo
  if self.mBoxIconTable[index] then
    self.mBoxIconTable[index]:openBox({boxInfo = boxInfo})
  end
  for i = 1, #boxInfo do
    DYAnalyze.item.get(boxInfo.id, "", boxInfo.num, "MAIN_STAGE_BOX")
  end
  for id, num in pairs(info) do
    DataUtils.updateItemNum(id, num)
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

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  local userLevel = CloudData.USER_LEVEL
  if stageProgress == 0 and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE0_CHAPTERLAY") then
    local guide = NoviceGuide.new("GUDIE_STAGE0_CHAPTERLAY"):addTo(self, 50)
  end
  if stageProgress == 1 then
    local buddhaOnTeam = DataUtils.getBuddhaTableOnTeam()
    if not DataUtils.getGuideIsFirstPlayed("STAGE2_0") and not DataUtils.getGuideIsFirstPlayed("DIALOGUE_STAGE2_2") then
      DataUtils.setGuideIsFirstPlayed("STAGE2_0", true)
      local guideLayer = GameDialogue.new("STAGE2_0", function()
        local scene = require("app.scenes.ChapterScene").new()
        display.replaceScene(scene, "FADETR", 1)
      end):addTo(self, 999)
    end
  end
  if stageProgress == 3 then
  end
  if stageProgress == 4 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STAGE4_STAGELAY") then
    DataUtils.setGuideIsFirstPlayed("GUIDE_STAGE4_STAGELAY", true)
    local guideLayer = GameDialogue.new("STAGE4_2", function()
      local scene = require("app.scenes.ChapterScene").new()
      display.replaceScene(scene, "FADETR", 1)
    end):addTo(self, 999)
  end
  local guide = stageProgress ~= 5 or table.keyof(DataUtils.getBuddhaTableOnTeam(), "1005") or DataUtils.getGuideIsFirstPlayed("GUIDE_STAGE6_STAGESCN") or NoviceGuide.new("GUIDE_STAGE6_STAGESCN", function()
    local scene = require("app.scenes.ChapterScene").new()
    display.replaceScene(scene, "FADETR", 1)
  end):addTo(self, 999)
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
  DYNotification.removeAllObservers(self)
end

return M

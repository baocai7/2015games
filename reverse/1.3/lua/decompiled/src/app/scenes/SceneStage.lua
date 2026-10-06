local DataLabelIcon = require("app.icons.DataLabelIcon")
local IconChapter = require("app.icons.IconChapter")
local IconExtraChapter = require("app.icons.IconExtraChapter")
local LayerChapter = require("app.layers.LayerChapter")
local LayerExtraChapter = require("app.layers.LayerExtraChapter")
local NoviceGuide = require("app.utils.NoviceGuide")
local GameDialogue = require("app.utils.GameDialogue")
local IconPkBubble = require("app.icons.IconPkBubble")
local M = {}
M = class("SceneStage", function()
  return display.newScene("SceneStage")
end)
M.MAIN = 1
M.ELITE = 2

function M:ctor(mode, chapter, stage)
  if not audio.isMusicPlaying() then
    DYSoundMgr.playMusic(DY_SND.bgm_theme)
  end
  DYRes.loadSheet("stage/bird_tx.plist")
  GameManager.MODE = 0
  self.mBg = nil
  self.mExtraBtn = nil
  self.mStageBtn = nil
  self.mMapNode = nil
  self.mChapterIconsTable = {}
  self.mMapSpriteTable = {}
  self.mStageProgress = 0
  self.mExtraStageProgress = 0
  self.mMapWidth = 0
  self.mScreenWidth = 980
  self.mBorderX = 154
  self.mProgressBar = nil
  self.mExpLevel = CloudData.USER_LEVEL
  self.mLevelRate = 0
  self.mIsMian = true
  self.mSelectedMode = mode or M.MAIN
  self.mSelectedChapter = chapter or 0
  self.mSelectedStage = stage or 0
  self.mTimeStr = nil
  self.mEliteTimeLabel = nil
  self.mDataLoaded = false
  self:initParamData()
  self:initBg()
  self:initPkBubble()
  self:requestData()
  self.mKeypadListener = handler(self, self.onKeypad)
end

function M:requestData()
  self.mDataLoaded = false
  
  local function tFuncListener(chapterInfo)
    self.mDataLoaded = true
    if self.dealWithData then
      self:dealWithData(chapterInfo.data)
    else
      return
    end
    if self.mSelectedMode == M.MAIN then
      self:showStage()
    else
      self:showExtraStage()
    end
    CloudData.SHOW_DUNGEON_PASS_ANI = -1
    self:checkBoxNew()
    self:dealUserGuide()
  end
  
  DYHttpMgr.dungeonInit(tFuncListener)
end

function M:dealWithData(info)
  CloudData.CHAPTER_INFO_TABLE = info
  local mainProgress = tonumber(CloudData.CHAPTER_INFO_TABLE.main.stageId) % 10000
  local eliteProgress = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.stageId) % 20000
  self.mStageProgress = mainProgress
  self.mExtraStageProgress = eliteProgress
  CloudData.MAIN_STAGE_PROGRESS = mainProgress
  CloudData.ELITE_STAGE_PROGRESS = eliteProgress
  local boxInfo = {
    elite = info.elite.chapterInfo,
    main = {
      chapterInfo = info.main.chapterInfo
    }
  }
  local stageInfo = {}
  for k, v in pairs(info.main.stageInfo) do
    stageInfo[tostring(k)] = v.starCount
  end
  boxInfo.main.stageInfo = stageInfo
  CloudData.DUNGEON_MAIN_BOX_NUM = DataUtils.stageMainBoxInfo(boxInfo)
  CloudData.DUNGEON_ELITE_BOX_NUM = DataUtils.stageEliteBoxInfo(boxInfo)
end

function M:initParamData()
  GameManager.STAGE_NUM = 0
  GameManager.ELITE_STAGE_NUM = 0
  if self.mExpLevel >= #DataRetainer.PLAYER_EXP_LEVEL_INFO - 1 then
    self.mExpLevel = #DataRetainer.PLAYER_EXP_LEVEL_INFO - 1
    self.mLevelRate = 99
  else
    local playerExpInfo = DYCommon.getDataByTag(DataRetainer.PLAYER_EXP_LEVEL_INFO, "level", tostring(self.mExpLevel))[1]
    if not playerExpInfo then
      DDERROR("playerExpInfo index : %d with error data", tonumber(self.mExpLevel))
      return
    end
    local need = tonumber(playerExpInfo.exp)
    local expSum = tonumber(playerExpInfo.expSum)
    local cur = need - (expSum - CloudData.EXP)
    self.mLevelRate = math.floor(cur / need * 100)
    if 0 > self.mLevelRate then
      self.mLevelRate = 0
    elseif self.mLevelRate > 99 then
      self.mLevelRate = 99
    end
  end
end

function M:initBg()
  self.mBg = display.newSprite("stage/bg.png", display.cx, display.cy):addTo(self, 1)
  cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):scale(0.8):align(display.CENTER, display.width * 0.05, display.height * 0.95):onButtonClicked(function()
    self:returnCallBack()
  end):addTo(self, 15)
  self:initTopInfoUI()
  self.mStageBtn = cc.ui.UIPushButton.new({
    normal = "stage/title_main.png",
    disabled = "stage/title_main1.png"
  }):onButtonClicked(function()
    self:showMap(true)
    self:showStage()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.22, self.mBg:getContentSize().height * 0.823 - 10):addTo(self.mBg)
  self.mStageBtn.mNewMark = display.newSprite("common_ui/red_point.png"):hide():align(display.CENTER, 60, 5):addTo(self.mStageBtn)
  self.mExtraBtn = cc.ui.UIPushButton.new({
    normal = "stage/title_elite.png",
    disabled = "stage/title_elite1.png"
  }):onButtonClicked(function()
    self:showMap(false)
    self:showExtraStage()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.36, self.mBg:getContentSize().height * 0.823 - 10):addTo(self.mBg)
  self.mExtraBtn.mNewMark = display.newSprite("common_ui/red_point.png"):hide():align(display.CENTER, 60, 5):addTo(self.mExtraBtn)
  
  local function tFuncUpdate()
    self:checkBoxNew()
  end
  
  DYNotification.registerScriptObserver(self, tFuncUpdate, DY_KEY.kGotStageBox)
  local levelLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = "L" .. self.mExpLevel,
    font = "fonts/white_num.fnt"
  }):scale(1.2):align(display.CENTER_RIGHT, self.mBg:getContentSize().width * 0.525, self.mBg:getContentSize().height * 0.82):addTo(self.mBg)
  local progressFrame = display.newSprite("stage/exp_progress_bg.png", self.mBg:getContentSize().width * 0.7, self.mBg:getContentSize().height * 0.825):addTo(self.mBg)
  self.mProgressBar = display.newProgressTimer("stage/exp_progress_bar.png", display.PROGRESS_TIMER_BAR):pos(progressFrame:getContentSize().width * 0.5, progressFrame:getContentSize().height * 0.5):addTo(progressFrame)
  self.mProgressBar:setMidpoint(cc.p(0, 0))
  self.mProgressBar:setBarChangeRate(cc.p(1, 0))
  self.mProgressBar:setPercentage(self.mLevelRate)
  
  local function tFuncUpdate()
    self.mExpLevel = CloudData.USER_LEVEL
    levelLabel:setString("L" .. self.mExpLevel)
    if self.mExpLevel >= #DataRetainer.PLAYER_EXP_LEVEL_INFO - 1 then
      self.mExpLevel = #DataRetainer.PLAYER_EXP_LEVEL_INFO - 1
      self.mProgressBar:setPercentage(99)
    else
      local playerExpInfo = DYCommon.getDataByTag(DataRetainer.PLAYER_EXP_LEVEL_INFO, "level", tostring(self.mExpLevel))[1]
      if not playerExpInfo then
        DDLOG("playerExpInfo index : %d with error data", tonumber(self.mExpLevel))
        return
      end
      local need = tonumber(playerExpInfo.exp)
      local expSum = tonumber(playerExpInfo.expSum)
      local cur = need - (expSum - CloudData.EXP)
      self.mLevelRate = math.floor(cur / need * 100)
      if self.mLevelRate < 0 then
        self.mLevelRate = 0
      elseif 99 < self.mLevelRate then
        self.mLevelRate = 99
      end
      self.mProgressBar:setPercentage(self.mLevelRate)
    end
  end
  
  DYNotification.registerScriptObserver(self, tFuncUpdate, DY_KEY.kUpdateUserExp)
  self.mTimeStr = display.newSprite("stage/time_str.png", self.mBg:getContentSize().width * 0.48, self.mBg:getContentSize().height * 0.7):addTo(self.mBg)
  self.mTimeStr:setVisible(false)
  self.mEliteTimeLabel = cc.ui.UILabel.new({
    text = "",
    size = 24,
    color = cc.c3b(58, 255, 12),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTimeStr:getContentSize().width + 15, self.mTimeStr:getContentSize().height * 0.49 - 2):addTo(self.mTimeStr)
  self.mEliteTimeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  
  local function tFuncUpdate()
    self.mTimeStr:setVisible(true)
    local times = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.challengeTimes)
    self.mEliteTimeLabel:setString(times)
  end
  
  DYNotification.registerScriptObserver(self, tFuncUpdate, DY_KEY.kUpdateEliteTimes)
  if self.mSelectedMode == M.MAIN then
    self:showMap(true)
  else
    self:showMap(false)
  end
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new()
  self:add(self.mPkBubble, 900)
end

function M:checkBoxNew()
  self.mStageBtn.mNewMark:setVisible(false)
  for k, v in pairs(CloudData.DUNGEON_MAIN_BOX_NUM) do
    if tonumber(v) > 0 then
      self.mStageBtn.mNewMark:setVisible(true)
      break
    end
  end
  self.mExtraBtn.mNewMark:setVisible(false)
  for k, v in pairs(CloudData.DUNGEON_ELITE_BOX_NUM) do
    if tonumber(v) > 0 then
      self.mExtraBtn.mNewMark:setVisible(true)
      break
    end
  end
  for i = 1, #self.mChapterIconsTable do
    local chapterIcon = self.mChapterIconsTable[i]
    chapterIcon:checkNewBox()
  end
end

function M:initTopInfoUI()
  local energyLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ENERGY, true)
  energyLabel:setPosition(cc.p(display.width * 0.27, display.height * 0.95))
  self:addChild(energyLabel, 15)
  local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH, true)
  peachLabel:setPosition(cc.p(display.width * 0.85, display.height * 0.95))
  self:addChild(peachLabel, 15)
  local essenceLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ESSENCE, true)
  essenceLabel:setPosition(display.width * 0.56, display.height * 0.95)
  self:addChild(essenceLabel, 15)
end

function M:showMap(tag)
  if self.mMapNode then
    self.mMapNode:removeSelf()
    self.mMapNode = nil
  end
  if tag then
    self.mMapNode = display.newSprite("stage/map_main.png")
  else
    self.mMapNode = display.newSprite("stage/map_elite.png")
  end
  self.mMapWidth = self.mMapNode:getContentSize().width
  self.mMapNode:setAnchorPoint(0, 0)
  self.mMapNode:setPosition(self.mBorderX, 90)
  self.mBg:addChild(self.mMapNode, -1)
  self.mMapNode:setTouchEnabled(true)
  self.mMapNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouch(event.name, event.x, event.y)
  end)
  local offsetX = {
    -100,
    -300,
    100,
    300
  }
  local v = self.mMapNode:getContentSize().width / 60
  for i = 1, 4 do
    local cloud = display.newSprite("stage/cloud" .. i .. ".png"):pos(offsetX[i], self.mMapNode:getContentSize().height - i * 75):addTo(self.mMapNode, 50)
    local t = (self.mMapNode:getContentSize().width + 100 - offsetX[i]) / v
    local ac = transition.sequence({
      cc.MoveTo:create(t, cc.p(self.mMapNode:getContentSize().width + 100, self.mMapNode:getContentSize().height - i * 75)),
      cc.CallFunc:create(function()
        cloud:setPositionX(offsetX[i])
      end)
    })
    cloud:runAction(cc.RepeatForever:create(ac))
  end
  local offsetX1 = {
    1000,
    800,
    1200,
    1400
  }
  for i = 1, 4 do
    local cloud = display.newSprite("stage/cloud" .. i .. ".png"):pos(offsetX1[i], self.mMapNode:getContentSize().height - i * 75):addTo(self.mMapNode, 50)
    local cloud1 = display.newSprite("stage/cloud" .. i .. ".png"):hide():pos(0, self.mMapNode:getContentSize().height - i * 75):addTo(self.mMapNode, 50)
    local t = (self.mMapNode:getContentSize().width + 100 - offsetX1[i]) / v
    local ac = transition.sequence({
      cc.MoveTo:create(t, cc.p(self.mMapNode:getContentSize().width + 100, self.mMapNode:getContentSize().height - i * 75)),
      cc.CallFunc:create(function()
        t = (self.mMapNode:getContentSize().width + 100) / v
        cloud:removeSelf()
        local ac1 = transition.sequence({
          cc.MoveTo:create(t, cc.p(self.mMapNode:getContentSize().width + 100, self.mMapNode:getContentSize().height - i * 75)),
          cc.CallFunc:create(function()
            cloud1:setPositionX(0)
          end)
        })
        cloud1:show()
        cloud1:runAction(cc.RepeatForever:create(ac1))
      end)
    })
    cloud:runAction(ac)
  end
  local offsetX2 = {
    -30,
    -80,
    -40
  }
  local scale = {
    0.75,
    0.8,
    0.95
  }
  for i = 1, 3 do
    local frames = display.newFrames("bird%d.png", 1, 10)
    local animation = display.newAnimation(frames, 0.2)
    local emptyPic = display.newSprite():scale(scale[i]):pos(offsetX2[i], 160 - 15 * i):addTo(self.mMapNode, 55)
    local ac = transition.sequence({
      cc.MoveBy:create(20, cc.p(self.mMapNode:getContentSize().width + 100, 0)),
      cc.CallFunc:create(function()
        emptyPic:setPositionX(offsetX2[i])
      end)
    })
    emptyPic:playAnimationForever(animation, 0)
    emptyPic:runAction(cc.RepeatForever:create(ac))
  end
end

function M:showStage()
  if not self.mDataLoaded then
    return
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  GameManager.MODE = 0
  self.mStageBtn:setButtonEnabled(false)
  self.mExtraBtn:setButtonEnabled(true)
  self.mIsMian = true
  self.mTimeStr:setVisible(false)
  if self.mSelectedMode ~= M.MAIN then
    self.mSelectedChapter = 0
    self.mSelectedStage = 0
  end
  self.mChapterIconsTable = {}
  local posTable = self:getPosTable()
  for i = 1, #posTable do
    local chapterIcon = IconChapter.new(i)
    if i == 1 then
      chapterIcon:playUnlockAnimation()
    end
    chapterIcon:setPosition(posTable[i].x, posTable[i].y)
    self.mMapNode:addChild(chapterIcon, 2)
    table.insert(self.mChapterIconsTable, chapterIcon)
  end
  local y = self.mMapNode:getPositionY()
  local pos = cc.p(self.mBorderX - (self.mMapWidth - self.mScreenWidth) / 2, y)
  if self.mStageProgress < 60 or 0 < self.mSelectedChapter and self.mSelectedChapter < 7 then
    pos = cc.p(self.mBorderX, y)
  elseif self.mStageProgress >= 90 or self.mSelectedChapter > 9 then
    pos = cc.p(self.mBorderX - (self.mMapWidth - self.mScreenWidth), y)
  end
  self.mMapNode:runAction(cc.MoveTo:create(0.3, pos))
  if 0 < self.mSelectedChapter then
    local chapterIcon = self.mChapterIconsTable[self.mSelectedChapter]
    if chapterIcon and chapterIcon.mIsUnlock then
      local chapterlayer = LayerChapter.new(self.mSelectedChapter, self.mSelectedStage)
      self:addChild(chapterlayer, 20)
    end
    self.mSelectedChapter = 0
    self.mSelectedStage = 0
  end
end

function M:showExtraStage()
  if not self.mDataLoaded then
    return
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  GameManager.MODE = 1
  self.mStageBtn:setButtonEnabled(true)
  self.mExtraBtn:setButtonEnabled(false)
  self.mIsMian = false
  if self.mSelectedMode == M.MAIN then
    self.mSelectedChapter = 0
    self.mSelectedStage = 0
  end
  self.mChapterIconsTable = {}
  local posTable = self:getPosTable()
  for i = 1, #posTable do
    local chapterIcon = IconExtraChapter.new(i)
    chapterIcon:setPosition(posTable[i].x, posTable[i].y)
    self.mMapNode:addChild(chapterIcon, 2)
    table.insert(self.mChapterIconsTable, chapterIcon)
  end
  local y = self.mMapNode:getPositionY()
  local pos
  if self.mExtraStageProgress < 24 or self.mSelectedChapter > 0 and self.mSelectedChapter < 7 then
    pos = cc.p(self.mBorderX - 10, y)
    self.mMapNode:runAction(cc.MoveTo:create(0.1, pos))
  else
    pos = cc.p(self.mBorderX - (self.mMapWidth - self.mScreenWidth) + 450, y)
    self.mMapNode:runAction(cc.MoveTo:create(0.3, pos))
  end
  if self.mSelectedChapter > 0 then
    local chapterIcon = self.mChapterIconsTable[self.mSelectedChapter]
    if chapterIcon and chapterIcon.mIsUnlock then
      local chapterlayer = LayerExtraChapter.new(self.mSelectedChapter, self.mSelectedStage)
      self:addChild(chapterlayer, 20)
    end
    self.mSelectedChapter = 0
    self.mSelectedStage = 0
  end
  self.mTimeStr:setVisible(true)
  local times = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.challengeTimes)
  self.mEliteTimeLabel:setString(times)
end

function M:touchChapterIcon(num)
  local chapterlayer = LayerChapter.new(num)
  self:addChild(chapterlayer, 20)
end

function M:touchExtraChapterIcon(num)
  local chapterlayer = LayerExtraChapter.new(num)
  self:addChild(chapterlayer, 20)
end

function M:onTouch(event, x, y)
  if event == "began" then
    self.mTouchBeginPoint = {x = x, y = y}
    self.mBeginPoint = cc.p(x, y)
    local border = self.mBorderX + self.mScreenWidth + 10
    if x > self.mBorderX - 10 and x < border then
      return true
    else
      return false
    end
  elseif event == "moved" then
    local cx = self.mMapNode:getPositionX()
    local dis = cx + (x - self.mTouchBeginPoint.x) * 2
    local maxX = self.mBorderX - (self.mMapWidth - self.mScreenWidth)
    if not self.mIsMian then
      maxX = maxX + 450
    end
    if dis > self.mBorderX then
      dis = self.mBorderX
    elseif maxX > dis then
      dis = maxX
    end
    self.mMapNode:setPositionX(dis)
    self.mTouchBeginPoint = {x = x, y = y}
  elseif event == "ended" then
    self.mTouchBeginPoint = nil
    if math.abs(x - self.mBeginPoint.x) > 20 or math.abs(y - self.mBeginPoint.y) > 20 then
      return
    end
    local point_ended = cc.p(x, y)
    for i = 1, #self.mChapterIconsTable do
      local chapterIcon = self.mChapterIconsTable[i]
      if chapterIcon ~= nil and chapterIcon.mIsUnlock and cc.rectContainsPoint(chapterIcon:getMyBoundingBox(), point_ended) then
        if self.mIsMian then
          self:touchChapterIcon(i)
        else
          self:touchExtraChapterIcon(i)
        end
      end
    end
  end
end

function M:getPosTable()
  local posTable = {}
  local info
  if self.mIsMian then
    info = DataRetainer.CHAPTER_LOCATION_INFO
  else
    info = DataRetainer.ELITE_LOCATION_INFO
  end
  for i = 1, #info - 1 do
    local posInfo = DYCommon.getDataByTag(info, "id", tostring(i))[1]
    if not posInfo then
      DDERROR("chapter position index : %d with error data", i)
    else
      posTable[i] = {
        x = tonumber(posInfo.locationx),
        y = tonumber(posInfo.locationy)
      }
    end
  end
  return posTable
end

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  if stageProgress == 20 and not DataUtils.getGuideIsFirstPlayed("DIALOGUE_STAGE20") then
    DataUtils.setGuideIsFirstPlayed("DIALOGUE_STAGE20", true)
    local guideLayer = GameDialogue.new("STAGE20_1", function()
      local guide = NoviceGuide.new("GUIDE_STAGE20_STAGESCN"):addTo(self, 999)
    end):addTo(self, 999)
  end
end

function M:returnCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  GameManager.MODE = 0
  CloudData.CHAPTER_INFO_TABLE = {}
  local nextScene = require("scenes.ChapterScene").new()
  display.replaceScene(nextScene, "fade", 0.2)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:returnCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYNotification.removeAllObservers(self)
  DYRes.unloadSheet("stage/bird_tx.plist")
  display.removeUnusedSpriteFrames()
end

return M

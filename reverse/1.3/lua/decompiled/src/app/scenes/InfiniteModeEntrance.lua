local WSToast = require("app.utils.WSToast")
local DataLabelIcon = require("app.icons.DataLabelIcon")
local LayerTeam = require("app.layers.LayerTeam")
local LayerWarResult = require("app.layers.LayerWarResult")
local LayerRule = require("app.layers.LayerRule")
local IconItem = require("app.icons.IconItem")
local M = {}
M = class("InfiniteModeEntrance", function()
  return display.newScene("InfiniteModeEntrance")
end)
M.RESET = 1
M.SWEEP = 2
M.UPSTAIR = 3

function M:ctor(needAnimation)
  GameManager.MODE = 2
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  if not audio.isMusicPlaying() then
    DYSoundMgr.playMusic(DY_SND.bgm_theme)
  end
  self.mStageLimit = #DataRetainer.INFINITE_STAGE_INFO
  self.mMaxStage = CloudData.INFINITE_MAX_STAGE
  self.mMaxWave = CloudData.INFINITE_MAX_WAVE
  self.mCurStage = CloudData.INFINITE_CUR_STAGE
  self.mTotalResetTimes = CloudData.INFINITE_MAX_RESET_TIMES
  self.mLeftResetTimes = CloudData.INFINITE_CUR_RESET_TIMES
  self.mBg = nil
  self.mProgressLabel = nil
  self.mFightLabel = nil
  self.mFightBtn = nil
  self.mResetBtn = nil
  self.mTipLayer = nil
  self.mSweepLayer = nil
  self.mListView = nil
  self.mAniType = 0
  self.mFloors = {}
  if needAnimation and 0 < needAnimation then
    self.mAniType = needAnimation
  end
  self:initBg()
  self:showFloorUI()
  self:createListView()
  self.mKeypadListener = handler(self, self.onKeypad)
end

function M:initBg()
  display.newSprite("game_infinite/entrance.png", display.cx, display.cy):addTo(self)
  self.mBg = display.newSprite("game_infinite/bg_frame.png", display.cx, display.cy - 40):addTo(self)
  cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):scale(0.8):align(display.CENTER, display.width * 0.05, display.height * 0.95):onButtonClicked(function()
    self:returnCallBack()
  end):addTo(self, 15)
  local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH, true)
  peachLabel:setPosition(cc.p(display.width * 0.25, display.height * 0.95))
  self:addChild(peachLabel, 15)
  local essenceLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ESSENCE, true)
  essenceLabel:setPosition(display.width * 0.54, display.height * 0.95)
  self:addChild(essenceLabel, 15)
  LayerRule.newRuleIcon(LayerRule.TOWER):align(display.CENTER, display.width * 0.72, display.height * 0.95):addTo(self.mBg, 5)
  cc.ui.UIPushButton.new("game_infinite/rank.png"):onButtonClicked(function()
    GameManager.MODE = 0
    display.replaceScene(require("scenes.SceneRankList").new())
  end):align(display.CENTER, display.width * 0.81, display.height * 0.95):addTo(self.mBg, 5)
  local str = string.format(DYLang.getString("S1234", ""), self.mMaxStage, self.mMaxWave)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = str,
    size = 22,
    color = cc.c3b(0, 255, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.926):addTo(self.mBg)
  self.mProgressLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S45", "") .. self.mCurStage .. DYLang.getString("S1236", ""),
    size = 28,
    color = cc.c3b(255, 236, 1),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.77, self.mBg:getContentSize().height * 0.825):addTo(self.mBg)
  cc.ui.UIPushButton.new("game_infinite/team.png"):onButtonClicked(function()
    self:showTeam()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.94, self.mBg:getContentSize().height * 0.828):addTo(self.mBg, 5)
  local fightStr = DYLang.getString("S1237", "")
  if self.mCurStage < self.mMaxStage then
    fightStr = DYLang.getString("S1238", "")
  elseif self.mMaxStage == 1 and self.mMaxWave == 0 then
    fightStr = DYLang.getString("S1239", "")
  end
  self.mFightLabel = cc.ui.UILabel.new({
    text = fightStr,
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  self.mFightLabel:enableOutline(cc.c4b(147, 78, 1, 255), 2)
  self.mFightBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }, {scale9 = true}):setButtonLabel("normal", self.mFightLabel):onButtonClicked(function()
    self:clickFightBtn()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.894, self.mBg:getContentSize().height * 0.1):addTo(self.mBg, 5)
  if self.mCurStage >= self.mStageLimit then
    self.mFightBtn:setButtonEnabled(false)
  end
  self.mResetLabel = cc.ui.UILabel.new({
    text = string.format(DYLang.getString("S1240", ""), self.mLeftResetTimes, self.mTotalResetTimes),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  self.mResetLabel:enableOutline(cc.c4b(147, 78, 1, 255), 2)
  local resetDisable = cc.ui.UILabel.new({
    text = string.format(DYLang.getString("S1241", ""), self.mTotalResetTimes),
    size = 26,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  })
  resetDisable:enableOutline(cc.c4b(40, 40, 40, 255), 2)
  self.mResetBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }, {scale9 = true}):setButtonLabel("normal", self.mResetLabel):setButtonLabel("disabled", resetDisable):onButtonClicked(function()
    self:resetCallback()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.665, self.mBg:getContentSize().height * 0.1):addTo(self.mBg)
  if self.mLeftResetTimes == 0 then
    self.mResetBtn:setButtonEnabled(false)
  end
end

function M:refreshControls()
  self.mMaxStage = CloudData.INFINITE_MAX_STAGE
  self.mMaxWave = CloudData.INFINITE_MAX_WAVE
  self.mCurStage = CloudData.INFINITE_CUR_STAGE
  self.mLeftResetTimes = CloudData.INFINITE_CUR_RESET_TIMES
  if self.mCurStage < self.mMaxStage then
    self.mFightLabel:setString(DYLang.getString("S1238", ""))
  elseif self.mCurStage == self.mMaxStage then
    self.mFightLabel:setString(DYLang.getString("S1237", ""))
  end
  if self.mCurStage >= self.mStageLimit then
    self.mFightBtn:setButtonEnabled(false)
  end
  self.mResetLabel:setString(string.format(DYLang.getString("S1240", ""), self.mLeftResetTimes, self.mTotalResetTimes))
  if self.mLeftResetTimes == 0 then
    self.mResetBtn:setButtonEnabled(false)
  end
  self.mProgressLabel:setString(DYLang.getString("S45", "") .. self.mCurStage .. DYLang.getString("S1236", ""))
  self:createListView()
end

function M:clickFightBtn()
  if self.mCurStage < self.mMaxStage then
    self:sweepCallback()
  elseif self.mCurStage == self.mMaxStage then
    self:fightCallback()
  end
end

function M:fightCallback()
  if self.mCurStage < self.mMaxStage or self.mCurStage >= self.mStageLimit then
    return
  end
  GameManager.STAGE_ID = self.mMaxStage + 40000
  GameManager.STAGE_NUM = self.mMaxStage or 0
  GameManager.MODE = 2
  display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE"))
end

function M:sweepCallback()
  if self.mCurStage >= self.mMaxStage then
    return
  end
  
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local toast = WSToast.new(info.errorMsg, 2)
      self:addChild(toast, 20)
    else
      CloudData.INFINITE_CUR_STAGE = tonumber(info.data.currentTowerStage)
      local gain = DataUtils.updateItemNum(2, tonumber(info.data.essence))
      DYAnalyze.item.get(2, "ESSENCE", gain, "TOWER_SWEEP")
      self:refreshControls()
      self.mAniType = M.SWEEP
      self:showFloorUI()
      for id, num in pairs(info.drop) do
        DataUtils.updateItemNum(id, num)
      end
    end
  end
  
  DYHttpMgr.towerSweep(tFuncListener)
end

function M:showSweepReward(info)
  self.mSweepLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 5)
  local tip = display.newSprite("common_ui/common_dialog.png", display.cx, display.cy):addTo(self.mSweepLayer)
  display.newSprite("stage/sweep_title.png"):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.87):addTo(tip)
  local textLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S1248", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  textLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.17):addTo(tip):setButtonLabel("normal", textLabel):onButtonClicked(function()
    self.mSweepLayer:runAction(cc.RemoveSelf:create())
    self.mSweepLayer = nil
  end)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(512, 191), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.52):addTo(tip)
  local awardStr = cc.ui.UILabel.new({
    text = DYLang.getString("S1249", ""),
    size = 25,
    color = cc.c3b(255, 252, 10),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.05, frame:getContentSize().height * 0.85):addTo(frame)
  awardStr:enableOutline(cc.c4b(88, 34, 1, 255), 2)
  display.newSprite("item_icon/pic_essence.png", frame:getContentSize().width * 0.25, frame:getContentSize().height * 0.85):scale(0.8):addTo(frame)
  local num = info.essenceGain
  local numLabel = cc.ui.UILabel.new({
    text = num,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.33, frame:getContentSize().height * 0.85):addTo(frame)
  numLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  if info.dropGain == nil then
    return
  end
  local sum = 1
  for id, num in pairs(info.dropGain) do
    if 0 < tonumber(id) then
      local icon = IconItem.new(tonumber(id), tonumber(num))
      icon:setPosition(frame:getContentSize().width * (0.245 * sum - 0.115), frame:getContentSize().height * 0.4)
      frame:addChild(icon)
      icon:showItemTip()
      DYAnalyze.item.get(id, "", num, "TOWER_SWEEP")
      sum = sum + 1
      if 4 < sum then
        return
      end
    end
  end
end

function M:resetCallback()
  if self.mLeftResetTimes <= 0 then
    self.mResetBtn:setButtonEnabled(false)
    return
  end
  
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local toast = WSToast.new(info.errorMsg, 2)
      self:addChild(toast, 20)
    else
      CloudData.INFINITE_CUR_RESET_TIMES = tonumber(info.data.towerLeftTimes)
      CloudData.INFINITE_CUR_STAGE = tonumber(info.data.currentTowerStage)
      self:refreshControls()
      self.mAniType = M.RESET
      self:showFloorUI()
    end
  end
  
  DYHttpMgr.towerReset(tFuncListener)
end

function M:showTeam()
  local pLayer = LayerTeam.new(LayerTeam.TEAM_NORMAL)
  self:addChild(pLayer, 20)
end

function M:showFloorUI()
  if self.mScrollNode then
    self.mScrollNode:runAction(cc.RemoveSelf:create())
    self.mScrollNode = nil
  end
  if self.mScrollView then
  end
  local sum = 4
  if 4 > self.mStageLimit - self.mCurStage then
    sum = self.mStageLimit - self.mCurStage
  end
  self.mScrollNode = cc.Node:create()
  self.mScrollNode:setContentSize(400, 130 * sum)
  self.mScrollView = cc.ui.UIScrollView.new({
    viewRect = cc.rect(115, 36, 400, 527)
  }):addScrollNode(self.mScrollNode)
  self.mBg:addChild(self.mScrollView, 5)
  self.mScrollView:setTouchEnabled(false)
  local params = {
    sum = sum,
    baseStage = self.mCurStage,
    tangPrePos = 1,
    tangPostPos = 0,
    moveTime = 0,
    dis = 0
  }
  local initPosY = -90
  if self.mAniType == M.UPSTAIR then
    params = {
      sum = sum + 1,
      baseStage = self.mCurStage - 1,
      tangPrePos = 1,
      tangPostPos = 2,
      moveTime = 0.5,
      dis = -130
    }
  elseif self.mAniType == M.SWEEP then
    params = {
      sum = sum + 8,
      baseStage = self.mCurStage - 8,
      tangPrePos = 1,
      tangPostPos = 9,
      moveTime = 0.5,
      dis = -1040
    }
  elseif self.mAniType == M.RESET then
    params = {
      sum = sum + 8,
      baseStage = 1,
      tangPrePos = 9,
      tangPostPos = 1,
      moveTime = 0.8,
      dis = 1040
    }
    initPosY = initPosY - 1040
  end
  self:initStairs(params)
  transition.moveBy(self.mScrollNode, {
    x = 0,
    y = initPosY,
    time = 0,
    easing = "sineOut",
    onComplete = function()
      self:showAni1(params)
    end
  })
end

function M:initStairs(params)
  for i = 1, params.sum do
    local stage = math.abs(params.baseStage + i - 1)
    if 100 < stage then
      break
    end
    local content = cc.Node:create()
    content:setContentSize(400, 130)
    content:setTouchEnabled(true)
    content:setTouchSwallowEnabled(true)
    local floorPic = display.newSprite("game_infinite/pedestal1.png"):align(display.CENTER, content:getContentSize().width * (stage % 2 * 0.3 + 0.35), content:getContentSize().height * 0.5):addTo(content)
    floorPic:setScaleX(1 - 2 * (stage % 2))
    if i == params.tangPrePos then
      floorPic:setTexture("game_infinite/pedestal.png")
      self.mTang1 = display.newSprite("game_infinite/tang_pic.png", floorPic:getContentSize().width * 0.5, floorPic:getContentSize().height * 1.35):addTo(floorPic)
      self.mTang1:setScaleX(1 - 2 * (stage % 2))
    elseif i == params.tangPostPos then
      self.mFloor = floorPic
      self.mTang2 = display.newSprite("game_infinite/tang_pic.png", floorPic:getContentSize().width * 0.5, floorPic:getContentSize().height * 1.35):addTo(floorPic)
      self.mTang2:setScaleX(1 - 2 * (stage % 2))
      self.mTang2:setOpacity(0)
    end
    local numFrame = display.newSprite("game_infinite/num_frame.png", 118, 33):pos(floorPic:getPositionX() - 35 + stage % 2 * 100, floorPic:getPositionY() - 10):addTo(content)
    local numLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = string.format(DYLang.getString("S1250", ""), stage),
      size = 20,
      color = cc.c3b(254, 158, 1),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, numFrame:getContentSize().width * 0.5, numFrame:getContentSize().height * 0.5):addTo(numFrame)
    display.newSprite("game_infinite/reward_pic.png", 0, 0):align(display.CENTER_RIGHT, numFrame:getPositionX() - 20, numFrame:getPositionY() - 40):addTo(content)
    display.newSprite("item_icon/pic_essence.png", numFrame:getPositionX(), numFrame:getPositionY() - 40):scale(0.6):addTo(content)
    display.newSprite("game_infinite/unknown.png", numFrame:getPositionX() + 40, numFrame:getPositionY() - 40):scale(0.4):addTo(content)
    content:setPosition(115, 130 * i)
    self.mScrollNode:addChild(content)
  end
end

function M:showAni1(params)
  if self.mAniType == 0 then
    return
  end
  self.mTang1:runAction(transition.sequence({
    cc.DelayTime:create(0),
    cc.FadeOut:create(params.moveTime)
  }))
  self.mTang2:runAction(transition.sequence({
    cc.DelayTime:create(0),
    cc.FadeIn:create(params.moveTime),
    cc.CallFunc:create(function()
      self.mFloor:setTexture("game_infinite/pedestal.png")
    end)
  }))
  transition.moveBy(self.mScrollNode, {
    x = 0,
    y = params.dis,
    time = params.moveTime,
    easing = "sineOut",
    onComplete = function()
      self.mAniType = 0
    end
  })
end

function M:createListView()
  if self.mListView then
    self.mListView:removeSelf()
    self.mListView = nil
  end
  local waveSum = DataUtils.getInfiniteWaveCount(self.mCurStage + 40000)
  local monsterIdTable = {}
  for i = 1, waveSum do
    monsterIdTable[i] = DataUtils.getMonsterIdsInWave(self.mCurStage + 40000, i)
  end
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(576, 108, 375, 346),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(self.mBg)
  for i = 1, waveSum do
    local item = self.mListView:newItem()
    local content = display.newNode()
    content:setAnchorPoint(0.5, 0.5)
    content:setContentSize(375, 138)
    local title = display.newSprite("game_infinite/wave_bg.png"):align(display.CENTER_TOP, content:getContentSize().width * 0.5, content:getContentSize().height):addTo(content)
    cc.ui.UILabel.new({
      text = DYLang.getString("S45", "") .. i .. DYLang.getString("S1252", ""),
      size = 26,
      color = cc.c3b(255, 224, 186),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, title:getContentSize().width * 0.5, title:getContentSize().height * 0.5):addTo(title)
    for j = 1, #monsterIdTable[i] do
      local id = tonumber(monsterIdTable[i][j])
      print("id =   " .. id)
      local monsterInfo = DataUtils.getMonsterModel(id)
      local icon = monsterInfo.npcIcon
      local frame = display.newSprite("common_ui/frame3.png"):scale(0.7542372881355932):align(display.CENTER, j * 91 - 40, 50):addTo(content)
      local iconFrame = cc.ui.UIPushButton.new(icon):align(display.CENTER, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame):onButtonPressed(function()
        self:monsterInfoShow(monsterInfo)
      end):onButtonRelease(function()
        if self.mTipLayer then
          self.mTipLayer:removeSelf()
          self.mTipLayer = nil
        end
      end)
      iconFrame:setTouchSwallowEnabled(false)
      if j == 1 then
        display.newSprite("game_infinite/boss.png"):align(display.RIGHT_TOP, frame:getContentSize().width, frame:getContentSize().height):addTo(frame, 1)
      end
    end
    item:addContent(content)
    item:setItemSize(375, 138)
    self.mListView:addItem(item)
  end
  self.mListView:reload()
end

function M:touchListener(event)
  if "began" ~= event.name and self.mTipLayer then
    self.mTipLayer:removeSelf()
    self.mTipLayer = nil
  end
end

function M:monsterInfoShow(monsterInfo)
  if self.mTipLayer then
    self.mTipLayer:removeSelf()
    self.mTipLayer = nil
  end
  local name = monsterInfo.npcName
  local phyDefence = monsterInfo.phyDefence
  local life = monsterInfo.life
  local magDefence = monsterInfo.magDefence
  local attack = monsterInfo.attack
  self.mTipLayer = display.newSprite("common_ui/common_tip.png"):pos(self.mBg:getContentSize().width * 0.35, self.mBg:getContentSize().height * 0.43):addTo(self.mBg, 10)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = name,
    size = 28,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTipLayer:getContentSize().width * 0.06, self.mTipLayer:getContentSize().height * 0.75):addTo(self.mTipLayer)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S1253", ""),
    size = 24,
    color = cc.c3b(254, 224, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTipLayer:getContentSize().width * 0.06, self.mTipLayer:getContentSize().height * 0.52):addTo(self.mTipLayer)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = phyDefence,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTipLayer:getContentSize().width * 0.32, self.mTipLayer:getContentSize().height * 0.52):addTo(self.mTipLayer)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S1254", ""),
    size = 24,
    color = cc.c3b(254, 224, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTipLayer:getContentSize().width * 0.52, self.mTipLayer:getContentSize().height * 0.52):addTo(self.mTipLayer)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = life,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTipLayer:getContentSize().width * 0.68, self.mTipLayer:getContentSize().height * 0.52):addTo(self.mTipLayer)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S1255", ""),
    size = 24,
    color = cc.c3b(254, 224, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTipLayer:getContentSize().width * 0.06, self.mTipLayer:getContentSize().height * 0.35):addTo(self.mTipLayer)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = magDefence,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTipLayer:getContentSize().width * 0.32, self.mTipLayer:getContentSize().height * 0.35):addTo(self.mTipLayer)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S1256", ""),
    size = 24,
    color = cc.c3b(254, 224, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTipLayer:getContentSize().width * 0.52, self.mTipLayer:getContentSize().height * 0.35):addTo(self.mTipLayer)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = attack,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTipLayer:getContentSize().width * 0.73, self.mTipLayer:getContentSize().height * 0.35):addTo(self.mTipLayer)
end

function M:returnCallBack()
  GameManager.MODE = 0
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local nextScene = require("scenes.ChapterScene").new(8)
  display.replaceScene(nextScene, "fade", 0.2)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    if self.mSweepLayer ~= nil then
      self.mSweepLayer:removeSelf()
      self.mSweepLayer = nil
    elseif self.mTipLayer ~= nil then
      self.mTipLayer:removeSelf()
      self.mTipLayer = nil
    else
      self:returnCallBack()
    end
  end
  return true
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
  GameManager.MODE = 2
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

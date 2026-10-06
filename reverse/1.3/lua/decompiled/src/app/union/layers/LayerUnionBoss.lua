local LayerFeed = require("app.union.layers.LayerUnionBossFeed")
local WSToast = require("app.utils.WSToast")
local LayerRule = require("app.layers.LayerRule")
local BossState = {
  Lock = 0,
  Idle = 1,
  Training = 2
}
local BossUnlockNeed = {
  {unionLv = 3, peach = 0},
  {unionLv = 5, peach = 0},
  {unionLv = 7, peach = 0},
  {unionLv = 9, peach = 0},
  {unionLv = 10, peach = 80000}
}

local function defaultBossData(i)
  local bossData = DataUtils.getUnionBossData(i)
  local tmp = {
    bossid = i,
    Lv = 1,
    Name = bossData.bossName,
    State = BossState.Idle,
    IsActive = false,
    IsOpen = false,
    ExpCur = 0,
    ExpMax = 10000,
    ActiveCost = 0,
    TrainCur = 0,
    TrainMax = 10000,
    TrainCost = 0,
    SkillDesc = bossData.skillDesc,
    SkillNum = bossData.skillAddNum,
    SkillUnit = "%",
    ResetRemainCount = 3,
    ResetMaxCount = 3,
    TrainRemainCount = 3,
    TrainMaxCount = 3,
    TrainRemainTime = 0,
    animature = bossData.animature,
    Feed_Record = {}
  }
  return tmp
end

local TrainPeachCost = {
  {
    0,
    200,
    300,
    300
  },
  {
    0,
    250,
    350,
    350
  },
  {
    0,
    300,
    400,
    400
  },
  {
    0,
    350,
    450,
    450
  },
  {
    0,
    500,
    700,
    700
  }
}
local M = {}
M = class("LayerGulidDefenceBoss", function()
  return display.newLayer()
end)

function M:ctor(cb)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  self.mBg = display.newSprite("union/defence/bg.jpg"):addTo(self.mNode)
  self.mBgWidth = self.mBg:getContentSize().width
  self.mBgHeight = self.mBg:getContentSize().height
  self.mIndex = 1
  self.mUnionLv = CloudData.UNION_INFO.level
  self.mTodayChallengeCount = 10 - CloudData.UNION_BOSS_FIGHT
  self.mUnion_Pos = CloudData.UNION_POS
  self.mFightCount = CloudData.UNION_SELF_INFO.fight_record or {}
  self.mCb = cb
  self.mCanClick = true
  self.mInitEnd = false
  local pageView = display.newNode():pos(0, 0):addTo(self.mBg)
  self.mBossPageView = self:createBossPageView():pos(0, 0):addTo(pageView, 1)
  self.mBossPageView:onTouch(function(event)
    if event.name == "pageChange" and self.mInitEnd == true then
      self.mIndex = event.pageIdx
      self:refreshUI()
    end
  end)
  self.mTmpPageView = pageView
  
  local function tFunc(event)
    if not self or self.__cname ~= "LayerGulidDefenceBoss" then
      return
    end
    self:initData(event.boss_data)
    self:initUI()
    self:initTrainTime()
  end
  
  self:safeSocketRequest("CMD_CLAN_BOSS_GET_DATA", nil, tFunc)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M.createNum(text0, text1, text2, lv)
  local node = display.newNode()
  local tmpScale = 0.6
  node.mLevel = lv
  node.mText = DYLabelTTF.new({
    text = text0,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):align(display.CENTER_LEFT, 0, 0):addTo(node, 4)
  node.mTextNum = cc.ui.UILabel.new({
    size = 24,
    text = string.format("%s/%s", text1, text2),
    color = cc.c3b(77, 255, 22),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, node.mText:getContentSize().width * 0.5 + 10, 0):addTo(node, 4)
  local width = node.mText:getContentSize().width + node.mTextNum:getContentSize().width + 10
  local height = node.mText:getContentSize().height
  node:size(width, height)
  local frame = display.newScale9Sprite("union/defence/bg_scale9.png", 0, 0, cc.size(width + 10, height + 4)):align(display.CENTER_LEFT, -30, 0):addTo(node)
  
  function node:updateText(text1, text2, level)
    if text2 < text1 then
      text1 = text2
    end
    if level == 10 then
      text1 = "MAX"
      text2 = "MAX"
    end
    node.mTextNum:setString(string.format("%s/%s", text1, text2))
  end
  
  if lv == 10 then
    node:updateText("MAX", "MAX")
  else
    node:updateText(text1, text2)
  end
  return node
end

function M:initData(bossData)
  self.mDefenceBoss = {}
  self.mInitEnd = true
  for i = 1, 5 do
    local tmp = defaultBossData(i)
    table.insert(self.mDefenceBoss, i, tmp)
  end
  for k, v in pairs(bossData) do
    local tmpBoss = {
      bossid = v.boss_id,
      Lv = v.level,
      Name = self.mDefenceBoss[v.boss_id].Name,
      State = BossState.Idle,
      IsActive = v.is_active,
      IsOpen = v.is_open,
      ExpCur = v.feed_exp or 0,
      ExpMax = v.upgrade_feed_exp,
      ActiveCost = 0,
      TrainCur = v.train_exp,
      TrainMax = v.upgrade_train_exp,
      TrainCost = TrainPeachCost[v.boss_id][1 + v.reset_count],
      SkillDesc = self.mDefenceBoss[v.boss_id].SkillDesc,
      SkillNum = self.mDefenceBoss[v.boss_id].SkillNum,
      SkillUnit = "%",
      ResetRemainCount = 3 - v.reset_count,
      ResetMaxCount = 3,
      TrainRemainCount = 3 - (self.mFightCount[tostring(v.boss_id)] or 0),
      TrainMaxCount = 3,
      TrainRemainTime = tonumber(v.left_time / 1000),
      animature = self.mDefenceBoss[v.boss_id].animature,
      Feed_Record = v.feed_record or {}
    }
    self.mDefenceBoss[tmpBoss.bossid] = tmpBoss
  end
end

function M:initUI()
  local boss = self.mDefenceBoss[self.mIndex]
  self.mNameLabel = display.newSprite(string.format("union/defence/boss_name%d.png", self.mIndex)):align(display.CENTER, 653, 657):addTo(self.mBg)
  self.mTodayChanglleCountLable = M.createSumChanllge(self.mTodayChallengeCount):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.245):addTo(self.mBg)
  self.mLvLabel = DYLabelTTF.new({
    text = string.format("%d\231\186\167", boss.Lv),
    size = 36,
    color = cc.c3b(255, 209, 50),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):align(display.CENTER, 524, 660):addTo(self.mBg)
  self.mExpLable = M.createNum(DYLang.getString("S1661", ""), boss.ExpCur, boss.ExpMax, boss.Lv):align(display.CENTER, self.mBg:getContentSize().width * 0.35, self.mBg:getContentSize().height * 0.85):addTo(self.mBg)
  self.mTrainLable = M.createNum(DYLang.getString("S1662", ""), boss.TrainCur, boss.TrainMax, boss.Lv):align(display.CENTER, self.mBg:getContentSize().width * 0.65, self.mBg:getContentSize().height * 0.85):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "upgrade/back.png",
    pressed = "upgrade/back.png"
  }):pos(1130, 654):addTo(self.mBg, 2):onButtonClicked(function()
    self:closeCallBack()
  end)
  LayerRule.newRuleIcon(LayerRule.UNIONBOSS):pos(178, 640):addTo(self.mBg, 2)
  self.mSkillDespLabel = M.createSkillDesp(DYLang.getString("S1663", ""), boss.SkillDesc, boss.SkillNum, boss.SkillUnit):align(display.CENTER, self.mBgWidth * 0.5 - 170, self.mBg:getContentSize().height * 0.19):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "union/defence/weiyang.png",
    pressed = "union/defence/weiyang2.png"
  }):onButtonClicked(function()
    if self.mDefenceBoss[self.mIndex].IsActive == true then
      LayerFeed.new(self.mDefenceBoss[self.mIndex], handler(self, self.feedRefreshUI)):pos(-display.cx, -display.cy):addTo(self.mNode, 50)
    else
      WSToast.new(DYLang.getString("S1665", "")):pos(0, 0):addTo(self.mNode, 50)
    end
  end):align(display.CENTER, 312, 233):addTo(self.mTmpPageView, 2)
  self.mChallengeBtn = cc.ui.UIPushButton.new({
    normal = "union/defence/tiaozhan.png",
    pressed = "union/defence/tiaozhan2.png",
    disabled = "union/defence/tiaozhan_dis.png"
  }):onButtonClicked(function()
    self:clickChallengeBtn()
  end):align(display.CENTER, 954, 233):addTo(self.mTmpPageView, 2)
  self.mChallengeBtn:setButtonEnabled(false)
  self.mChallengeLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("%d/%d", boss.TrainRemainCount, boss.TrainMaxCount),
    font = "fonts/greenNum.fnt"
  }):scale(0.6):align(display.CENTER_LEFT, self.mChallengeBtn:getContentSize().width + 45, -15):addTo(self.mChallengeBtn, 2)
  self:createDefenceBossState()
  self.mBossLabel:align(display.CENTER, self.mBg:getContentSize().width * 0.52, self.mBg:getContentSize().height * 0.1):addTo(self.mBg)
  self.mLeftArrow = display.newSprite("union/defence/btn_left.png"):pos(self.mBgWidth * 0.1, self.mBgHeight * 0.5):addTo(self.mBg)
  M.bindClickEvent(self.mLeftArrow, function()
    if self.mIndex ~= self.mBossPageView:getCurPageIdx() then
      return
    end
    self.mIndex = self.mIndex - 1
    if self.mIndex < 1 then
      self.mIndex = 1
    end
    self.mBossPageView:gotoPage(self.mIndex, true)
    self:refreshUI()
  end)
  self.mRightArrow = display.newSprite("union/defence/btn_left.png"):pos(self.mBgWidth * 0.9, self.mBgHeight * 0.5):addTo(self.mBg)
  self.mRightArrow:setScaleX(-1)
  M.bindClickEvent(self.mRightArrow, function()
    DDLOG(self.mIndex .. " / " .. self.mBossPageView:getCurPageIdx())
    if self.mIndex ~= self.mBossPageView:getCurPageIdx() then
      return
    end
    self.mIndex = self.mIndex + 1
    if self.mIndex > 5 then
      self.mIndex = 5
    end
    self.mBossPageView:gotoPage(self.mIndex, true)
    self:refreshUI()
  end)
  self:refreshUI()
end

function M:clickChallengeBtn()
  if self.mDefenceBoss[self.mIndex].TrainRemainCount > 0 and 0 < self.mTodayChallengeCount then
    GameManager.STAGE_ID = tonumber(self.mIndex) + 100
    GameManager.STAGE_NUM = 1
    GameManager.MODE = 0
    GameManager.DEFENCE_BOSS_ID = self.mIndex
    GameManager.DEFENCE_BOSS_LEVEL = self.mDefenceBoss[self.mIndex].Lv
    display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE", "NORMAL"))
  else
    WSToast.new(DYLang.getString("S1666", "")):pos(0, 0):addTo(self.mNode)
  end
end

function M:refreshUI()
  local curBoss = self.mDefenceBoss[self.mIndex]
  self.mNameLabel:setTexture(string.format("union/defence/boss_name%d.png", self.mIndex))
  self.mLvLabel:setString(curBoss.Lv .. DYLang.getString("S1667", ""))
  self.mExpLable:updateText(curBoss.ExpCur, curBoss.ExpMax, curBoss.Lv)
  self.mTrainLable:updateText(curBoss.TrainCur, curBoss.TrainMax, curBoss.Lv)
  self.mChallengeLabel:setString(string.format("%d/%d", curBoss.TrainRemainCount, curBoss.TrainMaxCount))
  if self.mBossLabel then
    self.mBossLabel:hide()
    self.mBossLabel = nil
    self:createDefenceBossState()
    self.mBossLabel:align(display.CENTER, self.mBg:getContentSize().width * 0.52, self.mBg:getContentSize().height * 0.1):addTo(self.mBg)
  end
  self.mSkillDespLabel:updateText(curBoss.SkillDesc, curBoss.SkillNum, curBoss.SkillUnit)
  if curBoss.TrainRemainTime > 0 then
    self.mChallengeBtn:setButtonEnabled(true)
  else
    self.mChallengeBtn:setButtonEnabled(false)
  end
  if self.mIndex == 1 then
    self.mLeftArrow:hide()
  else
    self.mLeftArrow:show()
  end
  if self.mIndex == 5 then
    self.mRightArrow:hide()
  else
    self.mRightArrow:show()
  end
end

function M:feedRefreshUI(index, feed_exp)
  self.mDefenceBoss[index].ExpCur = feed_exp
  self:refreshUI()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:runAction(cc.RemoveSelf:create())
    end)
  })
  if self.mCb then
    self.mCb()
  end
  self.mNode:runAction(popupLayer)
end

function M:createDefenceBossState()
  local boss = self.mDefenceBoss[self.mIndex]
  if false == boss.IsActive then
    boss.State = BossState.Lock
  elseif true == boss.IsActive and boss.TrainRemainTime <= 0 then
    boss.State = BossState.Idle
  elseif true == boss.IsActive and boss.TrainRemainTime > 0 then
    boss.State = BossState.Training
  end
  if boss.State == BossState.Lock then
    if self.mUnionLv >= BossUnlockNeed[boss.bossid].unionLv then
      self.mBossLabel = self:createActiveBtn(boss.bossid, BossUnlockNeed[boss.bossid].peach)
    else
      self.mBossLabel = M.createLockBossDecp(BossUnlockNeed[boss.bossid].unionLv, boss.Name)
    end
  elseif boss.State == BossState.Idle then
    if false == boss.IsOpen then
      self.mBossLabel = self:createTrainBtn(self.mIndex, boss.TrainCost, boss.ResetRemainCount)
    else
      self.mBossLabel = self:createTrainBtn(self.mIndex, boss.TrainCost, boss.ResetRemainCount)
    end
  elseif boss.State == BossState.Training then
    self.mBossLabel = M.createRemindTime(boss.TrainRemainTime)
    self.mChallengeBtn:setButtonEnabled(true)
  end
end

function M:initTrainTime()
  self:schedule(function()
    for i = 1, #self.mDefenceBoss do
      self.mDefenceBoss[i].TrainRemainTime = self.mDefenceBoss[i].TrainRemainTime - 1
    end
  end, 1)
end

function M:createTrainBtn(index, cost, times)
  local function tFuncCkickTrain(event)
    self.mCanClick = true
    
    dump(event)
    if event.ret_code == 0 and self.mIndex ~= nil then
      WSToast.new(DYLang.getString("S1668", "")):pos(0, 0):addTo(self.mNode)
      self.mDefenceBoss[self.mIndex].IsOpen = true
      self.mDefenceBoss[self.mIndex].TrainRemainTime = 900
      self.mDefenceBoss[self.mIndex].TrainRemainCount = 3
      DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
    else
      WSToast.new(event.err_msg):pos(0, 0):addTo(self.mNode)
    end
    self:refreshUI()
  end
  
  local node = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1669", ""),
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):scale(0.8):onButtonClicked(function()
    if self.mCanClick == false then
      return
    end
    self.mCanClick = false
    if CloudData.PEACH < cost then
      WSToast.new(string.format(DYLang.getString("S1670", ""), cost)):pos(0, 0):addTo(self.mNode)
      return
    end
    if times == 3 then
      self:safeSocketRequest("CMD_OPEN_CLAN_BOSS", {boss_id = index}, tFuncCkickTrain)
    elseif times <= 0 then
      WSToast.new(DYLang.getString("S1671", "")):pos(0, 0):addTo(self.mNode)
    else
      self:safeSocketRequest("CMD_RESET_CLAN_BOSS", {boss_id = index}, tFuncCkickTrain)
    end
  end)
  local peach = display.newSprite("item_icon/icon_1.png"):scale(0.6):align(display.CENTER, -200, 0):addTo(node)
  DYLabelTTF.new({
    text = cost,
    size = 48,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):align(display.CENTER_LEFT, 110, 60):addTo(peach, 5)
  peach:hide()
  local freeOpenLabel = DYLabelTTF.new({
    text = DYLang.getString("S1672", ""),
    size = 28,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):align(display.CENTER_LEFT, -180, 0):addTo(node, 5)
  freeOpenLabel:hide()
  local trainCount = DYLabelTTF.new({
    text = string.format("%d/3", times),
    size = 24,
    color = cc.c3b(70, 255, 45),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):align(display.CENTER_LEFT, 150, 0):addTo(node, 5)
  if 0 < cost then
    peach:show()
  else
    freeOpenLabel:show()
  end
  return node
end

function M.createLockBossDecp(level, name, extra)
  local node = display.newNode()
  node.mText0 = DYLabelTTF.new({
    text = DYLang.getString("S1673", ""),
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):align(display.CENTER_LEFT, 0, 50):addTo(node, 4)
  node.mText1 = DYLabelTTF.new({
    text = level .. DYLang.getString("S1667", ""),
    size = 24,
    color = cc.c3b(18, 255, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(node.mText0:getContentSize().width - 20, 50):addTo(node, 4)
  node.mText2 = DYLabelTTF.new({
    text = DYLang.getString("S1675", ""),
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(node.mText0:getContentSize().width + node.mText1:getContentSize().width, 50):addTo(node, 4)
  node.mText3 = DYLabelTTF.new({
    text = name .. "",
    size = 24,
    color = cc.c3b(255, 209, 50),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(node.mText0:getContentSize().width + node.mText1:getContentSize().width + node.mText2:getContentSize().width, 50):addTo(node, 4)
  local width = node.mText0:getContentSize().width + node.mText1:getContentSize().width + node.mText2:getContentSize().width + node.mText3:getContentSize().width
  local height = node.mText0:getContentSize().height + node.mText1:getContentSize().height + node.mText2:getContentSize().height + node.mText3:getContentSize().height
  node:size(width, height)
  return node
end

function M.createSkillDesp(textHead, text0, text1, text2)
  local node = display.newNode()
  node.mText0 = DYLabelTTF.new({
    text = textHead,
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(0, 0):addTo(node, 4)
  node.mText1 = DYLabelTTF.new({
    text = text0,
    size = 22,
    color = cc.c3b(255, 209, 50),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(node.mText0:getContentSize().width + 10, 0):addTo(node, 4)
  node.mTextNum = DYLabelTTF.new({
    UILabelType = 1,
    size = 22,
    text = " " .. text1 .. text2,
    font = "fonts/greenNum.fnt",
    dyalign = "CENTER_LEFT"
  }):scale(0.6):pos(node.mText0:getContentSize().width + node.mText1:getContentSize().width + 20, 0):addTo(node, 4)
  local width = node.mText0:getContentSize().width + node.mText1:getContentSize().width + node.mTextNum:getContentSize().width
  local height = node.mText0:getContentSize().height
  node.mFrame = display.newScale9Sprite("union/defence/bg_scale9.png", 0, 0, cc.size(width + 10, height + 4)):align(display.CENTER_LEFT, -5, 0):addTo(node)
  
  function node:updateText(text0, text1, text2)
    local width = node.mText0:getContentSize().width + node.mText1:getContentSize().width + node.mTextNum:getContentSize().width
    local height = node.mText0:getContentSize().height
    node.mText1:setString(text0)
    node.mTextNum:setString(" " .. text1 .. text2)
    node.mTextNum:pos(node.mText0:getContentSize().width + node.mText1:getContentSize().width + 10, 0)
  end
  
  node:setPositionX(-500)
  return node
end

function M:createBossListViewContent(modelName, cb)
  local node = display.newNode()
  node.animation = M.createAnimation(self, modelName, cb):addTo(node)
  node.animation:pos(640, 200)
  node.animation:setScale(0.8)
  node.animation:getAnimation():playWithIndex(0)
  return node
end

function M:createBossPageView()
  local bossPageView = cc.ui.UIPageView.new({
    viewRect = cc.rect(0, 0, 1280, 720),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  })
  local animationPath = {
    "linglu1Idle",
    "qinglong1Idle",
    "penglaigui1Idle",
    "nianshou1Idle",
    "yelong1Idle"
  }
  for i = 1, 5 do
    DDLOG(animationPath[i])
    local item = bossPageView:newItem()
    local tmpContent = M.createBossListViewContent(self, animationPath[i])
    item:addChild(tmpContent)
    bossPageView:addItem(item)
  end
  bossPageView:reload()
  return bossPageView
end

function M:createAnimation(modelName, cb)
  local armature = ccs.Armature:create(modelName)
  
  local function animationEvent(armatureBack, movementType, movementID)
    local id = movementID
    if movementType == ccs.MovementEventType.complete then
      armature:removeFromParent()
      if cb then
        cb()
      end
    end
  end
  
  armature:getAnimation():setMovementEventCallFunc(animationEvent)
  return armature
end

function M:createActiveBtn(index, cost)
  local function tFuncClickActive(event)
    self.mCanClick = true
    
    dump(event)
    if event.ret_code == 0 then
      WSToast.new(DYLang.getString("S1676", "")):pos(0, 0):addTo(self.mNode)
      DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
      self.mDefenceBoss[self.mIndex].IsActive = true
      CloudData.UNION_BOSS_LEVEL[tostring(self.mIndex)] = 1
      self.mDefenceBoss[self.mIndex].SkillNum = DataUtils.getUnionBossData(self.mIndex).skillAddNum
    else
      WSToast.new(DYLang.getString("S1677", "")):pos(0, 0):addTo(self.mNode)
    end
    self:refreshUI()
  end
  
  local node = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1678", ""),
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    if self.mCanClick == false then
      return
    end
    self.mCanClick = false
    if self.mUnion_Pos < 2 then
      WSToast.new(DYLang.getString("S1679", "")):pos(0, 0):addTo(self.mNode)
      return
    end
    if CloudData.PEACH < cost then
      WSToast.new(string.format(DYLang.getString("S1680", ""), cost)):pos(0, 0):addTo(self.mNode)
      return
    end
    self:safeSocketRequest("CMD_ACTIVATE_CLAN_BOSS", {boss_id = index}, tFuncClickActive)
  end)
  if 0 < cost then
    local peach = display.newSprite("item_icon/icon_1.png"):scale(0.6):align(display.CENTER, -200, 5):addTo(node)
    DYLabelTTF.new({
      text = cost,
      size = 48,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {
      lineColor = cc.c3b(0, 0, 0)
    }):align(display.CENTER_LEFT, 110, 60):addTo(peach, 5)
  end
  return node
end

function M.createSumChanllge(count)
  local node = display.newNode()
  node.mText0 = DYLabelTTF.new({
    text = string.format(DYLang.getString("S1681", ""), count),
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):align(display.CENTER_LEFT, 0, 0):addTo(node, 5)
  local nodeSize = node.mText0:getContentSize()
  local frame = display.newScale9Sprite("union/defence/bg_scale9.png", 0, 0, cc.size(nodeSize.width + 10, nodeSize.height + 4)):addTo(node)
  return node
end

function M.createRemindTime(time, cb)
  local node = display.newSprite("union/defence/training.png")
  node.mCleanTime = time
  node.mCb = cb
  
  function node:coverScend(sc)
    node.mHours = math.floor(sc / 3600)
    node.mMinutes = math.floor(sc % 3600 / 60)
    node.mSeconds = sc % 3600 % 60
  end
  
  node:coverScend(node.mCleanTime)
  node.mLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format(DYLang.getString("S1682", ""), node.mMinutes, node.mSeconds),
    font = "fonts/yellowNum.fnt"
  }):pos(305, 28):scale(0.5):addTo(node)
  
  function node:updateTime()
    node.mCleanTime = node.mCleanTime - 1
    node:coverScend(node.mCleanTime)
    node.mLabel:setString(string.format("%02d:%02d", node.mMinutes, node.mSeconds))
    if node.mCleanTime <= 0 then
      node.mCleanTime = 1
    end
  end
  
  node.mLabel:schedule(function()
    node:updateTime()
  end, 1)
  return node
end

function M.bindClickEvent(node, tFunc)
  node:setTouchEnabled(true)
  node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      node.pointBegan = {x = x, y = y}
      return true
    elseif name == "ended" then
      local pointEnd = {x = x, y = y}
      if math.abs(node.pointBegan.x - pointEnd.x) < 50 and math.abs(node.pointBegan.y - pointEnd.y) < 50 then
        tFunc()
      end
    end
  end)
  return node
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

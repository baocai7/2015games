local DataLabelIcon = require("app.icons.DataLabelIcon")
local LayerTeam = require("app.layers.LayerTeam")
local WSToast = require("app.utils.WSToast")
local LayerRule = require("app.layers.LayerRule")
local LayerDungeon = require("app.layers.LayerDungeon")
local IconPkBubble = require("app.icons.IconPkBubble")
local LayerPurgatoryBox = require("app.layers.LayerPurgatoryBox")
local LayerTip = require("app.babel.layers.LayerTip")
local M = {}
M = class("ScenePurgatory", function()
  return display.newScene("ScenePurgatory")
end)

function M:ctor(showPassAni)
  if not audio.isMusicPlaying() then
    DYSoundMgr.playMusic(DY_SND.bgm_theme)
  end
  GameManager.MODE = 3
  self.mBg = nil
  self.mStageId = 1
  self.mCurStage = 1
  self.mLeftResetTimes = 0
  self.mMaxResetTimes = 0
  self.mLianyubi = 0
  self.mBossCurHP = 1
  self.mBossMaxHP = 1
  self.mResetBtn = nil
  self.mLowerLevelBtn = nil
  self.mMaxStage = 8
  self.mCoinLabel = nil
  self.mHpProgress = nil
  self.mHpLabel = nil
  self.mResetTimeLabel = nil
  self.mBoxes = {}
  self.mDownstairsCost = 0
  self.mDownstairsLeftCount = 0
  self.mBossInfoTip = nil
  self.mShowPassAni = showPassAni
  DYRes.loadSheet("purgatory/purgatory_no.plist")
  self:initBg()
  self:initPkBubble()
  self:requestData()
  self.mKeypadListener = handler(self, self.onKeypad)
end

local function getBossId(index)
  local purgatoryInfo = DYCommon.getDataByTag(DataRetainer.PURGATORY_STAGE_INFO, "id", tostring(index))[1]
  if not purgatoryInfo then
    DDERROR("purgatoryInfo index : %d with error data", tonumber(index))
  end
  return checknumber(purgatoryInfo.monsterId)
end

local function getRecommendInfo(index)
  local purgatoryInfo = DYCommon.getDataByTag(DataRetainer.PURGATORY_STAGE_INFO, "id", tostring(index))[1]
  if not purgatoryInfo then
    DDERROR("purgatoryInfo index : %d with error data", tonumber(index))
  end
  local info = {}
  info.recLevel = checknumber(purgatoryInfo.recommendlevel)
  info.recPower = checknumber(purgatoryInfo.recommendpower)
  return info
end

function M:initBg()
  display.newSprite("common_ui/common_bg.png", display.cx, display.cy):addTo(self)
  self.mBg = display.newSprite("purgatory/bg.png", display.cx, display.cy):addTo(self)
  cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):align(display.CENTER, display.width * 0.05, display.height * 0.95):onButtonClicked(function()
    self:returnCallBack()
  end):addTo(self, 15)
  local title = display.newSprite("stage/title.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.94):addTo(self.mBg)
  local chapterNo = display.newSprite("#title.png"):align(display.CENTER, title:getContentSize().width * 0.35, title:getContentSize().height * 0.55):addTo(title)
  self.mTurnTitle = display.newSprite():align(display.CENTER_LEFT, chapterNo:getContentSize().width + 5, chapterNo:getContentSize().height * 0.5):addTo(chapterNo)
  local coinBg = display.newSprite("purgatory/coin_bg.png"):pos(self.mBg:getContentSize().width * 0.17, self.mBg:getContentSize().height * 0.83):addTo(self.mBg)
  self.mCoinLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, coinBg:getContentSize().width * 0.6, coinBg:getContentSize().height * 0.5):addTo(coinBg)
  self.mCoinLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local shopText = cc.ui.UILabel.new({
    text = DYLang.getString("S1323", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  shopText:enableOutline(cc.c4b(147, 78, 1, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.8):setButtonLabel("normal", shopText):onButtonClicked(function()
    require("app.layers.LayerShopNew").new(5):addTo(self, 20)
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.35, self.mBg:getContentSize().height * 0.83):addTo(self.mBg)
  LayerRule.newRuleIcon(LayerRule.PURGATORY):align(display.CENTER, self.mBg:getContentSize().width * 0.125, self.mBg:getContentSize().height * 0.93):addTo(self.mBg)
  local lab = display.newSprite("#reset.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.64, self.mBg:getContentSize().height * 0.83):addTo(self.mBg, 1)
  self.mResetTimeLabel = cc.ui.UILabel.new({
    text = "",
    size = 24,
    color = cc.c3b(88, 255, 21),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, lab:getContentSize().width + 10, lab:getContentSize().height * 0.5):addTo(lab)
  self.mResetTimeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  self.mResetBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1325", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1325", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):scale(0.8):onButtonClicked(function()
    self:clickReset()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.86, self.mBg:getContentSize().height * 0.83):addTo(self.mBg)
  self:addBossBar()
  self.mLowerLevelBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1327", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1327", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:toLowerLevel()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, 65):addTo(self.mBg)
end

function M:addBossBar()
  local progressFrame = display.newSprite("#hp_bg.png", self.mBg:getContentSize().width * 0.5, 213):addTo(self.mBg)
  self.mHpProgress = display.newProgressTimer("#hp_bar.png", display.PROGRESS_TIMER_BAR):pos(progressFrame:getContentSize().width * 0.5, progressFrame:getContentSize().height * 0.5):addTo(progressFrame)
  self.mHpProgress:setMidpoint(cc.p(0, 0))
  self.mHpProgress:setBarChangeRate(cc.p(1, 0))
  self.mHpProgress:setPercentage(100)
  display.newSprite("#boss_hp.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.17):align(display.CENTER_RIGHT, 555, 148):addTo(self.mBg)
  self.mHpLabel = cc.ui.UILabel.new({
    text = "",
    size = 30,
    color = cc.c3b(36, 255, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 570, 148):addTo(self.mBg)
  self.mHpLabel:enableOutline(cc.c4b(7, 7, 7, 255), 2)
  local posX = {
    0.9,
    0.5,
    0
  }
  local percentInfo = {
    80,
    50,
    0
  }
  for i = 1, 3 do
    local box = cc.ui.UIPushButton.new({
      normal = "#box" .. i .. ".png",
      disabled = "stage/box_active" .. i .. ".png"
    }):pos(progressFrame:getContentSize().width * posX[i], progressFrame:getContentSize().height * 0.5):addTo(progressFrame):onButtonClicked(function()
      self:showBox(i)
    end)
    local boxLabel = cc.ui.UILabel.new({
      text = percentInfo[i] .. "%",
      size = 20,
      color = cc.c3b(36, 255, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, 0, -24):addTo(box)
    boxLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    box.label = boxLabel
    self.mBoxes[i] = {}
    self.mBoxes[i].box = box
    self.mBoxes[i].percent = percentInfo[i]
  end
end

function M:showBox(index)
  LayerPurgatoryBox.new(self.mStageId, index):addTo(self, 20)
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new()
  self:add(self.mPkBubble, 900)
end

function M:requestData()
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local msg = info.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    elseif self.initData then
      self:initData(info.data)
    end
  end
  
  DYHttpMgr.initPurgatory(tFuncListener)
end

function M:initData(info)
  self.mBossCurHP = tonumber(info.bossBlood)
  local reachStage = tonumber(info.reachStage)
  if reachStage % 8 == 0 and 0 < reachStage and self.mBossCurHP <= 0 then
    self.mStageId = reachStage
  else
    self.mStageId = reachStage + 1
  end
  self.mCurStage = (self.mStageId - 1) % 8 + 1
  self.mLianyubi = tonumber(info.lianyubi)
  CloudData.PURGATORY_BOSS_LEFT_HP = self.mBossCurHP
  CloudData.PURGATORY_RECOVER_COST = info.recoverCost
  self.mLeftResetTimes = tonumber(info.leftResetTimes) or 0
  self.mMaxResetTimes = tonumber(info.totalResetTimes) or 0
  self.mDownstairsCost = checknumber(info.downstairsCost)
  self.mDownstairsLeftCount = checknumber(info.downstairsLeftCount)
  if self.mCurStage <= self.mMaxStage then
    local bossId = getBossId(self.mStageId)
    local bossInfo = DataUtils.getMonsterModel(bossId)
    self.mBossMaxHP = bossInfo.life
  end
  self:showCenterIcons()
  self:refreshControls()
  if self.mShowPassAni then
    self.mShowPassAni = false
    self:showPassAni()
  end
end

function M:addStageIcon(index)
  local item = self.mListView:newItem()
  local icon = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(200, 280), cc.rect(55, 45, 2, 2))
  display.newSprite("#stage" .. index .. ".png"):pos(100, 240):addTo(icon)
  local stageId = self.mStageId - ((self.mStageId - 1) % 8 + 1) + index
  local bossId = getBossId(stageId)
  local bossInfo = DataUtils.getMonsterModel(bossId)
  local npcIcon = bossInfo.npcIcon
  local iconFrame = cc.ui.UIPushButton.new({
    normal = "common_ui/frame6.png"
  }):scale(0.9):pos(100, 156):addTo(icon):onButtonPressed(function(event)
    self:showBossInfo(bossId, index)
  end):onButtonRelease(function(event)
    self.mBossInfoTip:runAction(cc.RemoveSelf:create())
    self.mBossInfoTip = nil
  end)
  iconFrame:setTouchSwallowEnabled(false)
  local buddhaIcon = display.newSprite(npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 1 == bossInfo.isRebel then
    buddhaIcon:setScaleX(-1)
  end
  local pTypePic = display.newSprite("team/mark_phy.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 2 == bossInfo.attackType then
    pTypePic:setTexture("team/mark_mag.png")
  end
  if index == self.mCurStage and 0 < self.mBossCurHP then
    cc.ui.UIPushButton.new("stage/challenge.png"):align(display.CENTER, 100, 55):addTo(icon):onButtonClicked(function()
      self:fightCallback()
    end)
    display.newScale9Sprite("common_ui/frame_selected.png", 0, 0, cc.size(203, 283), cc.rect(55, 55, 5, 5)):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):addTo(icon, 1)
  else
    local btn
    if index <= self.mCurStage then
      btn = display.newSprite("#pass.png")
    else
      local disabledText = cc.ui.UILabel.new({
        text = DYLang.getString("S1329", ""),
        size = 30,
        color = cc.c3b(202, 199, 199),
        font = GameManager.FONTNAME_TTF
      })
      disabledText:enableOutline(cc.c4b(40, 40, 40, 255), 2)
      btn = cc.ui.UIPushButton.new({
        normal = "common_ui/btn_disabled1.png"
      }):setButtonLabel("normal", disabledText)
    end
    btn:setPosition(100, 55)
    icon:addChild(btn)
  end
  item:addContent(icon)
  item:setItemSize(220, 280)
  self.mListView:addItem(item)
end

function M:showBossInfo(id, index)
  local posIndex = (index - 1) % 4 + 1
  local tipPosX = {
    0.505,
    0.712,
    0.29,
    0.497
  }
  local bossInfo = DataUtils.getMonsterModel(id)
  local h = 198
  local skillId = bossInfo.npcSkill
  if skillId and "table" == type(skillId) and 0 < #skillId then
    h = h + #skillId * 60
  end
  self.mBossInfoTip = display.newScale9Sprite("common_ui/common_tip.png", 0, 0, cc.size(550, h), cc.rect(200, 100, 10, 10)):pos(self.mBg:getContentSize().width * tipPosX[posIndex], display.cy):addTo(self.mBg, 2)
  local iconFrame = display.newSprite("common_ui/frame6.png"):pos(88, h - 81):addTo(self.mBossInfoTip)
  local buddhaIcon = display.newSprite(bossInfo.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 1 == bossInfo.isRebel then
    buddhaIcon:setScaleX(-1)
  end
  local bossName = cc.ui.UILabel.new({
    text = bossInfo.npcName,
    size = 20,
    color = cc.c3b(255, 48, 48),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, iconFrame:getContentSize().width * 0.5, -21):addTo(iconFrame)
  local sword = checknumber(999999999)
  if 100000 < sword then
    sword = string.format("%d\228\184\135", math.floor(sword / 10000))
  end
  local no = math.ceil(self.mStageId / 8)
  local stageId = (no - 1) * 8 + index
  local recommendInfo = getRecommendInfo(stageId)
  local info = {
    {
      key = DYLang.getString("S1330", ""),
      value = bossInfo.level,
      x = 135,
      y = 101
    },
    {
      key = DYLang.getString("S1331", ""),
      value = bossInfo.life,
      x = 315,
      y = 101
    },
    {
      key = DYLang.getString("S1332", ""),
      value = bossInfo.attack,
      x = 135,
      y = 71
    },
    {
      key = DYLang.getString("S1333", ""),
      value = bossInfo.magDefence,
      x = 315,
      y = 71
    },
    {
      key = DYLang.getString("S1334", ""),
      value = bossInfo.phyDefence,
      x = 135,
      y = 41
    },
    {
      key = DYLang.getString("S1335", ""),
      value = bossInfo.attackFrequency,
      x = 315,
      y = 41
    },
    {
      key = DYLang.getString("S1336", ""),
      value = bossInfo.attackDistance,
      x = 135,
      y = 11
    },
    {
      key = DYLang.getString("S1337", ""),
      value = bossInfo.runSpeed,
      x = 315,
      y = 11
    },
    {
      key = DYLang.getString("S1338", ""),
      value = recommendInfo.recLevel,
      x = 135,
      y = -19
    },
    {
      key = DYLang.getString("S1339", ""),
      value = recommendInfo.recPower,
      x = 315,
      y = -19
    }
  }
  for i = 1, #info do
    local keyLabel = cc.ui.UILabel.new({
      text = info[i].key,
      size = 20,
      color = cc.c3b(255, 239, 153),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, info[i].x, info[i].y):addTo(iconFrame)
    cc.ui.UILabel.new({
      text = info[i].value,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, keyLabel:getPositionX() + keyLabel:getContentSize().width + 5, keyLabel:getPositionY()):addTo(iconFrame)
  end
  if h <= 198 then
    return
  end
  local skillLv = bossInfo.skillLv
  if not skillLv or "table" ~= type(skillLv) or #skillLv == 0 then
    return
  end
  for i = 1, #skillId do
    local skillFrame = display.newSprite("common_ui/frame6.png"):scale(0.45):pos(20, bossName:getPositionY() + 10 - 60 * i):addTo(iconFrame)
    local skillInfo = DataUtils.getMonsterSkillModel(skillId[i], checknumber(skillLv[i]))
    local skillIcon = checkstring(skillInfo.skillIcon)
    display.newSprite(skillIcon):pos(skillFrame:getContentSize().width * 0.5, skillFrame:getContentSize().height * 0.5):addTo(skillFrame)
    local desc = string.format(skillInfo.skillDesc, unpack(skillInfo.effectTable))
    local valueLabel = cc.ui.UILabel.new({
      text = desc,
      size = 19,
      align = cc.ui.TEXT_ALIGN_LEFT,
      dimensions = cc.size(425, 50),
      color = cc.c3b(255, 239, 153),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, iconFrame:getContentSize().width * 0.5, skillFrame:getPositionY()):addTo(iconFrame)
  end
end

function M:showCenterIcons()
  if self.mListView then
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
  end
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(92, 260, 888, 300),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(self.mBg)
  for i = 1, 8 do
    self:addStageIcon(i)
  end
  self.mListView:reload()
end

function M:refreshControls()
  if self.mLeftResetTimes > 0 then
    self.mResetBtn:setButtonEnabled(true)
  else
    self.mResetBtn:setButtonEnabled(false)
  end
  self.mResetTimeLabel:setString(self.mLeftResetTimes .. "/" .. self.mMaxResetTimes)
  self.mCoinLabel:setString(self.mLianyubi)
  local bossHpPercent = 0
  if self.mCurStage <= self.mMaxStage then
    local str = ""
    if self.mBossCurHP >= 100000 then
      local num = math.floor(self.mBossCurHP / 10000)
      str = str .. num .. DYLang.getString("S1340", "")
    else
      str = str .. self.mBossCurHP .. " / "
    end
    if 100000 <= self.mBossMaxHP then
      local num = math.floor(self.mBossMaxHP / 10000)
      str = str .. num .. DYLang.getString("S42", "")
    else
      str = str .. self.mBossMaxHP
    end
    self.mHpLabel:setString(str)
    bossHpPercent = self.mBossCurHP / self.mBossMaxHP * 100
    self.mHpProgress:setPercentage(bossHpPercent)
  else
    self.mHpLabel:setString("0")
    self.mHpProgress:setPercentage(0)
  end
  if self.mCurStage > 4 then
    self.mListView:moveItems(1, 8, -880, 0, true)
  end
  local no = math.ceil(self.mStageId / 8)
  self.mTurnTitle:setSpriteFrame("title" .. no .. ".png")
  if 0 < self.mDownstairsLeftCount and 1 < no then
    self.mLowerLevelBtn:setButtonEnabled(true)
  else
    self.mLowerLevelBtn:setButtonEnabled(false)
  end
  for i = 1, #self.mBoxes do
    local box = self.mBoxes[i].box
    if checknumber(bossHpPercent) <= checknumber(self.mBoxes[i].percent) then
      box:setButtonEnabled(false)
      if box.label then
        box.label:setVisible(false)
      end
    else
      box:setButtonEnabled(true)
      if box.label then
        box.label:setVisible(true)
      end
    end
    box:setVisible(true)
  end
end

function M:fightCallback()
  GameManager.STAGE_ID = self.mStageId
  GameManager.STAGE_NUM = self.mCurStage
  GameManager.MODE = 3
  local pLayer = LayerTeam.new(LayerTeam.TEAM_PURGATORY)
  self:addChild(pLayer, 20)
end

function M:clickReset()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  if self.mLeftResetTimes <= 0 then
    local tip = WSToast.new(DYLang.getString("S1342", ""))
    self:addChild(tip, 20)
    return
  else
    self:showResetWarning()
  end
end

function M:showResetWarning()
  self.mResetWarningLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 20)
  local tip = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(598, 342), cc.rect(598, 231, 0, 50)):pos(display.cx, display.cy):addTo(self.mResetWarningLayer)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(515, 130), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.62):addTo(tip)
  local strLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S1343", ""),
    size = 30,
    color = cc.c3b(87, 53, 10),
    dimensions = cc.size(460, 70),
    align = cc.ui.TEXT_ALIGN_CENTER,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  self.mBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1344", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, tip:getContentSize().width * 0.3, tip:getContentSize().height * 0.25):onButtonClicked(function()
    self.mResetWarningLayer:runAction(cc.RemoveSelf:create())
    self.mResetWarningLayer = nil
  end):addTo(tip)
  self.mBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S38", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S38", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):align(display.CENTER, tip:getContentSize().width * 0.7, tip:getContentSize().height * 0.25):onButtonClicked(function()
    self:resetCallback()
    self.mResetWarningLayer:runAction(cc.RemoveSelf:create())
    self.mResetWarningLayer = nil
  end):addTo(tip)
end

function M:toLowerLevel()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  if self.mDownstairsLeftCount <= 0 then
    local tip = WSToast.new(DYLang.getString("S1342", ""))
    self:addChild(tip, 20)
    return
  else
    local str = DYLang.getString("S1348", "") .. self.mDownstairsCost .. DYLang.getString("S1349", "")
    local tip = LayerTip.new(str, handler(self, self.toLowerLevelCb))
    self:addChild(tip, 20)
  end
end

function M:toLowerLevelCb()
  if CloudData.PEACH < self.mDownstairsCost then
    WSToast.new(DYLang.getString("S1350", "")):addTo(self, 20)
    return
  end
  
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local toast = WSToast.new(info.errorMsg, 2)
      self:addChild(toast, 20)
    else
      DataUtils.updateItemNum(1, checknumber(info.data.peachLeft))
      self:initData(info.data)
    end
  end
  
  DYHttpMgr.purgatoryDownstairs(tFuncListener)
end

function M:test()
  GameManager.STAGE_ID = self.mStageId
  GameManager.STAGE_NUM = self.mCurStage
  GameManager.MODE = 3
  GameData = {}
  GameData.BATTLE_TIME = 999
  local warResult = 1
  local team = DataUtils.getBuddhaTableOnTeam()
  local teamInfoTable = {}
  for i, buddhaId in pairs(team) do
    if buddhaId ~= "" then
      local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
      local tempTable = {}
      tempTable.buddhaId = buddhaId
      tempTable.level = buddhaModel.level
      tempTable.star = buddhaModel.starLevel
      table.insert(teamInfoTable, tempTable)
    end
  end
  local teamInfoStr = json.encode(teamInfoTable)
  
  local function tFuncListener(info)
    local wrl = LayerWarResult.new(LayerWarResult.WIN)
    self:addChild(wrl, 20)
  end
  
  local bossBlood = 0
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&bossBlood=%s&fightResult=%s&stageId=%s&team=%s&token=%s&uid=%s", strAppSecret .. "", bossBlood .. "", warResult .. "", GameManager.STAGE_ID .. "", teamInfoStr .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.bossBlood = bossBlood
  params.fightResult = warResult
  params.stageId = GameManager.STAGE_ID
  params.team = teamInfoStr
  params.sign = crypto.md5(strSign, false)
  DYHttpMgr.purgatoryWarResult(tFuncListener, params)
end

function M:resetCallback()
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local toast = WSToast.new(info.errorMsg, 2)
      
      self:addChild(toast, 20)
    else
      self:buddhaRecover()
      self:initData(info.data)
    end
  end
  
  DYHttpMgr.resetPurgatoryStage(tFuncListener)
end

function M:buddhaRecover()
  local buddhaIds = DataUtils.getBuddhaIdsTableTeamScene()
  for k, v in pairs(buddhaIds) do
    local buddhaModel = DataUtils.getBuddhaModel(v)
    if 2 == buddhaModel.buddhaState then
      buddhaModel.buddhaState = 1
      CloudData.NPC_INFO[buddhaModel.npcId].status = 1
    end
  end
end

function M:showPassAni()
  self.mPassAniMask = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 20)
  local tip = display.newSprite("purgatory/pass_tip.png"):scale(0):pos(display.cx, display.cy):addTo(self.mPassAniMask)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  tip:runAction(popupLayer)
  local strLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S1353", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  strLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", strLabel):onButtonClicked(function()
    self.mPassAniMask:runAction(cc.RemoveSelf:create())
    self.mPassAniMask = nil
  end):align(display.CENTER, tip:getContentSize().width * 0.5, -50):addTo(tip)
end

function M:returnCallBack()
  GameManager.MODE = 0
  local nextScene = require("scenes.ChapterScene").new(8)
  display.replaceScene(nextScene, "fade", 0.2)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    if self.mPassAniMask then
      self.mPassAniMask:runAction(cc.RemoveSelf:create())
      self.mPassAniMask = nil
    elseif self.mResetWarningLayer then
      self.mResetWarningLayer:runAction(cc.RemoveSelf:create())
      self.mResetWarningLayer = nil
    else
      self:returnCallBack()
    end
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
  GameManager.MODE = 3
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYRes.unloadSheet("purgatory/purgatory_no.plist")
end

return M

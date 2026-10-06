local WSToast = require("app.utils.WSToast")
local LayerUpgradeSkill = require("app.layers.LayerUpgradeSkill")
local LayerBuddhaBreak = require("app.layers.LayerBuddhaBreak")
local LayerBuddhaAdvance = require("app.layers.LayerBuddhaAdvance")
local LayerBuddhaAwake = require("app.layers.LayerBuddhaAwake")
local LayerLackEssence = require("app.layers.LayerLackEssence")
local NewFellowLayer = require("app.layers.NewFellowLayer")
local LayerItem = require("app.layers.LayerItem")
local BuddhaSkillIcon = require("app.icons.BuddhaSkillIcon")
local BuddhaFateIcon = require("app.icons.BuddhaFateIcon")
local NoviceGuide = require("app.utils.NoviceGuide")
local GameDialogue = require("app.utils.GameDialogue")
local M = {}
local CLASS_NAME = UpgradeBuddhaLayer
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(buddhaModel, handler)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  DYRes.loadSheet("animation/tx_double_awake.plist")
  if handler then
    self.mHandler = handler
  end
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mEmptyNode = display.newNode()
  self.mEmptyNode:setPosition(display.cx, display.cy)
  self:addChild(self.mEmptyNode)
  self.mFileInfo = {}
  self.mLevelAdd = 0
  self:initBuddhaData_(buddhaModel)
  self.mSkillIconTable = {}
  self:initUI_()
  self:dealUserGuide()
end

function M:initBuddhaData_(buddhaModel)
  self.mBuddhaModel = buddhaModel
  self.mBuddhaName = buddhaModel.npcName
  self.mBuddhaLevel = buddhaModel.level
  self.mCurrStarLevel = buddhaModel.starLevel
  self.mBuddhaLife = buddhaModel.life
  self.mBuddhaAttack = buddhaModel.attack
  self.mAttackSpeed = buddhaModel.attackFrequency
  self.mCdTime = buddhaModel.cdTime
  self.mMoveSpeed = buddhaModel.runSpeed
  self.mArmatureFile = buddhaModel.armatureFile
  self.mUpMove = buddhaModel.upMove
  self.mAdaptScale = buddhaModel.zoomMultiple
  self.mAttackTime = buddhaModel.attackTime
  self.mBuddhaCE = buddhaModel.attackAssessment
  self.mPhyDefense = buddhaModel.phyDefence
  self.mMagDefense = buddhaModel.magDefence
  self.mAttackDistance = buddhaModel.attackDistance * buddhaModel.sizeInBattle
end

function M:initUI_()
  self.mBg = display.newSprite("upgrade/info_bg.png"):addTo(self.mEmptyNode)
  if self.mBuddhaModel.buddhaState > 0 then
    self:performWithDelay(function()
      self.mSoundId = DYSoundMgr.playEffect(self.mBuddhaModel.buddhaSound)
    end, 0.1)
  end
  self:propertyShow()
  self:initUpgradeBtn()
  self:initAdvanceBtn()
  self:initBreakBtn()
  self:armatureShow()
  self:skillShow()
  self:fateShow()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.97, self.mBg:getContentSize().height * 0.96):onButtonClicked(function()
    self:closeCallBack_()
  end):addTo(self.mBg)
end

function M:propertyShow()
  local propertyNumList = {
    self.mBuddhaLife,
    self.mBuddhaAttack,
    self.mPhyDefense,
    self.mMagDefense,
    self.mAttackDistance,
    self.mAttackSpeed,
    self.mCdTime,
    self.mMoveSpeed
  }
  local propertyAddNumList = {
    self.mBuddhaModel.addLife,
    self.mBuddhaModel.addAttack,
    self.mBuddhaModel.addPhyDefence,
    self.mBuddhaModel.addMagDefence
  }
  self.mProLabelList = {}
  self.mProAddLabelList = {}
  for i = 1, #propertyNumList do
    local lb = cc.ui.UILabel.new({
      UILabelType = 2,
      text = propertyNumList[i],
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, self.mBg:getContentSize().width * (0.81 - i % 2 * 0.22), self.mBg:getContentSize().height * (0.88 - 0.047 * math.ceil(i / 2))):addTo(self.mBg)
    table.insert(self.mProLabelList, lb)
  end
  for i = 1, #propertyAddNumList do
    local baseLB = self.mProLabelList[i]
    local lb = cc.ui.UILabel.new({
      UILabelType = 2,
      text = " +" .. propertyAddNumList[i],
      size = 20,
      color = cc.c3b(0, 245, 5),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, baseLB:getPositionX() + baseLB:getContentSize().width, self.mBg:getContentSize().height * (0.88 - 0.047 * math.ceil(i / 2))):addTo(self.mBg)
    table.insert(self.mProAddLabelList, lb)
  end
  self.mBreakProBtn = display.newSprite("upgrade/btn_break.png"):align(display.CENTER_LEFT, self.mBg:getContentSize().width - 68, self.mBg:getContentSize().height * 0.75):addTo(self.mBg)
  local pLayer
  self.mBreakProBtn:setTouchEnabled(true)
  self.mBreakProBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      if not pLayer then
        pLayer = self:buddhaBreakProShow()
        pLayer:setPosition(display.width * 0.7, display.height * 0.68)
        pLayer:addTo(self, 20)
      end
      return true
    elseif name == "moved" then
      pLayer:show()
    elseif name == "ended" then
      pLayer:removeSelf()
      pLayer = nil
    end
  end)
  if self.mBuddhaModel.level < 50 then
    self.mBreakProBtn:hide()
  end
end

function M:skillShow()
  local skillTable = self.mBuddhaModel.npcSkill
  for i = 1, #skillTable do
    local skillId = tonumber(self.mBuddhaModel.npcSkill[i])
    local skillIcon = BuddhaSkillIcon.new(skillId, self.mBuddhaModel.npcId):pos(self.mBg:getContentSize().width * (0.44 + i * 0.11), self.mBg:getContentSize().height * 0.46):addTo(self.mBg)
    skillIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:touchSkillIcon(event.name, event.x, event.y)
    end)
    skillIcon:updateSkillState(self.mBuddhaModel.level)
    table.insert(self.mSkillIconTable, skillIcon)
  end
end

function M:initUpgradeBtn()
  if 0 == self.mBuddhaModel.buddhaState then
    return
  end
  self.mCostFrame = display.newSprite("common_ui/frame0.png"):pos(self.mBg:getContentSize().width * 0.08, self.mBg:getContentSize().height * 0.25):scale(0.55):addTo(self.mBg)
  self.mCostIcon = display.newSprite("item_icon/icon_2.png"):pos(self.mCostFrame:getContentSize().width * 0.5, self.mCostFrame:getContentSize().height * 0.5):addTo(self.mCostFrame)
  self.mTextFrame = display.newSprite("upgrade/num_label.png"):pos(self.mBg:getContentSize().width * 0.21, self.mBg:getContentSize().height * 0.25):addTo(self.mBg)
  local needCostNum = self.mBuddhaModel.upgradeCostNum
  self.mCostNumLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = needCostNum,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mTextFrame:getContentSize().width * 0.5, self.mTextFrame:getContentSize().height * 0.5):addTo(self.mTextFrame, 1)
  self.mUpgradeBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1125", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1125", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:upgradeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.39, self.mBg:getContentSize().height * 0.25):addTo(self.mBg)
  self.mOneKeyBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1127", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1127", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:upgradeOneKey()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.39, self.mBg:getContentSize().height * 0.35):addTo(self.mBg)
  if self.mBuddhaLevel >= CloudData.USER_LEVEL then
    self.mCostNumLabel:setString(DYLang.getString("S1129", ""))
    self:performWithDelay(function()
      self.mUpgradeBtn:setButtonEnabled(false)
      self.mOneKeyBtn:setButtonEnabled(false)
    end, 0)
  end
  if 9 == self.mBuddhaLevel % 10 then
    self.mCostFrame:hide()
    self.mTextFrame:hide()
    self.mUpgradeBtn:hide()
    self.mOneKeyBtn:hide()
  end
end

function M:initAdvanceBtn()
  local frame1 = display.newSprite(string.format("common_ui/frame%d.png", self.mBuddhaModel.quality)):pos(self.mBg:getContentSize().width * 0.08, self.mBg:getContentSize().height * 0.15):scale(0.55):addTo(self.mBg)
  self.mPieceIcon = display.newSprite(self.mBuddhaModel.pieceIcon):pos(frame1:getContentSize().width * 0.5, frame1:getContentSize().height * 0.5):addTo(frame1, 1)
  frame1:setTouchEnabled(true)
  frame1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    local touchInSprite = cc.rectContainsPoint(frame1:getCascadeBoundingBox(), cc.p(x, y))
    if name == "began" then
      LayerItem.new(LayerItem.TYPE_LAYER, self.mBuddhaModel.pieceID):addTo(self, 20)
      return true
    elseif name == "moved" then
    elseif name == "ended" then
    end
  end)
  local barBg = display.newSprite("upgrade/bar_bg.png"):pos(self.mBg:getContentSize().width * 0.21, self.mBg:getContentSize().height * 0.15):addTo(self.mBg)
  local currPieceNum = self.mBuddhaModel.currPieceNum
  local needPieceNum = self.mBuddhaModel.advanceCostNum
  self.mPieceNumLabel = DYLabelTTF.new({
    UILabelType = 2,
    text = string.format("%d/%d", currPieceNum, needPieceNum),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  self.mProgressTimer = cc.ProgressTimer:create(display.newSprite("upgrade/bar_pro.png")):addTo(barBg)
  self.mProgressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.mProgressTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  self.mProgressTimer:setMidpoint(cc.p(0, 0))
  self.mProgressTimer:setBarChangeRate(cc.p(1, 0))
  self.mProgressTimer:setPercentage(currPieceNum / needPieceNum * 100)
  self.mAdvancedBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1130", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1130", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:advanceCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.39, self.mBg:getContentSize().height * 0.15):addTo(self.mBg)
  if currPieceNum >= needPieceNum then
  end
  if 0 == self.mBuddhaModel.buddhaState then
    needPieceNum = self.mBuddhaModel.summonCostNum
    self.mPieceNumLabel:setString(string.format("%d/%d", currPieceNum, needPieceNum))
    self.mProgressTimer:setPercentage(currPieceNum / needPieceNum * 100)
    self.mAdvancedBtn:hide()
    self.mSummonBtn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png",
      disabled = "common_ui/btn_disabled1.png"
    }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("S1132", ""),
      size = 30,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(25, 30, 3)
    })):setButtonLabel("disabled", DYLabelTTF.new({
      text = DYLang.getString("S1132", ""),
      size = 30,
      color = cc.c3b(202, 199, 199),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(40, 40, 40)
    })):onButtonClicked(function()
      self:summonCallBack()
    end):align(display.CENTER, self.mBg:getContentSize().width * 0.39, self.mBg:getContentSize().height * 0.15):addTo(self.mBg)
    if currPieceNum >= needPieceNum then
    end
    return
  end
  if self.mBuddhaModel.starLevel >= 5 then
    self.mPieceNumLabel:setString(DYLang.getString("S1134", ""))
    self.mProgressTimer:setPercentage(100)
    self.mAdvancedBtn:hide()
  end
end

function M:initBreakBtn()
  self.mBreakBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1135", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1135", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):hide():onButtonClicked(function()
    self:breakCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.39, self.mBg:getContentSize().height * 0.25):addTo(self.mBg)
  if 9 == self.mBuddhaLevel % 10 then
    self.mBreakBtn:show()
  end
  if self.mBuddhaLevel >= CloudData.USER_LEVEL then
    self:performWithDelay(function()
      self.mBreakBtn:setButtonEnabled(false)
    end, 0)
  end
end

function M:armatureShow()
  local nameFrame = display.newSprite("upgrade/name_frame.png"):align(display.CENTER_TOP, self.mBg:getContentSize().width * 0.25, self.mBg:getContentSize().height):addTo(self.mBg, 3)
  self.mLevelLabel = cc.ui.UILabel.new({
    text = string.format("LV.%d", self.mBuddhaLevel),
    size = 20,
    color = cc.c3b(69, 48, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, nameFrame:getContentSize().width * 0.12, nameFrame:getContentSize().height * 0.3):addTo(nameFrame)
  display.newSprite(string.format("equipment/element%d.png", self.mBuddhaModel.element), 90, 605):addTo(self.mBg, 3)
  self.mBuddhaNameLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = self.mBuddhaName,
    size = 20,
    color = cc.c3b(69, 48, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, nameFrame:getContentSize().width * 0.52, nameFrame:getContentSize().height * 0.3):addTo(nameFrame)
  self.mStarPic = display.newSprite(string.format("upgrade/star%d.png", self.mCurrStarLevel)):align(display.CENTER, nameFrame:getContentSize().width * 0.5, nameFrame:getContentSize().height * 0.6):addTo(nameFrame)
  local ceFrame = display.newSprite("upgrade/ce_label.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.25, self.mBg:getContentSize().height * 0.33):addTo(self.mBg, 2)
  self.mBuddhaCELabel = cc.ui.UILabel.new({
    text = self.mBuddhaCE,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, ceFrame:getContentSize().width * 0.55, ceFrame:getContentSize().height * 0.5):addTo(ceFrame)
  local pArmatureFile = string.format("armature/%s/%s.csb", self.mArmatureFile, self.mArmatureFile)
  DYRes.loadFileInfo(pArmatureFile, self.mFileInfo)
  self.mArmature = ccs.Armature:create(self.mArmatureFile)
  self.mArmature:setPosition(self.mBg:getContentSize().width * 0.23, self.mBg:getContentSize().height * 0.45 + self.mUpMove)
  self.mArmature:setScale(self.mAdaptScale)
  if 0 == self.mBuddhaModel.buddhaState then
    self.mArmature:setColor(cc.c3b(0, 0, 0))
  end
  if 0 == self.mBuddhaModel.isRebel then
    self.mArmature:setScaleX(-1 * self.mAdaptScale)
  end
  self.mBg:addChild(self.mArmature)
  local popuplayer = transition.sequence({
    cc.CallFunc:create(function()
      self.mArmature:getAnimation():playWithIndex(1)
    end),
    cc.DelayTime:create(1.3),
    cc.CallFunc:create(function()
      self.mArmature:getAnimation():playWithIndex(2)
    end),
    cc.DelayTime:create(self.mBuddhaModel.attackTime * 1.3)
  })
  self.mArmature:runAction(cc.RepeatForever:create(popuplayer))
  self.mTag1 = display.newSprite(string.format("buddha_tag/%d.png", self.mBuddhaModel.tag1)):pos(self.mBg:getContentSize().width * 0.39, self.mBg:getContentSize().height * 0.72):addTo(self.mBg, 1)
  self.mTag2 = display.newSprite(string.format("buddha_tag/%d.png", self.mBuddhaModel.tag2)):pos(self.mBg:getContentSize().width * 0.39, self.mBg:getContentSize().height * 0.6):addTo(self.mBg, 1)
  self.mTag3 = display.newSprite(string.format("buddha_tag/%d.png", self.mBuddhaModel.tag3)):pos(self.mBg:getContentSize().width * 0.39, self.mBg:getContentSize().height * 0.48):addTo(self.mBg, 1)
  self.mAwakeBtn = cc.ui.UIPushButton.new({
    normal = "upgrade/meditation.png",
    disabled = "upgrade/meditation1.png"
  }):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    local function tFuncListener(buddhaModel)
      self.mBuddhaModel = buddhaModel
      
      self:awakeUpdate()
    end
    
    LayerBuddhaAwake.new(self.mBuddhaModel, tFuncListener):addTo(self, 20)
  end):align(display.CENTER, 90, 540):addTo(self.mBg, 5)
  if self.mBuddhaLevel < 28 then
    self.mAwakeBtn:setButtonEnabled(false)
  end
  if self.mBuddhaLevel >= 28 and CloudData.DOUBLE_ACTIVITY and tonumber(CloudData.DOUBLE_ACTIVITY.type) == 3 and 0 < CloudData.DOUBLE_ACTIVITY.status then
    local frames = display.newFrames("double_%d.png", 0, 9)
    local animation = display.newAnimation(frames, 0.1)
    local animate = cc.Animate:create(animation)
    local emptyPic = display.newSprite():pos(142, 540):addTo(self.mBg, 5)
    local seq = transition.sequence({
      animate,
      cc.DelayTime:create(0.5)
    })
    emptyPic:runAction(cc.RepeatForever:create(seq))
  end
end

function M:fateShow()
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(518, 58, 500, 135),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(self.mBg)
  for i = 1, #self.mBuddhaModel.npcFate do
    local item = listView:newItem()
    local content = BuddhaFateIcon.new(self.mBuddhaModel.npcFate[i], self.mBuddhaModel.npcId)
    item:addContent(content)
    item:setItemSize(490, 110)
    listView:addItem(item)
  end
  listView:reload()
end

function M:upgradeCallBack()
  self.mUpgradeBtn:setButtonEnabled(false)
  self.mOneKeyBtn:setButtonEnabled(false)
  local costNum = math.floor(((30 + self.mBuddhaLevel) ^ 4 / 3000 + 500) / 50) * 50
  if costNum > CloudData.ESSENCE then
    local pLayer = LayerLackEssence.new()
    self:addChild(pLayer, 20)
    self.mUpgradeBtn:setButtonEnabled(true)
    self.mOneKeyBtn:setButtonEnabled(true)
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    self.mLevelAdd = jsonTable.data.buddhaLevel - self.mBuddhaLevel
    local newSkillIds = jsonTable.data.skillIds
    self.mBuddhaLevel = jsonTable.data.buddhaLevel
    self.mBuddhaModel.level = self.mBuddhaLevel
    CloudData.NPC_INFO[self.mBuddhaModel.npcId].level = self.mBuddhaLevel
    CloudData.ESSENCE = jsonTable.data.essence
    DYSoundMgr.playEffect(DY_SND.sfx_upgrade)
    self:upgradeAnimation_()
    self:numberAction_()
    self:upgradeUpdate(newSkillIds)
    DYAnalyze.item.consume("2", "", costNum, "Upgrade_cost")
    self:dealUserGuide()
  end
  
  local params = {}
  params.buddhaId = self.mBuddhaModel.npcId
  DYHttpMgr.npcUpgrade(tFuncListener, params)
end

function M:upgradeOneKey()
  self.mUpgradeBtn:setButtonEnabled(false)
  self.mOneKeyBtn:setButtonEnabled(false)
  local costNum = math.floor(((30 + self.mBuddhaLevel) ^ 4 / 3000 + 500) / 50) * 50
  if costNum > CloudData.ESSENCE then
    local pLayer = LayerLackEssence.new()
    self:addChild(pLayer, 20)
    self.mUpgradeBtn:setButtonEnabled(true)
    self.mOneKeyBtn:setButtonEnabled(true)
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    if not self.class or self.class.__cname ~= CLASS_NAME then
      return
    end
    self.mLevelAdd = jsonTable.data.buddhaLevel - self.mBuddhaLevel
    local newSkillIds = jsonTable.data.skillIds
    self.mBuddhaLevel = jsonTable.data.buddhaLevel
    self.mBuddhaModel.level = self.mBuddhaLevel
    CloudData.NPC_INFO[self.mBuddhaModel.npcId].level = self.mBuddhaLevel
    CloudData.ESSENCE = jsonTable.data.essence
    DYSoundMgr.playEffect(DY_SND.sfx_upgrade)
    self:upgradeAnimation_()
    self:numberAction_()
    self:upgradeUpdate(newSkillIds)
    local costEssence = jsonTable.data.essenceCost
    DYAnalyze.item.consume("2", "", costEssence, "Upgrade_cost")
  end
  
  local params = {}
  params.buddhaId = self.mBuddhaModel.npcId
  DYHttpMgr.npcOnekeyUpgrade(tFuncListener, params)
end

function M:breakCallBack()
  self.mBreakBtn:setButtonEnabled(false)
  
  local function tFunc(buddhaModel_, params_)
    if not params_.isBreakSuccess then
      self.mBreakBtn:setButtonEnabled(true)
      return
    end
    self.mIsArmatureUpdate = false
    local delayTime = 0.1
    if self.mBuddhaModel.npcModelId ~= buddhaModel_.npcModelId then
      display.addSpriteFrames("new_fellow/new_fellow3.plist", "new_fellow/new_fellow3.png")
      local frames = display.newFrames("bingzhonghuode3-%d.png", 1, 23)
      local animation = display.newAnimation(frames, 0.1)
      local emptyPic = display.newSprite():pos(self.mArmature:getPositionX(), self.mArmature:getPositionY() + 100):scale(1.5):addTo(self.mBg, 10, 100)
      emptyPic:playAnimationOnce(animation, true)
      self.mIsArmatureUpdate = true
      delayTime = 1.2
    end
    self:initBuddhaData_(buddhaModel_)
    self:performWithDelay(function()
      self:breakUpdate(params_.skillIds)
    end, delayTime)
  end
  
  self.mBuddhaModel = DataUtils.getBuddhaModel(self.mBuddhaModel.npcId)
  local pLayer = LayerBuddhaBreak.new(self.mBuddhaModel, tFunc)
  self:addChild(pLayer, 20)
end

function M:advanceCallBack()
  self.mAdvancedBtn:setButtonEnabled(false)
  
  local function tFunc(buddhaModel_, params)
    if not params then
      self.mAdvancedBtn:setButtonEnabled(true)
      return
    end
    self.mBuddhaModel = buddhaModel_
    self:advanceUpdate()
  end
  
  local pLayer = LayerBuddhaAdvance.new(self.mBuddhaModel, tFunc)
  self:addChild(pLayer, 20)
end

function M:summonCallBack()
  self.mSummonBtn:setButtonEnabled(false)
  if self.mProgressTimer:getPercentage() < 100 then
    LayerItem.new(LayerItem.TYPE_LAYER, self.mBuddhaModel.pieceID):addTo(self, 20)
    self.mSummonBtn:setButtonEnabled(true)
  else
    local function tFuncListener(jsonTable)
      if jsonTable.errorCode > 0 then
        local errMsg = jsonTable.errorMsg or "UNKNOWN"
        
        WSToast.new(errMsg):addTo(self, 20)
        return
      end
      CloudData.NPC_INFO[self.mBuddhaModel.npcId].star = jsonTable.data.starLevel
      CloudData.NPC_INFO[self.mBuddhaModel.npcId].status = jsonTable.data.buddhaStatus
      CloudData.NPC_INFO[self.mBuddhaModel.npcId].level = 1
      CloudData.NPC_INFO[self.mBuddhaModel.npcId].id = self.mBuddhaModel.npcId
      CloudData.NPC_INFO[self.mBuddhaModel.npcId].equipments = {
        0,
        0,
        0,
        0
      }
      CloudData.GAME_ITEM_INFO[tostring(self.mBuddhaModel.pieceID)] = jsonTable.data.pieceCount
      local newSkillIds = jsonTable.data.skillIds
      table.removebyvalue(GameManager.UNLOCK_BUDDHA_ID, self.mBuddhaModel.npcId, true)
      self.mBuddhaModel = DataUtils.getBuddhaModel(self.mBuddhaModel.npcId)
      self:summonUpdate(newSkillIds)
      local needPieceNum = self.mBuddhaModel.summonCostNum
      DYAnalyze.item.consume(self.mBuddhaModel.pieceID, "", needPieceNum, "Summon_cost")
      local pLayer = NewFellowLayer.new(self.mBuddhaModel)
      self:addChild(pLayer, 20)
    end
    
    local params = {}
    params.buddhaId = self.mBuddhaModel.npcId
    DYHttpMgr.npcCompose(tFuncListener, params)
  end
end

function M:upgradeUpdate(newSkillIds)
  self.mBuddhaLife = self.mBuddhaLife + self.mBuddhaModel.addLife * self.mLevelAdd
  self.mBuddhaAttack = self.mBuddhaAttack + self.mBuddhaModel.addAttack * self.mLevelAdd
  self.mPhyDefense = math.round(self.mPhyDefense + self.mBuddhaModel.addPhyDefence * self.mLevelAdd)
  self.mMagDefense = math.round(self.mMagDefense + self.mBuddhaModel.addMagDefence * self.mLevelAdd)
  local tempTable = {
    self.mBuddhaLife,
    self.mBuddhaAttack,
    self.mPhyDefense,
    self.mMagDefense
  }
  for i = 1, 4 do
    local lb1 = self.mProLabelList[i]
    local currNum = tonumber(lb1:getString())
    lb1:runAction(transition.sequence({
      cc.ScaleTo:create(0.15, 1.5),
      cc.ScaleTo:create(0.15, 1),
      DYRollnum:create(0.5, currNum, tempTable[i])
    }))
    local lb2 = self.mProAddLabelList[i]
    lb2:setPositionX(lb1:getPositionX() + lb1:getContentSize().width)
  end
  for i = 1, #newSkillIds do
    local skillId = newSkillIds[i]
    if skillId ~= 0 then
      CloudData.NPC_INFO[tonumber(self.mBuddhaModel.npcId)].skills[tostring(skillId)] = 1
      for i = 1, #self.mSkillIconTable do
        local icon = self.mSkillIconTable[i]
        if icon.mSkillId == skillId then
          icon:skillUnlock(skillId, self.mBuddhaModel.npcId)
        end
      end
    end
  end
  self:checkSkillState()
  local addCE = math.round(self.mBuddhaModel.addLife * 0.1 + self.mBuddhaModel.addAttack + (self.mBuddhaModel.addPhyDefence + self.mBuddhaModel.addMagDefence) * 4 * self.mLevelAdd)
  self.mBuddhaCE = self.mBuddhaCE + addCE
  self:buddhaCEAction(self.mBuddhaCE)
  self.mLevelLabel:setString(string.format("LV.%d", self.mBuddhaLevel))
  local costNum = math.floor(((30 + self.mBuddhaLevel) ^ 4 / 3000 + 500) / 50) * 50
  self.mCostNumLabel:setString(costNum)
  self.mLevelAdd = 0
  if self.mBuddhaLevel >= 28 then
    self.mAwakeBtn:setButtonEnabled(true)
  end
  if 9 == self.mBuddhaLevel % 10 then
    self.mBreakBtn:show()
    self.mBreakBtn:setButtonEnabled(true)
    if self.mBuddhaLevel >= CloudData.USER_LEVEL then
      self.mBreakBtn:setButtonEnabled(false)
    end
    self.mCostFrame:hide()
    self.mTextFrame:hide()
    self.mUpgradeBtn:hide()
    self.mOneKeyBtn:hide()
    return
  end
  if self.mBuddhaLevel >= CloudData.USER_LEVEL then
    self.mUpgradeBtn:setButtonEnabled(false)
    self.mOneKeyBtn:setButtonEnabled(false)
    return
  end
  self.mUpgradeBtn:setButtonEnabled(true)
  self.mOneKeyBtn:setButtonEnabled(true)
end

function M:oneKeyUpdate()
end

function M:advanceUpdate()
  self.mAdvancedBtn:setButtonEnabled(true)
  local currPieceNum = self.mBuddhaModel.currPieceNum
  local needPieceNum = self.mBuddhaModel.advanceCostNum
  self.mBuddhaLife = self.mBuddhaModel.life
  self.mBuddhaAttack = self.mBuddhaModel.attack
  self.mPhyDefense = self.mBuddhaModel.phyDefence
  self.mMagDefense = self.mBuddhaModel.magDefence
  local tempTable = {
    self.mBuddhaLife,
    self.mBuddhaAttack,
    self.mPhyDefense,
    self.mMagDefense
  }
  for i = 1, 4 do
    local lb1 = self.mProLabelList[i]
    lb1:setString(tempTable[i])
    local lb2 = self.mProAddLabelList[i]
    lb2:setPositionX(lb1:getPositionX() + lb1:getContentSize().width)
  end
  if self.mBuddhaModel.starLevel >= 5 then
    self.mPieceNumLabel:setString(DYLang.getString("S1134", ""))
    self.mProgressTimer:setPercentage(100)
    self.mAdvancedBtn:hide()
  else
    self.mPieceNumLabel:setString(string.format("%d/%d", currPieceNum, needPieceNum))
    self.mProgressTimer:setPercentage(currPieceNum / needPieceNum * 100)
  end
  self.mCurrStarLevel = self.mBuddhaModel.starLevel
  self.mStarPic:setTexture(string.format("upgrade/star%d.png", self.mCurrStarLevel))
  self.mBuddhaCE = self.mBuddhaModel.attackAssessment
  self:buddhaCEAction(self.mBuddhaCE)
end

function M:summonUpdate(newSkillIds)
  self:initUpgradeBtn()
  self.mArmature:setColor(cc.c3b(255, 255, 255))
  self.mBuddhaLife = self.mBuddhaModel.life
  self.mBuddhaAttack = self.mBuddhaModel.attack
  self.mPhyDefense = self.mBuddhaModel.phyDefence
  self.mMagDefense = self.mBuddhaModel.magDefence
  local tempTable = {
    self.mBuddhaLife,
    self.mBuddhaAttack,
    self.mPhyDefense,
    self.mMagDefense
  }
  for i = 1, 4 do
    local lb1 = self.mProLabelList[i]
    lb1:setString(tempTable[i])
    local lb2 = self.mProAddLabelList[i]
    lb2:setPositionX(lb1:getPositionX() + lb1:getContentSize().width)
  end
  for i = 1, #newSkillIds do
    local skillId = newSkillIds[i]
    if skillId ~= 0 then
      CloudData.NPC_INFO[tonumber(self.mBuddhaModel.npcId)].skills[tostring(skillId)] = 1
      for i = 1, #self.mSkillIconTable do
        local icon = self.mSkillIconTable[i]
        if icon.mSkillId == skillId then
          icon:skillUnlock(skillId, self.mBuddhaModel.npcId)
        end
      end
    end
  end
  self.mLevelLabel:setString(string.format("LV.%d", self.mBuddhaModel.level))
  self.mStarPic:setTexture(string.format("upgrade/star%d.png", self.mBuddhaModel.starLevel))
  self.mBuddhaCELabel:setString(self.mBuddhaModel.attackAssessment)
  self.mAdvancedBtn:show()
  local currPieceNum = self.mBuddhaModel.currPieceNum
  local needPieceNum = self.mBuddhaModel.advanceCostNum
  if currPieceNum < needPieceNum then
    self.mAdvancedBtn:setButtonEnabled(false)
  end
  self.mPieceNumLabel:setString(string.format("%d/%d", currPieceNum, needPieceNum))
  self.mProgressTimer:setPercentage(currPieceNum / needPieceNum * 100)
  self.mSummonBtn:removeSelf()
end

function M:breakUpdate(skillIds_)
  self.mBreakBtn:hide()
  self.mCostFrame:show()
  self.mTextFrame:show()
  self.mUpgradeBtn:show()
  self.mOneKeyBtn:show()
  self.mUpgradeBtn:setButtonEnabled(true)
  self.mOneKeyBtn:setButtonEnabled(true)
  if self.mBuddhaModel.level >= 50 then
    self.mBreakProBtn:show()
  end
  for i = 1, #skillIds_ do
    local skillId_ = skillIds_[i]
    if skillId_ ~= 0 then
      for i = 1, #self.mSkillIconTable do
        local icon = self.mSkillIconTable[i]
        if icon.mSkillId == skillId_ then
          icon:skillUnlock(skillId_, self.mBuddhaModel.npcId)
        end
      end
    end
  end
  self:checkSkillState()
  local costNum = math.floor(((30 + self.mBuddhaLevel) ^ 4 / 3000 + 500) / 50) * 50
  if self.mBuddhaLevel >= CloudData.USER_LEVEL or costNum > CloudData.ESSENCE then
    self.mUpgradeBtn:setButtonEnabled(false)
    self.mOneKeyBtn:setButtonEnabled(false)
  end
  self.mCostNumLabel:setString(costNum)
  local propertyNumList = {
    self.mBuddhaLife,
    self.mBuddhaAttack,
    self.mPhyDefense,
    self.mMagDefense,
    self.mAttackDistance,
    self.mAttackSpeed,
    self.mCdTime,
    self.mMoveSpeed
  }
  local propertyAddNumList = {
    self.mBuddhaModel.addLife,
    self.mBuddhaModel.addAttack,
    self.mBuddhaModel.addPhyDefence,
    self.mBuddhaModel.addMagDefence
  }
  for i = 1, #propertyNumList do
    local lb1 = self.mProLabelList[i]
    lb1:setString(propertyNumList[i])
    if i < 5 then
      local lb2 = self.mProAddLabelList[i]
      lb2:setString(" +" .. propertyAddNumList[i])
      lb2:setPositionX(lb1:getPositionX() + lb1:getContentSize().width)
    end
  end
  self.mBuddhaCE = self.mBuddhaModel.attackAssessment
  self:buddhaCEAction(self.mBuddhaCE)
  self.mLevelLabel:setString(string.format("LV.%d", self.mBuddhaLevel))
  self.mBuddhaNameLabel:setString(self.mBuddhaName)
  self:updateAmature_()
end

function M:skillUpgradeUpdate()
  self.mBuddhaLife = self.mBuddhaModel.life
  self.mBuddhaAttack = self.mBuddhaModel.attack
  self.mPhyDefense = self.mBuddhaModel.phyDefence
  self.mMagDefense = self.mBuddhaModel.magDefence
  local tempTable = {
    self.mBuddhaLife,
    self.mBuddhaAttack,
    self.mPhyDefense,
    self.mMagDefense
  }
  for i = 1, 4 do
    local lb1 = self.mProLabelList[i]
    lb1:setString(tempTable[i])
    local lb2 = self.mProAddLabelList[i]
    lb2:setPositionX(lb1:getPositionX() + lb1:getContentSize().width)
  end
  self:checkSkillState()
  self.mBuddhaCE = self.mBuddhaModel.attackAssessment
  self:buddhaCEAction(self.mBuddhaCE)
end

function M:awakeUpdate()
  self.mBuddhaLife = self.mBuddhaModel.life
  self.mBuddhaAttack = self.mBuddhaModel.attack
  self.mPhyDefense = self.mBuddhaModel.phyDefence
  self.mMagDefense = self.mBuddhaModel.magDefence
  local tempTable = {
    self.mBuddhaLife,
    self.mBuddhaAttack,
    self.mPhyDefense,
    self.mMagDefense
  }
  for i = 1, 4 do
    local lb1 = self.mProLabelList[i]
    lb1:setString(tempTable[i])
    local lb2 = self.mProAddLabelList[i]
    lb2:setPositionX(lb1:getPositionX() + lb1:getContentSize().width)
  end
  self.mBuddhaCE = self.mBuddhaModel.attackAssessment
  self:buddhaCEAction(self.mBuddhaCE)
end

function M:updateAmature_()
  if not self.mIsArmatureUpdate then
    return
  end
  self.mArmature:runAction(transition.sequence({
    cc.FadeOut:create(0.5),
    cc.CallFunc:create(function()
      self.mArmature:removeSelf()
      self.mArmature = nil
      DYRes.unloadFileInfo(self.mFileInfo)
      self.mFileInfo = {}
      display.removeUnusedSpriteFrames()
      local pArmatureFile = string.format("armature/%s/%s.csb", self.mArmatureFile, self.mArmatureFile)
      DYRes.loadFileInfo(pArmatureFile, self.mFileInfo)
      self.mArmature = ccs.Armature:create(self.mArmatureFile)
      self.mArmature:setPosition(self.mBg:getContentSize().width * 0.23, self.mBg:getContentSize().height * 0.45 + self.mUpMove)
      self.mArmature:setScale(self.mAdaptScale)
      if 0 == self.mBuddhaModel.buddhaState then
        self.mArmature:setColor(cc.c3b(0, 0, 0))
      end
      if 0 == self.mBuddhaModel.isRebel then
        self.mArmature:setScaleX(-1 * self.mAdaptScale)
      end
      self.mBg:addChild(self.mArmature, 1)
      local popuplayer = transition.sequence({
        cc.CallFunc:create(function()
          self.mArmature:getAnimation():playWithIndex(1)
        end),
        cc.DelayTime:create(1.3),
        cc.CallFunc:create(function()
          self.mArmature:getAnimation():playWithIndex(2)
        end),
        cc.DelayTime:create(self.mBuddhaModel.attackTime * 1.3)
      })
      self.mArmature:runAction(cc.RepeatForever:create(popuplayer))
    end)
  }))
end

function M:checkSkillState()
  for i = 1, #self.mSkillIconTable do
    local icon = self.mSkillIconTable[i]
    icon:updateSkillState(self.mBuddhaModel.level)
  end
end

function M:upgradeAnimation_()
  DYSoundMgr.playEffect(DY_SND.sfx_upgrade)
  display.addSpriteFrames("animation/upgrade_tx.plist", "animation/upgrade_tx.png")
  if self.mBg:getChildByTag(100) then
    self.mBg:removeChildByTag(100, true)
  end
  local frames = display.newFrames("upgrade_tx%d.png", 1, 10)
  local animation = display.newAnimation(frames, 0.1)
  local emptyPic = display.newSprite():pos(self.mBg:getContentSize().width * 0.23, self.mBg:getContentSize().height * 0.43):scale(1.5):addTo(self.mBg, 10, 100)
  emptyPic:playAnimationOnce(animation, true)
end

function M:numberAction_()
  local bloodNum = self.mBuddhaModel.addLife * self.mLevelAdd
  local tempBlood = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("+" .. bloodNum),
    font = "fonts/greenNum.fnt"
  }):pos(self.mProAddLabelList[1]:getPosition()):scale(0.8):addTo(self.mBg, 1)
  local moveTo1 = cc.MoveTo:create(0.5, cc.p(tempBlood:getPositionX(), tempBlood:getPositionY() + 50))
  local fadeOut1 = cc.FadeOut:create(0.5)
  tempBlood:runAction(transition.sequence({
    moveTo1,
    fadeOut1,
    cc.CallFunc:create(function()
      tempBlood:removeSelf()
    end)
  }))
  local attackNum = self.mBuddhaModel.addAttack * self.mLevelAdd
  local tempAttack = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("+" .. attackNum),
    font = "fonts/greenNum.fnt"
  }):pos(self.mProAddLabelList[2]:getPosition()):scale(0.8):addTo(self.mBg, 1)
  local moveTo2 = cc.MoveTo:create(0.5, cc.p(tempAttack:getPositionX(), tempAttack:getPositionY() + 50))
  local fadeOut2 = cc.FadeOut:create(0.5)
  tempAttack:runAction(transition.sequence({
    moveTo2,
    fadeOut2,
    cc.CallFunc:create(function()
      tempAttack:removeSelf()
    end)
  }))
end

function M:buddhaCEAction(num)
  local currNum = tonumber(self.mBuddhaCELabel:getString())
  if currNum == num then
    return
  end
  local ac = transition.sequence({
    cc.ScaleTo:create(0.15, 1.5),
    cc.ScaleTo:create(0.15, 1),
    DYRollnum:create(0.5, currNum, num)
  })
  self.mBuddhaCELabel:runAction(ac)
end

function M:buddhaBreakProShow()
  local bg = display.newSprite("upgrade/break_tip.png")
  local braakData = DataUtils.getBreakPropertyAdd(self.mBuddhaModel.npcId, self.mBuddhaModel.level)
  local tFun = {
    [1] = braakData.hit .. "%",
    [2] = braakData.miss .. "%",
    [3] = braakData.crit .. "%",
    [4] = braakData.decrit .. "%",
    [5] = braakData.critHarm .. "%",
    [6] = braakData.decritHarm .. "%"
  }
  for i = 1, 6 do
    local lb = cc.ui.UILabel.new({
      text = tFun[i],
      size = 20,
      color = cc.c3b(83, 255, 16),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 260 - i % 2 * 180, 150 - math.ceil(i / 2) * 33):addTo(bg)
    if 4 < i then
      lb:setPositionX(305 - i % 2 * 180)
    end
  end
  return bg
end

function M:pieceInfoShow_(event, pieceType)
  if "began" == event.name then
    self.mTipFrame = display.newSprite("upgrade/buddha/tip_frame.png"):align(display.LEFT_BOTTOM, -self.m_needPic:getContentSize().width * 0.65, self.m_needPic:getContentSize().height * 1.03):addTo(self.m_needPic)
    local text1 = ""
    local text2 = ""
    if 1 == pieceType then
      text1 = DYLang.getString("S1139", "")
      text2 = DYLang.getString("S1140", "")
    elseif 2 == pieceType then
      text1 = DYLang.getString("S1142", "")
      text2 = DYLang.getString("S1143", "")
    elseif 3 == pieceType then
      text1 = DYLang.getString("S1145", "")
      text2 = DYLang.getString("S1146", "")
    elseif 4 == pieceType then
      text1 = DYLang.getString("S1148", "")
      text2 = DYLang.getString("S1149", "")
    end
    local textLabel = DYRichTextUI.new({
      size = cc.size(285, 68)
    })
    textLabel:addElementText(0, display.COLOR_WHITE, 255, DYLang.getString("S1150", ""), GameManager.FONTNAME_TTF, 20)
    textLabel:addElementText(0, cc.c3b(255, 255, 0), 255, text1, GameManager.FONTNAME_TTF, 20)
    textLabel:addElementText(0, display.COLOR_WHITE, 255, DYLang.getString("S1151", ""), GameManager.FONTNAME_TTF, 20)
    textLabel:addElementText(0, cc.c3b(0, 255, 0), 255, text2, GameManager.FONTNAME_TTF, 20)
    textLabel:addElementText(0, display.COLOR_WHITE, 255, ",\230\173\166\233\129\147\228\188\154\229\149\134\229\186\151\229\143\175\229\133\145\230\141\162", GameManager.FONTNAME_TTF, 20)
    textLabel:setPosition(cc.p(self.mTipFrame:getContentSize().width * 0.5, -self.mTipFrame:getContentSize().height * 0.1))
    self.mTipFrame:addChild(textLabel)
    return true
  end
  if "ended" == event.name and self.mTipFrame then
    self.mTipFrame:removeSelf()
    self.mTipFrame = nil
  end
end

function M:touchSkillIcon(event, x, y)
  if "began" == event then
    self.mPointBegin = {x = x, y = y}
    return true
  elseif "moved" == event then
  elseif "ended" == event then
    local pointEnd = {x = x, y = y}
    if math.abs(self.mPointBegin.x - pointEnd.x) < 20 and math.abs(self.mPointBegin.y - pointEnd.y) < 20 then
      for i = 1, #self.mSkillIconTable do
        local skillIcon = self.mSkillIconTable[i]
        local touchInSprite = cc.rectContainsPoint(skillIcon:getMyBoundingBox(), cc.p(x, y))
        if touchInSprite then
          skillIcon:setIconSelected(true)
          
          local function tFunc(skillLevel)
            skillIcon:setIconSelected(false)
            if 0 < skillLevel then
              skillIcon.mSkillLevelLabel:setString(string.format("LV.%d", skillLevel))
              self.mBuddhaModel = DataUtils.getBuddhaModel(self.mBuddhaModel.npcId)
              self:skillUpgradeUpdate()
            end
          end
          
          local pLayer = LayerUpgradeSkill.new(skillIcon.mSkillId, self.mBuddhaModel.npcId, self.mBuddhaLevel, tFunc)
          self:addChild(pLayer, 20)
        else
          skillIcon:setIconSelected(false)
        end
      end
    end
  end
end

function M:touchListener(event)
  local lv = event.listView
  if "clicked" == event.name then
  elseif "moved" == event.name then
  else
    if "ended" == event.name then
    else
    end
  end
end

function M:closeCallBack_()
  DYSoundMgr.stopEffect(self.mSoundId)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mHandler then
    self.mBuddhaModel = DataUtils.getBuddhaModel(self.mBuddhaModel.npcId)
    self.mHandler(self.mBuddhaModel)
  end
  DYRes.unloadSheet("animation/tx_double_awake.plist")
  DYRes.unloadFileInfo(self.mFileInfo)
  self.mFileInfo = {}
  display.removeUnusedSpriteFrames()
  self:removeSelf()
end

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  local userLevel = CloudData.USER_LEVEL
  if stageProgress == 4 and not DataUtils.getGuideIsFirstPlayed("GUIDE_LEVEL5_UPGRADELAY") then
    DataUtils.setGuideIsFirstPlayed("GUIDE_LEVEL5_UPGRADELAY", true)
    
    local function tFunc()
      local dialogue = GameDialogue.new("STAGE4_3", function()
        display.replaceScene(require("scenes.SceneStage").new(1, 1, 5), "FADETR", 1)
      end):addTo(self)
    end
    
    local guide = NoviceGuide.new("GUIDE_LEVEL5_UPGRADELAY", function()
      tFunc()
    end):addTo(self, 50)
  end
  if stageProgress == 5 and DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_UPGRADESCN") and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_UPGRADELAY") then
    DataUtils.setGuideIsFirstPlayed("GUDIE_STAGE6_UPGRADELAY", true)
    local guide = NoviceGuide.new("GUDIE_STAGE6_UPGRADELAY"):addTo(self, 50)
  end
  if self.mBuddhaModel.level >= 28 and not DataUtils.getGuideIsFirstPlayed("GUIDE_LEVEL40_LINGWU_1") then
    local guide = NoviceGuide.new("GUIDE_LEVEL40_LINGWU_1"):addTo(self, 50)
    return
  end
end

BuddhaPropertyLayer = M
return M

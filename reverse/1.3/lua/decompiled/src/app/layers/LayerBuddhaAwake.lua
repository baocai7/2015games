local AwakeSkillIcon = require("app.icons.AwakeSkillIcon")
local LayerAwakeSkill = require("app.layers.LayerAwakeSkill")
local LayerSkillBooks = require("app.layers.LayerSkillBooks")
local LayerRule = require("app.layers.LayerRule")
local M = {}
M = class("LayerBuddhaAwake", function()
  return display.newLayer()
end)
local TEXT_LIST = {
  DYLang.getString("S518", ""),
  DYLang.getString("S519", "")
}
local TEXT_COLOR = {
  cc.c3b(0, 0, 0),
  cc.c3b(0, 255, 6),
  cc.c3b(81, 204, 255),
  cc.c3b(239, 38, 237),
  cc.c3b(255, 198, 0)
}

local function M_getLearnCostNum(times)
  local temp1 = math.floor(times / 10 + 1) * 5
  local temp2 = times < 3 and 2 or temp1
  local temp3 = temp2 < 90 and temp2 or 90
  return temp3
end

function M:ctor(buddhaModel, callback)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mBuddhaModel = buddhaModel
  self.mCallback = callback
  self:initUI()
  self:initData()
end

function M:initData()
  local npcInfo = CloudData.NPC_INFO[self.mBuddhaModel.npcId]
  self.mSkillList = {
    {},
    {},
    {},
    {},
    {},
    {},
    {}
  }
  self.mFreeSkill = npcInfo.arousalSkillId
  for k, v in pairs(npcInfo.arousals) do
    local idx = v.index
    v.status = 1
    self.mSkillList[idx] = v
  end
  for i = 1, #self.mSkillList do
    local levelInfo = DYCommon.getDataByTag(DataRetainer.PVP_COUNT_CONSUME, "id", tostring(i))[1]
    if not levelInfo then
      DDERROR("arousalLevel: %d with error data", i)
      return 0
    end
    if not self.mSkillList[i].index then
      self.mSkillList[i].index = i
    end
    local level = tonumber(levelInfo.arousalLevel)
    self.mSkillList[i].unlockLevel = level
    local status = 0
    if level <= self.mBuddhaModel.level then
      status = 2
    end
    if not self.mSkillList[i].status then
      self.mSkillList[i].status = status
    end
  end
  self.mBuddhaId = self.mBuddhaModel.npcId
  self.mSkillIcons = {}
  self.mStone = CloudData.GAME_ITEM_INFO["2029"] or 0
  self.mSkillPoints = CloudData.GAME_ITEM_INFO["8"] or 0
  self.mLearnTag = 0
  self.mIsChanged = false
  self:loadSkillList()
  self:skillMeditation()
end

function M:initUI()
  self.mBg = display.newSprite("pvp_ol/bg_rankInfo.png", 0, -10):addTo(self.mNode)
  local tFrame = display.newSprite("common_ui/title_frame.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.95):addTo(self.mBg)
  display.newSprite("upgrade/title_meditation.png"):pos(tFrame:getContentSize().width * 0.5, tFrame:getContentSize().height * 0.55):addTo(tFrame)
  DYLabelTTF.new({
    text = self.mBuddhaModel.npcName,
    size = 32,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(self.mBg:getContentSize().width * 0.11, self.mBg:getContentSize().height * 0.86):addTo(self.mBg)
  LayerRule.newRuleIcon(LayerRule.MEDITATION):align(display.CENTER, self.mBg:getContentSize().width * 0.06, self.mBg:getContentSize().height * 0.9):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):align(display.CENTER, self.mBg:getContentSize().width * 0.95, self.mBg:getContentSize().height * 0.94):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mBg)
end

function M:loadSkillList()
  local listFrame = display.newScale9Sprite("upgrade/common_frame.png", 378, 315, cc.size(600, 458), cc.rect(45, 45, 1, 1)):addTo(self.mBg)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(10, 9, 580, 440),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(listFrame, 1)
  for i = 1, #self.mSkillList do
    local skillInfo = self.mSkillList[i]
    local item = listView:newItem()
    local content = AwakeSkillIcon.new(self, skillInfo, self.mBuddhaModel.npcId)
    item:addContent(content)
    item:setItemSize(580, 110)
    listView:addItem(item)
    if skillInfo.status > 0 then
      self.mSkillIcons[skillInfo.index] = content
    end
  end
  listView:reload()
  self:performWithDelay(self.checkSkillsState, 0.1)
end

function M:skillMeditation()
  cc.ui.UIPushButton.new({
    normal = "upgrade/icon_skillbook_n.png",
    pressed = "upgrade/icon_skillbook_p.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.92, self.mBg:getContentSize().height * 0.61):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    local params = {
      buddhaId = self.mBuddhaId,
      awakeSkills = self.mBuddhaModel.awakeSkill,
      freeSkill = self.mFreeSkill
    }
    LayerSkillBooks.new(params, handler(self, self.onEventLearnBooks)):addTo(self, 5)
  end):addTo(self.mBg, 1)
  cc.ui.UIPushButton.new({
    normal = "summon_scene/skan.png",
    pressed = "summon_scene/skan.png"
  }):scale(0.75):align(display.CENTER, self.mBg:getContentSize().width * 0.92, self.mBg:getContentSize().height * 0.72):onButtonPressed(function(event)
    event.target:setScale(0.7)
  end):onButtonRelease(function(event)
    event.target:setScale(0.75)
  end):onButtonClicked(function()
    LayerAwakeSkill.new(self.mBuddhaModel.awakeSkill):addTo(self, 5)
  end):addTo(self.mBg, 1)
  local light = display.newSprite("upgrade/light1.png"):pos(845, self.mBg:getContentSize().height * 0.73):addTo(self.mBg)
  self.mSkillFrame = display.newSprite("common_ui/frame1.png"):scale(0.75):pos(845, self.mBg:getContentSize().height * 0.73):addTo(self.mBg, 1)
  self.mDoubleTip = display.newSprite("activity/double_tag2.png"):pos(845, self.mBg:getContentSize().height * 0.83):hide():addTo(self.mBg, 2)
  if CloudData.DOUBLE_ACTIVITY and tonumber(CloudData.DOUBLE_ACTIVITY.type) == 3 and CloudData.DOUBLE_ACTIVITY.status > 0 then
    self.mDoubleTip:show()
  end
  DYLabelTTF.new({
    text = DYLang.getString("S520", ""),
    size = 24,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(820, self.mBg:getContentSize().height * 0.38):addTo(self.mBg, 1)
  self.mPointsLabel = DYLabelTTF.new({
    text = self.mSkillPoints,
    size = 24,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(875, self.mBg:getContentSize().height * 0.38):addTo(self.mBg, 1)
  self:learnCostCoin()
  self:loadFuncBtn()
  self:checkLearnState()
end

function M:learnCostCoin()
  self.mCostNode1 = display.newNode():align(display.CENTER, 845, self.mBg:getContentSize().height * 0.49):addTo(self.mBg, 1)
  self.mCostNode1:setContentSize(326, 84)
  display.newSprite("upgrade/meditation.png", 110, 42):addTo(self.mCostNode1)
  self.mCostNode1.costNum = DYLabelTTF.new({
    text = string.format("%d / 1", self.mStone),
    size = 24,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(145, 42):addTo(self.mCostNode1)
  self.mCostNode2 = display.newNode():align(display.CENTER, 845, self.mBg:getContentSize().height * 0.49):addTo(self.mBg, 1)
  self.mCostNode2:setContentSize(326, 84)
  display.newSprite("item_icon/pic_peach.png", 50, 42):addTo(self.mCostNode2)
  self.mCostNode2.costNum = DYLabelTTF.new({
    text = "",
    size = 24,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(90, 42):addTo(self.mCostNode2)
  DYLabelTTF.new({
    text = DYLang.getString("S521", ""),
    size = 24,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(220, 42):addTo(self.mCostNode2)
  self.mCostNode2.leftTimes = DYLabelTTF.new({
    text = CloudData.AWAKE_LEARN_LEFT,
    size = 24,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(270, 42):addTo(self.mCostNode2)
  self:checkLearnCost()
end

function M:loadFuncBtn()
  self.mLearnBtn1 = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.75):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S522", ""),
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):align(display.CENTER, self.mBg:getContentSize().width * 0.72, self.mBg:getContentSize().height * 0.25):onButtonClicked(function()
    self:learnCallback1()
  end):addTo(self.mBg)
  self.mLearnBtn2 = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.75):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S523", ""),
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):align(display.CENTER, self.mBg:getContentSize().width * 0.87, self.mBg:getContentSize().height * 0.25):onButtonClicked(function()
    self:getConfirmLayer()
  end):addTo(self.mBg)
  self.mResolveBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.75):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S524", ""),
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):align(display.CENTER, self.mBg:getContentSize().width * 0.79, self.mBg:getContentSize().height * 0.25):onButtonClicked(function()
    self:resolveCallback()
  end):addTo(self.mBg)
end

function M:checkLearnCost()
  if self.mStone > 0 then
    self.mCostNode1:show()
    self.mCostNode2:hide()
    self.mCostNode1.costNum:setString(string.format("%d / 1", self.mStone))
    self.mLearnTag = 0
  else
    local costNum = M_getLearnCostNum(CloudData.AWAKE_LEARN_COUNT - CloudData.AWAKE_LEARN_LEFT + 1)
    self.mCostNode1:hide()
    self.mCostNode2:show()
    self.mCostNode2.leftTimes:setString(CloudData.AWAKE_LEARN_LEFT)
    self.mCostNode2.costNum:setString(costNum)
    if 0 >= CloudData.AWAKE_LEARN_LEFT then
      self.mCostNode2.leftTimes:setColor(display.COLOR_RED)
      self.mLearnTag = 1
    elseif costNum > CloudData.PEACH then
      self.mCostNode2.costNum:setColor(display.COLOR_RED)
      self.mLearnTag = 2
    end
  end
end

function M:checkLearnState()
  if self.mFreeSkill and self.mFreeSkill > 0 then
    local skillModel = DataUtils.getAwakeSkillBaseData(self.mFreeSkill)
    local textColor = {
      cc.c3b(0, 0, 0),
      cc.c3b(0, 255, 6),
      cc.c3b(81, 204, 255),
      cc.c3b(239, 38, 237),
      cc.c3b(255, 198, 0)
    }
    self.mSkillFrame:setTexture(string.format("common_ui/frame%d.png", skillModel.quality))
    local skillIcon = display.newSprite(skillModel.skillIcon):pos(self.mSkillFrame:getContentSize().width * 0.5, self.mSkillFrame:getContentSize().height * 0.5):addTo(self.mSkillFrame, 1)
    DYLabelTTF.new({
      text = skillModel.skillName,
      size = 28,
      color = textColor[skillModel.quality],
      font = GameManager.FONTNAME_TTF
    }, {}):pos(self.mSkillFrame:getContentSize().width * 0.5, -self.mSkillFrame:getContentSize().height * 0.3):addTo(self.mSkillFrame)
    local pTip
    skillIcon:setTouchEnabled(true)
    skillIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
      if name == "began" then
        pTip = self:getSkillTip(self.mFreeSkill)
        pTip:setPosition(display.cx, display.cy)
        pTip:addTo(self, 20)
        return true
      end
      if name == "moved" then
        pTip:show()
      elseif name == "ended" then
        pTip:removeSelf()
        pTip = nil
      end
    end)
    self.mResolveBtn:show()
    self.mLearnBtn1:hide()
    self.mLearnBtn2:hide()
  else
    self.mSkillFrame:setTexture("common_ui/frame1.png")
    self.mSkillFrame:removeAllChildren()
    self.mResolveBtn:hide()
    self.mLearnBtn1:show()
    self.mLearnBtn2:show()
  end
end

function M:checkSkillsState()
  local isNew, skillType = self:getIsNewSkill()
  for i = 1, #self.mSkillIcons do
    local skillIcon = self.mSkillIcons[i]
    if skillIcon.mSkillType then
      DDLOG("====== equip skillType : %d", skillIcon.mSkillType)
    end
    if 1 == skillIcon.mStatus then
      if isNew then
        skillIcon.mExchangeBtn:show()
      elseif skillType == skillIcon.mSkillType then
        skillIcon.mExchangeBtn:show()
      else
        skillIcon.mExchangeBtn:hide()
      end
      if self.mSkillPoints >= skillIcon.mCostNum and skillIcon.mSkillLevel < skillIcon.mSkillModel.maxLevel then
        skillIcon.mUpgradeBtn:show()
      else
        skillIcon.mUpgradeBtn:hide()
      end
    end
    if 2 == skillIcon.mStatus then
      if isNew then
        skillIcon.mEquipBtn:show()
      else
        skillIcon.mEquipBtn:hide()
      end
    end
  end
end

function M:getIsNewSkill()
  if not self.mFreeSkill or self.mFreeSkill <= 0 then
    return false, -1
  end
  local skillModel = DataUtils.getAwakeSkillBaseData(self.mFreeSkill)
  local skillType = skillModel.skillType
  DDLOG("skillID : %d ============ skillType : %d", tonumber(self.mFreeSkill), skillType)
  local isNew = true
  for k, v in pairs(CloudData.NPC_INFO[self.mBuddhaModel.npcId].arousals) do
    local pModel = DataUtils.getAwakeSkillBaseData(k)
    local pType = pModel.skillType
    DDLOG("id : %d ===== type : %d", tonumber(k), pType)
    if skillType == pType then
      isNew = false
      break
    end
  end
  return isNew, skillType
end

function M:learnCallback1()
  self.mLearnBtn1:setButtonEnabled(false)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  if self.mLearnTag > 0 then
    WSToast.new(TEXT_LIST[self.mLearnTag]):addTo(self, 20)
    self.mLearnBtn1:setButtonEnabled(true)
    return
  end
  
  local function tFuncListener(jsonValue)
    if not self or self.__cname ~= "LayerBuddhaAwake" then
      return
    end
    local errorCode = jsonValue.errorCode
    local errorMsg = jsonValue.errorMsg or "UNKNOWN"
    if 0 < errorCode then
      WSToast.new(errorMsg):addTo(self, 20)
      self.mLearnBtn1:setButtonEnabled(true)
      return
    end
    CloudData.PEACH = jsonValue.data.peachLeft
    self.mStone = jsonValue.data.wudaoshiLeft
    DataUtils.updateItemNum("1", CloudData.PEACH)
    DataUtils.updateItemNum("2029", self.mStone)
    CloudData.AWAKE_LEARN_LEFT = jsonValue.data.leftTimes
    self.mFreeSkill = jsonValue.data.skillId
    CloudData.NPC_INFO[self.mBuddhaModel.npcId].arousalSkillId = self.mFreeSkill
    if jsonValue.data.isDouble then
      if tonumber(CloudData.DOUBLE_ACTIVITY.type) == 3 and 0 < jsonValue.data.isDouble then
        self.mDoubleTip:show()
      else
        self.mDoubleTip:hide()
      end
    else
      self.mDoubleTip:hide()
    end
    self:updateUI()
    self.mLearnBtn1:setButtonEnabled(true)
  end
  
  local params = {
    buddhaId = self.mBuddhaModel.npcId
  }
  DYHttpMgr.singleLearn(tFuncListener, params)
end

function M:learnCallback2()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  
  local function tFuncListener(jsonValue)
    local errorCode = jsonValue.errorCode
    local errorMsg = jsonValue.errorMsg or "UNKNOWN"
    if 0 < errorCode then
      WSToast.new(errorMsg):addTo(self, 20)
      return
    end
    CloudData.PEACH = jsonValue.data.peachLeft
    self.mStone = jsonValue.data.wudaoshiLeft
    self.mSkillPoints = jsonValue.data.wuxingdian
    DataUtils.updateItemNum("1", CloudData.PEACH)
    DataUtils.updateItemNum("2029", self.mStone)
    DataUtils.updateItemNum("8", self.mSkillPoints)
    CloudData.AWAKE_LEARN_LEFT = jsonValue.data.leftTimes
    self.mPointsLabel:setString(self.mSkillPoints)
    local skillId = jsonValue.data.skillId
    if 0 < skillId then
      self.mFreeSkill = skillId
      CloudData.NPC_INFO[self.mBuddhaModel.npcId].arousalSkillId = self.mFreeSkill
    end
    local str = string.format(DYLang.getString("S525", ""), jsonValue.data.wuxingdianGain)
    WSToast.new(str):addTo(self, 20)
    if jsonValue.data.isDouble then
      if tonumber(CloudData.DOUBLE_ACTIVITY.type) == 3 and 0 < jsonValue.data.isDouble then
        self.mDoubleTip:show()
      else
        self.mDoubleTip:hide()
      end
    else
      self.mDoubleTip:hide()
    end
    self:updateUI()
  end
  
  local params = {
    buddhaId = self.mBuddhaModel.npcId
  }
  DYHttpMgr.mutipleLearn(tFuncListener, params)
end

function M:resolveCallback()
  self.mResolveBtn:setButtonEnabled(false)
  local pModel = DataUtils.getAwakeSkillBaseData(self.mFreeSkill)
  if pModel.quality <= 3 then
    self:confirmResolve()
    return
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  local pLayer = display.newColorLayer(cc.c4b(0, 0, 0, 120)):addTo(self, 15)
  local bg = display.newSprite("common_ui/common_dialog.png"):scale(0):pos(display.cx, display.cy):addTo(pLayer)
  bg:runAction(transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  }))
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(523, 190), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.54):addTo(bg)
  local str = string.format(DYLang.getString("S526", ""), pModel.skillName)
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S527", ""),
    size = 25,
    color = cc.c3b(66, 49, 29),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.55):addTo(bg)
  local lb1 = DYLabelTTF.new({
    text = pModel.skillName,
    size = 25,
    color = TEXT_COLOR[pModel.quality],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(lb:getPositionX() + lb:getContentSize().width, lb:getPositionY()):addTo(bg)
  DYLabelTTF.new({
    text = DYLang.getString("S528", ""),
    size = 25,
    color = cc.c3b(66, 49, 29),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb1:getPositionX() + lb1:getContentSize().width, lb:getPositionY()):addTo(bg)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S529", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.18):onButtonClicked(function()
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0, 1),
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
        pLayer:removeSelf()
        self:confirmResolve()
      end)
    })
    bg:runAction(popupLayer)
  end):addTo(bg)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S530", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.18):onButtonClicked(function()
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0, 1),
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
        pLayer:removeSelf()
        self.mResolveBtn:setButtonEnabled(true)
      end)
    })
    bg:runAction(popupLayer)
  end):addTo(bg)
end

function M:confirmResolve()
  local function tFuncListener(jsonValue)
    local errorCode = jsonValue.errorCode
    
    local errorMsg = jsonValue.errorMsg or "UNKNOWN"
    if 0 < errorCode then
      WSToast.new(errorMsg):addTo(self, 20)
      self.mResolveBtn:setButtonEnabled(true)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
    self.mSkillPoints = jsonValue.data.wuxingdian
    DataUtils.updateItemNum("8", self.mSkillPoints)
    local str = string.format(DYLang.getString("S531", ""), jsonValue.data.wuxingdianGain)
    WSToast.new(str):addTo(self, 20)
    self.mPointsLabel:setString(self.mSkillPoints)
    self.mFreeSkill = nil
    CloudData.NPC_INFO[self.mBuddhaModel.npcId].arousalSkillId = self.mFreeSkill
    self:updateUI()
    self.mResolveBtn:setButtonEnabled(true)
  end
  
  local params = {
    buddhaId = self.mBuddhaModel.npcId
  }
  DYHttpMgr.awakeSkillResolve(tFuncListener, params)
end

function M:getConfirmLayer()
  local costNum = 0
  if self.mStone < 10 then
    local needTimes = 10 - self.mStone
    if needTimes > CloudData.AWAKE_LEARN_LEFT then
      DYSoundMgr.playEffect(DY_SND.sfx_touch)
      WSToast.new(DYLang.getString("S518", "")):addTo(self, 20)
      return
    else
      local sum = 0
      local currTimes = CloudData.AWAKE_LEARN_COUNT - CloudData.AWAKE_LEARN_LEFT
      for i = 1, needTimes do
        sum = sum + M_getLearnCostNum(currTimes + i)
      end
      if sum > CloudData.PEACH then
        DYSoundMgr.playEffect(DY_SND.sfx_touch)
        WSToast.new(DYLang.getString("S519", "")):addTo(self, 20)
        return
      else
        costNum = sum
      end
    end
  end
  if 0 == GameManager.AWAKE_LEARN_PROMPT then
    self:learnCallback2()
    return
  end
  local pLayer = display.newColorLayer(cc.c4b(0, 0, 0, 120)):addTo(self, 15)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  local bg = display.newSprite("common_ui/common_dialog.png"):scale(0):pos(display.cx, display.cy):addTo(self, 16)
  bg:runAction(transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  }))
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(523, 180), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.65):addTo(bg)
  local str = string.format(DYLang.getString("S534", ""), costNum)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = str,
    size = 25,
    color = cc.c3b(66, 49, 29),
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(480, 144)
  }):align(display.CENTER, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  
  local function onEventCheckTag(target)
    if 1 == GameManager.AWAKE_LEARN_PROMPT then
      GameManager.AWAKE_LEARN_PROMPT = 0
      target.tag:show()
    else
      GameManager.AWAKE_LEARN_PROMPT = 1
      target.tag:hide()
    end
  end
  
  local btn = cc.ui.UIPushButton.new({
    normal = "upgrade/img_check box_00.png",
    pressed = "upgrade/img_check box_00.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\230\156\172\230\172\161\231\153\187\229\189\149\228\184\141\229\134\141\230\143\144\231\164\186",
    size = 20,
    color = cc.c3b(138, 109, 13),
    font = GameManager.FONTNAME_TTF
  })):setButtonLabelOffset(100, 0):align(display.CENTER, bg:getContentSize().width * 0.34, bg:getContentSize().height * 0.35):onButtonClicked(function(event)
    onEventCheckTag(event.target)
  end):addTo(bg)
  btn.tag = display.newSprite("cimelia/mark.png"):hide():scale(0.8):addTo(btn)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S529", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.18):onButtonClicked(function()
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0, 1),
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        bg:removeSelf()
        pLayer:removeSelf()
        self:learnCallback2()
      end)
    })
    bg:runAction(popupLayer)
  end):addTo(bg)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S530", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.18):onButtonClicked(function()
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0, 1),
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
        bg:removeSelf()
        pLayer:removeSelf()
      end)
    })
    bg:runAction(popupLayer)
  end):addTo(bg)
end

function M:updateUI()
  self:checkLearnCost()
  self:checkLearnState()
  self:checkSkillsState()
end

function M:onEventEquipSkill()
  self.mFreeSkill = nil
  CloudData.NPC_INFO[self.mBuddhaModel.npcId].arousalSkillId = self.mFreeSkill
  self:updateUI()
  self.mIsChanged = true
end

function M:onEventReplaceSkill(params)
  self.mFreeSkill = nil
  CloudData.NPC_INFO[self.mBuddhaModel.npcId].arousalSkillId = self.mFreeSkill
  self.mSkillPoints = params.skillPoints
  self.mPointsLabel:setString(self.mSkillPoints)
  self:updateUI()
  self.mIsChanged = true
end

function M:onEventUpgradeSkill(params)
  self.mSkillPoints = params.skillPoints
  self.mPointsLabel:setString(self.mSkillPoints)
  self:checkSkillsState()
  self.mIsChanged = true
end

function M:onEventLearnBooks(params)
  self.mFreeSkill = params.skillId
  CloudData.NPC_INFO[self.mBuddhaModel.npcId].arousalSkillId = self.mFreeSkill
  self:updateUI()
end

function M:getSkillTip(skillId)
  local skillModel = DataUtils.getAwakeSkillModel(skillId, nil, 1)
  local bg = display.newScale9Sprite("common_ui/common_tip.png", 0, 0, cc.size(540, 255), cc.rect(200, 100, 2, 2))
  local skillQuality = skillModel.quality
  local skillFrame = display.newSprite(string.format("common_ui/frame%d.png", skillQuality)):scale(0.8):align(display.CENTER_LEFT, 20, bg:getContentSize().height * 0.55):addTo(bg)
  local skillIcon = display.newSprite(skillModel.skillIcon):pos(skillFrame:getContentSize().width * 0.5, skillFrame:getContentSize().height * 0.5):addTo(skillFrame, 1)
  local skillName = DYLabelTTF.new({
    text = skillModel.skillName,
    size = 25,
    color = TEXT_COLOR[skillQuality],
    font = GameManager.FONTNAME_TTF
  }, {}):pos(skillFrame:getContentSize().width * 0.5, -skillFrame:getPositionY() * 0.25):addTo(skillFrame)
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S537", ""),
    size = 22,
    color = cc.c3b(255, 252, 8),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(49, 39, 4)
  }):pos(bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.82):addTo(bg)
  DYLabelTTF.new({
    text = string.format(skillModel.skillDesc, unpack(skillModel.effectTable)),
    size = 20,
    color = cc.c3b(251, 235, 150),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT",
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(385, 46)
  }, {}):pos(lb1:getPositionX(), lb1:getPositionY() - 38):addTo(bg)
  local lb2 = DYLabelTTF.new({
    text = DYLang.getString("S538", ""),
    size = 22,
    color = cc.c3b(255, 252, 8),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(49, 39, 4)
  }):pos(bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.5):addTo(bg)
  local label = DYLabelTTF.new({
    text = string.format(skillModel.skillDesc, unpack(skillModel.effectNextTable)),
    size = 20,
    color = cc.c3b(251, 235, 150),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT",
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(385, 46)
  }, {}):pos(lb2:getPositionX(), lb2:getPositionY() - 38):addTo(bg)
  local label1 = DYLabelTTF.new({
    text = DYLang.getString("S539", ""),
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.16):addTo(bg)
  local label2 = DYLabelTTF.new({
    text = DYLang.getString("S540", ""),
    size = 24,
    color = cc.c3b(255, 183, 11),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(label1:getContentSize().width + label1:getPositionX(), label1:getPositionY()):addTo(bg)
  local label3 = DYLabelTTF.new({
    text = skillModel.costNum,
    size = 22,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(label2:getContentSize().width + label2:getPositionX() + 5, label1:getPositionY()):addTo(bg)
  return bg
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mIsChanged then
    self.mBuddhaModel = DataUtils.getBuddhaModel(self.mBuddhaModel.npcId)
    if self.mCallback then
      self.mCallback(self.mBuddhaModel)
    end
  end
  self:runAction(cc.RemoveSelf:create())
end

return M

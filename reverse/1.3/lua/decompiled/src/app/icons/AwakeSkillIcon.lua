local M = {}
M = class("AwakeSkillIcon", function()
  return display.newNode()
end)
local TEXT_COLOR = {
  cc.c3b(0, 0, 0),
  cc.c3b(0, 255, 6),
  cc.c3b(81, 204, 255),
  cc.c3b(239, 38, 237),
  cc.c3b(255, 198, 0)
}

function M:ctor(obj, skillInfo, buddhaId)
  self.mParent = obj
  self:initData(skillInfo, buddhaId)
  self:initUI()
end

function M:initData(skillInfo, buddhaId)
  self.mBuddhaId = buddhaId
  self.mSkillId = skillInfo.skillId or 0
  self.mSkillLevel = skillInfo.level or 0
  self.mUnlockLevel = skillInfo.unlockLevel
  self.mStatus = skillInfo.status
  self.mIndex = skillInfo.index
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/dialog_bg.png", 0, 0, cc.size(580, 108), cc.rect(50, 50, 1, 1)):addTo(self)
  bg:setOpacity(0)
  self.mBg = bg
  local tFunc = {
    [0] = function()
      self:loadLockSkill()
    end,
    [1] = function()
      self:loadNormalSkill()
    end,
    [2] = function()
      self:loadEmptySkill()
    end
  }
  tFunc[self.mStatus]()
  local line = display.newSprite("upgrade/line.png"):pos(bg:getContentSize().width * 0.5, 1):addTo(bg)
  line:setScaleX(2.1)
end

function M:loadNormalSkill()
  self.mSkillModel = DataUtils.getAwakeSkillModel(self.mSkillId, self.mBuddhaId)
  self.mCostNum = self.mSkillModel.costNum
  self.mSkillType = self.mSkillModel.skillType
  local skillQuality = self.mSkillModel.quality
  local skillFrame = display.newSprite(string.format("common_ui/frame%d.png", skillQuality)):scale(0.75):align(display.CENTER_LEFT, 5, self.mBg:getContentSize().height * 0.51):addTo(self.mBg)
  local skillIcon = display.newSprite(self.mSkillModel.skillIcon):pos(skillFrame:getContentSize().width * 0.5, skillFrame:getContentSize().height * 0.5):addTo(skillFrame, 1)
  local pTip
  skillIcon:setTouchEnabled(true)
  skillIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      pTip = self:getSkillTip(self.mSkillModel)
      pTip:setPosition(display.cx, display.cy)
      pTip:addTo(self.mParent, 20)
      return true
    end
    if name == "moved" then
      pTip:show()
    elseif name == "ended" then
      pTip:removeSelf()
      pTip = nil
    end
  end)
  local skillName = DYLabelTTF.new({
    text = self.mSkillModel.skillName,
    size = 22,
    color = TEXT_COLOR[skillQuality],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(15 + skillFrame:getContentSize().width * 0.75, skillFrame:getPositionY() + 23):addTo(self.mBg)
  local levelLabel = DYLabelTTF.new({
    text = "LV." .. self.mSkillLevel,
    size = 22,
    color = cc.c3b(0, 255, 6),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {lineWidth = 1}):pos(skillName:getPositionX(), skillFrame:getPositionY() - 23):addTo(self.mBg)
  if self.mSkillLevel >= self.mSkillModel.maxLevel then
    levelLabel:setString("LV.max")
  end
  self.mSkillInfo = {
    skillFrame = skillFrame,
    skillIcon = skillIcon,
    skillName = skillName,
    skillLevel = levelLabel
  }
  self.mUpgradeBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):hide():scale(0.75):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S279", ""),
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):align(display.CENTER, self.mBg:getContentSize().width * 0.6, self.mBg:getContentSize().height * 0.5):onButtonClicked(function()
    self:getUpgradeLayer(self.mSkillModel)
  end):addTo(self.mBg)
  self.mExchangeBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):hide():scale(0.75):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S280", ""),
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):align(display.CENTER, self.mBg:getContentSize().width * 0.88, self.mBg:getContentSize().height * 0.5):onButtonClicked(function()
    self:getExchangeLayer()
  end):addTo(self.mBg)
end

function M:loadEmptySkill()
  local skillFrame = display.newSprite("common_ui/frame1.png"):scale(0.75):align(display.CENTER_LEFT, 5, self.mBg:getContentSize().height * 0.51):addTo(self.mBg)
  self.mSkillFrame = skillFrame
  DYLabelTTF.new({
    text = DYLang.getString("S281", ""),
    size = 30,
    color = cc.c3b(255, 237, 173),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(skillFrame:getContentSize().width * 0.5, skillFrame:getContentSize().height * 0.5):addTo(skillFrame)
  self.mEquipBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):hide():scale(0.75):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S282", ""),
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):align(display.CENTER, self.mBg:getContentSize().width * 0.88, self.mBg:getContentSize().height * 0.5):onButtonClicked(function()
    self:equipCallback()
  end):addTo(self.mBg)
end

function M:loadLockSkill()
  local skillFrame = display.newSprite("common_ui/frame1.png"):scale(0.75):align(display.CENTER_LEFT, 5, self.mBg:getContentSize().height * 0.51):addTo(self.mBg)
  local skillIcon = display.newSprite("upgrade/lock.png"):scale(0.82):pos(skillFrame:getContentSize().width * 0.5, skillFrame:getContentSize().height * 0.5):addTo(skillFrame, 1)
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S283", ""),
    size = 24,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(15 + skillFrame:getContentSize().width * 0.75, skillFrame:getPositionY()):addTo(self.mBg)
  local lb2 = DYLabelTTF.new({
    text = self.mUnlockLevel,
    size = 24,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {lineWidth = 1}):pos(lb1:getPositionX() + lb1:getContentSize().width, lb1:getPositionY()):addTo(self.mBg)
  local lb3 = DYLabelTTF.new({
    text = DYLang.getString("S284", ""),
    size = 24,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb2:getPositionX() + lb2:getContentSize().width, lb2:getPositionY()):addTo(self.mBg)
end

function M:getUpgradeLayer(skillModel)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  local maskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 120)):addTo(self.mParent, 20)
  local bg = display.newSprite("common_ui/common_dialog.png"):pos(display.cx, display.cy):addTo(maskLayer, 1)
  local skillQuality = skillModel.quality
  local skillFrame = display.newSprite(string.format("common_ui/frame%d.png", skillQuality)):pos(bg:getContentSize().width * 0.2, bg:getContentSize().height * 0.57):addTo(bg)
  local skillIcon = display.newSprite(skillModel.skillIcon):pos(skillFrame:getContentSize().width * 0.5, skillFrame:getContentSize().height * 0.5):addTo(skillFrame, 1)
  local skillName = DYLabelTTF.new({
    text = skillModel.skillName,
    size = 25,
    color = TEXT_COLOR[skillQuality],
    font = GameManager.FONTNAME_TTF
  }, {}):pos(skillFrame:getContentSize().width * 0.5, -skillFrame:getPositionY() * 0.1):addTo(skillFrame)
  local label1 = DYLabelTTF.new({
    text = DYLang.getString("S285", ""),
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(bg:getContentSize().width * 0.36, bg:getContentSize().height * 0.63):addTo(bg)
  local label2 = DYLabelTTF.new({
    text = DYLang.getString("S286", ""),
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
  local label1 = DYLabelTTF.new({
    text = DYLang.getString("S287", ""),
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(bg:getContentSize().width * 0.36, bg:getContentSize().height * 0.5):addTo(bg)
  local label2 = DYLabelTTF.new({
    text = DYLang.getString("S286", ""),
    size = 24,
    color = cc.c3b(255, 183, 11),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(label1:getContentSize().width + label1:getPositionX(), label1:getPositionY()):addTo(bg)
  local label31 = DYLabelTTF.new({
    text = self.mParent.mSkillPoints,
    size = 22,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(label2:getContentSize().width + label2:getPositionX() + 5, label1:getPositionY()):addTo(bg)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.85):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S279", ""),
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.2):onButtonClicked(function()
    self:upgradeCallback()
  end):addTo(bg)
  local onekeyBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.85):setButtonLabel("normal", DYLabelTTF.new({
    text = "\228\184\128\233\148\174\229\141\135\231\186\167",
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.2):onButtonClicked(function()
    self:onekeyCallback()
  end):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.8):align(display.CENTER, bg:getContentSize().width * 0.95, bg:getContentSize().height * 0.95):onButtonClicked(function()
    DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
    maskLayer:runAction(cc.RemoveSelf:create())
  end):addTo(bg)
  self.mUpgradeInfo = {
    costLabel = label3,
    countLabel = label31,
    btn = btn,
    btnOnekey = onekeyBtn
  }
end

function M:upgradeCallback()
  self.mUpgradeInfo.btn:setButtonEnabled(false)
  
  local function tFuncListener(jsonValue)
    local errorCode = jsonValue.errorCode
    local errorMsg = jsonValue.errorMsg or "UNKNOWN"
    if 0 < errorCode then
      DYSoundMgr.playEffect(DY_SND.sfx_touch)
      WSToast.new(errorMsg):addTo(self.mParent, 20)
      self.mUpgradeInfo.btn:setButtonEnabled(true)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_upgrade)
    self.mSkillLevel = jsonValue.data.skillLevel
    CloudData.NPC_INFO[self.mBuddhaId].arousals[tostring(self.mSkillId)].level = self.mSkillLevel
    self.mSkillModel = DataUtils.getAwakeSkillModel(self.mSkillId, self.mBuddhaId)
    local pointsNum = jsonValue.data.wuxingdianLeft
    DataUtils.updateItemNum("8", pointsNum)
    self.mUpgradeInfo.costLabel:setString(self.mSkillModel.costNum)
    self.mUpgradeInfo.countLabel:setString(pointsNum)
    if self.mSkillLevel >= self.mSkillModel.maxLevel then
      self.mSkillInfo.skillLevel:setString("LV.max")
    else
      self.mSkillInfo.skillLevel:setString("LV." .. self.mSkillLevel)
    end
    self.mUpgradeInfo.btn:setButtonEnabled(true)
    local params = {skillPoints = pointsNum}
    self.mParent:onEventUpgradeSkill(params)
  end
  
  local params = {
    buddhaId = self.mBuddhaId,
    index = self.mIndex
  }
  DYHttpMgr.awakeSkillUpgrade(tFuncListener, params)
end

function M:onekeyCallback()
  self.mUpgradeInfo.btnOnekey:setButtonEnabled(false)
  
  local function tFuncListener(jsonValue)
    local errorCode = jsonValue.errorCode
    local errorMsg = jsonValue.errorMsg or "UNKNOWN"
    if 0 < errorCode then
      DYSoundMgr.playEffect(DY_SND.sfx_touch)
      WSToast.new(errorMsg):addTo(self.mParent, 20)
      self.mUpgradeInfo.btnOnekey:setButtonEnabled(true)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_upgrade)
    self.mSkillLevel = jsonValue.data.skillLevel
    CloudData.NPC_INFO[self.mBuddhaId].arousals[tostring(self.mSkillId)].level = self.mSkillLevel
    self.mSkillModel = DataUtils.getAwakeSkillModel(self.mSkillId, self.mBuddhaId)
    local pointsNum = jsonValue.data.wuxingdianLeft
    DataUtils.updateItemNum("8", pointsNum)
    self.mUpgradeInfo.costLabel:setString(self.mSkillModel.costNum)
    self.mUpgradeInfo.countLabel:setString(pointsNum)
    if self.mSkillLevel >= self.mSkillModel.maxLevel then
      self.mSkillInfo.skillLevel:setString("LV.max")
    else
      self.mSkillInfo.skillLevel:setString("LV." .. self.mSkillLevel)
    end
    self.mUpgradeInfo.btnOnekey:setButtonEnabled(true)
    local params = {skillPoints = pointsNum}
    self.mParent:onEventUpgradeSkill(params)
  end
  
  local params = {
    buddhaId = self.mBuddhaId,
    index = self.mIndex
  }
  DYHttpMgr.awakeSkillUpgradeOnekey(tFuncListener, params)
end

function M:getExchangeLayer()
  local skillModel1 = DataUtils.getAwakeSkillBaseData(self.mParent.mFreeSkill)
  local skillModel2 = DataUtils.getAwakeSkillBaseData(self.mSkillId)
  local skillType1 = skillModel1.skillType
  local skillType2 = skillModel2.skillType
  if skillType1 ~= skillType2 then
    local npcInfo = CloudData.NPC_INFO[self.mBuddhaId]
    for k, v in pairs(npcInfo.arousals) do
      local skillModel = DataUtils.getAwakeSkillBaseData(k)
      local skillType = skillModel.skillType
      if skillType == skillType1 then
        WSToast.new(DYLang.getString("S290", "")):addTo(self.mParent, 20)
        return
      end
    end
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  local maskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 120)):addTo(self.mParent, 20)
  local bg = display.newSprite("common_ui/common_dialog.png"):pos(display.cx, display.cy):addTo(maskLayer, 1)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(523, 190), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.54):addTo(bg)
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S291", ""),
    size = 22,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(22, 140):addTo(frame)
  local lb2 = DYLabelTTF.new({
    text = skillModel1.skillName,
    size = 24,
    color = TEXT_COLOR[skillModel1.quality],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(22 + lb1:getContentSize().width, 140):addTo(frame)
  local lb3 = DYLabelTTF.new({
    text = DYLang.getString("S292", ""),
    size = 22,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb2:getPositionX() + lb2:getContentSize().width, 140):addTo(frame)
  local lb4 = DYLabelTTF.new({
    text = skillModel2.skillName,
    size = 24,
    color = TEXT_COLOR[skillModel2.quality],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(lb3:getPositionX() + lb3:getContentSize().width, 140):addTo(frame)
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S293", ""),
    size = 22,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(485, 65)
  }):align(display.CENTER, frame:getContentSize().width * 0.5, 75):addTo(frame)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S294", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.18):onButtonClicked(function()
    self:exchangeCallback(maskLayer)
  end):addTo(bg)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S295", ""),
    size = 25,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.18):onButtonClicked(function()
    DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
    maskLayer:runAction(cc.RemoveSelf:create())
  end):addTo(bg)
end

function M:exchangeCallback(pLayer)
  local function tFuncListener(jsonValue)
    local errorCode = jsonValue.errorCode
    
    local errorMsg = jsonValue.errorMsg or "UNKNOWN"
    if 0 < errorCode then
      DYSoundMgr.playEffect(DY_SND.sfx_touch)
      WSToast.new(errorMsg):addTo(self.mParent, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
    CloudData.NPC_INFO[self.mBuddhaId].arousals[tostring(self.mSkillId)] = nil
    self.mSkillId = jsonValue.data.skillId
    CloudData.NPC_INFO[self.mBuddhaId].arousals[tostring(self.mSkillId)] = {
      index = self.mIndex,
      level = 1,
      skillId = self.mSkillId
    }
    self.mSkillLevel = 1
    self.mSkillModel = DataUtils.getAwakeSkillModel(self.mSkillId, self.mBuddhaId)
    self.mCostNum = self.mSkillModel.costNum
    self.mSkillType = self.mSkillModel.skillType
    local pointsNum = jsonValue.data.wuxingdian
    DataUtils.updateItemNum("8", pointsNum)
    local str = string.format(DYLang.getString("S296", ""), jsonValue.data.wuxingdianGain)
    WSToast.new(str):addTo(self.mParent, 20)
    self.mSkillInfo.skillFrame:setTexture(string.format("common_ui/frame%d.png", self.mSkillModel.quality))
    self.mSkillInfo.skillIcon:setTexture(self.mSkillModel.skillIcon)
    self.mSkillInfo.skillName:setString(self.mSkillModel.skillName)
    self.mSkillInfo.skillName:setColor(TEXT_COLOR[self.mSkillModel.quality])
    self.mSkillInfo.skillLevel:setString("LV.1")
    local params = {skillPoints = pointsNum}
    self.mParent:onEventReplaceSkill(params)
    pLayer:runAction(cc.RemoveSelf:create())
  end
  
  local params = {
    buddhaId = self.mBuddhaId,
    index = self.mIndex
  }
  DYHttpMgr.awakeSkillReplace(tFuncListener, params)
end

function M:equipCallback()
  self.mEquipBtn:setButtonEnabled(false)
  local skillModel1 = DataUtils.getAwakeSkillBaseData(self.mParent.mFreeSkill)
  local skillType1 = skillModel1.skillType
  local npcInfo = CloudData.NPC_INFO[self.mBuddhaId]
  for k, v in pairs(npcInfo.arousals) do
    local skillModel = DataUtils.getAwakeSkillBaseData(k)
    local skillType = skillModel.skillType
    if skillType == skillType1 then
      DYSoundMgr.playEffect(DY_SND.sfx_touch)
      WSToast.new(DYLang.getString("S297", "")):addTo(self.mParent, 20)
      self.mEquipBtn:setButtonEnabled(true)
      return
    end
  end
  
  local function tFuncListener(jsonValue)
    local errorCode = jsonValue.errorCode
    local errorMsg = jsonValue.errorMsg or "UNKNOWN"
    if 0 < errorCode then
      DYSoundMgr.playEffect(DY_SND.sfx_touch)
      WSToast.new(errorMsg):addTo(self.mParent, 20)
      self.mEquipBtn:setButtonEnabled(true)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
    self.mSkillId = jsonValue.data.skillId
    self.mSkillLevel = 1
    self.mStatus = 1
    CloudData.NPC_INFO[self.mBuddhaId].arousals[tostring(self.mSkillId)] = {
      index = self.mIndex,
      level = 1,
      skillId = self.mSkillId
    }
    self.mSkillFrame:removeSelf()
    self.mEquipBtn:hide()
    self:loadNormalSkill()
    self.mParent:onEventEquipSkill()
  end
  
  local params = {
    buddhaId = self.mBuddhaId,
    index = self.mIndex
  }
  DYHttpMgr.awakeSkillEquip(tFuncListener, params)
end

function M:getSkillTip(skillModel)
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
    text = DYLang.getString("S298", ""),
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
    text = DYLang.getString("S299", ""),
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
  if self.mSkillLevel >= skillModel.maxLevel then
    label:setString("\239\188\136\230\138\128\232\131\189\229\183\178\230\187\161\231\186\167\239\188\137")
  end
  local label1 = DYLabelTTF.new({
    text = DYLang.getString("S300", ""),
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.16):addTo(bg)
  local label2 = DYLabelTTF.new({
    text = DYLang.getString("S286", ""),
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

return M

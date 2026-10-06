local LayerLackEssence = require("app.layers.LayerLackEssence")
local M = {}
M = class("LayerUpgradeSkill", function()
  return display.newLayer()
end)

function M:ctor(skillId, buddhaId, buddhaLevel, handler_)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):scale(0):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  if handler_ then
    self.mHandler = handler_
  end
  self:initData(skillId, buddhaId, buddhaLevel)
  self:initUI()
end

function M:initData(skillId, buddhaId, buddhaLevel)
  self.mSkillModel = DataUtils.getBuddhaSkillModel(skillId, buddhaId)
  self.mBuddhaId = tonumber(buddhaId)
  self.mSkillId = skillId
  self.mBuddhaLevel = buddhaLevel
  self.mSkillLevel = self.mSkillModel.skillLevel
end

function M:initUI()
  self.mBg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(598, 570), cc.rect(300, 140, 1, 1)):addTo(self.mNode)
  self:skillInfo()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.96, self.mBg:getContentSize().height * 0.95):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mBg)
end

function M:skillInfo()
  DYLabelTTF.new({
    text = self.mSkillModel.skillName,
    size = 30,
    color = cc.c3b(255, 230, 16),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(self.mBg:getContentSize().width * 0.1, self.mBg:getContentSize().height * 0.91):addTo(self.mBg)
  self.mLevelLabel = DYLabelTTF.new({
    text = string.format("%d/%d", self.mSkillLevel, self.mSkillModel.maxLevel),
    size = 26,
    color = cc.c3b(15, 255, 32),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(self.mBg:getContentSize().width * 0.55, self.mBg:getContentSize().height * 0.91):addTo(self.mBg)
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S1007", ""),
    size = 24,
    color = cc.c3b(255, 223, 47),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(49, 39, 4)
  }):pos(self.mBg:getContentSize().width * 0.1, self.mBg:getContentSize().height * 0.82):addTo(self.mBg)
  local frame1 = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(515, 94), cc.rect(50, 50, 2, 2)):pos(self.mBg:getContentSize().width * 0.5, lb1:getPositionY() - 68):addTo(self.mBg)
  self.mEffLabel = DYLabelTTF.new({
    text = string.format(self.mSkillModel.skillDesc, unpack(self.mSkillModel.effectTable)),
    size = 20,
    color = cc.c3b(44, 21, 5),
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(480, 60),
    font = GameManager.FONTNAME_TTF
  }):pos(frame1:getContentSize().width * 0.5, frame1:getContentSize().height * 0.5):addTo(frame1)
  local lb2 = DYLabelTTF.new({
    text = DYLang.getString("S1008", ""),
    size = 24,
    color = cc.c3b(255, 223, 47),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(49, 39, 4)
  }):pos(self.mBg:getContentSize().width * 0.1, self.mBg:getContentSize().height * 0.56):addTo(self.mBg)
  local frame2 = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(515, 94), cc.rect(50, 50, 2, 2)):pos(self.mBg:getContentSize().width * 0.5, lb2:getPositionY() - 68):addTo(self.mBg)
  self.mNextEffLabel = DYLabelTTF.new({
    text = string.format(self.mSkillModel.skillDesc, unpack(self.mSkillModel.effectNextTable)),
    size = 20,
    color = cc.c3b(0, 247, 0),
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(480, 60),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(frame2:getContentSize().width * 0.5, frame2:getContentSize().height * 0.5):addTo(frame2)
  if 0 == self.mSkillLevel then
    return
  end
  local lb3 = DYLabelTTF.new({
    text = DYLang.getString("S1009", ""),
    size = 24,
    color = cc.c3b(255, 223, 47),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(49, 39, 4)
  }):pos(self.mBg:getContentSize().width * 0.1, self.mBg:getContentSize().height * 0.29):addTo(self.mBg)
  local lvLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S1010", ""),
    size = 22,
    color = cc.c3b(44, 21, 5),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.11, lb3:getPositionY() - 40):addTo(self.mBg)
  self.mNeedLevel = DYLabelTTF.new({
    text = (self.mSkillLevel + 1) * self.mSkillModel.levelStep,
    size = 24,
    color = cc.c3b(0, 247, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(49, 39, 4)
  }):pos(lvLabel:getPositionX() + lvLabel:getContentSize().width, lvLabel:getPositionY()):addTo(self.mBg)
  local costNum = self.mSkillModel.costNum
  local costLabel = display.newSprite("upgrade/essence_label.png"):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.11, lvLabel:getPositionY() - 40):addTo(self.mBg)
  self.mCostNumLabel = cc.ui.UILabel.new({
    text = costNum,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, costLabel:getContentSize().width * 0.62, costLabel:getContentSize().height * 0.5):addTo(costLabel)
  self.mSkillUpgradeBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.8):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1011", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1011", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:upgradeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.8, lvLabel:getPositionY() - 20):addTo(self.mBg)
  self.mOneKeyBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.8):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1013", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1013", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:oneKeyCallback()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.58, lvLabel:getPositionY() - 20):addTo(self.mBg)
  if self.mSkillLevel == self.mSkillModel.maxLevel then
    self.mNextEffLabel:hide()
    self:performWithDelay(function()
      self.mSkillUpgradeBtn:setButtonEnabled(false)
      self.mOneKeyBtn:setButtonEnabled(false)
    end, 0)
  end
  if self.mBuddhaLevel < (self.mSkillLevel + 1) * self.mSkillModel.levelStep then
    self.mNeedLevel:setColor(display.COLOR_RED)
    self:performWithDelay(function()
      self.mSkillUpgradeBtn:setButtonEnabled(false)
      self.mOneKeyBtn:setButtonEnabled(false)
    end, 0)
  end
end

function M:upgradeCallBack()
  self.mSkillUpgradeBtn:setButtonEnabled(false)
  if self.mSkillModel.costNum > CloudData.ESSENCE then
    local pLayer = LayerLackEssence.new()
    self:addChild(pLayer, 20)
    self.mSkillUpgradeBtn:setButtonEnabled(true)
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_upgrade)
    self.mSkillLevel = jsonTable.data.skillLevel
    CloudData.ESSENCE = jsonTable.data.essence
    CloudData.NPC_INFO[self.mBuddhaId].skills[tostring(self.mSkillId)] = self.mSkillLevel
    self.mSkillModel = DataUtils.getBuddhaSkillModel(self.mSkillId, self.mBuddhaId)
    DYAnalyze.item.consume("2", "", self.mSkillModel.costNum, "Upgrade_skill_cost")
    self:updateUI()
  end
  
  local params = {}
  params.buddhaId = self.mBuddhaId
  params.skillId = self.mSkillId
  DYHttpMgr.upgradeBuddhaSkill(tFuncListener, params)
end

function M:oneKeyCallback()
  self.mOneKeyBtn:setButtonEnabled(false)
  if self.mSkillModel.costNum > CloudData.ESSENCE then
    local pLayer = LayerLackEssence.new()
    self:addChild(pLayer, 20)
    self.mOneKeyBtn:setButtonEnabled(true)
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_upgrade)
    self.mSkillLevel = jsonTable.data.skillLevel
    CloudData.ESSENCE = jsonTable.data.essence
    CloudData.NPC_INFO[self.mBuddhaId].skills[tostring(self.mSkillId)] = self.mSkillLevel
    self.mSkillModel = DataUtils.getBuddhaSkillModel(self.mSkillId, self.mBuddhaId)
    local costNum = jsonTable.data.essenceCost
    DYAnalyze.item.consume("2", "", costNum, "Upgrade_skill_cost")
    self:updateUI()
  end
  
  local params = {}
  params.buddhaId = self.mBuddhaId
  params.skillId = self.mSkillId
  DYHttpMgr.skillOnekeyUpgrade(tFuncListener, params)
end

function M:updateUI()
  self.mLevelLabel:setString(string.format("%d/%d", self.mSkillLevel, self.mSkillModel.maxLevel))
  self.mNeedLevel:setString((self.mSkillLevel + 1) * self.mSkillModel.levelStep)
  self.mEffLabel:setString(string.format(self.mSkillModel.skillDesc, unpack(self.mSkillModel.effectTable)))
  self.mNextEffLabel:setString(string.format(self.mSkillModel.skillDesc, unpack(self.mSkillModel.effectNextTable)))
  self.mCostNumLabel:setString(self.mSkillModel.costNum)
  if self.mSkillLevel == self.mSkillModel.maxLevel then
    self.mNextEffLabel:hide()
    self.mSkillUpgradeBtn:setButtonEnabled(false)
    self.mOneKeyBtn:setButtonEnabled(false)
    self.mNeedLevel:setColor(display.COLOR_RED)
    return
  end
  if self.mBuddhaLevel >= (self.mSkillLevel + 1) * self.mSkillModel.levelStep then
    self.mSkillUpgradeBtn:setButtonEnabled(true)
    self.mOneKeyBtn:setButtonEnabled(true)
  else
    self.mSkillUpgradeBtn:setButtonEnabled(false)
    self.mOneKeyBtn:setButtonEnabled(false)
    self.mNeedLevel:setColor(display.COLOR_RED)
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self.mHandler(self.mSkillLevel)
      self:removeSelf()
    end)
  })
  self.mNode:runAction(popupLayer)
end

return M

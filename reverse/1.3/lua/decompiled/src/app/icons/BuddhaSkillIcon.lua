local M = {}
M = class("BuddhaSkillIcon", function()
  return display.newNode()
end)

function M:ctor(skillId, buddhaId)
  self:initData(skillId, buddhaId)
  self:initUI()
  self:setTouchEnabled(true)
end

function M:initData(skillId, buddhaId)
  self.mBuddhaSkillModel = DataUtils.getBuddhaSkillModel(skillId, buddhaId)
  self.mBuddhaId = tonumber(buddhaId)
  self.mSkillId = tonumber(skillId)
  self.mBuddhaLevel = buddhaLevel or 1
  self.mSkillLevel = self.mBuddhaSkillModel.skillLevel
end

function M:initUI()
  if 0 == self.mSkillLevel then
    self:skillIconGray()
  else
    self:skillIconNormal()
  end
end

function M:skillIconGray()
  self.mBg = display.newNode():addTo(self)
  self.mBg:setAnchorPoint(0.5, 0.5)
  self.mBg:setContentSize(cc.size(100, 120))
  local params = {
    0.2,
    0.3,
    0.5,
    0.1
  }
  local frame = display.newSprite("common_ui/frame1.png"):scale(0.7457627118644068):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.4):addTo(self.mBg)
  local iconPath = self.mBuddhaSkillModel.skillIcon
  local skillIcon = display.newGraySprite(iconPath, params):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  local skillNameLabel = DYLabelTTF.new({
    text = self.mBuddhaSkillModel.skillName,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(103, 70, 22)
  }):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.95):addTo(self.mBg)
  cc.ui.UILabel.new({
    text = string.format("%d\231\186\167\229\188\128\230\148\190", self.mBuddhaSkillModel.needLevel),
    size = 20,
    color = cc.c3b(255, 0, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame, 1)
  self.mSelectedIcon = display.newSprite("common_ui/frame_selected.png"):hide():pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame, 1)
  self.mFrame = frame
end

function M:skillIconNormal()
  self.mBg = display.newNode():addTo(self)
  self.mBg:setAnchorPoint(0.5, 0.5)
  self.mBg:setContentSize(cc.size(100, 120))
  local frame = display.newSprite("common_ui/frame1.png"):scale(0.7457627118644068):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.4):addTo(self.mBg)
  local iconPath = self.mBuddhaSkillModel.skillIcon
  local skillIcon = display.newSprite(iconPath):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  self.mSkillLevelLabel = DYLabelTTF.new({
    text = string.format("LV.%d", self.mSkillLevel),
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {}):pos(frame:getContentSize().width - 10, 18):addTo(frame, 1)
  local skillNameLabel = DYLabelTTF.new({
    text = self.mBuddhaSkillModel.skillName,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(103, 70, 22)
  }):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.95):addTo(self.mBg)
  self.mSelectedIcon = display.newSprite("common_ui/frame_selected.png"):hide():pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame, 1)
  self.mFrame = frame
end

function M:skillUnlock(skillId, buddhaId)
  self:initData(skillId, buddhaId)
  self.mBg:removeSelf()
  self.mBg = nil
  self:skillIconNormal()
end

function M:setIconSelected(flag)
  self.mSelectedIcon:setVisible(flag)
end

function M:updateSkillState(buddhaLevel)
  local skillLevel = tonumber(CloudData.NPC_INFO[tonumber(self.mBuddhaId)].skills[tostring(self.mSkillId)] or 0)
  local costNum = math.floor(((8 + skillLevel * self.mBuddhaSkillModel.consume) ^ 5 / 3000 + 490) / 10) * 10
  
  local function getSkillState()
    if 0 < skillLevel and skillLevel < self.mBuddhaSkillModel.maxLevel and costNum <= CloudData.ESSENCE and buddhaLevel >= (skillLevel + 1) * self.mBuddhaSkillModel.levelStep then
      return 1
    else
      return 0
    end
  end
  
  local state = getSkillState()
  if 1 == state then
    if not self.mUp then
      self.mUp = display.newSprite("upgrade/blink1.png"):opacity(0):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame, 1)
      for i = 1, 3 do
        local pic = display.newSprite("upgrade/up1.png"):opacity(0):align(display.CENTER_LEFT, 0, self.mUp:getContentSize().height * (0.15 * i + 0.46)):addTo(self.mUp, 1)
        local seq = transition.sequence({
          cc.DelayTime:create(0.1 + (i - 1) * 0.2),
          cc.FadeIn:create(0),
          cc.DelayTime:create(1.1 - 0.2 * i),
          cc.FadeOut:create(0)
        })
        pic:runAction(cc.RepeatForever:create(seq))
      end
    end
  elseif self.mUp then
    self.mUp:runAction(cc.RemoveSelf:create())
    self.mUp = nil
  end
end

function M:getMyBoundingBox()
  local point = cc.p(self:getPositionX(), self:getPositionY())
  local worldpoint = self:getParent():convertToWorldSpace(point)
  local rect = cc.rect(worldpoint.x - self.mBg:getContentSize().width * 0.5, worldpoint.y - self.mBg:getContentSize().height * 0.5, self.mBg:getContentSize().width, self.mBg:getContentSize().height)
  return rect
end

BuddhaSkillIcon = M
return M

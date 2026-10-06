local M = {}
M = class("TeamIcon", function()
  return display.newNode()
end)
M.TYPE_MAIN = 1
M.TYPE_ASSIST = 2

function M:ctor(teamType, buddhaModel)
  self:initData(buddhaModel)
  self:initUI(teamType)
end

function M:initData(buddhaModel)
  self.mBuddhaModel = buddhaModel
  self.mIsOnTeam = false
  self.mIsOnAssist = false
  self.mIsHurt = false
  self.mInTask = false
end

function M:initUI(teamType)
  if M.TYPE_MAIN == teamType then
    self:initMainIcon()
  elseif M.TYPE_ASSIST == teamType then
    self:initAssistIcon()
  end
end

function M:initMainIcon()
  self.mBuddhaId = self.mBuddhaModel.npcId
  local bg = display.newScale9Sprite("common_ui/common_frame4.png", 0, 0, cc.size(160, 185), cc.rect(40, 35, 2, 2)):opacity(0):addTo(self)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mBuddhaModel.quality)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.62):addTo(bg)
  local icon = display.newSprite(self.mBuddhaModel.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 == self.mBuddhaModel.isRebel then
    icon:setScaleX(-1)
  end
  local starPic = display.newSprite(string.format("upgrade/star%d.png", self.mBuddhaModel.starLevel)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame, 1)
  local levelFrame = display.newSprite("team/frame.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.15):addTo(iconFrame)
  cc.ui.UILabel.new({
    text = string.format("LV.%d", self.mBuddhaModel.level),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, levelFrame:getContentSize().width * 0.5, levelFrame:getContentSize().height * 0.5):addTo(levelFrame)
  local spiritFrame = display.newSprite("team/spirit_frame.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.15):addTo(bg)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = self.mBuddhaModel.consume,
    font = "fonts/whiteNum.fnt"
  }):scale(0.5):align(display.CENTER_LEFT, spiritFrame:getContentSize().width * 0.35, spiritFrame:getContentSize().height * 0.5):addTo(spiritFrame)
  local pTypePic = display.newSprite(string.format("team/symbol%d.png", self.mBuddhaModel.symbol)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  self.mMarkOnTeam = display.newSprite("team/pic_on.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):hide():addTo(iconFrame, 1)
  self.mMarkHurt = display.newSprite("team/pic_hurt.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):hide():addTo(iconFrame, 1)
  self.mAssistMark = display.newSprite("team/pic_assist.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):hide():addTo(iconFrame, 1)
  if self.mBuddhaModel.inTask ~= 0 then
    self.mInTask = true
    local maskFrame = display.newSprite("union/patrol/img_icon_inf.png"):pos(59, 59):addTo(iconFrame, 1)
    DYLabelTTF.new({
      text = DYLang.getString("STR_IN_PATROL", ""),
      size = 24,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER"
    }, {
      lineColor = cc.c3b(90, 30, 50)
    }):align(display.CENTER, 59, 57):addTo(maskFrame)
  end
end

function M:initAssistIcon()
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):scale(0.95):addTo(self)
  if self.mBuddhaModel == nil then
    return
  end
  self.mBuddhaId = self.mBuddhaModel.npcId
  iconFrame:setTexture(string.format("common_ui/frame%d.png", self.mBuddhaModel.quality))
  local icon = display.newSprite(self.mBuddhaModel.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 == self.mBuddhaModel.isRebel then
    icon:setScaleX(-1)
  end
  local starPic = display.newSprite(string.format("upgrade/star%d.png", self.mBuddhaModel.starLevel)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.95):addTo(iconFrame, 1)
  local pTypePic = display.newSprite("team/mark_phy.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 2 == self.mBuddhaModel.attackType then
    pTypePic:setTexture("team/mark_mag.png")
  end
  self.mMarkOnTeam = display.newSprite("team/pic_assist.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):hide():addTo(iconFrame, 1)
  if self.mBuddhaModel.inTask ~= 0 then
    self.mInTask = true
    local maskFrame = display.newSprite("union/patrol/img_icon_inf.png"):pos(59, 59):addTo(iconFrame, 1)
    DYLabelTTF.new({
      text = DYLang.getString("STR_IN_PATROL", ""),
      size = 24,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER"
    }, {
      lineColor = cc.c3b(90, 30, 50)
    }):align(display.CENTER, 59, 57):addTo(maskFrame)
  end
end

function M:iconClicked()
  local seq = transition.sequence({
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self:runAction(seq)
end

function M:setOnTeam(isOnTeam)
  self.mIsOnTeam = isOnTeam
  if isOnTeam then
    self.mMarkOnTeam:show()
  else
    self.mMarkOnTeam:hide()
  end
end

function M:setHurtState(flag)
  self.mIsHurt = flag
  if flag then
    self.mMarkHurt:show()
  else
    self.mMarkHurt:hide()
  end
end

function M:setOnAssist(flag)
  self.mIsOnAssist = flag
  if flag then
    self.mAssistMark:show()
  else
    self.mAssistMark:hide()
  end
end

return M

local M = {}
M = class("PanelMemberApply", function()
  return display.newNode()
end)

function M:ctor(params, callback)
  self.mCallback = callback
  self:initData(params)
  self:initUI()
end

function M:initData(params)
  self.mInfo = params.info
  self.mIndex = params.index
end

function M:initUI()
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(555, 134), cc.rect(40, 40, 2, 2)):addTo(self)
  self.mBg = bg
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):scale(0.9):align(display.CENTER_LEFT, 20, bg:getContentSize().height * 0.5):addTo(bg)
  local icon = display.newSprite(GameManager.USER_ICON_PATH .. self.mInfo.icon .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  DYLabelTTF.new({
    text = "LV." .. self.mInfo.level,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {}):pos(iconFrame:getContentSize().width - 10, 20):addTo(iconFrame)
  if 0 < self.mInfo.vip then
    local vipFrame = display.newSprite("ranking/bg_vip.png"):align(display.CENTER_RIGHT, iconFrame:getContentSize().width, iconFrame:getContentSize().height):addTo(iconFrame)
    DYLabelTTF.new({
      text = string.format("%d", self.mInfo.vip),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(111, 47, 2)
    }):pos(vipFrame:getContentSize().width * 0.72, vipFrame:getContentSize().height * 0.32):addTo(vipFrame)
  end
  self:loadMemberInfo()
  self:loadFuncBtn()
end

function M:loadMemberInfo()
  DYLabelTTF.new({
    text = self.mInfo.nick,
    size = 24,
    color = cc.c3b(67, 38, 1),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(140, self.mBg:getContentSize().height * 0.78):addTo(self.mBg)
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S1749", ""),
    size = 24,
    color = cc.c3b(67, 38, 1),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(140, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  DYLabelTTF.new({
    text = self.mInfo.power,
    size = 24,
    color = cc.c3b(169, 108, 28),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb:getPositionX() + lb:getContentSize().width, lb:getPositionY()):addTo(self.mBg)
  local stateLabel = DYLabelTTF.new({
    text = DYLang.getString("S1750", ""),
    size = 24,
    color = cc.c3b(0, 169, 32),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(140, self.mBg:getContentSize().height * 0.22):addTo(self.mBg)
  if 0 == self.mInfo.online then
    stateLabel:setString(DYLang.getString("S1751", ""))
    stateLabel:setColor(cc.c3b(120, 120, 120))
  end
end

function M:loadFuncBtn()
  local passBtn = cc.ui.UIPushButton.new({
    normal = "union/btn_pass.png",
    disabled = "union/btn_pass.png"
  }):pos(self.mBg:getContentSize().width * 0.7, self.mBg:getContentSize().height * 0.5):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    if self.mCallback then
      self.mCallback({
        is_passed = true,
        info = self.mInfo,
        index = self.mIndex
      })
    end
  end):addTo(self.mBg)
  local rejectBtn = cc.ui.UIPushButton.new({
    normal = "union/btn_pass_no.png",
    disabled = "union/btn_pass_no.png"
  }):pos(self.mBg:getContentSize().width * 0.88, self.mBg:getContentSize().height * 0.5):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    if self.mCallback then
      self.mCallback({
        is_passed = false,
        info = self.mInfo,
        index = self.mIndex
      })
    end
  end):addTo(self.mBg)
end

return M

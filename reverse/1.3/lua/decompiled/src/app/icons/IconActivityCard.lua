local M = {}
M = class("IconActivityCard", function()
  return display.newNode()
end)
local WIDTH, HEIGHT = 240, 450

function M:ctor(index, params, handler_)
  self.mCallback = handler_
  self:initData(index, params)
  self:initUI()
  self:setContentSize(WIDTH, HEIGHT)
end

function M:initData(index, params)
  self.mStatus = params[tostring(index)].isDraw
  self.mLeftDays = params[tostring(index)].finishedValue
  self.mTaskId = index
  self.mIsActive = false
  if self.mStatus ~= 1 and self.mLeftDays > 0 then
    self.mIsActive = true
  end
end

function M:initUI()
  local textColor = {
    cc.c3b(0, 255, 16),
    cc.c3b(0, 234, 255),
    cc.c3b(249, 55, 235)
  }
  local textStr = {
    "\230\140\129\231\187\173\232\181\160\233\128\1297\229\164\169",
    "\230\140\129\231\187\173\232\181\160\233\128\12930\229\164\169",
    "\230\151\160\230\172\161\230\149\176\233\153\144\229\136\182"
  }
  local dailyGet = {
    80,
    120,
    120
  }
  local btnText = {normal = "\233\162\134\229\143\150", disabled = "\229\183\178\233\162\134\229\143\150"}
  local icon = display.newSprite(string.format("activity/card%d.png", self.mTaskId), WIDTH * 0.5, HEIGHT * 0.5 + 72):addTo(self, 2)
  local textBg = display.newSprite("activity/text_bg.png", WIDTH * 0.5, HEIGHT * 0.5 - 103):addTo(self)
  local text = display.newSprite("activity/text2.png"):pos(textBg:getContentSize().width * 0.5, textBg:getContentSize().height * 0.63):addTo(textBg)
  DYLabelTTF.new({
    text = dailyGet[self.mTaskId],
    size = 28,
    color = textColor[self.mTaskId],
    font = GameManager.FONTNAME_TTF
  }, {}):pos(text:getContentSize().width * 0.68, text:getContentSize().height * 0.5):addTo(text)
  if 0 >= self.mLeftDays then
    DYLabelTTF.new({
      text = textStr[self.mTaskId],
      size = 24,
      color = cc.c3b(0, 255, 16),
      font = GameManager.FONTNAME_TTF
    }, {}):pos(textBg:getContentSize().width * 0.5, textBg:getContentSize().height * 0.25):addTo(textBg)
    btnText.normal = "\232\180\173\228\185\176"
  elseif 3 == self.mTaskId then
    display.newSprite("activity/label3.png"):pos(textBg:getContentSize().width * 0.5, textBg:getContentSize().height * 0.25):addTo(textBg)
  else
    local sp = display.newSprite("activity/label6.png"):pos(textBg:getContentSize().width * 0.4, textBg:getContentSize().height * 0.25):addTo(textBg)
    local leftTimes = cc.ui.UILabel.new({
      UILabelType = 1,
      text = self.mLeftDays,
      font = "fonts/bulefonts.fnt"
    }):scale(0.6):align(display.CENTER_LEFT, sp:getPositionX() + sp:getContentSize().width * 0.55, textBg:getContentSize().height * 0.25):addTo(textBg)
    self.mLeftTimesLabel = leftTimes
  end
  self.mBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = btnText.normal,
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = btnText.disabled,
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):align(display.CENTER, WIDTH * 0.5, HEIGHT * 0.5 - 190):onButtonClicked(function()
    self:getAwardCallback()
  end):addTo(self)
  if 1 == self.mStatus then
    self:performWithDelay(function()
      self.mBtn:setButtonEnabled(false)
    end, 0)
  end
end

function M:getAwardCallback()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  local params = {
    taskId = self.mTaskId,
    leftDays = self.mLeftDays
  }
  if self.mCallback then
    self.mCallback(params)
  end
end

function M:updateUI(params)
  if self.mLeftTimesLabel then
    self.mLeftTimesLabel:setString(params.leftDays)
  end
  self.mBtn:setButtonEnabled(false)
end

return M

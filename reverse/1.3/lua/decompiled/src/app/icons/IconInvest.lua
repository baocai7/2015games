local LayerItem = require("app.layers.LayerItem")
local M = {}
M = class("IconInvest", function()
  return display.newNode()
end)

function M:ctor(params, handler_)
  self.mCallback = handler_
  self:initData(params)
  self:initUI()
end

function M:initData(params)
  self.mRewardNum = params.award
  self.mStatus = params.isDraw
  self.mNeedLevel = params.level
  self.mIsActive = false
  if 0 == params.isBuy then
    self.mStatus = 0
    return
  end
  if 0 == self.mStatus and CloudData.USER_LEVEL >= self.mNeedLevel then
    self.mStatus = 1
    self.mIsActive = true
    return
  end
  if 1 == self.mStatus then
    self.mStatus = 2
  end
end

function M:initUI()
  local bg = display.newSprite("activity/icon.png"):addTo(self)
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):align(display.CENTER_LEFT, 18, bg:getContentSize().height * 0.5):addTo(bg, 1)
  display.newSprite("item_icon/icon_peach1.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  DYLabelTTF.new({
    text = "X" .. self.mRewardNum,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {}):pos(iconFrame:getContentSize().width - 10, 20):addTo(iconFrame)
  display.newSprite("shop_new/img_line.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg)
  local textStr = string.format("%d\231\186\167\230\138\149\232\181\132\229\155\158\230\138\165", self.mNeedLevel)
  DYLabelTTF.new({
    text = textStr,
    size = 26,
    color = cc.c3b(255, 252, 20),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(59, 32, 3)
  }):pos(32 + iconFrame:getContentSize().width, bg:getContentSize().height * 0.7):addTo(bg)
  local textStr = string.format("\232\167\146\232\137\178\229\136\176\232\190\190%d\231\186\167\229\143\175\233\162\134\229\143\150", self.mNeedLevel)
  DYLabelTTF.new({
    text = textStr,
    size = 24,
    color = cc.c3b(104, 54, 6),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(32 + iconFrame:getContentSize().width, bg:getContentSize().height * 0.3):addTo(bg)
  local btnText = {normal = "\233\162\134  \229\143\150", disabled = "\233\162\134  \229\143\150"}
  if 1 <= self.mStatus then
    btnText.disabled = "\229\183\178\233\162\134\229\143\150"
  end
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = btnText.normal,
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {})):setButtonLabel("disabled", DYLabelTTF.new({
    text = btnText.disabled,
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  })):align(display.CENTER, bg:getContentSize().width * 0.85, bg:getContentSize().height * 0.5):onButtonClicked(function(event)
    local params = {
      level = self.mNeedLevel,
      btn = event.target
    }
    if self.mCallback then
      self.mCallback(params)
    end
  end):addTo(bg, 1)
  if self.mStatus ~= 1 then
    self:performWithDelay(function()
      btn:setButtonEnabled(false)
    end, 0)
  end
end

function M:getAwardCallback()
  DDLOG("get award")
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  local params = {
    taskId = self.mTaskId,
    loadTo = 0,
    tar = self.mBtn
  }
  if self.mCallback then
    self.mCallback(params)
  end
end

function M:layerChange()
  DDLOG("layer change")
  local params = {
    taskId = self.mTaskId,
    loadTo = self.mActivityModel.loadTo
  }
  if self.mCallback then
    self.mCallback(params)
  end
  if tonumber(self.mActivityModel.loadTo) == 3 then
  elseif tonumber(self.mActivityModel.loadTo) == 1 then
  end
end

return M

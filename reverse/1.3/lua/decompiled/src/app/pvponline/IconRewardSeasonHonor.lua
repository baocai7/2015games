local IconItem = import("icons.IconItem")
local M = {}
M = class("IconRewardSeasonHonor", function()
  return display.newNode()
end)

function M:ctor(index)
  self.mIndex = checknumber(index)
  self.mInfo = DataUtils.getSeasonHonorAwardData(self.mIndex)
  if not self.mInfo or checknumber(self.mInfo.itemNum) == 0 then
    self.tag = true
    self:runAction(cc.RemoveSelf:create())
    return
  end
  self.tag = false
  self:initUI()
end

function M:initUI()
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(800, 85), cc.rect(30, 30, 1, 1)):addTo(self)
  self.mBg = bg
  display.newSprite("#grade" .. checknumber(self.mInfo.grade) .. ".png"):scale(0.6):align(display.CENTER, 60, 45):addTo(bg)
  display.newSprite("#name" .. checknumber(self.mInfo.grade) .. ".png"):align(display.CENTER, 160, 45):addTo(bg)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = "+" .. self.mInfo.itemNum,
    font = "fonts/greenNum.fnt"
  }):scale(0.6):align(display.CENTER_RIGHT, 635, 43):addTo(bg)
  IconItem.new(self.mInfo.itemId):scale(0.65):align(display.CENTER, 680, 43):addTo(bg)
  self:addMask()
end

function M:addMask()
  local maxScore = checknumber(CloudData.GRADE_INFO.max_score)
  if maxScore >= checknumber(self.mInfo.credit) then
    local mask = display.newScale9Sprite("pvp_ol/reward_mask.png", 0, 0, cc.size(800, 85), cc.rect(30, 30, 1, 1)):align(display.CENTER, 400, 42.5):addTo(self.mBg, 1)
    display.newSprite("pvp_ol/reward_send.png"):align(display.CENTER, 80, 42.5):addTo(mask)
  end
end

return M

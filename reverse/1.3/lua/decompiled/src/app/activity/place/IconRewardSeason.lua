local IconItem = import("icons.IconItem")
local M = {}
M = class("IconRewardSeason", function()
  return display.newNode()
end)

function M:ctor(index, nowHurt)
  self.nowHurt = nowHurt or 0
  self.mIndex = checknumber(index)
  self.mInfo = DataUtils.getActivityPlaceHurt(self.mIndex)
  self.tag = false
  self:initData()
  self:initUI()
end

function M:initData()
end

function M:initUI()
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(800, 85), cc.rect(30, 30, 1, 1)):addTo(self)
  self.mBg = bg
  local numLabel = self.mInfo.hurt
  if 1 <= self.mInfo.hurt / 10000 then
    numLabel = self.mInfo.hurt / 10000
  end
  DYLabelTTF.new({
    text = numLabel .. DYLang.getString("S42", ""),
    size = 26,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.LEFT_CENTER, 100, 43):addTo(self.mBg)
  for i = 1, #self.mInfo.itemIds do
    local num = checknumber(self.mInfo.itemNums[i])
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = "+" .. num,
      font = "fonts/greenNum.fnt"
    }):scale(0.6):align(display.LEFT_CENTER, 60 + 180 * i, 43):addTo(bg)
    IconItem.new(checknumber(self.mInfo.itemIds[i])):scale(0.65):align(display.LEFT_CENTER, 180 * i, 43):addTo(bg)
  end
  self:addMask()
end

function M:addMask()
  local maxScore = checknumber(self.nowHurt)
  if maxScore >= checknumber(self.mInfo.hurt) then
    local mask = display.newScale9Sprite("pvp_ol/reward_mask.png", 0, 0, cc.size(800, 85), cc.rect(30, 30, 1, 1)):align(display.CENTER, 400, 42.5):addTo(self.mBg, 1)
    display.newSprite("pvp_ol/reward_send.png"):align(display.CENTER, 80, 42.5):addTo(mask)
  end
end

return M

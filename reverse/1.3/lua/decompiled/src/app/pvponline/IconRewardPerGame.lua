local IconItem = import("icons.IconItem")
local M = {}
M = class("IconRewardPerGame", function()
  return display.newNode()
end)

function M:ctor(index)
  self.mIndex = checknumber(index)
  self.mInfo = DataUtils.getPvpOlFightReward(self.mIndex)
  dump(self.mInfo)
  if not self.mInfo then
    return
  end
  self:initUI()
end

function M:initUI()
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(800, 85), cc.rect(30, 30, 1, 1)):addTo(self)
  self.mBg = bg
  display.newSprite("#grade" .. checknumber(self.mInfo.grade) .. ".png"):scale(0.6):align(display.CENTER, 60, 45):addTo(bg)
  display.newSprite("#name" .. checknumber(self.mInfo.grade) .. ".png"):align(display.CENTER, 156, 45):addTo(bg)
  if 0 <= tonumber(self.mInfo.credit) and 0 < tonumber(self.mInfo.level) then
    display.newSprite("#level" .. checknumber(self.mInfo.level) .. ".png"):align(display.CENTER, 227, 45):addTo(bg)
  end
  cc.ui.UILabel.new({
    text = DYLang.getString("S1152", ""),
    size = 25,
    color = cc.c3b(79, 38, 1),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 370, 43):addTo(bg)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = "+" .. self.mInfo.winNum,
    font = "fonts/greenNum.fnt"
  }):scale(0.6):align(display.CENTER_RIGHT, 455, 43):addTo(bg)
  IconItem.new(7):scale(0.65):align(display.CENTER_LEFT, 500, 43):addTo(bg)
  cc.ui.UILabel.new({
    text = DYLang.getString("S1153", ""),
    size = 25,
    color = cc.c3b(79, 38, 1),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 590, 43):addTo(bg)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = "+" .. self.mInfo.loseNum,
    font = "fonts/greenNum.fnt"
  }):scale(0.6):align(display.CENTER_RIGHT, 675, 43):addTo(bg)
  IconItem.new(7):scale(0.65):align(display.CENTER, 720, 43):addTo(bg)
end

return M

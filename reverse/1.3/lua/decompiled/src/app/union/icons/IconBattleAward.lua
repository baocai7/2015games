local IconItem = import("icons.IconItem")
local M = {}
M = class("IconBattleAward", function()
  return display.newNode()
end)

function M:ctor(params)
  self.mInfo = params
  if not self.mInfo then
    return
  end
  self:initUI()
end

function M:initUI()
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(800, 85), cc.rect(30, 30, 1, 1)):addTo(self)
  self.mBg = bg
  if self.mInfo.minNum < 4 then
    display.newSprite("pvp_ol/gi_rank" .. self.mInfo.minNum .. ".png"):scale(0.9):align(display.CENTER, 60, 45):addTo(bg)
  else
    local str = string.format("%d-%d", checknumber(self.mInfo.minNum), checknumber(self.mInfo.maxNum))
    cc.ui.UILabel.new({
      text = str,
      color = cc.c3b(138, 91, 1),
      size = 25,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 36, 45):addTo(bg)
  end
  for i = #self.mInfo.itemIds, 1, -1 do
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = "+" .. checknumber(self.mInfo.itemNums[i]),
      font = "fonts/greenNum.fnt"
    }):scale(0.6):align(display.CENTER_RIGHT, 885 - 205 * i, 43):addTo(bg)
    IconItem.new(checknumber(self.mInfo.itemIds[i])):scale(0.65):align(display.CENTER, 930 - 205 * i, 43):addTo(bg)
  end
end

return M

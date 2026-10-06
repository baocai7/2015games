local M = {}
M = class("BuddhaFateIcon", function()
  return display.newNode()
end)

function M:ctor(fateId, buddhaId)
  self:initData(fateId, buddhaId)
  self:initUI()
end

function M:initData(fateId, buddhaId)
  self.mFateModel = DataUtils.getBuddhaFateModel(fateId, buddhaId)
end

function M:initUI()
  local bg = ""
  local nameColor, textColor
  if self.mFateModel.isFateActive then
    bg = display.newSprite("upgrade/fate_bg2.png"):addTo(self)
    nameColor = cc.c3b(196, 111, 0)
    textColor = cc.c3b(107, 57, 19)
  else
    bg = display.newSprite("upgrade/fate_bg1.png"):addTo(self)
    nameColor = cc.c3b(196, 111, 0)
    textColor = cc.c3b(107, 57, 19)
  end
  local pName = cc.ui.UILabel.new({
    text = self.mFateModel.fateName,
    size = 24,
    color = nameColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.03, bg:getContentSize().height * 0.82):addTo(bg)
  cc.ui.UILabel.new({
    text = self.mFateModel.fataDesc,
    size = 20,
    color = textColor,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(450, 56),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.03, bg:getContentSize().height * 0.37):addTo(bg)
end

return M

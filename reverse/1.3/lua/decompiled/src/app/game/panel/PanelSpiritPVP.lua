local M = {}
M = class("PanelSpiritPVP", function()
  return display.newNode()
end)
M.BUDDHA_SPIRIT = 4001
M.ENEMY_SPIRIT = 4002

function M:ctor(spiritType, handler_)
  self.mCallback = handler_
  self.mType = spiritType
  self:initData()
  self:initUI()
end

function M:initData()
  GameData.BUDDHA_COUNT_SPIRIT = GameManager.PVP_BUDDHA_INFO.spirit
  GameData.ENEMY_COUNT_SPIRIT = GameManager.PVP_ENEMY_INFO.spirit
end

function M:initUI()
  local spiritIcon = display.newSprite("gamescene/spirit.png"):addTo(self)
  if M.BUDDHA_SPIRIT == self.mType then
    self.mNumLabel = cc.ui.UILabel.new({
      UILabelType = 1,
      text = GameData.BUDDHA_COUNT_SPIRIT,
      font = "fonts/whiteNum.fnt"
    }):scale(0.75):align(display.CENTER_RIGHT, spiritIcon:getPositionX() - spiritIcon:getContentSize().width * 0.5, 0):addTo(self)
  else
    self.mNumLabel = cc.ui.UILabel.new({
      UILabelType = 1,
      text = GameData.ENEMY_COUNT_SPIRIT,
      font = "fonts/whiteNum.fnt"
    }):scale(0.75):align(display.CENTER_LEFT, spiritIcon:getPositionX() + spiritIcon:getContentSize().width * 0.55, 0):addTo(self)
  end
end

function M:updateLabel(spiritType)
  if M.BUDDHA_SPIRIT == spiritType then
    self.mNumLabel:setString(GameData.BUDDHA_COUNT_SPIRIT)
  else
    self.mNumLabel:setString(GameData.ENEMY_COUNT_SPIRIT)
  end
end

return M

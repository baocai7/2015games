local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local SpiritCounter = {}
SpiritCounter = class("SpiritCounter", function()
  return display.newNode()
end)

function SpiritCounter:ctor()
  self.spiritLabel_ = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("%d/%d", 0, 0),
    font = "fonts/yellowNum.fnt"
  }):align(display.RIGHT_BOTTOM):addTo(self)
  display.newSprite("gamescene/spirit.png", 40, 10):addTo(self)
  self:reInit()
end

function SpiritCounter:reInit()
  if self.schedule_selector_ then
    self:stopAction(self.schedule_selector_)
  end
  local tangmonkLevel = GameManager.TANGMONK_LEVEL
  if 8 < tangmonkLevel then
    tangmonkLevel = 1
  end
  local towerBuddhaModel = DataUtils.getTowerBuddhaModel()
  local spiritStorageLimit = towerBuddhaModel.spiritStorageLimit_
  local spiritStorageLevel = DataUtils.getPropertyLevel(6)
  self.maxSpirit_ = spiritStorageLimit + 50 * spiritStorageLevel * (tangmonkLevel - 1)
  local tm = DataUtils.getTreasureModel(3)
  if tm.isTreasureEffective_ then
    self.maxSpirit_ = tonumber(self.maxSpirit_ * (1 + tm.effectIncreaseRate_ * 0.5))
  end
  local currentSpirit = GameManager.getCurrentSpirit()
  self.spiritLabel_:setString(string.format("%d/%d", currentSpirit, self.maxSpirit_))
  local growSpeed = towerBuddhaModel.spiritGrowSpeed_ * (1 - 0.05 * (tangmonkLevel - 1))
  local tm2 = DataUtils.getTreasureModel(2)
  if tm2.isTreasureEffective_ then
    growSpeed = tonumber(growSpeed / (1 + tm2.effectIncreaseRate_ * 0.5))
  end
  self.incPerSec_ = 0.1 / growSpeed / 1.11 + 100
  self.schedule_selector_ = self:schedule(function()
    self:updateSpirit()
  end, 0.1)
end

function SpiritCounter:updateSpirit()
  local currSpirit = GameManager.getCurrentSpirit()
  if currSpirit < self.maxSpirit_ then
    currSpirit = currSpirit + self.incPerSec_
    GameManager.setCurrentSpirit(currSpirit)
  else
    currSpirit = self.maxSpirit_ + 1000000
    GameManager.setCurrentSpirit(currSpirit)
  end
  self.spiritLabel_:setString(string.format("%d/%d", currSpirit, self.maxSpirit_))
end

function SpiritCounter:onExit()
  if self.schedule_selector_ then
    self:stopAction(self.schedule_selector_)
  end
end

return SpiritCounter

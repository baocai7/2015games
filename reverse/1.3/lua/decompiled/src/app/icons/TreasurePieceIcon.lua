TAG_TREASURE_PIECE_LAYER = 1
local TreasurePieceInfoLayer = require("app.layers.LayerTreasurePieceInfo")
local NoviceGuide = require("app.utils.NoviceGuide")
local TreasurePieceIcon = class("TreasurePieceIcon", function()
  return display.newNode()
end)

function TreasurePieceIcon:ctor(treasurePieceModel)
  self.id_ = tonumber(treasurePieceModel.treasurePieceId_)
  self.selectedId_ = 0
  local treasurePieceQuality = tonumber(treasurePieceModel.treasurePieceQuality_)
  local pieceFrame = display.newSprite("treasure/frame_tp.png"):addTo(self)
  display.newSprite(string.format("treasure/piece" .. treasurePieceQuality .. ".png"), pieceFrame:getContentSize().width * 0.5, pieceFrame:getContentSize().height * 0.5):scale(0.7857142857142857):addTo(pieceFrame)
  self.selectedIcon_ = display.newSprite("treasure/piece_selected.png"):addTo(self)
  self.selectedIcon_:setVisible(false)
  pieceFrame:setTouchEnabled(true)
  pieceFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouch(event.name, event.x, event.y)
  end)
  self:setContentSize(pieceFrame:getContentSize())
end

function TreasurePieceIcon:onTouch(event, x, y)
  if event == "began" then
    self.touchBeginPoint_ = {x = x, y = y}
    return true
  end
  if event == "moved" then
  end
  if event == "ended" then
    local touchEndedPoint = {x = x, y = y}
    if math.abs(self.touchBeginPoint_.x - touchEndedPoint.x) < 10 and math.abs(self.touchBeginPoint_.y - touchEndedPoint.y) < 10 and cc.rectContainsPoint(self:getMyBoundingBox(), touchEndedPoint) then
      self:touchPieceIcon_()
    end
  end
end

function TreasurePieceIcon:touchPieceIcon_()
  self.selectedId_ = self.id_
  local layer = TreasurePieceInfoLayer.new(self.id_, handler(self, self.onEventPieceLayer))
  layer:show()
  self.selectedIcon_:setVisible(true)
end

function TreasurePieceIcon:onEventPieceLayer()
  self.selectedIcon_:setVisible(false)
end

function TreasurePieceIcon:updateLayer_()
  if display.getRunningScene():getChildByTag(TAG_TREASURE_PIECE_LAYER) then
    if self.selectedId_ == self.id_ then
      self.selectedIcon_:setVisible(true)
      self.selectedId_ = 0
    end
  else
    self.selectedIcon_:setVisible(false)
  end
end

function TreasurePieceIcon:getMyBoundingBox()
  local point = cc.p(self:getPositionX(), self:getPositionY())
  local worldpoint = self:getParent():convertToWorldSpace(point)
  local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5, worldpoint.y - self:getContentSize().height * 0.5, self:getContentSize().width, self:getContentSize().height)
  return rect
end

return TreasurePieceIcon

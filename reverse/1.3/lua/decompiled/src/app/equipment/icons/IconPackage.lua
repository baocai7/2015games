local DYClass = "IconPackage"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)

function M:ctor(equipData, showLevel)
  self.mData = equipData
  self.mStatus = 0
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", equipData.quality)):addTo(self)
  display.newSprite("equipment/icon_back.png", 59, 59):addTo(iconFrame)
  local icon = display.newSprite(equipData.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if showLevel then
    self.mLevelLabel = DYLabelTTF.new({
      text = "Lv." .. equipData.level,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_RIGHT"
    }, {}):pos(110, 15):addTo(iconFrame)
  else
    local sp = display.newSprite("equipment/img_mask.png"):align(display.CENTER_BOTTOM, 59, 10):addTo(iconFrame, 1)
    DYLabelTTF.new({
      text = equipData.spirit,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):pos(48, 13):addTo(sp)
  end
  display.newSprite(string.format("equipment/mark%d.png", equipData.grade), 110, 110):addTo(iconFrame, 1)
  self.mSelectedFrame = display.newSprite("equipment/icon_selected.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):hide():addTo(iconFrame, -1)
  self.mMaskFrame = display.newSprite("equipment/icon_selected1.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):hide():addTo(iconFrame, 2)
end

function M:setSelected(flag)
  self.mStatus = flag and 1 or 0
  self.mSelectedFrame:setVisible(flag)
end

function M:setMaskVisible(flag)
  self.mStatus = flag and 2 or 0
  self.mMaskFrame:setVisible(flag)
end

function M:getStatus()
  return self.mStatus
end

function M:setStatus(status)
  self.mStatus = status
end

function M:getEquipmentData()
  return self.mData
end

function M:getEquipmentUeid()
  return self.mData.ueid
end

function M:updateLevel(data)
  self.mData = data
  self.mLevelLabel:setString("Lv." .. data.level)
end

return M

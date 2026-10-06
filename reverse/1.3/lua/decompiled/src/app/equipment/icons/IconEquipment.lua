local DYClass = "IconEquipment"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)

function M:ctor(equipData, tag, buddhaId, spiritCost, callback)
  cc(self):addComponent("framework.cc.components.behavior.EventProtocol"):exportMethods()
  self:setScale(0.8)
  self.mData = equipData
  self.mTag = tag
  self.mStatus = 0
  self.mBuddhaId = buddhaId
  self.mSpiritCost = spiritCost
  if equipData then
    self:loadEquipUI(equipData)
  else
    self:loadEmptyUI()
  end
  self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if "began" == name then
      return true
    elseif "ended" == name then
      local touchInSprite = cc.rectContainsPoint(self.mIconFrame:getCascadeBoundingBox(), cc.p(x, y))
      if touchInSprite then
        self:setSelected(true)
      end
    end
  end)
end

function M:loadEquipUI(equipData)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", equipData.quality)):addTo(self)
  self.mIconFrame = iconFrame
  display.newSprite("equipment/icon_back.png", 59, 59):addTo(iconFrame)
  local icon = display.newSprite(equipData.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  self.mIcon = icon
  local levelFrame = display.newSprite("equipment/img_01.png"):pos(iconFrame:getContentSize().width - 5, 5):addTo(iconFrame)
  self.mLevelLabel = cc.ui.UILabel.new({
    text = equipData.level,
    size = 18,
    color = cc.c3b(255, 255, 15),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, levelFrame:getContentSize().width * 0.5, levelFrame:getContentSize().height * 0.5):addTo(levelFrame)
  self.mMark = display.newSprite("equipment/icon_arrow.png", 25, 100):hide():addTo(iconFrame)
  if equipData.level < CloudData.USER_LEVEL * 2 and (CloudData.IRON > 0 or 0 < EMgr.getEquipmentsNumForPackage()) then
    self.mStatus = 1
    self.mMark:show()
  end
  self.mSelectedFrame = display.newSprite("equipment/icon_selected.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):hide():addTo(iconFrame, -1)
  self:setTouchEnabled(true)
end

function M:loadEmptyUI()
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):addTo(self)
  self.mIconFrame = iconFrame
  
  local function addFuncBtn()
    cc.ui.UIPushButton.new({
      normal = "equipment/img_add.png",
      pressed = "equipment/img_add.png"
    }):onButtonPressed(function(event)
      event.target:setScale(0.9)
    end):onButtonRelease(function(event)
      event.target:setScale(1)
    end):onButtonClicked(function()
      self:dispatchEvent({
        name = EMgr.EVENT_EQUIP_ON,
        data = {
          tag = self.mTag,
          icon = self
        }
      })
    end):align(display.CENTER, 59, 59):addTo(iconFrame)
  end
  
  for k, v in pairs(EMgr.EQUIP_LIST) do
    if EMgr.checkEquipmentValid(v, self.mTag, self.mBuddhaId, self.mSpiritCost) then
      self.mStatus = 2
      addFuncBtn()
      break
    end
  end
  self:setTouchEnabled(false)
end

function M:setSelected(flag)
  if flag and self.mSelectedFrame:isVisible() then
    return
  end
  self.mSelectedFrame:setVisible(flag)
  if flag then
    self:dispatchEvent({
      name = EMgr.EVENT_EQUIP_CLICKED,
      data = {icon = self}
    })
  end
end

function M:equipmentDown()
  self.mIconFrame:runAction(cc.RemoveSelf:create())
  self.mIconFrame = nil
  self.mStatus = 0
  self:loadEmptyUI()
end

function M:equipmentOn(data)
  self.mIconFrame:runAction(cc.RemoveSelf:create())
  self.mIconFrame = nil
  self.mStatus = 0
  self.mData = data
  self:loadEquipUI(data)
  self:setSelected(true)
end

function M:equipmentReplace(data)
  self.mData = data
  self.mIconFrame:setTexture(string.format("common_ui/frame%d.png", data.quality))
  self.mIcon:setTexture(data.icon)
  self.mLevelLabel:setString(data.level)
  if data.level < CloudData.USER_LEVEL * 2 then
    self.mStatus = 1
    self.mMark:show()
  else
    self.mStatus = 0
    self.mMark:hide()
  end
end

function M:getIconStatus()
  return self.mStatus
end

function M:updateLevel(level)
  self.mLevelLabel:setString(level)
  if level == CloudData.USER_LEVEL * 2 then
    self.mMark:hide()
  end
end

function M:updateIcon(data)
  self.mIconFrame:setTexture(string.format("common_ui/frame%d.png", data.quality))
  self.mIcon:setTexture(data.icon)
end

return M

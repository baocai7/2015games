local M = {}
M = class("IconBuddha", function()
  return display.newNode()
end)

function M:ctor(buddhaModel)
  self:setScale(0.9)
  self.mData = buddhaModel
  self.mIsOnTeam = buddhaModel.isOnTeam
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality)):addTo(self)
  local icon = display.newSprite(buddhaModel.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 == buddhaModel.isRebel then
    icon:setScaleX(-1)
  end
  local levelFrame = display.newSprite("team/frame.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.17):addTo(iconFrame)
  cc.ui.UILabel.new({
    text = string.format("LV.%d", buddhaModel.level),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, levelFrame:getContentSize().width * 0.5, levelFrame:getContentSize().height * 0.5):addTo(levelFrame)
  self.mSelectedFrame = display.newSprite("equipment/icon_selected.png"):hide():addTo(self, -1)
  self.mMark = display.newSprite("equipment/icon_arrow.png", 25, 100):hide():addTo(iconFrame)
  if 1 == self:checkIconStatus(buddhaModel) then
    self.mMark:show()
  end
end

function M:checkIconStatus(buddhaData)
  local status = 0
  if 0 == self.mIsOnTeam then
    return 0
  end
  
  local function checkValid(tag)
    local res = false
    for k, v in pairs(EMgr.EQUIP_LIST) do
      if EMgr.checkEquipmentValid(v, tag, buddhaData.npcId, buddhaData.consume) then
        res = true
        break
      end
    end
    return res
  end
  
  for i = 1, #buddhaData.equipmentList do
    local eid = buddhaData.equipmentList[i]
    local eData = EMgr.EQUIP_LIST[eid]
    if not eData then
      if checkValid(i) then
        status = 1
      end
    elseif eData.level < CloudData.USER_LEVEL * 2 and (0 < CloudData.IRON or 0 < EMgr.getEquipmentsNumForPackage()) then
      status = 1
    end
    if 1 == status then
      break
    end
  end
  return status
end

function M:setSelected(flag)
  self.mSelectedFrame:setVisible(flag)
end

function M:setMarkVisible(flag)
  self.mMark:setVisible(flag)
end

return M

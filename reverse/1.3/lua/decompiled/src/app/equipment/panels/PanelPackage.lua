local IconPackage = require("equipment.icons.IconPackage")
local DYClass = "PanelPackage"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)

local function M_filePath(name)
  return string.format("equipment/%s.png", name)
end

function M:ctor(params, callback)
  cc(self):addComponent("framework.cc.components.behavior.EventProtocol"):exportMethods()
  self:setContentSize(620, 640)
  self.mFrame = display.newScale9Sprite(M_filePath("img_00"), 290, 345, cc.size(589, 500), cc.rect(90, 320, 1, 1)):addTo(self)
  display.newSprite(M_filePath("title_knapsack"), 290, 500):addTo(self.mFrame)
  self:performWithDelay(function()
    self:loadListView()
  end, 0)
end

local function getEquipmentList()
  local list = {}
  for k, v in pairs(EMgr.EQUIP_LIST) do
    if 0 == v.buddhaId then
      table.insert(list, v)
    end
  end
  table.sort(list, function(v1, v2)
    if v1.level == v2.level then
      return v1.potential > v2.potential
    else
      return v1.level > v2.level
    end
  end)
  return list
end

function M:loadListView()
  self.mEquipIcons = {}
  self.mEquipmentList = getEquipmentList()
  if 0 == #self.mEquipmentList then
    return
  end
  self.mListView = DYListView.new({
    async = true,
    viewRect = cc.rect(20, 55, 540, 400),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(self.mFrame)
  local totalNum = #self.mEquipmentList
  local row = math.ceil(totalNum / 4)
  local column = totalNum % 4
  local endNum = 4
  
  local function tFuncDelegate(listView, tag, idx)
    if DYListView.COUNT_TAG == tag then
      return row
    elseif DYListView.CELL_TAG == tag then
      item = self.mListView:dequeueItem(idx)
      if item then
        return item
      end
      item = self.mListView:newItem()
      content = display.newNode()
      item:addContent(content)
      content:setContentSize(540, 128)
      for count = 1, endNum do
        local n = (idx - 1) * 4 + count
        local model = self.mEquipmentList[n]
        if model then
          local icon = IconPackage.new(model, true)
          icon:setPosition(270 * (0.5 * count - 0.25), 64)
          icon.index = n
          content:addChild(icon)
          table.insert(self.mEquipIcons, icon)
        end
      end
      item:setItemSize(540, 128)
      return item
    end
  end
  
  self.mListView:setDelegate(tFuncDelegate)
  self.mListView:reload()
end

function M:updateListView()
  if self.mCurrIcon then
    self.mCurrIcon:setSelected(false)
    self.mCurrIcon = nil
  end
  if self.mListView then
    self.mListView:removeAllItems()
    self.mListView:runAction(cc.RemoveSelf:create(true))
    self.mListView = nil
  end
  self:loadListView()
end

function M:selectIcon()
  if 0 == #self.mEquipIcons then
    EMgr.CURR_EQUIPMENT = nil
    self:dispatchEvent({
      name = EMgr.EVENT_EQUIP_INFO
    })
    return
  end
  self:changeEquipment(self.mEquipIcons[1], 1)
end

function M:changeEquipment(icon, index)
  if self.mCurrIcon then
    if self.mCurrIcon.index == index then
      return
    end
    self.mCurrIcon:setSelected(false)
  end
  icon:setSelected(true)
  self.mCurrIcon = icon
  EMgr.CURR_EQUIPMENT = self.mCurrIcon.mData.ueid
  self:dispatchEvent({
    name = EMgr.EVENT_EQUIP_INFO,
    data = EMgr.CURR_EQUIPMENT
  })
end

function M:onUpdateDataUpgrade(equipmentData)
  self:updateListView()
  if not display.getRunningScene().mIsPackageOn then
    return
  end
  for i = 1, #self.mEquipIcons do
    local icon = self.mEquipIcons[i]
    if icon:getEquipmentUeid() == EMgr.CURR_EQUIPMENT then
      icon:setSelected(true)
      self.mCurrIcon = icon
      break
    end
  end
end

function M:onUpdateDataResolve(equipmentData)
  self.mCurrIcon:updateLevel(equipmentData)
end

function M:onUpdateDataQuenching(equipmentData)
  self:onUpdateDataUpgrade(equipmentData)
end

function M:touchListener(event)
  if "clicked" == event.name then
    local column = math.ceil(event.point.x * 4 / 540)
    local index = 0
    if event.itemPos ~= nil then
      index = (event.itemPos - 1) * 4 + column
    end
    if index > #self.mEquipmentList then
      return
    end
    local icon = self.mEquipIcons[index]
    self:changeEquipment(icon, index)
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:panelShow(isAni)
  self:show()
  self:selectIcon()
  if not isAni then
    return
  end
  local seq = transition.sequence({
    cc.DelayTime:create(0.2),
    cc.MoveBy:create(0.2, cc.p(710, 0))
  })
  self:runAction(seq)
end

function M:panelHide(isAni)
  EMgr.CURR_EQUIPMENT = nil
  if self.mCurrIcon then
    self.mCurrIcon:setSelected(false)
    self.mCurrIcon = nil
  end
  if not isAni then
    self:hide()
    return
  end
  local seq = transition.sequence({
    cc.MoveBy:create(0.2, cc.p(-710, 0)),
    cc.CallFunc:create(function()
      self:hide()
    end)
  })
  self:runAction(seq)
end

return M

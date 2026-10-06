local IconPackage = require("equipment.icons.IconPackage")
local PanelUpgrade = require("equipment.panels.PanelUpgrade")
local CLASS_NAME = "LayerUpgrade"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local LIMIT_QUA = {
  [0] = 6,
  [1] = 3,
  [2] = 4,
  [3] = 5
}
local MAX_AUTO_NUM = 4

function M:ctor(params, callbcak)
  self.mCallback = callbcak
  self.mEquipData = EMgr.EQUIP_LIST[params.ueid]
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:initData()
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function M_filePath(name)
  return string.format("equipment/%s.png", name)
end

function M:getEquipmentList()
  local list = {}
  for k, v in pairs(EMgr.EQUIP_LIST) do
    if k ~= self.mEquipData.ueid and 0 == v.buddhaId and 0 == v.level and not v.shenbing then
      table.insert(list, v)
    end
  end
  table.sort(list, function(v1, v2)
    return v1.quality < v2.quality
  end)
  return list
end

function M:initData()
  self.mEquipmentList = self:getEquipmentList()
  self.mEquipIcons = {}
  self.mSelecetdIcons = {}
  self.mTabIndex = 0
end

function M:initUI()
  local bg = display.newSprite("equipment/bg.jpg"):addTo(self.mNode)
  self.mBg = bg
  display.newSprite(M_filePath("title_knapsack_0"), 375.5, 587):addTo(self.mBg, 1)
  self.mPanelUpgrade = PanelUpgrade.new({
    data = self.mEquipData
  })
  self.mPanelUpgrade:pos(685, 0)
  self.mPanelUpgrade:addTo(bg)
  self.mPanelUpgrade:addEventListener(EMgr.EVENT_SELECT_ONEKEY, handler(self, self.onEventSelectOnekey))
  self.mPanelUpgrade:addEventListener(EMgr.EVENT_EQUIP_UPGRADE, handler(self, self.onEventEquipUpgrade))
  self:loadListView()
  self:loadFilterTab()
end

function M:loadListView()
  local frame = display.newScale9Sprite(M_filePath("img_00"), 380, 320, cc.size(589, 534), cc.rect(90, 320, 1, 1)):addTo(self.mBg)
  self.mFrame = frame
  local equipmentList = self.mEquipmentList
  local countNum = #equipmentList
  if countNum > EMgr.PACKAGE_LIMIT_NUM then
    countNum = EMgr.PACKAGE_LIMIT_NUM
  end
  if 0 == countNum then
    return
  end
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(20, 55, 540, 430),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(frame)
  
  local function addListItem(self, idx, endNum)
    local item = listView:newItem()
    local content = display.newNode()
    item:addContent(content)
    content:setContentSize(540, 128)
    for count = 1, endNum do
      local n = (idx - 1) * 4 + count
      local model = equipmentList[n]
      if model then
        local icon = IconPackage.new(model)
        icon:setPosition(270 * (0.5 * count - 0.25), 64)
        content:addChild(icon)
        table.insert(self.mEquipIcons, icon)
      end
    end
    item:setItemSize(540, 128)
    listView:addItem(item)
  end
  
  local row = math.ceil(countNum / 4)
  local column = countNum % 4
  local endNum = 4
  local limitRow = 4 < row and 4 or row
  for i = 1, limitRow do
    if i == row and column ~= 0 then
      endNum = column
    end
    addListItem(self, i, endNum)
  end
  listView:reload()
  if row <= 4 then
    return
  end
  
  local function tFuncDelay()
    for i = limitRow + 1, row do
      if i == row and column ~= 0 then
        endNum = column
      end
      addListItem(self, i, endNum)
    end
    listView:reload()
  end
  
  self:performWithDelay(tFuncDelay, 0.5)
end

function M:loadFilterTab()
  local gradeText = {
    "\232\147\157\232\137\178\229\143\138\228\187\165\228\184\139",
    "\231\180\171\232\137\178\229\143\138\228\187\165\228\184\139",
    "\230\169\153\232\137\178\229\143\138\228\187\165\228\184\139"
  }
  for i = 1, #gradeText do
    local button = cc.ui.UIPushButton.new({
      normal = M_filePath("img_03")
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = gradeText[i],
      size = 18,
      color = cc.c3b(54, 34, 6),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    })):setButtonLabelOffset(22, 0):onButtonClicked(function(event)
      self:onEventTabChoose(event.target, i)
    end):align(display.CENTER, 205 + 145 * (i - 1), 28):addTo(self.mBg, 2)
  end
  self.mTip = display.newSprite(M_filePath("icon_choice"), 205, 28):hide():addTo(self.mBg, 3)
end

function M:onEventTabChoose(button, index)
  if index == self.mTabIndex then
    self.mTabIndex = 0
    self.mTip:hide()
    return
  end
  self.mTip:show()
  self.mTip:setPosition(button:getPosition())
  self.mTabIndex = index
end

function M:onEventSelectOnekey(param)
  local count, sumExp = 0, 0
  for i = 1, #self.mEquipIcons do
    local icon = self.mEquipIcons[i]
    local status = icon:getStatus()
    local data = icon:getEquipmentData()
    if 0 == status and data.quality <= LIMIT_QUA[self.mTabIndex] then
      count = count + 1
      sumExp = sumExp + data.ironValue
      icon:setMaskVisible(true)
      table.insert(self.mSelecetdIcons, icon)
    end
    if sumExp > param.data.countNum or count >= MAX_AUTO_NUM then
      break
    end
  end
  self.mPanelUpgrade:updateLabel(true, sumExp)
end

function M:onEventEquipUpgrade(param)
  local equipList = {}
  local idStr = ""
  for i = 1, #self.mSelecetdIcons do
    local icon = self.mSelecetdIcons[i]
    local data = icon:getEquipmentData()
    table.insert(equipList, data.ueid)
    if i == #self.mSelecetdIcons then
      idStr = idStr .. data.ueid
    else
      idStr = idStr .. data.ueid .. ";"
    end
  end
  if 0 == #equipList and 0 == param.data.ironNum then
    WSToast.new("\230\178\161\230\156\137\233\128\137\230\139\169\230\182\136\232\128\151\230\157\144\230\150\153\239\188\129"):addTo(self, 20)
    return
  end
  local currUeid = checkstring(self.mEquipData.ueid)
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(display.getRunningScene(), 50)
      return
    end
    self.mSelecetdIcons = {}
    self.mEquipIcons = {}
    for j = 1, #equipList do
      local ueid = checkstring(equipList[j])
      CloudData.EQUIPMENT_INFO[ueid] = nil
      EMgr.EQUIP_LIST[ueid] = nil
    end
    local level = jsonTable.data.level
    local leftExp = jsonTable.data.ironOverflow
    CloudData.ESSENCE = jsonTable.data.essenceLeft
    DataUtils.updateItemNum("10", jsonTable.data.ironLeft)
    CloudData.EQUIPMENT_INFO[currUeid].level = level
    EMgr.EQUIP_LIST[currUeid].level = level
    CloudData.EQUIPMENT_INFO[currUeid].ironOverflow = leftExp
    EMgr.EQUIP_LIST[currUeid].leftExp = leftExp
    self.mEquipmentList = self:getEquipmentList()
    self.mFrame:runAction(cc.RemoveSelf:create(true))
    self:loadListView()
    EMgr.updateIronLabel(CloudData.IRON)
    self:addSuccArmature()
    self.mPanelUpgrade:updateUI(level)
  end
  
  local params = {
    id = currUeid,
    ids = idStr,
    iron = param.data.ironNum
  }
  DYHttpMgr.equipmentUpgrade(tFuncListener, params)
end

function M:iconClicked(icon)
  local data = icon:getEquipmentData()
  if 2 == icon:getStatus() then
    self.mPanelUpgrade:updateLabel(false, data.ironValue)
    icon:setMaskVisible(false)
    table.removebyvalue(self.mSelecetdIcons, icon)
  else
    self.mPanelUpgrade:updateLabel(true, data.ironValue)
    icon:setMaskVisible(true)
    table.insert(self.mSelecetdIcons, icon)
  end
end

function M:checkValid(index)
  if index > #self.mEquipmentList then
    return
  end
  local icon = self.mEquipIcons[index]
  if self.mPanelUpgrade:isOnAction() then
    return
  end
  if self.mPanelUpgrade:isExpExcessed() and 0 == icon:getStatus() then
    return
  end
  self:iconClicked(icon)
end

function M:touchListener(event)
  if "clicked" == event.name then
    local column = math.ceil(event.point.x * 4 / 540)
    local index = 0
    if event.itemPos ~= nil then
      index = (event.itemPos - 1) * 4 + column
    end
    self:checkValid(index)
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:addSuccArmature()
  if self.mArmature then
    self.mArmature:getAnimation():playWithIndex(0)
    return
  end
  self.mArmature = ccs.Armature:create("qianghuachenggong")
  self.mArmature:setPosition(640, 360)
  self.mBg:addChild(self.mArmature, 10)
  self.mArmature:getAnimation():playWithIndex(0)
end

function M:closeCallback()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
  self:removeSelf()
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

local CLASS_NAME = "LayerResolve"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(params, callbcak)
  self.mCallback = callbcak
  self.mEquipData = EMgr.EQUIP_LIST[params.ueid]
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  local bg = display.newSprite("equipment/bg.jpg"):addTo(self.mNode)
  self.mBg = bg
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function M_filePath(name)
  return string.format("equipment/%s.png", name)
end

function M:initData()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    self.mItemIds, self.mItemNums = {}, {}
    for k, v in pairs(jsonTable.data.dropGain) do
      table.insert(self.mItemIds, k)
      table.insert(self.mItemNums, v)
    end
    self.mPeachCost = jsonTable.data.peach
    self:initUI()
  end
  
  DYHttpMgr.equipmentResolvePreview(tFuncListener, {
    id = tonumber(self.mEquipData.ueid)
  })
end

local function getItemContent(data, num)
  local content = display.newSprite(string.format("common_ui/frame%d.png", data.quality))
  local icon = display.newSprite(data.icon)
  icon:setPosition(content:getContentSize().width * 0.5, content:getContentSize().height * 0.5)
  icon:addTo(content)
  DYLabelTTF.new({
    text = data.name,
    size = 20,
    color = data.color,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(content:getContentSize().width * 0.5, -15):addTo(content)
  DYLabelTTF.new({
    text = "X" .. num,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "BOTTOM_RIGHT"
  }, {
    lineColor = cc.c3b(53, 35, 3)
  }):pos(content:getContentSize().width, 0):addTo(content)
  return content
end

function M:initUI()
  local frame = display.newSprite(M_filePath("bg_03"))
  frame:align(display.CENTER_BOTTOM, 640, 0)
  frame:addTo(self.mBg)
  for i = 1, #self.mItemIds do
    local id, num = self.mItemIds[i], self.mItemNums[i]
    local model = DataUtils.getItemModelWithColor(id)
    local content = getItemContent(model, num)
    content:pos(415 + 170 * (i - 1), 330)
    content:addTo(frame)
  end
  local btn1 = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_orange_n.png",
    pressed = "common_ui/btn_orange_p.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\229\174\140\231\190\142\229\136\134\232\167\163",
    size = 25,
    color = cc.c3b(236, 255, 25),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(75, 41, 3)
  })):setButtonLabel("pressed", DYLabelTTF.new({
    text = "\229\174\140\231\190\142\229\136\134\232\167\163",
    size = 23,
    color = cc.c3b(236, 255, 25),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(75, 41, 3)
  })):onButtonClicked(function()
    self:onButtonListener(1)
  end):align(display.CENTER, 500, 100):addTo(frame)
  local btn2 = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\229\136\134   \232\167\163",
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(65, 76, 15)
  })):setButtonLabel("pressed", DYLabelTTF.new({
    text = "\229\136\134   \232\167\163",
    size = 23,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(65, 76, 15)
  })):onButtonClicked(function()
    self:onButtonListener(0)
  end):align(display.CENTER, 840, 100):addTo(frame)
  local pic = display.newSprite("item_icon/pic_peach.png", 590, 100):scale(0.6):addTo(frame)
  self.mCostLabel = DYLabelTTF.new({
    text = self.mPeachCost,
    size = 24,
    color = cc.c3b(58, 38, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(610, 100):addTo(frame)
end

function M:onButtonListener(tag)
  if 1 == tag and CloudData.PEACH < self.mPeachCost then
    WSToast.new("\232\159\160\230\161\131\228\184\141\232\182\179\239\188\129"):addTo(self, 20)
    return
  end
  local ueid = self.mEquipData.ueid
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    for k, v in pairs(jsonTable.data.drop) do
      DataUtils.updateItemNum(k, v)
    end
    CloudData.EQUIPMENT_INFO[ueid] = jsonTable.data.equipment
    EMgr.EQUIP_LIST[ueid] = GameManager.generateEquipmentData(ueid, jsonTable.data.equipment)
    EMgr.updateIronLabel(CloudData.IRON)
    if self.mCallback then
      self.mCallback()
    end
    self:closeCallback()
  end
  
  DYHttpMgr.equipmentResolve(tFuncListener, {
    id = tonumber(ueid),
    usePeach = tag
  })
end

function M:closeCallback()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
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

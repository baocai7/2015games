local CLASS_NAME = "LayerCommon"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.TYPE_EQUIP_ON = 1
M.TYPE_UPSTAR_PROP = 2
M.TYPE_QUENCHING = 3

local function M_filePath(name)
  return string.format("equipment/%s.png", name)
end

function M:ctor(pType, params, callbcak)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mCallback = callbcak
  self.mType = pType or 1
  self.mParams = params
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local tFunc = {
    [1] = function()
      self:loadEquipOnUI()
    end,
    [2] = function()
      self:loadUpstarPropUI()
    end,
    [3] = function()
      self:loadQuenchingUI()
    end
  }
  tFunc[self.mType]()
end

local function getEquipmentIcon(data)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", data.quality))
  iconFrame:setScale(0.95)
  iconFrame.ueid = data.ueid
  display.newSprite("equipment/icon_back.png", 59, 59):addTo(iconFrame)
  local icon = display.newSprite(data.icon, 59, 59):addTo(iconFrame)
  DYLabelTTF.new({
    text = "Lv." .. data.level,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {}):pos(110, 15):addTo(iconFrame)
  display.newSprite(string.format("equipment/mark%d.png", data.grade), 110, 110):addTo(iconFrame, 1)
  local selectedFrame = display.newSprite("equipment/icon_selected.png", 59, 59):hide():addTo(iconFrame, -1)
  
  function iconFrame:setSelected(flag)
    selectedFrame:setVisible(flag)
  end
  
  return iconFrame
end

local function getEquipmentList(tag, buddhaId, spiritCost)
  local list = {}
  for k, v in pairs(EMgr.EQUIP_LIST) do
    if EMgr.checkEquipmentValid(v, tag, buddhaId, spiritCost) then
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

function M:loadEquipOnUI()
  local equipmentList = getEquipmentList(self.mParams.tag, self.mParams.buddhaId, self.mParams.spiritCost)
  self.mEquipIcons = {}
  self.mEquipmentDatas = equipmentList
  local bg = display.newSprite(M_filePath("img_knapsack_bombbox")):addTo(self.mNode)
  self.mBg = bg
  
  local function createButton(params)
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = params.text,
      size = 30,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(65, 76, 15)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = params.text,
      size = 28,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(65, 76, 15)
    })):onButtonClicked(function(event)
      params.callback()
    end):align(display.CENTER, params.x, params.y):addTo(bg)
  end
  
  createButton({
    text = "\229\143\150    \230\182\136",
    x = 150,
    y = 72,
    callback = handler(self, self.onEventEquipCancel)
  })
  createButton({
    text = "\231\161\174    \229\174\154",
    x = 402,
    y = 72,
    callback = handler(self, self.onEventEquipEnsure)
  })
  if 0 == #equipmentList then
    return
  end
  local listView = DYListView.new({
    viewRect = cc.rect(20, 125, 510, 530),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(bg)
  local totalNum = #equipmentList
  if totalNum > EMgr.PACKAGE_LIMIT_NUM then
    totalNum = EMgr.PACKAGE_LIMIT_NUM
  end
  local row = math.ceil(totalNum / 4)
  local column = totalNum % 4
  local endNum = 4
  for i = 1, row do
    local item = listView:newItem()
    local content = display.newNode()
    item:addContent(content)
    content:setContentSize(510, 132)
    item:setItemSize(510, 132)
    listView:addItem(item)
    for count = 1, endNum do
      local n = (i - 1) * 4 + count
      local model = equipmentList[n]
      if model then
        local icon = getEquipmentIcon(model)
        icon:setPosition(255 * (0.5 * count - 0.25), 66)
        content:addChild(icon)
        table.insert(self.mEquipIcons, icon)
      end
    end
  end
  listView:reload()
  self.mIsOnTouch, self.mTouchTime, self.mTouchParams = false, 0, nil
  self:schedule(function()
    self:onEventLongTouch()
  end, 0.2)
end

function M:onEventEquipEnsure()
  if not self.mCurrIcon then
    self:closeCallback()
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(display.getRunningScene(), 20)
      return
    end
    self.mCallback(self.mCurrIcon.ueid)
    self:closeCallback()
  end
  
  DYHttpMgr.equipmentOn(tFuncListener, {
    id = tonumber(self.mCurrIcon.ueid),
    buddhaId = tonumber(self.mParams.buddhaId)
  })
end

function M:onEventEquipCancel()
  self:closeCallback()
end

function M:iconSelected(icon)
  if self.mCurrIcon then
    self.mCurrIcon:setSelected(false)
  end
  icon:setSelected(true)
  self.mCurrIcon = icon
end

function M:touchListener(event)
  if "clicked" == event.name then
    local column = math.ceil(event.point.x * 4 / 510)
    local index = 0
    if event.itemPos ~= nil then
      index = (event.itemPos - 1) * 4 + column
    end
    if index > #self.mEquipIcons then
      return
    end
    if self.mTouchTime < 5 then
      self:iconSelected(self.mEquipIcons[index])
    else
      self:removeTip()
    end
    self.mIsOnTouch, self.mTouchTime, self.mTouchParams = false, 0, nil
  elseif "began" == event.name then
    local column = math.ceil(event.point.x * 4 / 510)
    local index = 0
    if event.itemPos ~= nil then
      index = (event.itemPos - 1) * 4 + column
    end
    if index > #self.mEquipIcons then
      return
    end
    local worldPoint = event.item:convertToWorldSpace(cc.p(event.point.x, event.point.y))
    self.mIsOnTouch, self.mTouchParams = true, {
      idx = index,
      x = worldPoint.x,
      y = worldPoint.y
    }
  elseif "moved" == event.name then
    self:removeTip()
    self.mIsOnTouch, self.mTouchTime, self.mTouchParams = false, 0, nil
  elseif "ended" == event.name then
  end
end

function M:onEventLongTouch()
  if not self.mIsOnTouch then
    return
  end
  self.mTouchTime = self.mTouchTime + 1
  if self.mTouchTime >= 5 and self.mTouchParams then
    self:showTip(self.mTouchParams.idx, self.mTouchParams.x, self.mTouchParams.y)
    self.mTouchParams = nil
  end
end

function M:showTip(index, x, y)
  if self.mTipLayer ~= nil then
    self.mTipLayer:removeSelf()
    self.mTipLayer = nil
  end
  local column = (index - 1) % 4 + 1
  local x = 120 * column - 60 + 250
  if 2 < column then
    x = 120 * column - 60 - 200
  end
  if 560 < y then
    y = 520
  end
  self.mTipLayer = display.newScale9Sprite("common_ui/common_tip.png", x, y, cc.size(425, 275), cc.rect(200, 100, 10, 10)):addTo(self.mBg, 2)
  local data = self.mEquipmentDatas[index]
  local name = DYLabelTTF.new({
    text = data.name,
    size = 30,
    color = cc.c3b(255, 147, 5),
    font = GameManager.FONTNAME_TTF
  }):pos(212, 245):addTo(self.mTipLayer)
  local x = 80
  for i = 1, data.star do
    display.newSprite(M_filePath("icon_stars_n"), x, 200):addTo(self.mTipLayer)
    x = x + 30
  end
  for i = 1, data.maxStar - data.star do
    display.newSprite(M_filePath("icon_stars_p"), x, 200):addTo(self.mTipLayer)
    x = x + 30
  end
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", data.quality), 130, 110):addTo(self.mTipLayer)
  display.newSprite("equipment/icon_back.png", 59, 59):addTo(iconFrame)
  display.newSprite(data.icon, 59, 59):addTo(iconFrame)
  local lb = DYLabelTTF.new({
    text = "\229\188\186\229\140\150\239\188\154" .. data.level,
    size = 24,
    color = cc.c3b(255, 250, 219),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width * 0.55, iconFrame:getPositionY() + 40):addTo(self.mTipLayer)
  local lbs = DYLabelTTF.new({
    text = "\233\153\144\229\136\182\239\188\154",
    size = 24,
    color = cc.c3b(255, 250, 219),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width * 0.55, iconFrame:getPositionY()):addTo(self.mTipLayer)
  local lbn = DYLabelTTF.new({
    text = data.spirit .. "\231\129\181",
    size = 24,
    color = cc.c3b(255, 250, 219),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(91, 64, 25)
  }):pos(lbs:getPositionX() + lbs:getContentSize().width, lbs:getPositionY()):addTo(self.mTipLayer)
  if 0 == data.spirit then
    lbn:setString("\230\151\160\233\153\144\229\136\182")
  end
  if 0 < data.uniqueId then
    local buddhaData = DataUtils.getBuddhaModelBaseInfo(data.uniqueId)
    lbn:setString(buddhaData.name)
  end
  local grades = {
    "\233\187\132",
    "\231\142\132",
    "\229\156\176",
    "\229\164\169",
    "\231\129\181"
  }
  local lbg = DYLabelTTF.new({
    text = "\232\175\132\228\187\183\239\188\154",
    size = 24,
    color = cc.c3b(255, 250, 219),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width * 0.55, iconFrame:getPositionY() - 40):addTo(self.mTipLayer)
  DYLabelTTF.new({
    text = grades[data.grade],
    size = 24,
    color = cc.c3b(255, 242, 224),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(91, 64, 25)
  }):pos(lbg:getPositionX() + lbg:getContentSize().width, lbg:getPositionY()):addTo(self.mTipLayer)
  display.newSprite(M_filePath("img_potential"), 100, 30):addTo(self.mTipLayer)
  DYLabelTTF.new({
    text = data.potential,
    size = 30,
    color = cc.c3b(255, 235, 18),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(26, 13, 1)
  }):pos(140, 30):addTo(self.mTipLayer)
end

function M:removeTip()
  if self.mTipLayer ~= nil then
    self.mTipLayer:removeSelf()
    self.mTipLayer = nil
  end
end

function M:loadUpstarPropUI()
  local bg = display.newSprite(M_filePath("popup_01"), -50, 0):addTo(self.mNode)
  local curData = self.mParams.curData
  local newData = self.mParams.newData
  if 0 == curData.id then
    DYLabelTTF.new({
      text = "\230\151\160\229\177\158\230\128\167",
      size = 24,
      color = cc.c3b(44, 21, 3),
      font = GameManager.FONTNAME_TTF
    }):pos(450, 245):addTo(bg)
  else
    local id, num = curData.id, curData.num
    if 10 < id and id < 21 then
      num = string.format("%d%%", num)
    end
    local textStr = "+" .. num .. EMgr.PROPERTIES[id]
    DYLabelTTF.new({
      text = textStr,
      size = 24,
      color = cc.c3b(44, 21, 3),
      font = GameManager.FONTNAME_TTF
    }):pos(450, 245):addTo(bg)
  end
  local id, num = newData.id, newData.num
  if 10 < id and id < 21 then
    num = string.format("%d%%", num)
  end
  local textStr = "+" .. num .. EMgr.PROPERTIES[id]
  DYLabelTTF.new({
    text = textStr,
    size = 24,
    color = cc.c3b(44, 21, 3),
    font = GameManager.FONTNAME_TTF
  }):pos(670, 245):addTo(bg)
  
  local function createButton(params)
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }):scale(0.8):setButtonLabel("normal", DYLabelTTF.new({
      text = params.text,
      size = 30,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(65, 76, 15)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = params.text,
      size = 28,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(65, 76, 15)
    })):onButtonClicked(function(event)
      params.callback()
    end):align(display.CENTER, params.x, params.y):addTo(bg)
  end
  
  createButton({
    text = "\229\143\150    \230\182\136",
    x = 480,
    y = 150,
    callback = handler(self, self.onEventUpstarCancel)
  })
  createButton({
    text = "\231\161\174    \229\174\154",
    x = 650,
    y = 150,
    callback = handler(self, self.onEventUpstarEnsure)
  })
end

function M:onEventUpstarEnsure()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(display.getRunningScene(), 20)
      return
    end
    self.mCallback()
    self:closeCallback()
  end
  
  DYHttpMgr.equipmentUpstarReplace(tFuncListener, {
    id = tonumber(self.mParams.ueid),
    star = tonumber(self.mParams.star)
  })
end

function M:onEventUpstarCancel()
  self:closeCallback()
end

function M:loadQuenchingUI()
  local bg = display.newSprite(M_filePath("popup_00"), -50, -50):addTo(self.mNode)
  local armature = ccs.Armature:create("tongyong_tx")
  armature:setPosition(565, 370)
  bg:addChild(armature, -1)
  armature:getAnimation():playWithIndex(0)
  local circle = display.newSprite(M_filePath("circle"), 565, 310):scale(0):addTo(bg, -2)
  circle:runAction(cc.ScaleTo:create(0.3, 1))
  self:performWithDelay(function()
    circle:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 50)))
  end, 0.3)
  local textStr = "\232\142\183\229\143\150\229\144\142\229\143\175\232\131\189\228\184\141\229\140\185\233\133\141\229\142\159\228\187\153\233\173\148\239\188\140\232\175\165\230\147\141\228\189\156\228\184\141\229\143\175\233\128\134\239\188\129"
  DYLabelTTF.new({
    text = textStr,
    size = 24,
    color = cc.c3b(57, 41, 24),
    font = GameManager.FONTNAME_TTF
  }):pos(568, 300):addTo(bg)
  DYLabelTTF.new({
    text = "\230\152\175\229\144\166\232\142\183\229\143\150\239\188\159",
    size = 30,
    color = cc.c3b(186, 106, 20),
    font = GameManager.FONTNAME_TTF
  }):pos(565, 240):addTo(bg)
  
  local function createButton(params)
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }):scale(0.8):setButtonLabel("normal", DYLabelTTF.new({
      text = params.text,
      size = 30,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(65, 76, 15)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = params.text,
      size = 28,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(65, 76, 15)
    })):onButtonClicked(function(event)
      params.callback()
    end):align(display.CENTER, params.x, params.y):addTo(bg)
  end
  
  createButton({
    text = "\229\143\150    \230\182\136",
    x = 480,
    y = 160,
    callback = handler(self, self.onEventQuenchingCancel)
  })
  createButton({
    text = "\231\161\174    \229\174\154",
    x = 650,
    y = 160,
    callback = handler(self, self.onEventQuenchingEnsure)
  })
end

function M:onEventQuenchingCancel()
  self.mCallback()
  self:closeCallback()
end

function M:onEventQuenchingEnsure()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    CloudData.EQUIPMENT_INFO[self.mParams.ueid] = jsonTable.data.equipment
    EMgr.EQUIP_LIST[self.mParams.ueid] = GameManager.generateEquipmentData(self.mParams.ueid, jsonTable.data.equipment)
    self.mCallback()
    self:closeCallback()
  end
  
  DYHttpMgr.equipmentQuenchingReplace(tFuncListener, {
    id = tonumber(self.mParams.ueid)
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

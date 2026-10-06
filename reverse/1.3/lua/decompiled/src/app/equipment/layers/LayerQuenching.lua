local LayerCommon = require("equipment.layers.LayerCommon")
local CLASS_NAME = "LayerQuenching"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(params, callback)
  self.mCallback = callback
  self.mData = EMgr.EQUIP_LIST[params.ueid]
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

function M:initData()
  self.mElementCardNums = {}
  for i = 2032, 2036 do
    local num = CloudData.GAME_ITEM_INFO[tostring(i)] or 0
    table.insert(self.mElementCardNums, num)
  end
  self.mQuenchingRuneNum = CloudData.GAME_ITEM_INFO[EMgr.QUENCHING_RUNE_ID] or 0
  self.mElementRuneNum = CloudData.GAME_ITEM_INFO[EMgr.ELEMENT_RUNE_ID] or 0
  self.mElementCards = {}
  self.mCurrIndex = 0
  self.mIsUseElementRune = false
  self.mIsOk = false
end

function M:initUI()
  local bg = display.newSprite("equipment/bg.jpg"):addTo(self.mNode)
  local frame = display.newSprite(M_filePath("bg_06"), 640, 307):addTo(bg)
  self.mFrame = frame
  local _width, _height = frame:getContentSize().width, frame:getContentSize().height
  local texts = {
    "\233\135\145",
    "\230\156\168",
    "\230\176\180",
    "\231\129\171",
    "\229\156\159"
  }
  for i = 1, 5 do
    display.newSprite(M_filePath("img_element" .. i), 270 + 100 * i, 612):scale(0.4):addTo(frame)
    DYLabelTTF.new({
      text = texts[i],
      size = 24,
      color = cc.c3b(70, 50, 40),
      font = GameManager.FONTNAME_TTF
    }):pos(310 + 100 * i, 612):addTo(frame)
  end
  local ccps = {
    cc.p(291, 572),
    cc.p(432, 481),
    cc.p(372, 326),
    cc.p(201, 327),
    cc.p(159, 479)
  }
  for i = 1, 5 do
    local card = self:createElementCard(i)
    card:setPosition(ccps[i])
    card:addTo(frame)
    table.insert(self.mElementCards, card)
  end
  local frame1 = display.newSprite(string.format("common_ui/frame%d.png", self.mData.quality), 291, 432):addTo(frame)
  display.newSprite("equipment/icon_back.png", 59, 59):addTo(frame1)
  display.newSprite(self.mData.icon, 59, 59):addTo(frame1)
  local pLayer
  frame1:setTouchEnabled(true)
  frame1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if "began" == name then
      if not pLayer then
        pLayer = self:getLayerTip(self.mData, 540, 432):addTo(frame, 20)
      end
      return true
    elseif "moved" == name then
      pLayer:show()
    elseif "ended" == name then
      pLayer:removeSelf()
      pLayer = nil
    end
  end)
  self:loadEquipment()
  self:loadQuenchingRune()
  self:loadElementRune()
  self.mButton = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("STR_QUENCH_TITLE", ""),
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(65, 76, 15)
  })):setButtonLabel("pressed", DYLabelTTF.new({
    text = DYLang.getString("STR_QUENCH_TITLE", ""),
    size = 28,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(65, 76, 15)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("STR_QUENCH_TITLE", ""),
    size = 30,
    color = cc.c3b(201, 201, 201),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(47, 47, 47)
  })):onButtonClicked(function()
    self:quenchingCallback()
  end):align(display.CENTER, 875, 80):addTo(frame)
  DYLabelTTF.new({
    text = DYLang.getString("STR_QUENCH_TIP", ""),
    size = 24,
    color = cc.c3b(128, 109, 90),
    font = GameManager.FONTNAME_TTF
  }):pos(565, 195):addTo(frame)
end

function M:loadEquipment()
  self.mEquipmentFrame = display.newSprite("common_ui/frame_battle.png", 892, 432):addTo(self.mFrame)
end

function M:createElementCard(index)
  local currNum, costNum = self.mElementCardNums[index], EMgr.ELEMENT_COST_NUM
  local card = display.newSprite(M_filePath("img_element" .. index), 0, 0, {
    class = cc.FilteredSpriteWithOne
  })
  card:setScale(0.75)
  local label1 = DYLabelTTF.new({
    text = currNum,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {}):pos(46, -20):addTo(card)
  DYLabelTTF.new({
    text = "/" .. costNum,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(48, -20):addTo(card)
  if currNum < costNum then
    label1:setColor(cc.c3b(255, 0, 0))
  end
  card.label = label1
  
  function card:setGray()
    self:setTouchEnabled(false)
    self:setFilter(filter.newFilter("GRAY"))
  end
  
  function card:setNormal()
    self:setTouchEnabled(true)
    self:setFilter(filter.newFilter("RGB"))
  end
  
  card:setTouchEnabled(true)
  card:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouchCard(event, index)
  end)
  return card
end

function M:loadQuenchingRune()
  local model = DataUtils.getItemModelWithColor(EMgr.QUENCHING_RUNE_ID)
  local frame2 = display.newSprite(string.format("common_ui/frame%d.png", model.quality), 628, 432):addTo(self.mFrame)
  local icon = display.newSprite(model.icon, 59, 59):addTo(frame2)
  DYLabelTTF.new({
    text = model.name,
    size = 24,
    color = model.color,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(59, -20):addTo(frame2)
  local label1 = DYLabelTTF.new({
    text = self.mQuenchingRuneNum,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(120, 15):addTo(frame2)
  DYLabelTTF.new({
    text = "/" .. EMgr.QUENCHING_RUNE_COST_NUM,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(label1:getPositionX() + label1:getContentSize().width + 2, 15):addTo(frame2)
  if self.mQuenchingRuneNum < EMgr.QUENCHING_RUNE_COST_NUM then
    label1:setColor(cc.c3b(255, 0, 0))
  end
  self.mQuenchingRuneLabel = label1
end

function M:loadElementRune()
  local model = DataUtils.getItemModelWithColor(EMgr.ELEMENT_RUNE_ID)
  local frame4 = display.newSprite(string.format("common_ui/frame%d.png", model.quality), 170, 80):addTo(self.mFrame)
  display.newSprite(model.icon, 59, 59):addTo(frame4)
  local label1 = DYLabelTTF.new({
    text = self.mElementRuneNum,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(125, 59):addTo(frame4)
  DYLabelTTF.new({
    text = "/" .. EMgr.ELEMENT_RUNE_COST_NUM,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(label1:getPositionX() + label1:getContentSize().width + 2, 59):addTo(frame4)
  if self.mElementRuneNum < EMgr.ELEMENT_RUNE_COST_NUM then
    label1:setColor(cc.c3b(255, 0, 0))
  end
  self.mElementRuneLabel = label1
  local button = cc.ui.UIPushButton.new({
    normal = M_filePath("img_03")
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\228\189\191\231\148\168\228\186\148\232\161\140\231\172\166",
    size = 24,
    color = cc.c3b(54, 34, 6),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  })):setButtonLabelOffset(22, 0):onButtonClicked(function(event)
    self.mIsUseElementRune = not self.mIsUseElementRune
    self.mMark:setVisible(self.mIsUseElementRune)
  end):align(display.CENTER, 500, 95):addTo(self.mFrame)
  DYLabelTTF.new({
    text = "(100%\231\187\167\230\137\191\228\186\148\232\161\140\229\142\159\231\159\179\231\154\132\229\177\158\230\128\167)",
    size = 24,
    color = cc.c3b(101, 81, 63),
    font = GameManager.FONTNAME_TTF
  }):pos(570, 63):addTo(self.mFrame)
  self.mMark = display.newSprite(M_filePath("icon_choice"), 500, 95):hide():addTo(self.mFrame, 2)
end

function M:getLayerTip(data, x, y)
  local pLayer = display.newScale9Sprite("common_ui/common_tip.png", x, y, cc.size(425, 275), cc.rect(200, 100, 10, 10))
  local name = DYLabelTTF.new({
    text = data.name,
    size = 30,
    color = cc.c3b(255, 147, 5),
    font = GameManager.FONTNAME_TTF
  }):pos(212, 245):addTo(pLayer)
  local x = 80
  for i = 1, data.star do
    display.newSprite(M_filePath("icon_stars_n"), x, 200):addTo(pLayer)
    x = x + 30
  end
  for i = 1, data.maxStar - data.star do
    display.newSprite(M_filePath("icon_stars_p"), x, 200):addTo(pLayer)
    x = x + 30
  end
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", data.quality), 130, 110):addTo(pLayer)
  display.newSprite("equipment/icon_back.png", 59, 59):addTo(iconFrame)
  display.newSprite(data.icon, 59, 59):addTo(iconFrame)
  local lb = DYLabelTTF.new({
    text = "\229\188\186\229\140\150\239\188\154" .. data.level,
    size = 24,
    color = cc.c3b(255, 250, 219),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width * 0.55, iconFrame:getPositionY() + 40):addTo(pLayer)
  local lbs = DYLabelTTF.new({
    text = "\233\153\144\229\136\182\239\188\154",
    size = 24,
    color = cc.c3b(255, 250, 219),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width * 0.55, iconFrame:getPositionY()):addTo(pLayer)
  local lbn = DYLabelTTF.new({
    text = data.spirit .. "\231\129\181",
    size = 24,
    color = cc.c3b(255, 250, 219),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(91, 64, 25)
  }):pos(lbs:getPositionX() + lbs:getContentSize().width, lbs:getPositionY()):addTo(pLayer)
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
  }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width * 0.55, iconFrame:getPositionY() - 40):addTo(pLayer)
  DYLabelTTF.new({
    text = grades[data.grade],
    size = 24,
    color = cc.c3b(255, 242, 224),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(91, 64, 25)
  }):pos(lbg:getPositionX() + lbg:getContentSize().width, lbg:getPositionY()):addTo(pLayer)
  display.newSprite(M_filePath("img_potential"), 100, 30):addTo(pLayer)
  DYLabelTTF.new({
    text = data.potential,
    size = 30,
    color = cc.c3b(255, 235, 18),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(26, 13, 1)
  }):pos(140, 30):addTo(pLayer)
  return pLayer
end

function M:onTouchCard(event, index)
  if "began" == event.name then
    if self.mCurrIndex == index then
      for i = 1, #self.mElementCards do
        local card = self.mElementCards[i]
        card:setNormal()
      end
      self.mCurrIndex = 0
      return true
    end
    for i = 1, #self.mElementCards do
      local card = self.mElementCards[i]
      if i == index then
        card:setNormal()
      else
        card:setGray()
      end
    end
    self.mCurrIndex = index
    return true
  end
end

function M:checkCostEnough()
  if self.mQuenchingRuneNum < EMgr.QUENCHING_RUNE_COST_NUM then
    return false
  end
  if self.mElementCardNums[self.mCurrIndex] < EMgr.ELEMENT_COST_NUM then
    return false
  end
  if self.mIsUseElementRune and self.mElementRuneNum < EMgr.ELEMENT_RUNE_COST_NUM then
    return false
  end
  return true
end

function M:quenchingCallback()
  if self.mCurrIndex == 0 then
    WSToast.new("\232\175\183\233\128\137\230\139\169\228\186\148\232\161\140\229\142\159\231\159\179\239\188\129"):addTo(self, 20)
    return
  end
  if not self:checkCostEnough() then
    WSToast.new("\230\183\172\231\129\181\230\157\144\230\150\153\228\184\141\232\182\179\239\188\129"):addTo(self, 20)
    return
  end
  self.mButton:setButtonEnabled(false)
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    self.mIsOk = true
    CloudData.EQUIPMENT_INFO[self.mData.ueid] = jsonTable.data.equipment
    EMgr.EQUIP_LIST[self.mData.ueid] = GameManager.generateEquipmentData(self.mData.ueid, jsonTable.data.equipment)
    local id = tostring(jsonTable.data.wuxingshiType)
    CloudData.GAME_ITEM_INFO[id] = jsonTable.data.wuxingshiLeft
    self.mElementCardNums[self.mCurrIndex] = jsonTable.data.wuxingshiLeft
    CloudData.GAME_ITEM_INFO[EMgr.QUENCHING_RUNE_ID] = jsonTable.data.yuanlingLeft
    self.mQuenchingRuneNum = CloudData.GAME_ITEM_INFO[EMgr.QUENCHING_RUNE_ID]
    CloudData.GAME_ITEM_INFO[EMgr.ELEMENT_RUNE_ID] = jsonTable.data.wuxingfuLeft
    self.mElementRuneNum = CloudData.GAME_ITEM_INFO[EMgr.ELEMENT_RUNE_ID]
    if 0 < jsonTable.data.quenchingId then
      LayerCommon.new(LayerCommon.TYPE_QUENCHING, {
        ueid = self.mData.ueid
      }, handler(self, self.onEventCallback)):addTo(self, 20)
    else
      self:updateUI()
      self:updateEquipment()
    end
  end
  
  local params = {
    id = tonumber(self.mData.ueid),
    element = self.mCurrIndex,
    useWuxingfu = self.mIsUseElementRune and 1 or 0
  }
  DYHttpMgr.equipmentQuenching(tFuncListener, params)
end

function M:updateUI()
  for i = 1, #self.mElementCards do
    local card = self.mElementCards[i]
    card:setGray()
    if i == self.mCurrIndex then
      local num = self.mElementCardNums[self.mCurrIndex]
      card.label:setString(num)
      if num < EMgr.ELEMENT_COST_NUM then
        card.label:setColor(cc.c3b(255, 0, 0))
      end
    end
  end
  self.mQuenchingRuneLabel:setString(self.mQuenchingRuneNum)
  if self.mQuenchingRuneNum < EMgr.QUENCHING_RUNE_COST_NUM then
    self.mQuenchingRuneLabel:setColor(cc.c3b(255, 0, 0))
  end
  self.mElementRuneLabel:setString(self.mElementRuneNum)
  if self.mElementRuneNum < EMgr.ELEMENT_RUNE_COST_NUM then
    self.mElementRuneLabel:setColor(cc.c3b(255, 0, 0))
  end
end

function M:updateEquipment()
  local function onComplete()
    local equipmentData = EMgr.EQUIP_LIST[self.mData.ueid]
    
    self.mEquipmentFrame:setTexture(string.format("common_ui/frame%d.png", equipmentData.quality))
    display.newSprite("equipment/icon_back.png", 59, 59):addTo(self.mEquipmentFrame)
    display.newSprite(equipmentData.icon, 59, 59):addTo(self.mEquipmentFrame)
    DYLabelTTF.new({
      text = equipmentData.name,
      size = 24,
      color = cc.c3b(70, 43, 11),
      font = GameManager.FONTNAME_TTF
    }):pos(59, -25):addTo(self.mEquipmentFrame)
    local pLayer
    self.mEquipmentFrame:setTouchEnabled(true)
    self.mEquipmentFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
      if "began" == name then
        if not pLayer then
          pLayer = self:getLayerTip(equipmentData, 740, 432):addTo(self.mFrame, 20)
        end
        return true
      elseif "moved" == name then
        pLayer:show()
      elseif "ended" == name then
        pLayer:removeSelf()
        pLayer = nil
      end
    end)
    self:addSuccArmature()
  end
  
  local frames = display.newFrames("ptcuilingtx%d.png", 1, 32)
  local animation = display.newAnimation(frames, 0.041666666666666664)
  local emptyPic = display.newSprite()
  emptyPic:setPosition(59, 59)
  emptyPic:setScale(2.5)
  emptyPic:addTo(self.mEquipmentFrame)
  emptyPic:playAnimationOnce(animation, true, onComplete)
end

function M:onEventCallback(param)
  self:updateUI()
  self:updateEquipment()
end

function M:addSuccArmature()
  local armature = ccs.Armature:create("qianghuachenggong")
  armature:setPosition(505, 360)
  self.mFrame:addChild(armature)
  armature:getAnimation():playWithIndex(1)
end

function M:closeCallback()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback({
      isOk = self.mIsOk
    })
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

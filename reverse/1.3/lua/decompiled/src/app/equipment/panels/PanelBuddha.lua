local IconBuddha = require("equipment.icons.IconBuddha")
local IconEquipment = require("equipment.icons.IconEquipment")
local LayerCommon = require("equipment.layers.LayerCommon")
local DYClass = "PanelBuddha"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)

function M:ctor(params, callback)
  cc(self):addComponent("framework.cc.components.behavior.EventProtocol"):exportMethods()
  self:setContentSize(650, 642)
  self.mBuddhaList = params.buddhaList
  self.mFileInfo = {}
  self.mBuddhaIcons = {}
  self.mIsTouchEnabled = true
  self:loadUI()
end

local function M_filePath(name)
  return string.format("equipment/%s.png", name)
end

function M:getBaseData()
  local baseData = {
    self.mBuddhaData.life,
    self.mBuddhaData.attack,
    self.mBuddhaData.phyDefence,
    self.mBuddhaData.magDefence,
    self.mBuddhaData.attackDistance * self.mBuddhaData.sizeInBattle,
    self.mBuddhaData.attackFrequency,
    self.mBuddhaData.cdTime,
    self.mBuddhaData.runSpeed
  }
  return baseData
end

function M:getSecData()
  local secData = {
    self.mBuddhaData.critRate .. "%",
    self.mBuddhaData.critHarmRate .. "%",
    self.mBuddhaData.decritRate .. "%",
    self.mBuddhaData.decritHarmRate .. "%",
    self.mBuddhaData.hitRate .. "%",
    self.mBuddhaData.missRate .. "%",
    self.mBuddhaData.harmReduceRate .. "%",
    self.mBuddhaData.harmReduce
  }
  return secData
end

function M:getResData()
  local resData = {
    self.mBuddhaData.resStun .. "%",
    self.mBuddhaData.resStone .. "%",
    self.mBuddhaData.resPoison .. "%",
    self.mBuddhaData.resBack .. "%",
    self.mBuddhaData.resPalsy .. "%",
    self.mBuddhaData.resSilence .. "%"
  }
  return resData
end

function M:getElementData()
  local elementData = {
    self.mBuddhaData.propGold + self.mBuddhaData.propAllElements,
    self.mBuddhaData.propWood + self.mBuddhaData.propAllElements,
    self.mBuddhaData.propWater + self.mBuddhaData.propAllElements,
    self.mBuddhaData.propFire + self.mBuddhaData.propAllElements,
    self.mBuddhaData.propEarth + self.mBuddhaData.propAllElements
  }
  return elementData
end

function M:loadUI()
  self:loadListView()
  self:loadBuddhaInfo()
  self:loadFuncBtn()
  self:buddhaProperties()
end

function M:loadListView()
  local frame = display.newSprite(M_filePath("img_00"), 80, 343):addTo(self)
  self.mListView = DYListView.new({
    async = true,
    viewRect = cc.rect(15, 35, 120, 435),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(frame)
  
  local function tFuncDelegate(listView, tag, idx)
    if DYListView.COUNT_TAG == tag then
      return #self.mBuddhaList
    else
      if DYListView.CELL_TAG == tag then
        item = self.mListView:dequeueItem(idx)
        if not item then
          item = self.mListView:newItem()
          local content = IconBuddha.new(self.mBuddhaList[idx])
          content:setPosition(60, 60)
          content.index = idx
          item:addContent(content)
          item:setItemSize(120, 120)
          table.insert(self.mBuddhaIcons, content)
          if 1 == idx then
            content:setSelected(true)
            self.mCurrContent = content
          end
        end
        return item
      else
      end
    end
  end
  
  self.mListView:setDelegate(tFuncDelegate)
  self.mListView:reload()
end

function M:loadBuddhaInfo()
  self.mBuddhaData = self.mBuddhaList[self.mCurrContent.index]
  local bg = display.newSprite(M_filePath("img_bg"), 380, 350):addTo(self)
  self.mBuddhaName = DYLabelTTF.new({
    text = self.mBuddhaData.npcName,
    size = 24,
    color = cc.c3b(104, 58, 16),
    font = GameManager.FONTNAME_TTF
  }):pos(240, 420):addTo(bg)
  local frameCE = display.newSprite(M_filePath("img_combat_effectiveness"), 375, 605):addTo(self, 1)
  self.mCELabel = DYLabelTTF.new({
    text = self.mBuddhaData.attackAssessment,
    size = 24,
    color = cc.c3b(255, 235, 18),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(94, 22):addTo(frameCE)
  self:loadArmature(bg)
  self:loadEquipment(bg)
end

function M:loadFuncBtn()
  local function createButton(params)
    local btn = cc.ui.UIPushButton.new({
      normal = params.img,
      
      pressed = params.img
    }):onButtonPressed(function(event)
      event.target:setScale(0.9)
    end):onButtonRelease(function(event)
      event.target:setScale(1)
    end):onButtonClicked(function(event)
      params.callback()
    end)
    return btn
  end
  
  local btnDischarge = createButton({
    img = M_filePath("unload"),
    callback = handler(self, self.onEventEquipmentDown)
  })
  btnDischarge:align(display.CENTER, 280, 130)
  btnDischarge:addTo(self, 2)
  local btnReplace = createButton({
    img = M_filePath("replace"),
    callback = handler(self, self.onEventEquipmentReplace)
  })
  btnReplace:align(display.CENTER, 500, 130)
  btnReplace:addTo(self, 2)
end

function M:buddhaProperties()
  local detailsFrame = display.newSprite(M_filePath("img_frame")):addTo(self, 3)
  detailsFrame:align(display.CENTER_TOP, 383, 70)
  self.mElementTip = display.newSprite(M_filePath("element" .. self.mBuddhaData.element), 395, 608):addTo(detailsFrame)
  local isOpen = false
  
  local function tFuncCallback(self)
    if isOpen then
      detailsFrame:runAction(cc.MoveBy:create(0.2, cc.p(0, -550)))
    else
      detailsFrame:runAction(cc.MoveBy:create(0.2, cc.p(0, 550)))
    end
    self.mIsTouchEnabled = isOpen
    isOpen = not isOpen
  end
  
  local btn = cc.ui.UIPushButton.new({
    normal = M_filePath("btn_details_n"),
    pressed = M_filePath("btn_details_n")
  }):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function(event)
    tFuncCallback(self)
    
    local function tFuncDisable()
      event.target:setButtonEnabled(false)
    end
    
    local function tFuncEnable()
      event.target:setButtonEnabled(true)
    end
    
    event.target:runAction(cc.Sequence:create(cc.CallFunc:create(tFuncDisable), cc.DelayTime:create(0.5), cc.RotateBy:create(0.2, 180), cc.CallFunc:create(tFuncEnable)))
  end):align(display.CENTER, 201, 645):addTo(detailsFrame)
  btn:setRotation(180)
  
  local function createTip(name, posY)
    local frame = display.newSprite(M_filePath("img_reel_00")):addTo(detailsFrame)
    frame:align(display.CENTER_LEFT, 10, posY)
    local label = DYLabelTTF.new({
      text = name,
      size = 22,
      color = cc.c3b(240, 220, 200),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {
      lineColor = cc.c3b(46, 26, 1)
    }):pos(12, 17):addTo(frame)
  end
  
  local function createLabel(textList, dataList, maxY)
    local labelList = {}
    for i = 1, #dataList do
      local col = i % 2 == 0 and 1 or 0
      local row = math.ceil(i / 2) - 1
      local lb = DYLabelTTF.new({
        text = textList[i],
        size = 20,
        color = cc.c3b(58, 38, 13),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(15 + 182 * col, maxY - 28 * row):addTo(detailsFrame)
      local num = DYLabelTTF.new({
        text = dataList[i],
        size = 20,
        color = cc.c3b(58, 38, 13),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(lb:getPositionX() + lb:getContentSize().width, lb:getPositionY()):addTo(detailsFrame)
      table.insert(labelList, num)
    end
    return labelList
  end
  
  local textBase = {
    "\232\161\128\233\135\143:",
    "\230\148\187\229\135\187:",
    "\231\137\169\231\144\134\233\152\178\229\190\161:",
    "\233\173\148\230\179\149\233\152\178\229\190\161:",
    "\230\148\187\229\135\187\232\183\157\231\166\187:",
    "\230\148\187\229\135\187\233\128\159\229\186\166:",
    "\229\134\183\229\141\180\229\143\172\229\148\164:",
    "\231\167\187\229\138\168\233\128\159\229\186\166:"
  }
  local baseData = self:getBaseData()
  self.mLabelList1 = createLabel(textBase, baseData, 620)
  local textSec = {
    "\230\154\180\229\135\187:",
    "\230\154\180\229\135\187\228\188\164\229\174\179:",
    "\230\138\151\230\154\180\231\142\135:",
    "\230\154\180\228\188\164\229\135\143\229\133\141\231\142\135:",
    "\229\145\189\228\184\173:",
    "\233\151\170\233\129\191:",
    "\228\188\164\229\174\179\229\135\143\229\133\141\231\142\135:",
    "\228\188\164\229\174\179\229\135\143\229\133\141\229\128\188:"
  }
  local secData = self:getSecData()
  createTip("\230\172\161\231\186\167\229\177\158\230\128\167", 490)
  self.mLabelList2 = createLabel(textSec, secData, 455)
  local textRes = {
    "\231\156\169\230\153\149\230\138\151\230\128\167:",
    "\231\159\179\229\140\150\230\138\151\230\128\167:",
    "\228\184\173\230\175\146\230\138\151\230\128\167:",
    "\229\135\187\233\128\128\230\138\151\230\128\167:",
    "\233\186\187\231\151\185\230\138\151\230\128\167:",
    "\230\178\137\233\187\152\230\138\151\230\128\167:"
  }
  local resData = self:getResData()
  createTip("\230\138\151      \230\128\167", 320)
  self.mLabelList3 = createLabel(textRes, resData, 285)
  local textelement = {
    "\233\135\145\239\188\154",
    "\230\156\168\239\188\154",
    "\230\176\180\239\188\154",
    "\231\129\171\239\188\154",
    "\229\156\159\239\188\154"
  }
  local elementData = self:getElementData()
  createTip("\228\186\148\232\161\140\229\177\158\230\128\167", 180)
  self.mLabelList4 = createLabel(textelement, elementData, 145)
end

function M:changeBuddha(content, index)
  if self.mCurrContent.index == index then
    return
  end
  EMgr.CURR_EQUIPMENT = nil
  content:setSelected(true)
  self.mCurrContent:setSelected(false)
  self.mCurrContent = content
  self.mBuddhaData = self.mBuddhaList[self.mCurrContent.index]
  self.mBuddhaName:setString(self.mBuddhaData.npcName)
  self.mCELabel:setString(self.mBuddhaData.attackAssessment)
  self:updateArmature()
  self:updateProperties()
  self:updateEquipment()
end

function M:loadArmature(pNode)
  local armatureFile = self.mBuddhaData.armatureFile
  local pArmatureFile = string.format("armature/%s/%s.csb", armatureFile, armatureFile)
  DYRes.loadFileInfo(pArmatureFile, self.mFileInfo)
  self.mArmature = ccs.Armature:create(armatureFile)
  self.mArmature:setPosition(pNode:getContentSize().width * 0.5, pNode:getContentSize().height * 0.12 + self.mBuddhaData.upMove)
  self.mArmature:setScale(self.mBuddhaData.zoomMultiple)
  if 0 == self.mBuddhaData.isRebel then
    self.mArmature:setScaleX(-1 * self.mBuddhaData.zoomMultiple)
  end
  pNode:addChild(self.mArmature)
  self.mArmature:getAnimation():playWithIndex(1)
end

function M:loadEquipment(pNode)
  local pos = {
    cc.p(70, 320),
    cc.p(425, 320),
    cc.p(70, 140),
    cc.p(425, 140)
  }
  self.mEquipIcons = {}
  self.mCurrEquipIcon = nil
  for i = 1, 4 do
    local ueid = tostring(self.mBuddhaData.equipmentList[i])
    local eData = EMgr.EQUIP_LIST[ueid]
    local icon = IconEquipment.new(eData, i, self.mBuddhaData.npcId, self.mBuddhaData.consume)
    icon:setPosition(pos[i])
    icon:addTo(pNode, 2)
    icon:addEventListener(EMgr.EVENT_EQUIP_ON, handler(self, self.onEventEquipmentOn))
    icon:addEventListener(EMgr.EVENT_EQUIP_CLICKED, handler(self, self.onEventEquipmentClicked))
    table.insert(self.mEquipIcons, icon)
    if i == 1 then
      if eData then
        icon:setSelected(true)
        EMgr.INIT_EQUIPMENT = icon.mData.ueid
      else
        EMgr.INIT_EQUIPMENT = nil
        self:dispatchEvent({
          name = EMgr.EVENT_EQUIP_INFO
        })
      end
    end
  end
end

function M:updateArmature()
  local bg = self.mArmature:getParent()
  self.mArmature:removeSelf()
  self.mArmature = nil
  DYRes.unloadFileInfo(self.mFileInfo)
  self.mFileInfo = {}
  self:loadArmature(bg)
end

function M:updateProperties()
  local function updateData(labelList, data)
    for i = 1, #labelList do
      labelList[i]:setString(data[i])
    end
  end
  
  local baseData = self:getBaseData()
  updateData(self.mLabelList1, baseData)
  local baseData = self:getSecData()
  updateData(self.mLabelList2, baseData)
  local baseData = self:getResData()
  updateData(self.mLabelList3, baseData)
  local baseData = self:getElementData()
  updateData(self.mLabelList4, baseData)
  self.mElementTip:setTexture(M_filePath("element" .. self.mBuddhaData.element))
end

function M:updateEquipment()
  local bg = self.mEquipIcons[1]:getParent()
  for i = 1, #self.mEquipIcons do
    local icon = self.mEquipIcons[i]
    icon:removeSelf()
  end
  self:loadEquipment(bg)
end

function M:updateBuddhaData()
  local buddhaData = DataUtils.getBuddhaModel(self.mBuddhaData.npcId)
  self.mBuddhaList[self.mCurrContent.index] = buddhaData
  self.mBuddhaData = buddhaData
  self:buddhaCEAction(self.mBuddhaData.attackAssessment)
  self:updateProperties()
end

function M:onEventEquipmentOn(params)
  local icon, tag = params.data.icon, params.data.tag
  
  local function tFuncListener(ueid)
    local rData = EMgr.EQUIP_LIST[ueid]
    CloudData.EQUIPMENT_INFO[ueid].buddhaId = self.mBuddhaData.npcId
    CloudData.NPC_INFO[self.mBuddhaData.npcId].equipments[tag] = ueid
    EMgr.setEquipmentOn(ueid, self.mBuddhaData.npcId)
    icon:equipmentOn(rData)
    self:updateBuddhaData()
    EMgr.CURR_EQUIPMENT = ueid
    self:updateBuddhaIconStatus()
    self:dispatchEvent({
      name = EMgr.EVENT_EQUIP_INFO,
      data = ueid
    })
    self:dispatchEvent({
      name = EMgr.EVENT_EQUIP_CHANGE
    })
  end
  
  LayerCommon.new(LayerCommon.TYPE_EQUIP_ON, {
    tag = tag,
    buddhaId = self.mBuddhaData.npcId,
    spiritCost = self.mBuddhaData.consume
  }, tFuncListener):addTo(display.getRunningScene(), 20)
end

function M:onEventEquipmentDown()
  if not self.mIsTouchEnabled then
    return
  end
  DDLOG(" ========= onEquipDown ")
  if not self.mCurrEquipIcon then
    WSToast.new("\229\189\147\229\137\141\233\131\168\228\189\141\230\178\161\230\156\137\232\163\133\229\164\135\239\188\129"):addTo(display.getRunningScene(), 20)
    return
  end
  local eData = self.mCurrEquipIcon.mData
  local tag, buddhaId = eData.tag, self.mBuddhaData.npcId
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(display.getRunningScene(), 50)
      return
    end
    CloudData.EQUIPMENT_INFO[eData.ueid].buddhaId = 0
    CloudData.NPC_INFO[self.mBuddhaData.npcId].equipments[tag] = 0
    EMgr.setEquipmentDown(eData.ueid)
    self.mCurrEquipIcon:equipmentDown()
    self.mCurrEquipIcon = nil
    EMgr.CURR_EQUIPMENT = nil
    self:updateBuddhaData()
    self:updateBuddhaIconStatus()
    self:dispatchEvent({
      name = EMgr.EVENT_EQUIP_INFO
    })
    self:dispatchEvent({
      name = EMgr.EVENT_EQUIP_CHANGE
    })
  end
  
  DYHttpMgr.equipmentDown(tFuncListener, {
    index = eData.tag,
    buddhaId = tonumber(buddhaId)
  })
end

function M:onEventEquipmentReplace()
  if not self.mIsTouchEnabled then
    return
  end
  DDLOG(" ========= onEventReplace ")
  if not self.mCurrEquipIcon then
    WSToast.new("\229\189\147\229\137\141\233\131\168\228\189\141\230\178\161\230\156\137\232\163\133\229\164\135\239\188\129"):addTo(display.getRunningScene(), 20)
    return
  end
  local eData = self.mCurrEquipIcon.mData
  local tag = eData.tag
  local curUeid = eData.ueid
  
  local function tFuncListener(ueid)
    local rData = EMgr.EQUIP_LIST[ueid]
    CloudData.EQUIPMENT_INFO[ueid].buddhaId = self.mBuddhaData.npcId
    CloudData.EQUIPMENT_INFO[curUeid].buddhaId = 0
    CloudData.NPC_INFO[self.mBuddhaData.npcId].equipments[tag] = tostring(ueid)
    EMgr.setEquipmentOn(ueid, self.mBuddhaData.npcId)
    EMgr.setEquipmentDown(curUeid)
    EMgr.CURR_EQUIPMENT = ueid
    self.mCurrEquipIcon:equipmentReplace(rData)
    self:updateBuddhaData()
    self:updateBuddhaIconStatus()
    self:dispatchEvent({
      name = EMgr.EVENT_EQUIP_INFO,
      data = ueid
    })
    self:dispatchEvent({
      name = EMgr.EVENT_EQUIP_CHANGE
    })
  end
  
  LayerCommon.new(LayerCommon.TYPE_EQUIP_ON, {
    tag = tag,
    buddhaId = self.mBuddhaData.npcId,
    spiritCost = self.mBuddhaData.consume
  }, tFuncListener):addTo(display.getRunningScene(), 20)
end

function M:onEventEquipmentClicked(params)
  DDLOG("======== onEventSelectEquipment")
  local icon = params.data.icon
  if self.mCurrEquipIcon then
    self.mCurrEquipIcon:setSelected(false)
    icon:setSelected(true)
  end
  self.mCurrEquipIcon = icon
  EMgr.CURR_EQUIPMENT = self.mCurrEquipIcon.mData.ueid
  self:dispatchEvent({
    name = EMgr.EVENT_EQUIP_INFO,
    data = EMgr.CURR_EQUIPMENT
  })
end

function M:updateBuddhaIconStatus()
  for i = 1, #self.mBuddhaIcons do
    local icon = self.mBuddhaIcons[i]
    local data = self.mBuddhaList[icon.index]
    if 1 == icon:checkIconStatus(data) then
      icon:setMarkVisible(true)
    else
      icon:setMarkVisible(false)
    end
  end
end

function M:onUpdateDataUpgrade(equipmentData)
  self:updateBuddhaData()
  self.mCurrEquipIcon:updateLevel(equipmentData.level)
  self:updateBuddhaIconStatus()
end

function M:onUpdateDataResolve(equipmentData)
  self:updateBuddhaData()
  self.mCurrEquipIcon:updateLevel(equipmentData.level)
  self:updateBuddhaIconStatus()
end

function M:onUpdateDataUpstar(equipmentData)
  self:updateBuddhaData()
end

function M:onUpdateDataQuenching(equipmentData)
  self:updateBuddhaData()
  if equipmentData.buddhaId == self.mBuddhaData.npcId then
    self.mCurrEquipIcon:updateIcon(equipmentData)
  else
    self.mCurrEquipIcon:equipmentDown()
    self.mCurrEquipIcon = nil
    EMgr.CURR_EQUIPMENT = nil
    self:updateBuddhaIconStatus()
    self:dispatchEvent({
      name = EMgr.EVENT_EQUIP_INFO
    })
  end
end

function M:buddhaCEAction(num)
  local currNum = tonumber(self.mCELabel:getString())
  if currNum == num then
    return
  end
  local ac = transition.sequence({
    cc.ScaleTo:create(0.15, 1.5),
    cc.ScaleTo:create(0.15, 1),
    DYRollnum:create(0.5, currNum, num)
  })
  self.mCELabel:runAction(ac)
end

function M:touchListener(event)
  if "clicked" == event.name then
    if not self.mIsTouchEnabled then
      return
    end
    local index = event.itemPos
    if index > #self.mBuddhaList then
      return
    end
    local content = event.item:getContent()
    self:changeBuddha(content, index)
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:panelShow(isAni)
  EMgr.CURR_EQUIPMENT = self.mCurrEquipIcon and self.mCurrEquipIcon.mData.ueid or nil
  self:show()
  self:dispatchEvent({
    name = EMgr.EVENT_EQUIP_INFO,
    data = EMgr.CURR_EQUIPMENT
  })
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

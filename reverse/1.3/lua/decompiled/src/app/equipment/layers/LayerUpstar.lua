local LayerCommon = require("equipment.layers.LayerCommon")
local CLASS_NAME = "LayerUpstar"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local M_POSITIONS = {
  cc.p(137, 291),
  cc.p(200, 365),
  cc.p(314, 392),
  cc.p(410, 338),
  cc.p(454, 262),
  cc.p(554, 302),
  cc.p(574, 415),
  cc.p(452, 470),
  cc.p(287, 228)
}
local COST_ITEMS = {2031, 2039}
local MAX_QUALITY = 6

function M:ctor(params, callbcak)
  self.mCallback = callbcak
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
  self.mStarList = {}
  self.mStarPics = {}
  self.mPropLabelList = {}
  self.mCostFrames = {}
  self.mCostLabels = {}
  self.mStarActiveLevel = {}
  self.mCostDatas = {}
  for i = 1, self.mData.maxStar do
    local data = DataUtils.getEquipmentUpstarCost(i)
    table.insert(self.mStarActiveLevel, data.level)
    table.insert(self.mCostDatas, data.costNums)
  end
  self.mCurrPropLabel = nil
  self.mClickStar = 0
end

function M:initUI()
  local bg = display.newSprite("equipment/bg.jpg"):addTo(self.mNode)
  self.mBg = bg
  self:loadStarBoard()
  self:loadEquipmentInfo()
  self:setInitStar()
end

function M:loadStarBoard()
  local frame = display.newSprite(M_filePath("bg_05")):addTo(self.mBg)
  frame:align(display.BOTTOM_LEFT, 90, 0)
  for i = 1, self.mData.maxStar do
    local star = display.newSprite(M_filePath("icon_00"))
    star:setPosition(M_POSITIONS[i])
    star:addTo(frame, 1)
    if i <= self.mData.star then
      local quality = self.mData.starPropertyQuas[i]
      star:setTexture(M_filePath("icon_0" .. quality))
      if MAX_QUALITY == quality then
        self:addMaxStarAnimation(star)
      end
    end
    star:setTouchEnabled(true)
    star:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onTouch(event, i)
    end)
    table.insert(self.mStarList, star)
  end
  self.mSelectedFrame = display.newSprite(M_filePath("icon_p_00"), 0, 0):hide():addTo(frame)
  local label = DYLabelTTF.new({
    text = "\230\182\136\232\128\151\239\188\154",
    size = 24,
    color = cc.c3b(58, 38, 13),
    font = GameManager.FONTNAME_TTF
  }):pos(125, 60):addTo(frame)
  local posX = 195
  for i = 1, #COST_ITEMS do
    local model = DataUtils.getItemModel(COST_ITEMS[i])
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", model.quality), posX, 60):scale(0.5):addTo(frame)
    local icon = display.newSprite(model.itemIcon, 59, 59):addTo(iconFrame)
    local label = DYLabelTTF.new({
      text = "",
      size = 40,
      color = cc.c3b(58, 38, 13),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(125, 59):addTo(iconFrame)
    posX = posX + 135
    table.insert(self.mCostFrames, iconFrame)
    table.insert(self.mCostLabels, label)
  end
  self.mButton = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.8):setButtonLabel("normal", DYLabelTTF.new({
    text = "\231\134\148   \231\130\188",
    size = 30,
    color = cc.c3b(254, 239, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = "\231\134\148   \231\130\188",
    size = 30,
    color = cc.c3b(201, 201, 201),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(47, 47, 47)
  })):onButtonClicked(function()
    self:upstarCallback()
  end):align(display.CENTER, 500, 60):addTo(frame)
end

function M:loadEquipmentInfo()
  local frame = display.newSprite(M_filePath("img_reel")):addTo(self.mBg)
  frame:align(display.BOTTOM_LEFT, 635, 0.5)
  DYLabelTTF.new({
    text = self.mData.name,
    size = 30,
    color = cc.c3b(70, 43, 11),
    font = GameManager.FONTNAME_TTF
  }):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height - 36):addTo(frame)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mData.quality)):addTo(frame)
  iconFrame:setPosition(frame:getContentSize().width * 0.5, 500)
  display.newSprite("equipment/icon_back.png", 59, 59):addTo(iconFrame)
  local icon = display.newSprite(self.mData.icon, 59, 59):addTo(iconFrame)
  local levelFrame = display.newSprite("equipment/img_01.png", 113, 5):addTo(iconFrame)
  cc.ui.UILabel.new({
    text = self.mData.level,
    size = 18,
    color = cc.c3b(255, 255, 15),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, levelFrame:getContentSize().width * 0.5, levelFrame:getContentSize().height * 0.5):addTo(levelFrame)
  local pNode = display.newNode():addTo(frame)
  pNode:setContentSize(30 * self.mData.maxStar, 30)
  pNode:align(display.CENTER, frame:getContentSize().width * 0.5, 400)
  local x = 15
  for i = 1, self.mData.star do
    local pic = display.newSprite(M_filePath("icon_stars_n"), x, 15):addTo(pNode)
    x = x + 30
    table.insert(self.mStarPics, pic)
  end
  for j = 1, self.mData.maxStar - self.mData.star do
    local pic = display.newSprite(M_filePath("icon_stars_p"), x, 15):addTo(pNode)
    x = x + 30
    table.insert(self.mStarPics, pic)
  end
  local tip = display.newSprite(M_filePath("img_reel_00")):addTo(frame)
  tip:align(display.CENTER_LEFT, 93, 350)
  DYLabelTTF.new({
    text = "\231\134\148\231\130\188\229\177\158\230\128\167",
    size = 22,
    color = cc.c3b(240, 220, 200),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(46, 26, 1)
  }):pos(12, 17):addTo(tip)
  local posY = 310
  for i = 1, self.mData.maxStar do
    local id = self.mData.starPropertyIds[i]
    local num = self.mData.starPropertyNums[i]
    local label
    if id == nil then
      local textStr = string.format("\239\188\136\229\188\186\229\140\150\231\173\137\231\186\167\232\190\190%d\231\186\167\229\188\128\229\144\175\239\188\137", self.mStarActiveLevel[i])
      if self.mData.level >= self.mStarActiveLevel[i] then
        textStr = "\239\188\136\230\156\170\230\191\128\230\180\187\239\188\137"
      end
      label = DYLabelTTF.new({
        text = textStr,
        size = 24,
        color = cc.c3b(188, 171, 151),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(98, posY):addTo(frame)
      label.color = cc.c3b(188, 171, 151)
    else
      if 10 < id and id < 21 then
        num = string.format("%d%%", num)
      end
      local textStr = "+" .. num .. EMgr.PROPERTIES[id]
      label = DYLabelTTF.new({
        text = textStr,
        size = 24,
        color = cc.c3b(44, 21, 3),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(102, posY):addTo(frame)
      label.color = cc.c3b(44, 21, 3)
    end
    table.insert(self.mPropLabelList, label)
    posY = posY - 35
  end
end

function M:setInitStar()
  if self.mData.star == self.mData.maxStar then
    self:clickStar(self.mData.star)
    return
  end
  local nextStatus = self:getStarStatus(self.mData.star + 1)
  if nextStatus == 1 then
    self:clickStar(self.mData.star + 1)
    self:addUnlockAnimation(self.mStarList[self.mData.star + 1])
    return
  end
  if self.mData.star > 0 then
    self:clickStar(self.mData.star)
    return
  end
  self:performWithDelay(function()
    self:clickStar(1)
  end, 0)
end

function M:getStarStatus(index)
  if 0 == index then
    return 2
  end
  if self.mData.starPropertyIds[index] ~= nil then
    return 2
  end
  if self.mData.level >= self.mStarActiveLevel[index] then
    return 1
  end
  return 0
end

function M:clickStar(index)
  self.mClickStar = index
  self.mSelectedFrame:show()
  self.mSelectedFrame:setPosition(M_POSITIONS[index])
  local costData = self.mCostDatas[index]
  for i = 1, #self.mCostFrames do
    local frame, label = self.mCostFrames[i], self.mCostLabels[i]
    local costNum, countNum = costData[i], CloudData.GAME_ITEM_INFO[tostring(COST_ITEMS[i])] or 0
    label:setString(countNum .. "/" .. costNum)
    if costNum > countNum then
      label:setColor(cc.c3b(255, 0, 0))
    else
      label:setColor(cc.c3b(58, 38, 13))
    end
    if 0 == costNum then
      frame:setVisible(false)
    else
      frame:setVisible(true)
    end
  end
  if self.mCurrPropLabel then
    self.mCurrPropLabel:setColor(self.mCurrPropLabel.color)
  end
  self.mCurrPropLabel = self.mPropLabelList[index]
  self.mCurrPropLabel:setColor(cc.c3b(224, 105, 0))
  local status1, status2 = self:getStarStatus(index), self:getStarStatus(index - 1)
  if 0 == status1 then
    self.mButton:setButtonEnabled(false)
  elseif status2 ~= 2 then
    self.mButton:setButtonEnabled(false)
  else
    self.mButton:setButtonEnabled(true)
  end
end

function M:onTouch(event, index)
  if "began" == event.name then
    self:clickStar(index)
    return true
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:addMaxStarAnimation(node)
  local frames = display.newFrames("cendtx%d.png", 1, 30)
  local animation = display.newAnimation(frames, 0.041666666666666664)
  local emptyPic = display.newSprite()
  emptyPic:setPosition(28, 33)
  emptyPic:addTo(node)
  emptyPic:playAnimationForever(animation)
  node.animationNode = emptyPic
end

function M:addUnlockAnimation(node)
  if node.animationNode then
    return
  end
  local frames = display.newFrames("neidanjiestx%d.png", 1, 20)
  local animation = display.newAnimation(frames, 0.041666666666666664)
  local emptyPic = display.newSprite()
  emptyPic:setPosition(27, 31)
  emptyPic:addTo(node)
  emptyPic:playAnimationForever(animation)
  node.animationNode = emptyPic
end

function M:addUpstarAnimation(node, onComplete)
  local frames = display.newFrames("sxggtx%d.png", 1, 7)
  local animation = display.newAnimation(frames, 0.041666666666666664)
  local emptyPic = display.newSprite()
  emptyPic:setPosition(13.5, 13.5)
  emptyPic:addTo(node)
  emptyPic:playAnimationOnce(animation, true, onComplete)
end

function M:upstarCallback()
  local ueid = self.mData.ueid
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    local id = jsonTable.data.type
    local num = jsonTable.data.value
    local quality = jsonTable.data.quality
    self.mNewData = {
      id = id,
      num = num,
      quality = quality
    }
    CloudData.GAME_ITEM_INFO[tostring(COST_ITEMS[1])] = jsonTable.data.danLeft
    CloudData.GAME_ITEM_INFO[tostring(COST_ITEMS[2])] = jsonTable.data.mingshuifuLeft
    local costData = self.mCostDatas[self.mClickStar]
    for i = 1, #self.mCostLabels do
      local label = self.mCostLabels[i]
      local costNum, countNum = costData[i], CloudData.GAME_ITEM_INFO[tostring(COST_ITEMS[i])] or 0
      label:setString(countNum .. "/" .. costNum)
      if costNum > countNum then
        label:setColor(cc.c3b(255, 0, 0))
      else
        label:setColor(cc.c3b(58, 38, 13))
      end
    end
    local curPropId = self.mData.starPropertyIds[self.mClickStar] or 0
    local curPropNum = self.mData.starPropertyNums[self.mClickStar] or 0
    local params = {
      curData = {id = curPropId, num = curPropNum},
      newData = {id = id, num = num},
      ueid = ueid,
      star = self.mClickStar
    }
    LayerCommon.new(LayerCommon.TYPE_UPSTAR_PROP, params, handler(self, self.onEventReplaceProp)):addTo(self, 20)
  end
  
  DYHttpMgr.equipmentUpstar(tFuncListener, {
    id = tonumber(ueid),
    star = self.mClickStar
  })
end

function M:onEventReplaceProp()
  local ueid = self.mData.ueid
  local id, num, quality = self.mNewData.id, self.mNewData.num, self.mNewData.quality
  CloudData.EQUIPMENT_INFO[ueid].starProps[self.mClickStar] = {
    type = id,
    value = num,
    quality = quality
  }
  local curStar = self.mData.star
  local newStar = #CloudData.EQUIPMENT_INFO[ueid].starProps
  EMgr.EQUIP_LIST[ueid].star = newStar
  EMgr.EQUIP_LIST[ueid].starPropertyIds[self.mClickStar] = id
  EMgr.EQUIP_LIST[ueid].starPropertyNums[self.mClickStar] = num
  EMgr.EQUIP_LIST[ueid].starPropertyQuas[self.mClickStar] = quality
  self.mData = EMgr.EQUIP_LIST[ueid]
  if curStar < newStar then
    local currStarPic = self.mStarPics[newStar]
    self:addUpstarAnimation(currStarPic, function()
      currStarPic:setTexture(M_filePath("icon_stars_n"))
    end)
  end
  if newStar < self.mData.maxStar then
    local nextStatus = self:getStarStatus(newStar + 1)
    if nextStatus == 1 then
      self:addUnlockAnimation(self.mStarList[newStar + 1])
    end
  end
  local currStarIcon = self.mStarList[self.mClickStar]
  currStarIcon:setTexture(M_filePath("icon_0" .. quality))
  if currStarIcon.animationNode then
    currStarIcon.animationNode:removeSelf()
    currStarIcon.animationNode = nil
  end
  if MAX_QUALITY == quality then
    self:addMaxStarAnimation(currStarIcon)
  end
  if 10 < id and id < 21 then
    num = string.format("%d%%", num)
  end
  local textStr = "+" .. num .. EMgr.PROPERTIES[id]
  self.mPropLabelList[self.mClickStar]:setString(textStr)
  self.mPropLabelList[self.mClickStar].color = cc.c3b(44, 21, 3)
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

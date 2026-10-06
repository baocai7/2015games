local LayerRule = require("app.layers.LayerRule")
local DYClass = "PanelSynthesizeCimelia"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)
local S_DATA = {
  {
    id = 1,
    case = {
      1,
      3,
      4
    },
    itemId = 2011,
    name = "fire",
    icon = "cimelia/icon_fire.png",
    num = 0,
    cost = 0
  },
  {
    id = 2,
    case = {
      2,
      4,
      5
    },
    itemId = 2008,
    name = "gold",
    icon = "cimelia/icon_gold.png",
    num = 0,
    cost = 0
  },
  {
    id = 3,
    case = {
      3,
      5,
      1
    },
    itemId = 2009,
    name = "wood",
    icon = "cimelia/icon_wood.png",
    num = 0,
    cost = 0
  },
  {
    id = 4,
    case = {
      4,
      1,
      2
    },
    itemId = 2012,
    name = "earth",
    icon = "cimelia/icon_earth.png",
    num = 0,
    cost = 0
  },
  {
    id = 5,
    case = {
      5,
      2,
      3
    },
    itemId = 2010,
    name = "water",
    icon = "cimelia/icon_water.png",
    num = 0,
    cost = 0
  },
  stone = 0
}
local QUALITY_RATE = {
  [1] = {0.05, 0.25},
  [2] = {1, 2.52},
  [3] = {13.95, 30.14}
}
local RADIUS, ANGLE = 198, 72
local MAX_STONE = 10
local MAX_MATERIAL_NUM = 99
M.TAG_GZ = 1000
M.TAG_PF = 1001
M.TAG_REDUCE = 1002
M.TAG_PLUS = 1003
M.TAG_MAX = 1004
M.TAG_HC = 1005
M.TAG_HC10 = 1006

function M:ctor(handler_)
  DDLOG(DYClass .. ": onCreate")
  self.mCallback = handler_
  self.mCoreNode = display.newNode()
  self:addChild(self.mCoreNode)
  for i = 1, #S_DATA do
    local data = S_DATA[i]
    data.num = CloudData.GAME_ITEM_INFO[tostring(data.itemId)] or 0
  end
  S_DATA.stone = CloudData.GAME_ITEM_INFO["2007"] or 0
  self.mData = DYMem.get(DY_KEY.kSynthesizeCimeliaData, clone(S_DATA))
  DYMem.set(DY_KEY.kSynthesizeCimeliaData, self.mData)
  self.mItems = {}
  self.mPanels = {}
  self.mTouchEnabled = true
  self.mSprite = nil
  self.mUseStoneNum = 0
  QUALITY_RATE = self:calculateRate()
  self:layoutUI()
  self:setNodeEventEnabled(true)
end

function M:calculateRate()
  local weight, rateData = {}, {
    {},
    {},
    {}
  }
  for i = 6, 2, -1 do
    local data = DataUtils.getCimeliaQualityRate(i)
    table.insert(weight, data)
  end
  for i = 1, 3 do
    for j = 1, 11 do
      local sum = 0
      for n = 1, #weight do
        sum = sum + weight[n][j]
      end
      rateData[i][j] = weight[i][j] / sum * 100
    end
  end
  return rateData
end

function M:layoutUI()
  self.mBg = display.newSprite("cimelia/bg_compose.png"):addTo(self.mCoreNode)
  display.newSprite("cimelia/img_basemap_02.png", 605, 300):addTo(self.mBg)
  self:loadTopUI()
  self:loadLeftUI()
  self:loadRightUI()
end

function M:loadTopUI()
  local button = LayerRule.newRuleIcon(LayerRule.CIMELIA)
  button:setPosition(110, 600)
  button:addTo(self.mBg)
  button:setTag(M.TAG_GZ)
  local button = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  })
  button:onButtonClicked(handler(self, self.buttonListener))
  button:setButtonLabel("normal", DYLabelTTF.new({
    text = "     \233\133\141\230\150\185",
    size = 30,
    font = GameManager.FONTNAME_TTF,
    color = cc.c3b(255, 224, 4)
  }, {}))
  button:setPosition(490, 580)
  button:setScale(0.8)
  button:addTo(self.mBg)
  button:setTag(M.TAG_PF)
  display.newSprite("cimelia/recipe_pic1.png", -42, 3):addTo(button)
  local sp = display.newSprite("cimelia/stone.png", 305, 580):scale(0.8):addTo(self.mBg)
  self.mStoneLabel = DYLabelTTF.new({
    text = self.mData.stone,
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(sp:getContentSize().width * 0.55, sp:getContentSize().height * 0.5):addTo(sp)
end

function M:loadLeftUI()
  local frame = display.newSprite("cimelia/img_basemap_03.png", 325, 290):addTo(self.mBg)
  self.mFrame = frame
  self.mSelectdFrame = display.newSprite("cimelia/img_selected_00.png"):hide():addTo(frame, 4)
  for i = 1, #self.mData do
    local rad = math.rad(90 - ANGLE * (i - 1))
    local posX, posY = 265 + RADIUS * math.cos(rad), 248 + RADIUS * math.sin(rad)
    local item = self:createItemNode(i)
    item:setPosition(posX, posY)
    item:addTo(frame, 3)
    table.insert(self.mItems, item)
    local panel = self:createPanelNode(i)
    panel:setVisible(false)
    panel:setPosition(posX, posY)
    panel:addTo(frame, 3)
    table.insert(self.mPanels, panel)
  end
end

function M:loadRightUI()
  local cb = handler(self, self.buttonListener)
  local frame = display.newSprite("cimelia/img_basemap_01.png", 807, 422):addTo(self.mBg)
  local grid = display.newScale9Sprite("cimelia/icon_cost.png", 146, 146, cc.size(100, 100), cc.rect(20, 20, 1, 1)):addTo(frame)
  self.mImgText = DYLabelTTF.new({
    text = "\229\188\186\229\140\150\231\159\179",
    size = 18,
    color = cc.c3b(0, 255, 0),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(50, 50):addTo(grid)
  self.mStoneImg = display.newSprite("item_icon/icon_2007.png", 50, 50):hide():addTo(grid)
  self.mStoneImg.label = DYLabelTTF.new({
    text = "X0",
    size = 18,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {}):pos(100, 20):addTo(self.mStoneImg)
  
  local function createButton(img, pos, tag, listener)
    local button = cc.ui.UIPushButton.new(img)
    button:onButtonClicked(listener)
    button:setPosition(pos)
    button:setTag(tag)
    button:addTo(frame)
    return button
  end
  
  createButton({
    normal = "cimelia/btn_reduce_n.png",
    pressed = "cimelia/btn_reduce_p.png"
  }, cc.p(60, 146), M.TAG_REDUCE, cb)
  createButton({
    normal = "cimelia/btn_plus_n.png",
    pressed = "cimelia/btn_plus_p.png"
  }, cc.p(232, 146), M.TAG_PLUS, cb)
  createButton({
    normal = "cimelia/btn_max_n.png",
    pressed = "cimelia/btn_max_p.png"
  }, cc.p(316, 146), M.TAG_MAX, cb)
  self.mRateTextArr = {}
  local rateFrame = display.newSprite("cimelia/img_basemap_00.png", 807, 190):addTo(self.mBg)
  local textParam = {
    str = {
      "\231\186\162\232\137\178\239\188\154",
      "\230\169\153\232\137\178\239\188\154",
      "\231\180\171\232\137\178\239\188\154"
    },
    color = {
      cc.c3b(255, 31, 31),
      cc.c3b(255, 155, 12),
      cc.c3b(237, 31, 255)
    }
  }
  for i = 1, 3 do
    local lb = DYLabelTTF.new({
      text = textParam.str[i],
      size = 22,
      color = textParam.color[i],
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(55, rateFrame:getContentSize().height * (1.06 - 0.28 * i)):addTo(rateFrame)
    local rate = DYLabelTTF.new({
      text = string.format("%.2f%%", QUALITY_RATE[i][1]),
      size = 20,
      color = cc.c3b(13, 255, 47),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_RIGHT"
    }, {}):pos(205, lb:getPositionY()):addTo(rateFrame)
    table.insert(self.mRateTextArr, rate)
  end
  local button = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  })
  button:onButtonClicked(handler(self, self.buttonListener))
  button:setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1107", ""),
    size = 30,
    font = GameManager.FONTNAME_TTF,
    color = cc.c3b(255, 240, 0)
  }, {
    lineColor = cc.c3b(25, 30, 3)
  }))
  button:setPosition(735, 70)
  button:addTo(self.mBg)
  button:setTag(M.TAG_HC)
  self.mHCButton = button
  local button = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_orange_n.png",
    pressed = "common_ui/btn_orange_p.png"
  })
  button:onButtonClicked(handler(self, self.buttonListener))
  button:setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1108", ""),
    size = 30,
    font = GameManager.FONTNAME_TTF,
    color = cc.c3b(255, 240, 0)
  }, {
    lineColor = cc.c3b(25, 30, 3)
  }))
  button:setPosition(900, 70)
  button:addTo(self.mBg)
  button:setTag(M.TAG_HC10)
end

function M:createItemNode(index)
  local data = self.mData[index]
  local item = display.newSprite(data.icon)
  item:setTouchEnabled(true)
  item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if not self.mTouchEnabled then
      return
    end
    if "began" == event.name then
      self.mSelectdFrame:pos(item:getPosition())
      self.mSelectdFrame:show()
      return true
    elseif "ended" == event.name then
      self.mSelectdFrame:hide()
      self:onTouchIcon(index)
    end
  end)
  return item
end

function M:createPanelNode(index)
  local data = self.mData[index]
  local panel = display.newSprite("cimelia/img_bombbox_00.png")
  panel.numLabel = DYLabelTTF.new({
    text = data.num,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):pos(120, 108):addTo(panel)
  local label = DYLabelTTF.new({
    text = data.cost,
    size = 28,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):pos(95, 55):addTo(panel)
  local isOnTouch, touchTime, touchlistener = false, 0
  self:schedule(function()
    if not isOnTouch then
      return
    end
    touchTime = touchTime + 1
    if 25 <= touchTime then
      for i = 1, 4 do
        touchlistener()
      end
    elseif 10 <= touchTime then
      touchlistener()
    end
  end, 0.1)
  
  local function tFuncReduce()
    if data.cost <= 0 then
      return
    end
    data.cost = data.cost - 1
    panel:updateCost(data.cost)
  end
  
  local function tFuncPlus()
    if data.cost >= data.num or data.cost >= MAX_MATERIAL_NUM then
      return
    end
    data.cost = data.cost + 1
    panel:updateCost(data.cost)
  end
  
  local function createButton(img, pos, listener)
    local button = cc.ui.UIPushButton.new(img)
    button:onButtonPressed(function()
      isOnTouch, touchTime, touchlistener = true, 0, listener
    end)
    button:onButtonRelease(function()
      isOnTouch, touchTime, touchlistener = false, 0
    end)
    button:onButtonClicked(listener)
    button:setPosition(pos)
    button:addTo(panel)
    return button
  end
  
  createButton({
    normal = "cimelia/btn_arrow_n_2.png",
    pressed = "cimelia/btn_arrow_p_2.png"
  }, cc.p(42, 55), tFuncReduce)
  createButton({
    normal = "cimelia/btn_arrow_n.png",
    pressed = "cimelia/btn_arrow_p.png"
  }, cc.p(155, 55), tFuncPlus)
  
  function panel:updateCost(num)
    label:setString(num)
    if num > data.num then
      label:setColor(cc.c3b(255, 0, 0))
    else
      label:setColor(cc.c3b(255, 255, 255))
    end
  end
  
  return panel
end

function M:onTouchIcon(index, params)
  self.mTouchEnabled = false
  if self.mSprite then
    self:panelHide()
  end
  self.mMask = display.newSprite("cimelia/img_basemap_04.png", 265, 248):addTo(self.mFrame)
  self.mSprite = display.newSprite():addTo(self.mFrame, 1)
  self.mSprite:setPosition(267, 245)
  self.mSprite:setRotation(ANGLE * (index - 1))
  local frames = display.newFrames("fqlj%d.png", 1, 15)
  local animation = display.newAnimation(frames, 0.041666666666666664)
  self.mSprite:playAnimationOnce(animation, false, function()
    self.mTouchEnabled = true
    self.mMask:removeSelf()
    self:panelShow(self.mData[index].case, params)
  end)
end

function M:panelShow(case, params)
  local params = params or {}
  for i = 1, #params do
    local data = params[i]
    self.mData[data.index].cost = data.cost
  end
  for i = 1, #case do
    local idx = case[i]
    self.mItems[idx]:hide()
    local panel = self.mPanels[idx]
    panel:updateCost(self.mData[idx].cost)
    panel:show()
  end
end

function M:panelHide()
  for i = 1, #self.mItems do
    self.mItems[i]:show()
    self.mData[i].cost = 0
  end
  for i = 1, #self.mPanels do
    self.mPanels[i]:hide()
  end
  self.mSprite:removeSelf()
  self.mSprite = nil
end

function M:useRecipe(params)
  self:onTouchIcon(params.mainIndex, params)
end

function M:updateLabel()
  for i = 1, #self.mData do
    local data = self.mData[i]
    data.num = CloudData.GAME_ITEM_INFO[tostring(data.itemId)] or 0
  end
  self.mData.stone = CloudData.GAME_ITEM_INFO["2007"] or 0
  for i = 1, #self.mPanels do
    self.mPanels[i].numLabel:setString(self.mData[i].num)
    self.mPanels[i]:updateCost(self.mData[i].cost)
  end
  self.mStoneLabel:setString(self.mData.stone)
  self.mUseStoneNum = 0
  self:updateRateLabel()
  self.mStoneImg:hide()
  self.mImgText:show()
end

function M:updateRateLabel()
  for i = 1, #self.mRateTextArr do
    local text = self.mRateTextArr[i]
    local rate = QUALITY_RATE[i][self.mUseStoneNum + 1]
    text:setString(string.format("%.2f%%", rate))
  end
end

function M:buttonListener(param)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  local tag = param.target:getTag()
  local params = {}
  local tFunc = {
    [M.TAG_GZ] = function()
      self:onEventRule(tag)
    end,
    [M.TAG_PF] = function()
      self:onEventRecipe(tag)
    end,
    [M.TAG_REDUCE] = function()
      self:onEventReduce()
    end,
    [M.TAG_PLUS] = function()
      self:onEventPlus()
    end,
    [M.TAG_MAX] = function()
      self:onEventMax()
    end,
    [M.TAG_HC] = function()
      self:onEventCompose(tag)
    end,
    [M.TAG_HC10] = function()
      self:onEventCompose(tag)
    end
  }
  tFunc[tag]()
end

function M:onEventRule(tag)
  if self.mCallback then
    self.mCallback(tag)
  end
end

function M:onEventRecipe(tag)
  if self.mCallback then
    self.mCallback(tag)
  end
end

function M:onEventReduce()
  if self.mUseStoneNum <= 0 then
    return
  end
  self.mUseStoneNum = self.mUseStoneNum - 1
  self.mStoneImg.label:setString("X" .. self.mUseStoneNum)
  self:updateRateLabel()
  if 0 == self.mUseStoneNum then
    self.mStoneImg:hide()
    self.mImgText:show()
  end
end

function M:onEventPlus()
  if self.mUseStoneNum >= self.mData.stone or self.mUseStoneNum >= MAX_STONE then
    return
  end
  self.mUseStoneNum = self.mUseStoneNum + 1
  self.mStoneImg.label:setString("X" .. self.mUseStoneNum)
  self:updateRateLabel()
  if self.mUseStoneNum >= 1 then
    self.mStoneImg:show()
    self.mImgText:hide()
  end
end

function M:onEventMax()
  if self.mUseStoneNum >= self.mData.stone or self.mUseStoneNum >= MAX_STONE then
    return
  end
  self.mUseStoneNum = self.mData.stone > MAX_STONE and MAX_STONE or self.mData.stone
  self.mStoneImg.label:setString("X" .. self.mUseStoneNum)
  self:updateRateLabel()
  if self.mUseStoneNum >= 1 then
    self.mStoneImg:show()
    self.mImgText:hide()
  end
end

function M:onEventCompose(tag)
  local params = {}
  for i = 1, #self.mData do
    local data = self.mData[i]
    params[data.name] = data.cost
  end
  params.useStone = self.mUseStoneNum
  if self.mCallback then
    self.mCallback(tag, params)
  end
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:hide()
  end
  return true
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYMem.set(DY_KEY.kSynthesizeCimeliaData, nil)
end

return M

local DYClass = "LayerFateCard"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
M.TAG_USE = 101
M.TAG_LOOK = 102

function M:ctor(params, cb)
  DDLOG(DYClass .. ": onCreate")
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mTag = params.tag or M.TAG_LOOK
  self.mCallback = cb
  self.mCardIcons = {}
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function M_filePath(name)
  return string.format("flight_chess/%s.png", name)
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(830, 710), cc.rect(300, 140, 1, 1)):addTo(self.mNode)
  self.mBg = bg
  for i = 1, 6 do
    local data = CMgr.FATE_CARD[i]
    local posX = bg:getContentSize().width * 0.25 * i
    local posY = bg:getContentSize().height * 0.75
    if 3 < i then
      posX = bg:getContentSize().width * 0.25 * (i - 3)
      posY = bg:getContentSize().height * 0.37
    end
    local icon = display.newSprite(M_filePath(data.icon), posX, posY, {
      class = cc.FilteredSpriteWithOne
    }):addTo(bg, 2)
    icon.isEnabled = true
    icon.id = i
    local labelFrame = display.newSprite(M_filePath("img_number"), 6, 230):addTo(icon)
    DYLabelTTF.new({
      text = data.num,
      size = 30,
      color = cc.c3b(140, 40, 0),
      font = GameManager.FONTNAME_TTF
    }):pos(28, 28):addTo(labelFrame)
    if 0 == data.num then
      icon:setFilter(filter.newFilter("GRAY"))
      icon.isEnabled = false
    end
    table.insert(self.mCardIcons, icon)
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.95, bg:getContentSize().height * 0.95):onButtonClicked(function()
    self:closeCallBack(-1)
  end):addTo(bg, 1)
  if M.TAG_USE == self.mTag then
    self:loadUseUI()
  end
end

function M:loadUseUI()
  self.mBg:setTouchEnabled(true)
  self.mBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouch(event)
  end)
  self.mUseBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\228\189\191  \231\148\168",
    size = 30,
    color = cc.c3b(254, 239, 0),
    font = GameManager.FONTNAME_TTF
  }, {})):setButtonLabel("disabled", DYLabelTTF.new({
    text = "\228\189\191  \231\148\168",
    size = 30,
    color = cc.c3b(201, 201, 201),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(47, 47, 47)
  })):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.12):onButtonClicked(function()
    self:useCallback()
  end):addTo(self.mBg, 1)
  self.mSelectFrame = display.newSprite(M_filePath("img_chosen")):addTo(self.mBg)
  self:performWithDelay(function()
    self:onSelectedCard(self.mCardIcons[1])
  end, 0)
end

function M:onSelectedCard(card)
  self.mSelectFrame:setPosition(card:getPosition())
  if card.isEnabled then
    self.mUseBtn:setButtonEnabled(true)
  else
    self.mUseBtn:setButtonEnabled(false)
  end
  self.mUseId = card.id
end

function M:onTouch(event)
  if event.name == "began" then
    for i = 1, #self.mCardIcons do
      local icon = self.mCardIcons[i]
      local touchInSprite = cc.rectContainsPoint(icon:getCascadeBoundingBox(), cc.p(event.x, event.y))
      if touchInSprite then
        self:onSelectedCard(icon)
      end
    end
    return true
  end
end

function M:useCallback()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(CMgr.RUNNING_LAYER, 20)
      return
    end
    CMgr.FATE_CARD_COUNT = 0
    for k, v in pairs(jsonTable.data.fateCards) do
      CMgr.FATE_CARD[tonumber(k)].num = v
      CMgr.FATE_CARD_COUNT = CMgr.FATE_CARD_COUNT + v
    end
    self:closeCallBack(self.mUseId)
  end
  
  DYHttpMgr.useFateCard(tFuncListener, {
    id = self.mUseId
  })
end

function M:closeCallBack(param)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback({id = param})
  end
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack(-1)
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

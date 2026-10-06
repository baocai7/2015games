local DYClass = "LayerCollection"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M:ctor(params, cb)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mCallback = cb
  self.mIsBtnEnabled = true
  self:initData(params)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function M_filePath(name)
  return string.format("activity_collection/%s.png", name)
end

local function getRefreshStr(times, cost)
  local textStr = ""
  if 0 < times then
    textStr = string.format("\229\133\141\232\180\185\230\172\161\230\149\176: %d", times)
  else
    textStr = string.format("\232\159\160\230\161\131\232\138\177\232\180\185: %d", cost)
  end
  return textStr
end

function M:initData(params)
  local function tFuncListener(jsonTable)
    self.mExchangeTimes = jsonTable.data.leftExchangeTimes
    
    self.mFreeTimes = jsonTable.data.refreshFreeTimes
    self.mRefreshCost = jsonTable.data.refreshCost
    self.mRefreshTimes = jsonTable.data.leftRefreshTimes
    self.mData = jsonTable.data.exchangeList
    local textStr = getRefreshStr(self.mFreeTimes, self.mRefreshCost)
    self.mRefreshLabel:setString(textStr)
    self.mExchangeTimesLabel:setString("\229\137\169\228\189\153\229\133\145\230\141\162\230\172\161\230\149\176\239\188\154" .. self.mExchangeTimes)
    self.mRefreshTimesLabel:setString("\229\137\169\228\189\153\229\136\183\230\150\176\230\172\161\230\149\176\239\188\154" .. self.mRefreshTimes)
    if 0 == self.mRefreshTimes then
      self.mRefreshBtn:setButtonEnabled(false)
    end
    self:loadContent()
  end
  
  DYHttpMgr.collectionInit(tFuncListener)
end

function M:initUI()
  local bg = display.newSprite(M_filePath("bg")):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):scale(0.9):align(display.CENTER, bg:getContentSize().width * 0.94, bg:getContentSize().height * 0.87):addTo(bg)
  self.mRefreshBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\229\136\183  \230\150\176",
    size = 32,
    color = cc.c3b(254, 239, 0),
    font = GameManager.FONTNAME_TTF
  }, {})):setButtonLabel("pressed", DYLabelTTF.new({
    text = "\229\136\183  \230\150\176",
    size = 30,
    color = cc.c3b(254, 239, 0),
    font = GameManager.FONTNAME_TTF
  }, {})):setButtonLabel("disabled", DYLabelTTF.new({
    text = "\229\136\183  \230\150\176",
    size = 32,
    color = cc.c3b(201, 201, 201),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(47, 47, 47)
  })):onButtonClicked(function()
    self:refreshCallBack()
  end):scale(0.9):align(display.CENTER, bg:getContentSize().width * 0.5, 105):addTo(bg)
  self.mRefreshLabel = DYLabelTTF.new({
    text = "",
    size = 24,
    color = cc.c3b(38, 255, 2),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(270, 105):addTo(bg)
  self.mExchangeTimesLabel = DYLabelTTF.new({
    text = "",
    size = 22,
    color = cc.c3b(38, 255, 2),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(670, 540):addTo(bg)
  self.mRefreshTimesLabel = DYLabelTTF.new({
    text = "",
    size = 22,
    color = cc.c3b(38, 255, 2),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(115, 540):addTo(bg)
end

local function getItemContent(index, data, listener)
  local node = display.newSprite(M_filePath("img_bg"))
  local posX, posY = 50, 56
  local isEnabled = true
  
  local function setItemGray(item)
    isEnabled = false
    item:setTexture("common_ui/frame1.png")
    item.icon:setFilter(filter.newFilter("GRAY"))
  end
  
  local function checkSameId(list, id, from)
    local ret = 0
    for i = 1, from - 1 do
      if id == list[i] then
        ret = ret + 1
      end
    end
    return ret
  end
  
  local itemFrames = {}
  local consumes = split(data.items, ";")
  for i = 1, #consumes do
    local id = consumes[i]
    local model = DataUtils.getItemModel(id)
    local frame = display.newSprite("common_ui/frame5.png", posX, posY):scale(0.65):addTo(node)
    frame.id = id
    frame.icon = display.newSprite(model.itemIcon, nil, nil, {
      class = cc.FilteredSpriteWithOne
    }):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
    local num = checkSameId(consumes, id, i)
    if model.currNum - num <= 0 then
      setItemGray(frame)
    end
    table.insert(itemFrames, frame)
    if i < #consumes then
      display.newSprite(M_filePath("plus"), posX + 68, posY):addTo(node)
    else
      display.newSprite(M_filePath("etc"), posX + 75, posY):addTo(node)
    end
    posX = posX + 136
  end
  local thingIds = split(data.things, ";")
  local counts = split(data.counts, ";")
  for i = 1, #thingIds do
    local model = DataUtils.getItemModel(thingIds[i])
    local frame = display.newSprite(string.format("common_ui/frame%d.png", model.quality)):scale(0.65):pos(posX + 12, posY):addTo(node)
    display.newSprite(model.itemIcon):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
    DYLabelTTF.new({
      text = "x" .. counts[i],
      size = 24,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_RIGHT"
    }, {}):pos(frame:getContentSize().width - 5, 15):addTo(frame)
    posX = posX + 85
  end
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\229\133\145  \230\141\162",
    size = 32,
    color = cc.c3b(250, 255, 225),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(62, 73, 12)
  })):setButtonLabel("pressed", DYLabelTTF.new({
    text = "\229\133\145  \230\141\162",
    size = 30,
    color = cc.c3b(250, 255, 225),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(62, 73, 12)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = "\229\133\145  \230\141\162",
    size = 32,
    color = cc.c3b(201, 201, 201),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(47, 47, 47)
  })):onButtonClicked(function()
    listener({
      index = index,
      id = data.id
    })
  end):scale(0.8):align(display.CENTER, node:getContentSize().width * 0.9, node:getContentSize().height * 0.5):addTo(node)
  node:performWithDelay(function()
    btn:setButtonEnabled(isEnabled)
  end, 0)
  
  function node:updateItemStatus()
    for i = 1, #itemFrames do
      local frame = itemFrames[i]
      local currNum = tonumber(CloudData.GAME_ITEM_INFO[tostring(frame.id)]) or 0
      local num = checkSameId(consumes, frame.id, i)
      if currNum - num <= 0 then
        setItemGray(frame)
      end
    end
    btn:setButtonEnabled(isEnabled)
  end
  
  function node:setButtonEnabled(enabled)
    btn:setButtonEnabled(enabled)
  end
  
  return node
end

function M:loadContent()
  self.mContents = {}
  local posX, posY = 478, 460
  for i = 1, #self.mData do
    local content = getItemContent(i, self.mData[i], handler(self, self.onEventExchange))
    content:setPosition(posX, posY)
    content:addTo(self.mBg)
    table.insert(self.mContents, content)
    posY = posY - 120
  end
end

function M:onEventExchange(params)
  if not self.mIsBtnEnabled then
    return
  end
  self.mIsBtnEnabled = false
  
  local function tFuncListener(jsonTable)
    self.mIsBtnEnabled = true
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or ""
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    self.mExchangeTimes = jsonTable.data.leftExchangeTimes
    for k, v in pairs(jsonTable.data.drop) do
      DataUtils.updateItemNum(k, v)
    end
    for id, num in pairs(jsonTable.data.dropJizi) do
      DataUtils.updateItemNum(id, num)
    end
    for i = 1, #self.mContents do
      local content = self.mContents[i]
      content:updateItemStatus()
    end
    self.mExchangeTimesLabel:setString("\229\137\169\228\189\153\229\133\145\230\141\162\230\172\161\230\149\176\239\188\154" .. self.mExchangeTimes)
    WSToast.new("\229\133\145\230\141\162\230\136\144\229\138\159\239\188\129"):addTo(self, 20)
  end
  
  DYHttpMgr.collectionExchange(tFuncListener, {
    id = params.id
  })
end

function M:refreshCallBack()
  if not self.mIsBtnEnabled then
    return
  end
  self.mIsBtnEnabled = false
  
  local function tFuncListener(jsonTable)
    self.mIsBtnEnabled = true
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or ""
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    self.mFreeTimes = jsonTable.data.refreshFreeTimes
    self.mRefreshCost = jsonTable.data.refreshCost
    self.mRefreshTimes = jsonTable.data.leftRefreshTimes
    CloudData.PEACH = jsonTable.data.peachLeft
    self.mData = jsonTable.data.exchangeList
    for i = 1, #self.mContents do
      local content = self.mContents[i]
      content:removeAllChildrenWithCleanup(true)
      content:runAction(cc.RemoveSelf:create())
    end
    local textStr = getRefreshStr(self.mFreeTimes, self.mRefreshCost)
    self.mRefreshLabel:setString(textStr)
    self.mRefreshTimesLabel:setString("\229\137\169\228\189\153\229\136\183\230\150\176\230\172\161\230\149\176\239\188\154" .. self.mRefreshTimes)
    if 0 == self.mRefreshTimes then
      self.mRefreshBtn:setButtonEnabled(false)
    end
    self:loadContent()
  end
  
  DYHttpMgr.collectionRefresh(tFuncListener)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
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

local DYClass = "LayerRecord"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
local ITEM_W, ITEM_H = 846, 65

function M:ctor(params, cb)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mCallback = cb
  self:initUI()
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function getMsgContent(info)
  local function generateLabel(params)
    local label = DYLabelTTF.new({
      text = params.text,
      
      size = 22,
      color = params.color,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {})
    return label
  end
  
  local node = display.newNode()
  node:setContentSize(ITEM_W, ITEM_H)
  local label1 = generateLabel({
    text = info.nick,
    color = cc.c3b(4, 255, 22)
  })
  label1:setPosition(5, ITEM_H * 0.5)
  label1:addTo(node)
  local label2 = generateLabel({
    text = "\229\156\168\232\189\172\231\155\152\230\180\187\229\138\168\228\184\173\230\138\189\229\136\176\228\186\134",
    color = cc.c3b(255, 255, 255)
  })
  label2:setPosition(label1:getPositionX() + label1:getContentSize().width, label1:getPositionY())
  label2:addTo(node)
  local posX = label2:getPositionX() + label2:getContentSize().width
  local posY = label1:getPositionY()
  for i = 1, #info.things do
    local itemId, itemNum = info.things[i], info.counts[i]
    local itemModel = DataUtils.getItemModelWithColor(itemId)
    local itemName, nameColor = itemModel.name, itemModel.color
    local textStr = ""
    if 1 == info.type and 1 == tonumber(itemId) then
      textStr = "\229\165\150\230\177\160\229\164\167\229\165\150  "
      nameColor = cc.c3b(255, 20, 37)
    end
    if i == #info.things then
      textStr = textStr .. itemName .. "*" .. itemNum
    else
      textStr = textStr .. itemName .. "*" .. itemNum .. ","
    end
    local label = generateLabel({text = textStr, color = nameColor})
    label:setPosition(posX, posY)
    label:addTo(node)
    posX = posX + label:getContentSize().width
  end
  display.newSprite("spin/img_splitline.png", ITEM_W * 0.5, 0):addTo(node)
  return node
end

function M:initData()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode ~= 0 then
      local msg = jsonTable.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(msg, 2):addTo(self, 20)
      return
    end
    self.mData = jsonTable.data
    self:loadListView()
  end
  
  DYHttpMgr.awardLog(tFuncListener)
end

function M:initUI()
  local bg = display.newSprite("pvp/log_bg.png"):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\231\161\174  \229\174\154",
    size = 30,
    color = cc.c3b(250, 255, 225),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(62, 73, 12)
  })):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.12):addTo(bg)
  local frame = display.newScale9Sprite("spin/bg_00.png", 507, 350, cc.size(846, 448), cc.rect(50, 50, 1, 1)):addTo(bg)
  self.mFrame = frame
end

function M:loadListView()
  local msgCount = #self.mData
  if 0 == msgCount then
    return
  end
  local listView = DYListView.new({
    viewRect = cc.rect(0, 0, 846, 448),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mFrame)
  for i = msgCount, 1, -1 do
    local msgInfo = self.mData[i]
    local item = listView:newItem()
    local content = getMsgContent(msgInfo)
    item:addContent(content)
    item:setItemSize(ITEM_W, ITEM_H)
    listView:addItem(item)
  end
  listView:reload()
  if 7 < msgCount then
    local moveByParams = {
      x = 0,
      y = (msgCount - 7) * ITEM_H,
      time = 0.2
    }
    for k, v in pairs(listView.items_) do
      transition.moveBy(v, moveByParams)
    end
  end
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

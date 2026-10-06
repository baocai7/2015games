local LayerItem = require("app.layers.LayerItem")
local M = {}
M = class("IconActivity", function()
  return display.newNode()
end)

function M:ctor(params, callback)
  self.mCallback = callback
  self:initData(params)
end

local function getTitleFrame(textStr)
  local width = math.ceil(#textStr / 3) * 30 + 10
  local frame = display.newScale9Sprite("activity/text_frame.png", 0, 0, cc.size(width, 44), cc.rect(40, 20, 1, 1))
  return frame
end

local function getItemFrame(itemId, itemNum, isInner)
  local pModel = DataUtils.getItemModel(itemId)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", pModel.quality))
  local icon = display.newSprite(pModel.itemIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if itemNum then
    if 10000 <= itemNum then
      itemNum = string.format("%d\228\184\135", math.floor(itemNum / 10000))
    end
    if isInner then
      DYLabelTTF.new({
        text = "X" .. itemNum,
        size = 32,
        color = display.COLOR_WHITE,
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_RIGHT"
      }, {}):pos(iconFrame:getContentSize().width - 5, 20):addTo(iconFrame, 1)
    else
      DYLabelTTF.new({
        text = "X" .. itemNum,
        size = 32,
        color = display.COLOR_WHITE,
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }, {}):pos(iconFrame:getContentSize().width, 20):addTo(iconFrame, 1)
    end
  end
  local pLayer
  iconFrame:setTouchEnabled(true)
  iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      if not pLayer then
        pLayer = LayerItem.new(LayerItem.TYPE_TIP, itemId):pos(iconFrame:getPositionX(), iconFrame:getPositionY()):addTo(iconFrame:getParent(), 20)
        DYUtils.setGlobalZOrder(pLayer, 10)
      end
      return true
    elseif name == "moved" then
      pLayer:show()
    elseif name == "ended" then
      pLayer:removeSelf()
      pLayer = nil
    end
  end)
  return iconFrame
end

function M:initData(params)
  self.mIsActive = false
  self.mCanBeClicked = true
  self.mData = params
  self:loadUI(params.type)
end

function M:loadUI(pType)
  local tFunc = {
    [1] = function()
      self:initRechargeCell()
    end,
    [2] = function()
      self:initBuddhaCell()
    end,
    [3] = function()
      self:initLoginCell()
    end
  }
  tFunc[pType]()
end

function M:initRechargeCell()
  local bg = display.newScale9Sprite("#frame_cell.png", 0, 0, cc.size(645, 140)):addTo(self)
  local textStr = DYLang.getString("S1", "") .. self.mData.money .. DYLang.getString("S2", "")
  local titleFrame = getTitleFrame(textStr):align(display.TOP_LEFT, 0, bg:getContentSize().height):addTo(bg)
  cc.ui.UILabel.new({
    text = textStr,
    size = 25,
    color = cc.c3b(252, 255, 27),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 15, titleFrame:getContentSize().height * 0.5):addTo(titleFrame)
  local labelFrame = display.newSprite("activity/icon_frame.png"):align(display.CENTER_LEFT, 8, bg:getContentSize().height * 0.32):addTo(bg)
  for i = 1, #self.mData.things do
    local itemId = self.mData.things[i]
    local itemNum = self.mData.counts[i]
    local iconFrame = getItemFrame(itemId, itemNum):scale(0.55):align(display.CENTER_LEFT, labelFrame:getContentSize().width * (0.28 * i - 0.26), labelFrame:getContentSize().height * 0.5):addTo(labelFrame)
  end
  local vipLabel = display.newSprite("#label4.png"):pos(bg:getContentSize().width * 0.52, bg:getContentSize().height * 0.68):addTo(bg)
  DYLabelTTF.new({
    text = self.mData.vip,
    size = 20,
    color = cc.c3b(77, 255, 22),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(57, 15):addTo(vipLabel)
  for i = 1, #self.mData.extraThings do
    local itemId = self.mData.extraThings[i]
    local itemNum = self.mData.extraCounts[i]
    local iconFrame = getItemFrame(itemId, itemNum, true):scale(0.55):align(display.CENTER_LEFT, labelFrame:getContentSize().width * (0.18 * i + 0.47), labelFrame:getContentSize().height * 0.5):addTo(labelFrame)
  end
  local sp = display.newSprite("activity/label1.png"):pos(bg:getContentSize().width * 0.75, bg:getContentSize().height * 0.72):addTo(bg)
  local currNum = self.mData.currNum
  local totalNum = self.mData.money
  local str1 = currNum < 10000 and currNum or string.format("%d\228\184\135", math.floor(currNum / 10000))
  local str2 = totalNum < 10000 and totalNum or string.format("%s\228\184\135", tostring(totalNum / 10000))
  local textStr = str1 .. "/" .. str2
  local numLabel = DYLabelTTF.new({
    text = textStr,
    color = cc.c3b(77, 255, 22),
    size = 24,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):align(display.CENTER_LEFT, sp:getPositionX() + sp:getContentSize().width * 0.55, sp:getPositionY() - 5):addTo(bg)
  local loadTo = 0
  local btnText1 = DYLabelTTF.new({
    text = DYLang.getString("S3", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })
  local btnText2 = DYLabelTTF.new({
    text = DYLang.getString("S4", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })
  self.mBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.85):setButtonLabel("normal", btnText1):setButtonLabel("disabled", btnText2):align(display.CENTER, bg:getContentSize().width * 0.88, bg:getContentSize().height * 0.3):onButtonClicked(function()
    self:getAwardCallback(loadTo)
  end):addTo(bg)
  if 0 == self.mData.status and currNum >= totalNum then
    self.mIsActive = true
  elseif 1 == self.mData.status and currNum >= totalNum and CloudData.VIP_LEVEL >= self.mData.vip then
    self.mIsActive = true
  elseif 1 == self.mData.status and CloudData.VIP_LEVEL < self.mData.vip then
    btnText1:setString(DYLang.getString("S5", ""))
    loadTo = 1
  elseif self.mData.status < 2 and currNum < totalNum then
    btnText1:setString(DYLang.getString("S6", ""))
    loadTo = 1
  elseif 2 == self.mData.status then
    numLabel:setString(DYLang.getString("S7", ""))
    self:performWithDelay(function()
      self.mBtn:setButtonEnabled(false)
    end, 0)
  end
end

function M:initBuddhaCell()
  local pNode = display.newNode():addTo(self)
  pNode:setAnchorPoint(0.5, 0.5)
  pNode:setContentSize(290, 105)
  local lb1 = display.newSprite("#label2.png"):align(display.CENTER_LEFT, 5, pNode:getContentSize().height * 0.81):addTo(pNode)
  local text = DYLabelTTF.new({
    text = self.mData.money .. DYLang.getString("S2", ""),
    size = 22,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(lb1:getPositionX() + lb1:getContentSize().width, lb1:getPositionY()):addTo(pNode, 1)
  local lb2 = display.newSprite("#label3.png"):align(display.CENTER_LEFT, 5, pNode:getContentSize().height * 0.31):addTo(pNode)
  local iconFrame = getItemFrame(self.mData.thingId):scale(0.45):align(display.CENTER_LEFT, lb2:getPositionX() + lb2:getContentSize().width, lb2:getPositionY()):addTo(pNode)
  DYLabelTTF.new({
    text = "X" .. self.mData.count,
    size = 22,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width * 0.48, lb2:getPositionY()):addTo(pNode, 1)
  local loadTo = 0
  local currNum = self.mData.currNum
  local totalNum = self.mData.money
  local btnText1 = DYLabelTTF.new({
    text = DYLang.getString("S9", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })
  local btnText2 = DYLabelTTF.new({
    text = DYLang.getString("S4", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })
  self.mBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.85):setButtonLabel("normal", btnText1):setButtonLabel("disabled", btnText2):align(display.CENTER, pNode:getContentSize().width * 0.78, pNode:getContentSize().height * 0.5):onButtonClicked(function()
    self:getAwardCallback(loadTo)
  end):addTo(pNode)
  if 0 == self.mData.status and currNum >= totalNum then
    self.mIsActive = true
  elseif 0 < self.mData.status then
    self:performWithDelay(function()
      self.mBtn:setButtonEnabled(false)
    end, 0)
  elseif currNum < totalNum then
    btnText1:setString(DYLang.getString("S6", ""))
    loadTo = 1
  end
  display.newSprite("#line.png"):pos(pNode:getContentSize().width * 0.5, 1):addTo(pNode)
end

function M:initLoginCell()
  local bg = display.newScale9Sprite("#frame_cell.png", 0, 0, cc.size(645, 102)):addTo(self)
  local lb = display.newSprite("#label1.png"):align(display.CENTER_LEFT, 10, bg:getContentSize().height * 0.5):addTo(bg)
  DYLabelTTF.new({
    text = self.mData.days,
    size = 26,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(75, lb:getContentSize().height * 0.5):addTo(lb)
  for i = 1, #self.mData.things do
    local itemId = self.mData.things[i]
    local itemNum = self.mData.counts[i]
    local iconFrame = getItemFrame(itemId, itemNum, true):scale(0.6):align(display.CENTER_LEFT, bg:getContentSize().width * (0.16 * i + 0.1), bg:getContentSize().height * 0.5):addTo(bg)
  end
  local loadTo = 0
  local btnText1 = DYLabelTTF.new({
    text = DYLang.getString("S3", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })
  local btnText2 = DYLabelTTF.new({
    text = DYLang.getString("S4", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })
  self.mBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.85):setButtonLabel("normal", btnText1):setButtonLabel("disabled", btnText2):align(display.CENTER, bg:getContentSize().width * 0.88, bg:getContentSize().height * 0.5):onButtonClicked(function()
    self:getAwardCallback(loadTo)
  end):addTo(bg)
  local currNum = self.mData.currNum
  local totalNum = self.mData.days
  if 0 == self.mData.status and currNum >= totalNum then
    self.mIsActive = true
  elseif 0 < self.mData.status then
    self:performWithDelay(function()
      self.mBtn:setButtonEnabled(false)
    end, 0)
  elseif currNum < totalNum then
    btnText2:setString(DYLang.getString("S3", ""))
    self:performWithDelay(function()
      self.mBtn:setButtonEnabled(false)
    end, 0)
  end
end

function M:getAwardCallback(loadTo)
  if not self.mCanBeClicked then
    return
  end
  DDLOG("get award")
  self.mCanBeClicked = false
  self:performWithDelay(function()
    self.mCanBeClicked = true
  end, 1.5)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  local params = {
    taskId = self.mData.id,
    loadTo = loadTo,
    tar = self.mBtn
  }
  if self.mCallback then
    self.mCallback(params)
  end
end

return M

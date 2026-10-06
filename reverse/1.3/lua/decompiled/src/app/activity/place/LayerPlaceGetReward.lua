local IconItem = require("app.icons.IconItem")
local WSToast = require("app.utils.WSToast")
local DYClass = "LayerPlaceGetReward"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M:ctor()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      WSToast.new(jsonTable.errorMsg or "UNKOWN", 2):pos(display.cx, display.cy):addTo(display.getRunningScene(), 100)
      
      self:performWithDelay(function()
        self:removeFromParent()
      end, 1)
    else
      self:showSweep5Result(jsonTable.data.dropGain)
      for id, num in pairs(jsonTable.data.drop) do
        DataUtils.updateItemNum(id, num)
      end
      CloudData.ACTIVITY_NIAN = 0
    end
  end
  
  DYHttpMgr.requestPlaceActiveDraw(tFuncListener)
end

function M:showSweep5Result(info)
  dump(info)
  self.mSweepItemSize = 245
  self.mSweepListBorderX = 13
  self.mSweepListWidth = 506
  self.mSweepListHight = 425
  display.addSpriteFrames("animation/sweep.plist", "animation/sweep.png")
  self.mSweepIconTable = {}
  self.mSweepLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):pos(0, 10):addTo(self, 5)
  local tip = display.newScale9Sprite("common_ui/common_dialog.png", display.cx, display.cy, cc.size(598, 669), cc.rect(598, 125, 5, 5)):addTo(self.mSweepLayer)
  local textLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S44", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  textLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.12):addTo(tip):setButtonLabel("normal", textLabel):onButtonClicked(function()
    if self.mSweepLayer then
      self.mSweepLayer:stopAllActions()
      self.mSweepLayer:runAction(cc.RemoveSelf:create())
      self.mSweepLayer = nil
      self:removeSelf()
    end
  end)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(532, 454), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.53):addTo(tip)
  self.mScrollNode = cc.Node:create()
  self.mScrollNode:setContentSize(self.mSweepListWidth, self.mSweepListHight)
  local params = {
    viewRect = cc.rect(self.mSweepListBorderX, 15, self.mSweepListWidth, self.mSweepListHight)
  }
  local node = cc.ui.UIScrollView.new(params):addScrollNode(self.mScrollNode)
  local dir = cc.ui.UIScrollView.DIRECTION_VERTICAL
  node:setDirection(dir)
  node:setBounceable(true)
  frame:addChild(node)
  node:setTouchEnabled(false)
  for i = 1, #info do
    local goods = {}
    if info ~= nil and info[i] ~= nil then
      goods = info[i]
    end
    self:addSweepItem(goods, i, #info)
  end
  local distance = -self.mSweepListHight + 17
  for i = 1, #info do
    transition.moveBy(self.mSweepIconTable[i], {
      x = 0,
      y = distance,
      time = 0,
      easing = "sineOut",
      onComplete = function()
        if i == #info then
          self:showSweepItemMoveIn(1, #info)
        end
      end
    })
  end
end

function M:addSweepItem(goods, index, suum)
  local item = cc.Node:create()
  item:setContentSize(self.mSweepListWidth, self.mSweepItemSize)
  local h = self.mSweepListHight - self.mSweepItemSize * index
  item:setPosition(self.mSweepListBorderX, h)
  self.mScrollNode:addChild(item)
  self.mSweepIconTable[index] = item
  local content = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(self.mSweepListWidth, self.mSweepItemSize - 10), cc.rect(45, 45, 2, 2)):pos(item:getContentSize().width * 0.5, item:getContentSize().height * 0.5):addTo(item)
  local titlePng = display.newSprite("new_year/place/title.png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.87):addTo(content)
  DYLabelTTF.new({
    text = DYLang.getString("S45", "") .. index .. DYLang.getString("S46", ""),
    size = 26,
    color = cc.c3b(255, 201, 15),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(titlePng:getPositionX(), titlePng:getPositionY()):addTo(content)
  DYLabelTTF.new({
    text = DYLang.getString("S47", ""),
    size = 24,
    color = cc.c3b(109, 47, 4),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, content:getContentSize().width * 0.12, content:getContentSize().height * 0.75):addTo(content)
  DYLabelTTF.new({
    text = DYLang.getString("S48", ""),
    size = 24,
    color = cc.c3b(109, 47, 4),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, content:getContentSize().width * 0.12, content:getContentSize().height * 0.35):addTo(content)
  if goods == nil then
    return
  end
  local s = string.split(goods.hurtAward, "-")
  local frame = IconItem.new(tonumber(s[1]), tonumber(s[2]))
  frame:setPosition(content:getContentSize().width * 0.33, content:getContentSize().height * 0.55)
  frame:setScale(0.6)
  content:addChild(frame)
  frame:showItemTip()
  local sum = 1
  goods.drop = string.split(goods.rankAward, ";")
  for k, v in pairs(goods.drop) do
    local s = string.split(v, "-")
    local frame = IconItem.new(tonumber(s[1]), tonumber(s[2]))
    frame:setPosition(content:getContentSize().width * (0.18 * sum + 0.15), content:getContentSize().height * 0.2)
    frame:setScale(0.6)
    content:addChild(frame)
    frame:showItemTip()
    sum = sum + 1
  end
end

function M:showSweepItemMoveIn(index, suum)
  local dis = self.mSweepListHight + self.mSweepItemSize * (index - 1)
  local t = 0.7
  if suum == 1 and index == 1 then
    dis = self.mSweepListHight
    t = 0.4
  elseif index == suum then
    dis = self.mSweepItemSize * index
  elseif index == 1 then
    t = 0.4
  end
  transition.moveBy(self.mSweepIconTable[index], {
    x = 0,
    y = dis,
    time = t,
    easing = "sineOut",
    onComplete = function()
      self:showSweep5Ani(index, suum)
    end
  })
end

function M:showSweep5Ani(index, suum)
  if index == suum then
    return
  end
  local popupLayer = transition.sequence({
    cc.DelayTime:create(0.7),
    cc.CallFunc:create(function()
      self:showSweepItemMoveIn(index + 1, suum)
    end),
    cc.DelayTime:create(0.3),
    cc.CallFunc:create(function()
      self:showSweepItemMoveOut(index, suum)
    end)
  })
  self.mSweepLayer:runAction(popupLayer)
end

function M:showSweepItemMoveOut(index, suum)
  local dis = self.mSweepItemSize
  if index == suum - 1 then
    dis = 2 * self.mSweepItemSize - self.mSweepListHight
  end
  for i = 1, index do
    transition.moveBy(self.mSweepIconTable[i], {
      x = 0,
      y = dis,
      time = 0.4,
      easing = "sineOut",
      onComplete = function()
      end
    })
  end
end

return M

local IconItem = require("app.icons.IconItem")
local DYClass = "LayerGetAward"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M.scene(cb, info)
  local scene = display.newScene()
  scene:addChild(M.new(cb, param1, param2))
  return scene
end

function M:ctor(callback, info)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mInfo = info or {}
  self.mBg = nil
  self.mCanBeClicked = false
  self.mSweepItemSize = 245
  self.mSweepListBorderX = 13
  self.mSweepListWidth = 506
  self.mSweepListHight = 425
  self.mSweepIconTable = {}
  self.mCount = 4
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(598, 669), cc.rect(598, 125, 5, 5)):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.12):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S629", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3),
    lineWidth = 2
  })):addTo(bg):onButtonClicked(function()
    self:closeCallBack()
  end)
  self:addAwards(self.mInfo, self.mCount)
  self.mCanBeClicked = true
end

function M:addAwards(info, countTimes)
  local tip = self.mBg
  display.newSprite("stage/award.png"):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.92):addTo(tip)
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
  local idx = 1
  for i = 1, countTimes do
    local goods = {}
    if info ~= nil and info[tostring(i)] ~= nil then
      goods = info[tostring(i)]
      self:addListItem(goods, idx, i)
      idx = idx + 1
    end
  end
  local moveTimes = idx - 1
  local distance = -50 - self.mSweepItemSize * 4 - self.mSweepListHight
  for i = 1, moveTimes do
    transition.moveBy(self.mSweepIconTable[i], {
      x = 0,
      y = distance,
      time = 0,
      easing = "sineOut",
      onComplete = function()
        if i == moveTimes then
          self:showItemMoveIn(1, moveTimes)
        end
      end
    })
  end
end

function M:addListItem(goods, index, stateId)
  local item = cc.Node:create()
  item:setContentSize(self.mSweepListWidth, self.mSweepItemSize)
  item:setPosition(self.mSweepListBorderX, self.mSweepItemSize * (6 - index))
  self.mScrollNode:addChild(item)
  self.mSweepIconTable[index] = item
  local content = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(self.mSweepListWidth, self.mSweepItemSize - 10), cc.rect(45, 45, 2, 2)):pos(item:getContentSize().width * 0.5, item:getContentSize().height * 0.5):addTo(item)
  if goods == nil then
    return
  end
  local imgTitle = string.format("aggress/img_title_award_%02d.png", stateId)
  display.newSprite(imgTitle):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.87):addTo(content)
  local expBg = display.newSprite("stage/bg_num.png"):align(display.CENTER_LEFT, content:getContentSize().width * 0.2, content:getContentSize().height * 0.68):addTo(content)
  display.newSprite("item_icon/pic_exp.png"):align(display.CENTER, expBg:getContentSize().width * 0.03, expBg:getContentSize().height * 0.5):scale(0.6):addTo(expBg)
  local exp = goods.exp
  local expLabel = cc.ui.UILabel.new({
    text = exp,
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, expBg:getContentSize().width * 0.55, expBg:getContentSize().height * 0.5):addTo(expBg)
  local essenceBg = display.newSprite("stage/bg_num.png"):align(display.CENTER_LEFT, content:getContentSize().width * 0.56, content:getContentSize().height * 0.68):addTo(content)
  display.newSprite("item_icon/pic_essence.png"):align(display.CENTER, essenceBg:getContentSize().width * 0.05, essenceBg:getContentSize().height * 0.5):scale(0.7):addTo(essenceBg)
  local essence = goods.essence
  local essenceLabel = cc.ui.UILabel.new({
    text = essence,
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, essenceBg:getContentSize().width * 0.56, essenceBg:getContentSize().height * 0.5):addTo(essenceBg)
  DYAnalyze.item.get(4, "EXP", exp, "MAIN_STAGE_SWEEP5")
  DYAnalyze.item.get(2, "ESSENCE", essence, "MAIN_STAGE_SWEEP5")
  local sum = 1
  if goods.drop == nil then
    return
  end
  for id, num in pairs(goods.drop) do
    if 0 < checknumber(id) then
      local frame = IconItem.new(checknumber(id), checknumber(num))
      frame:setPosition(content:getContentSize().width * (0.235 * sum - 0.1), content:getContentSize().height * 0.32)
      frame:setScale(0.9)
      content:addChild(frame)
      frame:showItemTip()
      DYAnalyze.item.get(id, "", num, "AGGRESS_AWARD")
      sum = sum + 1
      if 4 < sum then
        break
      end
    end
  end
end

function M:showItemMoveIn(index, countTimes)
  local dis = self.mSweepListHight + self.mSweepItemSize * (index - 1)
  local t = 0.7
  if 1 == index then
    t = 0.4
  elseif index == countTimes then
    dis = self.mSweepItemSize * index
  end
  transition.moveBy(self.mSweepIconTable[index], {
    x = 0,
    y = dis,
    time = t,
    easing = "sineOut",
    onComplete = function()
      self:showAni(index, countTimes)
    end
  })
end

function M:showAni(index, countTimes)
  if index == countTimes then
    return
  end
  local popupLayer = transition.sequence({
    cc.DelayTime:create(0.7),
    cc.CallFunc:create(function()
      self:showItemMoveIn(index + 1, countTimes)
    end),
    cc.DelayTime:create(0.3),
    cc.CallFunc:create(function()
      self:showItemMoveOut(index, countTimes)
    end)
  })
  if self.mBg then
    self.mBg:runAction(popupLayer)
  end
end

function M:showItemMoveOut(index, countTimes)
  local dis = self.mSweepItemSize
  if index == countTimes - 1 then
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

function M:closeCallBack()
  self.mCanBeClicked = false
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
  if self.mCallback then
    self.mCallback()
  end
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

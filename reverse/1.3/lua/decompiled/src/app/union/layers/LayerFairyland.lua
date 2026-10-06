local CLASS_NAME = "LayerFairyland"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(params, callback)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCallback = callback
  display.addSpriteFrames("union/fairyland/union_tx1.plist", "union/fairyland/union_tx1.png")
  display.addSpriteFrames("union/fairyland/union_tx2.plist", "union/fairyland/union_tx2.png")
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initData(params)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData(params)
  local attackList = clone(CloudData.LAST_BATTLE_RESULT.attack_clan_rank_list)
  local isAttackSuccess = CloudData.LAST_BATTLE_RESULT.is_challenge_success
  if not isAttackSuccess then
    local v = CloudData.LAST_BATTLE_RESULT.last_defence_clan
    table.insert(attackList, 1, v)
  end
  self.mList = attackList
end

function M:initUI()
  local bg = display.newSprite("union/fairyland/bg1.png", display.cx, display.cy):addTo(self)
  self.mBg = bg
  self:loadScrollMap()
  cc.ui.UIPushButton.new({
    normal = "union/btn_back.png",
    pressed = "union/btn_back.png"
  }):align(display.CENTER_RIGHT, display.width - 30, display.height * 0.92):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self, 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1652", ""),
    size = 27,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):onButtonClicked(function()
    display.replaceScene(require("union.scenes.SceneUnion").new())
  end):align(display.CENTER_RIGHT, display.width - 30, display.height * 0.08):addTo(self, 2)
end

function M:loadScrollMap()
  local M_POS = {
    {x = 199, y = 348},
    {x = 461, y = 197},
    {x = 758, y = 339},
    {x = 1017, y = 150}
  }
  self.mBgNode = display.newNode()
  for i = 1, 3 do
    local bg = display.newSprite("union/fairyland/bg2.png", 1280 * (i - 1), 0)
    bg:setAnchorPoint(0, 0)
    self.mBgNode:addChild(bg)
    for j = 1, 4 do
      local id = (i - 1) * 4 + j
      local icon = id <= #self.mList and self.mList[id].level and self:getUnionIcon(id):align(display.CENTER_BOTTOM, M_POS[j].x, M_POS[j].y):addTo(bg)
    end
  end
  self.mBgSize = cc.size(3200, 720)
  self.mBgNode:setTouchEnabled(true)
  self.mBgNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouch(event.name, event.x, event.y)
  end)
  self:addChild(self.mBgNode, 1)
end

function M:getUnionIcon(id)
  local info = self.mList[id]
  local grade = 0
  if info.level < 5 then
    grade = 1
  elseif info.level < 9 then
    grade = 2
  else
    grade = 3
  end
  local icon = display.newSprite(string.format("union/fairyland/icon%d.png", grade))
  local pNode = display.newNode()
  local pServer = DYLabelTTF.new({
    text = string.format("[%s]", info.server_name),
    size = 24,
    color = cc.c3b(77, 207, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(0, 0):addTo(pNode)
  local pName = DYLabelTTF.new({
    text = info.clan_name,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(pServer:getContentSize().width + 3, 0):addTo(pNode)
  pNode:setAnchorPoint(0.5, 0.5)
  pNode:setContentSize(pServer:getContentSize().width + pName:getContentSize().width, pServer:getContentSize().height)
  pNode:setPosition(icon:getContentSize().width * 0.5, -10)
  pNode:addTo(icon)
  local p1 = display.newSprite("union/adorn2.png"):pos(icon:getContentSize().width * 0.25, 10):addTo(icon, 2)
  local p2 = display.newSprite("union/adorn2.png"):pos(icon:getContentSize().width * 0.75, p1:getPositionY()):addTo(icon)
  p2:setScaleX(-1)
  DYLabelTTF.new({
    text = "No." .. id,
    size = 26,
    color = cc.c3b(255, 219, 17),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(icon:getContentSize().width * 0.5, p1:getPositionY()):addTo(icon, 2)
  if 1 == id then
    local offsetX = {
      5,
      -5,
      12
    }
    local offsetY = {
      0,
      10,
      5
    }
    local pBuddha = display.newSprite("union/fairyland/pic_buddha.png"):pos(icon:getContentSize().width * 0.5 + offsetX[grade], 150 + offsetY[grade]):addTo(icon, -1)
    local pCircle = display.newSprite("union/fairyland/pic_circle.png"):pos(pBuddha:getContentSize().width * 0.5, 300):addTo(pBuddha, -1)
    pCircle:runAction(cc.RepeatForever:create(cc.RotateBy:create(4, 360)))
    local frames = display.newFrames("hudieguang%d.png", 1, 10)
    local animation = display.newAnimation(frames, 0.1)
    local emptyPic = display.newSprite():pos(275, 170):addTo(icon)
    emptyPic:playAnimationForever(animation, 0)
    local frames1 = display.newFrames("xfgs%d.png", 1, 30)
    local animation1 = display.newAnimation(frames1, 0.075)
    local emptyPic1 = display.newSprite():pos(icon:getContentSize().width * 0.5, 55):addTo(icon)
    emptyPic1:setScaleX(2.5)
    emptyPic1:playAnimationForever(animation1, 0)
  end
  return icon
end

function M:onTouch(event, x, y)
  if event == "began" then
    self.mNodePoint = {x = x, y = y}
    return true
  end
  if event == "moved" then
    local point_moved = {x = x, y = y}
    local rect = cc.rect(0, 0, display.width, display.height)
    if self.mNodePoint and cc.rectContainsPoint(rect, point_moved) then
      local cx, cy = self.mBgNode:getPosition()
      self.mBgNode:setPosition(cx + (x - self.mNodePoint.x) * 2, cy)
      self.mNodePoint = {x = x, y = y}
      local maxX = 0
      local minX = display.width - self.mBgSize.width
      local currX = self.mBgNode:getPositionX()
      if minX > currX then
        self.mBgNode:setPositionX(minX)
      end
      if maxX < currX then
        self.mBgNode:setPositionX(maxX)
      end
    end
  end
  if event == "ended" then
    self.mNodePoint = nil
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  display.removeSpriteFramesWithFile("union/fairyland/union_tx1.plist", "union/fairyland/union_tx1.png")
  display.removeSpriteFramesWithFile("union/fairyland/union_tx2.plist", "union/fairyland/union_tx2.png")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

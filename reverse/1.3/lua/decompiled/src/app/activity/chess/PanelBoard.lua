local PanelBase = import(".PanelBase")
local Chess = import(".Chess")
local DYClass = "PanelBoard"
local M = {}
M = class(DYClass, PanelBase)
local WIDTH, HEIGHT = 74, 74
local MOVE_TIME = 0.15
local DELAY_TIME = 0.2
local FRONT_POINTS = {
  [7] = 15,
  [21] = 14,
  [23] = 31,
  [33] = 17
}
local POINT_ANGLE = {
  [-1] = 90,
  [1] = -90,
  [10] = 0,
  [-10] = 180
}
local TAG_BOX = {
  [1] = "\230\153\174\233\128\154\229\174\157\231\174\177",
  [2] = "\231\180\171\232\137\178\229\174\157\231\174\177",
  [3] = "\230\169\153\232\137\178\229\174\157\231\174\177"
}

function M:ctor(params, cb)
  M.super.ctor(self, params, cb)
  self.row_ = #Chess.BOARD
  self.column_ = #Chess.BOARD[1]
  self.mGridList = {}
  self:setContentSize(WIDTH * self.column_, HEIGHT * self.row_)
  self:generateGrid()
  self.mPathPoints = self:findPath(self.startPoint_, self.endPoint_)
  self:initStartPoint()
end

local function isEqualToPoint(point1, point2)
  if point1.x == point2.x and point1.y == point2.y then
    return true
  end
  return false
end

local function getLightFrameTexture(tag)
  if tag then
    return M_filePath("img_case1")
  end
  return M_filePath("img_case")
end

function M:generateGrid()
  local posX, posY = -WIDTH * 0.5, HEIGHT * (self.row_ + 0.5)
  for i = 1, self.row_ do
    posX, posY = -WIDTH * 0.5, posY - HEIGHT
    for j = 1, self.column_ do
      posX = posX + WIDTH
      local id = Chess.BOARD[i][j]
      if id ~= 0 then
        local offsetY = 0
        if -1 == id then
          offsetY = -13
          self.startPoint_ = {x = i, y = j}
        end
        if -2 == id then
          offsetY = 13
          self.endPoint_ = {x = i, y = j}
        end
        local gridData = Chess.GRID[id]
        local grid = display.newSprite(M_filePath(gridData.img))
        grid:pos(posX, posY + offsetY)
        grid:addTo(self)
        grid.img = gridData.img
        grid.name = gridData.name
        grid.desc = gridData.desc
        grid.event = gridData.event
        grid.initEvent = gridData.event
        grid.isEnabled = true
        if not gridData.desc then
          grid.isEnabled = false
        end
        grid:setTouchEnabled(true)
        grid:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
          return self:onTouchGrid(event, grid)
        end)
        self.mGridList[i * 10 + j] = grid
      end
    end
  end
end

function M:changeToNormalGrid(grid)
  grid:setTexture(M_filePath("icon_empty"))
  grid.event = "NORMAL_GRID"
  grid.isEnabled = false
end

function M:gridRestore(grid)
  grid:setTexture(M_filePath(grid.img))
  grid.event = grid.initEvent
  grid.isEnabled = true
end

function M:initStartPoint()
  self.mCurrPos = CMgr.CURR_POS
  local point = self.mPathPoints[self.mCurrPos]
  local startGrid = self.mGridList[point.x * 10 + point.y]
  local posX, posY = startGrid:getPosition()
  self.mRolePic = display.newSprite(M_filePath("img_role"))
  self.mRolePic:pos(posX, posY + startGrid:getContentSize().height * 0.5 + 33)
  self.mRolePic:addTo(self, 2)
  display.newSprite(CloudData.USER_ICON, 39, 56):scale(0.68):addTo(self.mRolePic, -1)
  local tag = 1 == self.mCurrPos or #self.mPathPoints == self.mCurrPos
  self.mLightFrame = display.newSprite(getLightFrameTexture(tag), posX, posY):addTo(self, 1)
  for i = 1, #CMgr.USED_GRID_POS do
    local point_ = self.mPathPoints[CMgr.USED_GRID_POS[i]]
    local grid_ = self.mGridList[point_.x * 10 + point_.y]
    self:changeToNormalGrid(grid_)
  end
end

function M:moveToPoint(pos, listener)
  local point = self.mPathPoints[pos]
  local grid = self.mGridList[point.x * 10 + point.y]
  local posX, posY = grid:getPosition()
  local seq = transition.sequence({
    cc.MoveTo:create(MOVE_TIME, cc.p(posX, posY + grid:getContentSize().height * 0.5 + 33)),
    cc.CallFunc:create(function()
      local tag = 1 == pos or #self.mPathPoints == pos
      self.mLightFrame:setTexture(getLightFrameTexture(tag))
      self.mLightFrame:setPosition(posX, posY)
      listener(self, grid.event)
    end)
  })
  self.mRolePic:runAction(seq)
end

function M:isIgnoreEvent()
  if CMgr.IGNORE_EVENT then
    DDLOG("\229\133\141\231\150\171\228\186\139\228\187\182")
    CMgr.IGNORE_EVENT = false
    self:dispatchEvent({
      name = CMgr.EVENT_STEP_OVER,
      eventList = CMgr.EVENT_LIST
    })
    return true
  end
  return false
end

function M:reset()
  self.mCurrPos = 1
  local startGrid = self.mGridList[self.startPoint_.x * 10 + self.startPoint_.y]
  local posX, posY = startGrid:getPosition()
  self.mRolePic:setPosition(posX, posY + startGrid:getContentSize().height * 0.5 + 33)
  self.mLightFrame:setTexture(getLightFrameTexture(true))
  self.mLightFrame:setPosition(posX, posY)
  for i = 1, #CMgr.USED_GRID_POS do
    local point_ = self.mPathPoints[CMgr.USED_GRID_POS[i]]
    local grid_ = self.mGridList[point_.x * 10 + point_.y]
    self:gridRestore(grid_)
  end
end

local function getSurroundPoints(point)
  return {
    {
      x = point.x + 1,
      y = point.y
    },
    {
      x = point.x - 1,
      y = point.y
    },
    {
      y = point.y + 1,
      x = point.x
    },
    {
      y = point.y - 1,
      x = point.x
    }
  }
end

local function isPointValid(point, board)
  local ret = false
  local x, y = point.x, point.y
  if board[x] and board[x][y] and board[x][y] ~= 0 then
    ret = true
  end
  return ret
end

local function isLastPoint(lastPoint, point)
  if not lastPoint then
    return false
  end
  if lastPoint.x ~= point.x or lastPoint.y ~= point.y then
    return false
  end
  return true
end

function M:findPath(startPoint, endPoint)
  local openList = {}
  table.insert(openList, startPoint)
  local isFinished = false
  while not isFinished do
    local currPoint = openList[#openList]
    local lastPoint = openList[#openList - 1]
    local surroundPoints = getSurroundPoints(currPoint)
    local foundPoint
    for k, v in pairs(surroundPoints) do
      if isPointValid(v, Chess.BOARD) and not isLastPoint(lastPoint, v) then
        foundPoint = v
        table.insert(openList, v)
      end
    end
    if foundPoint.x == endPoint.x and foundPoint.y == endPoint.y then
      isFinished = true
    end
  end
  return openList
end

function M:forwardStep(step)
  local currPos = self.mCurrPos
  local overstep = self.mCurrPos + step - #self.mPathPoints
  
  local function tFuncListener(self, event)
    if currPos < self.mCurrPos + step then
      if currPos == #self.mPathPoints then
        self.mCurrPos = currPos
        self:backwardStep(overstep)
      else
        currPos = currPos + 1
        self:moveToPoint(currPos, tFuncListener)
      end
    else
      self.mCurrPos = currPos
      self:selectedGridEvent(event)
    end
  end
  
  currPos = currPos + 1
  self:moveToPoint(currPos, tFuncListener)
end

function M:backwardStep(step)
  local currPos = self.mCurrPos
  if 1 == currPos then
    self:onStartPoint()
    return
  end
  
  local function tFuncListener(self, event)
    if currPos > self.mCurrPos - step then
      if 1 == currPos then
        self:onStartPoint()
        return
      end
      currPos = currPos - 1
      self:moveToPoint(currPos, tFuncListener)
    else
      self.mCurrPos = currPos
      self:selectedGridEvent(event)
    end
  end
  
  currPos = currPos - 1
  self:moveToPoint(currPos, tFuncListener)
end

function M:backToStartPoint()
  if self:isIgnoreEvent() then
    return
  end
  self:performWithDelay(function()
    local point = self.mPathPoints[self.mCurrPos]
    local grid = self.mGridList[point.x * 10 + point.y]
    local posX, posY = grid:getPosition()
    local frames = display.newFrames("bjstx%d.png", 1, 12)
    local animation = display.newAnimation(frames, 0.03333333333333333)
    local emptyPic = display.newSprite():pos(posX, posY):addTo(self, 2)
    emptyPic:playAnimationOnce(animation, true)
    local startPoint = self.mPathPoints[1]
    local startGrid = self.mGridList[startPoint.x * 10 + startPoint.y]
    local posX1, posY1 = startGrid:getPosition()
    local jumpTo = cc.JumpTo:create(0.5, cc.p(posX1, posY1 + startGrid:getContentSize().height * 0.5 + 33), HEIGHT, 1)
    local scaleTo = transition.sequence({
      cc.ScaleTo:create(0.3, 1.5),
      cc.ScaleTo:create(0.2, 1)
    })
    local rotate = cc.RotateBy:create(0.5, 360)
    local spwan = cc.Spawn:create({
      jumpTo,
      scaleTo,
      rotate
    })
    local seq = transition.sequence({
      spwan,
      cc.CallFunc:create(function()
        self.mLightFrame:setTexture(getLightFrameTexture(true))
        self.mLightFrame:setPosition(posX1, posY1)
        self.mCurrPos = 1
        self:selectedGridEvent(startGrid.event)
      end)
    })
    self.mRolePic:runAction(seq)
    table.insert(CMgr.EVENT_LIST, {
      name = "event_bajiaoshan"
    })
  end, DELAY_TIME)
end

function M:moveToFrontPoint()
  if self:isIgnoreEvent() then
    return
  end
  self:performWithDelay(function()
    local point = self.mPathPoints[self.mCurrPos]
    local grid = self.mGridList[point.x * 10 + point.y]
    local posX, posY = grid:getPosition()
    local frontPos = FRONT_POINTS[self.mCurrPos]
    local frontPoint = self.mPathPoints[frontPos]
    local frontGrid = self.mGridList[frontPoint.x * 10 + frontPoint.y]
    local posX1, posY1 = frontGrid:getPosition()
    if frontPos > self.mCurrPos then
      table.insert(CMgr.EVENT_LIST, {
        name = "event_jindouyun"
      })
    else
      table.insert(CMgr.EVENT_LIST, {
        name = "event_heifengguai"
      })
    end
    local seq = transition.sequence({
      cc.ScaleTo:create(0.1, 0.8),
      cc.ScaleTo:create(0.2, 1)
    })
    self.mLightFrame:runAction(seq)
    local frames = display.newFrames("tytx%d.png", 1, 19)
    local animation = display.newAnimation(frames, 0.03333333333333333)
    local emptyPic = display.newSprite():pos(39, 56):addTo(self.mRolePic, 2)
    emptyPic:playAnimationOnce(animation, true)
    local distance = cc.pGetLength({
      x = posX - posX1,
      y = posY - posY1
    })
    local moveTo = cc.MoveTo:create(distance / 740, cc.p(posX1, posY1 + frontGrid:getContentSize().width * 0.5 + 33))
    self.mRolePic:runAction(transition.sequence({
      moveTo,
      cc.CallFunc:create(function()
        local tag = 1 == frontPos or #self.mPathPoints == frontPos
        self.mLightFrame:setTexture(getLightFrameTexture(tag))
        self.mLightFrame:setPosition(posX1, posY1)
        self.mCurrPos = frontPos
        self:selectedGridEvent(frontGrid.event)
      end)
    }))
  end, DELAY_TIME)
end

function M:moveStepN(tag, step)
  if self:isIgnoreEvent() then
    return
  end
  self:performWithDelay(function()
    local direction = 1
    local listener, arrowFile
    if "forward" == tag then
      direction = 1
      arrowFile = M_filePath("arrow_green")
      
      function listener()
        self:forwardStep(step)
      end
      
      table.insert(CMgr.EVENT_LIST, {
        name = "event_forward"
      })
    else
      direction = -1
      arrowFile = M_filePath("arrow_red")
      
      function listener()
        self:backwardStep(step)
      end
      
      table.insert(CMgr.EVENT_LIST, {
        name = "event_backward"
      })
    end
    local point = self.mPathPoints[self.mCurrPos]
    local grid = self.mGridList[point.x * 10 + point.y]
    local posX, posY = grid:getPosition()
    local frames = display.newFrames("qjtx%d.png", 1, 19)
    local animation = display.newAnimation(frames, 0.03333333333333333)
    local emptyPic = display.newSprite():pos(posX, posY):addTo(self, 2)
    emptyPic:playAnimationForever(animation)
    local nextPoint = self.mPathPoints[self.mCurrPos + direction]
    local deltaX, deltaY = nextPoint.x - point.x, nextPoint.y - point.y
    local arrow = display.newSprite(arrowFile, posX, posY):addTo(self, 3)
    arrow:setRotation(POINT_ANGLE[deltaX * 10 + deltaY * 1])
    local seq = transition.sequence({
      cc.MoveBy:create(MOVE_TIME, cc.p(deltaY * 15, -deltaX * 15)),
      cc.MoveBy:create(MOVE_TIME, cc.p(-deltaY * 15, deltaX * 15))
    })
    arrow:runAction(cc.RepeatForever:create(seq))
    self:performWithDelay(function()
      emptyPic:removeSelf()
      arrow:removeSelf()
    end, MOVE_TIME * step)
    listener()
  end, DELAY_TIME)
end

function M:randomForward()
  if self:isIgnoreEvent() then
    return
  end
  self:performWithDelay(function()
    local seq = transition.sequence({
      cc.ScaleTo:create(0.1, 0.8),
      cc.ScaleTo:create(0.2, 1)
    })
    self.mLightFrame:runAction(seq)
    local frames = display.newFrames("zhtx%d.png", 1, 12)
    local animation = display.newAnimation(frames, 0.03333333333333333)
    local emptyPic = display.newSprite():pos(39, 56):addTo(self.mRolePic, -2)
    emptyPic:playAnimationForever(animation)
    local random = math.random(3, 6)
    self:forwardStep(random)
    self:performWithDelay(function()
      emptyPic:removeSelf()
    end, random * MOVE_TIME)
    table.insert(CMgr.EVENT_LIST, {
      name = "event_huoyanshan"
    })
  end, DELAY_TIME)
end

function M:randomBackward()
  if self:isIgnoreEvent() then
    return
  end
  self:performWithDelay(function()
    local seq = transition.sequence({
      cc.ScaleTo:create(0.1, 0.8),
      cc.ScaleTo:create(0.2, 1)
    })
    self.mLightFrame:runAction(seq)
    local frames = display.newFrames("guiji%d.png", 1, 13)
    local animation = display.newAnimation(frames, 0.03333333333333333)
    local emptyPic = display.newSprite():pos(39, 56):addTo(self.mRolePic, -2)
    emptyPic:playAnimationForever(animation)
    local random = math.random(6, 10)
    self:backwardStep(random)
    self:performWithDelay(function()
      emptyPic:removeSelf()
    end, random * MOVE_TIME)
    table.insert(CMgr.EVENT_LIST, {
      name = "event_wanniangui"
    })
  end, DELAY_TIME)
end

function M:gameComplete()
  CMgr.GAME_COMPLETE = true
  local point = self.mPathPoints[self.mCurrPos]
  local grid = self.mGridList[point.x * 10 + point.y]
  local posX, posY = grid:getPosition()
  local frames = display.newFrames("zdtx%d.png", 1, 30)
  local animation = display.newAnimation(frames, 0.03333333333333333)
  local emptyPic = display.newSprite():scale(2):pos(posX, posY):addTo(self, 2)
  emptyPic:playAnimationOnce(animation, true)
  self:performWithDelay(function()
    local function tFuncCallback()
      table.insert(CMgr.EVENT_LIST, {
        name = "event_endpoint"
      })
      self:dispatchEvent({
        name = CMgr.EVENT_STEP_OVER,
        eventList = CMgr.EVENT_LIST
      })
      CMgr.RUNNING_LAYER:resetGame()
    end
    
    local function tFuncListener(jsonTable)
      dump(jsonTable, " gameComplete : ")
      if jsonTable.errorCode > 0 then
        local errMsg = jsonTable.errorMsg or "UNKNOWN"
        WSToast.new(errMsg):addTo(CMgr.RUNNING_LAYER, 20)
        return
      end
      CMgr.PEACH_COST5 = jsonTable.data.peachContinueCost
      CMgr.LEFT_TIMES = jsonTable.data.walkLeft
      for k, v in pairs(jsonTable.data.drop) do
        DataUtils.updateItemNum(k, v)
      end
      local thingIds, counts = {}, {}
      for k, v in pairs(jsonTable.data.dropGain) do
        table.insert(thingIds, k)
        table.insert(counts, v)
      end
      local params = {
        type = "item",
        thingIds = thingIds,
        counts = counts
      }
      self:layerDropItems(params, tFuncCallback)
    end
    
    DYHttpMgr.gameComplete(tFuncListener, {seat = 1})
  end, 1)
end

function M:onStartPoint()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(CMgr.RUNNING_LAYER, 20)
      return
    end
    table.insert(CMgr.EVENT_LIST, {
      name = "event_startpoint"
    })
    self:dispatchEvent({
      name = CMgr.EVENT_STEP_OVER,
      eventList = CMgr.EVENT_LIST
    })
  end
  
  DYHttpMgr.updateCurrPos(tFuncListener, {
    seat = self.mCurrPos
  })
end

function M:onNormalPoint()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(CMgr.RUNNING_LAYER, 20)
      return
    end
    table.insert(CMgr.EVENT_LIST, {
      name = "event_nothing"
    })
    self:dispatchEvent({
      name = CMgr.EVENT_STEP_OVER,
      eventList = CMgr.EVENT_LIST
    })
  end
  
  DYHttpMgr.updateCurrPos(tFuncListener, {
    seat = self.mCurrPos
  })
end

function M:dropItems(tag)
  local point = self.mPathPoints[self.mCurrPos]
  local grid = self.mGridList[point.x * 10 + point.y]
  local rate = 1
  if CMgr.DOUBLE_AWARD then
    rate = 2
  end
  
  local function tFuncCallback()
    self:changeToNormalGrid(grid)
    table.insert(CMgr.USED_GRID_POS, self.mCurrPos)
    table.insert(CMgr.EVENT_LIST, {
      name = "event_item_award",
      param = TAG_BOX[tag]
    })
    self:dispatchEvent({
      name = CMgr.EVENT_STEP_OVER,
      eventList = CMgr.EVENT_LIST
    })
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(CMgr.RUNNING_LAYER, 20)
      return
    end
    CMgr.PEACH_COST5 = jsonTable.data.peachContinueCost
    CMgr.LEFT_TIMES = jsonTable.data.walkLeft
    for k, v in pairs(jsonTable.data.drop) do
      DataUtils.updateItemNum(k, v)
    end
    local thingIds, counts = {}, {}
    for k, v in pairs(jsonTable.data.dropGain) do
      table.insert(thingIds, k)
      table.insert(counts, v)
    end
    local params = {
      type = "item",
      thingIds = thingIds,
      counts = counts
    }
    self:layerDropItems(params, tFuncCallback)
  end
  
  DYHttpMgr.dropItems(tFuncListener, {
    type = tag,
    seat = self.mCurrPos,
    rate = rate
  })
end

function M:fateCard()
  local point = self.mPathPoints[self.mCurrPos]
  local grid = self.mGridList[point.x * 10 + point.y]
  local rate = 1
  if CMgr.DOUBLE_AWARD then
    rate = 2
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(CMgr.RUNNING_LAYER, 20)
      return
    end
    local id = jsonTable.data.cardId
    local cardData = CMgr.FATE_CARD[id]
    CMgr.FATE_CARD_COUNT = 0
    for k, v in pairs(jsonTable.data.fateCards) do
      CMgr.FATE_CARD[tonumber(k)].num = v
      CMgr.FATE_CARD_COUNT = CMgr.FATE_CARD_COUNT + v
    end
    
    local function tFuncCallback()
      self:changeToNormalGrid(grid)
      table.insert(CMgr.USED_GRID_POS, self.mCurrPos)
      table.insert(CMgr.EVENT_LIST, {
        name = "event_fate_award",
        param = cardData.name
      })
      self:dispatchEvent({
        name = CMgr.EVENT_STEP_OVER,
        eventList = CMgr.EVENT_LIST
      })
    end
    
    local params = {
      type = "card",
      data = cardData,
      num = rate
    }
    self:layerDropItems(params, tFuncCallback)
  end
  
  DYHttpMgr.dropFateCard(tFuncListener, {
    seat = self.mCurrPos,
    rate = rate
  })
end

function M:layerDropItems(params, cb)
  local pLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(CMgr.RUNNING_LAYER, 5)
  local bg = display.newSprite("summon_scene/alert_frame.png", display.cx, display.cy):addTo(pLayer)
  if params.type == "card" then
    local icon = display.newSprite(M_filePath(params.data.icon), 554, 210):addTo(bg)
    DYLabelTTF.new({
      text = "x" .. params.num,
      size = 30,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF,
      dyalign = "LEFT_BOTTOM"
    }, {}):pos(icon:getContentSize().width + 5, 5):addTo(icon)
  else
    local thingIds, counts = params.thingIds, params.counts
    local posX, posY = 554 - 75 * (#thingIds - 1), 240
    for i = 1, #thingIds do
      local itemId = thingIds[i]
      local model = DataUtils.getItemModelWithColor(itemId)
      local frame = display.newSprite("common_ui/frame" .. model.quality .. ".png", posX, posY):addTo(bg)
      local icon = display.newSprite(model.icon):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
      DYLabelTTF.new({
        text = model.name,
        size = 24,
        color = model.color,
        font = GameManager.FONTNAME_TTF
      }):pos(frame:getContentSize().width * 0.5, -30):addTo(frame)
      DYLabelTTF.new({
        text = "x" .. counts[i],
        size = 24,
        color = cc.c3b(255, 255, 255),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_RIGHT"
      }, {}):pos(frame:getContentSize().width - 10, 20):addTo(frame)
      posX = posX + 150
    end
  end
  pLayer:setTouchEnabled(true)
  pLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      pLayer:runAction(cc.RemoveSelf:create(true))
      if cb then
        cb()
      end
      return true
    end
  end)
  if 5 == CMgr.RUNNING_LAYER.mDicingType and not CMgr.GAME_COMPLETE then
    pLayer:setTouchEnabled(false)
    self:performWithDelay(function()
      pLayer:runAction(cc.RemoveSelf:create(true))
      if cb then
        cb()
      end
    end, 0.5)
  end
end

function M:selectedGridEvent(event)
  if not event then
    return
  end
  local tFunc = {
    START_POINT = function()
      self:onStartPoint()
    end,
    NORMAL_GRID = function()
      self:onNormalPoint()
    end,
    DROP_ITEMS1 = function()
      self:dropItems(1)
    end,
    DROP_ITEMS2 = function()
      self:dropItems(2)
    end,
    DROP_ITEMS3 = function()
      self:dropItems(3)
    end,
    FATE_CARD = function()
      self:fateCard()
    end,
    BACK_TO_STARTPOINT = function()
      self:backToStartPoint()
    end,
    GO_TO_FRONT = function()
      self:moveToFrontPoint()
    end,
    BACK_TO_FRONT = function()
      self:moveToFrontPoint()
    end,
    RANDOM_FORWARD = function()
      self:randomForward()
    end,
    RANDOM_BACKWARD = function()
      self:randomBackward()
    end,
    FORWARD_STEP3 = function()
      self:moveStepN("forward", 3)
    end,
    FORWARD_STEP4 = function()
      self:moveStepN("forward", 4)
    end,
    FORWARD_STEP5 = function()
      self:moveStepN("forward", 5)
    end,
    BACKWARD_STEP3 = function()
      self:moveStepN("backward", 3)
    end,
    BACKWARD_STEP4 = function()
      self:moveStepN("backward", 4)
    end,
    BACKWARD_STEP5 = function()
      self:moveStepN("backward", 5)
    end,
    GAME_COMPLETE = function()
      self:gameComplete()
    end
  }
  tFunc[event]()
end

function M:onTouchGrid(event, grid)
  if not grid.isEnabled then
    return
  end
  if "began" == event.name then
    local posX, posY = grid:getPosition()
    self.mBubble = self:bubbleShow(grid)
    if event.x > 450 then
      self.mBubble:align(display.CENTER_RIGHT, posX - 37, posY)
    else
      self.mBubble:align(display.CENTER_LEFT, posX + 37, posY)
    end
    return true
  end
  if "ended" == event.name then
    self.mBubble:removeSelf()
    self.mBubble = nil
  end
end

function M:bubbleShow(grid)
  local frame = display.newSprite(M_filePath("img_tips")):addTo(self, 5)
  local icon = display.newSprite(M_filePath(grid.img), 52, 140):addTo(frame)
  DYLabelTTF.new({
    text = grid.name,
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(100, 140):addTo(frame)
  DYLabelTTF.new({
    text = grid.desc,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dimensions = cc.size(320, 80),
    align = cc.ui.TEXT_ALIGN_LEFT
  }):pos(173, 40):addTo(frame)
  return frame
end

return M

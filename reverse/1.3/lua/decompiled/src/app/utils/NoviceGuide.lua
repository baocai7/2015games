local GUIDE_STAGE = 1
local GUIDE_PROCESS = 2
local GUIDE_TEXT = 3
local GUIDE_POINT_TYPE = 4
local GUIDE_POINTX = 5
local GUIDE_POINTY = 6
local GUIDE_BG_POINTX = 7
local GUIDE_BG_POINTY = 8
local GUIDE_TYPE = 9
local GUIDE_DIRCTION = 10
local GUIDE_RANGEX = 11
local GUIDE_RANGEY = 12
local GUIDE_ISNEEDPAUSE = 13
local GUIDE_DELAYTIME = 14
local NoviceGuide = {}
NoviceGuide = class("NoviceGuide", function()
  return display.newLayer()
end)

function NoviceGuide:ctor(guideStep, cb, obj)
  self.mKeypadListener = handler(self, self.onKeypad)
  self.obj = {}
  self.mGuideStepList = self:getGuideData(DataRetainer.NEW_GUIDE_INFO, guideStep)
  if self.mGuideStepList == nil or #self.mGuideStepList == 0 then
    DDLOG(DYLang.getString("S1800", ""), guideStep)
    self:runAction(cc.RemoveSelf:create())
    return
  end
  self.mGuideStepName = guideStep
  self.cb = cb
  if obj ~= nil then
    self.obj = obj
  end
  self.rowId_ = 1
  self:initUI_()
  self:setNodeEventEnabled(true)
end

function NoviceGuide:getGuideStep()
  local function tFuncListener(jsonTable)
    dump(self.mGuideStepList)
    
    if jsonTable.data >= self.mGuideStepList[1][GUIDE_STAGE] then
      self:runAction(cc.RemoveSelf:create())
    end
  end
  
  DYHttpMgr.getGuideStep(tFuncListener, nil)
end

function NoviceGuide:getGuideData(useData, guideStep)
  local content = {}
  for i = 1, #useData do
    if useData[i][GUIDE_PROCESS] == guideStep then
      content[#content + 1] = useData[i]
    end
  end
  dump(content, "content    ")
  return content
end

function NoviceGuide:initUI_()
  self.bg_ = display.newSprite("novice_guide/guide_bg.png"):addTo(self)
  self.finger1_ = display.newSprite("novice_guide/finger.png"):addTo(self, 3)
  self.finger2_ = display.newSprite("novice_guide/finger.png"):flipX(true):flipY(true):addTo(self, 3)
  self.circle_ = display.newSprite("novice_guide/circle.png"):addTo(self, 2)
  self.circle_:setTouchEnabled(true)
  self.circle_:setTouchSwallowEnabled(false)
  self.circle_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouch_(event.name, event.x, event.y)
  end)
  self.arrow_ = display.newSprite("novice_guide/arrow.png"):addTo(self, 1)
  self.textLabel_ = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 26,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(240, 105),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.bg_:getContentSize().width * 0.67, self.bg_:getContentSize().height * 0.18):addTo(self.bg_)
  self:setTouchEnabled(true)
  self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouch_(event.name, event.x, event.y)
  end)
  if #self.obj > 0 then
    self:setZOrder()
    local maskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
    maskLayer:setTouchSwallowEnabled(false)
  end
  self:nextStep_()
end

function NoviceGuide:nextStep_()
  if self.obj ~= nil then
    DYUtils.setGlobalZOrder(self.obj[self.rowId_], 1)
  end
  if self.mGuideStepList[self.rowId_] == nil then
    DataUtils.setGuideIsFirstPlayed(self.mGuideStepName, true)
    DYHttpMgr.updateGuideStep(function()
      DDLOG(DYLang.getString("S1802", ""))
    end, {
      guide = self.guideStage or 9999
    })
    if self.cb then
      self.cb()
    end
    self:removeSelf()
    return
  end
  local rowData = self.mGuideStepList[self.rowId_]
  local textContent = rowData[GUIDE_TEXT]
  local pointType = tonumber(rowData[GUIDE_POINT_TYPE])
  local pointX = tonumber(rowData[GUIDE_POINTX])
  local pointY = tonumber(rowData[GUIDE_POINTY])
  local bgPointX = tonumber(rowData[GUIDE_BG_POINTX])
  local bgPointY = tonumber(rowData[GUIDE_BG_POINTY])
  self.guideStage = tonumber(rowData[GUIDE_STAGE])
  self.guideType_ = tonumber(rowData[GUIDE_TYPE])
  self.roleDerection_ = tonumber(rowData[GUIDE_DIRCTION])
  self.rangeX_ = tonumber(rowData[GUIDE_RANGEX])
  self.rangeY_ = tonumber(rowData[GUIDE_RANGEY])
  self.isNeedPause_ = tonumber(rowData[GUIDE_ISNEEDPAUSE])
  self.delayTime = tonumber(rowData[GUIDE_DELAYTIME])
  self.bg_:setPosition(display.cx + bgPointX, display.cy + bgPointY)
  self.bg_:setFlippedX(false)
  if pointType == 1 then
    pointX = display.cx + pointX - 640
    pointY = display.cy + pointY - 360
  elseif pointType == 3 then
    pointX = display.width - pointX
  elseif pointType == 4 then
    pointX = display.width * pointX
    pointY = display.height * pointY
  elseif pointType == 5 then
    pointX = pointX - (1280 - display.width)
  elseif pointType == 6 then
    pointX, pointY = display.cx + pointX, display.cy + pointY
  end
  self.fingerPoint_ = cc.p(pointX, pointY)
  self:fingerAction_()
  self.textLabel_:setString(textContent)
  if roleDerection_ == 1 then
    self.bg_:setFlippedX(true)
    self.textLabel_:setPosition(self.bg_:getContentSize().width * 0.33, self.bg_:getContentSize().height * 0.2)
  end
  if self.isNeedPause_ == 1 then
    BMgr.pause()
  end
  self.rowId_ = self.rowId_ + 1
end

function NoviceGuide:fingerAction_()
  if self.guideType_ == 0 then
    self.finger1_:hide()
    self.finger2_:hide()
    self.circle_:hide()
    self.arrow_:hide()
  elseif self.guideType_ == 1 or self.guideType_ == 4 then
    self.finger1_:show()
    self.finger2_:hide()
    self.circle_:show()
    self.arrow_:hide()
    self.finger1_:setPosition(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.65, self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.65)
    self.circle_:setPosition(self.fingerPoint_.x, self.fingerPoint_.y)
    local moveTo1 = cc.MoveTo:create(0.5, cc.p(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.35, self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.35))
    local moveTo2 = cc.MoveTo:create(0.5, cc.p(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.65, self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.65))
    local seq = transition.sequence({moveTo1, moveTo2})
    self.finger1_:runAction(cc.RepeatForever:create(seq))
    local scaleTo1 = cc.ScaleTo:create(0.5, 1)
    local scaleTo2 = cc.ScaleTo:create(0.5, 1.5)
    local seq1 = transition.sequence({scaleTo1, scaleTo2})
    self.circle_:runAction(cc.RepeatForever:create(seq1))
  elseif self.guideType_ == 2 then
    self.finger2_:hide()
    self.circle_:hide()
    self.arrow_:show()
    self.finger1_:setPosition(self.fingerPoint_.x - self.arrow_:getContentSize().width * 0.5, self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.5)
    self.arrow_:setPosition(self.fingerPoint_.x, self.fingerPoint_.y)
    local moveTo1 = cc.MoveTo:create(1.5, cc.p(self.fingerPoint_.x + self.arrow_:getContentSize().width * 0.5, self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.5))
    local moveTo2 = cc.MoveTo:create(0, cc.p(self.fingerPoint_.x - self.arrow_:getContentSize().width * 0.5, self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.5))
    local seq = transition.sequence({moveTo1, moveTo2})
    self.finger1_:runAction(cc.RepeatForever:create(seq))
  else
    self.finger1_:show()
    self.finger2_:show()
    self.circle_:show()
    self.arrow_:hide()
    self.finger1_:setPosition(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.95, self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.95)
    self.finger2_:setPosition(self.fingerPoint_.x - self.finger2_:getContentSize().width * 0.95, self.fingerPoint_.y + self.finger2_:getContentSize().height * 0.95)
    self.circle_:setPosition(self.fingerPoint_.x, self.fingerPoint_.y)
    local moveTo1 = cc.MoveTo:create(0.8, cc.p(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.6, self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.6))
    local moveTo2 = cc.MoveTo:create(0.8, cc.p(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.95, self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.95))
    local moveTo3 = cc.MoveTo:create(0.8, cc.p(self.fingerPoint_.x - self.finger2_:getContentSize().width * 0.6, self.fingerPoint_.y + self.finger1_:getContentSize().height * 0.6))
    local moveTo4 = cc.MoveTo:create(0.8, cc.p(self.fingerPoint_.x - self.finger1_:getContentSize().width * 0.95, self.fingerPoint_.y + self.finger1_:getContentSize().height * 0.95))
    local seq1 = transition.sequence({moveTo1, moveTo2})
    local seq2 = transition.sequence({moveTo3, moveTo4})
    self.finger1_:runAction(cc.RepeatForever:create(seq1))
    self.finger2_:runAction(cc.RepeatForever:create(seq2))
    local scaleTo1 = cc.ScaleTo:create(0.8, 1)
    local scaleTo2 = cc.ScaleTo:create(0.8, 1.5)
    local seq3 = transition.sequence({scaleTo1, scaleTo2})
    self.circle_:runAction(cc.RepeatForever:create(seq3))
  end
end

function NoviceGuide:onTouch_(event, x, y)
  if event == "began" then
    self.beginPoint_ = {x = x, y = y}
    if self.guideType_ == 1 and #self.obj <= 0 then
      if math.abs(self.beginPoint_.x - self.fingerPoint_.x) < self.rangeX_ and math.abs(self.beginPoint_.y - self.fingerPoint_.y) < self.rangeY_ then
        self:setTouchSwallowEnabled(false)
      else
        self:setTouchSwallowEnabled(true)
      end
    end
    if self.guideType_ == 4 then
      if math.abs(self.beginPoint_.x - self.fingerPoint_.x) < self.rangeX_ and math.abs(self.beginPoint_.y - self.fingerPoint_.y) < self.rangeY_ then
        self:setTouchSwallowEnabled(false)
      else
        self:setTouchSwallowEnabled(true)
      end
    end
    if self.guideType_ == 2 or self.guideType_ == 3 then
      self:setTouchSwallowEnabled(false)
    end
    if self.guideType_ == 0 or #self.obj > 0 then
      DDLOG(DYLang.getString("S1803", ""))
      self:setTouchSwallowEnabled(true)
    end
    return true
  elseif event == "moved" then
    if self.guideType_ == 2 then
    end
  elseif event == "ended" then
    local endPoint = {x = x, y = y}
    if math.abs(self.beginPoint_.x - endPoint.x) < self.rangeX_ and math.abs(self.beginPoint_.y - endPoint.y) < self.rangeY_ then
      if self.guideType_ == 0 then
        if self.isNeedPause_ == 1 then
          BMgr.resume()
        end
        self:nextStep_()
      elseif self.guideType_ == 1 or self.guideType_ == 4 then
        if math.abs(endPoint.x - self.fingerPoint_.x) < self.rangeX_ and math.abs(endPoint.y - self.fingerPoint_.y) < self.rangeY_ then
          if self.isNeedPause_ == 1 then
            BMgr.resume()
          end
          if self.obj ~= nil then
            DYUtils.setGlobalZOrder(self.obj[self.rowId_ - 1], 0)
          end
          self.finger1_:stopAllActions()
          self.circle_:stopAllActions()
          self:nextStep_()
        end
      elseif self.guideType_ == 3 and self.isNeedPause_ == 1 then
        BMgr.resume()
      end
    end
  end
end

function NoviceGuide:setZOrder()
  DYUtils.setGlobalZOrder(self.finger1_, 1)
  DYUtils.setGlobalZOrder(self.circle_, 1)
  DYUtils.setGlobalZOrder(self.arrow_, 1)
end

function NoviceGuide:onKeypad(keyCode, event)
  return true
end

function NoviceGuide:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function NoviceGuide:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return NoviceGuide

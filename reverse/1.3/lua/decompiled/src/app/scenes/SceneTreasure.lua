local NoviceGuide = require("app.utils.NoviceGuide")
local CLASS_NAME = "LayerTreasure"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer(CLASS_NAME)
end)
local S_MAX_COUNT = 13

function M:ctor(handler_)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mStageProgress = nil
  self.mPageView = nil
  self.mBtnBack = nil
  self.mBtnLeft = nil
  self.mBtnRight = nil
  self.mBg = nil
  self.mFocusId = 1
  self.mCallback = handler_
  self.mCoreNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  self:layoutUI()
  self:setNodeEventEnabled(true)
  self:dealUserGuide()
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:hide()
  end
  return true
end

function M:onNotify(name, param)
  if name == DY_KEY.kUnlockTreasure then
    self.mFocusId = checknumber(param)
    self.mPageView:gotoPage(self.mFocusId, false)
  end
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
  DYNotification.regObserver(self, handler(self, self.onNotify), DY_KEY.kUnlockTreasure)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYNotification.removeAllObservers(self)
end

function M:layoutUI()
  self:initData()
  self:addBg()
  self:addContent()
end

function M:initData()
  GameManager.IS_TREASURE_PIECE_LAYER_CLOSED = false
end

function M:addBg()
  local node = self.mCoreNode
  self.mBg = display.newNode():addTo(node):size(1280, 720)
  self.mBg:setVisible(false)
end

function M:addContent()
  local node = self.mCoreNode
  local button = cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  })
  button:setPosition(dy.p(400, 320))
  button:onButtonClicked(handler(self, self.hide))
  node:addChild(button, 15)
  self.mBtnBack = button
  local button = cc.ui.UIPushButton.new("common_ui/left.png")
  button:setPosition(dy.p(-472, 0))
  button:onButtonClicked(handler(self, self.gotoPrevPage))
  button:onButtonPressed(DYButton.onStateChanged)
  button:onButtonRelease(DYButton.onStateChanged)
  node:addChild(button, 15)
  self.mBtnLeft = button
  local button = cc.ui.UIPushButton.new("common_ui/right.png")
  button:setPosition(dy.p(472, 0))
  button:onButtonClicked(handler(self, self.gotoNextPage))
  button:onButtonPressed(DYButton.onStateChanged)
  button:onButtonRelease(DYButton.onStateChanged)
  node:addChild(button, 15)
  self.mBtnRight = button
  self:createPageView()
  local ds = display.newSprite("treasure/treasure_tip1.png")
  ds:setPosition(dy.p(0, -330))
  node:addChild(ds)
  self:schedule(handler(self, self.updatePieceLayer), 0.1)
  self:performWithDelay(function()
    self.mDetailsBtn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = "\229\174\157\231\137\169\232\175\166\230\131\133",
      size = 28,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(25, 30, 3)
    })):onButtonClicked(function()
      self:showTreasureDetails()
    end):align(display.CENTER, 320, -260):addTo(node, 5)
  end, 0)
end

function M:showActivateEffect()
  local idx = 1
  if idx == S_MAX_COUNT then
    self.mBtnLeft:setVisible(true)
    self.mBtnRight:setVisible(false)
  elseif idx == 1 then
    self.mBtnLeft:setVisible(false)
    self.mBtnRight:setVisible(true)
  else
    self.mBtnLeft:setVisible(true)
    self.mBtnRight:setVisible(true)
  end
  self.mPageView:reload(idx, true)
end

function M:gotoPrevPage(param)
  DDLOG("<---")
  local sum = self.mPageView:getPageCount()
  local cur = self.mPageView:getCurPageIdx()
  local fun1 = cc.CallFunc:create(function()
    self.mBtnLeft:setTouchEnabled(false)
    self.mBtnRight:setTouchEnabled(false)
    self.mPageView:setTouchEnabled(false)
  end)
  local fun2 = cc.CallFunc:create(function()
    self.mBtnLeft:setTouchEnabled(true)
    self.mBtnRight:setTouchEnabled(true)
    self.mPageView:setTouchEnabled(true)
  end)
  self.mBtnLeft:runAction(transition.sequence({
    fun1,
    cc.DelayTime:create(0.6),
    fun2
  }))
  if 1 < cur then
    self.mPageView:gotoPage(cur - 1, true)
  else
    self.mPageView:gotoPage(1, true)
  end
end

function M:gotoNextPage(param)
  DDLOG("--->")
  local sum = self.mPageView:getPageCount()
  local cur = self.mPageView:getCurPageIdx()
  local fun1 = cc.CallFunc:create(function()
    self.mBtnLeft:setTouchEnabled(false)
    self.mBtnRight:setTouchEnabled(false)
    self.mPageView:setTouchEnabled(false)
  end)
  local fun2 = cc.CallFunc:create(function()
    self.mBtnLeft:setTouchEnabled(true)
    self.mBtnRight:setTouchEnabled(true)
    self.mPageView:setTouchEnabled(true)
  end)
  self.mBtnRight:runAction(transition.sequence({
    fun1,
    cc.DelayTime:create(0.6),
    fun2
  }))
  if sum > cur then
    self.mPageView:gotoPage(cur + 1, true)
  else
    self.mPageView:gotoPage(sum, true)
  end
end

function M:createPageView()
  local node = self.mCoreNode
  local param = {
    viewRect = cc.rect(-472, -360, 944, 720),
    padding = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 0
    },
    columnSpace = 80,
    rowSpace = 0
  }
  local pv = DYPageView.new(param)
  pv:addTo(node)
  pv:onTouch(handler(self, self.onPageViewSlide))
  local TreasurePage = require("app.icons.TreasurePage")
  local idx = 1
  
  local function tFuncAddPage()
    if idx <= S_MAX_COUNT then
      local item = pv:newItem()
      local content = TreasurePage.new(idx)
      content:setContentSize(944, 720)
      content:setAnchorPoint(0, 0)
      item:addChild(content)
      pv:addItem(item)
      item:retain()
    end
    if idx >= S_MAX_COUNT then
      self:showActivateEffect()
      self:onPageViewSlide()
    else
      idx = idx + 1
      self:performWithDelay(tFuncAddPage, 0)
    end
  end
  
  self.mBg:setVisible(true)
  self.mPageView = pv
  self.mBtnLeft:setVisible(false)
  self.mBtnRight:setVisible(false)
  tFuncAddPage()
end

function M:onPageViewSlide()
  DDLOG("onPageViewSlide")
  local idx = self.mPageView:getCurPageIdx()
  if idx == S_MAX_COUNT then
    self.mBtnLeft:setVisible(true)
    self.mBtnRight:setVisible(false)
  elseif idx == 1 then
    self.mBtnLeft:setVisible(false)
    self.mBtnRight:setVisible(true)
  else
    self.mBtnLeft:setVisible(true)
    self.mBtnRight:setVisible(true)
  end
end

function M:updatePieceLayer()
  if GameManager.IS_TREASURE_PIECE_LAYER_CLOSED then
    GameManager.IS_TREASURE_PIECE_LAYER_CLOSED = false
  end
end

function M:showTreasureDetails()
  local pLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 10)
  local bg = display.newSprite("treasure/img_01.png", display.cx, display.cy):addTo(pLayer)
  local offsetX, offsetY = 0, 0
  for i = 1, S_MAX_COUNT do
    local treasureRate = DataUtils.getTreasureIncRate(i)
    if i < 8 then
      offsetX, offsetY = 156, 303 - (i - 1) * 43.5
      if 1 == i then
        offsetX = 180
      end
    else
      offsetX, offsetY = 390, 303 - (i - 8) * 43.5
    end
    local label = DYLabelTTF.new({
      text = treasureRate .. "%",
      size = 20,
      color = cc.c3b(118, 69, 11),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(offsetX, offsetY):addTo(bg)
    if 0 == treasureRate then
      label:setString("\230\156\170\230\191\128\230\180\187")
      label:setColor(cc.c3b(199, 170, 110))
    end
  end
  display.newSprite("sign/img_prompt.png", display.cx, display.cy - 210):addTo(pLayer)
  pLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if "began" == event.name then
      return true
    elseif "ended" == event.name then
      local x, y = event.x, event.y
      local touchInSprite = cc.rectContainsPoint(bg:getCascadeBoundingBox(), cc.p(x, y))
      if not touchInSprite then
        pLayer:removeSelf()
      end
    end
  end)
end

function M:show()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  local scene = cc.Director:getInstance():getRunningScene()
  scene:addChild(self, 20)
end

function M:hide()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
  self:runAction(cc.RemoveSelf:create())
end

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  local guide = stageProgress ~= 10 or DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE10_TREASURESCN") or NoviceGuide.new("GUDIE_STAGE10_TREASURESCN"):addTo(self, 999)
end

return M

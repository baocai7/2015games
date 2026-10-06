local DataLabelIcon = require("app.icons.DataLabelIcon")
local LayerRule = require("app.layers.LayerRule")
local LayerFateCard = import(".LayerFateCard")
local PanelBoard = import(".PanelBoard")
local PanelDice = import(".PanelDice")
local PanelFateCard = import(".PanelFateCard")
local PanelRecord = import(".PanelRecord")
local DYClass = "LayerChess"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
M.EVENT_DICING = "event_dicing"

function M:ctor(cb)
  DDLOG(DYClass .. ": onCreate")
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  CMgr = require("app.activity.chess.ChessManager")
  CMgr.init()
  CMgr.RUNNING_LAYER = self
  self:loadRes()
  self:initData()
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function M_filePath(name)
  return string.format("flight_chess/%s.png", name)
end

function M:initUI()
  local bg = display.newSprite(M_filePath("img_bottom")):addTo(self.mNode)
  self.mBg = bg
  display.newSprite(M_filePath("img_title")):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.94):addTo(bg)
  local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH, true)
  peachLabel:setPosition(cc.p(display.width * 0.87, display.height * 0.94))
  peachLabel:addTo(self, 1)
  LayerRule.newRuleIcon(LayerRule.FLIGHT_CHESS):align(display.CENTER, bg:getContentSize().width * 0.18, bg:getContentSize().height * 0.94):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):align(display.CENTER, display.width * 0.05, display.height * 0.94):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self, 1)
end

function M:initData()
  local function tFuncListener(jsonTable)
    CMgr.FATE_CARD_COUNT = 0
    
    for k, v in pairs(jsonTable.data.fateCards) do
      CMgr.FATE_CARD[tonumber(k)].num = v
      CMgr.FATE_CARD_COUNT = CMgr.FATE_CARD_COUNT + v
    end
    CMgr.USED_GRID_POS = jsonTable.data.openSerial
    CMgr.LEFT_BUY_TIMES = jsonTable.data.buyLeft
    CMgr.LEFT_TIMES = jsonTable.data.walkLeft
    CMgr.PEACH_COST = jsonTable.data.peachCost
    CMgr.PEACH_COST5 = jsonTable.data.peachContinueCost
    CMgr.CURR_POS = jsonTable.data.seat
    self:loadPanel()
  end
  
  DYHttpMgr.chessInit(tFuncListener)
end

function M:loadPanel()
  self.mPanelBoard = PanelBoard.new()
  self.mPanelBoard:setPosition(117, 45)
  self.mPanelBoard:addTo(self.mBg, 2)
  self.mPanelBoard:addEventListener(CMgr.EVENT_STEP_OVER, handler(self, self.onEventStepOver))
  self.mPanelDice = PanelDice.new(nil, handler(self, self.onEventPanelDice))
  self.mPanelDice:setPosition(1000, 30)
  self.mPanelDice:addTo(self.mBg, 1)
  self.mPanelCard = PanelFateCard.new(nil, handler(self, self.onEventPanelCard))
  self.mPanelCard:setPosition(805, 30)
  self.mPanelCard:addTo(self.mBg, 1)
  self.mPanelRecord = PanelRecord.new()
  self.mPanelRecord:setPosition(805, 310)
  self.mPanelRecord:addTo(self.mBg, 1)
end

function M:playDiceAnimation()
  self.mPlayTimes = self.mPlayTimes + 1
  self.mStep = self.mStepNums[self.mPlayTimes]
  table.insert(CMgr.EVENT_LIST, {
    name = "event_dicing1",
    param = self.mStep
  })
  self.mMaskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 5)
  local bg = display.newSprite(M_filePath("img_bottom_03"), display.cx, display.cy):addTo(self.mMaskLayer)
  self.mMaskLayer.bg_ = bg
  local frames = display.newFrames("shanzi%d.png", 1, 16)
  local animation = display.newAnimation(frames, 0.03333333333333333)
  local emptyPic = display.newSprite():pos(345, 265):addTo(bg)
  emptyPic:playAnimationForever(animation)
  self:performWithDelay(function()
    emptyPic:removeSelf()
    self:animationComplete()
  end, 1.5)
end

function M:animationComplete()
  local step = self.mStep
  display.newSprite(M_filePath("icon_dice_0" .. step), 345, 265):addTo(self.mMaskLayer.bg_)
  DYLabelTTF.new({
    text = string.format("\230\156\172\230\172\161\229\176\134\232\161\140\232\181\176%d\230\173\165", step),
    size = 30,
    color = cc.c3b(110, 50, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(345, 140):addTo(self.mMaskLayer.bg_)
  local btn1 = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\228\189\191\231\148\168\229\145\189\232\191\144\229\141\161",
    size = 30,
    color = cc.c3b(255, 246, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(110, 50, 0)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = "\228\189\191\231\148\168\229\145\189\232\191\144\229\141\161",
    size = 30,
    color = cc.c3b(201, 201, 201),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(47, 47, 47)
  })):onButtonClicked(function()
    if 1 == self.mDicingType then
      self:useCallBack()
    end
  end):align(display.CENTER, 222, 65):addTo(self.mMaskLayer.bg_)
  if 0 == CMgr.FATE_CARD_COUNT then
    self:performWithDelay(function()
      btn1:setButtonEnabled(false)
    end, 0)
  end
  local btn2 = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\231\161\174\232\174\164\239\188\1365s\239\188\137",
    size = 30,
    color = cc.c3b(255, 246, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(110, 50, 0)
  })):onButtonClicked(function()
    if 1 == self.mDicingType then
      self:confirmCallBack()
    end
  end):align(display.CENTER, 450, 65):addTo(self.mMaskLayer.bg_)
  if 5 == self.mDicingType then
    self:performWithDelay(function()
      self:confirmCallBack()
    end, 0.5)
    return
  end
  local countTime = 5
  self.mSchedule = self:schedule(function()
    countTime = countTime - 1
    btn2:setButtonLabelString("normal", string.format("\231\161\174\232\174\164\239\188\136%ds\239\188\137", countTime))
    if 0 == countTime then
      self:confirmCallBack()
    end
  end, 1)
end

function M:useCallBack()
  self:stopAction(self.mSchedule)
  self.mSchedule = nil
  self.mMaskLayer:runAction(cc.RemoveSelf:create(true))
  LayerFateCard.new({
    tag = LayerFateCard.TAG_USE
  }, handler(self, self.onEventUseFateCard)):addTo(self, 20)
end

function M:confirmCallBack()
  self:stopAction(self.mSchedule)
  self.mSchedule = nil
  self.mMaskLayer:runAction(cc.RemoveSelf:create(true))
  self.mPanelBoard:forwardStep(self.mStep)
end

function M:onEventPanelDice(params)
  self.mPlayTimes = 0
  self.mDicingType = params.times
  self.mStepNums = params.steps
  if 5 == self.mDicingType then
    table.insert(CMgr.EVENT_LIST, {
      name = "event_dicing5"
    })
    self.mPanelRecord:addEventItem(clone(CMgr.EVENT_LIST))
    CMgr.EVENT_LIST = {}
  end
  self:playDiceAnimation()
end

function M:onEventPanelCard(params)
  LayerFateCard.new({}, nil):addTo(self, 20)
end

function M:onEventStepOver(event)
  local eventList = clone(event.eventList)
  CMgr.EVENT_LIST = {}
  CMgr.DOUBLE_AWARD = false
  CMgr.IGNORE_EVENT = false
  self.mPanelRecord:addEventItem(eventList)
  if 1 == self.mDicingType then
    CMgr.IS_BTN_ENABLED = true
    return
  end
  if self.mPlayTimes < 5 and not CMgr.GAME_COMPLETE then
    self:playDiceAnimation()
  else
    CMgr.IS_BTN_ENABLED = true
  end
end

function M:onEventUseFateCard(event)
  if -1 == event.id then
    self.mPanelBoard:forwardStep(self.mStep)
    return
  end
  table.insert(CMgr.EVENT_LIST, {
    name = "event_use_fatecard",
    param = CMgr.FATE_CARD[event.id].name
  })
  local tFunc = {
    [1] = function()
      self:onEventStepOver({
        name = CMgr.EVENT_STEP_OVER,
        eventList = CMgr.EVENT_LIST
      })
    end,
    [2] = function()
      local random1, random2 = math.random(1, 100), math.random(1, 3)
      if random1 < 50 then
        self.mPanelBoard:forwardStep(random2)
      else
        self.mPanelBoard:backwardStep(random2)
      end
    end,
    [3] = function()
      self.mPanelBoard:forwardStep(self.mStep * 2)
    end,
    [4] = function()
      CMgr.DOUBLE_AWARD = true
      self.mPanelBoard:forwardStep(self.mStep)
    end,
    [5] = function()
      CMgr.IGNORE_EVENT = true
      self.mPanelBoard:forwardStep(self.mStep)
    end,
    [6] = function()
      self.mPanelBoard:backwardStep(self.mStep)
    end
  }
  tFunc[event.id]()
end

function M:resetGame()
  self.mPanelBoard:reset()
  self.mPanelRecord:cleanEventLog()
  CMgr.GAME_COMPLETE = false
  CMgr.USED_GRID_POS = {}
end

function M:loadRes()
  DYRes.loadSheet("flight_chess/animation/tx_bjx.plist")
  DYRes.loadSheet("flight_chess/animation/tx_fire.plist")
  DYRes.loadSheet("flight_chess/animation/tx_fly.plist")
  DYRes.loadSheet("flight_chess/animation/tx_idle.plist")
  DYRes.loadSheet("flight_chess/animation/tx_selected.plist")
  DYRes.loadSheet("flight_chess/animation/tx_backford.plist")
  DYRes.loadSheet("flight_chess/animation/tx_dice.plist")
  DYRes.loadSheet("flight_chess/animation/tx_endpoint.plist")
end

function M:closeCallBack()
  if not CMgr.IS_BTN_ENABLED then
    return
  end
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
  CMgr = nil
  DYRes.unloadSheet("flight_chess/animation/tx_bjx.plist")
  DYRes.unloadSheet("flight_chess/animation/tx_fire.plist")
  DYRes.unloadSheet("flight_chess/animation/tx_fly.plist")
  DYRes.unloadSheet("flight_chess/animation/tx_idle.plist")
  DYRes.unloadSheet("flight_chess/animation/tx_selected.plist")
  DYRes.unloadSheet("flight_chess/animation/tx_backford.plist")
  DYRes.unloadSheet("flight_chess/animation/tx_dice.plist")
  DYRes.unloadSheet("flight_chess/animation/tx_endpoint.plist")
end

return M

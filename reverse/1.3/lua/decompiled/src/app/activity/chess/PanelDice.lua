local LayerCommon = require("app.activity.LayerCommonAlert")
local PanelBase = import(".PanelBase")
local DYClass = "PanelDice"
local M = {}
M = class(DYClass, PanelBase)

function M:ctor(params, cb)
  M.super.ctor(self, params, cb)
  self.freeTimes_ = 5
  self.peachCost_ = 10
  self:layoutUI()
end

function M:layoutUI()
  local frame = display.newSprite("common_ui/frame_battle.png", 90, 205):addTo(self)
  local horse = display.newSprite(M_filePath("icon_horse"), 59, 59):addTo(frame)
  self.timesLabel_ = DYLabelTTF.new({
    text = "x" .. CMgr.LEFT_TIMES,
    size = 24,
    color = cc.c3b(255, 246, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {
    lineColor = cc.c3b(110, 50, 0)
  }):pos(105, 20):addTo(frame, 1)
  self:loadButton()
end

function M:loadButton()
  local buttons = {
    {
      text = "\229\134\146\233\153\169\228\184\128\230\172\161",
      tag = 1
    },
    {
      text = "\229\134\146\233\153\169\228\186\148\230\172\161",
      tag = 5
    }
  }
  for i = 1, #buttons do
    local params = buttons[i]
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = params.text,
      size = 30,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = params.text,
      size = 27,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):onButtonClicked(function()
      self:confirmDicing(params.tag)
    end):align(display.CENTER, 90, 105 - 70 * (i - 1)):addTo(self)
  end
end

function M:confirmDicing(tag)
  if not CMgr.IS_BTN_ENABLED then
    return
  end
  CMgr.IS_BTN_ENABLED = false
  if CMgr.LEFT_TIMES <= 0 and tag >= CMgr.LEFT_BUY_TIMES then
    WSToast.new("\229\189\147\229\137\141\229\134\146\233\153\169\230\172\161\230\149\176\228\184\141\232\182\179\239\188\129"):addTo(CMgr.RUNNING_LAYER, 20)
    CMgr.IS_BTN_ENABLED = true
    return
  end
  local peachCost = {
    [1] = CMgr.PEACH_COST,
    [5] = CMgr.PEACH_COST5
  }
  local listeners = {
    [1] = function(event)
      self:onEventDicing1(event)
    end,
    [5] = function(event)
      self:onEventDicing5(event)
    end
  }
  if tag > CMgr.LEFT_TIMES then
    local textStr = string.format("\229\137\169\228\189\153\229\134\146\233\153\169\230\172\161\230\149\176\228\184\141\232\182\179\239\188\140\229\176\134\230\182\136\232\128\151%d\232\159\160\230\161\131\232\191\155\232\161\140\229\134\146\233\153\169\239\188\140\230\152\175\229\144\166\231\161\174\232\174\164\239\188\159", peachCost[tag])
    LayerCommon.new({text = textStr}, listeners[tag]):addTo(CMgr.RUNNING_LAYER, 20)
    return
  end
  listeners[tag](true)
end

function M:updateData(data)
  CMgr.LEFT_BUY_TIMES = data.buyLeft
  CMgr.LEFT_TIMES = data.walkLeft
  CMgr.PEACH_COST = data.peachCost
  CMgr.PEACH_COST5 = data.peachContinueCost
  CloudData.PEACH = data.peachLeft
  self.timesLabel_:setString("x" .. CMgr.LEFT_TIMES)
end

function M:onEventDicing1(param)
  if not param then
    CMgr.IS_BTN_ENABLED = true
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(CMgr.RUNNING_LAYER, 20)
      CMgr.IS_BTN_ENABLED = true
      return
    end
    self:updateData(jsonTable.data)
    local random = math.random(1, 6)
    self.mCallback({
      times = 1,
      steps = {random}
    })
  end
  
  DYHttpMgr.shakeDice1(tFuncListener)
end

function M:onEventDicing5(param)
  if not param then
    CMgr.IS_BTN_ENABLED = true
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(CMgr.RUNNING_LAYER, 20)
      CMgr.IS_BTN_ENABLED = true
      return
    end
    self:updateData(jsonTable.data)
    local steps = {}
    for i = 1, 5 do
      local random = math.random(1, 6)
      table.insert(steps, random)
    end
    self.mCallback({times = 5, steps = steps})
  end
  
  DYHttpMgr.shakeDice5(tFuncListener)
end

return M

local LayerReceivePkApply = require("app.layers.LayerReceivePkApply")
local M = {}
M = class("IconPkBubble", function()
  return display.newNode()
end)
local TAG_PK_REFUSE_TIMEOUT = "tag_pk_refuse_timeout"

function M:ctor()
  local time = os.time()
  self.mLastTime = CloudData.PK_ACTIVE_TIME - (time - CloudData.NEW_PK_TIME)
  if self.mLastTime < 0 then
    self.mLastTime = 0
  end
  self.mOriginBubblePos = {x = 50, y = 50}
  self.mTouchBeganPos = {x = 0, y = 0}
  self.mPkLayerShowed = false
  self.mSchedule = nil
  self:initUI()
  self:updatePos()
end

function M:initUI()
  local bubble = display.newSprite("chapter/friend_pk.png"):align(display.CENTER, self.mOriginBubblePos.x, self.mOriginBubblePos.y):addTo(self)
  bubble:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:touchCallBack(event)
  end)
  bubble:setTouchEnabled(true)
  local bubble1 = display.newSprite("chapter/friend_pk1.png", 200, 40):pos(bubble:getContentSize().width * 0.5, bubble:getContentSize().height * 0.5):addTo(bubble)
  bubble1:runAction(cc.RepeatForever:create(transition.sequence({
    cc.FadeIn:create(0.25),
    cc.FadeOut:create(0.25)
  })))
end

function M:touchCallBack(event)
  if "began" == event.name then
    self.mTouchBeganPos = {
      x = event.x,
      y = event.y
    }
  elseif "moved" == event.name then
    local pos = {
      x = event.x,
      y = event.y
    }
    local x = pos.x - self.mTouchBeganPos.x + self.mOriginBubblePos.x
    local y = pos.y - self.mTouchBeganPos.y + self.mOriginBubblePos.y
    self:setPosition(cc.p(x, y))
  elseif "ended" == event.name then
    local pos = {
      x = event.x,
      y = event.y
    }
    local x = pos.x - self.mTouchBeganPos.x + self.mOriginBubblePos.x
    local y = pos.y - self.mTouchBeganPos.y + self.mOriginBubblePos.y
    if x < 50 then
      x = 50
    end
    if x > display.width - 100 then
      x = display.width - 100
    end
    if y < 50 then
      y = 50
    end
    if y > display.height - 100 then
      y = display.height - 100
    end
    self.mOriginBubblePos = {x = x, y = y}
    self:setPosition(cc.p(x, y))
    if 50 > math.abs(pos.x - self.mTouchBeganPos.x) and 50 > math.abs(pos.y - self.mTouchBeganPos.y) then
      local pkApply = LayerReceivePkApply.new(CloudData.PK_APPLY_INFO)
      display.getRunningScene():addChild(pkApply, 20)
    end
  end
  return true
end

function M:updatePos()
  print(CloudData.NEW_PK_APPLY)
  if CloudData.NEW_PK_APPLY then
    self.mOriginBubblePos = {x = 50, y = 50}
    self:setPosition(cc.p(self.mOriginBubblePos.x, self.mOriginBubblePos.y))
    self:setVisible(true)
    GameManager.IS_USER_BUSY = 1
    local time = os.time()
    self.mLastTime = CloudData.PK_ACTIVE_TIME - (time - CloudData.NEW_PK_TIME)
    if self.mLastTime < 0 then
      self.mLastTime = 0
    end
    self:startCountDown()
  else
    self.mOriginBubblePos = {x = -200, y = -200}
    self:setPosition(cc.p(self.mOriginBubblePos.x, self.mOriginBubblePos.y))
    self:setVisible(false)
    GameManager.IS_USER_BUSY = 0
    if self.mSchedule then
      self:stopAction(self.mSchedule)
    end
  end
end

function M:startCountDown()
  self.mSchedule = self:schedule(function()
    CloudData.NEW_PK_APPLY = false
    self:updatePos()
    GameManager.IS_USER_BUSY = 0
    self:refuseCallback()
    self:stopAction(self.mSchedule)
  end, self.mLastTime)
end

function M:refuseCallback()
  local param = CloudData.PK_APPLY_INFO
  param.uid = CloudData.UID
  self:safeSocketRequest("CMD_FRIEND_PK_REFUSE", param)
end

return M

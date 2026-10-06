local CLASS_NAME = "DYShake"
local M = {}
M = class(CLASS_NAME, function(duration, radius)
  local act = dy.ActionDelegate:create(duration)
  
  local function onDelegate(data)
    local event = data:getEvent()
    if event == dy.action.EVENT_UPDATE and act.updateInLua then
      act:updateInLua(data:getT())
    elseif event == dy.action.EVENT_START_WITH_TARGET and act.startWithTargetInLua then
      act:startWithTargetInLua(data:getTarget())
    end
  end
  
  ScriptHandlerMgr:getInstance():registerScriptHandler(tolua.cast(act, "cc.Ref"), onDelegate, cc.Handler.CALLFUNC)
  return act
end)

function M:create(duration, radius)
  return M.new(duration, radius)
end

function M:ctor(duration, radius)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mDuration = duration
  self.mRadius = radius
  self.mOriginalX = 0
  self.mOriginalY = 0
  self.mTarget = nil
end

function M:clone()
  DDLOG(CLASS_NAME .. ": clone")
  return M.new(self.mDuration, self.mRadius)
end

function M:reverse()
  DDLOG(CLASS_NAME .. ": reverse")
  return M.new(self.mDuration, self.mRadius)
end

local S_MOVE = 10

function M:updateInLua(t)
  if 1 <= t then
    self.mTarget:setPosition(dy.p(self.mOriginalX, self.mOriginalY))
  else
    local base = math.random(0, S_MOVE * 2) - S_MOVE
    base = base / S_MOVE
    self.mTarget:setPosition(dy.p(self.mOriginalX + self.mRadius * base, self.mOriginalY + self.mRadius * base))
  end
end

function M:startWithTargetInLua(target)
  self.mTarget = target
  self.mOriginalX = target:getPositionX()
  self.mOriginalY = target:getPositionY()
end

return M

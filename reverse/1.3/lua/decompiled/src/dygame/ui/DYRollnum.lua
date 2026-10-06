local CLASS_NAME = "DYRollnum"
local M = {}
M = class(CLASS_NAME, function(duration)
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

function M:create(duration, from, to, isFloat)
  return M.new(duration, from, to, isFloat)
end

function M:ctor(duration, from, to, isFloat)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mDuration = duration or 1
  self.mFrom = from or 0
  self.mTo = to or 100
  self.mIsFloat = isFloat or false
  self.mTarget = nil
  self.mBeginTime = 0
end

function M:clone()
  DDLOG(CLASS_NAME .. ": clone")
  return M.new(self.mDuration, self.mFrom, self.mTo)
end

function M:reverse()
  DDLOG(CLASS_NAME .. ": reverse")
  return M.new(self.mDuration, self.mTo, self.mFrom)
end

function M:updateInLua(t)
  if 1 <= t then
    if self.mTarget.setString then
      self.mTarget:setString(checkstring(self.mTo))
    end
  else
    local delta = (self.mTo - self.mFrom) * (DYUtils.currentMillisecond() - self.mBeginTime) / (self.mDuration * 1000)
    if not self.mIsFloat then
      delta = checkint(delta)
    end
    local curNum = self.mFrom + delta
    if curNum >= self.mTo ~= (self.mFrom >= self.mTo) then
      curNum = self.mTo
    end
    if self.mTarget.setString then
      self.mTarget:setString(checkstring(curNum))
    end
  end
end

function M:startWithTargetInLua(target)
  self.mTarget = target
  self.mBeginTime = DYUtils.currentMillisecond()
end

return M

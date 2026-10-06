local CLASS_NAME = "DYSocketProxy"
local M = class(CLASS_NAME, DYUnitBase)

function M:request(cmd, t)
  local pid = SocketMgr:requestCommon(cmd, t)
  if not pid then
    return
  end
  local tEvent = DYCommon.genGlobalTag()
  
  local function tFuncListener(param)
    DYNotification.post(tEvent, param)
  end
  
  local kProto = string.format(DY_KEY.kSocketProto, checkstring(pid))
  DYNotification.regObserver(self:getTarget(), function(tag, param)
    assert(tag == kProto)
    tFuncListener(param)
    if self:getTarget() then
      DYNotification.unregisterScriptObserver(self:getTarget(), kProto)
    end
  end, kProto)
  return tEvent
end

function M:listen(cmd, isOnce)
  local pid = SocketMgr:listenCommon(cmd)
  if not pid then
    return
  end
  local tEvent = DYCommon.genGlobalTag()
  
  local function tFuncListener(param)
    DYNotification.post(tEvent, param)
  end
  
  local kProto = string.format(DY_KEY.kSocketProto, checkstring(pid))
  DYNotification.regObserver(self:getTarget(), function(tag, param)
    assert(tag == kProto)
    tFuncListener(param)
    if isOnce and self:getTarget() then
      DYNotification.unregisterScriptObserver(self:getTarget(), kProto)
    end
  end, kProto)
  return tEvent
end

function M:cancel(cmd)
  local pid = SocketMgr:listenCommon(cmd)
  if not pid then
    return
  end
  local kProto = string.format(DY_KEY.kSocketProto, checkstring(pid))
  if self:getTarget() then
    DYNotification.unregisterScriptObserver(self:getTarget(), kProto)
  end
end

return M

local M = {}

function M.isSupport()
  local bSupport = false
  if device.platform == "android" then
    local ret, val = luaj.callStaticMethod("com/dygame/common/DYCommon", "isSupportShare", {}, "()Ljava/lang/String;")
    if ret then
      bSupport = val == "true"
    end
  elseif device.platform == "ios" then
    local ret, val = luaoc.callStaticMethod("DYCommon_iOS", "isSupportShare")
    if ret then
      bSupport = val == "true"
    end
  else
    bSupport = true
  end
  return bSupport
end

function M.init(param, listener)
  local function tFuncListener(event)
    local et = json.decode(event)
    
    et.param = json.decode(et.param)
    if listener then
      listener(et)
    end
  end
  
  local strParam = json.encode(param)
  local bSupport = M.isSupport()
  if not bSupport then
    local fakeEvent = {}
    fakeEvent.event = dy.share.EVENT_INIT_FAIL
    fakeEvent.param = strParam
    
    local function tFuncDelay()
      tFuncListener(json.encode(fakeEvent))
    end
    
    DYUtils.schedule(tFuncDelay, 0, 1)
    return
  end
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYShareMgr", "init", {strParam, tFuncListener})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYShareMgr_iOS", "init", {param = strParam, listener = tFuncListener})
  else
    local fakeEvent = {}
    fakeEvent.event = dy.share.EVENT_INIT_SUCC
    fakeEvent.param = strParam
    
    local function tFuncDelay()
      tFuncListener(json.encode(fakeEvent))
    end
    
    DYUtils.schedule(tFuncDelay, 0, 1)
  end
end

function M.share(param, listener)
  local function tFuncListener(event)
    local et = json.decode(event)
    
    et.param = json.decode(et.param)
    if listener then
      listener(et)
    end
  end
  
  local strParam = json.encode(param)
  local bSupport = M.isSupport()
  if not bSupport then
    local fakeEvent = {}
    fakeEvent.event = dy.share.EVENT_SHARE_FAIL
    local paramErr = {}
    paramErr.error = "\230\130\168\231\154\132\229\174\162\230\136\183\231\171\175\230\154\130\228\184\141\230\148\175\230\140\129\229\136\134\228\186\171, \232\175\183\230\155\180\230\150\176"
    fakeEvent.param = json.encode(paramErr)
    
    local function tFuncDelay()
      tFuncListener(json.encode(fakeEvent))
    end
    
    DYUtils.schedule(tFuncDelay, 0, 1)
    return
  end
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYShareMgr", "share", {strParam, tFuncListener})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYShareMgr_iOS", "share", {param = strParam, listener = tFuncListener})
  else
    local fakeEvent = {}
    fakeEvent.event = dy.share.EVENT_SHARE_SUCC
    fakeEvent.param = strParam
    
    local function tFuncDelay()
      tFuncListener(json.encode(fakeEvent))
    end
    
    DYUtils.schedule(tFuncDelay, 0, 1)
  end
end

return M

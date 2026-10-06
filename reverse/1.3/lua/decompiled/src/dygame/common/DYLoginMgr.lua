local M = {}

function M.init(param, handler)
  param = param or {}
  assert(type(param) == "table")
  
  local function tFuncListener(event)
    if handler then
      local et = json.decode(event)
      et.param = json.decode(et.param)
      handler(et)
    end
  end
  
  local strParam = json.encode(param)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYLoginMgr", "init", {strParam, tFuncListener})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYLoginMgr_iOS", "init", {param = strParam, listener = tFuncListener})
  else
    local fakeEvent = {}
    fakeEvent.event = dy.login.EVENT_INIT_SUCC
    fakeEvent.param = json.encode(param)
    
    local function tFuncDelay()
      tFuncListener(json.encode(fakeEvent))
    end
    
    DYUtils.schedule(tFuncDelay, 0, 1)
  end
end

function M.login(param, handler)
  param = param or {}
  assert(type(param) == "table")
  
  local function tFuncListener(event)
    if handler then
      local et = json.decode(event)
      et.param = json.decode(et.param)
      handler(et)
    end
  end
  
  local strParam = json.encode(param)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYLoginMgr", "login", {strParam, tFuncListener})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYLoginMgr_iOS", "login", {param = strParam, listener = tFuncListener})
  else
    local fakeEvent = {}
    fakeEvent.event = dy.login.EVENT_LOGIN_SUCC
    fakeEvent.param = json.encode(param)
    
    local function tFuncDelay()
      tFuncListener(json.encode(fakeEvent))
    end
    
    DYUtils.schedule(tFuncDelay, 0, 1)
  end
end

function M.enter(param, listener)
  param = param or {}
  assert(type(param) == "table")
  
  local function tFuncListener(event)
  end
  
  local strParam = json.encode(param)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYLoginMgr", "enter", {strParam, tFuncListener})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYLoginMgr_iOS", "enter", {param = strParam, listener = tFuncListener})
  end
end

function M.updateEvent(eventName, param)
  param = param or {}
  param.eventName = eventName
  assert(type(param) == "table")
  
  local function tFuncListener(event)
  end
  
  local strParam = json.encode(param)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYLoginMgr", "updateEvent", {strParam, tFuncListener})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYLoginMgr_iOS", "updateEvent", {param = strParam, listener = tFuncListener})
  end
end

local FAKE_LOGOUT_LISTENER

function M.regLogout(param, listener)
  param = param or {}
  assert(type(param) == "table")
  
  local function tFuncListener(event)
    if listener then
      local et = json.decode(event)
      et.param = json.decode(et.param)
      listener(et)
    end
  end
  
  local strParam = json.encode(param)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYLoginMgr", "regLogout", {strParam, tFuncListener})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYLoginMgr_iOS", "regLogout", {param = strParam, listener = tFuncListener})
  else
    FAKE_LOGOUT_LISTENER = tFuncListener
  end
end

function M.logout(param)
  param = param or {}
  local strParam = json.encode(param)
  
  local function tFuncFake()
  end
  
  DDLOG("logout in lua: " .. strParam)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYLoginMgr", "logout", {strParam, tFuncFake})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYLoginMgr_iOS", "logout", {param = strParam, listener = tFuncFake})
  else
    local function tFuncDelay()
      if FAKE_LOGOUT_LISTENER then
        local params = json.encode({
          event = dy.login.EVENT_LOGOUT_SUCC,
          
          param = json.encode({})
        })
        FAKE_LOGOUT_LISTENER(params)
      end
    end
    
    DYUtils.schedule(tFuncDelay, 0, 1)
  end
end

return M

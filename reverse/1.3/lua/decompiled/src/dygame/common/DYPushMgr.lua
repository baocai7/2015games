local M = {}
local S_NOTICE_ON = true
local kNoticeSwitch = DY_KEY.kNoticeSwitch

function M.init(param, listener)
  S_NOTICE_ON = DYStat.getValueBool(kNoticeSwitch, true)
  param = param or {}
  assert(type(param) == "table")
  
  local function tFuncListener(event)
    if handler then
      local et = json.decode(event)
      et.param = json.decode(et.param)
      if listener then
        listener(et)
      end
    end
  end
  
  param.flag = false
  local strParam = json.encode(param)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYPushMgr", "init", {strParam, tFuncListener})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYPushMgr_iOS", "init", {param = strParam, listener = tFuncListener})
  else
    local fakeEvent = {}
    fakeEvent.event = dy.push.EVENT_INIT_SUCC
    fakeEvent.param = strParam
    
    local function tFuncDelay()
      tFuncListener(json.encode(fakeEvent))
    end
    
    DYUtils.schedule(tFuncDelay, 0, 1)
  end
end

function M.getNoticeOn()
  return S_NOTICE_ON
end

function M.setNoticeOn(flag)
  S_NOTICE_ON = flag
  DYStat.setValueBool(kNoticeSwitch, flag)
  local param = {}
  param.flag = S_NOTICE_ON
  local strParam = json.encode(param)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYPushMgr", "enable", {strParam})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYPushMgr_iOS", "enable", {param = strParam})
  end
end

function M.closeNotice()
  local param = {}
  param.flag = false
  local strParam = json.encode(param)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYPushMgr", "enable", {strParam})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYPushMgr_iOS", "enable", {param = strParam})
  end
end

function M.regScriptListener(handler)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYPushMgr", "regScriptListener", {handler}, "(I)V")
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYPushMgr_iOS", "regScriptListener", {listener = handler})
  end
end

function M.unregScriptListener()
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYPushMgr", "unregScriptListener", {}, "()V")
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYPushMgr_iOS", "unregScriptListener", nil)
  end
end

function M.setTags(tags)
  if not tags or #tags <= 0 then
    return
  end
  local strParam = checkstring(tags[1])
  for i = 2, #tags do
    strParam = strParam .. ";" .. tags[i]
  end
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYPushMgr", "setTags", {strParam})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYPushMgr_iOS", "setTags", {param = strParam})
  else
    DDLOG("DYPushMgr.setTags: " .. strParam)
  end
end

function M.delTags(tags)
  if not tags or #tags <= 0 then
    return
  end
  local strParam = checkstring(tags[1])
  for i = 2, #tags do
    strParam = strParam .. ";" .. tags[i]
  end
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYPushMgr", "delTags", {strParam})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYPushMgr_iOS", "delTags", {param = strParam})
  else
    DDLOG("DYPushMgr.delTags: " .. strParam)
  end
end

return M

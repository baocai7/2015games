local DCAgent = {}

function DCAgent.onStart(appId, channelId)
  appId = checkstring(appId)
  channelId = checkstring(channelId)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAgent", "onStart", {appId, channelId})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAgent", "onStart", {appId = appId, channelId = channelId})
  end
end

function DCAgent.setDebugMode(mode)
  mode = checkstring(mode)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAgent", "setDebugMode", {mode})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAgent", "setDebugMode", {mode = mode})
  end
end

function DCAgent.setReportMode(mode)
  mode = checkstring(mode)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAgent", "setReportMode", {mode})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAgent", "setReportMode", {mode = mode})
  end
end

function DCAgent.setUploadInterval(interval)
  interval = checkstring(interval)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAgent", "setUploadInterval", {interval})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAgent", "setUploadInterval", {interval = interval})
  end
end

function DCAgent.setVersion(version)
  version = checkstring(version)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAgent", "setVersion", {version})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAgent", "setVersion", {version = version})
  end
end

function DCAgent.reportError(title, content)
  title = checkstring(title)
  content = checkstring(content)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAgent", "reportError", {title, content})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAgent", "reportError", {title = title, content = content})
  end
end

function DCAgent.uploadNow()
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAgent", "uploadNow", {})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAgent", "uploadNow")
  end
end

function DCAgent.getUID()
  if device.platform == "android" then
    local ret, val = luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAgent", "getUID", {}, "()Ljava/lang/String;")
    if ret then
      return val
    end
  elseif device.platform == "ios" then
    local ret, val = luaoc.callStaticMethod("DCLuaAgent", "getUID")
    if ret then
      return val
    end
  end
  return "UNKNOWN"
end

return DCAgent

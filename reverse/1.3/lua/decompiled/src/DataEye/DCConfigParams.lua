local DCConfigParams = {}

function DCConfigParams.update()
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaConfigParams", "update", {})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaConfigParams", "update")
  end
end

function DCConfigParams.getParamNumber(key, defaultValue)
  key = checkstring(key)
  local def = checkstring(defaultValue)
  if device.platform == "android" then
    local ret, val = luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaConfigParams", "getParam", {key, def}, "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;")
    if ret then
      return checknumber(val)
    end
  elseif device.platform == "ios" then
    local ret, val = luaoc.callStaticMethod("DCLuaConfigParams", "getParam", {key = key, def = def})
    if ret then
      return checknumber(val)
    end
  end
  return defaultValue
end

function DCConfigParams.getParamString(key, defaultValue)
  key = checkstring(key)
  local def = checkstring(defaultValue)
  if device.platform == "android" then
    local ret, val = luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaConfigParams", "getParam", {key, def}, "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;")
    if ret then
      return checkstring(val)
    end
  elseif device.platform == "ios" then
    local ret, val = luaoc.callStaticMethod("DCLuaConfigParams", "getParam", {key = key, def = def})
    if ret then
      return checkstring(val)
    end
  end
  return defaultValue
end

function DCConfigParams.getParamBool(key, defaultValue)
  key = checkstring(key)
  local def = checkstring(defaultValue)
  if device.platform == "android" then
    local ret, val = luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaConfigParams", "getParam", {key, def}, "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;")
    if ret then
      return string.lower(val) == "true"
    end
  elseif device.platform == "ios" then
    local ret, val = luaoc.callStaticMethod("DCLuaConfigParams", "getParam", {key = key, def = def})
    if ret then
      return string.lower(val) == "true"
    end
  end
  return defaultValue
end

return DCConfigParams

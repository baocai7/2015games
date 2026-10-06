local DCLevels = {}

function DCLevels.begin(levelId)
  levelId = checkstring(levelId)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaLevels", "begin", {levelId})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaLevels", "begin", {levelId = levelId})
  end
end

function DCLevels.complete(levelId)
  levelId = checkstring(levelId)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaLevels", "complete", {levelId})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaLevels", "complete", {levelId = levelId})
  end
end

function DCLevels.fail(levelId, failPoint)
  levelId = checkstring(levelId)
  failPoint = checkstring(failPoint)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaLevels", "fail", {levelId, failPoint})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaLevels", "fail", {levelId = levelId, failPoint = failPoint})
  end
end

return DCLevels

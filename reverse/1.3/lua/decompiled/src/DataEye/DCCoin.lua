local DCCoin = {}

function DCCoin.setCoinNum(coinNum, coinType)
  coinNum = checkstring(coinNum)
  coinType = checkstring(coinType)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaCoin", "setCoinNum", {coinNum, coinType})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaCoin", "setCoinNum", {coinNum = coinNum, coinType = coinType})
  end
end

function DCCoin.lost(id, coinType, lost, left)
  id = checkstring(id)
  coinType = checkstring(coinType)
  lost = checkstring(lost)
  left = checkstring(left)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaCoin", "lost", {
      id,
      coinType,
      lost,
      left
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaCoin", "lost", {
      reason = id,
      coinType = coinType,
      lost = lost,
      left = left
    })
  end
end

function DCCoin.lostInLevel(id, coinType, lost, left, levelId)
  id = checkstring(id)
  coinType = checkstring(coinType)
  lost = checkstring(lost)
  left = checkstring(left)
  levelId = checkstring(levelId)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaCoin", "lostInLevel", {
      id,
      coinType,
      lost,
      left,
      levelId
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaCoin", "lostInLevel", {
      reason = id,
      coinType = coinType,
      lost = lost,
      left = left,
      levelId = levelId
    })
  end
end

function DCCoin.gain(id, coinType, gain, left)
  id = checkstring(id)
  coinType = checkstring(coinType)
  gain = checkstring(gain)
  left = checkstring(left)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaCoin", "gain", {
      id,
      coinType,
      gain,
      left
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaCoin", "gain", {
      reason = id,
      coinType = coinType,
      gain = gain,
      left = left
    })
  end
end

function DCCoin.gainInLevel(id, coinType, gain, left, levelId)
  id = checkstring(id)
  coinType = checkstring(coinType)
  gain = checkstring(gain)
  left = checkstring(left)
  levelId = checkstring(levelId)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaCoin", "gainInLevel", {
      id,
      coinType,
      gain,
      left,
      levelId
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaCoin", "gainInLevel", {
      reason = id,
      coinType = coinType,
      gain = gain,
      left = left,
      levelId = levelId
    })
  end
end

return DCCoin

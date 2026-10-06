local DCCardsGame = {}

function DCCardsGame.play(roomId, id, coinType, loseOrGain, tax, left)
  roomId = checkstring(roomId)
  id = checkstring(id)
  coinType = checkstring(coinType)
  loseOrGain = checkstring(loseOrGain)
  tax = checkstring(tax)
  left = checkstring(left)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaCardsGame", "play", {
      roomId,
      id,
      coinType,
      loseOrGain,
      tax,
      left
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaCardsGame", "play", {
      roomId = roomId,
      roomType = id,
      coinType = coinType,
      loseOrGain = loseOrGain,
      tax = tax,
      left = left
    })
  end
end

function DCCardsGame.gain(roomId, id, coinType, gain, left)
  roomId = checkstring(roomId)
  id = checkstring(id)
  coinType = checkstring(coinType)
  gain = checkstring(gain)
  left = checkstring(left)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaCardsGame", "gain", {
      roomId,
      id,
      coinType,
      gain,
      left
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaCardsGame", "gain", {
      roomId = roomId,
      roomType = id,
      coinType = coinType,
      gain = gain,
      left = left
    })
  end
end

function DCCardsGame.lost(roomId, id, coinType, lost, left)
  roomId = checkstring(roomId)
  id = checkstring(id)
  coinType = checkstring(coinType)
  lost = checkstring(lost)
  left = checkstring(left)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaCardsGame", "lost", {
      roomId,
      id,
      coinType,
      lost,
      left
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaCardsGame", "lost", {
      roomId = roomId,
      roomType = id,
      coinType = coinType,
      lost = lost,
      left = left
    })
  end
end

return DCCardsGame

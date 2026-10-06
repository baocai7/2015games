local DCItem = {}

function DCItem.buy(itemId, itemType, itemCount, virtualCurrency, currencyType, consumePoint)
  itemId = checkstring(itemId)
  itemType = checkstring(itemType)
  itemCount = checkstring(itemCount)
  virtualCurrency = checkstring(virtualCurrency)
  currencyType = checkstring(currencyType)
  consumePoint = checkstring(consumePoint)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaItem", "buy", {
      itemId,
      itemType,
      itemCount,
      virtualCurrency,
      currencyType,
      consumePoint
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaItem", "buy", {
      itemId = itemId,
      itemType = itemType,
      itemCount = itemCount,
      virtualCurrency = virtualCurrency,
      currencyType = currencyType,
      consumePoint = consumePoint
    })
  end
end

function DCItem.buyInLevel(itemId, itemType, itemCount, virtualCurrency, currencyType, consumePoint, levelId)
  itemId = checkstring(itemId)
  itemType = checkstring(itemType)
  itemCount = checkstring(itemCount)
  virtualCurrency = checkstring(virtualCurrency)
  currencyType = checkstring(currencyType)
  consumePoint = checkstring(consumePoint)
  levelId = checkstring(levelId)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaItem", "buyInLevel", {
      itemId,
      itemType,
      itemCount,
      virtualCurrency,
      currencyType,
      consumePoint,
      levelId
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaItem", "buyInLevel", {
      itemId = itemId,
      itemType = itemType,
      itemCount = itemCount,
      virtualCurrency = virtualCurrency,
      currencyType = currencyType,
      consumePoint = consumePoint,
      levelId = levelId
    })
  end
end

function DCItem.get(itemId, itemType, itemCount, reason)
  itemId = checkstring(itemId)
  itemType = checkstring(itemType)
  itemCount = checkstring(itemCount)
  reason = checkstring(reason)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaItem", "get", {
      itemId,
      itemType,
      itemCount,
      reason
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaItem", "get", {
      itemId = itemId,
      itemType = itemType,
      itemCount = itemCount,
      reason = reason
    })
  end
end

function DCItem.getInLevel(itemId, itemType, itemCount, reason, levelId)
  itemId = checkstring(itemId)
  itemType = checkstring(itemType)
  itemCount = checkstring(itemCount)
  reason = checkstring(reason)
  levelId = checkstring(levelId)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaItem", "getInLevel", {
      itemId,
      itemType,
      itemCount,
      reason,
      levelId
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaItem", "getInLevel", {
      itemId = itemId,
      itemType = itemType,
      itemCount = itemCount,
      reason = reason,
      levelId = levelId
    })
  end
end

function DCItem.consume(itemId, itemType, itemCount, reason)
  itemId = checkstring(itemId)
  itemType = checkstring(itemType)
  itemCount = checkstring(itemCount)
  reason = checkstring(reason)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaItem", "consume", {
      itemId,
      itemType,
      itemCount,
      reason
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaItem", "consume", {
      itemId = itemId,
      itemType = itemType,
      itemCount = itemCount,
      reason = reason
    })
  end
end

function DCItem.consumeInLevel(itemId, itemType, itemCount, reason, levelId)
  itemId = checkstring(itemId)
  itemType = checkstring(itemType)
  itemCount = checkstring(itemCount)
  reason = checkstring(reason)
  levelId = checkstring(levelId)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaItem", "consumeInLevel", {
      itemId,
      itemType,
      itemCount,
      reason,
      levelId
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaItem", "consumeInLevel", {
      itemId = itemId,
      itemType = itemType,
      itemCount = itemCount,
      reason = reason,
      levelId = levelId
    })
  end
end

return DCItem

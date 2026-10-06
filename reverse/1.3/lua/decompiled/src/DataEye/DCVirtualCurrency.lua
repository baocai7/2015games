local DCVirtualCurrency = {}

function DCVirtualCurrency.paymentSuccess(orderId, iapId, currencyAmount, currencyType, paymentType)
  orderId = checkstring(orderId)
  iapId = checkstring(iapId)
  currencyAmount = checkstring(currencyAmount)
  currencyType = checkstring(currencyType)
  paymentType = checkstring(paymentType)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaVirtualCurrency", "paymentSuccess", {
      orderId,
      iapId,
      currencyAmount,
      currencyType,
      paymentType
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaVirtualCurrency", "paymentSuccess", {
      orderId = orderId,
      iapId = iapId,
      orderId = orderId,
      currencyAmount = currencyAmount,
      currencyType = currencyType,
      paymentType = paymentType
    })
  end
end

function DCVirtualCurrency.paymentSuccessInLevel(orderId, iapId, currencyAmount, currencyType, paymentType, levelId)
  orderId = checkstring(orderId)
  iapId = checkstring(iapId)
  currencyAmount = checkstring(currencyAmount)
  currencyType = checkstring(currencyType)
  paymentType = checkstring(paymentType)
  levelId = checkstring(levelId)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaVirtualCurrency", "paymentSuccessInLevel", {
      orderId,
      iapId,
      currencyAmount,
      currencyType,
      paymentType,
      levelId
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaVirtualCurrency", "paymentSuccessInLevel", {
      orderId = orderId,
      iapId = iapId,
      orderId = orderId,
      currencyAmount = currencyAmount,
      currencyType = currencyType,
      paymentType = paymentType,
      levelId = levelId
    })
  end
end

return DCVirtualCurrency

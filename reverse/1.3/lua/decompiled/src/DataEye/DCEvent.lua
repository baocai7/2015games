local DCEvent = {}

function DCEvent.onEventBeforeLogin(eventId, map, duration)
  eventId = checkstring(eventId)
  map = json.encode(map or {})
  duration = checkstring(duration)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaEvent", "onEventBeforeLogin", {
      eventId,
      map,
      duration
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaEvent", "onEventBeforeLogin", {
      eventId = eventId,
      map = map,
      duration = duration
    })
  end
end

function DCEvent.onEventCount(eventId, count)
  eventId = checkstring(eventId)
  count = checkstring(count)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaEvent", "onEventCount", {eventId, count})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaEvent", "onEventCount", {eventId = eventId, count = count})
  end
end

function DCEvent.onEvent(eventId, label, map)
  eventId = checkstring(eventId)
  label = checkstring(label)
  map = json.encode(map or {})
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaEvent", "onEvent", {
      eventId,
      label,
      map
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaEvent", "onEvent", {
      eventId = eventId,
      label = label,
      map = map
    })
  end
end

function DCEvent.onEventDuration(eventId, label, map, duration)
  eventId = checkstring(eventId)
  label = checkstring(label)
  map = json.encode(map or {})
  duration = checkstring(duration)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaEvent", "onEventDuration", {
      eventId,
      label,
      map,
      duration
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaEvent", "onEventDuration", {
      eventId = eventId,
      label = label,
      map = map,
      duration = duration
    })
  end
end

function DCEvent.onEventBegin(eventId, map, flag)
  eventId = checkstring(eventId)
  map = json.encode(map or {})
  flag = checkstring(flag)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaEvent", "onEventBegin", {
      eventId,
      map,
      flag
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaEvent", "onEventBegin", {
      eventId = eventId,
      map = map,
      flag = flag
    })
  end
end

function DCEvent.onEventEnd(eventId, map, flag)
  eventId = checkstring(eventId)
  map = json.encode(map or {})
  flag = checkstring(flag)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaEvent", "onEventEnd", {
      eventId,
      map,
      flag
    })
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaEvent", "onEventEnd", {
      eventId = eventId,
      map = map,
      flag = flag
    })
  end
end

return DCEvent

local DCAccount = {}

function DCAccount.login(accountId, gameServer)
  accountId = checkstring(accountId)
  gameServer = checkstring(gameServer)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAccount", "login", {accountId, gameServer})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAccount", "login", {accountId = accountId, gameServer = gameServer})
  end
end

function DCAccount.logout()
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAccount", "logout", {})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAccount", "logout")
  end
end

function DCAccount.getAccountId()
  if device.platform == "android" then
    local ret, val = luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAccount", "getAccountId", {}, "()Ljava/lang/String;")
    if ret then
      return val
    end
  elseif device.platform == "ios" then
    local ret, val = luaoc.callStaticMethod("DCLuaAccount", "getAccountId")
    if ret then
      return val
    end
  end
end

function DCAccount.setAccountType(accountType)
  accountType = checkstring(accountType)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAccount", "setAccountType", {accountType})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAccount", "setAccountType", {accountType = accountType})
  end
end

function DCAccount.setLevel(level)
  level = checkstring(level)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAccount", "setLevel", {level})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAccount", "setLevel", {level = level})
  end
end

function DCAccount.setGender(gender)
  gender = checkstring(gender)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAccount", "setGender", {gender})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAccount", "setGender", {gender = gender})
  end
end

function DCAccount.setAge(age)
  age = checkstring(age)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAccount", "setAge", {age})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAccount", "setAge", {age = age})
  end
end

function DCAccount.setGameServer(server)
  local gameServer = checkstring(server)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAccount", "setGameServer", {gameServer})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAccount", "setGameServer", {gameServer = gameServer})
  end
end

function DCAccount.addTag(tag, subTag)
  tag = checkstring(tag)
  subTag = checkstring(subTag)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAccount", "addTag", {tag, subTag})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAccount", "addTag", {tag = tag, subTag = subTag})
  end
end

function DCAccount.removeTag(tag, subTag)
  tag = checkstring(tag)
  subTag = checkstring(subTag)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaAccount", "removeTag", {tag, subTag})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaAccount", "removeTag", {tag = tag, subTag = subTag})
  end
end

return DCAccount

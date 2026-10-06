local M = {}
local scheduler = require("framework.scheduler")
local S_GAME_CFG

local function init(parameters)
  local str = cc.FileUtils:getInstance():getStringFromFile("config.json")
  local jt = json.decode(str)
  S_GAME_CFG = jt and jt.game_cfg or CONFIG_GAME
end

init()

function M.gameId()
  return S_GAME_CFG.id
end

function M.gameMode()
  return dy.Common:getGameMode()
end

function M.gameVer()
  local ver = dy.Common:getGameVer()
  if ver == "" then
    ver = S_GAME_CFG.ver
  end
  return ver
end

function M.gameOrigVer()
  local ver = S_GAME_CFG.ver
  return ver
end

local T_CHANNEL = {
  ["000000"] = "DAYU",
  ["000001"] = "APPSTORE",
  ["000003"] = "DOWNJOY",
  ["000014"] = "MEIZU",
  ["000020"] = "OPPO",
  ["000023"] = "QIHOO",
  ["000054"] = "HUAWEI",
  ["000066"] = "XIAOMI",
  ["000108"] = "4399",
  ["000255"] = "UC",
  ["000368"] = "VIVO",
  ["000440"] = "KUGOU",
  ["000466"] = "YOUKU",
  ["000550"] = "QQ",
  ["110000"] = "BAIDU",
  ["160029"] = "XYASSIST",
  ["866001"] = "DAYU_QQ"
}

function M.channelName()
  local channel = ""
  if device.platform == "android" then
    local ret, val = luaj.callStaticMethod("com/dygame/common/DYCommon", "channelName", {""}, "(Ljava/lang/String;)Ljava/lang/String;")
    if ret then
      channel = val
    end
  elseif device.platform == "ios" then
    local ret, val = luaoc.callStaticMethod("DYCommon_iOS", "channelName")
    if ret then
      channel = val
    end
  else
    channel = "000000"
  end
  return channel, T_CHANNEL[checkstring(channel)]
end

function M.subChannelName()
  local subChannel = ""
  if device.platform == "android" then
    local ret, val = luaj.callStaticMethod("com/dygame/common/DYCommon", "subChannelName", {""}, "(Ljava/lang/String;)Ljava/lang/String;")
    if ret then
      subChannel = val
    end
  elseif device.platform == "ios" then
    local ret, val = luaoc.callStaticMethod("DYCommon_iOS", "subChannelName")
    if ret then
      subChannel = val
    end
  else
    subChannel = "000000"
  end
  return subChannel
end

function M.cachePath()
  local path = device.writablePath .. "cache" .. dy.FileIO:seperator()
  if not cc.FileUtils:getInstance():isFileExist(path) then
    dy.FileIO:createDirectory(path)
  end
  return path
end

function M.hotfixPath()
  return dy.Common:getHotfixPath()
end

function M.currentSecond()
  return dy.Common:currentSecond()
end

function M.currentMillisecond()
  return dy.Common:currentMillisecond()
end

function M.compareVer(ver1, ver2)
  return dy.Common:compareVer(ver1, ver2)
end

function M.uniqueID()
  local id
  if device.platform == "android" then
    local ret, val = luaj.callStaticMethod("com/dygame/common/DYCommon", "MAC", {}, "()Ljava/lang/String;")
    if ret then
      id = crypto.md5(checkstring(val))
    end
  elseif device.platform == "ios" then
    local ret, val = luaoc.callStaticMethod("DYCommon_iOS", "MAC")
    if ret then
      id = crypto.md5(checkstring(val))
    end
  end
  if id == nil or id == "" then
    local tmpID = crypto.md5(M.genGUID())
    id = DYStat.getValueStr(DY_KEY.kUniqueID, tmpID)
    DYStat.setValueStr(DY_KEY.kUniqueID, id)
  end
  return id
end

function M.hideLoading()
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYCommon", "hideLoading", {})
  end
end

local function unloadModule()
  local function unrequire(mPath)
    local mName = ""
    
    local pre = string.split(mPath, ".")
    pre = pre[1]
    if pre == "dygame" or pre == "app" or pre == "demo" or pre == "DataEye" then
      local lastSlashIndex = string.find(mPath, ".[^.]*$")
      if lastSlashIndex == nil then
        return
      end
      DDLOG("unrequire " .. mPath)
      mName = string.sub(mPath, lastSlashIndex + 1, string.len(mPath))
      package.loaded[mPath] = nil
      _G[mName] = nil
    end
  end
  
  for k, v in pairs(package.loaded) do
    unrequire(k)
  end
end

function M.restartGame()
  DYKeypadMgr.uninit()
  display.removeUnusedSpriteFrames()
  unloadModule()
  require("app.MyApp").new():run()
end

function M.setGlobalZOrder(node, zOrder)
  if not node then
    return
  end
  node:setGlobalZOrder(zOrder)
  local ct = node:getChildren()
  table.walk(ct, function(v, k)
    if v then
      M.setGlobalZOrder(v, zOrder)
    end
  end)
end

function M.genGUID()
  return dy.Common:genGUID()
end

function M.randomSeed(param)
  if param then
    math.randomseed(checknumber(param))
    return
  end
  local seed = tostring(M.currentMillisecond() % 1000000)
  seed = tonumber(seed:reverse())
  seed = math.floor(seed * 16 * math.random())
  math.randomseed(seed)
end

function M.getTopNode()
  local node = cc.Director:getInstance():getNotificationNode()
  if node == nil then
    node = cc.Node:create()
    cc.Director:getInstance():setNotificationNode(node)
  end
  return node
end

function M.schedule(listener, interval, times)
  times = times or 1
  if times < 0 then
    return scheduler.scheduleGlobal(listener, interval)
  end
  local scheduleID
  
  local function tFuncListener(param)
    times = times - 1
    if times <= 0 then
      M.unschedule(scheduleID)
    end
    if listener then
      listener(param)
    end
  end
  
  scheduleID = scheduler.scheduleGlobal(tFuncListener, interval)
  return scheduleID
end

function M.unschedule(id)
  scheduler.unscheduleGlobal(id)
end

function M.download(url, savePath, unzip, unzipKey, cb)
  local loader
  
  local function tFuncDownload(data)
    data = tolua.cast(data, "dy.DownloadData")
    local event = data:getEvent()
    local totalDown = data:getTotalDown()
    local nowDown = data:getNowDown()
    if event == dy.download.EVENT_ERROR or event == dy.download.EVENT_SUCCESS then
      loader:release()
    end
    if cb then
      cb(event, totalDown, nowDown)
    end
  end
  
  if not unzipKey then
    loader = dy.Download:create(url, savePath, unzip)
  else
    loader = dy.Download:createCustom(url, savePath, unzip, unzipKey)
  end
  ScriptHandlerMgr:getInstance():registerScriptHandler(tolua.cast(loader, "cc.Ref"), tFuncDownload, cc.Handler.CALLFUNC)
  loader:retain()
end

function M.gotoLink(link)
  link = checkstring(link)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYCommon", "gotoLink", {link})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYCommon_iOS", "gotoLink", {link = link})
  else
    DDLOG("Only support in iOS and Android, gotoLink: %s", link)
  end
end

function M.setPvrEncryptionKey(keyPart1, keyPart2, keyPart3, keyPart4)
  if dy.Common.setPvrEncryptionKey then
    return dy.Common:setPvrEncryptionKey(keyPart1, keyPart2, keyPart3, keyPart4)
  end
end

function M.getVersionCode()
  local ver = ""
  if device.platform == "android" then
    local ret, val = luaj.callStaticMethod("com/dygame/common/DYCommon", "getVersionCode", {""}, "(Ljava/lang/String;)Ljava/lang/String;")
    if ret then
      ver = val
    end
  elseif device.platform == "ios" then
    local ret, val = luaoc.callStaticMethod("DYCommon_iOS", "getVersionCode")
    if ret then
      ver = val
    end
  else
    ver = ""
  end
  return ver
end

function M.getVersionName()
  local ver = ""
  if device.platform == "android" then
    local ret, val = luaj.callStaticMethod("com/dygame/common/DYCommon", "getVersionName", {""}, "(Ljava/lang/String;)Ljava/lang/String;")
    if ret then
      ver = val
    end
  elseif device.platform == "ios" then
    local ret, val = luaoc.callStaticMethod("DYCommon_iOS", "getVersionName")
    if ret then
      ver = val
    end
  else
    ver = ""
  end
  return ver
end

local function repaireGlobalForProtectedTable()
  if not _G.__pairs__ then
    _G.__pairs__ = _G.pairs
    
    function _G.pairs(t)
      local metatable = getmetatable(t)
      if metatable and metatable.__protected_flag__ then
        return _G.__pairs__(t.__protected_raw_table__)
      else
        return _G.__pairs__(t)
      end
    end
  end
  if not _G.__ipairs__ then
    _G.__ipairs__ = _G.ipairs
    
    function _G.ipairs(t)
      local metatable = getmetatable(t)
      if metatable and metatable.__protected_flag__ then
        return _G.__ipairs__(t.__protected_raw_table__)
      else
        return _G.__ipairs__(t)
      end
    end
  end
end

local S_PROTECTED_KEY

function M.protectedTable(rt)
  repaireGlobalForProtectedTable()
  if not S_PROTECTED_KEY then
    S_PROTECTED_KEY = math.random(500000000, 599999999)
  end
  local index = {}
  local mt = {
    __index = function(t, k)
      if type(t[index][k]) == "number" and rawget(t.cryp, k) then
        DDLOG("\230\156\137\230\160\161\233\170\140\229\128\188")
        local sign = bit.bxor(t[index][k], S_PROTECTED_KEY)
        if rawget(t.cryp, k) ~= sign then
          assert(false, "\230\149\176\230\141\174\232\162\171\231\175\161\230\148\185")
        end
      end
      return t[index][k]
    end,
    __newindex = function(t, k, v)
      if type(v) == "table" then
        t[index][k] = M.protectedTable(v)
      elseif type(v) == "number" then
        local sign = bit.bxor(v, S_PROTECTED_KEY)
        rawset(t.cryp, k, sign)
        t[index][k] = v
      else
        t[index][k] = v
      end
    end,
    __protected_flag__ = true
  }
  local proxy = {}
  proxy[index] = rt
  proxy.cryp = {}
  proxy.__protected_raw_table__ = rt
  setmetatable(proxy, mt)
  return proxy
end

return M

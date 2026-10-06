local M = {}

function M.genGlobalTag()
  if not M.GLOBAL_TAG then
    M.GLOBAL_TAG = 1
  end
  local tag = string.format("GLOBAL_TAG_%d", M.GLOBAL_TAG)
  M.GLOBAL_TAG = M.GLOBAL_TAG + 1
  return tag
end

function M.reportError(errorLabel, errorLog)
  DYHttpMgr.reportError(errorLabel, errorLog)
end

function M.needShowTencentButton()
  local channel = DYUtils.channelName()
  local subChannel = DYUtils.subChannelName()
  if channel == "300002" and subChannel == "{D74620B0-9C2CD765}" then
    return true
  end
  return false
end

function M.needShowUserCenter()
  local loginMethod = DYMem.get(DY_KEY.kLoginMethod, "")
  return loginMethod == "0"
end

function M.tryQuit(force, listener)
  local function tFuncListener(event)
    local et = json.decode(event)
    
    et.param = json.decode(et.param)
    if et.event == dy.quit.EVENT_CONFIRM then
      DYPushMgr.closeNotice()
      DYCommon.tryQuit(true)
      return
    elseif et.event == dy.quit.EVENT_CANCEL then
      return
    end
    if listener then
      listener(et)
    end
  end
  
  force = force or false
  local strParam = checkstring(force)
  if force then
    cc.Director:getInstance():endToLua()
    if device.platform == "android" then
      luaj.callStaticMethod("com/dygame/common/DYCommon", "tryQuit", {strParam, tFuncListener})
    else
      os.exit(0)
    end
    return
  end
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYCommon", "tryQuit", {strParam, tFuncListener})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYCommon_iOS", "tryQuit", {param = strParam, listener = tFuncListener})
  else
    local fakeEvent = {}
    fakeEvent.event = dy.quit.EVENT_IGNORE
    fakeEvent.param = ""
    
    local function tFuncDelay()
      tFuncListener(json.encode(fakeEvent))
    end
    
    DYUtils.schedule(tFuncDelay, 0, 1)
  end
end

function M.getDataByTag(db, tagKey, tagVal)
  local tData = {}
  if db == nil or type(db) ~= "table" or db.index == nil then
    return tData
  end
  local ti = db.index[tagKey]
  if ti == nil then
    return tData
  end
  local cacheKey = string.format("%s_%s_%s", tostring(db), tostring(tagKey), tostring(tagVal))
  local cacheVal = DYMem.get(cacheKey)
  if cacheVal then
    return cacheVal
  end
  for di = 2, #db do
    local td = db[di]
    if td[ti] and td[ti] == tagVal then
      local data = {}
      for ai = 1, #db[1] do
        data[db[1][ai]] = td[ai]
      end
      table.insert(tData, data)
    end
  end
  DYMem.set(cacheKey, tData)
  return tData
end

function M.getDataByTagEx(db, tagKeys, tagVals)
  local tData = {}
  if db == nil or type(db) ~= "table" or db.index == nil then
    return tData
  end
  local tki = {}
  local count = #tagKeys
  for ci = 1, count do
    table.insert(tki, db.index[tagKeys[ci]])
  end
  if #tki == 0 then
    return tData
  end
  
  local function checkAllItems(item)
    for iki = 1, #tki do
      if tagKeys[iki] and tagVals[iki] and item[tki[iki]] == tagVals[iki] then
      else
        return false
      end
    end
    return true
  end
  
  for di = 2, #db do
    local td = db[di]
    local bFlag = checkAllItems(td)
    if bFlag then
      local data = {}
      for ai = 1, #db[1] do
        data[db[1][ai]] = td[ai]
      end
      table.insert(tData, data)
    end
  end
  return tData
end

return M

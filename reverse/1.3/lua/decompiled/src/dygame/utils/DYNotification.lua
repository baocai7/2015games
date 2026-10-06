local M = {}
local theTargets = {}

local function onNotification(tag, param)
  local name = tag
  local targets = clone(theTargets)
  
  local function getNames(nv, nk)
    if nv and nk == name then
      nv(name, param)
    end
  end
  
  local function getTargets(tv, tk)
    table.walk(tv, getNames)
  end
  
  table.walk(targets, getTargets)
end

function M.postNotification(name, param)
  onNotification(name, param)
end

function M.registerScriptObserver(target, cb, name)
  local tk = target
  local tm = theTargets[tk]
  if tm == nil then
    tm = {}
    theTargets[tk] = tm
  end
  if tm[name] or tm[name] ~= cb then
    tm[name] = cb
  end
end

function M.unregisterScriptObserver(target, name)
  local tk = target
  local tm = theTargets[tk]
  if tm ~= nil and tm[name] ~= nil then
    tm[name] = nil
  end
  if tm ~= nil and table.nums(tm) == 0 then
    theTargets[tk] = nil
  end
end

function M.removeAllObservers(target)
  local tk = target
  theTargets[tk] = nil
end

function M.post(name, param)
  return M.postNotification(name, param)
end

function M.regObserver(target, cb, name)
  return M.registerScriptObserver(target, cb, name)
end

function M.unregObserver(target, name)
  return M.unregisterScriptObserver(target, name)
end

local function test()
end

return M

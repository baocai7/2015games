local M = {}
local S_RES_INFO = {}

function M.loadSheet(resPath)
  local fullPath = resPath
  if fullPath ~= nil then
    local refCount = S_RES_INFO[fullPath]
    if refCount == nil or refCount == 0 then
      refCount = 1
      local cache = cc.SpriteFrameCache:getInstance()
      cache:addSpriteFrames(fullPath)
    else
      refCount = refCount + 1
    end
    S_RES_INFO[fullPath] = refCount
  end
end

function M.unloadSheet(resPath)
  local fullPath = resPath
  if fullPath ~= nil then
    local refCount = S_RES_INFO[fullPath]
    if refCount == nil or refCount < 1 then
    else
      refCount = refCount - 1
      S_RES_INFO[fullPath] = refCount
      if refCount < 1 then
        local cache = cc.SpriteFrameCache:getInstance()
        cache:removeSpriteFramesFromFile(fullPath)
      end
    end
  end
end

local S_FILE_INFO = {}

function M.loadFileInfoAsync(fi, fset, async)
  assert(fset)
  if fset[fi] and 1 <= fset[fi] then
    return
  end
  fset[fi] = 1
  local ref = S_FILE_INFO[fi] or 0
  if ref == 0 then
    local mgr = ccs.ArmatureDataManager:getInstance()
    mgr:addArmatureFileInfoAsync(fi, async)
  end
  ref = ref + 1
  S_FILE_INFO[fi] = ref
end

function M.loadFileInfo(fi, fset)
  assert(fset)
  if fset[fi] and 1 <= fset[fi] then
    return
  end
  fset[fi] = 1
  local ref = S_FILE_INFO[fi] or 0
  if ref == 0 then
    local mgr = ccs.ArmatureDataManager:getInstance()
    mgr:addArmatureFileInfo(fi)
  end
  ref = ref + 1
  S_FILE_INFO[fi] = ref
end

function M.unloadFileInfoEx(fi, fset)
  assert(fset)
  if not fset[fi] or fset[fi] <= 0 then
    return
  end
  fset[fi] = nil
  local ref = S_FILE_INFO[fi] or 0
  ref = ref - 1
  if ref <= 0 then
    ref = 0
    local mgr = ccs.ArmatureDataManager:getInstance()
    mgr:removeArmatureFileInfo(fi)
  end
  S_FILE_INFO[fi] = ref
end

function M.unloadFileInfo(fset)
  local tfset = clone(fset)
  table.walk(fset, function(v, k)
    local fi = k
    if v == 1 then
      DYRes.unloadFileInfoEx(fi, tfset)
    end
  end)
end

return M

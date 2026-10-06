local M = {}
local S_MEM_CACHE = {}

function M.set(k, v)
  S_MEM_CACHE[k] = v
end

function M.get(k, default)
  local v = S_MEM_CACHE[k] or default
  return v
end

function M.clear(k)
  if not k then
    return
  end
  S_MEM_CACHE[k] = nil
end

function M.reset()
  S_MEM_CACHE = {}
end

return M

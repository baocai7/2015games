local DYClass = "ComponetMgr"
local M = {}

function M.ReadUpdateOnly(t)
  local proxy = t or {}
  local mt = {
    __newindex = function(t, k, v)
      error(DYLang.getString("S209", ""), 2)
    end
  }
  setmetatable(proxy, mt)
  return proxy
end

function M.ReadOnlyTable(t)
  local proxy = {}
  local mt = {
    __index = t,
    __newindex = function(t, k, v)
      error("attempt to update a read-only talbe", 2)
    end
  }
  setmetatable(proxy, mt)
  return proxy
end

function M.getMethods(target, srcname)
  local source = require("app.component." .. srcname).new()
  local methods = source.mExportMethod
  for _, key in ipairs(methods) do
    if not target[key] then
      local m = source[key]
      target[key] = function(_, ...)
        return m(source, ...)
      end
    end
  end
end

function M.getTable(target, srcname)
  local source = require("app.component." .. srcname)
  local methods = source.mExportMethod
  for _, key in ipairs(methods) do
    if not target[key] then
      local m = source[key]
      target[key] = clone(m)
    end
  end
end

return M

local M = {}

function M:create()
  local t = {}
  t._et = {}
  
  function t:push(...)
    if (...) then
      local targs = {
        ...
      }
      for _, v in pairs(targs) do
        table.insert(self._et, v)
      end
    end
  end
  
  function t:pop(num)
    local num = num or 1
    local entries = {}
    for i = 1, num do
      if #self._et ~= 0 then
        table.insert(entries, self._et[#self._et])
        table.remove(self._et)
      else
        break
      end
    end
    return unpack(entries)
  end
  
  function t:top()
    return self._et[#self._et]
  end
  
  function t:getn()
    return #self._et
  end
  
  function t:list()
    for i, v in pairs(self._et) do
      print(i, v)
    end
  end
  
  function t:copy()
    local clone = M:create()
    for i, v in pairs(self._et) do
      clone:push(v)
    end
    return clone
  end
  
  return t
end

return M

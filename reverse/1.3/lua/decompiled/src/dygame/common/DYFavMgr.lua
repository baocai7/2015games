local M = {}
local S_MAX = 20

function M.load(key)
  local fav = {}
  fav.key = key
  local keyCount = string.format("%s_%s", key, "COUNT")
  fav.count = DYStat.getValueInt(keyCount, 0)
  if fav.count > S_MAX then
    fav.count = S_MAX
  end
  for i = 1, fav.count do
    local keyItem = string.format("%s_%s_%d", key, "ID", i)
    local item = DYStat.getValueStr(keyItem, "")
    if 0 < string.len(item) then
      table.insert(fav, json.decode(item))
    end
  end
  return fav
end

function M.save(fav)
  if not (fav and fav.key) or #fav < 0 then
    return
  end
  fav.count = #fav
  if fav.count > S_MAX then
    fav.count = S_MAX
  end
  local keyCount = string.format("%s_%s", fav.key, "COUNT")
  DYStat.setValueInt(keyCount, fav.count)
  for i = 1, fav.count do
    local keyItem = string.format("%s_%s_%d", fav.key, "ID", i)
    DYStat.setValueStr(keyItem, json.encode(fav[i]))
  end
end

return M

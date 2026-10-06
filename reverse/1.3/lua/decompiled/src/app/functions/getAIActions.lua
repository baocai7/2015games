local function getDataFromTable(tb)
  local cacheKey = string.format("%s_%s_%s", tostring(tb), tb[1][1], tb[2][1])
  
  local cacheVal = DYMem.get(cacheKey)
  if cacheVal then
    return cacheVal
  end
  local resData = {}
  local keys = tb[1]
  for i = 2, #tb do
    local ti = tb[i]
    local data = {}
    for idx, key in ipairs(keys) do
      data[key] = ti[idx]
    end
    resData[tostring(ti[1])] = data
  end
  DYMem.set(cacheKey, resData)
  return resData
end

function DataUtils.getAction()
  return getDataFromTable(DataRetainer.ACTION)
end

function DataUtils.getActionSeries()
  return getDataFromTable(DataRetainer.ACTION_SERIES)
end

function DataUtils.getStrategy()
  return getDataFromTable(DataRetainer.STRATEGY)
end

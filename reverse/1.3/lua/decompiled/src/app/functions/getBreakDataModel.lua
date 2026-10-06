function DataUtils.getBreakDataModel(buddhaId, breakTimes)
  local baseInfo = DYCommon.getDataByTag(DataRetainer.BREAK_BASE_INFO, "Times", tostring(breakTimes))[1]
  
  if not baseInfo then
    DDERROR("buddha: %d ,breakTimes : %d ,break data error", tonumber(buddhaId), breakTimes)
    return
  end
  local breakData = {}
  breakData.costItem = {
    baseInfo.ItemID
  }
  breakData.costNum = {
    baseInfo.ConsumeNum
  }
  breakData.addType = {}
  breakData.addNum = {}
  if 5 == breakTimes or 7 == breakTimes then
    local breakInfo = DYCommon.getDataByTagEx(DataRetainer.BREAK_ADD_INFO, {"BreakID", "BreakTimes"}, {
      tostring(buddhaId),
      tostring(breakTimes)
    })[1]
    if not breakInfo then
      DDERROR("buddha: %d ,breakTimes : %d ,break data error", tonumber(buddhaId), breakTimes)
      return
    end
    local itemTB = split(breakInfo.Items, ";")
    local numTB = split(breakInfo.Num, ";")
    local addTypeTB = split(breakInfo.AtrriType, ";")
    local addNumTB = split(breakInfo.Param, ";")
    for i = 1, #addTypeTB do
      table.insert(breakData.addType, addTypeTB[i])
      table.insert(breakData.addNum, addNumTB[i])
    end
    table.insertto(breakData.costItem, itemTB)
    table.insertto(breakData.costNum, numTB)
  end
  return breakData
end

function DataUtils.getBreakPropertyAdd(buddhaId, buddhaLevel)
  local breakTimes = math.floor(buddhaLevel / 10)
  local breakData = {
    hit = 0,
    miss = 0,
    crit = 0,
    decrit = 0,
    critHarm = 0,
    decritHarm = 0
  }
  
  local function tFuncAdd(idx, num)
    if 6 == idx then
      breakData.hit = breakData.hit + num
    elseif 7 == idx then
      breakData.miss = breakData.miss + num
    elseif 8 == idx then
      breakData.crit = breakData.crit + num
    elseif 9 == idx then
      breakData.decrit = breakData.decrit + num
    elseif 10 == idx then
      breakData.critHarm = breakData.critHarm + num
    elseif 11 == idx then
      breakData.decritHarm = breakData.decritHarm + num
    end
  end
  
  if 5 <= breakTimes then
    local breakInfo = DYCommon.getDataByTagEx(DataRetainer.BREAK_ADD_INFO, {"BreakID", "BreakTimes"}, {
      tostring(buddhaId),
      "5"
    })[1]
    if not breakInfo then
      DDERROR("buddha: %d ,breakTimes : %d ,break data error", tonumber(buddhaId), breakTimes)
      return
    end
    local addTypeTB = split(breakInfo.AtrriType, ";")
    local addNumTB = split(breakInfo.Param, ";")
    for i = 1, #addTypeTB do
      local addType = tonumber(addTypeTB[i])
      local addNum = tonumber(addNumTB[i])
      tFuncAdd(addType, addNum)
    end
  end
  if 7 <= breakTimes then
    local breakInfo = DYCommon.getDataByTagEx(DataRetainer.BREAK_ADD_INFO, {"BreakID", "BreakTimes"}, {
      tostring(buddhaId),
      "7"
    })[1]
    if not breakInfo then
      DDERROR("buddha: %d ,breakTimes : %d ,break data error", tonumber(buddhaId), breakTimes)
      return
    end
    local addTypeTB = split(breakInfo.AtrriType, ";")
    local addNumTB = split(breakInfo.Param, ";")
    for i = 1, #addTypeTB do
      local addType = tonumber(addTypeTB[i])
      local addNum = tonumber(addNumTB[i])
      tFuncAdd(addType, addNum)
    end
  end
  return breakData
end

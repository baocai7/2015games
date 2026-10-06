function DataUtils.getBuddhaFateModel(fateId, buddhaId)
  local fateInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_FATE_INFO, "fateId", tostring(fateId))[1]
  
  if not fateInfo then
    DDERROR("fate id : %d with error data", tonumber(fateId))
    return
  end
  local LEVEL = {
    "\226\133\160",
    "\226\133\161",
    "\226\133\162",
    "\226\133\163",
    "\226\133\164",
    "\226\133\165"
  }
  local fateData = {}
  fateData.fateId = tonumber(fateInfo.fateId)
  fateData.fateType = tonumber(fateInfo.fateType)
  fateData.cond = split(fateInfo.cond, ";")
  fateData.fataDesc = ""
  fateData.isFateActive = false
  local minStar = 5
  for k, v in pairs(fateData.cond) do
    local info = DataUtils.getBuddhaBaseData(v)
    minStar = minStar < info.starLevel and minStar or info.starLevel
  end
  if 1 == fateData.fateType then
    local tb1 = DataUtils.getBuddhaTableOnTeam()
    local tb2 = DataUtils.getBuddhaTableOnAssist()
    table.insertto(tb1, tb2)
    local buddhaTable = table.unique(tb1)
    local idx = table.indexof(buddhaTable, tostring(buddhaId))
    if idx then
      local isActive = true
      for k, v in pairs(fateData.cond) do
        local index = table.indexof(buddhaTable, tostring(v))
        if not index then
          isActive = false
          break
        end
      end
      fateData.isFateActive = isActive
    else
      fateData.isFateActive = false
    end
  end
  fateData.fateName = fateInfo.fateName .. LEVEL[minStar + 1]
  local str1 = ""
  if 1 == fateData.fateType then
    str1 = DYLang.getString("S210", "")
    local index = table.indexof(fateData.cond, tostring(buddhaId))
    if index then
      table.removebyvalue(fateData.cond, tostring(buddhaId), true)
    end
    local nameTable = {}
    for i = 1, #fateData.cond do
      local buddhaModelBaseInfo = DataUtils.getBuddhaModelBaseInfo(tostring(fateData.cond[i]))
      local buddhaName = buddhaModelBaseInfo.name
      if i == #fateData.cond then
        str1 = str1 .. buddhaName
      else
        str1 = str1 .. buddhaName .. ","
      end
    end
    str1 = str1 .. DYLang.getString("S211", "")
  elseif 2 == fateData.fateType then
    str1 = DYLang.getString("S212", "")
  elseif 3 == fateData.fateType then
    str1 = DYLang.getString("S212", "")
  end
  local addNum = split(fateInfo.addNum, ";")
  fateData.addNum = split(addNum[minStar + 1], ",")
  fateData.addType = split(fateInfo.addType, ";")
  local str2 = string.format(fateInfo.addDesc, unpack(fateData.addNum))
  fateData.fataDesc = str1 .. str2
  return fateData
end

function DataUtils.getFateInfoForAssist(buddhaId)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(buddhaId))[1]
  if not buddhaInfo then
    DDLOG("buddhaInfo index : %d with error data", tonumber(index))
    return
  end
  local fateIds = split(buddhaInfo.fateId, ";")
  local LEVEL = {
    "\226\133\160",
    "\226\133\161",
    "\226\133\162",
    "\226\133\163",
    "\226\133\164",
    "\226\133\165"
  }
  local tb1 = DataUtils.getBuddhaTableOnTeam()
  local tb2 = DataUtils.getBuddhaTableOnAssist()
  table.insertto(tb1, tb2)
  local buddhaTable = table.unique(tb1)
  local tempTable = {}
  for i = 1, #fateIds do
    local fateId = fateIds[i]
    local fateInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_FATE_INFO, "fateId", tostring(fateId))[1]
    if not fateInfo then
      DDERROR("fate id : %d with error data", tonumber(fateId))
      return
    end
    local fateData = {}
    fateData.fateType = tonumber(fateInfo.fateType)
    if 1 == fateData.fateType then
      fateData.buddhaIds = split(fateInfo.cond, ";")
      fateData.fataDesc = ""
      fateData.isFateActive = false
      local minStar = 5
      for k, v in pairs(fateData.buddhaIds) do
        local info = DataUtils.getBuddhaBaseData(v)
        minStar = minStar < info.starLevel and minStar or info.starLevel
      end
      local index = table.indexof(fateData.buddhaIds, tostring(buddhaId))
      if index then
        table.removebyvalue(fateData.buddhaIds, tostring(buddhaId), true)
      end
      local isActive = true
      for k, v in pairs(fateData.buddhaIds) do
        local index = table.indexof(buddhaTable, tostring(v))
        if not index then
          isActive = false
          break
        end
      end
      fateData.isFateActive = isActive
      fateData.fateName = fateInfo.fateName .. LEVEL[minStar + 1]
      local addNum = split(fateInfo.addNum, ";")
      fateData.addNum = split(addNum[minStar + 1], ",")
      fateData.addType = split(fateInfo.addType, ";")
      fateData.fataDesc = string.format(fateInfo.addDesc, unpack(fateData.addNum))
    end
    table.insert(tempTable, fateData)
  end
  return tempTable
end

function DataUtils.getFatePropertyAdd(buddhaId, fateIds, teamInfo, npcInfo)
  local tb1 = DataUtils.getBuddhaTableOnTeam()
  local tb2 = DataUtils.getBuddhaTableOnAssist()
  if (6 == GameManager.MODE or 9 == GameManager.MODE) and teamInfo then
    tb1 = clone(teamInfo.mainTeam)
    tb2 = clone(teamInfo.assistTeam)
  end
  table.insertto(tb1, tb2)
  local buddhaTable = table.unique(tb1)
  local tempTable1 = {
    life = 0,
    atk = 0,
    phyDef = 0,
    magDef = 0
  }
  local tempTable2 = {
    life = 0,
    atk = 0,
    phyDef = 0,
    magDef = 0,
    hit = 0,
    miss = 0,
    crit = 0,
    decrit = 0,
    critHarm = 0,
    decritHarm = 0,
    allPro = 0
  }
  if 5 == GameManager.MODE or 8 == GameManager.MODE then
    return tempTable1, tempTable2
  end
  local idx = table.indexof(buddhaTable, tostring(buddhaId))
  if not idx then
    return tempTable1, tempTable2
  end
  for i = 1, #fateIds do
    local fateId = fateIds[i]
    local fateInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_FATE_INFO, "fateId", tostring(fateId))[1]
    if not fateInfo then
      DDERROR("fate id : %d with error data", tonumber(fateId))
      return
    end
    local fateType = tonumber(fateInfo.fateType)
    if 1 == fateType then
      local buddhaIds = split(fateInfo.cond, ";")
      local isActive = true
      local minStar = 5
      for k, v in pairs(buddhaIds) do
        local currStar = 0
        if npcInfo and npcInfo[tostring(v)] then
          currStar = npcInfo[tostring(v)].realStar or npcInfo[buddhaId].star
        else
          local info = DataUtils.getBuddhaBaseData(v)
          currStar = info.starLevel
        end
        minStar = minStar < currStar and minStar or currStar
      end
      for k, v in pairs(buddhaIds) do
        local index = table.indexof(buddhaTable, tostring(v))
        if not index then
          isActive = false
          break
        end
      end
      if isActive and #buddhaIds ~= 0 then
        local num = split(fateInfo.addNum, ";")
        local addNum = split(num[minStar + 1], ",")
        local addType = split(fateInfo.addType, ";")
        for m = 1, #addType do
          local currType = tonumber(addType[m])
          local addNum = tonumber(addNum[m])
          if 1 == currType then
            tempTable1.life = tempTable1.life + addNum
          elseif 2 == currType then
            tempTable1.atk = tempTable1.atk + addNum
          elseif 3 == currType then
            tempTable1.phyDef = tempTable1.phyDef + addNum
          elseif 4 == currType then
            tempTable1.magDef = tempTable1.magDef + addNum
          elseif 5 == currType then
            tempTable2.allPro = tempTable2.allPro + addNum
          elseif 6 == currType then
            tempTable2.hit = tempTable2.hit + addNum
          elseif 7 == currType then
            tempTable2.miss = tempTable2.miss + addNum
          elseif 8 == currType then
            tempTable2.crit = tempTable2.crit + addNum
          elseif 9 == currType then
            tempTable2.decrit = tempTable2.decrit + addNum
          elseif 10 == currType then
            tempTable2.critHarm = tempTable2.critHarm + addNum
          elseif 11 == currType then
            tempTable2.decritHarm = tempTable2.decritHarm + addNum
          elseif 12 == currType then
            tempTable2.life = tempTable2.life + addNum
          elseif 13 == currType then
            tempTable2.atk = tempTable2.atk + addNum
          elseif 14 == currType then
            tempTable2.phyDef = tempTable2.phyDef + addNum
          elseif 15 == currType then
            tempTable2.magDef = tempTable2.magDef + addNum
          end
        end
      end
    end
  end
  return tempTable1, tempTable2
end

function DataUtils.getFateActiveNum(buddhaId)
  local buddhaInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_INFO, "buddhaID", tostring(buddhaId))[1]
  if not buddhaInfo then
    DDLOG("buddhaInfo index : %d with error data", tonumber(index))
    return
  end
  local fateIds = split(buddhaInfo.fateId, ";")
  local tb1 = DataUtils.getBuddhaTableOnTeam()
  local tb2 = DataUtils.getBuddhaTableOnAssist()
  table.insertto(tb1, tb2)
  local buddhaTable = table.unique(tb1)
  local activeNum = 0
  for i = 1, #fateIds do
    local fateId = fateIds[i]
    local fateInfo = DYCommon.getDataByTag(DataRetainer.BUDDHA_FATE_INFO, "fateId", tostring(fateId))[1]
    if not fateInfo then
      DDERROR("fate id : %d with error data", tonumber(fateId))
      return
    end
    local fateType = tonumber(fateInfo.fateType)
    if 1 == fateType then
      local buddhaIds = split(fateInfo.cond, ";")
      local isActive = true
      for k, v in pairs(buddhaIds) do
        local index = table.indexof(buddhaTable, tostring(v))
        if not index then
          isActive = false
          break
        end
      end
      if isActive then
        activeNum = activeNum + 1
      end
    end
  end
  return activeNum
end

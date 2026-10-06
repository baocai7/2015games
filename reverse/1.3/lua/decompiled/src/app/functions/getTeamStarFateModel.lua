function DataUtils.getTeamStarFateModel(fateId)
  local starInfo = DYCommon.getDataByTag(DataRetainer.TEAM_STAR_INFO, "Id", tostring(fateId))[1]
  
  if not starInfo then
    DDERROR("team star : %d with error data", tonumber(fateId))
    return
  end
  local fateData = {}
  fateData.fateId = tonumber(starInfo.Id)
  fateData.addType = split(starInfo.addType, ";")
  fateData.addNum = split(starInfo.addNum, ";")
  local numList = {}
  for i = 1, #fateData.addNum do
    local num = tonumber(fateData.addNum[i])
    table.insert(numList, num)
  end
  fateData.fataDesc = string.format(starInfo.addDesc, unpack(numList))
  return fateData
end

function DataUtils.getTeamStarFateAdd(buddhaId, teamInfo, npcInfo)
  local fateAdd = {
    life = 0,
    attack = 0,
    phyDef = 0,
    magDef = 0
  }
  local tb
  if (6 == GameManager.MODE or 9 == GameManager.MODE) and teamInfo then
    tb = clone(teamInfo.mainTeam)
  elseif teamInfo then
    tb = teamInfo
  else
    tb = DataUtils.getBuddhaTableOnTeam()
  end
  local index = table.indexof(tb, tostring(buddhaId))
  if #tb < 6 or not index then
    return fateAdd
  end
  local starList = {}
  if npcInfo then
    for i = 1, 6 do
      local buddhaId = tostring(tb[i])
      local starLevel = npcInfo[buddhaId].realStar or npcInfo[buddhaId].star
      table.insert(starList, starLevel)
    end
  else
    for i = 1, 6 do
      local buddhaId = tonumber(tb[i])
      local starLevel = CloudData.NPC_INFO[buddhaId].star or 0
      table.insert(starList, starLevel)
    end
  end
  
  local function tFuncAdd(idx, num)
    if 1 == idx then
      fateAdd.life = fateAdd.life + num
    elseif 2 == idx then
      fateAdd.attack = fateAdd.attack + num
    elseif 3 == idx then
      fateAdd.phyDef = fateAdd.phyDef + num
    elseif 4 == idx then
      fateAdd.magDef = fateAdd.magDef + num
    end
  end
  
  for i = 1, 5 do
    if i <= starList[1] and i <= starList[2] and i <= starList[3] and i <= starList[4] and i <= starList[5] and i <= starList[6] then
      local starInfo = DYCommon.getDataByTag(DataRetainer.TEAM_STAR_INFO, "Id", tostring(i))[1]
      local addType = split(starInfo.addType, ";")
      local addNum = split(starInfo.addNum, ";")
      for j = 1, #addType do
        local t = tonumber(addType[j])
        local n = tonumber(addNum[j])
        tFuncAdd(t, n)
      end
    end
  end
  return fateAdd
end

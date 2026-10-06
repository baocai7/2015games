function DataUtils.getPvpOlFightReward(id)
  local actualInfo = DYCommon.getDataByTag(DataRetainer.PVP_OL_FIGHT_AWARD, "id", tostring(id))[1]
  
  if not actualInfo then
    DDERROR("actual id : %d with error data", tonumber(id))
    return
  end
  local actualData = {}
  actualData.actualId = tonumber(actualInfo.id)
  actualData.grade = tonumber(actualInfo.grade)
  actualData.level = tonumber(actualInfo.level)
  actualData.credit = tonumber(actualInfo.credit)
  actualData.winNum = tonumber(actualInfo.win)
  actualData.loseNum = tonumber(actualInfo.lose)
  return actualData
end

function DataUtils.getSeasonHonorAwardData(grade)
  local actualInfo = DYCommon.getDataByTagEx(DataRetainer.PVP_OL_FIGHT_AWARD, {"grade", "level"}, {
    tostring(grade),
    "1"
  })[1]
  actualInfo = actualInfo or DYCommon.getDataByTag(DataRetainer.PVP_OL_FIGHT_AWARD, "grade", tostring(grade))[1]
  if not actualInfo then
    DDERROR("actual grade : %d with error data", tonumber(grade))
    return
  end
  local actualData = {}
  actualData.actualId = tonumber(actualInfo.id)
  actualData.grade = tonumber(actualInfo.grade)
  actualData.credit = tonumber(actualInfo.credit)
  actualData.itemId = tonumber(actualInfo.awarditem)
  actualData.itemNum = tonumber(actualInfo.awardnum)
  return actualData
end

function DataUtils.getPVPActualModel(id)
  local actualInfo = DYCommon.getDataByTag(DataRetainer.PVP_OL_ACTUAL_INFO, "id", tostring(id))[1]
  if not actualInfo then
    DDERROR("actual id : %d with error data", tonumber(id))
    return
  end
  local actualData = {}
  actualData.actualId = tonumber(actualInfo.id)
  actualData.minNum = tonumber(actualInfo.min)
  actualData.maxNum = tonumber(actualInfo.max)
  actualData.itemIds = split(actualInfo.itemid, ";")
  actualData.itemNums = split(actualInfo.num, ";")
  if actualData.minNum < 4 then
    actualData.honorIcon = "pvp_ol/gi_rank" .. actualData.minNum .. ".png"
  end
  return actualData
end

function DataUtils.getPVPGradeInfo(score)
  local totalNum = #DataRetainer.PVP_OL_FIGHT_AWARD - 1
  local pData = {
    grade = 0,
    level = 0,
    leftScore = 0,
    countScore = 0
  }
  for i = 1, totalNum - 1 do
    local info1 = DYCommon.getDataByTag(DataRetainer.PVP_OL_FIGHT_AWARD, "id", tostring(i))[1]
    local info2 = DYCommon.getDataByTag(DataRetainer.PVP_OL_FIGHT_AWARD, "id", tostring(i + 1))[1]
    local credit1 = tonumber(info1.credit)
    local credit2 = tonumber(info2.credit)
    if score >= credit1 and score < credit2 then
      pData.grade = tonumber(info1.grade)
      pData.level = tonumber(info1.level)
      pData.leftScore = score - credit1
      pData.countScore = credit2 - credit1
      break
    elseif i == totalNum - 1 then
      pData.grade = tonumber(info2.grade)
      pData.level = tonumber(info2.level)
      pData.leftScore = 0
      pData.countScore = credit2 - credit1
      break
    end
  end
  return pData
end

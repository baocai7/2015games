local posInfo = {
  [1] = {x = 304, y = 606},
  [2] = {x = 626, y = 539},
  [3] = {x = 424, y = 569},
  [4] = {x = 214, y = 537},
  [5] = {x = 563, y = 582},
  [6] = {x = 202, y = 451},
  [7] = {x = 329, y = 423},
  [8] = {x = 415, y = 406},
  [9] = {x = 465, y = 408},
  [10] = {x = 510, y = 354},
  [11] = {x = 604, y = 414},
  [12] = {x = 391, y = 354},
  [13] = {x = 224, y = 325},
  [14] = {x = 378, y = 259},
  [15] = {x = 635, y = 305},
  [16] = {x = 589, y = 206},
  [17] = {x = 212, y = 192},
  [18] = {x = 182, y = 181}
}

function DataUtils.getPatrolTaskModel(id)
  local taskInfo = DYCommon.getDataByTag(DataRetainer.PATROL, "id", checkstring(id))[1]
  if not taskInfo then
    DDERROR("patrol task id : %d with error data", checknumber(id))
    return
  end
  local taskData = {}
  taskData.id = checknumber(taskInfo.id)
  taskData.quality = checknumber(taskInfo.quality)
  taskData.name = checkstring(taskInfo.name)
  taskData.desc = checkstring(taskInfo.desc)
  taskData.location = checknumber(taskInfo.location)
  taskData.timeCost = checknumber(taskInfo.timeCost)
  taskData.timeStr = taskData.timeCost .. DYLang.getString("TIME_HOUR", "")
  taskData.attribute = taskInfo.attribute
  taskData.baseAward = split(taskInfo.baseAward, ";") or {}
  taskData.baseAwardNum = split(taskInfo.baseAwardNum, ";") or {}
  taskData.extraAwardCon = split(taskInfo.extraAwardCondition, ";") or {}
  taskData.extraAward = split(taskInfo.extraAwardContent, ";") or {}
  taskData.extraAwardNum = split(taskInfo.extraAwardNum, ";") or {}
  taskData.tag = split(taskInfo.tag, ";") or {}
  taskData.cost = checknumber(taskInfo.cost)
  local pos = posInfo[taskData.location] or {}
  taskData.x = checknumber(pos.x)
  taskData.y = checknumber(pos.y)
  return taskData
end

function DataUtils.getPatrolTaskUnlocked(index)
  local unionLv = checknumber(CloudData.UNION_INFO.level)
  if index == 2 and unionLv < 5 or index == 3 and unionLv < 8 or index == 4 and CloudData.VIP_LEVEL < 12 then
    return false
  else
    return true
  end
end

function DataUtils.getPatrolTaskLockedTip(index)
  local info = {
    [1] = "",
    [2] = string.format(DYLang.getString("STR_UNION_UNLOCK_LV", ""), 5),
    [3] = string.format(DYLang.getString("STR_UNION_UNLOCK_LV", ""), 8),
    [4] = string.format(DYLang.getString("STR_VIP_UNLOCK_LV", ""), 12)
  }
  return checkstring(info[index])
end

function DataUtils.getPatrolGoal(index)
  local info = DYCommon.getDataByTag(DataRetainer.PATROL_GOAL, "id", checkstring(index))[1]
  if not info then
    DDERROR("patrol goal id : %d with error data", checknumber(index))
    return
  end
  local goalData = {}
  goalData.id = checknumber(info.id)
  local itemId = split(info.itemId, ";") or {}
  local itemNum = split(info.itemNum, ";") or {}
  local extraId = split(info.extraId, ";") or {}
  local extraNum = split(info.extraNum, ";") or {}
  goalData.item = {}
  for i = 1, #itemId do
    if checknumber(itemId[i]) > 0 then
      table.insert(goalData.item, {
        id = checknumber(itemId[i]),
        num = checknumber(itemNum[i])
      })
    end
  end
  goalData.extra = {}
  for i = 1, #extraId do
    if checknumber(extraId[i]) > 0 then
      table.insert(goalData.extra, {
        id = checknumber(extraId[i]),
        num = checknumber(extraNum[i])
      })
    end
  end
  goalData.integral = checknumber(info.integral)
  local info = DYCommon.getDataByTag(DataRetainer.PATROL_GOAL, "id", checkstring(index + 1))[1]
  if info then
    goalData.integral = checknumber(info.integral)
  else
    goalData.integral = 0
  end
  return goalData
end

function DataUtils.getMaxPatrolGoal()
  local num = DataUtils.getPatrolGoalSum()
  local info = DYCommon.getDataByTag(DataRetainer.PATROL_GOAL, "id", checkstring(num))[1]
  if not info then
    return 10000
  end
  return checknumber(info.integral)
end

function DataUtils.getPatrolGoalSum()
  return #DataRetainer.PATROL_GOAL - 1
end

function DataUtils.timeToStr(t, dayShow, secondShow)
  local time = checknumber(t)
  local dayAdd = checknumber(dayShow)
  local secondAdd = checknumber(secondShow)
  local day = math.floor(time / 86400)
  local hour
  if dayAdd == 0 then
    hour = math.floor(time / 3600)
  else
    hour = math.floor(time / 3600) % 24
  end
  time = time % 3600
  local minute = math.floor(time / 60)
  local second = math.floor(time % 60)
  local str = ""
  str = 0 < hour and str .. hour .. DYLang.getString("TIME_HOUR", "") or str
  str = 0 < minute and str .. minute .. DYLang.getString("TIME_MINUTE", "") or str
  if dayShow ~= 0 then
    if 0 < day then
      str = day .. DYLang.getString("TIME_DAY", "") .. str or str
    end
  else
    str = secondShow ~= 0 and 0 < second and str .. second .. DYLang.getString("TIME_SECOND", "") or str
  end
  if str == "" then
    str = "0" .. DYLang.getString("TIME_MINUTE", "")
  end
  return str
end

function DataUtils.timeStrLeast(t)
  local time = checknumber(t)
  local day = math.floor(time / 86400)
  if 0 < day then
    return day .. DYLang.getString("TIME_DAY", "")
  end
  local hour = math.floor(time / 3600)
  if 0 < hour then
    return hour .. DYLang.getString("TIME_HOUR", "")
  end
  local minute = math.floor(time / 60)
  if 0 < minute then
    return minute .. DYLang.getString("TIME_MINUTE", "")
  end
  local second = math.floor(time % 60)
  return second .. DYLang.getString("TIME_SECOND", "")
end

function DataUtils.timeToHSM(t)
  local time = checknumber(t)
  local hour = math.floor(time / 3600)
  time = time % 3600
  local minute = math.floor(time / 60)
  local second = math.floor(time % 60)
  return hour, minute, second
end

function DataUtils.timeStrHSM(t)
  local time = checknumber(t)
  local hour = math.floor(time / 3600)
  time = time % 3600
  local minute = math.floor(time / 60)
  local second = math.floor(time % 60)
  return string.format("%02d:%02d:%02d", hour, minute, second)
end

function DataUtils.getKeyIndex(array, key, value)
  if not (array and #array ~= 0 and key) or not value then
    return 0
  end
  for i = 1, #array do
    if checkstring(array[i][checkstring(key)]) == checkstring(value) then
      return i
    end
  end
  return 0
end

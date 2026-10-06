local function getCurrTaskNum(taskType, param)
  local tFunc = {
    [1] = function()
      return CloudData.VIP_LEVEL
    end,
    [2] = function()
      return CloudData.MONEY
    end,
    [3] = function()
      if CloudData.PAY_MAX >= param then
        return 1
      else
        return 0
      end
    end,
    [4] = function()
      return CloudData.SIGN_COUNT
    end,
    [5] = function()
      return CloudData.COUNT_CE
    end,
    [6] = function()
      return CloudData.USER_LEVEL
    end,
    [7] = function()
      return CloudData.DAY_PAY
    end,
    [8] = function()
      return 0
    end,
    [9] = function()
      if CloudData.NPC_INFO[param] and CloudData.NPC_INFO[param].status > 0 then
        return 1
      else
        return 0
      end
    end,
    [10] = function()
      return CloudData.MAIN_STAGE_PROGRESS
    end,
    [11] = function()
      return CloudData.PURGATORY_STAGE_PROGRESS
    end,
    [12] = function()
      for k, v in pairs(CloudData.CIMELIA_LIST) do
        if v.quality >= param then
          return 1
        end
      end
      return 0
    end,
    [13] = function()
      local maxLevel = 0
      for k, v in pairs(CloudData.NPC_INFO) do
        local level = v.level
        if maxLevel < level then
          maxLevel = level
        end
      end
      return maxLevel
    end,
    [14] = function()
      local maxStar = 0
      for k, v in pairs(CloudData.NPC_INFO) do
        local star = v.star
        if maxStar < star then
          maxStar = star
        end
      end
      return maxStar
    end,
    [15] = function()
      return CloudData.PVP_WIN_TIMES
    end,
    [16] = function()
      return 0
    end,
    [17] = function()
      return 0
    end,
    [18] = function()
      return CloudData.WEEKEND_PAY
    end,
    [19] = function()
      return CloudData.DAILY_PAY_LIST[tostring(param)] or 0
    end
  }
  return tFunc[taskType]()
end

local function getSevenTaskCurrNum(taskType)
  local tFunc = {
    [1] = CloudData.MAIN_STAGE_PROGRESS,
    [2] = CloudData.USER_LEVEL,
    [3] = CloudData.PAY_MAX,
    [4] = CloudData.SIGN_COUNT,
    [5] = CloudData.COUNT_CE,
    [6] = CloudData.USER_LEVEL,
    [7] = CloudData.USER_LEVEL
  }
  return tFunc[taskType]
end

function DataUtils.getActivityModel(id)
  local activityInfo = DYCommon.getDataByTag(DataRetainer.ACTIVITY_INFO, "id", tostring(id))[1]
  if not activityInfo then
    DDERROR("activity id : %d with error data", tonumber(id))
    return
  end
  local activityData = {}
  activityData.priority = tonumber(activityInfo.index)
  activityData.aName = activityInfo.name
  return activityData
end

function DataUtils.getActivityTaskInfo1(taskId)
  local info = DYCommon.getDataByTag(DataRetainer.ACTIVITY_TASK1, "id", tostring(taskId))[1]
  if not info then
    DDTRACE("DataUtils.getActivityTaskInfo1", string.format("activity taskId : %s with error data", checkstring(taskId)))
    return
  end
  local taskData = {}
  taskData.desc = info.taskDescription
  taskData.type = tonumber(info.type)
  taskData.loadTo = tonumber(info.loadTo)
  taskData.taskNum = tonumber(info.num)
  taskData.rewardType = split(info.rewardType, ";") or {}
  taskData.rewardNum = split(info.rewardNum, ";") or {}
  taskData.param1 = info.param1
  taskData.param2 = info.param2
  return taskData
end

function DataUtils.getActivityTaskInfo2(taskId)
  local info = DYCommon.getDataByTag(DataRetainer.ACTIVITY_TASK2, "id", tostring(taskId))[1]
  if not info then
    DDERROR("activity taskId : %d with error data", tonumber(taskId))
    return
  end
  local taskData = {}
  taskData.taskCon = split(info.buyCon, ";")
  taskData.thingId = tonumber(info.thingId)
  taskData.thingNum = tonumber(info.thingNum)
  taskData.limitTimes = tonumber(info.limitTimes)
  taskData.rewardType = split(info.rewardType, ";") or {}
  taskData.rewardNum = split(info.rewardNum, ";") or {}
  taskData.currNum = CloudData.GAME_ITEM_INFO[tostring(taskData.thingId)]
  return taskData
end

function DataUtils.getSevenActivityModel(id)
  local activityInfo = DYCommon.getDataByTag(DataRetainer.ACTIVITY_SEVEN, "id", tostring(id))[1]
  if not activityInfo then
    DDERROR("seven activity id : %d with error data", tonumber(id))
    return
  end
  local activityData = {}
  activityData.activeId = tonumber(activityInfo.id)
  activityData.aName = activityInfo.name
  activityData.aGroup = split(activityInfo.group, ";")
  activityData.taskIds = {}
  activityData.buddhaId = tonumber(activityInfo.buddhaid)
  local taskIds = split(activityInfo.taskIds, ";") or {}
  for i = 1, #taskIds do
    local tb = split(taskIds[i], ",")
    table.insert(activityData.taskIds, tb)
  end
  return activityData
end

function DataUtils.getSevenActivityTask(taskId)
  local info = DYCommon.getDataByTag(DataRetainer.SEVEN_TASK, "id", tostring(taskId))[1]
  if not info then
    DDERROR("seven activity taskId : %d with error data", tonumber(taskId))
    return
  end
  local taskData = {}
  taskData.desc = info.description
  taskData.type = tonumber(info.type)
  taskData.loadTo = tonumber(info.loadTo)
  taskData.descNum = tonumber(info.param)
  taskData.taskNum = tonumber(info.Num)
  taskData.rewardType = split(info.rewardType, ";") or {}
  taskData.rewardNum = split(info.rewardNum, ";") or {}
  taskData.currNum = getSevenTaskCurrNum(taskData.type)
  return taskData
end

function DataUtils.getDailyTaskModel(id)
  local taskInfo = DYCommon.getDataByTag(DataRetainer.DAILYTASK_INFO, "id", tostring(id))[1]
  
  if not taskInfo then
    DDERROR("task_daily Info index : %d with error data", tonumber(id))
    return
  end
  local taskData = {}
  taskData.id = tonumber(taskInfo.id)
  taskData.vitality = tonumber(taskInfo.vitality)
  taskData.targetValue = tonumber(taskInfo.num)
  taskData.description = taskInfo.description
  taskData.fromNum = tonumber(taskInfo.from)
  taskData.text = taskInfo.text
  taskData.peachCost = tonumber(taskInfo.peachConsume)
  taskData.isOpen = 0
  taskData.state = 0
  local curData = tonumber(CloudData.DAILY_TASK_INFO.done[tostring(id)]) or 0
  if curData == -1 then
    curData = taskData.targetValue
    taskData.state = -1
  elseif curData >= taskData.targetValue then
    taskData.state = 1
  end
  taskData.curValue = curData
  taskData.reward = {}
  taskData.rewardDesc = ""
  for i = 1, 2 do
    if 0 < tonumber(taskInfo["reward" .. i]) then
      local info = {}
      info.id = tonumber(taskInfo["reward" .. i])
      info.num = tonumber(taskInfo["count" .. i])
      table.insert(taskData.reward, info)
      local itemInfo = DYCommon.getDataByTag(DataRetainer.GAME_ITEM_INFO, "id", tostring(info.id))[1]
      if not itemInfo then
        DDERROR("itemInfo index : %d with error data", info.id)
      else
        local name = itemInfo.name
        taskData.rewardDesc = taskData.rewardDesc .. name .. " X " .. info.num .. "    "
      end
    end
  end
  local level = tonumber(CloudData.USER_LEVEL)
  local unlockLevel = 0
  if taskData.fromNum == 4 then
    unlockLevel = tonumber(Const.FUNC_UNLOCK.summon)
  elseif taskData.fromNum == 6 then
    unlockLevel = Const.FUNC_UNLOCK.patrol
  elseif taskData.fromNum == 9 then
    unlockLevel = Const.FUNC_UNLOCK.purgatory
  elseif taskData.fromNum == 10 then
    unlockLevel = Const.FUNC_UNLOCK.cimelia
  elseif taskData.fromNum == 12 then
    unlockLevel = Const.FUNC_UNLOCK.buddha
  end
  if level >= unlockLevel then
    taskData.isOpen = 1
  end
  return taskData
end

function DataUtils.IsTaskActive(id)
  local cur = tonumber(CloudData.DAILY_TASK_INFO.done[tostring(id)])
  if cur < 0 then
    return false
  end
  local taskInfo = DYCommon.getDataByTag(DataRetainer.DAILYTASK_INFO, "id", tostring(id))[1]
  if not taskInfo then
    DDERROR("task_daily Info index : %d with error data", tonumber(id))
    return false
  end
  local targetValue = tonumber(taskInfo.num)
  if cur >= targetValue then
    return true
  else
    return false
  end
end

function DataUtils.IsBoxActive(id)
  local boxInfo = DYCommon.getDataByTag(DataRetainer.TASK_BOX_INFO, "id", tostring(id))[1]
  if not boxInfo then
    DDERROR("task_box Info index : %d with error data", tonumber(id))
    return false
  else
    local vitality = tonumber(CloudData.DAILY_TASK_INFO.vitality)
    local state = tonumber(CloudData.DAILY_TASK_INFO.box[tostring(id)])
    if state == 0 and vitality >= tonumber(boxInfo.vitality) then
      return true
    end
  end
  return false
end

function DataUtils.isTaskNew()
  for id, value in pairs(CloudData.DAILY_TASK_INFO.done) do
    if DataUtils.IsTaskActive(id) then
      return true
    end
  end
  for id, value in pairs(CloudData.DAILY_TASK_INFO.box) do
    if DataUtils.IsBoxActive(id) then
      return true
    end
  end
  return false
end

function DataUtils.getBoxInfo(id)
  local boxInfo = DYCommon.getDataByTag(DataRetainer.TASK_BOX_INFO, "id", tostring(id))[1]
  if not boxInfo then
    DDERROR("task_box Info index : %d with error data", tonumber(id))
    return
  else
    local info = {}
    info.id = tonumber(boxInfo.id)
    info.vitality = tonumber(boxInfo.vitality)
    info.reward = {}
    for i = 1, 8 do
      local rewardId = checknumber(boxInfo["reward" .. i])
      if 0 < rewardId then
        local rewardNum = checknumber(boxInfo["count" .. i])
        table.insert(info.reward, {id = rewardId, num = rewardNum})
      else
        break
      end
    end
    local state = tonumber(CloudData.DAILY_TASK_INFO.box[tostring(id)])
    local vitality = tonumber(CloudData.DAILY_TASK_INFO.vitality)
    if state == 1 then
      info.state = -1
    elseif tonumber(CloudData.DAILY_TASK_INFO.vitality) >= info.vitality then
      info.state = 1
    else
      info.state = 0
    end
    return info
  end
end

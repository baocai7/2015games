function DataUtils.getAchievementModel(key)
  local achieveType = tonumber(key)
  
  local achievementInfo = DYCommon.getDataByTag(DataRetainer.ACHIEVEMENT_INFO, "type", tostring(achieveType))
  if not achievementInfo then
    DDERROR("achievement Info key : %d with error data", achieveType)
    return
  end
  local id = 0
  local value = 0
  if CloudData.ACHIEVEMENT_INFO[tostring(achieveType)] then
    id = tonumber(CloudData.ACHIEVEMENT_INFO[tostring(achieveType)].id) or 0
    value = tonumber(CloudData.ACHIEVEMENT_INFO[tostring(achieveType)].value) or 0
  end
  local achieveData = {}
  local state = 0
  local firstId = tonumber(achievementInfo[1].firstId)
  if id == 0 then
    id = firstId
  elseif #achievementInfo > id - firstId + 1 then
    id = id + 1
  else
    state = -1
  end
  local info = DYCommon.getDataByTagEx(DataRetainer.ACHIEVEMENT_INFO, {"id", "type"}, {
    tostring(id),
    tostring(achieveType)
  })[1]
  if not info then
    DDERROR("achievement Info index : %d with error data", id)
    return
  end
  achieveData.id = tonumber(info.id)
  achieveData.type = tonumber(info.type)
  achieveData.name = info.name
  achieveData.curValue = value
  achieveData.description = info.description
  local target = split(info.values, ";")
  achieveData.targetValue = tonumber(target[1])
  if value >= achieveData.targetValue and state == 0 then
    state = 1
  end
  achieveData.state = state
  achieveData.reward = {}
  achieveData.rewardDesc = ""
  for i = 1, 2 do
    if 0 < tonumber(info["reward" .. i]) then
      local rewardInfo = {}
      rewardInfo.id = tonumber(info["reward" .. i])
      rewardInfo.num = tonumber(info["count" .. i])
      table.insert(achieveData.reward, rewardInfo)
      local itemInfo = DYCommon.getDataByTag(DataRetainer.GAME_ITEM_INFO, "id", tostring(rewardInfo.id))[1]
      if not itemInfo then
        DDERROR("itemInfo index : %d with error data", rewardInfo.id)
      else
        local name = itemInfo.name
        achieveData.rewardDesc = achieveData.rewardDesc .. name .. " X " .. rewardInfo.num .. "    "
      end
    end
  end
  return achieveData
end

function DataUtils.isAchievementNew()
  for key, value in pairs(CloudData.ACHIEVEMENT_INFO) do
    local achievementInfo = DYCommon.getDataByTag(DataRetainer.ACHIEVEMENT_INFO, "type", tostring(key))
    if not achievementInfo then
      DDERROR("achievement Info index : %d with error data", tonumber(key))
    else
      local id = tonumber(CloudData.ACHIEVEMENT_INFO[tostring(key)].id) or 0
      local value = tonumber(CloudData.ACHIEVEMENT_INFO[tostring(key)].value) or 0
      local firstId = tonumber(achievementInfo[1].firstId)
      if id == 0 then
        id = firstId
      elseif #achievementInfo > id - firstId + 1 then
        id = id + 1
      else
        value = 0
      end
      local info = DYCommon.getDataByTagEx(DataRetainer.ACHIEVEMENT_INFO, {"id", "type"}, {
        tostring(id),
        tostring(key)
      })[1]
      if not info then
        DDERROR("achievement Info index : %d with error data", id)
      else
        local target = split(info.values, ";")
        local targetValue = tonumber(target[1])
        if value >= targetValue then
          return true
        end
      end
    end
  end
  return false
end

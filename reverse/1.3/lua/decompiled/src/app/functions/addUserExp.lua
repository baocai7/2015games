function DataUtils.getUserLevelAndExp(expSum)
  if expSum == nil or expSum == 0 then
    return CloudData.USER_LEVEL, 0
  end
  local userLevel = #DataRetainer.PLAYER_EXP_LEVEL_INFO - 1
  for i = CloudData.USER_LEVEL, #DataRetainer.PLAYER_EXP_LEVEL_INFO - 2 do
    local playerExpInfo = DYCommon.getDataByTag(DataRetainer.PLAYER_EXP_LEVEL_INFO, "level", tostring(i))[1]
    if not playerExpInfo then
      DDERROR("playerExpInfo index : %d with error data", i)
      return i, 0
    end
    local num = tonumber(playerExpInfo.expSum)
    if expSum < num then
      userLevel = i
      break
    end
  end
  for i = userLevel - 1, 1, -1 do
    local playerExpInfo = DYCommon.getDataByTag(DataRetainer.PLAYER_EXP_LEVEL_INFO, "level", tostring(i))[1]
    if not playerExpInfo then
      DDERROR("playerExpInfo index : %d with error data", i)
      return i + 1, 0
    end
    local num = tonumber(playerExpInfo.expSum)
    if expSum >= num then
      userLevel = i + 1
      break
    end
  end
  if userLevel == 1 then
    return userLevel, expSum
  end
  local playerExpInfo = DYCommon.getDataByTag(DataRetainer.PLAYER_EXP_LEVEL_INFO, "level", tostring(userLevel - 1))[1]
  if not playerExpInfo then
    DDERROR("playerExpInfo index : %d with error data", userLevel - 1)
    return userLevel, 0
  end
  local num = tonumber(playerExpInfo.expSum)
  local exp = expSum - num
  return userLevel, exp
end

function DataUtils.getExpLevelRate()
  if CloudData.USER_LEVEL < #DataRetainer.PLAYER_EXP_LEVEL_INFO - 1 then
    local playerExpInfo = DYCommon.getDataByTag(DataRetainer.PLAYER_EXP_LEVEL_INFO, "level", tostring(CloudData.USER_LEVEL))[1]
    if not playerExpInfo then
      DDERROR("playerExpInfo index : %d with error data", tonumber(CloudData.USER_LEVEL))
      return 0
    else
      local need = tonumber(playerExpInfo.exp)
      local sum = tonumber(playerExpInfo.expSum)
      local cur = need - (sum - CloudData.EXP)
      local rate = math.floor(cur / need * 100)
      if rate < 0 then
        rate = 0
      elseif 100 < rate then
        rate = 100
      end
      return rate
    end
  else
    return 99
  end
end

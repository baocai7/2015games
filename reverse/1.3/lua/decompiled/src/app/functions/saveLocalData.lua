function DataUtils.setDialogueIsFirstPlayed(name, isPlayed)
  local uid = CloudData.UID
  
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsDialogueFirstPlay, serverId, uid, name)
  cc.UserDefault:getInstance():setBoolForKey(str, isPlayed)
end

function DataUtils.getDialogueIsFirstPlayed(name)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsDialogueFirstPlay, serverId, uid, name)
  return cc.UserDefault:getInstance():getBoolForKey(str, false)
end

function DataUtils.setGuideIsFirstPlayed(name, isPlayed)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsGuideFirstPlay, serverId, uid, name)
  cc.UserDefault:getInstance():setBoolForKey(str, isPlayed)
end

function DataUtils.getGuideIsFirstPlayed(name)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsGuideFirstPlay, serverId, uid, name)
  return cc.UserDefault:getInstance():getBoolForKey(str, false)
end

function DataUtils.setItemIsUnlock(id, isUnlock)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsItemUnlock, serverId, uid, id)
  DYStat.setValueBool(str, isUnlock)
end

function DataUtils.getItemIsUnlock(id)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsItemUnlock, serverId, uid, id)
  return DYStat.getValueBool(str, false)
end

function DataUtils.setSceneIsUnlock(name, isUnlock)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsScaneUnlock, serverId, uid, name)
  DYStat.setValueBool(str, isUnlock)
end

function DataUtils.getSceneIsUnlock(name)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsScaneUnlock, serverId, uid, name)
  return DYStat.getValueBool(str, false)
end

function DataUtils.setChapterIsUnlock(id, isUnlock)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsChapterUnlock, serverId, uid, id)
  DYStat.setValueBool(str, isUnlock)
end

function DataUtils.getChapterIsUnlock(id)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsChapterUnlock, serverId, uid, id)
  if id == 1 then
    return DYStat.getValueBool(str, true)
  else
    return DYStat.getValueBool(str, false)
  end
end

function DataUtils.setExtraChapterIsUnlock(id, isUnlock)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsExtraChapterUnlock, serverId, uid, id)
  DYStat.setValueBool(str, isUnlock)
end

function DataUtils.getExtraChapterIsUnlock(id)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsExtraChapterUnlock, serverId, uid, id)
  if id == 1 then
    return DYStat.getValueBool(str, true)
  else
    return DYStat.getValueBool(str, false)
  end
end

function DataUtils.setIsTreasureUnlockAnimationPlayed(id, isPlayed)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsTreasureUnlock, serverId, uid, id)
  DYStat.setValueBool(str, isPlayed)
end

function DataUtils.getIsTreasureUnlockAnimationPlayed(id)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsTreasureUnlock, serverId, uid, id)
  return DYStat.getValueBool(str, false)
end

function DataUtils.setIsTreasureEffctive(id, isEffctive)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsTreasureEffective, serverId, uid, id)
  DYStat.setValueBool(str, isEffctive)
end

function DataUtils.getIsTreasureEffctive(id)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kIsTreasureEffective, serverId, uid, id)
  return DYStat.getValueBool(str, false)
end

function DataUtils.setReadMsgId(msgId)
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kMsgId, serverId, uid)
  local tempStr = DYStat.getValueStr(str, "")
  if tempStr == "" then
    tempStr = string.format("%d", msgId)
  else
    tempStr = string.format("%s,%d", tempStr, msgId)
  end
  DYStat.setValueStr(str, tempStr)
end

function DataUtils.getReadMsgId()
  local uid = CloudData.UID
  local serverId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kMsgId, serverId, uid)
  local tempStr = DYStat.getValueStr(str, "")
  local tempTable = {0}
  if tempStr ~= "" then
    tempTable = split(tempStr, ",")
  end
  local tb = {}
  for k, v in pairs(tempTable) do
    tb[v] = true
  end
  CloudData.READ_MSG_TABLE = tb
  dump(CloudData.READ_MSG_TABLE)
end

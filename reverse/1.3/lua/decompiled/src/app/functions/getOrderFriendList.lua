function DataUtils.insertToFriendList(info)
  for i = 1, #CloudData.FRIENDS_LIST do
    local array = CloudData.FRIENDS_LIST[i]
    
    local infoMsg = checknumber(CloudData.CHAT_NEW_LIST[checkstring(info.uid)])
    local localMsg = checknumber(CloudData.CHAT_NEW_LIST[checkstring(array.uid)])
    local time = checknumber(info.time)
    local compareTime = checknumber(array.time)
    if infoMsg > localMsg then
      table.insert(CloudData.FRIENDS_LIST, i, info)
      return
    elseif infoMsg == localMsg then
      if time == 0 and 0 < compareTime then
        table.insert(CloudData.FRIENDS_LIST, i, info)
        return
      elseif time == 0 and compareTime == 0 or 0 < time and 0 < compareTime then
        if checknumber(info.enegyDraw) == 1 and checknumber(array.enegyDraw) == 0 then
          table.insert(CloudData.FRIENDS_LIST, i, info)
          return
        elseif checknumber(info.enegyDraw) == checknumber(array.enegyDraw) then
          if checknumber(info.enegySend) == 0 and checknumber(array.enegySend) == 1 then
            table.insert(CloudData.FRIENDS_LIST, i, info)
            return
          elseif checknumber(info.enegyDraw) == checknumber(array.enegyDraw) and time < compareTime then
            table.insert(CloudData.FRIENDS_LIST, i, info)
            return
          end
        end
      end
    end
  end
  table.insert(CloudData.FRIENDS_LIST, info)
end

function DataUtils.getOrderFriendList(data)
  CloudData.FRIENDS_LIST = {}
  if not data then
    return
  end
  for k, v in pairs(data) do
    DataUtils.insertToFriendList(v)
  end
end

function DataUtils.refreshFriendList(data)
  if not data then
    CloudData.FRIENDS_LIST = {}
    return
  end
  local online = {}
  local offline = {}
  for i = 1, #CloudData.FRIENDS_LIST do
    local info = CloudData.FRIENDS_LIST[i] or {}
    local uid = tostring(info.uid)
    if data[uid] then
      local status = tonumber(data[uid].time) or 0
      if status == 0 then
        table.insert(online, data[uid])
      else
        table.insert(offline, data[uid])
      end
      data[uid] = nil
    end
  end
  for k, v in pairs(data) do
    local status = tonumber(v.time) or 0
    if status == 0 then
      table.insert(online, v)
    else
      table.insert(offline, v)
    end
  end
  CloudData.FRIENDS_LIST = online
  for i = 1, #offline do
    table.insert(CloudData.FRIENDS_LIST, offline[i])
  end
end

function DataUtils.getLocalChatInfo(targetId)
  local str = string.format(DY_KEY.kFriendChatMsg, checkstring(CloudData.USER_SERVER_ID), checkstring(CloudData.UID))
  local value = DYStat.getValueStr(str, "")
  local msgInfo = json.decode(value) or {}
  return msgInfo[checkstring(targetId)] or {}
end

function DataUtils.setLocalChatInfo(targetId, info)
  local str = string.format(DY_KEY.kFriendChatMsg, checkstring(CloudData.USER_SERVER_ID), checkstring(CloudData.UID))
  local value = DYStat.getValueStr(str, "")
  local msgInfo = json.decode(value) or {}
  if not info or type(info) ~= "table" then
    msgInfo[checkstring(targetId)] = nil
  elseif #info > Const.FRIEND_CHAT_MAX then
    local sum = #info - Const.FRIEND_CHAT_MAX
    for i = sum, 1, -1 do
      table.remove(info, i)
    end
    msgInfo[checkstring(targetId)] = info
  else
    msgInfo[checkstring(targetId)] = info
  end
  local value = json.encode(msgInfo)
  DYStat.setValueStr(str, value)
end

function DataUtils.newLocalChatInfo(targetId, info)
  if not info or type(info) ~= "table" then
    return
  end
  local str = string.format(DY_KEY.kFriendChatMsg, checkstring(CloudData.USER_SERVER_ID), checkstring(CloudData.UID))
  local value = DYStat.getValueStr(str, "")
  local msgInfo = json.decode(value) or {}
  local msg = msgInfo[checkstring(targetId)] or {}
  table.insert(msg, info)
  if #msg > Const.FRIEND_CHAT_MAX then
    local sum = #info - Const.FRIEND_CHAT_MAX
    for i = sum, 1, -1 do
      table.remove(msg, i)
    end
  end
  msgInfo[checkstring(targetId)] = msg
  local value = json.encode(msgInfo)
  DYStat.setValueStr(str, value)
end

function DataUtils.sortChatInfo(contact)
  local str = string.format(DY_KEY.kFriendChatMsg, checkstring(CloudData.USER_SERVER_ID), checkstring(CloudData.UID))
  if not contact or type(contact) ~= "table" then
    DYStat.setValueStr(str, "")
    return
  end
  local value = DYStat.getValueStr(str, "")
  local msgInfo = json.decode(value) or {}
  for k, v in pairs(msgInfo) do
    if not contact[checkstring(k)] then
      msgInfo[k] = nil
    end
  end
  local value1 = json.encode(msgInfo)
  DYStat.setValueStr(str, value1)
end

function DataUtils.getRecentList()
  local str = string.format(DY_KEY.kRecentContact, checkstring(CloudData.USER_SERVER_ID), checkstring(CloudData.UID))
  local value = DYStat.getValueStr(str, "")
  local data = json.decode(value) or {}
  return data
end

function DataUtils.setRecentList(info)
  local str = string.format(DY_KEY.kRecentContact, checkstring(CloudData.USER_SERVER_ID), checkstring(CloudData.UID))
  if not info or type(info) ~= "table" then
    DYStat.setValueStr(str, "")
    return
  end
  local value = json.encode(info)
  DYStat.setValueStr(str, value)
end

function DataUtils.newRecentItem(uid)
  if not uid then
    return
  end
  local recent = DataUtils.getRecentList()
  table.insert(recent, 1, checkstring(uid))
  for i = 2, #recent do
    if checknumber(recent[i]) == checknumber(uid) then
      table.remove(recent, i)
      break
    end
  end
  if #recent > Const.FRIEND_RECENT_MAX then
    table.remove(recent, #recent)
  end
  DataUtils.setRecentList(recent)
end

function DataUtils.removeRecentItem(uid)
  if not uid then
    return
  end
  local recent = DataUtils.getRecentList()
  for i = 1, #recent do
    if checknumber(recent[i]) == checknumber(uid) then
      table.remove(recent, i)
      break
    end
  end
  DataUtils.setRecentList(recent)
end

function DataUtils.getSystemText(info)
  if not info or type(info) ~= "table" then
    return ""
  end
  local param = split(info.params, ";")
  local tFunc = {
    ["3010"] = function()
      local buddhaModel = DataUtils.getBuddhaModelBaseInfo(param[2])
      local skillModel = DataUtils.getAwakeSkillBaseData(param[3])
      local buddhaName = buddhaModel.name
      local skillName = skillModel.skillName
      local skillType = skillModel.skillType
      if 0 == skillType then
        return string.format("%s%s%s%s%s%s", DYLang.getString("S1807", ""), param[1], DYLang.getString("S1805", ""), buddhaName, DYLang.getString("S1808", ""), skillName)
      else
        return string.format("%s%s%s%s%s%s", DYLang.getString("S1804", ""), param[1], DYLang.getString("S1805", ""), buddhaName, DYLang.getString("S1806", ""), skillName)
      end
    end,
    ["3011"] = function()
      local models = {
        DYLang.getString("S1809", ""),
        DYLang.getString("S1810", ""),
        DYLang.getString("S1811", "")
      }
      local itemModel = DataUtils.getItemModel(param[3])
      local itemName = itemModel.itemName
      return string.format("%s%s%s%s%s*%s", param[1], DYLang.getString("S1812", ""), models[checknumber(param[2])], DYLang.getString("S1813", ""), itemName, param[4])
    end,
    ["3012"] = function()
      local itemModel = DataUtils.getItemModel(param[2])
      local itemName = itemModel.itemName
      return string.format("%s%s%s%s%s", DYLang.getString("S1814", ""), param[1], DYLang.getString("S1815", ""), itemName, DYLang.getString("STR_SCROLL_CAPTION1", ""))
    end,
    ["3013"] = function()
      return string.format("%s%s%s%s%s%s%s", DYLang.getString("S1816", ""), param[1], DYLang.getString("S1817", ""), param[2], DYLang.getString("STR_SCROLL_CAPTION2", ""), param[3], DYLang.getString("S1818", ""))
    end,
    ["3014"] = function()
      return string.format("%s%s%s%s", DYLang.getString("S1819", ""), param[1], DYLang.getString("S1820", ""), param[2])
    end,
    ["3015"] = function()
      return string.format("%s%s%s", param[1], DYLang.getString("S1821", ""), param[2])
    end,
    ["3016"] = function()
      return string.format("%s%s", param[1], DYLang.getString("S1822", ""))
    end,
    ["3017"] = function()
      return string.format("%s%s%s%s%s", DYLang.getString("S1823", ""), param[1], DYLang.getString("S1824", ""), param[2], DYLang.getString("STR_SCROLL_CAPTION3", ""))
    end,
    ["3018"] = function()
      return string.format("%s%s%s%s%s", DYLang.getString("S1825", ""), param[1], DYLang.getString("S1826", ""), param[2], DYLang.getString("S1827", ""))
    end,
    ["3019"] = function()
      local bossNames = {
        DYLang.getString("S1828", ""),
        DYLang.getString("S1829", ""),
        DYLang.getString("S1830", ""),
        DYLang.getString("S1831", ""),
        DYLang.getString("S1832", "")
      }
      return string.format("%s%s%s%s%s%s%s%s", DYLang.getString("S1833", ""), param[1], DYLang.getString("S1834", ""), bossNames[tonumber(param[2])], DYLang.getString("S1826", ""), param[3], DYLang.getString("S1827", ""), DYLang.getString("STR_SCROLL_CAPTION4", ""))
    end,
    ["3020"] = function()
      local bossNames = {
        DYLang.getString("S1828", ""),
        DYLang.getString("S1829", ""),
        DYLang.getString("S1830", ""),
        DYLang.getString("S1831", ""),
        DYLang.getString("S1832", "")
      }
      return string.format("%s%s%s%s%s", DYLang.getString("S1842", ""), bossNames[tonumber(param[1])], DYLang.getString("S1843", ""), param[2], DYLang.getString("S1844", ""))
    end,
    ["3021"] = function()
      return string.format("%s%s%s%s%s", DYLang.getString("S1845", ""), param[1], DYLang.getString("S1846", ""), param[2], DYLang.getString("S1847", ""))
    end,
    ["3022"] = function()
      return DYLang.getString("S1848", "")
    end,
    ["3023"] = function()
      return param[1]
    end,
    ["3024"] = function()
      local models = {
        [1] = "\229\165\150\230\177\160\229\164\167\229\165\150",
        [2] = ""
      }
      local itemModel = DataUtils.getItemModel(param[3])
      local itemName = itemModel.itemName
      return string.format("%s%s%s%s*%s", param[1], DYLang.getString("STR_SCROLL_CAPTION5", ""), models[checknumber(param[2])], itemName, param[4])
    end
  }
  return tFunc[checkstring(info.event)]()
end

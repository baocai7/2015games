local function explode(separator, str)
  local array_str_tab = {}
  
  while true do
    local pos = string.find(str, separator)
    if not pos then
      array_str_tab[#array_str_tab + 1] = str
      break
    end
    local sub_str = string.sub(str, 1, pos - 1)
    array_str_tab[#array_str_tab + 1] = sub_str
    str = string.sub(str, pos + 1, #str)
  end
  return array_str_tab
end

function DataUtils.getBuddhaTableOnTeam()
  local stringBuddhaIds = ""
  if 3 == GameManager.MODE then
    stringBuddhaIds = DYStat.getValueStr(DY_KEY.kTeamPurgatory, "")
  else
    stringBuddhaIds = DYStat.getValueStr(DY_KEY.kBuddhaOnTeam, "1003,")
  end
  local tempTable = explode(",", stringBuddhaIds)
  for k, v in pairs(tempTable) do
    if "" == v then
      table.removebyvalue(tempTable, v, true)
    end
  end
  return tempTable
end

function DataUtils.setBuddhaTableOnTeam(table, type_)
  local teamType = type_ or 0
  local stringBuddhaIds = ""
  for i, buddhaId in pairs(table) do
    if buddhaId ~= "" then
      stringBuddhaIds = stringBuddhaIds .. buddhaId .. ","
    end
  end
  if 3 == teamType then
    DYStat.setValueStr(DY_KEY.kTeamPurgatory, stringBuddhaIds)
  else
    DYStat.setValueStr(DY_KEY.kBuddhaOnTeam, stringBuddhaIds)
  end
end

function DataUtils.getBuddhaTableOnAssist()
  local stringBuddhaIds = ""
  if 3 == GameManager.MODE then
    stringBuddhaIds = DYStat.getValueStr(DY_KEY.kAssistPurgatory, "")
  else
    stringBuddhaIds = DYStat.getValueStr(DY_KEY.kBuddhaOnAssist, "")
  end
  local tempTable = explode(",", stringBuddhaIds)
  for k, v in pairs(tempTable) do
    if "" == v then
      table.removebyvalue(tempTable, v, true)
    end
  end
  return tempTable
end

function DataUtils.setBuddhaTableOnAssist(table, type_)
  local teamType = type_ or 0
  local stringBuddhaIds = ""
  for i, buddhaId in pairs(table) do
    if buddhaId ~= "" then
      stringBuddhaIds = stringBuddhaIds .. buddhaId .. ","
    end
  end
  if 3 == teamType then
    DYStat.setValueStr(DY_KEY.kAssistPurgatory, stringBuddhaIds)
  else
    DYStat.setValueStr(DY_KEY.kBuddhaOnAssist, stringBuddhaIds)
  end
end

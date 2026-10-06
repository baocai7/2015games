local M = {}

function M.init()
  require("app.functions.getBuddhaModel")
  require("app.functions.getMonsterModel")
  require("app.functions.getStageModel")
  require("app.functions.getTreasurePieceModel")
  require("app.functions.getTreasureModel")
  require("app.functions.getSceneIconLocationTable")
  require("app.functions.getSpiritCostBasic")
  require("app.functions.getBuddhaTableOnTeam")
  require("app.functions.getAchievementModel")
  require("app.functions.getDailyTaskModel")
  require("app.functions.getStageTaskModel")
  require("app.functions.getStageTaskSubModel")
  require("app.functions.getPaymentModel")
  require("app.functions.getBuddhaSkillModel")
  require("app.functions.getMonsterSkillModel")
  require("app.functions.getBuddhaFateModel")
  require("app.functions.getBreakDataModel")
  require("app.functions.getItemModel")
  require("app.functions.setNewBuddhaCloudData")
  require("app.functions.saveLocalData")
  require("app.functions.getSortedPaymentInfo")
  require("app.functions.getStageEssenceAddRate")
  require("app.functions.getSpiritModel")
  require("app.functions.addUserExp")
  require("app.functions.getVipModel")
  require("app.functions.getCimeliaSkillModel")
  require("app.functions.getCimeliaModel")
  require("app.functions.getActivityModel")
  require("app.functions.getTeamStarFateModel")
  require("app.functions.getPVPActualModel")
  require("app.functions.getOrderFriendList")
  require("app.functions.getShieldingWords")
  require("app.functions.getActivityPlace")
  require("app.functions.getUnionContriData")
  require("app.functions.getUnionBossData")
  require("app.functions.getAIActions")
  require("app.functions.getEquipmentModel")
  require("app.functions.getPatrolTask")
end

function explode(separator, str)
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

function split(s, p)
  local rt = {}
  if not s then
    return
  end
  string.gsub(s, "[^" .. p .. "]+", function(w)
    table.insert(rt, w)
  end)
  return rt
end

function random_sample(count, range)
  local function ecx(table, n, count)
    local n = n or #table
    
    for i = 1, count or n do
      local j = math.random(i, n)
      table[i], table[j] = table[j], table[i]
    end
    return table
  end
  
  do
    local mset = {}
    
    function mset:__index(key)
      return key
    end
    
    function Ilist()
      return setmetatable({}, mset)
    end
  end
  return {
    unpack(ecx(Ilist(), range, count), 1, count)
  }
end

return M

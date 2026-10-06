local M = {}
M.EVENT_EQUIP_INFO = "equip_info"
M.EVENT_EQUIP_CHANGE = "equip_change"
M.EVENT_EQUIP_ON = "equip_on"
M.EVENT_EQUIP_CLICKED = "equip_clicked"
M.EVENT_EQUIP_UPGRADE = "equip_upgrade"
M.EVENT_SELECT_ONEKEY = "select_onekey"
M.PACKAGE_LIMIT_NUM = 40
M.PROPERTIES = {
  [1] = "\232\161\128\233\135\143",
  [2] = "\230\148\187\229\135\187",
  [3] = "\231\137\169\231\144\134\233\152\178\229\190\161",
  [4] = "\233\173\148\230\179\149\233\152\178\229\190\161",
  [5] = "\233\135\145",
  [6] = "\230\156\168",
  [7] = "\230\176\180",
  [8] = "\231\129\171",
  [9] = "\229\156\159",
  [10] = "\229\133\168\228\186\148\232\161\140",
  [11] = "\232\163\133\229\164\135\232\161\128\233\135\143",
  [12] = "\232\163\133\229\164\135\230\148\187\229\135\187",
  [13] = "\232\163\133\229\164\135\231\137\169\233\152\178",
  [14] = "\232\163\133\229\164\135\233\173\148\233\152\178",
  [15] = "\230\154\180\229\135\187\231\142\135",
  [16] = "\230\138\151\230\154\180\231\142\135",
  [17] = "\230\154\180\229\135\187\228\188\164\229\174\179",
  [18] = "\230\154\180\228\188\164\229\135\143\229\133\141",
  [19] = "\229\145\189\228\184\173",
  [20] = "\233\151\170\233\129\191",
  [21] = "\228\188\164\229\174\179\229\135\143\229\133\141"
}

function M.init()
  M.IS_BTN_ENABLED = true
  M.CURR_EQUIPMENT = nil
end

function M.setEquipmentOn(ueid, buddhaId)
  M.EQUIP_LIST[ueid].buddhaId = buddhaId
end

function M.setEquipmentDown(ueid)
  M.EQUIP_LIST[ueid].buddhaId = 0
end

function M.getEquipmentsNumForPackage()
  local count = 0
  for k, v in pairs(M.EQUIP_LIST) do
    if 0 == v.buddhaId then
      count = count + 1
    end
  end
  return count
end

function M.checkEquipmentValid(data, tag, buddhaId, spiritCost)
  if data.buddhaId > 0 then
    return false
  end
  if tag ~= data.tag then
    return false
  end
  if 0 < data.spirit and spiritCost ~= data.spirit then
    return false
  end
  if 0 < data.uniqueId and buddhaId ~= data.uniqueId then
    return false
  end
  return true
end

function M.updateIronLabel(num)
  display.getRunningScene().mIronLabel:setString(num)
end

function M.equipmentSuitStatus(ueid)
  local eData = M.EQUIP_LIST[ueid]
  local suitStatus = {}
  if 0 == eData.buddhaId then
    suitStatus[tostring(eData.suitId)] = 1
    return suitStatus
  end
  local equipList = CloudData.NPC_INFO[eData.buddhaId].equipments
  
  local function checkSuitStatus(ueid)
    local eData = M.EQUIP_LIST[ueid]
    if not eData then
      return
    end
    local id = tostring(eData.suitId)
    if "-1" == id then
      return
    end
    if suitStatus[id] then
      suitStatus[id] = suitStatus[id] + 1
    else
      suitStatus[id] = 1
    end
  end
  
  for i = 1, #equipList do
    checkSuitStatus(tostring(equipList[i]))
  end
  return suitStatus
end

return M

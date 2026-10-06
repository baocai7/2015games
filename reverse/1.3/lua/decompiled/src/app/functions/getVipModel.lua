function DataUtils.getVipPrivilege(vipLevel)
  local vipInfo = DYCommon.getDataByTag(DataRetainer.VIP_PRIVILEGE_INFO, "level", tostring(vipLevel))[1]
  
  if not vipInfo then
    DDERROR("vip level : %d with error data", tonumber(vipLevel))
    return
  end
  local vipData = {}
  vipData.isSweep5 = tonumber(vipInfo.isSweep5)
  vipData.isVipPool = tonumber(vipInfo.isVipPool)
  vipData.isPermanentMysteryShop = tonumber(vipInfo.isPermanentMysteryShop)
  vipData.purchaseEnergyCount = tonumber(vipInfo.buyGinsenCount)
  vipData.sweepCount = 0
  vipData.miningCount = tonumber(vipInfo.miningCount)
  vipData.dungeonResetCount = tonumber(vipInfo.dungeonResetCount)
  vipData.purgatoryResetCount = tonumber(vipInfo.purgatoryResetCount)
  vipData.pvpResetCount = tonumber(vipInfo.pvpResetCount)
  vipData.towerResetCount = tonumber(vipInfo.towerResetCount)
  vipData.arousalCount = tonumber(vipInfo.arousalCount)
  vipData.arousalRate = tonumber(vipInfo.arousalRate) - 1
  local awards = split(vipInfo.dailyAward, "|")
  local id = split(awards[1], ";") or {}
  local num = split(awards[2], ";") or {}
  for i = 1, #id do
    if checknumber(id[i]) == 2006 then
      vipData.sweepCount = checknumber(num[i])
    end
  end
  return vipData
end

function DataUtils.getVipCountPeach(vipLevel)
  local vipInfo = DYCommon.getDataByTag(DataRetainer.VIP_PRIVILEGE_INFO, "level", tostring(vipLevel))[1]
  if not vipInfo then
    DDERROR("vip level : %d with error data", tonumber(vipLevel))
    return
  end
  local countNum = tonumber(vipInfo.needPeachCount)
  return countNum
end

function DataUtils.getVipGift(vipLevel)
  local vipInfo = DYCommon.getDataByTag(DataRetainer.VIP_PRIVILEGE_INFO, "level", tostring(vipLevel))[1]
  if not vipInfo then
    DDERROR("vip level : %d with error data", tonumber(vipLevel))
    return
  end
  local giftData = {}
  giftData.giftIds = split(vipInfo.packageThings, ";")
  giftData.giftNums = split(vipInfo.packageNum, ";")
  giftData.primePrice = tonumber(vipInfo.primePrice)
  giftData.dicountPrice = tonumber(vipInfo.dicountPrice)
  return giftData
end

function DataUtils.getIsVipFuntionsUnlock(funcName)
  local vipInfo = DYCommon.getDataByTag(DataRetainer.VIP_PRIVILEGE_INFO, "level", tostring(CloudData.VIP_LEVEL))[1]
  if not vipInfo then
    DDERROR("vip level : %d with error data", tonumber(CloudData.VIP_LEVEL))
    return
  end
  local isSweep5 = tonumber(vipInfo.isSweep5)
  local isVipPool = tonumber(vipInfo.isVipPool)
  local isPermanentMysteryShop = tonumber(vipInfo.isPermanentMysteryShop)
  local purgatoryResetCount = tonumber(vipInfo.purgatoryResetCount)
  if "sweep5" == funcName then
    if 0 == isSweep5 then
      return false
    else
      return true
    end
  end
  if "vipPool" == funcName then
    if 0 == isVipPool then
      return false
    else
      return true
    end
  end
  if "vipShop" == funcName then
    if 0 == isPermanentMysteryShop then
      return false
    else
      return true
    end
  end
  if "purgatoryReset" == funcName then
    if 0 == purgatoryResetCount then
      return false
    else
      return true
    end
  end
end

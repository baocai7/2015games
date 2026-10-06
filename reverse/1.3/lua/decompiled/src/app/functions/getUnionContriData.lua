function DataUtils.getUnionContriData(id)
  local contriInfo = DYCommon.getDataByTag(DataRetainer.UNION_CONTRI_BOX, "id", tostring(id))[1]
  
  if not contriInfo then
    DDERROR("contribute info id : %d with error data", tonumber(id))
    return
  end
  local contriData = {}
  contriData.progressNum = tonumber(contriInfo.progress)
  contriData.rewardItems = split(contriInfo.itemid, ";")
  contriData.rewardNums = split(contriInfo.num, ";")
  return contriData
end

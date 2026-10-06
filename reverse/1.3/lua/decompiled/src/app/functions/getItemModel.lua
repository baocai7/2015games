local function getFontColor(param)
  local func = {
    [1] = cc.c3b(255, 255, 255),
    
    [2] = cc.c3b(10, 254, 56),
    [3] = cc.c3b(10, 240, 254),
    [4] = cc.c3b(236, 20, 255),
    [5] = cc.c3b(255, 187, 2),
    [6] = cc.c3b(255, 20, 37)
  }
  return func[param]
end

local function getItemFromDetails(params)
  local fromNum = params.fromNum
  local fromParam = params.fromParam
  local tempTabel = {
    fromText = {},
    fromNum = {},
    fromParam = {},
    isOpen = {}
  }
  local textList = {
    DYLang.getString("S215", ""),
    DYLang.getString("S216", ""),
    DYLang.getString("S217", ""),
    DYLang.getString("S218", ""),
    DYLang.getString("S219", ""),
    DYLang.getString("S220", "")
  }
  local textStr = {}
  for i = 1, #fromNum do
    local num = tonumber(fromNum[i])
    local param = tonumber(fromParam[i])
    local isOpen = 1
    local textStr = ""
    if 1 == num then
      local n1 = math.ceil(param / 10)
      local n2 = param % 10
      if 0 == n2 then
        n2 = 10
      end
      textStr = string.format(DYLang.getString("S221", ""), n1, n2)
      if param > CloudData.MAIN_STAGE_PROGRESS then
        isOpen = 0
      end
    elseif 2 == num then
      local n1 = math.ceil(param / 4)
      local n2 = param % 4
      if 0 == n2 then
        n2 = 4
      end
      textStr = string.format(DYLang.getString("S222", ""), n1, n2)
    elseif 3 == num then
      local tb = {
        DYLang.getString("S223", ""),
        DYLang.getString("S224", ""),
        DYLang.getString("S225", ""),
        DYLang.getString("S226", "")
      }
      textStr = tb[param]
    elseif 6 == num then
      textStr = textList[num - 3]
      local limitLevel = Const.FUNC_UNLOCK.patrol
      if limitLevel > CloudData.USER_LEVEL then
        isOpen = 0
      end
    elseif 9 == num then
      textStr = textList[num - 3]
      local limitLevel = Const.FUNC_UNLOCK.tower
      if limitLevel > CloudData.USER_LEVEL then
        isOpen = 0
      end
    else
      textStr = textList[num - 3]
    end
    table.insert(tempTabel.fromText, textStr)
    table.insert(tempTabel.fromNum, num)
    table.insert(tempTabel.fromParam, param)
    table.insert(tempTabel.isOpen, isOpen)
  end
  return tempTabel
end

function DataUtils.getItemModel(itemId_)
  local itemInfo = DYCommon.getDataByTag(DataRetainer.GAME_ITEM_INFO, "id", tostring(itemId_))[1]
  if not itemInfo then
    DDTRACE("DataUtils.getItemModel() : ", string.format(" item id : %s with error data", checkstring(itemId_)))
    return
  end
  local gameItemData = {}
  gameItemData.itemId = tonumber(itemId_)
  gameItemData.itemType = tonumber(itemInfo.type)
  gameItemData.itemName = itemInfo.name
  gameItemData.itemIcon = itemInfo.icon
  gameItemData.quality = tonumber(itemInfo.quality)
  gameItemData.itemDesc = itemInfo.intro
  gameItemData.param = itemInfo.param or 0
  gameItemData.currNum = tonumber(CloudData.GAME_ITEM_INFO[tostring(itemId_)]) or 0
  return gameItemData
end

function DataUtils.getPackageItem(itemId_)
  local itemInfo = DYCommon.getDataByTag(DataRetainer.GAME_ITEM_INFO, "id", tostring(itemId_))[1]
  if not itemInfo then
    DDTRACE("DataUtils.getPackageItem() : ", string.format(" item id : %s with error data", checkstring(itemId_)))
    return
  end
  local gameItemData = {}
  gameItemData.itemId = tonumber(itemInfo.id)
  gameItemData.itemName = itemInfo.name
  gameItemData.itemType = tonumber(itemInfo.type)
  gameItemData.itemIcon = itemInfo.icon
  gameItemData.quality = tonumber(itemInfo.quality)
  gameItemData.salePrice = tonumber(itemInfo.price)
  gameItemData.isPile = tonumber(itemInfo.isPile)
  gameItemData.itemDesc = itemInfo.intro
  gameItemData.param = itemInfo.param
  gameItemData.canUse = tonumber(itemInfo.canUse)
  gameItemData.currNum = tonumber(CloudData.GAME_ITEM_INFO[tostring(itemId_)]) or 0
  gameItemData.color = getFontColor(gameItemData.quality)
  local fromNum = split(itemInfo.from, ";")
  local fromParam = split(itemInfo.fromParam, ";")
  local tb = getItemFromDetails({fromNum = fromNum, fromParam = fromParam})
  gameItemData.fromText = tb.fromText
  gameItemData.fromNum = tb.fromNum
  gameItemData.fromParam = tb.fromParam
  gameItemData.isOpen = tb.isOpen
  return gameItemData
end

function DataUtils.getItemModelWithColor(itemId)
  local itemInfo = DYCommon.getDataByTag(DataRetainer.GAME_ITEM_INFO, "id", tostring(itemId))[1]
  if not itemInfo then
    DDTRACE("DataUtils.getItemModelWithColor() : ", string.format(" item id : %s with error data", checkstring(itemId)))
    return
  end
  local gameItemData = {}
  gameItemData.itemId = tonumber(itemId)
  gameItemData.name = itemInfo.name
  gameItemData.icon = itemInfo.icon
  gameItemData.quality = tonumber(itemInfo.quality)
  gameItemData.itemDesc = itemInfo.intro
  gameItemData.currNum = tonumber(CloudData.GAME_ITEM_INFO[tostring(itemId)]) or 0
  gameItemData.color = getFontColor(gameItemData.quality)
  return gameItemData
end

function DataUtils.getItemInfoWithSource(itemId)
  local itemInfo = DYCommon.getDataByTag(DataRetainer.GAME_ITEM_INFO, "id", tostring(itemId))[1]
  if not itemInfo then
    DDERROR("item id : %d with error data", tonumber(itemId))
    return
  end
  local gameItemData = {}
  gameItemData.itemId = tonumber(itemId)
  gameItemData.name = itemInfo.name
  gameItemData.icon = itemInfo.icon
  gameItemData.quality = tonumber(itemInfo.quality)
  gameItemData.itemType = tonumber(itemInfo.type)
  gameItemData.itemDesc = itemInfo.intro
  gameItemData.currNum = tonumber(CloudData.GAME_ITEM_INFO[tostring(itemId)]) or 0
  gameItemData.color = getFontColor(gameItemData.quality)
  local fromNum = split(itemInfo.from, ";")
  local fromParam = split(itemInfo.fromParam, ";")
  local tb = getItemFromDetails({fromNum = fromNum, fromParam = fromParam})
  gameItemData.fromText = tb.fromText
  gameItemData.fromNum = tb.fromNum
  gameItemData.fromParam = tb.fromParam
  gameItemData.isOpen = tb.isOpen
  return gameItemData
end

function DataUtils.updateItemNum(itemId, num)
  local sum = checknumber(num)
  local id = checknumber(itemId)
  if id <= 0 then
    return 0
  end
  local originNum = CloudData.GAME_ITEM_INFO[tostring(id)] or 0
  CloudData.GAME_ITEM_INFO[tostring(id)] = sum
  if id == 1 then
    CloudData.PEACH = sum
  elseif id == 2 then
    CloudData.ESSENCE = sum
  elseif id == 3 then
    CloudData.ENERGY = sum
  elseif id == 4 then
    CloudData.EXP = sum
  elseif id == 5 then
    CloudData.FEAT = sum
  elseif id == 6 then
    CloudData.LIANYUBI = sum
  elseif id == 9 then
    CloudData.UNION_CONTRI_NUM = sum
  elseif id == 10 then
    CloudData.IRON = sum
  elseif id == 2005 then
    CloudData.GINSENG_FRUIT = sum
  elseif id == 2006 then
    CloudData.SWEEP = sum
  end
  return sum - originNum
end

function DataUtils.getCoinPic(itemId)
  local id = tonumber(itemId)
  if id <= 0 then
    return
  end
  local img
  if id == 1 then
    img = "item_icon/pic_peach.png"
  elseif id == 2 then
    img = "item_icon/pic_essence.png"
  elseif id == 3 then
    img = "item_icon/pic_energy.png"
  elseif id == 4 then
    img = "item_icon/pic_exp.png"
  elseif id == 5 then
    img = "item_icon/pic_feat.png"
  elseif id == 6 then
    img = "item_icon/pic_lianyubi.png"
  elseif id == 7 then
    img = "item_icon/pic_horn.png"
  elseif id == 9 then
    img = "item_icon/pic_contribution.png"
  elseif id == 2006 then
    img = "item_icon/pic_sweep.png"
  elseif id == 2021 then
    img = "item_icon/icon_purgatory_refresh.png"
  elseif id == 2022 then
    img = "item_icon/icon_feat_refresh.png"
  elseif id == 2023 then
    img = "item_icon/icon_mystery_refresh.png"
  elseif id == 2027 then
    img = "item_icon/icon_pvpOl_refresh.png"
  end
  return img
end

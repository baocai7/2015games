local M = {}
M.account = {}

function M.account.login(...)
  if DYAnalyzeHelper and DYAnalyzeHelper.account then
    DYAnalyzeHelper.account.login(...)
  end
end

function M.account.logout()
  if DYAnalyzeHelper and DYAnalyzeHelper.account then
    DYAnalyzeHelper.account.logout()
  end
end

function M.account.getAccountId()
  if DYAnalyzeHelper and DYAnalyzeHelper.account then
    return DYAnalyzeHelper.account.getAccountId()
  end
end

function M.account.setAccountType(accountType)
  if DYAnalyzeHelper and DYAnalyzeHelper.account then
    DYAnalyzeHelper.account.setAccountType(accountType)
  end
end

function M.account.setLevel(level)
  if DYAnalyzeHelper and DYAnalyzeHelper.account then
    DYAnalyzeHelper.account.setLevel(level)
  end
end

function M.account.setGender(gender)
  if DYAnalyzeHelper and DYAnalyzeHelper.account then
    DYAnalyzeHelper.account.setGender(gender)
  end
end

function M.account.setAge(age)
  if DYAnalyzeHelper and DYAnalyzeHelper.account then
    DYAnalyzeHelper.account.setAge(age)
  end
end

function M.account.setGameServer(server)
  if DYAnalyzeHelper and DYAnalyzeHelper.account then
    DYAnalyzeHelper.account.setGameServer(server)
  end
end

function M.account.addTag(tag, subTag)
  if DYAnalyzeHelper and DYAnalyzeHelper.account then
    DYAnalyzeHelper.account.addTag(tag, subTag)
  end
end

function M.account.removeTag(tag, subTag)
  if DYAnalyzeHelper and DYAnalyzeHelper.account then
    DYAnalyzeHelper.account.removeTag(tag, subTag)
  end
end

function M.account.changeTag(tag, subTag1, subTag2)
  tag = checkstring(tag)
  subTag1 = checkstring(subTag1)
  subTag2 = checkstring(subTag2)
  if subTag1 ~= subTag2 then
    DYAnalyzeHelper.account.removeTag(tag, subTag1)
    DYAnalyzeHelper.account.addTag(tag, subTag2)
  end
end

M.agent = {}

function M.agent.onStart(appId, channelId)
  if DYAnalyzeHelper and DYAnalyzeHelper.agent then
    DYAnalyzeHelper.agent.onStart(appId, channelId)
  end
end

function M.agent.setDebugMode(mode)
  if DYAnalyzeHelper and DYAnalyzeHelper.agent then
    DYAnalyzeHelper.agent.setDebugMode(mode)
  end
end

function M.agent.setReportMode(mode)
  if DYAnalyzeHelper and DYAnalyzeHelper.agent then
    DYAnalyzeHelper.agent.setReportMode(mode)
  end
end

function M.agent.setUploadInterval(interval)
  if DYAnalyzeHelper and DYAnalyzeHelper.agent then
    DYAnalyzeHelper.agent.setUploadInterval(interval)
  end
end

function M.agent.setVersion(version)
  if DYAnalyzeHelper and DYAnalyzeHelper.agent then
    DYAnalyzeHelper.agent.setVersion(version)
  end
end

function M.agent.reportError(title, content)
  if DYAnalyzeHelper and DYAnalyzeHelper.agent then
    DYAnalyzeHelper.agent.reportError(title, content)
  end
end

function M.agent.uploadNow()
  if DYAnalyzeHelper and DYAnalyzeHelper.agent then
    DYAnalyzeHelper.agent.uploadNow()
  end
end

function M.agent.getUID()
  if DYAnalyzeHelper and DYAnalyzeHelper.agent then
    return DYAnalyzeHelper.agent.getUID()
  end
end

M.cardsGame = {}

function M.cardsGame.play(roomId, id, coinType, loseOrGain, tax, left)
  if DYAnalyzeHelper and DYAnalyzeHelper.cardsGame then
    DYAnalyzeHelper.cardsGame.play(roomId, id, coinType, loseOrGain, tax, left)
  end
end

function M.cardsGame.gain(roomId, id, coinType, gain, left)
  if DYAnalyzeHelper and DYAnalyzeHelper.cardsGame then
    DYAnalyzeHelper.cardsGame.gain(roomId, id, coinType, gain, left)
  end
end

function M.cardsGame.lost(roomId, id, coinType, lost, left)
  if DYAnalyzeHelper and DYAnalyzeHelper.cardsGame then
    DYAnalyzeHelper.cardsGame.lost(roomId, id, coinType, lost, left)
  end
end

M.coin = {}

function M.coin.setCoinNum(coinNum, coinType)
  if DYAnalyzeHelper and DYAnalyzeHelper.coin then
    DYAnalyzeHelper.coin.setCoinNum(coinNum, coinType)
  end
end

function M.coin.lost(id, coinType, lost, left)
  if DYAnalyzeHelper and DYAnalyzeHelper.coin then
    DYAnalyzeHelper.coin.lost(id, coinType, lost, left)
  end
end

function M.coin.lostInLevel(id, coinType, lost, left, levelId)
  if DYAnalyzeHelper and DYAnalyzeHelper.coin then
    DYAnalyzeHelper.coin.lostInLevel(id, coinType, lost, left, levelId)
  end
end

function M.coin.gain(id, coinType, gain, left)
  if DYAnalyzeHelper and DYAnalyzeHelper.coin then
    DYAnalyzeHelper.coin.gain(id, coinType, gain, left)
  end
end

function M.coin.gainInLevel(id, coinType, gain, left, levelId)
  if DYAnalyzeHelper and DYAnalyzeHelper.coin then
    DYAnalyzeHelper.coin.gainInLevel(id, coinType, gain, left, levelId)
  end
end

M.configParams = {}

function M.configParams.update()
  if DYAnalyzeHelper and DYAnalyzeHelper.configParams then
    DYAnalyzeHelper.configParams.update()
  end
end

function M.configParams.getParamNumber(key, defaultValue)
  if DYAnalyzeHelper and DYAnalyzeHelper.configParams then
    return DYAnalyzeHelper.configParams.getParamNumber(key, defaultValue)
  end
end

function M.configParams.getParamString(key, defaultValue)
  if DYAnalyzeHelper and DYAnalyzeHelper.configParams then
    return DYAnalyzeHelper.configParams.getParamString(key, defaultValue)
  end
end

function M.configParams.getParamBool(key, defaultValue)
  if DYAnalyzeHelper and DYAnalyzeHelper.configParams then
    return DYAnalyzeHelper.configParams.getParamBool(key, defaultValue)
  end
end

M.event = {}

function M.event.onEventBeforeLogin(eventId, map, duration)
  if DYAnalyzeHelper and DYAnalyzeHelper.event then
    DYAnalyzeHelper.event.onEventBeforeLogin(eventId, map, duration)
  end
end

function M.event.onEventCount(eventId, count)
  if DYAnalyzeHelper and DYAnalyzeHelper.event then
    DYAnalyzeHelper.event.onEventCount(eventId, count)
  end
end

function M.event.onEvent(...)
  if DYAnalyzeHelper and DYAnalyzeHelper.event then
    DYAnalyzeHelper.event.onEvent(...)
  end
end

function M.event.onEventDuration(...)
  if DYAnalyzeHelper and DYAnalyzeHelper.event then
    DYAnalyzeHelper.event.onEventDuration(...)
  end
end

function M.event.onEventBegin(...)
  if DYAnalyzeHelper and DYAnalyzeHelper.event then
    DYAnalyzeHelper.event.onEventBegin(...)
  end
end

function M.event.onEventEnd(...)
  if DYAnalyzeHelper and DYAnalyzeHelper.event then
    DYAnalyzeHelper.event.onEventEnd(...)
  end
end

M.item = {}
do
  local function getItemName(itemId)
    local itemInfo = DYCommon.getDataByTag(DataRetainer.GAME_ITEM_INFO, "id", tostring(itemId))[1]
    
    return itemInfo and itemInfo.name or checkstring(itemId)
  end
  
  local function getItemType(itemId)
    local itemInfo = DYCommon.getDataByTag(DataRetainer.GAME_ITEM_INFO, "id", tostring(itemId))[1]
    local typeInfo = {
      [1] = "\232\180\167\229\184\129",
      [2] = "\229\184\184\232\167\132\233\129\147\229\133\183",
      [3] = "\229\133\181\231\167\141\231\162\142\231\137\135",
      [4] = "\230\179\149\229\153\168\231\137\169\229\147\129",
      [5] = "box\231\177\187\229\158\139"
    }
    return itemInfo and itemInfo.type and typeInfo[tonumber(itemInfo.type)] or checkstring(itemId)
  end
  
  function M.item.buy(itemId, itemType, itemCount, virtualCurrency, currencyType, consumePoint)
    if DYAnalyzeHelper and DYAnalyzeHelper.item then
      itemType = getItemType(itemId)
      itemId = getItemName(itemId)
      DYAnalyzeHelper.item.buy(itemId, itemType, itemCount, virtualCurrency, currencyType, consumePoint)
    end
  end
  
  function M.item.buyInLevel(itemId, itemType, itemCount, virtualCurrency, currencyType, consumePoint, levelId)
    if DYAnalyzeHelper and DYAnalyzeHelper.item then
      itemType = getItemType(itemId)
      itemId = getItemName(itemId)
      DYAnalyzeHelper.item.buyInLevel(itemId, itemType, itemCount, virtualCurrency, currencyType, consumePoint, levelId)
    end
  end
  
  function M.item.get(itemId, itemType, itemCount, reason)
    if DYAnalyzeHelper and DYAnalyzeHelper.item then
      itemType = getItemType(itemId)
      itemId = getItemName(itemId)
      DYAnalyzeHelper.item.get(itemId, itemType, itemCount, reason)
    end
  end
  
  function M.item.getInLevel(itemId, itemType, itemCount, reason, levelId)
    if DYAnalyzeHelper and DYAnalyzeHelper.item then
      itemType = getItemType(itemId)
      itemId = getItemName(itemId)
      DYAnalyzeHelper.item.getInLevel(itemId, itemType, itemCount, reason, levelId)
    end
  end
  
  function M.item.consume(itemId, itemType, itemCount, reason)
    if DYAnalyzeHelper and DYAnalyzeHelper.item then
      itemType = getItemType(itemId)
      itemId = getItemName(itemId)
      DYAnalyzeHelper.item.consume(itemId, itemType, itemCount, reason)
    end
  end
  
  function M.item.consumeInLevel(itemId, itemType, itemCount, reason, levelId)
    if DYAnalyzeHelper and DYAnalyzeHelper.item then
      itemType = getItemType(itemId)
      itemId = getItemName(itemId)
      DYAnalyzeHelper.item.consumeInLevel(itemId, itemType, itemCount, reason, levelId)
    end
  end
end
M.levels = {}

function M.levels.begin(levelId)
  if DYAnalyzeHelper and DYAnalyzeHelper.levels then
    DYAnalyzeHelper.levels.begin(levelId)
  end
end

function M.levels.complete(levelId)
  if DYAnalyzeHelper and DYAnalyzeHelper.levels then
    DYAnalyzeHelper.levels.complete(levelId)
  end
end

function M.levels.fail(levelId, failPoint)
  if DYAnalyzeHelper and DYAnalyzeHelper.levels then
    DYAnalyzeHelper.levels.fail(levelId, failPoint)
  end
end

M.task = {}

function M.task.begin(taskId, taskType)
  if DYAnalyzeHelper and DYAnalyzeHelper.task then
    DYAnalyzeHelper.task.begin(taskId, taskType)
  end
end

function M.task.complete(taskId)
  if DYAnalyzeHelper and DYAnalyzeHelper.task then
    DYAnalyzeHelper.task.complete(taskId)
  end
end

function M.task.fail(taskId, reason)
  if DYAnalyzeHelper and DYAnalyzeHelper.task then
    DYAnalyzeHelper.task.fail(taskId, reason)
  end
end

M.currency = {}

function M.currency.paymentSuccess(orderId, iapId, currencyAmount, currencyType, paymentType)
  if DYAnalyzeHelper and DYAnalyzeHelper.currency then
    DYAnalyzeHelper.currency.paymentSuccess(orderId, iapId, currencyAmount, currencyType, paymentType)
  end
end

function M.currency.paymentSuccessInLevel(orderId, iapId, currencyAmount, currencyType, paymentType, levelId)
  if DYAnalyzeHelper and DYAnalyzeHelper.currency then
    DYAnalyzeHelper.currency.paymentSuccessInLevel(orderId, iapId, currencyAmount, currencyType, paymentType, levelId)
  end
end

return M

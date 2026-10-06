local M = {}
local DCAccount = require(DataEye.PACKAGE_NAME .. ".DCAccount")
local DCAgent = require(DataEye.PACKAGE_NAME .. ".DCAgent")
local DCCardsGame = require(DataEye.PACKAGE_NAME .. ".DCCardsGame")
local DCCoin = require(DataEye.PACKAGE_NAME .. ".DCCoin")
local DCConfigParams = require(DataEye.PACKAGE_NAME .. ".DCConfigParams")
local DCEvent = require(DataEye.PACKAGE_NAME .. ".DCEvent")
local DCItem = require(DataEye.PACKAGE_NAME .. ".DCItem")
local DCLevels = require(DataEye.PACKAGE_NAME .. ".DCLevels")
local DCTask = require(DataEye.PACKAGE_NAME .. ".DCTask")
local DCVirtualCurrency = require(DataEye.PACKAGE_NAME .. ".DCVirtualCurrency")
M.account = {}

function M.account.login(...)
  DCAccount.login(...)
end

function M.account.logout()
  DCAccount.logout()
end

function M.account.getAccountId()
  return DCAccount.getAccountId()
end

function M.account.setAccountType(accountType)
  DCAccount.setAccountType(accountType)
end

function M.account.setLevel(level)
  DCAccount.setLevel(level)
end

function M.account.setGender(gender)
  DCAccount.setGender(gender)
end

function M.account.setAge(age)
  DCAccount.setAge(age)
end

function M.account.setGameServer(server)
  DCAccount.setGameServer(server)
end

function M.account.addTag(tag, subTag)
  DCAccount.addTag(tag, subTag)
end

function M.account.removeTag(tag, subTag)
  DCAccount.removeTag(tag, subTag)
end

M.agent = {}

function M.agent.onStart(appId, channelId)
  DCAgent.onStart(appId, channelId)
end

function M.agent.setDebugMode(mode)
  DCAgent.setDebugMode(mode)
end

function M.agent.setReportMode(mode)
  DCAgent.setReportMode(mode)
end

function M.agent.setUploadInterval(interval)
  DCAgent.setUploadInterval(interval)
end

function M.agent.setVersion(version)
  DCAgent.setVersion(version)
end

function M.agent.reportError(title, content)
  DCAgent.reportError(title, content)
end

function M.agent.uploadNow()
  DCAgent.uploadNow()
end

function M.agent.getUID()
  return DCAgent.getUID()
end

M.cardsGame = {}

function M.cardsGame.play(roomId, id, coinType, loseOrGain, tax, left)
  DCCardsGame.play(roomId, id, coinType, loseOrGain, tax, left)
end

function M.cardsGame.gain(roomId, id, coinType, gain, left)
  DCCardsGame.gain(roomId, id, coinType, gain, left)
end

function M.cardsGame.lost(roomId, id, coinType, lost, left)
  DCCardsGame.lost(roomId, id, coinType, lost, left)
end

M.coin = {}

function M.coin.setCoinNum(coinNum, coinType)
  DCCoin.setCoinNum(coinNum, coinType)
end

function M.coin.lost(id, coinType, lost, left)
  DCCoin.lost(id, coinType, lost, left)
end

function M.coin.lostInLevel(id, coinType, lost, left, levelId)
  DCCoin.lostInLevel(id, coinType, lost, left, levelId)
end

function M.coin.gain(id, coinType, gain, left)
  DCCoin.gain(id, coinType, gain, left)
end

function M.coin.gainInLevel(id, coinType, gain, left, levelId)
  DCCoin.gainInLevel(id, coinType, gain, left, levelId)
end

M.configParams = {}

function M.configParams.update()
  DCConfigParams.update()
end

function M.configParams.getParamNumber(key, defaultValue)
  return DCConfigParams.getParamNumber(key, defaultValue)
end

function M.configParams.getParamString(key, defaultValue)
  return DCConfigParams.getParamString(key, defaultValue)
end

function M.configParams.getParamBool(key, defaultValue)
  return DCConfigParams.getParamBool(key, defaultValue)
end

M.event = {}

function M.event.onEventBeforeLogin(eventId, map, duration)
  DCEvent.onEventBeforeLogin(eventId, map, duration)
end

function M.event.onEventCount(eventId, count)
  DCEvent.onEventCount(eventId, count)
end

function M.event.onEvent(eventId, label, map)
  DCEvent.onEvent(eventId, label, map)
end

function M.event.onEventDuration(eventId, label, map, duration)
  DCEvent.onEventDuration(eventId, label, map, duration)
end

function M.event.onEventBegin(eventId, map, flag)
  DCEvent.onEventBegin(eventId, map, flag)
end

function M.event.onEventEnd(eventId, map, flag)
  DCEvent.onEventEnd(eventId, map, flag)
end

M.item = {}

function M.item.buy(itemId, itemType, itemCount, virtualCurrency, currencyType, consumePoint)
  DCItem.buy(itemId, itemType, itemCount, virtualCurrency, currencyType, consumePoint)
end

function M.item.buyInLevel(itemId, itemType, itemCount, virtualCurrency, currencyType, consumePoint, levelId)
  DCItem.buyInLevel(itemId, itemType, itemCount, virtualCurrency, currencyType, consumePoint, levelId)
end

function M.item.get(itemId, itemType, itemCount, reason)
  DCItem.get(itemId, itemType, itemCount, reason)
end

function M.item.getInLevel(itemId, itemType, itemCount, reason, levelId)
  DCItem.getInLevel(itemId, itemType, itemCount, reason, levelId)
end

function M.item.consume(itemId, itemType, itemCount, reason)
  DCItem.consume(itemId, itemType, itemCount, reason)
end

function M.item.consumeInLevel(itemId, itemType, itemCount, reason, levelId)
  DCItem.consumeInLevel(itemId, itemType, itemCount, reason, levelId)
end

M.levels = {}

function M.levels.begin(levelId)
  DCLevels.begin(levelId)
end

function M.levels.complete(levelId)
  DCLevels.complete(levelId)
end

function M.levels.fail(levelId, failPoint)
  DCLevels.fail(levelId, failPoint)
end

M.task = {}

function M.task.begin(taskId, taskType)
  DCTask.begin(taskId, taskType)
end

function M.task.complete(taskId)
  DCTask.complete(taskId)
end

function M.task.fail(taskId, reason)
  DCTask.fail(taskId, reason)
end

M.currency = {}

function M.currency.paymentSuccess(orderId, iapId, currencyAmount, currencyType, paymentType)
  DCVirtualCurrency.paymentSuccess(orderId, iapId, currencyAmount, currencyType, paymentType)
end

function M.currency.paymentSuccessInLevel(orderId, iapId, currencyAmount, currencyType, paymentType, levelId)
  DCVirtualCurrency.paymentSuccessInLevel(orderId, iapId, currencyAmount, currencyType, paymentType, levelId)
end

return M

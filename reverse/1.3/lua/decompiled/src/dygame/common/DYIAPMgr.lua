local Store = import("framework.cc.sdk.Store")
local M = {}
local GAME_PRODUCTS = {}
if device.platform == "android" then
  GAME_PRODUCTS = {
    {
      id = "1",
      type = "CNY",
      price = "30",
      data = "0",
      name = "300\232\159\160\230\161\131\232\191\155\233\152\182\229\140\133",
      desc = ""
    },
    {
      id = "2",
      type = "CNY",
      price = "60",
      data = "0",
      name = "600\232\159\160\230\161\131\232\191\155\233\152\182\229\140\133",
      desc = ""
    },
    {
      id = "3",
      type = "CNY",
      price = "8",
      data = "0",
      name = "80\232\159\160\230\161\131\232\191\155\233\152\182\229\140\133",
      desc = ""
    },
    {
      id = "4",
      type = "CNY",
      price = "6",
      data = "0",
      name = "60\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "5",
      type = "CNY",
      price = "68",
      data = "0",
      name = "680\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "6",
      type = "CNY",
      price = "198",
      data = "0",
      name = "1980\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "7",
      type = "CNY",
      price = "328",
      data = "0",
      name = "3280\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "8",
      type = "CNY",
      price = "648",
      data = "0",
      name = "6480\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "9",
      type = "CNY",
      price = "6",
      data = "0",
      name = "6\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "10",
      type = "CNY",
      price = "30",
      data = "0",
      name = "30\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "11",
      type = "CNY",
      price = "68",
      data = "0",
      name = "68\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "12",
      type = "CNY",
      price = "198",
      data = "0",
      name = "198\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "13",
      type = "CNY",
      price = "328",
      data = "0",
      name = "328\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "14",
      type = "CNY",
      price = "648",
      data = "0",
      name = "648\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "15",
      type = "CNY",
      price = "30",
      data = "0",
      name = "300\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    }
  }
elseif device.platform == "ios" then
  GAME_PRODUCTS = {
    {
      id = "1",
      name1 = "GS_COIN1",
      type = "CNY",
      price = "30",
      data = "0",
      name = "300\232\159\160\230\161\131\232\191\155\233\152\182\229\140\133",
      desc = ""
    },
    {
      id = "2",
      name1 = "GS_COIN2",
      type = "CNY",
      price = "60",
      data = "0",
      name = "600\232\159\160\230\161\131\232\191\155\233\152\182\229\140\133",
      desc = ""
    },
    {
      id = "3",
      name1 = "GS_COIN15",
      type = "CNY",
      price = "8",
      data = "0",
      name = "80\232\159\160\230\161\131\232\191\155\233\152\182\229\140\133",
      desc = ""
    },
    {
      id = "4",
      name1 = "GS_COIN4",
      type = "CNY",
      price = "6",
      data = "0",
      name = "60\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "5",
      name1 = "GS_COIN6",
      type = "CNY",
      price = "68",
      data = "0",
      name = "680\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "6",
      name1 = "GS_COIN7",
      type = "CNY",
      price = "198",
      data = "0",
      name = "1980\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "7",
      name1 = "GS_COIN8",
      type = "CNY",
      price = "328",
      data = "0",
      name = "3280\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "8",
      name1 = "GS_COIN9",
      type = "CNY",
      price = "648",
      data = "0",
      name = "6480\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "9",
      name1 = "GS_COIN5",
      type = "CNY",
      price = "6",
      data = "0",
      name = "6\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "10",
      name1 = "GS_COIN10",
      type = "CNY",
      price = "30",
      data = "0",
      name = "30\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "11",
      name1 = "GS_COIN11",
      type = "CNY",
      price = "68",
      data = "0",
      name = "68\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "12",
      name1 = "GS_COIN12",
      type = "CNY",
      price = "198",
      data = "0",
      name = "198\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "13",
      name1 = "GS_COIN13",
      type = "CNY",
      price = "328",
      data = "0",
      name = "328\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "14",
      name1 = "GS_COIN14",
      type = "CNY",
      price = "648",
      data = "0",
      name = "648\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "15",
      name1 = "GS_COIN16",
      type = "CNY",
      price = "30",
      data = "0",
      name = "300\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    }
  }
else
  GAME_PRODUCTS = {
    {
      id = "1",
      type = "CNY",
      price = "30",
      data = "0",
      name = "300\232\159\160\230\161\131\232\191\155\233\152\182\229\140\133",
      desc = ""
    },
    {
      id = "2",
      type = "CNY",
      price = "60",
      data = "0",
      name = "600\232\159\160\230\161\131\232\191\155\233\152\182\229\140\133",
      desc = ""
    },
    {
      id = "3",
      type = "CNY",
      price = "8",
      data = "0",
      name = "80\232\159\160\230\161\131\232\191\155\233\152\182\229\140\133",
      desc = ""
    },
    {
      id = "4",
      type = "CNY",
      price = "6",
      data = "0",
      name = "60\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "5",
      type = "CNY",
      price = "68",
      data = "0",
      name = "680\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "6",
      type = "CNY",
      price = "198",
      data = "0",
      name = "1980\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "7",
      type = "CNY",
      price = "328",
      data = "0",
      name = "3280\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "8",
      type = "CNY",
      price = "648",
      data = "0",
      name = "6480\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    },
    {
      id = "9",
      type = "CNY",
      price = "6",
      data = "0",
      name = "6\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "10",
      type = "CNY",
      price = "30",
      data = "0",
      name = "30\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "11",
      type = "CNY",
      price = "68",
      data = "0",
      name = "68\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "12",
      type = "CNY",
      price = "198",
      data = "0",
      name = "198\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "13",
      type = "CNY",
      price = "328",
      data = "0",
      name = "328\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "14",
      type = "CNY",
      price = "648",
      data = "0",
      name = "648\229\133\131\233\129\147\229\133\183\229\140\133",
      desc = ""
    },
    {
      id = "15",
      type = "CNY",
      price = "30",
      data = "0",
      name = "300\232\159\160\230\161\131\229\165\151\233\164\144\229\140\133",
      desc = ""
    }
  }
end
local T_STORE = {}

local function onStoreEvent(transaction)
  if T_STORE.payListener then
    T_STORE.payListener(transaction)
    T_STORE.payListener = nil
  end
end

function M.init(param, iapHandler)
  param = param or GAME_PRODUCTS
  assert(type(param) == "table")
  
  local function tFuncListener(event)
    if iapHandler then
      local et = json.decode(event)
      et.param = json.decode(et.param)
      iapHandler(et)
    end
  end
  
  local strParam = json.encode(param)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYIAPMgr", "init", {"", tFuncListener})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYIAPMgr_iOS", "init", {param = strParam, listener = tFuncListener})
  else
    local fakeEvent = {}
    fakeEvent.event = dy.iap.EVENT_INIT_SUCC
    fakeEvent.param = json.encode(param)
    
    local function tFuncDelay()
      tFuncListener(json.encode(fakeEvent))
    end
    
    DYUtils.schedule(tFuncDelay, 0, 1)
  end
end

function M.pay(iapParam, iapHandler)
  local param = iapParam or {}
  assert(type(param) == "table")
  
  local function tFuncListener(event)
    if iapHandler then
      local et = json.decode(event)
      et.param = json.decode(et.param)
      iapHandler(et)
    end
  end
  
  local strParam = json.encode(param)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYIAPMgr", "pay", {strParam, tFuncListener})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYIAPMgr_iOS", "pay", {param = strParam, listener = tFuncListener})
  else
    local fakeEvent = {}
    fakeEvent.event = dy.iap.EVENT_PAY_SUCC
    fakeEvent.param = json.encode(param)
    
    local function tFuncDelay()
      tFuncListener(json.encode(fakeEvent))
    end
    
    DYUtils.schedule(tFuncDelay, 0, 1)
  end
end

function M.setNotifyUrl(param)
  local strParam = param
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/common/DYIAPMgr", "setNotifyUrl", {strParam})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DYIAPMgr_iOS", "setNotifyUrl", {param = strParam})
  end
end

function M.getProducts()
  return GAME_PRODUCTS
end

return M

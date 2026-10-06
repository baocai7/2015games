DataLayer = {}
DataLayer = class("DataLayer")
DataLayer.__index = DataLayer
DataLayer.handlerList = {}
DataLayer.CACHE = {}
require("app.communication/DTO")

function DataLayer.create()
  local dataLayer = DataLayer.new()
  dataLayer:init()
  return dataLayer
end

local instance

function DataLayer.getInstance()
  if instance == nil then
    instance = DataLayer.create()
  end
  return instance
end

function DataLayer:init()
end

function DataLayer:registerHandler(protocol, handler)
  local handlers = DataLayer.handlerList[protocol]
  if handlers == nil then
    handlers = {}
    DataLayer.handlerList[protocol] = handlers
  end
  table.insert(handlers, #handlers + 1, handler)
end

function DataLayer:unregisterHandler(protocol, handler)
  local handlers = DataLayer.handlerList[protocol]
  if handlers ~= nil then
    gg.removeFromTable(handlers, handler)
  end
end

function DataLayer:onSocketData(buf)
  local protocol = buf:readUInt()
  local cls = DataLayer.CACHE[protocol]
  if cls == nil then
    return
  end
  local obj = cls.new()
  obj:decode(buf)
  local handlers = DataLayer.handlerList[protocol]
  if handlers ~= nil then
    local len = #handlers
    for i = 1, len do
      handlers[i]:onNetEvent(protocol, obj)
    end
  end
end

gg = gg or {}
gg.netHandler = DataLayer.getInstance()

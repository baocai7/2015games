require("app.kernel.GameEventType")
require("app.kernel.GameEvent")
GameEventDispatcher = {}
GameEventDispatcher = class("GameEventDispatcher")
GameEventDispatcher.__index = GameEventDispatcher
gg = gg or {}

function GameEventDispatcher:ctor()
  self.events = {}
end

local instance

function GameEventDispatcher.getInstance()
  if instance == nil then
    instance = GameEventDispatcher.new()
  end
  return instance
end

function GameEventDispatcher:addEventListener(type, listener)
  local listeners = self.events[type]
  if listeners == nil then
    listeners = {}
    self.events[type] = listeners
  end
  table.insert(listeners, #listeners + 1, listener)
end

GameEventDispatcher.register = GameEventDispatcher.addEventListener

function GameEventDispatcher:removeEventListener(type, listener)
  if listener == nil then
    self.events[type] = nil
  else
    local listeners = self.events[type]
    if listeners ~= nil then
      gg.removeFromTable(listeners, listener)
    end
  end
end

GameEventDispatcher.unregister = GameEventDispatcher.removeEventListener

function GameEventDispatcher:dispatchEvent(evt)
  local type = evt.type
  local listeners = self.events[type]
  if listeners ~= nil then
    local len = #listeners
    for i = 1, len do
      listeners[i]:onUIEvent(type, evt.data)
    end
  end
end

GameEventDispatcher.dispatch = GameEventDispatcher.dispatchEvent

function GameEventDispatcher:hasEventListener(type)
  return self.events[type] ~= nil
end

function GameEventDispatcher:willTrigger(type)
  return false
end

gg.gameEventDispatcher = GameEventDispatcher.getInstance()

GameEvent = {}
GameEvent = class("GameEvent")
GameEvent.__index = GameEvent

function GameEvent:ctor(type)
  self.type = type
  self.data = {}
  return self
end

function GameEvent.create(type)
  return GameEvent.new(type)
end

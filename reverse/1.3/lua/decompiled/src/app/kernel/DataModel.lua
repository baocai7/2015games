require("app.kernel.GameEventDispatcher")
DataModel = {}
DataModel = class("DataModel")
DataModel.__index = DataModel
local instance

function DataModel.getInstance()
  if instance == nil then
    instance = DataModel.new()
    instance:init()
  end
  return instance
end

function DataModel:init()
  self.m_cbs = {}
  self:register()
end

function DataModel:register()
  local cbs = {}
  for protocol, callback in pairs(cbs) do
    self:registerHandler(protocol, callback)
  end
end

function DataModel:registerHandler(protocol, callback)
  gg.netHandler:registerHandler(protocol, self)
  self.m_cbs[protocol] = callback
end

function DataModel:onNetEvent(protocol, obj)
  local func = self.m_cbs[protocol]
  if func ~= nil then
    func(self, obj)
  else
    print("Protocol" .. protocol .. "Error")
  end
end

function DataModel:REQUEST_LOGIN(username, password)
  local obj = RequestLogin.new()
  obj.username = username
  obj.password = password
  USocket.getInstance():send(Protocol.REQUEST_LOGIN, obj)
end

function DataModel:RESPONSE_LOGIN_SUCCESS(obj)
  print(DYLang.getString("S419", ""))
end

function DataModel:RESPONSE_LOGIN_FAILED(obj)
  print(DYLang.getString("S420", ""))
end

function DataModel:REQUEST_TRAIN(npcId)
  local obj = RequestTrain.new()
  obj.npcId = npcId
  USocket.getInstance():send(Protocol.REQUEST_TRAIN, obj)
end

function DataModel:RESPONSE_TRAIN_SUCCESS(obj)
  local uid = obj.uid
  local npcId = obj.npcId
  local evt = GameEvent.create(GameEventType.M2U_TRAIN)
  evt.data.uid = uid
  evt.data.npcId = npcId
  gg.gameEventDispatcher:dispatch(evt)
end

function DataModel:RESPONSE_TRAIN_FAILED(obj)
end

function DataModel:REQUEST_FIGHT_RESULT(result)
  local obj = RequestFightResult.new()
  obj.result = result
  USocket.getInstance().send(Protocol.REQUEST_FIGHT_RESULT, obj)
end

function DataModel:RESPONSE_FIGHT_RESULT_SUCCESS(obj)
  local result = obj.result
  local evt = GameEvent.create(GameEventType.M2U_FIGHT_RESULT)
  evt.result = result
  gg.gameEventDispatcher:dispatch(evt)
end

function DataModel:RESPONSE_FIGHT_RESULT_FAILED(obj)
end

gg = gg or {}
gg.model = DataModel.getInstance()

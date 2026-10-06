require("app.communication/DataLayer")
USocket = {}
USocket = class("USocket")
USocket.__index = USocket
USocket.m_ws = nil
USocket.m_recvBuf = nil
USocket.m_sendBuf = nil
USocket.m_connected = false
USocket.m_connecting = false
USocket.m_cache = {}

function USocket.create()
  local socket = USocket.new()
  socket:init()
  return socket
end

local instance

function USocket.getInstance()
  if instance ~= nil and instance.m_connected ~= true and instance.m_connecting == false then
    instance = nil
  end
  if instance == nil then
    instance = USocket.create()
  end
  return instance
end

local address

function USocket.setAddress(addr)
  address = addr
end

function USocket:init()
  self.m_cache = nil
  self.m_connected = false
  self.m_ws = cc.WebSocket:create(address)
  self.m_connecting = true
  self.m_recvBuf = cc.ByteArray:create(8192)
  self.m_recvBuf:retain()
  self.m_sendBuf = cc.ByteArray:create(8192)
  self.m_sendBuf:retain()
  
  local function onOpen()
    print("opOpen")
    self.m_connected = true
    self.m_connecting = false
    if self.m_cache ~= nil then
      for i = 1, #self.m_cache do
        self:send(self.m_cache[i][1], self.m_cache[i][2])
      end
      self.m_cache = nil
    end
  end
  
  local function onMessage(data)
    print("onMessage")
    self.m_recvBuf:setBuffer(data)
    DataLayer.getInstance():onSocketData(self.m_recvBuf)
  end
  
  local function onClose()
    print("onClose")
    if self.m_connected then
    else
    end
    self.m_connected = false
    self.m_connecting = false
  end
  
  local function onError()
    print("onError")
    self.m_connected = false
  end
  
  if self.m_ws ~= nil then
    self.m_ws:registerScriptHandler(onOpen, cc.WEBSOCKET_OPEN)
    self.m_ws:registerScriptHandler(onMessage, cc.WEBSOCKET_MESSAGE)
    self.m_ws:registerScriptHandler(onClose, cc.WEBSOCKET_CLOSE)
    self.m_ws:registerScriptHandler(onError, cc.WEBSOCKET_ERROR)
  end
end

function USocket:send(protocol, obj)
  if self.m_connected == false then
    self.m_cache = self.m_cache or {}
    self.m_cache[#self.m_cache + 1] = {protocol, obj}
    return
  end
  self.m_sendBuf:reset()
  self.m_sendBuf:writeUInt(protocol)
  if obj ~= nil then
    obj:encode(self.m_sendBuf)
  end
  self.m_ws:sendString(self.m_sendBuf:getPack())
end

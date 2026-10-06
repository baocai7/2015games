local Node = cc.Node

function Node:addUnit(unitPath)
  local tUnit = require(unitPath).new()
  if not tUnit then
    return
  end
  local units = self.__units or {}
  self.__units = units
  units[tUnit.__cname] = tUnit
  tUnit.__target = self
  tUnit:onLoad_()
  self:performWithDelay(function()
    tUnit:onStart_()
  end, 0)
  return tUnit
end

function Node:getUnit(unitName)
  if not self.__units then
    return
  end
  return self.__units[unitName]
end

function Node:removeUnit(unitName)
  if not self.__units then
    return
  end
  local tUnit = self.__units[unitName]
  if tUnit then
    tUnit:onDestroy_()
    self.__units[unitName] = nil
  end
  return
end

function Node:removeAllUnits()
  if not self.__units then
    return
  end
  for k, v in pairs(self.__units) do
    if v then
      v:onDestroy_()
      self.__units[k] = nil
    end
  end
  self.__units = nil
  return
end

function Node:setNodeEventEnabled(enabled, listener)
  if enabled then
    if self.__node_event_handle__ then
      self:removeNodeEventListener(self.__node_event_handle__)
      self.__node_event_handle__ = nil
    end
    listener = listener or function(event)
      local name = event.name
      if name == "enter" then
        self:onEnter()
      elseif name == "exit" then
        self:onExit()
        DYNotification.removeAllObservers(self)
        self:removeAllUnits()
      elseif name == "enterTransitionFinish" then
        self:onEnterTransitionFinish()
      elseif name == "exitTransitionStart" then
        self:onExitTransitionStart()
      elseif name == "cleanup" then
        self:onCleanup()
      end
    end
    self.__node_event_handle__ = self:addNodeEventListener(cc.NODE_EVENT, listener)
  elseif self.__node_event_handle__ then
    self:removeNodeEventListener(self.__node_event_handle__)
    self.__node_event_handle__ = nil
  end
  return self
end

function Node:safeHttpRequest(api, listener, ...)
  self.__httpProxy = self.__httpProxy or self:addUnit("dygame.units.DYHttpProxy")
  local tEvent = self.__httpProxy:request(api, ...)
  if not tEvent then
    return
  end
  DYNotification.regObserver(self, function(tag, param)
    if listener then
      listener(param)
    end
    DYNotification.unregisterScriptObserver(self, tEvent)
  end, tEvent)
end

function Node:safeSocketRequest(cmd, param, listener)
  self.__socketProxy = self.__socketProxy or self:addUnit("dygame.units.DYSocketProxy")
  local tEvent = self.__socketProxy:request(cmd, param)
  if not tEvent then
    return
  end
  DYNotification.regObserver(self, function(tag, ret)
    if listener then
      listener(ret)
    end
    DYNotification.unregisterScriptObserver(self, tEvent)
  end, tEvent)
end

function Node:safeSocketListen(cmd, listener, isOnce)
  self.__socketProxy = self.__socketProxy or self:addUnit("dygame.units.DYSocketProxy")
  local tEvent = self.__socketProxy:listen(cmd, isOnce)
  if not tEvent then
    return
  end
  DYNotification.regObserver(self, function(tag, ret)
    if listener then
      listener(ret)
    end
    if isOnce then
      DYNotification.unregisterScriptObserver(self, tEvent)
    end
  end, tEvent)
end

function Node:safeSocketCancel(cmd)
  if not self.__socketProxy or not self.__socketProxy:isValid() then
    return
  end
  self.__socketProxy:cancel(cmd)
end

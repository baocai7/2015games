local CLASS_NAME = "DYUnitBase"
local M = class(CLASS_NAME)

function M:getTarget()
  return self.__target
end

function M:getName()
  return self.__cname
end

function M:isValid()
  return self.__isValid
end

function M:onLoad()
end

function M:onStart()
end

function M:onDestroy()
end

function M:onLoad_()
  self.__isValid = true
  self:onLoad()
end

function M:onStart_()
  self:onStart()
end

function M:onDestroy_()
  self:onDestroy()
  self.__isValid = false
  self.__target = nil
end

return M

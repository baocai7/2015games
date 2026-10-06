local CLASS_NAME = "DYRandomSeq"
local S_MAX_QSIZE = 20000
local S_MAX_QLEN = 100000
local M = {}
M = class(CLASS_NAME, function()
  return {}
end)

function M:ctor(sid)
  DDLOG(CLASS_NAME .. ": onCreate ->" .. sid)
  self.mSid = sid
end

local a = 7
local max = 2147483647

function M:random(m, n)
  self.mSid = a * self.mSid % max
  local rand = self.mSid % (n - m) + m
  return rand
end

return M

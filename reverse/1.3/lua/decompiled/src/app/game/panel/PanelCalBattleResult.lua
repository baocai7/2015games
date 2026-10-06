local M = {}

function M.init()
  M.FRAME_SEC = 24
  M._eventList = nil
  M._maxBattleTime = 600 * M.FRAME_SEC
end

function M.setEventList(eventList)
  M._eventList = eventList
end

function M.calResult()
end

return M

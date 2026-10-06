local DCTask = {}

function DCTask.begin(taskId, taskType)
  taskId = checkstring(taskId)
  taskType = checkstring(taskType)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaTask", "begin", {taskId, taskType})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaTask", "begin", {taskId = taskId, taskType = taskType})
  end
end

function DCTask.complete(taskId)
  taskId = checkstring(taskId)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaTask", "complete", {taskId})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaTask", "complete", {taskId = taskId})
  end
end

function DCTask.fail(taskId, reason)
  taskId = checkstring(taskId)
  reason = checkstring(reason)
  if device.platform == "android" then
    luaj.callStaticMethod("com/dygame/open/dataeye/DCLuaTask", "fail", {taskId, reason})
  elseif device.platform == "ios" then
    luaoc.callStaticMethod("DCLuaTask", "fail", {taskId = taskId, reason = reason})
  end
end

return DCTask

function __G__TRACKBACK__(errorMessage)
  print("----------------------------------------")
  
  print("[errorMessage]")
  print(errorMessage)
  local errorStack = debug.traceback("", 2)
  print("[errorStack]")
  print(errorStack)
  local errorLog = errorMessage .. "\n" .. errorStack
  print("----------------------------------------")
  if dy.ERROR_LIST then
    local error = {label = "LUA_ERROR", log = errorLog}
    table.insert(dy.ERROR_LIST, error)
  end
end

package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
require("app.MyApp").new():run()

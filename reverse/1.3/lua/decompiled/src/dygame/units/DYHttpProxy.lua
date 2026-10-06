local CLASS_NAME = "DYHttpProxy"
local M = class(CLASS_NAME, DYUnitBase)

function M:request(api, ...)
  local tApi = DYHttpMgr[api]
  if not tApi then
    return
  end
  local tEvent = DYCommon.genGlobalTag()
  
  local function tFuncListener(ret)
    DYNotification.post(tEvent, ret)
  end
  
  tApi(tFuncListener, ...)
  return tEvent
end

return M

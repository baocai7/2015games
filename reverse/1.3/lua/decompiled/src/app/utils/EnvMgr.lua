local ENV_CONFIG = {SCENE_ELEMENT = "0", SCENE_ELEMENT_FOR_MONSTER = "0"}
local M = {}

function M.set(kEnv, val, isPersist)
  local cfg = ENV_CONFIG[kEnv]
  if not cfg then
    DDERROR("ENV[%s] not DEFINE in ENV_CONFIG yet", kEnv)
    return
  end
  local v1 = M.get(kEnv)
  local v2 = checkstring(val)
  local k = string.format("K_ENV_%s", kEnv)
  DYMem.set(k, checkstring(val))
  if isPersist then
    DYStat.setValueStr(k, checkstring(val))
  end
  if v1 ~= v2 then
    DYNotification.post(DY_KEY.kEnvChanged, {
      k = kEnv,
      pre = v1,
      cur = v2
    })
  end
end

function M.get(kEnv)
  local cfg = ENV_CONFIG[kEnv]
  if not cfg then
    DDERROR("ENV[%s] not DEFINE in ENV_CONFIG yet", kEnv)
    return
  end
  local k = string.format("K_ENV_%s", kEnv)
  local ret = DYMem.get(k, nil)
  if ret then
    return ret
  end
  return DYStat.getValueStr(k, cfg)
end

function M.reset(kEnv)
  local cfg = ENV_CONFIG[kEnv]
  if not cfg then
    DDERROR("ENV[%s] not DEFINE in ENV_CONFIG yet", kEnv)
    return
  end
  local v1 = M.get(kEnv)
  local v2 = checkstring(cfg)
  local k = string.format("K_ENV_%s", kEnv)
  DYMem.clear(k)
  DYStat.clear(k)
  if v1 ~= v2 then
    DYNotification.post(DY_KEY.kEnvChanged, {
      k = kEnv,
      pre = v1,
      cur = v2
    })
  end
end

return M

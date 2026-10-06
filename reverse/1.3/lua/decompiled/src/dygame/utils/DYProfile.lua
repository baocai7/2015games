local M = {}
local S_PROFILE_CACHE

function M.init()
  S_PROFILE_CACHE = {}
end

function M.lock(pk)
  if S_PROFILE_CACHE then
    local p = S_PROFILE_CACHE[pk] or {
      times = 0,
      avg = 0,
      min = 36000000,
      max = -1
    }
    p.cost = DYUtils.currentMillisecond()
    S_PROFILE_CACHE[pk] = p
    return p
  end
end

function M.unlock(p)
  if S_PROFILE_CACHE and p then
    local cost = DYUtils.currentMillisecond() - p.cost
    local times = p.times + 1
    p.avg = (p.avg * p.times + cost) / times
    p.cost = cost
    p.times = times
    if cost < p.min then
      p.min = cost
    end
    if cost > p.max then
      p.max = cost
    end
  end
end

function M.dump()
  if S_PROFILE_CACHE then
    DDLOG("%s ----- %s ----- %s ----- %s     [%s:%d]", "TIMES", "AVG", "MIN", "MAX", "Profile", DYUtils.currentMillisecond())
    table.walk(S_PROFILE_CACHE, function(v, k)
      if v then
        DDLOG("- %s -        %s        %s        %s      %s", tostring(v.times), tostring(v.avg), tostring(v.min), tostring(v.max), tostring(k))
      end
    end)
  end
end

return M

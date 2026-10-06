local M = {}

function M.getValueStr(key, default)
  return dy.Stat:getInstance():getValueStr(key, default)
end

function M.getValueBool(key, default)
  return dy.Stat:getInstance():getValueBool(key, default)
end

function M.getValueInt(key, default)
  return dy.Stat:getInstance():getValueInt(key, default)
end

function M.getValueFloat(key, default)
  return dy.Stat:getInstance():getValueFloat(key, default)
end

function M.setValueStr(key, val)
  val = checkstring(val)
  dy.Stat:getInstance():setValueStr(key, val)
end

function M.setValueBool(key, val)
  val = checkbool(val)
  dy.Stat:getInstance():setValueBool(key, val)
end

function M.setValueInt(key, val)
  val = math.floor(checknumber(val))
  dy.Stat:getInstance():setValueInt(key, val)
end

function M.setValueFloat(key, val)
  val = checknumber(val)
  dy.Stat:getInstance():setValueFloat(key, val)
end

function M.clear(key)
  dy.Stat:getInstance():resetKey(key)
end

return M

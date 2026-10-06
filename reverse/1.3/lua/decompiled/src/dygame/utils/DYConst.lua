dy = dy or {}
dy.iap = {
  EVENT_INIT_SUCC = "EVENT_INIT_SUCC",
  EVENT_INIT_FAIL = "EVENT_INIT_FAIL",
  EVENT_PAY_SUCC = "EVENT_PAY_SUCC",
  EVENT_PAY_FAIL = "EVENT_PAY_FAIL",
  EVENT_QUERY_SUCC = "EVENT_QUERY_SUCC",
  EVENT_QUERY_FAIL = "EVENT_QUERY_FAIL",
  EVENT_REFUND_SUCC = "EVENT_REFUND_SUCC",
  EVENT_REFUND_FAIL = "EVENT_REFUND_FAIL"
}
dy.login = {
  EVENT_INIT_SUCC = "EVENT_INIT_SUCC",
  EVENT_INIT_FAIL = "EVENT_INIT_FAIL",
  EVENT_LOGIN_SUCC = "EVENT_LOGIN_SUCC",
  EVENT_LOGIN_FAIL = "EVENT_LOGIN_FAIL",
  EVENT_LOGOUT_SUCC = "EVENT_LOGOUT_SUCC",
  EVENT_LOGOUT_FAIL = "EVENT_LOGOUT_FAIL"
}
dy.push = {
  EVENT_INIT_SUCC = "EVENT_INIT_SUCC",
  EVENT_INIT_FAIL = "EVENT_INIT_FAIL"
}
dy.share = {
  EVENT_INIT_SUCC = "EVENT_INIT_SUCC",
  EVENT_INIT_FAIL = "EVENT_INIT_FAIL",
  EVENT_SHARE_SUCC = "EVENT_SHARE_SUCC",
  EVENT_SHARE_FAIL = "EVENT_SHARE_FAIL"
}
dy.download = {
  EVENT_PROGRESS = 0,
  EVENT_SUCCESS = 1,
  EVENT_ERROR = 2
}
dy.update = {
  EVENT_NO_UPDATE = "0",
  EVENT_QUIET_UPDATE = "1",
  EVENT_TIP_UPDATE = "2",
  EVENT_FORCE_UPDATE = "3"
}
dy.ens = {
  BREAK_STATE_WELL = 0,
  BREAK_STATE_CRACK = 1,
  BREAK_STATE_FALL_OFF = 2
}
dy.action = {
  EVENT_UPDATE = "ON_UPDATE",
  EVENT_START_WITH_TARGET = "ON_START_WITH_TARGET"
}
dy.channel = {DAYU = "000000", APPSTORE = "000001"}
dy.quit = {
  EVENT_CONFIRM = "EVENT_CONFIRM",
  EVENT_IGNORE = "EVENT_IGNORE",
  EVENT_CANCEL = "EVENT_CANCEL"
}

function checkstring(value)
  if value ~= nil then
    return tostring(value)
  end
  return ""
end

function pickle(t)
  local Pickle = {
    clone = function(t)
      local nt = {}
      for i, v in pairs(t) do
        nt[i] = v
      end
      return nt
    end
  }
  
  function Pickle:pickle_(root)
    if type(root) ~= "table" then
      error("can only pickle tables, not " .. type(root) .. "s")
    end
    self._tableToRef = {}
    self._refToTable = {}
    local savecount = 0
    self:ref_(root)
    local s = ""
    while savecount < table.getn(self._refToTable) do
      savecount = savecount + 1
      local t = self._refToTable[savecount]
      s = s .. "{\n"
      for i, v in pairs(t) do
        s = string.format("%s[%s]=%s,\n", s, self:value_(i), self:value_(v))
      end
      s = s .. "},\n"
    end
    return string.format("{%s}", s)
  end
  
  function Pickle:value_(v)
    local vtype = type(v)
    if vtype == "string" then
      return string.format("%q", v)
    elseif vtype == "number" then
      return v
    elseif vtype == "table" then
      return "{" .. self:ref_(v) .. "}"
    else
      if vtype == "boolean" then
        return tostring(v)
      else
      end
    end
  end
  
  function Pickle:ref_(t)
    local ref = self._tableToRef[t]
    if not ref then
      if t == self then
        error("can't pickle the pickle class")
      end
      table.insert(self._refToTable, t)
      ref = table.getn(self._refToTable)
      self._tableToRef[t] = ref
    end
    return ref
  end
  
  return Pickle:clone():pickle_(t)
end

function unpickle(s)
  if type(s) ~= "string" then
    error("can't unpickle a " .. type(s) .. ", only strings")
  end
  local gentables = loadstring("return " .. s)
  local tables = gentables()
  for tnum = 1, table.getn(tables) do
    local t = tables[tnum]
    local tcopy = {}
    for i, v in pairs(t) do
      tcopy[i] = v
    end
    for i, v in pairs(tcopy) do
      local ni, nv
      if type(i) == "table" then
        ni = tables[i[1]]
      else
        ni = i
      end
      if type(v) == "table" then
        nv = tables[v[1]]
      else
        nv = v
      end
      t[i] = nil
      t[ni] = nv
    end
  end
  return tables[1]
end

function table.toarray(tb)
  local tempTable = {}
  for k, v in pairs(tb) do
    if v then
      tempTable[#tempTable + 1] = v
    end
  end
  return tempTable
end

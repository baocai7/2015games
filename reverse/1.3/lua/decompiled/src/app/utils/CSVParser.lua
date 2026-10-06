local CSVParser = {}
CSVParser = class("CSVParser")

function CSVParser:ctor(csvFileName, isBuffer)
  local function explode(separator, str)
    local array_str_tab = {}
    
    while true do
      local pos = string.find(str, separator)
      if not pos then
        array_str_tab[#array_str_tab + 1] = str
        break
      end
      local sub_str = string.sub(str, 1, pos - 1)
      array_str_tab[#array_str_tab + 1] = sub_str
      str = string.sub(str, pos + 1, #str)
    end
    return array_str_tab
  end
  
  local buffer
  if isBuffer then
    self.m_isBuffer = isBuffer
    self.tab_xy = csvFileName
    return
  else
    self.csvFileName = csvFileName
    local path = cc.FileUtils:getInstance():fullPathForFilename(self.csvFileName)
    print("path.." .. path)
    buffer = cc.FileUtils:getInstance():getStringFromFile(path)
  end
  local table_temp = {}
  table_temp = explode("\n", buffer)
  self.tab_xy = {}
  for i, v in pairs(table_temp) do
    self.tab_xy[i] = explode(",", v)
  end
  table_temp = nil
end

function CSVParser:getTotalRows()
  if self.m_isBuffer then
    return #self.tab_xy
  end
  return #self.tab_xy - 1
end

function CSVParser:getTotalColumns()
  return #self.tab_xy[1]
end

function CSVParser:findIndexOfValueFromRow(row, value)
  if value == "level1Param" then
  end
  if self.m_isBuffer and row == 1 then
    return self.tab_xy.index[value] or -1
  end
  for i, v in pairs(self.tab_xy[row]) do
    if value == v then
      return i
    end
  end
  return -1
end

function CSVParser:findIndexOfValueFromColumn(column, value)
  for i, v in pairs(self.tab_xy) do
    if v[column] == value then
      return i
    end
  end
  return -1
end

function CSVParser:getData(row, column)
  return self.tab_xy[row][column]
end

function CSVParser:getDatas(row)
  return self.tab_xy[row]
end

function CSVParser:getTable()
  return self.tab_xy
end

function CSVParser:objectAtIndex(row)
  local line1 = self.tab_xy[1]
  local lineRow = self.tab_xy[row + 1]
  if lineRow == nil then
    return
  end
  local key = {}
  local value = {}
  for i, v in pairs(line1) do
    key[#key + 1] = v
  end
  for i, v in pairs(lineRow) do
    value[#value + 1] = v
  end
  local final = {}
  for i, v in pairs(key) do
    final[v] = value[i]
  end
  return final
end

return CSVParser

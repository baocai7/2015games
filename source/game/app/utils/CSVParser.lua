
local CSVParser = {}
CSVParser = class("CSVParser")

function CSVParser:ctor(csvFileName, isBuffer)

    ---- function explode :
    -- @param separator(string): split string with separator
    -- @param str(string): ori string ready to explode
    -- @return data(table)
    --
    local function explode(separator, str)
        local array_str_tab = {};
        --print(#array_str_tab)
        while (true) do
            local pos = string.find(str, separator);
            -- >if not found return Str
            if (not pos) then
                array_str_tab[#array_str_tab + 1] = str;
                break;
            end
            -- <
            local sub_str = string.sub(str, 1, pos - 1);
            --print(#array_str_tab)
            array_str_tab[#array_str_tab + 1] = sub_str;
            str = string.sub(str, pos + 1, #str);
        end
        return array_str_tab;
    end

    local buffer = nil
    if(isBuffer) then
        --buffer = csvFileName
        self.m_isBuffer = isBuffer
        self.tab_xy = csvFileName -- 直接跳过解析这一步,游戏启动加速
        return 
    else
        self.csvFileName = csvFileName
        local path = cc.FileUtils:getInstance():fullPathForFilename(self.csvFileName)

        print("path.."..path)

        buffer = cc.FileUtils:getInstance():getStringFromFile(path)
    end
    --print("buffer"..buffer)

    --local lines = io.open(path,"r")
    --local l = lines:read("*all")

    -- local lines = {}
    -- for line in io.lines(""..path) do
    --     table.insert(lines, line)
    -- end

    local table_temp = {}
    table_temp = explode('\n',buffer)

    self.tab_xy = {}
    for i,v in pairs(table_temp) do
        self.tab_xy[i] = explode(',',v)
    end

    table_temp = nil

    --    for i,v in pairs(tab_xy) do
    --        for j,w in pairs(v) do
    --            print(i.."->"..j.."...."..w)
    --        end
    --    end
end

--返回行数
function CSVParser:getTotalRows()
    if(self.m_isBuffer) then
        return #self.tab_xy
    end
    
    return #self.tab_xy - 1
end

--返回列数
function CSVParser:getTotalColumns()
    return #self.tab_xy[1]
end

--返回指定数值在特定行中的索引，若没有找到返回-1
function CSVParser:findIndexOfValueFromRow(row,value)
    if(value=="level1Param") then
--        print("xx")
    end
    
    if(self.m_isBuffer and row==1) then
--        print("A   findIndexOfValueFromRow", value, self.tab_xy["index"][value] or -1)
        return self.tab_xy["index"][value] or -1
    end

--    print("B   findIndexOfValueFromRow", value)
    
    for i,v in pairs(self.tab_xy[row]) do
        if value == v then
            return i
        end
    end

    return -1
end

--返回指定数值在特定列中的索引，若没有找到返回-1
function CSVParser:findIndexOfValueFromColumn(column,value)
    
    for i,v in pairs(self.tab_xy) do
        if v[column] == value then
            return i
        end
    end
    return -1
end

--取指定行指定列的 值
function CSVParser:getData(row,column)
    local dataRow = self.tab_xy[row]
    if dataRow == nil or column == nil or column < 1 then
        return nil
    end
    return dataRow[column]
end

-- 取指定行
function CSVParser:getDatas(row)
    return self.tab_xy[row]
end

function CSVParser:getTable()
    return self.tab_xy
end

function CSVParser:objectAtIndex( row )
    local line1 = self.tab_xy[1]
    local lineRow = self.tab_xy[row+1]

    local key = {}
    local value =  {}

    for i,v in pairs(line1) do
        --print(i.. "  " .. v)
        key[#key + 1] = v
    end

    for i,v in pairs(lineRow) do
        --print(i.. "  " .. v)
        value[#value + 1] = v
    end

    local final = {}

    for i,v in pairs(key) do
        final[v] = value[i]
    end

    return final
end


return CSVParser

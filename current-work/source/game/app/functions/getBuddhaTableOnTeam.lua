

function DataUtils.getBuddhaTableOnTeam()
    local stringBuddhaIds = cc.UserDefault:getInstance():getStringForKey("buddha_on_team","1,")

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

    local table = explode(",",stringBuddhaIds)

    return table
end

function DataUtils.setBuddhaTableOnTeam(table)

    local stringBuddhaIds = ""

    for i,buddhaId in pairs(table) do
        if buddhaId ~= "" then
            stringBuddhaIds = stringBuddhaIds..buddhaId..","
        end
        
    end

    cc.UserDefault:getInstance():setStringForKey("buddha_on_team",stringBuddhaIds)
end
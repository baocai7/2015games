DataUtils = {}

import("functions.getBuddhaModel")
import("functions.getMonsterModel")
import("functions.getInfiniteMonsterModel")
import("functions.getMonsterPieceModel")
import("functions.getStageModel")
import("functions.getTowerBuddhaModel")
import("functions.getTowerMonsterModel")
import("functions.getUpgradePropertyModel")
import("functions.getTreasurePieceModel")
import("functions.getTreasureModel")
import("functions.getChapterLocationTable")
import("functions.getSpiritCostBasic")
import("functions.getBuddhaTableOnTeam")
import("functions.getAchievementModel")
import("functions.getDailyTaskModel")
import("functions.getStageTaskModel")
import("functions.getStageTaskSubModel")
import("functions.getSkillItemModel")
import("functions.getPaymentModel")
import("functions.getInfiniteStageModel")
import("functions.getMonsterWaveModel")
import("functions.setNewBuddhaCloudData")
import("functions.saveLocalData")

---- function explode :
-- @param separator(string): split string with separator
-- @param str(string): ori string ready to explode
-- @return data(table)
--
function explode(separator, str)
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

function split(s, p)
    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt
end
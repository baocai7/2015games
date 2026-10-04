
-- 1级
function DataUtils.setNewBuddhaCloudData( id )
    --default : isActive = 0, addlevel = 0, level = 0, npcId = 0, status = 0
    CloudData.NPC_INFO[id].npcId = id
    CloudData.NPC_INFO[id].isActive = 1
    CloudData.NPC_INFO[id].addlevel = 0
    CloudData.NPC_INFO[id].status = 1
    CloudData.NPC_INFO[id].level = 1
end


-- 10 级
function DataUtils.setNewAdvancedBuddhaCloudData( id )
    --default : isActive = 0, addlevel = 0, level = 0, npcId = 0, status = 0
    CloudData.NPC_INFO[id].npcId = id
    CloudData.NPC_INFO[id].isActive = 1
    CloudData.NPC_INFO[id].addlevel = 0
    CloudData.NPC_INFO[id].status = 1
    CloudData.NPC_INFO[id].level = 10
end
function DataUtils.setNewBuddhaCloudData(id)
  CloudData.NPC_INFO[id].npcId = id
  
  CloudData.NPC_INFO[id].isActive = 1
  CloudData.NPC_INFO[id].addlevel = 0
  CloudData.NPC_INFO[id].status = 1
  CloudData.NPC_INFO[id].level = 1
  CloudData.NPC_INFO[id].starLevel = 0
  CloudData.NPC_INFO[id].skillTable = {}
end

function DataUtils.setNewAdvancedBuddhaCloudData(id)
  CloudData.NPC_INFO[id].npcId = id
  CloudData.NPC_INFO[id].isActive = 1
  CloudData.NPC_INFO[id].addlevel = 0
  CloudData.NPC_INFO[id].status = 1
  CloudData.NPC_INFO[id].level = 10
  CloudData.NPC_INFO[id].starLevel = 0
  CloudData.NPC_INFO[id].skillTable = {}
end

function DataUtils.setNewBuddhaFirstStarCloudData(id)
  CloudData.NPC_INFO[id].npcId = id
  CloudData.NPC_INFO[id].isActive = 1
  CloudData.NPC_INFO[id].addlevel = 0
  CloudData.NPC_INFO[id].status = 1
  CloudData.NPC_INFO[id].level = 1
  CloudData.NPC_INFO[id].starLevel = 1
  CloudData.NPC_INFO[id].skillTable = {}
end

--
--将剧情,引导,道具等的第一次出现存入本地
--

local RESOURCE_SNAPSHOT_PREFIX = "doubi_resource_snapshot_v3_"
local resourcePersistenceHandle = nil
local CompatTrace = import("utils.CompatTrace")

local function snapshotKey()
    local uid = tostring(CloudData.UID or "")
    if uid == "" or uid == "nil" then
        return nil
    end
    local server = tostring(GameManager.IP or GameManager.ACCOUNT_SERVER_IP or "unknown")
    server = string.gsub(server, "[^%w]", "_")
    return RESOURCE_SNAPSHOT_PREFIX .. server .. "_" .. uid
end

local function legacySnapshotKey()
    local uid = tostring(CloudData.UID or "")
    if uid == "" or uid == "nil" then
        return nil
    end
    local server = tostring(GameManager.IP or GameManager.ACCOUNT_SERVER_IP or "unknown")
    server = string.gsub(server, "[^%w]", "_")
    return "doubi_resource_snapshot_v2_" .. server .. "_" .. uid
end

local function numberOrZero(value)
    return tonumber(value) or 0
end

-- Currency and progression values are mutated in many legacy UI layers. Keep a
-- small account-scoped snapshot so a process kill cannot discard those changes
-- when the server is read-only or returns its initial player record again.
function DataUtils.saveResourceSnapshot()
    if CloudData.PLAYER_DATA_READY ~= true then
        return false
    end
    local key = snapshotKey()
    if key == nil then
        return false
    end
    local payload = {
        version = 3,
        exp = numberOrZero(CloudData.EXP),
        peach = numberOrZero(CloudData.PEACH),
        essence = numberOrZero(CloudData.ESSENCE),
        energy = numberOrZero(CloudData.ENERGY),
        maxEnergy = numberOrZero(CloudData.MAX_ENERGY),
        stageProgress = numberOrZero(CloudData.STAGE_PROGRESS),
        ginseng = numberOrZero(CloudData.GINSENG_FRUIT),
        sweep = numberOrZero(CloudData.SWEEP),
        activityCoins = numberOrZero(CloudData.ACTIVITY_COINS),
        drawNum = numberOrZero(CloudData.DRAW_NUM),
        npcInfo = {},
    }
    for id, info in pairs(CloudData.NPC_INFO or {}) do
        if type(info) == "table" then
            payload.npcInfo[#payload.npcInfo + 1] = {
                id = tonumber(id) or id,
                info = info,
            }
        end
    end
    local ok, encoded = pcall(function()
        return json.encode(payload)
    end)
    if not ok or type(encoded) ~= "string" then
        return false
    end
    cc.UserDefault:getInstance():setStringForKey(key, encoded)
    pcall(function()
        cc.UserDefault:getInstance():flush()
    end)
    CompatTrace.log("persistence", string.format("saved key=%s exp=%s peach=%s essence=%s npc=%d",
        tostring(key), tostring(payload.exp), tostring(payload.peach), tostring(payload.essence), #payload.npcInfo))
    return true
end

function DataUtils.restoreResourceSnapshot()
    local key = snapshotKey()
    if key == nil then
        return false
    end
    local encoded = cc.UserDefault:getInstance():getStringForKey(key, "")
    local loadedKey = key
    if encoded == nil or encoded == "" then
        local oldKey = legacySnapshotKey()
        if oldKey ~= nil then
            encoded = cc.UserDefault:getInstance():getStringForKey(oldKey, "")
            if encoded ~= nil and encoded ~= "" then
                loadedKey = oldKey
                CompatTrace.log("persistence", "migrating legacy snapshot key=" .. tostring(oldKey))
            end
        end
    end
    if encoded == nil or encoded == "" then
        return false
    end
    local ok, payload = pcall(function()
        return json.decode(encoded)
    end)
    if not ok or type(payload) ~= "table" then
        return false
    end
    local version = tonumber(payload.version) or 0
    if version ~= 2 and version ~= 3 then
        return false
    end
    -- A v2 snapshot written during the old startup race can contain only zeroes.
    -- Never let that stale value erase a non-empty server record.
    if version == 2 and numberOrZero(payload.exp) == 0 and numberOrZero(payload.peach) == 0
        and numberOrZero(payload.essence) == 0
        and (numberOrZero(CloudData.EXP) > 0 or numberOrZero(CloudData.PEACH) > 0
            or numberOrZero(CloudData.ESSENCE) > 0) then
        CompatTrace.log("persistence", "ignored stale v2 all-zero snapshot")
        return false
    end
    CloudData.EXP = numberOrZero(payload.exp)
    CloudData.PEACH = numberOrZero(payload.peach)
    CloudData.ESSENCE = numberOrZero(payload.essence)
    CloudData.ENERGY = numberOrZero(payload.energy)
    CloudData.MAX_ENERGY = numberOrZero(payload.maxEnergy)
    CloudData.STAGE_PROGRESS = numberOrZero(payload.stageProgress)
    CloudData.GINSENG_FRUIT = numberOrZero(payload.ginseng)
    CloudData.SWEEP = numberOrZero(payload.sweep)
    CloudData.ACTIVITY_COINS = numberOrZero(payload.activityCoins)
    CloudData.DRAW_NUM = numberOrZero(payload.drawNum)
    if version >= 3 and type(payload.npcInfo) == "table" then
        local restored = 0
        for _, entry in pairs(payload.npcInfo) do
            if type(entry) == "table" and entry.info ~= nil then
                local id = tonumber(entry.id)
                if id ~= nil then
                    CloudData.NPC_INFO[id] = entry.info
                    restored = restored + 1
                end
            end
        end
        CompatTrace.log("persistence", string.format("restored key=%s exp=%s peach=%s essence=%s npc=%d",
            tostring(loadedKey), tostring(CloudData.EXP), tostring(CloudData.PEACH), tostring(CloudData.ESSENCE), restored))
    else
        CompatTrace.log("persistence", string.format("restored legacy key=%s exp=%s peach=%s essence=%s",
            tostring(loadedKey), tostring(CloudData.EXP), tostring(CloudData.PEACH), tostring(CloudData.ESSENCE)))
    end
    return true
end

-- Call this after a user-visible resource/progression mutation. The scheduler
-- remains as a fallback, but gameplay changes are flushed in the same frame.
function DataUtils.markResourceMutation(reason)
    if CloudData.PLAYER_DATA_READY ~= true then
        return false
    end
    CompatTrace.log("persistence", string.format("mutation=%s exp=%s peach=%s essence=%s",
        tostring(reason), tostring(CloudData.EXP), tostring(CloudData.PEACH), tostring(CloudData.ESSENCE)))
    return DataUtils.saveResourceSnapshot()
end

function DataUtils.startResourcePersistence()
    if resourcePersistenceHandle ~= nil then
        return
    end
    local ok, scheduler = pcall(require, cc.PACKAGE_NAME .. ".scheduler")
    if not ok or scheduler == nil or scheduler.scheduleGlobal == nil then
        return
    end
    resourcePersistenceHandle = scheduler.scheduleGlobal(function()
        DataUtils.saveResourceSnapshot()
    end, 0.25)
end

--存储剧情进度
function DataUtils.setDialogueIsFirstPlayed(name,isPlayed)
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_%s",serverId,uid,name)
    cc.UserDefault:getInstance():setBoolForKey(str,isPlayed)
end
function DataUtils.getDialogueIsFirstPlayed( name )
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_%s",serverId,uid,name)
    return cc.UserDefault:getInstance():getBoolForKey(str,false)
end


--存储引导进度
function DataUtils.setGuideIsFirstPlayed(name,isPlayed)
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_%s",serverId,uid,name)
    cc.UserDefault:getInstance():setBoolForKey(str,isPlayed)
end
function DataUtils.getGuideIsFirstPlayed( name )
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_%s",serverId,uid,name)
    return cc.UserDefault:getInstance():getBoolForKey(str,false)
end

--存储道具是否解锁
function DataUtils.setItemIsUnlock(id,isUnlock)
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_ITEM%d_UNLOCK",serverId,uid,id)
    cc.UserDefault:getInstance():setBoolForKey(str,isUnlock)
end
function DataUtils.getItemIsUnlock( id )
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_ITEM%d_UNLOCK",serverId,uid,id)
    return cc.UserDefault:getInstance():getBoolForKey(str,false)
end

--下方场景入口是否播放过解锁动画
function DataUtils.setSceneIsUnlock(name,isUnlock)
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_%s",serverId,uid,name)
    cc.UserDefault:getInstance():setBoolForKey(str,isUnlock)
end
function DataUtils.getSceneIsUnlock( name )
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_%s",serverId,uid,name)
    return cc.UserDefault:getInstance():getBoolForKey(str,false)
end

--八个章节是否解锁是否播放过一次动画
function DataUtils.setChapterIsUnlock(id,isUnlock)
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_CHAPTER%d_UNLOCK",serverId,uid,id)
    cc.UserDefault:getInstance():setBoolForKey(str,isUnlock)
end
function DataUtils.getChapterIsUnlock( id )
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_CHAPTER%d_UNLOCK",serverId,uid,id)
    if id == 1 then
		return cc.UserDefault:getInstance():getBoolForKey(str,true)
	else
		return cc.UserDefault:getInstance():getBoolForKey(str,false)
	end
end

--八个宝物收集完全时是否播放过解锁动画
function DataUtils.setIsTreasureUnlockAnimationPlayed(id,isPlayed)
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_TREASURE%d_UNLOCK",serverId,uid,id)
    cc.UserDefault:getInstance():setBoolForKey(str,isPlayed)
end
function DataUtils.getIsTreasureUnlockAnimationPlayed( id )
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_TREASURE%d_UNLOCK",serverId,uid,id)
    return cc.UserDefault:getInstance():getBoolForKey(str,false)
end

--八个宝物是否生效引导过动画
function DataUtils.setIsTreasureEffctive(id,isEffctive)
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_TREASURE%d_EFFCTIVE",serverId,uid,id)
    cc.UserDefault:getInstance():setBoolForKey(str,isEffctive)
end
function DataUtils.getIsTreasureEffctive( id )
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_TREASURE%d_EFFCTIVE",serverId,uid,id)
    return cc.UserDefault:getInstance():getBoolForKey(str,false)
end

--存储已经读取的消息id
function DataUtils.setReadMsgId(msgId)
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_MSG",serverId,uid)
    local tempStr = cc.UserDefault:getInstance():getStringForKey(str,"")
    if tempStr == "" then
        tempStr = string.format("%d", msgId)
    else
        tempStr = string.format("%s,%d",tempStr,msgId)
    end
    cc.UserDefault:getInstance():setStringForKey(str,tempStr)
end
--读取已经存储的消息id
function DataUtils.getReadMsgId()
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format("%d_%s_MSG",serverId,uid)
    local tempStr = cc.UserDefault:getInstance():getStringForKey(str,"")

    --将字符串解析为table
    local tempTable = {0}
    if tempStr ~= "" then
        tempTable = split(tempStr,",")
    end

    --转成key value形式
    local tb = {}
    for k,v in pairs(tempTable) do
        tb[v] = true
    end
    CloudData.READ_MSG_TABLE = tb
    dump(CloudData.READ_MSG_TABLE)
    --return tb
end

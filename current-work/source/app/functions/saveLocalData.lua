--
--将剧情,引导,道具等的第一次出现存入本地
--

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
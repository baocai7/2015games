
local AchievementModel = import("models.AchievementModel")


-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
local _achievementIdColumn   = nil
local _achievementNameColumn = nil
local _achievementTypeColumn = nil
local _achievementDes1Column = nil
local _achievementDes2Column = nil
local _rewardTypeColumn      = nil
local _rewardNumColumn       = nil

function DataUtils.getAchievementModel( id )
    
    local achievementInfo = DataRetainer.ACHIEVEMENT_INFO
    
    -- 读第1行，获得各属性所在的列index
    _achievementIdColumn   = _achievementIdColumn or achievementInfo:findIndexOfValueFromRow(1,"achievementId")
    _achievementNameColumn = _achievementNameColumn or achievementInfo:findIndexOfValueFromRow(1,"achievementName")
    _achievementTypeColumn = _achievementTypeColumn or achievementInfo:findIndexOfValueFromRow(1,"achievementType")
    _achievementDes1Column = _achievementDes1Column or achievementInfo:findIndexOfValueFromRow(1,"description1")
    _achievementDes2Column = _achievementDes2Column or achievementInfo:findIndexOfValueFromRow(1,"description2")
    _rewardTypeColumn      = _rewardTypeColumn or achievementInfo:findIndexOfValueFromRow(1,"rewardType")
    _rewardNumColumn       = _rewardNumColumn or achievementInfo:findIndexOfValueFromRow(1,"rewardNum")
    
    --查找 id 所在的行
    local _idRow = achievementInfo:findIndexOfValueFromColumn(_achievementIdColumn, id.."")
    
    --读出 id 对应行的所有数据
    local achievementId   = achievementInfo:getData(_idRow,_achievementIdColumn)
    local achievementName = achievementInfo:getData(_idRow,_achievementNameColumn)
    local achievementType = achievementInfo:getData(_idRow,_achievementTypeColumn)
    local achievementDes1 = achievementInfo:getData(_idRow,_achievementDes1Column)
    local achievementDes2 = achievementInfo:getData(_idRow,_achievementDes2Column)
    local rewardType      = achievementInfo:getData(_idRow,_rewardTypeColumn)
    local rewardNum       = achievementInfo:getData(_idRow,_rewardNumColumn)

    --读取achievementData
    local achievementLevel = DataUtils.getAchievementLevel(id)             
    if achievementLevel > tonumber(rewardNum) then
        achievementLevel = tonumber(rewardNum)    --防止溢出
    end
    local _achievementDataColumn = achievementInfo:findIndexOfValueFromRow(1,string.format("data"..achievementLevel))
    local achievementData  = achievementInfo:getData(_idRow,_achievementDataColumn)
    --读取rewardQuantity
    local _rewardQuantityColumn  = achievementInfo:findIndexOfValueFromRow(1,string.format("rewardQuantity"..achievementLevel))
    local rewardQuantity   = achievementInfo:getData(_idRow,_rewardQuantityColumn)

    --读取currentData(具体计算后续读数据)
    local currentData = DataUtils.getCurrData(tonumber(achievementId))
    
    --生成achievementModel
    local achievementModel = AchievementModel.new()
    achievementModel.achievementId_   = achievementId
    achievementModel.achievementName_ = achievementName
    achievementModel.achievementType_ = achievementType
    achievementModel.achievementDes1_ = achievementDes1
    achievementModel.achievementDes2_ = achievementDes2
    achievementModel.rewardType_      = rewardType
    achievementModel.rewardNum_       = rewardNum
    achievementModel.achievementData_ = achievementData
    achievementModel.rewardQuantity_  = rewardQuantity
    achievementModel.currentData_     = currentData
    
    return achievementModel
end

function DataUtils.setAchievementLevel( achievementId ,achievementLevel)
    CloudData.ACHIEVEMENT_INFO[achievementId] = achievementLevel
end

function DataUtils.getAchievementLevel( achievementId )
    if CloudData.ACHIEVEMENT_INFO[achievementId] == 0 then
        return 1
    else
        return CloudData.ACHIEVEMENT_INFO[achievementId]
    end
end

function DataUtils.getCurrData( achievementId )
    if achievementId == 1 then
        return CloudData.COST_MONEY

    elseif achievementId == 2 then
        return CloudData.COST_PEACH
    
    elseif achievementId == 3 then
        return CloudData.BUDDHA_NUM

    elseif achievementId == 4 then
        return CloudData.BUDDHA_10_NUM

    elseif achievementId == 5 then
        return CloudData.BUDDHA_20_NUM

    elseif achievementId == 6 then
        return CloudData.BUY_EXP_NUM

    elseif achievementId == 7 then
        return CloudData.TOWER_PROPERTY_10

    elseif achievementId == 8 then
        return CloudData.STAGE_FAIL_NUM

    elseif achievementId == 9 then
        return CloudData.MONSTER_NUM

    elseif achievementId == 10 then
        return CloudData.STAGE_PROGRESS
        
    end
end

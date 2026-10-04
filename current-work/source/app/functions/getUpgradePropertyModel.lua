
local UpgradePropertyModel = import("models.UpgradePropertyModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
-- 读第1行，获取各属性值的列下标
local _idColumn = nil
local _cnNameColumn = nil
local _iconColumn = nil
local _descColumn = nil

local _propertyTypeColumn = nil

function DataUtils.getUpgradePropertyModel( id )

    -- csv
    local upgradePropertyInfo = DataRetainer.UPGRADE_PROPERTIES_INFO
    
    -- 读第1行，获取各属性值的列下标
    _idColumn = _idColumn or upgradePropertyInfo:findIndexOfValueFromRow(1, "id")
    _cnNameColumn = _cnNameColumn or upgradePropertyInfo:findIndexOfValueFromRow(1, "cnName")
    _iconColumn = _iconColumn or upgradePropertyInfo:findIndexOfValueFromRow(1, "icon")
    _descColumn = _descColumn or upgradePropertyInfo:findIndexOfValueFromRow(1, "desc")
    
    local level = DataUtils.getPropertyLevel(id)
    local _expCostColumn = upgradePropertyInfo:findIndexOfValueFromRow(1, string.format("level%dexpCost",level))
    local _paramColumn = upgradePropertyInfo:findIndexOfValueFromRow(1, string.format("level%dParam",level))
    local _paramInitColumn = upgradePropertyInfo:findIndexOfValueFromRow(1, string.format("level%dParam",1))
    local levelCurr = ( level > 20 ) and 20 or level
    local _paramCurrColumn = upgradePropertyInfo:findIndexOfValueFromRow(1, string.format("level%dParam",levelCurr))
    local levelNext = ( level + 1 > 20 ) and 20 or level + 1
    local _paramNextColumn = upgradePropertyInfo:findIndexOfValueFromRow(1, string.format("level%dParam",levelNext))
    _propertyTypeColumn = _propertyTypeColumn or upgradePropertyInfo:findIndexOfValueFromRow(1, "propertyType");
    
    -- 读"id"列，取id行下标
    local _idRow = upgradePropertyInfo:findIndexOfValueFromColumn(_idColumn, id.."")
    
    -- 读数值
    local datas = upgradePropertyInfo:getDatas(_idRow) or {}
    local id = tonumber(datas[_idColumn]) or tonumber(id) or 0
    local cnName = datas[_cnNameColumn]
    local icon = datas[_iconColumn]
    local desc = datas[_descColumn]
    local expCost = tonumber(datas[_expCostColumn]) or 0
    local param = tonumber(datas[_paramColumn]) or 10
    local paramInit = tonumber(datas[_paramInitColumn]) or param
    local paramCurr = tonumber(datas[_paramCurrColumn]) or param
    local paramNext = tonumber(datas[_paramNextColumn]) or param
    local propertyType = tonumber(datas[_propertyTypeColumn]) or 0

    --存入Model
    local upgradePropertyModel = UpgradePropertyModel.new()
    upgradePropertyModel.id_        = id
    upgradePropertyModel.cnName_    = cnName
    upgradePropertyModel.icon_      = icon
    upgradePropertyModel.desc_      = desc
    upgradePropertyModel.level_     = level
    upgradePropertyModel.expCost_   = expCost
    upgradePropertyModel.param_     = param
    upgradePropertyModel.paramInit_ = paramInit
    upgradePropertyModel.paramCurr_ = paramCurr
    upgradePropertyModel.paramNext_ = paramNext
    upgradePropertyModel.propertyType_ = propertyType

    return upgradePropertyModel
    
end

function DataUtils.getPropertyLevel( id )
    return tonumber(CloudData.UPGRADE_PROPERTY_INFO[id]) or 1
end

function DataUtils.setPropertyLevel( id, level)
    CloudData.UPGRADE_PROPERTY_INFO[id] = level
end

function DataUtils.getTableUpgradePropertyModel( flag )

    local towerTable = {}        --存储宝塔属性
    local tangTable  = {}        --存储唐僧属性

    local upgradePropertyInfo = DataRetainer.UPGRADE_PROPERTIES_INFO
    for i=1,upgradePropertyInfo:getTotalRows() - 1 do
        local model = DataUtils.getUpgradePropertyModel(i)
        local propertyType = tonumber(model.propertyType_)
        if propertyType == 1 then
            table.insert(towerTable,model)
        else
            table.insert(tangTable,model)
        end
    end

    --返回对应的table
    if flag == "TOWER" then
        return towerTable
    else
        return tangTable
    end
end

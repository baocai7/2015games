
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
    local id = upgradePropertyInfo:getData(_idRow,_idColumn)
    local cnName = upgradePropertyInfo:getData(_idRow,_cnNameColumn)
    local icon = upgradePropertyInfo:getData(_idRow,_iconColumn)
    local desc = upgradePropertyInfo:getData(_idRow,_descColumn)
    local expCost = upgradePropertyInfo:getData(_idRow,_expCostColumn)
    local param = upgradePropertyInfo:getData(_idRow,_paramColumn)
    local paramInit = upgradePropertyInfo:getData(_idRow,_paramInitColumn)
    local paramCurr = upgradePropertyInfo:getData(_idRow,_paramCurrColumn)
    local paramNext = upgradePropertyInfo:getData(_idRow,_paramNextColumn)
    local propertyType = upgradePropertyInfo:getData(_idRow,_propertyTypeColumn)

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
    return CloudData.UPGRADE_PROPERTY_INFO[id]
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
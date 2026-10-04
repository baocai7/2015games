
local SkillItemModel = import("models.SkillItemModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
--读第1行，获得各属性所在的列index
local _itemIdColumn         = nil   --道具id
local _itemNameColumn       = nil   --道具名称
local _itemIconColumn       = nil   --道具Icon
local _itemIconBigColumn    = nil
local _itemNameColonColumn  = nil
local _itemConsumableColumn = nil   --道具是否可多次使用（1：可以；0：不可以）
local _itemDescColumn       = nil   --道具效果描述
local _itemPriceColumn      = nil   --道具价格
local _itemPriceRMBColumn   = nil   --道具价格


--加载道具数据信息
function DataUtils.getSkillItemModel( itemId )

    --csv
    local skillItemInfo = DataRetainer.SKILL_ITEM_INFO

    --读第1行，获得各属性所在的列index
    _itemIdColumn         = _itemIdColumn or skillItemInfo:findIndexOfValueFromRow(1,"id")           --道具id
    _itemNameColumn       = _itemNameColumn or skillItemInfo:findIndexOfValueFromRow(1,"name")         --道具名称
    _itemIconColumn       = _itemIconColumn or skillItemInfo:findIndexOfValueFromRow(1,"icon")         --道具Icon
    _itemIconBigColumn    = _itemIconBigColumn or skillItemInfo:findIndexOfValueFromRow(1,"bigIcon")
    _itemNameColonColumn  = _itemNameColonColumn or skillItemInfo:findIndexOfValueFromRow(1,"nameColon")
    _itemConsumableColumn = _itemConsumableColumn or skillItemInfo:findIndexOfValueFromRow(1,"consumable")   --道具是否可多次使用（1：可以；0：不可以）
    _itemDescColumn       = _itemDescColumn or skillItemInfo:findIndexOfValueFromRow(1,"desc")         --道具效果描述
    _itemPriceColumn      = _itemPriceColumn or skillItemInfo:findIndexOfValueFromRow(1,"price")        --道具价格
    _itemPriceRMBColumn   = _itemPriceRMBColumn or skillItemInfo:findIndexOfValueFromRow(1,"price_rmb")        --道具价格

    --查找 id 所在的行
    local _idRow = skillItemInfo:findIndexOfValueFromColumn(_itemIdColumn,itemId.."")

    --读出 id 对应行的所有数据
    local itemId         = skillItemInfo:getData(_idRow,_itemIdColumn)
    local itemName       = skillItemInfo:getData(_idRow,_itemNameColumn)
    local itemIcon       = skillItemInfo:getData(_idRow,_itemIconColumn)
    local itemIconBig    = skillItemInfo:getData(_idRow,_itemIconBigColumn)
    local itemNameColon  = skillItemInfo:getData(_idRow,_itemNameColonColumn)
    local itemConsumable = skillItemInfo:getData(_idRow,_itemConsumableColumn)
    local itemDesc       = skillItemInfo:getData(_idRow,_itemDescColumn)
    local itemPrice      = skillItemInfo:getData(_idRow,_itemPriceColumn)
    local itemPriceRMB      = skillItemInfo:getData(_idRow,_itemPriceRMBColumn)

    --记录数据
    local skillItemModel = SkillItemModel.new()
    skillItemModel.itemId_         = tonumber(itemId)
    skillItemModel.itemName_       = itemName
    skillItemModel.itemIcon_       = itemIcon
    skillItemModel.itemIconBig_    = itemIconBig
    skillItemModel.itemNameColon_  = itemNameColon
    skillItemModel.itemConsumable_ = tonumber(itemConsumable)
    skillItemModel.itemDesc_       = itemDesc
    skillItemModel.itemPrice_      = tonumber(itemPrice)
    skillItemModel.itemPriceRMB_      = tonumber(itemPriceRMB)

    --
    --SkillItemModel.num_            = CloudData.item

    return skillItemModel
end


-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
local _locationIdColumn   = nil
local _locationXColumn = nil
local _locationYColumn = nil

function DataUtils.getChapterLocationTable()

    local chapterLocationInfo = DataRetainer.CHAPTER_LOCATION_INFO

    --读第1行，获得各属性所在的列index
    _locationIdColumn = _locationIdColumn or chapterLocationInfo:findIndexOfValueFromRow(1,"id")
    _locationXColumn = _locationXColumn or chapterLocationInfo:findIndexOfValueFromRow(1,"locationx")
    _locationYColumn = _locationYColumn or chapterLocationInfo:findIndexOfValueFromRow(1,"locationy")

    local locations = {}

    for i=1,8 do
        local _locationIdRow = chapterLocationInfo:findIndexOfValueFromColumn(_locationIdColumn, i.."")
        local _locationX = chapterLocationInfo:getData(_locationIdRow,_locationXColumn)
        local _locationY = chapterLocationInfo:getData(_locationIdRow,_locationYColumn)

        local point = cc.p(_locationX, _locationY)

        locations[#locations + 1] = point
    end

    return locations
end

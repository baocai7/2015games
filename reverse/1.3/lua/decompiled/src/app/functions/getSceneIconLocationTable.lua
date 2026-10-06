local _locationIdColumn, _locationXColumn, _locationYColumn

function DataUtils.getSceneIconLocationTable()
  local sceneIconLocationInfo = DataRetainer.SECNE_ICON_LOCATION
  _locationIdColumn = _locationIdColumn or sceneIconLocationInfo:findIndexOfValueFromRow(1, "id")
  _locationXColumn = _locationXColumn or sceneIconLocationInfo:findIndexOfValueFromRow(1, "locationx")
  _locationYColumn = _locationYColumn or sceneIconLocationInfo:findIndexOfValueFromRow(1, "locationy")
  local locations = {}
  for i = 1, 10 do
    local _locationIdRow = sceneIconLocationInfo:findIndexOfValueFromColumn(_locationIdColumn, i .. "")
    local _locationX = sceneIconLocationInfo:getData(_locationIdRow, _locationXColumn)
    local _locationY = sceneIconLocationInfo:getData(_locationIdRow, _locationYColumn)
    local point = cc.p(_locationX, _locationY)
    locations[#locations + 1] = point
  end
  return locations
end

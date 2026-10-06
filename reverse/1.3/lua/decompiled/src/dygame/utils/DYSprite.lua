local M = {}

function M.create(fileName, cached)
  local fullPath = ""
  if cached ~= nil and cached == true then
    fullPath = "#" .. fileName
    local sprite = display.newSprite(fullPath)
    return sprite
  end
  fullPath = fileName
  if fullPath ~= nil then
    local sprite = cc.Sprite:create(fullPath)
    return sprite
  end
  return nil
end

function M.createScale9(fileName, cached)
  local fullPath = ""
  if cached ~= nil and cached == true then
    fullPath = "#" .. fileName
    local sprite = display.newScale9Sprite(fullPath)
    return sprite
  end
  fullPath = fileName
  if fullPath ~= nil then
    local sprite = display.newScale9Sprite(fullPath)
    return sprite
  end
  return nil
end

return M

DeprecatedNetworkClass = {} or DeprecatedNetworkClass

local function deprecatedTip(old_name, new_name)
  print([[

********** 
]] .. old_name .. " was deprecated please use " .. new_name .. [[
 instead.
**********]])
end

function DeprecatedNetworkClass.WebSocket()
  deprecatedTip("WebSocket", "cc.WebSocket")
  return cc.WebSocket
end

_G.WebSocket = DeprecatedNetworkClass.WebSocket()

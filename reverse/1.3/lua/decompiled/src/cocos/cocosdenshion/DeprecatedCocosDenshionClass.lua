DeprecatedCocosDenshionClass = {} or DeprecatedCocosDenshionClass

local function deprecatedTip(old_name, new_name)
  print([[

********** 
]] .. old_name .. " was deprecated please use " .. new_name .. [[
 instead.
**********]])
end

function DeprecatedCocosDenshionClass.SimpleAudioEngine()
  deprecatedTip("SimpleAudioEngine", "cc.SimpleAudioEngine")
  return cc.SimpleAudioEngine
end

_G.SimpleAudioEngine = DeprecatedCocosDenshionClass.SimpleAudioEngine()

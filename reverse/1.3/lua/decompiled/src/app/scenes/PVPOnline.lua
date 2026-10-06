local FRAME_SEC = 60
CLASS_NAME = "GameScene"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene(CLASS_NAME)
end)

function M:ctor()
  self:performWithDelay(function()
    display.removeUnusedSpriteFrames()
  end, 5)
end

function M:initUI()
  display.addSpriteFrames("animation/dadouyanwu.plist", "animation/dadouyanwu.png")
  display.addSpriteFrames("animation/difangsiwangyan.plist", "animation/difangsiwangyan.png")
  display.addSpriteFrames("animation/wofangsiwangyan.plist", "animation/wofangsiwangyan.png")
  display.addSpriteFrames("animation/siwanglinghun.plist", "animation/siwanglinghun.png")
  display.addSpriteFrames("animation/lingqi.plist", "animation/lingqi.png")
  display.addSpriteFrames("animation/shengli_xingxing.plist", "animation/shengli_xingxing.png")
  display.addSpriteFrames("buff/buffball.plist", "buff/buffball.png")
  display.addSpriteFrames("buff/lianhua.plist", "buff/lianhua.png")
  display.addSpriteFrames("buff/wandPic.plist", "buff/wandPic.png")
  display.addSpriteFrames("buff/specialArea.plist", "buff/specialArea.png")
  display.addSpriteFrames("buff/buff_aberrant.plist", "buff/buff_aberrant.png")
  display.addSpriteFrames("buff/buff_atk_def.plist", "buff/buff_atk_def.png")
  display.addSpriteFrames("buff/buff_gain.plist", "buff/buff_gain.png")
  display.addSpriteFrames("buff/buff_effect.plist", "buff/buff_effect.png")
end

function M:update(cb)
  BMgrOL.update()
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
end

return M

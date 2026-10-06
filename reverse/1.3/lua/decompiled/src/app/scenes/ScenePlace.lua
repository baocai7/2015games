local LayerPlace = require("app.activity.place.LayerPlaceMain")
local CLASS_NAME = "ScenePlace"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene(CLASS_NAME)
end)

function M:ctor()
  if audio.isMusicPlaying() then
    DYSoundMgr.stopMusic(true)
  end
  DYSoundMgr.playMusic(DY_SND.bgm_battle1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  self.mBg = display.newSprite("app/common_ui/common_bg.png"):addTo(self.mNode)
  self.mLayerPlace = LayerPlace.new():addTo(self.mNode, 1)
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
end

function M:onExit()
  DYSoundMgr.stopMusic(true)
  DYSoundMgr.playMusic(DY_SND.bgm_theme)
  DDLOG(CLASS_NAME .. ": onExit")
end

return M

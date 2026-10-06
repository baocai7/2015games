local LoadingScene = {}
LoadingScene = class("LoadingScene", function()
  return display.newScene("LoadingScene")
end)

function LoadingScene:ctor()
  DYSoundMgr.playEffect(DY_SND.sfx_loading)
  self.mFile = {}
  DYRes.loadFileInfo("loading/Loading/Loading.csb", self.mFile)
  self:initUI_()
end

function LoadingScene:initUI_()
  local armature = ccs.Armature:create("Loading")
  armature:setPosition(display.cx, display.cy)
  armature:addTo(self)
  armature:getAnimation():playWithIndex(0)
  self:performWithDelay(function()
    self:action3_()
  end, 3)
end

function LoadingScene:action3_()
  DYSoundMgr.playEffect(DY_SND.sfx_go_1)
  local armature = ccs.Armature:create("huanchonghouzi")
  armature:setPosition(display.width * 0.06, display.height * 0.01)
  armature:setScaleX(-1)
  armature:getAnimation():playWithIndex(0)
  self:addChild(armature, 10)
  armature:runAction(transition.sequence({
    cc.MoveBy:create(2, cc.p(display.width * 0.88, 0)),
    cc.CallFunc:create(function()
      DYSoundMgr.stopMusic(true)
      local nextScene = require("scenes.ChapterScene").new()
      display.replaceScene(nextScene, "fadeTR", 0.2)
    end)
  }))
end

function LoadingScene:onEnter()
end

function LoadingScene:onExit()
  DYRes.unloadFileInfo(self.mFile)
  self.mFile = {}
end

return LoadingScene

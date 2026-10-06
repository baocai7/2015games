local DYClass = "LayerMeetBoss"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M.scene(cb, param1, param2)
  local scene = display.newScene()
  scene:addChild(M.new(cb, param1, param2))
  return scene
end

function M:ctor(callback, param1, param2)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mInfo = {}
  self.mParam1 = param1
  self.mParam2 = param2
  self.mBg = nil
  self.mCanBeClicked = false
  self.mFileInfo = {}
  DYRes.loadFileInfo("armature/yaomolaixi/yaomolaixi.csb", self.mFileInfo)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  self:addArmature()
end

function M:addArmature()
  local armature = ccs.Armature:create("yaomolaixi")
  armature:setPosition(0, 0)
  self.mNode:addChild(armature)
  
  local function tFuncAnimationEvent(armatureBack, movementType, movementID)
    if movementType ~= ccs.MovementEventType.complete and movementType ~= ccs.MovementEventType.loopComplete then
      return
    end
    local anim = movementID
    if anim == "Animation1" then
      self:performWithDelay(function()
        armature:getAnimation():play("Animation2")
        self:addButtons()
      end, 0)
    end
  end
  
  armature:getAnimation():setMovementEventCallFunc(tFuncAnimationEvent)
  armature:getAnimation():playWithIndex(0)
end

function M:addButtons()
  cc.ui.UIPushButton.new({
    normal = "aggress/btn_cancel.png",
    pressed = "aggress/btn_cancel.png"
  }):align(display.CENTER, -165, -215):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "aggress/btn_check.png",
    pressed = "aggress/btn_check.png"
  }):align(display.CENTER, 165, -215):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:toAggressScene()
  end):addTo(self.mNode)
  self.mCanBeClicked = true
end

function M:toAggressScene()
  self.mCanBeClicked = false
  self.mParam1 = "scenes.TinyLoadingScene"
  self.mParam2 = "SCENE_AGGRESS"
  self:closeCallBack()
end

function M:closeCallBack()
  self.mCanBeClicked = false
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
  if self.mCallback then
    self.mCallback(self.mParam1, self.mParam2)
  end
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYRes.unloadFileInfo(self.mFileInfo)
  self.mFileInfo = {}
end

return M

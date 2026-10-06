local DYClass = "LayerBoot"
local M = {}
M = class(DYClass, function()
  return display.newLayer(DYClass)
end)

function M.scene()
  local scene = display.newScene()
  scene:addChild(M.new())
  return scene
end

function M:ctor()
  DDLOG(DYClass .. ": onCreate")
  self:layoutUI()
end

function M:layoutUI()
  local node = display.newNode()
  node:setPosition(display.cx, display.cy)
  node:addTo(self)
  node:setCascadeOpacityEnabled(true)
  self.mCoreNode = node
  
  local function tFuncDelay()
    local scene = require("app.scenes.MainScene").new()
    display.replaceScene(scene)
  end
  
  if device.platform == "ios" then
    display.newSprite("common/logo_boot.png"):addTo(node)
    node:setOpacity(0)
    node:runAction(cc.Sequence:create(cc.FadeIn:create(1), cc.DelayTime:create(1.5), cc.CallFunc:create(tFuncDelay)))
  else
    node:runAction(cc.CallFunc:create(tFuncDelay))
  end
end

return M

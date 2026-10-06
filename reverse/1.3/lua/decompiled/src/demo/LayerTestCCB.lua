local CLASS_NAME = "LayerTestCCB"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer(CLASS_NAME)
end)
ccb.LayerTestCCBRoot = M
local onClickButtonBack

function M:ctor(cb)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCoreNode = display.newNode():addTo(self)
  self.mCoreNode:setPosition(dy.xp(640, 360))
  self.mCallback = cb
  M.onClickButtonBack = handler(self, onClickButtonBack)
  DYRes.loadSheet("uikit/dy_sheet_uikit.plist")
  self:layoutUI()
  self:setNodeEventEnabled(true)
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  self:invokeCallback("ON_ENTER_FOOTER")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
end

function M:layoutUI()
  local node = self.mCoreNode
  local proxy = cc.CCBProxy:create()
  local layer = CCBReaderLoad("LayerTestCCB.ccbi", proxy, M)
  node:addChild(layer)
  local root = layer:getChildByTag(100)
  root:setPosition(dy.p(0, 0))
end

function onClickButtonBack(self, param)
  DDLOG("onClickButtonBack, " .. tostring(self))
  local scene = require("MainScene").new()
  display.replaceScene(scene)
end

function M:invokeCallback(tag, param1, param2)
  if self.mCallback then
    self.mCallback(tag, param1, param2)
  end
end

return M

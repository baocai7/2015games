local CLASS_NAME = "LayerTest1Game"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer(CLASS_NAME)
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mGamePanel = nil
  self:layoutUI()
  self:setNodeEventEnabled(true)
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    display.replaceScene(require("app.scenes.LoginScene").new())
  end
  return true
end

function M:layoutUI()
  local panel = require("app.layers.PanelGame").new(handler(self, self.onEventPanelGame))
  panel:setPosition(dy.p(100, 100))
  panel:addTo(self)
  self.mGamePanel = panel
end

function M:onEventPanelGame(tag, param)
  DDLOG("on event from game panel")
end

return M

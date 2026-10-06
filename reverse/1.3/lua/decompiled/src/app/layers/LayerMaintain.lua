local CLASS_NAME = "LayerMaintain"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer(CLASS_NAME)
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mCoreNode = display.newNode():addTo(self)
  self.mCoreNode:setPosition(cc.p(display.cx, display.cy))
  self.mPanelRoot = nil
  DYRes.loadSheet("animation/maintain_ani.plist")
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
  DYRes.unloadSheet("animation/maintain_ani.plist")
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:hide()
    return true
  end
  return false
end

function M:layoutUI()
  self:addWidget()
  self:addContent()
end

function M:addWidget()
  local node = self.mCoreNode
  local widget = cc.uiloader:load("ui/LayerMaintain.csb")
  widget:addTo(node)
  self.mWidget = widget
  local panelRoot = cc.uiloader:seekNodeByName(widget, "PanelRoot")
  panelRoot:setPosition(dy.p(0, 0))
  self.mPanelRoot = panelRoot
  local button = cc.uiloader:seekNodeByName(widget, "ButtonClose")
  button:addTouchEventListener(handler(self, self.onClickButtonClose))
end

function M:addContent()
  local node = self.mCoreNode
  local ani = display.newSprite():addTo(self.mPanelRoot)
  local frames = display.newFrames("maintain_ani%d.png", 1, 3)
  local animation = display.newAnimation(frames, 0.07)
  ani:setPosition(0, 30)
  ani:playAnimationForever(animation)
end

function M:onTouch(event)
  if "began" == event.name then
    return true
  elseif "clicked" == event.name then
    DDLOG(event.itemPos)
    self:onClickItem(event.item)
  end
end

function M:show()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
end

function M:hide()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
end

function M:onClickButtonClose(sender, eventType)
  if eventType ~= ccui.TouchEventType.ended then
    return
  end
  self:hide()
end

return M

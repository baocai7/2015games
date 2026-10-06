local M = {}
M = class("LayerToBeStronger", function()
  return display.newLayer()
end)

function M:ctor(handler_)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  if handler_ then
    self.mHandler = handler_
  end
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("user_center/frame.png"):addTo(self.mNode)
  local M_TAB_BTN = {
    {
      normal = "user_center/pic_summon.png",
      pressed = "user_center/pic_summon1.png"
    },
    {
      normal = "user_center/pic_upgrade.png",
      pressed = "user_center/pic_upgrade1.png"
    },
    {
      normal = "user_center/pic_skill.png",
      pressed = "user_center/pic_skill1.png"
    },
    {
      normal = "user_center/pic_cimelia.png",
      pressed = "user_center/pic_cimelia1.png"
    },
    {
      normal = "user_center/pic_treasure.png",
      pressed = "user_center/pic_treasure1.png"
    }
  }
  for i = 1, #M_TAB_BTN do
    cc.ui.UIPushButton.new(M_TAB_BTN[i]):onButtonClicked(function()
      self:funcCallback(i)
    end):align(display.CENTER, bg:getContentSize().width * (0.26 + 0.12 * (i - 1)), bg:getContentSize().height * 0.5):addTo(bg, 2)
  end
  self:setTouchEnabled(true)
  self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    local touchInSprite = cc.rectContainsPoint(bg:getCascadeBoundingBox(), cc.p(x, y))
    if name == "began" then
      if not touchInSprite then
        self:closeCallBack()
      end
      return true
    end
  end)
end

function M:funcCallback(idx)
  local tFunc = {
    [1] = function()
      display.replaceScene(require("scenes.SceneSummon").new())
    end,
    [2] = function()
      display.replaceScene(require("scenes.UpgradeScene").new())
    end,
    [3] = function()
      display.replaceScene(require("scenes.UpgradeScene").new())
    end,
    [4] = function()
      display.replaceScene(require("cimelia.scenes.SceneCimelia").new())
    end,
    [5] = function()
      require("scenes.SceneTreasure").new():show()
    end
  }
  tFunc[idx]()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.mNode:runAction(popupLayer)
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
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

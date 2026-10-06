local CLASS_NAME = "PanelPause"
local M = {}
M = class(CLASS_NAME, function()
  return display.newNode(CLASS_NAME)
end)
M.TAG_CONTINUE = 1000
M.TAG_EXIT = 1001
M.TAG_RESTART = 1002

function M:ctor(cb)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCallback = cb
  self.mCoreNode = nil
  self:layoutUI()
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
end

function M:layoutUI()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  local node = display.newNode():pos(display.cx, display.cy):addTo(self)
  self.mCoreNode = node
  self:addBg()
  self:addContent()
end

function M:invokeCallback(tag, param)
  DDLOG(CLASS_NAME .. ": invokeCallback, tag = %d", tag)
  if self.mCallback then
    self.mCallback(tag, param)
  end
end

function M:addBg()
  local cl = display.newColorLayer(cc.c4b(0, 0, 0, 150))
  cl:addTo(self, -1)
end

function M:addContent()
  local node = self.mCoreNode
  local ds = display.newSprite("gamescene/bg_pause.png")
  ds:addTo(node)
  local restartBtn = cc.ui.UIPushButton.new({
    normal = "login_scene/button.png",
    pressed = "login_scene/button_h.png"
  })
  restartBtn:setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S259", ""),
    size = 32,
    color = cc.c3b(255, 234, 200),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(143, 78, 1)
  }))
  restartBtn:onButtonClicked(handler(self, self.buttonListener))
  restartBtn:setTag(M.TAG_RESTART)
  restartBtn:setPosition(dy.p(0, 95))
  restartBtn:addTo(node, 2)
  local button = cc.ui.UIPushButton.new({
    normal = "gamescene/continue.png",
    pressed = "gamescene/continue1.png"
  })
  button:onButtonClicked(handler(self, self.buttonListener))
  button:setTag(M.TAG_CONTINUE)
  button:setPosition(dy.p(0, 0))
  button:addTo(node, 2)
  local button = cc.ui.UIPushButton.new({
    normal = "gamescene/exit.png",
    pressed = "gamescene/exit1.png"
  })
  button:onButtonClicked(handler(self, self.buttonListener))
  button:setTag(M.TAG_EXIT)
  button:setPosition(dy.p(0, -95))
  button:addTo(node, 2)
  node:setScale(0)
  node:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2, 1.1), cc.ScaleTo:create(0.1, 1)))
end

function M:buttonListener(param)
  if not param or not param.target then
    return
  end
  local sender = param.target
  local tag = sender:getTag()
  if tag == M.TAG_CONTINUE then
    self:invokeCallback(tag)
    self:hide()
  elseif tag == M.TAG_EXIT then
    self:invokeCallback(tag)
    local num = GameManager.STAGE_NUM or 0
    local info = {
      [1] = DYLang.getString("S260", ""),
      [2] = DYLang.getString("S261", ""),
      [3] = DYLang.getString("S262", ""),
      [4] = DYLang.getString("S263", ""),
      [5] = DYLang.getString("S264", ""),
      [6] = DYLang.getString("S265", ""),
      [7] = DYLang.getString("S266", "")
    }
    local tip = info[tonumber(GameManager.MODE) + 1] or DYLang.getString("S267", "")
    self:hide()
  elseif tag == M.TAG_RESTART then
    self:invokeCallback(tag)
    self:hide()
  end
end

function M:hide()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local closeSeq = transition.sequence({
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.mCoreNode:runAction(closeSeq)
end

return M

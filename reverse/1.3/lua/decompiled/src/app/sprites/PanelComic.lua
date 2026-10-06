local CLASS_NAME = "PanelComic"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer(CLASS_NAME)
end)

function M:ctor(callback)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCallback = callback
  self:setNodeEventEnabled(true)
end

function M:layoutUI()
  self.mBg = display.newSprite("opening_comic/bg_frame.png", display.cx, display.cy):addTo(self)
  local comic = display.newSprite("opening_comic/moon_comic/comic1.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5):opacity(0):addTo(self.mBg)
  comic:runAction(transition.sequence({
    cc.FadeIn:create(1),
    cc.DelayTime:create(1.5),
    cc.FadeOut:create(1),
    cc.CallFunc:create(function()
      comic:removeSelf()
      self:loadComic2()
    end)
  }))
end

function M:loadComic2()
  local comic = display.newSprite("opening_comic/moon_comic/comic2.png"):pos(self.mBg:getContentSize().width * 0.5, 0):opacity(0):addTo(self.mBg)
  comic:runAction(transition.sequence({
    cc.FadeIn:create(1),
    cc.DelayTime:create(1.5),
    cc.MoveBy:create(0.25, cc.p(0, 720)),
    cc.DelayTime:create(1.5),
    cc.FadeOut:create(1),
    cc.CallFunc:create(function()
      comic:removeSelf()
      self:loadComic3()
    end)
  }))
end

function M:loadComic3()
  local comic = display.newSprite("opening_comic/moon_comic/comic3.png"):pos(self.mBg:getContentSize().width + 240, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  comic:runAction(transition.sequence({
    cc.MoveBy:create(0.25, cc.p(-1180, 0)),
    cc.DelayTime:create(1),
    cc.CallFunc:create(function()
      self:loadComic4(comic)
    end)
  }))
end

function M:loadComic4(lastComic)
  local comic = display.newSprite("opening_comic/moon_comic/comic4.png"):pos(self.mBg:getContentSize().width + 240, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  comic:runAction(transition.sequence({
    cc.MoveBy:create(0.25, cc.p(-640, 0)),
    cc.DelayTime:create(1),
    cc.FadeOut:create(1),
    cc.CallFunc:create(function()
      comic:removeSelf()
      self:loadComic5()
    end)
  }))
  lastComic:runAction(transition.sequence({
    cc.DelayTime:create(1.25),
    cc.FadeOut:create(1),
    cc.CallFunc:create(function()
      lastComic:removeSelf()
    end)
  }))
end

function M:loadComic5()
  local comic = display.newSprite("opening_comic/moon_comic/comic5.png"):scale(0):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.05, 1.02),
    cc.ScaleTo:create(0.04, 0.98),
    cc.ScaleTo:create(0.06, 1.02),
    cc.ScaleTo:create(0.05, 1)
  })
  local ac = cc.Repeat:create(popupLayer, 10)
  comic:runAction(transition.sequence({
    cc.ScaleTo:create(0.1, 1),
    cc.DelayTime:create(0.2),
    ac,
    cc.CallFunc:create(function()
      if self.mCallback then
        self.mCallback()
      end
    end)
  }))
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  self:layoutUI()
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
end

return M

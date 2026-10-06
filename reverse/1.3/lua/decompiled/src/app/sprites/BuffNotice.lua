local DYClass = "NoticeBuff"
local M = class(DYClass, function()
  return display.newNode()
end)

function M:ctor()
  self.isPlay = false
  self.noticeList = {}
  self.index = 1
  self:setCascadeOpacityEnabled(true)
end

function M:_playNotice(tmpBuff)
  local arrowToward, iconNum = unpack(tmpBuff)
  self.isPlay = true
  local viewCont = display.newNode():addTo(self)
  viewCont:setScaleX(self:getParent():getScaleX() / math.abs(self:getParent():getScaleX()))
  display.addSpriteFrames("buff/buffball.plist", "buff/buffball.png")
  local iconPath = string.format("#icon%d%d.png", arrowToward, iconNum)
  local icon = display.newSprite(iconPath):addTo(viewCont)
  local arrowPath = string.format("#iconarrow%d.png", arrowToward)
  viewCont:setCascadeOpacityEnabled(true)
  local onComplete = handler(self, self._playOnComplete)
  
  local function turnBig()
    transition.fadeIn(viewCont, {time = 0.5})
    transition.scaleTo(sprite, {scale = 1, time = 0.5})
  end
  
  local sequence = transition.sequence({
    cc.FadeIn:create(0.3),
    cc.ScaleTo:create(0.5, 1.2),
    cc.ScaleTo:create(0.5, 1),
    cc.DelayTime:create(0.5),
    cc.FadeOut:create(0.3),
    cc.CallFunc:create(function()
      viewCont:removeSelf()
    end),
    cc.CallFunc:create(onComplete)
  })
  self:runAction(sequence)
end

function M:PlayBuffNotice(arrowToward, iconNum)
  local tmpBuff = {arrowToward, iconNum}
  table.insert(self.noticeList, tmpBuff)
  if not self.isPlay then
    self:_playNotice(self.noticeList[1])
  end
end

function M:_playOnComplete()
  if #self.noticeList > self.index then
    self.index = self.index + 1
    self:_playNotice(self.noticeList[self.index])
  else
    self.isPlay = false
    self.noticeList = {}
    self.index = 1
  end
end

return M

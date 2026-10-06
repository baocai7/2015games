local M = {}
M = class("FunctionIcon", function()
  return display.newNode()
end)

function M:ctor(iconPath)
  self.mIcon = display.newSprite(iconPath)
  self.mNewMark = display.newSprite("common_ui/new.png", self.mIcon:getContentSize().width * 0.8, self.mIcon:getContentSize().height * 0.7):hide():addTo(self.mIcon, 1)
  self:setTouchEnabled(true)
  self:setContentSize(cc.size(self.mIcon:getContentSize().width, self.mIcon:getContentSize().height))
  self:addChild(self.mIcon)
end

function M:updateIcon(name)
  self.mIcon:setTexture(name)
end

function M:setMarkVisible(flag)
  if flag then
    self.mNewMark:setVisible(true)
    local seq = transition.sequence({
      cc.FadeOut:create(0.5),
      cc.FadeIn:create(0.5)
    })
    self.mNewMark:runAction(cc.RepeatForever:create(seq))
  else
    self.mNewMark:setVisible(false)
  end
end

function M:getMyBoundingBox()
  local point = cc.p(self:getPositionX(), self:getPositionY())
  local worldpoint = self:getParent():convertToWorldSpace(point)
  local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5, worldpoint.y - self:getContentSize().height * 0.5, self:getContentSize().width, self:getContentSize().height)
  return rect
end

return M

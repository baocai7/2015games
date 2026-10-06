local BMgrtmp
local DYClass = "cimeliaRangeTips"
local M = class(DYClass, function()
  return display.newNode()
end)

function M:ctor()
  display.addSpriteFrames("buff/cimlia_trip.plist", "buff/cimlia_trip.png")
  self:performWithDelay(function()
    self:initData()
  end, 1)
end

function M:initData()
  self.mType = tonumber(GameData.CIMELIA_ATK.skillType)
  self.mRange = GameData.CIMELIA_ATK.atkDistance * Const.Zoom0
  DDLOG("%d  %d", self.mType, self.mRange)
  if 6 >= GameManager.MODE or 9 == GameManager.MODE then
    BMgrtmp = BMgrOL
  else
    BMgrtmp = BMgr
  end
  if self.mType == 1 then
    self.mStartX = self:getRealX()
    self.mEndX = self.mStartX - self.mRange
  elseif self.mType == 2 then
    self.mStartX = BMgrtmp.getBuddhaTower():getPositionX()
    self.mEndX = self.mStartX - self.mRange
  elseif self.mType == 3 then
    self.mStartX = BMgrtmp.getBuddhaTower():getPositionX()
    self.mEndX = BMgrtmp.getMonsterTower():getPositionX()
    self.mRange = self.mStartX - self.mEndX
  end
end

function M:startTips()
  self.mainNode = display.newNode():opacity(0):addTo(self)
  self.mainNode:setCascadeOpacityEnabled(true)
  if self.mType == 1 then
    self:pointType()
  elseif self.mType == 2 then
    self:lineType()
  elseif self.mType == 3 then
    local tmpNode = self:fullScreenType():addTo(self.mainNode)
  end
  local sequence = transition.sequence({
    cc.FadeTo:create(1, 255),
    cc.DelayTime:create(0.5),
    cc.FadeTo:create(1, 0),
    cc.DelayTime:create(0.5)
  })
  local action = cc.RepeatForever:create(sequence)
  self.mainNode:runAction(action)
  if self.mType == 1 then
    self.mainNode:setScaleX(-1 * self.mainNode:getScaleX())
    self.schedulX = self:schedule(function()
      local x = self:getRealX()
      self.mainNode:setPositionX(x)
    end, 0.1)
  end
end

function M:lineType()
  local distance1 = display.newSprite("buff/distance.png"):pos(self.mEndX + 50, 0):addTo(self.mainNode)
  local arrow1 = display.newSprite("#cim_arrow3.png"):pos(self.mEndX + 80, 0):addTo(self.mainNode)
  local arrow2 = display.newSprite("#cim_arrow2.png"):pos(self.mEndX + 100, 0):addTo(self.mainNode)
  local arrow3 = display.newSprite("#cim_arrow1.png"):pos(self.mEndX + 120, 0):addTo(self.mainNode)
end

function M:pointType()
  local lUp = display.newSprite("#leftup.png"):pos(0, 30):addTo(self.mainNode)
  local lDown = display.newSprite("#leftdown.png"):pos(0, 0):addTo(self.mainNode)
  local rUp = display.newSprite("#rightup.png"):pos(self.mStartX - self.mEndX, 30):addTo(self.mainNode)
  local rDown = display.newSprite("#rightdown.png"):pos(self.mStartX - self.mEndX, 0):addTo(self.mainNode)
  local mPoint = display.newSprite("#middlepoint.png"):pos((self.mStartX - self.mEndX) * 0.5, 15):addTo(self.mainNode)
  self.mainNode:setAnchorPoint(0.5, 0.5)
  self.mainNode:size(self.mStartX - self.mEndX, 30)
end

function M:fullScreenType()
  local tmpNode = display.newSprite("#fullscreen.png")
  tmpNode:setPositionX(display.cx)
  tmpNode:setScaleY(0.5)
  return tmpNode
end

function M:endTips()
  if self.mainNode then
    self.mainNode:removeFromParent()
  end
  self:stopAction(self.schedulX)
end

function M:getRealX()
  local tmpList = BMgrtmp.getMonsterList()
  local x = 0
  for i = 1, #tmpList do
    if tmpList[i] and x < tmpList[i]:getPositionX() then
      x = tmpList[i]:getPositionX()
    end
  end
  if x < BMgrtmp.getMonsterTower():getPositionX() then
    x = BMgrtmp.getMonsterTower():getPositionX()
  end
  return x
end

function M:getRealX1()
  local tmpList = clone(BMgrtmp.getMonsterList())
  local tmpTower = clone(BMgrtmp.getMonsterTower())
  table.insert(tmpList, tmpTower)
  table.sort(tmpList, function(a, b)
    return a:getPositionX() > b:getPositionX()
  end)
  local x = tmpList[1]:getPositionX()
  return x
end

return M

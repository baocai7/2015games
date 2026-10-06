local CLASS_NAME = "DYProgress"
local M = {}
M = class(CLASS_NAME, function(resBg, resCore)
  return display.newSprite(resBg)
end)
local LAYER_INDEX_CORE = 20
local LAYER_INDEX_SHADOW = 10

function M:ctor(resBg, resCore)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCore = nil
  self.mShadow = nil
  self:setSprite(resCore)
end

function M:getPercentage()
  return self.mCore and self.mCore:getPercentage() or 100
end

function M:setPercentage(per)
  if self.mCore then
    self.mCore:setPercentage(per)
  end
end

function M:getShadowPercentage()
  return self.mShadow and self.mShadow:getPercentage() or 100
end

function M:setShadowPercentage(per)
  if self.mShadow then
    self.mShadow:setPercentage(per)
  end
end

function M:getMidpoint()
  return self.mCore and self.mCore:getMidpoint() or cc.p(0, 0.5)
end

function M:setMidpoint(pt)
  if self.mCore then
    self.mCore:setMidpoint(pt)
  end
  if self.mShadow then
    self.mShadow:setMidpoint(pt)
  end
end

function M:getBarChangeRate()
  return self.mCore and self.mCore:getBarChangeRate() or cc.p(1, 0)
end

function M:setBarChangeRate(pt)
  if self.mCore then
    self.mCore:setBarChangeRate(pt)
  end
  if self.mShadow then
    self.mShadow:setBarChangeRate(pt)
  end
end

function M:setSprite(res)
  local per = self:getPercentage()
  local mid = self:getMidpoint()
  local bcr = self:getBarChangeRate()
  if self.mCore then
    self.mCore:runAction(cc.RemoveSelf:create())
  end
  local sCore = display.newProgressTimer(res, display.PROGRESS_TIMER_BAR)
  sCore:setMidpoint(mid)
  sCore:setBarChangeRate(bcr)
  sCore:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
  sCore:setPercentage(per)
  self:addChild(sCore, LAYER_INDEX_CORE)
  self.mCore = sCore
end

function M:setShadow(res)
  local per = self:getShadowPercentage()
  local mid = self:getMidpoint()
  local bcr = self:getBarChangeRate()
  if self.mShadow then
    self.mShadow:runAction(cc.RemoveSelf:create())
  end
  local shadow = display.newProgressTimer(res, display.PROGRESS_TIMER_BAR)
  shadow:setMidpoint(mid)
  shadow:setBarChangeRate(bcr)
  shadow:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
  shadow:setPercentage(per)
  self:addChild(shadow, LAYER_INDEX_SHADOW)
  self.mShadow = shadow
end

return M

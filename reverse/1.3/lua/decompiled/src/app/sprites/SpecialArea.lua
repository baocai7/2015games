local DYClass = "SpecialArea"
local FLAG_HUOYAN = 1008
local FLAG_DUQI = 1014
local FLAG_BUDDHA = 1
local FLAG_MONSTER = 2
local M = class(DYClass, function()
  return display.newNode()
end)

local function initAnimation(mType)
  local frames
  local offsetY = 0
  if mType == FLAG_DUQI then
    frames = display.newFrames("duqi%d.png", 1, 16)
    offsetY = offsetY + 30
  elseif mType == FLAG_HUOYAN then
    frames = display.newFrames("yanjiang%d.png", 1, 10)
  else
    error("ID\233\148\153\232\175\175")
  end
  local animation = display.newAnimation(frames, 0.08)
  local sp = display.newSprite()
  sp:setPositionY(offsetY)
  sp:playAnimationForever(animation, true)
  return sp
end

local function getActorInArea(sourceFlag, startX, endX, maxNum)
  local tmpSource = self
  local tmpFlag = sourceFlag
  local tmpList
  local number = 0
  if tmpFlag == FLAG_BUDDHA then
    tmpList = clone(BMgr.getMonsterList())
  elseif tmpFlag == FLAG_MONSTER then
    tmpList = clone(BMgr.getBuddhaList())
  else
    error(DYLang.getString("S1500", ""))
  end
  local rtnList = {}
  for _, v in pairs(tmpList) do
    local tarX = v:getPositionX()
    if startX <= tarX and endX >= tarX then
      table.insert(rtnList, v)
    end
  end
  number = #rtnList
  if maxNum < number then
    number = maxNum
  end
  return {
    unpack(rtnList, 1, number)
  }
end

function M:ctor(sourceFlag, posx, buffid, dt, time, effectValue)
  self.mBuffId = buffid
  self.mEffectValue = effectValue
  self.mSourceFlag = sourceFlag
  self.mStartX = posx - 150
  self.mEndX = posx + 150
  local sp = initAnimation(self.mBuffId):addTo(self)
  self:schedule(function()
    self:updateLogic()
  end, 0.5)
  if 0 < time then
    self:performWithDelay(function()
      self:killSelf()
    end, time)
  end
end

function M:updateLogic()
  local tmpList = getActorInArea(self.mSourceFlag, self.mStartX, self.mEndX, 5)
  for _, v in pairs(tmpList) do
    v:addBuff(v, self.mBuffId, 0, 1, self.mEffectValue)
  end
end

function M:killSelf()
  BMgr.removeArea(self)
  self:removeSelf()
end

return M

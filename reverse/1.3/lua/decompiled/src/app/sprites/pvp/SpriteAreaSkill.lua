local DYClass = "SpecialArea"
local FLAG_HUOYAN = 1008
local FLAG_DUQI = 1014
local FLAG_BINGSHUANG = 1013
local FLAG_PALSY = 1006
local FLAG_DEATH = 1016
local FLAG_BUDDHA = 1
local FLAG_MONSTER = 2
local FRAME_SEC = GameManager.FRAME_SEC
local M = class(DYClass)

local function getActorInArea(sourceFlag, startX, endX, maxNum)
  local tmpSource = self
  local tmpFlag = sourceFlag
  local tmpList
  local number = 0
  if tmpFlag == FLAG_BUDDHA then
    tmpList = BMgrOL.getMonsterList()
  elseif tmpFlag == FLAG_MONSTER then
    tmpList = BMgrOL.getBuddhaList()
  else
    error(DYLang.getString("S1587", ""))
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
  self.mCount = 0
  self.mDuration = time * FRAME_SEC
  self.mDetalTime = dt * FRAME_SEC
  if not BMgrOL.SKIP_BATTLE then
    self.sp = SpriteViewMgr.createAreaAnimation(buffid, posx)
  end
  self:onTrigger()
end

function M:onTrigger()
  local tmpList = getActorInArea(self.mSourceFlag, self.mStartX, self.mEndX, 5)
  for _, v in pairs(tmpList) do
    if self.mBuffId == FLAG_DEATH then
      local rand = BMgrOL.RANDOM:random(0, 100)
      if rand > self.mEffectValue then
        return
      end
    end
    v:addBuff(v, self.mBuffId, 1, 1, self.mEffectValue)
  end
end

function M:update()
  self.mCount = self.mCount + 1
  if self.mCount % self.mDetalTime == 0 then
    self:onTrigger()
  end
  if self.mCount >= self.mDuration then
    self:killSelf()
  end
end

function M:killSelf()
  BMgrOL.removeArea(self)
  if self.sp then
    self.sp:removeFromParent()
  end
end

return M

local FLAGATTACK = "gongji"
local FLAGHURT = "shoushang"
local FLAGSKILL = "s1_atk"
local FLAGSKILL2 = "s2_atk"
local FLAGHURT1 = "hurt"
local FLAGATTACK1 = "atk"
local DYClass = "Animator"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)

function M:ctor(modelName)
  cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
  DYRes.loadFileInfo(string.format("armature/%s/%s.csb", modelName, modelName), GameData.S_FILE_INFO)
  self.armature_ = ccs.Armature:create(modelName)
  self.armature_:getAnimation():playWithIndex(0)
  self.armature_:setPosition(cc.p(0, 0))
  self:addChild(self.armature_)
  
  local function animationEvent(armatureBack, movementType, movementID)
    local id = movementID
    if movementType == ccs.MovementEventType.complete then
      if id == FLAGATTACK or id == FLAGATTACK1 or id == FLAGSKILL or id == FLAGSKILL2 then
        self:attackCompleteEvent()
      elseif id == FLAGHURT or id == FLAGHURT1 then
        self:hurtCompleteEvent()
      end
    end
  end
  
  self.armature_:getAnimation():setMovementEventCallFunc(animationEvent)
  
  local function onFrameEvent(bone, evt, originFrameIndex, currentFrameIndex)
    if "atkC" == evt then
      self:dispatchEvent({name = "ATTACK_CAL"})
    elseif "ski1C" == evt then
      DDLOG("======= evt : skill", evt)
      self:dispatchEvent({name = "SKILL1_CAL"})
    end
  end
  
  self.armature_:getAnimation():setFrameEventCallFunc(onFrameEvent)
end

function M:changeArmatureStateTo(state, index)
  if state == "STAND" then
    if self.curArmatureState_ ~= "STAND" then
      self.curArmatureState_ = "STAND"
      self.armature_:getAnimation():playWithIndex(0)
    end
  elseif state == "RUN" then
    if self.curArmatureState_ ~= "RUN" then
      self.curArmatureState_ = "RUN"
      self.armature_:getAnimation():playWithIndex(1)
    end
  elseif state == "ATTACK" then
    self.curArmatureState_ = "ATTACK"
    self.armature_:getAnimation():playWithIndex(2)
  elseif state == "HURT" then
    self.curArmatureState_ = "HURT"
    self.armature_:getAnimation():playWithIndex(3)
  elseif state == "SKILL" then
    self.curArmatureState_ = "SKILL"
    self.armature_:getAnimation():playWithIndex(index or 4)
  end
end

function M:attackCompleteEvent()
  self:dispatchEvent({
    name = "ATTACK_COMPLETE"
  })
end

function M:hurtCompleteEvent()
  self:dispatchEvent({
    name = "HURT_COMPLETE"
  })
end

function M:normalAttackEvent()
  self:dispatchEvent({
    name = "NORMAL_ATTACK"
  })
end

function M:tPause()
  local ch = self:getChildren()
  for k, v in pairs(ch) do
    if v.pause then
      v:pause()
    end
  end
  self.armature_:getAnimation():pause()
end

function M:tResume()
  local ch = self:getChildren()
  for k, v in pairs(ch) do
    if v.resume then
      v:resume()
    end
  end
  self.armature_:getAnimation():resume()
end

function M:setSpeed(v)
  self.armature_:getAnimation():setSpeedScale(v)
end

function M:getAniBoundingBox()
  return self.armature_:getBoundingBox()
end

return M

local DYClass = "RelicsUnit"
local M = class(DYClass, DYUnitBase)

function M:onLoad()
  self.mTimer = {}
end

function M:castSkill(sid, skillData)
  local tSwitch = {
    ["1"] = function()
      self:onSkillChangeElement({id = sid, data = skillData})
    end,
    ["2"] = function()
      self:onSkillUpdateSpirit({id = sid, data = skillData})
    end,
    ["3"] = function()
      self:onSkillUpdateTower({id = sid, data = skillData})
    end
  }
  local tFunc = tSwitch[checkstring(skillData.attackType)]
  if tFunc then
    tFunc()
  end
end

function M:onSkillChangeElement(param)
  local skillData = param.data
  if skillData.paramType1 == 0 then
    return self:onSkillResetElement()
  end
  GameData.SCENE_ELEMENT_BUDDHA = {
    0,
    0,
    0,
    0,
    0
  }
  GameData.SCENE_ELEMENT_BUDDHA[skillData.paramType1] = skillData.paramNum1
  local target = self:getTarget()
  local timer = self.mTimer.onSkillChangeElement
  if timer then
    target:stopAction(timer)
  end
  
  local function tFuncTimeUp()
    self.mTimer.onSkillChangeElement = nil
    EffectMgr.runEffectFadeEvent(0.5, false, function()
      DYNotification.post(DY_KEY.kResetBG)
    end)
    GameData.SCENE_ELEMENT_BUDDHA = {
      0,
      0,
      0,
      0,
      0
    }
  end
  
  local info = {
    bgPath = string.format("relics/map/%s/1.png", checkstring(skillData.paramType1)),
    bgMiddlePath = string.format("relics/map/%s/2.png", checkstring(skillData.paramType1)),
    bgSkyPath = string.format("relics/map/%s/3.png", checkstring(skillData.paramType1))
  }
  local anim = EffectMgr.runAnimationEvent("app/relics", "longwangqxtx", function(event)
    if not self:isValid() then
      return
    end
    if event.name ~= "FRAME_END" then
      return
    end
    EffectMgr.runEffectFadeEvent(0.5, false, function()
      DYNotification.post(DY_KEY.kChangeBG, info)
    end)
    self.mTimer.onSkillChangeElement = target:performWithDelay(tFuncTimeUp, skillData.durationTime or 0)
  end)
  anim:setScale(4)
  anim:pos(display.cx, display.cy):addTo(target, 100)
end

function M:onSkillResetElement()
  GameData.SCENE_ELEMENT_BUDDHA = {
    0,
    0,
    0,
    0,
    0
  }
  local target = self:getTarget()
  local timer = self.mTimer.onSkillChangeElement
  if timer then
    target:stopAction(timer)
  end
  self.mTimer.onSkillChangeElement = nil
  local anim = EffectMgr.runAnimationEvent("app/relics", "wushuxingcg", function(event)
    if not self:isValid() then
      return
    end
    if event.name ~= "FRAME_END" then
      return
    end
    EffectMgr.runEffectFadeEvent(0.5, false, function()
      DYNotification.post(DY_KEY.kResetBG)
    end)
  end)
  anim:setScale(2)
  anim:pos(display.cx, display.cy):addTo(target, 100)
end

function M:onSkillUpdateSpirit(param)
  local skillId = param.id
  local skillData = param.data
  local info = {}
  if skillData.paramType1 == 1 then
    info.key = DY_KEY.kUpdateSpiritLevel
    if skillData.targetBuff == 7 then
      info.isBuddha = false
      info.delta = skillData.paramNum1
    elseif skillData.targetBuff == 10 then
      info.isBuddha = true
      info.delta = skillData.paramNum1
    else
      return
    end
  elseif skillData.paramType1 == 2 then
    info.key = DY_KEY.kUpdateSpiritValue
    if skillData.targetBuff == 7 then
      info.isBuddha = false
      info.delta = skillData.paramNum1
    elseif skillData.targetBuff == 10 then
      info.isBuddha = true
      info.delta = skillData.paramNum1
    else
      return
    end
  else
    return
  end
  local target, pos
  local animRes = ""
  local BMgr = BMgr or BMgrOL
  if skillId == 7007 then
    target = BMgr.getBuddhaTower()
    pos = cc.p(0, 132)
    animRes = "jcdp_tglqtdj"
  elseif skillId == 7008 then
    target = BMgr.getMonsterTower()
    pos = cc.p(150, 132)
    animRes = "fh_jdlqtdj"
  elseif skillId == 7009 then
    target = BMgr.getBuddhaTower()
    pos = cc.p(0, 0)
    animRes = "jjyj_hltx"
  elseif skillId == 7010 then
    target = BMgr.getMonsterTower()
    pos = cc.p(0, 0)
    animRes = "zk_kcdflq"
  end
  if not target then
    return
  end
  local anim = EffectMgr.runAnimationEvent("app/relics", animRes, function(event)
    if not self:isValid() then
      return
    end
    if event.name ~= "FRAME_END" then
      return
    end
    DYNotification.post(info.key, info)
  end)
  anim:pos(pos.x, pos.y):addTo(target, 100)
end

function M:onSkillUpdateTower(param)
  local skillId = param.id
  local skillData = param.data
  local info = {}
  if skillData.paramType1 == 3 then
    info.key = DY_KEY.kUpdateTowerRatio
    if skillData.targetBuff == 7 then
      info.isBuddha = false
      info.delta = skillData.paramNum1
    elseif skillData.targetBuff == 10 then
      info.isBuddha = true
      info.delta = skillData.paramNum1
    else
      return
    end
  else
    return
  end
  local target, pos
  local animRes = ""
  local BMgr = BMgr or BMgrOL
  if skillId == 7011 then
    target = BMgr.getBuddhaTower()
    pos = cc.p(0, 0)
    animRes = "xw_yfthxtx"
  elseif skillId == 7012 then
    target = BMgr.getMonsterTower()
    pos = cc.p(0, 0)
    animRes = "nrggzbjttx"
  end
  if not target then
    return
  end
  local anim = EffectMgr.runAnimationEvent("app/relics", animRes, function(event)
    if not self:isValid() then
      return
    end
    if event.name ~= "FRAME_END" then
      return
    end
    DYNotification.post(info.key, info)
  end)
  anim:pos(pos.x, pos.y):addTo(target, 100)
end

return M

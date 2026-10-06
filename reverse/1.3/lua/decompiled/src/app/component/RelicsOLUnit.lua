local FRAME_SEC = 0
local DYClass = "RelicsOLUnit"
local M = class(DYClass, DYUnitBase)

function M:onLoad()
  FRAME_SEC = GameManager.FRAME_SEC
  BMgrOL.insertRelics(self)
  self.mTimer = {}
end

function M:onDestroy()
  BMgrOL.removeRelics(self)
end

function M:castSkill(sid, skillData, isBuddha)
  local tSwitch = {
    ["1"] = function()
      self:onSkillChangeElement({id = sid, data = skillData}, isBuddha)
    end,
    ["2"] = function()
      self:onSkillUpdateSpirit({id = sid, data = skillData}, isBuddha)
    end,
    ["3"] = function()
      self:onSkillUpdateTower({id = sid, data = skillData}, isBuddha)
    end
  }
  local tFunc = tSwitch[checkstring(skillData.attackType)]
  if tFunc then
    tFunc()
  end
end

function M:doThings()
  local timer = self.mTimer.onSkillChangeElement
  if timer and 0 < timer then
    timer = timer - 1
    self.mTimer.onSkillChangeElement = timer
    if timer <= 0 then
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
      GameData.SCENE_ELEMENT_MONSTER = {
        0,
        0,
        0,
        0,
        0
      }
      self.mTimer.onSkillChangeElement = nil
    end
  else
    self.mTimer.onSkillChangeElement = nil
  end
end

function M:onSkillClean()
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
  GameData.SCENE_ELEMENT_MONSTER = {
    0,
    0,
    0,
    0,
    0
  }
end

function M:onSkillChangeElement(param, isBuddha)
  local skillData = param.data
  if skillData.paramType1 == 0 then
    return self:onSkillResetElement(param, isBuddha)
  end
  if isBuddha then
    GameData.SCENE_ELEMENT_BUDDHA = {
      0,
      0,
      0,
      0,
      0
    }
    GameData.SCENE_ELEMENT_MONSTER = {
      0,
      0,
      0,
      0,
      0
    }
    GameData.SCENE_ELEMENT_BUDDHA[skillData.paramType1] = skillData.paramNum1
  else
    GameData.SCENE_ELEMENT_BUDDHA = {
      0,
      0,
      0,
      0,
      0
    }
    GameData.SCENE_ELEMENT_MONSTER = {
      0,
      0,
      0,
      0,
      0
    }
    GameData.SCENE_ELEMENT_MONSTER[skillData.paramType1] = skillData.paramNum1
  end
  local target = self:getTarget()
  self.mTimer.onSkillChangeElement = math.floor(skillData.durationTime * FRAME_SEC)
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
  end)
  anim:setScale(4)
  anim:pos(display.cx, display.cy):addTo(target, 100)
end

function M:onSkillResetElement(param, isBuddha)
  GameData.SCENE_ELEMENT_BUDDHA = {
    0,
    0,
    0,
    0,
    0
  }
  GameData.SCENE_ELEMENT_MONSTER = {
    0,
    0,
    0,
    0,
    0
  }
  local target = self:getTarget()
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
  self.mTimer.onSkillChangeElement = nil
end

function M:onSkillUpdateSpirit(param, isBuddha)
  local skillId = param.id
  local skillData = param.data
  local info = {}
  local flip = not isBuddha
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
  if flip then
    info.isBuddha = not info.isBuddha
  end
  local target, pos
  local animRes = ""
  local animFlip = 1
  if skillId == 7007 then
    if flip then
      target = BMgrOL.getMonsterTower()
    else
      target = BMgrOL.getBuddhaTower()
    end
    pos = cc.p(0, 132)
    animRes = "jcdp_tglqtdj"
  elseif skillId == 7008 then
    if flip then
      target = BMgrOL.getBuddhaTower()
      pos = cc.p(-150, 132)
      animFlip = -1
    else
      target = BMgrOL.getMonsterTower()
      pos = cc.p(150, 132)
    end
    animRes = "fh_jdlqtdj"
  elseif skillId == 7009 then
    if flip then
      target = BMgrOL.getMonsterTower()
    else
      target = BMgrOL.getBuddhaTower()
    end
    pos = cc.p(0, 40)
    animRes = "jjyj_hltx"
  elseif skillId == 7010 then
    if flip then
      target = BMgrOL.getBuddhaTower()
      pos = cc.p(0, 0)
      animFlip = -1
    else
      target = BMgrOL.getMonsterTower()
      pos = cc.p(0, 0)
    end
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
  anim:setScaleX(animFlip)
  anim:pos(pos.x, pos.y):addTo(target, 100)
end

function M:onSkillUpdateTower(param, isBuddha)
  local skillId = param.id
  local skillData = param.data
  local info = {}
  local flip = not isBuddha
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
  if flip then
    info.isBuddha = not info.isBuddha
  end
  local target, pos
  local animRes = ""
  local BMgr = BMgrOL
  if skillId == 7011 then
    if flip then
      target = BMgr.getMonsterTower()
    else
      target = BMgr.getBuddhaTower()
    end
    pos = cc.p(0, 0)
    animRes = "xw_yfthxtx"
  elseif skillId == 7012 then
    if flip then
      target = BMgr.getBuddhaTower()
    else
      target = BMgr.getMonsterTower()
    end
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

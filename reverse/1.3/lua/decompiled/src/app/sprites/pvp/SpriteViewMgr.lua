local BuffView = require("app.sprites.pvp.BuffViewOL")
local FLAGATTACK = "gongji"
local FLAGHURT = "shoushang"
local FLAGSKILL = "s1_atk"
local FLAGSKILL2 = "s2_atk"
local FLAGHURT1 = "hurt"
local FLAGATTACK1 = "atk"
local M = {}

function M.createBoneView(modelName)
  DYRes.loadFileInfo(string.format("armature/%s/%s.csb", modelName, modelName), GameData.S_FILE_INFO)
  local armature = ccs.Armature:create(modelName)
  cc.GameObject.extend(armature):addComponent("components.behavior.EventProtocol"):exportMethods()
  
  function armature.changeArmatureStateTo(stateIndex)
    local curState = armature.getAnimationState()
    armature:getAnimation():playWithIndex(stateIndex)
  end
  
  function armature.getAnimationState()
    return armature:getAnimation():getCurrentMovementID()
  end
  
  function armature:setSpeed(v)
    armature:getAnimation():setSpeedScale(v)
  end
  
  local function animationEvent(armatureBack, movementType, movementID)
    local id = movementID
    if movementType == ccs.MovementEventType.complete then
      if id == FLAGATTACK or id == FLAGATTACK1 or id == FLAGSKILL or id == FLAGSKILL2 then
        armature:dispatchEvent({
          name = "ATTACK_COMPLETE"
        })
      elseif id == FLAGHURT or id == FLAGHURT1 then
        armature:dispatchEvent({
          name = "HURT_COMPLETE"
        })
      end
    end
  end
  
  armature:getAnimation():setMovementEventCallFunc(animationEvent)
  return armature
end

function M.hurtEffect(source)
  if not source.isInTint_ then
    source.isInTint_ = true
    local tint = cc.TintTo:create(0, 243, 83, 7)
    local tintBack = cc.TintTo:create(0, 255, 255, 255)
    local dt = cc.DelayTime:create(0.4)
    source.mAnimator:runAction(transition.sequence({
      tint,
      dt,
      tintBack,
      cc.CallFunc:create(function()
        source.isInTint_ = false
      end)
    }))
  end
  if not source.isInShake_ then
    source.isInShake_ = true
    local m1 = cc.MoveBy:create(0.1, cc.p(5, 0))
    local m2 = cc.MoveBy:create(0.1, cc.p(-5, 0))
    source.mAnimator:runAction(transition.sequence({
      m1,
      m2,
      m1,
      m2,
      cc.CallFunc:create(function()
        source.isInShake_ = false
      end)
    }))
  end
  if source.mHitEffectCount < 4 then
    display.addSpriteFrames("animation/dadouyanwu.plist", "animation/dadouyanwu.png")
    local frames = display.newFrames("dadouyanwu%d.png", 1, 7)
    local animation = display.newAnimation(frames, 0.07)
    local sp = display.newSprite()
    sp:setAnchorPoint(cc.p(0.5, 0))
    local rect = source:getContentSize()
    sp:setScale((rect.width / 1.4 + rect.height / 1.4) / 200)
    source:addChild(sp, 11)
    sp:playAnimationOnce(animation, true, function()
      source.mHitEffectCount = source.mHitEffectCount - 1
    end)
  end
  if source.mHitEffectCount > 6 then
    source.mHitEffectCount = 0
  end
  source.mHitEffectCount = source.mHitEffectCount + 1
end

function M.showDamage(hpLose, damageType)
  display.addSpriteFrames("buff/buff_effect.plist", "buff/buff_effect.png")
  local showType = damageType or 1
  local tmpNode = display.newNode()
  local font
  if 2 == showType then
    font = cc.ui.UILabel.newBMFontLabel_({
      text = string.format("%d", hpLose),
      font = "fonts/critBattle.fnt"
    }):addTo(tmpNode)
    local sp = display.newSprite("#crit.png")
    sp:setAnchorPoint(1, 0.7)
    sp:setScale(1)
    sp:addTo(tmpNode)
    font:setAnchorPoint(0, 0.5)
    tmpNode:setLocalZOrder(9999)
    tmpNode:setScale(Const.Zoom0)
    tmpNode:setCascadeOpacityEnabled(true)
    local sequence = transition.sequence({
      cc.ScaleTo:create(0.3, 0.5),
      cc.ScaleTo:create(0.3, 0.4),
      cc.DelayTime:create(0.3),
      cc.FadeOut:create(0.2),
      cc.CallFunc:create(function()
        tmpNode:removeSelf()
      end)
    })
    tmpNode:runAction(sequence)
  elseif 1 == showType then
    font = cc.ui.UILabel.newBMFontLabel_({
      text = string.format("-%d", hpLose),
      font = "fonts/battle_red.fnt"
    }):addTo(tmpNode)
    local sequence = transition.sequence({
      cc.ScaleTo:create(0.2, 0.5),
      cc.ScaleTo:create(0.2, 0.4),
      cc.DelayTime:create(0.3),
      cc.FadeOut:create(0.2),
      cc.CallFunc:create(function()
        tmpNode:removeSelf()
      end)
    })
    tmpNode:runAction(sequence)
  elseif 3 == showType then
    local sp = display.newSprite("#miss.png"):addTo(tmpNode)
  elseif 4 == showType then
    local sp = display.newSprite("#dikang.png"):addTo(tmpNode)
    local sequence = transition.sequence({
      cc.ScaleTo:create(0.3, 0.5),
      cc.ScaleTo:create(0.3, 0.4),
      cc.DelayTime:create(0.3),
      cc.FadeOut:create(0.2),
      cc.CallFunc:create(function()
        tmpNode:removeSelf()
      end)
    })
    tmpNode:runAction(sequence)
  elseif 5 == showType then
    font = cc.ui.UILabel.newBMFontLabel_({
      text = string.format("-%d", hpLose),
      font = "fonts/critBattle.fnt"
    }):addTo(tmpNode)
    tmpNode:setLocalZOrder(9999)
    tmpNode:setScale(Const.Zoom0)
    tmpNode:setCascadeOpacityEnabled(true)
    local sequence = transition.sequence({
      cc.ScaleTo:create(0.3, 0.5),
      cc.ScaleTo:create(0.3, 0.4),
      cc.DelayTime:create(0.3),
      cc.FadeOut:create(0.2),
      cc.CallFunc:create(function()
        tmpNode:removeSelf()
      end)
    })
    tmpNode:runAction(sequence)
  elseif 10 == showType then
    local font = cc.ui.UILabel.newBMFontLabel_({
      text = string.format("+%d", math.abs(hpLose)),
      font = "fonts/greenNum.fnt"
    }):addTo(tmpNode)
    local sequence = transition.sequence({
      cc.ScaleTo:create(0.3, 0.8),
      cc.ScaleTo:create(0.3, 0.6),
      cc.DelayTime:create(0.3),
      cc.FadeOut:create(0.2),
      cc.CallFunc:create(function()
        tmpNode:removeSelf()
      end)
    })
    tmpNode:runAction(sequence)
  end
  return tmpNode
end

function M.createFrameView()
end

function M.createDeathBoom()
  display.addSpriteFrames("animation/wofangsiwangyan.plist", "animation/wofangsiwangyan.png")
  local frames = display.newFrames("wofangsiwangyan%d.png", 1, 7)
  local animation = display.newAnimation(frames, 0.15)
  local smoke = display.newSprite()
  return smoke
end

function M.createAreaAnimation(mType, posx)
  local FLAG_HUOYAN = 1008
  local FLAG_DUQI = 1014
  local FLAG_BINGSHUANG = 1013
  local FLAG_PALSY = 1006
  local FLAG_DEATH = 1016
  local frames
  local offsetY = 0
  local tmpScale = 1
  local zOrder = 0
  if mType == FLAG_DUQI then
    display.addSpriteFrames("buff/buff_area_posion.plist", "buff/buff_area_posion.png")
    frames = display.newFrames("duqi%d.png", 1, 16)
    offsetY = offsetY + 30
  elseif mType == FLAG_HUOYAN then
    display.addSpriteFrames("buff/buff_area_burn.plist", "buff/buff_area_burn.png")
    frames = display.newFrames("yanjiang%d.png", 1, 10)
  elseif mType == FLAG_BINGSHUANG then
    display.addSpriteFrames("buff/buff_bing.plist", "buff/buff_bing.png")
    frames = display.newFrames("bindu%d.png", 1, 34)
    offsetY = offsetY + 90
    tmpScale = 1.3
    zOrder = 20
  elseif mType == FLAG_PALSY then
    display.addSpriteFrames("buff/buff_area_psy.plist", "buff/buff_area_psy.png")
    frames = display.newFrames("dianmuBUFF%d.png", 1, 15)
    offsetY = offsetY + 45
    tmpScale = 1.3
    zOrder = 20
  elseif mType == FLAG_DEATH then
    display.addSpriteFrames("buff/buff_area_death.plist", "buff/buff_area_death.png")
    frames = display.newFrames("guishou%d.png", 1, 7)
    offsetY = offsetY + 45
    tmpScale = 0.8
    zOrder = 20
  else
    error("ID\233\148\153\232\175\175")
  end
  local animation = display.newAnimation(frames, 0.08)
  local sp = display.newSprite()
  sp:setPosition(posx, offsetY)
  sp:playAnimationForever(animation, true)
  sp:setScale(tmpScale)
  sp:addTo(GameData.BG, zOrder)
  return sp
end

function M.createBuffView(name, height, width)
  return BuffView[name](height, width)
end

function M.createPressCommon()
  display.addSpriteFrames("buff/buff_press_common.plist", "buff/buff_press_common.png")
  local frames = display.newFrames("fiqshiftx%d.png", 1, 19)
  local animation = display.newAnimation(frames, 0.05)
  local sp = display.newSprite()
  sp:playAnimationOnce(animation, true)
  return sp
end

function M.createFBIWarning()
  local node = display.newNode()
  node:setCascadeOpacityEnabled(true)
  node:setOpacity(255)
  local bg = display.newSprite("gamescene/fbiwarning.png"):addTo(node)
  local font = display.newSprite("gamescene/fbiwarning_1.png"):addTo(node)
  local sequence = transition.sequence({
    cc.FadeIn:create(0.5),
    cc.FadeOut:create(0.5),
    cc.FadeIn:create(0.5),
    cc.FadeOut:create(0.5)
  })
  node:runAction(sequence)
  return node
end

function M.createCimCommonEffect()
  local frames = display.newFrames("qiutx%d.png", 1, 7)
  local animation = display.newAnimation(frames, 0.125)
  local sp = display.newSprite()
  sp:playAnimationOnce(animation, true, nil, delayTime)
  return sp
end

function M.createSummontx(index)
  local index = index or 0
  DYRes.loadFileInfo("buff/zhaohuanmentx/zhaohuanmentx.csb", GameData.S_FILE_INFO)
  local armature = ccs.Armature:create("zhaohuanmentx")
  armature:setScale(1.2)
  armature:getAnimation():playWithIndex(index)
  return armature
end

return M

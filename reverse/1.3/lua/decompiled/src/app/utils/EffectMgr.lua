local M = {}
local S_FILE_INFO = {}

function M.runAnimationEvent(path, anim, cb)
  local fn = anim
  local fi = string.format("%s/%s/%s.csb", path, fn, fn)
  DYRes.loadFileInfo(fi, GameData.S_FILE_INFO)
  local armature = ccs.Armature:create(fn)
  armature:setPosition(0, 0)
  armature:getAnimation():playWithIndex(0)
  
  local function tFuncAnimationEvent(armatureBack, movementType, movementID)
    local id = movementID
    if movementType == ccs.MovementEventType.start then
      if cb then
        cb({
          name = "FRAME_BEGIN",
          target = armature
        })
      end
    elseif movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
      if cb then
        cb({name = "FRAME_END", target = armature})
      end
      armature:runAction(cc.RemoveSelf:create())
    end
  end
  
  armature:getAnimation():setMovementEventCallFunc(tFuncAnimationEvent)
  
  local function tFuncFrameEvent(bone, name, origIdx, curIdx)
    if cb then
      cb({
        name = name,
        origin = origIdx,
        current = curIdx,
        target = armature
      })
    end
  end
  
  armature:getAnimation():setFrameEventCallFunc(tFuncFrameEvent)
  return armature
end

function M.runEffectFadeEvent(duration, isOut, cb)
  local layer = display.newColorLayer(cc.c4b(255, 255, 255, 255)):addTo(display:getRunningScene(), 100)
  layer:setCascadeOpacityEnabled(true)
  local act
  if isOut then
    act = cc.FadeOut:create(duration)
    layer:setOpacity(255)
  else
    act = cc.FadeIn:create(duration)
    layer:setOpacity(0)
  end
  layer:runAction(cc.Sequence:create(act, cc.CallFunc:create(function()
    if cb then
      cb()
    end
  end), cc.RemoveSelf:create()))
end

function M.createButterfly()
  local fn = "hudie"
  local fi = string.format("effects/%s/%s.csb", fn, fn)
  DYRes.loadFileInfo(fi, S_FILE_INFO)
  local armature = ccs.Armature:create(fn)
  armature:setPosition(0, 0)
  armature:getAnimation():play(fn, -1, 1)
  local S_CORNOR = {
    cc.p(-200, -100),
    cc.p(-200, 100),
    cc.p(200, 100),
    cc.p(200, -100)
  }
  local S_INDEX = 1
  local tBezierAct, tDelayAct
  
  local function tFuncPrepare()
    local pt = cc.p(armature:getPosition())
    local tIndex = 0
    if S_INDEX == 1 then
      tIndex = math.random(1, 1000)
    else
      tIndex = S_INDEX
    end
    local ptCornor = S_CORNOR[tIndex % #S_CORNOR + 1]
    local ptMid = cc.p(0, 0)
    local ptEnd = clone(ptCornor)
    ptEnd = cc.pAdd(pt, ptEnd)
    if S_INDEX == 1 then
      ptEnd.x = math.floor(ptEnd.x / 2)
      ptEnd.y = math.floor(ptEnd.y / 2)
    end
    S_INDEX = tIndex + 1
    ptMid.x = math.random(math.min(pt.x, ptEnd.x), math.max(pt.x, ptEnd.x))
    ptMid.y = ptEnd.y
    armature:setScaleX(1)
    if 0 < ptCornor.x then
      armature:setScaleX(-1)
    else
      armature:setScaleX(1)
    end
    local dura = math.random(5, 10)
    tBezierAct = cc.BezierTo:create(dura, {
      pt,
      ptMid,
      ptEnd
    })
    local dura = math.random() * 0.5
    tDelayAct = cc.DelayTime:create(0)
    local speedScale = 0.7 + math.random() * 0.9
    armature:getAnimation():setSpeedScale(speedScale)
    armature:runAction(cc.Sequence:create(tBezierAct, tDelayAct, cc.CallFunc:create(tFuncPrepare)))
  end
  
  local t = display.newNode()
  t:addChild(armature)
  t:setScale(0.5)
  
  function t:play()
    tFuncPrepare()
  end
  
  return t
end

function M.runEffectLoading(label, text, delay)
  if not label then
    return
  end
  text = checkstring(text)
  local strLoad = {
    text,
    text .. ".",
    text .. "..",
    text .. "..."
  }
  local ti = 0
  
  local function tFuncLoading()
    ti = (ti + 1) % #strLoad
    label:setString(strLoad[ti + 1])
    label:performWithDelay(tFuncLoading, delay)
  end
  
  tFuncLoading()
end

function M.runActionFlyShuffle(duration, target, funcActEnd)
  if not target then
    return
  end
  local parent = target:getParent()
  local tx = target:getPositionX()
  local ty = target:getPositionY()
  local ng = cc.NodeGrid:create()
  local spr = cc.Sprite:createWithTexture(target:getTexture())
  ng:addChild(spr)
  ng:setPosition(tx, ty)
  if parent then
    parent:addChild(ng, 1000)
  end
  ng:setCascadeOpacityEnabled(true)
  local a1 = cc.ShuffleTiles:create(5, cc.size(150, 50), 500)
  local a2 = cc.Spawn:create(a1, cc.FadeTo:create(duration, 0))
  local seq = cc.Sequence:create(a2, cc.RemoveSelf:create())
  ng:runAction(seq)
  local a1 = cc.DelayTime:create(duration)
  local a2 = cc.CallFunc:create(function()
    if funcActEnd then
      funcActEnd(target)
    end
  end)
  local seq = cc.Sequence:create(a1, a2)
  ng:runAction(seq)
  return ng
end

function M.gotoLayerScene(layer)
  local scene = display.newScene()
  scene.common_bg = display.newSprite("common_ui/common_bg.png"):pos(display.cx, display.cy):addTo(scene)
  scene:addChild(layer)
  display.replaceScene(scene, "fadeUp", 0.6)
end

function M.gotoChapter(tag, param1, param2)
  local scene = require("scenes.ChapterScene").new()
  display.replaceScene(scene, "fadeDown", 0.5)
end

return M

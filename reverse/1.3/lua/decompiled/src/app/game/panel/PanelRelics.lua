local IconItem = require("app.icons.IconItem")
local CLASS_NAME = "PanelRelics"
local M = {}
M = class(CLASS_NAME, function()
  return display.newNode()
end)
local demoRelicsList = {
  9602,
  9630,
  9603,
  9621,
  9605,
  9612
}
local S_VISIBLE_CNT = 3

function M:ctor(stageNum)
  self.mRelicsData = GameManager.RELICS_LIST
  dump(GameManager.RELICS_LIST, " GameManager.RELICS_LIST : ")
  self.mRelics = {count = 0}
  self.mCoreNode = display.newNode():addTo(self)
  self.mRelicsUnit = nil
  self.mGlobalTag = DYCommon.genGlobalTag()
  display.addSpriteFrames("buff/yuanjuntexiao.plist", "buff/yuanjuntexiao.png")
  self:performWithDelay(handler(self, self.layoutUI), 0)
  self:setNodeEventEnabled(true)
end

function M:onEnter()
end

function M:onExit()
end

local function createView(res)
  local frames = display.newFrames(res.name, res.frame1, res.frame2)
  local animation = display.newAnimation(frames, res.frameDelta)
  local sp = display.newSprite()
  if res.isLoop then
    sp:playAnimationForever(animation, true, delayTime)
  else
    sp:playAnimationOnce(animation, true, nil, delayTime)
  end
  return sp
end

local function createYindaokuang()
  local res = {}
  res.name = "yingdaokuang%d.png"
  res.frame1 = 1
  res.frame2 = 13
  res.frameDelta = 0.05
  res.isLoop = true
  local sp = createView(res)
  return sp
end

function M:layoutUI()
  if #self.mRelicsData <= 0 then
    return
  end
  self:addBg()
  self:addContent()
  self.mRelicsUnit = self:addUnit("app.component.RelicsUnit")
end

function M:addBg()
  local node = self.mCoreNode
end

function M:addContent()
  local node = self.mCoreNode
  local idx = 1
  for k, v in pairs(self.mRelicsData) do
    while true do
      local equip = DataUtils.getEquipmentModel(v)
      if not equip.skillId or equip.skillId == -1 then
        break
      end
      local skill = DataUtils.getRelicsSkillModel(equip.skillId)
      local icon = self:createIcon(equip, skill):pos(display.cx, display.cy):addTo(node)
      icon:setCascadeOpacityEnabled(true)
      icon:setScale(0.8)
      icon.equipData = equip
      icon.skillData = skill
      icon.idx = idx
      local anim = EffectMgr.runAnimationEvent("app/armature", "yuanjuntexiao1", handler(self, self.onEventAnimation)):addTo(node)
      anim:pos(display.cx, display.cy)
      anim:setScale(2)
      anim.model = {icon = icon, idx = idx}
      idx = idx + 1
      break
    end
  end
end

function M:createIcon(equip, skill)
  local item = display.newNode()
  item.icon = IconItem.new(equip.id, 0):addTo(item)
  return item
end

function M:coolDown(target, coldTime)
  target.isCold = true
  if not target.sprShadow then
    target.sprShadow = display.newSprite("gamescene/buddha_shadow.png"):addTo(target, 2)
  end
  target.sprShadow:show()
  target.mProgressTimer = display.newProgressTimer("gamescene/bar_green.png", display.PROGRESS_TIMER_BAR):pos(0, -40):addTo(target, 9)
  target.mProgressTimer:setMidpoint(cc.p(0, 0))
  target.mProgressTimer:setBarChangeRate(cc.p(1, 0))
  target.mProgressTimer:setPercentage(0)
  target.mProgressTimer:setNodeEventEnabled(true)
  DYNotification.regObserver(target.mProgressTimer, function(name, param)
    if target.mProgressTimer and target.mProgressTimer[param] then
      target.mProgressTimer[param](target.mProgressTimer)
    end
  end, self.mGlobalTag)
  local realCDTime = coldTime
  local progressTo = cc.ProgressTo:create(realCDTime, 100)
  transition.execute(target.mProgressTimer, progressTo, {
    onComplete = function()
      target.sprEffect:show()
      if target.mProgressTimer ~= nil then
        target.mProgressTimer:removeSelf()
        target.mProgressTimer = nil
      end
      target.sprShadow:hide()
      target.isCold = false
    end
  })
end

function M:removeSkillIcon(target)
  target:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1, 0), cc.RemoveSelf:create()))
  local idx = checknumber(target.idx) + 1
  while idx <= self.mRelics.count do
    local spr = self.mRelics[checkstring(idx)]
    if spr then
      spr:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), cc.MoveBy:create(0.2, cc.p(0, 100))))
      if idx == S_VISIBLE_CNT + 1 then
        spr:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), cc.ScaleTo:create(0.2, 0.8)))
      end
    end
    self.mRelics[checkstring(idx - 1)] = spr
    spr.idx = checkstring(idx - 1)
    idx = idx + 1
  end
  self.mRelics.count = self.mRelics.count - 1
end

function M:onEventTouchIcon(target)
  if not target or target.isCold then
    return
  end
  DYSoundMgr.playEffect(DY_SND.sfx_buddha_makeup)
  local equip = target.equipData
  local skill = target.skillData
  self:removeSkillIcon(target)
  self.mRelicsUnit:castSkill(equip.skillId, skill)
end

function M:onEventAnimation(event)
  if event.name ~= "FRAME_END" then
    return
  end
  local model = event.target.model
  local icon = model.icon
  local idx = checknumber(model.idx)
  local sx = display.width - 64
  local sy = 450 - (idx - 1) * 100
  self:coolDown(icon, icon.skillData.prepareTime)
  icon:fadeIn(0.5)
  icon:moveTo(1, sx, sy)
  icon.sprEffect = createYindaokuang():addTo(icon, 1)
  icon.sprEffect:setScale(1.4)
  icon.sprEffect:hide()
  icon:setTouchEnabled(true)
  icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onEventTouchIcon(icon)
  end)
  if idx > S_VISIBLE_CNT then
    icon:setScale(0)
  end
  self.mRelics[checkstring(idx)] = icon
  self.mRelics.count = self.mRelics.count + 1
end

function M:pauseEx()
  DYNotification.post(self.mGlobalTag, "pause")
end

function M:resumeEx()
  DYNotification.post(self.mGlobalTag, "resume")
end

return M

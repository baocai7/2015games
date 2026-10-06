local DemoBuddhaTable = require("app.profiles.demoBuddha")
local CLASS_NAME = "PanelDemoBuddha"
local M = {}
M = class(CLASS_NAME, function()
  return display.newNode()
end)
local globalTag = DYCommon.genGlobalTag()

function M:ctor(stageNum)
  local demoBuddhaList = DemoBuddhaTable["stage" .. stageNum]
  if not demoBuddhaList then
    return
  end
  display.addSpriteFrames("buff/yuanjuntexiao.plist", "buff/yuanjuntexiao.png")
  self.demoBuddhaList = demoBuddhaList
  self.mCoreNode = nil
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
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

local function createChuchangbai()
  local res = {}
  res.name = "chuchangbai%d.png"
  res.frame1 = 1
  res.frame2 = 11
  local frames = display.newFrames(res.name, res.frame1, res.frame2)
  local animation = display.newAnimation(frames, 0.03333333333333333)
  return animation
end

local function createZhaohuan()
  local res = {}
  res.name = "zhaohuanjinkuang%d.png"
  res.frame1 = 1
  res.frame2 = 32
  local frames = display.newFrames(res.name, res.frame1, res.frame2)
  local animation = display.newAnimation(frames, 0.03333333333333333)
  return animation
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
  local node = display.newSprite("gamescene/demoBuddha_background.png"):pos(0, 0):addTo(self)
  for k, v in pairs(self.demoBuddhaList.buddhaList) do
    local sprite = self.createIcon(v)
    sprite:setOpacity(0)
    sprite:setCascadeOpacityEnabled(true)
    sprite:setScale(0.8)
    local filePath = string.format("armature/%s/%s.csb", "yuanjuntexiao1", "yuanjuntexiao1")
    DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
    local curScene = GameData.BG:getParent():getParent()
    local armature = ccs.Armature:create("yuanjuntexiao1")
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(display.cx, display.cy)
    armature:setScale(2)
    armature:setTouchEnabled(false)
    armature:addTo(display.getRunningScene())
    sprite:setPosition(display.cx, display.cy)
    curScene:addChild(sprite, 1)
    DDLOG(DYLang.getString("S253", ""))
    
    local function animationEvent(armatureBack, movementType, movementID)
      local id = movementID
      if movementType == ccs.MovementEventType.complete then
        DDLOG(DYLang.getString("S254", ""))
        local sx = display.width * 0.05 - 12.5
        local sy = display.height * (0.8 - 0.15 * (k - 1)) - 80
        sprite:fadeIn(0.5)
        sprite:moveTo(1, sx, sy)
        sprite.sp = createYindaokuang():addTo(sprite, 1)
        sprite.sp:setPosition(cc.p(59.5, 59.5))
        sprite.sp:setScale(1.4)
        local c = sprite:getBoundingBox()
        sprite:size(c.width, c.height)
        sprite:setTouchEnabled(false)
        sprite.icon:setTouchEnabled(true)
        sprite.icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
          return M.onIconTouch(event, tostring(v), sprite)
        end)
      end
    end
    
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
  end
  self.mCoreNode = node
end

function M.createIcon(v)
  local model = DataUtils.getMonsterModel(tostring(v))
  local iconFrame = display.newSprite("common_ui/frame_battle.png")
  iconFrame._coolDown = model.cdTime or 60
  iconFrame.mShadow = display.newSprite("gamescene/buddha_shadow.png"):pos(55, 55):hide():addTo(iconFrame, 2)
  iconFrame.icon = display.newSprite(model.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  return iconFrame
end

local function removeProTimer(target)
  if target.mProgressTimer ~= nil then
    target.mProgressTimer:removeFromParent()
    target.mProgressTimer = nil
  end
  target.mShadow:hide()
  target.mIsInCD = false
end

local function coolDown(target, coldTime)
  target.mIsInCD = true
  target.mShadow:show()
  target.mProgressTimer = display.newProgressTimer("gamescene/bar_green.png", display.PROGRESS_TIMER_BAR):pos(55, 15):addTo(target, 9)
  target.mProgressTimer:setMidpoint(cc.p(0, 0))
  target.mProgressTimer:setBarChangeRate(cc.p(1, 0))
  target.mProgressTimer:setPercentage(0)
  target.mProgressTimer:setNodeEventEnabled(true)
  DYNotification.regObserver(target.mProgressTimer, function(name, param)
    if target.mProgressTimer and target.mProgressTimer[param] then
      target.mProgressTimer[param](target.mProgressTimer)
    end
  end, globalTag)
  local realCDTime = coldTime
  local progressTo = cc.ProgressTo:create(realCDTime, 100)
  transition.execute(target.mProgressTimer, progressTo, {
    onComplete = function()
      target.sp:show()
      removeProTimer(target)
    end
  })
end

function M.onIconTouch(event, buddhaId, sprite)
  if sprite.mIsInCD then
    return
  end
  sprite.sp:hide()
  coolDown(sprite, sprite._coolDown)
  DYSoundMgr.playEffect(DY_SND.sfx_buddha_makeup)
  BMgr.createDemoBuddha(buddhaId)
end

function M:show()
  if self.demoBuddhaList then
    self:layoutUI()
    self:setVisible(true)
  end
end

function M:pauseEx()
  DYNotification.post(globalTag, "pause")
end

function M:resumeEx()
  DYNotification.post(globalTag, "resume")
end

return M

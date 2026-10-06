local DYClass = "BuffView"
local delayTime = 0.05
local M = {}

local function createBuffView(res)
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

function M.phyAtkAdd()
  local res = {}
  res.name = "ZJgongji%d.png"
  res.frame1 = 1
  res.frame2 = 13
  res.isLoop = false
  return createBuffView(res)
end

function M.phyAtkSub()
  local res = {}
  res.name = "jiangongji%d.png"
  res.frame1 = 1
  res.frame2 = 10
  res.isLoop = false
  return createBuffView(res)
end

function M.phyDefAdd()
  local res = {}
  res.name = "hudun%d.png"
  res.frame1 = 1
  res.frame2 = 13
  res.isLoop = false
  return createBuffView(res)
end

function M.phyDefSub()
  local res = {}
  res.name = "jianfangyu%d.png"
  res.frame1 = 1
  res.frame2 = 14
  res.isLoop = false
  return createBuffView(res)
end

function M.magAtkAdd()
  local res = {}
  res.name = "fashugongji%d.png"
  res.frame1 = 1
  res.frame2 = 11
  res.isLoop = false
  return createBuffView(res)
end

function M.magAtkSub()
  local res = {}
  res.name = "fashujiangongji%d.png"
  res.frame1 = 1
  res.frame2 = 13
  res.isLoop = false
  return createBuffView(res)
end

function M.magDefAdd()
  local res = {}
  res.name = "fashuhudun%d.png"
  res.frame1 = 1
  res.frame2 = 13
  res.isLoop = false
  return createBuffView(res)
end

function M.magDefSub()
  local res = {}
  res.name = "fashujianfangyu%d.png"
  res.frame1 = 1
  res.frame2 = 9
  res.isLoop = false
  return createBuffView(res)
end

function M.stun()
  local res = {}
  res.name = "yunxuan%d.png"
  res.frame1 = 1
  res.frame2 = 10
  res.isLoop = true
  return createBuffView(res)
end

function M.freeze()
  local res = {}
  res.name = "bingfeng%d.png"
  res.frame1 = 1
  res.frame2 = 17
  res.isLoop = false
  return createBuffView(res)
end

function M.burn()
  local res = {}
  res.name = "bingfeng%d.png"
  res.frame1 = 1
  res.frame2 = 17
  res.isLoop = false
  return createBuffView(res)
end

function M.palsy()
  local res = {}
  res.name = "mabi%d.png"
  res.frame1 = 1
  res.frame2 = 4
  res.frameDelta = 0.08
  res.isLoop = true
  return createBuffView(res)
end

function M.rebel()
  local res = {}
  res.name = "shoumeihuo%d.png"
  res.frame1 = 1
  res.frame2 = 14
  res.isLoop = true
  return createBuffView(res)
end

function M.meihuo()
  local res = {}
  res.name = "meihuo%d.png"
  res.frame1 = 1
  res.frame2 = 9
  res.isLoop = false
  return createBuffView(res)
end

function M.chenmo()
  local sp = display.newSprite("#chenmo.png")
  return sp
end

function M.lifeMaxAdd()
  local res = {}
  res.name = "shengmshu%d.png"
  res.frame1 = 1
  res.frame2 = 16
  res.isLoop = false
  return createBuffView(res)
end

function M.lifeRecovey()
  local res = {}
  res.name = "shouxue%d.png"
  res.frame1 = 1
  res.frame2 = 8
  res.frameDelta = 0.08
  res.isLoop = false
  return createBuffView(res)
end

function M.critAdd()
  local sp = display.newSprite("#kuangbao.png")
  local sequence = transition.sequence({
    cc.ScaleBy:create(0.4, 1.2),
    cc.ScaleBy:create(0.4, 0.83)
  })
  local action = cc.RepeatForever:create(sequence)
  sp:runAction(action)
  return sp
end

function M.qushan()
  local res = {}
  res.name = "qusat%d.png"
  res.frame1 = 1
  res.frame2 = 10
  res.frameDelta = 0.08
  res.isLoop = false
  return createBuffView(res)
end

function M.resist()
  local res = {}
  res.name = "kangti%d.png"
  res.frame1 = 1
  res.frame2 = 7
  res.frameDelta = 0.1
  res.isLoop = false
  return createBuffView(res)
end

return M

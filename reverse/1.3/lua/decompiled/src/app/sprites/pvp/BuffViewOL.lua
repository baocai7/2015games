local DYClass = "BuffViewOL"
local delayTime = 0.05
local M = {}
local MAX_SCALE = 2.5

local function calSize(height, width)
  local tmpSize = (width + height) / 175
  return tmpSize > MAX_SCALE and MAX_SCALE or tmpSize
end

local function createBuffView(res)
  local frames = display.newFrames(res.name, res.frame1, res.frame2)
  local sp = display.newSprite()
  if frames then
    local animation = display.newAnimation(frames, res.frameDelta)
    if res.isLoop then
      sp:playAnimationForever(animation, true, delayTime)
    else
      sp:playAnimationOnce(animation, true, nil, delayTime)
    end
  end
  return sp
end

function M.phyAtkAdd(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_atk.plist", "buff/buff_atk.png")
  res.name = "ZJgongji%d.png"
  res.frame1 = 1
  res.frame2 = 13
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setPositionY(height * 0.5)
  sp:setScale(calSize(height, width) * 1.3)
  return sp
end

function M.phyAtkSub(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_atk.plist", "buff/buff_atk.png")
  res.name = "jiangongji%d.png"
  res.frame1 = 1
  res.frame2 = 10
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) * 1.3)
  return sp
end

function M.phyDefAdd(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_phy_def.plist", "buff/buff_phy_def.png")
  res.name = "hudun%d.png"
  res.frame1 = 1
  res.frame2 = 13
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) * 1.3)
  return sp
end

function M.phyDefSub(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_phy_def.plist", "buff/buff_phy_def.png")
  res.name = "jianfangyu%d.png"
  res.frame1 = 1
  res.frame2 = 14
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) * 1.3)
  return sp
end

function M.phyResist(height, width)
  local res = {}
  res.name = "wulifangyu1_%d.png"
  res.frame1 = 1
  res.frame2 = 11
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) * 1.3)
  return sp
end

function M.magResist(height, width)
  local res = {}
  res.name = "fashufangyu2_%d.png"
  res.frame1 = 1
  res.frame2 = 11
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) * 1.3)
  return sp
end

function M.magAtkAdd(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_mag_atk.plist", "buff/buff_mag_atk.png")
  res.name = "fashugongji%d.png"
  res.frame1 = 1
  res.frame2 = 11
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) * 1.3)
  return sp
end

function M.magAtkSub(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_mag_atk.plist", "buff/buff_mag_atk.png")
  res.name = "fashujiangongji%d.png"
  res.frame1 = 1
  res.frame2 = 13
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) * 1.3)
  return sp
end

function M.magDefAdd(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_mag_def.plist", "buff/buff_mag_def.png")
  res.name = "fashuhudun%d.png"
  res.frame1 = 1
  res.frame2 = 13
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) * 1.3)
  return sp
end

function M.magDefSub(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_mag_def.plist", "buff/buff_mag_def.png")
  res.name = "fashujianfangyu%d.png"
  res.frame1 = 1
  res.frame2 = 9
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) * 1.3)
  return sp
end

function M.atkSpeedAdd(height, width)
  local res = {}
  res.name = "gonsu%d.png"
  res.frame1 = 1
  res.frame2 = 10
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) * 1.5)
  return sp
end

function M.atkSpeedSub(height, width)
end

function M.moveSpeedAdd(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_speed.plist", "buff/buff_speed.png")
  res.name = "sudutx%d.png"
  res.frame1 = 1
  res.frame2 = 12
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionY(height * 0.5)
  sp:setScale(calSize(height, width) * 1.5)
  return sp
end

function M.moveSpeedSub(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_speed.plist", "buff/buff_speed.png")
  res.name = "jiansu%d.png"
  res.frame1 = 1
  res.frame2 = 19
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionY(0)
  sp:setScale(calSize(height, width))
  return sp, -1
end

function M.harmDecrese(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_harm_decrease.plist", "buff/buff_harm_decrease.png")
  res.name = "tugd%d.png"
  res.frame1 = 1
  res.frame2 = 8
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) * 2)
  return sp
end

function M.stun(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_stun.plist", "buff/buff_stun.png")
  res.name = "yunxuan%d.png"
  res.frame1 = 1
  res.frame2 = 10
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionY(height)
  sp:setScale(2 * calSize(height, width))
  return sp
end

function M.freeze(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_freeze.plist", "buff/buff_freeze.png")
  res.name = "bingfeng%d.png"
  res.frame1 = 1
  res.frame2 = 17
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setPositionY(0)
  sp:setScale(calSize(height, width))
  return sp
end

function M.burn(height, width)
  local res = {}
  res.name = "shaoshang%d.png"
  res.frame1 = 1
  res.frame2 = 8
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionY(0)
  sp:setAnchorPoint(cc.p(0.5, 0))
  sp:setScale(calSize(height, width) * 0.8)
  return sp
end

function M.palsy(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_psy.plist", "buff/buff_psy.png")
  res.name = "mabi%d.png"
  res.frame1 = 1
  res.frame2 = 4
  res.frameDelta = 0.08
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setScale(calSize(height, width) * 0.5)
  sp:setPositionY(height / 2)
  return sp
end

function M.rebel(height, width)
  local res = {}
  res.name = "shoumeihuo%d.png"
  res.frame1 = 1
  res.frame2 = 14
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionX(width / 2)
  sp:setPositionY(height / 2)
  sp:setScale(calSize(height, width) / 2)
  return sp
end

function M.meihuo(height, width)
  local res = {}
  res.name = "meihuo%d.png"
  res.frame1 = 1
  res.frame2 = 9
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setPositionY(height * 0.6)
  sp:setScale(calSize(height, width))
  return sp
end

function M.chenmo(height, width)
  local sp = display.newSprite("#chenmo.png")
  sp:setPositionY(height * 1.1)
  sp:setScale(calSize(height, width) * 0.3)
  sp:setPositionX(width * 0.4)
  return sp
end

function M.lifeMaxAdd(height, width)
  local res = {}
  res.name = "shengmshu%d.png"
  res.frame1 = 1
  res.frame2 = 16
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionY(0)
  sp:setAnchorPoint(cc.p(0.5, 0.2))
  sp:setScale(calSize(height, width))
  return sp
end

function M.lifeRecovey(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_gain.plist", "buff/buff_gain.png")
  res.name = "shouxue%d.png"
  res.frame1 = 1
  res.frame2 = 8
  res.frameDelta = 0.08
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionY(0)
  sp:setAnchorPoint(cc.p(0.5, 0))
  sp:setScale(calSize(height, width) * 1.2)
  return sp
end

function M.critAdd(height, width)
  local sp = display.newSprite("#kuangbao.png")
  local sequence = transition.sequence({
    cc.ScaleBy:create(0.4, 1.2),
    cc.ScaleBy:create(0.4, 0.83)
  })
  local action = cc.RepeatForever:create(sequence)
  sp:setPositionY(height * 0.4)
  sp:setScale(calSize(height, width) * 0.8)
  sp:runAction(action)
  return sp, -1
end

function M.qushan(height, width)
  local res = {}
  res.name = "qusat%d.png"
  res.frame1 = 1
  res.frame2 = 11
  res.frameDelta = 0.08
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setPositionY(height)
  sp:setScale(calSize(height, width) * 1.2)
  return sp
end

function M.fuhuo(height, width)
  local res = {}
  res.name = "fuhzhihou%d.png"
  res.frame1 = 1
  res.frame2 = 11
  res.frameDelta = 0.08
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setPositionY(height * 0.3)
  return sp
end

function M.resist(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_resist.plist", "buff/buff_resist.png")
  res.name = "kangti%d.png"
  res.frame1 = 1
  res.frame2 = 7
  res.frameDelta = 0.1
  res.isLoop = false
  local sp = createBuffView(res)
  sp:setScale(calSize(height, width))
  sp:setPositionY(height * 0.3)
  return sp
end

function M.wudi(height, width)
  local res = {}
  display.addSpriteFrames("buff/buff_wudi.plist", "buff/buff_wudi.png")
  res.name = "wudi%d.png"
  res.frame1 = 1
  res.frame2 = 7
  res.frameDelta = 0.1
  res.isLoop = true
  local sp = createBuffView(res)
  sp:setScale(calSize(height, width) * 1.3)
  sp:setPositionY(height * 0.5)
  return sp
end

return M

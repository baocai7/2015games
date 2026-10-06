local CLASS_NAME = "PanelMoonBox"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer(CLASS_NAME)
end)
local TIME1 = 3.8
local TIME2 = 6
local TIME3 = 6.3
local TIME4 = 6.8
local TIME5 = 9.6
local TIME6 = 15
local TIME7 = 17.5
local TIME8 = 22.1
local TIME9 = 23.5

function M:ctor(callback)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCallback = callback
  self:setNodeEventEnabled(true)
end

function M:layoutUI()
  local bg = display.newSprite("opening_comic/moon_box/bg1.png", display.cx, display.cy):addTo(self)
  DYSoundMgr.stopMusic(true)
  DYSoundMgr.playMusic(DY_SND.sound_stage2_moon_music)
  self.mSkipButton = display.newSprite("common_ui/skip.png"):align(display.CENTER, display.width - 65, display.height * 0.93):addTo(self, 1)
  self.mSkipButton:setTouchEnabled(true)
  self.mSkipButton:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    DYSoundMgr.stopMusic(true)
    DYSoundMgr.playMusic(DY_SND.bgm_theme)
    if self.mCallback then
      self.mCallback()
    end
    self:removeSelf()
  end)
  local npc1 = display.newSprite("opening_comic/moon_box/npc1.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg)
  npc1:runAction(transition.sequence({
    cc.ScaleTo:create(TIME1, 0.9),
    cc.FadeOut:create(0)
  }))
  local text1 = display.newSprite("opening_comic/moon_box/text1.png"):opacity(0):align(display.CENTER_BOTTOM, bg:getContentSize().width * 0.5, 10):addTo(bg, 3)
  text1:runAction(transition.sequence({
    cc.FadeIn:create(0.3),
    cc.DelayTime:create(TIME1 - 0.3),
    cc.FadeOut:create(0)
  }))
  local text2 = display.newSprite("opening_comic/moon_box/text2.png"):opacity(0):align(display.CENTER_BOTTOM, bg:getContentSize().width * 0.5, 10):addTo(bg, 3)
  text2:runAction(transition.sequence({
    cc.DelayTime:create(TIME1),
    cc.FadeIn:create(0.3),
    cc.DelayTime:create(1.9),
    cc.FadeOut:create(0)
  }))
  local tangEye = display.newSprite("opening_comic/moon_box/eye.png"):opacity(0):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg, 1)
  tangEye:runAction(transition.sequence({
    cc.DelayTime:create(TIME1),
    cc.FadeIn:create(0),
    cc.DelayTime:create(2),
    cc.FadeOut:create(0.5)
  }))
  local black1 = display.newSprite("opening_comic/moon_box/black.png"):opacity(0):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height - 200):addTo(bg, 2)
  local black2 = display.newSprite("opening_comic/moon_box/black.png"):opacity(0):pos(bg:getContentSize().width * 0.5, 200):addTo(bg, 2)
  black1:runAction(transition.sequence({
    cc.DelayTime:create(TIME1),
    cc.FadeIn:create(0),
    cc.MoveBy:create(0.1, cc.p(0, 200)),
    cc.MoveBy:create(1, cc.p(0, 11)),
    cc.DelayTime:create(1.1),
    cc.FadeOut:create(0.5)
  }))
  black2:runAction(transition.sequence({
    cc.DelayTime:create(TIME1),
    cc.FadeIn:create(0),
    cc.MoveBy:create(0.1, cc.p(0, -200)),
    cc.MoveBy:create(1, cc.p(0, -11)),
    cc.DelayTime:create(1.1),
    cc.FadeOut:create(0.5)
  }))
  local text3 = display.newSprite("opening_comic/moon_box/text3.png"):opacity(0):align(display.CENTER_BOTTOM, bg:getContentSize().width * 0.5, 10):addTo(bg, 3)
  text3:runAction(transition.sequence({
    cc.DelayTime:create(TIME2),
    cc.FadeIn:create(0.2),
    cc.DelayTime:create(3.4),
    cc.FadeOut:create(0)
  }))
  self:performWithDelay(function()
    local armature = ccs.Armature:create("yueguangbaohe")
    armature:setPosition(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5)
    armature:addTo(bg, 2)
    armature:getAnimation():playWithIndex(0)
    armature:performWithDelay(function()
      armature:getAnimation():playWithIndex(1)
    end, 4)
    armature:performWithDelay(function()
      armature:getAnimation():playWithIndex(2)
    end, 8.5)
  end, TIME2)
  local eye = display.newSprite("opening_comic/moon_box/bg3.png"):opacity(0):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg, 1)
  eye:runAction(transition.sequence({
    cc.DelayTime:create(TIME3),
    cc.FadeIn:create(1),
    cc.DelayTime:create(7),
    cc.FadeOut:create(0.7)
  }))
  local bg2 = display.newSprite("opening_comic/moon_box/bg2.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):opacity(0):addTo(bg)
  bg2:runAction(transition.sequence({
    cc.DelayTime:create(TIME4),
    cc.FadeIn:create(0.6),
    cc.DelayTime:create(7),
    cc.FadeOut:create(0.6)
  }))
  local npc2 = display.newSprite("opening_comic/moon_box/npc2.png"):scale(2):opacity(0):pos(bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.6):addTo(bg, 1)
  local seq2 = transition.sequence({
    cc.FadeIn:create(0.5),
    cc.DelayTime:create(4.1),
    cc.FadeOut:create(0.7)
  })
  local spawn2 = cc.Spawn:create(cc.MoveBy:create(5.3, cc.p(-40, 0)), seq2)
  npc2:runAction(transition.sequence({
    cc.DelayTime:create(TIME5 + 0.1),
    spawn2
  }))
  local text4 = display.newSprite("opening_comic/moon_box/text4.png"):opacity(0):align(display.CENTER_BOTTOM, bg:getContentSize().width * 0.5, 10):addTo(bg, 3)
  text4:runAction(transition.sequence({
    cc.DelayTime:create(TIME5),
    cc.FadeIn:create(0.4),
    cc.DelayTime:create(5),
    cc.FadeOut:create(0)
  }))
  local text5 = display.newSprite("opening_comic/moon_box/text5.png"):opacity(0):align(display.CENTER_BOTTOM, bg:getContentSize().width * 0.5, 10):addTo(bg, 3)
  text5:runAction(transition.sequence({
    cc.DelayTime:create(TIME7),
    cc.FadeIn:create(0.3),
    cc.DelayTime:create(5.2),
    cc.FadeOut:create(0.8)
  }))
  local npc3 = display.newSprite("opening_comic/moon_box/npc3.png"):scale(1.5):opacity(0):pos(bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.3):addTo(bg, 1)
  local seq3 = transition.sequence({
    cc.FadeIn:create(0.7),
    cc.DelayTime:create(3.9),
    cc.FadeOut:create(1.4)
  })
  local spawn3 = cc.Spawn:create(cc.MoveBy:create(6, cc.p(30, 0)), seq3)
  npc3:runAction(transition.sequence({
    cc.DelayTime:create(TIME7),
    spawn3
  }))
  bg:runAction(transition.sequence({
    cc.DelayTime:create(TIME9),
    cc.FadeOut:create(0.6),
    cc.CallFunc:create(function()
      DYSoundMgr.stopMusic(true)
      DYSoundMgr.playMusic(DY_SND.bgm_theme)
      if self.mCallback then
        self.mCallback()
      end
      self:removeSelf()
    end)
  }))
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  self.mFile = {}
  DYRes.loadFileInfo("opening_comic/moon_box/yueguangbaohe/yueguangbaohe.csb", self.mFile)
  self:layoutUI()
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYRes.unloadFileInfo(self.mFile)
  self.mFile = {}
end

return M

local CLASS_NAME = "OpeningComicScene"
local M = {}
M = class("OpeningComicScene", function()
  return display.newScene("OpeningComicScene")
end)
local openSign = true

function M:ctor()
  self.mBg = display.newSprite("opening_comic/bg_frame.png", display.cx, display.cy):addTo(self)
  local pTip1 = display.newSprite("opening_comic/tip1.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5):opacity(0):addTo(self.mBg)
  pTip1:runAction(transition.sequence({
    cc.FadeIn:create(1.5),
    cc.FadeOut:create(1),
    cc.CallFunc:create(function()
      pTip1:removeFromParent()
    end)
  }))
  local pTip2 = display.newSprite("opening_comic/tip2.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5):opacity(0):addTo(self.mBg)
  pTip2:runAction(transition.sequence({
    cc.DelayTime:create(2),
    cc.FadeIn:create(1.5),
    cc.FadeOut:create(2),
    cc.CallFunc:create(function()
      pTip2:removeFromParent()
      self:comicScene1()
    end)
  }))
  self.mContinueBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/continue.png",
    pressed = "common_ui/continue.png"
  }):onButtonPressed(function(event)
    event.target:setScale(0.8)
    if openSign then
      openSign = false
      self:continueCallBack()
    end
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):hide():align(display.CENTER, self.mBg:getContentSize().width * 0.85, self.mBg:getContentSize().height * 0.05):addTo(self.mBg, 1)
  self.mNextComicId = 0
  self:performWithDelay(function()
    DYSoundMgr.playMusic(DY_SND.sound_comic_bg)
  end, 3.5)
end

function M:continueCallBack()
  if self.mNextComicId == 2 then
    self:comicScene2()
  elseif self.mNextComicId == 3 then
    self:comicScene3()
  elseif self.mNextComicId == 4 then
    self:comicScene4()
  elseif self.mNextComicId == 5 then
    self:comicScene5()
  elseif self.mNextComicId == 6 then
    self:comicScene6()
  elseif self.mNextComicId == 7 then
    self:comicScene7()
  end
  self.mContinueBtn:hide()
end

function M:comicScene1()
  self.comic11 = display.newSprite("opening_comic/comic1/comic11.png", self.mBg:getContentSize().width * 1.5, self.mBg:getContentSize().height * 0.5):scale(1.25):addTo(self.mBg)
  self.comic11:runAction(transition.sequence({
    cc.DelayTime:create(1),
    cc.CallFunc:create(function()
      DYSoundMgr.playEffect(DY_SND.sound_comic11)
    end),
    cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5)),
    cc.DelayTime:create(2),
    cc.Spawn:create(cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.7)), cc.ScaleTo:create(0.5, 1)),
    cc.CallFunc:create(function()
      self:comicScene12()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic1/comic11_tx.plist", "opening_comic/comic1/comic11_tx.png")
  local frames = display.newFrames("comic11_pic%d.png", 1, 4)
  local animation = display.newAnimation(frames, 0.1)
  self.animateComic11 = display.newSprite("opening_comic/comic1/comic11_pic1.png"):pos(self.comic11:getContentSize().width * 0.35, self.comic11:getContentSize().height * 0.6):addTo(self.comic11, 1)
  self.animateComic11:playAnimationForever(animation)
end

function M:comicScene12()
  DYSoundMgr.playEffect(DY_SND.sound_comic12)
  self.animateComic11:stopAllActions()
  self.comic12 = display.newSprite("opening_comic/comic1/comic12.png", self.mBg:getContentSize().width * 1.23, self.mBg:getContentSize().height * 0.25):addTo(self.mBg)
  self.comic12:runAction(transition.sequence({
    cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.23, self.mBg:getContentSize().height * 0.25)),
    cc.DelayTime:create(1.2),
    cc.CallFunc:create(function()
      self:comicScene13()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic1/comic12_tx.plist", "opening_comic/comic1/comic12_tx.png")
  local frames = display.newFrames("comic12_pic%d.png", 1, 4)
  local animation = display.newAnimation(frames, 0.1)
  self.animateComic12 = display.newSprite("opening_comic/comic1/comic12_pic1.png"):pos(self.comic12:getContentSize().width * 0.64, self.comic12:getContentSize().height * 0.5):addTo(self.comic12, 1)
  self.animateComic12:playAnimationForever(animation)
  local pTip = display.newSprite("opening_comic/comic1/comic12_tip.png"):pos(self.comic12:getContentSize().width * 0.145, self.comic12:getContentSize().height * 0.18):opacity(0):addTo(self.comic12, 1)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.FadeIn:create(0.7)
  }))
end

function M:comicScene13()
  DYSoundMgr.playEffect(DY_SND.sound_comic1)
  DYSoundMgr.playEffect(DY_SND.sound_comic13)
  self.animateComic12:stopAllActions()
  self.comic13 = display.newSprite("opening_comic/comic1/comic13.png", self.mBg:getContentSize().width * 1.62, self.mBg:getContentSize().height * 0.25):addTo(self.mBg)
  self.comic13:runAction(transition.sequence({
    cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.62, self.mBg:getContentSize().height * 0.25)),
    cc.DelayTime:create(2)
  }))
  display.addSpriteFrames("opening_comic/comic1/comic13_tx.plist", "opening_comic/comic1/comic13_tx.png")
  local frames = display.newFrames("comic13_pic%d.png", 1, 6)
  local animation = display.newAnimation(frames, 0.1)
  local animate = cc.Animate:create(animation)
  self.animateComic13 = display.newSprite("opening_comic/comic1/comic13_pic1.png"):pos(self.comic13:getContentSize().width * 0.668, self.comic13:getContentSize().height * 0.43):addTo(self.comic13, 1)
  self.animateComic13:runAction(cc.Repeat:create(animate, 3))
  display.addSpriteFrames("opening_comic/comic1/yezi_tx.plist", "opening_comic/comic1/yezi_tx.png")
  local frames1 = display.newFrames("yezi%d.png", 1, 29)
  local animation1 = display.newAnimation(frames1, 0.06)
  self.animateLeaves = display.newSprite("opening_comic/comic1/yezi1.png"):pos(self.comic13:getContentSize().width * 0.5, self.comic13:getContentSize().height * 0.5):addTo(self.comic13, 1)
  self.animateLeaves:playAnimationOnce(animation1, false)
  local pTip = display.newSprite("opening_comic/comic1/comic13_tip.png"):pos(self.comic13:getContentSize().width * 0.285, self.comic13:getContentSize().height * 0.5):opacity(0):addTo(self.comic13, 1)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.FadeIn:create(1)
  }))
  self:runAction(transition.sequence({
    cc.DelayTime:create(2),
    cc.CallFunc:create(function()
      self.mContinueBtn:show()
      self.mNextComicId = 2
      openSign = true
    end)
  }))
  local skipBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/skip.png",
    pressed = "common_ui/skip.png"
  }):onButtonPressed(function(event)
    event.target:setScale(0.8)
    self:toScene()
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):hide():align(display.CENTER, self.mBg:getContentSize().width * 0.85, self.mBg:getContentSize().height * 0.96):addTo(self.mBg, 1)
  skipBtn:runAction(transition.sequence({
    cc.DelayTime:create(2),
    cc.CallFunc:create(function()
      skipBtn:show()
    end)
  }))
end

function M:comicScene2()
  DYSoundMgr.playEffect(DY_SND.sound_comic21)
  self.comic11:removeSelf()
  self.comic12:removeSelf()
  self.comic13:removeSelf()
  self.comic21 = display.newSprite("opening_comic/comic2/comic21.png", self.mBg:getContentSize().width * 1.37, self.mBg:getContentSize().height * 0.7):addTo(self.mBg)
  self.comic21:runAction(transition.sequence({
    cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.37, self.mBg:getContentSize().height * 0.7)),
    cc.DelayTime:create(1.5),
    cc.CallFunc:create(function()
      self:comicScene22()
    end)
  }))
  local pTip = display.newSprite("opening_comic/comic2/comic21_tip.png"):pos(self.comic21:getContentSize().width * 0.67, self.comic21:getContentSize().height * 0.735):opacity(0):addTo(self.comic21, 1)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.FadeIn:create(1)
  }))
end

function M:comicScene22()
  DYSoundMgr.playEffect(DY_SND.sound_comic22)
  DYSoundMgr.playEffect(DY_SND.sound_comic22_door)
  self.comic22 = display.newSprite("opening_comic/comic2/comic22.png", self.mBg:getContentSize().width * 1.68, self.mBg:getContentSize().height * 0.7):addTo(self.mBg)
  self.comic22:runAction(transition.sequence({
    cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.68, self.mBg:getContentSize().height * 0.7)),
    cc.DelayTime:create(1),
    cc.CallFunc:create(function()
      self:comicScene23()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic2/comic22_tx.plist", "opening_comic/comic2/comic22_tx.png")
  local frames = display.newFrames("blink%d.png", 1, 7)
  local animation = display.newAnimation(frames, 0.05)
  self.animateComic22 = display.newSprite("opening_comic/comic2/blink1.png"):pos(self.comic22:getContentSize().width * 0.72, self.comic22:getContentSize().height * 0.43):addTo(self.comic22, 1)
  self.animateComic22:playAnimationForever(animation)
  local pTip = display.newSprite("opening_comic/comic2/comic22_tip.png"):pos(self.comic22:getContentSize().width * 0.21, self.comic22:getContentSize().height * 0.2):opacity(0):addTo(self.comic22, 1)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(1),
    cc.FadeIn:create(0.01)
  }))
end

function M:comicScene23()
  DYSoundMgr.playEffect(DY_SND.sound_comic23)
  self.animateComic22:stopAllActions()
  self.comic23 = display.newSprite("opening_comic/comic2/comic23_pic1.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.25):addTo(self.mBg)
  display.addSpriteFrames("opening_comic/comic2/comic23_tx.plist", "opening_comic/comic2/comic23_tx.png")
  local frames = display.newFrames("comic23_pic%d.png", 1, 2)
  local animation = display.newAnimation(frames, 0.1)
  local animate = cc.Animate:create(animation)
  self.comic23:runAction(cc.Repeat:create(animate, 7))
  self:runAction(transition.sequence({
    cc.DelayTime:create(1.6),
    cc.CallFunc:create(function()
      self.mContinueBtn:show()
      self.mNextComicId = 3
      openSign = true
    end)
  }))
end

function M:comicScene3()
  DYSoundMgr.playEffect(DY_SND.sound_comic3)
  self.comic21:removeSelf()
  self.comic22:removeSelf()
  self.comic23:removeSelf()
  self.comic31 = display.newSprite("opening_comic/comic3/comic31.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 1.5):addTo(self.mBg)
  self.comic31:runAction(transition.sequence({
    cc.MoveTo:create(0.1, cc.p(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5)),
    cc.MoveTo:create(0.2, cc.p(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.75)),
    cc.MoveTo:create(0.1, cc.p(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5))
  }))
  display.addSpriteFrames("opening_comic/comic3/comic31_tx1.plist", "opening_comic/comic3/comic31_tx1.png")
  local frames1 = display.newFrames("chandou%d.png", 1, 2)
  local animation1 = display.newAnimation(frames1, 0.1)
  local animate1 = cc.Animate:create(animation1)
  local animatePic1 = display.newSprite("opening_comic/comic3/chandou1.png"):pos(self.comic31:getContentSize().width * 0.17, self.comic31:getContentSize().height * 0.38):addTo(self.comic31, 1)
  animatePic1:runAction(cc.Repeat:create(animate1, 14))
  display.addSpriteFrames("opening_comic/comic3/comic31_tx2.plist", "opening_comic/comic3/comic31_tx2.png")
  local frames2 = display.newFrames("qingjin%d.png", 1, 2)
  local animation2 = display.newAnimation(frames2, 0.1)
  local animate2 = cc.Animate:create(animation2)
  local animatePic2 = display.newSprite("opening_comic/comic3/qingjin1.png"):pos(self.comic31:getContentSize().width * 0.21, self.comic31:getContentSize().height * 0.31):addTo(self.comic31, 1)
  animatePic2:runAction(cc.Repeat:create(animate2, 14))
  local dt = 0.5
  local fileName
  for i = 1, 4 do
    local pTip = display.newSprite(string.format("opening_comic/comic3/tip" .. i .. ".png")):opacity(0):addTo(self.comic31, 1)
    dt = dt + 0.5
    if i == 1 then
      pTip:setPosition(self.comic31:getContentSize().width * 0.7, self.comic31:getContentSize().height * 0.54)
      fileName = DY_SND.sound_comic31
    elseif i == 2 then
      pTip:setPosition(self.comic31:getContentSize().width * 0.57, self.comic31:getContentSize().height * 0.48)
      fileName = DY_SND.sound_comic31
    elseif i == 3 then
      pTip:setPosition(self.comic31:getContentSize().width * 0.44, self.comic31:getContentSize().height * 0.46)
      fileName = DY_SND.sound_comic31
    else
      pTip:setPosition(self.comic31:getContentSize().width * 0.33, self.comic31:getContentSize().height * 0.58)
      dt = dt + 0.25
      fileName = DY_SND.sound_comic32
    end
    pTip:runAction(transition.sequence({
      cc.DelayTime:create(dt),
      cc.FadeIn:create(0.01),
      cc.CallFunc:create(function()
        DYSoundMgr.playEffect(fileName)
      end)
    }))
  end
  self:runAction(transition.sequence({
    cc.DelayTime:create(3),
    cc.CallFunc:create(function()
      self.mContinueBtn:show()
      self.mNextComicId = 4
      openSign = true
    end)
  }))
end

function M:comicScene4()
  DYSoundMgr.playEffect(DY_SND.sound_comic41)
  self.comic31:removeSelf()
  self.comic41 = display.newSprite("opening_comic/comic4/comic41.png", self.mBg:getContentSize().width * 0.18, self.mBg:getContentSize().height * 1.75):addTo(self.mBg)
  self.comic41:runAction(transition.sequence({
    cc.MoveTo:create(0.2, cc.p(self.mBg:getContentSize().width * 0.18, self.mBg:getContentSize().height * 0.75)),
    cc.DelayTime:create(0.5),
    cc.CallFunc:create(function()
      self:comicScene42()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic4/comic41_tx.plist", "opening_comic/comic4/comic41_tx.png")
  local frames = display.newFrames("comic41_pic%d.png", 1, 5)
  local animation = display.newAnimation(frames, 0.05)
  local animatePic = display.newSprite("opening_comic/comic4/comic41_first.png"):pos(self.comic41:getContentSize().width * 0.52, self.comic41:getContentSize().height * 0.49):addTo(self.comic41, 1)
  animatePic:playAnimationOnce(animation, false, nil, 0.3)
end

function M:comicScene42()
  DYSoundMgr.playEffect(DY_SND.sound_comic41)
  self.comic42 = display.newSprite("opening_comic/comic4/comic42.png", self.mBg:getContentSize().width * 1.378, self.mBg:getContentSize().height * 0.75):addTo(self.mBg)
  self.comic42:runAction(transition.sequence({
    cc.MoveTo:create(0.2, cc.p(self.mBg:getContentSize().width * 0.378, self.mBg:getContentSize().height * 0.75)),
    cc.DelayTime:create(0.5),
    cc.CallFunc:create(function()
      self:comicScene43()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic4/comic42_tx.plist", "opening_comic/comic4/comic42_tx.png")
  local frames = display.newFrames("comic42_pic%d.png", 1, 5)
  local animation = display.newAnimation(frames, 0.05)
  local animatePic = display.newSprite("opening_comic/comic4/comic42_first.png"):pos(self.comic42:getContentSize().width * 0.54, self.comic42:getContentSize().height * 0.568):addTo(self.comic42, 1)
  animatePic:playAnimationOnce(animation, false, nil, 0.3)
end

function M:comicScene43()
  DYSoundMgr.playEffect(DY_SND.sound_comic41)
  self.comic43 = display.newSprite("opening_comic/comic4/comic43.png", -self.mBg:getContentSize().width * 0.82, self.mBg:getContentSize().height * 0.56):addTo(self.mBg)
  self.comic43:runAction(transition.sequence({
    cc.MoveTo:create(0.2, cc.p(self.mBg:getContentSize().width * 0.18, self.mBg:getContentSize().height * 0.56)),
    cc.DelayTime:create(0.5),
    cc.CallFunc:create(function()
      self:comicScene44()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic4/comic43_tx.plist", "opening_comic/comic4/comic43_tx.png")
  local frames = display.newFrames("comic43_pic%d.png", 1, 6)
  local animation = display.newAnimation(frames, 0.05)
  local animatePic = display.newSprite("opening_comic/comic4/comic43_first.png"):pos(self.comic43:getContentSize().width * 0.51, self.comic43:getContentSize().height * 0.33):addTo(self.comic43, 1)
  animatePic:playAnimationOnce(animation, false, nil, 0.3)
end

function M:comicScene44()
  DYSoundMgr.playEffect(DY_SND.sound_comic41)
  self.comic44 = display.newSprite("opening_comic/comic4/comic44.png", self.mBg:getContentSize().width * 0.378, -self.mBg:getContentSize().height * 0.44):addTo(self.mBg)
  self.comic44:runAction(transition.sequence({
    cc.MoveTo:create(0.2, cc.p(self.mBg:getContentSize().width * 0.378, self.mBg:getContentSize().height * 0.56)),
    cc.DelayTime:create(0.5),
    cc.CallFunc:create(function()
      self:comicScene49()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic4/comic44_tx.plist", "opening_comic/comic4/comic44_tx.png")
  local frames = display.newFrames("comic44_pic%d.png", 1, 6)
  local animation = display.newAnimation(frames, 0.05)
  local animatePic = display.newSprite("opening_comic/comic4/comic44_first.png"):pos(self.comic44:getContentSize().width * 0.494, self.comic44:getContentSize().height * 0.4):addTo(self.comic44, 1)
  animatePic:playAnimationOnce(animation, false, nil, 0.3)
end

function M:comicScene45()
  DYSoundMgr.playEffect(DY_SND.sound_comic46)
  self.comic41:runAction(cc.MoveBy:create(0.55, cc.p(-self.mBg:getContentSize().width * 0.48, 0)))
  self.comic42:runAction(cc.MoveBy:create(0.55, cc.p(-self.mBg:getContentSize().width * 0.48, 0)))
  self.comic43:runAction(cc.MoveBy:create(0.55, cc.p(-self.mBg:getContentSize().width * 0.48, 0)))
  self.comic44:runAction(cc.MoveBy:create(0.55, cc.p(-self.mBg:getContentSize().width * 0.48, 0)))
  self.comic49:runAction(cc.MoveBy:create(0.55, cc.p(-self.mBg:getContentSize().width * 0.48, 0)))
  self.comic410:runAction(cc.MoveBy:create(0.5, cc.p(-self.mBg:getContentSize().width * 0.4, 0)))
  self.comic411:runAction(cc.MoveBy:create(0.5, cc.p(-self.mBg:getContentSize().width * 0.4, 0)))
  self.comic412:runAction(cc.MoveBy:create(0.5, cc.p(-self.mBg:getContentSize().width * 0.4, 0)))
  self.comic45 = display.newSprite("opening_comic/comic4/comic45.png", self.mBg:getContentSize().width * 1.72, self.mBg:getContentSize().height * 0.83):addTo(self.mBg)
  self.comic45:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.MoveTo:create(0.2, cc.p(self.mBg:getContentSize().width * 0.72, self.mBg:getContentSize().height * 0.83)),
    cc.DelayTime:create(0.1),
    cc.CallFunc:create(function()
      self:comicScene46()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic4/comic45_tx.plist", "opening_comic/comic4/comic45_tx.png")
  local frames = display.newFrames("comic45_pic%d.png", 1, 3)
  local animation = display.newAnimation(frames, 0.2)
  local animate = cc.Animate:create(animation)
  local animatePic = display.newSprite("opening_comic/comic4/comic45.png"):pos(self.comic45:getContentSize().width * 0.5, self.comic45:getContentSize().height * 0.5):addTo(self.comic45, 1)
  animatePic:runAction(cc.Repeat:create(animate, 3))
  local pTip = display.newSprite("opening_comic/comic4/comic45_tip.png"):pos(self.comic45:getContentSize().width * 0.153, self.comic45:getContentSize().height * 0.69):opacity(0):addTo(self.comic45, 2)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.FadeIn:create(1)
  }))
end

function M:comicScene46()
  DYSoundMgr.playEffect(DY_SND.sound_comic47)
  self.comic46 = display.newSprite("opening_comic/comic4/comic46.png", self.mBg:getContentSize().width * 1.72, self.mBg:getContentSize().height * 0.6):addTo(self.mBg)
  self.comic46:runAction(transition.sequence({
    cc.MoveTo:create(0.2, cc.p(self.mBg:getContentSize().width * 0.72, self.mBg:getContentSize().height * 0.6)),
    cc.DelayTime:create(0.1),
    cc.CallFunc:create(function()
      self:comicScene47()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic4/comic46_tx.plist", "opening_comic/comic4/comic46_tx.png")
  local frames = display.newFrames("comic46_pic%d.png", 1, 3)
  local animation = display.newAnimation(frames, 0.2)
  local animate = cc.Animate:create(animation)
  local animatePic = display.newSprite("opening_comic/comic4/comic46_pic1.png"):pos(self.comic46:getContentSize().width * 0.5, self.comic46:getContentSize().height * 0.5):addTo(self.comic46, 1)
  animatePic:runAction(cc.Repeat:create(animate, 3))
  local pTip = display.newSprite("opening_comic/comic4/comic46_tip.png"):pos(self.comic46:getContentSize().width * 0.154, self.comic46:getContentSize().height * 0.33):opacity(0):addTo(self.comic46, 2)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.FadeIn:create(1)
  }))
end

function M:comicScene47()
  DYSoundMgr.playEffect(DY_SND.sound_comic46)
  self.comic47 = display.newSprite("opening_comic/comic4/comic47.png", self.mBg:getContentSize().width * 1.72, self.mBg:getContentSize().height * 0.38):addTo(self.mBg)
  self.comic47:runAction(transition.sequence({
    cc.MoveTo:create(0.2, cc.p(self.mBg:getContentSize().width * 0.72, self.mBg:getContentSize().height * 0.38)),
    cc.DelayTime:create(0.1),
    cc.CallFunc:create(function()
      self:comicScene48()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic4/comic47_tx.plist", "opening_comic/comic4/comic47_tx.png")
  local frames = display.newFrames("comic47_pic%d.png", 1, 3)
  local animation = display.newAnimation(frames, 0.2)
  local animate = cc.Animate:create(animation)
  local animatePic = display.newSprite("opening_comic/comic4/comic47.png"):pos(self.comic47:getContentSize().width * 0.5, self.comic47:getContentSize().height * 0.5):addTo(self.comic47, 1)
  animatePic:runAction(cc.Repeat:create(animate, 3))
  local pTip = display.newSprite("opening_comic/comic4/comic47_tip.png"):pos(self.comic47:getContentSize().width * 0.75, self.comic47:getContentSize().height * 0.5):opacity(0):addTo(self.comic47, 2)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.FadeIn:create(1)
  }))
end

function M:comicScene48()
  DYSoundMgr.playEffect(DY_SND.sound_comic48)
  self.comic48 = display.newSprite("opening_comic/comic4/comic48.png", self.mBg:getContentSize().width * 1.72, self.mBg:getContentSize().height * 0.17):addTo(self.mBg)
  self.comic48:runAction(cc.MoveTo:create(0.2, cc.p(self.mBg:getContentSize().width * 0.72, self.mBg:getContentSize().height * 0.17)))
  display.addSpriteFrames("opening_comic/comic4/comic48_tx.plist", "opening_comic/comic4/comic48_tx.png")
  local frames = display.newFrames("comic48_pic%d.png", 1, 3)
  local animation = display.newAnimation(frames, 0.2)
  local animate = cc.Animate:create(animation)
  local animatePic = display.newSprite("opening_comic/comic4/comic48.png"):pos(self.comic48:getContentSize().width * 0.5, self.comic48:getContentSize().height * 0.5):addTo(self.comic48, 1)
  animatePic:runAction(cc.Repeat:create(animate, 3))
  local pTip = display.newSprite("opening_comic/comic4/comic48_tip.png"):pos(self.comic48:getContentSize().width * 0.158, self.comic48:getContentSize().height * 0.34):opacity(0):addTo(self.comic48, 2)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.FadeIn:create(1)
  }))
  self:runAction(transition.sequence({
    cc.DelayTime:create(1.6),
    cc.CallFunc:create(function()
      self.mContinueBtn:show()
      self.mNextComicId = 5
      openSign = true
    end)
  }))
end

function M:comicScene49()
  DYSoundMgr.playEffect(DY_SND.sound_comic42)
  self.comic49 = display.newSprite("opening_comic/comic4/comic49.png", self.mBg:getContentSize().width * 0.28, -self.mBg:getContentSize().height * 0.78):addTo(self.mBg)
  self.comic49:runAction(transition.sequence({
    cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.28, self.mBg:getContentSize().height * 0.22)),
    cc.DelayTime:create(1.5),
    cc.CallFunc:create(function()
      self:comicScene410()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic4/comic49_tx.plist", "opening_comic/comic4/comic49_tx.png")
  local frames = display.newFrames("comic49_pic%d.png", 1, 7)
  local animation = display.newAnimation(frames, 0.05)
  local animatePic = display.newSprite("opening_comic/comic4/comic49.png"):pos(self.comic49:getContentSize().width * 0.5, self.comic49:getContentSize().height * 0.5):addTo(self.comic49, 1)
  animatePic:playAnimationOnce(animation, false, nil, 0.5)
  local pTip = display.newSprite("opening_comic/comic4/comic49_tip.png"):pos(self.comic49:getContentSize().width * 0.55, self.comic49:getContentSize().height * 0.7):opacity(0):addTo(self.comic49, 1)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.FadeIn:create(1)
  }))
end

function M:comicScene410()
  DYSoundMgr.playEffect(DY_SND.sound_comic43)
  self.comic410 = display.newSprite("opening_comic/comic4/comic410.png", self.mBg:getContentSize().width * 0.6, self.mBg:getContentSize().height * 1.75):addTo(self.mBg)
  self.comic410:runAction(transition.sequence({
    cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.6, self.mBg:getContentSize().height * 0.75)),
    cc.DelayTime:create(1),
    cc.CallFunc:create(function()
      self:comicScene411()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic4/comic410_tx.plist", "opening_comic/comic4/comic410_tx.png")
  local frames = display.newFrames("comic410_pic%d.png", 1, 2)
  local animation = display.newAnimation(frames, 0.05)
  local animate = cc.Animate:create(animation)
  local animatePic = display.newSprite("opening_comic/comic4/comic410.png"):pos(self.comic410:getContentSize().width * 0.5, self.comic410:getContentSize().height * 0.5):addTo(self.comic410, 1)
  animatePic:runAction(cc.Repeat:create(animate, 8))
  local pTip = display.newSprite("opening_comic/comic4/comic410_tip.png"):pos(self.comic410:getContentSize().width * 0.77, self.comic410:getContentSize().height * 0.17):opacity(0):addTo(self.comic410, 2)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.FadeIn:create(1)
  }))
end

function M:comicScene411()
  DYSoundMgr.playEffect(DY_SND.sound_comic44)
  self.comic411 = display.newSprite("opening_comic/comic4/comic411.png", self.mBg:getContentSize().width * 0.805, self.mBg:getContentSize().height * 1.75):addTo(self.mBg)
  self.comic411:runAction(transition.sequence({
    cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.805, self.mBg:getContentSize().height * 0.75)),
    cc.DelayTime:create(1),
    cc.CallFunc:create(function()
      self:comicScene412()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic4/comic411_tx.plist", "opening_comic/comic4/comic411_tx.png")
  local frames = display.newFrames("comic411_pic%d.png", 1, 10)
  local animation = display.newAnimation(frames, 0.05)
  local animate = cc.Animate:create(animation)
  local animatePic = display.newSprite("opening_comic/comic4/comic411_pic1.png"):pos(self.comic411:getContentSize().width * 0.48, self.comic411:getContentSize().height * 0.24):addTo(self.comic411, 1)
  animatePic:runAction(cc.Repeat:create(animate, 2))
  local pTip = display.newSprite("opening_comic/comic4/comic411_tip.png"):pos(self.comic411:getContentSize().width * 0.55, self.comic411:getContentSize().height * 0.7):opacity(0):addTo(self.comic411, 2)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.FadeIn:create(1)
  }))
end

function M:comicScene412()
  DYSoundMgr.playEffect(DY_SND.sound_comic45)
  self.comic412 = display.newSprite("opening_comic/comic4/comic412.png", self.mBg:getContentSize().width * 0.705, -self.mBg:getContentSize().height * 1.68):addTo(self.mBg)
  self.comic412:runAction(transition.sequence({
    cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.705, self.mBg:getContentSize().height * 0.325)),
    cc.DelayTime:create(1.5),
    cc.CallFunc:create(function()
      self:comicScene45()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic4/comic412_tx.plist", "opening_comic/comic4/comic412_tx.png")
  local frames = display.newFrames("comic412_pic%d.png", 1, 2)
  local animation = display.newAnimation(frames, 0.05)
  local animate = cc.Animate:create(animation)
  local animatePic = display.newSprite("opening_comic/comic4/comic412.png"):pos(self.comic412:getContentSize().width * 0.5, self.comic412:getContentSize().height * 0.5):addTo(self.comic412, 1)
  animatePic:runAction(cc.Repeat:create(animate, 13))
  local pTip = display.newSprite("opening_comic/comic4/comic412_tip.png"):pos(self.comic412:getContentSize().width * 0.28, self.comic412:getContentSize().height * 0.36):opacity(0):addTo(self.comic412, 2)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(1.5),
    cc.FadeIn:create(1)
  }))
end

function M:comicScene5()
  DYSoundMgr.playEffect(DY_SND.sound_comic5)
  self.comic41:removeSelf()
  self.comic42:removeSelf()
  self.comic43:removeSelf()
  self.comic44:removeSelf()
  self.comic45:removeSelf()
  self.comic46:removeSelf()
  self.comic47:removeSelf()
  self.comic48:removeSelf()
  self.comic49:removeSelf()
  self.comic410:removeSelf()
  self.comic411:removeSelf()
  self.comic412:removeSelf()
  self.comic5 = display.newSprite("opening_comic/comic5/comic51.png", self.mBg:getContentSize().width * 1.5, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  local action = transition.sequence({
    cc.ScaleTo:create(0.05, 1.01),
    cc.ScaleTo:create(0.04, 0.99),
    cc.ScaleTo:create(0.06, 1.01),
    cc.ScaleTo:create(0.05, 1)
  })
  display.addSpriteFrames("opening_comic/comic5/comic51_tx.plist", "opening_comic/comic5/comic51_tx.png")
  local frames = display.newFrames("comic51_pic%d.png", 1, 2)
  local animation = display.newAnimation(frames, 0.1)
  local animate = cc.Animate:create(animation)
  local spawn = cc.Spawn:create(action, animate)
  self.comic5:runAction(transition.sequence({
    cc.MoveTo:create(0.5, cc.p(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5)),
    cc.Repeat:create(spawn, 12)
  }))
  self:runAction(transition.sequence({
    cc.DelayTime:create(2.6),
    cc.CallFunc:create(function()
      self.mContinueBtn:show()
      self.mNextComicId = 6
      openSign = true
    end)
  }))
end

function M:comicScene6()
  DYSoundMgr.playEffect(DY_SND.sound_comic6)
  DYSoundMgr.playEffect(DY_SND.sound_comic61)
  self.comic5:removeSelf()
  self.comic61 = display.newSprite("opening_comic/comic6/comic61.png", -self.mBg:getContentSize().width * 0.8, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  self.comic61:runAction(transition.sequence({
    cc.MoveTo:create(0.2, cc.p(self.mBg:getContentSize().width * 0.2, self.mBg:getContentSize().height * 0.5)),
    cc.DelayTime:create(2),
    cc.CallFunc:create(function()
      self:comicScene62()
    end)
  }))
  display.addSpriteFrames("animation/jiangli.plist", "animation/jiangli.png")
  local frames = display.newFrames("jiangli%d.png", 1, 15)
  local animation = display.newAnimation(frames, 0.1)
  local animatePic = display.newSprite():pos(self.comic61:getContentSize().width * 0.5, self.comic61:getContentSize().height * 0.5):addTo(self.comic61, 1)
  animatePic:playAnimationOnce(animation, false, nil, 0.5)
  local pTip = display.newSprite("opening_comic/comic6/comic61_tip.png"):pos(self.comic61:getContentSize().width * 0.5, self.comic61:getContentSize().height * 0.5):opacity(0):addTo(self.comic61, 2)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(1),
    cc.FadeIn:create(1)
  }))
end

function M:comicScene62()
  DYSoundMgr.playEffect(DY_SND.sound_comic62)
  DYSoundMgr.playEffect(DY_SND.sound_comic62_haojiao)
  self.comic62 = display.newSprite("opening_comic/comic6/comic62.png", self.mBg:getContentSize().width * 0.32, self.mBg:getContentSize().height * 1.71):addTo(self.mBg)
  self.comic62:runAction(transition.sequence({
    cc.MoveTo:create(0.1, cc.p(self.mBg:getContentSize().width * 0.32, self.mBg:getContentSize().height * 0.71)),
    cc.DelayTime:create(2),
    cc.CallFunc:create(function()
      self:comicScene63()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic6/comic62_tx.plist", "opening_comic/comic6/comic62_tx.png")
  local frames = display.newFrames("comic62_pic%d.png", 1, 2)
  local animation = display.newAnimation(frames, 0.1)
  local animate = cc.Animate:create(animation)
  local animatePic = display.newSprite("opening_comic/comic6/comic62.png"):pos(self.comic62:getContentSize().width * 0.5, self.comic62:getContentSize().height * 0.5):addTo(self.comic62, 1)
  animatePic:runAction(cc.Repeat:create(animate, 10))
end

function M:comicScene63()
  DYSoundMgr.playEffect(DY_SND.sound_comic63)
  self.comic63 = display.newSprite("opening_comic/comic6/comic63.png", self.mBg:getContentSize().width * 1.41, self.mBg:getContentSize().height * 0.48):addTo(self.mBg)
  self.comic63:runAction(transition.sequence({
    cc.MoveTo:create(0.3, cc.p(self.mBg:getContentSize().width * 0.41, self.mBg:getContentSize().height * 0.48)),
    cc.DelayTime:create(2),
    cc.CallFunc:create(function()
      self:comicScene64()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic6/comic63_tx.plist", "opening_comic/comic6/comic63_tx.png")
  local frames = display.newFrames("comic63_pic%d.png", 1, 3)
  local animation = display.newAnimation(frames, 0.1)
  local animate = cc.Animate:create(animation)
  local animatePic = display.newSprite("opening_comic/comic6/comic63.png"):pos(self.comic63:getContentSize().width * 0.5, self.comic63:getContentSize().height * 0.5):addTo(self.comic63, 1)
  animatePic:runAction(cc.Repeat:create(animate, 7))
  local pTip = display.newSprite("opening_comic/comic6/comic63_tip.png"):pos(self.comic63:getContentSize().width * 0.84, self.comic63:getContentSize().height * 0.898):opacity(0):addTo(self.comic63, 2)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(1),
    cc.FadeIn:create(0.1)
  }))
end

function M:comicScene64()
  DYSoundMgr.playEffect(DY_SND.sound_comic64)
  DYSoundMgr.playEffect(DY_SND.sound_comic64_sha)
  self.comic64 = display.newSprite("opening_comic/comic6/comic64.png", self.mBg:getContentSize().width * 0.75, self.mBg:getContentSize().height * 1.69):addTo(self.mBg)
  local action = transition.sequence({
    cc.ScaleTo:create(0.05, 1.03),
    cc.ScaleTo:create(0.04, 0.97),
    cc.ScaleTo:create(0.06, 1.03),
    cc.ScaleTo:create(0.05, 1)
  })
  self.comic64:runAction(transition.sequence({
    cc.MoveTo:create(0.3, cc.p(self.mBg:getContentSize().width * 0.75, self.mBg:getContentSize().height * 0.69)),
    cc.Repeat:create(action, 10),
    cc.CallFunc:create(function()
      self:comicScene65()
    end)
  }))
  display.addSpriteFrames("opening_comic/comic6/comic64_tx.plist", "opening_comic/comic6/comic64_tx.png")
  local frames = display.newFrames("comic64_pic%d.png", 1, 2)
  local animation = display.newAnimation(frames, 0.1)
  local animate = cc.Animate:create(animation)
  local animatePic = display.newSprite("opening_comic/comic6/comic64.png"):pos(self.comic64:getContentSize().width * 0.5, self.comic64:getContentSize().height * 0.5):addTo(self.comic64, 1)
  animatePic:runAction(cc.Repeat:create(animate, 10))
  local pTip = display.newSprite("opening_comic/comic6/comic64_tip.png"):pos(self.comic64:getContentSize().width * 0.6, self.comic64:getContentSize().height * 0.6):opacity(0):addTo(self.comic64, 2)
  pTip:runAction(transition.sequence({
    cc.DelayTime:create(0.5),
    cc.FadeIn:create(1)
  }))
end

function M:comicScene65()
  DYSoundMgr.playEffect(DY_SND.sound_comic65)
  self.comic65 = display.newSprite("opening_comic/comic6/comic65.png", self.mBg:getContentSize().width * 1.665, self.mBg:getContentSize().height * 0.295):addTo(self.mBg)
  self.comic65:runAction(cc.MoveTo:create(0.3, cc.p(self.mBg:getContentSize().width * 0.665, self.mBg:getContentSize().height * 0.295)))
  self:runAction(transition.sequence({
    cc.DelayTime:create(1.6),
    cc.CallFunc:create(function()
      self.mContinueBtn:show()
      self.mNextComicId = 7
      openSign = true
    end)
  }))
end

function M:comicScene7()
  DYSoundMgr.playEffect(DY_SND.sound_comic7)
  self.comic61:removeSelf()
  self.comic62:removeSelf()
  self.comic63:removeSelf()
  self.comic64:removeSelf()
  self.comic65:removeSelf()
  local comic7 = display.newSprite("opening_comic/comic7/comic71.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5):scale(0):addTo(self.mBg)
  local spawn = cc.Spawn:create(cc.ScaleTo:create(1.2, 0.5), cc.RotateBy:create(1.2, 2160))
  comic7:runAction(transition.sequence({
    spawn,
    cc.DelayTime:create(3),
    cc.CallFunc:create(function()
      self:toScene()
    end)
  }))
end

function M:toScene()
  DYSoundMgr.stopMusic(true)
  CloudData.OPENNING_COMIC_PLAYED = 1
  DYStat.setValueBool(DY_KEY.kSkipOpenComic, true)
  GameManager.STAGE_ID = 10000
  GameManager.STAGE_NUM = 0
  GameManager.MODE = 0
  display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE", "NORMAL"))
end

function M:onEnter()
end

function M:onExit()
end

return M

--
--描述：播放开场漫画
--

local AlertConnection    = import("customs.AlertConnection")

local OpeningComicScene = {}
OpeningComicScene = class("OpeningComicScene",function()
    return display.newScene("OpeningComicScene")
end)

local openSign = true
function OpeningComicScene:ctor()
    --背景图
    self.bg_ = display.newSprite("opening_comic/bg_frame.png",display.cx,display.cy)
        :addTo(self)

    --标签："公元**年"
    local pTip1 =  display.newSprite("opening_comic/tip1.png",self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
        :opacity(0)
        :addTo(self.bg_)
    pTip1:runAction(transition.sequence({cc.FadeIn:create(1.5),cc.FadeOut:create(1.0),cc.CallFunc:create(function()
        pTip1:removeFromParent()
    end)}))

    --标签："**大战前夕"
    local pTip2 =  display.newSprite("opening_comic/tip2.png",self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
        :opacity(0)
        :addTo(self.bg_)
    pTip2:runAction(transition.sequence({cc.DelayTime:create(2.0),
        cc.FadeIn:create(1.5),cc.FadeOut:create(2.0),cc.CallFunc:create(function()
            pTip2:removeFromParent()
            self:comicScene1_()
        end)}))

    --"继续"按钮
    self.continueBtn_ = cc.ui.UIPushButton.new({normal = "common_ui/continue.png",pressed = "common_ui/continue.png"})
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
            if(openSign) then
                openSign = false
                self:continueCallBack_()
            end
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        -- :onButtonClicked(function()
        --     self:continueCallBack_()
        -- end)
        :hide()
        :align(display.CENTER,self.bg_:getContentSize().width * 0.85,self.bg_:getContentSize().height * 0.05)
        :addTo(self.bg_,1)

    --下一张漫画的编号（用于“继续”操作）
    self.nextComicId_ = 0

    --播放背景音乐
    if GameManager.MUSIC_SWITCH_ON then
        self:performWithDelay(function()
            audio.playMusic(string.format("sounds/comic/sound_comic_bg.%s",GameManager.POSTFIX))
        end, 3.5)
    end

    self:addAndroidReturnButton_()
end

--点击“继续”，前往下一张漫画
function OpeningComicScene:continueCallBack_()
    if self.nextComicId_ == 2 then
        self:comicScene2_()
    elseif self.nextComicId_ == 3 then
        self:comicScene3_()
    elseif self.nextComicId_ == 4 then
        self:comicScene4_()
    elseif self.nextComicId_ == 5 then
        self:comicScene5_()
    elseif self.nextComicId_ == 6 then
        self:comicScene6_()
    elseif self.nextComicId_ == 7 then
        self:comicScene7_()
    end
    --隐藏"继续"按钮
    self.continueBtn_:hide()
end

--第一张漫画
function OpeningComicScene:comicScene1_()
    --漫画一的第一张碎图
    self.comic11_ = display.newSprite("opening_comic/comic1/comic11.png",
        self.bg_:getContentSize().width * 1.5,self.bg_:getContentSize().height * 0.5)
        :scale(1.25)
        :addTo(self.bg_)
    self.comic11_:runAction(transition.sequence({cc.DelayTime:create(1.0),
        cc.CallFunc:create(function()
            if GameManager.SOUND_SWITCH_ON then
                audio.playSound(string.format("sounds/comic/sound_comic11.%s",GameManager.POSTFIX))
            end
        end),
        cc.MoveTo:create(0.5,cc.p(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)),
        cc.DelayTime:create(2.0),
        cc.Spawn:create(cc.MoveTo:create(0.5,cc.p(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.7)),
            cc.ScaleTo:create(0.5,1.0)),
        cc.CallFunc:create(function()
            self:comicScene12_()
        end)
    }))

    --创建动画
    display.addSpriteFrames("opening_comic/comic1/comic11_tx.plist","opening_comic/comic1/comic11_tx.png")
    local frames = display.newFrames("comic11_pic%d.png",1,4)
    local animation = display.newAnimation(frames, 0.1)
    self.animateComic11_ = display.newSprite("opening_comic/comic1/comic11_pic1.png")
        :pos(self.comic11_:getContentSize().width * 0.35,self.comic11_:getContentSize().height * 0.6)
        :addTo(self.comic11_,1)
    self.animateComic11_:playAnimationForever(animation)
end
function OpeningComicScene:comicScene12_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic12.%s",GameManager.POSTFIX))
    end

    --停止碎图1中唐僧的动画
    self.animateComic11_:stopAllActions()

    --漫画一的第二张碎图
    self.comic12_ = display.newSprite("opening_comic/comic1/comic12.png",
        self.bg_:getContentSize().width * 1.23,self.bg_:getContentSize().height * 0.25)
        :addTo(self.bg_)
    self.comic12_:runAction(transition.sequence({cc.MoveTo:create(0.5,cc.p(self.bg_:getContentSize().width * 0.23,self.bg_:getContentSize().height * 0.25)),
        cc.DelayTime:create(1.2),
        cc.CallFunc:create(function()
            self:comicScene13_()
        end)
    }))
    --创建动画
    display.addSpriteFrames("opening_comic/comic1/comic12_tx.plist","opening_comic/comic1/comic12_tx.png")
    local frames = display.newFrames("comic12_pic%d.png",1,4)
    local animation = display.newAnimation(frames, 0.1)
    self.animateComic12_ = display.newSprite("opening_comic/comic1/comic12_pic1.png")
        :pos(self.comic12_:getContentSize().width * 0.64,self.comic12_:getContentSize().height * 0.5)
        :addTo(self.comic12_,1)
    self.animateComic12_:playAnimationForever(animation)

    --tip:"哼"
    local pTip = display.newSprite("opening_comic/comic1/comic12_tip.png")
        :pos(self.comic12_:getContentSize().width * 0.145,self.comic12_:getContentSize().height * 0.18)
        :opacity(0)
        :addTo(self.comic12_,1)
    pTip:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.FadeIn:create(0.7)}))
end
function OpeningComicScene:comicScene13_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic1.%s",GameManager.POSTFIX))
        audio.playSound(string.format("sounds/comic/sound_comic13.%s",GameManager.POSTFIX))
    end

    --停止碎图1中唐僧的动画
    self.animateComic12_:stopAllActions()

    --漫画一的第二张碎图
    self.comic13_ = display.newSprite("opening_comic/comic1/comic13.png",
        self.bg_:getContentSize().width * 1.62,self.bg_:getContentSize().height * 0.25)
        :addTo(self.bg_)
    self.comic13_:runAction(transition.sequence({cc.MoveTo:create(0.5,cc.p(self.bg_:getContentSize().width * 0.62,self.bg_:getContentSize().height * 0.25)),
        cc.DelayTime:create(2.0)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic1/comic13_tx.plist","opening_comic/comic1/comic13_tx.png")
    local frames = display.newFrames("comic13_pic%d.png",1,6)
    local animation = display.newAnimation(frames, 0.1)
    local animate = cc.Animate:create(animation)
    self.animateComic13_ = display.newSprite("opening_comic/comic1/comic13_pic1.png")
        :pos(self.comic13_:getContentSize().width * 0.668,self.comic13_:getContentSize().height * 0.43)
        :addTo(self.comic13_,1)
    self.animateComic13_:runAction(cc.Repeat:create(animate,3))
    --创建树叶动画
    display.addSpriteFrames("opening_comic/comic1/yezi_tx.plist","opening_comic/comic1/yezi_tx.png")
    local frames1 = display.newFrames("yezi%d.png",1,29)
    local animation1 = display.newAnimation(frames1, 0.06)
    self.animateLeaves_ = display.newSprite("opening_comic/comic1/yezi1.png")
        :pos(self.comic13_:getContentSize().width * 0.5,self.comic13_:getContentSize().height * 0.5)
        :addTo(self.comic13_,1)
    self.animateLeaves_:playAnimationOnce(animation1,false)  -- 可能是这个地方出错

    --tip:"终于,要决战了吗..."
    local pTip = display.newSprite("opening_comic/comic1/comic13_tip.png")
        :pos(self.comic13_:getContentSize().width * 0.285,self.comic13_:getContentSize().height * 0.5)
        :opacity(0)
        :addTo(self.comic13_,1)
    pTip:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.FadeIn:create(1.0)}))

    --"继续"按钮出现
    self:runAction(transition.sequence({cc.DelayTime:create(2.0),cc.CallFunc:create(function()
        self.continueBtn_:show()
        self.nextComicId_ = 2
        openSign = true
    end)}))

    --"跳过"按钮
    local skipBtn = cc.ui.UIPushButton.new({normal = "common_ui/skip.png",pressed = "common_ui/skip.png"})
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
            self:toStage0_()
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        -- :onButtonClicked(function()
        --     self:toStage0_()
        -- end)
        :hide()
        :align(display.CENTER,self.bg_:getContentSize().width * 0.85,self.bg_:getContentSize().height * 0.96)
        :addTo(self.bg_,1)
    skipBtn:runAction(transition.sequence({cc.DelayTime:create(2.0),cc.CallFunc:create(function()
        skipBtn:show()
    end)}))
end

--第二张漫画
function OpeningComicScene:comicScene2_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic21.%s",GameManager.POSTFIX))
    end

    --移除上一漫画的文件
    self.comic11_:removeSelf()
    self.comic12_:removeSelf()
    self.comic13_:removeSelf()
    	display.removeUnusedSpriteFrames()
    --打印纹理缓存
    --local info1 = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --print(info1)

    --加载漫画二的第一张碎图
    self.comic21_ = display.newSprite("opening_comic/comic2/comic21.png",
        self.bg_:getContentSize().width * 1.37,self.bg_:getContentSize().height * 0.7)
        :addTo(self.bg_)
    self.comic21_:runAction(transition.sequence({cc.MoveTo:create(0.5,cc.p(self.bg_:getContentSize().width * 0.37,self.bg_:getContentSize().height * 0.7)),
        cc.DelayTime:create(1.5),
        cc.CallFunc:create(function()
            self:comicScene22_()
        end)}))

    --tip:"谈谈心,打打气..."
    local pTip = display.newSprite("opening_comic/comic2/comic21_tip.png")
        :pos(self.comic21_:getContentSize().width * 0.67,self.comic21_:getContentSize().height * 0.735)
        :opacity(0)
        :addTo(self.comic21_,1)
    pTip:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.FadeIn:create(1.0)}))
end
function OpeningComicScene:comicScene22_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic22.%s",GameManager.POSTFIX))
        audio.playSound(string.format("sounds/comic/sound_comic22_door.%s",GameManager.POSTFIX))
    end

    --漫画二的第二张碎图
    self.comic22_ = display.newSprite("opening_comic/comic2/comic22.png",
        self.bg_:getContentSize().width * 1.68,self.bg_:getContentSize().height * 0.7)
        :addTo(self.bg_)
    self.comic22_:runAction(transition.sequence({cc.MoveTo:create(0.5,cc.p(self.bg_:getContentSize().width * 0.68,self.bg_:getContentSize().height * 0.7)),
        cc.DelayTime:create(1.0),
        cc.CallFunc:create(function()
            self:comicScene23_()
        end)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic2/comic22_tx.plist","opening_comic/comic2/comic22_tx.png")
    local frames = display.newFrames("blink%d.png",1,7)
    local animation = display.newAnimation(frames, 0.05)
    self.animateComic22_ = display.newSprite("opening_comic/comic2/blink1.png")
        :pos(self.comic22_:getContentSize().width * 0.72,self.comic22_:getContentSize().height * 0.43)
        :addTo(self.comic22_,1)
    self.animateComic22_:playAnimationForever(animation)

    --tip:"我回来了..."
    local pTip = display.newSprite("opening_comic/comic2/comic22_tip.png")
        :pos(self.comic22_:getContentSize().width * 0.21,self.comic22_:getContentSize().height * 0.20)
        :opacity(0)
        :addTo(self.comic22_,1)
    pTip:runAction(transition.sequence({cc.DelayTime:create(1.0),
        cc.FadeIn:create(0.01)}))
end
function OpeningComicScene:comicScene23_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic23.%s",GameManager.POSTFIX))
    end

    self.animateComic22_:stopAllActions()

    --漫画二的第三张碎图
    self.comic23_ = display.newSprite("opening_comic/comic2/comic23_pic1.png",
        self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.25)
        :addTo(self.bg_)
    --创建动画
    display.addSpriteFrames("opening_comic/comic2/comic23_tx.plist","opening_comic/comic2/comic23_tx.png")
    local frames = display.newFrames("comic23_pic%d.png",1,2)
    local animation = display.newAnimation(frames, 0.1)
    local animate = cc.Animate:create(animation)
    self.comic23_:runAction(cc.Repeat:create(animate,7))

    --"继续"按钮出现
    self:runAction(transition.sequence({cc.DelayTime:create(1.6),cc.CallFunc:create(function()
        self.continueBtn_:show()
        self.nextComicId_ = 3
        openSign = true
    end)}))
end

--第三张漫画
function OpeningComicScene:comicScene3_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic3.%s",GameManager.POSTFIX))
    end

    --移除上一漫画的文件
    self.comic21_:removeSelf()
    self.comic22_:removeSelf()
    self.comic23_:removeSelf()
    --	display.removeUnusedSpriteFrames()
    --打印纹理缓存
    --local info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --print(info)

    --加载漫画三
    self.comic31_ = display.newSprite("opening_comic/comic3/comic31.png",
        self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 1.5)
        :addTo(self.bg_)
    self.comic31_:runAction(transition.sequence({cc.MoveTo:create(0.1,cc.p(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)),
        cc.MoveTo:create(0.2,cc.p(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.75)),
        cc.MoveTo:create(0.1,cc.p(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5))}))
    --创建动画1(唐僧颤抖的手)
    display.addSpriteFrames("opening_comic/comic3/comic31_tx1.plist","opening_comic/comic3/comic31_tx1.png")
    local frames1 = display.newFrames("chandou%d.png",1,2)
    local animation1 = display.newAnimation(frames1, 0.1)
    local animate1 = cc.Animate:create(animation1)
    local animatePic1 = display.newSprite("opening_comic/comic3/chandou1.png")
        :pos(self.comic31_:getContentSize().width * 0.17,self.comic31_:getContentSize().height * 0.38)
        :addTo(self.comic31_,1)
    animatePic1:runAction(cc.Repeat:create(animate1,14))
    --创建动画2(唐僧手上的青筋)
    display.addSpriteFrames("opening_comic/comic3/comic31_tx2.plist","opening_comic/comic3/comic31_tx2.png")
    local frames2 = display.newFrames("qingjin%d.png",1,2)
    local animation2 = display.newAnimation(frames2, 0.1)
    local animate2 = cc.Animate:create(animation2)
    local animatePic2 = display.newSprite("opening_comic/comic3/qingjin1.png")
        :pos(self.comic31_:getContentSize().width * 0.21,self.comic31_:getContentSize().height * 0.31)
        :addTo(self.comic31_,1)
    animatePic2:runAction(cc.Repeat:create(animate2,14))

    --tip:"我、不、干、了"
    local dt = 0.5
    local fileName = nil
    for i=1,4 do
        local pTip = display.newSprite(string.format("opening_comic/comic3/tip"..i..".png"))
            :opacity(0)
            :addTo(self.comic31_,1)
        dt = dt + 0.5
        if i == 1 then
            pTip:setPosition(self.comic31_:getContentSize().width * 0.7,self.comic31_:getContentSize().height * 0.54)
            fileName = "sounds/comic/sound_comic31"
        elseif i == 2 then
            pTip:setPosition(self.comic31_:getContentSize().width * 0.57,self.comic31_:getContentSize().height * 0.48)
            fileName = "sounds/comic/sound_comic31"
        elseif i == 3 then
            pTip:setPosition(self.comic31_:getContentSize().width * 0.44,self.comic31_:getContentSize().height * 0.46)
            fileName = "sounds/comic/sound_comic31"
        else
            pTip:setPosition(self.comic31_:getContentSize().width * 0.33,self.comic31_:getContentSize().height * 0.58)
            dt = dt + 0.25
            fileName = "sounds/comic/sound_comic32"
        end
        pTip:runAction(transition.sequence({cc.DelayTime:create(dt),
            cc.FadeIn:create(0.01),cc.CallFunc:create(function()
                if GameManager.SOUND_SWITCH_ON then
                    audio.playSound(string.format("%s.%s",fileName,GameManager.POSTFIX))
                end
            end)}))
    end

    --"继续"按钮出现
    self:runAction(transition.sequence({cc.DelayTime:create(3.0),cc.CallFunc:create(function()
        self.continueBtn_:show()
        self.nextComicId_ = 4
        openSign = true
    end)}))
end

--第四张漫画
function OpeningComicScene:comicScene4_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic41.%s",GameManager.POSTFIX))
    end

    --移除上一漫画的文件
    self.comic31_:removeSelf()
    --	display.removeUnusedSpriteFrames()
    --打印纹理缓存
    --local info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --print(info)

    --加载漫画四的第一张碎图
    self.comic41_ = display.newSprite("opening_comic/comic4/comic41.png",
        self.bg_:getContentSize().width * 0.18,self.bg_:getContentSize().height * 1.75)
        :addTo(self.bg_)
    self.comic41_:runAction(transition.sequence({cc.MoveTo:create(0.2,cc.p(self.bg_:getContentSize().width * 0.18,self.bg_:getContentSize().height * 0.75)),
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function()
            self:comicScene42_()
        end)}))
    --创建动画(递交辞职信)
    display.addSpriteFrames("opening_comic/comic4/comic41_tx.plist","opening_comic/comic4/comic41_tx.png")
    local frames = display.newFrames("comic41_pic%d.png",1,5)
    local animation = display.newAnimation(frames, 0.05)
    local animatePic = display.newSprite("opening_comic/comic4/comic41_first.png")
        :pos(self.comic41_:getContentSize().width * 0.52,self.comic41_:getContentSize().height * 0.49)
        :addTo(self.comic41_,1)
    animatePic:playAnimationOnce(animation,false,nil,0.3)
end
function OpeningComicScene:comicScene42_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic41.%s",GameManager.POSTFIX))
    end

    --加载漫画四的第二张碎图
    self.comic42_ = display.newSprite("opening_comic/comic4/comic42.png",
        self.bg_:getContentSize().width * 1.378,self.bg_:getContentSize().height * 0.75)
        :addTo(self.bg_)
    self.comic42_:runAction(transition.sequence({cc.MoveTo:create(0.2,cc.p(self.bg_:getContentSize().width * 0.378,self.bg_:getContentSize().height * 0.75)),
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function()
            self:comicScene43_()
        end)}))
    --创建动画(递交辞职信)
    display.addSpriteFrames("opening_comic/comic4/comic42_tx.plist","opening_comic/comic4/comic42_tx.png")
    local frames = display.newFrames("comic42_pic%d.png",1,5)
    local animation = display.newAnimation(frames, 0.05)
    local animatePic = display.newSprite("opening_comic/comic4/comic42_first.png")
        :pos(self.comic42_:getContentSize().width * 0.54,self.comic42_:getContentSize().height * 0.568)
        :addTo(self.comic42_,1)
    animatePic:playAnimationOnce(animation,false,nil,0.3)
end
function OpeningComicScene:comicScene43_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic41.%s",GameManager.POSTFIX))
    end

    --加载漫画四的第三张碎图
    self.comic43_ = display.newSprite("opening_comic/comic4/comic43.png",
        -self.bg_:getContentSize().width * 0.82,self.bg_:getContentSize().height * 0.56)
        :addTo(self.bg_)
    self.comic43_:runAction(transition.sequence({cc.MoveTo:create(0.2,cc.p(self.bg_:getContentSize().width * 0.18,self.bg_:getContentSize().height * 0.56)),
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function()
            self:comicScene44_()
        end)}))
    --创建动画(递交辞职信)
    display.addSpriteFrames("opening_comic/comic4/comic43_tx.plist","opening_comic/comic4/comic43_tx.png")
    local frames = display.newFrames("comic43_pic%d.png",1,6)
    local animation = display.newAnimation(frames, 0.05)
    local animatePic = display.newSprite("opening_comic/comic4/comic43_first.png")
        :pos(self.comic43_:getContentSize().width * 0.51,self.comic43_:getContentSize().height * 0.33)
        :addTo(self.comic43_,1)
    animatePic:playAnimationOnce(animation,false,nil,0.3)
end
function OpeningComicScene:comicScene44_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic41.%s",GameManager.POSTFIX))
    end

    --加载漫画四的第四张碎图
    self.comic44_ = display.newSprite("opening_comic/comic4/comic44.png",
        self.bg_:getContentSize().width * 0.378,-self.bg_:getContentSize().height * 0.44)
        :addTo(self.bg_)
    self.comic44_:runAction(transition.sequence({cc.MoveTo:create(0.2,cc.p(self.bg_:getContentSize().width * 0.378,self.bg_:getContentSize().height * 0.56)),
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function()
            self:comicScene49_()
        end)}))
    --创建动画(递交辞职信)
    display.addSpriteFrames("opening_comic/comic4/comic44_tx.plist","opening_comic/comic4/comic44_tx.png")
    local frames = display.newFrames("comic44_pic%d.png",1,6)
    local animation = display.newAnimation(frames, 0.05)
    local animatePic = display.newSprite("opening_comic/comic4/comic44_first.png")
        :pos(self.comic44_:getContentSize().width * 0.494,self.comic44_:getContentSize().height * 0.40)
        :addTo(self.comic44_,1)
    animatePic:playAnimationOnce(animation,false,nil,0.3)
end
function OpeningComicScene:comicScene45_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic46.%s",GameManager.POSTFIX))
    end

    --视图左移
    self.comic41_:runAction(cc.MoveBy:create(0.55,cc.p(-self.bg_:getContentSize().width * 0.48,0)))
    self.comic42_:runAction(cc.MoveBy:create(0.55,cc.p(-self.bg_:getContentSize().width * 0.48,0)))
    self.comic43_:runAction(cc.MoveBy:create(0.55,cc.p(-self.bg_:getContentSize().width * 0.48,0)))
    self.comic44_:runAction(cc.MoveBy:create(0.55,cc.p(-self.bg_:getContentSize().width * 0.48,0)))
    self.comic49_:runAction(cc.MoveBy:create(0.55,cc.p(-self.bg_:getContentSize().width * 0.48,0)))
    self.comic410_:runAction(cc.MoveBy:create(0.5,cc.p(-self.bg_:getContentSize().width * 0.40,0)))
    self.comic411_:runAction(cc.MoveBy:create(0.5,cc.p(-self.bg_:getContentSize().width * 0.40,0)))
    self.comic412_:runAction(cc.MoveBy:create(0.5,cc.p(-self.bg_:getContentSize().width * 0.40,0)))

    --加载漫画四的第五张碎图
    self.comic45_ = display.newSprite("opening_comic/comic4/comic45.png",
        self.bg_:getContentSize().width * 1.72,self.bg_:getContentSize().height * 0.83)
        :addTo(self.bg_)
    self.comic45_:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.MoveTo:create(0.2,cc.p(self.bg_:getContentSize().width * 0.72,self.bg_:getContentSize().height * 0.83)),
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function()
            self:comicScene46_()
        end)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic4/comic45_tx.plist","opening_comic/comic4/comic45_tx.png")
    local frames = display.newFrames("comic45_pic%d.png",1,3)
    local animation = display.newAnimation(frames, 0.2)
    local animate = cc.Animate:create(animation)
    local animatePic = display.newSprite("opening_comic/comic4/comic45.png")
        :pos(self.comic45_:getContentSize().width * 0.5,self.comic45_:getContentSize().height * 0.5)
        :addTo(self.comic45_,1)
    animatePic:runAction(cc.Repeat:create(animate,3))

    --tip:"噗..."
    local pTip = display.newSprite("opening_comic/comic4/comic45_tip.png")
        :pos(self.comic45_:getContentSize().width * 0.153,self.comic45_:getContentSize().height * 0.69)
        :opacity(0)
        :addTo(self.comic45_,2)
    pTip:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.FadeIn:create(1.0)}))
end
function OpeningComicScene:comicScene46_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic47.%s",GameManager.POSTFIX))
    end

    --加载漫画四的第六张碎图
    self.comic46_ = display.newSprite("opening_comic/comic4/comic46.png",
        self.bg_:getContentSize().width * 1.72,self.bg_:getContentSize().height * 0.60)
        :addTo(self.bg_)
    self.comic46_:runAction(transition.sequence({
        cc.MoveTo:create(0.2,cc.p(self.bg_:getContentSize().width * 0.72,self.bg_:getContentSize().height * 0.60)),
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function()
            self:comicScene47_()
        end)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic4/comic46_tx.plist","opening_comic/comic4/comic46_tx.png")
    local frames = display.newFrames("comic46_pic%d.png",1,3)
    local animation = display.newAnimation(frames, 0.2)
    local animate = cc.Animate:create(animation)
    local animatePic = display.newSprite("opening_comic/comic4/comic46_pic1.png")
        :pos(self.comic46_:getContentSize().width * 0.5,self.comic46_:getContentSize().height * 0.5)
        :addTo(self.comic46_,1)
    animatePic:runAction(cc.Repeat:create(animate,3))

    --tip:"哦..."
    local pTip = display.newSprite("opening_comic/comic4/comic46_tip.png")
        :pos(self.comic46_:getContentSize().width * 0.154,self.comic46_:getContentSize().height * 0.33)
        :opacity(0)
        :addTo(self.comic46_,2)
    pTip:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.FadeIn:create(1.0)}))
end
function OpeningComicScene:comicScene47_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic46.%s",GameManager.POSTFIX))
    end

    --加载漫画四的第七张碎图
    self.comic47_ = display.newSprite("opening_comic/comic4/comic47.png",
        self.bg_:getContentSize().width * 1.72,self.bg_:getContentSize().height * 0.38)
        :addTo(self.bg_)
    self.comic47_:runAction(transition.sequence({
        cc.MoveTo:create(0.2,cc.p(self.bg_:getContentSize().width * 0.72,self.bg_:getContentSize().height * 0.38)),
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function()
            self:comicScene48_()
        end)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic4/comic47_tx.plist","opening_comic/comic4/comic47_tx.png")
    local frames = display.newFrames("comic47_pic%d.png",1,3)
    local animation = display.newAnimation(frames, 0.2)
    local animate = cc.Animate:create(animation)
    local animatePic = display.newSprite("opening_comic/comic4/comic47.png")
        :pos(self.comic47_:getContentSize().width * 0.5,self.comic47_:getContentSize().height * 0.5)
        :addTo(self.comic47_,1)
    animatePic:runAction(cc.Repeat:create(animate,3))

    --tip:"我接..."
    local pTip = display.newSprite("opening_comic/comic4/comic47_tip.png")
        :pos(self.comic47_:getContentSize().width * 0.75,self.comic47_:getContentSize().height * 0.5)
        :opacity(0)
        :addTo(self.comic47_,2)
    pTip:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.FadeIn:create(1.0)}))
end
function OpeningComicScene:comicScene48_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic48.%s",GameManager.POSTFIX))
    end

    --加载漫画四的第八张碎图
    self.comic48_ = display.newSprite("opening_comic/comic4/comic48.png",
        self.bg_:getContentSize().width * 1.72,self.bg_:getContentSize().height * 0.17)
        :addTo(self.bg_)
    self.comic48_:runAction(cc.MoveTo:create(0.2,cc.p(self.bg_:getContentSize().width * 0.72,self.bg_:getContentSize().height * 0.17)))
    --创建动画
    display.addSpriteFrames("opening_comic/comic4/comic48_tx.plist","opening_comic/comic4/comic48_tx.png")
    local frames = display.newFrames("comic48_pic%d.png",1,3)
    local animation = display.newAnimation(frames, 0.2)
    local animate = cc.Animate:create(animation)
    local animatePic = display.newSprite("opening_comic/comic4/comic48.png")
        :pos(self.comic48_:getContentSize().width * 0.5,self.comic48_:getContentSize().height * 0.5)
        :addTo(self.comic48_,1)
    animatePic:runAction(cc.Repeat:create(animate,3))

    --tip:"额..."
    local pTip = display.newSprite("opening_comic/comic4/comic48_tip.png")
        :pos(self.comic48_:getContentSize().width * 0.158,self.comic48_:getContentSize().height * 0.34)
        :opacity(0)
        :addTo(self.comic48_,2)
    pTip:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.FadeIn:create(1.0)}))

    --"继续"按钮出现
    self:runAction(transition.sequence({cc.DelayTime:create(1.6),cc.CallFunc:create(function()
        self.continueBtn_:show()
        self.nextComicId_ = 5
        openSign = true
    end)}))
end
function OpeningComicScene:comicScene49_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic42.%s",GameManager.POSTFIX))
    end

    --加载漫画四的第九张碎图
    self.comic49_ = display.newSprite("opening_comic/comic4/comic49.png",
        self.bg_:getContentSize().width * 0.28,-self.bg_:getContentSize().height * 0.78)
        :addTo(self.bg_)
    self.comic49_:runAction(transition.sequence({cc.MoveTo:create(0.5,cc.p(self.bg_:getContentSize().width * 0.28,self.bg_:getContentSize().height * 0.22)),
        cc.DelayTime:create(1.5),
        cc.CallFunc:create(function()
            self:comicScene410_()
        end)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic4/comic49_tx.plist","opening_comic/comic4/comic49_tx.png")
    local frames = display.newFrames("comic49_pic%d.png",1,7)
    local animation = display.newAnimation(frames, 0.05)
    local animatePic = display.newSprite("opening_comic/comic4/comic49.png")
        :pos(self.comic49_:getContentSize().width * 0.50,self.comic49_:getContentSize().height * 0.50)
        :addTo(self.comic49_,1)
    animatePic:playAnimationOnce(animation,false,nil,0.5)

    --tip:"再相聚..."
    local pTip = display.newSprite("opening_comic/comic4/comic49_tip.png")
        :pos(self.comic49_:getContentSize().width * 0.55,self.comic49_:getContentSize().height * 0.70)
        :opacity(0)
        :addTo(self.comic49_,1)
    pTip:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.FadeIn:create(1.0)}))
end
function OpeningComicScene:comicScene410_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic43.%s",GameManager.POSTFIX))
    end

    --加载漫画四的第十张碎图
    self.comic410_ = display.newSprite("opening_comic/comic4/comic410.png",
        self.bg_:getContentSize().width * 0.6,self.bg_:getContentSize().height * 1.75)
        :addTo(self.bg_)
    self.comic410_:runAction(transition.sequence({cc.MoveTo:create(0.5,cc.p(self.bg_:getContentSize().width * 0.6,self.bg_:getContentSize().height * 0.75)),
        cc.DelayTime:create(1.0),
        cc.CallFunc:create(function()
            self:comicScene411_()
        end)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic4/comic410_tx.plist","opening_comic/comic4/comic410_tx.png")
    local frames = display.newFrames("comic410_pic%d.png",1,2)
    local animation = display.newAnimation(frames, 0.05)
    local animate = cc.Animate:create(animation)
    local animatePic = display.newSprite("opening_comic/comic4/comic410.png")
        :pos(self.comic410_:getContentSize().width * 0.50,self.comic410_:getContentSize().height * 0.50)
        :addTo(self.comic410_,1)
    animatePic:runAction(cc.Repeat:create(animate,8))

    --tip:"发..."
    local pTip = display.newSprite("opening_comic/comic4/comic410_tip.png")
        :pos(self.comic410_:getContentSize().width * 0.77,self.comic410_:getContentSize().height * 0.17)
        :opacity(0)
        :addTo(self.comic410_,2)
    pTip:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.FadeIn:create(1.0)}))
end
function OpeningComicScene:comicScene411_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic44.%s",GameManager.POSTFIX))
    end

    --加载漫画四的第十一张碎图
    self.comic411_ = display.newSprite("opening_comic/comic4/comic411.png",
        self.bg_:getContentSize().width * 0.805,self.bg_:getContentSize().height * 1.75)
        :addTo(self.bg_)
    self.comic411_:runAction(transition.sequence({cc.MoveTo:create(0.5,cc.p(self.bg_:getContentSize().width * 0.805,self.bg_:getContentSize().height * 0.75)),
        cc.DelayTime:create(1.0),
        cc.CallFunc:create(function()
            self:comicScene412_()
        end)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic4/comic411_tx.plist","opening_comic/comic4/comic411_tx.png")
    local frames = display.newFrames("comic411_pic%d.png",1,10)
    local animation = display.newAnimation(frames, 0.05)
    local animate = cc.Animate:create(animation)
    local animatePic = display.newSprite("opening_comic/comic4/comic411_pic1.png")
        :pos(self.comic411_:getContentSize().width * 0.48,self.comic411_:getContentSize().height * 0.24)
        :addTo(self.comic411_,1)
    animatePic:runAction(cc.Repeat:create(animate,2))

    --tip:"克..."
    local pTip = display.newSprite("opening_comic/comic4/comic411_tip.png")
        :pos(self.comic411_:getContentSize().width * 0.55,self.comic411_:getContentSize().height * 0.70)
        :opacity(0)
        :addTo(self.comic411_,2)
    pTip:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.FadeIn:create(1.0)}))
end
function OpeningComicScene:comicScene412_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic45.%s",GameManager.POSTFIX))
    end

    --加载漫画四的第十二张碎图
    self.comic412_ = display.newSprite("opening_comic/comic4/comic412.png",
        self.bg_:getContentSize().width * 0.705,-self.bg_:getContentSize().height * 1.68)
        :addTo(self.bg_)
    self.comic412_:runAction(transition.sequence({cc.MoveTo:create(0.5,cc.p(self.bg_:getContentSize().width * 0.705,self.bg_:getContentSize().height * 0.325)),
        cc.DelayTime:create(1.5),
        cc.CallFunc:create(function()
            self:comicScene45_()
        end)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic4/comic412_tx.plist","opening_comic/comic4/comic412_tx.png")
    local frames = display.newFrames("comic412_pic%d.png",1,2)
    local animation = display.newAnimation(frames, 0.05)
    local animate = cc.Animate:create(animation)
    local animatePic = display.newSprite("opening_comic/comic4/comic412.png")
        :pos(self.comic412_:getContentSize().width * 0.5,self.comic412_:getContentSize().height * 0.5)
        :addTo(self.comic412_,1)
    animatePic:runAction(cc.Repeat:create(animate,13))

    --tip:"油..."
    local pTip = display.newSprite("opening_comic/comic4/comic412_tip.png")
        :pos(self.comic412_:getContentSize().width * 0.28,self.comic412_:getContentSize().height * 0.36)
        :opacity(0)
        :addTo(self.comic412_,2)
    pTip:runAction(transition.sequence({cc.DelayTime:create(1.5),
        cc.FadeIn:create(1.0)}))
end

--第五张漫画
function OpeningComicScene:comicScene5_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic5.%s",GameManager.POSTFIX))
    end

    --移除上一漫画的文件
    self.comic41_:removeSelf()
    self.comic42_:removeSelf()
    self.comic43_:removeSelf()
    self.comic44_:removeSelf()
    self.comic45_:removeSelf()
    self.comic46_:removeSelf()
    self.comic47_:removeSelf()
    self.comic48_:removeSelf()
    self.comic49_:removeSelf()
    self.comic410_:removeSelf()
    self.comic411_:removeSelf()
    self.comic412_:removeSelf()
    --	display.removeUnusedSpriteFrames()
    --打印纹理缓存
    --local info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --print(info)

    --加载第五张漫画
    self.comic5_ = display.newSprite("opening_comic/comic5/comic51.png",
        self.bg_:getContentSize().width * 1.5,self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_)
    --创建动作
    local action_ = transition.sequence({
        cc.ScaleTo:create(0.05,1.01),
        cc.ScaleTo:create(0.04,0.99),
        cc.ScaleTo:create(0.06,1.01),
        cc.ScaleTo:create(0.05,1.0)
    })
    --创建动画
    display.addSpriteFrames("opening_comic/comic5/comic51_tx.plist","opening_comic/comic5/comic51_tx.png")
    local frames = display.newFrames("comic51_pic%d.png",1,2)
    local animation = display.newAnimation(frames, 0.1)
    local animate = cc.Animate:create(animation)
    local spawn_ = cc.Spawn:create(action_,animate)
    self.comic5_:runAction(transition.sequence({
        cc.MoveTo:create(0.5,cc.p(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)),
        cc.Repeat:create(spawn_, 12)}))

    --"继续"按钮出现
    self:runAction(transition.sequence({cc.DelayTime:create(2.6),cc.CallFunc:create(function()
        self.continueBtn_:show()
        self.nextComicId_ = 6
        openSign = true
    end)}))
end

--第六张漫画
function OpeningComicScene:comicScene6_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic6.%s",GameManager.POSTFIX))
        audio.playSound(string.format("sounds/comic/sound_comic61.%s",GameManager.POSTFIX))
    end

    --移除上一漫画的文件
    self.comic5_:removeSelf()
    --	display.removeUnusedSpriteFrames()
    --打印纹理缓存
    --local info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --print(info)

    --加载漫画六的第一张碎图
    self.comic61_ = display.newSprite("opening_comic/comic6/comic61.png",
        -self.bg_:getContentSize().width * 0.8,self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_)
    self.comic61_:runAction(transition.sequence({
        cc.MoveTo:create(0.2,cc.p(self.bg_:getContentSize().width * 0.2,self.bg_:getContentSize().height * 0.5)),
        cc.DelayTime:create(2.0),
        cc.CallFunc:create(function()
            self:comicScene62_()
        end)}))
    --创建动画
    display.addSpriteFrames("animation/jiangli.plist","animation/jiangli.png")
    local frames = display.newFrames("jiangli%d.png",1,15)
    local animation = display.newAnimation(frames, 0.1)
    local animatePic = display.newSprite()
        :pos(self.comic61_:getContentSize().width * 0.50,self.comic61_:getContentSize().height * 0.50)
        :addTo(self.comic61_,1)
    animatePic:playAnimationOnce(animation,false,nil,0.5)

    --tip:"决战..."
    local pTip = display.newSprite("opening_comic/comic6/comic61_tip.png")
        :pos(self.comic61_:getContentSize().width * 0.5,self.comic61_:getContentSize().height * 0.5)
        :opacity(0)
        :addTo(self.comic61_,2)
    pTip:runAction(transition.sequence({cc.DelayTime:create(1.0),
        cc.FadeIn:create(1.0)}))
end
function OpeningComicScene:comicScene62_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic62.%s",GameManager.POSTFIX))
        audio.playSound(string.format("sounds/comic/sound_comic62_haojiao.%s",GameManager.POSTFIX))
    end

    --加载漫画六的第二张碎图
    self.comic62_ = display.newSprite("opening_comic/comic6/comic62.png",
        self.bg_:getContentSize().width * 0.32,self.bg_:getContentSize().height * 1.71)
        :addTo(self.bg_)
    self.comic62_:runAction(transition.sequence({
        cc.MoveTo:create(0.1,cc.p(self.bg_:getContentSize().width * 0.32,self.bg_:getContentSize().height * 0.71)),
        cc.DelayTime:create(2.0),
        cc.CallFunc:create(function()
            self:comicScene63_()
        end)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic6/comic62_tx.plist","opening_comic/comic6/comic62_tx.png")
    local frames = display.newFrames("comic62_pic%d.png",1,2)
    local animation = display.newAnimation(frames, 0.1)
    local animate = cc.Animate:create(animation)
    local animatePic = display.newSprite("opening_comic/comic6/comic62.png")
        :pos(self.comic62_:getContentSize().width * 0.50,self.comic62_:getContentSize().height * 0.50)
        :addTo(self.comic62_,1)
    animatePic:runAction(cc.Repeat:create(animate,10))
end
function OpeningComicScene:comicScene63_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic63.%s",GameManager.POSTFIX))
    end

    --加载漫画六的第三张碎图
    self.comic63_ = display.newSprite("opening_comic/comic6/comic63.png",
        self.bg_:getContentSize().width * 1.41,self.bg_:getContentSize().height * 0.48)
        :addTo(self.bg_)
    self.comic63_:runAction(transition.sequence({
        cc.MoveTo:create(0.3,cc.p(self.bg_:getContentSize().width * 0.41,self.bg_:getContentSize().height * 0.48)),
        cc.DelayTime:create(2.0),
        cc.CallFunc:create(function()
            self:comicScene64_()
        end)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic6/comic63_tx.plist","opening_comic/comic6/comic63_tx.png")
    local frames = display.newFrames("comic63_pic%d.png",1,3)
    local animation = display.newAnimation(frames, 0.1)
    local animate = cc.Animate:create(animation)
    local animatePic = display.newSprite("opening_comic/comic6/comic63.png")
        :pos(self.comic63_:getContentSize().width * 0.50,self.comic63_:getContentSize().height * 0.50)
        :addTo(self.comic63_,1)
    animatePic:runAction(cc.Repeat:create(animate,7))

    --tip:"为了无天..."
    local pTip = display.newSprite("opening_comic/comic6/comic63_tip.png")
        :pos(self.comic63_:getContentSize().width * 0.84,self.comic63_:getContentSize().height * 0.898)
        :opacity(0)
        :addTo(self.comic63_,2)
    pTip:runAction(transition.sequence({cc.DelayTime:create(1.0),
        cc.FadeIn:create(0.1)}))
end
function OpeningComicScene:comicScene64_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic64.%s",GameManager.POSTFIX))
        audio.playSound(string.format("sounds/comic/sound_comic64_sha.%s",GameManager.POSTFIX))
    end

    --加载漫画六的第四张碎图
    self.comic64_ = display.newSprite("opening_comic/comic6/comic64.png",
        self.bg_:getContentSize().width * 0.75,self.bg_:getContentSize().height * 1.69)
        :addTo(self.bg_)
    --创建动作
    local action_ = transition.sequence({
        cc.ScaleTo:create(0.05,1.03),
        cc.ScaleTo:create(0.04,0.97),
        cc.ScaleTo:create(0.06,1.03),
        cc.ScaleTo:create(0.05,1.0)})
    self.comic64_:runAction(transition.sequence({
        cc.MoveTo:create(0.3,cc.p(self.bg_:getContentSize().width * 0.75,self.bg_:getContentSize().height * 0.69)),
        cc.Repeat:create(action_, 10),
        cc.CallFunc:create(function()
            self:comicScene65_()
        end)}))
    --创建动画
    display.addSpriteFrames("opening_comic/comic6/comic64_tx.plist","opening_comic/comic6/comic64_tx.png")
    local frames = display.newFrames("comic64_pic%d.png",1,2)
    local animation = display.newAnimation(frames, 0.1)
    local animate = cc.Animate:create(animation)
    local animatePic = display.newSprite("opening_comic/comic6/comic64.png")
        :pos(self.comic64_:getContentSize().width * 0.50,self.comic64_:getContentSize().height * 0.50)
        :addTo(self.comic64_,1)
    animatePic:runAction(cc.Repeat:create(animate,10))

    --tip:"杀杀杀..."
    local pTip = display.newSprite("opening_comic/comic6/comic64_tip.png")
        :pos(self.comic64_:getContentSize().width * 0.6,self.comic64_:getContentSize().height * 0.6)
        :opacity(0)
        :addTo(self.comic64_,2)
    pTip:runAction(transition.sequence({cc.DelayTime:create(0.5),
        cc.FadeIn:create(1.0)}))
end
function OpeningComicScene:comicScene65_()
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic65.%s",GameManager.POSTFIX))
    end

    --加载漫画六的第五张碎图
    self.comic65_ = display.newSprite("opening_comic/comic6/comic65.png",
        self.bg_:getContentSize().width * 1.665,self.bg_:getContentSize().height * 0.295)
        :addTo(self.bg_)
    self.comic65_:runAction(cc.MoveTo:create(0.3,cc.p(self.bg_:getContentSize().width * 0.665,self.bg_:getContentSize().height * 0.295)))

    --"继续"按钮出现
    self:runAction(transition.sequence({cc.DelayTime:create(1.6),cc.CallFunc:create(function()
        self.continueBtn_:show()
        self.nextComicId_ = 7
        openSign = true
    end)}))
end

--第七张漫画
function OpeningComicScene:comicScene7_()
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/comic/sound_comic7.%s",GameManager.POSTFIX))
    end

    --移除上一漫画的文件
    self.comic61_:removeSelf()
    self.comic62_:removeSelf()
    self.comic63_:removeSelf()
    self.comic64_:removeSelf()
    self.comic65_:removeSelf()
    --	display.removeUnusedSpriteFrames()
    --打印纹理缓存
    --local info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --print(info)

    --加载第七张漫画
    local comic7 = display.newSprite("opening_comic/comic7/comic71.png",
        self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
        :scale(0)
        :addTo(self.bg_)
    local spawn_ = cc.Spawn:create(cc.ScaleTo:create(1.2,0.5),
        cc.RotateBy:create(1.2,2160))
    comic7:runAction(transition.sequence({spawn_,
        cc.DelayTime:create(3.0),
        cc.CallFunc:create(function()
            self:toStage0_()
        end)}))
end

--漫画结束,进入第0关
function OpeningComicScene:toStage0_()
    --停止背景音乐
    audio.stopMusic()

    --todo:联网存储
    local ac = AlertConnection.new(CONNECTION_GUIDE,"oc")
    self:addChild(ac,100,12345)

    self.scheduleOC_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleOC_)

            CloudData.OPENNING_COMIC_PLAYED = 1
            --进入到章节界面
            display.replaceScene(require("scenes.TinyLoadingScene").new("CHAPTER_SCENE"))
        end
    end,0.1)

    --self.bg_:removeSelf()
    --display.removeUnusedSpriteFrames()
    --打印纹理缓存
    -- local info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    -- print(info)
end

function OpeningComicScene:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function OpeningComicScene:showReturnWarning_()
    if self.returnMask ~= nil then
        return
    end
    self.returnMask = display.newColorLayer(cc.c4b(0,0,0,150))
    self:addChild(self.returnMask,20000)
    
    local bg = display.newSprite("common_ui/common_bg.png"):pos(display.cx, display.cy):addTo(self.returnMask,1)
    cc.ui.UILabel.new({
        text = "确定退出？" ,size = 32,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.57)
        :addTo(bg)
        
    --确定按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.22)
        :onButtonClicked(function()
            if PaymentInfo.CHANNEL == 3 then
                --酷狗SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitKugou"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            elseif PaymentInfo.CHANNEL == 4 then
                --UC SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitUC"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            elseif BAIDU_PROMOTION then
                --Baidu SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitBaidu"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            else
                cc.Director:getInstance():endToLua()
                if device.platform == "windows" or device.platform == "mac" then
                    os.exit()
                end
            end
        end)
        :addTo(bg,2)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.95,bg:getContentSize().height * 0.95)
        :onButtonClicked(function()
            self.returnMask:removeSelf()
            self.returnMask = nil
        end)
        :scale(0.8)
        :addTo(bg,2)
end

function OpeningComicScene:onEnter()
end

function OpeningComicScene:onExit()
    display.removeUnusedSpriteFrames()
end

return OpeningComicScene
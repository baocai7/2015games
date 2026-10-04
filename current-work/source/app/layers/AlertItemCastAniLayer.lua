--
--道具释放动画
--

local AlertItemCastAniLayer = class("AlertItemCastAniLayer", function()
    return display.newLayer()
end)

function AlertItemCastAniLayer:ctor(itemID)
    --添加遮罩层
    self.mask_ = display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

    if itemID == 1 then
        --老君金丹
        self:startActionMaxSpirit_()
    elseif itemID == 5 then
        --万字符
        self:startActionZeroCDTime_()
    elseif itemID == 6 then
        --献宝令
        self:startActionGoldTreasure_()
    else
        --其他
        self:startOtherItemAnimation_(itemID)
    end

    --DataEye统计
    if USE_DATAEYE then
        DCEvent.onEvent("use_item_".. itemID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS)
    end
end

-- 6 献宝令
function AlertItemCastAniLayer:startActionGoldTreasure_()
    display.addSpriteFrames("item/baowutexiaoxuanzhuan.plist","item/baowutexiaoxuanzhuan.png")

    --print("***startActionGoldTreasure_!***")
    self.halo_ = display.newSprite("chapter/halo.png", display.cx, display.cy)
        :scale(3.2)
        :addTo(self)
    self.halo_:setOpacity(153)

    self.halo_:runAction(cc.RepeatForever:create(cc.RotateBy:create(3.0,90)))

    local icon = display.newSprite("item/treasure.png", display.cx,display.cy)
        :scale(3)
        :addTo(self)

    self.destPos_ = cc.p(display.width * 0.95, display.height * 0.3)

    local scale1 = cc.ScaleTo:create(0.3, 0.9)
    local scale2 = cc.ScaleTo:create(0.2, 1.0)
    local delay = cc.DelayTime:create(1.0)
    local mov = cc.MoveTo:create(0.3, self.destPos_)
    local scale3 = cc.ScaleTo:create(0.3, 0.5)
    local spawn = cc.Spawn:create(mov,scale3)
    local call1 = cc.CallFunc:create(function()
        self:hideMaskAndHalo_()
    end)
    local call2 = cc.CallFunc:create(function()
        self:addBuffAni1_()
    end)

    icon:runAction(transition.sequence({scale1,scale2,delay,call1,spawn,call2}))
end

-- 1 老君金丹
function AlertItemCastAniLayer:startActionMaxSpirit_()
    --print("***startActionMaxSpirit_!***")

    self.halo_ = display.newSprite("chapter/halo.png", display.cx, display.cy)
        :scale(3.2)
        :addTo(self)
    self.halo_:setOpacity(153)

    self.halo_:runAction(cc.RepeatForever:create(cc.RotateBy:create(3.0,90)))

    self.icon = display.newSprite("item/spirit.png", display.cx,display.cy)
        :scale(3)
        :addTo(self)

    local scale1 = cc.ScaleTo:create(0.3, 0.9)
    local scale2 = cc.ScaleTo:create(0.2, 1.0)
    local delay = cc.DelayTime:create(1.0)
    local call1 = cc.CallFunc:create(function()
        self:hideMaskAndHalo_()
    end)
    local call2 = cc.CallFunc:create(function()
        self:addBuffAni2_()
    end)
    self.icon:runAction(transition.sequence({scale1,scale2,delay,call1,call2}))
end

-- 5 万字符
function AlertItemCastAniLayer:startActionZeroCDTime_()

    display.addSpriteFrames("item/wanzifujihuo.plist","item/wanzifujihuo.png")
    display.addSpriteFrames("item/wanzifuxuanzhuan.plist","item/wanzifuxuanzhuan.png")
    display.addSpriteFrames("item/baowutexiaoxuanzhuan.plist","item/baowutexiaoxuanzhuan.png")

    self.halo_ = display.newSprite("chapter/halo.png", display.cx, display.cy)
        :scale(3.2)
        :addTo(self)
    self.halo_:setOpacity(153)

    self.halo_:runAction(cc.RepeatForever:create(cc.RotateBy:create(3.0,90)))

    self.icon = display.newSprite("item/wan.png", display.cx,display.cy)
        :scale(3)
        :addTo(self)

    local scale1 = cc.ScaleTo:create(0.3, 0.9)
    local scale2 = cc.ScaleTo:create(0.2, 1.0)
    local delay = cc.DelayTime:create(1.0)
    local call1 = cc.CallFunc:create(function()
        self:hideMaskAndHalo_()
    end)
    local call2 = cc.CallFunc:create(function()
        self:addBuffAni3_()
    end)
    self.icon:runAction(transition.sequence({scale1,scale2,delay,call1,call2}))

    local destPos = cc.p(display.width * 0.95, display.height * 0.4)

    local scale1 = cc.ScaleTo:create(0.3, 0.9)
    local scale2 = cc.ScaleTo:create(0.2, 1.0)
    local delay = cc.DelayTime:create(1.0)
    local mov = cc.MoveTo:create(0.3, destPos)
    local scale3 = cc.ScaleTo:create(0.3, 0.5)
    local spawn = cc.Spawn:create(mov,scale3)
    local call1 = cc.CallFunc:create(function()
        self:hideMaskAndHalo_()
    end)
    local call2 = cc.CallFunc:create(function()
        self:addBuffAni3_()
    end)
    self.icon:runAction(transition.sequence({scale1,scale2,delay,call1,spawn,call2}))
end

-- 其他 234号道具
function AlertItemCastAniLayer:startOtherItemAnimation_(itemID)
    --print("***startOtherItemAnimation_!***")
    display.addSpriteFrames("item/wanzifujihuo.plist","item/wanzifujihuo.png")
    --print("***pic***".."item/item"..itemID.."_pic.png")
    --print("***name***".."item/item"..itemID.."_name.png")
    if itemID == 0 then
        self:removeThis_()
        return
    end

    local light = display.newSprite("item/light.png", display.cx, display.cy)
        :addTo(self)
    light:setOpacity(153)

    --道具图片
    local icon = display.newSprite()
        :pos(light:getContentSize().width * 0.5, light:getContentSize().height * 0.5)
        :addTo(light)
    --道具名称
    local name = display.newSprite()
        :scale(0)
        :pos(light:getContentSize().width * 0.5, light:getContentSize().height * 0.35)
        :addTo(light)

    --由于与之前版本id序号不同,此处做相应改动
    if itemID == 2 then
        icon:setTexture("item/item1_pic.png")
        name:setTexture("item/item1_name.png")
    elseif itemID == 3 then
        icon:setTexture("item/item2_pic.png")
        name:setTexture("item/item2_name.png")
    elseif itemID == 4 then
        icon:setTexture("item/item4_pic.png")
        name:setTexture("item/item4_name.png")
    end

    --创建图片动作
    local delay = cc.DelayTime:create(1.5)
    local scale = cc.ScaleTo:create(1, 0.5)
    local fade = cc.FadeOut:create(1.0)
    local spawn = cc.Spawn:create(scale,fade)
    local call = cc.CallFunc:create(function()
        self:removeThis_()
    end)
    icon:runAction(transition.sequence({delay,spawn,call}))


    --创建名称动作
    local pos = cc.p(light:getContentSize().width * 0.5, light:getContentSize().height * 0.42)
    local delaytime1 = cc.DelayTime:create(0.5)
    local sca1 = cc.ScaleTo:create(0.3, 1.0)
    local delaytime2 = cc.DelayTime:create(0.7)
    local sca2 = cc.ScaleTo:create(1.0, 0.5)
    local fadeout = cc.FadeOut:create(1.0)
    local move = cc.MoveTo:create(1.0, pos)
    local spawn1 = cc.Spawn:create(sca2,fadeout,move)
    name:runAction(transition.sequence({delaytime1,sca1,delaytime2,spawn1}))

    local frames = display.newFrames("wanzifujihuo%d.png",1,30)
    local animation = display.newAnimation(frames,0.05)
    local sp = display.newSprite("animation/first.png")
        :pos(icon:getPositionX(), icon:getPositionY())
        :scale(2.0)
        :addTo(light,1)
    sp:playAnimationForever(animation)
end

function AlertItemCastAniLayer:hideMaskAndHalo_()
    --print("***hideMaskAndHalo_!***")
    self.mask_:setVisible(false)
    self.halo_:setVisible(false)
end

function AlertItemCastAniLayer:addBuffAni1_()
    --print("***addBuffAni1_!***")
    local frames = display.newFrames("baowutexiaoxuanzhuan%d.png",1,16)
    local animation = display.newAnimation(frames,0.07)
    local sp = display.newSprite("animation/first.png")
        :pos(self.destPos_.x, self.destPos_.y)
        :scale(2.0)
        :addTo(self:getParent(),9)
    sp:playAnimationForever(animation)
    self:removeThis_()
end

function AlertItemCastAniLayer:addBuffAni2_()
    --print("***addBuffAni2_!***")
    self.icon:removeSelf()

    local destPos1_ = cc.p(display.width * 0.7, display.height * 0.7)
    local destPos2_ = cc.p(-display.width * 0.7, -display.height * 0.7)

    local particleNode1_ = cc.ParticleBatchNode:create("item/particle.png")
    local myParticle1   = cc.ParticleSystemQuad:create("item/laojunjindan-lizi.plist")
    myParticle1:setPosition(cc.p(display.cx,display.cy))
    particleNode1_:addChild(myParticle1)
    self:addChild(particleNode1_,1)

    local particleNode2_ = cc.ParticleBatchNode:create("item/particle.png")
    local myParticle3   = cc.ParticleSystemQuad:create("item/laojunjindan-lizi.plist")
    myParticle3:setPosition(cc.p(display.cx,display.cy))
    particleNode2_:addChild(myParticle3)
    self:addChild(particleNode2_,1)

    local mov1 = cc.MoveTo:create(0.8, destPos1_)
    local mov2 = cc.MoveTo:create(0.8, destPos2_)
    particleNode1_:runAction(transition.sequence({mov1,cc.CallFunc:create(function()
        self:removeThis_()
    end)}))
    particleNode2_:runAction(mov2)
end

function AlertItemCastAniLayer:addBuffAni3_()
    --print("***addBuffAni3_!***")
    self.icon:removeSelf()

    for i = 1, #Game.TEAM_ICON do
        local frames = display.newFrames("wanzifuxuanzhuan%d.png",1,16)
        local animation = display.newAnimation(frames,0.15)
        local sp = display.newSprite()
            :pos(Game.TEAM_ICON[i]:getPosition())
            :scale(2.6)
            :addTo(display.getRunningScene(),15,10086 + i)      --此处添加tag值,以便在使用道具后,开启自动战斗或关闭自动战斗特效光圈能够同步
        sp:playAnimationForever(animation)
    end

    -- local frames = display.newFrames("baowutexiaoxuanzhuan%d.png",1,16)
    -- local animation = display.newAnimation(frames,0.07)
    -- local sp = display.newSprite("animation/first.png")
    --     :pos(display.width * 0.95, display.height * 0.4)
    --     :scale(2.0)
    --     :addTo(self:getParent(),9)
    -- sp:playAnimationForever(animation)

    local delay = cc.DelayTime:create(1.0)
    local call = cc.CallFunc:create(function()
        self:removeThis_()
    end)
    self:runAction(transition.sequence({delay,call}))
end

function AlertItemCastAniLayer:removeThis_()
    --print("***removeThis_!***")
    self:removeSelf()
end

return AlertItemCastAniLayer
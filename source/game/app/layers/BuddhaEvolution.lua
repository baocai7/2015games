--
--兵种十级变身特效
--

local BuddhaEvolution = class("BuddhaEvolution", function()
    return display.newLayer()
end)

function BuddhaEvolution:ctor( buddhaModel )
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_advanced.%s",GameManager.POSTFIX))
	end

    self.model_ = buddhaModel
    --灰色遮罩背景
    self.bg_ = display.newColorLayer(cc.c4b(0,0,0,230))
        :pos(display.cx,display.cy)
        :addTo(self)
    self.bg_:setContentSize(cc.size(display.width,display.height))
    self.bg_:setAnchorPoint(0.5,0.5)

    --旋转的光圈
    self.lightCircle_ = display.newSprite("upgrade/lighting.png",self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_)
    self.lightCircle_:runAction(cc.RepeatForever:create(cc.RotateBy:create(9.0,360)))

    --此处添加两张精灵,给骨骼动画标记位置,一遍骨骼动画缩放的时候与升级界面位置能对上
    local frame = display.newSprite("upgrade/upgradebg.png",self.bg_:getContentSize().width * 0.52,self.bg_:getContentSize().height * 0.45)
        :opacity(0)
        :addTo(self.bg_)
    --右上展示骨骼动画区域
    self.armatureFrame_ = display.newSprite("upgrade/upgradebg1.png",frame:getContentSize().width * 0.706,frame:getContentSize().height * 0.655)
        :opacity(0)
        :addTo(frame,1)
    --加载并创建骨骼动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb",
        buddhaModel.hurtFrame_,buddhaModel.hurtFrame_))
    self.armature_ = ccs.Armature:create(buddhaModel.hurtFrame_)
    self.armature_:setOpacity(0)
    self.armature_:setPosition(-self.armatureFrame_:getContentSize().width * 0.05, self.armatureFrame_:getContentSize().height * 0.05 + buddhaModel.upMove_ * buddhaModel.adaptScale_)
    self.armature_:setScale(buddhaModel.adaptScale_ * 1.5)
    self.armature_:getAnimation():playWithIndex(0)
    self.armatureFrame_:addChild(self.armature_,1)
    self.armature_:runAction(transition.sequence({cc.DelayTime:create(0.5),cc.FadeIn:create(1.0)}))

    --创建动画(进化)
    display.addSpriteFrames("animation/jinhua_tx.plist","animation/jinhua_tx.png")
    local frames1 = display.newFrames("jinhua%d.png",1,17)
    local animation1 = display.newAnimation(frames1, 0.08)
    local emptyPic1 = display.newSprite()
        :scale(2.0)
        :pos(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_,2)
    emptyPic1:playAnimationOnce(animation1,true)

    --创建特效(星星)
    display.addSpriteFrames("animation/xingxing.plist","animation/xingxing.png")
    local frames2 = display.newFrames("xingxing-%d.png",1,76)
    local animation2 = display.newAnimation(frames2, 0.1)
    local emptyPic2 = display.newSprite()
        :scale(2.0)
        :pos(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_,2)
    emptyPic2:playAnimationOnce(animation2,true)

    --2.0s后移除动画
    self:runAction(transition.sequence({cc.DelayTime:create(2.0),cc.CallFunc:create(function()
        self:removeAimation_()
    end)}))
end

--移除动画
function BuddhaEvolution:removeAimation_( )
    --移除光圈
    self.lightCircle_:runAction(cc.FadeOut:create(0.6))

    --骨骼动画缩小,位置后移
    local toPoint = cc.p(self.armatureFrame_:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.2 + self.model_.upMove_)
    self.armature_:runAction(cc.Spawn:create(cc.MoveTo:create(0.5,toPoint),cc.ScaleTo:create(0.5,self.model_.adaptScale_)))

    --背景渐变消失
    self.bg_:runAction(transition.sequence({cc.FadeOut:create(0.6),cc.CallFunc:create(function()
        self:removeSelf()
        display.removeUnusedSpriteFrames()
    end)}) )
end

return BuddhaEvolution
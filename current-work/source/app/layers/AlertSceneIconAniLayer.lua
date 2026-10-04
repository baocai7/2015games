--
--开启新章节入口时播放动画
--
local SceneIcon = import("icons.SceneIcon")

local AlertSceneIconAniLayer = class("AlertSceneIconAniLayer", function()
	return display.newLayer()
end)

function AlertSceneIconAniLayer:ctor(index)
	self.destPos_ = cc.p(display.cx - display.height * (0.875 - 0.25 * index), display.height * 0.1)
	
	--添加遮罩层
	self.mask_ = display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

	--记录是哪个场景
	self.secneId_ = index
	
	self:initUI_(index)	
end

function AlertSceneIconAniLayer:initUI_(index)
	--加载特效配置文件
	display.addSpriteFrames("animation/splash.plist","animation/splash.png")
		
	self.halo_ = display.newSprite("chapter/halo.png", display.cx,display.cy)
		:scale(2)
		:addTo(self)
		self.halo_:setOpacity(153)
	
	self.halo_:runAction(cc.RepeatForever:create(cc.RotateBy:create(3.0,90)))
	
	self.icon_ = SceneIcon.new(index)
		:pos(display.cx,display.cy)
		:scale(3.0)
		:addTo(self)
	
	local popupLayer = transition.sequence(
			{cc.ScaleTo:create(0.2, 1.0),
			cc.ScaleTo:create(0.2, 1.3),
			cc.ScaleTo:create(0.1, 1.0),			
			cc.DelayTime:create(1.0),
			cc.CallFunc:create(function()
				self:hideMaskAndHalo_()
			end),
			cc.MoveTo:create(0.2,self.destPos_),
			cc.CallFunc:create(function()
				self:splashAnimation_()
			end)})
	self.icon_:runAction(popupLayer)
end

function AlertSceneIconAniLayer:hideMaskAndHalo_()
	self.mask_:setVisible(false)
	self.halo_:setVisible(false)
end

function AlertSceneIconAniLayer:splashAnimation_()
	self.icon_:runAction(transition.sequence({cc.ScaleTo:create(0.1,1.2),cc.ScaleTo:create(0.1,1.0)}))
	
	local frames = display.newFrames("splash%d.png",1,16)
	local animation = display.newAnimation(frames,0.07)
	local sp = display.newSprite("animation/first.png")
		:pos(self.destPos_.x, self.destPos_.y)
	    :scale(2.0)
	    :addTo(self,2)
	sp:playAnimationOnce(animation,true,function()
			self:saveAndRemoveThis_()
		end)
end

function AlertSceneIconAniLayer:saveAndRemoveThis_()

	CloudData.SCENE_UNLOCK_ANIMATION_PLAYED[self.secneId_] = 1

	--获取chapterScene
	local currScene = display.getRunningScene()
	local currIcon  = currScene.sceneIconsTable_[self.secneId_]
	currIcon:setVisible(true)
	currScene:dealUserProgress()
	
	self:removeSelf()
end

return AlertSceneIconAniLayer

-- GameScene 中 右下角照妖镜发射按钮

local FireBtn = {} 
FireBtn = class("FireBtn", function()
    return display.newNode()
end)

function FireBtn:ctor()
    self:init()
end

function FireBtn:init()
    local sprite = display.newSprite("gamescene/fire.png"):addTo(self)
    self:setContentSize(sprite:getContentSize())
    
    --点击事件
    sprite:setTouchEnabled(true) -- enable sprite touch
    sprite:setTouchSwallowEnabled(true)
    sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y, prevX, prevY = event.name, event.x, event.y, event.prevX, event.prevY
        if name == "began" then
            self:onPressed()
            return true
        end
    end)

    --动画缓存
    display.addSpriteFrames("animation/mirrfire.plist", "animation/mirrfire.png")
    
    
    --
    local towerBuddhaModel = DataUtils.getTowerBuddhaModel()
    local level = towerBuddhaModel.wandPropertyLevelTotal_
    local armatureName = ""
    self.lineWithIn_ = display.newSprite("gamescene/sc1.png",Game.TOWER_BUDDHA:getPositionX() - Game.TOWER_BUDDHA.model_.range_,Game.BG1:getContentSize().height * 0.3)
    if level < 30 then
        armatureName = "shandiantexiao1"
    elseif level < 55 then
        armatureName = "shandiantexiao2"
    else
        armatureName = "shandiantexiao3"
    end

    -- 给第二关红孩儿引导用
    self.toRangeX_ = Game.TOWER_BUDDHA:getPositionX() - Game.TOWER_BUDDHA.model_.range_
    
    -- 闪电20组骨骼动画缓存
    self.tableShandian_ = {}
    local armature = nil
    for i = 1,20 do
        armature = ccs.Armature:create(armatureName)
        armature:setVisible(false)
        armature:setPosition(Game.TOWER_BUDDHA:getPositionX() - 60 * (i-1) - 50, display.height * 0.22)
        Game.BG1:addChild(armature)
        self.tableShandian_[i] = armature
    end
    
    --攻击距离标识
    self.lineWithIn_:setScale(0.4)
    self.lineWithIn_:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.4,cc.p(0,10)),cc.MoveBy:create(0.4,cc.p(0,-10)))))
    Game.BG1:addChild(self.lineWithIn_,10)
    self.lineWithIn_:setVisible(false)
    --线
    self.line_ = display.newSprite("gamescene/distance.png",Game.TOWER_BUDDHA:getPositionX() - Game.TOWER_BUDDHA.model_.range_,Game.BG1:getContentSize().height * 0.22)
    Game.BG1:addChild(self.line_,10)
    self.line_:setVisible(false)
    
    -- 图形
    self.figureSprite_ = display.newSprite("gamescene/mirror.png",9,0):addTo(self,3)
    self.figureSprite_:setVisible(false)
    self.graySprite_ = display.newSprite("gamescene/gray_mirror.png",9,0):addTo(self,1)
    
    -- 发射火焰底图，视觉效果提交
    self.mirrorBg = cc.Sprite:create("gamescene/mirror.png")
    self.mirrorBg:setOpacity(32)
    self.mirrorBg:setPosition(9,0)
    self:addChild(self.mirrorBg,2)
    
    -- progressbar
    self.progressTimer_ = cc.ProgressTimer:create(display.newSprite("gamescene/mirror.png")):addTo(self,2)
    self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progressTimer_:setPosition(9,0)
    self.progressTimer_:setMidpoint(cc.p(0,0))
    self.progressTimer_:setBarChangeRate(cc.p(0,1))
    
    self:cd()
    
end

function FireBtn:cd()

    self.isReady_ = false
    
    self.lineWithIn_:setVisible(false)
    self.line_:stopAllActions()
    self.line_:setVisible(false)

    self.progressTimer_:setPercentage(0)

    local upgradePropertyModel = DataUtils.getUpgradePropertyModel(3)

    local seq = transition.sequence({
        --cc.ProgressTo:create(10,100), --for test
        cc.ProgressTo:create(upgradePropertyModel.param_,100),
        cc.CallFunc:create(function()
            self:readyForFire()
        end),
    })
    self.progressTimer_:runAction(seq)

    if Game.MODE == "NORMAL" then
        local stageModel = DataUtils.getStageModel(GameManager.STAGE_NUM)
        if 1 ~= tonumber(stageModel.isGrooveMode_) then
            -- 降妖杖CD状态
            Game.TOWER_BUDDHA:wandInCD()
        end
    end
end

function FireBtn:readyForFire()

    self.isReady_ = true
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_gun_cooldown.%s",GameManager.POSTFIX))
	end	
	
	local frames = display.newFrames("mirrfire%d.png", 1, 2)
    local animation = display.newAnimation(frames, 0.15)
    self.figureSprite_:setVisible(true)
    self.figureSprite_:playAnimationForever(animation)
    
    --
    self.lineWithIn_:setVisible(true)
    self.line_:runAction(cc.RepeatForever:create(cc.Blink:create(0.5,2)))

    if Game.MODE == "NORMAL" then
        local stageModel = DataUtils.getStageModel(GameManager.STAGE_NUM)
        if 1 ~= tonumber(stageModel.isGrooveMode_) then
            -- 降妖杖满能量状态
            Game.TOWER_BUDDHA:wandIsReady()
        end
    end
end

function FireBtn:onPressed()
    if self.isReady_ then
		if GameManager.SOUND_SWITCH_ON then
			audio.playSound(string.format("sounds/sfx_flash_exploed.%s",GameManager.POSTFIX))
		end

        -- 降妖杖攻击状态
        Game.TOWER_BUDDHA:wandAttack()

        self:performWithDelay(function()
            self:fire()
        end, 1.0)
        --self:fire()
        self.figureSprite_:stopAllActions()
        self.figureSprite_:setVisible(false)
        --
        
        self:cd()
    end
end

--
function FireBtn:fire()
    self.shandianIndex_ = 1
    
    if self.schedule_shandian_ then
        self:stopAction(self.schedule_shandian_)
    end
    
    self.schedule_shandian_ = self:schedule(function()
        self:shandian()
    end,0.25)
end

function FireBtn:shandian()
    if self.shandianIndex_ < #self.tableShandian_ then
		if GameManager.SOUND_SWITCH_ON then
			audio.playSound(string.format("sounds/snd026.%s",GameManager.POSTFIX))
		end
        local shandian = self.tableShandian_[self.shandianIndex_]
        if ( shandian:getPositionX() < Game.TOWER_BUDDHA:getPositionX() - Game.TOWER_BUDDHA.model_.range_ ) then
            self:stopAction(self.schedule_shandian_)
            --受伤结束
            for i,monster in pairs(Game.MONSTER_TABLE) do
                monster.isHurtedByShandian_ = false
            end
            return
		end
		shandian:setVisible(true)
		shandian:getAnimation():playWithIndex(0)
        self.shandianIndex_ = self.shandianIndex_ + 1
        --受伤
        for i,monster in pairs(Game.MONSTER_TABLE) do
            if monster:getPositionX() + 50 >= shandian:getPositionX() then
            	if not monster.isHurtedByShandian_ then
            	    --temp
                    monster:underAttack(Game.TOWER_BUDDHA.model_.attack_,true)
            	end
            end
        end
	else
        self:stopAction(self.schedule_shandian_)
	end
end


return FireBtn
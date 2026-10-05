
-- GameScene 中 左下角唐僧升级按钮

local UpgradeBtn = {} 
local CompatTrace = import("utils.CompatTrace")
UpgradeBtn = class("UpgradeBtn", function()
    return display.newNode()
end)

function UpgradeBtn:ctor()
    self:init()
end

function UpgradeBtn:init()
    --
    local sprite = display.newSprite("gamescene/upgrade.png"):addTo(self)
    self:setContentSize(sprite:getContentSize())

    --点击事件
    sprite:setTouchEnabled(true) -- enable sprite touch
    sprite:setTouchSwallowEnabled(true)
    sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y, prevX, prevY = event.name, event.x, event.y, event.prevX, event.prevY
        if name == "began" then
            if CloudData.STAGE_PROGRESS == 0 then
                if  DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_MAKE_BUDDHA") then
                    self:upgrade()
                end
            else
                self:upgrade()
            end
            return true
        end
    end)
    
    -- 动画缓存（原版构造时机和图集路径保留）
    CompatTrace.log("ui", "UpgradeBtn ctor: loading upgrade_spirit atlas")
    display.addSpriteFrames("animation/upgrade_spirit.plist", "animation/upgrade_spirit.png")

    -- 图形
    self.figureSprite_ = display.newSprite("#upgrade_spirit1.png",-9,0):addTo(self)
    self.graySprite_ = display.newSprite("gamescene/gray_upgrade_spirit.png",-9,0):addTo(self,1)
    
    -- level 标签 1 ~ 8 
    display.newSprite("gamescene/level.png",-30,60):addTo(self)
    self.labelLevel_ = cc.ui.UILabel.new({
        UILabelType = 1,text = string.format("%d",GameManager.TANGMONK_LEVEL),font = "fonts/yellowNum.fnt"})
        :align(display.CENTER, 30,62)
        :addTo(self)
    self.labelLevel_:setScale(0.8)
    
    -- 灵气消耗标签 : 40 80 160...
    local levelSpiritGrowSpeed = tonumber(DataUtils.getPropertyLevel(5)) or 1
    self.spiritCostBasic_ = tonumber(DataUtils.getSpiritCostBasic(levelSpiritGrowSpeed)) or 40
    self.labelSpirit_ = cc.ui.UILabel.new({
        UILabelType = 1,text = string.format("%d",self.spiritCostBasic_),font = "fonts/whiteNum.fnt"})
        :align(display.CENTER, 25,-25)
        :addTo(self,2)
    self.labelSpirit_:setScale(0.7)
    
    --update
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,handler(self , self.update))
    self:scheduleUpdate()

    -- 无尽模式默认灵气等级最大
    if Game.MODE == "INFINITE" then
        -- GameManager.TANGMONK_LEVEL = 8
        self:maxLevel()
    end
end

function UpgradeBtn:update()
    
    if GameManager.TANGMONK_LEVEL < 8 then
        local currentSpirit = tonumber(GameManager.getCurrentSpirit()) or 0
        if ( currentSpirit >= GameManager.TANGMONK_LEVEL * self.spiritCostBasic_ ) then
            if not self.isBlinkAnimationInPlay_ then
                self.isBlinkAnimationInPlay_ = true
                self.graySprite_:setVisible(false)
                local frames = display.newFrames("upgrade_spirit%d.png", 1, 2)
                local animation = display.newAnimation(frames, 0.15)
                self.figureSprite_:playAnimationForever(animation)
            end
        else
            self.isBlinkAnimationInPlay_ = false
            self.figureSprite_:stopAllActions()
            self.graySprite_:setVisible(true)
        end
    else
        self.isBlinkAnimationInPlay_ = false
        self.figureSprite_:stopAllActions()
        self.graySprite_:setVisible(false)
    end
    
end

function UpgradeBtn:upgrade()

    if ( GameManager.TANGMONK_LEVEL < 8) then

        local currentSpirit = tonumber(GameManager.getCurrentSpirit()) or 0
        if ( currentSpirit >= GameManager.TANGMONK_LEVEL * self.spiritCostBasic_ ) then
            if GameManager.SOUND_SWITCH_ON then
				audio.playSound(string.format("sounds/sfx_lq_upgrade.%s",GameManager.POSTFIX))
			end
			
--            GameManager.CURRENT_SPIRIT = GameManager.CURRENT_SPIRIT - GameManager.TANGMONK_LEVEL * self.spiritCostBasic_
            local currentSpirit = tonumber(GameManager.getCurrentSpirit()) or 0
            GameManager.setCurrentSpirit(currentSpirit - GameManager.TANGMONK_LEVEL * self.spiritCostBasic_)

            GameManager.TANGMONK_LEVEL = GameManager.TANGMONK_LEVEL + 1

            Game.SPIRIT_COUNTER:reInit()

            --让右上角灵气计数器闪烁两次 加 飘粒子效果
            --创建粒子特效
            self.particleNode_ = cc.ParticleBatchNode:create("item/particle.png")
            local myParticle1 = cc.ParticleSystemQuad:create("item/laojunjindan-lizi.plist")
            myParticle1:setPosition(self:getPosition())
            self.particleNode_:addChild(myParticle1)
            self:addChild(self.particleNode_,0)
            local positionSpiritCounter = cc.p(display.getRunningScene().spiritCounter_:getPosition())
            myParticle1:runAction(transition.sequence({cc.MoveTo:create(0.5, positionSpiritCounter),
            cc.DelayTime:create(1.0),
            cc.CallFunc:create(function()
                myParticle1:removeSelf()
            end)}))
            
            if( GameManager.TANGMONK_LEVEL < 8 ) then
                --更新唐僧等级
                self.labelLevel_:setString(string.format("%d",GameManager.TANGMONK_LEVEL))
                --更新下一级升级消耗灵气值
                self.labelSpirit_:setString(string.format("%d",GameManager.TANGMONK_LEVEL * self.spiritCostBasic_))
            else
                -- 8级 max
                self:maxLevel()
            end
        end
    end
end

function UpgradeBtn:maxLevel()
	self:removeChild(self.labelLevel_)
	self:removeChild(self.labelSpirit_)
	display.newSprite("gamescene/level_max.png",39,62):addTo(self)
end

return UpgradeBtn

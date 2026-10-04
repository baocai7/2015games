
-- GameSceneGroove 中 左下角唐僧升级按钮

local UpgradeBtn = class("UpgradeBtn", function()
    return display.newNode()
end)

function UpgradeBtn:ctor()
    self:init()
end

function UpgradeBtn:init()
    --
    local sprite = display.newSprite("gamescene/upgrade.png"):addTo(self)
    self:setContentSize(sprite:getContentSize())
    --动画缓存
    display.addSpriteFrames("animation/upgrade_spirit.plist", "animation/upgrade_spirit.png")
    -- 图形
    self.figureSprite_ = display.newSprite("#upgrade_spirit1.png",-9,0):addTo(self)
    --self.graySprite_ = display.newSprite("gamescene/gray_upgrade_spirit.png",-9,0):addTo(self,1)
    
    -- level 标签 1 ~ 8 
    display.newSprite("gamescene/level.png",-30,60):addTo(self)
    self.labelLevel_ = cc.ui.UILabel.new({
        UILabelType = 1,text = string.format("%d",GameManager.TANGMONK_LEVEL),font = "fonts/yellowNum.fnt"})
        :align(display.CENTER, 30,62)
        :addTo(self)
    self.labelLevel_:setScale(0.8)
    -- 灵气消耗标签 : 40 80 160...
    local levelSpiritGrowSpeed = DataUtils.getPropertyLevel(5)
    self.spiritCostBasic_ = DataUtils.getSpiritCostBasic(levelSpiritGrowSpeed)
end


function UpgradeBtn:upgrade()

    if ( GameManager.TANGMONK_LEVEL < 8) then
        
        --卡槽模式下升级不需要计算灵气
        --if ( GameManager.CURRENT_SPIRIT >= GameManager.TANGMONK_LEVEL * self.spiritCostBasic_ ) then
        if GameManager.SOUND_SWITCH_ON then    
			audio.playSound(string.format("sounds/sfx_lq_upgrade.%s",GameManager.POSTFIX))
		end
		  -- 这边被注释掉
            --GameManager.CURRENT_SPIRIT = GameManager.CURRENT_SPIRIT - GameManager.TANGMONK_LEVEL * self.spiritCostBasic_
--            local currentSpirit = GameManager.getCurrentSpirit()
--            GameManager.setCurrentSpirit(currentSpirit + self.spiritAdd_ or 0)
        --这边被注释掉
            GameManager.TANGMONK_LEVEL = GameManager.TANGMONK_LEVEL + 1

            Game.SPIRIT_COUNTER:reInit()

            --todo 让右上角灵气计数器闪烁两次 加 飘粒子效果
            
            if( GameManager.TANGMONK_LEVEL < 8 ) then
                --更新唐僧等级
                self.labelLevel_:setString(string.format("%d",GameManager.TANGMONK_LEVEL))
            else
                -- 8级 max
                self:maxLevel()
            end
        --end
    end
end

function UpgradeBtn:maxLevel()
	self:removeChild(self.labelLevel_)
    self:removeChild(self.labelSpirit_)
	display.newSprite("gamescene/level_max.png",39,62):addTo(self)
end

return UpgradeBtn

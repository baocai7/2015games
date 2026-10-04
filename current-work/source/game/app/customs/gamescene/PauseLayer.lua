
local PauseLayer = {} 
PauseLayer = class("PauseLayer", function()
    return display.newLayer()
end)

function PauseLayer:ctor()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
    end
	
    --添加遮罩层
    display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

    --初始化基础节点
    self.nodeThis_ = display.newNode()
    self.nodeThis_:setPosition(display.cx,display.cy)
    self:addChild(self.nodeThis_)

    --弹出效果
    self.nodeThis_:setScale(0)
    local popupSeq = transition.sequence({cc.ScaleTo:create(0.2, 1.1),
            cc.ScaleTo:create(0.1, 1.0)})
    self.nodeThis_:runAction(popupSeq)

    --init
    self:init()
end

function PauseLayer:init()
    --背景
    local bg = display.newSprite("gamescene/bg_pause.png")
    self.nodeThis_:addChild(bg)

    -- 继续按钮
    cc.ui.UIPushButton.new({normal = "gamescene/continue.png",pressed = "gamescene/continue1.png"})
        :onButtonClicked(function()
            if 2.0 == display.getRunningScene().timeScale_ then
                --如果玩家开启了2倍速，则恢复2倍速
                cc.Director:getInstance():getScheduler():setTimeScale(2.0)
            end
            operateAllSchedulerAndActions(display.getRunningScene(),"RESUME")
            self:closeDialog()
        end)
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.63)
        :addTo(bg,2)
    
    -- 退出
    cc.ui.UIPushButton.new({normal = "gamescene/exit.png",pressed = "gamescene/exit1.png"})
        :onButtonClicked(function()
			if GameManager.SOUND_SWITCH_ON then
				audio.stopMusic()
				audio.playSound(string.format("sounds/sfx_touch.%s",GameManager.POSTFIX))
			end
            cc.Director:getInstance():getScheduler():setTimeScale(1.0)

            --DataEye统计关卡
            if USE_DATAEYE then  
                DCLevels.fail(CloudData.STAGE_PROGRESS .. "", "exit fighting")               
            end
            display.replaceScene(require("scenes.TinyLoadingScene").new("CHAPTER_SCENE"))
            end)
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.35)
        :addTo(bg,2)
end

function PauseLayer:closeDialog()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
	end
	
    local closeSeq = transition.sequence({
        cc.ScaleTo:create(0.1, 1.1),
        cc.ScaleTo:create(0.2, 0.0),
        cc.CallFunc:create(function()
            self:removeSelf()
        end),
    })
    self.nodeThis_:runAction(closeSeq)
end


return PauseLayer
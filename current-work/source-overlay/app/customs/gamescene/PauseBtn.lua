
-- GameScene 中 左上角暂停按钮

local PauseLayer = import("customs.gamescene.PauseLayer")

local PauseBtn = {} 
PauseBtn = class("PauseBtn", function()
    return display.newNode()
end)

function PauseBtn:ctor()
    self:init()
end

function PauseBtn:init()

    local sprite = display.newSprite("gamescene/pause.png"):addTo(self)
    self:setContentSize(sprite:getContentSize())

    --点击事件
    sprite:setTouchEnabled(true) -- enable sprite touch
    sprite:setTouchSwallowEnabled(true)
    sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y, prevX, prevY = event.name, event.x, event.y, event.prevX, event.prevY
        if name == "began" then
            sprite:setScale(0.9)
            return true
        end
        
        local touchInSprite = cc.rectContainsPoint(sprite:getCascadeBoundingBox(), cc.p(x, y))
        
        if name == "moved" then
            sprite:setScale(0.9)
        elseif name == "ended" then
            sprite:setScale(1.0)
            if touchInSprite then
                if 2.0 == display.getRunningScene().timeScale_ then
                	--暂时恢复1.0
                	cc.Director:getInstance():getScheduler():setTimeScale(1.0)
                end
            
                operateAllSchedulerAndActions(display.getRunningScene(),"PAUSE")

                 -- BAIDU 品宣广告
                if BAIDU_PROMOTION then                    
                    local javaClassName = "org/cocos2dx/lua/AppActivity"
                    local javaMethodName = "pauseBaidu"
                    local javaParams = {}
                    local javaMethodSig = "()V"
                    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
                end 

                local pauseLayer = PauseLayer.new()
                display.getRunningScene():addChild(pauseLayer,10)
            end
        else
            sprite:setScale(1.0)
        end
    end)
end

-- flag "PAUSE"暂停 "RESUME"恢复
function operateAllSchedulerAndActions( node, flag )
	
    if node:isRunning() then
		if flag == "PAUSE" then
            node:pause()
		elseif flag == "RESUME" then
            node:resume()
		end
	end
	
    for i, childNode in pairs(node:getChildren()) do
        operateAllSchedulerAndActions(childNode, flag)
	end
end


return PauseBtn
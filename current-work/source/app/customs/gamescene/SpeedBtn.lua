
-- GameScene 中上方切换二倍速度按钮

local SpeedBtn = {}
SpeedBtn = class("SpeedBtn", function()
    return display.newNode()
end)

function SpeedBtn:ctor()

    self.sprite_ = display.newSprite("gamescene/speed1.png"):addTo(self)
    self:setContentSize(self.sprite_:getContentSize())

    --点击事件
    self.sprite_:setTouchEnabled(true) -- enable sprite touch
    self.sprite_:setTouchSwallowEnabled(true)
    self.sprite_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y, prevX, prevY = event.name, event.x, event.y, event.prevX, event.prevY
        if name == "began" then
            return true
        end

        local touchInSprite = cc.rectContainsPoint(self.sprite_:getCascadeBoundingBox(), cc.p(x, y))

        if name == "moved" then

        end
        if name == "ended" then
            if touchInSprite then
                self:onPressed()
            end

        else

        end
    end)
end

function SpeedBtn:onPressed()

    if 1.3 == display.getRunningScene().timeScale_ then
        cc.Director:getInstance():getScheduler():setTimeScale(2.0)
        display.getRunningScene().timeScale_ = 2.0
        self.sprite_:setTexture("gamescene/speed2.png")
    elseif 2.0 == cc.Director:getInstance():getScheduler():getTimeScale() then
        cc.Director:getInstance():getScheduler():setTimeScale(1.3)
        display.getRunningScene().timeScale_ = 1.3
        self.sprite_:setTexture("gamescene/speed1.png")
    end

end

return SpeedBtn
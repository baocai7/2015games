
--[[=============================================================================
#     FileName: TimerIcon.lua
#         Desc: 无尽模式计时器
#       Author: Hoo
#   LastChange: 2015-04-01 
#      History:
=============================================================================]]


local TimerIcon = {} 
TimerIcon = class("TimerIcon", function()
    return display.newNode()
end)

function TimerIcon:ctor(cleanTime)
    
    self:initData_()
    
    self:initUI_(cleanTime)  
end

-- 初始化数据
function TimerIcon:initData_()
    self.minutes_ = 0              -- 分
    self.seconds_ = 0              -- 秒
end

-- 初始化UI
function TimerIcon:initUI_(cleanTime)
    -- 倒计时边框
    local timeFrame = display.newSprite("gamescene/timer.png",0,0)
        :addTo(self)
    -- 倒计时标签
    self.timeLabel_ = cc.ui.UILabel.new({UILabelType = 1,text = string.format("%02d:%02d",self.minutes_,self.seconds_),
        font = "fonts/yellowNum.fnt"})
        :scale(0.75)
        :align(display.CENTER_LEFT,timeFrame:getContentSize().width * 1.1,timeFrame:getContentSize().height * 0.5)
        :addTo(timeFrame)

    -- 开始倒计时
    self:startCountDown_(cleanTime)
end

-- 开始倒计时
function TimerIcon:startCountDown_(time)
    if time == 0 then
        self:countdownOver_()
    else
        -- 转换时分秒
        self.minutes_ = math.floor(time / 60)
        self.seconds_ = math.floor(time - self.minutes_ * 60)

        -- 倒计时
        self.scheduleTime_ = self:schedule(function()
            self:updateTime_()
        end, 1.0)
    end 
end
-- 时间更新
function TimerIcon:updateTime_()
    if self.seconds_ > 0 then
        self.seconds_ = self.seconds_ - 1
    else
        if self.minutes_ > 0 then
            self.seconds_ = 59
            self.minutes_ = self.minutes_ - 1
        else
            self:countdownOver_()
        end
    end

    -- todo:倒计时标签刷新  
    self.timeLabel_:setString(string.format("%02d:%02d",self.minutes_,self.seconds_))
end
-- 倒计时结束
function TimerIcon:countdownOver_()
    -- 停止计时器
    self:stopAction(self.scheduleTime_)
    
    -- todo:逻辑处理 
    Game.TOWER_MONSTER.isLastFinished_ = true
    Game.TOWER_MONSTER.interrupted_ = false
    Game.TOWER_MONSTER:changeStrategyTo("strategyCleanMonster")
end

return TimerIcon
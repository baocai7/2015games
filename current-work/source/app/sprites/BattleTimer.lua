
--[[=============================================================================
#     FileName: BattleTimer.lua
#         Desc: 无尽模式计时器
#       Author: Hoo
#   LastChange: 2015-03-19 
#      History:
=============================================================================]]

local Monster                  = import("sprites.Monster")
local AlertConnection          = import("customs.AlertConnection")
local InfiniteModeResultLayer  = import("layers.InfiniteModeResultLayer")

local BattleTimer = {} 
BattleTimer = class("BattleTimer", function()
    return display.newNode()
end)

function BattleTimer:ctor()
    
    self:initData_()
    
    self:initUI_()
     
    self:schedule(function() 
        self:update()
    end,0.1)    
end

-- 初始化数据
function BattleTimer:initData_()
    -- 初始化infiniteStageModel
    self.infiniteStageModel_ = DataUtils.getInfiniteStageModel(CloudData.INFINITE_STAGE_PROGRESS)
    -- 读取该层的波次id
    self.waveIdTable_ = self.infiniteStageModel_.waveIdTable_

    -- 初始化monsterWaveModel
    self.monsterWaveModel_ = DataUtils.getMonsterWaveModel(self.waveIdTable_[Game.ROUND_NUM])

    self.minutes_ = 0              -- 分
    self.seconds_ = 0              -- 秒

    self.canMakeMonster_  = true    -- 当前是否可以出兵
    self.strategyInWave_  = 1       -- 当前波次的第N个策略
    self.indexInStrategy_ = 1       -- 记录当前策略执行到了第几步

    -- 初始默认策略1
    self:changeStrategyTo("strategy1")
end

-- 初始化UI
function BattleTimer:initUI_()
    -- 倒计时边框
    self.timeFrame_ = display.newSprite("game_infinite/time_frame.png",0,0)
        :addTo(self)
    -- 倒计时标签
    self.timeLabel_ = cc.ui.UILabel.new({UILabelType = 1,text = string.format("%02d:%02d",self.minutes_,self.seconds_),
        font = "fonts/yellowNum.fnt"})
        :scale(0.75)
        :align(display.CENTER,self.timeFrame_:getContentSize().width * 0.75,self.timeFrame_:getContentSize().height * 0.5)
        :addTo(self.timeFrame_)

    -- 开始倒计时
    self:startCountDown_(self.monsterWaveModel_.waveTime_)
end

-- 检测场上兵种情况
function BattleTimer:update()
    if self.canMakeMonster_ and self.strategyInWave_ <= 7 then
        self.canMakeMonster_ = false

        print("--------------after : "..self.curIntervalTime_)
        self:performWithDelay(function()      
            self:makeMonster()      
        end,self.curIntervalTime_) 
    end
end

-- 出兵策略更改
function BattleTimer:changeStrategyTo(strategyName)
    self.curStrategy_ = strategyName
    if "strategy1" == strategyName then
        print("进入策略1")
        self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable1_
        self.curIntervalTime_    = self.monsterWaveModel_.intervalTimeStrategy1_

    elseif "strategy2" == strategyName then
        print("进入策略2")
        self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable2_
        self.curIntervalTime_    = self.monsterWaveModel_.intervalTimeStrategy2_

    elseif "strategy3" == strategyName then
        print("进入策略3")
        self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable3_
        self.curIntervalTime_    = self.monsterWaveModel_.intervalTimeStrategy3_

    elseif "strategy4" == strategyName then
        print("进入策略4")
        self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable4_
        self.curIntervalTime_    = self.monsterWaveModel_.intervalTimeStrategy4_

    elseif "strategy5" == strategyName then
        print("进入策略5")
        self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable5_
        self.curIntervalTime_    = self.monsterWaveModel_.intervalTimeStrategy5_

    elseif "strategy6" == strategyName then
        print("进入策略6")
        self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable6_
        self.curIntervalTime_    = self.monsterWaveModel_.intervalTimeStrategy6_

    elseif "strategy7" == strategyName then
        print("进入策略7")
        self.curMonsterIdsTable_ = self.monsterWaveModel_.monsterIdsTable7_
        self.curIntervalTime_    = self.monsterWaveModel_.intervalTimeStrategy7_

    end
end

-- 出兵
function BattleTimer:makeMonster()

    -- 当前场上兵种达上限  self.monsterWaveModel_.monsterNumLimit_
    if #Game.MONSTER_TABLE > self.monsterWaveModel_.monsterNumLimit_ then
        print("=========== full!!! ===========")
        self.canMakeMonster_ = false
    	return
    end

    -- 获取兵种id
    local monsterId = tonumber(self.curMonsterIdsTable_[self.indexInStrategy_]) or 0
    print("monsterId : "..monsterId)

    -- 出兵
    if monsterId > 0 then
        print(self.curStrategy_.."    "..self.indexInStrategy_.." 出兵 ： "..monsterId)
        local monsterModel = DataUtils.getInfiniteMonsterModel(monsterId)
        local monster = Monster.new(monsterModel, cc.p(Game.TOWER_MONSTER:getPositionX() + 70,display.height * 0.2))
        Game.BG1:addChild(monster, monster.zOrder_)
        Game.MONSTER_TABLE[#Game.MONSTER_TABLE + 1] = monster
    end
    
    -- 当前策略执行步骤+1
    self.indexInStrategy_ = self.indexInStrategy_ + 1
    
    -- 策略执行完成
    if ( monsterId <= 0 or self.indexInStrategy_ > #self.curMonsterIdsTable_ ) then

        -- 执行下一个策略
        self.strategyInWave_ = self.strategyInWave_ + 1

        -- 策略步数还原
	    self.indexInStrategy_ = 1

        if self.strategyInWave_ == 2 then
            self:changeStrategyTo("strategy2")
        elseif self.strategyInWave_ == 3 then
            self:changeStrategyTo("strategy3")
        elseif self.strategyInWave_ == 4 then
            self:changeStrategyTo("strategy4")
        elseif self.strategyInWave_ == 5 then
            self:changeStrategyTo("strategy5")
        elseif self.strategyInWave_ == 6 then
            self:changeStrategyTo("strategy6")
        elseif self.strategyInWave_ == 7 then
            self:changeStrategyTo("strategy7")
        else
            -- 当前波次结束
            self:countdownOver_()
        end   
    end
    
    -- 可以继续出兵
    self.canMakeMonster_ = true
end

-- 开始倒计时
function BattleTimer:startCountDown_(time)
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
function BattleTimer:updateTime_()
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
function BattleTimer:countdownOver_()
    -- 停止计时器
    self:stopAction(self.scheduleTime_)
    
    -- todo:逻辑处理 
    Game.ROUND_NUM = Game.ROUND_NUM + 1

    print(string.format("==========第%d波===========",Game.ROUND_NUM))

    if Game.ROUND_NUM > #self.waveIdTable_ then        
        -- 出兵结束
        Game.MONSTER_WAVE_OVER = true
        
        return
    end

    -- 战斗场景“第N波”标签更改
    self:getParent().roundNumLabel_:setString(Game.ROUND_NUM)

    -- 下一波model
    self.monsterWaveModel_ = DataUtils.getMonsterWaveModel(self.waveIdTable_[Game.ROUND_NUM])

    -- 进入策略1
    self:changeStrategyTo("strategy1")

    -- 重新倒计时
    self:startCountDown_(self.monsterWaveModel_.waveTime_)

    -- 最后一波，隐藏计时器
    if Game.ROUND_NUM == #self.waveIdTable_ then
        self.timeLabel_:setVisible(false)
        self.timeFrame_:setTexture("game_infinite/last_wave.png")
    end

    -- 波次提示动画
    self:getParent():waveAction()

    -- 数据还原
    self.strategyInWave_  = 1      
    self.indexInStrategy_ = 1  
end

return BattleTimer

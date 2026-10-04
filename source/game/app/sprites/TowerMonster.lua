
local Buddha                   = import("sprites.Buddha")
local Monster                  = import("sprites.Monster")
local AlertConnection          = import("customs.AlertConnection")
local WarResultLayer           = import("layers.WarResultLayer")
local CommonResultLayer        = import("layers.CommonResultLayer")
local InfiniteModeResultLayer  = import("layers.InfiniteModeResultLayer")

local TowerMonster = {} 
TowerMonster = class("TowerMonster", function()
    return display.newNode()
end)

function TowerMonster:ctor(towerMonsterModel)
    if towerMonsterModel == "infiniteMode" then           -- isInfiniteMode: 无尽模式
        self.isInfiniteMode_ = true
        -- 塔血量
        self.hpMax_ = Game.MONSTER_TOWER_LIFE
        self.hpCur_ = self.hpMax_

        self:initExtra() 
    else
        self.isInfiniteMode_ = false

        self:initData(towerMonsterModel)
    
        self:initExtra()
        
        self.isLastFinished_ = true
        self.isLastFinishedSp_  = true
        self:changeStrategyTo("strategy1")
        
        self:schedule(function() 
            self:update()
        end,0.1)
        
        self:schedule(function() 
            self:updateSp()
        end,0.1)
    end  
end


function TowerMonster:initData(towerMonsterModel)

    self.model_ = towerMonsterModel
    towerMonsterModel = nil

    self.times_ = 0
    self.indexInStrategy_ = 1

    self.hpMax_ = self.model_.life_
    self.hpCur_ = self.hpMax_

    self.interrupted_ = false
    self.isStrategy99Excuted_ = false
    self.isStrategy50Excuted_ = false
    self.isStrategy20Excuted_ = false

end


function TowerMonster:initExtra()
    --初始化防御塔外形
    if self.isInfiniteMode_ then
        self:initTowerImageFigure(14)      -- 指定塔类型
    else
        self:initTowerImageFigure(tonumber(self.model_.towerType_))
    end

    --血量进度条
    local barBg = display.newSprite("gamescene/bar_bg_tower_m.png",self.towerBg_:getContentSize().width * 0.5,self.towerBg_:getContentSize().height * 1.15)
        :addTo(self.towerBg_)
    -- progressbar
    self.progressTimer_ = cc.ProgressTimer:create(display.newSprite("gamescene/bar_hp_tower_m.png")):addTo(barBg)
    self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progressTimer_:setPosition(barBg:getContentSize().width/2,barBg:getContentSize().height/2)
    self.progressTimer_:setMidpoint(cc.p(0,0))
    self.progressTimer_:setBarChangeRate(cc.p(1,0))
    self.progressTimer_:setPercentage(100)

    if not self.isInfiniteMode_ then
        --敌方塔血量标签
        self.towerBloodLabel_ = cc.ui.UILabel.new({
            UILabelType = 2,text = string.format("%d/%d",self.hpCur_,self.hpMax_),size = 20})
            :align(display.CENTER,barBg:getContentSize().width * 0.5,barBg:getContentSize().height * 0.5)
            :addTo(barBg,1)
    end
end

--改变策略
function TowerMonster:changeStrategyTo( name )

    self.curStrategy_ = name

	if "strategy1" == name then
	    print("进入策略1")
        self.curMonsterIdsTable_ = self.model_.monsterIdsTable1_
        self.curIntervalTime_ = self.model_.intervalTimeStrategy1_
    elseif "strategy2" == name then
        print("进入策略2")
        self.curMonsterIdsTable_ = self.model_.monsterIdsTable2_
        self.curIntervalTime_ = self.model_.intervalTimeStrategy2_
    elseif "strategy3" == name then
        print("进入策略3")
        self.curMonsterIdsTable_ = self.model_.monsterIdsTable3_
        self.curIntervalTime_ = self.model_.intervalTimeStrategy3_
    elseif "repeatStrategy1" == name then
        print("重复策略1")
        self.curMonsterIdsTable_ = self.model_.monsterIdsTableRepeat1_
        self.curIntervalTime_ = self.model_.intervalTimeRP1_
    elseif "repeatStrategy2" == name then
        print("重复策略2")
        self.curMonsterIdsTable_ = self.model_.monsterIdsTableRepeat2_
        self.curIntervalTime_ = self.model_.intervalTimeRP2_
    elseif "strategyCleanMonster" == name then
        print("清场怪")
        self.curMonsterIdsTable_ = self.model_.cleanMonsterIdsTable_
        self.curIntervalTime_ = self.model_.intervalTimeClean_
    end
end

--
function TowerMonster:update()
    
    if not self.isLastFinished_ or self.interrupted_ then
        return
    end

    -- 可以继续出怪了
    self.isLastFinished_ = false
    print("after "..self.curIntervalTime_)
    
    -- 出兵
    self:performWithDelay(function()      
        self:makeMonster()      
    end, self.curIntervalTime_)  
end

--
function TowerMonster:updateSp()

    local hp = self.hpCur_/self.hpMax_
    
    if not self.isStrategy99Excuted_ and hp <= 0.99 and hp > 0.5 then
        self.isStrategy99Excuted_ = true
        print("特殊策略99")
        self.interrupted_ = true      
        self.indexInStrategySp_ = 1
        self.curMonsterIdsTableSp_ = self.model_.monsterIdsTable99_
        self.curIntervalTimeSp_ = self.model_.intervalTime99_
    end
    
    if not self.isStrategy50Excuted_ and hp <= 0.5 and hp > 0.2 then
        self.isStrategy50Excuted_ = true
        print("特殊策略50")
        self.interrupted_ = true
        self.indexInStrategySp_ = 1
        self.curMonsterIdsTableSp_ = self.model_.monsterIdsTable50_
        self.curIntervalTimeSp_ = self.model_.intervalTime50_
    end

    if not self.isStrategy20Excuted_ and hp < 0.2 then
        self.isStrategy20Excuted_ = true
        print("特殊策略20")
        self.interrupted_ = true
        self.indexInStrategySp_ = 1
        self.curMonsterIdsTableSp_ = self.model_.monsterIdsTable20_
        self.curIntervalTimeSp_ = self.model_.intervalTime20_
    end
    
    if not self.interrupted_ then
        return
    end 

    if not self.isLastFinishedSp_ then 
        return
    end

    -- 可以继续出怪了
    self.isLastFinishedSp_ = false
    print("sp after "..self.curIntervalTimeSp_)
    
    -- 出兵
    self:performWithDelay(function()      
        self:makeMonsterSp()      
    end,self.curIntervalTimeSp_)  
end

--普通策略出兵 123 & 重复12
function TowerMonster:makeMonster()

    print("----------------------------")
    if #Game.MONSTER_TABLE >= tonumber(self.model_.monsterNumLimit_) then
        print("full")
        self.isLastFinished_ = true
    	return
    end

    local monsterId = tonumber(self.curMonsterIdsTable_[self.indexInStrategy_])
    print("monsterId : "..monsterId)

    if monsterId > 0 then
        print(self.curStrategy_.."    "..self.indexInStrategy_.." 出兵 ： "..monsterId)
        local monsterModel = DataUtils.getMonsterModel(monsterId)
        local monster = Monster.new(monsterModel, cc.p(self:getPositionX() + 30,self:getPositionY()))
        Game.BG1:addChild(monster, monster.zOrder_)
        Game.MONSTER_TABLE[#Game.MONSTER_TABLE + 1] = monster

        -- 开门，关门
        local doorOpen = cc.CallFunc:create(function()
            self:openDoor()
        end)
        local doorClose = cc.CallFunc:create(function()
            self:closeDoor()
        end)
        self:runAction(transition.sequence({doorOpen,cc.DelayTime:create(1.0),doorClose}))
    end
    
    self.indexInStrategy_ = self.indexInStrategy_ + 1
    
    -- 策略执行完成
    if ( monsterId <= 0 or self.indexInStrategy_ > #self.curMonsterIdsTable_ ) then
	   
	   self.times_ = self.times_ + 1
       self.indexInStrategy_ = 1

       if self.times_ == 1 then
           self:changeStrategyTo("strategy2")
       elseif self.times_ == 2 then
           self:changeStrategyTo("strategy3")
       elseif self.times_ >= 3 and self.times_ % 2 == 1 then
            self:changeStrategyTo("repeatStrategy1")
       elseif self.times_ >= 3 and self.times_ % 2 == 0 then
           self:changeStrategyTo("repeatStrategy2")
       end
    end
    
    --
    self.isLastFinished_ = true
end


--特殊策略 99 50 20
function TowerMonster:makeMonsterSp()
    print("----------------------------")

    local monsterId = tonumber(self.curMonsterIdsTableSp_[self.indexInStrategySp_])
    print("sp monsterId : "..monsterId)
    
    if monsterId > 0 then
        print(self.curStrategy_.."  特殊  "..self.indexInStrategySp_.." 出兵 ： "..monsterId)
        local monsterModel = DataUtils.getMonsterModel(monsterId)
        local monster = Monster.new(monsterModel, cc.p(self:getPositionX() + 30,self:getPositionY()))
        Game.BG1:addChild(monster, monster.zOrder_)
        Game.MONSTER_TABLE[#Game.MONSTER_TABLE + 1] = monster

        -- 开门，关门
        local doorOpen = cc.CallFunc:create(function()
            self:openDoor()
        end)
        local doorClose = cc.CallFunc:create(function()
            self:closeDoor()
        end)
        self:runAction(transition.sequence({doorOpen,cc.DelayTime:create(1.0),doorClose}))
    end
    
    self.indexInStrategySp_ = self.indexInStrategySp_ + 1
    
    -- 策略执行完成
    if ( monsterId <= 0 or self.indexInStrategySp_ > #self.curMonsterIdsTableSp_ ) then
       
       if self.curStrategy_ == "strategy1" then
           self:changeStrategyTo("strategy1")
       elseif self.curStrategy_ == "strategy2" then
           self:changeStrategyTo("strategy2")
       elseif self.curStrategy_ == "strategy3" then
           self:changeStrategyTo("strategy3")
       elseif self.curStrategy_ == "repeatStrategy1" then
           self:changeStrategyTo("repeatStrategy1")
       elseif self.curStrategy_ == "repeatStrategy2"then
           self:changeStrategyTo("repeatStrategy2")
       end
       
       self.interrupted_ = false
    end
    
    --
    self.isLastFinishedSp_ = true
end


--
function TowerMonster:initTowerImageFigure(towerType)
    if towerType == 0 then      --李畅画的最原始的洞穴
        --没有用到门，但是门负责出兵，所以留了空图
        self.door_ = display.newSprite("animation/first.png"):addTo(self,-3)
        self.door_:setAnchorPoint(cc.p(0.5,0))
        self.door_:setScale(0.4)

        --洞口的发光物:黑底
        self.dark_ = display.newSprite("gamescene/tower_enemy_0.png"):addTo(self,-2)
        self.dark_:setAnchorPoint(cc.p(0.5,0))
        self.dark_:setScale(0.4)
        --洞口的发光物:绿光
        self.light_ = display.newSprite("gamescene/tower_enemy_1.png"):addTo(self,-1)
        self.light_:setAnchorPoint(cc.p(0.5,0))
        self.light_:setScale(0.4)
        self.light_:runAction(cc.RepeatForever:create(transition.sequence({cc.FadeIn:create(1.5),cc.FadeOut:create(1.5)})))

        --防御塔背景
        self.towerBg_ = display.newSprite("gamescene/tower_enemy_2.png"):addTo(self,0)
        self.towerBg_:setAnchorPoint(cc.p(0.5,0))
        self.towerBg_:setScale(0.4)

        --光环
        self.halo_ = display.newSprite("gamescene/tower_enemy_3.png"):addTo(self,1)
        self.halo_:setAnchorPoint(cc.p(0.5,0))
        self.halo_:setScale(0.4)
        self.halo_:runAction(cc.RepeatForever:create(transition.sequence({cc.FadeIn:create(1.5),cc.FadeOut:create(1.5)})))

    elseif towerType == 6 or towerType == 8 then       --旋转光圈洞穴 6,8
        self.door_ = display.newSprite("animation/first.png"):addTo(self,-3)
        self.door_:setAnchorPoint(cc.p(0.5,0))
        self.door_:setScale(0.4)

        --底层精灵
        self.backBg_ = display.newSprite(string.format("monster_tower/"..towerType.."/back.png")):addTo(self,-2)
        self.backBg_:setAnchorPoint(cc.p(0.5,0))
        self.backBg_:setScale(0.4)

        --光环
        self.halo_ = display.newSprite(string.format("monster_tower/"..towerType.."/halo.png"))
        self.halo_:setAnchorPoint(cc.p(0.5,0.5))
        if towerType == 6 then
            self.halo_:setPosition(cc.p(self.backBg_:getContentSize().width * 0.475,self.backBg_:getContentSize().height * 0.34))
        else
            self.halo_:setPosition(cc.p(self.backBg_:getContentSize().width * 0.5,self.backBg_:getContentSize().height * 0.35)) 
        end
        self.halo_:runAction(cc.RepeatForever:create(cc.RotateBy:create(0.5,90)))
        self.backBg_:addChild(self.halo_)

        --防御塔背景
        self.towerBg_ = display.newSprite(string.format("monster_tower/"..towerType.."/front.png")):addTo(self,0)
        self.towerBg_:setAnchorPoint(cc.p(0.5,0))
        self.towerBg_:setScale(0.4)
    
    elseif towerType == 12 then
        self.door_ = display.newSprite("animation/first.png"):addTo(self,-3)
        self.door_:setAnchorPoint(cc.p(0.5,0))
        self.door_:setScale(0.4)
        
        --防御塔背景
        self.towerBg_ = display.newSprite(string.format("monster_tower/"..towerType.."/bg.png")):addTo(self,1)
        self.towerBg_:setAnchorPoint(cc.p(0.5,0))
        self.towerBg_:setScale(0.4)

    elseif towerType == 13 then
         --防御塔背景
        self.towerBg_ = display.newSprite(string.format("monster_tower/"..towerType.."/bg.png")):addTo(self,1)
        self.towerBg_:setAnchorPoint(cc.p(0.5,0))
        self.towerBg_:setScale(0.4)

        --底层精灵
        self.backBg_ = display.newSprite("monster_tower/"..towerType.."/door.png"):addTo(self,-1)
        self.backBg_:setAnchorPoint(cc.p(0.5,0))
        self.backBg_:setScale(0.4)
        
        --上门
        self.door_ = display.newSprite(string.format("monster_tower/"..towerType.."/door1.png")):addTo(self,0)
        self.door_:setAnchorPoint(cc.p(0.5,0))
        self.door_:setScale(0.4)

        --下门
        self.door1_ = display.newSprite(string.format("monster_tower/"..towerType.."/door2.png")):addTo(self,0)
        self.door1_:setAnchorPoint(cc.p(0.5,0))
        self.door1_:setScale(0.4)  

    elseif towerType == 14 then
        -- 防御塔背景
        self.towerBg_ = display.newSprite(string.format("monster_tower/"..towerType.."/bg.png"),0,-30):addTo(self,1)
        self.towerBg_:setAnchorPoint(cc.p(0.5,0))
        self.towerBg_:setScale(0.4)

        -- 塔内部旋转光圈
        self.door_ = display.newSprite(string.format("monster_tower/"..towerType.."/door.png"),
            self.towerBg_:getContentSize().width * 0.5,self.towerBg_:getContentSize().height * 0.63)
            :addTo(self.towerBg_)
        self.door_:runAction(cc.RepeatForever:create(cc.RotateBy:create(0.5,360)))
    else
        --防御塔背景
        self.towerBg_ = display.newSprite(string.format("monster_tower/"..towerType.."/bg.png")):addTo(self,0)
        self.towerBg_:setAnchorPoint(cc.p(0.5,0))
        self.towerBg_:setScale(0.4)
      
        --门
        self.door_ = display.newSprite("monster_tower/"..towerType.."/door.png"):addTo(self,1)
        self.door_:setAnchorPoint(cc.p(0.5,0))
        self.door_:setScale(0.4)
        self.door_:setVisible(false)
    end
end

function TowerMonster:underAttack( loseHp )
    if not Game.END then
        --被攻击效果 变色 抖动 灰尘
        self:hurtEffect()
        
        self.hpCur_ = self.hpCur_ - loseHp
        if self.hpCur_ <= 0 then
            if not self.isInfiniteMode_ then
                self.towerBloodLabel_:setString(string.format("0/%d",self.hpMax_))
            end
            self.progressTimer_:setPercentage(0)
            self:dead()
            return
        end
        -- 血量标签
        if not self.isInfiniteMode_ then
            self.towerBloodLabel_:setString(string.format("%d/%d",self.hpCur_,self.hpMax_))
        end
        self.progressTimer_:setPercentage(self.hpCur_/self.hpMax_ * 100)
    end
end

function TowerMonster:hurtEffect()
    -- 变色
    if not self.isInTint_ then
        self.isInTint_ = true
        local tint = cc.TintTo:create(0.0,243,83,7)
        local tintBack = cc.TintTo:create(0.0,255,255,255)
        local dt = cc.DelayTime:create(0.4)
        self.towerBg_:runAction(transition.sequence({tint,dt,tintBack,cc.CallFunc:create(function()
            self.isInTint_ = false
        end)}))
    end
    
    --抖动
    if not self.isInShake_ then
        self.isInShake_ = true
        local m1 = cc.MoveBy:create(0.1,cc.p(-3,0))
        local m2 = cc.MoveBy:create(0.1,cc.p(3,0))
        self:runAction(transition.sequence({m1,m2,m1,m2,cc.CallFunc:create(function()
            self.isInShake_ = false
        end)}))
    end

    --打斗灰尘
    local frames = display.newFrames("dadouyanwu%d.png", 1, 7)
    local animation = display.newAnimation(frames, 0.1)
    local sp = display.newSprite()
    sp:setAnchorPoint(cc.p(0.5,0))
    self:addChild(sp)
    sp:playAnimationOnce(animation,true)
end

function TowerMonster:dead()
    Game.END = true

    -- 默认 1倍速
    cc.Director:getInstance():getScheduler():setTimeScale(1.0)

    -- 关闭自动出兵,防止网络连接异常时还能出兵
    for i=1,#Game.TEAM_ICON do
        local teamIcon = Game.TEAM_ICON[i]
        teamIcon:changeAutoMode(-100)
    end

    -- 战斗结束时我方塔血量，若为0则是作弊，判定为失败
    local isSuccess = 1
    if Game.TOWER_BUDDHA.hpCur_ <= 0 then
        isSuccess = 0
    else
        isSuccess = 1
    end
    
    if Game.MODE == "NORMAL" then
        local buyProp = json.encode(Game.SKILL_ITEM_BUY)
        dump(buyProp)
        local useProp = json.encode(Game.SKILL_ITEM_USE)
        dump(useProp)

        -- 队伍信息
        local buddhaOnTeamTable = DataUtils.getBuddhaTableOnTeam()
        local teamInfoTable   = {}
        for i, buddhaId in pairs(buddhaOnTeamTable) do
            if buddhaId ~= "" then
                local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
                local tempTable = {}
                tempTable["npcId"]    = buddhaId
                tempTable["level"]    = buddhaModel.level_
                tempTable["addLevel"] = buddhaModel.addLevel_
                table.insert(teamInfoTable,tempTable)
            end
        end

        local alertConnection = AlertConnection.new(CONNECTION_PASS_STAGE,GameManager.STAGE_NUM,isSuccess,buyProp,useProp,teamInfoTable)
        display.getRunningScene():addChild(alertConnection,100,12345)

        self.scheduleResult_ = self:schedule(function()
            if not display.getRunningScene():getChildByTag(12345) then
                self:stopAction(self.scheduleResult_)

                -- 暂停游戏
                operateAllSchedulerAndActions( display.getRunningScene(), "PAUSE" )

                -- 战斗结果
                if isSuccess == 1 then      -- 胜利
                    local wrl = WarResultLayer.new( RESULT_TYPE_WIN )
                    display.getRunningScene():addChild(wrl,20)
                    --进度+1
                    if CloudData.STAGE_PROGRESS < GameManager.STAGE_NUM then
                        CloudData.STAGE_PROGRESS = CloudData.STAGE_PROGRESS + 1

                        --DataEye统计关卡
                        if CloudData.STAGE_PROGRESS == 1 and USE_DATAEYE then
                            --开启第一章主线任务                     
                            DCTask.begin("stagetask1", DC_MainLine)
                            --开启第一章支线任务
                            for i = 1, 7 do
                                DCTask.begin("stagetask1_subtask" .. i, DC_BranchLine)
                            end 
                            --开启成就                             
                            DCTask.begin("recharge1", DC_Other)
                            DCTask.begin("peach_used_num1", DC_Other)
                            DCTask.begin("unlock_buddha_num1", DC_Other)
                            DCTask.begin("level10_buddha_num1", DC_Other)
                            DCTask.begin("level20_buddha_num1", DC_Other)
                            DCTask.begin("exp_buy1", DC_Other)
                            DCTask.begin("level10_tower_property_num1", DC_Other)
                            DCTask.begin("lose_num1", DC_Other)
                            DCTask.begin("unlock_monster_num1", DC_Other)
                            DCTask.begin("stage_progress1", DC_Other)                                               
                        end
                    end 
                else                        -- 失败
                    local wrl = WarResultLayer.new( RESULT_TYPE_LOSE )
                    display.getRunningScene():addChild(wrl,20)
                end               
            end
        end, 0.1)
    elseif Game.MODE == "CHALLENGE" then
        local alertConnection = AlertConnection.new(CONNECTION_PASS_STAGE_CHALLENGE,GameManager.STAGE_NUM_CHALLENGE)
        display.getRunningScene():addChild(alertConnection,100,12345)

        self.scheduleResult_ = self:schedule(function()
            if not display.getRunningScene():getChildByTag(12345) then
                self:stopAction(self.scheduleResult_)

                -- 暂停游戏
                operateAllSchedulerAndActions( display.getRunningScene(), "PAUSE" )
                
                CloudData.CHALLENGE_PROGRESS = CloudData.CHALLENGE_PROGRESS + 1
                --
                print("挑战关 游戏胜利 ")
                --DataEye统计任务
                if USE_DATAEYE then             
                    DCTask.complete("Trial" .. (GameManager.STAGE_NUM_CHALLENGE))                   
                end
                local crl = CommonResultLayer.new(RESULT_TYPE_TRIAL_WIN)
                display.getRunningScene():addChild(crl,20)
            end
        end, 0.1)
    elseif Game.MODE == "DIARY" then
        local alertConnection = AlertConnection.new(CONNECTION_PASS_STAGE_DIARY,GameManager.STAGE_NUM_DIARY)
        display.getRunningScene():addChild(alertConnection,100,12345)

        self.scheduleResult_ = self:schedule(function()
            if not display.getRunningScene():getChildByTag(12345) then
                self:stopAction(self.scheduleResult_)

                -- 暂停游戏
                operateAllSchedulerAndActions( display.getRunningScene(), "PAUSE" )

                --
                print("日常关 游戏胜利 ")
                --DataEye统计任务
                if USE_DATAEYE then             
                    DCTask.complete("Diary" .. GameManager.STAGE_NUM_DIARY)                   
                end
                CloudData.DIARY_NUM_LEFT = CloudData.DIARY_NUM_LEFT - 1
                local crl = CommonResultLayer.new(RESULT_TYPE_DIARY_WIN)
                display.getRunningScene():addChild(crl,20)
            end
        end, 0.1)
    elseif Game.MODE == "ACTIVITY" then
        print("========= 活动关卡 : GAME WIN!!!==========")
        local buyProp = json.encode(Game.SKILL_ITEM_BUY)
        dump(buyProp)
        local useProp = json.encode(Game.SKILL_ITEM_USE)
        dump(useProp)

        -- 队伍信息
        local buddhaOnTeamTable = DataUtils.getBuddhaTableOnTeam()
        local teamInfoTable   = {}
        for i, buddhaId in pairs(buddhaOnTeamTable) do
            if buddhaId ~= "" then
                local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
                local tempTable = {}
                tempTable["npcId"]    = buddhaId
                tempTable["level"]    = buddhaModel.level_
                tempTable["addLevel"] = buddhaModel.addLevel_
                table.insert(teamInfoTable,tempTable)
            end
        end

        local alertConnection = AlertConnection.new(CONNECTION_ACTIVITY_STAGE_FINISH,GameManager.ACTIVITY_STAGE_TYPE,isSuccess,buyProp,useProp,teamInfoTable)
        display.getRunningScene():addChild(alertConnection,100,12335)

        self.scheduleResultA_ = self:schedule(function()
            if not display.getRunningScene():getChildByTag(12335) then
                self:stopAction(self.scheduleResultA_)

                -- 暂停游戏
                operateAllSchedulerAndActions( display.getRunningScene(), "PAUSE" )

                -- 战斗结果
                if isSuccess == 1 then    -- 胜利
                    local crl = CommonResultLayer.new(RESULT_TYPE_ACTIVITY_WIN)
                    display.getRunningScene():addChild(crl,20)
                else                      -- 失败
                    local crl = CommonResultLayer.new( RESULT_TYPE_COMMON_LOSE )
                    display.getRunningScene():addChild(crl,20)
                end         
            end
        end, 0.1)
    elseif Game.MODE == "INFINITE" then
        --todo:胜利结算
        print("========= INFINITE MODE : GAME WIN!!!==========")
        -- 道具结算
        local buyProp = json.encode(Game.SKILL_ITEM_BUY)
        -- dump(buyProp)
        local useProp = json.encode(Game.SKILL_ITEM_USE)
        -- dump(useProp)

        -- 队伍信息
        local buddhaOnTeamTable = DataUtils.getBuddhaTableOnTeam()
        local teamInfoTable   = {}
        for i, buddhaId in pairs(buddhaOnTeamTable) do
            if buddhaId ~= "" then
                local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
                local tempTable = {}
                tempTable["npcId"]    = buddhaId
                tempTable["level"]    = buddhaModel.level_
                tempTable["addLevel"] = buddhaModel.addLevel_
                table.insert(teamInfoTable,tempTable)
            end
        end

        local infiniteStageId = CloudData.INFINITE_STAGE_PROGRESS + 1      -- 每一层通关存储的进度为下一层0波
        local waveId          = 0
        local ac = AlertConnection.new(CONNECTION_INFINITE_RESULT,infiniteStageId,teamInfoTable,waveId,isSuccess,buyProp,useProp)
        display.getRunningScene():addChild(ac,101,11346)

        display.getRunningScene().scheduleResultInfinite_ = display.getRunningScene():schedule(function()
            if not display.getRunningScene():getChildByTag(11346) then
                display.getRunningScene():stopAction(display.getRunningScene().scheduleResultInfinite_)

                -- 默认 1倍速
                cc.Director:getInstance():getScheduler():setTimeScale(1.0)

                -- 暂停游戏
                operateAllSchedulerAndActions( display.getRunningScene(), "PAUSE" )

                -- 战斗结果
                if isSuccess == 1 then    -- 胜利
                    -- 最高纪录
                    CloudData.INFINITE_STAGE_PROGRESS = CloudData.INFINITE_STAGE_PROGRESS + 1
                    CloudData.INFINITE_WAVES_PROGRESS = 0

                    -- 胜利弹窗
                    local pLayer = InfiniteModeResultLayer.new(RESULT_TYPE_WIN)
                    display.getRunningScene():addChild(pLayer,100)
                else                      -- 失败
                    -- 最高纪录
                    CloudData.INFINITE_STAGE_PROGRESS = CloudData.INFINITE_STAGE_PROGRESS
                    if waveId >= CloudData.INFINITE_WAVES_PROGRESS  then
                        CloudData.INFINITE_WAVES_PROGRESS = waveId
                    end
                    
                    -- 失败弹窗
                    local pLayer = InfiniteModeResultLayer.new(RESULT_TYPE_LOSE)
                    display.getRunningScene():addChild(pLayer,100)
                end  
            end
        end,0.1)
    end
end

function TowerMonster:getMyBoundingBox()

    local position = cc.p(self:getPosition())
    local size = cc.size(self.towerBg_:getContentSize().width * 0.4, self.towerBg_:getContentSize().height * 0.4)
    local rect = cc.rect( position.x - size.width * 0.7,
        position.y,
        size.width,
        size.height)
    return rect
end

--开门
function TowerMonster:openDoor()
    if tonumber(self.model_.towerType_) == 13 then
        -- local pos = cc.p(self.backBg_:getContentSize().width * 0.5,self.backBg_:getContentSize().height * 0.35)
        -- local posX1 = self.door_:getPositionX() 
        -- local posY1 = self.door_:getPositionY()
        -- local posX2 = self.door1_:getPositionX() 
        -- local posY2 = self.door_:getPositionY()
        -- local move1 = cc.MoveTo:create(0.5,cc.p(0,18))
        -- local fun1 = self.door_:setVisible(false)
        -- local move2 = cc.MoveTo:create(0.5,cc.p(0,-18))
        -- local fun2 = self.door1_:setVisible(false)
        -- self.door_:runAction(transition.sequence({move1,fun1}))
        -- self.door1_:runAction(transition.sequence({move2,fun2}))
        self.door_:setVisible(false)
        self.door1_:setVisible(false)
    elseif self.door_ then
        self.door_:setVisible(true)
    end
end
--关门
function TowerMonster:closeDoor()
    if tonumber(self.model_.towerType_) == 13 then
        -- local pos = cc.p(self.towerBg_:getContentSize().width * 0.5,self.towerBg_:getContentSize().height * 0.35)
        -- local posX1 = self.door_:getPositionX() 
        -- local posY1 = self.door_:getPositionY()
        -- local posX2 = self.door1_:getPositionX() 
        -- local posY2 = self.door_:getPositionY()
        -- local move1 = cc.MoveTo:create(0.3,cc.p(0,0))
        -- local fun1 = self.door_:setVisible(true)
        -- local move2 = cc.MoveTo:create(0.3,cc.p(0,0))
        -- local fun2 = self.door1_:setVisible(true)
        -- self.door_:runAction(transition.sequence({move1,fun1}))
        -- self.door1_:runAction(transition.sequence({move2,fun2}))
        self.door_:setVisible(true)
        self.door1_:setVisible(true)
    elseif self.door_ then
        self.door_:setVisible(false)
    end
end

return TowerMonster
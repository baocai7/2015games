
local AlertConnection          = import("customs.AlertConnection")
local InfiniteModeResultLayer  = import("layers.InfiniteModeResultLayer")
local CompatTrace              = import("utils.CompatTrace")

local Monster = {}
Monster = class("Monster", function()
    return display.newNode()
end)

function Monster:ctor( monsterModel, position )

    self:initData( monsterModel )

    self:initExtra( position )

    self:changeArmatureStateTo("RUN")
    self.isInFight_ = false
    self.isAttackCoolDown_ = true
    --每0.05秒调用的方法
    self.schedule_selector_ = self:schedule(function()
        self:updateLogic()
    end , 0.05)

    self.schedule_cooldown_ = self:schedule(function()
        self:cooldown()
    end , self.attackFrequency_)

end

function Monster:initData( monsterModel )

    self.isHurtedByShandian_ = false

    self.isDead_ = false
    self.isInHurt = false
    self.isRestrained_ = false      --是否被克制
    self.isRestrainOther_ = false   --克制对方

    -- model保留
    self.model_ = monsterModel
    monsterModel = nil

    -- hp
    self.maxHp_ = tonumber(self.model_.life_) or 100
    self.curHp_ = tonumber(self.model_.life_) or 100

    self.lostHpAccum_ = 0

    -- attack
    self.attack_ = tonumber(self.model_.attackParam_) or 10

    self.attackFrequency_ = tonumber(self.model_.attackFrequency_) or 1
    if self.attackFrequency_ <= 0 then self.attackFrequency_ = 1 end

end

function Monster:initExtra( position )

    -- setPosition
    self:setPosition(position)

    --Y轴上下偏移
    self.zOrder_ = math.random(0,5)
    self.yOffset_ = position.y + (20 - self.zOrder_ * 10)

    -- 碰撞区域精灵
    CompatTrace.resource("actor-sprite", self.model_.standFrame_)
    self.sprite_ = display.newSprite(self.model_.standFrame_):addTo(self)
    self.sprite_:setScale(0.4 * self.model_.sizeInBattle_)
    CompatTrace.node("actor-sprite", self.sprite_)

    -- Preserve the original animated actor whenever its CSB was registered;
    -- the standing sprite remains the local fallback for a missing/broken CSB.
    self.armature_ = nil
    local armaturePath = string.format("armature/%s/%s.csb", self.model_.hurtFrame_, self.model_.hurtFrame_)
    local ok, armature = xpcall(function()
        return CompatTrace.createArmature(self.model_.hurtFrame_, armaturePath)
    end, debug.traceback)
    if ok and armature ~= nil then
        self.armature_ = armature
        self.armature_:getAnimation():playWithIndex(0)
        self.armature_:setPosition(cc.p(0,0))
        self:addChild(self.armature_)
        self.armature_:setScale(0.4 * self.model_.sizeInBattle_)
        self.armature_:setVisible(true)
        CompatTrace.node("actor-visible", self.armature_)
    else
        CompatTrace.log("actor-visible", "Monster fallback=stand-sprite name=" .. tostring(self.model_.hurtFrame_) .. " error=" .. tostring(armature))
        self.sprite_:setVisible(true)
    end

    -- 骨骼动画事件
    local function animationEvent(armatureBack,movementType,movementID)
        -- id == daiji xingzou gongji shoushang
        local id = movementID
        -- 单次骨骼动画播放完成
        if movementType == ccs.MovementEventType.complete then
            --if movementType == ccs.MovementEventType.loopComplete then
            if id == "gongji" then
                self.isInFight_ = false
                self:changeArmatureStateTo("STAND")
            elseif id == "shoushang" then
                self.isInFight_ = false
                self.isInHurt_ = false
                if (self.isDead_) then
                    self:dead()
                    return
                end
                self:changeArmatureStateTo("STAND")
                self:setPositionX(self:getPositionX() - self.model_.backLength_ * 0.4 * self.model_.sizeInBattle_)
            end
        end
    end
    if self.armature_ ~= nil then
        self.armature_:getAnimation():setMovementEventCallFunc(animationEvent)
    end

    --血条以剪刀石头布区分
    local restrainType = tonumber(self.model_.restrainType_)
    if restrainType > 0 and restrainType < 4  then
        --血条背景
        self.barBg_ = display.newSprite(string.format("gamescene/bar_bg_type%d.png",restrainType),0,self.sprite_:getContentSize().height * 0.4 * self.model_.sizeInBattle_):addTo(self)
        self.barBg_:setScale(0.4)
        -- progressbar
        self.progressTimer_ = cc.ProgressTimer:create(display.newSprite(string.format("gamescene/bar_type%d.png",restrainType))):addTo(self.barBg_)
        self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        self.progressTimer_:setPosition(self.barBg_:getContentSize().width/2 + 18.5,self.barBg_:getContentSize().height/2 - 1)
        self.progressTimer_:setMidpoint(cc.p(0,0))
        self.progressTimer_:setBarChangeRate(cc.p(1,0))
        self.progressTimer_:setPercentage(100)
    else
        -- 血条
        local bar_bg_pic = "gamescene/bar_hp_bg.png"
        local bar_pic = "gamescene/bar_hp_monster.png"
        if GameManager.INFINITE_MODE then
            if (tonumber(self.model_.isBossS_) == CloudData.INFINITE_STAGE_PROGRESS) and
                (tonumber(self.model_.isBossW_) == Game.ROUND_NUM) then
                bar_bg_pic = "gamescene/bar_hp_bg_boss.png"
                bar_pic = "gamescene/bar_hp_boss.png"
            else
                bar_bg_pic = "gamescene/bar_hp_bg_elite.png"
                bar_pic = "gamescene/bar_hp_boss.png"
            end
        else
            if ( tonumber(self.model_.isBoss_) == GameManager.STAGE_NUM ) then
                bar_bg_pic = "gamescene/bar_hp_bg_boss.png"
                bar_pic = "gamescene/bar_hp_boss.png"
            elseif (tonumber(self.model_.isElite_) == GameManager.STAGE_NUM ) then
                bar_bg_pic = "gamescene/bar_hp_bg_elite.png"
                bar_pic = "gamescene/bar_hp_boss.png"
            end
        end

        -- 血条
        self.barBg_ = display.newSprite(bar_bg_pic, 0, self.sprite_:getContentSize().height * (0.4 * self.model_.sizeInBattle_ + 0.05)):addTo(self)
        self.barBg_:setScale(0.4)
        -- progressbar
        self.progressTimer_ = cc.ProgressTimer:create(display.newSprite(bar_pic)):addTo(self.barBg_)
        self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        self.progressTimer_:setPosition(self.barBg_:getContentSize().width/2,self.barBg_:getContentSize().height/2)
        if GameManager.INFINITE_MODE then
            self.progressTimer_:setPosition(self.barBg_:getContentSize().width/2 + 22,self.barBg_:getContentSize().height/2)
        else
            if (tonumber(self.model_.isBoss_) == GameManager.STAGE_NUM) or ((tonumber(self.model_.isElite_) == GameManager.STAGE_NUM )) then
                self.progressTimer_:setPosition(self.barBg_:getContentSize().width/2 + 22,self.barBg_:getContentSize().height/2)
            end
        end
        self.progressTimer_:setMidpoint(cc.p(0,0))
        self.progressTimer_:setBarChangeRate(cc.p(1,0))
        self.progressTimer_:setPercentage(100)
    end

    -- --石头剪刀布标识
    -- local restrainType = tonumber(self.model_.restrainType_)
    -- if restrainType > 0 and restrainType < 4 then
    --     local pMark = display.newSprite(string.format("buddha_icon/restrain"..restrainType..".png"))
    --         :pos(self.barBg_:getContentSize().width * 0.5,self.barBg_:getContentSize().height + 45)
    --         :addTo(self.barBg_,2)
    --     if (tonumber(self.model_.isBoss_) == GameManager.STAGE_NUM) or ((tonumber(self.model_.isElite_) == GameManager.STAGE_NUM )) then
    --         pMark:setPosition(self.barBg_:getContentSize().width * 0.13,self.barBg_:getContentSize().height + 45)
    --     end
    -- end
end

--
function Monster:updateLogic( dt )

    if self.isDead_ then
        self:changeArmatureStateTo("HURT")
        self:stopAction(self.schedule_selector_)
        self:stopAction(self.schedule_cooldown_)
        return
    end

    if self.lostHpAccum_/self.maxHp_ > tonumber(self.model_.backParam_) then
        self.isInHurt_ = true
        self.lostHpAccum_ = 0
        if self.curArmatureState_ ~= "HURT" then
            self:changeArmatureStateTo("HURT")
        end
        return
    end

    if self.isInHurt_ or self.isInFight_ or self.isFlying_ then
        return
    end

    -- 与最近的敌人有碰撞
    if 0 == #Game.BUDDHA_TABLE then
        Game.NEAREST_BUDDHA_ = nil
    end
    if Game.NEAREST_BUDDHA_ and not Game.NEAREST_BUDDHA_.isDead_ then
        if cc.rectIntersectsRect(Game.NEAREST_BUDDHA_:getMyBoundingBox(false),self:getMyBoundingBox(true)) then
            -- 攻击冷却已经完成
            if self.isAttackCoolDown_ then
                if self.curArmatureState_ ~= "ATTACK" then
                    self.isInFight_ = true
                    self:changeArmatureStateTo("ATTACK")

                    --精确受伤时间
                    self:performWithDelay(function()
                        self:attack()
                    end , self.model_.attackTime_)
                    --攻击未冷却
                    self.isAttackCoolDown_ = false
                end
            else
                -- 攻击cd中
                if self.curArmatureState_ ~= "STAND" then
                    self:changeArmatureStateTo("STAND")
                end
            end
            return
        end
    end

    -- 战斗2,攻击塔
    if cc.rectIntersectsRect(Game.TOWER_BUDDHA:getMyBoundingBox(),self:getMyBoundingBox(true)) then
        -- 攻击冷却已经完成
        if self.isAttackCoolDown_ then
            if self.curArmatureState_ ~= "ATTACK" then
                self.isInFight_ = true
                self:changeArmatureStateTo("ATTACK")
                --精确受伤时间
                self:performWithDelay(function()
                    self:attackTower()
                end , self.model_.attackTime_)
                --攻击未冷却
                self.isAttackCoolDown_ = false
            end
        else
            -- 攻击cd中
            if self.curArmatureState_ ~= "STAND" then
                self:changeArmatureStateTo("STAND")
            end
        end
        return
    end

    -- 移动
    self:changeArmatureStateTo("RUN")
    if self:getPositionY() > self.yOffset_ then
        self:setPosition(cc.pAdd(cc.p(self:getPosition()),cc.p(self.model_.runSpeed_/20/1.4,0)))
        return
    end
    self:setPosition(cc.pAdd(cc.p(self:getPosition()),cc.p(self.model_.runSpeed_/20/1.4,0.15)))
end


function Monster:attack()

    -- 群攻击型
    if 1 == tonumber(self.model_.isAreaDamage_) then
        for i,buddha in pairs(Game.BUDDHA_TABLE) do
            -- 有碰撞发生
            if cc.rectIntersectsRect(buddha:getMyBoundingBox(false),self:getMyBoundingBox(true)) then
                --buddha:underAttack(self.attack_)
                --石头剪刀布
                local buddhaRestrainType  = tonumber(buddha.model_.restrainType_)
                local monsterRestrainType = tonumber(self.model_.restrainType_)
                self:restraint_(buddha,buddhaRestrainType,monsterRestrainType)
            end
        end
        -- 单攻击
    elseif nil ~= Game.NEAREST_BUDDHA_ then
        if cc.rectIntersectsRect(Game.NEAREST_BUDDHA_:getMyBoundingBox(false),self:getMyBoundingBox(true)) then
            if not Game.NEAREST_BUDDHA_.isDead_ then
                --Game.NEAREST_BUDDHA_:underAttack(self.attack_)
                --石头剪刀布
                local buddhaRestrainType  = tonumber(Game.NEAREST_BUDDHA_.model_.restrainType_)
                local monsterRestrainType = tonumber(self.model_.restrainType_)
                self:restraint_(Game.NEAREST_BUDDHA_,buddhaRestrainType,monsterRestrainType)
            end
        end
    end

    -- Standing sprites do not emit the legacy animation-complete callback.
    if self.armature_ == nil then
        self.isInFight_ = false
        self.curArmatureState_ = "STAND"
    end

end
--石头剪刀布的克制系统
function Monster:restraint_(buddha,buddhaRestrainType,monsterRestrainType)
    if monsterRestrainType == 1 then        --1.敌方石头
        if buddhaRestrainType == 2 then
            buddha.isRestrained_ = true      --被克制
            buddha:underAttack(self.attack_ * 3)
    elseif buddhaRestrainType == 3 then
        buddha.isRestrainOther_ = true   --克制对方
        buddha:underAttack(self.attack_ * 0.5)
    else
        buddha:underAttack(self.attack_)
    end
    elseif monsterRestrainType == 2 then        --2.敌方剪刀
        if buddhaRestrainType == 3 then
            buddha.isRestrained_ = true      --被克制
            buddha:underAttack(self.attack_ * 5)
    elseif buddhaRestrainType == 1 then
        buddha.isRestrainOther_ = true   --克制对方
        buddha:underAttack(self.attack_ * 0.25)
    else
        buddha:underAttack(self.attack_)
    end
    elseif monsterRestrainType == 3 then        --3.敌方布
        if buddhaRestrainType == 1 then
            buddha.isRestrained_ = true      --被克制
            buddha:underAttack(self.attack_ * 3)
    elseif buddhaRestrainType == 2 then
        buddha.isRestrainOther_ = true   --克制对方
        buddha:underAttack(self.attack_ * 0.1)
    else
        buddha:underAttack(self.attack_)
    end
    else
        buddha:underAttack(self.attack_)
    end
end

--
function Monster:attackTower()
    Game.TOWER_BUDDHA:underAttack(self.attack_)
    if self.armature_ == nil then
        self.isInFight_ = false
        self.curArmatureState_ = "STAND"
    end
end

--攻击冷却结束
function Monster:cooldown()
    self.isAttackCoolDown_ = true
end

-- 被攻击
function Monster:underAttack( hpLose, isHurtedByShandian )

    -- 被照妖镜闪电的雷劈了
    if isHurtedByShandian then
        self.isHurtedByShandian_ = true
        --todo jump
    end

    if self.isInHurt_ and not isHurtedByShandian then
        return
    end

    -- 受伤变色、打斗灰尘
    self:hurtEffect()

    -- 飘伤害数字
    local font = nil
    if self.isRestrained_ then
        --todo(被克制的表现形式)
        self.isRestrained_ = false
        font = cc.ui.UILabel.newBMFontLabel_({text = string.format("-%d",hpLose), font = "fonts/battle_yellow.fnt"}):addTo(self)
        font:setScale(0.6 * self.model_.sizeInBattle_)

    elseif self.isRestrainOther_ then
        --todo(克制对方的表现形式)
        self.isRestrainOther_ = false
        font = cc.ui.UILabel.newBMFontLabel_({text = string.format("-%d",hpLose), font = "fonts/battle_red.fnt"}):addTo(self)
        font:setScale(0.3 * self.model_.sizeInBattle_)
    else
        font = cc.ui.UILabel.newBMFontLabel_({text = string.format("-%d",hpLose), font = "fonts/battle_red.fnt"}):addTo(self)
        font:setScale(0.4 * self.model_.sizeInBattle_)
    end
    font:setPosition(0,self.sprite_:getContentSize().height * 0.4 * self.model_.sizeInBattle_)

    local spawn = cc.Spawn:create(cc.MoveBy:create(1.0,cc.p(0,self.sprite_:getContentSize().height * 0.4 * self.model_.sizeInBattle_ * 0.5)),
        cc.FadeOut:create(1.0))
    font:runAction(transition.sequence({spawn,cc.CallFunc:create(function()
        font:removeSelf()
    end)}))

    -- 执行掉血
    self.curHp_ = self.curHp_ - hpLose
    self.lostHpAccum_ = self.lostHpAccum_ + hpLose

    self.progressTimer_:setPercentage(self.curHp_/self.maxHp_ * 100)

    if self.curHp_ <= 0 then
        self.isDead_ = true
        self.barBg_:setVisible(false)
    end

end


function Monster:hurtEffect()

    local effectTarget = self.armature_ or self.sprite_

    --变色
    if not self.isInTint_ then
        self.isInTint_ = true
        local tint = cc.TintTo:create(0.0,243,83,7)
        local tintBack = cc.TintTo:create(0.0,255,255,255)
        local dt = cc.DelayTime:create(0.4)
        effectTarget:runAction(transition.sequence({tint,dt,tintBack,cc.CallFunc:create(function()
            self.isInTint_ = false
        end)}))
    end

    --抖动
    if not self.isInShake_ then
        self.isInShake_ = true
        local m1 = cc.MoveBy:create(0.1,cc.p(-5,0))
        local m2 = cc.MoveBy:create(0.1,cc.p(5,0))
        effectTarget:runAction(transition.sequence({m1,m2,m1,m2,cc.CallFunc:create(function()
            self.isInShake_ = false
        end)}))
    end

    --打斗灰尘
    local frames = display.newFrames("dadouyanwu%d.png", 1, 7)
    local animation = display.newAnimation(frames, 0.1)
    local sp = display.newSprite()
    sp:setPosition(20, self.sprite_:getContentSize().height * 0.25)
    self:addChild(sp)
    sp:playAnimationOnce(animation,true)

end

--
function Monster:dead()

    if self.armature_ ~= nil then
        self.armature_:setVisible(false)
    else
        self.sprite_:setVisible(false)
    end
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_siwang1.%s",GameManager.POSTFIX))
    end

    -- 死亡烟雾
    local frames = display.newFrames("difangsiwangyan%d.png", 1, 7)
    local animation = display.newAnimation(frames, 0.15)
    local smoke = display.newSprite()
    smoke:setPosition( -self.sprite_:getContentSize().width/2, self.sprite_:getContentSize().height )
    self.sprite_:addChild(smoke)
    smoke:playAnimationOnce(animation,true,function()
        --加灵气
        --        GameManager.CURRENT_SPIRIT = GameManager.CURRENT_SPIRIT + self.model_.value_
        local currentSpirit = tonumber(GameManager.getCurrentSpirit()) or 0
        local spiritReward = tonumber(self.model_.value_) or 0
        local maxSpirit = tonumber(Game.SPIRIT_COUNTER.maxSpirit_) or currentSpirit
        if (currentSpirit + spiritReward) > maxSpirit then
            GameManager.setCurrentSpirit(maxSpirit)
        else
            GameManager.setCurrentSpirit(currentSpirit + spiritReward)
        end

        --print("灵气增加 " .. self.model_.value_)

        --飘灵气
        local frames = display.newFrames("lingqi%d.png", 1, 2)
        local animation = display.newAnimation(frames, 0.1)
        local spirit = display.newSprite()
        spirit:playAnimationForever(animation)
        spirit:setPosition(self:getPositionX()- self.model_.backLength_ * 0.4 * self.model_.sizeInBattle_,self:getPositionY()+self.sprite_:getContentSize().height)
        display.getRunningScene():addChild(spirit)

        local points = {cc.p(150,0),cc.p(-150,0),cc.p(0,0)}
        local b = cc.BezierBy:create(1.0,points)
        local m = cc.MoveTo:create(1.0,cc.p(display.getRunningScene().spiritCounter_:getPosition()))
        local seq =  transition.sequence({b,m})
        transition.execute(spirit,seq,{
            onComplete = function()
                spirit:removeSelf()
            end
        })

        -- 移除该对象
        table.removebyvalue(Game.MONSTER_TABLE, self, false)
        self:removeSelf()

        -- 当最后一个妖怪死亡时游戏胜利（限无尽模式）
        if Game.MODE == "INFINITE" then
            if Game.MONSTER_WAVE_OVER and (#Game.MONSTER_TABLE == 0) then
                --todo:胜利结算
                print("=========GAME WIN!!!==========")

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

                -- 道具结算
                local buyProp = json.encode(Game.SKILL_ITEM_BUY)
                -- dump(buyProp)
                local useProp = json.encode(Game.SKILL_ITEM_USE)
                -- dump(useProp)

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
    end)
end


-- 被芭蕉扇吹飞
function Monster:flyUp()

    if self.isDead_ then
        return
    end

    self.isFlying_ = true

    self.actionFlyUp_ = cc.Spawn:create(cc.MoveBy:create(2.5,cc.p(-100,1000)),cc.RotateBy:create(2.5,3600))
    self:runAction(self.actionFlyUp_)

end

-- 跌落 执行一次受伤后退
function Monster:fallDown()

    self:stopAction(self.actionFlyUp_)

    self:setPosition(Game.TOWER_MONSTER:getPositionX(),Game.TOWER_MONSTER:getPositionY() + 1000)

    -- local spawn = cc.Spawn:create(cc.MoveBy:create(2.5,cc.p(0,-1000)),cc.RotateBy:create(2.5,3600))
    local spawn = cc.Spawn:create(cc.MoveTo:create(2.5,cc.p(Game.TOWER_MONSTER:getPosition())),cc.RotateBy:create(2.5,3600))

    local seq = transition.sequence({spawn,
        --cc.DelayTime:create(2.5),
        cc.CallFunc:create(function()
            self:setRotation(0)
            self.isInHurt_ = true
            self:changeArmatureStateTo("HURT")
            self.isFlying_ = false
        end)})
    self:runAction( seq )


end

--
function Monster:changeArmatureStateTo( state )

    if self.armature_ == nil then
        self.curArmatureState_ = state
        return
    end

    if state == "STAND" then
        if self.curArmatureState_ ~= "STAND" then
            self.curArmatureState_ = "STAND"
            self.armature_:getAnimation():playWithIndex(0)
        end
    elseif state == "RUN" then
        if self.curArmatureState_ ~= "RUN" then
            self.curArmatureState_ = "RUN"
            self.armature_:getAnimation():playWithIndex(1)
        end
    elseif state == "ATTACK" then
        self.curArmatureState_ = "ATTACK"
        self.armature_:getAnimation():playWithIndex(2)
        if GameManager.SOUND_SWITCH_ON then
            if(cc.FileUtils:getInstance():isFileExist(string.format("%s.%s",self.model_.soundFile_,GameManager.POSTFIX))) then
                audio.playSound(string.format("%s.%s",self.model_.soundFile_,GameManager.POSTFIX))
            else
                audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
            end
        end
    elseif state == "HURT" then
        self.curArmatureState_ = "HURT"
        self.armature_:getAnimation():playWithIndex(3)
    end
end

-- 计算碰撞区域
function Monster:getMyBoundingBox( isAttacking )
    local attackDistance = 0
    if isAttacking then
        attackDistance = self.model_.attackDistance_
    end

    local position = cc.p(self:getPosition())
    local size = cc.size(self.sprite_:getContentSize().width * 0.4 * self.model_.sizeInBattle_, self.sprite_:getContentSize().height * 0.4 * self.model_.sizeInBattle_)
    local rect = cc.rect( position.x - (size.width + attackDistance * 0.4 * self.model_.sizeInBattle_)/2,
        position.y - size.height,
        size.width + attackDistance * 0.4 * self.model_.sizeInBattle_,
        size.height * 10)
    return rect
end


return Monster

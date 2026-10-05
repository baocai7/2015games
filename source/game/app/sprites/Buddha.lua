
local Buddha = {}
local CompatTrace = import("utils.CompatTrace")
Buddha = class("Buddha", function()
    return display.newNode()
end)


function Buddha:ctor( buddhaModel, position )

    self:initData( buddhaModel )

    self:initExtra( position )

    self:changeArmatureStateTo("RUN")
    self.isInFight_ = false
    self.isAttackCoolDown_ = true

    --  添加一个每0.05秒刷新的方法
    self.schedule_selector_ = self:schedule(function()
        self:updateLogic()
    end , 0.05)

    self.schedule_cooldown_ = self:schedule(function()
        self:cooldown()
    end , self.attackFrequency_)

end


function Buddha:initData(buddhaModel)

    self.isDead_ = false
    self.isInHurt = false
    self.isRestrained_ = false      --是否被克制
    self.isRestrainOther_ = false   --克制对方

    -- model保留
    self.model_ = buddhaModel
    buddhaModel = nil

    -- hp
    -- local hp = self.model_.lifeParamK_ * self.model_.level_ + self.model_.lifeParamB_
    -- local hpAdd = self.model_.lifeParamKAdd_ * self.model_.addLevel_ + self.model_.lifeParamBAdd_

    -- self.curHp_ = hp + hpAdd
    -- self.maxHp_ = hp + hpAdd
    self.curHp_ = tonumber(self.model_.life_) or 100
    self.maxHp_ = tonumber(self.model_.life_) or 100

    self.lostHpAccum_ = 0

    --todo 宝物hp加成

    -- attack
    -- local attack = self.model_.attackParamK_ * self.model_.level_ + self.model_.attackParamB_
    -- local attackAdd = self.model_.attackParamKAdd_ * self.model_.addLevel_ + self.model_.attackParamBAdd_

    -- self.attack_ = attack + attackAdd

    self.attack_ = tonumber(self.model_.attack_) or 10

    --todo 宝物attack加成

    -- attack freq
    self.attackFrequency_ = (tonumber(self.model_.level_) or 1) *
        (tonumber(self.model_.attackFrequencyK_) or 0) +
        (tonumber(self.model_.attackFrequencyB_) or 1)
    if self.attackFrequency_ <= 0 then self.attackFrequency_ = 1 end

end


function Buddha:initExtra(position)
    -- setPosition
    self:setPosition(position)

    --Y轴上下偏移
    self.zOrder_ = math.random(0,5)
    self.yOffset_ = position.y + (20 - self.zOrder_ * 10)

    --碰撞精灵区域
    CompatTrace.resource("actor-sprite", self.model_.standFrame_)
    self.sprite_ = display.newSprite(self.model_.standFrame_):addTo(self)
    self.sprite_:setScale(0.4 * self.model_.sizeInBattle_)
    CompatTrace.node("actor-sprite", self.sprite_)

    -- The stage loader normally registers this armature before construction.
    -- Keep the original animated actor when that succeeds, but leave the
    -- standing sprite as a bounded fallback on devices that reject a CSB.
    self.armature_ = nil
    local armaturePath = string.format("armature/%s/%s.csb", self.model_.hurtFrame_, self.model_.hurtFrame_)
    local ok, armature = xpcall(function()
        return CompatTrace.createArmature(self.model_.hurtFrame_, armaturePath)
    end, debug.traceback)
    if ok and armature ~= nil then
        self.armature_ = armature
        self.armature_:setPosition(cc.p(0,0))
        self:addChild(self.armature_)
        self.armature_:setScale(0.4 * self.model_.sizeInBattle_)
        self.armature_:setVisible(true)
        if "1" == self.model_.isRebel_ then
            self.armature_:setScaleX(-1 * 0.4 * self.model_.sizeInBattle_)
        end
        CompatTrace.node("actor-visible", self.armature_)
    else
        CompatTrace.log("actor-visible", "Buddha fallback=stand-sprite name=" .. tostring(self.model_.hurtFrame_) .. " error=" .. tostring(armature))
        self.sprite_:setVisible(true)
    end

    -- 骨骼动画事件
    local function animationEvent(armatureBack,movementType,movementID)
        -- id == daiji xingzou gongji shoushang
        local id = movementID
        if movementType == ccs.MovementEventType.complete then
            --if movementType == ccs.MovementEventType.loopComplete then
            if id == "gongji" then
                self.isInFight_ = false
                self:changeArmatureStateTo("STAND")
            elseif id == "shoushang" then
                self.isInFight_ = false
                self.isInHurt_ = false
                self:changeArmatureStateTo("STAND")
                self:setPositionX(self:getPositionX() + self.model_.backLength_ * 0.4 * self.model_.sizeInBattle_)
                if (self.isDead_) then
                    self:dead()
                    return
                end
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
        --血条bg
        self.barBg_ = display.newSprite("gamescene/bar_hp_bg.png",0,self.sprite_:getContentSize().height * 0.4 * self.model_.sizeInBattle_):addTo(self)
        self.barBg_:setScale(0.4)
        -- progressbar
        self.progressTimer_ = cc.ProgressTimer:create(display.newSprite("gamescene/bar_hp_buddha.png")):addTo(self.barBg_)
        self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        self.progressTimer_:setPosition(self.barBg_:getContentSize().width/2,self.barBg_:getContentSize().height/2)
        self.progressTimer_:setMidpoint(cc.p(0,0))
        self.progressTimer_:setBarChangeRate(cc.p(1,0))
        self.progressTimer_:setPercentage(100)
    end

    -- 无敌光环素材
    self.shield_ = display.newSprite("item/shield.png")
    self.shield_:setScale(0.4 * self.sprite_:getContentSize().width / 300)
    self:addChild(self.shield_)
    self.shield_:setVisible(false)

    -- --石头剪刀布标识
    -- local restrainType = tonumber(self.model_.restrainType_)
    -- if restrainType > 0 and restrainType < 4 then
    --     local pMark = display.newSprite(string.format("buddha_icon/restrain"..restrainType..".png"))
    --         :pos(self.barBg_:getContentSize().width * 0.5,self.barBg_:getContentSize().height + 45)
    --         :addTo(self.barBg_,2)
    -- end
end


--
function Buddha:updateLogic()

    -- dead
    if self.isDead_ then
        self:changeArmatureStateTo("HURT")
        self:stopAction(self.schedule_selector_)
        self:stopAction(self.schedule_cooldown_)
        return
    end

    -- invicible 无敌道具相关
    if ( Game.INVINCIBLE ) then
        self.IsInvincible_ = true
        self.shield_:setVisible(true)
    else
        self.IsInvincible_ = false
        self.shield_:setVisible(false)
    end


    -- hurt
    if self.lostHpAccum_/self.maxHp_ > tonumber(self.model_.backParam_) then
        self.isInHurt_ = true
        self.lostHpAccum_ = 0
        if self.curArmatureState_ ~= "HURT" then
            self:changeArmatureStateTo("HURT")
        end
        return
    end

    -- disable status
    if self.isInHurt_ or self.isInFight_  then
        return
    end


    -- 场面有敌人 and 与最近的敌人有碰撞
    if 0 == #Game.MONSTER_TABLE then
        Game.NEAREST_MONSTER_ = nil
    end
    if Game.NEAREST_MONSTER_ and not Game.NEAREST_MONSTER_.isDead_ then
        if cc.rectIntersectsRect(Game.NEAREST_MONSTER_:getMyBoundingBox(false),self:getMyBoundingBox(true)) then
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

    -- 战斗2,没有遇到敌人，判断是否攻击塔
    if cc.rectIntersectsRect(Game.TOWER_MONSTER:getMyBoundingBox(),self:getMyBoundingBox(true)) then
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
        self:setPosition(cc.pAdd(cc.p(self:getPosition()),cc.p(-self.model_.runSpeed_/20/1.4,0)))
        return
    end
    self:setPosition(cc.pAdd(cc.p(self:getPosition()),cc.p(-self.model_.runSpeed_/20/1.4,0.15)))
end


function Buddha:attack()

    -- 群攻击型
    if 1 == tonumber(self.model_.isAreaDamage_) then
        for i,monster in pairs(Game.MONSTER_TABLE) do
            -- 有碰撞发生
            if cc.rectIntersectsRect(monster:getMyBoundingBox(false),self:getMyBoundingBox(true)) then
                --monster:underAttack(self.attack_)
                --石头剪刀布
                local buddhaRestrainType  = tonumber(self.model_.restrainType_)
                local monsterRestrainType = tonumber(monster.model_.restrainType_)
                self:restraint_(monster,buddhaRestrainType,monsterRestrainType)
            end
        end
        -- 单攻击
    elseif nil ~= Game.NEAREST_MONSTER_ then
        if cc.rectIntersectsRect(Game.NEAREST_MONSTER_:getMyBoundingBox(false),self:getMyBoundingBox(true)) then
            if not Game.NEAREST_MONSTER_.isDead_ then
                --Game.NEAREST_MONSTER_:underAttack(self.attack_)
                --石头剪刀布
                local buddhaRestrainType  = tonumber(self.model_.restrainType_)
                local monsterRestrainType = tonumber(Game.NEAREST_MONSTER_.model_.restrainType_)
                self:restraint_(Game.NEAREST_MONSTER_,buddhaRestrainType,monsterRestrainType)
            end
        end
    end

    -- The compatibility path uses standing sprites instead of armatures, so
    -- there is no animation-complete callback to release the fight lock.
    if self.armature_ == nil then
        self.isInFight_ = false
        self.curArmatureState_ = "STAND"
    end

end

--石头剪刀布的克制系统
function Buddha:restraint_(monster,buddhaRestrainType,monsterRestrainType)
    if buddhaRestrainType == 1 then        --1.我方石头
        if monsterRestrainType == 2 then
            monster.isRestrained_ = true     --被克制
            monster:underAttack(self.attack_ * 3)
    elseif monsterRestrainType == 3 then
        monster.isRestrainOther_ = true  --克制对方
        monster:underAttack(self.attack_ * 0.5)
    else
        monster:underAttack(self.attack_)
    end
    elseif buddhaRestrainType == 2 then        --2.我方剪刀
        if monsterRestrainType == 3 then
            monster.isRestrained_ = true     --被克制
            monster:underAttack(self.attack_ * 5)
    elseif monsterRestrainType == 1 then
        monster.isRestrainOther_ = true  --克制对方
        monster:underAttack(self.attack_ * 0.25)
    else
        monster:underAttack(self.attack_)
    end
    elseif buddhaRestrainType == 3 then        --3.我方布
        if monsterRestrainType == 1 then
            monster.isRestrained_ = true     --被克制
            monster:underAttack(self.attack_ * 3)
    elseif monsterRestrainType == 2 then
        monster.isRestrainOther_ = true  --克制对方
        monster:underAttack(self.attack_ * 0.1)
    else
        monster:underAttack(self.attack_)
    end
    else
        monster:underAttack(self.attack_)
    end
end


function Buddha:attackTower()
    Game.TOWER_MONSTER:underAttack(self.attack_)
    if self.armature_ == nil then
        self.isInFight_ = false
        self.curArmatureState_ = "STAND"
    end
end


function Buddha:cooldown()
    self.isAttackCoolDown_ = true
end

--被攻击
function Buddha:underAttack( hpLose )

    if self.isInHurt_ or self.IsInvincible_ then
        return
    end

    -- 受伤变色、打斗灰尘
    self:hurtEffect()

    -- 掉血飘数字
    local font = nil
    if self.isRestrained_ then
        --todo(被克制的表现形式)
        self.isRestrained_ = false
        font = cc.ui.UILabel.newBMFontLabel_({text = string.format("-%d",hpLose), font = "fonts/battle_purple.fnt"}):addTo(self)
        font:setScale(0.6 * self.model_.sizeInBattle_)

    elseif self.isRestrainOther_ then
        --todo(克制对方的表现形式)
        self.isRestrainOther_ = false
        font = cc.ui.UILabel.newBMFontLabel_({text = string.format("-%d",hpLose), font = "fonts/battle_blue.fnt"}):addTo(self)
        font:setScale(0.3 * self.model_.sizeInBattle_)
    else
        font = cc.ui.UILabel.newBMFontLabel_({text = string.format("-%d",hpLose), font = "fonts/battle_blue.fnt"}):addTo(self)
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


function Buddha:hurtEffect()

    local effectTarget = self.armature_ or self.sprite_

    -- 变色
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
        local m1 = cc.MoveBy:create(0.1,cc.p(5,0))
        local m2 = cc.MoveBy:create(0.1,cc.p(-5,0))
        effectTarget:runAction(transition.sequence({m1,m2,m1,m2,cc.CallFunc:create(function()
            self.isInShake_ = false
        end)}))
    end

    --打斗灰尘
    local frames = display.newFrames("dadouyanwu%d.png", 1, 7)
    local animation = display.newAnimation(frames, 0.1)
    local sp = display.newSprite()
    sp:setPosition(-10, self.sprite_:getContentSize().height * 0.25)
    self:addChild(sp)
    sp:playAnimationOnce(animation,true)
end


function Buddha:dead()

    if self.armature_ ~= nil then
        self.armature_:setVisible(false)
    else
        self.sprite_:setVisible(false)
    end
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_siwang2.%s",GameManager.POSTFIX))
    end

    -- 死亡烟雾
    local frames = display.newFrames("wofangsiwangyan%d.png", 1, 7)
    local animation = display.newAnimation(frames, 0.15)
    local smoke = display.newSprite()
    smoke:setPosition( self.sprite_:getContentSize().width,self.sprite_:getContentSize().height )
    self.sprite_:addChild(smoke)
    smoke:playAnimationOnce(animation,true,function()
        --飘灵魂
        local frames = display.newFrames("siwanglinghun%d.png", 1, 3)
        local animation = display.newAnimation(frames, 0.15)
        local soul = display.newSprite()
        soul:setAnchorPoint(cc.p(0.5,0.5))
        soul:setScale(0.4)
        soul:playAnimationForever(animation)
        soul:setPosition(self:getPosition())
        Game.BG1:addChild(soul)
        transition.execute(soul,cc.MoveBy:create(4.0,cc.p(0,300)),{
            onComplete = function()
                soul:removeSelf()
            end
        })

        --移除该对象
        table.removebyvalue(Game.BUDDHA_TABLE, self, false)
        self:removeSelf()
    end)

end

function Buddha:changeArmatureStateTo( state )

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

--获得碰撞区域   isAttacking 为true时加入攻击范围
function Buddha:getMyBoundingBox( isAttacking )
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

return Buddha


local AlertConnection          = import("customs.AlertConnection")
local WarResultLayer           = import("layers.WarResultLayer")
local CommonResultLayer        = import("layers.CommonResultLayer")
local ReliveLayer              = import("layers.ReliveLayer")
local InfiniteModeResultLayer  = import("layers.InfiniteModeResultLayer")
local CompatTrace              = import("utils.CompatTrace")

local TowerBuddha = {}
TowerBuddha = class("TowerBuddha", function()
    return display.newNode()
end)

function TowerBuddha:ctor(towerBuddhaModel)

    self.model_ = towerBuddhaModel

    --塔相关数据
    local baseLife = tonumber(self.model_.life_) or 1000
    self.hpMax_         = baseLife
    self.hpCur_         = baseLife
    self.hpShield_      = baseLife
    self.towerLevel_    = tonumber(towerBuddhaModel.towerPropertyLevelTotal_) or 1
    self.wandLevel_     = tonumber(towerBuddhaModel.wandPropertyLevelTotal_) or 1

    -- 加载特效(降妖杖的特效)，保留原版构造时机和图集路径。
    CompatTrace.log("ui", "TowerBuddha ctor: loading wand effect atlases")
    display.addSpriteFrames("animation/wand_light_tx.plist","animation/wand_light_tx.png")
    display.addSpriteFrames("animation/wand_tx.plist","animation/wand_tx.png")

    local function loadTowerArmature(path, name)
        CompatTrace.resource("tower-armature", path)
        local ok, value = xpcall(function()
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
            return ccs.Armature:create(name)
        end, debug.traceback)
        if not ok then
            CompatTrace.log("tower-armature", string.format("FAILED path=%s name=%s\n%s", path, name, tostring(value)))
            return nil
        end
        CompatTrace.log("tower-armature", string.format("created path=%s name=%s object=%s", path, name, tostring(value)))
        return value
    end

    -- 加载防御塔骨骼资源（原版分支保留）
    local barPosRatio  = 0          -- 血条的位置调整系数
    local wandPosRatio = 0          -- 降妖杖的位置调整系数
    if self.towerLevel_ <= 9 then
        self.towerArmature_ = loadTowerArmature("armature/tower_armature1/tower_armature1.csb", "tower_armature1")
        if self.towerArmature_ == nil then self.towerArmature_ = display.newSprite("gamescene/tower1.png") end
        barPosRatio = 1.0
        wandPosRatio = -60
    elseif self.towerLevel_ <= 19 then
        self.towerArmature_ = loadTowerArmature("armature/tower_armature2/tower_armature2.csb", "tower_armature2")
        if self.towerArmature_ == nil then self.towerArmature_ = display.newSprite("gamescene/tower2.png") end
        barPosRatio = 0.9
        wandPosRatio = -78
    else
        self.towerArmature_ = loadTowerArmature("armature/tower_armature3/tower_armature3.csb", "tower_armature3")
        if self.towerArmature_ == nil then self.towerArmature_ = display.newSprite("gamescene/tower3.png") end
        barPosRatio = 0.85
        wandPosRatio = -85
    end

    -- 防御塔(骨骼)
    if self.towerArmature_.getAnimation ~= nil then
        self.towerArmature_:getAnimation():playWithIndex(0)
    end
    self.towerArmature_:setAnchorPoint(0.5,0)
    self.towerArmature_:setScale(0.4)
    self:addChild(self.towerArmature_)

    -- 骨骼动画事件
    local function animationEvent(armatureBack,movementType,movementID)
        -- id == stage1 under_attack1 stage2 under_attack2 stage3 under_attack3
        local id = movementID
        -- 单次骨骼动画播放完成
        if movementType == ccs.MovementEventType.loopComplete then
            if id == "under_attack1" then
                if (self.hpCur_ / self.hpMax_) >= 2/3 then
                    self:changeArmatureStateTo("IDLE1")
                elseif (self.hpCur_ / self.hpMax_) >= 1/3 then
                    self:changeArmatureStateTo("IDLE2")
                else
                    self:changeArmatureStateTo("IDLE3")
                end
            elseif id == "under_attack2" then
                if (self.hpCur_ / self.hpMax_) >= 1/3 then
                    self:changeArmatureStateTo("IDLE2")
                else
                    self:changeArmatureStateTo("IDLE3")
                end
            elseif id == "under_attack3" then
                self:changeArmatureStateTo("IDLE3")
            end
        end
    end
    if self.towerArmature_.getAnimation ~= nil then
        self.towerArmature_:getAnimation():setMovementEventCallFunc(animationEvent)
    end

    --血量进度条
    self.barBg_ = display.newSprite("gamescene/bar_bg_tower_b.png",0,
        self.towerArmature_:getContentSize().height * barPosRatio)
        :addTo(self.towerArmature_)
    -- progressbar
    self.progressTimer_ = cc.ProgressTimer:create(display.newSprite("gamescene/bar_hp_tower_b1.png")):addTo(self.barBg_)
    self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progressTimer_:setPosition(self.barBg_:getContentSize().width/2,self.barBg_:getContentSize().height/2)
    self.progressTimer_:setMidpoint(cc.p(0,0))
    self.progressTimer_:setBarChangeRate(cc.p(1,0))
    self.progressTimer_:setPercentage(self.hpCur_/self.hpMax_ * 100)
    --我方塔血量标签
    self.towerBloodLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = string.format("%d/%d",self.hpCur_,self.hpMax_),size = 20})
        :align(display.CENTER,self.barBg_:getContentSize().width/2,self.barBg_:getContentSize().height/2)
        :addTo(self.barBg_,1)

    -- 加载降妖杖
    if self.wandLevel_ < 30 then
        self.wandPic_  = display.newSprite("upgrade/wand/wand1.png",wandPosRatio,20)
        self.wandBall_ = display.newSprite("gamescene/wand_light1.png")
        self.wandBall_:setPosition(self.wandPic_:getContentSize().width * 0.44,self.wandPic_:getContentSize().height * 0.74)
    elseif self.wandLevel_ < 55 then
        self.wandPic_  = display.newSprite("upgrade/wand/wand2.png",wandPosRatio,20)
        self.wandBall_ = display.newSprite("gamescene/wand_light2.png")
        self.wandBall_:setPosition(self.wandPic_:getContentSize().width * 0.39,self.wandPic_:getContentSize().height * 0.74)
    else
        self.wandPic_  = display.newSprite("upgrade/wand/wand3.png",wandPosRatio,20)
        self.wandBall_ = display.newSprite("gamescene/wand_light3.png")
        self.wandBall_:setPosition(self.wandPic_:getContentSize().width * 0.5,self.wandPic_:getContentSize().height * 0.74)
    end
    self.wandBall_:hide()
    self.wandPic_:setScale(0.4)
    self.wandPic_:setAnchorPoint(0.5,0)
    self.wandPic_:addChild(self.wandBall_)
    self:addChild(self.wandPic_,-1)

    if Game.MODE == "NORMAL" then
        local stageModel = DataUtils.getStageModel(GameManager.STAGE_NUM)
        if 1 == tonumber(stageModel.isGrooveMode_) then
            self:wandInCD()
        end
    end
    
    --道具 金钟罩
    self.shield_ = display.newSprite("#zhong1.png")
    if self.shield_ == nil then
        CompatTrace.log("tower-shield", "atlas frame zhong1.png unavailable; using static fallback")
        self.shield_ = display.newSprite("gamescene/tower_center.png")
    end
    self.shield_:addTo(self)
    self.shield_:setAnchorPoint(cc.p(0.5,0))
    self.shield_:setScale(0.4)
    local frames = display.newFrames("zhong%d.png", 1, 4)
    local animation = display.newAnimation(frames, 0.15)
    if self.shield_.playAnimationForever ~= nil then
        self.shield_:playAnimationForever(animation)
    end
    self.shield_:setVisible(false)
    --金钟罩血量进度条
    local barBg = display.newSprite("gamescene/bar_bg_tower_b.png",self.shield_:getContentSize().width/2,self.shield_:getContentSize().height * 1.05)
        :addTo(self.shield_)
    -- progressbar
    self.zhongProTimer_ = cc.ProgressTimer:create(display.newSprite("gamescene/bar_hp_tower_b2.png")):addTo(barBg)
    self.zhongProTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.zhongProTimer_:setPosition(barBg:getContentSize().width/2,barBg:getContentSize().height/2)
    self.zhongProTimer_:setMidpoint(cc.p(0,0))
    self.zhongProTimer_:setBarChangeRate(cc.p(1,0))
    self.zhongProTimer_:setPercentage(self.hpShield_/self.hpMax_ * 100)
end

--防御塔的骨骼状态的变化
function TowerBuddha:changeArmatureStateTo( state )
    if self.towerArmature_ == nil or self.towerArmature_.getAnimation == nil then
        return
    end
    if state == "IDLE1" then
        if self.curArmatureState_ ~= "IDLE" then
            self.curArmatureState_ = "IDLE"
            self.towerArmature_:getAnimation():playWithIndex(0)
        end
    elseif state == "IDLE2" then
        if self.curArmatureState_ ~= "IDLE" then
            self.curArmatureState_ = "IDLE"
            self.towerArmature_:getAnimation():playWithIndex(2)
        end
    elseif state == "IDLE3" then
        if self.curArmatureState_ ~= "IDLE" then
            self.curArmatureState_ = "IDLE"
            self.towerArmature_:getAnimation():playWithIndex(4)
        end
    elseif state == "HURT1" then
        if self.curArmatureState_ ~= "HURT" then
            self.curArmatureState_ = "HURT"
            self.towerArmature_:getAnimation():playWithIndex(1)
        end
    elseif state == "HURT2" then
        if self.curArmatureState_ ~= "HURT" then
            self.curArmatureState_ = "HURT"
            self.towerArmature_:getAnimation():playWithIndex(3)
        end
    elseif state == "HURT3" then
        if self.curArmatureState_ ~= "HURT" then
            self.curArmatureState_ = "HURT"
            self.towerArmature_:getAnimation():playWithIndex(5)
        end
    end
end

function TowerBuddha:underAttack( loseHp )

    if not Game.END then

        -- 如果在复活状态则无敌
        if self.isInRecover_ then  
            loseHp = 0
        end

        --被攻击效果 变色 抖动 灰尘
        self:hurtEffect()

        -- 道具金钟罩
        if self.isShieldOn_ then
            self.hpShield_ = self.hpShield_ - loseHp
            self.zhongProTimer_:setPercentage(self.hpShield_/self.hpMax_ * 100)
            if self.hpShield_ <= 0 then
                self.isShieldOn_ = false;
                self.shield_:setVisible(false)
            end
        else
            self.hpCur_ = self.hpCur_ - loseHp
        end

        if (self.hpCur_ / self.hpMax_) >= 2/3 then
            self:changeArmatureStateTo("HURT1")
        elseif (self.hpCur_ / self.hpMax_) >= 1/3 then
            self:changeArmatureStateTo("HURT2")
        else
            self:changeArmatureStateTo("HURT3")
        end

        if self.hpCur_ <= 0 then
            self.towerBloodLabel_:setString(string.format("0/%d",self.hpMax_))
            self.progressTimer_:setPercentage(0)
            self:dead()
            return
        end
        self.towerBloodLabel_:setString(string.format("%d/%d",self.hpCur_,self.hpMax_))
        self.progressTimer_:setPercentage(self.hpCur_/self.hpMax_ * 100)
    end
end

function TowerBuddha:hurtEffect()

    --抖动
    if not self.isInShake_ then
        self.isInShake_ = true
        local m1 = cc.MoveBy:create(0.1,cc.p(3,0))
        local m2 = cc.MoveBy:create(0.1,cc.p(-3,0))
        self.towerArmature_:runAction(transition.sequence({m1,m2,m1,m2,cc.CallFunc:create(function()
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

function TowerBuddha:dead()

    Game.END = true

    --提示复活
    local rl = ReliveLayer.new()
    display.getRunningScene():addChild(rl,100,87965)

    self.scheduleRL_ = self:schedule(function()
        if not display.getRunningScene():getChildByTag(87965) then
            self:stopAction(self.scheduleRL_)

            if GameManager.RECOVER == true then
                Game.END = false
                GameManager.RECOVER = false

                -- 复活3秒无敌
                self.isInRecover_ = true
                self:performWithDelay(function()
                    self.isInRecover_ = false
                end,3.0)

                -- 龙卷风
                Game.SKILL_ITEM_ICON[3]:cast2_Alt()

                -- 恢复满血状态
                self.hpCur_    = tonumber(self.model_.life_) or self.hpMax_
                self.towerBloodLabel_:setString(string.format("%d/%d",self.hpCur_,self.hpCur_))
                self.progressTimer_:setPercentage(100)
                self:changeArmatureStateTo("IDLE1")
            else
                print("ENNNNNNNNNNNNNNNNNNNNNNND LOSE")

                -- 默认 1倍速
                cc.Director:getInstance():getScheduler():setTimeScale(1.0)

                -- 关闭自动出兵,防止网络连接异常时还能出兵
                for i=1,#Game.TEAM_ICON do
                    local teamIcon = Game.TEAM_ICON[i]
                    teamIcon:changeAutoMode(-100)
                end

                -- 普通模式结算
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

                    local alertConnection = AlertConnection.new(CONNECTION_PASS_STAGE,GameManager.STAGE_NUM,0,buyProp,useProp,teamInfoTable)
                    display.getRunningScene():addChild(alertConnection,100,12345)

                    self.scheduleResult_ = self:schedule(function()
                        if not display.getRunningScene():getChildByTag(12345) then
                            self:stopAction(self.scheduleResult_)

                            -- 暂停游戏
                            operateAllSchedulerAndActions( display.getRunningScene(), "PAUSE" )

                            local wrl = WarResultLayer.new( RESULT_TYPE_LOSE )
                            display.getRunningScene():addChild(wrl,20)

                        end
                    end, 0.1)

                elseif Game.MODE == "INFINITE" then
                    -- ============无尽模式=============

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

                    local infiniteStageId = CloudData.INFINITE_STAGE_PROGRESS
                    local waveId          = Game.ROUND_NUM - 1
                    local ac = AlertConnection.new(CONNECTION_INFINITE_RESULT,infiniteStageId,teamInfoTable,waveId,0,buyProp,useProp)
                    display.getRunningScene():addChild(ac,101,12366)

                    self.scheduleResultInfinite_ = self:schedule(function()
                        if not display.getRunningScene():getChildByTag(12366) then
                            self:stopAction(self.scheduleResultInfinite_)

                            -- 暂停游戏
                            operateAllSchedulerAndActions( display.getRunningScene(), "PAUSE" )

                            -- 最高纪录
                            CloudData.INFINITE_STAGE_PROGRESS = CloudData.INFINITE_STAGE_PROGRESS
                            if waveId >= CloudData.INFINITE_WAVES_PROGRESS  then
                                CloudData.INFINITE_WAVES_PROGRESS = waveId
                            end
                            
                            -- 失败弹窗
                            local pLayer = InfiniteModeResultLayer.new(RESULT_TYPE_LOSE)
                            display.getRunningScene():addChild(pLayer,100)
                        end
                    end,0.1)
                else
                    -- 挑战模式 或 日常模式
                    operateAllSchedulerAndActions( display.getRunningScene(), "PAUSE" )

                    if Game.MODE == "DIARY" then
                        --DataEye统计任务
                        if USE_DATAEYE then             
                            DCTask.fail("Diary" .. GameManager.STAGE_NUM_DIARY, "diary failed")                   
                        end
                    elseif Game.MODE == "CHALLENGE" then
                        --DataEye统计任务
                        if USE_DATAEYE then             
                            DCTask.fail("Trial" .. (GameManager.STAGE_NUM_CHALLENGE), "trial failed")                   
                        end
                    end                    

                    local crl = CommonResultLayer.new( RESULT_TYPE_COMMON_LOSE )
                    display.getRunningScene():addChild(crl,20)
                end
            end
        end
    end,0.1)
end

-- 开启金钟罩
function TowerBuddha:openShield()
    self.isShieldOn_ = true
    self.hpShield_ = tonumber(self.model_.life_) or self.hpMax_
    self.shield_:setVisible(true)
end

-- 降妖杖蓄积能量
function TowerBuddha:wandInCD()
    self.wandBall_:show()
    local seq = transition.sequence({cc.FadeOut:create(2.0),cc.FadeIn:create(2.0)})
    self.wandBall_:runAction(cc.RepeatForever:create(seq))
end
-- 降妖杖能量蓄满
function TowerBuddha:wandIsReady()
    -- 光球停止渐变效果
    self.wandBall_:stopAllActions()

    -- 光球闪烁
    self.wandBall_:runAction(cc.RepeatForever:create(cc.Blink:create(0.5,2)))
end
-- 降妖杖攻击
function TowerBuddha:wandAttack()
    -- 光球停止闪烁
    self.wandBall_:stopAllActions()

    -- 创建动画
    local frames1 = display.newFrames("wand%d.png",1,18)
    local animation1 = display.newAnimation(frames1, 0.75/18)
    local emptySp1  = display.newSprite()
        :scale(1/0.4)
        :pos(self.wandBall_:getPositionX(),self.wandPic_:getContentSize().height * 0.74)
        :addTo(self.wandPic_,1)
    emptySp1:playAnimationOnce(animation1,true)

    local frames2 = display.newFrames("w_light%d.png",1,26)
    local animation2 = display.newAnimation(frames2, 1.0/26)
    local emptySp2  = display.newSprite()
        :scale(1/0.4)
        :pos(self.wandBall_:getPositionX(),self.wandPic_:getContentSize().height * 0.32)
        :addTo(self.wandPic_,-1)
    emptySp2:setAnchorPoint(0.5,0)
    emptySp2:playAnimationOnce(animation2,true)
end

function TowerBuddha:getMyBoundingBox()

    local position = cc.p(self:getPosition())
    local size = cc.size(self.towerArmature_:getContentSize().width * 0.4, self.towerArmature_:getContentSize().height * 0.4)
    local rect = cc.rect( position.x - size.width * 0.5,
        position.y,
        size.width,
        size.height)
    return rect
end

return TowerBuddha

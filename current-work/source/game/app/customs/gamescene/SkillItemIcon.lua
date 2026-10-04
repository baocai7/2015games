
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local SkillItemLayer = import("layers.SkillItemLayer")
local AlertItemCastAniLayer = import("layers.AlertItemCastAniLayer")
local WSToast = import("utils.WSToast")

-- 战斗技能道具
local SkillItemIcon = {} 
SkillItemIcon = class("SkillItemIcon", function()
    return display.newNode()
end)

function SkillItemIcon:ctor( itemId )

    self.itemId_ = itemId
    self.model_ = DataUtils.getSkillItemModel( itemId )
    
    --默认锁定
    local sprite = display.newSprite("item/lock.png"):addTo(self)
    self:setContentSize(sprite:getContentSize())
    --点击事件
    sprite:setTouchEnabled(true) -- enable sprite touch
    sprite:setTouchSwallowEnabled(true)
    sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y, prevX, prevY = event.name, event.x, event.y, event.prevX, event.prevY
        if name == "began" then
            self:onPressed()
            return true
        end
    end)
    
    self.isUnLock_ = false
    self.isInCd_ = false

    self.schedule_ = self:schedule(function()
        self:update1()
    end, 0.1)
    
end

function SkillItemIcon:update1()

    if self.itemId_ == 1 then
        self.isUnLocked_ = CloudData.STAGE_PROGRESS > 5 or DataUtils.getItemIsUnlock(self.itemId_) -- CloudData.ITEM1_UNLOCK  
    elseif self.itemId_ == 2 then
        self.isUnLocked_ = CloudData.STAGE_PROGRESS > 5 or DataUtils.getItemIsUnlock(self.itemId_) -- CloudData.ITEM2_UNLOCK
    elseif self.itemId_ == 3 then
        self.isUnLocked_ = CloudData.STAGE_PROGRESS > 6 or DataUtils.getItemIsUnlock(self.itemId_) -- CloudData.ITEM3_UNLOCK
    elseif self.itemId_ == 4 then
        self.isUnLocked_ = CloudData.STAGE_PROGRESS > 7 or DataUtils.getItemIsUnlock(self.itemId_) -- CloudData.ITEM4_UNLOCK
    elseif self.itemId_ == 5 then
        self.isUnLocked_ = CloudData.STAGE_PROGRESS > 9 or DataUtils.getItemIsUnlock(self.itemId_) -- CloudData.ITEM5_UNLOCK
    elseif self.itemId_ == 6 then
        self.isUnLocked_ = CloudData.STAGE_PROGRESS > 10 or DataUtils.getItemIsUnlock(self.itemId_) -- CloudData.ITEM6_UNLOCK
    end
    
    --已解锁
    if self.isUnLocked_ then
        --显示图标
	    if not self:getChildByTag(111) then
            local icon = display.newSprite(self.model_.itemIcon_)
            self:addChild(icon,1,111)
	    end
	    
	    --剩余道具数为0
        if CloudData.SKILL_ITEM_INFO[self.itemId_] == 0 then
            --显示+号
            if not self:getChildByTag(112) then display.newSprite("item/add.png",30,30):addTo(self,1,112) end
            --移除剩余数量数字
            if self:getChildByTag(113) then self:removeChildByTag(113) end
        else
            --道具数不为0 移除+号
            if self:getChildByTag(112) then self:removeChildByTag(112) end
            --显示剩余数量数字
            if not self:getChildByTag(113) then
                local redPoint = display.newSprite("item/red_point1.png",30,30):addTo(self,1,113)
                self.label_ = cc.ui.UILabel.new({text = string.format("%d",CloudData.SKILL_ITEM_INFO[self.itemId_]) ,size = 32,font = GameManager.FONTNAME_TTF})
                self.label_:setPosition(cc.p(redPoint:getContentSize().width/2 - 12,redPoint:getContentSize().height/2 + 3))
                redPoint:addChild(self.label_,1)
                redPoint:setScale(0.7)
            end
        end
	end
    
end


function SkillItemIcon:onPressed()
	print("onpress "..self.itemId_)
	
	-- 万字符在卡槽关不生效
	if self.itemId_ == 5 and #Game.TEAM_ICON == 0 then
	    WSToast.new("万字符在卡槽关不可用"):addTo(display.getRunningScene(),50)
		return
	end
    
    -- 还在锁定中
    if self.isUnLocked_ and not self.isInCd_ then
        -- 数量为0 去兑换
        if CloudData.SKILL_ITEM_INFO[self.itemId_] == 0 then
            local sil = SkillItemLayer.new(TYPE_BUY, self.itemId_)
            display.getRunningScene():addChild(sil,20)
        else
        -- 剩余有数量 去释放
            -- 道具使用计数 +1 剩余数量-1
            Game.SKILL_ITEM_USE[self.itemId_] = Game.SKILL_ITEM_USE[self.itemId_] + 1
            CloudData.SKILL_ITEM_INFO[self.itemId_] = CloudData.SKILL_ITEM_INFO[self.itemId_] - 1
            self.label_:setString(string.format("%d",CloudData.SKILL_ITEM_INFO[self.itemId_]))
            if 1 == self.itemId_ then
                self:cast3()
            elseif 2 == self.itemId_ then
                self:cast1()
            elseif 3 == self.itemId_ then
                self:cast2()
            elseif 4 == self.itemId_ then
                self:cast4()
            elseif 5 == self.itemId_ then
                self:cast5()
            elseif 6 == self.itemId_ then
                self:cast6()
            end 
        end
    end
end


--释放技能，和上边方法的区别是不计入过关之后的结算，给短代付钱之后直接使用调用
function SkillItemIcon:castSkill()
    if 1 == self.itemId_ then
        self:cast3()
    elseif 2 == self.itemId_ then
        self:cast1()
    elseif 3 == self.itemId_ then
        self:cast2()
    elseif 4 == self.itemId_ then
        self:cast4()
    elseif 5 == self.itemId_ then
        self:cast5()
    elseif 6 == self.itemId_ then
        self:cast6()
    end 
end


--1.金刚盾：场上所有神仙获得30秒免疫伤害效果（15蟠桃）
function SkillItemIcon:cast1()
    --DataEye统计道具使用
    if USE_DATAEYE then      
        DCItem.consume("JGD", "gamescene", 1, "use to fight")                 
    end
    --出现效果
    local aicl = AlertItemCastAniLayer.new(self.itemId_)
    display.getRunningScene():addChild(aicl,20)
    
	Game.INVINCIBLE = true
    scheduler.performWithDelayGlobal(function()
        Game.INVINCIBLE = false
    end,20)
    
    self.isInCd_ = true
    --
    self.gray_ = display.newSprite("item/gray.png"):addTo(self,2)
    --
    self.progressTimer_ = cc.ProgressTimer:create(display.newSprite(self.model_.itemIcon_)):addTo(self,3)
    self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progressTimer_:setPosition(0,0)
    self.progressTimer_:setMidpoint(cc.p(0,0))
    self.progressTimer_:setBarChangeRate(cc.p(0,1))
    
    local seq = transition.sequence({
        cc.ProgressTo:create(60,100),
        cc.CallFunc:create(function()
            self.isInCd_ = false
            self.progressTimer_:removeSelf()
            self.gray_:removeSelf()
        end),
    })
    
    self.progressTimer_:runAction(seq)   
end


--2.芭蕉扇：所有妖怪被吹到刷新点（10蟠桃）
function SkillItemIcon:cast2()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_item_wind.%s",GameManager.POSTFIX))
	end
    
    --DataEye统计道具使用
    if USE_DATAEYE then      
        DCItem.consume("BJS", "gamescene", 1, "use to fight")                 
    end

    --出现效果
    local aicl = AlertItemCastAniLayer.new(self.itemId_)
    display.getRunningScene():addChild(aicl,20)
    
    --cd
    self.isInCd_ = true
    --
    self.gray_ = display.newSprite("item/gray.png"):addTo(self,2)
    --
    self.progressTimer_ = cc.ProgressTimer:create(display.newSprite(self.model_.itemIcon_)):addTo(self,3)
    self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progressTimer_:setPosition(0,0)
    self.progressTimer_:setMidpoint(cc.p(0,0))
    self.progressTimer_:setBarChangeRate(cc.p(0,1))

    local seq = transition.sequence({
        cc.ProgressTo:create(60,100),
        cc.CallFunc:create(function()
            self.isInCd_ = false
            self.progressTimer_:removeSelf()
            self.gray_:removeSelf()
        end),
    })

    self.progressTimer_:runAction(seq)

    --效果
    local frames = display.newFrames("daojuxuanfeng%d.png", 1, 6)
    local animation = display.newAnimation(frames, 0.1)
    local wind = display.newSprite()
    wind:setAnchorPoint(cc.p(0.5,0))
    wind:setScale(0.4)
    wind:setPosition(Game.TOWER_BUDDHA:getPositionX() - 50, Game.TOWER_BUDDHA:getPositionY())
    Game.BG1:addChild(wind,10)
    wind:playAnimationForever(animation)
    
    local function updateWind() 
        wind:setPosition(cc.pAdd(cc.p(wind:getPosition()),cc.p(-5,0)))
        
        -- 吹起
        for i,monster in pairs(Game.MONSTER_TABLE) do
            if monster:getPositionX() >= wind:getPositionX() then
                if not monster.isFlying_ then
                    monster:flyUp()
                end
            end
        end
        
        if wind:getPositionX() < Game.TOWER_MONSTER:getPositionX() then
            wind:removeSelf()
            -- 落下
            for i,monster in pairs(Game.MONSTER_TABLE) do
                if monster.isFlying_ then
                    monster:fallDown()
                end
            end
        end
        
    end
    
    wind:schedule(function()
        updateWind()
    end,0.02)

end


-- 复活时送的龙卷风
function SkillItemIcon:cast2_Alt()
    --DataEye统计道具使用
    if USE_DATAEYE then  
        DCItem.get("BJS", "gamescene", 1, "appendence of relive")      
        DCItem.consume("BJS", "gamescene", 1, "appendence of relive")                 
    end

    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_item_wind.%s",GameManager.POSTFIX))
    end

    --效果
    local frames = display.newFrames("daojuxuanfeng%d.png", 1, 6)
    local animation = display.newAnimation(frames, 0.1)
    local wind = display.newSprite()
    wind:setAnchorPoint(cc.p(0.5,0))
    wind:setScale(0.4)
    wind:setPosition(Game.TOWER_BUDDHA:getPositionX() - 50, Game.TOWER_BUDDHA:getPositionY())
    Game.BG1:addChild(wind,10)
    wind:playAnimationForever(animation)

    local function updateWind() 
        wind:setPosition(cc.pAdd(cc.p(wind:getPosition()),cc.p(-5,0)))

        -- 吹起
        for i,monster in pairs(Game.MONSTER_TABLE) do
            if monster:getPositionX() >= wind:getPositionX() then
                if not monster.isFlying_ then
                    monster:flyUp()
                end
            end
        end

        if wind:getPositionX() < Game.TOWER_MONSTER:getPositionX() then
            wind:removeSelf()
            -- 落下
            for i,monster in pairs(Game.MONSTER_TABLE) do
                if monster.isFlying_ then
                    monster:fallDown()
                end
            end
        end

    end

    wind:schedule(function()
        updateWind()
    end,0.02)
    
end



--3.老君金丹：立刻获得最大的灵气储量和最多的灵气（20蟠桃）
function SkillItemIcon:cast3()    
    --DataEye统计道具使用
    if USE_DATAEYE then      
        DCItem.consume("LJJD", "gamescene", 1, "use to fight")                 
    end
    
    --出现效果
    local aicl = AlertItemCastAniLayer.new(self.itemId_)
    display.getRunningScene():addChild(aicl,20)

    --cd
    self.isInCd_ = true
    --
    self.gray_ = display.newSprite("item/gray.png"):addTo(self,2)
    --
    self.progressTimer_ = cc.ProgressTimer:create(display.newSprite(self.model_.itemIcon_)):addTo(self,3)
    self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progressTimer_:setPosition(0,0)
    self.progressTimer_:setMidpoint(cc.p(0,0))
    self.progressTimer_:setBarChangeRate(cc.p(0,1))

    local seq = transition.sequence({
        cc.ProgressTo:create(60,100),
        cc.CallFunc:create(function()
            self.isInCd_ = false
            self.progressTimer_:removeSelf()
            self.gray_:removeSelf()
        end),
    })

    self.progressTimer_:runAction(seq)

    -- 效果(当前等级提升一级，回复满灵气)
    if GameManager.TANGMONK_LEVEL < 7 then
        GameManager.TANGMONK_LEVEL = GameManager.TANGMONK_LEVEL + 1
        -- 更新唐僧等级
        display.getRunningScene().upgradeBtn_.labelLevel_:setString(string.format("%d",GameManager.TANGMONK_LEVEL))
        -- 更新下一级升级消耗灵气值
        display.getRunningScene().upgradeBtn_.labelSpirit_:setString(string.format("%d",GameManager.TANGMONK_LEVEL * display.getRunningScene().upgradeBtn_.spiritCostBasic_))
    else
        GameManager.TANGMONK_LEVEL = 8
        -- 更新唐僧等级
        display.getRunningScene().upgradeBtn_:maxLevel()
    end
    Game.SPIRIT_COUNTER:reInit()
    GameManager.setCurrentSpirit(display.getRunningScene().spiritCounter_.maxSpirit_)

    
    -- 效果(直接最大等级，回复满灵气)
    -- GameManager.TANGMONK_LEVEL = 8
    -- display.getRunningScene().upgradeBtn_:maxLevel()
    -- display.getRunningScene().spiritCounter_:reInit()
    -- GameManager.setCurrentSpirit(display.getRunningScene().spiritCounter_.maxSpirit_)
end


--4.金钟罩：给宝塔施加一个等同于宝塔最大血量的护盾（20蟠桃）
function SkillItemIcon:cast4()
    --DataEye统计道具使用
    if USE_DATAEYE then      
        DCItem.consume("JZZ", "gamescene", 1, "use to fight")                 
    end
    
    --出现效果
    local aicl = AlertItemCastAniLayer.new(self.itemId_)
    display.getRunningScene():addChild(aicl,20)

    --cd
    self.isInCd_ = true
    --
    self.gray_ = display.newSprite("item/gray.png"):addTo(self,2)
    --
    self.progressTimer_ = cc.ProgressTimer:create(display.newSprite(self.model_.itemIcon_)):addTo(self,3)
    self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progressTimer_:setPosition(0,0)
    self.progressTimer_:setMidpoint(cc.p(0,0))
    self.progressTimer_:setBarChangeRate(cc.p(0,1))

    local seq = transition.sequence({
        cc.ProgressTo:create(60,100),
        cc.CallFunc:create(function()
            self.isInCd_ = false
            self.progressTimer_:removeSelf()
            self.gray_:removeSelf()
        end),
    })

    self.progressTimer_:runAction(seq)
    
    --生效
    Game.TOWER_BUDDHA:openShield()
end


--5.卍字符：接下来的是个神仙召唤冷却时间减少为0（50蟠桃）（可重复使用）
function SkillItemIcon:cast5()
    --DataEye统计道具使用
    if USE_DATAEYE then      
        DCItem.consume("WZF", "gamescene", 1, "use to fight")                 
    end
    
    --出现效果
    local aicl = AlertItemCastAniLayer.new(self.itemId_)
    display.getRunningScene():addChild(aicl,20)

    --cd
    self.isInCd_ = true
    --
    self.gray_ = display.newSprite("item/gray.png"):addTo(self,2)
    --
    self.progressTimer_ = cc.ProgressTimer:create(display.newSprite(self.model_.itemIcon_)):addTo(self,3)
    self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progressTimer_:setPosition(0,0)
    self.progressTimer_:setMidpoint(cc.p(0,0))
    self.progressTimer_:setBarChangeRate(cc.p(0,1))

    local seq = transition.sequence({
        cc.ProgressTo:create(60,100),
        cc.CallFunc:create(function()
            self.isInCd_ = false
            self.progressTimer_:removeSelf()
            self.gray_:removeSelf()
        end),
    })

    self.progressTimer_:runAction(seq)
    
    -- 生效
    Game.CDZERO = true
    for i,unitIcon in pairs(Game.TEAM_ICON) do
        unitIcon:removeProTimer()
    end
end


--6.献宝令：战斗结束后100%几率得到金色品质宝物（50蟠桃）
function SkillItemIcon:cast6()
    --DataEye统计道具使用
    if USE_DATAEYE then      
        DCItem.consume("XBL", "gamescene", 1, "use to fight")                 
    end
    
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_item_treasureget.%s",GameManager.POSTFIX))
	end

    --出现效果
    local aicl = AlertItemCastAniLayer.new(self.itemId_)
    display.getRunningScene():addChild(aicl,20)

    --cd
    self.isInCd_ = true
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_item_treasureget.%s",GameManager.POSTFIX))
	end
end



























return SkillItemIcon

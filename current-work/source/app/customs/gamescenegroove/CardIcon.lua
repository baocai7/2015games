
--TYPE:1.兵种卡    2灵气卡    3升级卡      4照妖镜卡 
TYPE_CARD_BUDDHA    = 1
TYPE_CARD_SPIRIT    = 2
TYPE_CARD_UPGRADE   = 3
TYPE_CARD_MIRROR    = 4

local Buddha = import("sprites.Buddha")

local CardIcon = {} 
CardIcon = class("CardIcon", function()
    return display.newNode()
end)

function CardIcon:ctor( type, position )

    self.TYPE_ = type       --TYPE:1.兵种卡    2灵气卡    3升级卡      4照妖镜卡 

    self:setPosition(position)

    --边框
    self.sprite_ = display.newSprite("gamescenegroove/frame.png"):addTo(self,2)
    self:setContentSize(self.sprite_:getContentSize())

    --点击事件
    self.sprite_:setTouchEnabled(true) -- enable sprite touch
    self.sprite_:setTouchSwallowEnabled(true)
    self.sprite_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y, prevX, prevY = event.name, event.x, event.y, event.prevX, event.prevY
        if name == "began" then
            self.x_ = x
            self.y_ = y
            return true
        end
        
        local touchInSprite = cc.rectContainsPoint(self.sprite_:getCascadeBoundingBox(), cc.p(x, y))
        
        if name == "moved" then
            local offsetY = y - self.y_
            if offsetY > 100 and not self.inDelete_ then
                self.inDelete_ = true
                table.removebyvalue(Game.CARD_TABLE, self, false)
                local spawn = cc.Spawn:create(cc.MoveBy:create(0.6,cc.p(0,100)),cc.FadeOut:create(0.6))
                self:runAction(transition.sequence({spawn,cc.CallFunc:create(function() 
                    self:removeSelf()
                end)}))
            end
        elseif name == "ended" then
            if touchInSprite then self:onPressed() end
        else
        end
    end)

    if TYPE_CARD_BUDDHA == self.TYPE_ then
        
        --所有坦克的model
        local Tanks = {}
        local Others = {}
        for i,buddhaId in pairs(Game.TEAM_TABLE) do
            local buddhaModel = DataUtils.getBuddhaModel(buddhaId)
            --print("buddhaId  " .. buddhaId .. "   buddhaModel.tag1_   " .. buddhaModel.tag1_)
            if buddhaModel.tag1_ == "1" then
            	Tanks[#Tanks + 1] = buddhaId
            else
                Others[#Others + 1] = buddhaId
            end
        end
        
        --二分之一概率出T
        local randomNum = math.random(0,100)
        if randomNum < 50 then
            --出坦克
            if #Tanks ~= 0 then
            	--有坦克
                if #Tanks == 1 then
                    --只有一个坦克
                    local buddhaId = Tanks[1]
                    self.model_ = DataUtils.getBuddhaModel(buddhaId)
                else
                    local randomNum = math.random(1,#Tanks)
                    local buddhaId = Tanks[randomNum]
                    self.model_ = DataUtils.getBuddhaModel(buddhaId)
                end
            else
                --无坦克 出其他
                if #Others == 1 then
                    --只有一个其他
                    local buddhaId = Others[1]
                    self.model_ = DataUtils.getBuddhaModel(buddhaId)
                else
                    local randomNum = math.random(1,#Others)
                    local buddhaId = Others[randomNum]
                    self.model_ = DataUtils.getBuddhaModel(buddhaId)
                end
            end
        else
            --出其他
            if #Others ~= 0 then
                --有其他
                if #Others == 1 then
                	--只有一个其他
                    local buddhaId = Others[1]
                    self.model_ = DataUtils.getBuddhaModel(buddhaId)
                else
                    local randomNum = math.random(1,#Others)
                    local buddhaId = Others[randomNum]
                    self.model_ = DataUtils.getBuddhaModel(buddhaId)
                end
            else
            --没有其他，还出坦克
                if #Tanks == 1 then
                    local buddhaId = Tanks[1]
                    self.model_ = DataUtils.getBuddhaModel(buddhaId)
                else
                    local randomNum = math.random(1,#Tanks)
                    local buddhaId = Tanks[randomNum]
                    self.model_ = DataUtils.getBuddhaModel(buddhaId)
                end
            end
        end
        
        --根据品质选择边框
        local quality = tonumber(self.model_.quality_) + 1
        display.newSprite(string.format("gamescenegroove/frame%d.png",quality)):addTo(self,2)
        
        --icon
        local icon = display.newSprite(self.model_.icon_):addTo(self)
        icon:setScale(0.8)
        if self.model_.isRebel_ == "1" then
            icon:setScaleX(-1 * 0.8)
        end
        
        
        --初始化阴影（默认不显示，兵种CD用）
        self.shadow_ = display.newSprite("gamescene/iconshadow.png"):addTo(self,1)
        self.shadow_:setScale(0.8)
        self.shadow_:setVisible(false)

        --消耗灵气显示框
        self.spiritFrame_ = display.newSprite("gamescene/spirit_icon.png",0,-45):addTo(self,3)
        self.spiritFrame_:setScale(0.9)
        --制造该兵种所消耗灵气
        self.spiritCostNum_ = tonumber(self.model_.costValue_) or 40
        --灵气数值标签
        self.spiritCostLabel_ = cc.ui.UILabel.new({
            UILabelType = 2,text = string.format("%d", self.spiritCostNum_),size = 22,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
            :align(display.CENTER,self.spiritFrame_:getContentSize().width * 0.6,self.spiritFrame_:getContentSize().height * 0.28)
            :addTo(self.spiritFrame_)
        --监测灵气值得计时器
        self.schedule_ = self:schedule(function()
            self:updateSpirit()
        end , 0.1)

        --当前是否可以制造兵种
        self.isReadyToSpawn_ = false
    elseif TYPE_CARD_SPIRIT == self.TYPE_ then
        self.SPIRIT_TYPE_ = 0
        self.spiritAdd_ = 0
        local quality = 0
        local name = ""
        local randomNum = math.random(0,40)
        if randomNum <= 30 then
        	self.SPIRIT_TYPE_ = 1
        	self.spiritAdd_ = 0.25 * display.getRunningScene().spiritCounter_.maxSpirit_
        	name = "灵气符"
        	quality = 1
        elseif randomNum >30 and randomNum <= 40 then
            self.SPIRIT_TYPE_ = 2
            self.spiritAdd_ = 0.5 * display.getRunningScene().spiritCounter_.maxSpirit_
            name = "超级灵气符"
            quality = 5
        end
        --根据品质选择边框
        display.newSprite(string.format("gamescenegroove/frame%d.png",quality)):addTo(self,2)
        --icon
        local icon = display.newSprite(string.format("gamescenegroove/spirit%d.png",self.SPIRIT_TYPE_)):addTo(self)
        --名字标签
        local label = cc.ui.UILabel.new({
            text = name, size = 16, font = GameManager.FONTNAME_TTF, color = display.COLOR_WHITE})
            :align(display.CENTER,0,-self.sprite_:getContentSize().height * 0.33)
            :addTo(self,3)
    elseif TYPE_CARD_UPGRADE == self.TYPE_ then
        --icon
        local icon = display.newSprite("gamescenegroove/upgrade.png"):addTo(self)
        icon:setScale(0.95)
        --名字标签
        local label = cc.ui.UILabel.new({
            text = "聚灵符",size = 18,font = GameManager.FONTNAME_TTF,color = display.COLOR_WHITE})
            :align(display.CENTER,self.sprite_:getContentSize().width * 0.5,self.sprite_:getContentSize().height * 0.16)
            :addTo(self.sprite_)
    elseif TYPE_CARD_MIRROR == self.TYPE_ then
        --icon
        local icon = display.newSprite("gamescenegroove/mirror.png"):addTo(self)
        icon:setScale(0.95)
        --名字标签
        local label = cc.ui.UILabel.new({
            text = "照妖棍",size = 18,font = GameManager.FONTNAME_TTF,color = display.COLOR_WHITE})
            :align(display.CENTER,self.sprite_:getContentSize().width * 0.5,self.sprite_:getContentSize().height * 0.16)
            :addTo(self.sprite_)
            
        --当场面上有照妖镜的时候，显示攻击距离
        display.getRunningScene().fireBtn_:readyForFire()
    end
    

    --  添加一个每0.05秒刷新的方法
    self.schedule_selector_ = self:schedule(function()
        self:updateLogic()
    end , 0.05)
    
end




function CardIcon:updateLogic()

    for i,card in pairs(Game.CARD_TABLE) do
        if card ~= self then
            if cc.rectIntersectsRect(self:getMyBoundingBox(true),card:getMyBoundingBox(false)) then
                return
            end
        end
    end

    if self:getPositionX() > Game.leftPoint and not self.inDelete_ then
        self:setPosition(cc.pAdd(cc.p(self:getPosition()),cc.p(-5,0)))
    end
end


--兵种卡监测灵气方法
function CardIcon:updateSpirit()

    local currentSpirit = tonumber(GameManager.getCurrentSpirit()) or 0
    if not self.isSpawnInCoolDown_ and currentSpirit >= self.spiritCostNum_ then
        --冷却完成 and 有足够灵气制造兵种
        self.shadow_:setVisible(false)
        self.isReadyToSpawn_ = true
    else
        --冷却中 or 灵气不足
        self.shadow_:setVisible(true)
        self.isReadyToSpawn_ = false
    end
end

--点击Icon
function CardIcon:onPressed()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_buddha_makeup.%s",GameManager.POSTFIX))
	end
	
    if TYPE_CARD_BUDDHA == self.TYPE_ then
    	if self.isReadyToSpawn_ then

            self.isReadyToSpawn_ = false
    
            --扣除灵气操作
--            GameManager.CURRENT_SPIRIT = GameManager.CURRENT_SPIRIT - self.spiritCostNum_
            local currentSpirit = tonumber(GameManager.getCurrentSpirit()) or 0
            GameManager.setCurrentSpirit(currentSpirit - self.spiritCostNum_)
            
            --制造兵种
            local buddha = Buddha.new(self.model_, cc.p(Game.TOWER_BUDDHA:getPosition()))
            Game.BG1:addChild(buddha,buddha.zOrder_)
            Game.BUDDHA_TABLE[#Game.BUDDHA_TABLE + 1] = buddha
    
            --移除自己
            table.removebyvalue(Game.CARD_TABLE, self, false)
            self:removeSelf()
        end
    elseif TYPE_CARD_SPIRIT == self.TYPE_ then
        
--        GameManager.CURRENT_SPIRIT = GameManager.CURRENT_SPIRIT + self.spiritAdd_
        local currentSpirit = tonumber(GameManager.getCurrentSpirit()) or 0
        GameManager.setCurrentSpirit(currentSpirit + self.spiritAdd_)
        --移除自己
        table.removebyvalue(Game.CARD_TABLE, self, false)
        self:removeSelf()
        
    elseif TYPE_CARD_UPGRADE == self.TYPE_ then
    
        display.getRunningScene().upgradeBtn_:upgrade()
        --移除自己
        table.removebyvalue(Game.CARD_TABLE, self, false)
        self:removeSelf()
        
    elseif TYPE_CARD_MIRROR == self.TYPE_ then

        Game.TOWER_BUDDHA:wandAttack()

        display.getRunningScene().fireBtn_:fire()
        --场景上不再显示攻击距离
        display.getRunningScene().fireBtn_:cd()
        --移除自己
        table.removebyvalue(Game.CARD_TABLE, self, false)
        self:removeSelf()
    end
end




--获得碰撞区域   isAttacking 为true时加入攻击范围
function CardIcon:getMyBoundingBox( isAttacking )
    local attackDistance = 0
    if isAttacking then
        attackDistance = 10
    end

    local position = cc.p(self:getPosition())
    local size = self.sprite_:getContentSize()
    local rect = cc.rect( position.x - size.width/2 - attackDistance,
        position.y - size.height/2,
        size.width,
        size.height)
    return rect
end

return CardIcon

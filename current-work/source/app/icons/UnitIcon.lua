
local Buddha = import("sprites.Buddha")

local UnitIcon = {} 
UnitIcon = class("UnitIcon", function()
    return display.newNode()
end)

function UnitIcon:ctor(buddhaModel)

    self.model_ = buddhaModel
    buddhaModel = nil

    -- 标记当前是队列里的第几个,在GameScene里布置UI时赋值
    self.idx_ = 0

	--兵种边框
	self.sprite_ = display.newSprite("common_ui/tou.png"):addTo(self)
    self:setContentSize(self.sprite_:getContentSize())
    
    --自动出战素材
    self.autoSprite_ = display.newSprite("gamescene/auto.png"):addTo(self.sprite_,-1)
    self.autoSprite_:setPosition(cc.p(self.sprite_:getContentSize().width/2,-10))
    self.autoSprite_:setVisible(false)
	
	--点击事件
    self.sprite_:setTouchEnabled(true) -- enable sprite touch
    self.sprite_:setTouchSwallowEnabled(true)
    self.sprite_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y, prevX, prevY = event.name, event.x, event.y, event.prevX, event.prevY
--        if name == "began" then
--            self:onPressed()
--            return true
--        end

        if name == "began" then
            self.x_ = x
            self.y_ = y
            return true
        end

        local touchInSprite = cc.rectContainsPoint(self.sprite_:getCascadeBoundingBox(), cc.p(x, y))

        if name == "moved" then
            local offsetY = y - self.y_
            self:changeAutoMode(offsetY)
            
        elseif name == "ended" then
            if touchInSprite then self:onPressed() end
        else
        end
        
    end)

	--icon
	local icon = display.newSprite(self.model_.icon_):addTo(self)
	if self.model_.isRebel_ == "1" then
		icon:setScaleX(-1)
	end

	--初始化阴影（默认不显示，兵种CD用）
	self.shadow_ = display.newSprite("gamescene/iconshadow.png"):addTo(self,2)
	self.shadow_:setVisible(false)

	--消耗灵气显示框
	self.spiritFrame_ = display.newSprite("gamescene/spirit_icon.png",0,-40):addTo(self,2)
	--制造该兵种所消耗灵气
    self.spiritCostNum_ = tonumber(self.model_.costValue_) or 40
	--灵气数值标签
	self.spiritCostLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = string.format("%d", self.spiritCostNum_),size = 24,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.spiritFrame_:getContentSize().width * 0.6,self.spiritFrame_:getContentSize().height * 0.33)
        :addTo(self.spiritFrame_)

    --石头剪刀布标识
    local buddhaRestrainType = tonumber(self.model_.restrainType_)
    if buddhaRestrainType > 0 and buddhaRestrainType < 4 then
        local pMark = display.newSprite(string.format("buddha_icon/restrain_icon"..buddhaRestrainType..".png"))
            --:pos(self.sprite_:getContentSize().width * 0.5,self.sprite_:getContentSize().height * 0.5)
            --:addTo(self.sprite_)
            :addTo(self,1)
    end    

	--监测灵气值得计时器
	self.schedule_ = self:schedule(function()
                    self:updateSpirit()
                end , 0.02)

	--当前是否可以制造兵种
	self.isReadyToSpawn_ = false
	--该兵种是否在CD中
	self.isSpawnInCoolDown_ = false
end

function UnitIcon:changeAutoMode(offsetY)

    if offsetY > 50 and (not self.inAutoMode_) and (not Game.CDZERO) then
        self.inAutoMode_ = true
        self.autoSprite_:setVisible(true)
        self:runAction(cc.MoveBy:create(0.3,cc.p(0,30)))
    end
    if offsetY < -50 and self.inAutoMode_ then
        self.inAutoMode_ = false
        self.autoSprite_:setVisible(false)
        self:runAction(cc.MoveBy:create(0.3,cc.p(0,-30)))
        if Game.CDZERO then
            --根据tag值获取卐字符特效光圈,与UI同步
            if display.getRunningScene():getChildByTag(10086 + self.idx_) then
                local sp = display.getRunningScene():getChildByTag(10086 + self.idx_)
                sp:runAction(cc.MoveBy:create(0.3,cc.p(0,-30)))
            end 
        end
    end
	
end

function UnitIcon:updateSpirit()

    local currentSpirit = tonumber(GameManager.getCurrentSpirit()) or 0
    if not self.isSpawnInCoolDown_ and currentSpirit >= self.spiritCostNum_ then
		--冷却完成 and 有足够灵气制造兵种
		self.shadow_:setVisible(false)
		self.isReadyToSpawn_ = true
		
        -- 自动出兵
		if self.inAutoMode_ then self:onPressed() end
	else
		--冷却中 or 灵气不足
		self.shadow_:setVisible(true)
		self.isReadyToSpawn_ = false
	end

    -- 使用卍字符时取消自动出兵
    if self.inAutoMode_ and Game.CDZERO then
        self:changeAutoMode(-100)
    end
end

--点击Icon制造兵种
function UnitIcon:onPressed()

    if self.isReadyToSpawn_ then
		if GameManager.SOUND_SWITCH_ON then
			audio.playSound(string.format("sounds/sfx_buddha_makeup.%s",GameManager.POSTFIX))
		end

        self.isReadyToSpawn_ = false
        self.isSpawnInCoolDown_ = true
        
        --扣除灵气操作
--        GameManager.CURRENT_SPIRIT = GameManager.CURRENT_SPIRIT - self.spiritCostNum_
        local currentSpirit = tonumber(GameManager.getCurrentSpirit()) or 0
        currentSpirit = currentSpirit - self.spiritCostNum_
        GameManager.setCurrentSpirit(currentSpirit)

        --制造兵种
        local buddha = Buddha.new(self.model_, cc.p(Game.TOWER_BUDDHA:getPositionX() - 30,Game.TOWER_BUDDHA:getPositionY()))
        Game.BG1:addChild(buddha,buddha.zOrder_)
        Game.BUDDHA_TABLE[#Game.BUDDHA_TABLE + 1] = buddha

        --进入CD
        self.shadow_:setVisible(true)
        self.spiritFrame_:setVisible(false)
        --加载cd条
        self.progress_ = display.newProgressTimer("gamescene/bar_green.png", display.PROGRESS_TIMER_BAR)
            :pos(0,-40)
            :addTo(self,2)
        self.progress_:setMidpoint(cc.p(0,0))
        self.progress_:setBarChangeRate(cc.p(1,0))
        self.progress_:setPercentage(0)
        -- todo 计算CD时间(后续导入公式计算)
        local realCDTime = tonumber(self.model_.cdTime_) or 2
        if realCDTime < 2 then
            realCDTime = 2
        end

        -- 卍字符效果
        if Game.CDZERO then
            -- 计数+1
            Game.makeBuddhaNumInCDZERO = Game.makeBuddhaNumInCDZERO + 1

            if Game.makeBuddhaNumInCDZERO <= 10 then          -- 卍字符生效
                -- cd位0
                realCDTime = 0
            else                                              -- 取消卍字符效果
                -- 数据重置
                Game.makeBuddhaNumInCDZERO = 0
                Game.CDZERO = false
                -- 移除特效
                for i=1,#Game.TEAM_ICON do
                    display.getRunningScene():removeChildByTag(10086 + i,true)
                end
            end
        end

        
        local progressTo = cc.ProgressTo:create(realCDTime,100);    --设置刷新时间
        transition.execute(self.progress_, progressTo, {
            onComplete = function()
                self:removeProTimer()
            end
        })
    end
end

function UnitIcon:removeProTimer()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_buddha_cooldown.%s",GameManager.POSTFIX))
	end

	--显示灵气框
	self.spiritFrame_:setVisible(true)
	--移除cd条
    if self.progress_ ~= nil then
        self.progress_:removeFromParent()
        self.progress_ = nil
	end

	self.isSpawnInCoolDown_ = false
end

return UnitIcon

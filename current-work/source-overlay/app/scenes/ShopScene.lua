--
--商店界面（购买物品）
--
local DataLabelIcon = import("icons.DataLabelIcon")
local ShopIcon = import("icons.ShopIcon")
--local WarResultLayer = import("..layers.WarResultLayer")
--local NewFellowLayer = import("..layers.NewFellowLayer")
local AlertConnection = import("..customs.AlertConnection")
local WSToast = import("..utils.WSToast")

local ShopScene = class("ShopScene", function()
    return display.newScene("ShopScene")
end)

function ShopScene:ctor()
    
    --背景图片
    local bg_ = display.newSprite("common_ui/uibg.jpg",display.cx,display.cy):addTo(self)

    --"商店"标签
    local shopTitle_ = display.newSprite("shop/title_shop.png",bg_:getContentSize().width * 0.3,bg_:getContentSize().height * 0.93):addTo(bg_)
		shopTitle_:setScale(0.9)

    --经验
    local expLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_EXP,true)
    expLabel:setScale(0.8)
    expLabel:setPosition(cc.p(bg_:getContentSize().width * 0.55,bg_:getContentSize().height * 0.93))
    bg_:addChild(expLabel,15)
    --蟠桃
    local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH,true)
    peachLabel:setScale(0.8)
    peachLabel:setPosition(cc.p(bg_:getContentSize().width * 0.82,bg_:getContentSize().height * 0.93))
    bg_:addChild(peachLabel,15)
    --返回按钮
    cc.ui.UIPushButton.new({normal = "common_ui/back.png",pressed = "common_ui/back_h.png"})
        :scale(0.8)
        :align(display.CENTER,bg_:getContentSize().width * 0.12 ,bg_:getContentSize().height * 0.93)
        :onButtonClicked(function()
            self:returnCallBack_()
        end)
        :addTo(bg_,15)

    --下次刷新
    local flushSprite_ = display.newSprite("shop/nextflush.png")
		:pos(bg_:getContentSize().width * 0.5 - bg_:getContentSize().height * 0.16, bg_:getContentSize().height * 0.065)
		:addTo(bg_)

    --经历倒计时,color = display.COLOR_GREEN
    self.flushLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = "",size = 28,color = display.COLOR_GREEN,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,flushSprite_:getContentSize().width * 0.75,flushSprite_:getContentSize().height * 0.5)
        :addTo(flushSprite_)

    --立即刷新
    cc.ui.UIPushButton.new({normal = "shop/flush.png",pressed = "shop/flush_h.png"})
        :align(display.CENTER,bg_:getContentSize().width * 0.5 + bg_:getContentSize().height * 0.16,
            bg_:getContentSize().height * 0.065)
        :onButtonClicked(function()
            self:pressFlushCallBack_()
        end)
        :addTo(bg_, 1)

    self.propBack_ = display.newSprite("shop/shopdi.png",bg_:getContentSize().width * 0.5,
        bg_:getContentSize().height * 0.5)
        :addTo(bg_)  
		self.propBack_:setScale(0.9)		
	
	self:initData()
	self:addAndroidReturnButton_()
end

function ShopScene:initData()
	local ac = AlertConnection.new(CONNECTION_SHOP_INIT)
    self:addChild(ac, 100, 12345)
    
    self.scheduleResult_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)
            self.shopInfo_ = CloudData.SHOP_INFO
--            dump(self.shopInfo_)
			self:initIcon_(true)
        end
    end,0.1)
end

function ShopScene:initIcon_(countTag)
	if countTag then
		self.flushTime_ = tonumber(self.shopInfo_.data.nextFreshTime)
		self:startCountDown_(self.flushTime_)
	end
	self.iconsTable_ = {}
    for i = 1, 6 do	
		local content = ShopIcon.new(self.shopInfo_.data.goodsList[i], i)
			content:setPosition(self.propBack_:getContentSize().width * (((i - 1) % 3)*0.32 + 0.18),
			self.propBack_:getContentSize().height*(0.74 - math.floor(i/4)*0.48))
			self.propBack_:addChild(content)
		self.iconsTable_[i] = content
	end		
end

function ShopScene:startCountDown_(time)
	--转换时分秒
    self.hour_    = math.floor(time / 3600)
    self.minutes_ = math.floor((time - self.hour_ * 3600) / 60)
    self.seconds_ = math.floor(time - self.hour_ * 3600 - self.minutes_ * 60)
	
	print(" ** time --"..time)
	print(" ** self.hour_ --"..self.hour_)
	print(" ** self.minutes_ --"..self.minutes_)
	print(" ** self.seconds_ --"..self.seconds_)
	
    --倒计时
    self.schedule_ = self:schedule(function()
        self:updateTime_()
    end, 1.0)
end

function ShopScene:updateTime_()
	if self.seconds_ > 0 then
        self.seconds_ = self.seconds_ - 1
    else
        if self.minutes_ > 0 then
            self.seconds_ = 59
            self.minutes_ = self.minutes_ - 1
        else
            if self.hour_ > 0 then
                self.seconds_ = 59
                self.minutes_ = 59
                self.hour_    = self.hour_ - 1
            else
                self:countdownOver_()
            end
        end
    end
	
    --倒计时标签刷新
    self.flushLabel_:setString(string.format("%02d:%02d:%02d",self.hour_,self.minutes_,self.seconds_))
end

function ShopScene:countdownOver_()
	self:stopAction(self.schedule_)
end

function ShopScene:returnCallBack_()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
	end
    
    display.replaceScene(require("scenes.ChapterScene").new())
end

function ShopScene:pressFlushCallBack_()
    print("Flush immediately!")	
		
	if CloudData.PEACH < 20 then
		local t = WSToast.new("蟠桃不足", 1)
		self:addChild(t, 20)
	else
		local ac = AlertConnection.new(CONNECTION_SHOP_REFRESH)
		self:addChild(ac, 100, 12345)
    
		self.scheduleResult_ = self:schedule(function() 
			if not self:getChildByTag(12345) then
				self:stopAction(self.scheduleResult_)
				self.shopInfo_ = CloudData.SHOP_INFO
			
				
				self:flushSuccessfully_()
			end
		end,0.1)
	end
end

function ShopScene:flushSuccessfully_()
	if self.hour_ + self.minutes_ + self.seconds_ > 0 then
		CloudData.PEACH = CloudData.PEACH - 20
		self:initIcon_(false)
	else 
		self:initIcon_(true)
	end
	print("flushSuccessfully_***************")
end

function ShopScene:addAndroidReturnButton_()
	--退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
		btn:setKeypadEnabled(true)
        btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
            if event.key == "back" then
				self:showReturnWarning_()
			end
		end)
end

function ShopScene:showReturnWarning_()
	if self.returnMask ~= nil then
        return
    end
    self.returnMask = display.newColorLayer(cc.c4b(0,0,0,150))
    self:addChild(self.returnMask,20000)
    
    local bg = display.newSprite("common_ui/common_bg.png"):pos(display.cx, display.cy):addTo(self.returnMask,1)
    cc.ui.UILabel.new({
        text = "确定退出？" ,size = 32,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.57)
        :addTo(bg)
        
    --确定按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.22)
        :onButtonClicked(function()
            if PaymentInfo.CHANNEL == 3 then
                --酷狗SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitKugou"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            elseif PaymentInfo.CHANNEL == 4 then
                --UC SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitUC"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            elseif BAIDU_PROMOTION then
                --Baidu SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitBaidu"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            else
                cc.Director:getInstance():endToLua()
                if device.platform == "windows" or device.platform == "mac" then
                    os.exit()
                end
            end
        end)
        :addTo(bg,2)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.95,bg:getContentSize().height * 0.95)
        :onButtonClicked(function()
            self.returnMask:removeSelf()
            self.returnMask = nil
        end)
        :scale(0.8)
        :addTo(bg,2)
end

function ShopScene:onEnter()
end

function ShopScene:onExit()
    self:removeAllChildren()
    display.removeUnusedSpriteFrames()
end

return ShopScene

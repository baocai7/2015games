--
--签到
--
local AlertConnection = import("customs.AlertConnection")
local NewFellowLayer   = import("layers.NewFellowLayer")

local ShowSignAwardLayer = import("layers.ShowSignAwardLayer")
local SignLayer = class("SignLayer", function ()
	return display.newLayer()
end)

function SignLayer:ctor()
	--添加遮罩层
	self.mask = display.newColorLayer(cc.c4b(0,0,0,150))
		:addTo(self,-1)
	
	--初始化基础节点	
	self.node = display.newNode()
		:scale(0)
		:pos(display.cx, display.cy)
		:addTo(self,1)
	
	--弹出效果	
	local popupLayer = transition.sequence(
			{cc.ScaleTo:create(0.2, 1.1),
			cc.ScaleTo:create(0.1, 1.0)})
		self.node:runAction(popupLayer)

	--播放音效(打开层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end
	
	--初始化界面
	self:requestData()
end

function SignLayer:requestData()
	local ac = AlertConnection.new(CONNECTION_SIGN_INFO_INIT)
    self:addChild(ac, 100, 12345)
    
    self.scheduleResult_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)
            self.signInfo_ = CloudData.SIGN_INFO
            dump(self.shopInfo_)
			self:initData()
        end
    end,0.1)
end

function SignLayer:initData()
	--1.应签到序号：  	self.time_
	--2.今日是否已签到: self.tag_
	self.time_ = CloudData.SIGN_WEEK_NUM + 1
	self.tag_ = CloudData.IS_SIGNED_TODAY	
	print("**************self.time_" .. self.time_)
	print("***************self.tag_")
	print(self.tag_)
	self:initUI_()
end

function SignLayer:initUI_()
	--背景
	self.bg_ = display.newSprite("sign/bg_frame.png")
		:addTo(self.node)
			
	if self.tag_ then
		display.newSprite("sign/signed.png")
			:align(display.CENTER,self.bg_:getContentSize().width * 0.82,self.bg_:getContentSize().height * 0.52)
			:addTo(self.bg_)
	else
		self.sign = cc.ui.UIPushButton.new({normal = "sign/sign.png",pressed = "sign/sign_h.png", disabled = "sign/signed.png"})
		:align(display.CENTER,self.bg_:getContentSize().width * 0.82,self.bg_:getContentSize().height * 0.52)
        :addTo(self.bg_)
		:onButtonClicked(function()
			self:toSign_()
        end)
	end
	
	--奖励图标	
	for i = 1, 7 do
		print("*****************" .. i)
		dump(self.signInfo_.data[i])
		local type_ = self.signInfo_.data[i].itemType
		local itemId_ = self.signInfo_.data[i].itemId
		
		local iconframe = display.newSprite("sign/signk.png")
			:scale(0.9)
			:align(display.CENTER,self.bg_:getContentSize().width * (0.04 + i * 0.114), self.bg_:getContentSize().height * 0.288)
			:addTo(self.bg_)
			iconframe:setTag(i)
		
		local img = nil
		if type_ == 1 then
			img = "sign/pantao.png"
		elseif type_ == 2 then
			img = "sign/renshen.png"
		elseif type_ == 3 then  --经验
			img = "sign/exp.png"
		elseif type_ == 6 then  -- 扫荡券
			img = "sign/saodang.png"
		elseif type_ == 4 then  --神仙
			if itemId_ == 6 then
				img = "sign/miao.png"
			else
				img = "sign/bajie.png"
			end	
		else
			img = "sign/item.png"
		end
		
		local icon = cc.ui.UIPushButton.new(img)
		:pos(iconframe:getContentSize().width * 0.5,iconframe:getContentSize().height * 0.5)
        :addTo(iconframe,-1)
   --      :onButtonClicked(function()
			-- self:showAwardTips_(i)
   --      end)
        :onButtonPressed(function()
        	self:showAwardTips_(i)
        end)
        :onButtonRelease(function()
    		self.tip_:hide()
    		self.tipInfo_:hide()
        end)
			
		local num = cc.ui.UILabel.newBMFontLabel_({text = "x" .. self.signInfo_.data[i].itemNum, font = "fonts/yellowNum.fnt"})		
			:scale(0.5)
			:pos(iconframe:getContentSize().width - 15,iconframe:getContentSize().height * 0.235)
			:addTo(iconframe)
			num:setAnchorPoint(1.0,1.0)	
			
		if  i < self.time_ or (i == self.time_ and self.tag_) then
			local icon = display.newSprite("sign/shadow.png")
			:align(display.CENTER,iconframe:getContentSize().width * 0.5,iconframe:getContentSize().height * 0.5)
			:addTo(iconframe)
		end														
	end
		
	--未签到时出现签到提示图片
	local point1 = cc.p(self.bg_:getContentSize().width * (0.04 + self.time_ * 0.114),
			self.bg_:getContentSize().height * 0.48)
	if not self.tag_ then							
		local point2 = cc.p(point1.x, point1.y - 20)
		self.notice = display.newSprite("sign/reward_pic.png")
			:align(display.CENTER,point1.x, point1.y)
			:addTo(self.bg_)
		self.notice:runAction(cc.RepeatForever:create(transition.sequence({cc.MoveTo:create(0.7,point2),
		cc.MoveTo:create(0.7,point1)})))				
	end
	
	self.tip_ = display.newSprite("sign/tips.png")
		--:pos(point1.x + 50, point1.y + 20)
		:addTo(self.bg_)
				
	self.tipInfo_ = cc.ui.UILabel.new({text = "",size = 25,color = display.WHITE,
		font = GameManager.FONTNAME_TTF,dimensions = cc.size(175,85)})
		--:scale(0.5)
		:align(display.CENTER, self.tip_:getContentSize().width*0.52,self.tip_:getContentSize().height*0.45)
		:addTo(self.tip_)
	self.tip_:setAnchorPoint(0.5, 0)
	self.tip_:setVisible(false)
		
	--关闭按钮	
	cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
		:scale(0.8)
		:align(display.CENTER,self.bg_:getContentSize().width * 0.93,self.bg_:getContentSize().height * 0.71)
        :addTo(self.bg_)
		:onButtonClicked(function()
			self:closeCallBack_()
        end)
end

function SignLayer:showAwardTips_(index)
	self.tip_:setPosition(self.bg_:getContentSize().width * (0.04 + index * 0.114), self.bg_:getContentSize().height * 0.288 + 50)
	self.tip_:setVisible(true)
	self.tipInfo_:setString(self.signInfo_.data[index].description)
	self.tipInfo_:setVisible(true)
end
--点击签到按钮
function SignLayer:toSign_()
	local ac = AlertConnection.new(CONNECTION_SIGN_TODAY)
    self:addChild(ac, 100, 12345)
    
    self.scheduleResult_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)          
			self:signSuccess_()
        end
    end,0.1)	
end

function SignLayer:signSuccess_()
	--改变当日签到状态和已签到次数
	CloudData.IS_SIGNED_TODAY = true
	--CloudData.SIGN_WEEK_NUM = CloudData.SIGN_WEEK_NUM + 1
	--弹出获得奖励提示界面
	local show = ShowSignAwardLayer.new(self.signInfo_.data[self.time_])
	self:addChild(show,20)
	
	--禁用签到按钮
	self.sign:setButtonEnabled(false)
	
	--将当日签到奖励设置为灰色
	local type_ = self.signInfo_.data[self.time_].itemType
	local num_ = self.signInfo_.data[self.time_].itemNum
	local itemId_ = self.signInfo_.data[self.time_].itemId
	--local img = nil
	
	--dump(CloudData.SKILL_ITEM_INFO)	
	if type_ == 1 then 		--蟠桃
		--img = "sign/pantao_h.png"
		CloudData.PEACH = CloudData.PEACH + num_

        --DataEye统计蟠桃产出
        if USE_DATAEYE then
            DCCoin.gain("sign", "peach", num_, CloudData.PEACH)              
        end
	elseif type_ == 2 then  --人参果
		--img = "sign/renshen_h.png"
		CloudData.GINSENG_FRUIT = CloudData.GINSENG_FRUIT + num_
	elseif type_ == 3 then  --经验
		--img = "sign/exp_h.png"
		CloudData.EXP = CloudData.EXP + num_
	elseif type_ == 6 then  -- 扫荡券
		--img = "sign/saodang_h.png"
		CloudData.SWEEP = CloudData.SWEEP + num_
	elseif type_ == 4 then  --神仙
		local buddhaModel = DataUtils.getBuddhaModel(itemId_)
		if buddhaModel.buddhaState_ == 1 then
			CloudData.ESSENCE = CloudData.ESSENCE + buddhaModel.essenceValue_
		else
			local layer = NewFellowLayer.new(buddhaModel)
			self:addChild(layer,20)
			DataUtils.setNewBuddhaCloudData(itemId_)
		end      
	elseif type_ == 5 then  -- 道具
--		img = "sign/item_h.png"
		for i = 1, 6 do
			CloudData.SKILL_ITEM_INFO[i] = CloudData.SKILL_ITEM_INFO[i] + 1
		end	
		--DataEye统计道具使用
	    if USE_DATAEYE then  
	        DCItem.get("JGD", "sign", 1, "reward for sign")      
	        DCItem.get("BJS", "sign", 1, "reward for sign")
	        DCItem.get("JZZ", "sign", 1, "reward for sign")
	        DCItem.get("LJJD", "sign", 1, "reward for sign")
	        DCItem.get("WZF", "sign", 1, "reward for sign")
	        DCItem.get("XBL", "sign", 1, "reward for sign")               
	    end
	end
	
	local sp = self.bg_:getChildByTag(self.time_)
	local icon = display.newSprite("sign/shadow.png")
		:align(display.CENTER,sp:getContentSize().width * 0.5, sp:getContentSize().height * 0.5)
		:addTo(sp)
		
	--隐藏签到提示图片
	self.notice:setVisible(false)	
end

--弹窗关闭
function SignLayer:closeCallBack_()
	--播放音效(关闭层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
	end

    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.node:runAction(popupLayer)
end

return SignLayer
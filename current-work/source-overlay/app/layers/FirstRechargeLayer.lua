--
--首充奖励查看与领取
--

local AlertConnection = import("customs.AlertConnection")
local PaymentLayer    = import("layers.PaymentLayer")

local FirstRechargeLayer = class("FirstRechargeLayer", function()
	return display.newLayer()
end)

function FirstRechargeLayer:ctor()

    --充值界面是否关闭
    GameManager.IS_PAYMENT_LAYER_CLOSED   = false

	--添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

	--初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.cy)
	self:addChild(self.emptyNode_)

	--弹出效果
	self.emptyNode_:setScale(0)
	local popupLayer = transition.sequence(
		{cc.ScaleTo:create(0.2, 1.1),
		cc.ScaleTo:create(0.1, 1.0)})
	self.emptyNode_:runAction(popupLayer)

    --播放音效(打开层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end

   --加载首充界面
   self:initUI_()
end

--首充UI
function FirstRechargeLayer:initUI_()
    --背景
    self.bg_ = display.newSprite("recharge/reward_frame.png")
        :addTo(self.emptyNode_)

    --礼包内容
    self.gift_ = display.newSprite("recharge/reward.png",
        self.bg_:getContentSize().width * 0.32,self.bg_:getContentSize().height * 0.15)
        :addTo(self.bg_)

    --充值按钮
    self.rechargeBtn_ = cc.ui.UIPushButton.new({normal = "recharge/recharge.png",pressed = "recharge/recharge_h.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.80,self.bg_:getContentSize().height * 0.15)
        :onButtonClicked(function()
            self:rechargeCallBack_()
        end)
        :addTo(self.bg_)
    --领奖按钮
    self.getRewardBtn_ = cc.ui.UIPushButton.new({normal = "recharge/get_reward.png",pressed = "recharge/get_reward_h.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.80,self.bg_:getContentSize().height * 0.15)
        :onButtonClicked(function()
            self:getRewardCallBack_()
        end)
        :addTo(self.bg_)
    --关闭按钮
    self.closeBtn_ = cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.98,self.bg_:getContentSize().height * 0.93)
        :scale(0.85)
        :onButtonPressed(function()
            self:closeCallBack_()
        end)
        -- :onButtonClicked(function()
        --     self:closeCallBack_()
        -- end)
        :addTo(self.bg_)

    --是否充值过的判断
    if CloudData.FIRST_PURCHASE_STATE == 0 then
        self.getRewardBtn_:hide()
        self.rechargeBtn_:show()   
    elseif CloudData.FIRST_PURCHASE_STATE == 1 then
        self.getRewardBtn_:show()
        self.rechargeBtn_:hide()  
    else
        self.getRewardBtn_:show()
        self.getRewardBtn_:setButtonEnabled(false)
        self.rechargeBtn_:hide()  

        self.gift_:setTexture("recharge/reward_h.png")
    end

    --检测是否充值成功
    self.schedul_ = self:schedule(function()
        self:updateState_()
    end,0.1)
end

--检测是否充值成功
function FirstRechargeLayer:updateState_()
    if GameManager.IS_PAYMENT_LAYER_CLOSED then
        GameManager.IS_PAYMENT_LAYER_CLOSED = false
        if CloudData.FIRST_PURCHASE_STATE == 1 then
            self.getRewardBtn_:show()
            self.rechargeBtn_:hide() 
        end
    end
end

--充值回调
function FirstRechargeLayer:rechargeCallBack_()
    local currScene = display.getRunningScene()
    local layer = PaymentLayer.new()
    currScene:addChild(layer,100)

    -- self.getRewardBtn_:show()
    -- self.rechargeBtn_:hide()
    -- CloudData.FIRST_PURCHASE_STATE = 1
end

--领奖回调
function FirstRechargeLayer:getRewardCallBack_()
    --奖励数据存储(服务器)
    local ac = AlertConnection.new(CONNECTION_PAYMENT_FIRSTTIME_GIFT)
    self:addChild(ac,100,12345)

    self.schedulePay_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.schedulePay_)
                
                --领取奖励,弹出奖励层
            self.alertBg_ = display.newSprite("recharge/alert_pic.png",
                self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
                :addTo(self.bg_,10)

            --"知道了"按钮
            cc.ui.UIPushButton.new({normal = "sign/known.png",pressed = "sign/known_h.png"})
                :align(display.CENTER,self.alertBg_:getContentSize().width * 0.5,self.alertBg_:getContentSize().height * 0.2)
                :onButtonClicked(function()
                    self:knownCallBack_()
                end)
                :addTo(self.alertBg_)

            --弹出效果
            local popupLayer = transition.sequence(
                {cc.ScaleTo:create(0.2, 1.1),
                cc.ScaleTo:create(0.1, 1.0)})
            self.alertBg_:runAction(popupLayer)

            --屏蔽下层点击
            self.getRewardBtn_:setButtonEnabled(false)
            self.closeBtn_:setButtonEnabled(false)
        end
    end,0.1)   
end
--"知道了"回调
function FirstRechargeLayer:knownCallBack_()
    --标记已领取
    self.getRewardBtn_:setButtonImage("disabled","recharge/get_reward_unenabled.png")
    self.getRewardBtn_:setButtonEnabled(false)
    self.gift_:setTexture("recharge/reward_h.png") 
    CloudData.FIRST_PURCHASE_STATE = 2

    --本地数据存储
    CloudData.PEACH = CloudData.PEACH + 50
    --DataEye统计蟠桃产出
    if USE_DATAEYE then  
        DCCoin.gain("first recharge", "peach", 50, CloudData.PEACH)              
    end
    CloudData.SWEEP = CloudData.SWEEP + 50
    DataUtils.setNewBuddhaCloudData(61)
    CloudData.MONSTER_PIECE_INFO[18] = CloudData.MONSTER_PIECE_INFO[18] + 330

    --弹窗关闭效果
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self.alertBg_:removeSelf()
        end)
        })
    self.alertBg_:runAction(popupLayer)

    --开启下层点击
    self.closeBtn_:setButtonEnabled(true)
end

function FirstRechargeLayer:closeCallBack_()
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
    self.emptyNode_:runAction(popupLayer)
end

return FirstRechargeLayer
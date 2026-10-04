--
--复活界面
--
local AlertConnection = import("customs.AlertConnection")
local PaymentLayer = import("layers.PaymentLayer")

RELIVE_TYPE_SMS      = 1
RELIVE_TYPE_PEACH    = 2

local ReliveLayer = {}
ReliveLayer = class("ReliveLayer", function()
    return display.newLayer()
end)

function ReliveLayer:ctor(reliveType)

    --蟠桃或充值复活
    self.reliveType_ = 0
    if device.platform == "android" and USE_SMS_PAY then
        self.reliveType_ = RELIVE_TYPE_SMS
    elseif device.platform == "ios" or device.platform == "windows" or device.platform == "mac" then
        self.reliveType_ = RELIVE_TYPE_PEACH
    else
        self.reliveType_ = RELIVE_TYPE_PEACH
    end

    --DataEye统计
    if USE_DATAEYE then
        DCEvent.onEvent("waiting_for_recover")
    end

    operateAllSchedulerAndActions(display.getRunningScene(), "PAUSE")

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

    --初始化界面
    self:initUI_()
end

--初始化UI
function ReliveLayer:initUI_()

    -- 复活价格
    self.costNum_ = 0
    if self.reliveType_ == RELIVE_TYPE_SMS then
        self.costNum_ = 2
    else
        self.costNum_ = 40
    end

    --背景
    local bg = display.newSprite("win_or_lose/relive_bg.png")
        :addTo(self.emptyNode_,1)

    --背景上的蟠桃数量
    local bgLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = "0",size = 30,color = cc.c3b(186,14,242),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.56,bg:getContentSize().height * 0.58)
        :addTo(bg)

    --背景下层的旋转光圈
    local halo = display.newSprite("win_or_lose/halo.png",-275,-40)
        :addTo(self.emptyNode_)
    halo:runAction(cc.RepeatForever:create(cc.RotateBy:create(3.0,90)))

    --"复活"按钮
    local reliveBtn = cc.ui.UIPushButton.new({normal = "win_or_lose/relive.png",pressed = "win_or_lose/relive1.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.65,bg:getContentSize().height * 0.25)
        :onButtonClicked(function()
            self:reliveCallBack_()
        end)
        :addTo(bg)

    --复活所需的蟠桃数
    -- local btnLabel = cc.ui.UILabel.new({
    --     UILabelType = 2,text = "0",size = 24,color = cc.c3b(0,255,24),font = GameManager.FONTNAME_TTF})
    --     :align(display.CENTER,-40,0)
    --     :addTo(reliveBtn)

    if self.reliveType_ == RELIVE_TYPE_SMS then
        bgLabel:setString(string.format("%d元",self.costNum_))
        --btnLabel:setString(string.format("%d元",self.costNum_))
    else
        bgLabel:setString(string.format("%d蟠桃",self.costNum_))
        --btnLabel:setString(string.format("%d蟠桃",self.costNum_))
    end

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.95,bg:getContentSize().height * 0.72)
        :scale(0.7)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :addTo(bg)

end

function ReliveLayer:reliveCallBack_()
    print("-----------relive------------")
    --DataEye统计
    if USE_DATAEYE then
        DCEvent.onEvent("recover")
    end

    --    if USE_DATAEYE and CHANNEL ~= 2 then DCEvent.onEvent("recover") end
    --    --AnySdk内嵌统计接口
    --    if USE_DATAEYE and CHANNEL == 2 then analytics_plugin:logEvent("recover") end

    if self.reliveType_ == RELIVE_TYPE_SMS then
        --todo:Ray  充值复活

        -- 先获取商品订单号 [移动要求16位，联通要求24位, 电信要求32位之内]
        local ac = nil
        if PaymentInfo.CHANNEL == 10086 then
            ac = AlertConnection.new(CONNECTION_PAYMENT,GameManager.PRODUCT_RELIVE)
        elseif PaymentInfo.CHANNEL == 10010 then
            ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,GameManager.PRODUCT_RELIVE)

        else
            if PaymentInfo.OPERATOR == 10086 then
                ac = AlertConnection.new(CONNECTION_PAYMENT,GameManager.PRODUCT_RELIVE)
            elseif PaymentInfo.OPERATOR == 10010 then
                ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,GameManager.PRODUCT_RELIVE)
            elseif PaymentInfo.OPERATOR == 10000 then
                if CHANNEL_ID  == 370000 then
                    ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,GameManager.PRODUCT_RELIVE)
                else
                    ac = AlertConnection.new(CONNECTION_PAYMENT,GameManager.PRODUCT_RELIVE)
                end     
            else
                ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,GameManager.PRODUCT_RELIVE)
            end
        end

        
        self:addChild(ac,100,12345)

        self.schedulePay_ = self:schedule(function()
            if not self:getChildByTag(12345) then
                self:stopAction(self.schedulePay_)
                
                if PaymentInfo.CHANNEL == 10086 then 
                    self:payMM(9)
                elseif PaymentInfo.CHANNEL == 10010 then 
                    self:payWo(9)
                else 
                    if PaymentInfo.OPERATOR == 10086 then
                        self:payMM(9)
                    elseif PaymentInfo.OPERATOR == 10010 then
                        self:payWo(9)
                    elseif PaymentInfo.OPERATOR == 10000 then
                        if CHANNEL_ID  == 370000 then
                            self:payWo(9)
                        else 
                            self:payTele(9)
                        end 
                    else
                        self:payWo(9)
                    end
                end 
            end
        end,0.1)

    else
        if CloudData.PEACH < self.costNum_ then
            --DataEye统计
            if USE_DATAEYE then
                DCEvent.onEvent("recover_lack_of_peach")
            end

            local pl = PaymentLayer.new()
            display.getRunningScene():addChild(pl,200)
        else
            --DataEye统计
            if USE_DATAEYE  then
                DCEvent.onEvent("recover_success")
            end

            local ac = AlertConnection.new(CONNECTION_RECOVER)
            self:addChild(ac,100,12345)

            self.schedule_ = self:schedule(function()
                if not self:getChildByTag(12345) then
                    self:stopAction(self.schedule_)
                    --DataEye统计
                    if USE_DATAEYE then
                        DCEvent.onEvent("relive_at_stage_progress_" .. CloudData.STAGE_PROGRESS)
                    end

                    CloudData.PEACH = CloudData.PEACH - self.costNum_
                    GameManager.RECOVER = true
                    self:closeCallBack_()
                end
            end,0.1)
        end
    end
end



--MM支付
function ReliveLayer:payMM(idx)
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "payMM"
    local javaParams = {PaymentInfo.BILLNO.."", idx }
    local javaMethodSig = "(Ljava/lang/String;I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    self:checkIsMMPaySuccess()
end
--检查MM -- 需要返回
function ReliveLayer:checkIsMMPaySuccess()
    if self.scheduleCk_ ~= nil then
        self:stopAction(self.scheduleCk_)
    end
    -- 查询充值状态
    self.scheduleCk_ = self:schedule(function()
        local javaClassName = "org/cocos2dx/lua/AppActivity"
        local javaMethodName = "checkIsMMPaySuccess"
        local javaParams = {
            function(event)
                print("event : " .. event)
                if event == "notOK" then
                    print("notOK")
                    --elseif event == "OK" then
                else
                    local results = string.split(event, ",")
                    if(results[1]~="OK") then
                        return
                    end

                    -- android payMM 交易号
                    PaymentInfo.TRADE_ID = results[2]

                    -- 充值成功
                    self:stopAction(self.scheduleCk_)
                    self.scheduleCk_ = nil
                    
                    -- 直接使用，不验证，支付有问题
                    GameManager.RECOVER = true
                    self:closeCallBack_()

                    local params = {}
                    params.times = 11
                    params.type = 2
                    params.tradeId = PaymentInfo.TRADE_ID
                    params.orderId = PaymentInfo.BILLNO
                    params.ID = PaymentInfo.ID
                    params.STAGE_PROGRESS = CloudData.STAGE_PROGRESS
                    params.BILLNO = PaymentInfo.BILLNO
                    params.MONEY = PaymentInfo.MONEY
                    params.PEACH = PaymentInfo.PEACH

                    -- 延迟支付验证
                    PaymentVerification.getInstance():checkInMM(params)

                    -- 向服务器添加产品,并需验证
                    --[[local ac = AlertConnection.new(CONNECTION_PAYMENT_MM, PaymentInfo.BILLNO.."")
                    self:addChild(ac,100,10086)
                    self.scheduleCk1_ = self:schedule(function()
                    if not self:getChildByTag(10086) then
                    self:stopAction(self.scheduleCk1_)
                    self.scheduleCk1_ = nil

                    -- 如果支付失败
                    if(PaymentInfo.PAY_SUCCESS==false) then
                    GameManager.RECOVER = false
                    self:closeCallBack_()
                    return
                    else

                    --新增支付统计
                    --PaymentInfo.MONEY = jsonTable.data.amount
                    --PaymentInfo.PEACH = jsonTable.data.peach
                    --PaymentInfo.BILLNO = jsonTable.data.orderId
                    --DataEye统计
                    if USE_DATAEYE and CHANNEL ~= 2 then
                    local paymentType = nil
                    if CHANNEL == 3 then
                    paymentType = "酷狗"
                    elseif CHANNEL == 4 then
                    paymentType = "UC"
                    else
                    paymentType = "SMS"
                    end
                    DCVirtualCurrency.paymentSuccess(PaymentInfo.BILLNO.."", PaymentInfo.MONEY,"CNY",paymentType)
                    end
                    --AnySdk内嵌统计接口
                    if USE_DATAEYE and CHANNEL == 2 then
                    if(analytics_plugin and analytics_plugin:isFunctionSupported("onChargeOnlySuccess")) then
                    local paramMap = {
                    Order_Id = "654321",
                    Product_Name = "relive",
                    Currency_Amount = "2",
                    Currency_Type = "CNY",
                    Payment_Type = "SMS",
                    Virtual_Currency_Amount = "20"
                    }
                    local data = PluginParam:create(paramMap);
                    analytics_plugin:callFuncWithParam("onChargeOnlySuccess",data);
                    end
                    end

                    GameManager.RECOVER = true
                    self:closeCallBack_()
                    end
                    end
                    end,0.1)--]]
                end
            end
        }
        local javaMethodSig = "(I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end, 0.2)
end

--联通Wo支付
function ReliveLayer:payWo(idx)
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "payWo"
    local javaParams = {PaymentInfo.BILLNO.."", idx }
    local javaMethodSig = "(Ljava/lang/String;I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    self:checkIsWoPaySuccess()
end
--检查Wo
function ReliveLayer:checkIsWoPaySuccess()
    if self.scheduleCk_ ~= nil then
        self:stopAction(self.scheduleCk_)
    end
    -- 查询充值状态
    self.scheduleCk_ = self:schedule(function()
        local javaClassName = "org/cocos2dx/lua/AppActivity"
        local javaMethodName = "checkIsWoPaySuccess"
        local javaParams = {
            function(event)
                print("event : " .. event)
                if event == "notOK" then
                    print("notOK")
                elseif event == "OK" then
                    -- 充值成功
                    self:stopAction(self.scheduleCk_)
                    self.scheduleCk_ = nil

                    -- 直接复活
                    GameManager.RECOVER = true
                    self:closeCallBack_()
                    
                    local params = {}
                    params.times = 11
                    params.type = 2
                    params.orderId = PaymentInfo.BILLNO
                    params.ID = PaymentInfo.ID
                    params.STAGE_PROGRESS = CloudData.STAGE_PROGRESS
                    params.BILLNO = PaymentInfo.BILLNO
                    params.MONEY = PaymentInfo.MONEY
                    params.PEACH = PaymentInfo.PEACH

                    -- 延迟支付验证
                    PaymentVerification.getInstance():checkInWO(params)

                    -- 向服务器添加产品,并需验证
                    --[[local ac = AlertConnection.new(CONNECTION_PAYMENT_WO, PaymentInfo.BILLNO.."")
                    self:addChild(ac,100,10010)
                    self.scheduleCk1_ = self:schedule(function()
                    if not self:getChildByTag(10010) then
                    self:stopAction(self.scheduleCk1_)
                    self.scheduleCk1_ = nil

                    -- 如果支付失败
                    if(PaymentInfo.PAY_SUCCESS==false) then
                    GameManager.RECOVER = false
                    self:closeCallBack_()
                    return
                    else
                    --新增支付统计
                    --PaymentInfo.MONEY = jsonTable.data.amount
                    --PaymentInfo.PEACH = jsonTable.data.peach
                    --PaymentInfo.BILLNO = jsonTable.data.orderId
                    --DataEye统计
                    if USE_DATAEYE and CHANNEL ~= 2 then
                    local paymentType = nil
                    if CHANNEL == 3 then
                    paymentType = "酷狗"
                    elseif CHANNEL == 4 then
                    paymentType = "UC"
                    else
                    paymentType = "SMS"
                    end
                    DCVirtualCurrency.paymentSuccess(PaymentInfo.BILLNO.."", PaymentInfo.MONEY,"CNY",paymentType)
                    end
                    --AnySdk内嵌统计接口
                    if USE_DATAEYE and CHANNEL == 2 then
                    if(analytics_plugin and analytics_plugin:isFunctionSupported("onChargeOnlySuccess")) then
                    local paramMap = {
                    Order_Id = "654321",
                    Product_Name = "relive",
                    Currency_Amount = "2",
                    Currency_Type = "CNY",
                    Payment_Type = "SMS",
                    Virtual_Currency_Amount = "20"
                    }
                    local data = PluginParam:create(paramMap);
                    analytics_plugin:callFuncWithParam("onChargeOnlySuccess",data);
                    end
                    end

                    GameManager.RECOVER = true
                    self:closeCallBack_()
                    end
                    end
                    end,0.1)--]]
                end
            end
        }
        local javaMethodSig = "(I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end, 0.2)
end

function ReliveLayer:closeCallBack_()
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            operateAllSchedulerAndActions(display.getRunningScene(), "RESUME")
            self:removeSelf()
        end)
    })
    self.emptyNode_:runAction(popupLayer)
end


--电信爱游戏支付
function ReliveLayer:payTele(idx)
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "payTele"
    local javaParams = { PaymentInfo.BILLNO.."",PaymentInfo.MONEY, idx }
    local javaMethodSig = "(Ljava/lang/String;II)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    local peachNum = PaymentInfo.PEACH

    self:checkIsTelePaySuccess(peachNum)
end
--检查Tele
function ReliveLayer:checkIsTelePaySuccess(peachNum)
    if self.scheduleCk_ ~= nil then
        self:stopAction(self.scheduleCk_)
    end
    -- 查询充值状态
    self.scheduleCk_ = self:schedule(function()
        local javaClassName = "org/cocos2dx/lua/AppActivity"
        local javaMethodName = "checkIsTelePaySuccess"
        local javaParams = {
            function(event)
                print("event : " .. event)
                if event == "notOK" then
                    print("notOK")
                elseif event == "OK" then
                    -- 充值成功
                    self:stopAction(self.scheduleCk_)
                    self.scheduleCk_ = nil

                    -- 直接复活
                    GameManager.RECOVER = true
                    self:closeCallBack_()
                    
                    -- 三次验证
                    local params = {}
                    params.times = 11
                    params.type = 2
                    params.orderId = PaymentInfo.BILLNO
                    params.ID = PaymentInfo.ID
                    params.STAGE_PROGRESS = CloudData.STAGE_PROGRESS
                    params.BILLNO = PaymentInfo.BILLNO
                    params.MONEY = PaymentInfo.MONEY
                    params.PEACH = PaymentInfo.PEACH

                    -- 延迟支付验证[电信]
                    PaymentVerification.getInstance():checkInTele(params)

                   
                    --                    --联网
                    --                    local ac = AlertConnection.new(CONNECTION_PAYMENT_MM, PaymentInfo.BILLNO.."")
                    --                    self:addChild(ac,100,10086)
                    --                    self.scheduleCk1_ = self:schedule(function()
                    --                        if not self:getChildByTag(10086) then
                    --                            self:stopAction(self.scheduleCk1_)
                    --
                    --                            --DataEye统计
                    --                            if USE_DATAEYE and CHANNEL ~= 2 then
                    --                                DCEvent.onEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end
                    --                            --AnySdk内嵌统计接口
                    --                            if USE_DATAEYE and CHANNEL == 2 then
                    --                                analytics_plugin:logEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end
                    --
                    --                            CloudData.PEACH = CloudData.PEACH + peachNum
                    --                            if CloudData.FIRST_PURCHASE_STATE == 0 then CloudData.FIRST_PURCHASE_STATE = 1 end
                    --                        end
                    --                    end,0.2)
                end
            end
        }
        local javaMethodSig = "(I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end, 0.2)
end

return ReliveLayer
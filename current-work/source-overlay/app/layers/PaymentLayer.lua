--
--充值界面
--

local AlertConnection = import("customs.AlertConnection")
local PaymentIcon     = import("icons.PaymentIcon")
local Store           = import("framework.cc.sdk.Store")
local ConnectionLayer = import("layers.ConnectionLayer")
local WSToast         = import("utils.WSToast")

local PaymentLayer = {}
PaymentLayer = class("PaymentLayer", function()
    return display.newLayer()
end)

local paymentLayer = nil

function OnStoreCallBack(transaction)
    paymentLayer:storeCallBack(transaction)
end

TAG_PAY_CONNECTION_LAYER = 1002

function PaymentLayer:ctor()
    paymentLayer = self

    --添加遮罩层
    display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1)

    --初始化基础节点
    self.emptyNode_ = display.newNode()
        :scale(0)
        :pos(display.cx, display.cy)
        :addTo(self,1)

    --弹出效果
    local popupLayer = transition.sequence(
        {cc.ScaleTo:create(0.2, 1.1),
            cc.ScaleTo:create(0.1, 1.0)})
    self.emptyNode_:runAction(popupLayer)

    --播放音效(打开层)
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
    end

    --加入ios内购商品
    if device.platform == "ios" then
        --ios商品ID
        self.iosGoodsIDTable_ = {"com.kg.pay12","com.kg.pay5","com.kg.pay4","com.kg.pay6","com.kg.pay7","com.kg.pay8"}
        --初始化商店
        if not GameManager.IS_STORE_INIT then
            --Store.init(handler(self,self.storeCallBack))
            Store.init(OnStoreCallBack)
            GameManager.IS_STORE_INIT = true
        end

        --载入商品
        Store.loadProducts(self.iosGoodsIDTable_,handler(self,self.loadCallBack))
    end

    --初始化UI
    --self:initUI_()

    --联网获取优惠活动倒计时
    local ac = AlertConnection.new(CONNECTION_PAYMENT_INIT)
    self:addChild(ac,100,11345)

    self.schedulePAY_ = self:schedule(function()
        if not self:getChildByTag(11345) then
            self:stopAction(self.schedulePAY_)

            --初始化界面
            self:initUI_()
        end
    end,0.1)
end

--布置UI
function PaymentLayer:initUI_()
    self.paymentIconTable_ = {}

    --背景
    local frame = display.newSprite("recharge/bg.png")
        :addTo(self.emptyNode_)

    --获取model数组
    local paymentModelTable = DataUtils.getPaymentModelTable()

    --创建listView
    self.listView = cc.ui.UIListView.new {
        --bgColor = cc.c4b(200, 200, 200, 120),
        viewRect = cc.rect(67,30,920,545),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
        :onTouch(handler(self,self.touchListener))
        :addTo(frame)

    local totalNum    = #paymentModelTable - 6
    local row         = math.ceil(totalNum / 2)    --行数
    local column      = totalNum % 2               --末行剩几个
    local endNum = 2
    for i=1,row do
        local item = self.listView:newItem()
        local content = display.newNode()
        if i == row and column > 0 then
            endNum = column
        end
        for count = 1, endNum do
            local paymentIcon  = PaymentIcon.new((i - 1) * 2 + count)
            paymentIcon:setPosition(460 * count - 230,91)
            paymentIcon:setTouchSwallowEnabled(false)
            content:addChild(paymentIcon)

            table.insert(self.paymentIconTable_,paymentIcon)
        end
        content:setContentSize(920,182)
        item:addContent(content)
        item:setItemSize(920,182)
        self.listView:addItem(item)
    end
    self.listView:reload()

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :onButtonPressed(function()
            self:closeCallBack_()
        end)
        -- :onButtonClicked(function()
        -- 		self:closeCallBack_()
        -- 	end)
        :scale(0.9)
        :align(display.CENTER,frame:getContentSize().width * 0.92,frame:getContentSize().height * 0.90)
        :addTo(frame)
end

local NEW_PAY = {1,2,4,6,7,8} -- 新的计费点映射
function PaymentLayer:touchListener(event)

    if "clicked" == event.name then
        local column = math.ceil(event.point.x / 460)
        -- local idx = (event.itemPos - 1) * 2 + column              --充值id(1~8)
        local idx = (event.itemPos - 1) * 2 + column + 20            --新充值id(21~26),+20与id区分开
        print("idx = "..idx)    -- idx 1~8

        --充值
        if device.platform == "windows" or device.platform == "mac" then
            --            self:pcPayMM(idx)
            --            self:pcPayTele(idx)
            self:pcPayWO(idx)
            return
        end

        if device.platform == "ios" then
            if PaymentInfo.CHANNEL == 0 then
                local ac = AlertConnection.new(CONNECTION_PAYMENT_IOS,idx)
                self:addChild(ac,100,12345)

                self.schedulePay_ = self:schedule(function()
                    if not self:getChildByTag(12345) then
                        self:stopAction(self.schedulePay_)
                        self:payIOS(idx - 20)        -- 此处-20，方便取商品table里的值
                    end
                end,0.1)
            end
        elseif device.platform == "android" then

            -- 先获取商品信息
            -- local ac = AlertConnection.new(CONNECTION_PAYMENT,idx)
            -- 先获取商品订单号 [移动要求16位，联通要求24位]

            -- 请求订单号，现在为21~32的编号
            local orderIdx = idx
            -- if(CloudData.PAYMENT_ITEM_STATE[idx-20]>0) then
            --     orderIdx = orderIdx + 6
            -- end

            local ac = nil
            if PaymentInfo.OPERATOR == 10086 then
                ac = AlertConnection.new(CONNECTION_PAYMENT,orderIdx)
            elseif PaymentInfo.OPERATOR == 10010 then
                ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,orderIdx)
            elseif PaymentInfo.OPERATOR == 10000 then
                if CHANNEL_ID  == 370000 then            -- 37wan不接电信
                    ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,orderIdx)
                else
                    ac = AlertConnection.new(CONNECTION_PAYMENT,orderIdx)
                end   
            else
                ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,orderIdx)
            end

            self:addChild(ac,100,12345)

            self.schedulePay_ = self:schedule(function()
                if not self:getChildByTag(12345) then
                    self:stopAction(self.schedulePay_)
                    -- 成功获取商品信息 调用SDK购买
                    if PaymentInfo.CHANNEL == 3 then
                        --使用短代支付
                        if USE_SMS_PAY == true then
                            --安卓Pad或无sim卡用户短代不可用，直接使用Kugou
                            if PaymentInfo.OPERATOR ~= 10086 and PaymentInfo.OPERATOR ~= 10010 and PaymentInfo.OPERATOR ~= 10000 then
                                self:payKugou()
                            elseif tonumber(PaymentInfo.MONEY) <= 30 then
                                --小于30元的使用短代
                                if PaymentInfo.OPERATOR == 10086 then
                                    self:payMM(idx)
                                elseif PaymentInfo.OPERATOR == 10010 then
                                    self:payWo(idx)
                                elseif PaymentInfo.OPERATOR == 10000 then
                                    self:payTele(idx)
                                end
                            else
                                --大于30元的商品
                                self:payKugou()
                            end
                        else
                            --短代不支持
                            self:payKugou()
                        end
                    elseif PaymentInfo.CHANNEL == 2 then
                        if USE_SMS_PAY == true then
                            --AnySdk
                            if PaymentInfo.OPERATOR ~= 10086 and PaymentInfo.OPERATOR ~= 10010 and PaymentInfo.OPERATOR ~= 10000 then
                                --电信和Pad用户短代不可用，直接使用AnySdk
                                self:payAnySdk(idx)
                            elseif tonumber(PaymentInfo.MONEY) <= 30 then
                                if PaymentInfo.OPERATOR == 10086 then
                                    self:payMM(idx)
                                elseif PaymentInfo.OPERATOR == 10010 then
                                    self:payWo(idx)
                                elseif PaymentInfo.OPERATOR == 10000 then
                                    self:payTele(idx)
                                else
                                    self:payAnySdk(idx)
                                end
                            else
                                self:payAnySdk(idx)
                            end
                        else
                            self:payAnySdk(idx)
                        end
                    elseif PaymentInfo.CHANNEL == 0 then
                    --self:paySMS()
                    elseif PaymentInfo.CHANNEL == 4 then
                        self:payUC()
                    elseif PaymentInfo.CHANNEL == 5 then
                        if CHANNEL_ID  == 370000 then
                             if PaymentInfo.OPERATOR == 10086 then
                                self:payMM(idx)
                            elseif PaymentInfo.OPERATOR == 10010 then
                                self:payWo(idx)
                            else
                                self:payWo(idx)
                            end
                        else
                           self:payBaidu(idx)
                        end    
                    elseif PaymentInfo.CHANNEL == 6 then
                        self:queryQQGamecoin(idx)

                    elseif PaymentInfo.CHANNEL == 10086 then
                        self:payMM(idx)
                        -- self:payBaidu(idx)
                    elseif PaymentInfo.CHANNEL == 10010 then
                        self:payWo(idx)
                    elseif PaymentInfo.CHANNEL == 10000 then
                        self:payTele(idx)
                    end
                end
            end,0.1)
        end
    elseif "moved" == event.name then

    elseif "ended" == event.name then

    end
end


--先检查Q点是否够支付，不够再充值
function PaymentLayer:queryQQGamecoin(idx)
    print("RAYYYYYYYY query qq game coin")
    -- 查询QQ Gamecoin
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "queryQQGameCoin"
    local javaParams = {
        function(event)
            print("event : " .. event)
            self.qqGameCoinDataTable_ = split(event,",")
            local openId = self.qqGameCoinDataTable_[1]
            local openKey = self.qqGameCoinDataTable_[2]
            local payToken = self.qqGameCoinDataTable_[3]
            local pf = self.qqGameCoinDataTable_[4]
            local pfKey = self.qqGameCoinDataTable_[5]
            print("openId : "..openId)
            print("openKey : "..openKey)
            print("payToken : "..payToken)
            print("pf : "..pf)
            print("pfKey : "..pfKey)

            --微信没有payToken "leftblank"是Ray手写留空标识符
            if payToken == "leftblank" then
                payToken = ""
                print("payToken After : "..payToken)
                local ac = AlertConnection.new(CONNECTION_WX_GAMECOIN_QUERY,openId,openKey,payToken,pf,pfKey)
                self:addChild(ac,100,12345)
            else
                local ac = AlertConnection.new(CONNECTION_QQ_GAMECOIN_QUERY,openId,openKey,payToken,pf,pfKey)
                self:addChild(ac,100,12345)
            end

            self.scheduleCk3_ = self:schedule(function()
                if not self:getChildByTag(12345) then
                    self:stopAction(self.scheduleCk3_)
                    self.scheduleCk3_ = nil

                    --Q币够支付 则不调用MSDK充值界面，直接向游戏服请求扣GameGoin
                    if PaymentInfo.QQGameCoin >= tonumber(PaymentInfo.MONEY) * 10 then

                        --微信没有payToken "leftblank"是Ray手写留空标识符
                        if PaymentInfo.payToken == "leftblank" then
                            local payToken = ""
                            local ac = AlertConnection.new(CONNECTION_WX_PAY_ORDER_BY_GAMECOIN,PaymentInfo.openId,PaymentInfo.openKey,payToken,PaymentInfo.pf,PaymentInfo.pfKey,idx)
                            self:addChild(ac,100,15998)
                        else
                            local ac = AlertConnection.new(CONNECTION_QQ_PAY_ORDER_BY_GAMECOIN,PaymentInfo.openId,PaymentInfo.openKey,PaymentInfo.payToken,PaymentInfo.pf,PaymentInfo.pfKey,idx)
                            self:addChild(ac,100,15998)
                        end

                        self.scheduleCk2_ = self:schedule(function()
                            if not self:getChildByTag(15998) then
                                self:stopAction(self.scheduleCk2_)
                                self.scheduleCk2_ = nil

                                local toast = WSToast.new("充值成功")
                                self:addChild(toast,200)
                                -- 发放桃子
                                CloudData.PEACH = CloudData.PEACH + PaymentInfo.PEACH

                                --DataEye统计
                                if USE_DATAEYE then
                                    DCEvent.onEvent("payment_index_"..PaymentInfo.ID .."_at_stage_progress_" ..CloudData.STAGE_PROGRESS)
                                end

                                --DataEye统计
                                if USE_DATAEYE then
                                    local paymentType = nil
                                    if CHANNEL == 3 then
                                        paymentType = "酷狗"
                                    elseif CHANNEL == 4 then
                                        paymentType = "UC"
                                    elseif CHANNEL == 6 then
                                        paymentType = "QQ"
                                    else
                                        paymentType = "SMS"
                                    end
                                    DCVirtualCurrency.paymentSuccess(PaymentInfo.BILLNO.."", PaymentInfo.MONEY,"CNY",paymentType)
                                end
                            end
                        end,0.25)
                    else
                        --用户Q点不够，调用SDK充值

                        self:payQQ(idx)
                    end
                end
            end,0.25)
        end
    }
    local javaMethodSig = "(I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)








end


--QQ支付 GameCoin
function PaymentLayer:payQQ(idx)

    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "pay"
    local javaParams = { PaymentInfo.MONEY, idx }
    local javaMethodSig = "(II)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    local peachNum = PaymentInfo.PEACH

    self:checkIsQQPaySuccess(peachNum, idx)
end
--检查QQ
function PaymentLayer:checkIsQQPaySuccess(peachNum, idx)
    if self.scheduleCk_ ~= nil then
        self:stopAction(self.scheduleCk_)
    end
    -- 查询充值状态
    self.scheduleCk_ = self:schedule(function()
        local javaClassName = "org/cocos2dx/lua/AppActivity"
        local javaMethodName = "checkIsQQPaySuccess"
        local javaParams = {
            function(event)
                print("event : " .. event)
                if event == "notOK" then
                    print("notOK")
                else
                    -- 充值成功
                    self:stopAction(self.scheduleCk_)
                    self.scheduleCk_ = nil

                    self.qqGameCoinDataTable_ = split(event,",")
                    local openId = self.qqGameCoinDataTable_[1]
                    local openKey = self.qqGameCoinDataTable_[2]
                    local payToken = self.qqGameCoinDataTable_[3]
                    local pf = self.qqGameCoinDataTable_[4]
                    local pfKey = self.qqGameCoinDataTable_[5]
                    print("openId : "..openId)
                    print("openKey : "..openKey)
                    print("payToken : "..payToken)
                    print("pf : "..pf)
                    print("pfKey : "..pfKey)

                    --微信没有payToken "leftblank"是Ray手写留空标识符
                    if payToken == "leftblank" then
                        payToken = ""
                        local ac = AlertConnection.new(CONNECTION_WX_PAY_ORDER_BY_GAMECOIN,openId,openKey,payToken,pf,pfKey,idx)
                        self:addChild(ac,100,15998)
                    else
                        local ac = AlertConnection.new(CONNECTION_QQ_PAY_ORDER_BY_GAMECOIN,openId,openKey,payToken,pf,pfKey,idx)
                        self:addChild(ac,100,15998)
                    end

                    self.scheduleCk2_ = self:schedule(function()
                        if not self:getChildByTag(15998) then
                            self:stopAction(self.scheduleCk2_)
                            self.scheduleCk2_ = nil

                            -- 发放桃子
                            CloudData.PEACH = CloudData.PEACH + peachNum

                            --DataEye统计
                            if USE_DATAEYE then
                                DCEvent.onEvent("payment_index_"..PaymentInfo.ID .."_at_stage_progress_" ..CloudData.STAGE_PROGRESS)
                            end

                            --DataEye统计
                            if USE_DATAEYE then
                                local paymentType = nil
                                if CHANNEL == 3 then
                                    paymentType = "酷狗"
                                elseif CHANNEL == 4 then
                                    paymentType = "UC"
                                elseif CHANNEL == 6 then
                                    paymentType = "QQ"
                                else
                                    paymentType = "SMS"
                                end
                                DCVirtualCurrency.paymentSuccess(PaymentInfo.BILLNO.."", PaymentInfo.MONEY,"CNY",paymentType)
                            end
                        end
                    end,0.25)

                end
            end
        }
        local javaMethodSig = "(I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end, 0.2)
end



--ios内支付
function PaymentLayer:payIOS(idx)
    Store.purchase(self.iosGoodsIDTable_[idx])

    --连接...
    local pLayer = ConnectionLayer.new()
    self:addChild(pLayer,100,TAG_PAY_CONNECTION_LAYER)
end
function PaymentLayer:storeCallBack(transaction)
    if transaction.transaction.state == "purchased" then
        print("buy success")
        --联网
        local ac = AlertConnection.new(CONNECTION_PAYMENT_IOS_FINISH,transaction.transaction.receipt)
        self:addChild(ac,102,10087)
        self.scheduleIOS_ = self:schedule(function()
            if not self:getChildByTag(10087) then
                self:stopAction(self.scheduleIOS_)

                CloudData.PEACH = CloudData.PEACH + PaymentInfo.PEACH
                --DataEye统计蟠桃产出
                if USE_DATAEYE then
                    DCEvent.onEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS)
                    DCCoin.gain("recharge", "peach", PaymentInfo.PEACH, CloudData.PEACH)
                    DCVirtualCurrency.paymentSuccess(PaymentInfo.BILLNO.."", PaymentInfo.MONEY,"CNY","IOS")
                end

                if CloudData.FIRST_PURCHASE_STATE == 0 then CloudData.FIRST_PURCHASE_STATE = 1 end

                -- 移除等待框
                if self:getChildByTag(TAG_PAY_CONNECTION_LAYER) then
                    self:removeChildByTag(TAG_PAY_CONNECTION_LAYER,true)
                end
            end
        end,0.2)
    elseif transaction.transaction.state == "failed" then
        print("buy failed")
        -- 移除等待框
        if self:getChildByTag(TAG_PAY_CONNECTION_LAYER) then
            self:removeChildByTag(TAG_PAY_CONNECTION_LAYER,true)
        end
    elseif transaction.transaction.state == "restored" then
        print("buy restored")
        -- 移除等待框
        if self:getChildByTag(TAG_PAY_CONNECTION_LAYER) then
            self:removeChildByTag(TAG_PAY_CONNECTION_LAYER,true)
        end
    elseif transaction.transaction.state == "cancelled" then
        print("buy cancelled")
        -- 移除等待框
        if self:getChildByTag(TAG_PAY_CONNECTION_LAYER) then
            self:removeChildByTag(TAG_PAY_CONNECTION_LAYER,true)
        end
    elseif transaction.transaction.state == "purchasing" then
        print("purchasing...")
        -- 移除等待框
        if self:getChildByTag(TAG_PAY_CONNECTION_LAYER) then
            self:removeChildByTag(TAG_PAY_CONNECTION_LAYER,true)
        end
    elseif transaction.transaction.state == "unknown" then
        print("unknown error")
        -- 移除等待框
        if self:getChildByTag(TAG_PAY_CONNECTION_LAYER) then
            self:removeChildByTag(TAG_PAY_CONNECTION_LAYER,true)
        end
    end
    dump(transaction)
    Store.finishTransaction(transaction.transaction)
end
function PaymentLayer:loadCallBack(products)
    --返回商品列表
    dump(pruducts)
end


--电信爱游戏支付
function PaymentLayer:payTele(idx)

    idx = NEW_PAY[idx-20]
    print("new idx = "..idx)    -- idx 1,2,4,6,7,8

    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "payTele"
    local javaParams = { PaymentInfo.BILLNO.."",PaymentInfo.MONEY, idx }
    local javaMethodSig = "(Ljava/lang/String;II)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    local peachNum = PaymentInfo.PEACH

    self:checkIsTelePaySuccess(peachNum)
end
--检查Tele
function PaymentLayer:checkIsTelePaySuccess(peachNum)
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

                    -- 直接发放桃子
                    CloudData.PEACH = CloudData.PEACH + peachNum
                    --DataEye统计蟠桃产出
                    if USE_DATAEYE then
                        DCCoin.gain("recharge", "peach", peachNum, CloudData.PEACH)
                    end

                    if CloudData.FIRST_PURCHASE_STATE == 0 then
                        CloudData.FIRST_PURCHASE_STATE = 1
                    end

                    -- 三次验证
                    local params = {}
                    params.times = 11
                    params.type = 1
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

--百度支付
function PaymentLayer:payBaidu(idx)

    if PaymentInfo.OPERATOR == 10086 then
        self:payMM(idx)
    elseif PaymentInfo.OPERATOR == 10010 then
        self:payWo(idx)
    elseif PaymentInfo.OPERATOR == 10000 then
        self:payTele(idx)
    else
        self:payWo(idx)
    end
end


--联通Wo支付
function PaymentLayer:payWo(idx)

    idx = NEW_PAY[idx-20]
    print("new idx = "..idx)    -- idx 1,2,4,6,7,8

    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "payWo"
    local javaParams = { PaymentInfo.BILLNO.."", idx }
    local javaMethodSig = "(Ljava/lang/String;I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    local peachNum = PaymentInfo.PEACH
    self:checkIsWoPaySuccess(peachNum)
end
--检查Wo, 无返回交易号
function PaymentLayer:checkIsWoPaySuccess(peachNum)
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

                    -- 直接发放桃子
                    CloudData.PEACH = CloudData.PEACH + peachNum
                    --DataEye统计蟠桃产出
                    if USE_DATAEYE then
                        DCCoin.gain("recharge", "peach", peachNum, CloudData.PEACH)
                    end
                    if CloudData.FIRST_PURCHASE_STATE == 0 then
                        CloudData.FIRST_PURCHASE_STATE = 1
                    end

                    -- 三次验证
                    local params = {}
                    params.times = 11
                    params.type = 1
                    params.orderId = PaymentInfo.BILLNO
                    params.ID = PaymentInfo.ID
                    params.STAGE_PROGRESS = CloudData.STAGE_PROGRESS
                    params.BILLNO = PaymentInfo.BILLNO
                    params.MONEY = PaymentInfo.MONEY
                    params.PEACH = PaymentInfo.PEACH

                    -- 延迟支付验证
                    PaymentVerification.getInstance():checkInWO(params)

                    --联网
                    --[[local ac = AlertConnection.new(CONNECTION_PAYMENT_WO, PaymentInfo.BILLNO.."")
                    self:addChild(ac,100,10010)
                    self.scheduleCk1_ = self:schedule(function()
                    if not self:getChildByTag(10010) then
                    self:stopAction(self.scheduleCk1_)

                    -- 如果支付失败
                    if(PaymentInfo.PAY_SUCCESS==false) then
                    return
                    end

                    -- 如果支付成功，收集统计数据，添加道具

                    --DataEye统计
                    if USE_DATAEYE and CHANNEL ~= 2 then
                    DCEvent.onEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end
                    --AnySdk内嵌统计接口
                    if USE_DATAEYE and CHANNEL == 2 then
                    analytics_plugin:logEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end

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
                    Order_Id = PaymentInfo.BILLNO.."",
                    Product_Name = PaymentInfo.ID.."",
                    Currency_Amount = PaymentInfo.MONEY.."",
                    Currency_Type = "CNY",
                    Payment_Type = "SMS",
                    Virtual_Currency_Amount = PaymentInfo.PEACH..""
                    }
                    local data = PluginParam:create(paramMap);
                    analytics_plugin:callFuncWithParam("onChargeOnlySuccess",data);
                    end
                    end

                    CloudData.PEACH = CloudData.PEACH + peachNum
                    if CloudData.FIRST_PURCHASE_STATE == 0 then CloudData.FIRST_PURCHASE_STATE = 1 end
                    end
                    end,0.2)--]]
                end
            end
        }
        local javaMethodSig = "(I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end, 0.2)
end

function PaymentLayer:pcPayMM(idx)

    -- 请求订单号，现在为21~32的编号
    local orderIdx = idx
    -- if(CloudData.PAYMENT_ITEM_STATE[idx-20]>0) then
    --     orderIdx = orderIdx + 6
    -- end

    local ac = nil
    if PaymentInfo.OPERATOR == 10086 then
        ac = AlertConnection.new(CONNECTION_PAYMENT,orderIdx)
    elseif PaymentInfo.OPERATOR == 10010 then
        ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,orderIdx)
    else
        ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,orderIdx)
    end
    self:addChild(ac,100,12345)

    self.schedulePay_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.schedulePay_)
            local event = "OK,sdfsfsf"
            print("event : " .. event)
            if event == "notOK" then
                print("notOK")
                --elseif event == "OK" then
            else
                local results = string.split(event,",")
                if(results[1]~="OK") then
                    return
                end

                local peachNum = PaymentInfo.PEACH

                -- 移动订单号
                PaymentInfo.TRADE_ID = results[2] -- android 返回的交易号

                -- 充值成功
                self:stopAction(self.scheduleCk_)
                self.scheduleCk_ = nil

                -- 直接发送桃子
                CloudData.PEACH = CloudData.PEACH + peachNum
                --DataEye统计蟠桃产出
                if USE_DATAEYE then
                    DCCoin.gain("recharge", "peach", peachNum, CloudData.PEACH)
                end
                if CloudData.FIRST_PURCHASE_STATE == 0 then
                    CloudData.FIRST_PURCHASE_STATE = 1
                end

                -- 三次验证
                local params = {}
                params.times = 11
                params.type = 1
                params.tradeId = PaymentInfo.TRADE_ID
                params.orderId = PaymentInfo.BILLNO
                params.ID = PaymentInfo.ID
                params.STAGE_PROGRESS = CloudData.STAGE_PROGRESS
                params.BILLNO = PaymentInfo.BILLNO
                params.MONEY = PaymentInfo.MONEY
                params.PEACH = PaymentInfo.PEACH

                -- 延迟支付验证
                PaymentVerification.getInstance():checkInMM(params)

                --联网, 以后就不需要了，因为支付延迟
                --[[local ac = AlertConnection.new(CONNECTION_PAYMENT_MM, PaymentInfo.BILLNO.."")
                self:addChild(ac,100,10086)
                self.scheduleCk1_ = self:schedule(function()
                if not self:getChildByTag(10086) then
                self:stopAction(self.scheduleCk1_)

                -- 如果支付失败
                if(PaymentInfo.PAY_SUCCESS==false) then
                return
                end

                -- 如果支付成功，收集统计数据，添加道具

                --DataEye统计
                if USE_DATAEYE and CHANNEL ~= 2 then
                DCEvent.onEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end
                --AnySdk内嵌统计接口
                if USE_DATAEYE and CHANNEL == 2 then
                analytics_plugin:logEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end

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
                Order_Id = PaymentInfo.BILLNO.."",
                Product_Name = PaymentInfo.ID.."",
                Currency_Amount = PaymentInfo.MONEY.."",
                Currency_Type = "CNY",
                Payment_Type = "SMS",
                Virtual_Currency_Amount = PaymentInfo.PEACH..""
                }
                local data = PluginParam:create(paramMap);
                analytics_plugin:callFuncWithParam("onChargeOnlySuccess",data);
                end
                end

                CloudData.PEACH = CloudData.PEACH + peachNum
                if CloudData.FIRST_PURCHASE_STATE == 0 then CloudData.FIRST_PURCHASE_STATE = 1 end
                end
                end,0.2)--]]
            end

        end
    end, 0.1)
end


function PaymentLayer:pcPayWO(idx)

    -- 请求订单号，现在为21~32的编号
    local orderIdx = idx
    -- if(CloudData.PAYMENT_ITEM_STATE[idx-20]>0) then
    --     orderIdx = orderIdx + 6
    -- end

    local ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,idx)
    self:addChild(ac,100,12345)

    self.schedulePay_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.schedulePay_)
            local event = "OK"

            print("event : " .. event)
            if event == "notOK" then
                print("notOK")
            elseif event == "OK" then
                -- 充值成功
                self:stopAction(self.scheduleCk_)
                self.scheduleCk_ = nil

                local peachNum = PaymentInfo.PEACH

                -- 直接发放桃子
                CloudData.PEACH = CloudData.PEACH + peachNum
                --DataEye统计蟠桃产出
                if USE_DATAEYE then
                    DCCoin.gain("recharge", "peach", peachNum, CloudData.PEACH)
                end
                if CloudData.FIRST_PURCHASE_STATE == 0 then
                    CloudData.FIRST_PURCHASE_STATE = 1
                end

                -- 三次验证
                local params = {}
                params.times = 11
                params.type = 1
                params.orderId = PaymentInfo.BILLNO
                params.ID = PaymentInfo.ID
                params.STAGE_PROGRESS = CloudData.STAGE_PROGRESS
                params.BILLNO = PaymentInfo.BILLNO
                params.MONEY = PaymentInfo.MONEY
                params.PEACH = PaymentInfo.PEACH

                -- 延迟支付验证
                PaymentVerification.getInstance():checkInWO(params)

                --联网
                --[[local ac = AlertConnection.new(CONNECTION_PAYMENT_WO, PaymentInfo.BILLNO.."")
                self:addChild(ac,100,10010)
                self.scheduleCk1_ = self:schedule(function()
                if not self:getChildByTag(10010) then
                self:stopAction(self.scheduleCk1_)

                -- 如果支付失败
                if(PaymentInfo.PAY_SUCCESS==false) then
                return
                end

                -- 如果支付成功，收集统计数据，添加道具

                --DataEye统计
                if USE_DATAEYE and CHANNEL ~= 2 then
                DCEvent.onEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end
                --AnySdk内嵌统计接口
                if USE_DATAEYE and CHANNEL == 2 then
                analytics_plugin:logEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end

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
                Order_Id = PaymentInfo.BILLNO.."",
                Product_Name = PaymentInfo.ID.."",
                Currency_Amount = PaymentInfo.MONEY.."",
                Currency_Type = "CNY",
                Payment_Type = "SMS",
                Virtual_Currency_Amount = PaymentInfo.PEACH..""
                }
                local data = PluginParam:create(paramMap);
                analytics_plugin:callFuncWithParam("onChargeOnlySuccess",data);
                end
                end

                CloudData.PEACH = CloudData.PEACH + peachNum
                if CloudData.FIRST_PURCHASE_STATE == 0 then CloudData.FIRST_PURCHASE_STATE = 1 end
                end
                end,0.2)--]]
            end
        end
    end, 0.1)
end

function PaymentLayer:pcPayTele(idx)

    -- 请求订单号，现在为21~32的编号
    local orderIdx = idx
    -- if(CloudData.PAYMENT_ITEM_STATE[idx-20]>0) then
    --     orderIdx = orderIdx + 6
    -- end

    local ac = nil
    if PaymentInfo.OPERATOR == 10086 then
        ac = AlertConnection.new(CONNECTION_PAYMENT,idx)
    elseif PaymentInfo.OPERATOR == 10010 then
        ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,idx)
    else
        ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,idx)
    end
    self:addChild(ac,100,12345)

    self.schedulePay_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.schedulePay_)
            local event = "OK,sdfsfsf"
            print("event : " .. event)
            if event == "notOK" then
                print("notOK")
                --elseif event == "OK" then
            else
                local results = string.split(event,",")
                if(results[1]~="OK") then
                    return
                end

                local peachNum = PaymentInfo.PEACH

                -- 移动订单号
                PaymentInfo.TRADE_ID = results[2] -- android 返回的交易号

                -- 充值成功
                self:stopAction(self.scheduleCk_)
                self.scheduleCk_ = nil

                -- 直接发送桃子
                CloudData.PEACH = CloudData.PEACH + peachNum
                --DataEye统计蟠桃产出
                if USE_DATAEYE then
                    DCCoin.gain("recharge", "peach", peachNum, CloudData.PEACH)
                end
                if CloudData.FIRST_PURCHASE_STATE == 0 then
                    CloudData.FIRST_PURCHASE_STATE = 1
                end

                -- 三次验证
                local params = {}
                params.times = 11
                params.type = 1
                params.orderId = PaymentInfo.BILLNO
                params.ID = PaymentInfo.ID
                params.STAGE_PROGRESS = CloudData.STAGE_PROGRESS
                params.BILLNO = PaymentInfo.BILLNO
                params.MONEY = PaymentInfo.MONEY
                params.PEACH = PaymentInfo.PEACH

                -- 延迟支付验证[电信]
                PaymentVerification.getInstance():checkInTele(params)

                --联网, 以后就不需要了，因为支付延迟
                --[[local ac = AlertConnection.new(CONNECTION_PAYMENT_MM, PaymentInfo.BILLNO.."")
                self:addChild(ac,100,10086)
                self.scheduleCk1_ = self:schedule(function()
                if not self:getChildByTag(10086) then
                self:stopAction(self.scheduleCk1_)

                -- 如果支付失败
                if(PaymentInfo.PAY_SUCCESS==false) then
                return
                end

                -- 如果支付成功，收集统计数据，添加道具

                --DataEye统计
                if USE_DATAEYE and CHANNEL ~= 2 then
                DCEvent.onEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end
                --AnySdk内嵌统计接口
                if USE_DATAEYE and CHANNEL == 2 then
                analytics_plugin:logEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end

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
                Order_Id = PaymentInfo.BILLNO.."",
                Product_Name = PaymentInfo.ID.."",
                Currency_Amount = PaymentInfo.MONEY.."",
                Currency_Type = "CNY",
                Payment_Type = "SMS",
                Virtual_Currency_Amount = PaymentInfo.PEACH..""
                }
                local data = PluginParam:create(paramMap);
                analytics_plugin:callFuncWithParam("onChargeOnlySuccess",data);
                end
                end

                CloudData.PEACH = CloudData.PEACH + peachNum
                if CloudData.FIRST_PURCHASE_STATE == 0 then CloudData.FIRST_PURCHASE_STATE = 1 end
                end
                end,0.2)--]]
            end

        end
    end, 0.1)
end


--移动MM支付
function PaymentLayer:payMM(idx)

    idx = NEW_PAY[idx-20]
    print("new idx = "..idx)    -- idx 1,2,4,6,7,8

    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "payMM"
    local javaParams = { PaymentInfo.BILLNO.."", idx }
    local javaMethodSig = "(Ljava/lang/String;I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    local peachNum = PaymentInfo.PEACH
    self:checkIsMMPaySuccess(peachNum)
end
--检查MM,需要返回交易号
function PaymentLayer:checkIsMMPaySuccess(peachNum)
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
                    local results = string.split(event,",")
                    if(results[1]~="OK") then
                        return
                    end

                    -- 移动交易号
                    PaymentInfo.TRADE_ID = results[2] -- android 返回的交易号

                    -- 直接发放桃子
                    CloudData.PEACH = CloudData.PEACH + peachNum
                    --DataEye统计蟠桃产出
                    if USE_DATAEYE then
                        DCCoin.gain("recharge", "peach", peachNum, CloudData.PEACH)
                    end
                    if CloudData.FIRST_PURCHASE_STATE == 0 then
                        CloudData.FIRST_PURCHASE_STATE = 1
                    end

                    -- 充值成功
                    self:stopAction(self.scheduleCk_)
                    self.scheduleCk_ = nil

                    local params = {}
                    params.times = 11
                    params.type = 1
                    params.tradeId = PaymentInfo.TRADE_ID
                    params.orderId = PaymentInfo.BILLNO
                    params.ID = PaymentInfo.ID
                    params.STAGE_PROGRESS = CloudData.STAGE_PROGRESS
                    params.BILLNO = PaymentInfo.BILLNO
                    params.MONEY = PaymentInfo.MONEY
                    params.PEACH = PaymentInfo.PEACH

                    -- 延迟支付验证
                    PaymentVerification.getInstance():checkInMM(params)



                    --联网
                    --[[local ac = AlertConnection.new(CONNECTION_PAYMENT_MM, PaymentInfo.BILLNO.."")
                    self:addChild(ac,100,10086)
                    self.scheduleCk1_ = self:schedule(function()
                    if not self:getChildByTag(10086) then
                    self:stopAction(self.scheduleCk1_)

                    -- 如果支付失败
                    if(PaymentInfo.PAY_SUCCESS==false) then
                    return
                    end

                    -- 如果支付成功，收集统计数据，添加道具

                    --DataEye统计
                    if USE_DATAEYE and CHANNEL ~= 2 then
                    DCEvent.onEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end
                    --AnySdk内嵌统计接口
                    if USE_DATAEYE and CHANNEL == 2 then
                    analytics_plugin:logEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS) end

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
                    Order_Id = PaymentInfo.BILLNO.."",
                    Product_Name = PaymentInfo.ID.."",
                    Currency_Amount = PaymentInfo.MONEY.."",
                    Currency_Type = "CNY",
                    Payment_Type = "SMS",
                    Virtual_Currency_Amount = PaymentInfo.PEACH..""
                    }
                    local data = PluginParam:create(paramMap);
                    analytics_plugin:callFuncWithParam("onChargeOnlySuccess",data);
                    end
                    end

                    CloudData.PEACH = CloudData.PEACH + peachNum
                    if CloudData.FIRST_PURCHASE_STATE == 0 then CloudData.FIRST_PURCHASE_STATE = 1 end
                    end
                    end,0.2)
                    --]]
                end
            end
        }
        local javaMethodSig = "(I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end, 0.2)
end



-- UC支付充值
function PaymentLayer:payUC()
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "payUC"
    local javaParams = { PaymentInfo.BILLNO.."",PaymentInfo.MONEY }
    local javaMethodSig = "(Ljava/lang/String;I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    local peachNum = PaymentInfo.PEACH
    self:checkIsUCPaySuccess(peachNum)
end
--检查
function PaymentLayer:checkIsUCPaySuccess(peachNum)
    if self.scheduleCk_ ~= nil then
        self:stopAction(self.scheduleCk_)
    end
    -- 查询充值状态
    self.scheduleCk_ = self:schedule(function()
        local javaClassName = "org/cocos2dx/lua/AppActivity"
        local javaMethodName = "checkIsUCPaySuccess"
        local javaParams = {
            function(event)
                print("event : " .. event)
                if event == "notOK" then
                    print("notOK")
                elseif event == "OK" then
                    -- 充值成功
                    self:stopAction(self.scheduleCk_)
                    self.scheduleCk_ = nil

                    self.checkPaymentStatusTimes_ = 0
                    --再次检查
                    self:checkIsUCPaySuccess1(peachNum)

                end
            end
        }
        local javaMethodSig = "(I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end, 0.2)
end
--再次检查，向服务器确认充值成功，避免UC废卡漏洞
function PaymentLayer:checkIsUCPaySuccess1(peachNum)

    -- 再查询充值状态
    local ac = AlertConnection.new(CONNECTION_PAYMENT_CHECK_STATUS,PaymentInfo.BILLNO.."")
    self:addChild(ac,100,69145)

    self.scheduleCk2_ = self:schedule(function()
        if not self:getChildByTag(69145) then
            self:stopAction(self.scheduleCk2_)

            if GameManager.CHECK_PAYMENT_STATUS == 2 then
                --DataEye统计
                if USE_DATAEYE then
                    DCEvent.onEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS)
                end
                --新增支付统计
                --PaymentInfo.MONEY = jsonTable.data.amount
                --PaymentInfo.PEACH = jsonTable.data.peach
                --PaymentInfo.BILLNO = jsonTable.data.orderId
                --DataEye统计
                if USE_DATAEYE then
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
                --                if USE_DATAEYE and CHANNEL == 2 then
                --                    if(analytics_plugin and analytics_plugin:isFunctionSupported("onChargeOnlySuccess")) then
                --                        local paramMap = {
                --                            Order_Id = PaymentInfo.BILLNO.."",
                --                            Product_Name = PaymentInfo.ID.."",
                --                            Currency_Amount = PaymentInfo.MONEY.."",
                --                            Currency_Type = "CNY",
                --                            Payment_Type = "Anysdk",
                --                            Virtual_Currency_Amount = PaymentInfo.PEACH..""
                --                        }
                --                        local data = PluginParam:create(paramMap);
                --                        analytics_plugin:callFuncWithParam("onChargeOnlySuccess",data);
                --                    end
                --                end

                CloudData.PEACH = CloudData.PEACH + peachNum
                --DataEye统计蟠桃产出
                if USE_DATAEYE then
                    DCCoin.gain("recharge", "peach", peachNum, CloudData.PEACH)
                end
                if CloudData.FIRST_PURCHASE_STATE == 0 then CloudData.FIRST_PURCHASE_STATE = 1 end
            else
                self.checkPaymentStatusTimes_ = self.checkPaymentStatusTimes_ + 1
                self:checkIsUCPaySuccess1(peachNum)
            end
        end
    end,0.2)

end


-- 短代支付TouchPay
function PaymentLayer:paySMS()
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "paySMS"
    local javaParams = { PaymentInfo.BILLNO.."",PaymentInfo.MONEY }
    local javaMethodSig = "(Ljava/lang/String;I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end

-- anysdk 付费
function PaymentLayer:payAnySdk(index)
    local info = {
        Product_Price = PaymentInfo.MONEY,
        Product_Id = index,
        Product_Name = "peach",
        Server_Id=0,
        Product_Count=1,
        Role_Id="1001",
        Role_Name="asd",
        EXT = PaymentInfo.BILLNO
    }
    -- analytics_plugin:logEvent("pay", info)
    for key, value in pairs(iap_plugin_maps) do
        print("key:" .. key)
        print("value: " .. type(value))
        value:payForProduct(info)
    end
end

--酷狗充值
function PaymentLayer:payKugou()
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "payKugou"
    local javaParams = { PaymentInfo.BILLNO.."",PaymentInfo.MONEY }
    local javaMethodSig = "(Ljava/lang/String;I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    local peachNum = PaymentInfo.PEACH
    self:checkIsKugouPaySuccess(peachNum)
end

function PaymentLayer:checkIsKugouPaySuccess(peachNum)
    if self.scheduleCk_ ~= nil then
        self:stopAction(self.scheduleCk_)
    end
    -- 查询充值状态
    self.scheduleCk_ = self:schedule(function()
        local javaClassName = "org/cocos2dx/lua/AppActivity"
        local javaMethodName = "checkIsKugouPaySuccess"
        local javaParams = {
            function(event)
                print("event : " .. event)
                if event == "notOK" then
                    print("notOK")
                else
                    -- 充值成功
                    self:stopAction(self.scheduleCk_)
                    self.scheduleCk_ = nil

                    --DataEye统计
                    if USE_DATAEYE then
                        DCEvent.onEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS)
                    end
                    CloudData.PEACH = CloudData.PEACH + peachNum
                    --DataEye统计蟠桃产出
                    if USE_DATAEYE then
                        DCCoin.gain("recharge", "peach", peachNum, CloudData.PEACH)
                    end
                    if CloudData.FIRST_PURCHASE_STATE == 0 then CloudData.FIRST_PURCHASE_STATE = 1 end

                    --DataEye统计
                    if USE_DATAEYE then
                        local paymentType = "unknown"
                        if CHANNEL == 3 then
                            paymentType = "酷狗"
                        elseif CHANNEL == 4 then
                            paymentType = "UC"
                        else
                            paymentType = "SMS"
                        end
                        DCVirtualCurrency.paymentSuccess(PaymentInfo.BILLNO.."", PaymentInfo.MONEY,"CNY",paymentType)
                    end
                end
            end
        }
        local javaMethodSig = "(I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end, 0.2)
end


























--弹窗关闭
function PaymentLayer:closeCallBack_()
    --标记关闭
    GameManager.IS_PAYMENT_LAYER_CLOSED   = true

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

return PaymentLayer
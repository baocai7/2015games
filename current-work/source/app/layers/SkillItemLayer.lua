--
--道具解锁与兑换
--

TYPE_UNLOCK      = 1
TYPE_BUY         = 2

local WSToast = import("utils.WSToast")
local AlertLackPeachLayer = import("layers.AlertLackPeachLayer")
local AlertConnection = import("customs.AlertConnection")

local SkillItemLayer = {}
SkillItemLayer = class("SkillItemLayer", function()
    return display.newLayer()
end)

function SkillItemLayer:ctor( type_, itemId )

    --type:TYPE_UNLOCK->解锁道具时的弹出层
    --type:TYPE_EXCHANGE->兑换道具时的弹出层

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

    --游戏暂停
    operateAllSchedulerAndActions(display.getRunningScene(),"PAUSE")

    --加载道具数据信息
    self.model_ = DataUtils.getSkillItemModel(itemId)
    self.itemId_ = itemId

    -- PC测试短信支付
    if device.platform == "mac" or device.platform == "pc" then
        USE_SMS_PAY = false
    end
    
    --init 
    if type_ == TYPE_UNLOCK then
        self:unlockItem_()
    elseif device.platform == "android" and USE_SMS_PAY then --短代支付,mac测试
        self:buyItemAn_()
    elseif device.platform == "android" and 4 == PaymentInfo.CHANNEL then -- UC平台，支付
        self:buyItem_()
    elseif device.platform == "ios" or device.platform == "windows" or device.platform == "mac" then --使用蟠桃
        self:buyItem_()
    else 
        self:buyItem_()
    end
end

--道具解锁
function SkillItemLayer:unlockItem_()
    --底层的光效
    local pLight = display.newSprite("item/light.png",display.cx,display.cy):addTo(self,1)

    --创建动画
    local frames = display.newFrames("item_appear%d.png",1,18,false)
    local animation = display.newAnimation(frames, 1.4/18)
    self.itemAppearAnimaPic1_ = display.newSprite()
    self.itemAppearAnimaPic1_:setPosition(display.cx,display.height * 0.6)
    self:addChild(self.itemAppearAnimaPic1_,2)
    self.itemAppearAnimaPic1_:playAnimationOnce(animation,false,function()
        self:action1_()
    end)
end
function SkillItemLayer:action1_()
    --道具图标
    self.itemPic_ = display.newSprite(self.model_.itemIconBig_,display.cx,display.height * 0.65)
        :addTo(self,3)
    --道具名称
    self.itemNamePic_ = display.newSprite(self.model_.itemName_,display.cx,display.height * 0.54)
        :addTo(self,3)
    --道具描述
    self.itemDescLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = string.format(self.model_.itemDesc_) ,size = 24,color = display.COLOR_BLACK,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(240,80),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,display.cx,display.height * 0.33)
        :addTo(self,3)
    --创建星星动画
    local frames = display.newFrames("shengli-xingxing%d.png",1,19)
    local animation = display.newAnimation(frames,0.12)
    self.itemStarAnimaPic_ = display.newSprite()
    self.itemStarAnimaPic_:setScale(1.2)
    self.itemStarAnimaPic_:setPosition(display.cx,display.height * 0.65)
    self:addChild(self.itemStarAnimaPic_,3)
    self.itemStarAnimaPic_:playAnimationForever(animation)
    --创建粒子特效
    self.particleNode_ = cc.ParticleBatchNode:create("item/star.png")
    local myParticle1   = cc.ParticleSystemQuad:create("item/star.plist")
    myParticle1:setPosition(cc.p(display.cx,display.cy))
    self.particleNode_:addChild(myParticle1)
    self:addChild(self.particleNode_,0)

    self:runAction(transition.sequence({cc.DelayTime:create(0.5),cc.CallFunc:create(function()
        --弹出“知道了”按钮
        self.closeBtn_ = cc.ui.UIPushButton.new({normal = "common_ui/known.png",pressed = "common_ui/known_h.png"})
            :align(display.CENTER,display.cx,display.height * 0.2)
            :onButtonClicked(function()
                self:knownCallBack_()
            end)
            :addTo(self,2)
    end)}))
end
function SkillItemLayer:knownCallBack_()
    --移除特效及图片
    self.itemAppearAnimaPic1_:removeFromParent()
    self.itemStarAnimaPic_:removeFromParent()
    self.particleNode_:removeFromParent()
    self.itemNamePic_:removeFromParent()
    self.itemDescLabel_:removeFromParent()
    self.closeBtn_:removeFromParent()

    --道具动画反向消失
    local frames = display.newFrames("item_appear%d.png",1,18,true)
    local animation = display.newAnimation(frames, 1.4/18)
    self.itemAppearAnimaPic2_ = display.newSprite()
    self.itemAppearAnimaPic2_:setPosition(display.cx,display.height * 0.6)
    self:addChild(self.itemAppearAnimaPic2_,2)
    self.itemAppearAnimaPic2_:playAnimationOnce(animation,false,function()
        --道具图标移动
        local spawn = cc.Spawn:create(cc.MoveTo:create(0.5,cc.p(display.width - 64,display.height * 0.1 * (9 - self.model_.itemId_))),
            cc.ScaleTo:create(0.5,0.65))
        self.itemPic_:runAction(transition.sequence({spawn,cc.CallFunc:create(function()
            self:action2_()
        end)}))
    end)
end
function SkillItemLayer:action2_()
    --逻辑处理（后续）
    if tonumber(self.model_.itemId_) == 1 then
        GameManager.ITEM1_ANIMATION_SHOWED_STAGE5 = true
    elseif tonumber(self.model_.itemId_) == 2 then
        GameManager.ITEM2_ANIMATION_SHOWED_STAGE5 = true
    end
    --游戏恢复
    operateAllSchedulerAndActions(display.getRunningScene(),"RESUME")

    --移除处理
    self.itemAppearAnimaPic2_:removeFromParent()
    self.itemPic_:removeFromParent()
    self:removeFromParent()
end






--兑换道具（使用蟠桃，旧）
function SkillItemLayer:buyItem_()
    --背景图
    local bg = display.newSprite("item/frame.png"):addTo(self.emptyNode_,1)

    --左边蟠桃
    --蟠桃边框
    local peachFrame = display.newSprite("common_ui/tou.png",bg:getContentSize().width * 0.25,bg:getContentSize().height * 0.72)
        :addTo(bg)
    --蟠桃图片
    display.newSprite("recharge/peach.png",peachFrame:getContentSize().width * 0.5,peachFrame:getContentSize().height * 0.5)
        :scale(0.7)
        :addTo(peachFrame)
    --红色显示圈
    local redPointPic1 = display.newSprite("item/red_point1.png",peachFrame:getContentSize().width * 0.9,peachFrame:getContentSize().height * 0.9)
        :addTo(peachFrame)
    --购买该道具所需的蟠桃数
    cc.ui.UILabel.new({
        UILabelType = 2,text = self.model_.itemPrice_ ,size = 24,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,redPointPic1:getContentSize().width * 0.42,redPointPic1:getContentSize().height * 0.55)
        :addTo(redPointPic1)

    --右边道具
    --道具边框
    local itemFrame = display.newSprite("common_ui/tou.png",bg:getContentSize().width * 0.75,bg:getContentSize().height * 0.72)
        :addTo(bg)
    --道具图标
    display.newSprite(self.model_.itemIconBig_,
        itemFrame:getContentSize().width * 0.5,itemFrame:getContentSize().height * 0.5)
        :addTo(itemFrame)
    --红色显示圈
    local redPointPic2 = display.newSprite("item/red_point1.png",itemFrame:getContentSize().width * 0.9,itemFrame:getContentSize().height * 0.9)
        :addTo(itemFrame)
    --一个道具的标识（“x1”）
    cc.ui.UILabel.new({
        UILabelType = 2,text = "x1" ,size = 24,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,redPointPic2:getContentSize().width * 0.42,redPointPic2:getContentSize().height * 0.55)
        :addTo(redPointPic2)

    --中间“=”标识
    display.newSprite("item/equal.png",bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.72)
        :addTo(bg)

    --左下显示当前的蟠桃数量
    display.newSprite("shop/peach_pic.png",bg:getContentSize().width * 0.1,bg:getContentSize().height * 0.42)
        :scale(0.5)
        :addTo(bg)
    --数量标签
    local labelFrame1 = display.newSprite("item/label.png",bg:getContentSize().width * 0.25,bg:getContentSize().height * 0.42)
        :addTo(bg)
    self.peachNumLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = CloudData.PEACH,size = 30,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,labelFrame1:getContentSize().width * 0.5,labelFrame1:getContentSize().height * 0.5)
        :addTo(labelFrame1)

    --右下显示当前道具的数量
    --道具名称
    local pItemName = display.newSprite(self.model_.itemNameColon_,
        bg:getContentSize().width * 0.56,bg:getContentSize().height * 0.42)
        :addTo(bg)
    --数量标签
    local labelFrame2 = display.newSprite("item/label.png",
        pItemName:getPositionX() + pItemName:getContentSize().width * 0.5,bg:getContentSize().height * 0.42)
        :addTo(bg)
    labelFrame2:setAnchorPoint(0,0.5)
    self.itemNumLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "0" ,size = 30,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,labelFrame2:getContentSize().width * 0.5,labelFrame2:getContentSize().height * 0.5)
        :addTo(labelFrame2)

    --兑换按钮
    cc.ui.UIPushButton.new({normal = "item/exchange.png",pressed = "item/exchange_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.18)
        :onButtonClicked(function()
            self:buyCallBack_()
        end)
        :addTo(bg,2)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.97,bg:getContentSize().height * 0.96)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :scale(0.7)
        :addTo(bg,2)

    --右侧滑出道具信息介绍
    self:loadItemInfo_()
end
function SkillItemLayer:loadItemInfo_()
    --边框
    local infoFrame = display.newSprite("item/label_frame.png")
        :addTo(self.emptyNode_,0)
    infoFrame:setOpacity(0)
    --道具图标
    local itemFrame = display.newSprite("common_ui/tou.png",
        infoFrame:getContentSize().width * 0.25,infoFrame:getContentSize().height * 0.83)
        :scale(0.5)
        :addTo(infoFrame)
    display.newSprite(self.model_.itemIconBig_,
        itemFrame:getContentSize().width * 0.5,itemFrame:getContentSize().height * 0.5)
        :addTo(itemFrame)
    --道具名称
    display.newSprite(self.model_.itemName_,
        infoFrame:getContentSize().width * 0.63,infoFrame:getContentSize().height * 0.88)
        :scale(0.70)
        :addTo(infoFrame)
    --道具功能介绍
    cc.ui.UILabel.new({
        UILabelType = 2,text = string.format(self.model_.itemDesc_) ,size = 20,color = cc.c3b(63,31,4),
        align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(158,80),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,infoFrame:getContentSize().width * 0.52,infoFrame:getContentSize().height * 0.56)
        :addTo(infoFrame)

    --滑出动画
    local delayTime = cc.DelayTime:create(0.25)
    local fadeIn    = cc.FadeIn:create(0.05)
    local moveTo    = cc.MoveTo:create(0.5,cc.p(230 + infoFrame:getContentSize().width * 0.55,0))
    infoFrame:runAction(transition.sequence({delayTime,fadeIn,moveTo}))
end


-- 安卓使用短代RMB直接购买
function SkillItemLayer:buyItemAn_()
    --背景图
    local bg = display.newSprite("item/frame_bg.png"):addTo(self.emptyNode_,1)

    --道具边框
    local itemFrame = display.newSprite("common_ui/tou.png",bg:getContentSize().width * 0.19,bg:getContentSize().height * 0.735)
        :scale(0.9)
        :addTo(bg)

    --道具图标
    display.newSprite(self.model_.itemIconBig_,
        itemFrame:getContentSize().width * 0.5,itemFrame:getContentSize().height * 0.5)
        :addTo(itemFrame)

    --道具名称
    display.newSprite(self.model_.itemName_,
        bg:getContentSize().width * 0.62,bg:getContentSize().height * 0.88)
        :scale(0.75)
        :addTo(bg)

    --道具功能介绍
    cc.ui.UILabel.new({
        UILabelType = 2,text = string.format(self.model_.itemDesc_) ,size = 20,color = cc.c3b(63,31,4),
        align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(330,70),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.38)
        :addTo(bg)

    --道具价格
--    cc.ui.UILabel.new({
--        UILabelType = 2,text = string.format(self.model_.itemPriceRMB_),size = 30,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
--        :align(display.CENTER,bg:getContentSize().width * 0.65,bg:getContentSize().height * 0.66)
--        :addTo(bg)
    cc.ui.UILabel.new({
        UILabelType = 1,text = string.format(self.model_.itemPriceRMB_),font = "fonts/whiteNum.fnt"})
        :scale(0.85)
        :align(display.CENTER,bg:getContentSize().width * 0.65,bg:getContentSize().height * 0.66)
        :addTo(bg)

    --使用按钮
    cc.ui.UIPushButton.new({normal = "item/use.png",pressed = "item/use1.png"})
        :scale(0.85)
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.18)
        :onButtonClicked(function()
            self:buyAnCallBack_()
        end)
        :addTo(bg,2)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.97,bg:getContentSize().height * 0.96)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :scale(0.6)
        :addTo(bg,2)
end

function SkillItemLayer:buyCallBack_()
    --逻辑处理
    if CloudData.PEACH >= self.model_.itemPrice_ then
        Game.SKILL_ITEM_BUY[self.itemId_] = Game.SKILL_ITEM_BUY[self.itemId_] + 1
        CloudData.SKILL_ITEM_INFO[self.itemId_] = CloudData.SKILL_ITEM_INFO[self.itemId_] + 1
        CloudData.PEACH = CloudData.PEACH - self.model_.itemPrice_
        self.peachNumLabel_:setString(string.format("%d",CloudData.PEACH))
        self.itemNumLabel_:setString(string.format("%d",CloudData.SKILL_ITEM_INFO[self.itemId_]))

        --DataEye统计道具购买
        if USE_DATAEYE then
            --DCItem.buy(self.model_.itemName_, "战斗内", 1, self.model_.itemPrice_, "蟠桃", CloudData.STAGE_PROGRESS .. "") 
            local name
            if self.itemId_ == 1 then
                name = "LJJD"               
            elseif self.itemId_ == 2 then 
                name = "JGD"             
            elseif self.itemId_ == 3 then
                name = "BJS"             
            elseif self.itemId_ == 4 then
                name = "JZZ"              
            elseif self.itemId_ == 5 then
                name = "WZF"             
            else
                name = "XBL"               
            end 
            DCItem.buy(name, "gamescene", 1, self.model_.itemPrice_, "peach", CloudData.STAGE_PROGRESS .. "")        
        end
    else
        local alert = AlertLackPeachLayer.new()
        self:addChild(alert, 20)
        --[[local toast = WSToast.new("蟠桃不足",1.5)
        self:addChild(toast,100)--]]
    end

end

-- 游戏内ID 到 服务器产品号
SkillItemLayer.PRODUCT_IDs = {19,18,17,16,15,14} -- 由cp服务器给定

function SkillItemLayer:buyAnCallBack_()

    -- 先获取商品信息
--    local ac = AlertConnection.new(CONNECTION_PAYMENT,SkillItemLayer.PRODUCT_IDs[self.itemId_]) -- idx 可能变化
    -- 先获取商品订单号 [移动要求16位，联通要求24位]
    local ac = nil
    if PaymentInfo.CHANNEL == 10086 then
        ac = AlertConnection.new(CONNECTION_PAYMENT,SkillItemLayer.PRODUCT_IDs[self.itemId_])
    elseif PaymentInfo.CHANNEL == 10010 then
        ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,SkillItemLayer.PRODUCT_IDs[self.itemId_])
    else
        if PaymentInfo.OPERATOR == 10086 then
            ac = AlertConnection.new(CONNECTION_PAYMENT,SkillItemLayer.PRODUCT_IDs[self.itemId_])
        elseif PaymentInfo.OPERATOR == 10010 then
            ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,SkillItemLayer.PRODUCT_IDs[self.itemId_])
        elseif PaymentInfo.OPERATOR == 10000 then
            if CHANNEL_ID  == 370000 then
                ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,SkillItemLayer.PRODUCT_IDs[self.itemId_])
            else
                ac = AlertConnection.new(CONNECTION_PAYMENT,SkillItemLayer.PRODUCT_IDs[self.itemId_])
            end     
        else
            ac = AlertConnection.new(CONNECTION_PRODUCT_ADD,SkillItemLayer.PRODUCT_IDs[self.itemId_])
        end
    end
    self:addChild(ac,100,12345)

    self.schedulePay_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.schedulePay_)

            --todo Ray 购买道具并使用
            if PaymentInfo.CHANNEL == 10086 then 
                self:payMM(9 + self.itemId_)
            elseif PaymentInfo.CHANNEL == 10010 then 
                self:payWo(9 + self.itemId_)
            else 
                if PaymentInfo.OPERATOR == 10086 then
                    self:payMM(9 + self.itemId_)
                elseif PaymentInfo.OPERATOR == 10010 then
                    self:payWo(9 + self.itemId_)
                elseif PaymentInfo.OPERATOR == 10000 then
                    if CHANNEL_ID  == 370000 then
                        self:payWo(9 + self.itemId_)
                    else 
                        self:payTele(9 + self.itemId_)
                    end 
                else
                    self:payWo(9 + self.itemId_)
                end
            end 
        end
    end,0.1)
end

--MM支付 -- 添加订单号
function SkillItemLayer:payMM(idx)
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "payMM"
    local javaParams = {PaymentInfo.BILLNO.."", idx }
    local javaMethodSig = "(Ljava/lang/String;I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    self:checkIsMMPaySuccess()
end



--检查MM
function SkillItemLayer:checkIsMMPaySuccess()
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

                    PaymentInfo.TRADE_ID = results[2] -- android payMM 返回的交易号

                    -- 充值成功
                    self:stopAction(self.scheduleCk_)
                    self.scheduleCk_ = nil

                    -- 向服务器添加产品,并需验证【如果体验不好，先操作后补交订单，但有可能有支付漏洞】
                    --local ac = AlertConnection.new(CONNECTION_PRODUCT_ADD, SkillItemLayer.PRODUCT_IDs[self.itemId_])

                    local params = {}
                    params.times = 11
                    params.type = 3
                    params.tradeId = PaymentInfo.TRADE_ID
                    params.orderId = PaymentInfo.BILLNO
                    params.ID = PaymentInfo.ID
                    params.STAGE_PROGRESS = CloudData.STAGE_PROGRESS
                    params.BILLNO = PaymentInfo.BILLNO
                    params.MONEY = PaymentInfo.MONEY
                    params.PEACH = PaymentInfo.PEACH

                    params.itemPriceRMB_ = self.model_.itemPriceRMB_..""
                    params.itemId_ = self.itemId_
                    params.itemPrice_ = self.model_.itemPrice_..""
                    
                    -- 延迟支付验证
                    PaymentVerification.getInstance():checkInMM(params)
                    
                    Game.SKILL_ITEM_ICON[self.itemId_]:castSkill()
                    
                    -- 结算统计（短代购买献宝令）
                    if self.itemId_ == 6 then
                        -- 使用传2为了方便服务器判断是短信购买的，不做扣除蟠桃的操作
                        Game.SKILL_ITEM_BUY[6] = Game.SKILL_ITEM_BUY[6] + 1
                        Game.SKILL_ITEM_USE[6] = Game.SKILL_ITEM_USE[6] + 2
                    end
                    
                    --DataEye统计道具购买
                    if USE_DATAEYE then
                        --DCItem.buy(self.model_.itemName_, "战斗内", 1, self.model_.itemPrice_, "蟠桃", CloudData.STAGE_PROGRESS .. "")                                  
                        local name
                        if self.itemId_ == 1 then
                            name = "LJJD"               
                        elseif self.itemId_ == 2 then 
                            name = "JGD"             
                        elseif self.itemId_ == 3 then
                            name = "BJS"             
                        elseif self.itemId_ == 4 then
                            name = "JZZ"              
                        elseif self.itemId_ == 5 then
                            name = "WZF"             
                        else
                            name = "XBL"               
                        end 
                        DCItem.buy(name, "gamescene", 1, self.model_.itemPrice_, "peach", CloudData.STAGE_PROGRESS .. "")
                    end

                    self:closeCallBack_()
                    
                    -- 直接走正常支付流程
                    --[[local ac = AlertConnection.new(CONNECTION_PAYMENT_MM, PaymentInfo.BILLNO.."")
                    self:addChild(ac,100,10086)
                    self.scheduleCk1_ = self:schedule(function()
                        if not self:getChildByTag(10086) then

                            -- 如果支付失败
                            if(PaymentInfo.PAY_SUCCESS==false) then
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
                                            Order_Id = "123456",
                                            Product_Name = "item"..self.itemId_,
                                            Currency_Amount = self.model_.itemPriceRMB_.."",
                                            Currency_Type = "CNY",
                                            Payment_Type = "SMS",
                                            Virtual_Currency_Amount = self.model_.itemPrice_..""
                                        }
                                        local data = PluginParam:create(paramMap);
                                        analytics_plugin:callFuncWithParam("onChargeOnlySuccess",data);
                                    end
                                end

                                Game.SKILL_ITEM_ICON[self.itemId_]:castSkill()
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
function SkillItemLayer:payWo(idx)
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "payWo"
    local javaParams = {PaymentInfo.BILLNO.."", idx }
    local javaMethodSig = "(Ljava/lang/String;I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    self:checkIsWoPaySuccess()
end
--检查Wo
function SkillItemLayer:checkIsWoPaySuccess()
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

                    local params = {}
                    params.times = 11
                    params.type = 3
                    params.orderId = PaymentInfo.BILLNO
                    params.ID = PaymentInfo.ID
                    params.STAGE_PROGRESS = CloudData.STAGE_PROGRESS
                    params.BILLNO = PaymentInfo.BILLNO
                    params.MONEY = PaymentInfo.MONEY
                    params.PEACH = PaymentInfo.PEACH
                                            
                    params.itemPriceRMB_ = self.model_.itemPriceRMB_..""
                    params.itemId_ = self.itemId_
                    params.itemPrice_ = self.model_.itemPrice_..""
                    
                    -- 延迟支付验证
                    PaymentVerification.getInstance():checkInWO(params)
                    
                    -- 结算统计（短代购买献宝令）
                    if self.itemId_ == 6 then
                        -- 使用传2为了方便服务器判断是短信购买的，不做扣除蟠桃的操作
                        Game.SKILL_ITEM_BUY[6] = Game.SKILL_ITEM_BUY[6] + 1
                        Game.SKILL_ITEM_USE[6] = Game.SKILL_ITEM_USE[6] + 2
                    end
                    
                    -- 直接使用，不验证。支付漏洞？？
                    Game.SKILL_ITEM_ICON[self.itemId_]:castSkill()

                    --DataEye统计道具购买
                    if USE_DATAEYE then
                        --DCItem.buy(self.model_.itemName_, "战斗内", 1, self.model_.itemPrice_, "蟠桃", CloudData.STAGE_PROGRESS .. "")                                  
                        local name
                        if self.itemId_ == 1 then
                            name = "LJJD"               
                        elseif self.itemId_ == 2 then 
                            name = "JGD"             
                        elseif self.itemId_ == 3 then
                            name = "BJS"             
                        elseif self.itemId_ == 4 then
                            name = "JZZ"              
                        elseif self.itemId_ == 5 then
                            name = "WZF"             
                        else
                            name = "XBL"               
                        end 
                        DCItem.buy(name, "gamescene", 1, self.model_.itemPrice_, "peach", CloudData.STAGE_PROGRESS .. "")
                    end

                    self:closeCallBack_()
                    
                    -- 直接走正常支付流程
                    --[[local ac = AlertConnection.new(CONNECTION_PAYMENT_WO, PaymentInfo.BILLNO.."")
                    self:addChild(ac,100,10010)
                    self.scheduleCk1_ = self:schedule(function()
                        if not self:getChildByTag(10010) then
                            -- 如果支付失败
                            if(PaymentInfo.PAY_SUCCESS==false) then
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
                                            Order_Id = "123456",
                                            Product_Name = "item"..self.itemId_,
                                            Currency_Amount = self.model_.itemPriceRMB_.."",
                                            Currency_Type = "CNY",
                                            Payment_Type = "SMS",
                                            Virtual_Currency_Amount = self.model_.itemPrice_..""
                                        }
                                        local data = PluginParam:create(paramMap);
                                        analytics_plugin:callFuncWithParam("onChargeOnlySuccess",data);
                                    end
                                end

                                Game.SKILL_ITEM_ICON[self.itemId_]:castSkill()
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




--电信爱游戏支付
function SkillItemLayer:payTele(idx)
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "payTele"
    local javaParams = { PaymentInfo.BILLNO.."",PaymentInfo.MONEY,idx }
    local javaMethodSig = "(Ljava/lang/String;II)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    local peachNum = PaymentInfo.PEACH

    self:checkIsTelePaySuccess(peachNum)
end
--检查Tele
function SkillItemLayer:checkIsTelePaySuccess(peachNum)
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
                
                    print("pay tele OK")
                    
                    -- 充值成功
                    self:stopAction(self.scheduleCk_)
                    self.scheduleCk_ = nil

                    -- 直接使用，不验证。支付漏洞？
                    Game.SKILL_ITEM_ICON[self.itemId_]:castSkill()
                    
                    -- 三次验证
                    local params = {}
                    params.times = 11
                    params.type = 3
                    params.orderId = PaymentInfo.BILLNO
                    params.ID = PaymentInfo.ID
                    params.STAGE_PROGRESS = CloudData.STAGE_PROGRESS
                    params.BILLNO = PaymentInfo.BILLNO
                    params.MONEY = PaymentInfo.MONEY
                    params.PEACH = PaymentInfo.PEACH

                    params.itemPriceRMB_ = self.model_.itemPriceRMB_..""
                    params.itemId_ = self.itemId_
                    params.itemPrice_ = self.model_.itemPrice_..""

                    -- 延迟支付验证[电信]
                    PaymentVerification.getInstance():checkInTele(params)
                    
                    -- 结算统计（短代购买献宝令）
                    if self.itemId_ == 6 then
                        -- 使用传2为了方便服务器判断是短信购买的，不做扣除蟠桃的操作
                        Game.SKILL_ITEM_BUY[6] = Game.SKILL_ITEM_BUY[6] + 1
                        Game.SKILL_ITEM_USE[6] = Game.SKILL_ITEM_USE[6] + 2
                    end

                    --DataEye统计道具购买
                    if USE_DATAEYE then
                        --DCItem.buy(self.model_.itemName_, "战斗内", 1, self.model_.itemPrice_, "蟠桃", CloudData.STAGE_PROGRESS .. "")                               
                        local name
                        if self.itemId_ == 1 then
                            name = "LJJD"               
                        elseif self.itemId_ == 2 then 
                            name = "JGD"             
                        elseif self.itemId_ == 3 then
                            name = "BJS"             
                        elseif self.itemId_ == 4 then
                            name = "JZZ"              
                        elseif self.itemId_ == 5 then
                            name = "WZF"             
                        else
                            name = "XBL"               
                        end 
                        DCItem.buy(name, "gamescene", 1, self.model_.itemPrice_, "peach", CloudData.STAGE_PROGRESS .. "")
                    end

                    self:closeCallBack_()

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







function SkillItemLayer:closeCallBack_()
    --游戏恢复
    operateAllSchedulerAndActions(display.getRunningScene(),"RESUME")

    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
    })
    self.emptyNode_:runAction(popupLayer)
end


return SkillItemLayer
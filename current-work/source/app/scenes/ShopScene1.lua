--
--商店界面（购买物品）
--
local DataLabelIcon = import("icons.DataLabelIcon")
local ShopIcon = import("icons.ShopIcon1")
local AlertConnection = import("customs.AlertConnection")
local WSToast = import("utils.WSToast")
local CSVParser = import("utils.CSVParser")
local AlertLackPeachLayer = import("layers.AlertLackPeachLayer")

SHOP_TYPE_MYSTERY_BUSINESSMAN = 1
SHOP_TYPE_FAIRY_GOODS = 2
SHOP_TYPE_EXP_MALL = 3

local ShopScene1 = class("ShopScene1", function()
    return display.newScene("ShopScene1")
end)

function ShopScene1:ctor(index)

    --背景图片
    local bg_ = display.newSprite("common_ui/uibg.jpg",display.cx,display.cy):addTo(self)

    --"商店"标签
    local shopTitle_ = display.newSprite("shop/title_shop.png",bg_:getContentSize().width * 0.3,bg_:getContentSize().height * 0.94):addTo(bg_)
    shopTitle_:setScale(0.9)

    --经验
    local expLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_EXP,true)
    expLabel:setScale(0.8)
    expLabel:setPosition(cc.p(bg_:getContentSize().width * 0.55,bg_:getContentSize().height * 0.95))
    bg_:addChild(expLabel,15)
    --蟠桃
    local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH,true)
    peachLabel:setScale(0.8)
    peachLabel:setPosition(cc.p(bg_:getContentSize().width * 0.82,bg_:getContentSize().height * 0.95))
    bg_:addChild(peachLabel,15)
    --返回按钮
    cc.ui.UIPushButton.new({normal = "common_ui/back.png",pressed = "common_ui/back_h.png"})
        :scale(0.8)
        :align(display.CENTER,bg_:getContentSize().width * 0.12 ,bg_:getContentSize().height * 0.94)
        :onButtonPressed(function()
            self:performWithDelay(function()
                self:returnCallBack_()
            end,0.1)
        end)
        -- :onButtonClicked(function()
        --     self:returnCallBack_()
        -- end)
        :addTo(bg_,15)

    self.propBack_ = display.newSprite("shop1/shopdi.png",bg_:getContentSize().width * 0.5,
        bg_:getContentSize().height * 0.5)
        :addTo(bg_)

    self.businessIcon = cc.ui.UIPushButton.new({normal = "shop/business.png",disabled = "shop/business_h.png"})
        :pos(bg_:getContentSize().width * 0.5 + self.propBack_:getContentSize().width/2 + 35,bg_:getContentSize().height * 0.75)
        :addTo(bg_)
        :onButtonClicked(function(event)
            self:initBusinessmanData()
        end)

    self.goodsIcon = cc.ui.UIPushButton.new({normal = "shop/goods.png",disabled = "shop/goods_h.png"})
        :pos(bg_:getContentSize().width * 0.5 + self.propBack_:getContentSize().width/2 + 35,bg_:getContentSize().height * 0.55)
        :addTo(bg_)
        :onButtonClicked(function(event)
            self:initFairyGoodsUI()
        end)

    self.expIcon = cc.ui.UIPushButton.new({normal = "shop/exp_mall.png",disabled = "shop/exp_mall_h.png"})
        :pos(bg_:getContentSize().width * 0.5 + self.propBack_:getContentSize().width/2 + 35,bg_:getContentSize().height * 0.35)
        :addTo(bg_)
        :onButtonClicked(function(event)
            self:initEXPMallUI()
        end)

    if index == SHOP_TYPE_EXP_MALL then
        self:initEXPMallUI()
    elseif index == SHOP_TYPE_FAIRY_GOODS then
        self:initFairyGoodsUI()
    else
        self:initBusinessmanData()
    end

    if USE_DATAEYE then
        DCEvent.onEvent("open_shopScene")
    end

    self:addAndroidReturnButton_()
end

function ShopScene1:initBusinessmanData()
    local ac = AlertConnection.new(CONNECTION_SHOP_INIT_1)
    self:addChild(ac, 100, 12345)

    self.scheduleResult_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)
            self.shopInfo_ = CloudData.SHOP_INFO_1
            dump(self.shopInfo_)
            self:initMysteryBusinessmanUI(true)
        end
    end,0.1)
end

function ShopScene1:initMysteryBusinessmanUI(countTag)
    self.businessIcon:setButtonEnabled(false)
    self.goodsIcon:setButtonEnabled(true)
    self.expIcon:setButtonEnabled(true)
    self.propBack_:removeAllChildren()
    --下次刷新
    local flushSprite_ = display.newSprite("shop1/nextflush.png")
        :pos(self.propBack_:getContentSize().width * 0.35, -self.propBack_:getContentSize().height * 0.075)
        :addTo(self.propBack_)

    --经历倒计时
    self.flushLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = "",size = 28,color = display.COLOR_GREEN,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,flushSprite_:getContentSize().width * 0.75 - 5,flushSprite_:getContentSize().height * 0.5)
        :addTo(flushSprite_)

    --立即刷新
    cc.ui.UIPushButton.new({normal = "shop1/flush.png",pressed = "shop/flush_h.png"})
        :pos(self.propBack_:getContentSize().width * 0.65,-self.propBack_:getContentSize().height * 0.075)
        :onButtonClicked(function()
            self:pressFlushCallBack_()
        end)
        :addTo(self.propBack_, 1)

    if countTag then
        self.flushTime_ = tonumber(self.shopInfo_.data.nextFreshTime)
        self:startCountDown_(self.flushTime_)
    end

    self.iconsTable_ = {}
    for i = 1, 6 do
        self.shopInfo_.data.goodsList[i].goods.goodsInfoType = SHOP_TYPE_MYSTERY_BUSINESSMAN
        self.shopInfo_.data.goodsList[i].goods.flag = self.shopInfo_.data.goodsList[i].flag
        local content = ShopIcon.new(self.shopInfo_.data.goodsList[i].goods, i)
        content:setPosition(624 - (i % 2) * 408, 615 - math.ceil(i/2) * 172)
        self.propBack_:addChild(content)
        self.iconsTable_[i] = content
    end
end

function ShopScene1:initFairyGoodsUI()
    self:countdownOver_()
    self.businessIcon:setButtonEnabled(true)
    self.goodsIcon:setButtonEnabled(false)
    self.expIcon:setButtonEnabled(true)
    self.propBack_:removeAllChildren()

    local cPropInfo = DataRetainer.SHOPGOODS_INFO

    for i = 1, 8 do
        local content = {}
        content.goodsName = cPropInfo:objectAtIndex(i)["goodsName"]
        content.type = cPropInfo:objectAtIndex(i)["goodsType"]
        content.itemId = cPropInfo:objectAtIndex(i)["Id"]
        content.pic = cPropInfo:objectAtIndex(i)["pic"]
        content.desc = cPropInfo:objectAtIndex(i)["desc"]
        content.num = cPropInfo:objectAtIndex(i)["num"]
        content.price = cPropInfo:objectAtIndex(i)["price"]
        content.costType = 0
        content.goodsInfoType = SHOP_TYPE_FAIRY_GOODS
        local icon_ = ShopIcon.new(content, i)
        icon_:setPosition(620 - (i % 2) * 400, 595 - math.ceil(i/2) * 130)
        self.propBack_:addChild(icon_)
    end
end

function ShopScene1:initEXPMallUI()
    self:countdownOver_()
    self.businessIcon:setButtonEnabled(true)
    self.goodsIcon:setButtonEnabled(true)
    self.expIcon:setButtonEnabled(false)
    self.propBack_:removeAllChildren()

    local cPropInfo = DataRetainer.SHOPEXP_INFO

    for i = 1, 8 do
        local num = tonumber(cPropInfo:objectAtIndex(i)["num"])
        local price = tonumber(cPropInfo:objectAtIndex(i)["price"])
        local iconBg_ = display.newSprite("shop1/shopkuang.png", 620 - (i % 2) * 400, 595 - math.ceil(i/2) * 130)
            :addTo(self.propBack_)
        iconBg_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            return self:clickEXPItem_(i, num, price)
        end)
        iconBg_:setTouchEnabled(true)

        local frame_ = display.newSprite("common_ui/tou.png", iconBg_:getContentSize().width * 0.15,iconBg_:getContentSize().height * 0.5)
            :scale(0.78)
            :addTo(iconBg_)

        display.newSprite("shop/exp_pic.png", frame_:getContentSize().width * 0.5,frame_:getContentSize().height * 0.5)
            :scale(95/144)
            :addTo(frame_)

        cc.ui.UILabel.new({text = num .. "万经验",size = 25,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
            :align(display.CENTER,iconBg_:getContentSize().width * 0.65,iconBg_:getContentSize().height * 0.75)
            :addTo(iconBg_)

        local priceSprite_ = display.newSprite("shop1/shopprice.png", iconBg_:getContentSize().width * 0.7,
            iconBg_:getContentSize().height * 0.32)
            :addTo(iconBg_)

        cc.ui.UILabel.newBMFontLabel_({text = price, font = "fonts/whiteNum.fnt"})
            :scale(0.65)
            :align(display.CENTER,priceSprite_:getPositionX() + 30,priceSprite_:getPositionY())
            :addTo(iconBg_)
    end
end

function ShopScene1:startCountDown_(time)
    --转换时分秒
    self.hour_    = math.floor(time / 3600)
    self.minutes_ = math.floor((time - self.hour_ * 3600) / 60)
    self.seconds_ = math.floor(time - self.hour_ * 3600 - self.minutes_ * 60)

    --倒计时
    self.schedule_ = self:schedule(function()
        self:updateTime_()
    end, 1.0)
end

function ShopScene1:updateTime_()
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

function ShopScene1:countdownOver_()
    self:stopAction(self.schedule_)
end

function ShopScene1:returnCallBack_()
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
    end

    display.replaceScene(require("scenes.ChapterScene").new())
end

function ShopScene1:pressFlushCallBack_()
    if CloudData.PEACH < 20 then
        local alert = AlertLackPeachLayer.new()
        self:addChild(alert, 20)
        --local t = WSToast.new("蟠桃不足", 1)
        --self:addChild(t, 20)
    else
        local ac = AlertConnection.new(CONNECTION_SHOP_REFRESH_1)
        self:addChild(ac, 100, 12345)

        self.scheduleResult_ = self:schedule(function()
            if not self:getChildByTag(12345) then
                self:stopAction(self.scheduleResult_)
                self.shopInfo_ = CloudData.SHOP_INFO_1

                self:flushSuccessfully_()
            end
        end,0.1)
    end
end

function ShopScene1:flushSuccessfully_()
    --DataEye统计
    if USE_DATAEYE  then
        DCEvent.onEvent("flush_shop_info")
    end

    if self.hour_ + self.minutes_ + self.seconds_ > 0 then
        CloudData.PEACH = CloudData.PEACH - 20
        self:initMysteryBusinessmanUI(false)
    else
        self:initMysteryBusinessmanUI(true)
    end
end

function ShopScene1:clickEXPItem_(index, num, price)
    self.buyConfirmNode = display.newNode()
        :pos(display.cx, display.cy)
        :addTo(self,20)

    local buyConfirmLayer = display.newColorLayer(cc.c4b(0,0,0,150))
        :pos(-display.cx,-display.cy)
        :addTo(self.buyConfirmNode,-1)

    local bg = display.newSprite("common_ui/common_bg.png")
        :scale(0.7)
        :addTo(self.buyConfirmNode)


    --文字标签
    cc.ui.UILabel.new({UILabelType = 2,text = "确定购买吗",size = 30,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.56)
        :addTo(bg)

    --确定按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.25)
        :onButtonClicked(function()
            self:buyEXPConfirm_(index, num, price)
        end)
        :addTo(bg)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.95,bg:getContentSize().height * 0.95)
        :scale(0.9)
        :onButtonClicked(function()
            self:closeBuyConfirmLayer_()
        end)
        :addTo(bg)

    --DataEye统计
    if USE_DATAEYE  then
        DCEvent.onEvent("press_shop_3_" .. index)
    end
end

function ShopScene1:buyEXPConfirm_(index, num, price)
    --DataEye统计
    if USE_DATAEYE then
        DCEvent.onEvent("buy_shop_3_" .. index)
    end

    local num_ = CloudData.PEACH
    if num_ < price then
        --DataEye统计
        if USE_DATAEYE  then
            DCEvent.onEvent("buy_shop_3_" .. index .. "_not_enough_peach")
        end

        local alert = AlertLackPeachLayer.new()
        self:addChild(alert, 20)
        --local t = WSToast.new("蟠桃不足",1.0)
        --self:addChild(t,100)
        return
    end

    local ac = AlertConnection.new(CONNECTION_SHOP_BUY_EXP, index)
    display.getRunningScene():addChild(ac, 100, 12345)

    self.scheduleResult_ = self:schedule(function()
        if not display.getRunningScene():getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)
            self:buyEXPSuccessed_(index, num, price)
        end
    end,0.1)
end

function ShopScene1:buyEXPSuccessed_(index, num, price)
    --DataEye统计
    if USE_DATAEYE  then
        DCEvent.onEvent("buy_shop_3_" .. index .. "_success")
    end

    local t = WSToast.new("购买成功", 1.0)
    display.getRunningScene():addChild(t, 50)
    CloudData.PEACH = CloudData.PEACH - price
    CloudData.EXP = CloudData.EXP + num * 10000
    self:closeBuyConfirmLayer_()
end

function ShopScene1:closeBuyConfirmLayer_()
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),
        cc.CallFunc:create(function()
            self.buyConfirmNode:removeSelf()
        end)
    })
    self.buyConfirmNode:runAction(popupLayer)
end

function ShopScene1:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function ShopScene1:showReturnWarning_()
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

function ShopScene1:onEnter()
end

function ShopScene1:onExit()
    self:removeAllChildren()
    display.removeUnusedSpriteFrames()
end

return ShopScene1

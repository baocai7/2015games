
local AlertConnection = import("customs.AlertConnection")
local BuddhaIcon      = import("icons.BuddhaIcon")
local WSToast = import("utils.WSToast")
local AlertLackPeachLayer = import("layers.AlertLackPeachLayer")
local AlertLackEXPLayer = import("layers.AlertLackEXPLayer")
local NewFellowLayer   = import("layers.NewFellowLayer")

local ShopIconDetailLayer1 =  class("ShopIconDetailLayer1", function()
    return display.newNode()
end)

function ShopIconDetailLayer1:ctor(content, index)
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

    self:initData(content, index)
end

function ShopIconDetailLayer1:initData(content, index)
    self.no_ = index
    self.costType_ = tonumber(content.costType)
    self.desc_ = content.desc
    --	self.discount_ = content.discount
    self.goodsId_ = content.goodsId
    self.goodsName_ = content.goodsName
    self.itemId_ = tonumber(content.itemId)
    self.num_ = tonumber(content.num)
    self.pic_ = content.pic
    self.price_ = tonumber(content.price)
    self.type_ = content.type
    self.goodsInfoType = content.goodsInfoType

    print("self.desc_" .. self.desc_)
    print("self.costType_" .. self.costType_)
    print("self.num_" .. self.num_)
    print("self.type_" .. self.type_)
    print("self.goodsInfoType" .. self.goodsInfoType)

    self:initContent()
end

function ShopIconDetailLayer1:initContent()
    self.bg_ = display.newSprite("shop/tips.png")
        :addTo(self.emptyNode_)

    cc.ui.UILabel.new({UILabelType = 2,text = self.goodsName_,size = 25,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.63,self.bg_:getContentSize().height * 0.88)
        :addTo(self.bg_)

    if self.type_ == "buddha" then
        local buddhaModel = DataUtils.getBuddhaModel(self.itemId_)
        local buddhaIcon = BuddhaIcon.new(buddhaModel)
        buddhaIcon:setPosition(self.bg_:getContentSize().width * 0.2,self.bg_:getContentSize().height * 0.86)
        buddhaIcon:setScale(0.75)
        self.bg_:addChild(buddhaIcon)
    else
        local frame_ = display.newSprite("common_ui/tou.png", self.bg_:getContentSize().width * 0.2,self.bg_:getContentSize().height * 0.86)
            :scale(0.78)
            :addTo(self.bg_)
        local buddhaIcon_ = display.newSprite(self.pic_, frame_:getContentSize().width * 0.5,
            frame_:getContentSize().height * 0.5)
            :addTo(frame_)
        if self.type_ == "renshen" then
            buddhaIcon_:setScale(0.9)
        end
    end

    cc.ui.UILabel.new({text = "数量:" .. self.num_, size = 22,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        --:scale(0.6)
        :align(display.CENTER_LEFT,self.bg_:getContentSize().width * 0.38,
            self.bg_:getContentSize().height * 0.8)
        :addTo(self.bg_)

    cc.ui.UILabel.new({text = self.desc_,size = 24,color = display.COLOR_BLACK, dimensions = cc.size(260,170),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.52,self.bg_:getContentSize().height * 0.53)
        :addTo(self.bg_)

    cc.ui.UILabel.new({text = "购买" .. self.num_ .."件",size = 20,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.2,self.bg_:getContentSize().height * 0.3)
        :addTo(self.bg_)

    local img_
    if self.costType_ == 1 then
        img_ = "shop1/shopprice1.png"
    else
        img_ = "shop1/shopprice.png"
    end

    local priceSprite_ = display.newSprite(img_, self.bg_:getContentSize().width * 0.6,
        self.bg_:getContentSize().height * 0.3)
        :addTo(self.bg_)

    cc.ui.UILabel.newBMFontLabel_({text = self.price_, font = "fonts/whiteNum.fnt"})
        :scale(0.8)
        :align(display.CENTER,priceSprite_:getPositionX() + 30,priceSprite_:getPositionY())
        :addTo(self.bg_)

    cc.ui.UIPushButton.new({normal = "shop1/buy_normal.png",pressed = "shop1/buy_normal_special.png"})
        :onButtonClicked(function()
            self:buyPropCallBack_()
        end)
        :scale(0.8)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.15)
        :addTo(self.bg_)

    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :scale(0.8)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.95,self.bg_:getContentSize().height * 0.95)
        :addTo(self.bg_)
end

function ShopIconDetailLayer1:buyPropCallBack_()
    if self.costType_ == 0 then
        local num = CloudData.PEACH
        if num < self.price_ then
            if self.goodsInfoType == SHOP_TYPE_MYSTERY_BUSINESSMAN then
                --DataEye统计
                if USE_DATAEYE then
                    DCEvent.onEvent("buy_shop_1_goodsId_" .. self.goodsId_ .. "_not_enough_peach")
                end
            elseif self.goodsInfoType == SHOP_TYPE_FAIRY_GOODS then
                --DataEye统计
                if USE_DATAEYE then
                    DCEvent.onEvent("buy_shop_2_" .. self.no_ .. "_not_enough_peach")
                end
            end

            local alert = AlertLackPeachLayer.new()
            self:addChild(alert, 20)
            --[[local t = WSToast.new("蟠桃不足",1.0)
            self:addChild(t,100)--]]
            return
        end
    else
        local num = CloudData.EXP
        if num < self.price_ then
            if self.goodsInfoType == SHOP_TYPE_MYSTERY_BUSINESSMAN then
                --DataEye统计
                if USE_DATAEYE then
                    DCEvent.onEvent("buy_shop_1_goodsId_" .. self.goodsId_ .. "_not_enough_exp")
                end
            elseif self.goodsInfoType == SHOP_TYPE_FAIRY_GOODS then
                --DataEye统计
                if USE_DATAEYE then
                    DCEvent.onEvent("buy_shop_2_" .. self.no_ .. "_not_enough_exp")
                end
            end

            local alert = AlertLackEXPLayer.new()
            self:addChild(alert, 20)
            --[[local t = WSToast.new("经验不足",1.0)
            self:addChild(t,100)--]]
            return
        end
    end

    if self.goodsInfoType == SHOP_TYPE_MYSTERY_BUSINESSMAN then
        local ac = AlertConnection.new(CONNECTION_SHOP_BUY_1,self.no_ - 1)
        self:addChild(ac, 100, 12345)

        self.scheduleResult_ = self:schedule(function()
            if not self:getChildByTag(12345) then
                self:stopAction(self.scheduleResult_)
                self:addThings()
            end
        end,0.1)
    elseif self.goodsInfoType == SHOP_TYPE_FAIRY_GOODS then
        local ac = AlertConnection.new(CONNECTION_SHOP_BUY_ITEM,self.no_)
        self:addChild(ac, 100, 12345)

        self.scheduleResult_ = self:schedule(function()
            if not self:getChildByTag(12345) then
                self:stopAction(self.scheduleResult_)
                self:addThings()
            end
        end,0.1)
    end

end

function ShopIconDetailLayer1:addThings()
    if self.type_ == "exp" then
        CloudData.EXP = CloudData.EXP + self.num_
    elseif self.type_ == "buddha" then
        local buddhaModel = DataUtils.getBuddhaModel(self.itemId_)
        if buddhaModel.buddhaState_ == 1 then
            CloudData.ESSENCE = CloudData.ESSENCE + buddhaModel.essenceValue_
        else
            local layer = NewFellowLayer.new(buddhaModel)
            display.getRunningScene():addChild(layer,150)
            DataUtils.setNewBuddhaCloudData(self.itemId_)
        end
    elseif self.type_ == "piece" then
        CloudData.MONSTER_PIECE_INFO[self.itemId_] = CloudData.MONSTER_PIECE_INFO[self.itemId_] + self.num_
    elseif self.type_ == "item" then
        CloudData.SKILL_ITEM_INFO[self.itemId_] = CloudData.SKILL_ITEM_INFO[self.itemId_] + self.num_

        --DataEye统计道具购买
        if USE_DATAEYE then
            --DCItem.buy(self.goodsName_, "商店", self.num_, self.price_, "peach", CloudData.STAGE_PROGRESS .. "") 
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
            DCItem.buy(name, "shopscene", self.num_, self.price_, "peach", CloudData.STAGE_PROGRESS .. "")              
        end
    elseif self.type_ == "renshen" then
        CloudData.GINSENG_FRUIT = CloudData.GINSENG_FRUIT + self.num_
    elseif self.type_ == "sweep" then
        CloudData.SWEEP = CloudData.SWEEP + self.num_
    elseif self.type_ == "essence" then
        CloudData.ESSENCE = CloudData.ESSENCE + self.num_
    end

    if self.costType_ == 0 then
        CloudData.PEACH = CloudData.PEACH - self.price_
    else
        CloudData.EXP = CloudData.EXP - self.price_
    end

    local t = WSToast.new("购买成功",1.0)
    self:addChild(t,100)

    if self.goodsInfoType == SHOP_TYPE_MYSTERY_BUSINESSMAN then
        --DataEye统计
        if USE_DATAEYE  then
            DCEvent.onEvent("buy_shop_1_goodsId_" .. self.goodsId_ .. "_success")
        end
    elseif self.goodsInfoType == SHOP_TYPE_FAIRY_GOODS then
        --DataEye统计
        if USE_DATAEYE then
            DCEvent.onEvent("buy_shop_2_" .. self.no_ .. "_success")
        end
    end

    self:closeCallBack_()
    if self.goodsInfoType == SHOP_TYPE_MYSTERY_BUSINESSMAN then
        display.getRunningScene().iconsTable_[self.no_]:soldOut()
    end
end

function ShopIconDetailLayer1:closeCallBack_()
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
    })
    self.emptyNode_:runAction(popupLayer)
end

return ShopIconDetailLayer1
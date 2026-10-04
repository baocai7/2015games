
local AlertConnection = import("customs.AlertConnection")
local ShopIconDetailLayer = import("layers.ShopIconDetailLayer1")
local BuddhaIcon      = import("icons.BuddhaIcon")

local ShopIcon1  =  class("ShopIcon1", function()
    return display.newNode()
end)

function ShopIcon1:ctor(content, index)
    --dump(content)
    self.goodsInfoType = content.goodsInfoType
    if self.goodsInfoType == SHOP_TYPE_MYSTERY_BUSINESSMAN then --神秘商人
        self:initData(content, index)
    elseif self.goodsInfoType == SHOP_TYPE_FAIRY_GOODS then     --仙宫杂货
        self:initData1(content, index)
    end
end

function ShopIcon1:initData(content, index)
    self.type = SHOP_TYPE_MYSTERY_BUSINESSMAN
    self.no_ = index
    self.costType_ = tonumber(content.costType)
    self.discount_ = tonumber(content.discount)

    self.goodsId_ = content.goodsId
    self.goodsName_ = content.goodsName
    self.itemId_ = tonumber(content.itemId)
    self.num_ = content.num
    self.pic_ = content.pic
    self.price_ = content.price
    self.type_ = content.type
    self.isBought_ = content.flag
    --self.goodsInfoType = content.goodsInfoType

    self:initContent(content)
end

function ShopIcon1:initData1(content, index)
    self.no_ = index
    --self.costType_ = tonumber(content.costType)

    --self.discount_ = tonumber(content.discount)

    self.goodsId_ = content.goodsId
    self.goodsName_ = content.goodsName
    self.itemId_ = tonumber(content.itemId)
    self.num_ = content.num
    self.pic_ = content.pic
    self.price_ = content.price
    self.type_ = content.type
    -- self.isBought_ = content.flag
    --self.goodsInfoType = content.goodsInfoType

    self:initContent1(content)
end

function ShopIcon1:initContent(content)
    self.icon = display.newSprite("shop1/shopdikuang.png")
    self.icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:buyPropCallBack_(event.name, content, self.no_)
    end)
    self.icon:setTouchEnabled(true)
    self:setContentSize(cc.size(self.icon:getContentSize().width,self.icon:getContentSize().height))
    self:addChild(self.icon)

    local name = self.goodsName_ .. "x" .. self.num_
    --[[if self.type_ == "piece" then
    name = self.goodsName_ .. "x" .. self.num_
    end	--]]
    cc.ui.UILabel.new({text = name,size = 25,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.icon:getContentSize().width * 0.64,self.icon:getContentSize().height * 0.785)
        :addTo(self.icon)

    if self.type_ == "buddha" then
        local buddhaModel = DataUtils.getBuddhaModel(self.itemId_)
        local buddhaIcon = BuddhaIcon.new(buddhaModel)
        buddhaIcon:setPosition(self.icon:getContentSize().width * 0.15,self.icon:getContentSize().height * 0.5)
        --buddhaIcon:setScale(0.78)
        self.icon:addChild(buddhaIcon)
    else
        local frame_ = display.newSprite("common_ui/tou.png", self.icon:getContentSize().width * 0.175,
            self.icon:getContentSize().height * 0.5)
            --:scale(0.78)
            :addTo(self.icon)
        local buddhaIcon_ = display.newSprite(self.pic_, frame_:getContentSize().width * 0.5,
            frame_:getContentSize().height * 0.5)
            :addTo(frame_)
        if self.type_ == "renshen" then
            buddhaIcon_:setScale(0.9)
        elseif self.type_ == "piece" then
            buddhaIcon_:setScale(1.4)
        end
    end

    local img_, img1_, scale1_
    if self.costType_ == 1 then
        img_ = "shop1/shopprice1.png"
        img1_ = "win_or_lose/exp.png"
        scale1_ = 0.415
    else
        img_ = "shop1/shopprice.png"
        img1_ = "shop1/peach_pic.png"
        scale1_ = 0.32
    end

    if self.discount_ and self.discount_ ~= 0 then
        display.newSprite("shop1/oprice.png", self.icon:getContentSize().width * 0.455,
            self.icon:getContentSize().height * 0.53)
            :addTo(self.icon)
        --:scale(0.9)

        local oprice_ = display.newSprite(img1_, self.icon:getContentSize().width * 0.6,
            self.icon:getContentSize().height * 0.53)
            :addTo(self.icon)
            :scale(scale1_)

        local op = self.price_ / self.discount_ * 100
        local optext = cc.ui.UILabel.newBMFontLabel_({text = op, font = "fonts/whiteNum.fnt", size = 20})
            :scale(0.65)
            :align(display.CENTER,oprice_:getPositionX() + 30,oprice_:getPositionY())
            :addTo(self.icon)
        optext:setAnchorPoint(0,0.5)

        display.newSprite("shop1/line.png", self.icon:getContentSize().width * 0.62, self.icon:getContentSize().height * 0.53)
            :addTo(self.icon)
        --:scale(0.9)

        display.newSprite("shop1/cprice.png", self.icon:getContentSize().width * 0.455,
            self.icon:getContentSize().height * 0.28)
            :addTo(self.icon)
        --:scale(0.9)

        local cprice_ = display.newSprite(img_, self.icon:getContentSize().width * 0.735, self.icon:getContentSize().height * 0.28)
            :addTo(self.icon)
            :scale(0.88)

        local cptext = cc.ui.UILabel.newBMFontLabel_({text = self.price_, font = "fonts/whiteNum.fnt", size = 20})
            :scale(0.65)
            :align(display.CENTER,cprice_:getPositionX() - 15,cprice_:getPositionY())
            :addTo(self.icon)
        cptext:setAnchorPoint(0,0.5)

        display.newSprite("shop1/".. self.discount_ ..".png", self.icon:getContentSize().width * 0.162,self.icon:getContentSize().height * 0.782)
            :addTo(self.icon, 2)
    else
        display.newSprite("shop1/price.png", self.icon:getContentSize().width * 0.455,
            self.icon:getContentSize().height * 0.35)
            :addTo(self.icon)
        --:scale(0.9)

        local cprice_ = display.newSprite(img_, self.icon:getContentSize().width * 0.735, self.icon:getContentSize().height * 0.35)
            :addTo(self.icon)
            :scale(0.88)

        local cptext = cc.ui.UILabel.newBMFontLabel_({text = self.price_, font = "fonts/whiteNum.fnt", size = 20})
            :scale(0.65)
            :align(display.CENTER,cprice_:getPositionX() - 15, cprice_:getPositionY())
            :addTo(self.icon)
        cptext:setAnchorPoint(0,0.5)
    end

    --    local priceSprite_ = display.newSprite(img_, self.icon:getContentSize().width * 0.74,
    --			self.icon:getContentSize().height * 0.28)
    --        :addTo(self.icon)
    --        :scale(0.9)
    --
    --    local pp = display.newSprite(img_, self.icon:getContentSize().width * 0.74, self.icon:getContentSize().height * 0.53)
    --        :addTo(self.icon)
    --        :scale(0.9)
    --
    --	cc.ui.UILabel.newBMFontLabel_({text = self.price_, font = "fonts/whiteNum.fnt", size = 20})
    --		:scale(0.65)
    --        :align(display.CENTER,priceSprite_:getPositionX() + 35,priceSprite_:getPositionY())
    --        :addTo(self.icon)
    --
    --    local p = self.price_ / self.discount_ * 100
    --    cc.ui.UILabel.newBMFontLabel_({text = p, font = "fonts/whiteNum.fnt", size = 20})
    --        :scale(0.65)
    --        :align(display.CENTER,pp:getPositionX() + 35,pp:getPositionY())
    --        :addTo(self.icon)
    --
    --    display.newSprite("shop1/line.png", self.icon:getContentSize().width * 0.65, self.icon:getContentSize().height * 0.53)
    --        :addTo(self.icon)
    --        :scale(0.9)

    if self.isBought_ ~= 0 then
        display.newSprite("shop1/soldout.png", self.icon:getContentSize().width * 0.75,self.icon:getContentSize().height * 0.5)
            :addTo(self.icon, 2)
    end

end

function ShopIcon1:initContent1(content)
    self.icon = display.newSprite("shop1/shopkuang.png")
    self.icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:buyPropCallBack_(event.name, content, self.no_)
    end)
    self.icon:setTouchEnabled(true)
    self:setContentSize(cc.size(self.icon:getContentSize().width,self.icon:getContentSize().height))
    self:addChild(self.icon)

    local name = self.goodsName_ .. "x" .. self.num_
    --[[if self.type_ == "piece" then
    name = self.goodsName_ .. "x" .. self.num_
    end --]]
    cc.ui.UILabel.new({text = name,size = 25,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.icon:getContentSize().width * 0.65,self.icon:getContentSize().height * 0.75)
        :addTo(self.icon)

    local frame_ = display.newSprite("common_ui/tou.png", self.icon:getContentSize().width * 0.15,
        self.icon:getContentSize().height * 0.5)
        :scale(0.78)
        :addTo(self.icon)
    local buddhaIcon_ = display.newSprite(self.pic_, frame_:getContentSize().width * 0.5,
        frame_:getContentSize().height * 0.5)
        :addTo(frame_)
    if self.type_ == "renshen" then
        buddhaIcon_:setScale(0.9)
    elseif self.type_ == "piece" then
        buddhaIcon_:setScale(1.4)
    end

    local priceSprite_ = display.newSprite("shop1/shopprice.png", self.icon:getContentSize().width * 0.7,
        self.icon:getContentSize().height * 0.32)
        :addTo(self.icon)

    cc.ui.UILabel.newBMFontLabel_({text = self.price_, font = "fonts/whiteNum.fnt", size = 20})
        :scale(0.65)
        :align(display.CENTER,priceSprite_:getPositionX() + 35,priceSprite_:getPositionY())
        :addTo(self.icon)
end

function ShopIcon1:buyPropCallBack_(event, content, index)
    if event == "began" then
        return true
    end

    if event == "ended" then
        if self.goodsInfoType ~= SHOP_TYPE_MYSTERY_BUSINESSMAN or self.isBought_ == 0 then
            if self.goodsInfoType == SHOP_TYPE_MYSTERY_BUSINESSMAN then
                if USE_DATAEYE then
                    DCEvent.onEvent("press_shop_1_goodsId_" .. self.goodsId_ )
                end
            elseif self.goodsInfoType == SHOP_TYPE_FAIRY_GOODS then
                if USE_DATAEYE then
                    DCEvent.onEvent("press_shop_2_" .. index)
                end
            end

            local detail = ShopIconDetailLayer.new(content, index)
            display.getRunningScene():addChild(detail,20)
        end
    end
end

function ShopIcon1:soldOut()
    self.isBought_ = 1
    display.newSprite("shop1/soldout.png", self.icon:getContentSize().width * 0.75,self.icon:getContentSize().height * 0.5)
        :addTo(self.icon, 100)
end

return ShopIcon1
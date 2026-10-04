
--[[=============================================================================
#     FileName: ExchangeIcon.lua
#         Desc: 活动时活动币的兑换物品
#       Author: Hoo
#   LastChange: 2015-04-28 
#      History:
=============================================================================]]

local ExchangeIcon  =  class("ExchangeIcon", function()
	return display.newNode()
end)

function ExchangeIcon:ctor( id )
    local goodsId      =  tonumber(DataRetainer.ACTIVITY_SHOP_INFO:objectAtIndex(id)["goodsId"])
    local goodsPrice   =  tonumber(DataRetainer.ACTIVITY_SHOP_INFO:objectAtIndex(id)["price"])
    local goodsName    =  DataRetainer.ACTIVITY_SHOP_INFO:objectAtIndex(id)["goodsName"]
    local goodsPic     =  DataRetainer.ACTIVITY_SHOP_INFO:objectAtIndex(id)["picPath"]
    local goodsType    =  DataRetainer.ACTIVITY_SHOP_INFO:objectAtIndex(id)["goodsType"]
    
    -- print("====================================================")
    -- print("goodsId : "..goodsId)
    -- print("goodsPrice : "..goodsPrice)
    -- print("goodsName : "..goodsName)
    -- print("goodsPic : "..goodsPic)
    -- print("goodsType : "..goodsType)
    -- print("====================================================")

    -- 背景
    local cellFrame = display.newSprite("recharge/cell_frame.png")
        :addTo(self)

    -- 添加图片
    local picFrame = nil
    if goodsType == "buddha" then 
        -- 边框
        picFrame = display.newSprite("upgrade/q4.png",cellFrame:getContentSize().width * 0.18,cellFrame:getContentSize().height * 0.5)
            :addTo(cellFrame)
        -- if id == 1 then
        --     -- 边框
        --     picFrame = display.newSprite("upgrade/q4.png",cellFrame:getContentSize().width * 0.18,cellFrame:getContentSize().height * 0.5)
        --         :addTo(cellFrame)
        -- elseif id == 2 then
        --     -- 边框
        --     picFrame = display.newSprite("upgrade/q5.png",cellFrame:getContentSize().width * 0.18,cellFrame:getContentSize().height * 0.5)
        --         :addTo(cellFrame)
        -- end
    else
        -- 边框
        picFrame = display.newSprite("common_ui/tou.png",cellFrame:getContentSize().width * 0.18,cellFrame:getContentSize().height * 0.5)
            :addTo(cellFrame)
    end
    -- 图片
    local pic = display.newSprite(goodsPic,picFrame:getContentSize().width * 0.5,picFrame:getContentSize().height * 0.5)
        :addTo(picFrame,-1)

    -- 商品名称
    local nameLabel = cc.ui.UILabel.new({
    UILabelType = 2,text = goodsName,size = 25,color = cc.c3b(51,28,0),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,cellFrame:getContentSize().width * 0.63,cellFrame:getContentSize().height * 0.78)
        :addTo(cellFrame)

    -- 标价显示
        -- 价格
    display.newSprite("shop1/price.png",cellFrame:getContentSize().width * 0.4,cellFrame:getContentSize().height * 0.45)
        :addTo(cellFrame)
        -- 代币
    display.newSprite("activity_stage/currency_pic1.png",
        cellFrame:getContentSize().width * 0.54,cellFrame:getContentSize().height * 0.45)
        :scale(0.9)
        :addTo(cellFrame)
        --边框
    local priceFrame = display.newSprite("activity_stage/price_frame.png",cellFrame:getContentSize().width * 0.75,cellFrame:getContentSize().height * 0.45)
        :addTo(cellFrame)
    local priceLabel = cc.ui.UILabel.new({
        UILabelType = 1,text = goodsPrice,font = "fonts/whiteNum.fnt"})
        :scale(0.75)
        :align(display.CENTER,priceFrame:getContentSize().width * 0.5,priceFrame:getContentSize().height * 0.5)
        :addTo(priceFrame)
end


return ExchangeIcon
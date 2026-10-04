
--[[=============================================================================
#     FileName: ExchangeLayer.lua
#         Desc: 活动奖励兑换
#       Author: Hoo
#   LastChange: 2015-04-28
#      History:
=============================================================================]]

local ExchangeIcon    = import("icons.ExchangeIcon")
local AlertConnection = import("customs.AlertConnection")
local NewFellowLayer  = import("layers.NewFellowLayer")
local WSToast         = import("utils.WSToast")
local x = 1

local ExchangeLayer  =  class("ExchangeLayer", function()
	return display.newLayer()
end)

function ExchangeLayer:ctor()
	-- 添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

	-- 初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.cy)
	self:addChild(self.emptyNode_)

	-- 弹出效果
	self.emptyNode_:setScale(0)
	local popupLayer = transition.sequence(
		{cc.ScaleTo:create(0.2, 1.1),
		cc.ScaleTo:create(0.1, 1.0)})
	self.emptyNode_:runAction(popupLayer)

	-- 播放音效(打开层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end

	-- init
	self:initUI_()
end

function ExchangeLayer:initUI_()
	local activityShopInfo = DataRetainer.ACTIVITY_SHOP_INFO
	self.exchangeIconTable_ = {}

	-- 背景
	local bg = display.newSprite("common_ui/window_bg.png"):addTo(self.emptyNode_)
    display.newSprite("activity_stage/exchange.png",bg:getContentSize().width * 0.14,bg:getContentSize().height * 0.88):addTo(bg)

    -- 当前代币数量
    cc.ui.UILabel.new({
        UILabelType = 2,text = "当前数量:",size = 25,color = cc.c3b(255,255,255),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.45,bg:getContentSize().height * 0.96)
        :addTo(bg,3)
    local rewardPic = display.newSprite("activity_stage/currency_pic1.png",
        bg:getContentSize().width * 0.52,bg:getContentSize().height * 0.96)
        :addTo(bg,3)
        -- 数量
    self.coinsNumLabel_ = cc.ui.UILabel.new({
        UILabelType = 1,text = CloudData.ACTIVITY_COINS,font = "fonts/whiteNum.fnt"})
        :scale(0.7)
        :align(display.CENTER_LEFT,bg:getContentSize().width * 0.52 + rewardPic:getContentSize().width * 0.55,bg:getContentSize().height * 0.96)
        :addTo(bg,3)  

    -- 创建listView
    self.listView = cc.ui.UIListView.new {
        --bgColor = cc.c4b(200, 200, 200, 120),
        viewRect = cc.rect(67,30,920,545),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
        :onTouch(handler(self,self.touchListener))
        :addTo(bg)

    local totalNum    = activityShopInfo:getTotalRows() - 1
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
            local exchangeIcon  = ExchangeIcon.new((i - 1) * 2 + count)
            exchangeIcon:setPosition(460 * count - 230,91)
            exchangeIcon:setTouchSwallowEnabled(false)
            content:addChild(exchangeIcon)

            table.insert(self.exchangeIconTable_,exchangeIcon)
        end
        content:setContentSize(920,182)
        item:addContent(content)
        item:setItemSize(920,182)
        self.listView:addItem(item)
    end
    self.listView:reload()

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
	    :onButtonClicked(function()
	    	self:closeCallBack_()
	    end)
		:scale(0.8)
	    :align(display.CENTER,bg:getContentSize().width * 0.94,bg:getContentSize().height * 0.89)
	    :addTo(bg,2)
end

function ExchangeLayer:touchListener(event)
	if "clicked" == event.name then
        local column = math.ceil(event.point.x / 460)
        local idx = (event.itemPos - 1) * 2 + column
        self:exchangeGoods_(idx)
        print("idx = "..idx)    -- idx 1~8
    elseif "moved" == event.name then

    elseif "ended" == event.name then

    end
end

function ExchangeLayer:exchangeGoods_( index )
    local goodsPrice   =  tonumber(DataRetainer.ACTIVITY_SHOP_INFO:objectAtIndex(index)["price"])
    local goodsName    =  DataRetainer.ACTIVITY_SHOP_INFO:objectAtIndex(index)["goodsName"]

    -- 遮罩层
    self.confirmLayer_ = display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,10)

    -- 背景
    local bg = display.newSprite("common_ui/common_bg.png", display.cx, display.cy)
        :scale(0)
        :addTo(self.confirmLayer_)
    bg:runAction(transition.sequence({cc.ScaleTo:create(0.2, 1.1),cc.ScaleTo:create(0.1, 1.0)}))

    -- 提示信息
    cc.ui.UILabel.new({
        UILabelType = 2,text = string.format("确定消耗%d仙石兑换%s吗？", goodsPrice,goodsName),size = 28,color = cc.c3b(51,28,0),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.55)
        :addTo(bg,3)  

    -- 确定按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.25)
        :onButtonClicked(function()
            self:confirmCallBack_(index)
        end)
        :addTo(bg,3)   

    -- 关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.7)
        :align(display.CENTER,bg:getContentSize().width * 0.96,bg:getContentSize().height * 0.94)
        :onButtonClicked(function()
            bg:runAction(transition.sequence({cc.ScaleTo:create(0,1.0),cc.ScaleTo:create(0.1,1.1),
                cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
                    self.confirmLayer_:removeSelf()
                end)
            }))
        end)
        :addTo(bg,3)   
end

-- 确定购买
function ExchangeLayer:confirmCallBack_(index)
    local ac = AlertConnection.new(CONNECTION_ACTIVITY_SHOP_EXCHANGE,index)
    self:addChild(ac,100,12345)

    self.scheduleExchange_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleExchange_)

            -- 更新数量
            self.coinsNumLabel_:setString(CloudData.ACTIVITY_COINS)

            if CloudData.ACTIVITY_SHOP_INFO_TABLE["errorCode"] ~= 0 then
                local msg = CloudData.ACTIVITY_SHOP_INFO_TABLE["errorMsg"]
                local toast = WSToast.new(msg)
                self:addChild(toast,20)

                return
            end

            -- 若是新兵种，则跳转新兵种界面
            local infoTable = CloudData.ACTIVITY_SHOP_INFO_TABLE.data
            if infoTable["type"] == "buddha" then
                if infoTable["essence"] == 0  then
                    local buddhaModel = DataUtils.getBuddhaModel(infoTable["npcId"])
                    local layer = NewFellowLayer.new(buddhaModel)
                    display.getRunningScene():addChild(layer,200)
                    DataUtils.setNewBuddhaCloudData(infoTable["npcId"])
                else
                    local toast = WSToast.new(string.format("已有神仙，转换为%d精华石",infoTable["essence"]))
                    self:addChild(toast,20)

                    self.confirmLayer_:removeSelf()
                    return 
                end     
            end

            local toast = WSToast.new("兑换成功")
            self:addChild(toast,20)

            self.confirmLayer_:removeSelf()
        end
    end,0.1)
end

-- 弹窗关闭
function ExchangeLayer:closeCallBack_()

	GameManager.IS_EXCHANGE_LAYER_CLOSED = true
	-- 播放音效(关闭层)
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

return ExchangeLayer
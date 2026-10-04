--
--充值界面
--

local AlertConnection = import("customs.AlertConnection")

local PaymentIcon  =  class("PaymentIcon", function()
	return display.newNode()
end)

function PaymentIcon:ctor( id )
	self:initData_(id)
	self:initUI_()
end

--加载充值数据
function PaymentIcon:initData_(id)
    -- 若已购买，则+6
	if CloudData.PAYMENT_ITEM_STATE[id] ~= 0 then          -- 原条件：CloudData.PAYMENT_ITEM_STATE[id] == 1
		id = id + 6
	end
	local paymentModel = DataUtils.getPaymentModel(id)
	self.id_        = paymentModel.id_
    self.type_      = paymentModel.type_
    self.price_     = paymentModel.price_
    self.peachNum_  = paymentModel.peachNum_
    self.addedNum_  = paymentModel.addedNum_
    self.dailyGet_  = paymentModel.dailyGet_
    self.validTime_ = paymentModel.validTime_
    self.title_     = paymentModel.title_
    self.desc_      = paymentModel.desc_ 
    self.picPath_   = paymentModel.picPath_
end

--初始化UI
function PaymentIcon:initUI_()
	--背景
	local cellFrame = display.newSprite("recharge/cell_frame.png")
		:addTo(self)

	--添加图片
		--边框
	local picFrame = display.newSprite("common_ui/tou.png",cellFrame:getContentSize().width * 0.18,cellFrame:getContentSize().height * 0.5)
		:addTo(cellFrame)
		--图片
	local pic = display.newSprite(self.picPath_,picFrame:getContentSize().width * 0.5,picFrame:getContentSize().height * 0.5)
		:scale(95/134)
		:addTo(picFrame)

	--充值title
	local titleLabel = cc.ui.UILabel.new({
    UILabelType = 2,text = self.title_,size = 25,color = cc.c3b(51,28,0),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,cellFrame:getContentSize().width * 0.63,cellFrame:getContentSize().height * 0.78)
        :addTo(cellFrame)

    --充值相关信息描述
	local descLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = self.desc_,size = 20,color = cc.c3b(3,161,4),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,cellFrame:getContentSize().width * 0.63,cellFrame:getContentSize().height * 0.52)
        :addTo(cellFrame)
    if self.id_ < 3 then
        descLabel:setColor(cc.c3b(221,0,1))
    end

    --标价显示
    	--边框
    local priceFrame = display.newSprite("recharge/price_frame.png",cellFrame:getContentSize().width * 0.60,cellFrame:getContentSize().height * 0.25)
    	:addTo(cellFrame)
    	--价格
	-- local priceLabel = cc.ui.UILabel.new({
 --    	UILabelType = 1,text = self.price_,font = "fonts/whiteNum.fnt"})
	-- 	:scale(0.75)
 --        :align(display.CENTER,priceFrame:getContentSize().width * 0.55,priceFrame:getContentSize().height * 0.5)
 --        :addTo(priceFrame)
    local priceLabel = cc.ui.UILabel.new({
        UILabelType = 1,text = self.price_,font = "fonts/whiteNum.fnt"})
        :scale(0.75)
        :align(display.CENTER_RIGHT,priceFrame:getContentSize().width * 0.5,priceFrame:getContentSize().height * 0.5)
        :addTo(priceFrame)

    -- 是否有首次双倍
    if self.type_ == 1 then
        display.newSprite("recharge/tip.png",cellFrame:getContentSize().width * 0.143,cellFrame:getContentSize().height * 0.80)
            :addTo(cellFrame,1)
    elseif self.type_ == 2 then
        display.newSprite("recharge/double.png",cellFrame:getContentSize().width * 0.143,cellFrame:getContentSize().height * 0.80)
            :addTo(cellFrame,1)
    end
end

-- function PaymentIcon:getPeackCallBack_()
-- 	local currScene = display.getRunningScene()
-- 	local ac = AlertConnection.new(CONNECTION_PAYMENT_GET_DAILY_PEACH,self.id_)
--     currScene:addChild(ac,100,11345)

--     self.scheduleP_ = self:schedule(function() 
--         if not currScene:getChildByTag(11345) then
--             self:stopAction(self.scheduleP_)
            
--             --数据处理
--             self.getPeachBtn_:setButtonEnabled(false)
--             CloudData.PAYMENT_ITEM_STATE[self.id_] = -1
-- 			CloudData.PEACH = CloudData.PEACH + self.dailyGet_
-- 			--DataEye统计蟠桃产出
-- 	        if USE_DATAEYE then  
-- 	            DCCoin.gain("recharge", "peach", self.dailyGet_, CloudData.PEACH)              
-- 	        end
--         end
--     end,0.1)	
-- end

return PaymentIcon
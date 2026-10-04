--
--购买经验
--

local AlertConnection = import("customs.AlertConnection")
local WSToast         = import("utils.WSToast")
local AlertLackPeachLayer = import("layers.AlertLackPeachLayer")

local BuyExpLayer  =  class("BuyExpLayer", function()
	return display.newLayer()
end)

function BuyExpLayer:ctor( param )
	--1.物品名称数组: self.nameTable_
	--2.图片类型数组: self.typeTable_
	--3.物品价格数组: self.priceTable_
	self.nameTable_ = {"1万经验", "10万经验","80万经验","320万经验"}
	self.typeTable_ = {1,1,1,1}
	self.priceTable_ = {10,95,720,2800}
	self.expTable_ = {10000,100000,800000,3200000}
	
	--添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150))
		:addTo(self,-1)
	
	--初始化基础节点	
	self.node = display.newNode()
		:scale(0)
		:pos(display.cx, display.cy)
		:addTo(self,1)
	
	--弹出效果	
	local popupLayer = transition.sequence(
			{cc.ScaleTo:create(0.2, 1.1),
			cc.ScaleTo:create(0.1, 1.0)})
		self.node:runAction(popupLayer)

	--播放音效(打开层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end
	
	if param ~= nil then
		--确认购买
		self:confirmToBuy_(param)
	else
		--初始化界面
		self:initUI_()
	end
end

function BuyExpLayer:initUI_()	
	--背景
	local frame = display.newSprite("alert_exp/bg_frame.png")
		:addTo(self.node)
	
	for i = 1, 4 do	
		local item = display.newSprite("alert_exp/item_bg.png")
			:align(display.CENTER,frame:getContentSize().width * (i * 0.21 - 0.02),frame:getContentSize().height * 0.43)
			:addTo(frame)
		
		local bg = cc.ui.UIPushButton.new({normal = "alert_exp/item_bg.png",pressed = "alert_exp/item_bg.png"})
			:onButtonPressed(function(event)
					item:setScale(0.8)
				end)
			:onButtonRelease(function(event)
					item:setScale(1.0)
				end)
			:onButtonClicked(function()
					self:onPress(i)
				end)
			:align(display.CENTER,item:getContentSize().width * 0.5,item:getContentSize().height * 0.5)
			:addTo(item)
		
		cc.ui.UILabel.new({text = self.nameTable_[i],size = 26, color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
			:align(display.CENTER,item:getContentSize().width * 0.5,item:getContentSize().height * 0.88)
			:addTo(item)
		
		local img = display.newSprite("common_ui/touicon.png")
			:scale(0.93)
			:align(display.CENTER,item:getContentSize().width * 0.5,item:getContentSize().height * 0.55)
			:addTo(item)
			
		display.newSprite("alert_exp/pic"..self.typeTable_[i]..".png")
			:align(display.CENTER,img:getContentSize().width * 0.5,img:getContentSize().height * 0.5)
			:addTo(img)
		
		display.newSprite("shop/peach_pic.png")
			:scale(0.49)
			:align(display.CENTER,item:getContentSize().width * 0.23,item:getContentSize().height * 0.18)
			:addTo(item)
			
		cc.ui.UILabel.new({text = self.priceTable_[i],size = 26, color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
			:align(display.CENTER,item:getContentSize().width * 0.57,item:getContentSize().height * 0.185)
			:addTo(item)	
	end		
	
	cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
		:onButtonClicked(function()
				self:closeCallBack_()
			end)
		:scale(0.8)
		:align(display.CENTER,frame:getContentSize().width * 0.89,frame:getContentSize().height * 0.86)
		:addTo(frame)
end

function BuyExpLayer:onPress(index)
	local layer = BuyExpLayer.new(index)
	self:addChild(layer,10)
end



----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------


--确认购买弹窗
function BuyExpLayer:confirmToBuy_(idx)
	--背景
	local bg = display.newSprite("common_ui/common_bg.png")
		:addTo(self.node)

	--文字标签
	cc.ui.UILabel.new({UILabelType = 2,text = "确定购买吗",size = 30,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
		:align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.56)
		:addTo(bg)

	--确定按钮
	cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.25)
        :onButtonClicked(function()
            self:confirmCallBack_(idx)
        end)
        :addTo(bg)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.95,bg:getContentSize().height * 0.95)
        :scale(0.9)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :addTo(bg)
end
--确定购买
function BuyExpLayer:confirmCallBack_(idx)
	if CloudData.PEACH >= self.priceTable_[idx] then
    
        local ac = AlertConnection.new(CONNECTION_BUY_EXP,idx)
        self:addChild(ac,100,12345)

        self.scheduleResult_ = self:schedule(function() 
            if not self:getChildByTag(12345) then
                self:stopAction(self.scheduleResult_)
                CloudData.EXP = CloudData.EXP + self.expTable_[idx]
                CloudData.PEACH = CloudData.PEACH - self.priceTable_[idx]

                --购买成功后关闭弹窗
                self:closeCallBack_()
            end
        end, 0.1)
    else
		local alert = AlertLackPeachLayer.new()
			self:addChild(alert, 20)
        -- todo TOAST 蟠桃不足
        --[[local toast = WSToast.new("蟠桃不足")
		self:addChild(toast, 20)--]]
		self:closeCallBack_()
    end   
end	

--弹窗关闭
function BuyExpLayer:closeCallBack_()
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
    self.node:runAction(popupLayer)
end

return BuyExpLayer
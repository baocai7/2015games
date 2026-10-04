--
--显示签到奖励
--

local ShowSignAwardLayer = class("ShowSignAwardLayer", function ()
	return display.newLayer()
end)

function ShowSignAwardLayer:ctor(content)
	--添加遮罩层
	self.mask = display.newColorLayer(cc.c4b(0,0,0,150))
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
	
	--初始化界面
	self:initData_(content)
end

function ShowSignAwardLayer:initData_(content)
	--1.已签到次数：  	self.icon_
	--2.签到奖励图标: 	self.info_	
	local type_ = content.itemType
	local itemId_ = content.itemId
	if type_ == 1 then
		self.icon_ = "sign/pantao.png"
	elseif type_ == 2 then
		self.icon_ = "sign/renshen.png"
	elseif type_ == 3 then  --经验
		self.icon_ = "sign/exp.png"
	elseif type_ == 6 then  -- 扫荡券
		self.icon_ = "sign/saodang.png"
	elseif type_ == 4 then  --神仙
		if itemId_ == 6 then
			self.icon_ = "sign/miao.png"
		else
			self.icon_ = "sign/bajie.png"
		end	
	else
		self.icon_ = "sign/item.png"
	end

	self.info_ = content.description
	
	self:init()
end
function ShowSignAwardLayer:init()
	--背景
	local bg_ = display.newSprite("sign/frame.png")
		:addTo(self.node)
	
	local iconframe = display.newSprite("sign/signk.png")
			:scale(0.9)
			:align(display.CENTER,bg_:getContentSize().width * 0.192, bg_:getContentSize().height * 0.515)
			:addTo(bg_)
		
	local icon = display.newSprite(self.icon_)
			:align(display.CENTER,iconframe:getContentSize().width * 0.5,iconframe:getContentSize().height * 0.5)
			:addTo(iconframe, -1)	
	
	cc.ui.UILabel.new({text = self.info_,size = 24,color = display.COLOR_BLACK,
			dimensions = cc.size(305,115),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg_:getContentSize().width * 0.655, bg_:getContentSize().height * 0.5)
        :addTo(bg_)	
			
	cc.ui.UIPushButton.new({normal = "sign/known.png",pressed = "sign/known_h.png"})
		:scale(0.8)
		:align(display.CENTER,bg_:getContentSize().width * 0.6,bg_:getContentSize().height * 0.35)
        :addTo(bg_)
		:onButtonClicked(function()
			self:closeCallBack_()
        end)
end

--弹窗关闭
function ShowSignAwardLayer:closeCallBack_()
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.node:runAction(popupLayer)
end

return ShowSignAwardLayer
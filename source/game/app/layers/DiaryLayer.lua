local DiarytasklevelLayer = import("layers.DiarytasklevelLayer")
local WSToast = import("utils.WSToast")

ACTIVITY_TYPE_ODD = 1
ACTIVITY_TYPE_EVEN = 2
ACTIVITY_TYPE_SUNDAY = 3

local DiaryLayer  =  class("DiaryLayer", function()
	return display.newLayer()
end)

function DiaryLayer:ctor()
	--添加遮罩层
	
	self.mask = display.newColorLayer(cc.c4b(0,0,0,150))
	self:addChild(self.mask,20)

	--初始化基础节点
	self.node = display.newNode()
	self.node:setPosition(display.cx,display.cy)
	self:addChild(self.node,20)

	--弹出效果
	self.node:setScale(0)
	local popupLayer = transition.sequence(
		{cc.ScaleTo:create(0.2, 1.1),
		cc.ScaleTo:create(0.1, 1.0)})
	self.node:runAction(popupLayer)

	--播放音效(打开层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end

	--init
	self:initData()
end

function DiaryLayer:initData()
	self.weekDay_ = CloudData.DAY_OF_WEEK
	
	self:initUI_()
end
function DiaryLayer:initUI_()
	--背景
	pBg = display.newSprite("Diary/bg.png")
	self.node:addChild(pBg)

	local pos1 = cc.p(pBg:getContentSize().width * 0.5,pBg:getContentSize().height * 0.69)
	local pos2 = cc.p(pBg:getContentSize().width * 0.5,pBg:getContentSize().height * 0.45)
	local pos3 = cc.p(pBg:getContentSize().width * 0.5,pBg:getContentSize().height * 0.2)
	local img1 = nil
	local img2 = nil
	local img3 = nil
	--加载任务列表
	if self.weekDay_ == 7 then
		img1 = "Diary/activity_sunday.png"
		img2 = "Diary/gray_odd.png"
		img3 = "Diary/gray_even.png"
		self.activityType = ACTIVITY_TYPE_SUNDAY
	elseif self.weekDay_ % 2 == 1 then
		img1 = "Diary/activity_odd.png"
		img2 = "Diary/gray_even.png"
		img3 = "Diary/gray_sunday.png"
		self.activityType = ACTIVITY_TYPE_ODD
	else
		img1 = "Diary/activity_even.png"
		img2 = "Diary/gray_odd.png"
		img3 = "Diary/gray_sunday.png"
		self.activityType = ACTIVITY_TYPE_EVEN
	end
	cc.ui.UIPushButton.new(img1)
    :onButtonClicked(function()
    	self:chooseMode_(self.activityType)
    end)
    :align(display.CENTER,pBg:getContentSize().width * 0.5,pBg:getContentSize().height * 0.69)
    :addTo(pBg)
	
	cc.ui.UIPushButton.new(img2)
    :onButtonClicked(function()
		local t = WSToast.new("活动还不到开启时间哦！", 1)
		self:addChild(t, 20)
    	--self:chooseMode_(ACTIVITY_TYPE_EVEN)
    end)
    :align(display.CENTER,pBg:getContentSize().width * 0.5,pBg:getContentSize().height * 0.45)
    :addTo(pBg)
	
	cc.ui.UIPushButton.new(img3)
    :onButtonClicked(function()
		local t = WSToast.new("活动还不到开启时间哦！", 1)
		self:addChild(t, 20)
    	--self:chooseMode_(ACTIVITY_TYPE_SUNDAY)
    end)
    :align(display.CENTER,pBg:getContentSize().width * 0.5,pBg:getContentSize().height * 0.2)
    :addTo(pBg)
	
    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
    :onButtonClicked(function()
    	self:closeCallBack_()
    end)
	:scale(0.8)
    :align(display.CENTER,pBg:getContentSize().width * 0.9,pBg:getContentSize().height * 0.89)
    :addTo(pBg)
	
end

function DiaryLayer:chooseMode_(activityType)
	GameManager.STAGE_NUM = 0
	
	local tasklevel = DiarytasklevelLayer.new(activityType)
	self:addChild(tasklevel,20)
end

--弹窗关闭
function DiaryLayer:closeCallBack_()
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

return DiaryLayer
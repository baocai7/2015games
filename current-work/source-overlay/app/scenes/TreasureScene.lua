--
--宝物界面（查看宝物相关信息）
--
local TreasurePage      = import("icons.TreasurePage")
local NoviceGuide       = import("utils.NoviceGuide")
local AlertConnection   = import("customs.AlertConnection")

local DataLabelIcon = import("icons.DataLabelIcon")

local TreasureScene = class("TreasureScene", function()
    return display.newScene("TreasureScene")
end)

function TreasureScene:ctor()
    GameManager.IS_TREASURE_PIECE_LAYER_CLOSED  = false
    
    --背景图片
    bg_ = display.newSprite("common_ui/uibg.jpg",display.cx,display.cy):addTo(self)

    --"宝物"标签
    treasureTitle_ = display.newSprite("treasure/title_treasure.png",bg_:getContentSize().width * 0.3,bg_:getContentSize().height * 0.94):addTo(bg_,15)
    
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
    self.backBtn_ = cc.ui.UIPushButton.new({normal = "common_ui/back.png",pressed = "common_ui/back_h.png"})
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
	
	local pos1 = cc.p(bg_:getContentSize().width * 0.1 ,bg_:getContentSize().height * 0.5)
	local pos2 = cc.p(bg_:getContentSize().width * 0.9 ,bg_:getContentSize().height * 0.5)
		
	self:createPageView()
	
	--向前翻页按钮
    self.left = cc.ui.UIPushButton.new("common_ui/left.png")
       -- :scale(0.8)
        :align(display.CENTER,pos1.x ,pos1.y)
        :onButtonClicked(function()
            self:gotoLastPage_()
        end)
        :addTo(bg_,15)
	self.left:runAction(cc.RepeatForever:create(transition.sequence({cc.MoveTo:create(0.7,cc.p(pos1.x + 15, pos1.y)),
		cc.MoveTo:create(0.7,pos1)})))
	if self.pv:getCurPageIdx() == 1 then
		self.left:setVisible(false)
	end
			
	--向后翻页按钮
    self.right = cc.ui.UIPushButton.new("common_ui/right.png")
       -- :scale(0.8)
        :align(display.CENTER, pos2.x, pos2.y)
        :onButtonClicked(function()
            self:gotoNextPage_()
        end)
        :addTo(bg_,15)		
	self.right:runAction(cc.RepeatForever:create(transition.sequence({cc.MoveTo:create(0.7,cc.p(pos2.x - 15, pos2.y)),
		cc.MoveTo:create(0.7,pos2)})))	
	if self.pv:getCurPageIdx() == self.pv:getPageCount() then
		self.right:setVisible(false)
	end
	
	display.newSprite("treasure/treasure_tip1.png",bg_:getContentSize().width*0.5,
			bg_:getContentSize().height *0.05)
		:addTo(bg_)
		
	--tip2

    --第一次进入宝物界面引导查看碎片信息
    if CloudData.STAGE_PROGRESS == 4 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_TREASURE1") then     --引导召唤妖怪
		local guide = NoviceGuide.new(GUIDE_STEP_TREASURE1)
		self:addChild(guide,50)
		DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_TREASURE1",true)
	end

    self.schedule_ =  self:schedule(function()
        self:updatePieceLayer_()
    end,0.1)


    for i=1,8 do
        if DataUtils.getIsTreasureEffctive(i) and not DataUtils.getIsTreasureUnlockAnimationPlayed(i) then
            self.pv:gotoPage(i, false)
            self.backBtn_:setButtonEnabled(false)
        end
    end
	
	self:addAndroidReturnButton_()
end

function TreasureScene:updatePieceLayer_()
    if GameManager.IS_TREASURE_PIECE_LAYER_CLOSED then
        GameManager.IS_TREASURE_PIECE_LAYER_CLOSED = false
        --碎片信息展示层后
        if CloudData.STAGE_PROGRESS == 4 and DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_TREASURE1") and 
        not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_TREASURE2") then     --引导召唤妖怪
			local guide = NoviceGuide.new(GUIDE_STEP_TREASURE2)
			self:addChild(guide,50)
			DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_TREASURE2",true)
		end    
    end
end

function TreasureScene:createPageView()
	self.pv = cc.ui.UIPageView.new {
        viewRect = cc.rect(80, 0, 1104, 652),
        padding = {left = 80, right = 80, top = 0, bottom = 0},
        columnSpace = 80, rowSpace = 0
		}
        :addTo(bg_)
		self.pv:onTouch(function()
			--print("***********TreasureScene:pageViewSlide_")
			self:pageViewSlide_()
		end)
		
	for i=1,8 do
        local item = self.pv:newItem()
        local content = TreasurePage.new(i)
        content:setContentSize(944, 652)
		content:setAnchorPoint(0,0)
        item:addChild(content)
        self.pv:addItem(item)        
    end
    self.pv:reload()
end

function TreasureScene:pageViewSlide_()	
	local pageNum = self.pv:getCurPageIdx()
	local sum = self.pv:getPageCount()
	print("***********pageViewSlide_began "..pageNum .. " *** "..sum)	
    if pageNum <= 1 then
		self.left:setVisible(false)
		self.pv:gotoPage(1, true)
	else
		self.left:setVisible(true)
	end
		
	if pageNum >= sum then
		self.right:setVisible(false)
		self.pv:gotoPage(sum, true)
	else
		self.right:setVisible(true)
	end	
	--[[if event == "began" then
		self.curPVPage = self.pv:getCurPageIdx()
		print("***********pageViewSlide_began"..self.curPVPage)		     
        return true
    end

    if event == "moved" then
       print("***********pageViewSlide_moved"..self.curPVPage)	
    end

    if event == "ended" then
		print("***********pageViewSlide_ended"..self.curPVPage)
		local pageNum = self.pv:getCurPageIdx()
		local sum = self.pv:getPageCount()
		if pageNum == self.curPVPage then
			return
		end
        if pageNum <= 1 then
			self.left:setVisible(false)
			self.pv:gotoPage(1)
		else
			self.left:setVisible(true)
		end
		
		if pageNum >= sum then
			self.right:setVisible(false)
			self.pv:gotoPage(sum)
		else
			self.right:setVisible(true)
		end
		
		if math.abs(self.pointBegan_.x - point_ended.x) < 10 and math.abs(self.pointBegan_.y - point_ended.y) < 10 then
			if self.stageProgress_ < self.trialRequireStage then
				local t = WSToast.new(self.trialRequireStage .. "关开启",1.0)
				self:addChild(t,100)	
			else
				local trial = TrialLayer.new(self.challengeStage)
				self:addChild(trial, 20)
			end
		end			
    end--]]
end

function TreasureScene:gotoLastPage_()
	local sum = self.pv:getPageCount()
	local cur = self.pv:getCurPageIdx()
	
	local fun1 = cc.CallFunc:create(function()
		self.left:setTouchEnabled(false)
	end)
	local fun2 = cc.CallFunc:create(function()
		self.left:setTouchEnabled(true)
	end)
	self.left:runAction(transition.sequence({fun1,cc.DelayTime:create(0.6),fun2}))
	
	if cur > 1 then
		self.pv:gotoPage(cur - 1, true)
	else
		self.pv:gotoPage(1, true)
	end
end

function TreasureScene:gotoNextPage_()
	local sum = self.pv:getPageCount()
	local cur = self.pv:getCurPageIdx()
	
	local fun1 = cc.CallFunc:create(function()
		self.right:setTouchEnabled(false)
	end)
	local fun2 = cc.CallFunc:create(function()
		self.right:setTouchEnabled(true)
	end)
	self.right:runAction(transition.sequence({fun1,cc.DelayTime:create(0.6),fun2}))
	
	if cur < sum then
		self.pv:gotoPage(cur + 1, true)
	else
		self.pv:gotoPage(sum, true)
	end
end

function TreasureScene:returnCallBack_()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
	end
	
    display.replaceScene(require("scenes.ChapterScene").new())
end

function TreasureScene:addAndroidReturnButton_()
	--退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
		btn:setKeypadEnabled(true)
        btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
            if event.key == "back" then
				self:showReturnWarning_()
			end
		end)
end

function TreasureScene:showReturnWarning_()
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

function TreasureScene:onEnter()
end

function TreasureScene:onExit()
    self:removeAllChildren()
    display.removeUnusedSpriteFrames()
end

return TreasureScene

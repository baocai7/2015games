--
--累计充值奖励界面
--
local PaymentLayer       = import("layers.PaymentLayer")

local CumulateRechargeLayer  =  class("CumulateRechargeLayer", function()
    return display.newLayer()
end)

function CumulateRechargeLayer:ctor()   
    --背景
    local bgLayer = display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1)

    --空节点
    self.node_ = display.newNode()
        :scale(0)
        :pos(display.cx, display.cy)
        :addTo(self,1)
    self.node_:setAnchorPoint(0.5, 0.5)
    
              
    local popupLayer = transition.sequence(
        {cc.ScaleTo:create(0.2, 1.1),
            cc.ScaleTo:create(0.1, 1.0)})
    self.node_:runAction(popupLayer)

    --添加空白图扩充点击区域
    self.emptyLayer = display.newColorLayer(cc.c4b(255,255,255,0)):addTo(self.node_, 1)
    self.emptyLayer:setAnchorPoint(0.5,0.5)
    self.emptyLayer:setContentSize(cc.size(display.width,display.height))

    --添加触摸事件
    self.emptyLayer:setTouchEnabled(false)
    self.emptyLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                self:TouchScreen_(event)
                return true
            end)
    self.emptyLayer:setTouchSwallowEnabled(false)

    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
    end
    
    self:initData_()    
end

function CumulateRechargeLayer:initData_()
    self.money_ = tonumber(CloudData.COST_MONEY)
    self.subscriptTable_ = {}
    if self.money_ <= 0 then
        self.num_ = 5
        self.firstNo_ = 1
    elseif self.money_ < 30 then
        self.num_ = 4
        self.firstNo_ = 2
    elseif self.money_ < 120 then
        self.num_ = 3
        self.firstNo_ = 3
    elseif self.money_ < 300 then
        self.num_ = 2
        self.firstNo_ = 4
    elseif self.money_ < 500 then
        self.num_ = 1
        self.firstNo_ = 5
    else
        self.num_ = 0  
        self.firstNo_ = 0     
    end

    self.showLimited_ = CloudData.SHOW_LIMITED_TIME_RECHARGE
    if self.showLimited_ == 1 then 
        self.typeCount_ = 6
        self.num_ = self.num_ + 1

        local time = os.time()
        print("time = " .. time)
        self.lastTime_ = CloudData.LAST_TIME_FOR_RECHARGE_ACTIVITY - time 
    else
        self.typeCount_ = 5
    end
    
    self:initUI_() 
    self:startCountDown_()
    if self.num_ > 1 then 
        self.emptyLayer:setTouchEnabled(true)   
    end
end

function CumulateRechargeLayer:initUI_()
    local bg = display.newSprite("common_ui/bg_frame.png"):addTo(self.node_)
    display.newSprite("recharge/title.png",bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.95):addTo(bg)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.96,bg:getContentSize().height * 0.92)
        :onButtonClicked(function()
            self:closeCallBack_()           
        end)
        :scale(0.65)
        :addTo(bg,2)      
    
    if self.num_ == 0 then
        return
    end
    
    self.pageView_ = cc.ui.UIPageView.new {viewRect = cc.rect(43, 84, 895, 430)}
        :addTo(bg)

    local no = 1
    if self.showLimited_ == 1 then 
        local item = self.pageView_:newItem()
        local content = display.newSprite("recharge/cumulate0.png")       
        content:setContentSize(895, 423)
        content:setAnchorPoint(0,0)
        item:addChild(content)
        item:setContentSize(895, 423)
        self.pageView_:addItem(item)
        no = 2      


        local hour   = math.floor(self.lastTime_ / 3600)
        local minutes = math.floor((self.lastTime_ - hour * 3600) / 60)
        local seconds = math.floor(self.lastTime_ - hour * 3600 - minutes * 60)

        self.limitedTimeLabel_ = cc.ui.UILabel.new({
            UILabelType = 1,text = (string.format("%02d:%02d:%02d",hour,minutes,seconds)),font = "fonts/greenNum.fnt"})
            :scale(0.6)
            :align(display.CENTER_LEFT,content:getContentSize().width * 0.61,content:getContentSize().height * 0.19)
            :addTo(content)

        self:limitedActivityCountDown_(self.lastTime_)
    end

    local pageno = self.firstNo_
    for i=no,self.num_ do
        local item = self.pageView_:newItem()
        local content = display.newSprite("recharge/cumulate" .. pageno .. ".png")       
        content:setContentSize(895, 423)
        content:setAnchorPoint(0,0)
        item:addChild(content)
        item:setContentSize(895, 423)
        self.pageView_:addItem(item) 
        pageno = pageno + 1       
    end
    self.pageView_:reload()
              
    --去充值，透明按钮
    local btn = cc.ui.UIPushButton.new("common_ui/confirm.png")
        :pos(bg:getContentSize().width * 0.73,bg:getContentSize().height * 0.22)
        :onButtonClicked(function()
            self:toCharge_()           
        end)
        :scale(1.5)
        :addTo(bg,2)
    btn:setOpacity(0)

    for i = 1, self.num_ do
        local icon = cc.ui.UIPushButton.new({normal = "notice/2.png",disabled = "notice/1.png"})
            :pos(bg:getContentSize().width * 0.5 - (self.num_ / 2 - i) * 35,bg:getContentSize().height * 0.1)
            :addTo(bg,2)
        
        self.subscriptTable_[i] = icon
    end
    self.subscriptTable_[1]:setButtonEnabled(false)

    --累计充值数量
    cc.ui.UILabel.new({
        text = "当前已累计充值：" .. (self.money_) .. "元",size = 24,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,bg:getContentSize().width * 0.05,bg:getContentSize().height * 0.1)
        :addTo(bg)

    --进度条
    cc.ui.UILabel.new({
        text = "已完成：",size = 24,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.73,bg:getContentSize().height * 0.1)
        :addTo(bg)

    local comNum = self.typeCount_ - self.num_
    local str = "0"
    if comNum > 0 then
        str = comNum .. "/" .. (self.typeCount_)
    end

    --加载进度条
    local progressFrame = display.newSprite("tasks/progress_bar11.png",bg:getContentSize().width * 0.86,bg:getContentSize().height * 0.098):addTo(bg)
    local progress = display.newProgressTimer("tasks/progress_bar12.png", display.PROGRESS_TIMER_BAR)
        :pos(progressFrame:getContentSize().width * 0.5,progressFrame:getContentSize().height * 0.5)
        :addTo(progressFrame)
    progress:setMidpoint(cc.p(0,0))
    progress:setBarChangeRate(cc.p(1,0))
    progress:setPercentage(comNum/(self.typeCount_) * 100)  

    cc.ui.UILabel.new({
        text = str,size = 24,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,progressFrame:getContentSize().width * 0.5,progressFrame:getContentSize().height * 0.5)
        :addTo(progressFrame, 5) 
end

function CumulateRechargeLayer:startCountDown_()  
    local sum = self.pageView_:getPageCount()
    if sum <= 1 then
        return
    end

    --计时轮播
    self.schedule_ = self:schedule(function()
        self:countdownOver_()
    end, 10.0) 
end

function CumulateRechargeLayer:countdownOver_()
    self.pageView_:stopAllTransition()
    local pageNum =self.pageView_:getCurPageIdx()
    local sum = self.pageView_:getPageCount()
    if pageNum < 1 then
        pageNum = 1
    elseif pageNum > sum then
        pageNum = sum
    end

    if pageNum < sum then
        self.pageView_:gotoPage(pageNum + 1, true, true)
        self:pageViewSlide_(pageNum + 1)
    else
        self.pageView_:gotoPage(1, true, true)
        self:pageViewSlide_(1)       
    end
end

function CumulateRechargeLayer:limitedActivityCountDown_(time)
    --转换时分秒
    self.hour_    = math.floor(time / 3600)
    self.minutes_ = math.floor((time - self.hour_ * 3600) / 60)
    self.seconds_ = math.floor(time - self.hour_ * 3600 - self.minutes_ * 60)

    --倒计时
    self.schedule1_ = self:schedule(function()
        self:limitedActivityUpdateTime_()
    end, 1.0)
end

function CumulateRechargeLayer:limitedActivityUpdateTime_()
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
                self:limitedActivityOver_()
            end
        end
    end

    --倒计时标签刷新
    self.limitedTimeLabel_:setString(string.format("%02d:%02d:%02d",self.hour_,self.minutes_,self.seconds_))
end

function CumulateRechargeLayer:limitedActivityOver_()
    self:stopAction(self.schedule1_)

    --CloudData.SHOW_LIMITED_TIME_RECHARGE = false
end

function CumulateRechargeLayer:TouchScreen_(event)
    if event.name == "began" then
        dump(event, "begin:")
        self:stopAction(self.schedule_)

        local x = event.x
        local y = event.y
        if x > 190 and x < 1086 and y > 135 and y < 560 then
            self.beginPos_ = cc.p(event.x, event.y)
            --self.beginPage_ =self.pageView_:getCurPageIdx()
        else
            self.beginPos_ = nil
        end             

    elseif event.name == "ended" then
        dump(event, "ended:")
        if self.beginPos_ ~= nil then 
            -- local dis = event.x - self.beginPos_.x
            -- if dis > 430 and (self.beginPos_.x) < 1000 then
            --     self:pageViewSlide_(self.beginPage_ - 1) 
            -- elseif dis < -430 then
            --     self:pageViewSlide_(self.beginPage_ + 1) 
            -- end

            self:runAction(transition.sequence({cc.DelayTime:create(0.35),cc.CallFunc:create(function()
                local num = self.pageView_:getCurPageIdx()
                print("现在是第 " .. num .. " 页")
                self:pageViewSlide_(num)                
            end)}))
        end

        self:startCountDown_()
    end
end

function CumulateRechargeLayer:pageViewSlide_(num)     
    local pageNum =num
    if num == nil then
        pageNum = math.ceil(self.pageView_:getCurPageIdx())
    end
    
    local sum = self.pageView_:getPageCount()
    if pageNum < 1 then
        pageNum = 1
    elseif pageNum > sum then
        pageNum = sum
    end

    print("***********pageViewSlide_began "..pageNum .. " *** "..sum)   
    
    for i = 1, self.num_ do
        self.subscriptTable_[i]:setButtonEnabled(true) 
    end
    self.subscriptTable_[pageNum]:setButtonEnabled(false)
end

function CumulateRechargeLayer:toCharge_() 
    local recharge = PaymentLayer.new()
        display.getRunningScene():addChild(recharge,100)

    self:removeSelf()
end

function CumulateRechargeLayer:closeCallBack_() 
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
    end

    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
    })
    self.node_:runAction(popupLayer)
end

return CumulateRechargeLayer
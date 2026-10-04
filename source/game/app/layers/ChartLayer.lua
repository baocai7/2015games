--
--排行榜界面
--
local ChartIcon = import("icons.ChartIcon")
local AlertConnection = import("customs.AlertConnection")

local ChartLayer  =  class("ChartLayer", function()
    return display.newScene("ChartLayer")
end)

function ChartLayer:ctor()   
    -- --背景
    -- display.newColorLayer(cc.c4b(0,0,0,150))
    --     :addTo(self,-1)

    -- --空节点
    -- self.node = display.newNode()
    --     --:scale(0)
    --     :pos(display.cx, display.cy)
    --     :addTo(self,1)
    -- self.node:setAnchorPoint(0.5, 0.5)

    -- local popupLayer = transition.sequence(
    --     {cc.ScaleTo:create(0.2, 1.1),
    --         cc.ScaleTo:create(0.1, 1.0)})
    --self.node:runAction(popupLayer)

    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
    end

    self:initData_()
    self:addAndroidReturnButton_()
end

function ChartLayer:initData_()
    self.name_ = CloudData.NICK_NAME
    self.level_ = 9999999 --string.format("第%d层%d波",CloudData.INFINITE_STAGE_PROGRESS,CloudData.INFINITE_WAVES_PROGRESS)
    --self.rank_ = 1000
    self.essNum_ = 0
    self.expNum_ = 0
    
    self:initUI_()
    self:toConnection_()
end

--连网获取排行榜
function ChartLayer:toConnection_()
    local ac = AlertConnection.new(CONNECTION_CHART_INFO, 1)
    self:addChild(ac, 100, 12345)

    self.scheduleResult_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
           self:stopAction(self.scheduleResult_)
           
           self.chartInfoTable_ = CloudData.CHART_TABLE
           dump(CloudData.CHART_TABLE)
           local time  = CloudData.CHART_REFRESH_INTERVAL
           print("time : "..time)
           self:startCountDown_(time)          
           self:getChartInfo_()
        end
    end,0.1)
end

function ChartLayer:startCountDown_(time)
    --转换时分秒
    self.hour_    = math.floor(time / 3600)
    self.minutes_ = math.floor((time - self.hour_ * 3600) / 60)
    self.seconds_ = math.floor(time - self.hour_ * 3600 - self.minutes_ * 60)

    --倒计时
    self.schedule_ = self:schedule(function()
        self:updateTime_()
    end, 1.0)
end

function ChartLayer:updateTime_()
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
                self:countdownOver_()
            end
        end
    end

    --倒计时标签刷新
    self.flushLabel_:setString(string.format("%02d:%02d:%02d",self.hour_,self.minutes_,self.seconds_))
end

function ChartLayer:countdownOver_()
    self:stopAction(self.schedule_)

    -- if self.listView_ ~= nil then
    --     self.listView_:removeAllChildren()
    --     self.listView_:removeSelf()    
    --     self.listView_ = nil
    -- end 
    self:toConnection_()
end

--连网成功
function ChartLayer:getChartInfo_(index)
    self.level_ = CloudData.CHART_MYRANK
    if self.level_ >= 1000000 then
        self.myrankLabel_:setString("未上榜")
    else
        self.myrankLabel_:setString(self.level_)
    end

    if self.level_ >= 1000000 then       
        self.essNum_ = 0
        self.expNum_ = 0       
    elseif self.level_ > 10000 then 
        self.essNum_ = 800
        self.expNum_ = 40000
    elseif self.level_ > 1000 then 
        self.essNum_ = 2000 - (math.floor(math.sqrt(self.level_)) * 10)
        self.expNum_ = 100000 - (math.floor(math.sqrt(self.level_)) * 500)
    elseif self.level_ > 100 then 
        self.essNum_ = 4000 - (math.floor(self.level_ / 10) * 20)
        self.expNum_ = 200000 - (math.floor(self.level_ / 10) * 1000)
    elseif self.level_ > 10 then 
        self.essNum_ = 6000 - (self.level_ * 20)
        self.expNum_ = 300000 - (self.level_ * 10)
    elseif self.level_ > 3 then 
        self.essNum_ = 8000 - (self.level_ * 200)
        self.expNum_ = 400000 - (self.level_ * 100)
    elseif self.level_ == 3 then 
        self.essNum_ = 8000
        self.expNum_ = 400000
    elseif self.level_ == 2 then 
        self.essNum_ = 9000
        self.expNum_ = 450000
    elseif self.level_ == 1 then 
        self.essNum_ = 10000
        self.expNum_ = 500000
    end
    self.essNumLabel_:setString("X" .. (self.essNum_))
    self.expNumLabel_:setString("X" .. (self.expNum_))
    
    if self.chartInfoTable_ == nil then
        return
    end
         
    self.sum_ = #self.chartInfoTable_   
    self:initList_()
        
    if self.sum_ < 50 then
        return
    end
    
    --获取排行榜第二页数据
    local ac = AlertConnection.new(CONNECTION_CHART_INFO, 2)
        self:addChild(ac, 100, 12345)
    self.scheduleResult_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)

            --table.insertto(self.chartInfoTable_, CloudData.CHART_TABLE, self.sum_ + 1)
            self.chartInfoTable_ = CloudData.CHART_TABLE
            self.sum_ = #self.chartInfoTable_
            
            if #CloudData.CHART_TABLE == 100 then
                self:getChartList3_()
            end                           
        end
    end,0.1)
end

--获取排行榜第三页数据
function ChartLayer:getChartList3_()
    local ac = AlertConnection.new(CONNECTION_CHART_INFO, 3)
        self:addChild(ac, 100, 12345)
    self.scheduleResult_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)

            self.chartInfoTable_ = CloudData.CHART_TABLE
            self.sum_ = #self.chartInfoTable_

            if #CloudData.CHART_TABLE == 150 then
                self:getChartList4_()
            end                           
        end
    end,0.1)
end

--获取排行榜第四页数据
function ChartLayer:getChartList4_()
    local ac = AlertConnection.new(CONNECTION_CHART_INFO, 4)
        self:addChild(ac, 100, 12345)
    self.scheduleResult_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)

            self.chartInfoTable_ = CloudData.CHART_TABLE
            self.sum_ = #self.chartInfoTable_                          
        end
    end,0.1)
end

function ChartLayer:initList_()
    if self.sum_ == 0 then
        return
    end
    
    if self.listView_ ~= nil then
        self.listView_:removeSelf()    
        self.listView_ = nil
    end    

    self.listView_ = cc.ui.UIListView.new {
        bgColor = cc.c4b(255,255,255,0),
        async = true,
        viewRect = cc.rect(display.cx - 510, 3, 1020, 480),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL      
    }
        --:onTouch(handler(self, self.touchListener))
        :addTo(self, 5)

    self.listView_:setDelegate(handler(self, self.sourceDelegate))

 --add items
--    for i=1, #CloudData.CHART_TABLE do
--        local item = self.listView_:newItem()       
--        local content = ChartIcon.new(i)
--        --content:setAnchorPoint(0.5, 1.0)             
--        item:addContent(content)
--        item:setItemSize(999, 121)        
--        self.listView_:addItem(item)               
--    end
    self.listView_:reload() 
end

function ChartLayer:initUI_()
    -- local bg = display.newSprite("chart/bg.png"):addTo(self.node)
    local bg = display.newSprite("chart/bg.png",display.cx,display.cy):addTo(self)

    cc.ui.UILabel.new({
        text = self.name_,size = 28,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.316,bg:getContentSize().height * 0.932)
        :addTo(bg)

    cc.ui.UILabel.new({
        text = "我的排名：",size = 28, color = cc.c3b(255,224,17), font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,bg:getContentSize().width * 0.49,bg:getContentSize().height * 0.932)
        :addTo(bg)

    self.myrankLabel_ = cc.ui.UILabel.new({
        text = self.level_,size = 28,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,bg:getContentSize().width * 0.6,bg:getContentSize().height * 0.932)
        :addTo(bg)

    cc.ui.UILabel.new({
        text = "下次刷新：",size = 28, color = cc.c3b(255,224,17), font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,bg:getContentSize().width * 0.7,bg:getContentSize().height * 0.932)
        :addTo(bg)

    self.flushLabel_ = cc.ui.UILabel.new({
        text = "00:00:00",size = 28, color = display.COLOR_GREEN, font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,bg:getContentSize().width * 0.81,bg:getContentSize().height * 0.932)
        :addTo(bg)

    --高度
    local h = 0.83
    -- 排行榜奖励提示按钮
    cc.ui.UIPushButton.new({normal = "chart/rule.png",pressed = "chart/rule1.png"})
        :onButtonClicked(function()
            self:showAwardTip_()
        end)
        :align(display.CENTER,bg:getContentSize().width * 0.316,bg:getContentSize().height * h)
        :addTo(bg,5)

    --奖励
    cc.ui.UILabel.new({
        text = "当前排名可获得奖励：",size = 20,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,bg:getContentSize().width * 0.366,bg:getContentSize().height * h)
        :addTo(bg)

    --蟠桃
    -- display.newSprite("shop/peach_pic.png")
    --     :scale(0.4)
    --     :pos(bg:getContentSize().width * 0.52,bg:getContentSize().height * h)
    --     :addTo(bg)

    -- --蟠桃数量
    -- cc.ui.UILabel.new({
    --     text = "X1000",size = 20,font = GameManager.FONTNAME_TTF})
    --     :align(display.CENTER_LEFT,bg:getContentSize().width * 0.54,bg:getContentSize().height * h)
    --     :addTo(bg)

    --精石
    display.newSprite("upgrade/essence.png")
        :scale(0.9)
        :pos(bg:getContentSize().width * 0.54,bg:getContentSize().height * h)
        :addTo(bg)

    --精石数量
    self.essNumLabel_ = cc.ui.UILabel.new({
        text = "X" .. (self.essNum_),size = 20,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,bg:getContentSize().width * 0.56,bg:getContentSize().height * h)
        :addTo(bg)

    --经验
    display.newSprite("win_or_lose/exp.png")
        :scale(0.7)
        :pos(bg:getContentSize().width * 0.65,bg:getContentSize().height * h)
        :addTo(bg)

    --经验数量
    self.expNumLabel_ = cc.ui.UILabel.new({
        text = "X" .. (self.expNum_),size = 20,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,bg:getContentSize().width * 0.685,bg:getContentSize().height * h)
        :addTo(bg)

    --返回按钮
    cc.ui.UIPushButton.new({normal = "common_ui/back.png",pressed = "common_ui/back_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.112,bg:getContentSize().height * 0.932)
        :onButtonClicked(function()
            self:closeCallBack_()           
        end)
        :scale(0.65)
        :addTo(bg,2)
end

--显示排行榜奖励规则
function ChartLayer:showAwardTip_()
    --添加遮罩层
    local awardTipLayer = display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,20)

    --添加背景图
    local bg = display.newSprite("settings/bg.png", display.cx, display.cy)
        :scale(0)
        :addTo(awardTipLayer)

    --背景弹出效果
    local popupLayer = transition.sequence({cc.ScaleTo:create(0.1, 1.1),
        cc.ScaleTo:create(0.05, 1.0)})
    bg:runAction(popupLayer)
    
    --历史排名奖励标题
    cc.ui.UILabel.new({
        text = "历史最高排名奖励规则", size = 26, color = cc.c3b(200,10,10), font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.834)
        :addTo(bg)

    --历史排名奖励规则
    local tipLabel = cc.ui.UILabel.new({
        text = "当玩家成功提升自己的历史排名到一定名次时，将获得一次性的 \n蟠桃奖励，最高排名越高，奖励越丰厚(奖励通过邮箱发放)!" ,
        size = 20,color = cc.c3b(96,22,10),align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(570,60),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.51,bg:getContentSize().height * 0.727)
        :addTo(bg)

    --每日排名奖励标题
    cc.ui.UILabel.new({
        text = "每日排名奖励规则", size = 26, color = cc.c3b(200,10,10), font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.628)
        :addTo(bg)    
    

    --local tip = "1. 首次到达或超过10000, 5000, 3000, 2000, 1000, 800, 600, 400, 200, 100, \n \t  50, 30, 20, 10, 5, 3, 2, 1名发放额外奖励。\n \n2. 每天19:00结算当前排名，发放每日排名奖励。"
    --每日排名奖励规则
    local tipLabel = cc.ui.UILabel.new({
        text = "\t \t 每天19:00结算当前排名，通过邮箱发放每日排名奖励。\n \t \t每日排行奖励大量经验和精华石，排名越高奖励越丰厚。" ,
        size = 20,color = cc.c3b(96,22,10),align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(580,60),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.535,bg:getContentSize().height * 0.521)
        :addTo(bg)

    local h = {0.405,0.287,0.168}
    for i = 1, 3 do
        --名次图标
        display.newSprite("chart/".. i .. ".png")
            :scale(0.7)
            :pos(bg:getContentSize().width * 0.31,bg:getContentSize().height * h[i])
            :addTo(bg)

        -- --蟠桃
        -- display.newSprite("shop/peach_pic.png")
        --     :scale(0.3)
        --     :pos(bg:getContentSize().width * 0.342,bg:getContentSize().height * h[i])
        --     :addTo(bg)

        -- --蟠桃数量
        -- cc.ui.UILabel.new({
        --     UILabelType = 1,text = "*1000",font = "fonts/whiteNum.fnt"})
        --     :scale(0.5)
        --     :align(display.CENTER_LEFT,bg:getContentSize().width * 0.368,bg:getContentSize().height * h[i])
        --     :addTo(bg)

        --精石
        display.newSprite("upgrade/essence.png")
            :scale(0.7)
            :pos(bg:getContentSize().width * 0.398,bg:getContentSize().height * h[i])
            :addTo(bg)

        --精石数量
        local peaNum = 11000 - (i * 1000)
        cc.ui.UILabel.new({
            UILabelType = 1,text = "*" .. peaNum,font = "fonts/whiteNum.fnt"})
            :scale(0.5)
            :align(display.CENTER_LEFT,bg:getContentSize().width * 0.429,bg:getContentSize().height * h[i])
            :addTo(bg)

        --经验
        display.newSprite("win_or_lose/exp.png")
            :scale(0.55)
            :pos(bg:getContentSize().width * 0.591,bg:getContentSize().height * h[i])
            :addTo(bg)

        --经验数量
        local expNum = 550000 - (i * 50000)
        cc.ui.UILabel.new({
            UILabelType = 1,text = "*" .. expNum,font = "fonts/whiteNum.fnt"})
            :scale(0.5)
            :align(display.CENTER_LEFT,bg:getContentSize().width * 0.641,bg:getContentSize().height * h[i])
            :addTo(bg)
    end

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.7)
        :align(display.CENTER,bg:getContentSize().width * 0.96,bg:getContentSize().height * 0.94)
        :onButtonClicked(function()
            awardTipLayer:removeSelf()
        end)
        :addTo(bg)   
end

function ChartLayer:sourceDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
        return self.sum_
    elseif cc.ui.UIListView.CELL_TAG == tag then
        local item
        local content

        item = self.listView_:dequeueItem()
        if not item then
            item = self.listView_:newItem()
            content = ChartIcon.new(idx)
            item:addContent(content)
        else
            content = item:getContent()
            content:showInfo_(idx)
        end
        --content:showInfo_(idx)
        item:setItemSize(997, 108)
        return item
    else
    end
end

function ChartLayer:closeCallBack_()   
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
    end

    -- local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
    --     cc.ScaleTo:create(0.1,1.1),
    --     cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
    --         self:removeSelf()
    --     end)
    -- })
    -- --self.node:runAction(popupLayer)
    -- self:removeSelf()
    
    display.replaceScene(require("scenes.InfiniteModeEntrance").new())


end

function ChartLayer:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
        btn:setKeypadEnabled(true)
        btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
            if event.key == "back" then
                self:showReturnWarning_()
            end
        end)
end

function ChartLayer:showReturnWarning_()
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

function ChartLayer:onEnter()
end

function ChartLayer:onExit()
    self:removeAllChildren()
    display.removeUnusedSpriteFrames()
end

return ChartLayer
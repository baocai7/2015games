--
--公告界面
--
local AlertConnection = import("customs.AlertConnection")
local ActivityStageLayer = import("layers.ActivityStageLayer")

local NoticeLayer  =  class("NoticeLayer", function()
    return display.newLayer()
end)

function NoticeLayer:ctor()   
    --背景
    --display.newColorLayer(cc.c4b(0,0,0,150))
    --    :addTo(self,-1)

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

    --音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
    end
    
    --联网加载数据
    local ac = AlertConnection.new(CONNECTION_NOTICE)
    self:addChild(ac,100,12345)

    self.scheduleCH_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleCH_)
            
        --    dump(CloudData.NOTICE_INFO,"notice info : ")            
            self:initData_()
            --local notice = NoticeLayer.new()
            --self:addChild(notice,20)
        end
    end,0.1)       
end

function NoticeLayer:initData_()
    self.Switch_ = GameManager.SHOW_NOTICE

    self.info_ = CloudData.NOTICE_INFO
    if self.info_ == nil then
        print("无公告")
        CloudData.NOTICE_SHOWED = true     
        self:closeCallBack_()
        return                        
    end

    self.num_ = #self.info_
    

    if self.num_ <= 0 and not CloudData.NOTICE_SHOWED then
        print("无公告")
        CloudData.NOTICE_SHOWED = true     
        self:closeCallBack_()
        return                        
    end

    self.subscriptTable_ = {}

    if CloudData.NOTICE_SHOWED then
        print("公告已显示过")
        self:loadRes()                           
    else
        print("公告未显示过")       
        local y = os.date("20%y")
        local m = os.date("%m")
        local d = os.date("%d")
        local date = tonumber(y * 10000 + m * 100 + d)
        CloudData.CUR_DATE = tonumber(cc.UserDefault:getInstance():getStringForKey("cur_date",tostring(20150401)))

        if CloudData.CUR_DATE ~= date then
            CloudData.CUR_DATE = date
            GameManager.SHOW_NOTICE = true
            self.Switch_ = GameManager.SHOW_NOTICE
            cc.UserDefault:getInstance():setBoolForKey("user_notice_switch", true)
            cc.UserDefault:getInstance():setStringForKey("cur_date",tostring(date))                 
        end 

        if GameManager.SHOW_NOTICE then
            self:loadRes()                            
        else          
            self:closeCallBack_()        
        end     
    end
    CloudData.NOTICE_SHOWED = true
end

--判断资源
function NoticeLayer:loadRes() 
    self.loadResNum = 0
    local cachePath = DYUtils.getCachePath() .. "notice/"
    self:createDownPath(cachePath)    
       
    for i=1, self.num_ do
        if self.info_[i].msg == nil or self.info_[i].msg == "" then
            local cacheImg = cachePath .. (self.info_[i].id) .. ".png"
            file,err = io.open(cacheImg)
            if file == nil then                
                self:getNoticeImg(self.info_[i].picUrl, self.info_[i].id, cachePath)
            else 
                self.loadResNum = self.loadResNum + 1
            end
        else
            self.loadResNum = self.loadResNum + 1
        end                     
    end  

    if self.loadResNum == self.num_ then 
        self:initUI_()
    end
end

function NoticeLayer:startCountDown_()  
    local sum = self.num_
    if sum <= 1 then
        return
    end

    --计时轮播
    self.schedule_ = self:schedule(function()
        self:countdownOver_()
    end, 10.0) 
end

function NoticeLayer:countdownOver_()
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

function NoticeLayer:initUI_()
    dump(self.info_)

    display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1)

    self.mBg = display.newSprite("common_ui/bg_frame.png"):addTo(self.node_)
    display.newSprite("notice/title.png",self.mBg:getContentSize().width * 0.5,self.mBg:getContentSize().height * 0.95):addTo(self.mBg)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,self.mBg:getContentSize().width * 0.96,self.mBg:getContentSize().height * 0.92)
        :onButtonClicked(function()
            self:closeCallBack_()           
        end)
        :scale(0.65)
        :addTo(self.mBg,2) 

    --透明按钮（当日显示公告单选框）
    local btn = cc.ui.UIPushButton.new("common_ui/confirm.png")
        :pos(self.mBg:getContentSize().width * 0.11,self.mBg:getContentSize().height * 0.09)
        :onButtonClicked(function()
            self:clickSwitch_()           
        end)
        --:scale(0.65)
        :addTo(self.mBg,3)
    btn:setOpacity(0)

    local ss =  display.newSprite("notice/switch.png")
        :pos(self.mBg:getContentSize().width * 0.053,self.mBg:getContentSize().height * 0.093)
        :addTo(self.mBg, 4)

        ss:setAnchorPoint(0, 0.5)

    self.swiBtn_ =  display.newSprite("notice/tick.png")
        :pos(self.mBg:getContentSize().width * 0.07,self.mBg:getContentSize().height * 0.093)
        :addTo(self.mBg, 4)

    if self.Switch_ then
        self.swiBtn_:setVisible(false)
    else
        self.swiBtn_:setVisible(true)
    end

    if self.num_ == 0 then
        return 
    end

    
    self.titleLabel = cc.ui.UILabel.new({
        text = self.info_[1].title ,size = 24,color = cc.c3b(255,249,11),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.mBg:getContentSize().width * 0.06,self.mBg:getContentSize().height * 0.88)
        :addTo(self.mBg)
    
    local str = (self.info_[1].startTime) .. " - " .. (self.info_[1].endTime)  
    self.timeLabel = cc.ui.UILabel.new({
        text = str ,size = 22,color = display.COLOR_GREEN,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_RIGHT,self.mBg:getContentSize().width * 0.91,self.mBg:getContentSize().height * 0.88)
        :addTo(self.mBg)        
    
    self.pageView_ = cc.ui.UIPageView.new {
        viewRect = cc.rect(44, 88, 895, 423),
        padding = {left = 438, right = 170, top = 0, bottom = 210},
        columnSpace = 30, rowSpace = 0
    }
    :addTo(self.mBg)
    -- self.pageView_:onTouch(function()
    --     --print("***********TreasureScene:pageViewSlide_")
    --     self:pageViewSlide_()
    -- end)

    for i=1,self.num_ do
        local item = self.pageView_:newItem()
        local content 

        if self.info_[i].msg == nil or self.info_[i].msg == "" then
            local cachePath = DYUtils.getCachePath() .. "notice/"
            local cacheImg = cachePath .. (self.info_[i].id) .. ".png"
            content = display.newSprite(cacheImg)
            content:setContentSize(895, 423)           
        else
            content = cc.ui.UILabel.new({text = self.info_[i].msg,size = 22,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(800,385),font = GameManager.FONTNAME_TTF})                              
            content:setContentSize(800, 400)
        end        
        content:setAnchorPoint(0.5,0.5)
        item:addChild(content)
        self.pageView_:addItem(item)        
    end
    self.pageView_:reload()
        
    for i = 1, self.num_ do
        local icon = cc.ui.UIPushButton.new({normal = "notice/2.png",disabled = "notice/1.png"})
            :pos(self.mBg:getContentSize().width * 0.5 - (self.num_ / 2 - i) * 35,self.mBg:getContentSize().height * 0.17)
            :addTo(self.mBg,2)
        
        self.subscriptTable_[i] = icon
    end
    self.subscriptTable_[1]:setButtonEnabled(false)

    if self.num_ > 1 then
        self:startCountDown_()
        self.emptyLayer:setTouchEnabled(true)
    end          
end

--检查本地图片是否存在
function NoticeLayer:getNoticeImg( msgUrl, msgId, cachePath )
    local function onError(errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            print("no image")
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            print("network error")
        end
    end         

    local function onSuccess()  
        self.loadResNum = self.loadResNum + 1
        if self.loadResNum == self.num_ then 
            self:initUI_()
        end           
        if nil ~= self.assetsManager then 
            print("释放assetsManager")
            self.assetsManager:release()
            self.assetsManager = nil               
        end          
    end
    
    self.assetsManager = cc.AssetsManager:new(msgUrl, GameManager.GET_TIME_SECOND_URL, cachePath)
    self.assetsManager:retain()
    self.assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
    self.assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
    self.assetsManager:setConnectionTimeout(3)
    
    if self.assetsManager:checkUpdate() then
        self.assetsManager:update()
    end  
end

function NoticeLayer:createDownPath( path )
    if not self:checkDirOK(path) then
        print("缓存目录创建失败")
        return
    else
        print("缓存目录存在或创建成功")
    end
end
--
function NoticeLayer:checkDirOK( path )
    require "lfs"
    local oldpath = lfs.currentdir()
    if lfs.chdir(path) then
        lfs.chdir(oldpath)
        return true
    end
    if lfs.mkdir(path) then
        return true
    end
end

function NoticeLayer:TouchScreen_(event)
    if event.name == "began" then
        dump(event, "begin:")
        self:stopAction(self.schedule_)

        local x = event.x
        local y = event.y
        if x > 190 and x < 1086 and y > 135 and y < 560 then
            self.beginPos_ = cc.p(event.x, event.y)
            --self.beginPage_ = self.pageView_:getCurPageIdx()
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

function NoticeLayer:pageViewSlide_(num) 
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
    
    self.titleLabel:setString(self.info_[pageNum].title)
    local str = string.format((self.info_[pageNum].startTime) .. " - " .. (self.info_[pageNum].endTime))    
    self.timeLabel:setString(str)
    
    for i = 1, self.num_ do
        self.subscriptTable_[i]:setButtonEnabled(true)
    end
    self.subscriptTable_[pageNum]:setButtonEnabled(false) 
end

function NoticeLayer:clickSwitch_()  
    self.Switch_ = not self.Switch_
    GameManager.SHOW_NOTICE = self.Switch_

    -- 数据保存到设备
    cc.UserDefault:getInstance():setBoolForKey("user_notice_switch",self.Switch_)

    if self.Switch_ then
        self.swiBtn_:setVisible(false)
    else
        self.swiBtn_:setVisible(true)
    end
end

function NoticeLayer:closeCallBack_()          
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

return NoticeLayer
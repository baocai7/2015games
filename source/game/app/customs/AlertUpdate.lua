
local CompatTrace = import("utils.CompatTrace")

local AlertUpdate = class("AlertUpdate", function()
    return display.newLayer()
end)

function AlertUpdate:ctor( url, filesize, isForce, isPreVersion, reachedVersion )

    CompatTrace.log("update", string.format("dialog url=%s size=%s force=%s pre=%s reached=%s",
        tostring(url), tostring(filesize), tostring(isForce), tostring(isPreVersion), tostring(reachedVersion)))

    self.url_ = url
    self.isPreVersion_ = isPreVersion
    self.reachedVersion_ = reachedVersion
    
    --添加遮罩层
    display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

    --初始化基础节点
    self.nodeThis_ = display.newNode()
    self.nodeThis_:setPosition(display.cx,display.cy)
    self:addChild(self.nodeThis_)

    --弹出效果
    self.nodeThis_:setScale(0)
    local popupSeq = transition.sequence({cc.ScaleTo:create(0.2, 1.1),
        cc.ScaleTo:create(0.1, 1.0)})
    self.nodeThis_:runAction(popupSeq)

    --init
    self:init( filesize, isForce )
end

function AlertUpdate:init( filesize, isForce )
    --背景
    self.bg_ = display.newSprite("update/bg.png")
    self.nodeThis_:addChild(self.bg_)
    
    --label 1
    cc.ui.UILabel.new({text = "有最新的更新包可供下载，", size = 28,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER, self.bg_:getContentSize().width/2, self.bg_:getContentSize().height * 0.62)
        :addTo(self.bg_)
        
    --label 2
    cc.ui.UILabel.new({text = "大小", size = 28,font = GameManager.FONTNAME_TTF})
        :align(display.LEFT_CENTER , self.bg_:getContentSize().width * 0.1, self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_)
        
    --label 3
    cc.ui.UILabel.new({text = string.format("%.2fM",filesize), size = 28, color = display.COLOR_GREEN,font = GameManager.FONTNAME_TTF})
        :align(display.LEFT_CENTER , self.bg_:getContentSize().width * 0.22, self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_) 
        
    --label 4
    cc.ui.UILabel.new({text = "建议使用WIFI环境下载", size = 28,font = GameManager.FONTNAME_TTF})
        :align(display.LEFT_CENTER , self.bg_:getContentSize().width * 0.4, self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_)

    -- 必须现在更新的，不显示下次再说
    local offset = 1
    
    if isForce ~= "FORCE" then
        -- 下次再说
        local nextTime = cc.ui.UIPushButton.new({normal = "update/next_time.png",pressed = "update/next_time1.png"})
            :onButtonClicked(function()
                self:closeDialog()
            end)
            :align(display.CENTER,self.bg_:getContentSize().width * 0.75,self.bg_:getContentSize().height * 0.2)
            :addTo(self.bg_,2)
    else
        offset = 2
    end

    
    -- 现在更新
    local rightNow = cc.ui.UIPushButton.new({normal = "update/right_now.png",pressed = "update/right_now1.png"})
        :onButtonClicked(function()
            self:startDownload()
        end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.25 * offset,self.bg_:getContentSize().height * 0.2)
        :addTo(self.bg_,2)
        
end


--
function AlertUpdate:startDownload()

    --DataEye统计
    -- if USE_DATAEYE and CHANNEL ~= 2 then DCEvent.onEvent("start_download") end
    -- --AnySdk内嵌统计接口
    -- if USE_DATAEYE and CHANNEL == 2 then analytics_plugin:logEvent("start_download") end

    self.bg_:setVisible(false)
    
    --背景
    local bg = display.newSprite("update/download.png")
    self.nodeThis_:addChild(bg)
    
    -- label
    self.label_ = cc.ui.UILabel.new({text = string.format("%d％",0), size = 28,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER , bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.75)
        :addTo(bg)
    
    -- bar bg
    local barBg = display.newSprite("update/bar_bg.png",bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.33)
    bg:addChild(barBg)
    
    --加载cd条
    self.progress_ = display.newProgressTimer("update/bar.png", display.PROGRESS_TIMER_BAR)
    self.progress_:setPosition(barBg:getContentSize().width * 0.5,barBg:getContentSize().height * 0.5)
    barBg:addChild(self.progress_)
    self.progress_:setMidpoint(cc.p(0,0))
    self.progress_:setBarChangeRate(cc.p(1,0))
    self.progress_:setPercentage(0)

    self:assetsManager()
end


--
function AlertUpdate:assetsManager()

    local function onError(errorCode)
        CompatTrace.log("update", string.format("assets error code=%s url=%s timeUrl=%s",
            tostring(errorCode), tostring(self.url_), "http://125.88.152.28/dbxy/0.html"))
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            print("no new version")
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            print("network error")
        end
    end

    local function onProgress( percent )
        CompatTrace.log("update", string.format("assets progress=%s url=%s", tostring(percent), tostring(self.url_)))
        print("downloading %d ％",percent)
        self.label_:setString(string.format("%d％",percent))
        self.progress_:runAction(cc.ProgressTo:create(0,percent))
    end

    local function onSuccess()
        CompatTrace.log("update", "assets success url=" .. tostring(self.url_))
        if self.isPreVersion_ then
            cc.UserDefault:getInstance():setBoolForKey("missed_armature_res_downloaded", true)
            GameManager.IS_ARMATURE_DOWNLOADED = true
        end
        
        if nil ~= self.reachedVersion_ then
            cc.UserDefault:getInstance():setStringForKey("v", self.reachedVersion_)
        end
        
        print("downloading ok")
        self.label_:setString(string.format("更新完成"))

        if nil ~= self.assetsManager then
            print("释放assetsManager")
            self.assetsManager:release()
            self.assetsManager = nil
        end
        
        self:performWithDelay(function()
            self:closeDialog()
        end, 1.0)
    end
    
    --将  assetsManager 内部版本号制空
    cc.UserDefault:getInstance():setStringForKey("current-version-codezd","")
    self.assetsManager = cc.AssetsManager:new(self.url_, "http://125.88.152.28/dbxy/0.html", GameManager.PATH_DLC)
    CompatTrace.log("update", string.format("assets check start url=%s versionUrl=%s cache=%s",
        tostring(self.url_), "http://125.88.152.28/dbxy/0.html", tostring(GameManager.PATH_DLC)))
    self.assetsManager:retain()
    self.assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
    self.assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
    self.assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
    self.assetsManager:setConnectionTimeout(3)
    
    if self.assetsManager:checkUpdate() then
        self.assetsManager:update()
    end
end




function AlertUpdate:closeDialog()

    local closeSeq = transition.sequence({
        cc.ScaleTo:create(0.1, 1.1),
        cc.ScaleTo:create(0.2, 0.0),
        cc.CallFunc:create(function()
            self:removeSelf()
        end),
    })
    self.nodeThis_:runAction(closeSeq)
end


return AlertUpdate

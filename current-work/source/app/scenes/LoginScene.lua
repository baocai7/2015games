
Game = {}

local AlertUpdate         = import("customs.AlertUpdate")
local AlertConnection     = import("customs.AlertConnection")
local WSToast             = import("utils.WSToast")
local ServerMaintainLayer = import("layers.ServerMaintainLayer")
local ForceUpdateLayer    = import("layers.ForceUpdateLayer")
local SetAccountLayer     = import("layers.SetAccountLayer")
local ServersBtn          = import("icons.ServersBtn")
local ServerMaintainLayer = import("layers.ServerMaintainLayer")

-- 服务器是否正在维护
local IS_SERVER_IN_MAINTAINING = false      

local LoginScene = {}
LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

-- ios、Android的logo不同
if device.platform == "ios" or device.platform == "mac" then   
    LOGO_PATH = "common/logo_ios.png"
else
    LOGO_PATH = "common/logo.png"
end

function LoginScene:ctor()
    -- 小渠道标识
    self.m_isSmallChannel = false
    
    if GameManager.MUSIC_SWITCH_ON then
        audio.playMusic(string.format("sounds/bgm_theme_night.%s",GameManager.POSTFIX))
    end

    GameManager.IS_LITE_VERSION = LITE   -- 当前版本是否为精简版的标识
    
    PaymentInfo.CHANNEL = CHANNEL        -- 0:缺省值；2：AnySdk；3：KuGou；4：UC；5：各小渠道 ； 6:腾讯；其他：短代运营商渠道 10086 10010 10000
    
    if PaymentInfo.CHANNEL == 0 or PaymentInfo.CHANNEL == 5 or PaymentInfo.CHANNEL == 10086 or PaymentInfo.CHANNEL == 10010 or PaymentInfo.CHANNEL == 10000 then
        self.m_isSmallChannel = true
    end

    --bg
    display.newSprite("login_scene/login_bg.jpg",display.cx,display.cy):addTo(self)
    --logo
    display.newSprite(LOGO_PATH,display.cx,display.height * 0.8):addTo(self,2)
   
    -- 版本号
    self.m_visionLabel = cc.ui.UILabel.new({text = "", size = 24, font = "res/fonts/DFYuanW7-GB2312.ttf", color = cc.c3b(248, 234, 8) })
        :align(display.CENTER, display.width * 0.1, display.height * 0.1)
        :addTo(self,2)

    -- button LOGIN(开始游戏按钮，默认不可见)
    self.buttonStart_ = cc.ui.UIPushButton.new({normal = "login_scene/start_long.png",pressed = "login_scene/start_long1.png"})
        :align(display.CENTER,display.width * 0.5,display.height * 0.12)
        :addTo(self,1)
        :onButtonClicked(handler(self,self.startCallBack))
    self.buttonStart_:setVisible(false)

    -- 用户中心（用于没有账号系统的平台）
    self.m_userCenterBtn = cc.ui.UIPushButton.new({normal = "settings/user_center.png",pressed = "settings/user_center1.png"})
        :align(display.CENTER,display.width * 0.9,display.height * 0.12)
        :addTo(self,1)
        :onButtonClicked(handler(self,self.setCallBack))
    self.m_userCenterBtn:setVisible(false)
    
    -- android返回键
    self:addAndroidReturnButton_()

    -- ios端判断酷狗用户是否已登录,用于切换账号时条件判断
    if device.platform == "ios" then
        cc.UserDefault:getInstance():setBoolForKey("isUserLogin",false)
    end

    -- 腾讯登陆
    if 6 == PaymentInfo.CHANNEL then
        --区分是QQ还是微信登录，以便开始游戏回调去请求正确的接口
        self.isQQ_ = 1

        -- 微信登陆按钮
        self.weChatBtn_ = cc.ui.UIPushButton.new({normal = "login_scene/login_wechat.png",pressed = "login_scene/login_wechat1.png"})
            :align(display.CENTER,display.width * 0.35,display.height * 0.2)
            :hide()
            :addTo(self,1)
            :onButtonClicked(handler(self,self.weChatCallBack_))

        -- QQ登陆按钮
        self.qqLoginBtn_ = cc.ui.UIPushButton.new({normal = "login_scene/login_qq.png",pressed = "login_scene/login_qq1.png"})
            :align(display.CENTER,display.width * 0.65,display.height * 0.2)
            :hide()
            :addTo(self,1)
            :onButtonClicked(handler(self,self.qqLoginCallBack_))
    end
    
    -- 没有账号系统的平台，提供用户中心按钮，用于绑定账号，切换账号
    if device.platform == "android" and self.m_isSmallChannel then
        self.m_userCenterBtn:setVisible(true)
    end

    -- 连接消息服务器
    -- self:connectToMsg()

    -- 检查新版本
    self:getNewestVersion()

    -- 检查用户手机运营商信息
    self:getOperatorInfo()

end

function LoginScene:setCallBack()
    local lastUser = cc.UserDefault:getInstance():getStringForKey("userName","")
    print("lastUser = " .. lastUser)

    local account = SetAccountLayer.new()
    self:addChild(account,20)
end

function LoginScene:connectToMsg()   
    
    local connectionType = nil
    if device.platform == "android" and PaymentInfo.CHANNEL == 6 then
        connectionType = CONNECTION_SERVER_MAINTAIN_QQ
    elseif device.platform == "ios" then
        connectionType = CONNECTION_SERVER_MAINTAIN_IOS
    else 
        connectionType = CONNECTION_SERVER_MAINTAIN_ANDROID
    end

    local ac = AlertConnection.new(connectionType)
    self:addChild(ac,100,12345)

    self.schedule_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.schedule_)

            print("*****Server***MSG**********")
    
            -- 若没有消息则返回
            if CloudData.SERVER_MSG.data == nil then
                return
            end
            
            -- 消息弹窗
            local msg = ServerMaintainLayer.new(2)
            self:addChild(msg,20)
            
            -- 服务器正在维护。。。
            IS_SERVER_IN_MAINTAINING = true
        end
    end,0.1)
end

--获取手机运营商信息
function LoginScene:getOperatorInfo()
    if device.platform == "windows" or device.platform == "mac" or device.platform == "ios" then 
        return 
    end

    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "getOperatorInfo"
    local javaParams = {
        function(event)
            print("PaymentInfo.OPERATOR : " .. event)
            PaymentInfo.OPERATOR = tonumber(event)
        end
    }
    local javaMethodSig = "(I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end

-------------------------
--initKuGou SDK (IOS版)--
-------------------------
function LoginScene:initKugouSdkIOS()
    -- 酷狗SDK登录 luaOC桥接
    luaoc.callStaticMethod("RootViewController", "KGLogin",{})

    -- 查询登录状态
    self.schedule_ = self:schedule(function()
        -- 开始登录
        local function callback(event)
            print("event = "..event)
            if event == "" then
                print("not ready!")
            elseif event == "SDK_LOGIN_FAIED" then
                print("SDK_LOGIN_FAIED")
                self:stopAction(self.schedule_)
            else
                -- 酷狗SDK登录成功
                print("酷狗SDK登录成功")
                
                -- ios端判断酷狗用户是否已登录,用于切换账号时条件判断
                cc.UserDefault:getInstance():setBoolForKey("isUserLogin",true)
            
                self:stopAction(self.schedule_)
                self.kugouDataTable_ = split(event,",")
                
                --
                self:kugouLoginIOS(self.kugouDataTable_)
            end
        end
        luaoc.callStaticMethod("RootViewController", "checkLoginStatus",{listener = callback})
    end, 0.2)
end
function LoginScene:kugouLoginIOS(kugouDataTable)
    local unixTime = kugouDataTable[1]
    local userName = kugouDataTable[2]
    local token = kugouDataTable[3]

    -- 获取到unixTime 和酷狗的 userName 之后请求游戏服务器登录
    local ac = AlertConnection.new(CONNECTION_LOGIN_KUGOU,unixTime,userName,token)
    self:addChild(ac,100,12345)

    self.scheduleKGLoginIOS_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleKGLoginIOS_)
            
            -- 发送登录统计
            luaoc.callStaticMethod("RootViewController", "enterGameForSDK",{})
            
            -- 加载服务器相关UI
            self:performWithDelay(function ()
                self.server_ = ServersBtn.new(handler(self, self.onEventServerBtn))
                self.server_:setPosition(display.width * 0.5,display.height * 0.28)
                self:addChild(self.server_, 2)
                
                -- 开始按钮
                self.buttonStart_:setVisible(true)
            end, 0.5)
        end
    end,0.1)
end

-- init kugou sdk
function LoginScene:initKugouSdk()
    --酷狗SDK登录 luaJ桥接
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "loginKugouSDK"
    local javaParams = {}
    local javaMethodSig = "()V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    -- 查询登录状态
    self.schedule_ = self:schedule(function()
        -- 开始登录
        local javaClassName = "org/cocos2dx/lua/AppActivity"
        local javaMethodName = "checkKugouSDKLoginStatus"
        local javaParams = {
            function(event)
                print("event : " .. event)
                if event == "notReady" then
                    print("notReady")
                else
                    --酷狗SDK登录成功
                    self:stopAction(self.schedule_)
                    --local table = string.split(event,",")
                    self.kugouDataTable_ = split(event,",")
                    
                    -- 显示登陆信息
                    self:kugouLogin(self.kugouDataTable_)
                end
            end
        }
        local javaMethodSig = "(I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end, 0.2)

end
-- kugou login
function LoginScene:kugouLogin( kugouDataTable )
    local unixTime = kugouDataTable[1]
    local userName = kugouDataTable[2]
    local token = kugouDataTable[3]

    --获取到unixTime 和酷狗的 userName 之后请求游戏服务器登录
    local ac = AlertConnection.new(CONNECTION_LOGIN_KUGOU,unixTime,userName,token)
    self:addChild(ac,100,12345)

    self.schedule1_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.schedule1_)

            -- 发送登录统计
            local javaClassName = "org/cocos2dx/lua/AppActivity"
            local javaMethodName = "sendEnterGameStatics"
            local javaParams = {}
            local javaMethodSig = "()V"
            luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

            -- 显示欢迎信息
            local javaClassName = "org/cocos2dx/lua/AppActivity"
            local javaMethodName = "showWelcome"
            local javaParams = {}
            local javaMethodSig = "()V"
            luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

            -- 显示浮动工具栏
            local javaClassName = "org/cocos2dx/lua/AppActivity"
            local javaMethodName = "showToolbar"
            local javaParams = {}
            local javaMethodSig = "()V"
            luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            
            -- 加载服务器相关UI（此处做0.5s延迟，防止OpenGL(0x0502)渲染错误）
            self:performWithDelay(function ()
                self.server_ = ServersBtn.new(handler(self, self.onEventServerBtn))
                self.server_:setPosition(display.width * 0.5,display.height * 0.28)
                self:addChild(self.server_, 2)
                
                -- 开始按钮
                self.buttonStart_:setVisible(true)
            end, 0.5)
        end
    end,0.1)
end

-------------------------
--------腾讯登陆---------
-------------------------
function LoginScene:weChatCallBack_()
    -- Ray todo:
    print("====== WeChat Login ======")

    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "checkIfWechatInstalled"
    local javaParams = {
        function(event)
            print("event : " .. event)
            if event == "false" then
                print("wechat not installed")
                local toast = WSToast.new("微信未安装")
                self:addChild(toast,200)
            else
                self:continueWechatLogin()
            end
        end
    }
    local javaMethodSig = "(I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end

function LoginScene:continueWechatLogin()

    local toast = WSToast.new("正在登录，请稍等。")
    self:addChild(toast,200)

    self.isQQ_ = 0

    local function tFuncStatusListener(status)
        local ts = split(status,";")
        local state = ts[1]
        local param = ts[2] or ""
        
        if state == "THIRD_LOGIN_SUCC" then
            self.qqDataTable_ = split(param,",")
            --存储腾讯用户登录身份 1 QQ 2 WECHAT
            cc.UserDefault:getInstance():setStringForKey("tencentUser","2")

            -- 登陆成功获取服务器信息
            self:getTencentServerInfo()

            -- 隐藏按钮
            self.weChatBtn_:setVisible(false)
            self.qqLoginBtn_:setVisible(false)
            
        elseif state == "THIRD_LOGIN_CANCEL" then
            -- 取消登录时重现微信和QQ登录的按钮
            self.weChatBtn_:setVisible(true)
            self.qqLoginBtn_:setVisible(true)
            
        elseif state == "THIRD_LOGIN_FAIL" then
        
        end
    end

    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "loginMSDK"
    local javaParams = {2,tFuncStatusListener}
    local javaMethodSig = "(II)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

    -- -- 查询登录状态
    -- self.scheduleQQ_ = self:schedule(function()
    --     -- 开始登录
    --     local javaClassName = "org/cocos2dx/lua/AppActivity"
    --     local javaMethodName = "checkLoginStatus"
    --     local javaParams = {
    --         function(event)
    --             print("event : " .. event)
    --             if event == "not ready" then
    --                 print("not ready")
    --             else
    --                 --微信SDK登录成功
    --                 self:stopAction(self.scheduleQQ_)
    --                 self.qqDataTable_ = split(event,",")

    --                 --存储腾讯用户登录身份 1 QQ 2 WECHAT
    --                 cc.UserDefault:getInstance():setStringForKey("tencentUser","2")
                    
    --                 -- 登陆成功获取服务器信息
    --                 self:getTencentServerInfo()
                    
    --                 -- 隐藏按钮
    --                 self.weChatBtn_:setVisible(false)
    --                 self.qqLoginBtn_:setVisible(false)
    --             end
    --         end
    --     }
    --     local javaMethodSig = "(I)V"
    --     luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    -- end, 0.2)
end

function LoginScene:qqLoginCallBack_()
    -- Ray todo:
    print("====== QQ Login ======")
    local toast = WSToast.new("正在登录，请稍等。")
    self:addChild(toast,200)

    self.isQQ_ = 1
    
    local function tFuncStatusListener(status)
        local ts = split(status,";")
        local state = ts[1]
        local param = ts[2] or ""

        if state == "THIRD_LOGIN_SUCC" then
            self.qqDataTable_ = split(param,",")
            --存储腾讯用户登录身份 1 QQ 2 WECHAT
            cc.UserDefault:getInstance():setStringForKey("tencentUser","1")

            -- 登陆成功获取服务器信息
            self:getTencentServerInfo()

            -- 隐藏按钮
            self.weChatBtn_:setVisible(false)
            self.qqLoginBtn_:setVisible(false)
            
        elseif state == "THIRD_LOGIN_CANCEL" then
            -- 取消登录时重现微信和QQ登录的按钮
            self.weChatBtn_:setVisible(true)
            self.qqLoginBtn_:setVisible(true)
            
        elseif state == "THIRD_LOGIN_FAIL" then
        
        end
    end
    
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "loginMSDK"
    local javaParams = {1,tFuncStatusListener}
    local javaMethodSig = "(II)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

--    -- 查询登录状态
--    self.scheduleQQ_ = self:schedule(function()
--        -- 开始登录
--        local javaClassName = "org/cocos2dx/lua/AppActivity"
--        local javaMethodName = "checkLoginStatus"
--        local javaParams = {
--            function(event)
--                print("event : " .. event)
--                if event == "not ready" then
--                    print("not ready")
--                else
--                    --手Q SDK登录成功
--                    self:stopAction(self.scheduleQQ_)
--                    self.qqDataTable_ = split(event,",")
--
--                    --存储腾讯用户登录身份 1 QQ 2 WECHAT
--                    cc.UserDefault:getInstance():setStringForKey("tencentUser","1")
--                    
--                    -- 登陆成功获取服务器信息
--                    self:getTencentServerInfo()
--                    
--                    -- 隐藏按钮
--                    self.weChatBtn_:setVisible(false)
--                    self.qqLoginBtn_:setVisible(false)
--                end
--            end
--        }
--        local javaMethodSig = "(I)V"
--        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
--    end, 0.2)
end

-- 腾讯登陆成功获取服务器信息
function LoginScene:getTencentServerInfo()
    if self.isQQ_ == 1 then
        PaymentInfo.openId = self.qqDataTable_[1]
        PaymentInfo.openKey = self.qqDataTable_[2]
        PaymentInfo.payToken = self.qqDataTable_[3]
        PaymentInfo.pf = self.qqDataTable_[4]
        PaymentInfo.pfKey = self.qqDataTable_[5]
        PaymentInfo.mid = self.qqDataTable_[6] or ""
        
        local ac = AlertConnection.new(CONNECTION_QQ_LOGIN, PaymentInfo.openId, PaymentInfo.openKey,PaymentInfo.mid)
        self:addChild(ac,100,1235)
    else
        PaymentInfo.openId = self.qqDataTable_[1]
        PaymentInfo.openKey = self.qqDataTable_[2]
        PaymentInfo.payToken = self.qqDataTable_[3]
        PaymentInfo.pf = self.qqDataTable_[4]
        PaymentInfo.pfKey = self.qqDataTable_[5]
        PaymentInfo.mid = self.qqDataTable_[6] or ""
        
        local ac = AlertConnection.new(CONNECTION_WX_LOGIN, PaymentInfo.openId, PaymentInfo.openKey,PaymentInfo.mid)
        self:addChild(ac,100,1235)
    end

    self.scheduleTencent_ = self:schedule(function()
        if not self:getChildByTag(1235) then
            self:stopAction(self.scheduleTencent_)
            
            -- 加载服务器相关UI
            self.server_ = ServersBtn.new(handler(self, self.onEventServerBtn))
            self.server_:setPosition(display.width * 0.5,display.height * 0.28)
            self:addChild(self.server_, 2)
            
            -- 开始按钮
            self.buttonStart_:setVisible(true)
        end
    end,0.1)
end
-- init anysdk
function LoginScene:initAnySdk()
    require "anysdkConst"

    --for anysdk
    agent = AgentManager:getInstance()

    local appKey = "18930D57-B99A-A542-20F4-AB54AE5AAACA";
    local appSecret = "b878a29fd741f3f1902b5482e2e42355";
    local privateKey = "E943A12F2F1594FE061433640A6ECD0A";
    local oauthLoginServer = "http://125.88.152.21/account/anysdklogin";
    agent:init(appKey,appSecret,privateKey,oauthLoginServer)
    --load
    agent:loadALLPlugin()

    local user_plugin = agent:getUserPlugin()

    --用户系统初始化
    local function onActionListener( pPlugin, code, msg )
        if code == UserActionResultCode.kInitSuccess then  --初始化SDK成功回调
            --sdk初始化成功，游戏相关处理
            print("sdk初始化成功")
            self:anySdkLogin()
        end
        if code == UserActionResultCode.kLoginSuccess  then   --登陆成功回调
            print("登陆成功")
--            local uid = agent:getUserPlugin():getUserID()
--            print("anysdk uid : " .. uid)
            
            -- 根据AnySdk返回的msg解析服务器信息
            local jsonValue = json.decode(msg)
            
            CloudData.SERVERS_TABLE = jsonValue.regions
            CloudData.REGIONS = jsonValue.user.regions or ""
            CloudData.TOKEN = jsonValue.user.token or ""
            CloudData.UID = jsonValue.user.uid
            
            -- 加载服务器相关UI（此处做0.5s延迟，防止OpenGL(0x0502)渲染错误）
            self:performWithDelay(function ()
                self.server_ = ServersBtn.new(handler(self, self.onEventServerBtn))
                self.server_:setPosition(display.width * 0.5,display.height * 0.28)
                self:addChild(self.server_, 2)
                
                -- 开始按钮
                self.buttonStart_:setVisible(true)
            end, 0.5)
        end
    end
    user_plugin:setActionListener(onActionListener)

    -- 支付系统初始化
    local function onResult( code, msg, info )   --code: pay result code, msg: par result message, info: product info.
        print("pay result----")
        if code == PayResultCode.kPaySuccess  then
            print("Pay Success")
            --DataEye统计
            if USE_DATAEYE then
                DCEvent.onEvent("payment_index_".. PaymentInfo.ID .."_at_stage_progress_" .. CloudData.STAGE_PROGRESS)
            end

            --新增支付统计
            --PaymentInfo.MONEY = jsonTable.data.amount
            --PaymentInfo.PEACH = jsonTable.data.peach
            --PaymentInfo.BILLNO = jsonTable.data.orderId
            --DataEye统计
            if USE_DATAEYE then
                local paymentType = nil
                if CHANNEL == 3 then
                    paymentType = "酷狗"
                elseif CHANNEL == 4 then
                    paymentType = "UC"
                else
                    paymentType = "SMS"
                end
                DCVirtualCurrency.paymentSuccess(PaymentInfo.BILLNO.."", PaymentInfo.MONEY,"CNY",paymentType)
            end

            CloudData.PEACH = CloudData.PEACH + PaymentInfo.PEACH
            --DataEye统计蟠桃产出
            if USE_DATAEYE then
                DCCoin.gain("recharge", "peach", PaymentInfo.PEACH, CloudData.PEACH)
            end
            if CloudData.FIRST_PURCHASE_STATE == 0 then CloudData.FIRST_PURCHASE_STATE = 1 end
        end
    end
    iap_plugin_maps = agent:getIAPPlugin()
    for key, value in pairs(iap_plugin_maps) do
        print("key:" .. key)
        print("value: " .. type(value))
        value:setResultListener(onResult)
    end

    if USE_DATAEYE then
    -- 统计系统
    --        analytics_plugin = agent:getAnalyticsPlugin()
    --        analytics_plugin:startSession()
    end
end
-- anysdk login
function LoginScene:anySdkLogin()
    local user_plugin = agent:getUserPlugin()
    if nil ~= user_plugin then
        user_plugin:login()
    end
end

-- init UCSdk
function LoginScene:initUCSdk()
    -- UC登录
    local javaClassName = "org/cocos2dx/lua/AppActivity"
    local javaMethodName = "checkAndGetUCId"
    local javaParams = {function(event)
        print("uc sid : "..event)

        local ac = AlertConnection.new(CONNECTION_LOGIN_UC,event)
        self:addChild(ac,100,12456)
        self.scheduleUCLogin_ = self:schedule(function()
            if not self:getChildByTag(12456) then
                self:stopAction(self.scheduleUCLogin_)
                
                -- 加载服务器相关UI
                self.server_ = ServersBtn.new(handler(self, self.onEventServerBtn))
                self.server_:setPosition(display.width * 0.5,display.height * 0.28)
                self:addChild(self.server_, 2)
                
                -- 开始按钮
                self.buttonStart_:setVisible(true)
            end
        end,0.1)
    end}
    local javaMethodSig = "(I)V"
    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end

-- init operator
function LoginScene:initOperator()
    local lastUser = cc.UserDefault:getInstance():getStringForKey("userName","")

    --第一次进入游戏
    if lastUser == "" then
        --快速注册
        local ac = AlertConnection.new(CONNECTION_QUICK_REGISTER)
        self:addChild(ac,100,6665)

        -- 查询注册状态
        self.scheduleO_ = self:schedule(function()
            if not self:getChildByTag(6665) then
                -- 注册成功
                self:stopAction(self.scheduleO_)
                
                self.server_ = ServersBtn.new(handler(self, self.onEventServerBtn))
                self.server_:setPosition(display.width * 0.5,display.height * 0.28)
                self:addChild(self.server_, 2)
                
                self.buttonStart_:setVisible(true)
            end
        end, 0.2)
    else
        self.server_ = ServersBtn.new(handler(self, self.onEventServerBtn))
        self.server_:setPosition(display.width * 0.5,display.height * 0.28)
        self:addChild(self.server_, 2)
        
        self.buttonStart_:setVisible(true)
    end
end

--点击开始按钮
function LoginScene:startCallBack()
    self.buttonStart_:setVisible(false)

    --DataEye统计z
    if USE_DATAEYE then
        DCEvent.onEvent("game_start")
    end

    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch.%s",GameManager.POSTFIX))
    end

    if IS_SERVER_IN_MAINTAINING then
        local msg = ServerMaintainLayer.new(2)
        self:addChild(msg,20)

        --退出游戏？
        self.buttonStart_:setVisible(true)
        return
    end
    
    -- 本地存储当前进入的服务器ID
    cc.UserDefault:getInstance():setIntegerForKey("user_server",CloudData.USER_SERVER_ID)
    
    -- 记录当前服务器的IP
    GameManager.IP = CloudData.USER_SERVER_IP

    --Windows开发测试环境
    if device.platform == "windows" or device.platform == "mac" then
        -- print("************cemima")
        print(GameManager.ACCOUNT_SERVER_IP)
        local ac = AlertConnection.new(CONNECTION_LOGIN, GameManager.USER_NAME, GameManager.PASSWORD)
        self:addChild(ac,100,123456)

        self.schedule1_ = self:schedule(function()
            if not self:getChildByTag(123456) then
                self:stopAction(self.schedule1_)

                self:getUserInfo()
            end
        end,0.1)
        
    elseif device.platform == "android" and PaymentInfo.CHANNEL == 3 then
        -- 酷狗用户
        local lastUser = cc.UserDefault:getInstance():getStringForKey("userName","")
        --切换了用户
        if lastUser ~= tostring(userName) then
            --存储本次用户名
            cc.UserDefault:getInstance():setStringForKey("userName",tostring(userName))
            --下阵场上兵种
            cc.UserDefault:getInstance():setStringForKey("buddha_on_team","1,")
        end
        
        -- 获取角色信息
        self:getUserInfo()
        
    elseif device.platform == "android" and PaymentInfo.CHANNEL == 2 then
        --anysdk
        local uid = agent:getUserPlugin():getUserID()
        local lastUser = cc.UserDefault:getInstance():getStringForKey("userName","")

        -- anysdk 用户登录后，开始记录,防止统计出错。渠道以进入游戏算为新增用户
        --        if(analytics_plugin and analytics_plugin:isFunctionSupported("setAccount")) then
        --            local paramMap = {
        --                Account_Id = uid.."",
        --                Account_Name = "",
        --                Account_Type = string.format(AccountType.ANONYMOUS),
        --                Account_Level = "1",
        --                Account_Age = "1",
        --                Account_Operate = string.format(AccountOperate.LOGIN),
        --                Account_Gender = string.format(AccountGender.MALE),
        --                Server_Id = "1"
        --            }
        --            local data = PluginParam:create(paramMap);
        --            analytics_plugin:callFuncWithParam("setAccount", data);
        --        end

        --切换了用户
        if lastUser ~= uid.."" then
            --存储上次用户名
            cc.UserDefault:getInstance():setStringForKey("userName",uid.."")
            --下阵场上兵种
            cc.UserDefault:getInstance():setStringForKey("buddha_on_team","1,")
        end
        
        -- 获取角色信息
        self:getUserInfo()
        
    elseif device.platform == "android" and self.m_isSmallChannel then
        -- 运营商 or 无渠道SDK登录
        -- 读取用户名
        local userName = cc.UserDefault:getInstance():getStringForKey("userName","")
        --读取密码
        local password = cc.UserDefault:getInstance():getStringForKey("password","")

        local ac = AlertConnection.new(CONNECTION_LOGIN, userName, password)
        self:addChild(ac,100,123456)

        self.schedule1_ = self:schedule(function()
            if not self:getChildByTag(123456) then
                self:stopAction(self.schedule1_)                

                self:getUserInfo()
            end
        end,0.1)
        
    elseif device.platform == "android" and PaymentInfo.CHANNEL == 4 then
        --UC
        local lastUser = cc.UserDefault:getInstance():getStringForKey("userName","")
        --切换了用户
        if lastUser ~= CloudData.UID.."" then
            --存储上次用户名
            cc.UserDefault:getInstance():setStringForKey("userName",CloudData.UID.."")
            --下阵场上兵种
            cc.UserDefault:getInstance():setStringForKey("buddha_on_team","1,")
        end
        
        -- 获取角色信息
        self:getUserInfo()
       
    elseif device.platform == "android" and PaymentInfo.CHANNEL == 6 then
        --腾讯QQ MSDK with 微信 登录
        local lastUser = cc.UserDefault:getInstance():getStringForKey("userName","")
        
        --切换了用户
        if lastUser ~= CloudData.UID.."" then
            --存储上次用户名
            cc.UserDefault:getInstance():setStringForKey("userName",CloudData.UID.."")
            --下阵场上兵种
            cc.UserDefault:getInstance():setStringForKey("buddha_on_team","1,")
        end

        -- 获取角色信息
        self:getUserInfo()
    end

    if device.platform == "ios" and PaymentInfo.CHANNEL == 0 then
        -- ios酷狗登录
        local lastUser = cc.UserDefault:getInstance():getStringForKey("userName","")
        -- 切换了用户
        if lastUser ~= tostring(userName) then
            -- 存储本次用户名
            cc.UserDefault:getInstance():setStringForKey("userName",tostring(userName))
            -- 下阵场上兵种
            cc.UserDefault:getInstance():setStringForKey("buddha_on_team","1,")
        end

        -- 获取角色信息
        self:getUserInfo()
    end
end

-- 获取角色信息
function LoginScene:getUserInfo()
    --CloudData.UID = 13101
    local ac = AlertConnection.new(CONNECTION_CREATE_PLAYER)
    self:addChild(ac,100,123456)
    self.schedule2_ = self:schedule(function()
        if not self:getChildByTag(123456) then
            self:stopAction(self.schedule2_)

            -- DataEye统计,设置用户登录，在Android里，初始化DataEye在用户登录后开始记录
            if USE_DATAEYE then
                DCAccount.login(CloudData.UID.."")
            end
                
            self:performWithDelay(function()
                self:toScene()
            end,0.2)
        end
    end,0.1)
end

--跳转章节场景
function LoginScene:toScene()
    --DataEye统计
    if USE_DATAEYE then
        DCEvent.onEvent("loading_done")
    end

    if CloudData.OPENNING_COMIC_PLAYED == 0 and not GameManager.IS_LITE_VERSION then
        audio.stopMusic()
        display.replaceScene(require("scenes.OpeningComicScene").new())
    else
        audio.stopMusic()
        display.replaceScene(require("scenes.LoadingScene").new())
    end
end


local function setOnClick(widget, callback, params)
    if(widget==nil) then return end
    params = params or {}
    if(params.swallow ==nil) then  params.swallow = true end
    if(params.pass ==nil) then params.pass = false end

    widget:setTouchEnabled(true)
    local function onTouch(sender, eventType)
        if(gHasDnD==true) then
            return
        end

        if eventType==ccui.TouchEventType.ended then
            --            gg.guide:clickCheck(widget) -- guide 测试
            if(callback) then
                callback(widget, params)
            end
            --            GameSoundManager.playEffect("bgm/sound_button_0001.wav")
        end
    end

    -- 是否传递信息
    widget:setPropagateTouchEvents(params.pass)
    widget:setSwallowTouches(params.swallow)
    widget:addTouchEventListener(onTouch)
end

function LoginScene:onEventServerBtn(tag, param1, param2)
    if tag == ServersBtn.TAG_SHOW_ALERT then
        if param1 then
            self:addChild(param1)
        end
    end
end

--检查新版本
function LoginScene:getNewestVersion()

    function versionLower(v1,v2) -- v1版本低于v2
        if tonumber(v1[1]) < tonumber(v2[1]) then
            return true
        elseif (tonumber(v1[1]) == tonumber(v2[1])) and (tonumber(v1[2]) < tonumber(v2[2]))then
            return true
        elseif (tonumber(v1[2]) == tonumber(v2[2])) and (tonumber(v1[3]) < tonumber(v2[3]))then
            return true
        else
            return false
        end
    end

    -- 创建下载目录
    GameManager.PATH_DLC = device.writablePath.."dlc/"
    self:createDownPath(GameManager.PATH_DLC)

    --windows开发环境
    if device.platform == "windows" or device.platform == "mac" then
        self.server_ = ServersBtn.new(handler(self, self.onEventServerBtn))
        
        self.server_:setPosition(display.width * 0.5,display.height * 0.28)
        self:addChild(self.server_, 2)

        self.buttonStart_:setVisible(true)
        local v = cc.UserDefault:getInstance():getStringForKey("v",GameManager.DEFAULT_VERSION)
        self.m_visionLabel:setString(string.format("版本号：%s",v))

        --        if device.platform == "ios" or device.platform == "android" then
        --            local webView = ccui.WebView.create()
        --            webView:loadURL("http://www.baidu.com")
        --            webView:setScalesPageToFit(true)
        --            self:addChild(webView,9000,10000)
        --            webView:setAnchorPoint(cc.p(0, 0))
        --            webView:setPosition(0,80)
        --            webView:setContentSize(display.width, display.height-80)
        --
        --            local btn = ccui.Button:create("activity/close.png","activity/close_h.png","activity/close.png")
        --            self:addChild(btn,9001,11110)
        --            btn:setAnchorPoint(cc.p(0,0))
        --            btn:setPosition(display.width - 200,0)
        --
        --            local function onEnd(params)
        --                self:removeChild(webView)
        --                self:removeChild(btn)
        --                resetLuaEngine()
        --            end
        --
        --
        --            setOnClick(btn, onEnd, {})
        --
        --        end

        return
    end

    -- 连接更新服务器
    local ac = AlertConnection.new(CONNECTION_CHECK_UPDATE_INFO)
    self:addChild(ac,100,12345)

    self.scheduleResult_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)

            local v = cc.UserDefault:getInstance():getStringForKey("v",GameManager.DEFAULT_VERSION)

            -- 分割版本号
            local oldVersions = split(v,".")
            local newVersions = split(GameManager.V,".")
            --强更版本号
            local forceVersions = split(GameManager.FC,".")

            -- 版本已更新至最新,三个版本号相同，则不用更新
            -- 中间版本号不同时，渠道应该强制更新包
            -- 只热更新小版本，只要不涉及c++层的错误
            -- ?

            -- 有热更
            if versionLower(oldVersions, forceVersions) then 
                --强制更新游戏，退出游戏
                local fu = ForceUpdateLayer.new()
                self:addChild(fu,20)                
                return
            end                                           

            -- 版本最新
            if(tonumber(newVersions[1])==tonumber(oldVersions[1]) and
                tonumber(newVersions[2])==tonumber(oldVersions[2]) and
                tonumber(newVersions[3])<=tonumber(oldVersions[3])) then

                WSToast.new("版本已是最新"):addTo(self,10)
                self.m_visionLabel:setString(string.format("版本号：%s",v))            

                --PaymentInfo.CHANNEL
                -- 3 酷狗
                -- 2 anysdk
                -- 0 三网短代TouchPay
                -- 4 UC
                -- 5 百度
                -- 6 腾讯
                -- 10086 移动MM
                -- 10010 联通wo商店
                -- 10000 电信爱游戏

                if device.platform == "android" and PaymentInfo.CHANNEL == 3 then
                    -- 直接从设置里返回
                    if GameManager.IS_BACK_FROM_SETLAYER then
                        GameManager.IS_BACK_FROM_SETLAYER = false
                        
                        self.server_ = ServersBtn.new(handler(self, self.onEventServerBtn))
                        self.server_:setPosition(display.width * 0.5,display.height * 0.28)
                        self:addChild(self.server_, 2)
                    
                        -- 开始按钮
                        self.buttonStart_:setVisible(true)
                    else
                        self:initKugouSdk()
                    end
                    
                elseif device.platform == "android" and PaymentInfo.CHANNEL == 2 then
                    -- 直接从设置里返回
                    if GameManager.IS_BACK_FROM_SETLAYER then
                        GameManager.IS_BACK_FROM_SETLAYER = false   
                        
                        self.server_ = ServersBtn.new(handler(self, self.onEventServerBtn))
                        self.server_:setPosition(display.width * 0.5,display.height * 0.28)
                        self:addChild(self.server_, 2)
                    
                        -- 开始按钮
                        self.buttonStart_:setVisible(true)
                    else
                        self:initAnySdk()
                    end
                    
                elseif device.platform == "android" and self.m_isSmallChannel then
                    self:initOperator()
                elseif device.platform == "android" and PaymentInfo.CHANNEL == 4 then
                    self:initUCSdk()
                end

                -- ios酷狗端登陆
                if device.platform == "ios" and PaymentInfo.CHANNEL == 0 then
                    -- 直接从设置里返回
                    if GameManager.IS_BACK_FROM_SETLAYER then
                        GameManager.IS_BACK_FROM_SETLAYER = false
                        
                        self.server_ = ServersBtn.new(handler(self, self.onEventServerBtn))
                        self.server_:setPosition(display.width * 0.5,display.height * 0.28)
                        self:addChild(self.server_, 2)
                    
                        -- 开始按钮
                        self.buttonStart_:setVisible(true)
                    else
                        self:initKugouSdkIOS()
                    end
                end

                -- 腾讯登陆
                if device.platform == "android" and PaymentInfo.CHANNEL == 6 then
                    
                    local tencentUser = cc.UserDefault:getInstance():getStringForKey("tencentUser","")
                    if tencentUser == "1" then
                        self.weChatBtn_:setVisible(false)
                        self.qqLoginBtn_:setVisible(false)
                        self:qqLoginCallBack_()
                    elseif tencentUser == "2" then
                        self.weChatBtn_:setVisible(false)
                        self.qqLoginBtn_:setVisible(false)
                        self:weChatCallBack_()
                    else
                        self.weChatBtn_:show()
                        self.qqLoginBtn_:show()
                    end
                end
            else
                -- 有新版本
                local v = cc.UserDefault:getInstance():getStringForKey("v",GameManager.DEFAULT_VERSION)
                GameManager.URL_UPDATE = GameManager.P .. v .. "-" .. GameManager.V .. ".zip"
                print(GameManager.URL_UPDATE)
                local table = split(v,".")
                local vr = tonumber(table[3])

                local needRestart = false
                if vr < tonumber(GameManager.R) then
                    needRestart = true
                end

                local size = GameManager.SIZE_TABLE[ vr + 1 ]

                if size == nil then size = 0.1 end

                local au = AlertUpdate.new(GameManager.URL_UPDATE, size, "FORCE", false, GameManager.V)
                self:addChild(au,100,87654)

                self.scheduleUpdate_ = self:schedule(function()
                    if not self:getChildByTag(87654) then
                        self:stopAction(self.scheduleUpdate_)

                        if needRestart then
                            -- 下载完成重启游戏
                            --require("app.MyApp").new():run()
                            --                            self:showRestart()
                            if device.platform == "ios" or device.platform == "android" then
                                resetLuaEngine()
                            else
                                self:showRestart()
                            end
                        else
                            self:getNewestVersion()
                        end
                    end
                end, 0.1)
            end
        end
    end,0.1)
end

--
function LoginScene:showRestart()
    self.returnMask = display.newColorLayer(cc.c4b(0,0,0,150))
    self:addChild(self.returnMask,20)

    local bg = display.newSprite("common_ui/common_bg.png"):pos(display.cx, display.cy):addTo(self.returnMask,1)
    cc.ui.UILabel.new({
        text = "更新完成，请重新进入游戏。" ,size = 30, color = cc.c3b(76,34,1), font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.57)
        :addTo(bg)

    --重启按钮
    cc.ui.UIPushButton.new({normal = "connection/restart.png",pressed = "connection/restart1.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.22)
        :onButtonClicked(function()
            cc.Director:getInstance():endToLua()
            if device.platform == "windows" or device.platform == "mac" then
                os.exit()
            end
        end)
        :addTo(bg,2)
end


--
function LoginScene:createDownPath( path )
    if not self:checkDirOK(path) then
        print("更新目录创建失败")
        return
    else
        print("更新目录存在或创建成功")
    end
end
--
function LoginScene:checkDirOK( path )
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

function LoginScene:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function LoginScene:showReturnWarning_()
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

function LoginScene:onEnter()
    -- self.server_ = ServersBtn.new()
    -- self.server_:setPosition(display.width * 0.5,display.height * 0.28)
    -- self:addChild(self.server_, 2)
end

function LoginScene:onExit()

end

return LoginScene

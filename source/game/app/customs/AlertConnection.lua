
CONNECTION_CHECK_UPDATE_INFO = 100

CONNECTION_LOGIN = 1000
CONNECTION_LOGIN_ANYSDK = 1002
CONNECTION_LOGIN_KUGOU = 1003
CONNECTION_LOGIN_UC = 1004
CONNECTION_QUICK_REGISTER = 1005

CONNECTION_QQ_LOGIN = 1006
CONNECTION_WX_LOGIN = 1007
CONNECTION_QQ_GAMECOIN_QUERY = 2000
CONNECTION_QQ_PAY_ORDER_BY_GAMECOIN = 2001
CONNECTION_WX_GAMECOIN_QUERY = 2002
CONNECTION_WX_PAY_ORDER_BY_GAMECOIN = 2003

CONNECTION_RECOVER = 2
CONNECTION_GIFT_CODE_EXCHANGE = 3
CONNECTION_COST_ENERGY = 4
CONNECTION_ADD_ENERGY = 5
CONNECTION_BUY_EXP = 6
CONNECTION_GUIDE = 7
CONNECTION_UNLOCK_TEAM_NUM = 8
CONNECTION_CHAPTER = 9

CONNECTION_NPC_UPGRADE = 10
CONNECTION_NPC_EVOLUTION = 11
CONNECTION_NPC_BREAKTOP = 12
CONNECTION_NPC_COMPOSE = 13
CONNECTION_UPGRADE_PROPERTY = 14

CONNECTION_SHOP_INIT = 20
CONNECTION_SHOP_REFRESH = 21
CONNECTION_SHOP_BUY = 22

CONNECTION_SHOP_INIT_1 = 23
CONNECTION_SHOP_REFRESH_1 = 24
CONNECTION_SHOP_BUY_1 = 25

CONNECTION_SHOP_BUY_ITEM = 26
CONNECTION_SHOP_BUY_EXP = 27

CONNECTION_SUMMON_INIT = 30
CONNECTION_SUMMON_EXP_1 = 31
CONNECTION_SUMMON_EXP_10 = 32
CONNECTION_SUMMON_PEACH_1 = 33
CONNECTION_SUMMON_PEACH_10 = 34

CONNECTION_SIGN_INFO_INIT = 40
CONNECTION_SIGN_TODAY = 41

CONNECTION_ACHIEVEMENT_STEP      = 50
CONNECTION_ACHIEVEMENT_INFO      = 51
CONNECTION_DAILY_TASK_INFO       = 52
CONNECTION_DAILY_TASK_FINISH     = 53
CONNECTION_STAGE_TASK_SUB_INFO   = 54
CONNECTION_STAGE_TASK_SUB_FINISH = 55
CONNECTION_CHAPTER_TASK_INFO = 56
CONNECTION_CHAPTER_TASK_FINISH = 57

CONNECTION_PASS_STAGE = 60
CONNECTION_SWEEP = 61
CONNECTION_SWEEP_5 = 62
CONNECTION_PASS_STAGE_CHALLENGE = 63
CONNECTION_PASS_STAGE_DIARY = 64

CONNECTION_PAYMENT_PROMOTION_COUNTDOWN = 70
CONNECTION_PAYMENT = 71
CONNECTION_PAYMENT_FIRSTTIME_GIFT = 72
CONNECTION_PAYMENT_MM = 73
CONNECTION_PAYMENT_CHECK_STATUS = 74
CONNECTION_PAYMENT_IOS = 75
CONNECTION_PAYMENT_IOS_FINISH = 76
CONNECTION_PRODUCT_ADD = 77 -- 游戏内支付,添加订单，只用于联通
CONNECTION_PAYMENT_WO = 78 -- 联通支付

--特殊卡领取蟠桃状态
CONNECTION_PAYMENT_INIT = 81
CONNECTION_PAYMENT_GET_DAILY_PEACH = 82

--章节界面判断"new"标识(主要是任务,召唤,体力)
CONNECTION_CHAPTER_NEW_INFO = 83

--抽奖
CONNECTION_DRAW_LOTTERY = 90

--服务器维护
CONNECTION_SERVER_MAINTAIN = 91
CONNECTION_GET_SERVER_MAINTAIN_COMPENSATION = 92

--排行榜
CONNECTION_CHART_INFO = 93

--修改昵称
CONNECTION_CHANGE_NICKNAME = 94

--公告
CONNECTION_NOTICE = 95

-- 无尽模式结算
CONNECTION_INFINITE_RESULT = 96

--信箱刷新
CONNECTION_MAIL_REFRESH = 97

--修改账号密码
CONNECTION_CHANGE_ACCOUNT = 98

-- 活动关卡相关
CONNECTION_ACTIVITY_STAGE_INFO    = 110
CONNECTION_ACTIVITY_STAGE_START   = 111
CONNECTION_ACTIVITY_STAGE_FINISH  = 112
CONNECTION_ACTIVITY_SHOP_EXCHANGE = 113

--连接消息服务器
CONNECTION_SERVER_MAINTAIN_QQ      = 114
CONNECTION_SERVER_MAINTAIN_IOS     = 115
CONNECTION_SERVER_MAINTAIN_ANDROID = 116

--读取开服信息
CONNECTION_SERVERS_INFO            = 117
--创建新角色
CONNECTION_CREATE_PLAYER           = 118

--修改队伍阵容
CONNECTION_UPDATE_TEAM             = 119

local ErrorCodeLayer = import("layers.ErrorCodeLayer")
local CompatTrace = import("utils.CompatTrace")

local AlertConnection = {}
AlertConnection =  class("AlertConnection", function()
    return display.newLayer()
end)


function AlertConnection:update()
    if (self.isConnectionSucceed_) then
        self:stopAction(self.schedule_)
        self:closeDialog()
    end
end

function AlertConnection:ctor( connectionType, value1, value2, value3, value4, value5, value6 )

    self:initData( connectionType, value1, value2, value3, value4, value5, value6 )
    self.schedule_ = self:schedule(function()
        self:update()
    end, 0.1)
    self:loading()
end

function AlertConnection:initData( connectionType, value1, value2, value3, value4, value5, value6 )
    self.isConnectionSucceed_ = false
    self.connectionType_ = connectionType
    self.failTimes_ = 0

    if CONNECTION_LOGIN == self.connectionType_ then
        self.userName_ = value1
        self.passWord_ = value2
        self.cb = value3
    elseif CONNECTION_LOGIN_ANYSDK == self.connectionType_ then
        self.uid_ = value1
    elseif CONNECTION_LOGIN_KUGOU == self.connectionType_ then
        self.unixTime_ = value1
        self.userName_ = value2
        self.token_ = value3
    elseif CONNECTION_LOGIN_UC == self.connectionType_ then
        self.sid_ = value1
    elseif CONNECTION_QQ_LOGIN == self.connectionType_ then
        self.openid_ = value1
        self.openkey_ = value2
        self.mid_ = value3
    elseif CONNECTION_WX_LOGIN == self.connectionType_ then
        self.openid_ = value1
        self.accessToken_ = value2
        self.mid_ = value3
    elseif CONNECTION_QQ_GAMECOIN_QUERY == self.connectionType_ then
        self.openid_ = value1
        self.openkey_ = value2
        self.pay_token_ = value3
        self.pf_ = value4
        self.pfkey_ = value5
    elseif CONNECTION_QQ_PAY_ORDER_BY_GAMECOIN == self.connectionType_ then
        self.openid_ = value1
        self.openkey_ = value2
        self.pay_token_ = value3
        self.pf_ = value4
        self.pfkey_ = value5
        self.productId_ = value6
    elseif CONNECTION_WX_GAMECOIN_QUERY == self.connectionType_ then
        self.openid_ = value1
        self.openkey_ = value2
        self.pay_token_ = value3
        self.pf_ = value4
        self.pfkey_ = value5
    elseif CONNECTION_WX_PAY_ORDER_BY_GAMECOIN == self.connectionType_ then
        self.openid_ = value1
        self.openkey_ = value2
        self.pay_token_ = value3
        self.pf_ = value4
        self.pfkey_ = value5
        self.productId_ = value6
    elseif CONNECTION_GIFT_CODE_EXCHANGE == self.connectionType_ then
        self.code_ = value1
    elseif CONNECTION_COST_ENERGY == self.connectionType_ then
        self.stageId_ = value1
    elseif CONNECTION_SWEEP == self.connectionType_ then
        self.stageId_ = value1
    elseif CONNECTION_SWEEP_5 == self.connectionType_ then
        self.stageId_ = value1
    elseif CONNECTION_PASS_STAGE_CHALLENGE == self.connectionType_ then
        self.stageId_ = value1
    elseif CONNECTION_PASS_STAGE_DIARY == self.connectionType_ then
        self.stageId_ = value1
    elseif CONNECTION_PASS_STAGE == self.connectionType_ then
        self.stageId_ = value1
        self.success_ = value2
        self.buyProp_ = value3
        self.useProp_ = value4
        self.teamInfoTable_ = value5
    elseif CONNECTION_NPC_UPGRADE == self.connectionType_ then
        self.npcid_ = value1
    elseif CONNECTION_NPC_EVOLUTION == self.connectionType_ then
        self.npcid_ = value1
    elseif CONNECTION_NPC_BREAKTOP == self.connectionType_ then
        self.npcid_ = value1
    elseif CONNECTION_NPC_COMPOSE == self.connectionType_ then
        self.npcid_ = value1
    elseif CONNECTION_BUY_EXP == self.connectionType_ then
        self.num_ = value1
    elseif CONNECTION_GUIDE == self.connectionType_ then
        self.step_ = value1
    elseif CONNECTION_UPGRADE_PROPERTY == self.connectionType_ then
        self.id_ = value1
    elseif CONNECTION_ACHIEVEMENT_STEP == self.connectionType_ then
        self.achievementId_ = value1
        self.progress_ = value2
    elseif CONNECTION_DAILY_TASK_FINISH == self.connectionType_ then
        self.taskId_ = value1
    elseif CONNECTION_STAGE_TASK_SUB_INFO == self.connectionType_ then
        self.chapterId_ = value1
    elseif CONNECTION_STAGE_TASK_SUB_FINISH == self.connectionType_ then
        self.chapterId_ = value1
        self.taskSubId_ = value2
    elseif CONNECTION_CHAPTER_TASK_FINISH == self.connectionType_ then
        self.chapterId_ = value1
    elseif CONNECTION_SHOP_BUY == self.connectionType_ then
        self.index_ = value1
    elseif CONNECTION_SHOP_BUY_1 == self.connectionType_ then
        self.index_ = value1
    elseif CONNECTION_SHOP_BUY_ITEM == self.connectionType_ then
        self.id_ = value1
    elseif CONNECTION_SHOP_BUY_EXP == self.connectionType_ then
        self.id_ = value1
    elseif CONNECTION_PAYMENT == self.connectionType_ then
        self.productId_ = value1
    elseif CONNECTION_PAYMENT_IOS == self.connectionType_ then
        self.productId_ = value1
    elseif CONNECTION_PAYMENT_IOS_FINISH == self.connectionType_ then
        self.receipt_ = value1
    elseif CONNECTION_PAYMENT_GET_DAILY_PEACH == self.connectionType_ then
        self.productId_ = value1
    elseif CONNECTION_PAYMENT_MM == self.connectionType_ then
        self.orderId_ = value1
    elseif CONNECTION_PAYMENT_CHECK_STATUS == self.connectionType_ then
        self.orderId_ = value1
    elseif CONNECTION_GET_SERVER_MAINTAIN_COMPENSATION == self.connectionType_ then
        self.msgId_ = value1
    elseif CONNECTION_PRODUCT_ADD == self.connectionType_ then
        self.productId_ = value1
    elseif CONNECTION_PAYMENT_WO == self.connectionType_ then
        self.orderId_ = value1
    elseif CONNECTION_CHART_INFO == self.connectionType_ then
        self.pageNum_ = value1     
    elseif CONNECTION_CHANGE_NICKNAME == self.connectionType_ then
        self.nickName_ = value1
    elseif CONNECTION_INFINITE_RESULT == self.connectionType_ then
        self.infiniteStageId_ = value1
        self.teamInfoTable_   = value2
        self.waveId_          = value3   
        self.battleResult_    = value4   
        self.buyProp_         = value5   
        self.useProp_         = value6
    elseif CONNECTION_CHANGE_ACCOUNT == self.connectionType_ then
        self.AccountName_     = value1
        self.AccountPWord_    = value2  
        self.LastName_        = value3 
        self.LastPWord_       = value4  
    elseif CONNECTION_ACTIVITY_STAGE_START == self.connectionType_ then
        self.stageType_ = value1
    elseif CONNECTION_ACTIVITY_STAGE_FINISH == self.connectionType_ then
        self.stageType_      = value1
        self.battleResult_   = value2   
        self.buyProp_        = value3   
        self.useProp_        = value4
        self.teamInfoTable_  = value5
    elseif CONNECTION_ACTIVITY_SHOP_EXCHANGE == self.connectionType_ then
        self.goodsId_ = value1
    elseif CONNECTION_UPDATE_TEAM            == self.connectionType_ then
        self.mTeam = value1
    end
end


function AlertConnection:connectionInNewThread()

    if CONNECTION_LOGIN == self.connectionType_ then
        self:login()
    elseif CONNECTION_LOGIN_ANYSDK == self.connectionType_ then
        self:loginAnysdk()
    elseif CONNECTION_LOGIN_KUGOU == self.connectionType_ then
        self:loginKugou()
    elseif CONNECTION_LOGIN_UC == self.connectionType_ then
        self:loginUC()
    elseif CONNECTION_QUICK_REGISTER == self.connectionType_ then
        self:quickRegister()
    elseif CONNECTION_QQ_LOGIN == self.connectionType_ then
        self:qqLogin()
    elseif CONNECTION_WX_LOGIN == self.connectionType_ then
        self:wxLogin()
    elseif CONNECTION_QQ_GAMECOIN_QUERY == self.connectionType_ then
        self:qqGamecoinQuery()
    elseif CONNECTION_QQ_PAY_ORDER_BY_GAMECOIN == self.connectionType_ then
        self:qqPayOrderByGamecoin()
    elseif CONNECTION_WX_GAMECOIN_QUERY == self.connectionType_ then
        self:wxGamecoinQuery()
    elseif CONNECTION_WX_PAY_ORDER_BY_GAMECOIN == self.connectionType_ then
        self:wxPayOrderByGamecoin()
    elseif CONNECTION_RECOVER == self.connectionType_ then
        self:recover()
    elseif CONNECTION_GIFT_CODE_EXCHANGE == self.connectionType_ then
        self:giftCodeExchange()
    elseif CONNECTION_PASS_STAGE == self.connectionType_ then
        self:pass()
    elseif CONNECTION_SWEEP == self.connectionType_ then
        self:sweep()
    elseif CONNECTION_SWEEP_5 == self.connectionType_ then
        self:sweep5()
    elseif CONNECTION_PASS_STAGE_CHALLENGE == self.connectionType_ then
        self:passStageChallenge()
    elseif CONNECTION_PASS_STAGE_DIARY == self.connectionType_ then
        self:passStageDiary()
    elseif CONNECTION_CHAPTER == self.connectionType_  then
        self:chapter()
    elseif CONNECTION_COST_ENERGY == self.connectionType_ then
        self:costEnergy()
    elseif CONNECTION_ADD_ENERGY == self.connectionType_ then
        self:addEnergy()
    elseif CONNECTION_UNLOCK_TEAM_NUM == self.connectionType_ then
        self:unlockTeamNum()
    elseif CONNECTION_SUMMON_INIT == self.connectionType_ then
        self:summonInit()
    elseif CONNECTION_SUMMON_EXP_1 == self.connectionType_ then
        self:summonExp1()
    elseif CONNECTION_SUMMON_EXP_10 == self.connectionType_ then
        self:summonExp10()
    elseif CONNECTION_SUMMON_PEACH_1 == self.connectionType_ then
        self:summonPeach1()
    elseif CONNECTION_SUMMON_PEACH_10 == self.connectionType_ then
        self:summonPeach10()
    elseif CONNECTION_SHOP_INIT == self.connectionType_ then
        self:shopInit()
    elseif CONNECTION_SHOP_REFRESH == self.connectionType_ then
        self:shopRefresh()
    elseif CONNECTION_SHOP_BUY == self.connectionType_ then
        self:shopBuy()
    elseif CONNECTION_SHOP_INIT_1 == self.connectionType_ then
        self:shopInit1()
    elseif CONNECTION_SHOP_REFRESH_1 == self.connectionType_ then
        self:shopRefresh1()
    elseif CONNECTION_SHOP_BUY_1 == self.connectionType_ then
        self:shopBuy1()
    elseif CONNECTION_SHOP_BUY_ITEM == self.connectionType_ then
        self:shopBuyItem()
    elseif CONNECTION_SHOP_BUY_EXP == self.connectionType_ then
        self:shopBuyExp()
    elseif CONNECTION_NPC_UPGRADE == self.connectionType_ then
        self:npcUpgrade()
    elseif CONNECTION_NPC_EVOLUTION == self.connectionType_ then
        self:npcEvolution()
    elseif CONNECTION_NPC_BREAKTOP == self.connectionType_ then
        self:npcBreakTop()
    elseif CONNECTION_NPC_COMPOSE == self.connectionType_ then
        self:npcCompose()
    elseif CONNECTION_BUY_EXP == self.connectionType_ then
        self:buyExp()
    elseif CONNECTION_GUIDE == self.connectionType_ then
        self:guide()
    elseif CONNECTION_UPGRADE_PROPERTY == self.connectionType_ then
        self:upgradeProperty()
    elseif CONNECTION_SIGN_INFO_INIT == self.connectionType_ then
        self:signInfoInit()
    elseif CONNECTION_SIGN_TODAY == self.connectionType_ then
        self:signToday()
    elseif CONNECTION_ACHIEVEMENT_INFO == self.connectionType_ then
        self:achievementInfo()
    elseif CONNECTION_ACHIEVEMENT_STEP == self.connectionType_ then
        self:achievementStep()
    elseif CONNECTION_DAILY_TASK_INFO == self.connectionType_ then
        self:dailyTaskInfo()
    elseif CONNECTION_DAILY_TASK_FINISH == self.connectionType_ then
        self:dailyTaskFinish()
    elseif CONNECTION_STAGE_TASK_SUB_INFO == self.connectionType_ then
        self:stageTaskSubInfo()
    elseif CONNECTION_STAGE_TASK_SUB_FINISH == self.connectionType_ then
        self:stageTaskSubFinish()
    elseif CONNECTION_CHAPTER_TASK_INFO == self.connectionType_ then
        self:chapterTaskInfo()
    elseif CONNECTION_CHAPTER_TASK_FINISH == self.connectionType_ then
        self:chapterTaskFinish()
    elseif CONNECTION_CHECK_UPDATE_INFO == self.connectionType_ then
        self:checkUpdateInfo()
    elseif CONNECTION_PAYMENT_PROMOTION_COUNTDOWN == self.connectionType_ then
        self:paymentPromotionCountdown()
    elseif CONNECTION_PAYMENT == self.connectionType_ then
        self:pay()
    elseif CONNECTION_PAYMENT_IOS == self.connectionType_ then
        self:payIOS()
    elseif CONNECTION_PAYMENT_IOS_FINISH == self.connectionType_ then
        self:payIOSSucceed()
    elseif CONNECTION_PAYMENT_FIRSTTIME_GIFT == self.connectionType_ then
        self:paymentFirstTimeGift()
    elseif CONNECTION_PAYMENT_INIT == self.connectionType_ then
        self:paymentInit()
    elseif CONNECTION_PAYMENT_GET_DAILY_PEACH == self.connectionType_ then
        self:paymentGetDailyPeach()
    elseif CONNECTION_CHAPTER_NEW_INFO == self.connectionType_ then
        self:chapterNewInfo()
    elseif CONNECTION_PAYMENT_MM == self.connectionType_ then
        self:payMM()
    elseif CONNECTION_PAYMENT_CHECK_STATUS == self.connectionType_ then
        self:checkPaymentStatus()
    elseif CONNECTION_DRAW_LOTTERY == self.connectionType_ then
        self:drawLottery()
    elseif CONNECTION_SERVER_MAINTAIN == self.connectionType_ then
        self:serverMaintain()
    elseif CONNECTION_MAIL_REFRESH == self.connectionType_ then
        self:refreshMail()
    elseif CONNECTION_GET_SERVER_MAINTAIN_COMPENSATION == self.connectionType_ then
        self:getSMaintainCompensation()
    elseif CONNECTION_PRODUCT_ADD == self.connectionType_ then
        self:productAdd()
    elseif CONNECTION_PAYMENT_WO == self.connectionType_ then
        self:payWO()
    elseif CONNECTION_CHART_INFO  == self.connectionType_ then
        self:getChartInfo()
    elseif CONNECTION_CHANGE_NICKNAME  == self.connectionType_ then
        self:changeNickName()
    elseif CONNECTION_NOTICE  == self.connectionType_ then
        self:noticeInit()
    elseif CONNECTION_INFINITE_RESULT  == self.connectionType_ then
        self:infiniteModeResult()
    elseif CONNECTION_CHANGE_ACCOUNT  == self.connectionType_ then
        self:changeAccount()
    elseif CONNECTION_ACTIVITY_STAGE_INFO == self.connectionType_ then
        self:initActivityStageInfo()
    elseif CONNECTION_ACTIVITY_STAGE_START == self.connectionType_ then
        self:activityStageStart()
    elseif CONNECTION_ACTIVITY_STAGE_FINISH == self.connectionType_ then
        self:activityStageFinish()
    elseif CONNECTION_ACTIVITY_SHOP_EXCHANGE == self.connectionType_ then
        self:exchangeActivityGoods()
    elseif CONNECTION_SERVER_MAINTAIN_QQ      == self.connectionType_ then
        self:serverMaintainQQ()
    elseif CONNECTION_SERVER_MAINTAIN_IOS     == self.connectionType_ then
        self:serverMaintainIOS()
    elseif CONNECTION_SERVER_MAINTAIN_ANDROID == self.connectionType_ then
        self:serverMaintainANDROID()
    elseif CONNECTION_SERVERS_INFO            == self.connectionType_ then
        self:getServersInfo()
    elseif CONNECTION_CREATE_PLAYER           == self.connectionType_ then
        self:getPlayerInfo()
    elseif CONNECTION_UPDATE_TEAM             == self.connectionType_ then
        self:updateTeam()
    end
end

function MyCreateHttpRequest(onRequestFinish, url, method)
    -- 扩展回调处理
    local function myOnRequestFinish(event)
        -- cocos reports progress callbacks for the same request; they are not
        -- failures and must not pollute the compatibility trace.
        if event.name == "progress" then
            return
        end
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            CompatTrace.log("http", string.format("request failed event=%s url=%s", tostring(event.name), tostring(url)))
            return
        end
        local statusOk, code = pcall(function()
            return request:getResponseStatusCode()
        end)
        if not statusOk then
            CompatTrace.log("http", "status read failed url=" .. tostring(url))
            return
        end
        if code ~= 200 then
            CompatTrace.log("http", string.format("unexpected status=%s method=%s url=%s", tostring(code), tostring(method), tostring(url)))
            return
        end
        local bodyOk, body = pcall(function()
            return request:getResponseString()
        end)
        if not bodyOk or type(body) ~= "string" then
            CompatTrace.log("http", "response body read failed url=" .. tostring(url))
            return
        end
        local decodeOk, jsonTable = xpcall(function()
            return json.decode(body)
        end, debug.traceback)
        if not decodeOk or type(jsonTable) ~= "table" then
            CompatTrace.log("http", "invalid JSON url=" .. tostring(url) .. "\n" .. tostring(jsonTable))
            return
        end
        -- dump(jsonTable)

        local errCode = tonumber(jsonTable.errorCode) or 0
        local errMsg  = jsonTable.errorMsg

        -- print("err code " .. errCode)
        -- print("err msg " .. errMsg)
        
        -- error
        if(errCode > 0) then
            local pLayer = ErrorCodeLayer.new(errCode)
            display.getRunningScene():addChild(pLayer,10000)

            return
        end
        
        -- normal
        -- xpcall(onRequestFinish, __G__TRACKBACK__, event)
        onRequestFinish(event)
    end

    return network.createHTTPRequest(myOnRequestFinish, url, method)
end


--抽奖
function AlertConnection:drawLottery()
    CompatTrace.log("lottery", string.format("request start uid=%s region=%s url=http://%s/lottery/draw", tostring(CloudData.UID), tostring(CloudData.USER_SERVER_ID), tostring(GameManager.IP)))
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            CompatTrace.log("lottery", "request failed event=" .. tostring(event.name))
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            CompatTrace.log("lottery", "unexpected status=" .. tostring(code))
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        CompatTrace.log("lottery", "response=" .. tostring(response))
        local jsonTable = json.decode(response)
        dump(jsonTable)

        if type(jsonTable) ~= "table" or type(jsonTable.data) ~= "table" then
            CompatTrace.log("lottery", "invalid response shape; data table is missing")
            return
        end
        if jsonTable.data.index == nil or jsonTable.data.critNum == nil or jsonTable.data.awardNum == nil then
            CompatTrace.log("lottery", "invalid reward fields index=" .. tostring(jsonTable.data.index) ..
                " crit=" .. tostring(jsonTable.data.critNum) .. " item=" .. tostring(jsonTable.data.itemId) ..
                " num=" .. tostring(jsonTable.data.awardNum))
            return
        end

        --奖品id
        CloudData.AWARD_ID      = jsonTable.data.index
        --暴击倍数
        CloudData.CRIT_NUM      = jsonTable.data.critNum
        --道具id
        CloudData.AWARD_ITEM_ID = jsonTable.data.itemId
        --奖品数量
        CloudData.AWARD_NUM     = jsonTable.data.awardNum
        CompatTrace.log("lottery", string.format("reward index=%s crit=%s item=%s num=%s",
            tostring(CloudData.AWARD_ID), tostring(CloudData.CRIT_NUM), tostring(CloudData.AWARD_ITEM_ID), tostring(CloudData.AWARD_NUM)))

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/lottery/draw",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

-- 兑换CDKEY
function AlertConnection:giftCodeExchange()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        --dump(jsonTable)
        GameManager.ERROR_CODE = jsonTable.errorCode
        GameManager.ERROR_MSG = jsonTable.errorMsg
        if jsonTable.errorCode == 0 then
            CloudData.TAMP_DATA = jsonTable.data
        end

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/giftcode/exchange",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("code",self.code_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- 快速注册
function AlertConnection:quickRegister()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        local userName = jsonTable.data.userName
        local password = jsonTable.data.password
        --存储用户名
        cc.UserDefault:getInstance():setStringForKey("userName",userName)
        --存储密码
        cc.UserDefault:getInstance():setStringForKey("password",password)

        --是否为新用户
        cc.UserDefault:getInstance():setBoolForKey("is_new_user",true)

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/user/quickregister",GameManager.ACCOUNT_SERVER_IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    -- 开始请求。当请求完成时会调用 callback() 函数
    
    -- 添加渠道号
    request:addPOSTValue("channel",CHANNEL_ID or 0)
    request:start()
end

-- 无尽模式战斗结算
function AlertConnection:infiniteModeResult()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        -- dump(jsonTable)

        if self.battleResult_ == 1 then      -- 胜利
            CloudData.INFINITE_GOODS_TYPE        = jsonTable.data.goodstype             -- 随机奖励的类型
            CloudData.INFINITE_GOODS_ITEM_ID     = jsonTable.data.goodsitemid           -- 随机奖励的物品的ID
            CloudData.INFINITE_GOODS_NUM         = jsonTable.data.goodsnum              -- 随机奖励的物品的数量
            CloudData.INFINITE_ESSENCE_NUM       = jsonTable.data.essence               -- 精华石的数量
            CloudData.INFINITE_MONSTER_PIECE_ID  = jsonTable.data.monsterPieceId        -- 妖怪碎片的ID
            CloudData.INFINITE_MONSTER_PIECE_NUM = jsonTable.data.num                   -- 妖怪碎片数量
        end

        CloudData.DELTA_TIME = jsonTable.time - os.time()

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/stage/reachTower",GameManager.IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    local teamInfoStr = json.encode(self.teamInfoTable_)
    local time = CloudData.DELTA_TIME + os.time()
    local propertyInfo = json.encode(CloudData.UPGRADE_PROPERTY_INFO)

    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&battleResult=%s&buyProp=%s&propertyInfo=%s&team=%s&time=%s&token=%s&towerLevel=%s&uid=%s&useProp=%s&waveId=%s",
        strAppSecret.."",
        self.battleResult_.."",
        self.buyProp_.."",
        propertyInfo.."",
        teamInfoStr.."",
        time.."",
        CloudData.TOKEN.."",
        self.infiniteStageId_.."",
        CloudData.UID.."",
        self.useProp_.."",
        self.waveId_.."")
    CloudData.SIGN = crypto.md5(strSign, false)

    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("towerLevel",self.infiniteStageId_)
    request:addPOSTValue("team",teamInfoStr)
    request:addPOSTValue("waveId",self.waveId_)
    request:addPOSTValue("battleResult",self.battleResult_)
    request:addPOSTValue("buyProp",self.buyProp_)
    request:addPOSTValue("useProp",self.useProp_)
    request:addPOSTValue("time",time)
    request:addPOSTValue("propertyInfo",propertyInfo)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

-- 活动关卡相关
function AlertConnection:initActivityStageInfo()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        if jsonTable ~= nil then
            CloudData.ACTIVITY_STAGE_INFO_TABLE = jsonTable.data
        else
            local errCode = jsonTable.errorCode
            local pLayer = ErrorCodeLayer.new(errCode)
            display.getRunningScene():addChild(pLayer,200)
        end
    
        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/event/list",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end
function AlertConnection:activityStageStart()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        if jsonTable.data ~= nil then
            CloudData.SKILL_ITEM_INFO = jsonTable.data.items
            if CloudData.PLAYER_DATA_READY ~= true then
                CloudData.EXP = jsonTable.data.exp
                CloudData.PEACH = jsonTable.data.peach
            end
            CloudData.ENERGY = jsonTable.data.energy
            CloudData.TEMP_TOKEN = jsonTable.data.tempToken or "tempToken"
        end

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/event/costenergy",GameManager.IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("type",self.stageType_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end
function AlertConnection:activityStageFinish()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        -- dump(jsonTable)

        if self.battleResult_ == 1 then      -- 胜利
            CloudData.ACTIVITY_COINS = jsonTable.data.coin
            CloudData.ACTIVITY_COINS_ADD_NUM = jsonTable.data.addcoin
        end

        CloudData.DELTA_TIME = jsonTable.time - os.time()

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/event/receive",GameManager.IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    local time = CloudData.DELTA_TIME + os.time()
    local teamInfoStr = json.encode(self.teamInfoTable_)
    local propertyInfo = json.encode(CloudData.UPGRADE_PROPERTY_INFO)

    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&buyProp=%s&propertyInfo=%s&success=%s&teamInfoStr=%s&tempToken=%s&time=%s&token=%s&type=%s&uid=%s&useProp=%s",
        strAppSecret.."",
        self.buyProp_.."",
        propertyInfo.."",
        self.battleResult_.."",
        teamInfoStr.."",
        CloudData.TEMP_TOKEN.."",
        time.."",
        CloudData.TOKEN.."",
        self.stageType_.."",
        CloudData.UID.."",
        self.useProp_.."")
    CloudData.SIGN = crypto.md5(strSign, false)

    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("buyProp",self.buyProp_)
    request:addPOSTValue("success",self.battleResult_)
    request:addPOSTValue("type",self.stageType_)
    request:addPOSTValue("useProp",self.useProp_)
    request:addPOSTValue("time",time)
    request:addPOSTValue("propertyInfo",propertyInfo)
    request:addPOSTValue("teamInfoStr",teamInfoStr)
    request:addPOSTValue("tempToken",CloudData.TEMP_TOKEN)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end
function AlertConnection:exchangeActivityGoods()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        -- dump(jsonTable)

        CloudData.ACTIVITY_SHOP_INFO_TABLE = jsonTable

        if jsonTable.errorCode == 0 then
            local infoTable = jsonTable.data

            -- 代币数量
            CloudData.ACTIVITY_COINS = infoTable["coin"]

            -- 奖励
            if jsonTable.data["type"] == "peach" then        -- 蟠桃
                CloudData.PEACH = infoTable["peach"]
    
            elseif jsonTable.data["type"] == "exp" then      -- 经验
                CloudData.EXP = infoTable["exp"]
 
            elseif jsonTable.data["type"] == "sweep" then    -- 扫荡券
                CloudData.SWEEP = infoTable["sweep"]

            elseif jsonTable.data["type"] == "essence" then  -- 精华石
                CloudData.ESSENCE = infoTable["essence"]

            elseif jsonTable.data["type"] == "item" then     -- 道具
                CloudData.SKILL_ITEM_INFO = infoTable["items"]

            end
        end
    
        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/event/buy",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("id",self.goodsId_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- 复活
function AlertConnection:recover()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/account/renew",GameManager.IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--章节界面判断"new"标识(主要是任务,召唤,体力)
function AlertConnection:chapterNewInfo()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        --成就数据--jsonTable.achievementProgress["buddaLevel10Num"]
        CloudData.BUDDHA_10_NUM = jsonTable.data.achievementProgress.buddaLevel10Num
        CloudData.BUDDHA_20_NUM = jsonTable.data.achievementProgress.buddaLevel20Num
        CloudData.BUDDHA_NUM = jsonTable.data.achievementProgress.buddaNum
        CloudData.BUY_EXP_NUM = jsonTable.data.achievementProgress.buyExpNum
        CloudData.COST_MONEY = jsonTable.data.achievementProgress.costMoney
        CloudData.COST_PEACH = jsonTable.data.achievementProgress.costPeach
        CloudData.STAGE_FAIL_NUM = jsonTable.data.achievementProgress.failNum
        CloudData.MONSTER_NUM = jsonTable.data.achievementProgress.monsterNum
        CloudData.SIGN_TOTAL_NUM = jsonTable.data.achievementProgress.signNum
        CloudData.STAGE_PROGRESS = jsonTable.data.achievementProgress.stageId
        CloudData.TOWER_PROPERTY_10 = jsonTable.data.achievementProgress.towerPropertyLevelFull
        CloudData.TREASURE_NUM = jsonTable.data.achievementProgress.treasureNum

        --日常任务
        CloudData.DAILY_TASK_INFO = jsonTable.data.dailyTaskProgress

        --阶段任务
        CloudData.CHAPTER_TASK_INFO = jsonTable.data.chapterProgress

        --体力
        CloudData.ENERGY = jsonTable.data["energy"]
        CloudData.MAX_ENERGY = jsonTable.data["maxEnergy"]

        --召唤数据
        --经验倒计时
        if tonumber(jsonTable.data.expAvailableTime - jsonTable.time) < 0 then
            CloudData.NEXT_FREESUMMON_TIME_EXP = 0
        else
            CloudData.NEXT_FREESUMMON_TIME_EXP = tonumber(jsonTable.data.expAvailableTime - jsonTable.time)
        end
        --蟠桃倒计时
        if tonumber(jsonTable.data.peachAvailableTime - jsonTable.time) < 0 then
            CloudData.NEXT_FREESUMMON_TIME_PEACH = 0
        else
            CloudData.NEXT_FREESUMMON_TIME_PEACH = tonumber(jsonTable.data.peachAvailableTime - jsonTable.time)
        end
        --免费经验次数
        CloudData.FREE_SUMMON_NUM_EXP = jsonTable.data.expFreeNum

        --充值数据
        CloudData.PAYMENT_ITEM_STATE = jsonTable.data.productStatus

        --限时充值界面是否显示
        CloudData.SHOW_LIMITED_TIME_RECHARGE = tonumber(jsonTable.data.charge10Status)
        --限时充值活动剩余时间
        CloudData.LAST_TIME_FOR_RECHARGE_ACTIVITY = tonumber(jsonTable.data.charge10RemainSecond)

        --服务器时间
        CloudData.TIME_SERVER = jsonTable.time

        --服务器维护消息
        CloudData.SERVER_MSG = jsonTable.data.msgs

        --抽奖是否处于特殊状态，是为1，否为0
        CloudData.DRAW_ACTIVITY_STATUS = tonumber(jsonTable.data.drawActivityStatus)

        -- 当前活动关卡是否开启（0：没开启；1：开启）
        CloudData.ACTIVITY_STAGE_STATUS = jsonTable.data.activityStatus

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&token=%s&uid=%s",
        strAppSecret.."",
        CloudData.TOKEN.."",
        CloudData.UID.."")

    local url = string.format("http://%s/account/chapterinfoNew",GameManager.IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",crypto.md5(strSign, false))
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- 读日常任务信息
function AlertConnection:dailyTaskInfo()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)
        CloudData.DAILY_TASK_INFO = jsonTable.data

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/task/dailyprogress",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end
-- 完成日常任务
function AlertConnection:dailyTaskFinish()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        CloudData.DAILY_TASK_INFO = jsonTable.data

        --网络请求错误信息返回
        CloudData.ERR_CODE = jsonTable.errorCode

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&taskId=%s&token=%s&uid=%s",
        strAppSecret.."",
        self.taskId_.."",
        CloudData.TOKEN.."",
        CloudData.UID.."")

    local url = string.format("http://%s/task/drawdailyreward",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",crypto.md5(strSign, false))
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("taskId",self.taskId_)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

-- 读取阶段任务子任务信息
function AlertConnection:stageTaskSubInfo()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)
        CloudData.STAGE_TASK_SUB_INFO = jsonTable.data

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/task/stageprogress",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("chapterId",self.chapterId_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end
-- 完成阶段任务子任务
function AlertConnection:stageTaskSubFinish()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&chapterId=%s&taskId=%s&token=%s&uid=%s",
        strAppSecret.."",
        self.chapterId_.."",
        self.taskSubId_.."",
        CloudData.TOKEN.."",
        CloudData.UID.."")

    local url = string.format("http://%s/task/stagereward",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",crypto.md5(strSign, false))
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("chapterId",self.chapterId_)
    request:addPOSTValue("taskId",self.taskSubId_)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- 获取章节阶段任务奖励信息
function AlertConnection:chapterTaskInfo()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)
        CloudData.CHAPTER_TASK_INFO = jsonTable.data

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/task/chapterprogress",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



--领取章节阶段任务总奖励
function AlertConnection:chapterTaskFinish()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        CloudData.CHAPTER_TASK_INFO = jsonTable.data

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&chapterId=%s&token=%s&uid=%s",
        strAppSecret.."",
        self.chapterId_.."",
        CloudData.TOKEN.."",
        CloudData.UID.."")

    local url = string.format("http://%s/task/chapterreward",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",crypto.md5(strSign, false))
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("chapterId",self.chapterId_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- payment INIT time countdown 48hour
function AlertConnection:paymentPromotionCountdown()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        --dump(jsonTable)
        CloudData.PAYMENT_PROMOTION_COUNTDOWN = (CloudData.CREATE_TIME + 48 * 3600) - jsonTable.time
        if CloudData.FIRST_PURCHASE_STATE > 0 then
            CloudData.PAYMENT_PROMOTION_COUNTDOWN = -1
        end
        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/account/chapterinfo",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- payment
function AlertConnection:pay()
    CompatTrace.log("payment", string.format("order request product=%s uid=%s url=http://%s/order/add",
        tostring(self.productId_), tostring(CloudData.UID), tostring(GameManager.IP)))
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            CompatTrace.log("payment", "order request failed event=" .. tostring(event.name))
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            CompatTrace.log("payment", "order unexpected status=" .. tostring(code))
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        CompatTrace.log("payment", "order response=" .. tostring(response))
        local jsonTable = json.decode(response)
        dump(jsonTable)
        if type(jsonTable) ~= "table" or type(jsonTable.data) ~= "table" or
            jsonTable.data.amount == nil or jsonTable.data.peach == nil or jsonTable.data.orderId == nil then
            CompatTrace.log("payment", "order response missing amount/peach/orderId; no payment marked successful")
            return
        end
        PaymentInfo.ID = self.productId_
        PaymentInfo.MONEY = jsonTable.data.amount
        PaymentInfo.PEACH = jsonTable.data.peach
        PaymentInfo.BILLNO = jsonTable.data.orderId

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/order/add",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("productId",self.productId_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

function AlertConnection:payIOS()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)
        PaymentInfo.ID = self.productId_
        PaymentInfo.MONEY = jsonTable.data.amount
        PaymentInfo.PEACH = jsonTable.data.peach
        PaymentInfo.BILLNO = jsonTable.data.orderId

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/order/addApple",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("productId",self.productId_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end
function AlertConnection:payIOSSucceed()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/pay/apple",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("receipt",self.receipt_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

function AlertConnection:payMM()
    -- 缺省设置支付失败
    
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        
        --请求成功
        local response = request:getResponseString()
        
        PaymentInfo.PAY_SUCCESS = false
        
        -- 支付是否成功, 返回字符串 "SUCCESS"成功
        if response == "SUCCESS" then
            PaymentInfo.PAY_SUCCESS = true
        end

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/pay/mmorderquery",GameManager.IP) -- 已过期
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&orderId=%s&token=%s&tradeId=%s&uid=%s",
        strAppSecret.."",
        PaymentInfo.BILLNO.."",
        CloudData.TOKEN.."",
        PaymentInfo.TRADE_ID.."",
        CloudData.UID.."")

    CloudData.SIGN = crypto.md5(strSign, false)
    
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN) -- 添加签名
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("orderId",PaymentInfo.BILLNO) -- 订单号
    request:addPOSTValue("tradeId",PaymentInfo.TRADE_ID) -- 交易号
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

-- wo支付 向cp服务器查询是否支付成功
function AlertConnection:payWO()
    
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        -- 缺省设置支付失败
        PaymentInfo.PAY_SUCCESS = false
        
        -- 支付是否成功
        if(jsonTable.data>0) then
            PaymentInfo.PAY_SUCCESS = true
        else  -- 其实还有其它情况1,2..
            PaymentInfo.PAY_SUCCESS = false
        end

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/order/status",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&orderId=%s&token=%s&uid=%s",
        strAppSecret.."",
        PaymentInfo.BILLNO.."",
        CloudData.TOKEN.."",
        CloudData.UID.."")
    CloudData.SIGN = crypto.md5(strSign, false)

    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN) -- 添加签名
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("orderId",PaymentInfo.BILLNO) -- 订单号
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--新增订单提交接口
function AlertConnection:productAdd()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)
        PaymentInfo.ID = self.productId_
        PaymentInfo.MONEY = jsonTable.data.amount
        PaymentInfo.PEACH = jsonTable.data.peach
        PaymentInfo.BILLNO = jsonTable.data.orderId
        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/order/add2",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&appVersion=%s&productId=%s&token=%s&uid=%s",
        strAppSecret.."",
        GameManager.DEFAULT_VERSION.."",
        self.productId_.."",
        CloudData.TOKEN.."",
        CloudData.UID..""
    )
    CloudData.SIGN = crypto.md5(strSign, false)
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN) -- 添加签名
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("productId",self.productId_)
    request:addPOSTValue("appVersion",GameManager.DEFAULT_VERSION) -- 添加版本号
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


--向服务器查询充值状态（0：失败，1：已支付；2：成功）
function AlertConnection:checkPaymentStatus()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)
        GameManager.CHECK_PAYMENT_STATUS = tonumber(jsonTable.data)

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/order/status",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("orderId",self.orderId_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



function AlertConnection:paymentFirstTimeGift()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/pay/getgift",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- 查询充值过的月卡周卡信息
function AlertConnection:paymentInit()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        --存储状态值
        CloudData.PAYMENT_ITEM_STATE = jsonTable.data

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/order/specialcardstatus",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- 领取月卡周卡每日蟠桃奖励
function AlertConnection:paymentGetDailyPeach()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/product/dailyget",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("productId",self.productId_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end









-- login
function AlertConnection:login()
    local obj = self
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end

        --请求成功
        print("_____________*****")
        local response = request:getResponseString()
        --print("ray .. "..response)
        self:parseNewBriefLoginJson(response)

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/user/login",GameManager.ACCOUNT_SERVER_IP)
    -- local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("userName",self.userName_)
    request:addPOSTValue("password",self.passWord_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    
    -- 添加渠道号
    request:addPOSTValue("channel",CHANNEL_ID or 0)
   
    request:start()
end


-- login anysdk
function AlertConnection:loginAnysdk()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print(" err http 500")
            return
        end

        --请求成功
        local response = request:getResponseString()
        --print("ray .. "..response)
        self:parseNewBriefLoginJson(response)

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/user/anysdklogin",GameManager.ACCOUNT_SERVER_IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("uid",self.uid_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- login kugou
function AlertConnection:loginKugou()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print(" err http 500")
            return
        end

        --请求成功
        local response = request:getResponseString()
        print("ray .. "..response)
        self:parseNewBriefLoginJson(response)

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/user/kugoulogin",GameManager.ACCOUNT_SERVER_IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("unixTime",self.unixTime_)
    request:addPOSTValue("userName",self.userName_)
    request:addPOSTValue("token",self.token_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



--QQ MSDK 登录
function AlertConnection:qqLogin()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print(" err http 500")
            return
        end

        --请求成功
        local response = request:getResponseString()
        print("login data .. "..response)
        self:parseNewBriefLoginJson(response)

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/user/qqlogin",GameManager.ACCOUNT_SERVER_IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("openid",self.openid_)
    request:addPOSTValue("openkey",self.openkey_)
    request:addPOSTValue("mid",self.mid_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


--WX微信 MSDK 登录
function AlertConnection:wxLogin()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print(" err http 500")
            return
        end

        --请求成功
        local response = request:getResponseString()
        print("login data .. "..response)
        self:parseNewBriefLoginJson(response)

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/user/wechatlogin",GameManager.ACCOUNT_SERVER_IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("openid",self.openid_)
    request:addPOSTValue("accessToken",self.accessToken_)
    request:addPOSTValue("mid",self.mid_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end




--QQ游戏币查询接口
function AlertConnection:qqGamecoinQuery()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print(" err http 500")
            return
        end

        --请求成功
        local response = request:getResponseString()
        print("qqdata .. "..response)
        local jsonTable = json.decode( response )
        dump(jsonTable)
        PaymentInfo.QQGameCoin = jsonTable.balance

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/order/queryQQGameCoin",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("openid",self.openid_)
    request:addPOSTValue("openkey",self.openkey_)
    request:addPOSTValue("pay_token",self.pay_token_)
    request:addPOSTValue("pf",self.pf_)
    request:addPOSTValue("pfkey",self.pfkey_)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



--微信游戏币查询接口
function AlertConnection:wxGamecoinQuery()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print(" err http 500")
            return
        end

        --请求成功
        local response = request:getResponseString()
        print("qqdata .. "..response)
        local jsonTable = json.decode( response )
        dump(jsonTable)
        PaymentInfo.QQGameCoin = jsonTable.balance

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/order/queryWechatGameCoin",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("openid",self.openid_)
    request:addPOSTValue("openkey",self.openkey_)
    request:addPOSTValue("pay_token",self.pay_token_)
    request:addPOSTValue("pf",self.pf_)
    request:addPOSTValue("pfkey",self.pfkey_)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


--QQ游戏币支付订单接口
function AlertConnection:qqPayOrderByGamecoin()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print(" err http 500")
            return
        end

        --请求成功
        local response = request:getResponseString()
        print("RAYYYYYYYYYY qq pay gamecoin .. "..response)

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/order/addQQOrder",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("openid",self.openid_)
    request:addPOSTValue("openkey",self.openkey_)
    request:addPOSTValue("pay_token",self.pay_token_)
    request:addPOSTValue("pf",self.pf_)
    request:addPOSTValue("pfkey",self.pfkey_)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("productId",self.productId_)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



--微信游戏币支付订单接口
function AlertConnection:wxPayOrderByGamecoin()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print(" err http 500")
            return
        end

        --请求成功
        local response = request:getResponseString()
        print("RAYYYYYYYYYY Wechat pay gamecoin .. "..response)

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/order/addWechatOrder",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("openid",self.openid_)
    request:addPOSTValue("openkey",self.openkey_)
    request:addPOSTValue("pay_token",self.pay_token_)
    request:addPOSTValue("pf",self.pf_)
    request:addPOSTValue("pfkey",self.pfkey_)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("productId",self.productId_)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end




-- login UC 9game
function AlertConnection:loginUC()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print(" err http 500")
            return
        end

        --请求成功
        local response = request:getResponseString()
        --print("ray .. "..response)
        self:parseNewBriefLoginJson(response)

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/user/uclogin",GameManager.ACCOUNT_SERVER_IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("sid",self.sid_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- achievement info
function AlertConnection:achievementInfo()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("err connection")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print(" err code 500")
            return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode( request:getResponseString() )
        dump(jsonTable)
        CloudData.BUDDHA_10_NUM = jsonTable.data.buddaLevel10Num
        CloudData.BUDDHA_20_NUM = jsonTable.data.buddaLevel20Num
        CloudData.BUDDHA_NUM = jsonTable.data.buddaNum
        CloudData.BUY_EXP_NUM = jsonTable.data.buyExpNum
        CloudData.COST_MONEY = jsonTable.data.costMoney
        CloudData.COST_PEACH = jsonTable.data.costPeach
        CloudData.STAGE_FAIL_NUM = jsonTable.data.failNum
        CloudData.MONSTER_NUM = jsonTable.data.monsterNum
        CloudData.SIGN_TOTAL_NUM = jsonTable.data.signNum
        CloudData.STAGE_PROGRESS = jsonTable.data.stageId
        CloudData.TOWER_PROPERTY_10 = jsonTable.data.towerPropertyLevelFull
        CloudData.TREASURE_NUM = jsonTable.data.treasureNum

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&token=%s&uid=%s",
        strAppSecret.."",
        CloudData.TOKEN.."",
        CloudData.UID.."")

    local url = string.format("http://%s/achievement/property",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",crypto.md5(strSign, false))
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- achievement step
function AlertConnection:achievementStep()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("err connection")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print(" err code 500")
            return
        end

        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode( request:getResponseString() )
        dump(jsonTable)

        CloudData.BUDDHA_10_NUM = jsonTable.data.buddaLevel10Num
        CloudData.BUDDHA_20_NUM = jsonTable.data.buddaLevel20Num
        CloudData.BUDDHA_NUM = jsonTable.data.buddaNum
        CloudData.BUY_EXP_NUM = jsonTable.data.buyExpNum
        CloudData.COST_MONEY = jsonTable.data.costMoney
        CloudData.COST_PEACH = jsonTable.data.costPeach
        CloudData.STAGE_FAIL_NUM = jsonTable.data.failNum
        CloudData.MONSTER_NUM = jsonTable.data.monsterNum
        CloudData.SIGN_TOTAL_NUM = jsonTable.data.signNum
        CloudData.STAGE_PROGRESS = jsonTable.data.stageId
        CloudData.TOWER_PROPERTY_10 = jsonTable.data.towerPropertyLevelFull
        CloudData.TREASURE_NUM = jsonTable.data.treasureNum

        self.isConnectionSucceed_ = true
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&achievementId=%s&progress=%s&token=%s&uid=%s",
        strAppSecret.."",
        self.achievementId_.."",
        self.progress_.."",
        CloudData.TOKEN.."",
        CloudData.UID.."")
    
    local url = string.format("http://%s/achievement/award",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",crypto.md5(strSign, false))
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("achievementId",self.achievementId_)
    request:addPOSTValue("progress",self.progress_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

-- npcUpgrade
function AlertConnection:npcUpgrade()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        --print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/npc/upgrade",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("npcid",self.npcid_)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

-- npc Evolution
function AlertConnection:npcEvolution()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        --print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/npc/evolution",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("npcid",self.npcid_)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

-- npc BreakTop
function AlertConnection:npcBreakTop()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        --print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/npc/breach",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("npcid",self.npcid_)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- npc compose
function AlertConnection:npcCompose()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        --print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/npc/compose",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("npcid",self.npcid_)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


--. pass
function AlertConnection:pass()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        --print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        Game.EXP_ADD = jsonTable.data.exp
        CloudData.EXP = CloudData.EXP + Game.EXP_ADD
        if self.success_ == 1 then
            Game.PEACH_ADD = jsonTable.data.peach
            CloudData.PEACH = CloudData.PEACH + Game.PEACH_ADD
            --DataEye统计蟠桃产出
            if USE_DATAEYE then  
                DCCoin.gain("level completed", "peach", Game.PEACH_ADD, CloudData.PEACH)              
            end
            Game.TREASURE_PIECE_QUALITY = jsonTable.data.treasure
            if 0 ~= Game.TREASURE_PIECE_QUALITY then
                CloudData.TREASURE_PIECE_INFO[self.stageId_] = Game.TREASURE_PIECE_QUALITY
            end
            Game.MONSTER_PIECE_ID_TABLE = {jsonTable.data.monster.npcId, jsonTable.data.monster.advanceNpcId}
            Game.MONSTER_PIECE_NUM_TABLE = {jsonTable.data.monster.npcNum, jsonTable.data.monster.advanceNpcNum}

            if jsonTable.data.monster.npcId ~= 0 then
                CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.npcId] = CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.npcId] + jsonTable.data.monster.npcNum
            end
            if jsonTable.data.monster.advanceNpcId ~= 0 then
                CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.advanceNpcId] = CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.advanceNpcId] + jsonTable.data.monster.advanceNpcNum
            end

            if DataUtils.markResourceMutation ~= nil then
                DataUtils.markResourceMutation("stage-pass")
            end
        end

        CloudData.DELTA_TIME = jsonTable.time - os.time()

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/stage/pass",GameManager.IP)
    local time = CloudData.DELTA_TIME + os.time()
    local teamInfoStr = json.encode(self.teamInfoTable_)
    local propertyInfo = json.encode(CloudData.UPGRADE_PROPERTY_INFO)

    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("stageId",self.stageId_)
    request:addPOSTValue("success",self.success_)
    request:addPOSTValue("buyProp",self.buyProp_)
    request:addPOSTValue("useProp",self.useProp_)
    request:addPOSTValue("time",time)
    request:addPOSTValue("teamInfoStr",teamInfoStr)
    request:addPOSTValue("propertyInfo",propertyInfo)
    request:addPOSTValue("tempToken",CloudData.TEMP_TOKEN)

    local strAppSecret ="AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&buyProp=%s&propertyInfo=%s&stageId=%s&success=%s&teamInfoStr=%s&tempToken=%s&time=%s&token=%s&uid=%s&useProp=%s",
        strAppSecret.."",
        self.buyProp_.."",
        propertyInfo.."",
        self.stageId_.."",
        self.success_.."",
        teamInfoStr.."",
        CloudData.TEMP_TOKEN.."",
        time.."",
        CloudData.TOKEN.."",
        CloudData.UID.."",
        self.useProp_.."")
    -- CloudData.SIGN = crypto.md5(strSign, false)
    request:addPOSTValue("sign",crypto.md5(strSign, false))

    -- print("check   " ..CloudData.UID .. "   ".. self.stageId_.."   "..self.success_ .. "   " .. self.buyProp_ .. "   " .. self.useProp_ )

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- 扫荡
function AlertConnection:sweep()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        --print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        Game.EXP_ADD = jsonTable.data.exp
        Game.PEACH_ADD = jsonTable.data.peach
        Game.TREASURE_PIECE_QUALITY = jsonTable.data.treasure
        Game.MONSTER_PIECE_ID_TABLE = {jsonTable.data.monster.npcId, jsonTable.data.monster.advanceNpcId}
        Game.MONSTER_PIECE_NUM_TABLE = {jsonTable.data.monster.npcNum, jsonTable.data.monster.advanceNpcNum}


        CloudData.EXP = CloudData.EXP + Game.EXP_ADD
        CloudData.PEACH = CloudData.PEACH + Game.PEACH_ADD
        CloudData.SWEEP = jsonTable.data.sweepNum

        --DataEye统计蟠桃产出
        if USE_DATAEYE then  
            DCCoin.gain("sweep", "peach", Game.PEACH_ADD, CloudData.PEACH)              
        end
        if 0 ~= Game.TREASURE_PIECE_QUALITY then
            CloudData.TREASURE_PIECE_INFO[self.stageId_] = Game.TREASURE_PIECE_QUALITY
        end
        if jsonTable.data.monster.npcId ~= 0 then
            CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.npcId] = CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.npcId] + jsonTable.data.monster.npcNum
        end
        if jsonTable.data.monster.advanceNpcId ~= 0 then
            CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.advanceNpcId] = CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.advanceNpcId] + jsonTable.data.monster.advanceNpcNum
        end
        if DataUtils.markResourceMutation ~= nil then
            DataUtils.markResourceMutation("stage-sweep")
        end
        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/stage/sweep",GameManager.IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("stageId",self.stageId_)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

-- 扫荡5次
function AlertConnection:sweep5()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        --print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        Game.EXP_ADD = jsonTable.data.exp
        Game.PEACH_ADD = jsonTable.data.peach
        Game.TREASURE_PIECE_QUALITY = jsonTable.data.treasure
        Game.MONSTER_PIECE_ID_TABLE = {jsonTable.data.monster.npcId, jsonTable.data.monster.advanceNpcId}
        Game.MONSTER_PIECE_NUM_TABLE = {jsonTable.data.monster.npcNum, jsonTable.data.monster.advanceNpcNum}


        CloudData.EXP = CloudData.EXP + Game.EXP_ADD
        CloudData.PEACH = CloudData.PEACH + Game.PEACH_ADD
        CloudData.SWEEP = jsonTable.data.sweepNum
        --DataEye统计蟠桃产出
        if USE_DATAEYE then  
            DCCoin.gain("sweep5", "peach", Game.PEACH_ADD, CloudData.PEACH)              
        end

        if 0 ~= Game.TREASURE_PIECE_QUALITY then
            CloudData.TREASURE_PIECE_INFO[self.stageId_] = Game.TREASURE_PIECE_QUALITY
        end
        if jsonTable.data.monster.npcId ~= 0 then
            CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.npcId] = CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.npcId] + jsonTable.data.monster.npcNum
        end
        if jsonTable.data.monster.advanceNpcId ~= 0 then
            CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.advanceNpcId] = CloudData.MONSTER_PIECE_INFO[jsonTable.data.monster.advanceNpcId] + jsonTable.data.monster.advanceNpcNum
        end
        if DataUtils.markResourceMutation ~= nil then
            DataUtils.markResourceMutation("stage-sweep5")
        end
        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/stage/sweep5",GameManager.IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("stageId",self.stageId_)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- 挑战关过关结算
function AlertConnection:passStageChallenge()

    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        --print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)
        CloudData.CHALLENGE_SUCCESS_AWARD_NPCID = jsonTable.data.npcId
        -- DataUtils.setNewBuddhaCloudData(CloudData.CHALLENGE_SUCCESS_AWARD_NPCID)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/stage/challege",GameManager.IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("stageId",self.stageId_)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- 日常关过关结算
function AlertConnection:passStageDiary()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        --print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        CloudData.DIARY_SUCCESS_AWARD_EXP = jsonTable.data.exp
        CloudData.DIARY_SUCCESS_AWARD_PEACH = jsonTable.data.peach
        CloudData.DIARY_SUCCESS_AWARD_SWEEP = jsonTable.data.sweep
        CloudData.DIARY_SUCCESS_AWARD_ITEM_ID = jsonTable.data.item.id
        CloudData.DIARY_SUCCESS_AWARD_ITEM_NUM = jsonTable.data.item.num
        CloudData.DIARY_SUCCESS_AWARD_PIECE_ID = jsonTable.data.piece.id
        CloudData.DIARY_SUCCESS_AWARD_PIECE_NUM = jsonTable.data.piece.num

        CloudData.EXP = CloudData.EXP + jsonTable.data.exp
        CloudData.PEACH = CloudData.PEACH + jsonTable.data.peach
        --DataEye统计蟠桃产出
        if USE_DATAEYE then  
            DCCoin.gain("diary passed", "peach", jsonTable.data.peach, CloudData.PEACH)              
        end

        CloudData.SWEEP = CloudData.SWEEP + jsonTable.data.sweep
        CloudData.SKILL_ITEM_INFO[jsonTable.data.item.id] = CloudData.SKILL_ITEM_INFO[jsonTable.data.item.id] + jsonTable.data.item.num

        --DataEye统计道具使用
        if USE_DATAEYE then  
            DCItem.get("XBL", "diary", 1, "reward for diary_success")               
        end

        if jsonTable.data.piece.id ~= 0 then
            CloudData.MONSTER_PIECE_INFO[jsonTable.data.piece.id] = CloudData.MONSTER_PIECE_INFO[jsonTable.data.piece.id] + jsonTable.data.piece.num
        end

        if DataUtils.markResourceMutation ~= nil then
            DataUtils.markResourceMutation("stage-diary")
        end

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/stage/daily",GameManager.IP)
    local request = MyCreateHttpRequest(onRequestFinished, url, "POST")
    -- local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("stageId",self.stageId_)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- 3. chapter info energy
function AlertConnection:chapter()

    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            return
        end

        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)
        CloudData.ENERGY = jsonTable["energy"]
        CloudData.MAX_ENERGY = jsonTable["maxEnergy"]
        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/account/chapterinfo",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- 4. cost energy
function AlertConnection:costEnergy()

    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        -- print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        local errorCode = jsonTable.errorCode
        if errorCode > 0 then
            CloudData.HAS_ENERGY = false
            CloudData.ENERGY = jsonTable.data.energy
        else
            CloudData.SKILL_ITEM_INFO = jsonTable.data.items
            if CloudData.PLAYER_DATA_READY ~= true then
                CloudData.EXP = jsonTable.data.exp
                CloudData.PEACH = jsonTable.data.peach
            end
            CloudData.SWEEP = jsonTable.data.sweepNum
            CloudData.TEMP_TOKEN = jsonTable.data.tempToken or "tempToken"
            if DataUtils.markResourceMutation ~= nil then
                DataUtils.markResourceMutation("cost-energy")
            end
        end

        self.isConnectionSucceed_ = true
    end
    CloudData.HAS_ENERGY = true
    local url = string.format("http://%s/account/costenergy",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("stageId",self.stageId_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- add energy
function AlertConnection:addEnergy()

    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        -- print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)
        CloudData.GINSENG_FRUIT = jsonTable.data.ginsen

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/account/regainenergy",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()

end


-- unlock team grid
function AlertConnection:unlockTeamNum()

    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end

        --请求成功
        print( request:getResponseString() )
        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/account/unlockmembernum",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()

end


-- summon init info
function AlertConnection:summonInit()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonValue = json.decode(request:getResponseString())
        CloudData.TIME_SERVER = jsonValue.time

        --经验倒计时
        if tonumber(jsonValue.data.expAvailableTime - jsonValue.time) < 0 then
            CloudData.NEXT_FREESUMMON_TIME_EXP = 0
        else
            CloudData.NEXT_FREESUMMON_TIME_EXP = tonumber(jsonValue.data.expAvailableTime - jsonValue.time)
        end
        --蟠桃倒计时
        if tonumber(jsonValue.data.peachAvailableTime - jsonValue.time) < 0 then
            CloudData.NEXT_FREESUMMON_TIME_PEACH = 0
        else
            CloudData.NEXT_FREESUMMON_TIME_PEACH = tonumber(jsonValue.data.peachAvailableTime - jsonValue.time)
        end
        --免费经验次数
        CloudData.FREE_SUMMON_NUM_EXP = jsonValue.data.expFreeNum
        --抽奖金额
        CloudData.EXP_SINGLE_COST = jsonValue.data.costExp
        CloudData.EXP_CONTINUE_COST = jsonValue.data.costExpContinue
        CloudData.PEACH_SINGLE_COST = jsonValue.data.costPeach
        CloudData.PEACH_CONTINUE_COST = jsonValue.data.CostPeachContinue

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/lottery/initinfo",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

function AlertConnection:summonExp1()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        --dump(jsonTable)
        CloudData.TIME_SERVER = jsonTable.time
        --经验倒计时
        if tonumber(jsonTable.data.availableTime - jsonTable.time) < 0 then
            CloudData.NEXT_FREESUMMON_TIME_EXP = 0
        else
            CloudData.NEXT_FREESUMMON_TIME_EXP = tonumber(jsonTable.data.availableTime - jsonTable.time)
        end

        local newNpcId = jsonTable.data.npcId
        local essenceNum = jsonTable.data.essenceNum
        CompatTrace.log("summon", string.format("exp single npc=%s essence=%s", tostring(newNpcId), tostring(essenceNum)))

        CloudData.SUMMON_RESULT_NPCID_TABLE = {}
        CloudData.SUMMON_RESULT_ESSENCE_TABLE = {}
        CloudData.SUMMON_RESULT_NPCID_TABLE[1] = newNpcId
        CloudData.SUMMON_RESULT_ESSENCE_TABLE[1] = essenceNum

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/lottery/exp/single",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

function AlertConnection:summonExp10()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        CloudData.SUMMON_RESULT_NPCID_TABLE = {}
        CloudData.SUMMON_RESULT_ESSENCE_TABLE = {}
        for i = 1, 10 do
            local newNpcId = jsonTable.data.npcs[i].npcId
            local essenceNum = jsonTable.data.npcs[i].essenceNum
            CloudData.SUMMON_RESULT_NPCID_TABLE[i] = newNpcId
            CloudData.SUMMON_RESULT_ESSENCE_TABLE[i] = essenceNum
        end
        CompatTrace.log("summon", "exp ten npcs=" .. table.concat(CloudData.SUMMON_RESULT_NPCID_TABLE, ","))

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/lottery/exp/continue",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

function AlertConnection:summonPeach1()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        --dump(jsonTable)
        CloudData.TIME_SERVER = jsonTable.time
        --蟠桃倒计时
        if tonumber(jsonTable.data.availableTime - jsonTable.time) < 0 then
            CloudData.NEXT_FREESUMMON_TIME_PEACH = 0
        else
            CloudData.NEXT_FREESUMMON_TIME_PEACH = tonumber(jsonTable.data.availableTime - jsonTable.time)
        end

        local newNpcId = jsonTable.data.npcId
        local essenceNum = jsonTable.data.essenceNum
        CompatTrace.log("summon", string.format("peach single npc=%s essence=%s", tostring(newNpcId), tostring(essenceNum)))

        CloudData.SUMMON_RESULT_NPCID_TABLE = {}
        CloudData.SUMMON_RESULT_ESSENCE_TABLE = {}
        CloudData.SUMMON_RESULT_NPCID_TABLE[1] = newNpcId
        CloudData.SUMMON_RESULT_ESSENCE_TABLE[1] = essenceNum

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/lottery/peach/single",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

function AlertConnection:summonPeach10()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        CloudData.SUMMON_RESULT_NPCID_TABLE = {}
        CloudData.SUMMON_RESULT_ESSENCE_TABLE = {}
        for i = 1, 10 do
            local newNpcId = jsonTable.data.npcs[i].npcId
            local essenceNum = jsonTable.data.npcs[i].essenceNum
            CloudData.SUMMON_RESULT_NPCID_TABLE[i] = newNpcId
            CloudData.SUMMON_RESULT_ESSENCE_TABLE[i] = essenceNum
        end
        CompatTrace.log("summon", "peach ten npcs=" .. table.concat(CloudData.SUMMON_RESULT_NPCID_TABLE, ","))

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/lottery/peach/continue",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

-- shop init info
function AlertConnection:shopInit()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        CloudData.SHOP_INFO = json.decode(request:getResponseString())
        dump(CloudData.SHOP_INFO)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/shop/list",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- shop refresh
function AlertConnection:shopRefresh()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        --print( request:getResponseString() )
        CloudData.SHOP_INFO = json.decode(request:getResponseString())

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/shop/refresh",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- shop buy
function AlertConnection:shopBuy()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())

        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/shop/buy",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("index",self.index_)

    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end




--************************* NEW SHOP **************************************
-- shop init info 1
function AlertConnection:shopInit1()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        CloudData.SHOP_INFO_1 = json.decode(request:getResponseString())
        dump(CloudData.SHOP_INFO_1)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/shop/goodlist",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- shop refresh 1
function AlertConnection:shopRefresh1()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        --print( request:getResponseString() )
        CloudData.SHOP_INFO_1 = json.decode(request:getResponseString())

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/shop/refreshnew",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- shop buy 1
function AlertConnection:shopBuy1()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/shop/buynew",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("index",self.index_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- shop buy item !!! NEWLY ADDED!!!! 商店分页2
function AlertConnection:shopBuyItem()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/shop/commonbuy",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("id",self.id_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end



-- shop buy EXP !!! NEWLY ADDED!!!! 商店分页3
function AlertConnection:shopBuyExp()

    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/shop/buyexp",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("id",self.id_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end





-- buy exp
function AlertConnection:buyExp()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/account/buyexp",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("num",self.num_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

-- GUIDE
function AlertConnection:guide()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        --table.insert( CloudData.GUIDE_INFO, self.step_ )

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/account/guide",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("step",self.step_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- upgrade property
function AlertConnection:upgradeProperty()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/account/upgradetower",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("id",self.id_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- SIGN INFO INIT
function AlertConnection:signInfoInit()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        CloudData.SIGN_INFO = jsonTable
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/sign/gift",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


-- SIGN TODAY
function AlertConnection:signToday()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/sign/today",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

-- 更新检查
function AlertConnection:checkUpdateInfo()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500 ")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        dump(jsonTable)

        GameManager.V = jsonTable.v
        GameManager.P = jsonTable.p
        GameManager.SIZE_TABLE = jsonTable.sz
        GameManager.R = jsonTable.r
        GameManager.FC = jsonTable.fc
        --print("AlertConnection--GameManager.FC" .. GameManager.FC)

        self.isConnectionSucceed_ = true
    end

--    local url = string.format("http://125.88.152.25/dbxy/update.html") --正式更新服 1.0.x
--    local url = string.format("http://125.88.152.25/dbxy/update2.html") --测试更新服 
--    local url = string.format("http://125.88.152.25/dbxy/update_1_1_x_inner.html") --测试更新服 1.1.x
    local url = string.format("http://%s/dbxy/update_1_1_x.html",GameManager.ACCOUNT_SERVER_IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "GET")
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--服务器维修消息
function AlertConnection:serverMaintain()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功

        print( request:getResponseString() )
        CloudData.SERVER_MSG = json.decode(request:getResponseString())
        dump(CloudData.SERVER_MSG)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/msg/notice",GameManager.MSG_SERVER_IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--即时刷新信箱
function AlertConnection:refreshMail()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功

        --print( request:getResponseString() )
        CloudData.SERVER_MSG = json.decode(request:getResponseString()).data.msg
        dump(CloudData.SERVER_MSG)

        --限时充值界面是否显示
        CloudData.SHOW_LIMITED_TIME_RECHARGE = tonumber(json.decode(request:getResponseString()).data.charge10Status)
        print("CloudData.SHOW_LIMITED_TIME_RECHARGE = " .. CloudData.SHOW_LIMITED_TIME_RECHARGE)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/msg/list",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--获取服务器维修的补偿
function AlertConnection:getSMaintainCompensation()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功
        print( request:getResponseString() )
        local jsonTable = json.decode(request:getResponseString())
        if tonumber(jsonTable.errorCode) == 0 then
            CloudData.COMPENSATION_GET_STATION = nil
        else
            CloudData.COMPENSATION_GET_STATION = jsonTable.errorMsg
        end

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/msg/draw",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("msgId",self.msgId_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


--获取排行榜信息
function AlertConnection:getChartInfo()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response).data
        local tab = jsonTable.rank
        dump(tab)

        CloudData.CHART_REFRESH_INTERVAL = tonumber(jsonTable.refreshInterval)
        CloudData.CHART_MYRANK = tonumber(jsonTable.myrank)
               
        if self.pageNum_ == 1 then
        	CloudData.CHART_TABLE = tab
        else
            local num = #CloudData.CHART_TABLE
            table.insertto(CloudData.CHART_TABLE, tab)
        end
        
                              
        self.isConnectionSucceed_ = true
    end
    
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/stage/towerrank",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("page",self.pageNum_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--修改昵称
function AlertConnection:changeNickName()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        
        --请求成功
        local response = request:getResponseString()
        local jsonTable = json.decode(response)
        dump(jsonTable)

        -- 根据返回信息判断用户名
        CloudData.CHANGE_NICKNAME_ERRORCODE = jsonTable.errorCode

        -- 错误信息提示
        CloudData.CHANGE_NICKNAME_ERRORMSG  = jsonTable.errorMsg

        -- 校正蟠桃数
        CloudData.PEACH = jsonTable.data.peach
        
        self.isConnectionSucceed_ = true
    end
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/account/updatenick",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    request:addPOSTValue("nick",self.nickName_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--公告
function AlertConnection:noticeInit()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        CloudData.NOTICE_INFO = json.decode(response).data
    --    dump(CloudData.NOTICE_INFO)
                             
        self.isConnectionSucceed_ = true
    end
    
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/notice/list",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--修改账户和密码
function AlertConnection:changeAccount()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")
            return
        end
        --请求成功
        local response = request:getResponseString()
        dump(json.decode(response))

        --print("uid" .. CloudData.UID)

        local tip = json.decode(response).errorMsg
        if tip == nil or tip == "" then
            CloudData.CHANGE_ACCOUNT_TIP = nil
        else
            CloudData.CHANGE_ACCOUNT_TIP = tip
        end 
                             
        self.isConnectionSucceed_ = true
    end
    
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = string.format("http://%s/user/updatepassword",GameManager.ACCOUNT_SERVER_IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    --CloudData.TOKEN = "6238013c-0789-4078-95d8-8f40a236e76d"
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    --CloudData.UID = 622
    --request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("userName",self.AccountName_)
    request:addPOSTValue("password",self.AccountPWord_)
    request:addPOSTValue("oldUserName",self.LastName_)
    request:addPOSTValue("oldPassword",self.LastPWord_)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--QQ服务器维修消息
function AlertConnection:serverMaintainQQ()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功

        print( request:getResponseString() )
        CloudData.SERVER_MSG = json.decode(request:getResponseString())
        dump(CloudData.SERVER_MSG)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/sysmsg/qq",GameManager.MSG_SERVER_IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--IOS服务器维修消息
function AlertConnection:serverMaintainIOS()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功

        print( request:getResponseString() )
        CloudData.SERVER_MSG = json.decode(request:getResponseString())
        dump(CloudData.SERVER_MSG)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/sysmsg/apple",GameManager.MSG_SERVER_IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--安卓服务器维修消息
function AlertConnection:serverMaintainANDROID()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功

        print( request:getResponseString() )
        CloudData.SERVER_MSG = json.decode(request:getResponseString())
        dump(CloudData.SERVER_MSG)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/sysmsg/android",GameManager.MSG_SERVER_IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--获取开服信息
function AlertConnection:getServersInfo()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功

        print( request:getResponseString() )
        CloudData.SERVERS_TABLE = json.decode(request:getResponseString()).data
        dump(CloudData.SERVERS_TABLE)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/region/list",GameManager.ACCOUNT_SERVER_IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--创建新角色
function AlertConnection:getPlayerInfo()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功

        -- print( request:getResponseString() )
        -- local jsonTable = json.decode(request:getResponseString()).data
        -- dump(jsonTable)
        local response = request:getResponseString()
        --print("ray .. "..response)
        self:parseLoginJsonToCloudData(response)

        print("登录CloudData.UID" .. CloudData.UID)
        print("登录GameManager.IP" .. GameManager.IP)

        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/account/playerInfoNew",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    print("登录服务器ID" .. CloudData.USER_SERVER_ID)
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

--修改队伍阵容
function AlertConnection:updateTeam()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            print("connecting...")   return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            print("err http 500")    return
        end
        --请求成功

        local response = request:getResponseString()
        print("updateTeam .. "..response)
       
        self.isConnectionSucceed_ = true
    end

    local url = string.format("http://%s/account/updateteam",GameManager.IP)
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    request:addPOSTValue("token",CloudData.TOKEN)
    request:addPOSTValue("sign",CloudData.SIGN)
    request:addPOSTValue("uid",CloudData.UID)
    request:addPOSTValue("team",self.mTeam)    
    request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end















function AlertConnection:loading()
    --背景
    self.bg_ = display.newSprite("connection/loading_bg.png",display.cx,display.cy):addTo(self)
    self.bg_:setVisible(false)

    local circle = display.newSprite("connection/loading.png",self.bg_:getContentSize().width/5,self.bg_:getContentSize().height/2):addTo(self.bg_)
    circle:runAction(cc.RepeatForever:create(cc.RotateBy:create(0.5,90)))

    --连接0.5s后都没有响应再出现界面
    self.bg_:runAction(transition.sequence({cc.DelayTime:create(1.5),cc.Show:create()}))

    --连接
    self:connectionInNewThread()

    --超时
    self:timeOutCountDown()
end


function AlertConnection:timeOutCountDown()
    if self.failTimes_ >= 2 then
        self:runAction(transition.sequence({cc.DelayTime:create(10.0),cc.CallFunc:create(function()
            -- error occured
            self:errorOccured()
        end)}))
    else
        self:runAction(transition.sequence({cc.DelayTime:create(10.0),cc.CallFunc:create(function()
            -- time out
            self:timeOut()
        end)}))
    end
end

function AlertConnection:timeOut()
    self.bg_:removeSelf()

    self.timeoutBg_ = display.newSprite("connection/timeout_bg.png",display.cx,display.cy):addTo(self)
    --重试按钮
    cc.ui.UIPushButton.new({normal = "connection/retry.png",pressed = "connection/retry1.png"})
        :onButtonClicked(function()
            self.failTimes_ = self.failTimes_ + 1
            self.timeoutBg_:removeSelf()
            self:loading()
        end)
        :align(display.CENTER,self.timeoutBg_:getContentSize().width * 0.5,self.timeoutBg_:getContentSize().height /4)
        :addTo(self.timeoutBg_)
end

function AlertConnection:errorOccured()
    self.bg_:removeSelf()

    self.timeoutBg_ = display.newSprite("connection/error_bg.png",display.cx,display.cy):addTo(self)
    --重试按钮
    cc.ui.UIPushButton.new({normal = "connection/restart.png",pressed = "connection/restart1.png"})
        :onButtonClicked(function()
            --require("app.MyApp").new():run()
            cc.Director:getInstance():endToLua()
            if device.platform == "windows" or device.platform == "mac" or device.platform == "ios" then
                os.exit()
            end
        end)
        :align(display.CENTER,self.timeoutBg_:getContentSize().width * 0.5,self.timeoutBg_:getContentSize().height /4)
        :addTo(self.timeoutBg_)
end

function AlertConnection:closeDialog()
    if self.cb then
        self.cb()
    end
    self:removeSelf()
end


--解析引导步骤完成否
function AlertConnection:parseGuideStep( data )

    if json.decode(data) then

        CloudData.GUIDE_INFO = json.decode(data)
        if table.indexof(CloudData.GUIDE_INFO,"g1") then CloudData.GUIDE_STEP_STAGE0_1 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g2") then CloudData.GUIDE_STEP_STAGE0_2 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g3") then CloudData.GUIDE_STEP_STAGE0_3 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g4") then CloudData.GUIDE_STEP_SELECT_CHAPTER = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g5") then CloudData.GUIDE_STEP_GAME_START = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g6") then CloudData.GUIDE_STEP_SWIPE = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g7") then CloudData.GUIDE_STEP_MAKE_BUDDHA = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g8") then CloudData.GUIDE_STEP_UPGRADE_SPIRIT = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g9") then CloudData.GUIDE_STEP_FIRE = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g10") then CloudData.GUIDE_STEP_ENTER_TEAMSCENE = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g11") then CloudData.GUIDE_STEP_TIANJIANG_ON_TEAM = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g12") then CloudData.GUIDE_STEP_SCREEN_ZOOM = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g13") then CloudData.GUIDE_STEP_ENTER_UPGRADESCENE = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g14") then CloudData.GUIDE_STEP_UPGRADE_BUDDHA = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g15") then CloudData.GUIDE_STEP_UPGRADE_PROPERTY = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g16") then CloudData.GUIDE_STEP_ENTER_SUMMONSCENE = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g17") then CloudData.GUIDE_STEP_SUMMON1 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g18") then CloudData.GUIDE_STEP_SUMMON2 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g19") then CloudData.GUIDE_STEP_SHASENG_ON_TEAM = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g20") then CloudData.GUIDE_STEP_ENTER_TREASURESCENE = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g21") then CloudData.GUIDE_STEP_TREASURE1 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g22") then CloudData.GUIDE_STEP_TREASURE2 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g23") then CloudData.GUIDE_STEP_OPEN_ACHIEVEMENT = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g24") then CloudData.GUIDE_STEP_ACHIEVEMENT = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g25") then CloudData.GUIDE_STEP_UNLOCK_MONSTER1 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g26") then CloudData.GUIDE_STEP_UNLOCK_MONSTER2 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g27") then CloudData.GUIDE_STEP_UNLOCK_MONSTER3 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g28") then CloudData.GUIDE_STEP_LOSE_TIP1 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g29") then CloudData.GUIDE_STEP_LOSE_TIP2 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g30") then CloudData.GUIDE_STEP_ITEM1 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g31") then CloudData.GUIDE_STEP_ITEM2 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g32") then CloudData.GUIDE_STEP_DAILY = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"g33") then CloudData.GUIDE_STEP_CHALLENGE = 1 end

        --剧情对话
        if table.indexof(CloudData.GUIDE_INFO,"d1") then CloudData.DIALOGUE_STAGE0_1 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"d2") then CloudData.DIALOGUE_STAGE0_2 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"d3") then CloudData.DIALOGUE_STAGE0_3 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"d4") then CloudData.DIALOGUE_STAGE0_4 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"d5") then CloudData.DIALOGUE_STAGE0_5 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"d6") then CloudData.DIALOGUE_STAGE0_6 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"d7") then CloudData.DIALOGUE_STAGE0_7 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"d8") then CloudData.DIALOGUE_STAGE0_8 = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"d9") then CloudData.DIALOGUE_TIANJIANG_UNLOCK = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"d10") then CloudData.DIALOGUE_UPGRADE = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"d11") then CloudData.DIALOGUE_TREASURE = 1 end


        --道具
        if table.indexof(CloudData.GUIDE_INFO,"item1") then CloudData.ITEM1_UNLOCK = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"item2") then CloudData.ITEM2_UNLOCK = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"item3") then CloudData.ITEM3_UNLOCK = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"item4") then CloudData.ITEM4_UNLOCK = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"item5") then CloudData.ITEM5_UNLOCK = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"item6") then CloudData.ITEM6_UNLOCK = 1 end

        --章节解锁动画
        if table.indexof(CloudData.GUIDE_INFO,"c2") then CloudData.CHAPTER_UNLOCK_ANIMATION_PLAYED[2] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"c3") then CloudData.CHAPTER_UNLOCK_ANIMATION_PLAYED[3] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"c4") then CloudData.CHAPTER_UNLOCK_ANIMATION_PLAYED[4] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"c5") then CloudData.CHAPTER_UNLOCK_ANIMATION_PLAYED[5] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"c6") then CloudData.CHAPTER_UNLOCK_ANIMATION_PLAYED[6] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"c7") then CloudData.CHAPTER_UNLOCK_ANIMATION_PLAYED[7] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"c8") then CloudData.CHAPTER_UNLOCK_ANIMATION_PLAYED[8] = 1 end

        --场景入口解锁动画
        if table.indexof(CloudData.GUIDE_INFO,"s1") then CloudData.SCENE_UNLOCK_ANIMATION_PLAYED[1] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"s2") then CloudData.SCENE_UNLOCK_ANIMATION_PLAYED[2] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"s3") then CloudData.SCENE_UNLOCK_ANIMATION_PLAYED[3] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"s4") then CloudData.SCENE_UNLOCK_ANIMATION_PLAYED[4] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"s5") then CloudData.SCENE_UNLOCK_ANIMATION_PLAYED[5] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"s6") then CloudData.SCENE_UNLOCK_ANIMATION_PLAYED[6] = 1 end

        --宝物是否收集完全
        if table.indexof(CloudData.GUIDE_INFO,"ts1") then CloudData.IS_TREASURE_EFFECTIVE[1] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"ts2") then CloudData.IS_TREASURE_EFFECTIVE[2] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"ts3") then CloudData.IS_TREASURE_EFFECTIVE[3] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"ts4") then CloudData.IS_TREASURE_EFFECTIVE[4] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"ts5") then CloudData.IS_TREASURE_EFFECTIVE[5] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"ts6") then CloudData.IS_TREASURE_EFFECTIVE[6] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"ts7") then CloudData.IS_TREASURE_EFFECTIVE[7] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"ts8") then CloudData.IS_TREASURE_EFFECTIVE[8] = 1 end

        --宝物收集完全时解锁动画
        if table.indexof(CloudData.GUIDE_INFO,"t1") then CloudData.TREASURE_UNLOCK_ANIMATION_PLAYED[1] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"t2") then CloudData.TREASURE_UNLOCK_ANIMATION_PLAYED[2] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"t3") then CloudData.TREASURE_UNLOCK_ANIMATION_PLAYED[3] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"t4") then CloudData.TREASURE_UNLOCK_ANIMATION_PLAYED[4] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"t5") then CloudData.TREASURE_UNLOCK_ANIMATION_PLAYED[5] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"t6") then CloudData.TREASURE_UNLOCK_ANIMATION_PLAYED[6] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"t7") then CloudData.TREASURE_UNLOCK_ANIMATION_PLAYED[7] = 1 end

        if table.indexof(CloudData.GUIDE_INFO,"t8") then CloudData.TREASURE_UNLOCK_ANIMATION_PLAYED[8] = 1 end

        --开场漫画
        if table.indexof(CloudData.GUIDE_INFO,"oc") then CloudData.OPENNING_COMIC_PLAYED = 1 end

    end
end



--解析登录json
function AlertConnection:parseNewBriefLoginJson( jsondata )
    if json.decode(jsondata) then
        local jsonValue = json.decode(jsondata)
        dump(jsonValue)

        print("err code " .. jsonValue.errorCode)
        print("err msg " .. jsonValue.errorMsg)

        if CloudData.CHECK_ACCOUNT_ONLY == true then 
            local tip = jsonValue.errorMsg
            if tip == nil or tip == "" then
                CloudData.CHANGE_ACCOUNT_TIP = nil
            else
                CloudData.CHANGE_ACCOUNT_TIP = tip
            end
            return 
        end

        CloudData.SERVERS_TABLE = jsonValue.data.regions 
        dump(CloudData.SERVERS_TABLE)
        CloudData.REGIONS = jsonValue.data.user.regions or ""
        CloudData.TOKEN = jsonValue.data.user.token or ""
        CloudData.UID = jsonValue.data.user.uid
    end
end

--解析登录json
function AlertConnection:parseLoginJsonToCloudData( jsondata )
    if json.decode(jsondata) then

        local jsonValue = json.decode(jsondata)
        dump(jsonValue)

        print("err code " .. jsonValue.errorCode)
        print("err msg " .. jsonValue.errorMsg)
               
        print("-----------------------------------")
        --dump(jsonValue.data)

        --CloudData.SERVERS_TABLE = jsonValue.data

--        CloudData.ACCOUNT_VALID = jsonValue.data.valid=="1"
--        print("valid "..jsonValue.data.valid)
        --CloudData.TOKEN = jsonValue.data.token
        --print("token " .. jsonValue.data.token)
        CloudData.UID = jsonValue.data.uid
        print("uid " .. jsonValue.data.uid)
        
        local team = json.decode(jsonValue.data.team)  --jiexijson.decode
        --dump(team, "xiaoning***")
        if team == nil or #team == 0 then 
            team = {1}
        end
        DataUtils.setBuddhaTableOnTeam(team)
        

        CloudData.CHALLENGE_PROGRESS = jsonValue.data.challegeStageId
        print("challenge progress "..jsonValue.data.challegeStageId)
        CloudData.DAY_OF_WEEK = jsonValue.data.dayOfWeek
        print("dayOfWeek "..jsonValue.data.dayOfWeek)
        CloudData.DIARY_NUM_LEFT = jsonValue.data.dailyStageAvailableNum
        print("diary num left "..jsonValue.data.dailyStageAvailableNum)


        CloudData.EXP = jsonValue.data.expNum
        print("exp " .. jsonValue.data.expNum)
        CloudData.PEACH = jsonValue.data.peachNum
        print("peachNum " .. jsonValue.data.peachNum)
        CloudData.STAGE_PROGRESS = jsonValue.data.reachStageId
        print("reachStageId " .. jsonValue.data.reachStageId)
        CloudData.GINSENG_FRUIT = jsonValue.data.ginsen
        print("ginsen " .. jsonValue.data.ginsen)
        print("buyExpNum " .. jsonValue.data.buyExpNum)
        CloudData.BUY_EXP_NUM = jsonValue.data.buyExpNum
        print("chapterTime " .. jsonValue.data.chapterTime)
        print("costMoney " .. jsonValue.data.costMoney)
        CloudData.COST_MONEY = jsonValue.data.costMoney
        print("costPeach " .. jsonValue.data.costPeach)
        CloudData.COST_PEACH = jsonValue.data.costPeach
        print("createTime " .. jsonValue.data.createTime)
        CloudData.CREATE_TIME = jsonValue.data.createTime

        CloudData.ENERGY = jsonValue.data.energy
        print("energy " .. jsonValue.data.energy)
        CloudData.MAX_ENERGY = jsonValue.data.maxEnergy
        print("max energy " .. jsonValue.data.maxEnergy)
        CloudData.ESSENCE = jsonValue.data.essence
        print("essence " .. jsonValue.data.essence)
        print("failNum " .. jsonValue.data.failNum)
        CloudData.STAGE_FAIL_NUM = jsonValue.data.failNum
        print("freeNPCByPeachTime " .. jsonValue.data.freeNPCByPeachTime)
        print("freeNpcNum " .. jsonValue.data.freeNpcNum)
        print("freeNpcTime " .. jsonValue.data.freeNpcTime)

        CloudData.TEAM_UNLOCKGRID_NUM = jsonValue.data.memberNumBattle
        print("memberNumBattle " .. jsonValue.data.memberNumBattle)

        print("payGiftStatus " .. jsonValue.data.payGiftStatus)
        CloudData.FIRST_PURCHASE_STATE = jsonValue.data.payGiftStatus

        print("shareNum " .. jsonValue.data.shareNum)
        print("signTotalNum " .. jsonValue.data.signTotalNum)
        CloudData.SIGN_TOTAL_NUM = jsonValue.data.signTotalNum
        print("signWeekNum " .. jsonValue.data.signWeekNum)
        CloudData.SIGN_WEEK_NUM = jsonValue.data.signWeekNum
        print("signedToday ")
        CloudData.IS_SIGNED_TODAY = jsonValue.data.signedToday
        print(jsonValue.data.signedToday)
        CloudData.SWEEP = jsonValue.data.sweepNum
        print("sweepNum " .. jsonValue.data.sweepNum)
        print("guest " .. 0)
        print("expiry " .. jsonValue.data.expiry)
        print("channelId " .. jsonValue.data.channelId)
--        print("password " .. jsonValue.data.password)
        
        print("username " .. jsonValue.data.username)
        CloudData.USERNAME = jsonValue.data.username

        CloudData.DRAW_NUM = jsonValue.data.drawNum
        print("drawNum " .. jsonValue.data.drawNum)

        CloudData.NICK_NAME = jsonValue.data.nick or ""
        print("nickname " .. CloudData.NICK_NAME)

        CloudData.INFINITE_STAGE_PROGRESS = jsonValue.data.reachTowerLevel
        print("reachTowerLevel " .. CloudData.INFINITE_STAGE_PROGRESS)

        CloudData.INFINITE_WAVES_PROGRESS = jsonValue.data.reachTowerWave
        print("reachTowerWave " .. CloudData.INFINITE_WAVES_PROGRESS)

        -- 活动奖励的代币
        CloudData.ACTIVITY_COINS = jsonValue.data.coin or 0
        print("coin " .. CloudData.ACTIVITY_COINS)

        -- 服务器时间与本地时间的时间差 
        CloudData.DELTA_TIME = jsonValue.time - os.time()   
        print("CloudData.DELTA_TIME " .. CloudData.DELTA_TIME)

        --引导存储
        --print("guide " .. jsonValue.data.guide)
        self:parseGuideStep(jsonValue.data.guide)


        --存储怪物碎片fragmentList
        --初始化CloudData中的table，给合适的长度
        for i = 1,50 do
            CloudData.MONSTER_PIECE_INFO[i] = 0
        end

        --dump(jsonValue.data.fragmentList)
        for i,v in pairs(jsonValue.data.fragmentList) do
            local monsterPieceId = 0
            local monsterPieceNum = 0
            for j,w in pairs(v) do
                --print(i .. "  :  " .. j .. "__" .. w)
                if j == "fragmentId" then
                    monsterPieceId = w
                elseif j == "fragementNum" then
                    monsterPieceNum = w
                end
            end
            CloudData.MONSTER_PIECE_INFO[monsterPieceId] = monsterPieceNum
        end



        --存储 战斗界面技能道具 items
        --初始化CloudData中的table，给合适的长度
        for i = 1,6 do
            CloudData.SKILL_ITEM_INFO[i] = 0
        end
        --dump(jsonValue.data.items)
        for i,v in pairs(jsonValue.data.items) do
            CloudData.SKILL_ITEM_INFO[i] = v
        end



        --存储npcList
        --初始化CloudData中的table，给合适的长度
        for i = 1,111 do
            CloudData.NPC_INFO[i] = { isActive = 0, addlevel = 0, level = 0, npcId = 0, status = 0 }
        end

    --    dump(jsonValue.data.npcList)

        for i,v in pairs(jsonValue.data.npcList) do
            local npcId = 0
            for j,w in pairs(v) do
                --print(i .. "  :  " .. j .. "__" .. w)
                if j == "npcId" then
                    npcId = w
                end
            end
            CloudData.NPC_INFO[npcId] = v
        end


        --存储treasureList
        --初始化CloudData中的table，给合适的长度
        for i = 1,80 do
            CloudData.TREASURE_PIECE_INFO[i] = 0
        end
       
        --dump(jsonValue.data.treasureList)
        for i,v in pairs(jsonValue.data.treasureList) do
            local treasureId = 0
            local quality = 0
            for j,w in pairs(v) do
                --print(i .. "  :  " .. j .. "__" .. w)
                if j == "treasureId" then
                    treasureId = w
                elseif j == "quality" then
                    quality = w
                end
            end
            CloudData.TREASURE_PIECE_INFO[treasureId] = quality
        end



        --防御塔属性towerProperty
        --不需要初始化CloudData中的table了，固定字段名
        dump(jsonValue.data.towerProperty)
        CloudData.UPGRADE_PROPERTY_INFO[1] = jsonValue.data.towerProperty["comprehension"]          --1.悟性提高
        CloudData.UPGRADE_PROPERTY_INFO[2] = jsonValue.data.towerProperty["mirrorPowerLevel"]       --2.照妖镜威力
        CloudData.UPGRADE_PROPERTY_INFO[3] = jsonValue.data.towerProperty["mirrorRecoverLevel"]     --3.照妖镜冷却
        CloudData.UPGRADE_PROPERTY_INFO[4] = jsonValue.data.towerProperty["mirrorRange"]            --4.照妖镜射程
        CloudData.UPGRADE_PROPERTY_INFO[5] = jsonValue.data.towerProperty["spiritGatherSpeed"]      --5.灵气收集效率
        CloudData.UPGRADE_PROPERTY_INFO[6] = jsonValue.data.towerProperty["spiritStorage"]          --6.灵气存储扩容
        CloudData.UPGRADE_PROPERTY_INFO[7] = jsonValue.data.towerProperty["towerHP"]                --7.宝塔血量
        CloudData.UPGRADE_PROPERTY_INFO[8] = jsonValue.data.towerProperty["buddhaRecoverLevel"]     --8.神仙召唤冷却
        CloudData.UPGRADE_PROPERTY_INFO[9] = jsonValue.data.towerProperty["spiritCultivateSpeed"]   --9.炼妖效率
        CloudData.UPGRADE_PROPERTY_INFO[10] = jsonValue.data.towerProperty["energyStorage"]         --10.精力上限增加



        --成就achievementList
        --初始化CloudData中的table，给合适的长度
        for i = 1, 14 do
            CloudData.ACHIEVEMENT_INFO[i] = 0
        end
       
        --dump(jsonValue.data.achievementList) 
        for i,v in pairs(jsonValue.data.achievementList) do
            local achievementId = 0
            local progress = 0
            for j,w in pairs(v) do
                --print(i .. "  :  " .. j .. "__" .. w)
                if j == "achievementId" then
                    achievementId = w
                elseif j == "progress" then
                    progress = w
                end
            end
            CloudData.ACHIEVEMENT_INFO[achievementId] = progress
        end

        --dump(CloudData.ACHIEVEMENT_INFO)
        -- Restore the account-local resource snapshot after the server record
        -- has been decoded. This keeps EXP/peach/essence stable when an old
        -- or compatibility server returns its initial values on each login.
        if DataUtils.restoreResourceSnapshot ~= nil then
            DataUtils.restoreResourceSnapshot()
        end
        CloudData.PLAYER_DATA_READY = true
        if DataUtils.saveResourceSnapshot ~= nil then
            DataUtils.saveResourceSnapshot()
        end
        local npcCount = 0
        for _ in pairs(CloudData.NPC_INFO or {}) do npcCount = npcCount + 1 end
        CompatTrace.log("persistence", string.format("player data ready uid=%s exp=%s peach=%s essence=%s npc=%d",
            tostring(CloudData.UID), tostring(CloudData.EXP), tostring(CloudData.PEACH),
            tostring(CloudData.ESSENCE), npcCount))
    end
end


return AlertConnection

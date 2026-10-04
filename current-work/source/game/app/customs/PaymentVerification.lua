-- 延迟支付验证, 移动MM, 联通WO
-- 规则，验证三次，2，4，10
PaymentVerification = {}
PaymentVerification = class("PaymentVerification")
PaymentVerification.__index = PaymentVerification

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

-- 成员函数
function PaymentVerification.create()
    local obj = PaymentVerification.new()
    obj:init()
    return obj
end

local instance = nil
function PaymentVerification.getInstance()
    if(instance==nil) then
        instance = PaymentVerification.create()
    end

    return instance
end

-- 初始化
function PaymentVerification:init()
end

PaymentVerification.DELAY_TIMES = {10,10,10,10,10,10,10,10,5,2}

-- 验证移动支付
function PaymentVerification:checkInMM(params)

    local paySuccess = false
    function StartCheckIn()
        -- 检验次数
        params.times = params.times - 1
        if params.times<=0 then
            return
        end

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

            print("times: "..params.times)

            --请求成功
            local response = request:getResponseString()
            local jsonTable = json.decode(response)
            dump(jsonTable)

            -- 缺省设置支付失败
            paySuccess = false

            -- 支付是否成功
            if(jsonTable.data>0) then
                paySuccess = true
                -- 记录
                if params.type == 1 then -- 正常支付
                    self:record1(params)
                elseif params.type == 2 then -- 复活
                    self:record2(params)
                elseif params.type == 3 then -- 道具
                    self:record3(params)
                end                
            else
                -- 再次验证
                scheduler.performWithDelayGlobal(StartCheckIn, PaymentVerification.DELAY_TIMES[params.times])
            end
        end
        -- 创建一个请求，并以 POST 方式发送数据到服务端
        local url = string.format("http://%s/order/status",GameManager.IP)
        local request = network.createHTTPRequest(onRequestFinished, url, "POST")
        local strAppSecret ="AFDASDFA47#$%@568%^076"
        local strSign = string.format("%s&orderId=%s&token=%s&uid=%s",
            strAppSecret.."",
            params.BILLNO.."",
            CloudData.TOKEN.."",
            CloudData.UID.."")
        CloudData.SIGN = crypto.md5(strSign, false)

        request:addPOSTValue("token",CloudData.TOKEN)
        request:addPOSTValue("sign",CloudData.SIGN) -- 添加签名
        request:addPOSTValue("uid",CloudData.UID)
        request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
        request:addPOSTValue("orderId",params.BILLNO) -- 订单号
        -- 开始请求。当请求完成时会调用 callback() 函数
        request:start()
    end

    StartCheckIn()
end

-- dataEye记录,正常支付
function PaymentVerification:record1(params)
    local ID = params.ID
    local STAGE_PROGRESS = params.STAGE_PROGRESS
    local BILLNO = params.BILLNO
    local MONEY = params.MONEY
    local PEACH = params.PEACH

    --DataEye统计
    if USE_DATAEYE then
        DCEvent.onEvent("payment_index_"..ID .."_at_stage_progress_" ..STAGE_PROGRESS)
    end

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
        DCVirtualCurrency.paymentSuccess(BILLNO.."", MONEY,"CNY",paymentType)
    end
end

-- DataEye记录，复活
function PaymentVerification:record2(params)
    local ID = params.ID
    local STAGE_PROGRESS = params.STAGE_PROGRESS
    local BILLNO = params.BILLNO
    local MONEY = params.MONEY

    --DataEye统计
    if USE_DATAEYE then
        DCEvent.onEvent("payment_index_"..ID .."_at_stage_progress_" ..STAGE_PROGRESS)
    end

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
        DCVirtualCurrency.paymentSuccess(BILLNO.."", MONEY,"CNY",paymentType)
    end
end

-- DataEye记录,战斗中道具使用
function PaymentVerification:record3(params)
    local BILLNO = params.BILLNO
    local MONEY = params.MONEY
    local ID = params.ID
    local STAGE_PROGRESS = params.STAGE_PROGRESS

    local ITEM_PRICE_RMB = params.itemPriceRMB_
    local ITEM_ID = params.itemId_
    local ITEM_PRICE = params.itemPrice_

    if USE_DATAEYE then
        DCEvent.onEvent("payment_index_"..ID .."_at_stage_progress_" ..STAGE_PROGRESS)
    end

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
        DCVirtualCurrency.paymentSuccess(BILLNO.."", MONEY,"CNY",paymentType)
    end
end

-- 验证联通支付
function PaymentVerification:checkInWO(params)

    local paySuccess = false
    function StartCheckIn()
        -- 检验次数
        params.times = params.times - 1
        if params.times<=0 then
            return
        end

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

            print("times: "..params.times)

            --请求成功
            local response = request:getResponseString()
            local jsonTable = json.decode(response)
            dump(jsonTable)

            -- 缺省设置支付失败
            paySuccess = false

            -- 支付是否成功
            if(jsonTable.data>0) then
                paySuccess = true
                -- 记录
                if params.type == 1 then -- 正常支付
                    self:record1(params)
                elseif params.type == 2 then -- 复活
                    self:record2(params)
                elseif params.type == 3 then -- 道具
                    self:record3(params)
                end                
            else
                -- 再次验证
                scheduler.performWithDelayGlobal(StartCheckIn, PaymentVerification.DELAY_TIMES[params.times])
            end
        end
        -- 创建一个请求，并以 POST 方式发送数据到服务端
        local url = string.format("http://%s/order/status",GameManager.IP)
        local request = network.createHTTPRequest(onRequestFinished, url, "POST")
        local strAppSecret ="AFDASDFA47#$%@568%^076"
        local strSign = string.format("%s&orderId=%s&token=%s&uid=%s",
            strAppSecret.."",
            params.BILLNO.."",
            CloudData.TOKEN.."",
            CloudData.UID.."")
        CloudData.SIGN = crypto.md5(strSign, false)

        request:addPOSTValue("token",CloudData.TOKEN)
        request:addPOSTValue("sign",CloudData.SIGN) -- 添加签名
        request:addPOSTValue("uid",CloudData.UID)
        request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
        request:addPOSTValue("orderId",params.BILLNO) -- 订单号
        -- 开始请求。当请求完成时会调用 callback() 函数
        request:start()
    end

    StartCheckIn()
end

-- 验证电信支付
function PaymentVerification:checkInTele(params)
    local paySuccess = false
    function StartCheckIn()
        -- 检验次数
        params.times = params.times - 1
        if params.times<=0 then
            return
        end

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

            print("times: "..params.times)

            --请求成功
            local response = request:getResponseString()
            local jsonTable = json.decode(response)
            dump(jsonTable)

            -- 缺省设置支付失败
            paySuccess = false

            -- 支付是否成功
            if(jsonTable.data>0) then
                paySuccess = true
                -- 记录
                if params.type == 1 then -- 正常支付
                    self:record1(params)
                elseif params.type == 2 then -- 复活
                    self:record2(params)
                elseif params.type == 3 then -- 道具
                    self:record3(params)
                end                
            else
                -- 再次验证
                scheduler.performWithDelayGlobal(StartCheckIn, PaymentVerification.DELAY_TIMES[params.times])
            end
        end
        -- 创建一个请求，并以 POST 方式发送数据到服务端
        local url = string.format("http://%s/order/status",GameManager.IP)
        local request = network.createHTTPRequest(onRequestFinished, url, "POST")
        local strAppSecret ="AFDASDFA47#$%@568%^076"
        local strSign = string.format("%s&orderId=%s&token=%s&uid=%s",
            strAppSecret.."",
            params.BILLNO.."",
            CloudData.TOKEN.."",
            CloudData.UID.."")
        CloudData.SIGN = crypto.md5(strSign, false)

        request:addPOSTValue("token",CloudData.TOKEN)
        request:addPOSTValue("sign",CloudData.SIGN) -- 添加签名
        request:addPOSTValue("uid",CloudData.UID)
        request:addPOSTValue("regionId",CloudData.USER_SERVER_ID)
        request:addPOSTValue("orderId",params.BILLNO) -- 订单号
        -- 开始请求。当请求完成时会调用 callback() 函数
        request:start()
    end

    StartCheckIn()
end








require("app.kernel.GameEventDispatcher")

DataModel = {}
DataModel = class("DataModel")
DataModel.__index = DataModel

local instance
function DataModel.getInstance()
    if(instance==nil) then
        instance = DataModel.new()
        instance:init()
    end

    return instance
end

-- 初始化
function DataModel:init()
    self.m_cbs = {}
    self:register()
end

-- 注册回调
function DataModel:register()

    local cbs = {
--        -- 登录
--        [Protocol.RESPONSE_LOGIN_SUCCESS] = self.RESPONSE_LOGIN_SUCCESS,
--        [Protocol.RESPONSE_LOGIN_FAILED] = self.RESPONSE_LOGIN_FAILED,
--
--        -- 出兵
--        [Protocol.RESPONSE_TRAIN_SUCCESS] = self.RESPONSE_TRAIN_SUCCESS,
--        [Protocol.RESPONSE_TRAIN_FAILED] = self.RESPONSE_TRAIN_FAILED,
--        
--        -- 请求战斗结果
--        [Protocol.RESPONSE_FIGHT_RESULT_SUCCESS] = self.RESPONSE_FIGHT_RESULT_SUCCESS,
--        [Protocol.RESPONSE_FIGHT_RESULT_FAILED] = self.RESPONSE_FIGHT_RESULT_FAILED,
    }

    for protocol, callback in pairs(cbs) do
        self:registerHandler(protocol,callback)
    end
end

-- 注册处理器函数
function DataModel:registerHandler(protocol, callback)
    gg.netHandler:registerHandler(protocol, self)
    self.m_cbs[protocol] = callback
end

-- 网络事件回调函数
function DataModel:onNetEvent(protocol, obj)
    local func = self.m_cbs[protocol]
    if(func~=nil) then
        func(self, obj)
    else
        print("Protocol"..protocol.."Error")
    end
end


-- 测试登录
function DataModel:REQUEST_LOGIN(username, password)
    local obj = RequestLogin.new()
    obj.username = username
    obj.password = password

    USocket.getInstance():send(Protocol.REQUEST_LOGIN, obj)
end

-- 登录成功
function DataModel:RESPONSE_LOGIN_SUCCESS(obj)
    print("登录成功")
end

-- 登录失败
function DataModel:RESPONSE_LOGIN_FAILED(obj)
    print("登录失败")
end

-- 请求出兵
function DataModel:REQUEST_TRAIN(npcId)
    local obj = RequestTrain.new()
    obj.npcId = npcId 
    
    USocket.getInstance():send(Protocol.REQUEST_TRAIN, obj)
end

-- 请求出兵成功
function DataModel:RESPONSE_TRAIN_SUCCESS(obj)
    local uid = obj.uid
    local npcId = obj.npcId
    
    -- 发送战斗 出兵指令
    local evt = GameEvent.create(GameEventType.M2U_TRAIN)
    evt.data.uid = uid
    evt.data.npcId = npcId
    gg.gameEventDispatcher:dispatch(evt)
end

-- 请求出兵失败
function DataModel:RESPONSE_TRAIN_FAILED(obj)
    -- todo
end

-- 请求战斗结果
function DataModel:REQUEST_FIGHT_RESULT(result)
    local obj = RequestFightResult.new()
    obj.result = result
    
    USocket.getInstance().send(Protocol.REQUEST_FIGHT_RESULT, obj)
end

-- 请求战斗结果，成功
function DataModel:RESPONSE_FIGHT_RESULT_SUCCESS(obj)
    local result = obj.result -- 1:胜利,2:失败
    
    -- 战斗结果
    local evt = GameEvent.create(GameEventType.M2U_FIGHT_RESULT)
    evt.result = result
    gg.gameEventDispatcher:dispatch(evt)
    
end

-- 请求战斗结果，失败
function DataModel:RESPONSE_FIGHT_RESULT_FAILED(obj)
    -- todo
end


gg = gg or {}
gg.model = DataModel.getInstance()






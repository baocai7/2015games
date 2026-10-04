-- GameEventType
GameEventType = {}

-- --------------------------------------------------
-- 战斗事件

-- 出兵
GameEventType.M2U_TRAIN = "M2U_TRAIN"

-- 战斗结果
GameEventType.M2U_FIGHT_RESULT = "M2U_FIGHT_RESULT"



--[[
local PVPGameScene = {}
PVPGameScene = class("PVPGameScene", function()
    return display.newScene("PVPGameScene")
end)

function PVPGameScene:ctor()
    self:init()
end

function PVPGameScene:init()
    -- 远程回调事件注册
    self.m_netFuncHash = {
        [Protocol.RESPONSE_PVP_LIST_SUCCESS] = self.RESPONSE_PVP_LIST_SUCCESS,
        [Protocol.RESPONSE_FIGHT_MATCH_SUCCESS] = self.RESPONSE_FIGHT_MATCH_SUCCESS,
        [Protocol.RESPONSE_FIGHT_READY_SUCCESS] = self.RESPONSE_FIGHT_READY_SUCCESS,
        [Protocol.RESPONSE_FIGHT_START_SUCCESS] = self.RESPONSE_FIGHT_START_SUCCESS,
        [Protocol.RESPONSE_TRAIN_SUCCESS] = self.RESPONSE_TRAIN_SUCCESS,
        [Protocol.RESPONSE_SEND_FIGHT_RESULT_SUCCESS] = self.RESPONSE_SEND_FIGHT_RESULT_SUCCESS,
        [Protocol.RESPONSE_FIGHT_RESULT_SUCCESS] = self.RESPONSE_FIGHT_RESULT_SUCCESS,
    }
end

function PVPGameScene:register()
    for type, func in pairs(self.m_netFuncHash) do
        self:registerNetEvnet(type, func)
    end
end

function PVPGameScene:unregister()
    for type, func in pairs(self.m_netFuncHash) do
        self:unregisterUIEvent(type)
    end
end

-- 注册网络事件
function PVPGameScene:registerNetEvnet(protocol, callback)
    -- 防止重复注册
    if(self.m_netFuncHash[protocol]==nil) then
        gg.netHandler:registerHandler(protocol, self)
    end
    self.m_netFuncHash[protocol] = callback
end

-- 注销网络事件
function PVPGameScene:unregisterNetEvent(protocol)
    self.m_netFuncHash[protocol] = nil
    gg.netHandler:unregisterHandler(protocol, self)
end

function PVPGameScene:onNetEvent(protocol, obj)
    local func = self.m_netFuncHash[protocol]
    if(func~=nil) then
        func(self, obj)
    end
end

-- 获取PVP列表处理
function PVPGameScene:RESPONSE_PVP_LIST_SUCCESS(obj)
end

-- 撮合成功,->加载资源
function PVPGameScene:RESPONSE_FIGHT_MATCH_SUCCESS(obj)
end

-- 加载完成,等待其它用户
function PVPGameScene:RESPONSE_FIGHT_READY_SUCCESS(obj)
end

-- 战斗真正开始
function PVPGameScene:RESPONSE_FIGHT_START_SUCCESS(obj)
end

-- 处理 出兵消息
function PVPGameScene:RESPONSE_TRAIN_SUCCESS(obj)
end

-- 处理 战斗结果消息
function PVPGameScene:RESPONSE_SEND_FIGHT_RESULT_SUCCESS(obj)
end


function PVPGameScene:onEnter()
    self:register()
end

function PVPGameScene:onExit()
    self:unregister()
end
]]








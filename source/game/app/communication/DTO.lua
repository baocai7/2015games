ResponseSuccess = {}
ResponseSuccess = class("ResponseSuccess")
ResponseSuccess.__index = ResponseSuccess

ResponseSuccess.result = nil

function ResponseSuccess:ctor(ver)
    ver = ver or 1
    self.result = 0
end

function ResponseSuccess:decode(buf,ver)
    self.result = buf:readInt()
end

function ResponseSuccess:encode(buf,ver)
    buf:writeInt(self.result)
end

ResponseFailed = {}
ResponseFailed = class("ResponseFailed")
ResponseFailed.__index = ResponseFailed

ResponseFailed.result = nil

function ResponseFailed:ctor(ver)
    ver = ver or 1
    self.result = 0
end

function ResponseFailed:decode(buf,ver)
    self.result = buf:readInt()
end

function ResponseFailed:encode(buf,ver)
    buf:writeInt(self.result)
end

RequestLogin = {}
RequestLogin = class("RequestLogin")
RequestLogin.__index = RequestLogin

RequestLogin.username = nil
RequestLogin.password = nil

function RequestLogin:ctor(ver)
    ver = ver or 1
    self.username = ""
    self.password = ""
end

function RequestLogin:decode(buf,ver)
    self.username = buf:readStringUShort()
    self.password = buf:readStringUShort()
end

function RequestLogin:encode(buf,ver)
    buf:writeStringUShort(self.username)
    buf:writeStringUShort(self.password)
end

RequestPVPList = {}
RequestPVPList = class("RequestPVPList")
RequestPVPList.__index = RequestPVPList


function RequestPVPList:ctor(ver)
    ver = ver or 1
end

function RequestPVPList:decode(buf,ver)
end

function RequestPVPList:encode(buf,ver)
end

PlayerInfo = {}
PlayerInfo = class("PlayerInfo")
PlayerInfo.__index = PlayerInfo


function PlayerInfo:ctor(ver)
    ver = ver or 1
end

function PlayerInfo:decode(buf,ver)
end

function PlayerInfo:encode(buf,ver)
end

ResponsePVPListSuccess = {}
ResponsePVPListSuccess = class("ResponsePVPListSuccess")
ResponsePVPListSuccess.__index = ResponsePVPListSuccess

ResponsePVPListSuccess.list = nil

function ResponsePVPListSuccess:ctor(ver)
    ver = ver or 1
    self.list = {} -- 【PlayerInfo】
end

function ResponsePVPListSuccess:decode(buf,ver)
    local len = buf:readShort()
    for i=1, len, 1 do
        local data = PlayerInfo.new(ver)
        data:decode(buf,ver)
        self.list[i] = data
    end
end

function ResponsePVPListSuccess:encode(buf,ver)
    local len = #self.list
    buf:writeShort(len)
    for i=1,len,1 do
        self.list[i]:encode(buf,ver)
    end
end

RequestFightMatch = {}
RequestFightMatch = class("RequestFightMatch")
RequestFightMatch.__index = RequestFightMatch


function RequestFightMatch:ctor(ver)
    ver = ver or 1
end

function RequestFightMatch:decode(buf,ver)
end

function RequestFightMatch:encode(buf,ver)
end

ResponseMatchSuccess = {}
ResponseMatchSuccess = class("ResponseMatchSuccess")
ResponseMatchSuccess.__index = ResponseMatchSuccess


function ResponseMatchSuccess:ctor(ver)
    ver = ver or 1
end

function ResponseMatchSuccess:decode(buf,ver)
end

function ResponseMatchSuccess:encode(buf,ver)
end

RequestFightReady = {}
RequestFightReady = class("RequestFightReady")
RequestFightReady.__index = RequestFightReady


function RequestFightReady:ctor(ver)
    ver = ver or 1
end

function RequestFightReady:decode(buf,ver)
end

function RequestFightReady:encode(buf,ver)
end

ResponseFightStartSuccess = {}
ResponseFightStartSuccess = class("ResponseFightStartSuccess")
ResponseFightStartSuccess.__index = ResponseFightStartSuccess


function ResponseFightStartSuccess:ctor(ver)
    ver = ver or 1
end

function ResponseFightStartSuccess:decode(buf,ver)
end

function ResponseFightStartSuccess:encode(buf,ver)
end

RequestTrain = {}
RequestTrain = class("RequestTrain")
RequestTrain.__index = RequestTrain

RequestTrain.npcId = nil

function RequestTrain:ctor(ver)
    ver = ver or 1
    self.npcId = 0
end

function RequestTrain:decode(buf,ver)
    self.npcId = buf:readInt()
end

function RequestTrain:encode(buf,ver)
    buf:writeInt(self.npcId)
end

ResponseTrainSuccess = {}
ResponseTrainSuccess = class("ResponseTrainSuccess")
ResponseTrainSuccess.__index = ResponseTrainSuccess

ResponseTrainSuccess.uid = nil
ResponseTrainSuccess.npcId = nil

function ResponseTrainSuccess:ctor(ver)
    ver = ver or 1
    self.uid = 0 -- 用户编号
    self.npcId = 0 -- npc编号
end

function ResponseTrainSuccess:decode(buf,ver)
    self.uid = buf:readInt()
    self.npcId = buf:readInt()
end

function ResponseTrainSuccess:encode(buf,ver)
    buf:writeInt(self.uid)
    buf:writeInt(self.npcId)
end

RequestSendFightResult = {}
RequestSendFightResult = class("RequestSendFightResult")
RequestSendFightResult.__index = RequestSendFightResult

RequestSendFightResult.result = nil

function RequestSendFightResult:ctor(ver)
    ver = ver or 1
    self.result = 0
end

function RequestSendFightResult:decode(buf,ver)
    self.result = buf:readInt()
end

function RequestSendFightResult:encode(buf,ver)
    buf:writeInt(self.result)
end

ResponseSendFightResultSuccess = {}
ResponseSendFightResultSuccess = class("ResponseSendFightResultSuccess")
ResponseSendFightResultSuccess.__index = ResponseSendFightResultSuccess

ResponseSendFightResultSuccess.result = nil

function ResponseSendFightResultSuccess:ctor(ver)
    ver = ver or 1
    self.result = 0
end

function ResponseSendFightResultSuccess:decode(buf,ver)
    self.result = buf:readInt()
end

function ResponseSendFightResultSuccess:encode(buf,ver)
    buf:writeInt(self.result)
end

RequestFightResult = {}
RequestFightResult = class("RequestFightResult")
RequestFightResult.__index = RequestFightResult


function RequestFightResult:ctor(ver)
    ver = ver or 1
end

function RequestFightResult:decode(buf,ver)
end

function RequestFightResult:encode(buf,ver)
end

ResponseFightResultSuccess = {}
ResponseFightResultSuccess = class("ResponseFightResultSuccess")
ResponseFightResultSuccess.__index = ResponseFightResultSuccess


function ResponseFightResultSuccess:ctor(ver)
    ver = ver or 1
end

function ResponseFightResultSuccess:decode(buf,ver)
end

function ResponseFightResultSuccess:encode(buf,ver)
end

-----------------------------------------------------------------
-- protocol object register
DataLayer.CACHE[Protocol.REQUEST_LOGIN] = RequestLogin
DataLayer.CACHE[Protocol.RESPONSE_LOGIN_SUCCESS] = ResponseSuccess
DataLayer.CACHE[Protocol.RESPONSE_LOGIN_FAILED] = ResponseFailed
DataLayer.CACHE[Protocol.REQUEST_PVP_LIST] = RequestPVPList
DataLayer.CACHE[Protocol.RESPONSE_PVP_LIST_SUCCESS] = ResponsePVPListSuccess
DataLayer.CACHE[Protocol.RESPONSE_PVP_LIST_FAILED] = ResponseFailed
DataLayer.CACHE[Protocol.REQUEST_FIGHT_MATCH] = RequestFightMatch
DataLayer.CACHE[Protocol.RESPONSE_FIGHT_MATCH_SUCCESS] = ResponseMatchSuccess
DataLayer.CACHE[Protocol.RESPONSE_FIGHT_MATCH_FAILED] = ResponseFailed
DataLayer.CACHE[Protocol.REQUEST_FIGHT_READY] = RequestFightReady
DataLayer.CACHE[Protocol.RESPONSE_FIGHT_READY_SUCCESS] = ResponseFightStartSuccess
DataLayer.CACHE[Protocol.RESPONSE_FIGHT_READY_FAILED] = ResponseFailed
DataLayer.CACHE[Protocol.RESPONSE_FIGHT_START_SUCCESS] = ResponseFightStartSuccess
DataLayer.CACHE[Protocol.RESPONSE_FIGHT_START_FAILED] = ResponseFailed
DataLayer.CACHE[Protocol.REQUEST_TRAIN] = RequestTrain
DataLayer.CACHE[Protocol.RESPONSE_TRAIN_SUCCESS] = ResponseTrainSuccess
DataLayer.CACHE[Protocol.RESPONSE_TRAIN_FAILED] = ResponseFailed
DataLayer.CACHE[Protocol.REQUEST_SEND_FIGHT_RESULT] = RequestSendFightResult
DataLayer.CACHE[Protocol.RESPONSE_SEND_FIGHT_RESULT_SUCCESS] = ResponseFightResultSuccess
DataLayer.CACHE[Protocol.RESPONSE_SEND_FIGHT_RESULT_FAILED] = ResponseFailed
DataLayer.CACHE[Protocol.REQUEST_FIGHT_RESULT] = RequestFightResult
DataLayer.CACHE[Protocol.RESPONSE_FIGHT_RESULT_SUCCESS] = ResponseFightResultSuccess
DataLayer.CACHE[Protocol.RESPONSE_FIGHT_RESULT_FAILED] = ResponseFailed

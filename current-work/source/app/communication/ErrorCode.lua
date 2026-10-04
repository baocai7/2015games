-- 服务器错误码 
ErrorCode = {}

-- 通用未知错误
ErrorCode.UNKNOWN_ERROR = 0x10000001

-- 网络协议错误,如链接后第一个应该是登录协议却发成了其他协议
ErrorCode.PROTOCOL_ERROR = 0x10000002

-- 数据包数据长度有误
ErrorCode.PACKAGE_SIZE_ERROR = 0x10000003
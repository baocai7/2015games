# 数据和网络清单

## 网络层

- HTTP 入口和逻辑服地址：`dygame/common/DYHttpMgr.lua`
- TCP 登录、心跳、收发包：`app/communication/SocketMgr.lua`
- 命令和响应映射：`app/communication/Protocol.lua`、`SocketHandler.lua`
- 数据分发：`app/communication/DataLayer.lua`
- 登录后的全局状态：`app/game/CloudData.lua`

`DYHttpMgr.setLogicURL(ip, port, base)` 动态生成逻辑服 URL；入口服返回的 IP、端口和 base 必须一起记录。不要只改客户端显示地址而忽略入口响应。

## 接口族

| 接口前缀 | 功能 |
| --- | --- |
| `/user` | 登录、用户初始化、章节、队伍、战斗数据 |
| `/pve` | 普通/精英/炼狱/爬塔/旅行关卡和战斗结果 |
| `/summon` | 伙伴召唤和十连 |
| `/lottery` | 抽奖初始化、抽取和记录 |
| `/payment` | 订单、支付校验、首充和奖励 |
| `/shop` | 商店购买和刷新 |
| `/sign`、`/daily` | 签到、任务和每日奖励 |
| `/pvp`、`/babel`、`/aggress` | PVP、爬塔和遇敌玩法 |

完整接口调用点见 `../analysis/endpoints-and-loader.txt`。

## 本地状态检查

资源、经验、蟠桃、蓝宝石和伙伴等级的读写应沿着 `CloudData` → 对应 model/profile → UI 更新链路检查。若退出后重置，优先确认：

1. 服务端响应是否包含最新值；
2. `DataLayer` 是否收到更新事件；
3. 本地缓存是否写入；
4. 下次登录是否被服务端初始化数据覆盖。

只在确认原版协议没有持久化需求时，才考虑增加本地缓存；本地缓存不能替代服务端权威数据。


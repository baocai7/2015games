# 模块索引

全树扫描范围：`../lua/decompiled/src/`，共 762 个 Lua 文件、约 7,786 个函数定义。

## 顶层模块

| 模块 | 文件数 | 责任 |
| --- | ---: | --- |
| `app` | 565 | 游戏业务、场景、战斗、UI、模型、配置 |
| `framework` | 81 | Cocos/Lua 基础框架、UI、网络、平台桥接 |
| `dygame` | 58 | HTTP、登录、支付、统计、资源和通用 UI |
| `cocos` | 38 | Cocos2d-x Lua 常量和运行时封装 |
| `DataEye` | 12 | 数据统计 SDK Lua 接口 |
| `demo` | 6 | 示例场景和本地化样例 |
| 根文件 | 2 | `main.lua`、`config.lua` |

## `app` 子模块

| 子模块 | 文件数 | 主要内容 |
| --- | ---: | --- |
| `profiles` | 117 | 角色、关卡、技能、物品和活动配置/数据表 |
| `layers` | 88 | 通用 UI、登录、关卡、商店、支付、召唤等界面 |
| `game` | 48 | 游戏状态、战斗流程、场景运行时 |
| `functions` | 41 | 数据转换、奖励、队伍和业务辅助函数 |
| `union` | 36 | 帮派/联盟功能 |
| `activity` | 31 | 活动、签到、棋盘、场景活动 |
| `sprites` | 30 | 角色、PVP、特效和显示组件 |
| `utils` | 14 | 资源、时间、字符串和通用工具 |
| `cimelia` | 13 | 法宝/装备技能和界面 |
| `communication` | 9 | Socket、协议、DTO、数据分发 |
| `aggress` | 9 | 遇敌/强敌玩法 |
| `pvponline` | 9 | 在线 PVP |
| `friend` | 8 | 好友、聊天和队伍协助 |
| `equipment` | 15 | 装备、升级、淬炼和背包 |
| `babel` | 14 | 爬塔玩法 |
| `component` | 11 | 战斗组件、血条、动画、塔技能 |
| `scenes` | 22 | 主场景、关卡、召唤、商店、PVP 等场景 |

## 修改优先级

1. 先看 `communication` + `dygame/common/DYHttpMgr.lua`，确认接口和返回数据。
2. 再看对应 `models`/`profiles`，确认数据字段和默认值。
3. 最后改 `layers`/`scenes`/`component`，避免只修 UI 而破坏状态机。
4. 涉及人物或特效时同步检查 `sprites`、`DYAnimator` 和资源索引。


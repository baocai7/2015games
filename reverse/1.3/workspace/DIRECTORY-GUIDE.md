# 逆向目录说明

本目录面向后续阅读和修改。路径均相对于 `reverse/1.3/workspace/`，原始 APK 和逆向产物不覆盖修改稿。

## 工作区文件

| 文件/目录 | 用途 |
| --- | --- |
| `README.md` | 工作约定和快速入口 |
| `APK-CONTENTS.md` | APK 版本、条目、资源和二进制清单 |
| `DIRECTORY-GUIDE.md` | 本文件；逐层说明源码目录职责 |
| `REVERSE-COVERAGE.md` | 已完成的逆向范围、方法和未还原边界 |
| `FILE-INDEX.md` / `lua-file-index.tsv` | 762 个 Lua 文件的逐文件索引 |
| `APK-ENTRY-INDEX.md` / `apk-entry-index.tsv` | APK 全部路径级内容索引 |
| `module-map.md` | Lua 模块数量和业务模块索引 |
| `entrypoints.md` | 启动、登录、关卡、战斗、召唤和支付链路 |
| `data-network.md` | HTTP、Socket、协议和数据模型 |
| `resource-audit.md` | 资源完整性、缺失骨骼和下载地址 |
| `change-guide.md` | 修改边界、回滚和打包注意事项 |
| `patches/` | 每次修改的补丁说明和验证记录 |
| `tests/` | 静态检查、接口回归和资源检查记录 |

## `../lua/`

| 路径 | 用途 |
| --- | --- |
| `../lua/src.zip` | APK 内 `assets/src.zip` 的原始副本，不修改 |
| `../lua/source/` | 解密后的 Lua 5.1 字节码和脚本随包资源，作为运行基线 |
| `../lua/decompiled/` | 字节码反编译出的可读近似 Lua，便于定位逻辑；不是原始源码 |

## `../lua/decompiled/src/` 模块

| 模块 | 责任 |
| --- | --- |
| `app/scenes/` | 启动、登录、主城、选关、召唤、商店和 PVP 场景 |
| `app/layers/` | 登录、章节、关卡详情、战斗结果、升级、签到、支付等 UI 层 |
| `app/game/` | 游戏场景、战斗管理器、战斗状态和在线战斗流程 |
| `app/sprites/` | 角色、敌人、塔、PVP 单位和显示组件 |
| `app/component/` | `DYAnimator`、战斗组件、血条、特效和塔技能 |
| `app/functions/` | 角色/敌人模型转换、关卡解析、奖励和队伍辅助函数 |
| `app/profiles/` | 角色、敌人、技能、关卡、装备、活动和掉落表 |
| `app/communication/` | Socket、协议、DTO、数据分发和连接处理 |
| `app/models/` | 业务模型和支付模型 |
| `app/utils/` | `GameManager`、资源、数据、时间和通用工具 |
| `app/equipment/` | 装备、升级、淬炼和背包 |
| `app/cimelia/` | 法宝和法宝技能 |
| `app/activity/` | 签到、活动、棋盘、节日和活动战斗 |
| `app/union/` | 帮派/联盟、帮派战和帮派数据 |
| `app/friend/` | 好友、聊天和协助队伍 |
| `app/babel/` | 爬塔/试炼玩法 |
| `app/aggress/` | 遇敌、强敌和相关战斗 |
| `app/pvponline/` | 在线 PVP |
| `app/icons/` | 章节、关卡、宝箱和入口图标 |
| `app/locale/` | 游戏文本和本地化 |
| `framework/` | Lua UI、显示、平台和兼容层 |
| `cocos/` | Cocos2d-x、CocosStudio、UI、网络和 Spine Lua 封装 |
| `dygame/common/` | 原生桥接、HTTP、登录、支付、统计和键值存储 |
| `dygame/utils/` | 下载、文件、设备、热更新和通用工具 |
| `dygame/ui/`、`dygame/units/` | SDK 通用 UI 和基础单位 |
| `DataEye/` | DataEye 统计 SDK 的 Lua 接口 |
| `demo/` | Demo/样例场景，不代表生产流程 |

## `../android-smali/`

这是 `classes.dex` 的 Smali 反汇编，不是 Java 源码。重点包如下：

| 包 | 责任 |
| --- | --- |
| `com/dygame/common/` | `DYGame`、`DYCommon`、HTTP、下载、登录、支付和 Lua 回调桥接 |
| `com/dygame/open/` | Dayu、支付宝、微信、百度和渠道 SDK 适配 |
| `com/alipay/`、`com/tencent/`、`com/baidu/`、`com/ut/` | 第三方 SDK 实现 |
| `org/cocos2dx/` | Cocos Android 启动和平台封装 |
| `android/`、`org/json/`、`org/dom4j/` | Android 支持类和第三方基础库 |

## `../lib*.so` 和 `native-symbols.txt`

`libcocos2dlua-armeabi.so` 负责 Cocos/Lua 引擎、加密 ZIP 解包、Lua 启动、下载和原生桥接；`libbdpush_V2_3-armeabi.so` 是百度推送库。`native-symbols.txt` 只是导出符号索引，不等于原生 C++ 源码。

## 推荐阅读顺序

1. `config.json`、`AndroidManifest.xml` 和 `../lua/decompiled/src/main.lua`。
2. `app/MyApp.lua`、`app/scenes/MainScene.lua`、`app/scenes/SceneLogin.lua`。
3. `app/communication/`、`dygame/common/DYHttpMgr.lua` 和 `app/utils/GameManager.lua`。
4. 具体玩法对应的 `scenes/`、`layers/`、`functions/`、`profiles/`。
5. 角色/战斗问题最后核对 `getBuddhaModel.lua`、`getMonsterModel.lua`、`DYAnimator.lua` 和 APK 的 `res/app/armature/`。

# APK 内容清单

审计对象：`releases/1.3/xiaoxiao-xiyou-ol-1.3.apk`

## 版本锁定

| 项目 | 值 |
| --- | --- |
| `game_cfg.ver` | `1.3.2.170727` |
| application id | `com.dygame.journeywest.taptap` |
| SHA-256 | `384c657f7a441ea1180d55172ce79be7bb043100bf81b07fa1395909265b62f5` |
| APK 总条目 | 4,712 |
| ABI | `armeabi` |
| Lua 入口 | `src/main.lua` |

## APK 顶层内容

| 路径 | 作用 |
| --- | --- |
| `AndroidManifest.xml` | 包名、启动 Activity、权限、SDK receiver/service 和支付 Activity |
| `classes.dex` | Java/Android 平台层、SDK、网络和支付实现；已拆到 `../android-smali/` |
| `resources.arsc` | Android 资源索引 |
| `lib/armeabi/libcocos2dlua.so` | Cocos2d-x/Lua 引擎、Lua 解压加载器、DYGame 原生桥接 |
| `lib/armeabi/libbdpush_V2_3.so` | 百度推送 native 库 |
| `assets/config.json` | Cocos 入口、屏幕配置、游戏版本和调试配置 |
| `assets/src.zip` | 加密 Lua 5.1 字节码和随包脚本资源；原样保存在 `../lua/src.zip` |
| `assets/res/` | 游戏图片、图集、骨骼、音频、字体和玩法资源 |

## `assets/` 文件统计

| 类型 | 数量 | 说明 |
| --- | ---: | --- |
| `.png` | 3,530 | UI、角色静态图、图集纹理、图标和特效 |
| `.plist` | 444 | SpriteFrame 图集索引 |
| `.csb` | 304 | CocosStudio 骨骼/场景/动画文件 |
| `.mp3` | 280 | 音乐、攻击音效、技能音效和 UI 音效 |
| `.fnt` | 20 | 位图字体 |
| `.jpg/.jpeg` | 26 | 公告、背景或活动图片 |
| `.fsh/.vsh` | 13 | GLSL shader |
| `.ccbi` | 2 | CocosBuilder 文件 |
| `.ttf` | 1 | 字体 |
| `.csv/.json/.sam` | 3 | 配置或数据文件 |
| `src.zip` | 1 | 加密脚本载荷 |

## 主要资源目录

| 目录 | 内容 |
| --- | --- |
| `res/app/armature/` | 角色、敌人、炮塔和特效的 CocosStudio 骨骼；230 个骨骼目录 |
| `res/app/buddha/` | 伙伴/角色静态站立图 |
| `res/app/buddha_icon/` | 伙伴头像 |
| `res/app/buddha_piece/` | 伙伴碎片图标 |
| `res/app/skillcimelia/` | 法宝和技能动画骨骼 |
| `res/app/animation/` | 战斗胜负、章节和通用动画 |
| `res/app/gamescene*/` | 战斗场景背景、路径和槽位资源 |
| `res/app/stage/`、`dungeon/`、`chapter/` | 关卡、章节和副本 UI |
| `res/app/summon_scene/`、`spin/` | 召唤、抽奖和结果界面资源 |
| `res/app/recharge/`、`shop/` | 充值、商城和商品界面资源 |
| `res/app/update/`、`notice/` | 更新和公告资源 |
| `res/app/sounds/` | 音乐和音效 |

## 资源审计结论

`GameManager.RES_MISSED_ARMATURE` 声明 51 个扩展骨骼名称，其中 11 组已经随 APK 内置，40 组不在 `res/app/armature/` 中。这个结论只针对扩展清单，不代表 APK 总共只有 11 组骨骼。详细名单见 `resource-audit.md`。

## 不可从 APK 直接还原的内容

- `.png/.plist/.csb/.mp3/.so` 是二进制产物，已做路径、数量、引用和加载点审计，不能还原成开发者原始工程文件。
- `assets/src.zip` 解密后是可运行 Lua 5.1 字节码，不是带注释的原始 Lua 工程源码。
- 服务端返回的账号、队伍、关卡、抽奖和热更新数据不在 APK 内。
- 旧服务器上的 `online_res.zip`/`lite_p.zip` 不在当前 APK 内，也未在本地找到。

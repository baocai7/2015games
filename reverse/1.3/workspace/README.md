# 1.3 修改工作区

这个目录是后续分析和修改的入口。原始逆向产物仍保留在上一级目录，避免把可运行字节码、反编译文本和修改稿混在一起。

## 目录约定

| 目录/文件 | 用途 |
| --- | --- |
| `../lua/source/` | 从 APK 解密得到的 Lua 5.1 字节码和原始资源，作为运行基线，不直接改动 |
| `../lua/decompiled/` | 762 个 Lua 字节码的可读近似反编译结果，后续定位逻辑使用 |
| `patches/` | 每个功能修改的补丁说明、目标文件、验证记录 |
| `tests/` | 静态检查、接口回归和资源完整性检查记录 |
| `module-map.md` | 全部源码模块和文件数量索引 |
| `entrypoints.md` | 启动、登录、选关、战斗、召唤、抽奖、支付、资源加载主链路 |
| `data-network.md` | 数据模型、HTTP/TCP 入口和服务端依赖 |
| `change-guide.md` | 后续修改的边界、回滚和打包注意事项 |

## 快速定位

- 启动：`../lua/decompiled/src/main.lua` → `app/MyApp.lua`
- 关卡：`app/scenes/SceneStage.lua`、`app/layers/LayerStageInfo.lua`、`app/game/GameScene.lua`
- 战斗：`app/component/BattleManager.lua`、`app/game/BattleMgrOL.lua`
- 通信：`app/communication/SocketMgr.lua`、`app/communication/Protocol.lua`、`dygame/common/DYHttpMgr.lua`
- 召唤/抽奖：`app/layers/LayerSummon.lua`、`app/models/PaymentModel.lua`、`dygame/common/DYHttpMgr.lua`
- 资源/骨骼：`app/component/DYAnimator.lua`、`app/utils/ResourceManager.lua`、`app/sprites/`
- 本地持久化：`app/profiles/`、`app/game/CloudData.lua`、`app/communication/DataLayer.lua`

## 重要限制

`decompiled` 是 Lua 5.1 字节码反编译结果，不是开发者原始源码。变量名、注释和部分控制流可能与原工程不同；`lua/source` 才是原始可运行脚本载荷。修改前应先在 `patches/` 记录目标和验证方式，避免直接覆盖基线。


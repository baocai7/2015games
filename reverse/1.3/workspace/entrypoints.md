# 关键调用链

## 启动和登录

`main.lua` → `app.MyApp` → `LayerBoot`/`SceneLogin` → `DYLoginMgr` → `DYHttpMgr` → `/user/login`、`/user/userinit` → `CloudData`/`DataLayer`。

入口文件：

- `../lua/decompiled/src/main.lua`
- `../lua/decompiled/src/app/MyApp.lua`
- `../lua/decompiled/src/app/layers/LayerBoot.lua`
- `../lua/decompiled/src/app/scenes/SceneLogin.lua`
- `../lua/decompiled/src/dygame/common/DYLoginMgr.lua`

## 选关和战斗

`SceneStage` → `LayerChapter`/`LayerStageInfo` → `DYHttpMgr.dungeonInit` 或关卡请求 → `GameScene` → `BattleManager`/`BattleMgrOL` → `LayerBattleResult` → `mainfightresult`。

重点文件：

- `../lua/decompiled/src/app/scenes/SceneStage.lua`
- `../lua/decompiled/src/app/layers/LayerStageInfo.lua`
- `../lua/decompiled/src/app/game/GameScene.lua`
- `../lua/decompiled/src/app/component/BattleManager.lua`
- `../lua/decompiled/src/app/game/BattleMgrOL.lua`
- `../lua/decompiled/src/dygame/common/DYHttpMgr.lua`

排查卡在 90% 时按顺序记录：关卡参数 → `dungeoninit` 返回 → 资源请求/骨骼注册 → 场景替换次数 → 战斗对象数量 → 首帧异常。

## 召唤和抽奖

- 召唤界面：`LayerSummon` → `DYHttpMgr.summonInit` → `summon/commonsingle`、`commoncontinue`、`advancesingle`、`advancecontinue`、`hongmengsingle`、`hongmengcontinue`。
- 抽奖界面：`LayerSpin`/`LayerSpinAward` → `lottery/init`、`lottery/draw`、`lottery/awardlog`。
- 新伙伴显示：检查返回的角色 ID、`profiles` 映射、`sprites` 资源名和确认按钮回调是否都完成。

## 支付

支付状态由 `PaymentModel`、`DYIAPMgr` 和 `DYHttpMgr` 协作，接口包括 `/payment/addorder`、`/payment/check`、`/payment/list`、`/payment/firstpaydraw`、`/payment/payawarddraw`。支付结果必须以服务端返回为准，修改时不要在客户端伪造订单成功。

## 资源和骨骼

重点检查：

- `app/component/DYAnimator.lua`
- `app/component/CimeliaSkill.lua`
- `app/component/CimeliaTowerSkill.lua`
- `app/sprites/`
- `app/utils/ResourceManager.lua`

原有图集、骨骼和特效加载逻辑属于玩法显示链路，兼容修补应包裹失败处理，不应删除原始加载调用。


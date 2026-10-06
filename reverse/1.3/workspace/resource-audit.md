# 1.3 资源完整性审计

审计对象：`releases/1.3/xiaoxiao-xiyou-ol-1.3.apk`、`lua/decompiled/src/` 全部 Lua、Android Smali 和现有分析报告。

## 结论

基础 APK 内置资源统计：

| 类型 | 数量 |
| --- | ---: |
| PNG | 3,530 |
| PLIST 图集 | 444 |
| CSB 场景/骨骼文件 | 304 |
| JSON | 1 |

因此，UI 图片和大部分角色/特效资源已经在 APK 中。但不能认为“所有资源都齐全”：`GameManager.lua` 明确维护了一组额外骨骼资源，51 个名称中只有 11 个能在 APK 内找到，40 个缺失。

## 明确缺失的骨骼资源

以下资源在 `GameManager.RES_MISSED_ARMATURE` 中声明，但 APK 的 `assets/res/app/armature/` 下没有对应的 `*1/*.csb` 文件：

```text
dadaomuguai  daerlangshen  dafuhu  dahouyi  dajiguanren  dalongnv
dashikeng  dawanshenglong  dawugang  daxiang  daxianglong  daxingtian
daxuangui  dayuguai  dizangseng  heiwuchang  honghama  huaihou
jichenezha  pibajing  shotouguai  taishanglaolaojun  tieshan  xiaocaishen
xiaoerlangshen  xiaofuhu  xiaohouyi  xiaojiguanren  xiaonuozha
xiaotaishanglaojun  xiaowugang  xiaowukong  xiaoxianglong  xiaoxingtian
xiaoxuanwu  zhongdaomuguai  bianshenwutian  zixia  xiaolongnv  gaojiwukong
```

当前 APK 中能找到的 11 个是：

```text
dapeng  daxiangzi  dizangwang  dongdongdawang  heibaiwuchang
jinjiaoyinjiao  jinluowang  laoshuguai  shizi  zhongxiangzi  zixiaxianzi
```

缺失资源的关联代码：

- `../lua/decompiled/src/app/utils/GameManager.lua:59-115`
- `../lua/decompiled/src/dygame/common/DY_KEY.lua:33`
- `../lua/decompiled/src/app/layers/LayerStageInfo.lua:811-813`
- `../lua/decompiled/src/app/layers/LayerExtraStageInfo.lua:398-400`

## 额外下载路径

代码声明了两个额外骨骼包：

```text
LITE=true  -> http://125.88.152.25/dbxy/lite_p.zip
LITE=false -> http://125.88.152.25/dbxy/online_res.zip
```

声明位置：`../lua/decompiled/src/app/utils/GameManager.lua:112-116`。

通用热更新也会从入口服返回的 `param.data.hotfix` 获取地址，然后调用 `/checkupdate`：

1. `DYHttpMgr.initEntrance` 保存 `param.data.hotfix`；
2. `MainScene` 调用 `DYHttpMgr.checkUpdateInfo`；
3. `LayerUpdate` 使用 `DYUtils.download` 下载并解压到 `DYUtils.hotfixPath()`；
4. `app/init.lua` 把 hotfix 目录加入 Cocos 搜索路径，优先于 APK 内置资源。

相关位置：

- `../lua/decompiled/src/dygame/common/DYHttpMgr.lua:16-47,83-92`
- `../lua/decompiled/src/app/scenes/MainScene.lua:118-163`
- `../lua/decompiled/src/app/layers/LayerUpdate.lua:130-190`
- `../lua/decompiled/src/dygame/utils/DYUtils.lua:233-255`
- `../lua/decompiled/src/app/init.lua:8-21`

## 发现的代码风险

`GameManager.URL_MISSED_ARMATURE`、`RES_MISSED_ARMATURE` 和 `CloudData.MISSED_ARMATURE_RES` 在全量 Lua 扫描中只有声明/标记，没有找到实际的 `DYUtils.download(...)` 调用。`LayerStageInfo:resDownloaded()` 和 `LayerExtraStageInfo:resDownloaded()` 只写入“已下载”标志，不负责下载。

这意味着当前版本存在两种情况之一：

1. 缺失骨骼由服务端热更新包间接补齐；或
2. 原本的缺失骨骼下载逻辑在这个版本中断链，导致角色无图、骨骼创建失败或关卡加载卡住。

不能只把 `kIsArmatureDownloaded` 设为 true 来解决问题，这会跳过检查，却不会生成实际资源。

## 不应误判为缺失的引用

全量 Lua 中有大量动态路径，例如 `armature/%s/%s.csb`、`circle%d.png`、`buddha/buddha%s.png`。这些不能仅凭字符串静态比对判定缺失，必须使用运行时展开后的角色 ID/资源名再检查 APK 或 hotfix 目录。

## 建议的下一步

1. 在不删除原加载逻辑的前提下，对 `GameManager.RES_MISSED_ARMATURE` 做启动时逐项存在性日志。
2. 记录 `DYUtils.hotfixPath()`、`param.data.hotfix`、更新包 URL、解压结果和最终搜索路径。
3. 若服务端不可用，将缺失的 40 组 `armature/<name>1/<name>1.csb`、PLIST、PNG 从合法资源包补入本地 hotfix 目录，再验证第一关和召唤伙伴。
4. 对每次 `ccs.Armature:create(name)` 记录名称和失败回调，避免把资源错误表现成场景切换或闪退。

本报告没有修改 APK、资源或 Lua 逻辑，只记录审计结果。


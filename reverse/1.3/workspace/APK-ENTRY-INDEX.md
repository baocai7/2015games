# APK 条目索引

`apk-entry-index.tsv` 收录目标 APK 的全部 ZIP 条目。字段为：

```text
path    kind    purpose
```

这是对 APK 的完整路径级清单。`purpose` 根据路径、扩展名和资源目录归类；对图片、音频、CSB 等二进制文件，不把路径归类误认为已经还原了原始工程语义。

生成来源：

```sh
unzip -Z1 ../releases/1.3/xiaoxiao-xiyou-ol-1.3.apk
```

脚本逻辑和 Lua 文件索引一样，属于可重复的静态审计结果。需要查看角色、骨骼或某个界面资源时，先在此文件中定位路径，再回到 `entrypoints.md`、`resource-audit.md` 和 `lua-file-index.tsv` 查加载方。

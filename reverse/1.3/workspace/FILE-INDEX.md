# 文件级索引

`lua-file-index.tsv` 是对 `../lua/decompiled/src/` 下全部 Lua 文件的可搜索索引，每个文件一行：

```text
path    module    purpose
```

`purpose` 是根据模块目录归纳的职责，不是对反编译代码的臆测。需要理解具体行为时，按 `entrypoints.md`、`data-network.md` 和 `module-map.md` 的链路继续阅读对应文件。

## 原始文件和可读文件的关系

| 文件 | 说明 |
| --- | --- |
| `../lua/source/...` | APK 解密后的 Lua 5.1 字节码，运行基线 |
| `../lua/decompiled/...` | 同一批字节码的可读近似结果，定位逻辑使用 |
| `../android-smali/...` | `classes.dex` 的 Smali 反汇编 |
| APK `assets/res/...` | 图片、图集、骨骼、音频等二进制资源 |

## 如何使用

```sh
rg -n "SceneStage|TinyLoading|zixiaxianzi" workspace/lua-file-index.tsv workspace/*.md
```

资源完整路径仍以 APK 为准，可用以下命令搜索：

```sh
unzip -Z1 ../releases/1.3/xiaoxiao-xiyou-ol-1.3.apk | rg 'assets/res/app/armature/'
```

索引不会替代二进制资源本身，也不会把服务端返回的数据伪造为本地文件。

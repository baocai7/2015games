# 逆向覆盖范围

## 已完成

- 已锁定 APK 为 `1.3.2.170727`，并记录 SHA-256。
- 已从 APK 提取 `assets/src.zip`，保留原始副本并解密出完整 Lua 字节码载荷。
- 已对 762 个 Lua 文件生成可读近似反编译结果。
- 已建立 Lua 模块、调用点、资源调用点、网络端点和启动链路索引。
- 已拆解 `classes.dex` 为 1,547 个 Smali 文件，并标记平台层、登录、支付、下载和第三方 SDK。
- 已提取两个 ARM native 库并建立导出符号表，确认 Lua ZIP 解密和启动路径。
- 已对 APK 中 3,530 个 PNG、444 个 PLIST、304 个 CSB 和 280 个 MP3 做类型及路径统计。
- 已审计角色模型、关卡表、骨骼加载、热更新、缺失骨骼清单和资源下载地址。

## “完整读取”的准确边界

“完整”指 APK 内可提取的脚本、清单、Smali、符号、资源路径和引用关系都已纳入索引；不表示把二进制 `.csb`、图片、音频或 native `.so` 伪还原成开发者原始工程。

| 内容 | 状态 | 可读形式 |
| --- | --- | --- |
| Lua 逻辑 | 已提取/反编译 | `../lua/source/`、`../lua/decompiled/` |
| Android 平台层 | 已反汇编 | `../android-smali/` |
| Native 接口 | 已做符号和关键函数审计 | `../native-symbols.txt`、两个 `.so` |
| 图片/图集 | 已按路径、数量和引用审计 | APK `assets/res/` |
| CocosStudio 骨骼 | 已按目录、CSB 和加载调用审计 | APK `assets/res/app/armature/` |
| 音频/字体/shader | 已按类型和引用审计 | APK `assets/res/app/` |
| 服务端数据 | 不在 APK 内 | 只能从协议/日志和运行时响应确认 |
| 缺失扩展资源包 | 未取得 | `online_res.zip`/`lite_p.zip` 地址已记录但当前不可用 |

## 当前已知风险

- 反编译 Lua 的局部变量名、注释和控制流可能与原始工程不同。
- 服务器返回的队伍、伙伴、关卡、抽奖和热更新数据不属于静态 APK 内容。
- 资源文件存在不等于服务端会返回正确模型 ID；需要同时检查数据映射和运行时加载日志。
- `TinyLoadingScene` 的异步资源回调需要运行时验证是否等待全部文件完成。
- 两个外部骨骼包不在 APK 内，因此无法宣称所有角色和后期玩法都具备完整资源。

## 复核命令

```sh
cd /Users/ahs/Desktop/未命名文件夹/2015games
sha256sum releases/1.3/xiaoxiao-xiyou-ol-1.3.apk
unzip -Z1 releases/1.3/xiaoxiao-xiyou-ol-1.3.apk
find reverse/1.3/lua/decompiled/src -type f -name '*.lua' | wc -l
find reverse/1.3/android-smali -type f -name '*.smali' | wc -l
```

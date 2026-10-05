# Xiaoxiao Xiyou OL 1.3 reverse-engineering artifacts

Source APK: `releases/1.3/xiaoxiao-xiyou-ol-1.3.apk`

The APK is a Cocos2d-x/Lua application. The following artifacts were produced
from the supplied APK:

- `android-smali/`: Apktool output for `classes.dex` (1,547 smali files).
- `lua/src.zip`: the bundled Lua source archive, byte-for-byte copied from
  `assets/src.zip` in the APK.
- `config.json`: the runtime entry point and game version configuration.
- `AndroidManifest.xml`: the decoded Android manifest.
- `native-symbols.txt`: exported symbols from the bundled ARM native libraries.
- `libcocos2dlua-armeabi.so` and `libbdpush_V2_3-armeabi.so`: native libraries
  copied from the APK for native analysis.

## Lua source status

The archive contains 875 entries and exposes the full source tree and file
names, but Lua entries are protected with ZipCrypto. The APK's runtime loads
`src/main.lua` from that archive using a native password that is not present in
the JSON configuration. The archive is therefore preserved unchanged rather
than represented as incomplete or fabricated plaintext source.

### Native loader trace

Static analysis of `libcocos2dlua-armeabi.so` confirms this load path:

1. `LuaManager::runLuaHome()` schedules the Lua loading task.
2. `LoadLuaTask::runOnWorkThread()` copies the bundled ZIP to its work path.
3. It constructs a password argument and calls
   `FileIO::uncompressWithPassword(std::string, std::string)`.
4. The uncompressor iterates archive entries and calls
   `unzOpenCurrentFilePassword()` for encrypted entries.
5. When the task completes, `LuaManager::onTaskFinished()` starts the Lua
   engine at the configured `src/main.lua` entry point.

Relevant ARM Thumb function addresses in this APK's `libcocos2dlua.so`:

| Function | Address |
| --- | ---: |
| `FileIO::uncompressWithPassword` | `0x00294438` |
| `LoadLuaTask::runOnWorkThread` | `0x002947b0` |
| `LuaManager::runLuaHome` | `0x00294b2c` |
| `LuaManager::onTaskFinished` | `0x00294bd4` |
| `LuaManager::init` | `0x00294cec` |

The password is assembled in native code and is not exposed as a plain string
by the usual string scan. The known `dywl523613713` value belongs to the older
Doubi Xiyou XXTEA-protected assets and does not unlock this 1.3 archive.
Extracting the original Lua text still requires recovering this APK's exact
ZipCrypto password or observing it at runtime. `lua/src.zip` is complete but
encrypted; `android-smali/` and native symbols are analysis artifacts, not a
substitute for the original Lua source.

The source archive has 875 entries, including directory entries. Use
`unzip -Z1 lua/src.zip` to inspect its file tree without decrypting contents.

## Reproduce the extraction

```sh
unzip -p releases/1.3/xiaoxiao-xiyou-ol-1.3.apk assets/src.zip > reverse/1.3/lua/src.zip
java -jar /private/tmp/apktool.jar d -f releases/1.3/xiaoxiao-xiyou-ol-1.3.apk -o /private/tmp/xiaoxiao-apktool-1.3
```

The native libraries are ARM (`armeabi`) and are not equivalent to original
C++ source; `native-symbols.txt` is an interface/symbol inventory only.

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

## Reproduce the extraction

```sh
unzip -p releases/1.3/xiaoxiao-xiyou-ol-1.3.apk assets/src.zip > reverse/1.3/lua/src.zip
java -jar /private/tmp/apktool.jar d -f releases/1.3/xiaoxiao-xiyou-ol-1.3.apk -o /private/tmp/xiaoxiao-apktool-1.3
```

The native libraries are ARM (`armeabi`) and are not equivalent to original
C++ source; `native-symbols.txt` is an interface/symbol inventory only.

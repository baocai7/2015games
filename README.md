# Doubi Xiyou original reverse-engineering output

This directory was generated from the unmodified baseline package:

`org.cocos2dx.lua.ApplicationEx.apk.1`

Baseline SHA-256:

`e7b3bae4e5c3846b2755c89b8a76483856b2e86ffd14bf26fbba9c35f756b743`

## Contents

- `org.cocos2dx.lua.ApplicationEx.apk.1`: original APK copy.
- `apk/`: byte-for-byte ZIP extraction of the APK contents.
- `smali/`: 658 smali files produced from `classes.dex` with Apktool 3.0.3.
- `source/assets/src/`: decrypted outer Lua/framework payloads and plaintext Lua files.
- `source/game/`: 282 files extracted from the decrypted `source/assets/src/game.bin` archive.
- `outer-decryption-manifest.txt`: files decrypted by `decrypt_doubi_lua.rb`.
- `source-files.txt`: manifest of recovered source files.
- `apk-files.txt`: manifest of extracted APK files.
- `lua-bytecode-files.txt`: outer Lua payloads that are still Lua 5.1 bytecode.
- `lua-text-files.txt`: Lua/text files that are directly readable.
- `decrypt_doubi_lua.rb`: the XXTEA recovery script used to generate the Lua payloads.

## Recovery details

The client uses XXTEA for the signed Lua chunks and the packed `game.bin` file.
The key used by the existing recovery script is `dywl523613713`; the signed
chunk prefix is `dywl`. Plaintext Lua files such as `channelConfig.lua` and the
DataEye stubs were copied unchanged from the original APK. The `game.bin`
archive was then unpacked without modifying its files.

The recovered game layer is directly readable Lua: `source/game/` contains all
282 files from `game.bin`. The outer boot/framework layer contains 103 Lua 5.1
bytecode files; those are decrypted payloads, but they are not the original
text source. No Lua 5.1 decompiler is bundled here, so those files are kept
exactly as recovered and listed separately.

`classes.dex` and the native libraries in `apk/` remain compiled artifacts; an
APK cannot restore the original Java/C++ project source, build files, or server
source code. `smali/` is the closest recoverable representation for the Java
layer.

## Entry points

- Outer Lua entry: `source/assets/src/main.lua`
- Game entry: `source/game/app/MyApp.lua`
- Original server configuration: `source/assets/src/channelConfig.lua`

# 1.3 Code Analysis

The original `src.zip` was decrypted with the native ZipCrypto password and
all 762 Lua 5.1 bytecode files were processed with Unluac. The readable output
is under `../lua/decompiled/`, mirroring the original `src/` tree.

This output is a decompilation, not the original developer source. Lua 5.1
bytecode does not retain comments and may rename locals or simplify control
flow differently from the original script. The bytecode payload under
`../lua/source/` remains the authoritative, runnable artifact.

Key entry points confirmed in the decompiled code:

- `src/main.lua`: initializes the Cocos/Lua application and runs `app.MyApp`.
- `src/app/MyApp.lua`: application-level scene and manager initialization.
- `src/app/scenes/SceneStage.lua`: chapter/stage map, stage selection, and
  transition into battle.
- `src/app/communication/SocketMgr.lua`: TCP login, connection lifecycle, and
  packet dispatch.
- `src/app/communication/Protocol.lua`: protocol command and response mapping.
- `src/app/component/BattleManager.lua`: battle state and unit processing.
- `src/app/activity/buddha/LayerActivityBuddha.lua`: summon/peach activity UI
  and reward response handling.

The native analysis artifacts remain in this directory's parent tree. They
cover the Lua ZIP loader, password construction, Cocos bridge, and exported
native interfaces; native machine code cannot be restored to original C++
source without symbols and build inputs.

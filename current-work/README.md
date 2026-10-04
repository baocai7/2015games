# Doubi Xiyou current work branch

This directory contains the current 2026-10-04 repair and compatibility work.
The original, unmodified baseline remains in the `main` branch.

## Contents

- `artifacts/`: the two requested APKs: `逗比嘻游-全局触摸清理修复版-20261004.apk` and the latest `逗比嘻游-原版图集保留诊断版-20261004.apk`.
- `source/`: the latest non-`main` Lua source snapshot used by the current repair build (283 files).
- `patches/`: Lua packing/decryption and native/loading compatibility scripts.
- `server/`: the local Python/SQLite compatibility server and protocol test.
- `verification/`: device logs and screenshots collected during validation.
- `analysis/`: the reverse-engineering and recovery notes.
- `manifests/`: SHA-256 inventory of all Doubi APK variants left in the workspace.

The historical APK variants are intentionally represented by the hash manifest
instead of being copied into this branch. The two requested builds are included
as branch artifacts. Unchanged baseline/framework files are intentionally not
duplicated here; they remain in `main`.

The SQLite database is excluded from this branch because it contains local
account state rather than source or reproducible server data.

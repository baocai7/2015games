from pathlib import Path
import hashlib
import struct


LIBRARY = Path("/private/tmp/jpgame-cheat-decode/lib/armeabi-v7a/libcocos2dcpp.so")
BACKUP = LIBRARY.with_suffix(".so.before-resource-refresh")

EXPECTED_BASE_SHA256 = "e1a6fb5d10e1174c256d5b8560194dbeeffc96783c4e22259bb7886562b6e8e5"
COIN_HOOK_VMA = 0x1915D4
RUBY_HOOK_VMA = 0x1915D8
BRIDGE_VMA = 0x4D7660


def encode_branch(source, target, link):
    offset = target - (source + 4)
    if offset % 2 or not -(1 << 24) <= offset < (1 << 24):
        raise ValueError("Thumb branch is out of range")
    sign = (offset >> 24) & 1
    i1 = (offset >> 23) & 1
    i2 = (offset >> 22) & 1
    imm10 = (offset >> 12) & 0x3FF
    imm11 = (offset >> 1) & 0x7FF
    j1 = (~(i1 ^ sign)) & 1
    j2 = (~(i2 ^ sign)) & 1
    first = 0xF000 | (sign << 10) | imm10
    second = (0xD000 if link else 0x9000) | (j1 << 13) | (j2 << 11) | imm11
    return struct.pack("<HH", first, second)


base = BACKUP.read_bytes()
digest = hashlib.sha256(base).hexdigest()
if digest != EXPECTED_BASE_SHA256:
    raise RuntimeError(f"unexpected base library SHA-256: {digest}")
if base[:4] != b"\x7fELF":
    raise RuntimeError("unexpected native library format")
if base[COIN_HOOK_VMA:COIN_HOOK_VMA + 4] != bytes.fromhex("14 f0 64 b9"):
    raise RuntimeError("coin JNI entry does not match the original payment-success bridge")
if base[RUBY_HOOK_VMA:RUBY_HOOK_VMA + 4] != bytes.fromhex("14 f0 e6 b9"):
    raise RuntimeError("ruby JNI entry does not match the original payment-failure bridge")

# Thumb-2 bridge. It calls the game's own ProfileMgr::Refresh/RefreshRuby
# functions, then refreshes the active CStartGame only after validating its
# vtable and both resource-label pointers. The JNI calls are dispatched from
# Java through Cocos2dxActivity.runOnGLThread.
bridge = bytearray.fromhex(
    "00 23 00 e0 01 23 f0 b5 85 b0 1f 46 d4 f4 14 fe "
    "00 28 51 d0 d0 f8 e4 20 00 2a 4d d0 d0 f8 e8 20 "
    "00 2a 49 d0 04 46 01 46 68 46 d4 f4 24 ff 00 2f "
    "10 d1 01 99 48 f2 a0 62 c0 f2 01 02 11 44 49 f2 "
    "7f 62 c0 f2 98 02 91 42 88 bf 11 46 20 46 d4 f4 "
    "4a fe 0d e0 03 99 40 f2 e8 32 11 44 44 f2 3f 22 "
    "c0 f2 0f 02 91 42 88 bf 11 46 20 46 d4 f4 80 fe "
    "5d f5 2c f8 00 b3 00 6f f0 b1 56 f5 35 fe d8 b1 "
    "04 46 5c f5 ee f8 b8 b1 20 46 00 21 5c f5 f8 f8 "
    "90 b1 04 46 22 68 7b 46 4c f6 be 05 c0 f2 01 05 "
    "2b 44 9a 42 08 d1 d4 f8 28 22 2a b1 d4 f8 2c 22 "
    "12 b1 20 46 ec f4 62 fe 05 b0 f0 bd"
)

call_targets = {
    0x0C: 0x1AC288,  # ProfileMgr::sharedProfileMgr()
    0x2A: 0x1AC4A8,  # ProfileMgr::getProfileMgr() (struct-return ABI)
    0x4E: 0x1AC2F4,  # ProfileMgr::Refresh(int)
    0x6C: 0x1AC360,  # ProfileMgr::RefreshRuby(int)
    0x70: 0x2346B8,  # CCDirector::sharedDirector()
    0x7A: 0x22E2CA,  # CCNode::getChildren()
    0x82: 0x23383C,  # CCArray::count()
    0x8C: 0x233850,  # CCArray::objectAtIndex(0)
    0xB4: 0x1C4324,  # CStartGame::ownRefush(float)
}
for offset, target in call_targets.items():
    bridge[offset:offset + 4] = encode_branch(BRIDGE_VMA + offset, target, link=True)

data = bytearray(base)
bridge_end = BRIDGE_VMA + len(bridge)
if bridge_end > 0x4D77A8:
    raise RuntimeError("native bridge overlaps the second PT_LOAD segment")
if data[BRIDGE_VMA:bridge_end] != b"\x00" * len(bridge):
    raise RuntimeError("native bridge area is not unused padding")

data[COIN_HOOK_VMA:COIN_HOOK_VMA + 4] = encode_branch(
    COIN_HOOK_VMA, BRIDGE_VMA, link=False
)
data[RUBY_HOOK_VMA:RUBY_HOOK_VMA + 4] = encode_branch(
    RUBY_HOOK_VMA, BRIDGE_VMA + 4, link=False
)
data[BRIDGE_VMA:bridge_end] = bridge

# Include the injected bridge in the executable first PT_LOAD segment.
phoff = struct.unpack_from("<I", data, 28)[0]
phentsize = struct.unpack_from("<H", data, 42)[0]
load_offset = phoff + phentsize
if struct.unpack_from("<I", data, load_offset)[0] != 1:
    raise RuntimeError("unexpected first load segment")
struct.pack_into("<I", data, load_offset + 16, bridge_end)
struct.pack_into("<I", data, load_offset + 20, bridge_end)

LIBRARY.write_bytes(data)
print(
    f"patched {LIBRARY}: coin/ruby native credit bridge, "
    f"{len(bridge)} bytes at 0x{BRIDGE_VMA:x}"
)

from pathlib import Path


library = Path("/private/tmp/jpgame-decode/lib/armeabi-v7a/libcocos2dcpp.so")
offset = 0x1A77DC
expected = bytes.fromhex("24 4b 20 46 eb 58 0a 93 00 23")
replacement = bytes.fromhex("20 46 00 21 ff f7 fa f9 15 e0")

data = bytearray(library.read_bytes())
actual = bytes(data[offset : offset + len(expected)])
if actual != expected:
    raise SystemExit(
        f"Unexpected bytes at 0x{offset:x}: {actual.hex(' ')}; "
        f"expected {expected.hex(' ')}"
    )

data[offset : offset + len(replacement)] = replacement
library.write_bytes(data)
print(f"Patched {library} at 0x{offset:x}")

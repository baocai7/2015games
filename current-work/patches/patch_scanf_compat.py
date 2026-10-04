from pathlib import Path


LIBRARY = Path("/private/tmp/jpgame-decode/lib/armeabi-v7a/libcocos2dcpp.so")

# This old NDK build contains its own stdio scanner, but its vfscanf calls the
# device libc's flockfile/__srefill/funlockfile with an obsolete FILE layout.
# All direct users in this binary are sscanf() over a bounded memory string, so
# buffer exhaustion must be treated as EOF instead of asking Android 13 libc to
# refill the synthetic FILE object.
NOOP = bytes.fromhex("00 bf 00 bf")
RETURN_EOF = bytes.fromhex("01 20 00 bf")  # movs r0, #1; nop

PATCHES = {
    0x21BECA: (bytes.fromhex("74 f7 ea ed"), NOOP),
    0x21BF2C: (bytes.fromhex("74 f7 be ed"), RETURN_EOF),
    0x21C01C: (bytes.fromhex("74 f7 46 ed"), RETURN_EOF),
    0x21C1E6: (bytes.fromhex("74 f7 68 ec"), NOOP),
    0x21C20C: (bytes.fromhex("74 f7 4e ec"), RETURN_EOF),
    0x21C23E: (bytes.fromhex("74 f7 36 ec"), RETURN_EOF),
    0x21C29A: (bytes.fromhex("74 f7 08 ec"), RETURN_EOF),
    0x21C306: (bytes.fromhex("74 f7 d2 eb"), RETURN_EOF),
    0x21C34E: (bytes.fromhex("74 f7 ae eb"), RETURN_EOF),
    0x21C3B6: (bytes.fromhex("74 f7 7a eb"), RETURN_EOF),
    0x21C404: (bytes.fromhex("74 f7 52 eb"), RETURN_EOF),
    0x21C514: (bytes.fromhex("74 f7 ca ea"), RETURN_EOF),
    0x21C6F4: (bytes.fromhex("74 f7 da e9"), RETURN_EOF),
    0x21C7B8: (bytes.fromhex("74 f7 7e e9"), NOOP),
}


def main() -> None:
    data = bytearray(LIBRARY.read_bytes())
    changed = 0

    for offset, (expected, replacement) in PATCHES.items():
        actual = bytes(data[offset : offset + len(expected)])
        if actual == replacement:
            continue
        if actual != expected:
            raise RuntimeError(
                f"unexpected bytes at 0x{offset:x}: {actual.hex(' ')}; "
                f"expected {expected.hex(' ')}"
            )
        data[offset : offset + len(replacement)] = replacement
        changed += 1

    LIBRARY.write_bytes(data)

    verified = LIBRARY.read_bytes()
    for offset, (_, replacement) in PATCHES.items():
        actual = verified[offset : offset + len(replacement)]
        if actual != replacement:
            raise RuntimeError(f"scanf compatibility verification failed at 0x{offset:x}")

    print(f"Patched {changed} of {len(PATCHES)} legacy scanf stdio call sites")


if __name__ == "__main__":
    main()

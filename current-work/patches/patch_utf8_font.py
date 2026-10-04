from pathlib import Path


LIBRARY = Path("/private/tmp/jpgame-decode/lib/armeabi-v7a/libcocos2dcpp.so")
OFFSET = 0x450B46
LEGACY_GBK = bytes.fromhex("d0 d0 bf ac cc e5")  # GBK: 行楷体
SAFE_FONT = b"Arial\0"


def main() -> None:
    data = bytearray(LIBRARY.read_bytes())

    occurrences = []
    start = 0
    while True:
        found = data.find(LEGACY_GBK, start)
        if found < 0:
            break
        occurrences.append(found)
        start = found + 1

    actual = bytes(data[OFFSET : OFFSET + len(LEGACY_GBK)])
    if actual == SAFE_FONT:
        print(f"UTF-8 font patch already present at 0x{OFFSET:x}")
        return
    if actual != LEGACY_GBK:
        raise RuntimeError(
            f"unexpected bytes at 0x{OFFSET:x}: {actual.hex(' ')}; "
            f"expected {LEGACY_GBK.hex(' ')}"
        )
    if occurrences != [OFFSET]:
        raise RuntimeError(
            "legacy GBK font byte sequence was not unique: "
            + ", ".join(f"0x{item:x}" for item in occurrences)
        )

    # Keep the original six-byte allocation exactly: "Arial" plus NUL.
    data[OFFSET : OFFSET + len(LEGACY_GBK)] = SAFE_FONT
    LIBRARY.write_bytes(data)

    verified = LIBRARY.read_bytes()[OFFSET : OFFSET + len(SAFE_FONT)]
    if verified != SAFE_FONT:
        raise RuntimeError("font patch verification failed")
    print(f"Patched GBK font name to Arial at 0x{OFFSET:x}")


if __name__ == "__main__":
    main()

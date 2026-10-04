# Doubi Xiyou local compatibility server

This server implements the legacy HTTP form API used by the recovered Android
client. Player state is stored in `doubi.sqlite3`.

Start it before opening the patched APK:

```sh
python3 server.py --host 192.168.31.225 --port 18080
```

The Mac and Android phone must remain on the same Wi-Fi network. The patched
client currently points to `192.168.31.225:18080`.

Run the protocol smoke test with:

```sh
python3 -m unittest -v test_server.py
```

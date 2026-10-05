# Doubi Xiyou local compatibility server

This server implements the legacy HTTP form API used by the recovered Android
client. Player state is stored in `doubi.sqlite3`.

Start it before opening the patched APK:

```sh
python3 server.py --host 192.168.31.225 --port 18080
```

Requests and lottery/payment results are appended to `compat-server.log`.
For local QA only, `python3 server.py --test-payments` makes locally created
orders report paid; this is a test switch and does not represent real payment.

The Mac and Android phone must remain on the same Wi-Fi network. The patched
client currently points to `192.168.31.225:18080`.

Run the protocol smoke test with:

```sh
python3 -m unittest -v test_server.py
```

#!/usr/bin/env python3

import json
import tempfile
import threading
import unittest
from pathlib import Path
from urllib.parse import urlencode
from urllib.request import Request, urlopen

from server import CompatibilityServer, Handler, Store


class ServerTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.server = CompatibilityServer(
            ("127.0.0.1", 0),
            Handler,
            Store(Path(self.temp.name) / "test.sqlite3"),
            "127.0.0.1",
            18080,
        )
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()
        self.base = f"http://127.0.0.1:{self.server.server_port}"

    def tearDown(self):
        self.server.shutdown()
        self.server.server_close()
        self.temp.cleanup()

    def get(self, path):
        with urlopen(self.base + path) as response:
            return json.load(response)

    def post(self, path, values):
        request = Request(
            self.base + path,
            data=urlencode(values).encode(),
            method="POST",
        )
        with urlopen(request) as response:
            return json.load(response)

    def test_boot_and_battle_flow(self):
        self.assertEqual(self.get("/health")["status"], "ok")
        update = self.get("/dbxy/update_1_1_x.html")
        self.assertEqual(update["v"], "1.1.7")

        registered = self.post("/user/quickregister", {"channel": "255"})["data"]
        login = self.post("/user/login", registered)["data"]
        user = login["user"]
        self.assertEqual(login["regions"][0]["regionId"], 1)

        auth = {"uid": str(user["uid"]), "token": user["token"], "regionId": "1"}
        player = self.post("/account/playerInfoNew", auth)["data"]
        self.assertEqual(player["npcList"][0]["npcId"], 1)
        self.assertTrue(all(level == 1 for level in player["towerProperty"].values()))
        upgraded = self.post("/account/upgradetower", {**auth, "id": "6"})
        self.assertEqual(upgraded["errorCode"], 0)
        reloaded_tower = self.post("/account/playerInfoNew", auth)["data"]["towerProperty"]
        self.assertEqual(reloaded_tower["spiritStorage"], 2)
        chapter = self.post("/account/chapterinfoNew", auth)["data"]
        self.assertEqual(chapter["energy"], 100)

        gifts = self.post("/sign/gift", auth)["data"]
        self.assertEqual(len(gifts), 7)
        self.assertEqual(gifts[0]["itemType"], 3)
        before_sign = self.post("/account/playerInfoNew", auth)["data"]
        self.assertFalse(before_sign["signedToday"])
        signed = self.post("/sign/today", auth)["data"]
        self.assertTrue(signed["signedToday"])
        self.assertEqual(signed["signWeekNum"], 1)
        after_sign = self.post("/account/playerInfoNew", auth)["data"]
        self.assertEqual(after_sign["expNum"], before_sign["expNum"] + gifts[0]["itemNum"])
        signed_again = self.post("/sign/today", auth)["data"]
        self.assertEqual(signed_again["signTotalNum"], signed["signTotalNum"])

        battle = self.post("/account/costenergy", {**auth, "stageId": "0"})["data"]
        self.assertTrue(battle["tempToken"])
        result = self.post(
            "/stage/pass", {**auth, "stageId": "0", "success": "1", "tempToken": battle["tempToken"]}
        )["data"]
        self.assertEqual(result["peach"], 1)
        reloaded = self.post("/account/playerInfoNew", auth)["data"]
        self.assertEqual(reloaded["reachStageId"], 1)
        self.assertEqual(reloaded["energy"], 95)

    def test_lottery_returns_protocol_shape_and_not_fixed_value(self):
        registered = self.post("/user/quickregister", {"channel": "255"})["data"]
        login = self.post("/user/login", registered)["data"]
        auth = {"uid": str(login["user"]["uid"]), "token": login["user"]["token"], "regionId": "1"}
        results = [self.post("/lottery/draw", auth)["data"] for _ in range(12)]
        self.assertTrue(all({"index", "critNum", "itemId", "awardNum"} <= set(result) for result in results))
        self.assertGreater(len({(result["index"], result["itemId"]) for result in results}), 1)

    def test_order_is_pending_by_default(self):
        registered = self.post("/user/quickregister", {"channel": "255"})["data"]
        login = self.post("/user/login", registered)["data"]
        auth = {"uid": str(login["user"]["uid"]), "token": login["user"]["token"], "regionId": "1"}
        order = self.post("/order/add", {**auth, "productId": "21"})["data"]
        self.assertEqual(order["peach"], 50)
        self.assertEqual(self.post("/order/status", {**auth, "orderId": order["orderId"]})["data"], 0)


if __name__ == "__main__":
    unittest.main()

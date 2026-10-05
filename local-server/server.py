#!/usr/bin/env python3
"""Local compatibility server for the legacy Doubi Xiyou Android client."""

from __future__ import annotations

import argparse
import json
import secrets
import sqlite3
import threading
import time
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse


REGION_ID = 1
TOWER_KEYS = (
    "comprehension",
    "mirrorPowerLevel",
    "mirrorRecoverLevel",
    "mirrorRange",
    "spiritGatherSpeed",
    "spiritStorage",
    "towerHP",
    "buddhaRecoverLevel",
    "spiritCultivateSpeed",
    "energyStorage",
)

SIGN_REWARDS = (
    {"itemType": 3, "itemId": 0, "itemNum": 500, "description": "经验 x500"},
    {"itemType": 1, "itemId": 0, "itemNum": 10, "description": "蟠桃 x10"},
    {"itemType": 6, "itemId": 0, "itemNum": 5, "description": "扫荡券 x5"},
    {"itemType": 2, "itemId": 0, "itemNum": 1, "description": "人参果 x1"},
    {"itemType": 3, "itemId": 0, "itemNum": 1000, "description": "经验 x1000"},
    {"itemType": 1, "itemId": 0, "itemNum": 20, "description": "蟠桃 x20"},
    {"itemType": 3, "itemId": 0, "itemNum": 2000, "description": "经验 x2000"},
)

# The restored client expects these fields from /lottery/draw. Keep the pool
# explicit so test results vary while every returned item still exists in the
# bundled data tables.
LOTTERY_REWARDS = (
    {"index": 1, "itemId": 0, "awardNum": 100},
    {"index": 2, "itemId": 0, "awardNum": 10},
    {"index": 3, "itemId": 0, "awardNum": 2},
    {"index": 4, "itemId": 0, "awardNum": 1},
    {"index": 5, "itemId": 1, "awardNum": 1},
    {"index": 6, "itemId": 2, "awardNum": 1},
)

SUMMON_EXP_POOL = tuple(range(1, 17))
SUMMON_PEACH_POOL = tuple(range(17, 33))

PAYMENT_PRODUCTS = {
    1: (1, 50),
    2: (30, 300),
    3: (10, 200),
    4: (68, 1360),
    5: (128, 2560),
    6: (300, 6000),
}

UNLIMITED_PEACH_AMOUNT = 999_999_999

LOG_FILE = Path(__file__).with_name("compat-server.log")
_LOG_LOCK = threading.Lock()


def audit(event: str, **fields) -> None:
    """Write a redacted, append-only protocol trace for local debugging."""
    details = " ".join(f"{key}={fields[key]}" for key in sorted(fields))
    line = f"{time.strftime('%Y-%m-%dT%H:%M:%S%z')} {event} {details}\n"
    with _LOG_LOCK:
        with LOG_FILE.open("a", encoding="utf-8") as output:
            output.write(line)


def now() -> int:
    return int(time.time())


def default_player(username: str, uid: int) -> dict:
    created = now()
    return {
        "uid": uid,
        "team": json.dumps([1], separators=(",", ":")),
        "challegeStageId": 1,
        "dayOfWeek": int(time.strftime("%w")) or 7,
        "dailyStageAvailableNum": 3,
        "expNum": 5000,
        "peachNum": 500,
        "reachStageId": 0,
        "ginsen": 10,
        "buyExpNum": 0,
        "chapterTime": created,
        "costMoney": 0,
        "costPeach": 0,
        "createTime": created,
        "energy": 100,
        "maxEnergy": 100,
        "essence": 1000,
        "failNum": 0,
        "freeNPCByPeachTime": 0,
        "freeNpcNum": 0,
        "freeNpcTime": 0,
        "memberNumBattle": 3,
        "payGiftStatus": 2,
        "shareNum": 0,
        "signTotalNum": 0,
        "signWeekNum": 0,
        "signedToday": False,
        "lastSignDate": "",
        "sweepNum": 50,
        "expiry": "",
        "channelId": 255,
        "username": username,
        "drawNum": 0,
        "nick": username,
        "reachTowerLevel": 1,
        "reachTowerWave": 0,
        "coin": 0,
        "guide": json.dumps(["oc"], separators=(",", ":")),
        "fragmentList": [],
        "items": [10, 10, 10, 10, 10, 10],
        "npcList": [
            {"npcId": 1, "isActive": 1, "addlevel": 0, "level": 1, "status": 1}
        ],
        "treasureList": [],
        # Upgrade levels in the original client are one-based. Zero is an
        # unset value, and makes level0Param lookups fall back to a fixed 100
        # spirit cap instead of using the upgrade table.
        "towerProperty": {key: 1 for key in TOWER_KEYS},
        "achievementList": [],
        "dailyTaskProgress": [0] * 13,
        "chapterProgress": [0] * 8,
    }


class Store:
    def __init__(self, database: Path):
        database.parent.mkdir(parents=True, exist_ok=True)
        self.connection = sqlite3.connect(database, check_same_thread=False)
        self.connection.row_factory = sqlite3.Row
        self.lock = threading.RLock()
        with self.connection:
            self.connection.execute(
                """
                CREATE TABLE IF NOT EXISTS accounts (
                    uid INTEGER PRIMARY KEY AUTOINCREMENT,
                    username TEXT NOT NULL UNIQUE,
                    password TEXT NOT NULL,
                    token TEXT NOT NULL,
                    player_json TEXT,
                    updated_at INTEGER NOT NULL
                )
                """
            )

    def login(self, username: str, password: str) -> tuple[sqlite3.Row, dict]:
        username = username.strip() or "local-player"
        with self.lock, self.connection:
            row = self.connection.execute(
                "SELECT * FROM accounts WHERE username = ?", (username,)
            ).fetchone()
            if row is None:
                token = secrets.token_hex(16)
                cursor = self.connection.execute(
                    "INSERT INTO accounts(username, password, token, player_json, updated_at) "
                    "VALUES (?, ?, ?, NULL, ?)",
                    (username, password, token, now()),
                )
                uid = cursor.lastrowid
                player = default_player(username, uid)
                self.connection.execute(
                    "UPDATE accounts SET player_json = ? WHERE uid = ?",
                    (json.dumps(player, ensure_ascii=False), uid),
                )
                row = self.connection.execute(
                    "SELECT * FROM accounts WHERE uid = ?", (uid,)
                ).fetchone()
            else:
                player = json.loads(row["player_json"])
                self.normalize_player(player)
                if password and row["password"] != password:
                    self.connection.execute(
                        "UPDATE accounts SET password = ?, updated_at = ? WHERE uid = ?",
                        (password, now(), row["uid"]),
                    )
                    row = self.connection.execute(
                        "SELECT * FROM accounts WHERE uid = ?", (row["uid"],)
                    ).fetchone()
            return row, player

    @staticmethod
    def normalize_player(player: dict) -> None:
        """Migrate legacy zero-based tower levels in memory."""
        tower_property = player.setdefault("towerProperty", {})
        for key in TOWER_KEYS:
            try:
                level = int(tower_property.get(key, 1))
            except (TypeError, ValueError):
                level = 1
            tower_property[key] = max(1, level)

    def create_quick_account(self) -> tuple[sqlite3.Row, dict]:
        while True:
            username = f"local{int(time.time())}{secrets.randbelow(1000):03d}"
            try:
                return self.login(username, secrets.token_urlsafe(8))
            except sqlite3.IntegrityError:
                continue

    def player_for(self, params: dict[str, str]) -> tuple[sqlite3.Row, dict]:
        uid_text = params.get("uid", "")
        token = params.get("token", "")
        with self.lock:
            row = None
            if uid_text.isdigit():
                row = self.connection.execute(
                    "SELECT * FROM accounts WHERE uid = ?", (int(uid_text),)
                ).fetchone()
            if row is None and token:
                row = self.connection.execute(
                    "SELECT * FROM accounts WHERE token = ?", (token,)
                ).fetchone()
            if row is None:
                row, player = self.login("local-player", "local")
                return row, player
            player = json.loads(row["player_json"])
            self.normalize_player(player)
            self.save(row, player)
            return row, player

    def save(self, row: sqlite3.Row, player: dict) -> None:
        with self.lock, self.connection:
            self.connection.execute(
                "UPDATE accounts SET player_json = ?, updated_at = ? WHERE uid = ?",
                (json.dumps(player, ensure_ascii=False), now(), row["uid"]),
            )


class CompatibilityServer(ThreadingHTTPServer):
    daemon_threads = True

    def __init__(
        self,
        address,
        handler,
        store: Store,
        advertised_host: str,
        port: int,
        test_payments: bool = False,
        unlimited_peach: bool = False,
    ):
        super().__init__(address, handler)
        self.store = store
        self.advertised_host = advertised_host
        self.advertised_port = port
        self.orders: dict[str, dict] = {}
        self.order_lock = threading.RLock()
        self.test_payments = test_payments
        self.unlimited_peach = unlimited_peach

    def region(self) -> dict:
        return {
            "regionId": REGION_ID,
            "flag": 0,
            "name": "Local Server",
            "ip": self.advertised_host,
            "port": str(self.advertised_port),
        }


class Handler(BaseHTTPRequestHandler):
    server: CompatibilityServer

    def log_message(self, fmt: str, *args) -> None:
        message = fmt % args
        print(f"[{time.strftime('%H:%M:%S')}] {self.client_address[0]} {message}")
        audit("http", client=self.client_address[0], message=message)

    def send_json(self, payload: dict, status: HTTPStatus = HTTPStatus.OK) -> None:
        body = json.dumps(payload, ensure_ascii=False, separators=(",", ":")).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def success(self, data=None, **extra) -> None:
        payload = {"errorCode": 0, "errorMsg": "", "data": {} if data is None else data}
        payload.update(extra)
        self.send_json(payload)

    def read_form(self) -> dict[str, str]:
        length = int(self.headers.get("Content-Length", "0") or "0")
        body = self.rfile.read(length).decode("utf-8", "replace")
        return {key: values[-1] for key, values in parse_qs(body).items()}

    def do_GET(self) -> None:
        path = urlparse(self.path).path
        audit("request", client=self.client_address[0], method="GET", path=path)
        if path == "/health":
            self.send_json({"status": "ok", "time": now()})
            return
        if path.endswith("update_1_1_x.html") or path.endswith("update_1_1_x_ios.html"):
            self.send_json({"v": "1.1.7", "fc": "1.1.7", "p": "", "sz": [], "r": []})
            return
        if path == "/server/timesecond":
            self.send_json({"time": now()})
            return
        self.send_json(
            {"error": {"code": "not_found", "message": f"Unknown path: {path}"}},
            HTTPStatus.NOT_FOUND,
        )

    def do_POST(self) -> None:
        path = urlparse(self.path).path
        params = self.read_form()
        print(f"POST {path} {sorted(params)}")
        audit(
            "request",
            client=self.client_address[0],
            method="POST",
            path=path,
            fields=",".join(sorted(params)),
            uid=params.get("uid", ""),
        )

        if path == "/user/quickregister":
            row, _ = self.server.store.create_quick_account()
            self.success({"userName": row["username"], "password": row["password"]})
            return

        if path in {
            "/user/login",
            "/user/uclogin",
            "/user/anysdklogin",
            "/user/kugoulogin",
            "/user/qqlogin",
            "/user/wechatlogin",
        }:
            username = (
                params.get("userName")
                or params.get("sid")
                or params.get("uid")
                or params.get("openid")
                or "local-player"
            )
            row, _ = self.server.store.login(username, params.get("password", "local"))
            data = {
                "regions": [self.server.region()],
                "user": {"regions": str(REGION_ID), "token": row["token"], "uid": row["uid"]},
            }
            self.success(data)
            return

        if path == "/region/list":
            self.success([self.server.region()])
            return

        row, player = self.server.store.player_for(params)

        if self.server.unlimited_peach:
            player["peachNum"] = UNLIMITED_PEACH_AMOUNT
            self.server.store.save(row, player)
            audit("unlimited_peach", uid=row["uid"], amount=UNLIMITED_PEACH_AMOUNT)

        if path == "/account/playerInfoNew":
            player["uid"] = row["uid"]
            player["username"] = row["username"]
            self.server.store.save(row, player)
            self.success(player, time=now())
            return

        if path == "/account/chapterinfoNew":
            achievement = self.achievement_progress(player)
            data = {
                "achievementProgress": achievement,
                "dailyTaskProgress": player["dailyTaskProgress"],
                "chapterProgress": player["chapterProgress"],
                "energy": player["energy"],
                "maxEnergy": player["maxEnergy"],
                "expAvailableTime": 0,
                "peachAvailableTime": 0,
                "expFreeNum": 5,
                "productStatus": [0, 0, 0, 0, 0, 0],
                "charge10Status": 0,
                "charge10RemainSecond": 0,
                "msgs": {"data": {}},
                "drawActivityStatus": 0,
                "activityStatus": 0,
            }
            self.success(data, time=now())
            return

        if path == "/account/chapterinfo":
            self.send_json({"energy": player["energy"], "maxEnergy": player["maxEnergy"]})
            return

        if path == "/account/costenergy":
            player["energy"] = max(0, int(player["energy"]) - 5)
            self.server.store.save(row, player)
            self.success(
                {
                    "energy": player["energy"],
                    "items": player["items"],
                    "exp": player["expNum"],
                    "peach": player["peachNum"],
                    "sweepNum": player["sweepNum"],
                    "tempToken": secrets.token_hex(8),
                },
                time=now(),
            )
            return

        if path in {"/stage/sweep", "/stage/sweep5"}:
            # The legacy client reads every field below immediately after the
            # request completes. Returning the generic empty success payload
            # makes Lua add nil to EXP/PEACH and looks like a network failure.
            requested = 5 if path.endswith("sweep5") else 1
            available = max(0, self.to_int(player.get("sweepNum"), 0))
            if available < requested:
                audit("sweep_rejected", uid=row["uid"], path=path,
                      requested=requested, available=available)
                self.send_json({
                    "errorCode": 1001,
                    "errorMsg": "扫荡券不足",
                    "data": {"sweepNum": available},
                })
                return

            stage_id = self.to_int(params.get("stageId"), 0)
            exp_reward = 100 * requested
            peach_reward = 1 * requested
            player["sweepNum"] = available - requested
            player["expNum"] += exp_reward
            player["peachNum"] += peach_reward
            player["reachStageId"] = max(player.get("reachStageId", 0), stage_id + 1)
            self.server.store.save(row, player)
            data = {
                "exp": exp_reward,
                "peach": peach_reward,
                "sweepNum": player["sweepNum"],
                "treasure": 0,
                "monster": {
                    "npcId": 0,
                    "npcNum": 0,
                    "advanceNpcId": 0,
                    "advanceNpcNum": 0,
                },
            }
            audit("sweep", uid=row["uid"], path=path, stage=stage_id,
                  count=requested, exp=exp_reward, peach=peach_reward,
                  remaining=player["sweepNum"])
            self.success(data, time=now())
            return

        if path == "/stage/pass":
            stage_id = self.to_int(params.get("stageId"), 0)
            won = self.to_int(params.get("success"), 0) == 1
            exp_reward = 100
            peach_reward = 1 if won else 0
            player["expNum"] += exp_reward
            player["peachNum"] += peach_reward
            if won:
                player["reachStageId"] = max(player["reachStageId"], stage_id + 1)
            self.server.store.save(row, player)
            self.success(
                {
                    "exp": exp_reward,
                    "peach": peach_reward,
                    "treasure": 0,
                    "monster": {"npcId": 0, "npcNum": 0, "advanceNpcId": 0, "advanceNpcNum": 0},
                },
                time=now(),
            )
            return

        if path == "/account/updateteam":
            player["team"] = params.get("team", player["team"])
            self.server.store.save(row, player)
            self.success()
            return

        if path == "/account/guide":
            try:
                guide = json.loads(player["guide"])
            except (TypeError, json.JSONDecodeError):
                guide = []
            step = params.get("step", "")
            if step and step not in guide:
                guide.append(step)
            player["guide"] = json.dumps(guide, separators=(",", ":"))
            self.server.store.save(row, player)
            self.success()
            return

        if path == "/account/updatenick":
            player["nick"] = params.get("nick", player["nick"])
            self.server.store.save(row, player)
            self.success()
            return

        if path == "/account/upgradetower":
            property_id = self.to_int(params.get("id"), 0)
            if 1 <= property_id <= len(TOWER_KEYS):
                key = TOWER_KEYS[property_id - 1]
                player["towerProperty"][key] += 1
            self.server.store.save(row, player)
            self.success()
            return

        if path == "/account/unlockmembernum":
            player["memberNumBattle"] = min(6, player["memberNumBattle"] + 1)
            self.server.store.save(row, player)
            self.success()
            return

        if path in {"/npc/upgrade", "/npc/evolution", "/npc/breach", "/npc/compose"}:
            self.update_npc(player, self.to_int(params.get("npcid"), 1), path)
            self.server.store.save(row, player)
            self.success()
            return

        if path == "/lottery/initinfo":
            self.success(
                {
                    "expAvailableTime": 0,
                    "peachAvailableTime": 0,
                    "expFreeNum": 5,
                    "costExp": 100,
                    "costExpContinue": 900,
                    "costPeach": 10,
                    "CostPeachContinue": 90,
                },
                time=now(),
            )
            return

        if path == "/lottery/draw":
            reward = dict(secrets.choice(LOTTERY_REWARDS))
            reward["critNum"] = secrets.choice((1, 1, 1, 2, 3))
            player["drawNum"] = int(player.get("drawNum", 0)) + 1
            self.server.store.save(row, player)
            audit(
                "lottery_draw",
                uid=row["uid"],
                index=reward["index"],
                item=reward["itemId"],
                amount=reward["awardNum"],
                crit=reward["critNum"],
                draw_num=player["drawNum"],
            )
            self.success(reward, time=now())
            return

        if path in {"/lottery/exp/single", "/lottery/peach/single"}:
            result = self.summon_one(player, advanced=path.startswith("/lottery/peach"))
            self.server.store.save(row, player)
            audit("summon", uid=row["uid"], path=path, npc=result["npcId"],
                  new=result["isNew"], essence=result["essenceNum"])
            self.success({"availableTime": now(), **result}, time=now())
            return

        if path in {"/lottery/exp/continue", "/lottery/peach/continue"}:
            advanced = path.startswith("/lottery/peach")
            results = [self.summon_one(player, advanced=advanced) for _ in range(10)]
            self.server.store.save(row, player)
            audit(
                "summon_ten",
                uid=row["uid"],
                path=path,
                npcs=",".join(str(item["npcId"]) for item in results),
                new_count=sum(1 for item in results if item["isNew"]),
            )
            self.success({"npcs": results}, time=now())
            return

        if path in {"/order/add", "/order/add2", "/order/addApple"}:
            product_id = self.to_int(params.get("productId"), 0)
            base_id = product_id - 20 if 21 <= product_id <= 26 else product_id
            amount, peach = PAYMENT_PRODUCTS.get(base_id, (0, 0))
            order_id = f"LOCAL-{row['uid']}-{now()}-{secrets.randbelow(10000):04d}"
            with self.server.order_lock:
                self.server.orders[order_id] = {
                    "uid": row["uid"],
                    "productId": product_id,
                    "amount": amount,
                    "peach": peach,
                    "paid": bool(self.server.test_payments),
                    "granted": False,
                }
            audit(
                "payment_order",
                uid=row["uid"],
                order=order_id,
                product=product_id,
                amount=amount,
                peach=peach,
                test_paid=self.server.test_payments,
            )
            self.success({"amount": amount, "peach": peach, "orderId": order_id})
            return

        if path == "/order/status":
            order_id = params.get("orderId", "")
            status = 0
            with self.server.order_lock:
                order = self.server.orders.get(order_id)
                if order and order["uid"] == row["uid"] and order["paid"]:
                    status = 2
                    if not order["granted"]:
                        player["peachNum"] += int(order["peach"])
                        player["costMoney"] += int(order["amount"])
                        player["payGiftStatus"] = 1
                        order["granted"] = True
                        self.server.store.save(row, player)
            audit("payment_status", uid=row["uid"], order=order_id, status=status)
            self.success(status)
            return

        if path in {"/task/dailyprogress", "/task/drawdailyreward"}:
            self.success(player["dailyTaskProgress"])
            return

        if path in {"/task/chapterprogress", "/task/chapterreward"}:
            self.success(player["chapterProgress"])
            return

        if path in {"/task/stageprogress", "/task/stagereward"}:
            self.success([0] * 10)
            return

        if path in {"/achievement/property", "/achievement/award"}:
            self.success(self.achievement_progress(player))
            return

        if path == "/sign/gift":
            self.success([dict(reward) for reward in SIGN_REWARDS])
            return

        if path == "/sign/today":
            today = time.strftime("%Y-%m-%d")
            if player.get("lastSignDate") != today:
                player["signedToday"] = False
                if player.get("signWeekNum", 0) >= len(SIGN_REWARDS):
                    player["signWeekNum"] = 0

            if not player.get("signedToday", False):
                reward_index = min(max(int(player.get("signWeekNum", 0)), 0), len(SIGN_REWARDS) - 1)
                reward = SIGN_REWARDS[reward_index]
                self.apply_sign_reward(player, reward)
                player["signedToday"] = True
                player["lastSignDate"] = today
                player["signWeekNum"] = reward_index + 1
                player["signTotalNum"] = int(player.get("signTotalNum", 0)) + 1
                self.server.store.save(row, player)

            self.success(
                {
                    "signedToday": player["signedToday"],
                    "signWeekNum": player["signWeekNum"],
                    "signTotalNum": player["signTotalNum"],
                }
            )
            return

        if path in {"/shop/list", "/shop/refresh", "/shop/goodlist", "/shop/refreshnew"}:
            self.success([])
            return

        if path == "/notice/list":
            self.success([])
            return

        if path in {"/msg/list", "/msg/notice", "/sysmsg/android", "/sysmsg/apple", "/sysmsg/qq"}:
            self.success({})
            return

        # Legacy screens often only wait for a successful response and update
        # CloudData locally. Keep unknown write calls non-blocking and log them.
        self.success({}, time=now())

    @staticmethod
    def summon_one(player: dict, advanced: bool = False) -> dict:
        pool = SUMMON_PEACH_POOL if advanced else SUMMON_EXP_POOL
        owned_ids = {item.get("npcId") for item in player["npcList"]}
        unowned = [npc_id for npc_id in pool if npc_id not in owned_ids]
        # Prefer an unowned entry so a new account can actually discover the
        # roster before duplicate draws are converted into essence stones.
        npc_id = secrets.choice(unowned or list(pool))
        owned = next((item for item in player["npcList"] if item.get("npcId") == npc_id), None)
        if owned is not None:
            return {"npcId": npc_id, "essenceNum": 10, "isNew": False}
        player["npcList"].append(
            {"npcId": npc_id, "isActive": 1, "addlevel": 0, "level": 1, "status": 1}
        )
        return {"npcId": npc_id, "essenceNum": 0, "isNew": True}

    @staticmethod
    def to_int(value, default: int) -> int:
        try:
            return int(value)
        except (TypeError, ValueError):
            return default

    @staticmethod
    def achievement_progress(player: dict) -> dict:
        return {
            "buddaLevel10Num": 0,
            "buddaLevel20Num": 0,
            "buddaNum": len([npc for npc in player["npcList"] if npc.get("status") == 1]),
            "buyExpNum": player["buyExpNum"],
            "costMoney": player["costMoney"],
            "costPeach": player["costPeach"],
            "failNum": player["failNum"],
            "monsterNum": 0,
            "signNum": player["signTotalNum"],
            "stageId": player["reachStageId"],
            "towerPropertyLevelFull": 0,
            "treasureNum": len(player["treasureList"]),
        }

    @staticmethod
    def update_npc(player: dict, npc_id: int, path: str) -> None:
        npc = next((item for item in player["npcList"] if item.get("npcId") == npc_id), None)
        if npc is None:
            npc = {"npcId": npc_id, "isActive": 1, "addlevel": 0, "level": 1, "status": 1}
            player["npcList"].append(npc)
        if path == "/npc/upgrade":
            npc["level"] += 1
        elif path == "/npc/breach":
            npc["addlevel"] += 1
        else:
            npc["status"] = 1

    @staticmethod
    def apply_sign_reward(player: dict, reward: dict) -> None:
        item_type = reward["itemType"]
        amount = reward["itemNum"]
        if item_type == 1:
            player["peachNum"] += amount
        elif item_type == 2:
            player["ginsen"] += amount
        elif item_type == 3:
            player["expNum"] += amount
        elif item_type == 6:
            player["sweepNum"] += amount
            npc["isActive"] = 1


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bind", default="0.0.0.0")
    parser.add_argument("--host", default="192.168.31.225", help="Address advertised to the phone")
    parser.add_argument("--port", type=int, default=18080)
    parser.add_argument("--database", type=Path, default=Path(__file__).with_name("doubi.sqlite3"))
    parser.add_argument(
        "--test-payments",
        action="store_true",
        help="local QA only: mark local test orders paid; never use for production",
    )
    parser.add_argument(
        "--unlimited-peach",
        action="store_true",
        help="local QA only: replenish every authenticated account with unlimited peaches",
    )
    args = parser.parse_args()

    server = CompatibilityServer(
        (args.bind, args.port), Handler, Store(args.database), args.host, args.port,
        test_payments=args.test_payments,
        unlimited_peach=args.unlimited_peach,
    )
    print(f"Doubi compatibility server: http://{args.host}:{args.port}")
    print(f"Database: {args.database.resolve()}")
    print(f"Local test payments: {'enabled' if args.test_payments else 'disabled'}")
    print(f"Unlimited peaches: {'enabled' if args.unlimited_peach else 'disabled'}")
    audit("server_start", host=args.host, port=args.port, test_payments=args.test_payments,
          unlimited_peach=args.unlimited_peach)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == "__main__":
    main()

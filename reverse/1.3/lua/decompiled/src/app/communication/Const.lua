Const = Const or {}
Const.SKIP_GUIDE = true
Const.MAX_LEVEL = 80
Const.MAX_STAR = 5
Const.Zoom0 = 0.4
Const.isTowerMonsterCast = false
Const.MaxSpirit = 0
Const.TowerBuddhaLoseHp = nil
Const.CIMELIA_SKILL = nil
Const.CIMELIA_DEF_SKILL = nil
Const.MaxMoveSpeed = 500
Const.CurSprite = 210
Const.CimeliaColdTime1 = nil
Const.CimeliaColdTime2 = nil
Const.isTestScene = false
Const.TowerBuddhaSpeed = -25
Const.STAGE_PROGRESS = nil
Const.PVPOL_TOWER_HP_RATIO = 4
Const.CIMELIA_LIMIT_NUM = 50
Const.CommonCD = 24
Const.PVPCurSprite = 500
Const.CardMode = {
  INTERVAL_TIME = 2.5,
  SpiritRecover = 400,
  CimeliaAtkCost = 300,
  CimeliaDefCost = 300,
  InitSpirit = 600,
  Distance = 1000
}
Const.Card1 = {
  [1] = 35,
  [2] = 5,
  [3] = 40,
  [4] = 20,
  [5] = 0
}
Const.Card2 = {
  [1] = 25,
  [2] = 10,
  [3] = 60,
  [4] = 10,
  [5] = 5
}
Const.Card3 = {
  [1] = 0,
  [2] = 15,
  [3] = 70,
  [4] = 10,
  [5] = 5
}
Const.Card4 = {
  [1] = 0,
  [2] = 25,
  [3] = 60,
  [4] = 5,
  [5] = 5
}
Const.FUNC_UNLOCK = {
  team = 1,
  summon = 5,
  buddha = 2,
  treasure = 8,
  pvp = 11,
  cimelia = 7,
  cemeliamake = 12,
  patrol = 13,
  tower = 28,
  purgatory = 20,
  package = 1,
  pvpOL = 14,
  equipment = 15,
  union = 20,
  recast = 20,
  friend = 10,
  aggress = 20
}
Const.CHAT_CONTENT = {
  {
    DYLang.getString("S170", ""),
    DYLang.getString("S171", ""),
    DYLang.getString("S172", "")
  },
  {
    DYLang.getString("S173", ""),
    DYLang.getString("S174", ""),
    DYLang.getString("S175", "")
  },
  {
    DYLang.getString("S176", ""),
    DYLang.getString("S177", ""),
    DYLang.getString("S178", "")
  },
  {
    DYLang.getString("S179", ""),
    DYLang.getString("S180", ""),
    DYLang.getString("S181", "")
  }
}
Const.Skill = {TRIGGER2 = 0, TRIGGER7 = 0}
Const.GameType = {NomalType = 1, CardType = 2}
Const.Layer = Const.Layer or {}
Const.Layer = {
  LAYER_BG = 0,
  LAYER_GAME = 1,
  LAYER_MASK = 2,
  LAYER_POP = 3,
  LAYER_TOUCH = 4
}
Const.Act = Const.Act or {}
Const.Act = {}
Const.BATTLE_RESULT = {WIN = 1, LOSE = 0}
Const.UNION_FIGHT_TYPE = {NORMAL = 1, BOSS = 2}
Const.UNION_FIGHT_END = 1
Const.UNION_FIGHT_ATTACK = 1
Const.UNION_FIGHT_DEFENCE = 2
Const.FLAG_BUDDHA = 1
Const.FLAG_MONSTER = 2
Const.TAG_BATTLE_COUNT = {
  TOWER_CUR_HP = 2,
  USE_SPIRIT = 3,
  CREATE_BUDDHA = 4,
  CIM_DAMAGE = 5,
  KILL_MONSTER = 6
}
Const.UNION_POS = {
  LEADER = 3,
  MIDDLE = 2,
  MEMBER = 1
}
Const.ActorType = {Buddha = 1, Monster = 2}
LIFE = 1
ATK = 2
PHY_DEF = 3
MAG_DEF = 4
ATK_SPED = 5
MOV_SPED = 10
ADD_HARM = 11
REAL_HARM = 12
PHY_DEF_IGNORE = 13
FINAL_HARM = 14
REDUCE_HARM = 15
WOOD_HARM = 16
WATER_HARM = 17
EARTH_HARM = 18
LIFE_HEAL = 19
SHANXIAN = 20
RELIVE = 21
MAG_DEF_IGNORE = 22
LIFE_CUR = 19
LIFE_RATE = 101
ATK_RATE = 102
PHY_DEF_RATE = 103
MAG_DEF_RATE = 104
ATK_SPED_RATE = 105
MOV_SPED_RATE = 110
ADD_HARM_RATE = 111
LIFE_HEAL_RATE = 119
LIFE_CUR_RATE = 119
HIT_RATE = 120
MISS_RATE = 121
CRIT_RATE = 122
RES_CRIT_RATE = 123
REDUCE_HARM_RATE = 124
ADD_HARM_RATE = 125
CRIT_HARM_RATE = 126
RES_CRIT_HARM_RATE = 127
SKILL_HARM_RATE = 999
CAUSE_BACK = 1001
CAUSE_STUN = 1002
CAUSE_STONE = 1003
CAUSE_REBEL = 1004
CAUSE_CHANGE = 1005
CAUSE_PALSY = 1006
CAUSE_FREEZE = 1007
CAUSE_BURN = 1008
CAUSE_POISON = 1014
CAUSE_SILENCE = 1018
RES_BACK = 2001
RES_STUN = 2002
RES_STONE = 2003
RES_REBEL = 2004
RES_CHANGE = 2005
RES_PALSY = 2006
RES_FREEZE = 2007
RES_BURN = 2008
RES_ALL = 2009
RES_POISON = 2014
RES_FLYUP = 2015
RES_RUNDEAD = 2016
RES_SILENCE = 2018
TRIGGER_ON_PASSIVE = 1
TRIGGER_ON_ATK = 2
TRIGGER_ON_LIFE = 3
TRIGGER_ON_KILL = 4
TRIGGER_ON_ONBATTLE = 5
TRIGGER_ON_DEF = 6
TRIGGER_ON_ATKCOUNT = 7
TRIGGER_ON_DEATH = 8
TRIGGER_ON_LIVE = 9
TRIGGER_ON_DEFCOUNT = 10
FLAG_TOWER_BUDDHA = 10
FLAG_TOWER_MONSTER = 9
Const.ELEMENT_RATIO = {
  {
    1,
    1.3,
    0.9,
    0.7,
    1.1
  },
  {
    0.7,
    1,
    1.1,
    0.9,
    1.3
  },
  {
    1.1,
    0.9,
    1,
    1.3,
    0.7
  },
  {
    1.3,
    1.1,
    0.7,
    1,
    0.9
  },
  {
    0.9,
    0.7,
    1.3,
    1.1,
    1
  }
}
Const.ELEMENT_RELATED = {
  [1] = 4,
  [2] = 1,
  [3] = 5,
  [4] = 3,
  [5] = 2
}
Const.FRIEND_MAX = 60
Const.FRIEND_RECENT_MAX = 10
Const.FRIEND_ADD_MAX = 20
Const.FRIEND_CHAT_MAX = 100
Const.FRIEND_OFFLINE_TIME_MAX = 7
Const.FRIEND_CHAT_SAVE_TIME = 30

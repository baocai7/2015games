local DataLabelIcon = require("app.icons.DataLabelIcon")
local SceneIcon = require("app.icons.SceneIcon")
local FunctionIcon = require("app.icons.FunctionIcon")
local LayerNotice = require("app.layers.LayerNotice")
local LayerFirstRecharge = require("app.layers.LayerFirstRecharge")
local LayerPackage = require("app.layers.LayerPackage")
local LayerTeam = require("app.layers.LayerTeam")
local LayerSign = require("app.layers.LayerSign")
local LayerUserCenter = require("app.layers.LayerUserCenter")
local LayerRecharge = require("app.layers.LayerRecharge")
local LayerActivity = require("app.layers.LayerActivity")
local LayerMail = require("app.layers.LayerMail")
local LayerActivitySeven = require("app.layers.LayerActivitySeven")
local LayerAchievement = require("app.layers.LayerAchievement")
local LayerDungeon = require("app.layers.LayerDungeon")
local LayerRankList = require("app.layers.LayerRankList")
local LayerPVPEntrance = require("app.layers.LayerPVPEntrance")
local LayerChangeUserName = require("app.layers.LayerChangeUserName")
local LayerShopNew = require("app.layers.LayerShopNew")
local LayerRedPacket = require("app.activity.LayerRedPacket")
local LayerNewYear = require("app.activity.LayerNewYear")
local LayerSpin = require("app.activity.LayerSpin")
local LayerNewBuddha = require("app.activity.LayerNewBuddha")
local LayerCollection = require("app.activity.collection.LayerCollection")
local LayerChess = require("app.activity.chess.LayerChess")
local LayerRankingAward = require("app.layers.LayerRankingAward")
local LayerActivityBuddha = require("app.activity.buddha.LayerActivityBuddha")
local LayerCompeteAlert = require("app.pvponline.LayerCompeteAlert")
local LayerUnionApply = require("app.union.layers.LayerUnionApply")
local LayerUnionMember = require("app.union.layers.LayerUnionMember")
local LayerBossRelated = require("app.aggress.layers.LayerBossRelated")
local WSToast = require("app.utils.WSToast")
local NoviceGuide = require("app.utils.NoviceGuide")
local GameDialogue = require("app.utils.GameDialogue")
local ScrollCaption = require("app.utils.ScrollCaption")
local LayerChat = require("app.layers.LayerChat")
local LayerFriends = require("app.friend.LayerFriends")
local IconPkBubble = require("app.icons.IconPkBubble")
local TAG_EVENT_LOGIN_OK = "tag_event_login_ok"
local TAG_CACHE_CHAT_MSG = "tag_cache_chat_msg"
local TAG_FRIENDS_PK_APPLY = "tag_friends_pk_apply"
local M = {}
M = class("ChapterScene", function()
  return display.newScene("ChapterScene")
end)
M.BG_LEFT = 1920 - display.width
M.BG_RIGHT = 0

function M:ctor(funcIndex)
  self.mKeypadListener = handler(self, self.onKeypad)
  if not audio.isMusicPlaying() then
    DYSoundMgr.playMusic(DY_SND.bgm_theme)
  end
  self:performWithDelay(function()
    self:initData()
    SocketHandler:connectScocekChat(self)
    self:userFunUnlock()
    self:initCenterScrollMap()
    self:initTopInfoUI()
    self:initFunctionsBtn()
    self:initLeftBottomBtn()
    self:initRightBottomBtn()
    if CloudData.FESTIVAL_ACT_TYPE ~= 0 and CloudData.FESTIVAL_ACT_TYPE ~= 4 then
      self:loadFestivalFuncBtn()
    end
    self:initPkBubble()
    self:performWithDelay(function()
      self.mIsCanBGMoved = true
      self:initParamData()
      self:dealUserProgress()
    end, 0.5)
    self:addNoticeLayer()
    self:dealSceneReplace(funcIndex)
    self:updateScrollMsg()
    self:schedule(function()
      self:updateScrollMsg()
    end, 10)
    self:addPostListener()
    display.removeUnusedSpriteFrames()
  end, 0)
end

function M:initData()
  self.mBgNode = nil
  self.mBgSize = nil
  self.mSceneIconTable = {}
  self.mSceneNameTable = {}
  self.mCanBeClicked = true
  self.mFuncIconTable = {}
  self.mRightBtnTable = {}
  self.mFestivalFuncBtn = {}
  self.mIsRightBtnCanClicked = true
  self.mIsRightBtnOpened = false
  self.mBarFrame = nil
  self.mIsCanBGMoved = false
  GameManager.STAGE_NUM = 0
  self.mIsScrollShow = false
  GameManager.UNLOCK_BUDDHA_ID = DataUtils.getUnlockBuddhaList()
end

function M:addNoticeLayer()
  if CloudData.NOTICE_SHOWED then
    return
  end
  if CloudData.USER_LEVEL < 15 then
    CloudData.NOTICE_SHOWED = true
    return
  end
  if CloudData.MAIN_STAGE_PROGRESS < 1 then
    CloudData.NOTICE_SHOWED = true
    return
  end
  local t = os.date("*t", os.time())
  local tag1 = string.format("%d%d%d", t.year, t.month, t.day)
  local tag2 = DYStat.getValueStr(DY_KEY.kNoticeInvisibleTag, "")
  if tag1 == tag2 then
    CloudData.NOTICE_SHOWED = true
    return
  end
  CloudData.NOTICE_SHOWED = true
  local layer = LayerNotice.new()
  layer:addTo(self, 100)
end

local function M_saveValueToCloudData(jsonTable)
  CloudData.DAILY_TASK_INFO = jsonTable.data.task
  CloudData.ACHIEVEMENT_INFO = jsonTable.data.achievement
  CloudData.ENERGY = jsonTable.data.energy
  CloudData.MAX_ENERGY = jsonTable.data.maxEnergy
  CloudData.ENERGY_REFRESH_TIME = jsonTable.data.energyRefreshTime
  if CloudData.ENERGY + 1 < CloudData.MAX_ENERGY then
    CloudData.ENERGY_FULL_TIME = CloudData.ENERGY_REFRESH_TIME + (CloudData.MAX_ENERGY - CloudData.ENERGY) * 480
  else
    CloudData.ENERGY_FULL_TIME = CloudData.ENERGY_REFRESH_TIME
  end
  GameManager.LAST_ENERGY_TIME = os.time()
  CloudData.PEACH = jsonTable.data.peach
  DataUtils.updateItemNum(1, CloudData.PEACH)
  DataUtils.updateItemNum(3, CloudData.ENERGY)
  CloudData.NEXT_COMMON_FREE_TIME = jsonTable.data.commonRefreshTime < 0 and 0 or jsonTable.data.commonRefreshTime
  CloudData.NEXT_ADVANCE_FREE_TIME = 0 > jsonTable.data.advanceRefreshTime and 0 or jsonTable.data.advanceRefreshTime
  CloudData.COMMON_FREE_NUM = 0 > jsonTable.data.commonFreeTimes and 0 or jsonTable.data.commonFreeTimes
  CloudData.TIME_SERVER = jsonTable.time
  CloudData.SERVER_MSG = jsonTable.data.msgs or {}
  CloudData.ICON_LIST = jsonTable.data.iconList
  CloudData.NEW_FRIEND_APPLY = tonumber(jsonTable.data.newFriendApply) or 0
  CloudData.NEW_AGGRESS = checknumber(jsonTable.data.aggress)
  local mysteryOpened = tonumber(jsonTable.data.mysteryShow) or 0
  if mysteryOpened == 0 or mysteryOpened == 1 and CloudData.MYSTERY_SHOP_NEW ~= 2 then
    CloudData.MYSTERY_SHOP_NEW = mysteryOpened
  end
  if DataUtils.getIsVipFuntionsUnlock("vipShop") then
    CloudData.MYSTERY_SHOP_NEW = 2
  end
  CloudData.DUNGEON_BOX_INFO = jsonTable.data.dungeonInfo or {}
  do
    local tag1 = math.floor(checknumber(CloudData.MONEY) / 10)
    local tag2 = math.floor(checknumber(jsonTable.data.money) / 10)
    if tag1 ~= tag2 then
      DYAnalyze.account.changeTag("MONEY", tag1, tag2)
    end
  end
  CloudData.MONEY = jsonTable.data.money or 0
  CloudData.VIP_LEVEL = tonumber(jsonTable.data.vip) or CloudData.VIP_LEVEL
  CloudData.COUNT_CE = jsonTable.data.CE or 0
  CloudData.MAX_PVP_LOG_TIME = tonumber(jsonTable.data.maxPvpFightLogID) or 0
  CloudData.ACTIVITY_INFO = jsonTable.data.activity.activityCommon or {}
  CloudData.ACTIVITY_SEVEN_INFO = jsonTable.data.activity.activitySeven or {}
  CloudData.ACTIVITY_VIP_INFO = jsonTable.data.activity.activityVip or {}
  CloudData.ACTIVITY_FESTIVAL_INFO = jsonTable.data.activity.activityFestival or {}
  CloudData.ACTIVITY_INVEST = jsonTable.data.activity.activityInvest or 0
  CloudData.NEW_BUDDHA_INFO = CloudData.ACTIVITY_FESTIVAL_INFO["1"] or 0
  CloudData.SPIN_INFO = CloudData.ACTIVITY_FESTIVAL_INFO["2"] or 0
  CloudData.RED_PACKET_INFO = CloudData.ACTIVITY_FESTIVAL_INFO["3"] or 0
  CloudData.ACTIVITY_BUDDHA = CloudData.ACTIVITY_FESTIVAL_INFO["4"] or 0
  CloudData.ACTIVITY_NEW_YEAR = CloudData.ACTIVITY_FESTIVAL_INFO["5"].newyearAct or {}
  CloudData.ACTIVITY_NIAN = CloudData.ACTIVITY_FESTIVAL_INFO["5"].nianshou or 0
  CloudData.DOUBLE_ACTIVITY = jsonTable.data.actDouble
  DYNotification.postNotification(DY_KEY.kCloudDataUpdated)
end

function M:initParamData()
  local function tFuncListener(newInfo)
    M_saveValueToCloudData(newInfo)
    
    if self.checkNewReminders then
      self:checkNewReminders()
    end
    if self.mDoubleTip and CloudData.DOUBLE_ACTIVITY and tonumber(CloudData.DOUBLE_ACTIVITY.type) == 3 and CloudData.DOUBLE_ACTIVITY.status > 0 then
      self.mDoubleTip:show()
    end
  end
  
  local countCE = DataUtils.getUserCountCE()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&power=%s&token=%s&uid=%s", strAppSecret .. "", countCE .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.sign = crypto.md5(strSign, false)
  params.power = countCE
  self:safeHttpRequest("chapterInfoNew", tFuncListener, params)
end

function M:userFunUnlock()
  local userLevel = CloudData.USER_LEVEL
  DataUtils.setSceneIsUnlock("PVP", userLevel >= Const.FUNC_UNLOCK.pvp)
  DataUtils.setSceneIsUnlock("TREASURE_SCENE", userLevel >= Const.FUNC_UNLOCK.treasure)
  DataUtils.setSceneIsUnlock("SUMMON_SCENE", userLevel >= Const.FUNC_UNLOCK.summon)
  DataUtils.setSceneIsUnlock("UPGRADE_SCENE", userLevel >= Const.FUNC_UNLOCK.buddha)
  DataUtils.setSceneIsUnlock("TEAM_SCENE", userLevel >= Const.FUNC_UNLOCK.team)
  DataUtils.setSceneIsUnlock("CIMELIA_SCENE", userLevel >= Const.FUNC_UNLOCK.cimelia)
  DataUtils.setSceneIsUnlock("AGGRESS_SCENE", userLevel >= Const.FUNC_UNLOCK.aggress)
  DataUtils.setSceneIsUnlock("EQUIPMENT_SCENE", userLevel >= Const.FUNC_UNLOCK.equipment)
end

function M:dealUserProgress()
  if Const.SKIP_GUIDE then
    return
  end
  local userLevel = CloudData.USER_LEVEL
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  if stageProgress == 0 then
    self.mIsCanBGMoved = false
    
    local function tFunc()
      self:startStage(1)
    end
    
    local guideLayer = GameDialogue.new("MAP_0_1", tFunc):addTo(self, 999)
  end
  if stageProgress == 1 then
    self.mIsCanBGMoved = false
    if not DataUtils.getGuideIsFirstPlayed("DIALOGUE_STAGE2_2") then
      local function tFunc()
        local model = DataUtils.getBuddhaModel(1002)
        
        local n = require("app.layers.NewFellowLayer").new(model):addTo(self, 999, 1213)
      end
      
      local guideLayer = GameDialogue.new("MAP_0_2", tFunc):addTo(self, 999)
      return
    else
      self:performWithDelay(function()
        self:startStage(2)
      end, 1)
    end
  end
  if stageProgress == 2 then
    local function tFunc()
      if not DataUtils.getGuideIsFirstPlayed("DIALOGUE_STAGE2_3") then
        self.mIsCanBGMoved = false
        
        DataUtils.setGuideIsFirstPlayed("DIALOGUE_STAGE2_3", true)
        local guideLayer = GameDialogue.new("STAGE2_3", function()
          if tostring(CloudData.UID) ~= tostring(CloudData.USER_NAME) then
            return
          end
          
          local function tFunc()
            local guideLayer = GameDialogue.new("STAGE2_4", function()
              display.replaceScene(require("app.scenes.SceneStage").new(1, 1, 3))
            end):addTo(self, 999)
          end
          
          local nameChange = LayerChangeUserName.new(tFunc):addTo(self, 50)
          nameChange:randomName_()
        end):addTo(self, 999)
        return
      end
    end
    
    if not DataUtils.getGuideIsFirstPlayed("YueGuangBaoHe") then
      DataUtils.setGuideIsFirstPlayed("YueGuangBaoHe", true)
      local moon = require("app.sprites.PanelMoonBox").new(tFunc):addTo(self, 999)
      return
    end
  end
  if stageProgress == 4 and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE2_CHAPTERSCN") then
    self.mBgNode:setPositionX(M.BG_RIGHT)
    self.mIsCanBGMoved = false
    local guideLayer = NoviceGuide.new("GUDIE_STAGE2_CHAPTERSCN"):addTo(self, 999)
  end
  if stageProgress == 5 then
    local ac = DataUtils.getBuddhaModel(1005)
    local buddhaOnTeam = DataUtils.getBuddhaTableOnTeam()
    if ac.buddhaState == 1 and table.keyof(buddhaOnTeam, "1005") and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_CHAPTERSCN_2") then
      self.mBgNode:setPositionX(M.BG_LEFT)
      local guideLayer = NoviceGuide.new("GUDIE_STAGE6_CHAPTERSCN_2"):addTo(self, 999)
      return true
    end
    if ac.buddhaState == 1 and not table.keyof(buddhaOnTeam, "1005") and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_MONKEY_ONTEAM") then
      self.mBgNode:setPositionX(M.BG_RIGHT)
      self.mIsCanBGMoved = false
      DataUtils.setGuideIsFirstPlayed("GUDIE_STAGE6_MONKEY_ONTEAM", true)
      local guideLayer = NoviceGuide.new("GUDIE_STAGE6_CHAPTERSCN_1"):addTo(self, 999)
      return
    end
    if ac.buddhaState == 0 and ac.currPieceNum == 10 then
      local scene = require("app.scenes.UpgradeScene").new()
      display.replaceScene(scene, "FADETR", 1)
      return
    end
    if ac.buddhaState == 0 and ac.currPieceNum == 0 and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_CHAPTERSCN") then
      self.mIsCanBGMoved = false
      self.mBgNode:setPositionX(M.BG_LEFT)
      DataUtils.setGuideIsFirstPlayed("GUDIE_STAGE6_CHAPTERSCN", true)
      local guideLayer = NoviceGuide.new("GUDIE_STAGE6_CHAPTERSCN"):addTo(self, 999)
      return
    end
  end
  if stageProgress == 8 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STAGE8_CHAPTERSCN") then
    local function tFuncListener(jsonTable)
      CloudData.GAME_ITEM_INFO["3001"] = jsonTable.data["3001"]
      
      if jsonTable.data["3001"] > 0 then
        self.mIsCanBGMoved = false
        self.mBgNode:setPositionX(M.BG_RIGHT)
        local guideLayer = NoviceGuide.new("GUIDE_STAGE8_CHAPTERSCN"):addTo(self, 999)
      end
    end
    
    DYHttpMgr.getUserThingCount(tFuncListener, {ids = "3001"})
    return
  end
  if stageProgress == 10 and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE10_CHAPTERSCN") then
    self.mBgNode:setPositionX(M.BG_RIGHT)
    self.mIsCanBGMoved = false
    local guideLayer = NoviceGuide.new("GUDIE_STAGE10_CHAPTERSCN"):addTo(self, 999)
    return
  end
  if userLevel == Const.FUNC_UNLOCK.pvp and not DataUtils.getGuideIsFirstPlayed("GUIDE_LEVEL11_CHAPTERSCN") then
    self.mIsCanBGMoved = false
    self.mBgNode:setPositionX(M.BG_LEFT)
    local guideLayer = NoviceGuide.new("GUIDE_LEVEL11_CHAPTERSCN"):addTo(self, 999)
    return
  end
  if userLevel == Const.FUNC_UNLOCK.cemeliamake and not DataUtils.getGuideIsFirstPlayed("GUIDE_LEVEL12_CEMLEMAKE") then
    self.mIsCanBGMoved = false
    DDLOG(DYLang.getString("S1197", ""))
    
    local function tFuncListener(jsonTable)
      CloudData.GAME_ITEM_INFO["2009"] = jsonTable.data["2009"]
      CloudData.GAME_ITEM_INFO["2011"] = jsonTable.data["2011"]
      CloudData.GAME_ITEM_INFO["2012"] = jsonTable.data["2012"]
      if jsonTable.data["2011"] >= 10 and jsonTable.data["2009"] >= 10 and jsonTable.data["2012"] >= 10 and not DataUtils.getGuideIsFirstPlayed("GUIDE_LEVEL12_CEMLEMAKE") then
        self.mBgNode:setPositionX(M.BG_RIGHT)
        local guideLayer = NoviceGuide.new("GUIDE_LEVEL12_CEMLEMAKE"):addTo(self, 999)
      end
    end
    
    DYHttpMgr.getUserThingCount(tFuncListener, {
      ids = "2011;2009;2012"
    })
    return
  end
  if userLevel == Const.FUNC_UNLOCK.pvpOL and not DataUtils.getGuideIsFirstPlayed("GUIDE_LEVEL14_CHAPTERSCN") then
    self.mBgNode:setPositionX(M.BG_LEFT)
    local guideLayer = NoviceGuide.new("GUIDE_LEVEL14_CHAPTERSCN"):addTo(self, 999)
    return
  end
  if userLevel == Const.FUNC_UNLOCK.patrol and not DataUtils.getGuideIsFirstPlayed("GUIDE_PATROL_CHAPTERSCN") then
    self.mBgNode:setPositionX(M.BG_LEFT)
    local guideLayer = NoviceGuide.new("GUIDE_PATROL_CHAPTERSCN"):addTo(self, 999)
    return
  end
  if userLevel == Const.FUNC_UNLOCK.purgatory and not DataUtils.getGuideIsFirstPlayed("GUIDE_PURGATORY_CHAPTERSCN") then
    self.mBgNode:setPositionX(M.BG_LEFT)
    local guideLayer = NoviceGuide.new("GUIDE_PURGATORY_CHAPTERSCN"):addTo(self, 999)
    return
  end
end

function M:dealSceneReplace(funcIndex)
  if not funcIndex then
    return
  elseif funcIndex == 8 then
    LayerDungeon.new():addTo(self, 20)
  elseif funcIndex == 3 then
    LayerPVPEntrance.new():addTo(self, 20)
  elseif funcIndex == 5 then
    require("scenes.SceneTreasure").new(handler(self, self.checkNewTreasure_)):show()
  end
end

function M:initCenterScrollMap()
  self.mBgNode = display.newNode()
  local bg = display.newNode():pos(display.width, 0)
  bg:setContentSize(1920, 720)
  self.mBgSize = bg:getContentSize()
  bg:setAnchorPoint(1, 0)
  self.mBgNode:addChild(bg)
  self:addChild(self.mBgNode, 0)
  self.mBgNode:setTouchEnabled(true)
  self.mBgNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouch(event.name, event.x, event.y, 0)
  end)
  self.mBgNode:setPositionX(GameManager.BG_POINT_X)
  GameManager.BG_POINT_X = 1920 - display.width
  display.newSprite("chapter/bg1.png", self.mBgSize.width * 0.5, self.mBgSize.height * 0):addTo(bg):setAnchorPoint(0.5, 0)
  display.newSprite("chapter/trunk.png", 0, 428):addTo(bg):setAnchorPoint(0, 0)
  display.newSprite("chapter/bg2.png", self.mBgSize.width * 0.5, self.mBgSize.height * 1):addTo(bg, -2):setAnchorPoint(0.5, 1)
  local cloud1 = display.newSprite("chapter/cloud.png", self.mBgSize.width * 0.5, self.mBgSize.height * 0.5 + 249):addTo(bg, -1)
  local cloud2 = display.newSprite("chapter/cloud.png", -self.mBgSize.width * 0.5, self.mBgSize.height * 0.5 + 249):addTo(bg, -1)
  local point1 = cc.p(self.mBgSize.width * 1.5, self.mBgSize.height * 0.5 + 249)
  local point2 = cc.p(self.mBgSize.width * 0.5, self.mBgSize.height * 0.5 + 249)
  local seq1 = transition.sequence({
    cc.MoveTo:create(150, point1),
    cc.CallFunc:create(function()
      cloud1:setPositionX(self.mBgSize.width * 0.5)
    end)
  })
  local seq2 = transition.sequence({
    cc.MoveTo:create(150, point2),
    cc.CallFunc:create(function()
      cloud2:setPositionX(-self.mBgSize.width * 0.5)
    end)
  })
  cloud1:runAction(cc.RepeatForever:create(seq1))
  cloud2:runAction(cc.RepeatForever:create(seq2))
  display.newSprite("chapter/tree.png", self.mBgSize.width * 0.5 + 772, self.mBgSize.height * 0.5):addTo(bg, 1)
  display.newSprite("chapter/grass.png", self.mBgSize.width * 0.5, self.mBgSize.height * 0.5 - 249):addTo(bg, 1)
  if CloudData.MAIN_STAGE_PROGRESS < 2 and not Const.SKIP_GUIDE then
    local armature = ccs.Armature:create("zhuchangjing4")
    armature:setPosition(self.mBgSize.width * 0.5 - 84, self.mBgSize.height * 0.5 - 53)
    armature:addTo(bg, 1)
    armature:getAnimation():playWithIndex(0)
    self.mBgNode:setPositionX(400)
    return
  end
  local pointList = {
    cc.p(self.mBgSize.width * 0.5 + 741, self.mBgSize.height * 0.5 + 85),
    cc.p(self.mBgSize.width * 0.5 - 747, self.mBgSize.height * 0.5 - 360),
    cc.p(self.mBgSize.width * 0.5 - 555, self.mBgSize.height * 0.5 - 95),
    cc.p(self.mBgSize.width * 0.5 - 155, self.mBgSize.height * 0.5 - 100),
    cc.p(self.mBgSize.width * 0.5 + 90, self.mBgSize.height * 0.5 - 270),
    cc.p(self.mBgSize.width * 0.5 + 425, self.mBgSize.height * 0.5 - 138),
    cc.p(self.mBgSize.width * 0.5 + 685, self.mBgSize.height * 0.5 - 170),
    cc.p(self.mBgSize.width * 0.5 + 320, self.mBgSize.height * 0.5 - 280),
    cc.p(self.mBgSize.width * 0.5 - 784, self.mBgSize.height * 0.5 + 327),
    cc.p(self.mBgSize.width * 0.5 + 7, self.mBgSize.height * 0.5 + 335),
    cc.p(self.mBgSize.width * 0.5 + 721, self.mBgSize.height * 0.5 + 285),
    cc.p(self.mBgSize.width * 0.5 + 260, self.mBgSize.height * 0.5 + 185)
  }
  local idx = 1
  
  local function tFuncDelayLoad()
    local i = idx
    local f = "zhuchangjing" .. i
    local p = pointList[i]
    local armature = ccs.Armature:create(f)
    armature:setPosition(p)
    armature:addTo(bg, 1)
    armature:getAnimation():playWithIndex(0)
    if 7 < i then
      armature:setLocalZOrder(0)
    end
    if i == 8 then
      armature:setVisible(false)
    end
    if i < 7 then
      table.insert(self.mSceneIconTable, armature)
    end
    idx = idx + 1
    if idx <= #pointList then
      self:performWithDelay(tFuncDelayLoad, 0)
    else
      local p1 = display.newSprite("chapter/icon_travel.png", self.mBgSize.width * 0.5 - 653, self.mBgSize.height * 0.5 + 212):addTo(bg, -1)
      local p2 = display.newSprite("chapter/icon_summon.png", self.mBgSize.width * 0.5 + 263, self.mBgSize.height * 0.5 + 126):addTo(bg, -1)
      table.insert(self.mSceneIconTable, p1)
      local p = display.newSprite("chapter/icon_travel1.png", p1:getContentSize().width / 2, p1:getContentSize().height / 2):addTo(p1)
      p:runAction(cc.RepeatForever:create(transition.sequence({
        cc.FadeOut:create(1),
        cc.FadeIn:create(1)
      })))
      display.addSpriteFrames("chapter/summon_tx.plist", "chapter/summon_tx.png")
      local frames = display.newFrames("zhaohuanzouguang%d.png", 1, 9)
      local animation = display.newAnimation(frames, 0.2)
      local emptyPic = display.newSprite():pos(p2:getContentSize().width / 2, p2:getContentSize().height / 2 + 20):addTo(p2)
      emptyPic:playAnimationForever(animation, 0)
      local p3 = display.newSprite("chapter/icon_rank.png", self.mBgSize.width * 0.5 - 420, self.mBgSize.height * 0.5 - 200):addTo(bg, 1)
      table.insert(self.mSceneIconTable, p3)
      local p4 = display.newSprite("chapter/icon_equipment.png", self.mBgSize.width * 0.5 + 525, self.mBgSize.height * 0.5 - 260):addTo(bg, 1)
      table.insert(self.mSceneIconTable, p4)
    end
  end
  
  self:performWithDelay(tFuncDelayLoad, 0)
  local labelList = {}
  local labelFrame = display.newSprite("chapter/label_frame.png"):pos(pointList[7].x + 15, pointList[7].y + 65):addTo(bg, 2)
  if CloudData.USER_LEVEL <= 10 then
    labelList = {
      DYLang.getString("S1198", ""),
      DYLang.getString("S1199", ""),
      DYLang.getString("S1198", ""),
      DYLang.getString("S1199", "")
    }
  else
    labelList = {
      DYLang.getString("S1202", ""),
      DYLang.getString("S1203", ""),
      DYLang.getString("S1204", ""),
      DYLang.getString("S1205", "")
    }
  end
  local randNum = math.random(1, 4)
  local labelText = DYLabelTTF.new({
    text = "",
    size = 15,
    color = cc.c3b(99, 48, 10),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(5, 22):addTo(labelFrame)
  local callFunc1 = cc.CallFunc:create(function()
    labelFrame:show()
    labelText:setString(labelList[randNum])
  end)
  local callFunc2 = cc.CallFunc:create(function()
    labelFrame:show()
    labelText:setString(labelList[2])
  end)
  local callFunc3 = cc.CallFunc:create(function()
    labelFrame:show()
    labelText:setString(labelList[3])
  end)
  local callFunc4 = cc.CallFunc:create(function()
    labelFrame:show()
    labelText:setString(labelList[4])
  end)
  local callFunc = cc.CallFunc:create(function()
    labelFrame:hide()
  end)
  local delayTime1 = cc.DelayTime:create(5)
  local delayTime2 = cc.DelayTime:create(10)
  local seq = transition.sequence({
    callFunc1,
    delayTime1,
    callFunc,
    delayTime2,
    callFunc2,
    delayTime1,
    callFunc,
    delayTime2,
    callFunc3,
    delayTime1,
    callFunc,
    delayTime2,
    callFunc4,
    delayTime1,
    callFunc,
    delayTime2
  })
  labelFrame:runAction(cc.RepeatForever:create(seq))
  local sizeList = {
    cc.size(185, 200),
    cc.size(285, 252),
    cc.size(300, 170),
    cc.size(270, 180),
    cc.size(240, 270),
    cc.size(200, 235),
    cc.size(300, 145),
    cc.size(140, 181),
    cc.size(213, 230)
  }
  local offsetY = {
    0,
    0,
    0,
    0,
    -65,
    -35,
    -120
  }
  for i = 1, #sizeList do
    local icon = display.newScale9Sprite("chapter/blank.png", 0, 0, sizeList[i], cc.rect(30, 30, 2, 2)):opacity(125):addTo(bg, 2)
    icon:setAnchorPoint(0.5, 0)
    if i <= #sizeList - 3 then
      icon:setPosition(pointList[i].x, pointList[i].y + offsetY[i])
    elseif i == #sizeList - 2 then
      icon:setPosition(self.mBgSize.width * 0.5 - 570, self.mBgSize.height * 0.5 + 80)
    elseif i == #sizeList - 1 then
      icon:setPosition(self.mBgSize.width * 0.5 - 420, self.mBgSize.height * 0.5 - 290)
    else
      icon:setPosition(self.mBgSize.width * 0.5 + 525, self.mBgSize.height * 0.5 - 355)
    end
    icon:setTouchEnabled(true)
    icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onTouch(event.name, event.x, event.y, i)
    end)
    local point = {
      x = icon:getPositionX(),
      y = icon:getPositionY()
    }
    local iconName = SceneIcon.new(i, point):addTo(bg, 3)
    iconName:setTouchEnabled(true)
    iconName:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onTouch(event.name, event.x, event.y, i)
    end)
    table.insert(self.mSceneNameTable, iconName)
  end
  local pos = pointList[6]
  self.mDoubleTip = display.newSprite("chapter/img_double.png", pos.x, pos.y + 200):hide():addTo(bg, 4)
end

function M:initTopInfoUI()
  local iconFrame = display.newSprite("user_center/icon_frame.png"):align(display.LEFT_TOP, 0, display.height):addTo(self, 15)
  self.mUserIcon = display.newSprite(CloudData.USER_ICON):pos(iconFrame:getContentSize().width * 0.44, iconFrame:getContentSize().height * 0.61):addTo(iconFrame, -1)
  self.mUserLevel = cc.ui.UILabel.new({
    text = CloudData.USER_LEVEL,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, iconFrame:getContentSize().width * 0.82, iconFrame:getContentSize().height * 0.32):addTo(iconFrame)
  self.mUserVipLevel = display.newSprite(string.format("recharge/vip%d.png", CloudData.VIP_LEVEL)):scale(0.6):align(display.CENTER, iconFrame:getContentSize().width * 0.45, iconFrame:getContentSize().height * 0.11):addTo(iconFrame)
  iconFrame:setTouchEnabled(true)
  iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      return true
    end
    if name == "ended" then
      local pLayer = LayerUserCenter.new(handler(self, self.usercenterNew))
      self:addChild(pLayer, 20)
    end
  end)
  self.mUserIconNew = display.newSprite("common_ui/red_point.png"):pos(iconFrame:getContentSize().width - 40, iconFrame:getContentSize().height - 30):addTo(iconFrame, 1)
  self.mUserIconNew:setVisible(false)
  self:usercenterNew()
  local energyLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ENERGY, true)
  energyLabel:setPosition(cc.p(display.width * 0.27, display.height * 0.96))
  self:addChild(energyLabel, 15)
  local essenceLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ESSENCE, true)
  essenceLabel:setPosition(cc.p(display.width * 0.56, display.height * 0.96))
  self:addChild(essenceLabel, 15)
  local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH, true)
  peachLabel:setPosition(cc.p(display.width * 0.85, display.height * 0.96))
  self:addChild(peachLabel, 15)
  if DYUtils.gameMode() == "debug" then
    local wizardIcon = display.newSprite("stage/star.png"):align(display.RIGHT_TOP, display.width, display.height):addTo(self, 15)
    wizardIcon:setTouchEnabled(true)
    wizardIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onTouchWizardIcon(event.name, event.x, event.y)
    end)
  end
end

function M:usercenterNew()
  if not self or not self.mUserIconNew then
    return
  end
  local str = string.format(DY_KEY.kBindPhoneNew, CloudData.UID)
  local isBindNew = DYStat.getValueInt(str, 0)
  if isBindNew == 0 and CloudData.GOT_PHONE_AWARD == 0 then
    self.mUserIconNew:setVisible(true)
  else
    self.mUserIconNew:setVisible(false)
  end
end

function M:initFunctionsBtn()
  local funcList = {
    [1] = {
      path = "chapter/func_recharge.png",
      index = 1
    },
    [2] = {
      path = "chapter/func_sign.png",
      index = 2
    },
    [3] = {
      path = "chapter/func_task.png",
      index = 3
    },
    [4] = {
      path = "chapter/func_activity.png",
      index = 4
    },
    [5] = {
      path = "chapter/func_union.png",
      index = 5
    },
    [6] = {
      path = "chapter/func_festival.png",
      index = 6
    },
    [7] = {
      path = "chapter/func_activity7.png",
      index = 7
    },
    [8] = {
      path = "chapter/func_shop.png",
      index = 8
    },
    [9] = {
      path = "chapter/func_gift.png",
      index = 9
    },
    [10] = {
      path = "chapter/func_ranking.png",
      index = 10
    }
  }
  if 0 == CloudData.FESTIVAL_ACT_TYPE then
    funcList[6].path = CloudData.NEW_BUDDHA_ICON
  elseif 4 == CloudData.FESTIVAL_ACT_TYPE then
    funcList[6].path = CloudData.ACT_BUDDHA_ICON
  elseif 6 == CloudData.FESTIVAL_ACT_TYPE then
    funcList[6].path = CloudData.ACT_BUDDHA_ICON
  else
    funcList[6].path = string.format("chapter/func_festival%d.png", CloudData.FESTIVAL_ACT_TYPE)
  end
  if 0 == CloudData.IS_ACTIVITY_SEVEN_OPEN then
    funcList[7] = nil
  end
  if not CloudData.RECHARGE_REWARD then
    funcList[9] = nil
  elseif CloudData.RECHARGE_REWARD.isFirst ~= 1 then
    funcList[9].path = "chapter/func_gift1.png"
  end
  if not CloudData.IS_RANKING_AWARD_OPEN then
    funcList[10] = nil
  end
  local tempList = {}
  for k, v in pairs(funcList) do
    if v then
      table.insert(tempList, v)
    end
  end
  table.sort(tempList, function(v1, v2)
    return v1.index < v2.index
  end)
  local sc = 1
  if display.sizeInPixels.width / display.sizeInPixels.height < 1.5 then
    sc = 0.85
  end
  for i = 1, #tempList do
    local posX = 160
    if 1 < i then
      local lastIdx = tempList[i - 1].index
      lastIcon = self.mFuncIconTable[lastIdx]
      posX = lastIcon:getPositionX() + lastIcon:getContentSize().width * 0.5 * sc
    end
    local data = tempList[i]
    local btn = FunctionIcon.new(data.path)
    btn:setPosition(posX + 10 * sc + btn:getContentSize().width * 0.5 * sc, display.height * 0.85)
    btn:setScale(sc)
    self:addChild(btn, 5)
    self.mFuncIconTable[data.index] = btn
    posX = posX + 100
    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
      if name == "began" then
        btn.pointBegan = {x = x, y = y}
        btn:setScale(0.9)
        return true
      elseif name == "moved" then
        local pointMove = {x = x, y = y}
        if math.abs(btn.pointBegan.x - pointMove.x) < 30 and math.abs(btn.pointBegan.y - pointMove.y) < 30 then
          btn:setScale(0.9)
        else
          btn:setScale(1)
        end
      elseif name == "ended" then
        local pointEnd = {x = x, y = y}
        if math.abs(btn.pointBegan.x - pointEnd.x) < 30 and math.abs(btn.pointBegan.y - pointEnd.y) < 30 then
          btn:setScale(1)
          self:touchFunctionsBtn(data.index)
        end
      end
    end)
  end
end

function M:initLeftBottomBtn()
  if CloudData.USER_LEVEL < 10 then
    return
  end
  self.mChatBtn = cc.ui.UIPushButton.new({
    normal = "chapter/bt_chat.png"
  }):align(display.CENTER_LEFT, 0, display.height * 0.5):addTo(self, 5):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function(event)
    if GameManager.IS_CHAT_LOGIN_OK then
      LayerChat.new(1, nil, handler(self, self.checkNewChat)):addTo(self, 20)
    else
      local msg = DYLang.getString("S1207", "")
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    end
  end)
  self.mChatBtn.newMark = display.newSprite("friends/bubble_msg.png"):hide():pos(52, 37):addTo(self.mChatBtn)
  GameManager.CHAT_BTN = self.mChatBtn
  if CloudData.IS_NEW_UNION_CHAT then
    self.mChatBtn.newMark:show()
  end
end

function M:initRightBottomBtn()
  local btnList = {
    "chapter/btn_friends.png",
    "chapter/btn_notice.png",
    "chapter/btn_mail.png",
    "chapter/btn_packge.png",
    "chapter/btn_wiki.png",
    "chapter/btn_treasure.png",
    "chapter/btn_team.png"
  }
  local btnCount = #btnList
  local mainBtn = display.newSprite("chapter/button.png", display.width * 0.92, display.height * 0.1):opacity(150):scale(0.85):addTo(self, 5)
  self.mBottomNew = display.newSprite("common_ui/new.png"):pos(mainBtn:getPositionX() + 30, mainBtn:getPositionY() + 35):hide():addTo(self, 6)
  local seq = transition.sequence({
    cc.FadeOut:create(0.5),
    cc.FadeIn:create(0.5)
  })
  self.mBottomNew:runAction(cc.RepeatForever:create(seq))
  local barFrame = display.newScale9Sprite("chapter/bar_frame.png", display.width * 0.92, display.height * 0.1, cc.size(60 + 110 * btnCount, 103), cc.rect(240, 50, 5, 5))
  barFrame:setScaleX(0)
  barFrame:setAnchorPoint(1, 0.5)
  self:addChild(barFrame, 4)
  barFrame:setTouchEnabled(true)
  barFrame:setTouchSwallowEnabled(true)
  local tFunc = {
    [1] = function()
      if CloudData.USER_LEVEL < Const.FUNC_UNLOCK.friend then
        WSToast.new(DYLang.getString("STR_FUNC_FRIEND", "") .. Const.FUNC_UNLOCK.friend .. DYLang.getString("S1211", "")):addTo(self, 50)
      elseif GameManager.IS_CHAT_LOGIN_OK then
        local nextScene = LayerFriends.scene()
        EffectMgr.gotoLayerScene(nextScene)
      else
        local msg = DYLang.getString("S1207", "")
        local toast = WSToast.new(msg, 2)
        self:addChild(toast, 20)
      end
    end,
    [2] = function()
      LayerNotice.new(true):addTo(self, 20)
    end,
    [3] = function()
      EffectMgr.gotoLayerScene(LayerMail.new(EffectMgr.gotoChapter))
    end,
    [4] = function()
      if CloudData.USER_LEVEL >= Const.FUNC_UNLOCK.package then
        EffectMgr.gotoLayerScene(LayerPackage.new(EffectMgr.gotoChapter))
      else
        WSToast.new(DYLang.getString("S1210", "") .. Const.FUNC_UNLOCK.package .. DYLang.getString("S1211", "")):addTo(self, 50)
      end
    end,
    [5] = function()
      EffectMgr.gotoLayerScene(require("scenes.SceneWiki").new(EffectMgr.gotoChapter))
    end,
    [6] = function()
      EffectMgr.gotoLayerScene(require("scenes.SceneTreasure").new(EffectMgr.gotoChapter))
    end,
    [7] = function()
      EffectMgr.gotoLayerScene(LayerTeam.new(nil, EffectMgr.gotoChapter))
    end
  }
  for i = 1, btnCount do
    local btn = cc.ui.UIPushButton.new({
      normal = btnList[i],
      pressed = btnList[i]
    }):onButtonPressed(function(event)
      event.target:setScale(0.9)
    end):onButtonRelease(function(event)
      event.target:setScale(1)
    end):onButtonClicked(function(event)
      tFunc[i]()
    end):align(display.CENTER, barFrame:getContentSize().width - 120 - 110 * (i - 1), barFrame:getContentSize().height * 0.51):addTo(barFrame)
    btn.newMark = display.newSprite("common_ui/red_point.png", 35, 25):hide():addTo(btn)
    table.insert(self.mRightBtnTable, btn)
  end
  mainBtn:setTouchEnabled(true)
  mainBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      if self.mIsRightBtnCanClicked then
        DYSoundMgr.playEffect(DY_SND.sfx_touch)
        self.mIsRightBtnCanClicked = false
        if self.mIsRightBtnOpened then
          local spawn = cc.Spawn:create(cc.ScaleTo:create(0.1, 0.85), cc.FadeTo:create(0.1, 150))
          mainBtn:runAction(transition.sequence({
            cc.RotateBy:create(0.25, -90),
            spawn,
            cc.CallFunc:create(function()
              self.mIsRightBtnOpened = false
              self.mIsRightBtnCanClicked = true
            end)
          }))
          barFrame:runAction(cc.ScaleTo:create(0.25, 0, 1))
        else
          local spawn = cc.Spawn:create(cc.ScaleTo:create(0.1, 1), cc.FadeTo:create(0.1, 255))
          mainBtn:runAction(transition.sequence({
            spawn,
            cc.RotateBy:create(0.25, 90),
            cc.CallFunc:create(function()
              self.mIsRightBtnOpened = true
              self.mIsRightBtnCanClicked = true
            end)
          }))
          barFrame:runAction(transition.sequence({
            cc.DelayTime:create(0.1),
            cc.ScaleTo:create(0.25, 1, 1)
          }))
        end
      end
      return true
    end
  end)
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new()
  self:add(self.mPkBubble, 900)
end

function M:loadFestivalFuncBtn()
  local iconList = {
    [1] = CloudData.NEW_BUDDHA_ICON,
    [2] = "new_year/icon_spin.png",
    [3] = string.format("new_year/icon_packet%d.png", CloudData.FESTIVAL_ACT_TYPE),
    [4] = string.format("new_year/icon_nian%d.png", CloudData.FESTIVAL_ACT_TYPE),
    [5] = "new_year/icon_collect.png",
    [6] = "new_year/icon_adventure.png",
    [7] = CloudData.ACT_BUDDHA_ICON,
    [8] = "new_year/icon_newyear.png"
  }
  local count = #CloudData.FESTIVAL_ACT_LIST
  local icon = self.mFuncIconTable[6]
  local frame = display.newScale9Sprite("chapter/frame.png", 0, 0, cc.size(120 * count, 128), cc.rect(40, 70, 1, 1)):scale(0):pos(icon:getPositionX(), icon:getPositionY() - 40):addTo(self, 6)
  frame:setAnchorPoint(1 / count * (count - 0.33), 1)
  self.mFestivalFrame = frame
  
  function frame:openFestival()
    self:runAction(cc.ScaleTo:create(0.2, 1))
  end
  
  function frame:closeFestival()
    self:runAction(cc.ScaleTo:create(0.2, 0))
  end
  
  local function onEventActivityBtn(idx)
    local tFunc = {
      [1] = function()
        LayerNewBuddha.new(handler(self, self.onEventFuncFestival)):addTo(self, 20)
      end,
      [2] = function()
        LayerSpin.new(handler(self, self.onEventFuncFestival)):addTo(self, 20)
      end,
      [3] = function()
        LayerRedPacket.new(handler(self, self.onEventFuncFestival)):addTo(self, 20)
      end,
      [4] = function()
        self:loadActivityNian()
      end,
      [5] = function()
        LayerCollection.new(handler(self, self.onEventFuncFestival)):addTo(self, 20)
      end,
      [6] = function()
        LayerChess.new(handler(self, self.onEventFuncFestival)):addTo(self, 20)
      end,
      [7] = function()
        LayerActivityBuddha.new(handler(self, self.onEventFuncFestival)):addTo(self, 20)
      end,
      [8] = function()
        LayerNewYear.new(handler(self, self.onEventFuncFestival)):addTo(self, 20)
      end
    }
    tFunc[idx]()
  end
  
  for i = 1, count do
    local id = CloudData.FESTIVAL_ACT_LIST[i]
    local btn = cc.ui.UIPushButton.new({
      normal = iconList[id],
      pressed = iconList[id]
    }):onButtonPressed(function(event)
      event.target:setScale(0.85)
    end):onButtonRelease(function(event)
      event.target:setScale(1)
    end):onButtonClicked(function(event)
      onEventActivityBtn(id)
    end):align(display.CENTER, 120 * i - 60, frame:getContentSize().height * 0.42):addTo(frame)
    btn.redPoint = display.newSprite("common_ui/red_point.png", 25, 30):hide():addTo(btn)
    self.mFestivalFuncBtn[id] = btn
  end
end

function M:touchSceneIcon(index)
  if not self.mCanBeClicked or 0 == index then
    return
  end
  self.mCanBeClicked = false
  local iconName = self.mSceneNameTable[index]
  if not iconName.mIsUnlock then
    local str = DYLang.getString("S1215", "") .. iconName.mUnlockLevel .. DYLang.getString("S1211", "")
    WSToast.new(str):addTo(self, 50)
    self.mCanBeClicked = true
    return
  end
  GameManager.BG_POINT_X = self.mBgNode:getPositionX()
  local tFunc = {
    [1] = function()
      LayerBossRelated.new():addTo(self, 20)
    end,
    [2] = function()
      EffectMgr.gotoLayerScene(require("scenes.SceneSummon").new())
    end,
    [3] = function()
      if not GameManager.IS_CHAT_LOGIN_OK then
        WSToast.new("PVP\229\136\157\229\167\139\229\140\150\230\156\170\229\174\140\230\136\144"):addTo(self, 100)
      else
        LayerPVPEntrance.new():addTo(self, 20)
      end
    end,
    [4] = function()
      display.replaceScene(require("scenes.SceneStage").new())
    end,
    [5] = function()
      display.replaceScene(require("cimelia.scenes.SceneCimelia").new())
    end,
    [6] = function()
      display.replaceScene(require("scenes.UpgradeScene").new())
    end,
    [7] = function()
      LayerDungeon.new():addTo(self, 20)
    end,
    [8] = function()
      EffectMgr.gotoLayerScene(LayerRankList.new(nil, EffectMgr.gotoChapter))
    end,
    [9] = function()
      display.replaceScene(require("equipment.scenes.SceneEquipment").new())
    end
  }
  local icon = self.mSceneIconTable[index]
  if icon then
    icon:runAction(transition.sequence({
      cc.ScaleTo:create(0.1, 1.2),
      cc.ScaleTo:create(0.1, 1),
      cc.CallFunc:create(function()
        self.mCanBeClicked = true
        tFunc[index]()
      end)
    }))
  end
end

function M:touchFunctionsBtn(index)
  local tFunc = {
    [1] = function()
      LayerRecharge.new():addTo(self, 20)
    end,
    [2] = function()
      LayerSign.new(handler(self, self.onEventFuncSign)):addTo(self, 20)
    end,
    [3] = function()
      LayerAchievement.new(handler(self, self.checkNewTask_)):addTo(self, 20)
    end,
    [4] = function()
      LayerActivity.new(handler(self, self.onEventFuncActivity)):addTo(self, 20)
    end,
    [5] = function()
      self:enterUnion()
    end,
    [6] = function()
      if 0 == CloudData.FESTIVAL_ACT_TYPE then
        LayerNewBuddha.new(handler(self, self.onEventActivityBuddha)):addTo(self, 20)
      elseif 4 == CloudData.FESTIVAL_ACT_TYPE then
        LayerActivityBuddha.new(handler(self, self.onEventActivityBuddha)):addTo(self, 20)
      else
        local s = self.mFestivalFrame:getScale()
        if 1 == s then
          self.mFestivalFrame:closeFestival()
        end
        if 0 == s then
          self.mFestivalFrame:openFestival()
        end
      end
    end,
    [7] = function()
      LayerActivitySeven.new(handler(self, self.onEventFuncActivitySeven)):addTo(self, 20)
    end,
    [8] = function()
      LayerShopNew.new(1, handler(self, self.onEventFuncShop)):addTo(self, 20)
    end,
    [9] = function()
      LayerFirstRecharge.new(handler(self, self.onEventFuncFirstRecharge)):addTo(self, 20)
    end,
    [10] = function()
      LayerRankingAward.new():addTo(self, 20)
    end
  }
  tFunc[index]()
end

function M:loadActivityNian()
  local function tFunc(jsonTable)
    if jsonTable.errorCode > 0 then
      WSToast.new(jsonTable.errorMsg, 2):addTo(self, 50)
    else
      display.replaceScene(require("scenes.ScenePlace").new())
    end
  end
  
  local power = M.getAllBuddhaCE()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&power=%s&token=%s&uid=%s", strAppSecret .. "", power .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.power = power
  params.sign = crypto.md5(strSign, false)
  DYHttpMgr.requestPlaceActiveOpen(tFunc, params)
end

function M:enterUnion()
  if CloudData.USER_LEVEL < Const.FUNC_UNLOCK.union then
    local str = string.format(DYLang.getString("S1230", ""), Const.FUNC_UNLOCK.union)
    WSToast.new(str):addTo(self, 20)
    return
  end
  
  local function tFuncEvent(param)
    DDLOG(" ================ GET_UNION_ID !!!!!!!")
    CloudData.UNION_ID = param.clan_id
    if CloudData.UNION_ID and CloudData.UNION_ID > 0 then
      display.replaceScene(require("union.scenes.SceneUnion").new())
    else
      LayerUnionApply.new():addTo(self, 20)
    end
  end
  
  self:safeSocketRequest("CMD_UNION_ID", nil, tFuncEvent)
end

function M:checkNewReminders()
  self:checkNewMail_()
  self:checkNewSummon_()
  self:checkNewBuddha_()
  self:checkNewSign_()
  if CloudData.USER_LEVEL >= 5 then
    self:checkNewTask_()
  end
  self:checkNewTreasure_()
  self:checkNewPVPLog_()
  if CloudData.RECHARGE_REWARD then
    self:checkNewFirstRecharge()
  end
  self:checkNewActivity()
  self:checkNewShop()
  if 0 == CloudData.FESTIVAL_ACT_TYPE or 4 == CloudData.FESTIVAL_ACT_TYPE then
    self:checkNewActivityBuddha()
  else
    self:checkFestivalActivity()
  end
  if 1 == CloudData.IS_ACTIVITY_SEVEN_OPEN then
    self:checkNewActivitySeven()
  end
  self:checkDungeonBox()
  self:checkNewFriendApply()
  self:checkNewAggress()
end

function M:checkNewMail_()
  local msgList = CloudData.SERVER_MSG and CloudData.SERVER_MSG.msg or {}
  local mailIcon = self.mRightBtnTable[3]
  if msgList and 0 < #msgList then
    CloudData.NEW_MAIL = 1
    mailIcon.newMark:show()
    self.mBottomNew:show()
  else
    CloudData.NEW_MAIL = 0
    mailIcon.newMark:hide()
    if CloudData.NEW_FRIEND_APPLY == 0 then
      self.mBottomNew:hide()
    end
  end
end

function M:checkNewFriendApply()
  if CloudData.USER_LEVEL < Const.FUNC_UNLOCK.friend then
    return
  end
  local friendIcon = self.mRightBtnTable[1]
  if CloudData.NEW_FRIEND_APPLY == 1 or table.nums(CloudData.CHAT_NEW_LIST) > 0 then
    friendIcon.newMark:show()
    self.mBottomNew:show()
  else
    friendIcon.newMark:hide()
    if CloudData.NEW_MAIL == 0 then
      self.mBottomNew:hide()
    end
  end
end

function M:checkNewSummon_()
  if not DataUtils.getSceneIsUnlock("SUMMON_SCENE", false) then
    return
  end
  local nextCommonFreeTime = CloudData.NEXT_COMMON_FREE_TIME
  local nextAdvanceFreeTime = CloudData.NEXT_ADVANCE_FREE_TIME
  local commonFreeNum = CloudData.COMMON_FREE_NUM
  local delayTime = 0
  if 0 < commonFreeNum then
    if nextCommonFreeTime <= nextAdvanceFreeTime then
      delayTime = nextCommonFreeTime
    else
      delayTime = nextAdvanceFreeTime
    end
  else
    delayTime = nextAdvanceFreeTime
  end
  self:performWithDelay(function()
    local icon = self.mSceneNameTable[2]
    if icon then
      icon:setMarkVisible(true)
    end
  end, delayTime)
end

function M:checkNewBuddha_()
  local upgradeIcon = self.mSceneNameTable[6]
  if upgradeIcon and DataUtils.getSceneIsUnlock("UPGRADE_SCENE") then
    for k, v in pairs(GameManager.UNLOCK_BUDDHA_ID) do
      local pieceInfo = DataUtils.getUnlockBuddhaPieceInfo(v)
      if pieceInfo.currPieceNum >= pieceInfo.summonCostNum then
        upgradeIcon:setMarkVisible(true)
        break
      else
        upgradeIcon:setMarkVisible(false)
      end
    end
  end
end

function M:checkNewSign_()
  local signIcon = self.mFuncIconTable[2]
  if CloudData.IS_SIGNED_TODAY == 0 then
    signIcon:setMarkVisible(true)
  else
    signIcon:setMarkVisible(false)
  end
end

function M:checkNewFirstRecharge()
  if not CloudData.RECHARGE_REWARD then
    return
  end
  local icon = self.mFuncIconTable[9]
  if CloudData.MONEY >= CloudData.RECHARGE_REWARD.money then
    icon:setMarkVisible(true)
  else
    icon:setMarkVisible(false)
  end
end

function M:checkNewTask_()
  local taskIcon = self.mFuncIconTable[3]
  GameManager.IS_ACHIEVEMENT_NEW = DataUtils.isAchievementNew()
  GameManager.IS_DAILY_TASK_NEW = DataUtils.isTaskNew()
  if GameManager.IS_ACHIEVEMENT_NEW or GameManager.IS_DAILY_TASK_NEW then
    taskIcon:setMarkVisible(true)
  else
    taskIcon:setMarkVisible(false)
  end
end

function M:checkNewTreasure_()
end

function M:checkNewPVPLog_()
  local time = CloudData.MAX_PVP_LOG_TIME
  local regionId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kPvpLogId, regionId, CloudData.UID)
  local lastLogTime = DYStat.getValueInt(str, 0)
  if time > lastLogTime then
    local pvpIcon = self.mSceneNameTable[3]
    pvpIcon:setMarkVisible(true)
  end
end

function M:checkNewActivity()
  local icon = self.mFuncIconTable[4]
  if CloudData.ACTIVITY_INFO and #CloudData.ACTIVITY_INFO > 0 then
    icon:setMarkVisible(true)
  else
    icon:setMarkVisible(false)
  end
end

function M:checkNewActivityBuddha()
  local icon = self.mFuncIconTable[6]
  if 1 == CloudData.ACTIVITY_BUDDHA or 1 == CloudData.NEW_BUDDHA_INFO then
    icon:setMarkVisible(true)
  else
    icon:setMarkVisible(false)
  end
end

function M:checkNewActivitySeven()
  local icon = self.mFuncIconTable[7]
  if CloudData.ACTIVITY_SEVEN_INFO and #CloudData.ACTIVITY_SEVEN_INFO > 0 then
    icon:setMarkVisible(true)
  else
    icon:setMarkVisible(false)
  end
end

function M:checkNewShop()
  if CloudData.ACTIVITY_VIP_INFO == nil then
    DDTRACE("ChapterScene:checkNewShop", string.format("platform : %s", device.platform))
    return
  end
  local icon = self.mFuncIconTable[8]
  if #CloudData.ACTIVITY_VIP_INFO > 0 or 1 == CloudData.ACTIVITY_INVEST or 1 == CloudData.MYSTERY_SHOP_NEW then
    icon:setMarkVisible(true)
  else
    icon:setMarkVisible(false)
  end
end

function M:checkFestivalActivity()
  local icon = self.mFuncIconTable[6]
  local count = 0
  local tFunc = {
    [1] = function(btn)
      if CloudData.NEW_BUDDHA_INFO == 1 then
        return true
      end
    end,
    [2] = function(btn)
      if CloudData.SPIN_INFO > 0 then
        return true
      end
    end,
    [3] = function(btn)
      if CloudData.RED_PACKET_INFO > 0 then
        return true
      end
    end,
    [4] = function(btn)
      if CloudData.ACTIVITY_NIAN == 1 then
        return true
      end
    end,
    [5] = function(btn)
      return false
    end,
    [6] = function(btn)
      return false
    end,
    [7] = function(btn)
      if CloudData.ACTIVITY_BUDDHA == 1 then
        return true
      end
    end,
    [8] = function(btn)
      if #CloudData.ACTIVITY_NEW_YEAR > 0 then
        return true
      end
    end
  }
  for i = 1, #CloudData.FESTIVAL_ACT_LIST do
    local id = CloudData.FESTIVAL_ACT_LIST[i]
    local btn = self.mFestivalFuncBtn[id]
    local flag = tFunc[id](btn) or false
    btn.redPoint:setVisible(flag)
    if flag then
      count = count + 1
    end
  end
  if 0 < count then
    icon:setMarkVisible(true)
  else
    icon:setMarkVisible(false)
  end
end

function M:checkNewNian()
end

function M:checkNewChat()
  self.mChatBtn.newMark:hide()
  if CloudData.IS_NEW_UNION_CHAT then
    self.mChatBtn.newMark:show()
    return
  end
end

function M:checkDungeonBox()
  local dungeonIcon = self.mSceneNameTable[4]
  if not dungeonIcon then
    return
  end
  if DataUtils.newStageBox(CloudData.DUNGEON_BOX_INFO) then
    dungeonIcon:setMarkVisible(true)
  else
    dungeonIcon:setMarkVisible(false)
  end
end

function M:checkNewAggress()
  local icon = self.mSceneNameTable[1]
  if not icon then
    return
  end
  if CloudData.NEW_AGGRESS == 1 then
    icon:setMarkVisible(true)
  else
    icon:setMarkVisible(false)
  end
end

function M:onEventMail()
  self:checkNewMail_()
  self:checkNewBuddha_()
end

function M:onEventFuncSign()
  self:checkNewSign_()
  self:checkNewBuddha_()
end

function M:onEventFuncFirstRecharge()
  if not CloudData.RECHARGE_REWARD then
    local rechargeIcon = self.mFuncIconTable[9]
    rechargeIcon:hide()
    local iconNext = self.mFuncIconTable[10]
    if iconNext then
      iconNext:setPositionX(rechargeIcon:getPositionX())
    end
  else
    if CloudData.RECHARGE_REWARD.isFirst ~= 1 then
      self.mFuncIconTable[9]:updateIcon("chapter/func_gift1.png")
    end
    self:checkNewFirstRecharge()
  end
  self:checkNewBuddha_()
end

function M:onEventFuncActivity()
  self:checkNewActivity()
  self:checkNewBuddha_()
end

function M:onEventFuncActivitySeven()
  self:checkNewActivitySeven()
  self:checkNewBuddha_()
end

function M:onEventFuncShop()
  self:checkNewShop()
  self:checkNewBuddha_()
end

function M:onEventActivityBuddha()
  self:checkNewActivityBuddha()
  self:checkNewBuddha_()
end

function M:onEventFuncFestival()
  self:checkFestivalActivity()
  self:checkNewBuddha_()
end

function M:playUnlockAnimation(idx)
end

function M:onTouch(event, x, y, tag)
  if event == "began" then
    self.mPointBegin = {x = x, y = y}
    self.mNodePoint = {x = x, y = y}
    return true
  end
  if event == "moved" then
    local point_moved = {x = x, y = y}
    local rect = cc.rect(0, 0, display.width, display.height)
    if self.mIsCanBGMoved and self.mNodePoint and cc.rectContainsPoint(rect, point_moved) then
      local cx, cy = self.mBgNode:getPosition()
      self.mBgNode:setPosition(cx + (x - self.mNodePoint.x) * 2, cy)
      self.mNodePoint = {x = x, y = y}
      local minX = 0
      local maxX = self.mBgSize.width - display.width
      local currX = self.mBgNode:getPositionX()
      if minX > currX then
        self.mBgNode:setPositionX(minX)
      end
      if maxX < currX then
        self.mBgNode:setPositionX(maxX)
      end
    end
  end
  if event == "ended" then
    self.mNodePoint = nil
    local pointEnd = {x = x, y = y}
    if math.abs(pointEnd.x - self.mPointBegin.x) < 30 and math.abs(pointEnd.y - self.mPointBegin.y) < 30 then
      self:touchSceneIcon(tag)
    end
  end
end

function M:startStage(stageNum)
  local function tFuncListener(jsonTable)
    local pData = jsonTable.data
    
    CloudData.PVE_ATK_CIMELIA_DATA = pData.attackCimelia
    CloudData.PVE_DEF_CIMELIA_DATA = pData.defenceCimelia
    for k, info in pairs(pData.teamList) do
      local npcId = info.id or 0
      CloudData.NPC_INFO[tonumber(npcId)] = info
    end
    CloudData.ENERGY = CloudData.ENERGY - 8
    GameManager.ENERGY_COST = 8
    GameManager.STAGE_ID = stageNum + 10000
    GameManager.STAGE_NUM = stageNum or 0
    GameManager.MODE = 0
    display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE", "NORMAL"))
  end
  
  DYHttpMgr.getFightData(tFuncListener, {fightMode = 0})
end

function M:updateScrollMsg()
  local function tFuncListener(jsonTable)
    if not self or self.__cname ~= "ChapterScene" then
      return
    end
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 50)
      return
    end
    if jsonTable.data then
      for k, v in pairs(jsonTable.data) do
        table.insert(CloudData.SCROLL_MSG, v)
        local str = DataUtils.getSystemText(v)
        if checkstring(str) ~= "" then
          table.insert(CloudData.SYSTEM_MSG_LOG, str)
          DYNotification.postNotification(DY_KEY.kUpdateSystemMsg, str)
        end
      end
    end
    if not self.mIsScrollShow and self.showScrollMsg then
      self:showScrollMsg()
    end
  end
  
  DYHttpMgr.getScrollCaptionList(tFuncListener)
end

function M:showScrollMsg()
  if not CloudData.SCROLL_MSG or #CloudData.SCROLL_MSG <= 0 then
    self.mIsScrollShow = false
    return
  end
  self.mIsScrollShow = true
  local msgInfo = CloudData.SCROLL_MSG[1]
  
  local function tFuncListener()
    self:performWithDelay(self.showScrollMsg, 1)
  end
  
  msgInfo.callback = tFuncListener
  local scrollCaption = ScrollCaption.new(msgInfo)
  scrollCaption:setPosition((display.width - 1028) * 0.5, display.height - 220)
  self:addChild(scrollCaption, 16)
  table.remove(CloudData.SCROLL_MSG, 1)
end

function M:addPostListener()
  local function tFuncNewApply()
    if not self or not self.checkNewFriendApply then
      return
    end
    self:checkNewFriendApply()
  end
  
  DYNotification.registerScriptObserver(self, tFuncNewApply, DY_KEY.kFriendAddApply)
  
  local function tFuncNewMsg()
    if not self or not self.checkNewFriendApply then
      return
    end
    self:checkNewFriendApply()
  end
  
  DYNotification.registerScriptObserver(self, tFuncNewMsg, DY_KEY.kFriendMsg)
end

function M:onTouchWizardIcon(event, x, y)
  if event == "began" then
    return true
  end
  if event == "ended" then
    self.mWizardmask = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 20)
    self.mIinputFrame = cc.ui.UIInput.new({
      image = "login_scene/input_frame.png",
      size = cc.size(486, 35),
      x = display.cx,
      y = display.cy
    })
    self.mIinputFrame:setPlaceholderFontColor(cc.c3b(144, 124, 93))
    self.mIinputFrame:setPlaceholderFontName(GameManager.FONTNAME_TTF)
    self.mIinputFrame:setPlaceholderFontSize(24)
    self.mIinputFrame:setFontColor(cc.c3b(47, 17, 8))
    self.mIinputFrame:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    self.mWizardmask:addChild(self.mIinputFrame)
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/close_normal.png",
      pressed = "common_ui/close_pressed.png"
    }):onButtonClicked(function()
      self:clickWizard()
    end):align(display.CENTER, self.mIinputFrame:getContentSize().width * 1.12, self.mIinputFrame:getContentSize().height * 0.5):addTo(self.mIinputFrame, 1)
  end
end

function M.getAllBuddhaCE()
  local team = DataUtils.getBuddhaTableOnTeam()
  local sum = 0
  for k, v in pairs(team) do
    local buddhaModel = DataUtils.getBuddhaModel(v)
    sum = sum + buddhaModel.attackAssessment
  end
  return math.floor(math.sqrt(sum))
end

function M:clickWizard()
  local str = self.mIinputFrame:getText()
  print(str)
  
  local function tFuncListener(info)
    local msg = info.errorMsg or "UNKNOWN"
    if info.errorCode == 0 then
      msg = DYLang.getString("S1233", "")
    end
    local toast = WSToast.new(msg, 3)
    self:addChild(toast, 20)
    self.mWizardmask:removeSelf()
    self.mWizardmask = nil
  end
  
  local params = {}
  params.chant = str
  DYHttpMgr.testWizard(tFuncListener, params)
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  if GameManager then
    GameManager.CHAT_BTN = nil
  end
  self:removeAllChildren()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    if self.mWizardmask then
      self.mWizardmask:removeSelf()
      self.mWizardmask = nil
    else
      DYCommon.tryQuit(false, function(et)
        if et.event == dy.quit.EVENT_IGNORE then
          local layer = require("app.layers.LayerQuit").new()
          layer:show()
        end
      end)
    end
  end
  return true
end

return M

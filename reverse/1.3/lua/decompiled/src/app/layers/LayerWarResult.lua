local WSToast = require("app.utils.WSToast")
local IconItem = require("app.icons.IconItem")
local LayerPvpRecordUp = require("app.layers.LayerPvpRecordUp")
local LayerLevelUpAni = require("app.layers.LayerLevelUpAni")
local LayerMeetBoss = require("app.aggress.layers.LayerMeetBoss")
local mode_main_stage = 0
local mode_elite_stage = 1
local mode_infinite = 2
local mode_purgatory = 3
local mode_travel = 4
local mode_pvp = 5
local mode_pvpol = 6
local mode_babel = 7
local mode_aggress = 10
local CLASS_NAME = "LayerWarResult"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.WIN = 1
M.LOSE = 0

function M:ctor(resultType)
  GameManager.RESULT_SHOWED = true
  DYSoundMgr.stopMusic(true)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode()
  self.mNode:setPosition(display.cx, display.cy)
  self:addChild(self.mNode)
  self.mInfo = CloudData.WAR_RESULT_TABLE
  self.mBg = nil
  self.mExp = 0
  self.mEssence = 0
  self.mLianyubi = 0
  self.mFeat = 0
  self.mPeach = 0
  self.mStars = -1
  self.mAwardTable = {}
  self.mDropsList = {}
  self.mOldLevelRate = DataUtils.getExpLevelRate()
  self.mNewLevelRate = 0
  self.mLevelLabel = nil
  self.mProgressBar = nil
  self.mProgressLabel = nil
  self.mPvpRank = CloudData.PVP_RANK
  self.mPvpRecord = CloudData.PVP_RECORD
  self.mUserLevel = CloudData.USER_LEVEL
  self.mMode = GameManager.MODE
  self.mResultTpye = resultType
  self.mRetTime = self.mInfo.retTime or 0
  self.mTouchEnabled = false
  self.mArmature_posY = 0.77
  self.mMark_posY = 390
  self.mStageFirstPass = false
  self.mDouble = 0
  self.mMeetBoss = checknumber(self.mInfo.isMeetBoss)
  self.mIsPvpRevenge = GameManager.IS_REVENGE
  GameManager.IS_REVENGE = 0
  self.mIsBabelGrab = GameManager.IS_BABEL_GRAB
  GameManager.IS_BABEL_GRAB = 0
  if self.mMode == mode_infinite then
    if self.mInfo.reachTowerStage ~= nil then
      CloudData.INFINITE_MAX_STAGE = tonumber(self.mInfo.reachTowerStage)
      CloudData.INFINITE_CUR_STAGE = CloudData.INFINITE_MAX_STAGE
    end
    if self.mInfo.reachTowerWave ~= nil then
      CloudData.INFINITE_MAX_WAVE = tonumber(self.mInfo.reachTowerWave)
    end
  end
  if self.mMode ~= mode_aggress then
    self:initData()
  else
    self.mTouchEnabled = true
  end
  self:initBg()
  self:analyze()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:analyze()
  local id = checknumber(GameManager.STAGE_ID) % 10000
  if self.mMode == nil then
    self.mMode = 0
  elseif self.mMode == mode_pvp then
    id = 0
  end
  local modetable = {
    [1] = DYLang.getString("S1050", ""),
    [2] = DYLang.getString("S1051", ""),
    [3] = DYLang.getString("S1052", ""),
    [4] = DYLang.getString("S1053", ""),
    [5] = DYLang.getString("S1054", ""),
    [6] = DYLang.getString("S1055", ""),
    [7] = DYLang.getString("S1056", ""),
    [8] = DYLang.getString("S1057", ""),
    [9] = "",
    [10] = "",
    [11] = DYLang.getString("STR_AGGRESS", "")
  }
  local mode = modetable[self.mMode + 1] or ""
  local str = mode .. "_" .. id
  if self.mMode == mode_pvp and self.mIsBabelGrab == 1 then
    str = DYLang.getString("S1058", "") .. id
  end
  if self.mResultTpye == M.WIN then
    DYAnalyze.levels.complete(str)
  else
    DYAnalyze.levels.fail(str, "")
  end
end

function M:initData()
  if self.mInfo.drop then
    for id, num in pairs(self.mInfo.drop) do
      DataUtils.updateItemNum(id, num)
    end
  end
  if self.mInfo.energy ~= nil then
    local gain = DataUtils.updateItemNum(3, tonumber(self.mInfo.energy))
    DYAnalyze.item.get(3, "ENERGY", gain, "WAR_" .. self.mMode)
  end
  if self.mInfo.essence ~= nil then
    CloudData.ESSENCE = tonumber(self.mInfo.essence)
    CloudData.GAME_ITEM_INFO["2"] = CloudData.ESSENCE
  end
  if self.mInfo.essenceGain ~= nil then
    self.mEssence = tonumber(self.mInfo.essenceGain)
    local info = {
      icon = "item_icon/pic_essence.png",
      num = self.mEssence,
      desc = DYLang.getString("S1059", "")
    }
    table.insert(self.mAwardTable, info)
    DYAnalyze.item.get(2, "ESSENCE", self.mEssence, "WAR_" .. self.mMode)
  end
  if self.mInfo.expGain ~= nil then
    self.mExp = tonumber(self.mInfo.expGain)
    local info = {
      icon = "item_icon/pic_exp.png",
      num = self.mExp,
      desc = DYLang.getString("S1060", "")
    }
    table.insert(self.mAwardTable, info)
    DYAnalyze.item.get(4, "EXP", self.mExp, "WAR_" .. self.mMode)
  end
  if self.mInfo.peach ~= nil then
    CloudData.PEACH = tonumber(self.mInfo.peach)
    CloudData.GAME_ITEM_INFO["1"] = CloudData.PEACH
  end
  if self.mInfo.peachGain ~= nil then
    self.mPeach = tonumber(self.mInfo.peachGain)
    if self.mMode ~= mode_pvp then
      local info = {
        icon = "item_icon/pic_peach.png",
        num = self.mPeach,
        desc = DYLang.getString("S1061", "")
      }
      table.insert(self.mAwardTable, info)
    end
    DYAnalyze.item.get(1, "PEACH", self.mPeach, "WAR_" .. self.mMode)
  end
  if self.mInfo.star ~= nil then
    self.mStars = tonumber(self.mInfo.star)
  end
  if self.mInfo.lianyubi ~= nil then
    CloudData.LIANYUBI = tonumber(self.mInfo.lianyubi)
    CloudData.GAME_ITEM_INFO["6"] = CloudData.LIANYUBI
  end
  if self.mInfo.lianyubiGain ~= nil then
    self.mLianyubi = tonumber(self.mInfo.lianyubiGain)
    local info = {
      icon = "item_icon/pic_lianyubi.png",
      num = self.mLianyubi,
      desc = DYLang.getString("S1062", "")
    }
    table.insert(self.mAwardTable, info)
    DYAnalyze.item.get(6, "LIANYUBI", self.mLianyubi, "WAR_" .. self.mMode)
  end
  if self.mInfo.medalPrize ~= nil then
    CloudData.FEAT = tonumber(self.mInfo.medalPrize)
    CloudData.GAME_ITEM_INFO["5"] = CloudData.FEAT
  end
  if self.mInfo.medalPrizeGain ~= nil then
    self.mFeat = tonumber(self.mInfo.medalPrizeGain)
    local info = {
      icon = "item_icon/pic_feat.png",
      num = self.mFeat,
      desc = DYLang.getString("S1063", "")
    }
    table.insert(self.mAwardTable, info)
    DYAnalyze.item.get(5, "MEDAL", self.mFeat, "WAR_" .. self.mMode)
  end
  if self.mInfo.newRanking ~= nil then
    CloudData.PVP_RANK = tonumber(self.mInfo.newRanking) + 1
  end
  if self.mInfo.maxRanking ~= nil then
    CloudData.PVP_RECORD = tonumber(self.mInfo.maxRanking) + 1
  end
  local sum = 0
  if self.mInfo.treasureQuality ~= nil and 0 < tonumber(self.mInfo.treasureQuality) then
    local quality = tonumber(self.mInfo.treasureQuality)
    local treasurePieceQuality = DataUtils.getTreasurePieceQuality(GameManager.STAGE_NUM)
    if quality > treasurePieceQuality then
      CloudData.TREASURE_PIECE_INFO[GameManager.STAGE_NUM] = quality
      sum = sum + 1
      local info = {id = quality, isTreasure = 1}
      table.insert(self.mDropsList, info)
    end
  end
  if self.mInfo.dropGain ~= nil then
    for itemId, itemNum in pairs(self.mInfo.dropGain) do
      if tonumber(itemNum) > 0 then
        local info = {
          id = tonumber(itemId),
          num = tonumber(itemNum),
          isTreasure = 0
        }
        table.insert(self.mDropsList, info)
        DYAnalyze.item.get(itemId, "", itemNum, "WAR_" .. self.mMode)
      end
    end
  end
  if self.mInfo.exp ~= nil then
    local userLevel, exp = DataUtils.getUserLevelAndExp(tonumber(self.mInfo.exp))
    CloudData.USER_LEVEL = userLevel
    CloudData.EXP = tonumber(self.mInfo.exp)
    CloudData.GAME_ITEM_INFO["4"] = CloudData.EXP
    if self.mUserLevel > CloudData.USER_LEVEL then
      self.mUserLevel = CloudData.USER_LEVEL
    end
    self.mNewLevelRate = DataUtils.getExpLevelRate()
  end
  if self.mUserLevel < CloudData.USER_LEVEL then
    self.mTouchEnabled = false
    DYAnalyze.account.changeTag(DYLang.getString("S1064", ""), self.mUserLevel, CloudData.USER_LEVEL)
  else
    self.mTouchEnabled = true
  end
  self.mDouble = checknumber(self.mInfo.isDouble)
end

function M:initBg()
  self.mBg = display.newSprite("war_result/frame.png"):addTo(self.mNode)
  if self.mDouble == 1 then
    display.newSprite("activity/double_tag1.png"):pos(813, 305):addTo(self.mBg, 2)
  end
  if self.mResultTpye == M.WIN then
    if self.mMode == mode_main_stage and CloudData.MAIN_STAGE_PROGRESS + 1 == GameManager.STAGE_NUM then
      CloudData.MAIN_STAGE_PROGRESS = GameManager.STAGE_NUM
      self.mStageFirstPass = true
    end
    self:showSuccess()
  else
    self:showFailure()
  end
end

function M:showSuccess()
  DYSoundMgr.playEffect(DY_SND.sfx_win)
  self:addSuccArmature()
  self:addBottomBtns()
  if self.mMode == mode_pvp then
    self:addPVPRecord()
  end
  self:addBattleTime()
  if self.mMode == mode_aggress then
    self:addHurtInfo()
  end
  if self.mAwardTable and #self.mAwardTable > 0 then
    self:addAwardGoods()
  end
  if self.mMode ~= mode_pvp and self.mMode ~= mode_aggress then
    self:addDrops()
  end
  if self.mInfo.exp ~= nil then
    self:addExpProgress()
  end
end

function M:showFailure()
  DYSoundMgr.playEffect(DY_SND.sfx_failed)
  self:addFailArmature()
  self:addBottomBtns()
  if #self.mAwardTable > 0 or 0 < #self.mDropsList then
    if self.mMode == mode_pvp and self.mIsBabelGrab ~= 1 then
      self:addPVPRecord()
    end
    self:addBattleTime()
    if self.mAwardTable and #self.mAwardTable > 0 then
      self:addAwardGoods()
    end
    if self.mMode ~= mode_pvp then
      self:addDrops()
    end
    if self.mInfo.exp ~= nil then
      self:addExpProgress()
    end
  elseif self.mMode == mode_aggress then
    self:addBattleTime()
    self:addHurtInfo()
  else
    display.newSprite("war_result/fail_str.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.5, 340):addTo(self.mBg)
    local info = {
      {
        icon = "pic_summon",
        func = function()
          self:returnCallBack("scenes.SceneSummon")
        end
      },
      {
        icon = "pic_upgrade",
        func = function()
          self:returnCallBack("scenes.UpgradeScene")
        end
      },
      {
        icon = "pic_skill",
        func = function()
          self:returnCallBack("scenes.UpgradeScene")
        end
      },
      {
        icon = "pic_cimelia",
        func = function()
          self:returnCallBack("cimelia.scenes.SceneCimelia")
        end
      },
      {
        icon = "pic_treasure",
        func = function()
          self:returnCallBack("scenes.ChapterScene", 5)
        end
      }
    }
    for i = 1, #info do
      cc.ui.UIPushButton.new({
        normal = "user_center/" .. info[i].icon .. ".png",
        pressed = "user_center/" .. info[i].icon .. "1.png"
      }):onButtonClicked(function()
        info[i].func()
      end):align(display.CENTER, 116 * i + 280, 250):addTo(self.mBg, 1)
    end
  end
end

function M:addBottomBtns()
  local num = GameManager.STAGE_NUM or 0
  local stageInfo = {
    [1] = {
      id = "start_main_" .. num,
      lab = DYLang.getString("S1065", "")
    },
    [2] = {
      id = "start_elite_" .. num,
      lab = DYLang.getString("S1066", "")
    },
    [3] = {
      id = "start_tower_" .. num,
      lab = DYLang.getString("S1067", "")
    },
    [4] = {
      id = "start_purgatory_" .. num,
      lab = DYLang.getString("S1068", "")
    },
    [5] = {
      id = "start_travel_" .. num,
      lab = DYLang.getString("S1069", "")
    },
    [6] = {
      id = "start_pvp_" .. num,
      lab = DYLang.getString("S1070", "")
    },
    [7] = {
      id = "start_pvpol_" .. num,
      lab = DYLang.getString("S1071", "")
    },
    [8] = {
      id = "start_babel_" .. num,
      lab = DYLang.getString("S1072", "")
    }
  }
  local info = {}
  if self.mResultTpye == M.WIN or self.mMode == mode_aggress then
    info = {
      {
        str = DYLang.getString("S1073", ""),
        func = function()
          self:returnCallBack()
        end,
        posX = 630
      }
    }
  elseif self.mMode ~= mode_purgatory and self.mMode ~= mode_pvp then
    info = {
      {
        str = DYLang.getString("S1074", ""),
        func = function()
          self:returnCallBack("scenes.UpgradeScene")
        end,
        posX = 420
      },
      {
        str = DYLang.getString("S1075", ""),
        func = function()
          self:returnCallBack("scenes.TinyLoadingScene", "GAME_SCENE")
          if stageInfo[self.mMode + 1] then
          end
        end,
        posX = 630
      },
      {
        str = DYLang.getString("S1073", ""),
        func = function()
          self:returnCallBack()
        end,
        posX = 840
      }
    }
    if #self.mAwardTable == 0 and #self.mDropsList == 0 then
      info[2].posX = 480
      info[3].posX = 780
      table.remove(info, 1)
    end
  else
    info = {
      {
        str = DYLang.getString("S1074", ""),
        func = function()
          self:returnCallBack("scenes.UpgradeScene")
        end,
        posX = 480
      },
      {
        str = DYLang.getString("S1073", ""),
        func = function()
          self:returnCallBack()
        end,
        posX = 780
      }
    }
    if #self.mAwardTable == 0 and #self.mDropsList == 0 then
      info[2].posX = 630
      table.remove(info, 1)
    end
  end
  for i = 1, #info do
    local strLabel = cc.ui.UILabel.new({
      text = info[i].str,
      size = 30,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    })
    strLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }, {scale9 = true}):setButtonSize(180, 75):setButtonLabel("normal", strLabel):onButtonClicked(function()
      if self.mTouchEnabled == true then
        info[i].func()
      end
    end):align(display.CENTER, info[i].posX, 100):addTo(self.mBg, 1)
  end
end

function M:addPVPRecord()
  local rank = CloudData.PVP_RANK
  local record = CloudData.PVP_RECORD
  local posY = self.mMark_posY - 5
  local rankStr = cc.ui.UILabel.new({
    text = DYLang.getString("S1080", ""),
    size = 25,
    color = cc.c3b(255, 242, 24),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 393, posY):addTo(self.mBg)
  rankStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  if 10004 < rank then
    local rankLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = DYLang.getString("S1081", ""),
      size = 22,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, 838, posY):addTo(self.mBg)
    rankLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  else
    local rankLabel = cc.ui.UILabel.new({
      UILabelType = 1,
      text = rank,
      font = "fonts/white_num.fnt"
    }):scale(0.88):align(display.CENTER_RIGHT, 870, posY - 5):addTo(self.mBg)
    if rank ~= self.mPvpRank then
      local inc = rank - self.mPvpRank
      local img = "war_result/down.png"
      if rank < self.mPvpRank then
        img = "war_result/up.png"
        inc = -inc
      end
      local incLabel = cc.ui.UILabel.new({
        UILabelType = 1,
        text = string.format("%d)", inc),
        font = "fonts/white_num.fnt"
      }):scale(0.88):align(display.CENTER_RIGHT, 870, posY - 5):addTo(self.mBg)
      local arrow = display.newSprite(img):align(display.CENTER_RIGHT, 868 - incLabel:getContentSize().width * 0.88, posY):addTo(self.mBg)
      rankLabel:setString(string.format("%d(", rank))
      rankLabel:setPositionX(arrow:getPositionX() - arrow:getContentSize().width - 2)
    end
  end
  posY = self.mMark_posY - 55
  display.newSprite("war_result/record.png"):scale(0.95):align(display.CENTER_LEFT, 393, posY):addTo(self.mBg)
  if 10004 < record then
    local recordLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = DYLang.getString("S1081", ""),
      size = 22,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, 838, posY):addTo(self.mBg)
    recordLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  else
    local recordLabel = cc.ui.UILabel.new({
      UILabelType = 1,
      text = record,
      font = "fonts/white_num.fnt"
    }):scale(0.88):align(display.CENTER_RIGHT, 870, posY - 5):addTo(self.mBg)
    local tagShow = false
    if record ~= self.mPvpRecord then
      local inc = record - self.mPvpRecord
      local img = "war_result/down.png"
      if record < self.mPvpRecord then
        img = "war_result/up.png"
        inc = -inc
        tagShow = true
      end
      local incLabel = cc.ui.UILabel.new({
        UILabelType = 1,
        text = string.format("%d)", inc),
        font = "fonts/white_num.fnt"
      }):scale(0.88):align(display.CENTER_RIGHT, 870, posY - 5):addTo(self.mBg)
      local arrow = display.newSprite(img):align(display.CENTER_RIGHT, 868 - incLabel:getContentSize().width * 0.88, posY):addTo(self.mBg)
      recordLabel:setString(string.format("%d(", record))
      recordLabel:setPositionX(arrow:getPositionX() - arrow:getContentSize().width - 2)
      if tagShow then
        local info = {
          peach = self.mPeach,
          record = record,
          up = inc
        }
        recordLabel:performWithDelay(function()
          self:showRecordUpLayer(info)
        end, 0.5)
      end
    end
  end
  self.mMark_posY = self.mMark_posY - 100
end

function M:showRecordUpLayer(info)
  local lay = LayerPvpRecordUp.new(info)
  self:addChild(lay, 20)
end

function M:addBattleTime()
  local posY = self.mMark_posY
  local timeStr = display.newSprite("war_result/war_time.png"):scale(0.88):align(display.CENTER_LEFT, 393, posY):addTo(self.mBg)
  local time = GameData.BATTLE_TIME or 0
  local timeLabel = cc.ui.UILabel.new({
    text = time .. DYLang.getString("S1084", ""),
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 870, posY):addTo(self.mBg)
  timeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:addHurtInfo()
  local posY = self.mMark_posY - 75
  local hurtStr = cc.ui.UILabel.new({
    text = DYLang.getString("S968", ""),
    size = 24,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 393, posY):addTo(self.mBg)
  hurtStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local damage = math.floor(self.mInfo.aggressBossDamage)
  local damageLabel = cc.ui.UILabel.new({
    text = damage .. DYLang.getString("S969", ""),
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 870, posY):addTo(self.mBg)
  damageLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local perStr = cc.ui.UILabel.new({
    text = DYLang.getString("STR_HURT_PERCENT", ""),
    size = 24,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 393, posY - 75):addTo(self.mBg)
  perStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local str = string.format("%.2f%%", checknumber(self.mInfo.aggressBossDamagePer))
  local perLabel = cc.ui.UILabel.new({
    text = str,
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 870, posY - 75):addTo(self.mBg)
  perLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:addAwardGoods()
  local posY = self.mMark_posY - 60
  local sum = #self.mAwardTable
  local dis = 240
  if sum == 3 then
    dis = 188
  end
  for i = 1, sum do
    local info = self.mAwardTable[i]
    local coinBg = display.newSprite("stage/bg_num.png", dis * i + 275, posY):addTo(self.mBg)
    display.newSprite(info.icon, coinBg:getContentSize().width * 0.69, coinBg:getContentSize().height * posY):scale(0.6):align(display.CENTER_RIGHT, 0, coinBg:getContentSize().height * 0.5):addTo(coinBg)
    local numLabel = cc.ui.UILabel.new({
      text = info.num,
      size = 22,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, coinBg:getContentSize().width * 0.5, coinBg:getContentSize().height * 0.5):addTo(coinBg)
    numLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  end
  if 0 < sum then
    self.mMark_posY = self.mMark_posY - 50
  end
end

function M:addDrops()
  local posY = self.mMark_posY - 95
  local sum = #self.mDropsList
  if 4 < sum then
    self.mListView = cc.ui.UIListView.new({
      viewRect = cc.rect(421, posY - 45, 425, 96),
      direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
    }):addTo(self.mBg)
    for i = 1, sum do
      local item = self.mListView:newItem()
      local info = self.mDropsList[i]
      local frame
      if info and info.isTreasure == 1 then
        frame = display.newSprite("common_ui/frame0.png")
        display.newSprite("treasure/piece" .. info.id .. ".png", frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
      elseif info then
        frame = IconItem.new(info.id, info.num)
        frame:showItemTip()
      end
      frame:setScale(0.7)
      item:addContent(frame)
      item:setItemSize(105, 96)
      self.mListView:addItem(item)
    end
    self.mListView:reload()
  else
    for i = 1, 4 do
      local frame = display.newSprite("war_result/null_icon.png"):scale(0.7):pos(102 * i + 370, posY):addTo(self.mBg)
      local info = self.mDropsList[i]
      if info and info.isTreasure == 1 then
        display.newSprite("common_ui/frame0.png"):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
        display.newSprite("treasure/piece" .. info.id .. ".png"):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
      elseif info then
        local icon = IconItem.new(info.id, info.num)
        icon:setPosition(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5)
        frame:addChild(icon)
        icon:showItemTip()
      end
    end
  end
end

function M:addExpProgress()
  if self.mUserLevel < #DataRetainer.PLAYER_EXP_LEVEL_INFO - 1 then
    local progressFrame = display.newSprite("cimelia/bar_bg1.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.5, 170):addTo(self.mBg)
    self.mProgressBar = display.newProgressTimer("cimelia/bar_pro1.png", display.PROGRESS_TIMER_BAR):pos(progressFrame:getContentSize().width * 0.5, progressFrame:getContentSize().height * 0.5):addTo(progressFrame)
    self.mProgressBar:setMidpoint(cc.p(0, 0))
    self.mProgressBar:setBarChangeRate(cc.p(1, 0))
    self.mLevelLabel = cc.ui.UILabel.new({
      text = "LV." .. self.mUserLevel,
      size = 25,
      color = cc.c3b(255, 242, 24),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_RIGHT, -10, progressFrame:getContentSize().height * 0.5):addTo(progressFrame, 1)
    self.mLevelLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    self.mProgressLabel = cc.ui.UILabel.new({
      text = self.mOldLevelRate .. "%",
      size = 25,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, progressFrame:getContentSize().width + 20, progressFrame:getContentSize().height * 0.5):addTo(progressFrame, 1)
    self.mProgressLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    self.mProgressBar:setPercentage(self.mOldLevelRate)
  end
end

function M:addSuccArmature()
  display.newSprite("war_result/halo1.png"):align(display.CENTER, self.mBg:getContentSize().width * 0.5, 470):addTo(self.mBg, -1)
  local aniNode = display.newSprite():pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * self.mArmature_posY):addTo(self.mBg)
  display.newSprite("war_result/light.png"):align(display.CENTER, aniNode:getContentSize().width * 0.5, aniNode:getContentSize().height * 0.5 - 180):addTo(aniNode, -1)
  cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("animation/game_win/shenglidonghau0.csb")
  local game_win = ccs.Armature:create("shenglidonghau")
  game_win:setPosition(0, 0)
  game_win:getAnimation():playWithIndex(0)
  aniNode:addChild(game_win)
  cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
  display.addSpriteFrames("animation/shengli_zouguang.plist", "animation/shengli_zouguang.png")
  self:runAction(transition.sequence({
    cc.DelayTime:create(0.7),
    cc.CallFunc:create(function()
      self.schedule_ = self:schedule(function()
        local frames1 = display.newFrames("shengli-zouguang%d.png", 1, 28)
        local animation1 = display.newAnimation(frames1, 0.08)
        local emptySp1 = display.newSprite():pos(self.mBg:getContentSize().width * 0.5 - 5, self.mBg:getContentSize().height * self.mArmature_posY - 20):addTo(self.mBg, 2)
        emptySp1:playAnimationOnce(animation1, true)
      end, 3.2)
    end)
  }))
  display.addSpriteFrames("animation/shengli_xingxing.plist", "animation/shengli_xingxing.png")
  self:runAction(transition.sequence({
    cc.DelayTime:create(0.6),
    cc.CallFunc:create(function()
      local frames2 = display.newFrames("shengli-xingxing%d.png", 1, 19)
      local animation2 = display.newAnimation(frames2, 0.15)
      local emptySp2 = display.newSprite():scale(2):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * self.mArmature_posY):addTo(self.mBg, 2)
      emptySp2:playAnimationForever(animation2)
    end),
    cc.DelayTime:create(0.3),
    cc.CallFunc:create(function()
      self:addStarAni()
    end)
  }))
end

function M:addStarAni()
  if self.mStars < 0 then
    self:showDropAni()
    return
  end
  local delayTime = 1.1
  self.mNode:runAction(transition.sequence({
    cc.DelayTime:create(delayTime + 0.1),
    cc.ScaleTo:create(0.1, 0.95),
    cc.ScaleTo:create(0.1, 1),
    cc.DelayTime:create(0.1),
    cc.ScaleTo:create(0.05, 0.95),
    cc.ScaleTo:create(0.05, 1)
  }))
  local img = "war_result/star.png"
  local star1 = display.newSprite(img, self.mBg:getContentSize().width * 0.44, self.mBg:getContentSize().height * (self.mArmature_posY + 0.12)):scale(0):addTo(self.mBg, 1)
  star1:runAction(transition.sequence({
    cc.DelayTime:create(delayTime),
    cc.ScaleTo:create(0, 2),
    cc.FadeIn:create(0.1),
    cc.CallFunc:create(function()
      DYSoundMgr.playEffect(DY_SND.sfx_starclear)
    end),
    cc.ScaleTo:create(0.1, 0.9),
    cc.ScaleTo:create(0.2, 1.1)
  }))
  if self.mStars < 2 then
    img = "war_result/star_gray.png"
  end
  local star2 = display.newSprite(img, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * (self.mArmature_posY + 0.16)):scale(0):addTo(self.mBg, 1)
  star2:runAction(transition.sequence({
    cc.DelayTime:create(delayTime + 0.3),
    cc.ScaleTo:create(0, 2),
    cc.FadeIn:create(0.1),
    cc.CallFunc:create(function()
      if self.mStars >= 2 then
        DYSoundMgr.playEffect(DY_SND.sfx_starclear)
      end
    end),
    cc.ScaleTo:create(0.1, 0.9),
    cc.ScaleTo:create(0.1, 1.1)
  }))
  if self.mStars < 3 then
    img = "war_result/star_gray.png"
  end
  local star3 = display.newSprite(img, self.mBg:getContentSize().width * 0.56, self.mBg:getContentSize().height * (self.mArmature_posY + 0.12)):scale(0):addTo(self.mBg, 1)
  star3:runAction(transition.sequence({
    cc.DelayTime:create(delayTime + 0.5),
    cc.ScaleTo:create(0, 1),
    cc.CallFunc:create(function()
      if self.mStars >= 3 then
        DYSoundMgr.playEffect(DY_SND.sfx_starclear)
      end
    end),
    cc.DelayTime:create(0.2),
    cc.CallFunc:create(function()
      self:showDropAni()
    end)
  }))
end

function M:showDropAni()
  local sum = #self.mDropsList
  if self.mListView and 4 < sum then
    local x = (sum - 4) * 105
    self.mListView:moveItems(1, sum, -x, 0, true)
    self:performWithDelay(function()
      self:showLevelProgress()
    end, 0.3)
  else
    self:showLevelProgress()
  end
end

function M:showLevelProgress()
  if self.mProgressBar == nil then
    return
  end
  self.mLevelLabel:setString("LV." .. self.mUserLevel)
  if self.mUserLevel < CloudData.USER_LEVEL then
    self.mUserLevel = self.mUserLevel + 1
    self.mProgressLabel:setString("100%")
    self.mProgressBar:runAction(transition.sequence({
      cc.ProgressTo:create(0.4, 100),
      cc.CallFunc:create(function()
        self:upgradeAni(self.mUserLevel)
      end),
      cc.ProgressTo:create(0, 0)
    }))
  else
    self.mProgressLabel:setString(self.mNewLevelRate .. "%")
    self.mProgressBar:runAction(transition.sequence({
      cc.ProgressTo:create(0.4, self.mNewLevelRate)
    }))
  end
end

function M:upgradeAni(curLevel)
  local levelInfo = {
    regionId = tostring(CloudData.USER_SERVER_INFO.id),
    regionName = tostring(CloudData.USER_SERVER_INFO.name),
    roleId = tostring(CloudData.UID),
    roleName = tostring(CloudData.USER_NAME),
    roleLevel = tostring(CloudData.USER_LEVEL),
    roleCTime = tostring(CloudData.ROLE_C_TIME),
    roleLevelMTime = tostring(self.mRetTime)
  }
  DYLoginMgr.updateEvent("LEVEL_UP", levelInfo)
  LayerLevelUpAni.new(curLevel, handler(self, self.removeUpgradeAni)):addTo(self, 20)
  self.mTouchEnabled = true
end

function M:removeUpgradeAni(tag)
  if tag then
    self:returnCallBack("scenes.TinyLoadingScene", "CHAPTER_SCENE")
  else
    self:showLevelProgress()
  end
end

function M:getFailAwardList()
  if #self.mAwardTable > 0 then
    return
  end
  local exp = {
    icon = "item_icon/pic_exp.png",
    num = self.mExp,
    desc = DYLang.getString("S1060", "")
  }
  local essence = {
    icon = "item_icon/pic_essence.png",
    num = self.mEssence,
    desc = DYLang.getString("S1059", "")
  }
  local lianyubi = {
    icon = "item_icon/pic_lianyubi.png",
    num = self.mLianyubi,
    desc = DYLang.getString("S1062", "")
  }
  local peach = {
    icon = "item_icon/pic_peach.png",
    num = self.mPeach,
    desc = DYLang.getString("S1061", "")
  }
  local feat = {
    icon = "item_icon/pic_feat.png",
    num = self.mFeat,
    desc = DYLang.getString("S1063", "")
  }
  if self.mMode == mode_main_stage then
    table.insert(self.mAwardTable, exp)
    table.insert(self.mAwardTable, essence)
  elseif self.mMode == mode_elite_stage then
    table.insert(self.mAwardTable, exp)
    table.insert(self.mAwardTable, essence)
  elseif self.mMode == mode_purgatory then
    table.insert(self.mAwardTable, essence)
    table.insert(self.mAwardTable, lianyubi)
  elseif self.mMode == mode_pvp then
    table.insert(self.mAwardTable, exp)
    table.insert(self.mAwardTable, feat)
  elseif self.mMode == mode_travel then
  end
end

function M:addFailArmature()
  local losePic = display.newSprite("war_result/lose.png", self.mBg:getContentSize().width * 0.5, 530):scale(2):opacity(0):addTo(self.mBg)
  local delay1 = cc.DelayTime:create(0.5)
  local fadeIn1 = cc.FadeIn:create(0.1)
  local scaleTo1 = cc.ScaleTo:create(0.1, 0.75)
  local scaleTo2 = cc.ScaleTo:create(0.2, 1.2)
  local scaleTo3 = cc.ScaleTo:create(0.2, 1)
  losePic:runAction(transition.sequence({
    delay1,
    cc.Spawn:create(fadeIn1, scaleTo1),
    scaleTo2,
    scaleTo3
  }))
end

function M:returnCallBack(scene, params)
  GameManager.RESULT_SHOWED = false
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  if self.mMeetBoss == 1 then
    self.mMeetBoss = 0
    LayerMeetBoss.new(handler(self, self.returnCallBack), scene, params):addTo(self, 20)
    return
  end
  DYSoundMgr.playMusic(DY_SND.bgm_theme)
  GameManager.IS_USER_BUSY = 0
  display.removeUnusedSpriteFrames()
  CloudData.WAR_RESULT_TABLE = {}
  if scene then
    display.replaceScene(require(scene).new(params))
    return
  end
  local destScene = "SCENE_STAGE"
  local params
  CloudData.SHOW_DUNGEON_PASS_ANI = -1
  if self.mMode == mode_main_stage then
    destScene = "SCENE_STAGE"
    if GameManager.STAGE_NUM % 10 == 0 and self.mStageFirstPass then
      params = {1}
      CloudData.SHOW_DUNGEON_PASS_ANI = self.mMode
    else
      local chapter = math.ceil(GameManager.STAGE_NUM / 10)
      params = {1, chapter}
    end
  elseif self.mMode == mode_elite_stage then
    destScene = "SCENE_STAGE"
    if GameManager.STAGE_NUM % 4 == 0 and CloudData.ELITE_STAGE_PROGRESS + 1 == GameManager.STAGE_NUM and self.mResultTpye == M.WIN then
      params = {2}
      CloudData.SHOW_DUNGEON_PASS_ANI = self.mMode
    else
      local stageID = GameManager.STAGE_ID % 20000
      local chapter = math.ceil(stageID / 4)
      params = {2, chapter}
    end
  elseif self.mMode == mode_infinite then
    destScene = "INFINITE_MODE_ENTRANCE"
    if self.mResultTpye == M.WIN then
      params = 3
    end
  elseif self.mMode == mode_purgatory then
    destScene = "SCENE_PURGATORY"
    if GameManager.STAGE_NUM % 8 == 0 and self.mResultTpye == M.WIN then
      params = true
    end
  elseif self.mMode == mode_travel then
    destScene = "SCENE_TRAVEL"
  elseif self.mMode == mode_pvp then
    destScene = "SCENE_PVP"
    if self.mIsBabelGrab == 1 then
      destScene = "SCENE_BABEL"
    end
  elseif self.mMode == mode_babel then
    destScene = "SCENE_BABEL"
    params = 0
    if self.mResultTpye == M.WIN then
      params = 1
    end
  elseif self.mMode == mode_aggress then
    destScene = "SCENE_AGGRESS"
  end
  display.replaceScene(require("scenes.TinyLoadingScene").new(destScene, params))
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE and self.mTouchEnabled == true then
    self:returnCallBack()
  end
  return true
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

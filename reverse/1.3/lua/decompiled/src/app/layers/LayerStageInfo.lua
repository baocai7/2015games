local LayerLackEnergy = require("app.layers.LayerLackEnergy")
local LayerTeam = require("app.layers.LayerTeam")
local WSToast = require("app.utils.WSToast")
local IconItem = require("app.icons.IconItem")
local LayerLevelUpAni = require("app.layers.LayerLevelUpAni")
local LayerMeetBoss = require("app.aggress.layers.LayerMeetBoss")
local LayerBossRelated = require("app.aggress.layers.LayerBossRelated")
local NoviceGuide = require("app.utils.NoviceGuide")
local CLASS_NAME = "LayerStageInfo"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(stageNum)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mBg = nil
  self.mStageNum = stageNum
  self.mStars = 0
  self.mTimes = 0
  self.mTotalTimes = 0
  self.mEneryCost = 0
  self.mSweepLayer = nil
  self.mResetLayer = nil
  self.mExp = 0
  self.mEssence = 0
  self.mEssenceInc = 0
  self.mPieceTable = {}
  self.mTimesLabel = nil
  self.mExpLabel = nil
  self.mPeachCost = 0
  self.mResetTime = 0
  self.mMeetBoss = 0
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):scale(0):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initData()
  self:initBg()
  self:dealUserGuide()
end

function M:initData()
  self.mExp = CloudData.USER_LEVEL * 60
  self.mStageInfo = DYCommon.getDataByTag(DataRetainer.STAGE_INFO, "id", tostring(self.mStageNum + 10000))[1]
  if not self.mStageInfo then
    DDERROR("stageInfo index : %d with error data", checknumber(self.mStageNum + 10000))
    return
  end
  self.mEneryCost = checknumber(self.mStageInfo.energyCost)
  self.mTotalTimes = checknumber(self.mStageInfo.challengeTimes)
  self.mEssence = checknumber(self.mStageInfo.essenceAward)
  self.mEssenceInc = math.floor(self.mEssence * DataUtils.getStageEssenceAddRate())
  local awardList = self.mStageInfo.awardIdList
  if awardList == "0" then
    self.mPieceTable = {}
  else
    local awardTable = split(awardList, ";")
    for i = 1, #awardTable do
      self.mPieceTable[i] = {
        id = checknumber(awardTable[i])
      }
    end
  end
  local challengeTime = self.mTotalTimes
  local info = CloudData.CHAPTER_INFO_TABLE.main.stageInfo[tostring(self.mStageNum + 10000)]
  if info ~= nil and checknumber(info.starCount) > 0 then
    self.mStars = checknumber(info.starCount)
    challengeTime = checknumber(info.challengeTimes)
    self.mPeachCost = checknumber(info.resetCost)
    self.mResetTime = checknumber(info.resetLeft)
  end
  self.mTimes = challengeTime
end

function M:initBg()
  self.mBg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(598, 652), cc.rect(598, 125, 5, 5)):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.95, self.mBg:getContentSize().height * 0.96):addTo(self.mBg):onButtonClicked(function()
    self:closeCallBack()
  end)
  local chapter = math.ceil(self.mStageNum / 10)
  display.newSprite(string.format("stage/chapter" .. chapter .. ".png"), self.mBg:getContentSize().width * 0.23, self.mBg:getContentSize().height * 0.915):addTo(self.mBg)
  local stagelabel = cc.ui.UILabel.new({
    text = DYLang.getString("S45", "") .. self.mStageNum .. DYLang.getString("S910", ""),
    size = 30,
    color = cc.c3b(255, 235, 12),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.37, self.mBg:getContentSize().height * 0.915):addTo(self.mBg)
  stagelabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  for i = 1, self.mStars do
    display.newSprite("stage/star.png", self.mBg:getContentSize().width * (0.68 + i * 0.06), self.mBg:getContentSize().height * 0.915):addTo(self.mBg)
  end
  for i = 3, self.mStars + 1, -1 do
    display.newSprite("stage/star_gray.png"):pos(self.mBg:getContentSize().width * (0.68 + i * 0.06), self.mBg:getContentSize().height * 0.915):addTo(self.mBg)
  end
  local timeStr = display.newSprite("stage/time_str.png"):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.08, self.mBg:getContentSize().height * 0.82):addTo(self.mBg)
  self.mTimesLabel = cc.ui.UILabel.new({
    text = self.mTimes .. "/" .. self.mTotalTimes,
    size = 22,
    color = cc.c3b(67, 255, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, timeStr:getContentSize().width + 15, timeStr:getContentSize().height * 0.49):addTo(timeStr)
  self.mTimesLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local teamLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S912", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  teamLabel:enableOutline(cc.c4b(147, 78, 1, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", teamLabel):onButtonClicked(function()
    local team = LayerTeam.new(LayerTeam.TEAM_NORMAL)
    self:addChild(team, 20)
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.78, self.mBg:getContentSize().height * 0.8):addTo(self.mBg)
  display.newSprite("stage/award_str.png"):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.08, self.mBg:getContentSize().height * 0.75):addTo(self.mBg)
  local expBg = display.newScale9Sprite("stage/bg_num.png", 0, 0, cc.size(155, 30), cc.rect(50, 0, 5, 0)):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.1, self.mBg:getContentSize().height * 0.68):addTo(self.mBg)
  display.newSprite("item_icon/pic_exp.png"):align(display.CENTER, expBg:getContentSize().width * 0.05, expBg:getContentSize().height * 0.5):scale(0.6):addTo(expBg)
  self.mExpLabel = cc.ui.UILabel.new({
    text = self.mExp,
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, expBg:getContentSize().width * 0.6, expBg:getContentSize().height * 0.5):addTo(expBg)
  local essenceBg = display.newScale9Sprite("stage/bg_num.png", 0, 0, cc.size(185, 30), cc.rect(50, 0, 5, 0)):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.53, self.mBg:getContentSize().height * 0.68):addTo(self.mBg)
  display.newSprite("item_icon/pic_essence.png"):align(display.CENTER, essenceBg:getContentSize().width * 0.05, essenceBg:getContentSize().height * 0.5):scale(0.7):addTo(essenceBg)
  local essenceLabel = cc.ui.UILabel.new({
    text = self.mEssence,
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, essenceBg:getContentSize().width * 0.56, essenceBg:getContentSize().height * 0.5):addTo(essenceBg)
  if 0 < self.mEssenceInc then
    essenceLabel:setPositionX(essenceBg:getContentSize().width * 0.33)
    cc.ui.UILabel.new({
      text = "+",
      size = 22,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, essenceBg:getContentSize().width * 0.565, essenceBg:getContentSize().height * 0.5):addTo(essenceBg)
    cc.ui.UILabel.new({
      text = self.mEssenceInc,
      size = 22,
      color = cc.c3b(67, 255, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, essenceBg:getContentSize().width * 0.8, essenceBg:getContentSize().height * 0.5):addTo(essenceBg)
  end
  display.newSprite("stage/treasure_str.png"):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.08, self.mBg:getContentSize().height * 0.58):addTo(self.mBg)
  local treasureBg = display.newSprite("stage/treasure_bg.png", self.mBg:getContentSize().width * 0.41, self.mBg:getContentSize().height * 0.56):scale(0.8):addTo(self.mBg)
  self.mTreasureIcon = display.newSprite():pos(treasureBg:getContentSize().width * 0.5, treasureBg:getContentSize().height * 0.5):addTo(treasureBg)
  local treasurePieceQuality = DataUtils.getTreasurePieceQuality(self.mStageNum)
  if treasurePieceQuality ~= 0 then
    self.mTreasureIcon:setTexture("treasure/piece" .. treasurePieceQuality .. ".png")
  end
  display.newSprite("stage/award_str1.png"):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.08, self.mBg:getContentSize().height * 0.47):addTo(self.mBg)
  local awardListBg = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(512, 145), cc.rect(50, 50, 2, 2)):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.32):addTo(self.mBg)
  for i = 1, #self.mPieceTable do
    local frame = IconItem.new(self.mPieceTable[i].id)
    frame:setPosition(awardListBg:getContentSize().width * (0.245 * i - 0.115), awardListBg:getContentSize().height * 0.5)
    awardListBg:addChild(frame)
    frame:showItemTip()
  end
  local fightLabel = cc.ui.UILabel.new({
    text = "     \230\140\145\230\136\152",
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  fightLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  local fightBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonSize(160, 69):setButtonLabel("normal", fightLabel):onButtonClicked(function()
    self:gameStartCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.14):addTo(self.mBg)
  display.newSprite("item_icon/pic_energy.png", -52, 0):scale(0.8):addTo(fightBtn)
  cc.ui.UILabel.new({
    text = self.mEneryCost,
    size = 25,
    color = cc.c3b(255, 235, 12),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, -20, 0):addTo(fightBtn)
  if self.mStars == 3 then
    fightBtn:setPositionX(self.mBg:getContentSize().width * 0.78)
    local sweepLabel = cc.ui.UILabel.new({
      text = DYLang.getString("S914", ""),
      size = 26,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    })
    sweepLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
    local sweepBtn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }, {scale9 = true}):setButtonSize(160, 69):setButtonLabel("normal", sweepLabel):onButtonClicked(function()
      self:sweepCallBack()
    end):align(display.CENTER, self.mBg:getContentSize().width * 0.22, self.mBg:getContentSize().height * 0.14):addTo(self.mBg)
    if DataUtils.getIsVipFuntionsUnlock("sweep5") then
      local sweep5Label = cc.ui.UILabel.new({
        text = string.format("\230\137\171\232\141\161%d\230\172\161", self.mTimes),
        size = 26,
        color = cc.c3b(255, 240, 0),
        font = GameManager.FONTNAME_TTF
      })
      sweep5Label:enableOutline(cc.c4b(25, 30, 3, 255), 2)
      self.mBtnSweep5 = cc.ui.UIPushButton.new({
        normal = "common_ui/btn_normal1.png",
        pressed = "common_ui/btn_pressed1.png"
      }, {scale9 = true}):setButtonSize(160, 69):setButtonLabel("normal", sweep5Label):onButtonClicked(function()
        self:sweep5CallBack()
      end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.14):addTo(self.mBg)
    else
      local sweep5Label = cc.ui.UILabel.new({
        text = string.format("\230\137\171\232\141\161%d\230\172\161", self.mTimes),
        size = 26,
        color = cc.c3b(202, 199, 199),
        font = GameManager.FONTNAME_TTF
      })
      sweep5Label:enableOutline(cc.c4b(40, 40, 40, 255), 2)
      self.mBtnSweep5 = cc.ui.UIPushButton.new("common_ui/btn_disabled1.png", {scale9 = true}):setButtonSize(160, 69):setButtonLabel("normal", sweep5Label):onButtonClicked(function()
        local tip = WSToast.new("VIP\231\173\137\231\186\167\228\184\141\232\182\179")
        self:addChild(tip, 20)
      end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.14):addTo(self.mBg)
    end
  end
end

function M:gameStartCallBack()
  if self.mTimes > 0 and CloudData.ENERGY >= self.mEneryCost then
    local function tFuncListener(jsonTable)
      local pData = jsonTable.data
      
      if not self.class or self.class.__cname ~= CLASS_NAME then
        return
      end
      if not pData then
        DDTRACE("LayerStageInfo.gameStartCallBack", string.format("pData is nil, errorCode: %s, errorMsg: %s", checkstring(jsonTable.errorCode), checkstring(jsonTable.errorMsg)))
        return
      end
      CloudData.PVE_ATK_CIMELIA_DATA = pData.attackCimelia
      CloudData.PVE_DEF_CIMELIA_DATA = pData.defenceCimelia
      for k, info in pairs(pData.teamList) do
        local npcId = info.id or 0
        CloudData.NPC_INFO[tonumber(npcId)] = info
      end
      CloudData.ENERGY = CloudData.ENERGY - self.mEneryCost
      GameManager.ENERGY_COST = self.mEneryCost
      GameManager.STAGE_ID = self.mStageNum + 10000
      GameManager.STAGE_NUM = self.mStageNum or 0
      GameManager.MODE = 0
      display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE", "NORMAL"))
    end
    
    DYHttpMgr.getFightData(tFuncListener, {fightMode = 0})
  elseif self.mTimes > 0 then
    local tip = LayerLackEnergy.new()
    self:addChild(tip, 50)
  else
    self:showResetWarn()
  end
end

function M:sweepCallBack()
  if CloudData.ENERGY < self.mEneryCost then
    local tip = LayerLackEnergy.new()
    self:addChild(tip, 50)
  elseif self.mTimes < 1 then
    self:showResetWarn()
  elseif 1 > CloudData.SWEEP then
    local tip = WSToast.new(DYLang.getString("S919", ""), 1)
    self:addChild(tip, 20)
  else
    local function tFuncListener(info)
      if info.errorCode ~= 0 then
        local toast = WSToast.new(info.errorMsg, 2)
        
        self:addChild(toast, 20)
      else
        DYSoundMgr.playEffect(DY_SND.sfx_saodang)
        local quality = tonumber(info.data.treasureQuality) or 0
        local treasurePieceQuality = DataUtils.getTreasurePieceQuality(self.mStageNum)
        if quality <= treasurePieceQuality then
          info.data.treasureQuality = 0
        end
        if self.refreshSweepData then
          self.mRetTime = info.time or 0
          self:refreshSweepData(info.data)
        end
        self.mExp = tonumber(info.data.expGain)
        local essence = tonumber(info.data.essenceGain)
        self.mEssenceInc = essence - checknumber(self.mEssence)
        DYAnalyze.item.get(4, "EXP", self.mExp, "MAIN_STAGE_SWEEP")
        DYAnalyze.item.get(2, "ESSENCE", essence, "MAIN_STAGE_SWEEP")
        DYAnalyze.item.consume(2006, "SWEEP", 1, "MAIN_STAGE_SWEEP")
        DYAnalyze.item.consume(3, "ENERGY", self.mEneryCost, "MAIN_STAGE_SWEEP")
        if self.mBtnSweep5 then
          self.mBtnSweep5:setButtonLabelString("normal", string.format("\230\137\171\232\141\161%d\230\172\161", self.mTimes))
        end
        if self.showSweepResult then
          self:showSweepResult(info.data)
        end
        if self.mExpLabel then
          self.mExp = CloudData.USER_LEVEL * 60
          self.mExpLabel:setString(self.mExp)
        end
      end
    end
    
    local params = {}
    params.stageId = self.mStageNum + 10000
    DYHttpMgr.sweepInMain(tFuncListener, params)
  end
end

function M:sweep5CallBack()
  if CloudData.ENERGY < self.mEneryCost * self.mTimes then
    local tip = LayerLackEnergy.new()
    self:addChild(tip, 50)
  elseif self.mTimes == 0 then
    self:showResetWarn()
  elseif CloudData.SWEEP < self.mTimes then
    local tip = WSToast.new(DYLang.getString("S919", ""), 1)
    self:addChild(tip, 20)
  else
    local countTimes = self.mTimes
    
    local function tFuncListener(info)
      if info.errorCode ~= 0 then
        local toast = WSToast.new(info.errorMsg, 2)
        self:addChild(toast, 20)
      else
        DYSoundMgr.playEffect(DY_SND.sfx_saodang)
        local quality = tonumber(info.data.treasureQuality) or 0
        local treasurePieceQuality = DataUtils.getTreasurePieceQuality(self.mStageNum)
        if quality <= treasurePieceQuality then
          info.data.treasureQuality = 0
        end
        self.mRetTime = info.time or 0
        self:refreshSweepData(info.data)
        self:showSweep5Result(info.data.reward, countTimes)
        DYAnalyze.item.consume(2006, "SWEEP", 5, "MAIN_STAGE_SWEEP5")
        DYAnalyze.item.consume(3, "ENERGY", self.mEneryCost * 5, "MAIN_STAGE_SWEEP5")
        self.mBtnSweep5:setButtonLabelString("normal", "\230\137\171\232\141\1610\230\172\161")
        self.mExp = CloudData.USER_LEVEL * 60
        self.mExpLabel:setString(self.mExp)
      end
    end
    
    local params = {}
    params.stageId = self.mStageNum + 10000
    params.times = countTimes
    DYHttpMgr.sweep5InMain(tFuncListener, params)
  end
end

function M:refreshSweepData(info)
  self.mMeetBoss = checknumber(info.isMeetBoss)
  CloudData.CHAPTER_INFO_TABLE.main.stageInfo[tostring(self.mStageNum + 10000)].challengeTimes = tonumber(info.challengeTimes)
  self.mTimes = tonumber(info.challengeTimes)
  self.mTimesLabel:setString(self.mTimes .. "/" .. self.mTotalTimes)
  CloudData.ENERGY = tonumber(info.energy)
  CloudData.SWEEP = tonumber(info.sweep)
  CloudData.ESSENCE = tonumber(info.essence)
  local userLevel, exp = DataUtils.getUserLevelAndExp(tonumber(info.exp))
  local originLevel = CloudData.USER_LEVEL
  CloudData.USER_LEVEL = userLevel
  CloudData.EXP = tonumber(info.exp)
  DYNotification.postNotification(DY_KEY.kUpdateUserExp)
  self.mShowLevel = 0
  if originLevel < CloudData.USER_LEVEL then
    self.mShowLevel = originLevel + 1
    self:showUpgradeAni()
    DYAnalyze.account.changeTag(DYLang.getString("S922", ""), originLevel, CloudData.USER_LEVEL)
  end
  local quality = tonumber(info.treasureQuality)
  if 0 < quality then
    CloudData.TREASURE_PIECE_INFO[self.mStageNum] = quality
    DYNotification.postNotification(DY_KEY.kUpdateStageTreasure, (self.mStageNum - 1) % 10 + 1)
    if self.mTreasureIcon then
      self.mTreasureIcon:setTexture("treasure/piece" .. quality .. ".png")
    end
  end
  CloudData.GAME_ITEM_INFO["2006"] = CloudData.SWEEP
  CloudData.GAME_ITEM_INFO["3"] = CloudData.ENERGY
  CloudData.GAME_ITEM_INFO["2"] = CloudData.ESSENCE
  CloudData.GAME_ITEM_INFO["4"] = CloudData.EXP
  for id, num in pairs(info.drop) do
    DataUtils.updateItemNum(id, num)
  end
end

function M:showUpgradeAni()
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
  LayerLevelUpAni.new(self.mShowLevel, handler(self, self.removeUpgradeAni)):addTo(self, 20)
end

function M:removeUpgradeAni(tag)
  if self.mShowLevel < CloudData.USER_LEVEL then
    self.mShowLevel = self.mShowLevel + 1
    self:showUpgradeAni()
  elseif tag and self.mMeetBoss == 0 then
    GameManager.MODE = 0
    CloudData.CHAPTER_INFO_TABLE = {}
    local nextScene = require("scenes.ChapterScene").new()
    display.replaceScene(nextScene, "fade", 0.2)
  end
end

function M:meetBossCB(param1, param2)
  if checkstring(param2) == "SCENE_AGGRESS" then
    local nextScene = LayerBossRelated.scene()
    display.replaceScene(nextScene, "fade", 0.2)
  end
end

function M:showSweepResult(info)
  self.mSweepLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):pos(0, 10):addTo(self, 5)
  local tip = display.newSprite("common_ui/common_dialog.png", display.cx, display.cy):addTo(self.mSweepLayer)
  display.newSprite("stage/sweep_title.png"):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.87):addTo(tip)
  local textLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S923", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  textLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.17):addTo(tip):setButtonLabel("normal", textLabel):onButtonClicked(function()
    if self.mSweepLayer then
      self.mSweepLayer:runAction(cc.RemoveSelf:create())
      self.mSweepLayer = nil
    end
    if self.mMeetBoss == 1 then
      self.mMeetBoss = 0
      LayerMeetBoss.new(handler(self, self.meetBossCB)):addTo(self, 20)
    end
  end)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(512, 191), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.52):addTo(tip)
  local awardStr = cc.ui.UILabel.new({
    text = DYLang.getString("S924", ""),
    size = 25,
    color = cc.c3b(255, 252, 10),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.05, frame:getContentSize().height * 0.85):addTo(frame)
  awardStr:enableOutline(cc.c4b(88, 34, 1, 255), 2)
  display.newSprite("item_icon/pic_exp.png", frame:getContentSize().width * 0.25, frame:getContentSize().height * 0.85):scale(0.7):addTo(frame)
  local exp = info.expGain
  local numLabel = cc.ui.UILabel.new({
    text = exp,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.33, frame:getContentSize().height * 0.85):addTo(frame)
  numLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  display.newSprite("item_icon/pic_essence.png", frame:getContentSize().width * 0.6, frame:getContentSize().height * 0.85):scale(0.8):addTo(frame)
  local num = info.essenceGain
  local numLabel = cc.ui.UILabel.new({
    text = num,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.67, frame:getContentSize().height * 0.85):addTo(frame)
  numLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local sum = 1
  local quality = tonumber(info.treasureQuality) or 0
  if 0 < quality then
    sum = sum + 1
    local icon = display.newSprite("common_ui/frame0.png", frame:getContentSize().width * 0.13, frame:getContentSize().height * 0.4):addTo(frame)
    local quality = tonumber(info.treasureQuality)
    display.newSprite("treasure/piece" .. quality .. ".png"):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):addTo(icon)
  end
  if info.dropGain == nil then
    return
  end
  for id, num in pairs(info.dropGain) do
    if 0 < tonumber(id) then
      local icon = IconItem.new(tonumber(id), tonumber(num))
      icon:setPosition(frame:getContentSize().width * (0.245 * sum - 0.115), frame:getContentSize().height * 0.4)
      frame:addChild(icon)
      icon:showItemTip()
      DYAnalyze.item.get(id, "", num, "MAIN_STAGE_SWEEP")
      sum = sum + 1
      if 4 < sum then
        return
      end
    end
  end
  local guide = stageProgress == 10 and DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE10_STAGELAY") and NoviceGuide.new("GUDIE_STAGE10_STAGELAY_SWEEP", function()
    local scene = require("app.scenes.ChapterScene").new()
    display.replaceScene(scene("FADETR"), 1)
  end):addTo(self, 50)
end

function M:showSweep5Result(info, countTimes)
  self.mSweepItemSize = 245
  self.mSweepListBorderX = 13
  self.mSweepListWidth = 506
  self.mSweepListHight = 425
  display.addSpriteFrames("animation/sweep.plist", "animation/sweep.png")
  self.mSweepIconTable = {}
  self.mSweepLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):pos(0, 10):addTo(self, 5)
  local tip = display.newScale9Sprite("common_ui/common_dialog.png", display.cx, display.cy, cc.size(598, 669), cc.rect(598, 125, 5, 5)):addTo(self.mSweepLayer)
  display.newSprite("stage/sweep_title.png"):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.92):addTo(tip)
  local textLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S923", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  textLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.12):addTo(tip):setButtonLabel("normal", textLabel):onButtonClicked(function()
    if self.mSweepLayer then
      self.mSweepLayer:stopAllActions()
      self.mSweepLayer:runAction(cc.RemoveSelf:create())
      self.mSweepLayer = nil
    end
    if self.mMeetBoss == 1 then
      self.mMeetBoss = 0
      LayerMeetBoss.new(handler(self, self.meetBossCB)):addTo(self, 20)
    end
  end)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(532, 454), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.53):addTo(tip)
  self.mScrollNode = cc.Node:create()
  self.mScrollNode:setContentSize(self.mSweepListWidth, self.mSweepListHight)
  local params = {
    viewRect = cc.rect(self.mSweepListBorderX, 15, self.mSweepListWidth, self.mSweepListHight)
  }
  local node = cc.ui.UIScrollView.new(params):addScrollNode(self.mScrollNode)
  local dir = cc.ui.UIScrollView.DIRECTION_VERTICAL
  node:setDirection(dir)
  node:setBounceable(true)
  frame:addChild(node)
  node:setTouchEnabled(false)
  for i = 1, countTimes do
    local goods = {}
    if info ~= nil and info[tostring(i)] ~= nil then
      goods = info[tostring(i)]
    end
    self:addSweepItem(goods, i)
  end
  local distance = -50 - self.mSweepItemSize * 4 - self.mSweepListHight
  for i = 1, countTimes do
    transition.moveBy(self.mSweepIconTable[i], {
      x = 0,
      y = distance,
      time = 0,
      easing = "sineOut",
      onComplete = function()
        if i == countTimes then
          self:showSweepItemMoveIn(1, countTimes)
        end
      end
    })
  end
end

function M:addSweepItem(goods, index)
  local item = cc.Node:create()
  item:setContentSize(self.mSweepListWidth, self.mSweepItemSize)
  item:setPosition(self.mSweepListBorderX, self.mSweepItemSize * (6 - index))
  self.mScrollNode:addChild(item)
  self.mSweepIconTable[index] = item
  local content = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(self.mSweepListWidth, self.mSweepItemSize - 10), cc.rect(45, 45, 2, 2)):pos(item:getContentSize().width * 0.5, item:getContentSize().height * 0.5):addTo(item)
  if goods == nil then
    return
  end
  display.newSprite("stage/sweep_title" .. index .. ".png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.87):addTo(content)
  local expBg = display.newSprite("stage/bg_num.png"):align(display.CENTER_LEFT, content:getContentSize().width * 0.2, content:getContentSize().height * 0.68):addTo(content)
  display.newSprite("item_icon/pic_exp.png"):align(display.CENTER, expBg:getContentSize().width * 0.03, expBg:getContentSize().height * 0.5):scale(0.6):addTo(expBg)
  local exp = goods.exp
  local expLabel = cc.ui.UILabel.new({
    text = exp,
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, expBg:getContentSize().width * 0.55, expBg:getContentSize().height * 0.5):addTo(expBg)
  local essenceBg = display.newSprite("stage/bg_num.png"):align(display.CENTER_LEFT, content:getContentSize().width * 0.56, content:getContentSize().height * 0.68):addTo(content)
  display.newSprite("item_icon/pic_essence.png"):align(display.CENTER, essenceBg:getContentSize().width * 0.05, essenceBg:getContentSize().height * 0.5):scale(0.7):addTo(essenceBg)
  local essence = goods.essence
  local essenceLabel = cc.ui.UILabel.new({
    text = essence,
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, essenceBg:getContentSize().width * 0.56, essenceBg:getContentSize().height * 0.5):addTo(essenceBg)
  DYAnalyze.item.get(4, "EXP", exp, "MAIN_STAGE_SWEEP5")
  DYAnalyze.item.get(2, "ESSENCE", essence, "MAIN_STAGE_SWEEP5")
  local treasureId = tonumber(goods.treasureQuality)
  local sum = 1
  if treasureId ~= nil and 0 < treasureId then
    sum = sum + 1
    local frame = display.newSprite("common_ui/frame0.png", content:getContentSize().width * 0.135, content:getContentSize().height * 0.32):scale(0.9):addTo(content)
    display.newSprite("treasure/piece" .. treasureId .. ".png"):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  end
  if goods.drop == nil then
    return
  end
  for id, num in pairs(goods.drop) do
    if 0 < tonumber(id) then
      local frame = IconItem.new(tonumber(id), tonumber(num))
      frame:setPosition(content:getContentSize().width * (0.235 * sum - 0.1), content:getContentSize().height * 0.32)
      frame:setScale(0.9)
      content:addChild(frame)
      frame:showItemTip()
      DYAnalyze.item.get(id, "", num, "MAIN_STAGE_SWEEP5")
      sum = sum + 1
      if 4 < sum then
        break
      end
    end
  end
end

function M:showSweepItemMoveIn(index, countTimes)
  local dis = self.mSweepListHight + self.mSweepItemSize * (index - 1)
  local t = 0.7
  if 1 == index then
    t = 0.4
  elseif index == countTimes then
    dis = self.mSweepItemSize * index
  end
  transition.moveBy(self.mSweepIconTable[index], {
    x = 0,
    y = dis,
    time = t,
    easing = "sineOut",
    onComplete = function()
      self:showSweep5Ani(index, countTimes)
    end
  })
end

function M:showSweep5Ani(index, countTimes)
  local frames = display.newFrames("sweep%d.png", 1, 18)
  local animation = display.newAnimation(frames, 0.05)
  local emptySp = display.newSprite():pos(self.mSweepIconTable[index]:getContentSize().width * 0.5, self.mSweepIconTable[index]:getContentSize().height * 0.35):addTo(self.mSweepIconTable[index], 5)
  emptySp:playAnimationOnce(animation)
  if index == countTimes then
    return
  end
  local popupLayer = transition.sequence({
    cc.DelayTime:create(0.7),
    cc.CallFunc:create(function()
      self:showSweepItemMoveIn(index + 1, countTimes)
    end),
    cc.DelayTime:create(0.3),
    cc.CallFunc:create(function()
      self:showSweepItemMoveOut(index, countTimes)
    end)
  })
  if self.mSweepLayer then
    self.mSweepLayer:runAction(popupLayer)
  end
end

function M:showSweepItemMoveOut(index, countTimes)
  local dis = self.mSweepItemSize
  if index == countTimes - 1 then
    dis = 2 * self.mSweepItemSize - self.mSweepListHight
  end
  for i = 1, index do
    transition.moveBy(self.mSweepIconTable[i], {
      x = 0,
      y = dis,
      time = 0.4,
      easing = "sineOut",
      onComplete = function()
      end
    })
  end
end

function M:showResetWarn()
  self.mResetLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):pos(0, 10):addTo(self, 5)
  local tip = display.newSprite("common_ui/common_dialog.png", display.cx, display.cy):addTo(self.mResetLayer)
  display.newSprite("stage/reset_str.png"):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.87):addTo(tip)
  local resetTextLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S926", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  resetTextLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", resetTextLabel):onButtonClicked(function()
    self:reset()
    self.mResetLayer:removeSelf()
    self.mResetLayer = nil
  end):align(display.CENTER, tip:getContentSize().width * 0.3, tip:getContentSize().height * 0.21):addTo(tip)
  local cancelLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S927", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  cancelLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", cancelLabel):onButtonClicked(function()
    self.mResetLayer:removeSelf()
    self.mResetLayer = nil
  end):align(display.CENTER, tip:getContentSize().width * 0.7, tip:getContentSize().height * 0.21):addTo(tip)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(509, 174), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.56):addTo(tip)
  local resetStr = DYLabelTTF.new({
    text = DYLang.getString("S928", ""),
    size = 25,
    color = cc.c3b(255, 252, 10),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(88, 34, 1, 255)
  }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.18, frame:getContentSize().height * 0.65):addTo(frame)
  local resetTime = cc.ui.UILabel.new({
    UILabelType = 2,
    text = self.mResetTime,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.56, frame:getContentSize().height * 0.65):addTo(frame)
  resetTime:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local costStr = DYLabelTTF.new({
    text = DYLang.getString("S929", ""),
    size = 25,
    color = cc.c3b(255, 252, 10),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(88, 34, 1, 255)
  }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.18, frame:getContentSize().height * 0.35):addTo(frame)
  display.newSprite("item_icon/pic_peach.png", frame:getContentSize().width * 0.56, frame:getContentSize().height * 0.35):scale(0.8):addTo(frame)
  local costLabel = cc.ui.UILabel.new({
    text = self.mPeachCost,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.61, frame:getContentSize().height * 0.35):addTo(frame)
  costLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

function M:reset()
  if self.mPeachCost > CloudData.PEACH then
    local toast = WSToast.new(DYLang.getString("S930", ""))
    self:addChild(toast, 20)
    return
  elseif self.mResetTime <= 0 then
    local toast = WSToast.new(DYLang.getString("S931", ""))
    self:addChild(toast, 20)
    return
  end
  local stage = self.mStageNum + 10000
  
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local toast = WSToast.new(info.errorMsg, 2)
      self:addChild(toast, 20)
    else
      DYAnalyze.item.consume(1, "PEACH", self.mPeachCost, "MAIN_STAGE_RESET")
      CloudData.CHAPTER_INFO_TABLE.main.stageInfo[tostring(stage)].resetCost = tonumber(info.data.resetPeach)
      CloudData.CHAPTER_INFO_TABLE.main.stageInfo[tostring(stage)].resetLeft = tonumber(info.data.leftTimes)
      CloudData.CHAPTER_INFO_TABLE.main.stageInfo[tostring(stage)].challengeTimes = tonumber(info.data.challengeTimes)
      CloudData.PEACH = tonumber(info.data.peach)
      CloudData.GAME_ITEM_INFO[tostring(id)] = CloudData.PEACH
      self.mResetTime = tonumber(info.data.leftTimes)
      self.mPeachCost = tonumber(info.data.resetPeach)
      if self.mBtnSweep5 then
        self.mBtnSweep5:setButtonLabelString("normal", "\230\137\171\232\141\1615\230\172\161")
      end
      self.mTimes = tonumber(info.data.challengeTimes)
      self.mTimesLabel:setString(self.mTimes .. "/" .. self.mTotalTimes)
    end
  end
  
  local params = {}
  params.stageId = stage
  DYHttpMgr.mainReset(tFuncListener, params)
end

function M:dealUserGuide()
end

function M:resDownloaded()
  DYStat.setValueBool(DY_KEY.kIsArmatureDownloaded, true)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:runAction(cc.RemoveSelf:create())
    end)
  })
  self.mNode:runAction(popupLayer)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    if self.mSweepLayer then
      self.mSweepLayer:stopAllActions()
      self.mSweepLayer:runAction(cc.RemoveSelf:create())
      self.mSweepLayer = nil
    elseif self.mResetLayer then
      self.mResetLayer:runAction(cc.RemoveSelf:create())
      self.mResetLayer = nil
    else
      self:runAction(cc.RemoveSelf:create())
    end
    return true
  end
  return false
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

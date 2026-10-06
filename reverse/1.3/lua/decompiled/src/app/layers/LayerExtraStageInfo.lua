local LayerLackEnergy = require("app.layers.LayerLackEnergy")
local WSToast = require("app.utils.WSToast")
local IconItem = require("app.icons.IconItem")
local LayerTeam = require("app.layers.LayerTeam")
local LayerLevelUpAni = require("app.layers.LayerLevelUpAni")
local LayerMeetBoss = require("app.aggress.layers.LayerMeetBoss")
local LayerBossRelated = require("app.aggress.layers.LayerBossRelated")
local CLASS_NAME = "LayerExtraStageInfo"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(stageNum, cb)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mBg = nil
  self.mStageNum = stageNum
  self.mTimes = 0
  self.mTotalTimes = 0
  self.mEneryCost = 0
  self.mExp = 0
  self.mEssence = 0
  self.mEssenceInc = 0
  self.mPieceTable = {}
  self.mSweepLayer = nil
  self.mBuddhaId = 0
  self.mBuddhaName = ""
  self.mTimesLabel = nil
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
end

function M:initData()
  self.mExp = CloudData.USER_LEVEL * 6
  self.mStageInfo = DYCommon.getDataByTag(DataRetainer.STAGE_INFO, "id", tostring(self.mStageNum + 20000))[1]
  if not self.mStageInfo then
    DDERROR("stageInfo index : %d with error data", tonumber(self.mStageNum + 20000))
    return
  end
  self.mTotalTimes = tonumber(self.mStageInfo.challengeTimes)
  self.mEneryCost = tonumber(self.mStageInfo.energyCost)
  self.mEssence = tonumber(self.mStageInfo.essenceAward)
  self.mEssenceInc = math.floor(self.mEssence * DataUtils.getStageEssenceAddRate())
  local awardList = self.mStageInfo.awardIdList
  if awardList == "0" then
    self.mPieceTable = {}
  else
    local awardTable = split(awardList, ";")
    for i = 1, #awardTable do
      self.mPieceTable[i] = {
        id = tonumber(awardTable[i])
      }
    end
  end
  self.mBuddhaId = tonumber(self.mStageInfo.monsterId)
  local monsterInfo = DataUtils.getMonsterModel(self.mBuddhaId)
  self.mBuddhaName = monsterInfo.npcName
  self.mBuddhaPic = monsterInfo.npcIcon
  local challengeTimes = CloudData.CHAPTER_INFO_TABLE.elite.stageInfo[tostring(self.mStageNum + 20000)]
  if challengeTimes ~= nil then
    self.mTimes = tonumber(challengeTimes)
  else
    self.mTimes = self.mTotalTimes
  end
end

function M:initBg()
  self.mBg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(598, 652), cc.rect(598, 125, 5, 5)):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.95, self.mBg:getContentSize().height * 0.96):addTo(self.mBg):onButtonClicked(function()
    self:closeCallBack()
  end)
  local chapter = math.ceil(self.mStageNum / 4)
  display.newSprite(string.format("stage/chapter" .. chapter .. ".png"), self.mBg:getContentSize().width * 0.23, self.mBg:getContentSize().height * 0.915):addTo(self.mBg)
  local stage = (self.mStageNum - 1) % 4 + 1
  local stagelabel = cc.ui.UILabel.new({
    text = DYLang.getString("S45", "") .. stage .. DYLang.getString("S633", ""),
    size = 30,
    color = cc.c3b(255, 235, 12),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.37, self.mBg:getContentSize().height * 0.915):addTo(self.mBg)
  stagelabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local frame = display.newSprite("common_ui/frame3.png", self.mBg:getContentSize().width * 0.16, self.mBg:getContentSize().height * 0.78):scale(0.9):addTo(self.mBg)
  display.newSprite(self.mBuddhaPic, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  cc.ui.UILabel.new({
    text = self.mBuddhaName,
    size = 22,
    color = cc.c3b(60, 36, 13),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.28, self.mBg:getContentSize().height * 0.82):addTo(self.mBg)
  local timeStr = display.newSprite("stage/time_str.png"):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.27, self.mBg:getContentSize().height * 0.73):addTo(self.mBg)
  self.mTimesLabel = cc.ui.UILabel.new({
    text = self.mTimes,
    size = 22,
    color = cc.c3b(67, 255, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, timeStr:getContentSize().width + 15, timeStr:getContentSize().height * 0.49):addTo(timeStr)
  self.mTimesLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local teamLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S635", ""),
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
  display.newSprite("stage/award_str.png"):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.08, self.mBg:getContentSize().height * 0.63):addTo(self.mBg)
  local expBg = display.newScale9Sprite("stage/bg_num.png", 0, 0, cc.size(155, 30), cc.rect(50, 0, 5, 0)):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.1, self.mBg:getContentSize().height * 0.55):addTo(self.mBg)
  display.newSprite("item_icon/pic_exp.png"):align(display.CENTER, expBg:getContentSize().width * 0.05, expBg:getContentSize().height * 0.5):scale(0.6):addTo(expBg)
  self.mExpLabel = cc.ui.UILabel.new({
    text = self.mExp,
    size = 22,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, expBg:getContentSize().width * 0.6, expBg:getContentSize().height * 0.5):addTo(expBg)
  local essenceBg = display.newScale9Sprite("stage/bg_num.png", 0, 0, cc.size(185, 30), cc.rect(50, 0, 5, 0)):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.53, self.mBg:getContentSize().height * 0.55):addTo(self.mBg)
  display.newSprite("item_icon/pic_essence.png"):align(display.CENTER, essenceBg:getContentSize().width * 0.08, essenceBg:getContentSize().height * 0.5):scale(0.7):addTo(essenceBg)
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
  display.newSprite("stage/award_str1.png"):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.08, self.mBg:getContentSize().height * 0.47):addTo(self.mBg)
  local awardListBg = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(512, 145), cc.rect(50, 50, 2, 2)):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.32):addTo(self.mBg)
  for i = 1, #self.mPieceTable do
    local frame = IconItem.new(self.mPieceTable[i].id)
    frame:setPosition(awardListBg:getContentSize().width * (0.245 * i - 0.115), awardListBg:getContentSize().height * 0.5)
    awardListBg:addChild(frame)
    frame:showItemTip()
  end
  local fightLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S637", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  fightLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  local fightBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }, {scale9 = true}):setButtonLabel("normal", fightLabel):onButtonClicked(function()
    self:gameStartCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.14):addTo(self.mBg)
  local progress = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.stageId) % 20000
  if progress >= self.mStageNum then
    fightBtn:setPositionX(self.mBg:getContentSize().width * 0.7)
    local sweepLabel = cc.ui.UILabel.new({
      text = DYLang.getString("S638", ""),
      size = 26,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    })
    sweepLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
    local sweepBtn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }, {scale9 = true}):setButtonLabel("normal", sweepLabel):onButtonClicked(function()
      self:sweepCallBack()
    end):align(display.CENTER, self.mBg:getContentSize().width * 0.3, self.mBg:getContentSize().height * 0.14):addTo(self.mBg)
  end
end

function M:gameStartCallBack()
  local dungeonTimes = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.challengeTimes)
  if dungeonTimes <= 0 then
    local tip = WSToast.new(DYLang.getString("S639", ""), 1)
    self:addChild(tip, 20)
  elseif 0 >= self.mTimes then
    local tip = WSToast.new(DYLang.getString("S640", ""), 1)
    self:addChild(tip, 20)
  else
    local function tFuncListener(jsonTable)
      local pData = jsonTable.data
      
      CloudData.PVE_ATK_CIMELIA_DATA = pData.attackCimelia
      CloudData.PVE_DEF_CIMELIA_DATA = pData.defenceCimelia
      for k, info in pairs(pData.teamList) do
        local npcId = info.id or 0
        CloudData.NPC_INFO[tonumber(npcId)] = info
      end
      self.mTimes = self.mTimes - 1
      CloudData.ENERGY = CloudData.ENERGY - self.mEneryCost
      GameManager.STAGE_ID = self.mStageNum + 20000
      GameManager.STAGE_NUM = (self.mStageNum - 1) % 4 + 1
      GameManager.MODE = 1
      display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE", "NORMAL"))
    end
    
    DYHttpMgr.getFightData(tFuncListener, {fightMode = 0})
  end
end

function M:sweepCallBack()
  local dungeonTimes = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.challengeTimes)
  if 0 < dungeonTimes and 0 < self.mTimes and 0 < CloudData.SWEEP then
    local function tFuncListener(info)
      if info.errorCode ~= 0 then
        local toast = WSToast.new(info.errorMsg, 2)
        
        self:addChild(toast, 20)
      else
        DYSoundMgr.playEffect(DY_SND.sfx_saodang)
        self.mRetTime = info.time or 0
        self:refreshSweepData(info.data)
        self.mExp = tonumber(info.data.expGain)
        local essence = tonumber(info.data.essenceGain)
        self.mEssenceInc = essence - self.mEssence
        DYAnalyze.item.get(4, "EXP", self.mExp, "ELITE_STAGE_SWEEP")
        DYAnalyze.item.get(2, "ESSENCE", essence, "ELITE_STAGE_SWEEP")
        self:showSweepResult(info.data)
        self.mExp = CloudData.USER_LEVEL * 6
        self.mExpLabel:setString(self.mExp)
      end
    end
    
    local params = {}
    params.stageId = self.mStageNum + 20000
    DYHttpMgr.sweepInElite(tFuncListener, params)
  elseif 0 >= CloudData.SWEEP then
    local tip = WSToast.new(DYLang.getString("S642", ""))
    self:addChild(tip, 20)
  elseif dungeonTimes <= 0 then
    local tip = WSToast.new(DYLang.getString("S639", ""), 1)
    self:addChild(tip, 20)
  elseif 0 >= self.mTimes then
    local tip = WSToast.new(DYLang.getString("S640", ""), 1)
    self:addChild(tip, 20)
  end
end

function M:refreshSweepData(info)
  self.mMeetBoss = checknumber(info.isMeetBoss)
  CloudData.SWEEP = tonumber(info.sweep)
  CloudData.ESSENCE = tonumber(info.essence)
  local userLevel, exp = DataUtils.getUserLevelAndExp(tonumber(info.exp))
  local originLevel = CloudData.USER_LEVEL
  CloudData.USER_LEVEL = userLevel
  CloudData.EXP = tonumber(info.exp)
  DYNotification.postNotification(DY_KEY.kUpdateUserExp)
  CloudData.ENERGY = tonumber(info.energy) or CloudData.ENERGY
  self.mShowLevel = 0
  if originLevel < CloudData.USER_LEVEL then
    self.mShowLevel = originLevel + 1
    self:showUpgradeAni()
    DYAnalyze.account.changeTag(DYLang.getString("S645", ""), originLevel, CloudData.USER_LEVEL)
  end
  CloudData.CHAPTER_INFO_TABLE.elite.challengeTimes = info.dungeonChallengeTimes
  CloudData.CHAPTER_INFO_TABLE.elite.stageInfo[tostring(self.mStageNum + 20000)] = info.stageChallengeTimes
  self.mTimes = tonumber(info.stageChallengeTimes)
  self.mTimesLabel:setString(self.mTimes)
  DYNotification.postNotification(DY_KEY.kUpdateEliteTimes)
  CloudData.GAME_ITEM_INFO["2006"] = CloudData.SWEEP
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

function M:showSweepResult(info)
  self.mSweepLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):pos(0, 10):addTo(self, 5)
  local tip = display.newSprite("common_ui/common_dialog.png", display.cx, display.cy):addTo(self.mSweepLayer)
  display.newSprite("stage/sweep_title.png"):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.87):addTo(tip)
  
  local function meetBossCB(param1, param2)
    if checkstring(param2) == "SCENE_AGGRESS" then
      local nextScene = LayerBossRelated.scene()
      display.replaceScene(nextScene, "fade", 0.2)
    end
  end
  
  local textLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S646", ""),
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
      LayerMeetBoss.new(meetBossCB):addTo(self, 20)
    end
  end)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(512, 191), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.52):addTo(tip)
  local awardStr = cc.ui.UILabel.new({
    text = DYLang.getString("S647", ""),
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
  if info.dropGain == nil then
    return
  end
  local sum = 1
  for id, num in pairs(info.dropGain) do
    if 0 < tonumber(id) then
      local icon = IconItem.new(tonumber(id), tonumber(num))
      icon:setPosition(frame:getContentSize().width * (0.245 * sum - 0.115), frame:getContentSize().height * 0.4)
      frame:addChild(icon)
      icon:showItemTip()
      DYAnalyze.item.get(id, "", num, "ELITE_STAGE_SWEEP")
      sum = sum + 1
      if 4 < sum then
        return
      end
    end
  end
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
      self.mSweepLayer:runAction(cc.RemoveSelf:create())
      self.mSweepLayer = nil
    else
      self:runAction(cc.RemoveSelf:create())
    end
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

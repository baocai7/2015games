local LayerLackEnergy = require("app.layers.LayerLackEnergy")
local LayerInvite = require("app.aggress.layers.LayerInvite")
local LayerGetAward = require("app.aggress.layers.LayerGetAward")
local S_ENERGY_COST = 3
local DYClass = "LayerBossDetail"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M.scene(cb, param)
  local scene = display.newScene()
  scene:addChild(M.new(cb))
  return scene
end

function M:ctor(cb, param)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = cb
  self.mParam = param
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mAggressId = ""
  self.mBossId = 0
  self.mBossQuality = 0
  self.mBossLv = 0
  self.mCurHp = 0
  self.mMaxHp = 1
  self.mFinderNick = ""
  self.mFinderUid = 0
  self.mTimeLeft = 0
  self.mBossState = 0
  self.mRankList = {}
  self.mEnergyCost = 0
  self.mStageId = 1
  self.mBossName = ""
  self.mFlagReward = false
  self.mBg = nil
  self.mBossInfoTip = nil
  self:initUI()
  self:requestData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("aggress/img_boss_pop_01.png", 0, 0):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, 838, 654):addTo(self.mBg)
  self.mCanBeClicked = true
end

function M:requestData()
  local info = {}
  info.bid = self.mParam.bid
  info.mid = self.mParam.mid
  info.curHp = self.mParam.curHP
  info.maxHp = self.mParam.totalHP
  info.finderNick = self.mParam.userNick
  info.finderUid = self.mParam.userUid
  info.time = 7200 - math.floor(DYUtils.currentSecond() - self.mParam.meetTime / 1000)
  info.level = self.mParam.level
  info.state = self.mParam.state
  info.energyCost = self.mParam.energyCost
  info.stageId = self.mParam.stageId
  info.rankList = {}
  for i = 1, #self.mParam.damageRank do
    local rankItem = {}
    rankItem.uid = self.mParam.damageRank[i].uid
    rankItem.nick = self.mParam.damageRank[i].nick
    rankItem.icon = self.mParam.damageRank[i].icon
    rankItem.hurt = self.mParam.damageRank[i].damage
    rankItem.attackCount = self.mParam.damageRank[i].times
    rankItem.rank = self.mParam.damageRank[i].rank
    rankItem.award = self.mParam.damageRank[i].award
    table.insert(info.rankList, rankItem)
    if rankItem.uid == checkstring(CloudData.UID) then
      self.mFlagReward = true
    end
  end
  
  local function tFuncSort(a, b)
    if checknumber(a.hurt) > checknumber(b.hurt) then
      local tRank = a.rank
      a.rank = b.rank
      b.rank = tRank
      return true
    end
    return false
  end
  
  table.sort(info.rankList, tFuncSort)
  self:initData(info)
end

function M:initData(info)
  if not info or type(info) ~= "table" then
    return
  end
  self.mAggressId = checkstring(info.bid)
  self.mBossId = checknumber(info.mid)
  self.mBossLv = checknumber(info.level)
  self.mCurHp = checknumber(info.curHp)
  local hp = checknumber(info.maxHp)
  self.mMaxHp = 0 < hp and hp or 1
  self.mFinderNick = checkstring(info.finderNick)
  self.mFinderUid = checknumber(info.finderUid)
  self.mTimeLeft = checknumber(info.time)
  self.mBossState = checkstring(info.state)
  self.mRankList = info.rankList or {}
  self.mEnergyCost = checknumber(info.energyCost)
  self.mStageId = checknumber(info.stageId)
  self:loadBossInfo()
  self:loadRankInfo()
end

local function getTime(t)
  local str = ""
  local time = checknumber(t)
  local hours = math.floor(time / 3600)
  time = time % 3600
  local minutes = math.floor(time / 60)
  return string.format("%02d:%02d", hours, minutes)
end

function M:loadBossInfo()
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_FINDER", "") .. self.mFinderNick,
    size = 26,
    color = cc.c3b(151, 105, 87),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 715, 587):addTo(self.mBg)
  local stateIcon = display.newSprite("aggress/img_boss_state.png"):pos(754, 520):addTo(self.mBg)
  local str = ""
  local fColor = cc.c3b(80, 30, 0)
  if self.mBossState == "FIGHT" then
    local canInvite = CloudData.UID == self.mFinderUid
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png",
      disabled = "common_ui/btn_disabled.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("BTN_INVITE_FRIEND", ""),
      size = 30,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = DYLang.getString("BTN_INVITE_FRIEND", ""),
      size = 27,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):setButtonLabel("disabled", DYLabelTTF.new({
      text = DYLang.getString("BTN_INVITE_FRIEND", ""),
      size = 30,
      color = cc.c3b(201, 201, 201),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(47, 47, 47)
    })):onButtonClicked(function()
      self:toInvite()
    end):align(display.CENTER, 290, 83):addTo(self.mBg)
    btn:performWithDelay(function()
      btn:setButtonEnabled(canInvite)
    end, 0)
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png",
      disabled = "common_ui/btn_disabled.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("BTN_FIGHT", ""),
      size = 30,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = DYLang.getString("BTN_FIGHT", ""),
      size = 27,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):onButtonClicked(function()
      self:tryFight()
    end):align(display.CENTER, 610, 83):setButtonEnabled(CloudData.ENERGY >= self.mEnergyCost):addTo(self.mBg)
    if 0 <= self.mEnergyCost then
      cc.ui.UILabel.new({
        text = DYLang.getString("STR_ENERGY_COST", "") .. " x " .. self.mEnergyCost,
        size = 24,
        color = cc.c3b(200, 0, 0),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER, 610, 130):addTo(self.mBg)
    end
    str = getTime(self.mTimeLeft)
    fColor = cc.c3b(200, 0, 0)
  elseif self.mBossState == "STRUGGLE" then
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_disabled.png",
      pressed = "common_ui/btn_pressed.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("S44", ""),
      size = 30,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = DYLang.getString("S44", ""),
      size = 27,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):onButtonClicked(function()
    end):align(display.CENTER, 451, 83):addTo(self.mBg)
    btn:setTouchEnabled(false)
    str = DYLang.getString("STR_STRUGGLE", "")
  elseif self.mBossState == "KILL" then
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png",
      disabled = "common_ui/btn_disabled.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("S44", ""),
      size = 30,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = DYLang.getString("S44", ""),
      size = 27,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):onButtonClicked(function()
      self:tryReward()
    end):align(display.CENTER, 451, 83):addTo(self.mBg):setButtonEnabled(self.mFlagReward)
    str = DYLang.getString("STR_WIN", "")
  elseif self.mBossState == "ESCAPE" then
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png",
      disabled = "common_ui/btn_disabled.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("STR_REMOVE", ""),
      size = 30,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = DYLang.getString("STR_REMOVE", ""),
      size = 27,
      color = cc.c3b(255, 246, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(110, 50, 0)
    })):onButtonClicked(function()
      self:toRemove()
    end):align(display.CENTER, 451, 83):addTo(self.mBg)
    str = DYLang.getString("STR_ESCAPE", "")
  end
  cc.ui.UILabel.new({
    text = str,
    size = 36,
    color = fColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, stateIcon:getContentSize().width * 0.5, stateIcon:getContentSize().height * 0.5):addTo(stateIcon)
  local bossInfo = DataUtils.getMonsterBaseInfo(self.mBossId)
  if not bossInfo or type(bossInfo) ~= "table" then
    return
  end
  local npcIcon = bossInfo.npcIcon
  self.mBossQuality = checknumber(bossInfo.quality)
  self.mBossName = checkstring(bossInfo.npcName)
  local img = string.format("common_ui/frame%d.png", self.mBossQuality)
  local iconFrame = cc.ui.UIPushButton.new({normal = img}):pos(141, 554):addTo(self.mBg):onButtonPressed(function(event)
    self:showBossInfo(bossInfo)
  end):onButtonRelease(function(event)
    if self.mBossInfoTip then
      self.mBossInfoTip:runAction(cc.RemoveSelf:create())
      self.mBossInfoTip = nil
    end
  end)
  local buddhaIcon = display.newSprite(npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 1 == bossInfo.isRebel then
    buddhaIcon:setScaleX(-1)
  end
  local lvLab = cc.ui.UILabel.new({
    text = "Lv." .. self.mBossLv,
    size = 30,
    color = cc.c3b(75, 27, 4),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 220, 585):addTo(self.mBg)
  cc.ui.UILabel.new({
    text = checkstring(bossInfo.npcName),
    size = 30,
    color = cc.c3b(56, 31, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 230 + lvLab:getContentSize().width, 585):addTo(self.mBg)
  local barBg = display.newSprite("aggress/img_bar_01.png"):align(display.CENTER, 422, 519):addTo(self.mBg)
  DYLabelTTF.new({
    text = self.mCurHp .. "/" .. self.mMaxHp,
    size = 30,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  local hpPro = cc.ProgressTimer:create(display.newSprite("aggress/img_bar_02.png")):addTo(barBg)
  hpPro:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  hpPro:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  hpPro:setMidpoint(cc.p(0, 0))
  hpPro:setBarChangeRate(cc.p(1, 0))
  hpPro:setPercentage(self.mCurHp / self.mMaxHp * 100)
end

function M:toInvite()
  local layer = LayerInvite.new({
    level = self.mBossLv,
    name = self.mBossName
  })
  layer:addTo(self)
end

function M:toRemove()
  if self.mProcessing then
    return
  end
  self.mProcessing = true
  
  local function tFuncListener(resp)
    self.mProcessing = false
    if resp.errorCode ~= 0 then
      WSToast.new(resp.errorMsg, 2):addTo(self, 20)
    else
      local nextScene = require("app.aggress.layers.LayerBossRelated").scene()
      display.replaceScene(nextScene)
    end
  end
  
  self:safeHttpRequest("aggressRemove", tFuncListener, {
    aggressId = self.mAggressId
  })
end

function M:tryFight()
  if CloudData.ENERGY < self.mEnergyCost then
    local tip = LayerLackEnergy.new()
    self:addChild(tip, 10)
    return
  end
  
  local function tFuncListener(resp)
    if resp.errorCode ~= 0 then
      local toast = WSToast.new(resp.errorMsg, 2):addTo(self, 20)
      return
    end
    CloudData.ENERGY = resp.data.energyLeft
    self:toFight(self.mCurHp)
  end
  
  self:safeHttpRequest("aggressFightReady", tFuncListener, {
    aggressId = self.mAggressId
  })
end

function M:toFight(leftHp)
  DDLOG("toFight")
  
  local function tFuncListener(jsonTable)
    local pData = jsonTable.data
    dump(pData)
    if not self.class or self.class.__cname ~= DYClass then
      return
    end
    CloudData.PVE_ATK_CIMELIA_DATA = pData.attackCimelia
    CloudData.PVE_DEF_CIMELIA_DATA = pData.defenceCimelia
    for k, info in pairs(pData.teamList) do
      local npcId = info.id or 0
      CloudData.NPC_INFO[tonumber(npcId)] = info
    end
    CloudData.AGGRESS_BOSS_LEFT_HP = leftHp
    CloudData.AGGRESS_BOSS_ID = self.mBossId
    CloudData.AGGRESS_ID = self.mAggressId
    GameManager.ENERGY_COST = self.mEnergyCost
    GameManager.STAGE_ID = self.mStageId
    GameManager.STAGE_NUM = self.mStageId
    GameManager.MODE = 10
    display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE", "AGGRESS"))
    DYAnalyze.event.onEvent("aggress", DYLang.getString("STR_AGGRESS", ""))
  end
  
  self:safeHttpRequest("getFightData", tFuncListener, {fightMode = 0})
end

function M:tryReward2()
  local data = {
    dropGain = {
      ["1"] = {
        ["1"] = 100,
        ["2"] = 500
      },
      ["2"] = {
        ["1"] = 100,
        ["2"] = 500
      },
      ["4"] = {
        ["1"] = 100,
        ["2"] = 500
      }
    }
  }
  self:toReward(data)
end

function M:tryReward()
  local function tFuncListener(resp)
    if not self.class or self.class.__cname ~= DYClass then
      return
    end
    if resp.errorCode ~= 0 then
      local toast = WSToast.new(resp.errorMsg, 2):addTo(self, 20)
      return
    end
    self:toReward(resp.data)
  end
  
  self:safeHttpRequest("aggressReward", tFuncListener, {
    aggressId = self.mAggressId
  })
end

function M:toReward(data)
  if data.drop then
    for id, num in pairs(data.drop) do
      DataUtils.updateItemNum(id, num)
    end
  end
  local rewardInfo = {}
  if data.dropGain then
    for id, gain in pairs(data.dropGain) do
      local item = {exp = 0, essence = 0}
      local kExp = "4"
      local kEss = "2"
      if gain[kExp] then
        item.exp = checknumber(gain[kExp]) or 0
        gain[kExp] = nil
      end
      if gain[kEss] then
        item.essence = checknumber(gain[kEss]) or 0
        gain[kEss] = nil
      end
      item.drop = gain
      rewardInfo[id] = item
    end
    local layer = LayerGetAward.new(function()
      local nextScene = require("app.aggress.layers.LayerBossRelated").scene()
      display.replaceScene(nextScene)
    end, rewardInfo)
    layer:addTo(self, 20)
  end
end

function M:showBossInfo(bossInfo)
  local bossInfo = DataUtils.getMonsterModel(self.mBossId)
  if not bossInfo or type(bossInfo) ~= "table" then
    return
  end
  local h = 198
  local skillId = bossInfo.npcSkill
  if skillId and "table" == type(skillId) and 0 < #skillId then
    h = h + #skillId * 60
  end
  self.mBossInfoTip = display.newScale9Sprite("common_ui/common_tip.png", 0, 0, cc.size(550, h), cc.rect(200, 100, 10, 10)):align(display.LEFT_TOP, 205, 600):addTo(self.mBg, 2)
  local img = string.format("common_ui/frame%d.png", self.mBossQuality)
  local iconFrame = display.newSprite(img):pos(88, h - 81):addTo(self.mBossInfoTip)
  local buddhaIcon = display.newSprite(bossInfo.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 1 == bossInfo.isRebel then
    buddhaIcon:setScaleX(-1)
  end
  local bossName = cc.ui.UILabel.new({
    text = bossInfo.npcName,
    size = 20,
    color = cc.c3b(255, 48, 48),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, iconFrame:getContentSize().width * 0.5, -21):addTo(iconFrame)
  local sword = checknumber(999999999)
  if 100000 < sword then
    sword = string.format("%d\228\184\135", math.floor(sword / 10000))
  end
  local info = {
    {
      key = DYLang.getString("S1330", ""),
      value = bossInfo.level,
      x = 135,
      y = 101
    },
    {
      key = DYLang.getString("S1331", ""),
      value = bossInfo.life,
      x = 315,
      y = 101
    },
    {
      key = DYLang.getString("S1332", ""),
      value = bossInfo.attack,
      x = 135,
      y = 71
    },
    {
      key = DYLang.getString("S1333", ""),
      value = bossInfo.magDefence,
      x = 315,
      y = 71
    },
    {
      key = DYLang.getString("S1334", ""),
      value = bossInfo.phyDefence,
      x = 135,
      y = 41
    },
    {
      key = DYLang.getString("S1335", ""),
      value = bossInfo.attackFrequency,
      x = 315,
      y = 41
    },
    {
      key = DYLang.getString("S1336", ""),
      value = bossInfo.attackDistance,
      x = 135,
      y = 11
    },
    {
      key = DYLang.getString("S1337", ""),
      value = bossInfo.runSpeed,
      x = 315,
      y = 11
    }
  }
  for i = 1, #info do
    local keyLabel = cc.ui.UILabel.new({
      text = info[i].key,
      size = 20,
      color = cc.c3b(255, 239, 153),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, info[i].x, info[i].y):addTo(iconFrame)
    cc.ui.UILabel.new({
      text = info[i].value,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, keyLabel:getPositionX() + keyLabel:getContentSize().width + 5, keyLabel:getPositionY()):addTo(iconFrame)
  end
  if h <= 198 then
    return
  end
  local skillLv = bossInfo.skillLv
  if not skillLv or "table" ~= type(skillLv) or #skillLv == 0 then
    return
  end
  for i = 1, #skillId do
    local skillFrame = display.newSprite("common_ui/frame6.png"):scale(0.45):pos(20, bossName:getPositionY() + 10 - 60 * i):addTo(iconFrame)
    local skillInfo = DataUtils.getMonsterSkillModel(skillId[i], checknumber(skillLv[i]))
    local skillIcon = checkstring(skillInfo.skillIcon)
    display.newSprite(skillIcon):pos(skillFrame:getContentSize().width * 0.5, skillFrame:getContentSize().height * 0.5):addTo(skillFrame)
    local desc = string.format(skillInfo.skillDesc, unpack(skillInfo.effectTable))
    local valueLabel = cc.ui.UILabel.new({
      text = desc,
      size = 19,
      align = cc.ui.TEXT_ALIGN_LEFT,
      dimensions = cc.size(425, 50),
      color = cc.c3b(255, 239, 153),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, iconFrame:getContentSize().width * 0.5, skillFrame:getPositionY()):addTo(iconFrame)
  end
end

local function newRankIcon(info, index, self)
  local frame = display.newScale9Sprite("common_ui/img_square.png", 0, 0, cc.size(780, 70), cc.rect(5, 5, 1, 1))
  if index % 2 == 0 then
    frame:setColor(cc.c3b(255, 242, 208))
  else
    frame:setColor(cc.c3b(255, 244, 224))
  end
  cc.ui.UILabel.new({
    text = checkstring(info.rank),
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 35, 35):addTo(frame)
  if info.icon then
    local img = GameManager.USER_ICON_PATH .. info.icon .. ".png"
    display.newSprite(img):scale(0.6):pos(116, 35):addTo(frame)
  end
  cc.ui.UILabel.new({
    text = checkstring(info.nick),
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 160, 35):addTo(frame)
  cc.ui.UILabel.new({
    text = checkstring(info.hurt),
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 370, 35):addTo(frame)
  cc.ui.UILabel.new({
    text = checkstring(info.attackCount),
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 535, 35):addTo(frame)
  if info.award then
    local awards = string.split(info.award, ";")
    local tIcons = {
      ["1"] = "aggress/img_mvp_02.png",
      ["2"] = "aggress/img_kill_02.png",
      ["3"] = "aggress/img_help_02.png",
      ["4"] = "aggress/img_discover_02.png"
    }
    local x = 584
    for i = 1, #awards do
      x = x + 54
      local icon = tIcons[checkstring(awards[i])]
      if icon then
        display.newSprite(icon):pos(x, 35):addTo(frame)
      end
    end
  end
  return frame
end

function M:loadRankInfo()
  local frame = display.newScale9Sprite("common_ui/img_square.png", 0, 0, cc.size(780, 40), cc.rect(5, 5, 1, 1)):pos(457, 450):addTo(self.mBg)
  frame:setColor(cc.c3b(219, 192, 162))
  local strArr = {
    "S812",
    "STR_NICK",
    "STR_HURT",
    "STR_ATTACK",
    "STR_AWARD"
  }
  local posXArr = {
    35,
    160,
    370,
    535,
    638
  }
  for i = 1, 5 do
    if i ~= 1 and i ~= 5 then
      cc.ui.UILabel.new({
        text = DYLang.getString(strArr[i], ""),
        size = 26,
        color = cc.c3b(151, 105, 87),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER_LEFT, posXArr[i], 20):addTo(frame)
    else
      cc.ui.UILabel.new({
        text = DYLang.getString(strArr[i], ""),
        size = 26,
        color = cc.c3b(151, 105, 87),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER, posXArr[i], 20):addTo(frame)
    end
  end
  if #self.mRankList == 0 then
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(67, 153, 780, 280),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  self.mListView = list
  for i = 1, #self.mRankList do
    local item = list:newItem()
    local content = newRankIcon(self.mRankList[i], i, self)
    item:addContent(content)
    item:setItemSize(780, 70)
    list:addItem(item)
  end
  list:reload()
end

function M:closeCallBack()
  if self.mProcessing then
    return
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
  if self.mCallback then
    self.mCallback()
  end
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

local WSToast = require("app.utils.WSToast")
local LayerRule = require("app.layers.LayerRule")
local LayerPVPLog = require("app.layers.LayerPVPLog")
local LayerPVPTeam = require("app.layers.LayerPVPTeam")
local LayerPVPMatchInfo = require("app.layers.LayerPVPMatchInfo")
local LayerRankList = require("app.layers.LayerRankList")
local IconPkBubble = require("app.icons.IconPkBubble")
local NoviceGuide = require("app.utils.NoviceGuide")
local CLASS_NAME = "ScenePVP"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene(CLASS_NAME)
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  if not audio.isMusicPlaying() then
    DYSoundMgr.playMusic(DY_SND.bgm_theme)
  end
  GameManager.MODE = 5
  self.mBg = nil
  self.mRankLabel = nil
  self.mTimeLabel = nil
  self.mRefreshTimeLabel = nil
  self.mRefreshBtn = nil
  self.mCELabel = nil
  self.mNewLogTag = nil
  self.mGridIcon = {}
  self.mMatchIconTable = {}
  self.mRank = 0
  self.mTime = 0
  self.mCE = 0
  self.mCommondTime = 0
  self.mScheduleRefresh = nil
  self.mMatchModelList = {}
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initUIFrame()
  self:initPkBubble()
  self:toGetData()
  self:dealUserGuide()
end

function M:initUIFrame()
  local bg = display.newSprite("common_ui/common_bg.png", display.cx, display.cy)
  self:addChild(bg)
  local frame = display.newSprite("pvp/frame.png", bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg)
  self.mBg = frame
  cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):align(display.CENTER, display.width * 0.05, display.height * 0.95):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self, 15)
  local ruleLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S1354", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  ruleLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):scale(0.7):align(display.CENTER, 633, 660):addTo(frame):setButtonLabel("normal", ruleLabel):onButtonClicked(function()
    self:showRule()
  end)
  local logLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S1356", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  logLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  local logBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):scale(0.7):align(display.CENTER, 738, 660):addTo(frame):setButtonLabel("normal", logLabel):onButtonClicked(function()
    self:showWarLog()
  end)
  self.mNewLogTag = display.newSprite("common_ui/red_point.png", 50, 20):addTo(logBtn)
  self.mNewLogTag:setVisible(false)
  local chartLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S1358", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  chartLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):scale(0.7):align(display.CENTER, 845, 660):addTo(frame):setButtonLabel("normal", chartLabel):onButtonClicked(function()
    LayerRankList.new(LayerRankList.RANK_PVP):addTo(self, 20)
  end)
  local shopIcon = cc.ui.UIPushButton.new({
    normal = "pvp/shop.png"
  }):align(display.CENTER, 945, 660):addTo(frame):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    require("app.layers.LayerShopNew").new(4):addTo(self, 20)
  end)
  display.newSprite("pvp/rank.png"):align(display.CENTER_LEFT, 73, 660):addTo(frame)
  self.mRankLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 21,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 236, 660):addTo(frame)
  self.mRankLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local levelLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "Lv." .. CloudData.USER_LEVEL,
    size = 21,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 446, 660):addTo(frame)
  levelLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local timeStr = display.newSprite("pvp/time_str.png"):align(display.CENTER, 810, 211):addTo(frame)
  self.mTimeLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 25,
    color = cc.c3b(4, 255, 70),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, timeStr:getContentSize().width + 10, timeStr:getContentSize().height * 0.45):addTo(timeStr)
  self.mTimeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local newLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S1361", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  newLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  local refreshDisableLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S1361", ""),
    size = 26,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  })
  refreshDisableLabel:enableOutline(cc.c4b(40, 40, 40, 255), 2)
  self.mRefreshBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.8):align(display.CENTER, 975, 211):addTo(frame):setButtonLabel("normal", newLabel):setButtonLabel("disabled", refreshDisableLabel):onButtonClicked(function()
    self:refreshMatchList()
  end)
  self.mRefreshBtn:setVisible(false)
  self.mRefreshTimeLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = "",
    font = "fonts/greenNum.fnt"
  }):scale(0.8):align(display.CENTER, 1046, 211):addTo(frame)
  local swordBg = display.newSprite("upgrade/ce_label.png"):align(display.CENTER_LEFT, 40, 217):addTo(frame)
  self.mCELabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, swordBg:getContentSize().width * 0.62, swordBg:getContentSize().height * 0.5):addTo(swordBg)
  self.mCELabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  display.newSprite("pvp/guard_str.png", 529, 208):addTo(frame)
  for i = 1, 6 do
    self.mGridIcon[i] = display.newSprite("team/grid_frame.png"):pos(151 * i - 58, 100):addTo(frame)
  end
  cc.ui.UIPushButton.new({
    normal = "pvp/update.png",
    pressed = "pvp/update1.png"
  }, {scale9 = true}):align(display.CENTER, 991, 100):addTo(frame):onButtonClicked(function()
    self:updateTeam()
  end)
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new()
  self:add(self.mPkBubble, 900)
end

function M:toGetData()
  CloudData.PVP_INFO = {}
  
  local function tFuncListener(pvpInfo)
    if pvpInfo.errorCode ~= 0 then
      local errMsg = pvpInfo.errorMsg or "UNKNOWN"
      local toast = WSToast.new(errMsg, 2)
      self:addChild(toast, 20)
    else
      CloudData.PVP_INFO = pvpInfo.data
      self.mCommondTime = tonumber(pvpInfo.time) or 0
      if self.initData then
        self:initData()
      end
    end
  end
  
  DYHttpMgr.initPVPInfo(tFuncListener)
end

function M:initData()
  self.mRank = tonumber(CloudData.PVP_INFO.selfRank) + 1
  self.mTime = tonumber(CloudData.PVP_INFO.leftFightCount)
  CloudData.PVP_RANK = self.mRank
  CloudData.PVP_RECORD = tonumber(CloudData.PVP_INFO.maxRanking) + 1
  self:getMatchData()
  self:showUIFrame()
end

function M:showUIFrame()
  if self.mRank > 10004 then
    self.mRankLabel:setString(DYLang.getString("S1365", ""))
  else
    self.mRankLabel:setString(self.mRank)
  end
  self.mTimeLabel:setString(self.mTime)
  self.mRefreshBtn:setVisible(true)
  self:showMatchTable()
  self:showTeam()
  self:markNewLog()
end

local function getSword(self, info)
  local sword = 0
  if not info or #info == 0 then
    return sword
  end
  for i = 1, #info do
    local single = 99
    sword = sword + single * info[i].num
  end
  return sword
end

function M:getMatchData()
  local infoList = CloudData.PVP_INFO.targetList or {}
  self.mMatchModelList = {}
  for i = 1, 4 do
    local info = infoList[tostring(i)]
    if not info then
      break
    end
    local userIcon = GameManager.USER_ICON_PATH .. info.icon .. ".png"
    CloudData.savePVPEnemyInfo(info)
    local infoTable = {
      uid = info.uid,
      icon = userIcon,
      level = info.level,
      nick = info.nick,
      ranking = info.ranking
    }
    local npcInfo = {}
    local buddhaList = info.defenseTeam or {}
    local sword = 0
    local no = 1
    for id, num in pairs(buddhaList) do
      local model = DataUtils.getPVPMonsterModel(id)
      npcInfo[no] = {}
      npcInfo[no].id = tonumber(id)
      npcInfo[no].num = tonumber(num)
      npcInfo[no].level = tonumber(model.level) or 0
      npcInfo[no].star = tonumber(model.starLevel) or 0
      npcInfo[no].cd = model.cdTime or 0
      npcInfo[no].quality = model.quality or 0
      npcInfo[no].icon = model.npcIcon
      npcInfo[no].isRebel = model.isRebel
      npcInfo[no].name = model.npcName
      npcInfo[no].tag1 = model.tag1
      npcInfo[no].tag2 = model.tag2
      npcInfo[no].tag3 = model.tag3
      no = no + 1
      sword = sword + tonumber(model.attackAssessment) * tonumber(num)
    end
    infoTable.buddhaInfo = npcInfo
    infoTable.sword = sword
    self.mMatchModelList[i] = infoTable
  end
end

function M:showMatchTable()
  for i = 1, #self.mMatchIconTable do
    self.mMatchIconTable[i]:removeSelf()
  end
  local infoList = CloudData.PVP_INFO.targetList or {}
  for i = 1, 4 do
    local info = infoList[tostring(i)]
    if not info then
      break
    end
    local x = {
      276,
      781,
      276,
      781
    }
    local y = {
      541,
      541,
      365,
      365
    }
    local frame = display.newScale9Sprite("common_ui/common_frame10.png", x[i], y[i], cc.size(437, 170), cc.rect(45, 45, 2, 2)):addTo(self.mBg)
    self.mMatchIconTable[i] = frame
    local icon = display.newSprite("common_ui/frame3.png", frame:getContentSize().width * 0.15, frame:getContentSize().height * 0.4):scale(0.85):addTo(frame)
    local userIcon = GameManager.USER_ICON_PATH .. info.icon .. ".png"
    display.newSprite(userIcon, icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):addTo(icon)
    cc.ui.UILabel.new({
      UILabelType = 2,
      text = info.nick,
      size = 23,
      color = cc.c3b(80, 49, 4),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.05, frame:getContentSize().height * 0.83):addTo(frame)
    local icon = display.newSprite("pvp/rank_str.png", frame:getContentSize().width * 0.355, frame:getContentSize().height * 0.54):scale(0.9):addTo(frame)
    local rank = tonumber(info.ranking) + 1
    if 10004 < rank then
      rank = DYLang.getString("S1365", "")
    end
    local rankLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = rank,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.45, frame:getContentSize().height * 0.645):addTo(frame)
    rankLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    local levelLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = info.level,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.45, frame:getContentSize().height * 0.43):addTo(frame)
    levelLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    local detailLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = DYLang.getString("S1367", ""),
      size = 26,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    })
    detailLabel:enableOutline(cc.c4b(147, 78, 1, 255), 2)
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }, {scale9 = true}):setButtonSize(135, 61):scale(0.9):align(display.CENTER, frame:getContentSize().width * 0.8, frame:getContentSize().height * 0.7):addTo(frame):setButtonLabel("normal", detailLabel):onButtonClicked(function()
      self:showMatchDetails(i)
    end)
    local fightLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = "    \230\140\145\230\136\152",
      size = 26,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    })
    fightLabel:enableOutline(cc.c4b(147, 78, 1, 255), 2)
    local fightBtn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }, {scale9 = true}):setButtonSize(135, 61):scale(0.9):align(display.CENTER, frame:getContentSize().width * 0.8, frame:getContentSize().height * 0.3):addTo(frame):setButtonLabel("normal", fightLabel):onButtonClicked(function()
      self:startFight(i)
    end)
    display.newSprite("pvp/fight_icon.png", -30, 0):addTo(fightBtn)
    local ceIcon = display.newSprite("pvp/sword.png", frame:getContentSize().width * 0.45, frame:getContentSize().height * 0.2):scale(0.8):addTo(frame)
    local num = self.mMatchModelList[i].sword
    if 100000 <= num then
      local count = math.floor(num / 10000)
      num = count .. DYLang.getString("S42", "")
    end
    local ceLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = num,
      size = 25,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, ceIcon:getContentSize().width * 0.65, ceIcon:getContentSize().height * 0.5):addTo(ceIcon)
    ceLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  end
end

function M:showMatchDetails(index)
  local info = self.mMatchModelList[index]
  local detail = LayerPVPMatchInfo.new(info)
  self:addChild(detail, 10)
end

function M:startFight(index)
  local info = self.mMatchModelList[index]
  if info == nil then
    DDERROR("Opponent info is null.")
    return
  end
  CloudData.savePVPEnemyInfo(CloudData.PVP_INFO.targetList[tostring(index)])
  GameManager.IS_REVENGE = 0
  GameManager.STAGE_NUM = 0
  local infoTable = {}
  local cdTable = {}
  for i = 1, #info.buddhaInfo do
    local buddhaId = info.buddhaInfo[i].id
    local buddhaNum = info.buddhaInfo[i].num
    infoTable[tostring(buddhaId)] = buddhaNum
    cdTable[i] = {
      id = buddhaId,
      num = buddhaNum,
      cd = info.buddhaInfo[i].cd,
      level = info.buddhaInfo[i].level,
      star = info.buddhaInfo[i].star
    }
  end
  local SP = DataUtils.getMaxSP(info.level)
  GameManager.PVP_ENEMY_INFO = {
    team = infoTable,
    nick = info.nick,
    spirit = SP,
    uid = info.uid,
    sword = info.sword,
    buddhaInfo = cdTable
  }
  local team = LayerPVPTeam.new(LayerPVPTeam.ATTACK)
  self:addChild(team, 20)
end

function M:showTeam()
  local info = CloudData.PVP_INFO.defenseTeam or {}
  if info == "" then
    info = {}
  end
  self.mCE = 0
  for i = 1, 6 do
    self.mGridIcon[i]:removeAllChildren()
  end
  local teamInfo = {}
  for k, v in pairs(info) do
    local team = {}
    team.buddhaId = tonumber(k)
    team.num = tonumber(v)
    team.model = DataUtils.getBuddhaModelPVP(tonumber(k))
    local tag = false
    for i = 1, #teamInfo do
      if team.model.cdTime < teamInfo[i].model.cdTime then
        table.insert(teamInfo, i, team)
        tag = true
        break
      end
    end
    if not tag then
      table.insert(teamInfo, team)
    end
  end
  for i = 1, #teamInfo do
    if 6 < i then
      break
    end
    local model = teamInfo[i].model
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", model.quality)):pos(self.mGridIcon[i]:getContentSize().width * 0.5, self.mGridIcon[i]:getContentSize().height * 0.53):addTo(self.mGridIcon[i])
    local icon = display.newSprite(model.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    if 0 == model.isRebel then
      icon:setScaleX(-1)
    end
    display.newSprite(string.format("upgrade/star%d.png", model.starLevel)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame)
    local numLabel = cc.ui.UILabel.new({
      text = teamInfo[i].num,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.BOTTOM_RIGHT, iconFrame:getContentSize().width * 0.9, iconFrame:getContentSize().height * 0.05):addTo(iconFrame, 1)
    numLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    self.mCE = self.mCE + model.attackAssessment * teamInfo[i].num
  end
  local num = self.mCE
  if 100000 <= num then
    local count = math.floor(num / 10000)
    num = count .. DYLang.getString("S42", "")
  end
  self.mCELabel:setString(num)
end

function M:showRule()
  local rule = LayerRule.new(LayerRule.PVP)
  self:addChild(rule, 5)
end

function M:showWarLog()
  local log = LayerPVPLog.new(self.mCommondTime)
  self:addChild(log, 10)
  self.mNewLogTag:setVisible(false)
  local logInfo = CloudData.PVP_INFO.fightLog or {}
  if logInfo[1] then
    local msgId = logInfo[1].fightTime or 0
    local regionId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format(DY_KEY.kPvpLogId, regionId, CloudData.UID)
    DYStat.setValueInt(str, msgId)
  end
end

function M:refreshMatchList()
  local function tFuncListener(matchInfo)
    if matchInfo.errorCode ~= 0 then
      local toast = WSToast.new(matchInfo.errorMsg, 2)
      
      self:addChild(toast, 20)
    else
      CloudData.PVP_INFO.targetList = matchInfo.data.targetList
      if not self.getMatchData or not self.showMatchTable then
        return
      end
      self:getMatchData()
      self:showMatchTable()
    end
  end
  
  DYHttpMgr.refreshPVPMatchTable(tFuncListener)
  self:startCountDown()
end

function M:startCountDown()
  self.mRefreshBtn:setButtonEnabled(false)
  self.mRefreshTimeLabel:setString("5")
  local time = 5
  self.mScheduleRefresh = self:schedule(function()
    time = time - 1
    self:updateTime(time)
  end, 1)
end

function M:updateTime(time)
  if 0 < time then
    self.mRefreshTimeLabel:setString(time)
  else
    self.mRefreshTimeLabel:setString("")
    self:stopAction(self.mScheduleRefresh)
    self.mRefreshBtn:setButtonEnabled(true)
  end
end

function M:updateTeam()
  local team = LayerPVPTeam.new(LayerPVPTeam.GUARD, handler(self, self.showTeam))
  self:addChild(team, 20)
end

function M:markNewLog()
  local regionId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kPvpLogId, regionId, CloudData.UID)
  local lastLogTime = DYStat.getValueInt(str, 0)
  local logInfo = CloudData.PVP_INFO.fightLog or {}
  for i = 1, #logInfo do
    local time = tonumber(logInfo[i].fightTime) or 0
    local attack = tonumber(logInfo[i].isAttacking)
    if lastLogTime < time and attack ~= 1 then
      self.mNewLogTag:setVisible(true)
      return
    elseif lastLogTime >= time then
      self.mNewLogTag:setVisible(false)
      return
    end
  end
  self.mNewLogTag:setVisible(false)
end

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  local userLevel = CloudData.USER_LEVEL
  local guide = userLevel ~= 11 or DataUtils.getGuideIsFirstPlayed("GUIDE_LEVEL11_PVPSCN") or NoviceGuide.new("GUIDE_LEVEL11_PVPSCN"):addTo(self, 50)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  GameManager.MODE = 0
  CloudData.PVP_INFO = {}
  local nextScene = require("scenes.ChapterScene").new(3)
  display.replaceScene(nextScene, "fade", 0.2)
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

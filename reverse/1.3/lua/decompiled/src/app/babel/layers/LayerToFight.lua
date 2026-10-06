local IconItem = require("app.icons.IconItem")
local LayerPVPTeam = require("app.layers.LayerPVPTeam")
local LayerTip = require("app.babel.layers.LayerTip")
local CLASS_NAME = "LayerToFight"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(info)
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  if not info then
    self:closeCallBack()
  end
  self.mInfo = info
  self.mId = 0
  self.mUid = 0
  self.mLevel = 1
  self.mIcon = ""
  self.mName = ""
  self.mPower = 0
  self.mCurProfit = 0
  self.mMaxProfit = 0
  self.mTeamInfo = {}
  self.mRewardInfo = {}
  self.mLeftCount = 0
  self.mTimeBuyCost = 0
  self.mMaxCount = 0
  self.mUnionName = ""
  self.cb = info.cb
  self:initData()
  self:initBg()
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mId = checknumber(self.mInfo.seatId)
  self.mUid = checknumber(self.mInfo.opponentUid)
  self.mLevel = checknumber(self.mInfo.level)
  self.mIcon = checknumber(self.mInfo.icon)
  self.mName = checkstring(self.mInfo.nick)
  self.mPower = checknumber(self.mInfo.power)
  self.mCurProfit = checknumber(self.mInfo.currentIncomeCount)
  self.mMaxProfit = checknumber(self.mInfo.totalIncomeCount)
  self.mTeamInfo = self.mInfo.pvpDefenseTeamInfo
  self.mRewardInfo = self.mInfo.awardGain
  self.mLeftCount = checknumber(CloudData.BabelInfo.plunderLeftTimes)
  self.mTimeBuyCost = checknumber(CloudData.BabelInfo.plunderBuyPeach)
  self.mMaxCount = checknumber(CloudData.BabelInfo.totalPlunderCount)
  self.mUnionName = checkstring(self.mInfo.clanName)
end

function M:initBg()
  local bg = display.newSprite("pvp_ol/bg_rankInfo.png"):pos(0, -20):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, bg:getContentSize().width + 5, bg:getContentSize().height):addTo(bg):onButtonClicked(function()
    self:closeCallBack()
  end)
  local titleBg = display.newSprite("common_ui/title_frame.png"):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height - 33):addTo(self.mBg)
  display.newSprite("babel/title.png"):align(display.CENTER, titleBg:getContentSize().width * 0.5, titleBg:getContentSize().height * 0.5):addTo(titleBg)
  self:addContent()
  self:addTeam()
  self:addReward()
  self:addButton()
end

function M:addContent()
  local icon = display.newSprite("common_ui/frame4.png", 153, 525):addTo(self.mBg)
  if self.mIcon ~= "" then
    display.newSprite(GameManager.USER_ICON_PATH .. self.mIcon .. ".png"):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):addTo(icon)
  end
  DYLabelTTF.new({
    text = "LV." .. self.mLevel,
    size = 25,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_RIGHT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.BOTTOM_RIGHT, icon:getContentSize().width * 0.89, icon:getContentSize().height * 0.18):addTo(icon, 1)
  local nickLab = DYLabelTTF.new({
    text = self.mName,
    size = 25,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 228, 558):addTo(self.mBg)
  local swordBg = display.newSprite("pvp/sword.png"):align(display.CENTER_LEFT, 228, 506):addTo(self.mBg)
  local str = self.mPower
  if self.mPower > 100000 then
    str = string.format("%d\228\184\135", math.floor(self.mPower / 10000))
  end
  DYLabelTTF.new({
    text = str,
    size = 25,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, 120, 28):addTo(swordBg)
  local profitStr = display.newSprite("babel/profit_left.png"):align(display.CENTER, 795, 548):addTo(self.mBg)
  local progressFrame = display.newSprite("user_center/bar_bg.png", 795, 510):addTo(self.mBg)
  local progressBar = display.newProgressTimer("user_center/bar_pro.png", display.PROGRESS_TIMER_BAR):pos(progressFrame:getContentSize().width * 0.5, progressFrame:getContentSize().height * 0.5):addTo(progressFrame)
  progressBar:setMidpoint(cc.p(0, 0))
  progressBar:setBarChangeRate(cc.p(1, 0))
  local rate = 0
  if 0 < self.mMaxProfit then
    rate = self.mCurProfit / self.mMaxProfit * 100
  end
  progressBar:setPercentage(rate)
  DYLabelTTF.new({
    text = self.mCurProfit .. "/" .. self.mMaxProfit,
    size = 24,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, progressFrame:getContentSize().width * 0.5, progressFrame:getContentSize().height * 0.5):addTo(progressFrame, 1)
  if checkstring(self.mUnionName) ~= "" then
    DYLabelTTF.new({
      text = "\227\128\144" .. self.mUnionName .. "\227\128\145",
      size = 25,
      color = cc.c3b(24, 120, 240),
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 230 + nickLab:getContentSize().width, 558):addTo(self.mBg)
  end
end

function M:addTeam()
  display.newSprite("babel/adorn.png"):align(display.CENTER_RIGHT, 174, 357):addTo(self.mBg)
  local adorn = display.newSprite("babel/adorn.png"):align(display.CENTER_RIGHT, 890, 357):addTo(self.mBg)
  adorn:setScaleX(-1)
  if not self.mTeamInfo or #self.mTeamInfo == 0 then
    return
  end
  for i = 1, #self.mTeamInfo do
    local model = DataUtils.getBuddhaFeatureInfo(self.mTeamInfo[i].buddhaId, self.mTeamInfo[i].level)
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", model.quality)):scale(0.82):pos(135 + 114 * i, 393):addTo(self.mBg)
    local icon = display.newSprite(model.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    if 0 == model.isRebel then
      icon:setScaleX(-1)
    end
    display.newSprite(string.format("upgrade/star%d.png", self.mTeamInfo[i].star)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame, 1)
    local levelFrame = display.newSprite("team/frame.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.15):addTo(iconFrame)
    cc.ui.UILabel.new({
      text = string.format("LV.%d", self.mTeamInfo[i].level),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, levelFrame:getContentSize().width * 0.5, levelFrame:getContentSize().height * 0.5):addTo(levelFrame)
    local numBg = display.newSprite("pvp/num_bg.png"):align(display.CENTER, iconFrame:getContentSize().width * 0.5, -25):addTo(iconFrame)
    local numLevel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = self.mTeamInfo[i].num,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, numBg:getContentSize().width * 0.5, numBg:getContentSize().height * 0.5):addTo(numBg)
    numLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  end
end

function M:addReward()
  display.newSprite("babel/profit_win.png"):align(display.CENTER_LEFT, 79, 260):addTo(self.mBg)
  if not self.mRewardInfo then
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(74, 143, 712, 100),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(self.mBg)
  for k, v in pairs(self.mRewardInfo) do
    local item = list:newItem()
    local content = IconItem.new(k, v)
    content:showItemTip()
    content:setScale(0.75)
    item:addContent(content)
    item:setItemSize(113, 100)
    list:addItem(item)
  end
  list:reload()
end

function M:addButton()
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):align(display.CENTER, 890, 184):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S162", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(147, 78, 1)
  })):onButtonClicked(function()
    self:clickFightBtn()
  end)
  DYLabelTTF.new({
    text = DYLang.getString("S163", ""),
    size = 22,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_RIGHT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.BOTTOM_RIGHT, 943, 125):addTo(self.mBg)
  DYLabelTTF.new({
    text = self.mLeftCount .. "/" .. self.mMaxCount,
    size = 22,
    color = cc.c3b(0, 255, 54),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 946, 125):addTo(self.mBg)
end

function M:clickFightBtn()
  local time = checknumber(CloudData.BabelInfo.safeLeftTime)
  if 0 < time then
    local str = DYLang.getString("S164", "")
    LayerTip.new(str, handler(self, self.showTeam)):addTo(self, 20)
  else
    self:showTeam()
  end
end

function M:showTeam()
  local team = LayerPVPTeam.new(LayerPVPTeam.ATTACK, handler(self, self.teamCallBack))
  self:addChild(team, 20)
end

function M:teamCallBack(tag, teamInfo)
  if tag == "FIGHT" then
    if self.mLeftCount <= 0 then
      local str
      if self.mTimeBuyCost == -1 then
        str = DYLang.getString("S165", "")
        LayerTip.new(str):addTo(self, 20)
      else
        str = DYLang.getString("S166", "") .. self.mTimeBuyCost .. DYLang.getString("S167", "")
        LayerTip.new(str, handler(self, self.checkPlayer), teamInfo):addTo(self, 20)
      end
      return
    else
      self:checkPlayer(teamInfo)
    end
  elseif tag == "LACKTIME" then
    WSToast.new(DYLang.getString("S168", "")):addTo(self, 20)
  end
end

function M:checkPlayer(teamInfo)
  local teamStr = json.encode(teamInfo)
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode ~= 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      local toast = WSToast.new(errMsg, 2)
      self:addChild(toast, 20)
    else
      local info = jsonTable.data.rankingData
      local peach = checknumber(jsonTable.data.peachLeft)
      DataUtils.updateItemNum(1, peach)
      self:toFight(info)
    end
  end
  
  local params = {}
  params.seatId = self.mId
  params.attackTeam = teamStr
  params.opponentUid = self.mUid
  DYHttpMgr.babelToFight(tFuncListener, params)
end

function M:toFight(info)
  if not info then
    local t = WSToast.new(DYLang.getString("S169", ""), 1)
    self:addChild(t, 100)
    return
  end
  CloudData.savePVPEnemyInfo(info)
  local buddhaList = json.decode(info.defenseTeam) or {}
  local sword = 0
  local no = 1
  local cdTable = {}
  for id, num in pairs(buddhaList) do
    local model = DataUtils.getPVPMonsterModel(id)
    cdTable[no] = {}
    cdTable[no].id = tonumber(id)
    cdTable[no].num = tonumber(num)
    cdTable[no].cd = tonumber(model.cdTime) or 0
    cdTable[no].level = tonumber(model.level) or 1
    cdTable[no].star = tonumber(model.starLevel) or 0
    no = no + 1
    sword = sword + tonumber(model.attackAssessment) * tonumber(num)
  end
  local SP = DataUtils.getMaxSP(info.level)
  GameManager.PVP_ENEMY_INFO = {
    team = json.decode(info.defenseTeam),
    nick = info.nick,
    spirit = SP,
    uid = info.uid,
    sword = sword,
    buddhaInfo = cdTable
  }
  GameManager.BABEL_ENEMY_INFO = self.mInfo
  GameManager.STAGE_ID = self.mId
  GameManager.STAGE_NUM = 1
  GameManager.MODE = 5
  GameManager.IS_BABEL_GRAB = 1
  display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE"))
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.cb then
    self.cb(self.mInfo.index, self.mCurProfit)
  end
  self:runAction(cc.RemoveSelf:create())
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

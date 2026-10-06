local LayerRewardShow = require("app.babel.layers.LayerRewardShow")
local LayerToFight = require("app.babel.layers.LayerToFight")
local LayerFightWin = require("app.babel.layers.LayerFightWin")
local LayerAvoidWar = require("app.babel.layers.LayerAvoidWar")
local LayerChallengeBabel = require("app.babel.layers.LayerChallengeBabel")
local LayerRank = require("app.babel.layers.LayerRank")
local LayerLog = require("app.babel.layers.LayerLog")
local LayerPVPTeam = require("app.layers.LayerPVPTeam")
local LayerRule = require("app.layers.LayerRule")
local LayerSeatInfo = require("app.babel.layers.LayerSeatInfo")
local NoviceGuide = require("app.utils.NoviceGuide")
local M = {}
M = class("SceneBabel", function()
  return display.newScene("SceneBabel")
end)
M.BG = 0
M.CloudBack = 1
M.Tower = 2
M.CloudMid = 3
M.CloudFront = 4
M.Floor = 5
M.Btns = 6
M.Layers = 20
M.MAX_FLOOR = 9

function M:ctor(needAni)
  GameManager.MODE = 7
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  if not audio.isMusicPlaying() then
    DYSoundMgr.playMusic(DY_SND.bgm_theme)
  end
  self.mNeedAni = checknumber(needAni)
  self.mPeaceTime = 0
  self.mFloor = 0
  self.mSeatFloor = 0
  self.mSeatFloorName = 0
  self.mSelectFloor = 0
  self.mEmptySeat = 0
  self.mMaxSeat = 0
  self.mLeftTimes = 0
  self.mSeatList = {}
  self.mLogNew = 0
  self.mRewardNew = 0
  self.mSeatNumLab = nil
  self.mTowerIcon = {}
  self.mPeaceTimeLab = nil
  self.mFloorIcon = nil
  self.mCushionIcon = {}
  self.mPeaceBtn = nil
  self.mPeaceIcon = nil
  self.mRewardBtn = nil
  self.mGuardBtn = nil
  self.mLogBtn = nil
  self.mFileInfo = {}
  DYRes.loadFileInfo("animation/suo2/suo2.csb", self.mFileInfo)
  self:initBg()
  self:requestData()
  self.mKeypadListener = handler(self, self.onKeypad)
end

function M:initBg()
  self.mBg = display.newScale9Sprite("babel/bg_color.jpg", display.cx, display.cy, cc.size(1280, 720), cc.rect(4, 720, 2, 2)):addTo(self)
  display.newSprite("babel/montain.png"):align(display.CENTER_BOTTOM, display.width * 0.5, 0):addTo(self.mBg, M.BG)
  display.newSprite("babel/cloud_bg.png"):align(display.CENTER_BOTTOM, display.width * 0.5, 0):addTo(self.mBg, M.CloudFront)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_back.png"
  }):align(display.CENTER, display.width * 0.93, display.height * 0.92):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:returnCallBack()
  end):addTo(self, M.Btns)
  self:addCloudAni()
end

function M:addCloudAni()
  local pos = {
    [1] = 400,
    [2] = 155,
    [3] = 550,
    [4] = 380,
    [5] = 655
  }
  local time = {
    [1] = 12,
    [2] = 17,
    [3] = 14,
    [4] = 15,
    [5] = 10
  }
  for i = 1, 2 do
    local cloud = display.newSprite("babel/cloud_back" .. i .. ".png"):align(display.CENTER_LEFT, display.width, pos[i]):addTo(self.mBg, M.CloudBack)
    local wid = cloud:getContentSize().width
    local seq = transition.sequence({
      cc.MoveTo:create(time[i], cc.p(-wid, pos[i])),
      cc.MoveTo:create(0, cc.p(display.width, pos[i])),
      cc.DelayTime:create(i - 0.5)
    })
    cloud:runAction(cc.RepeatForever:create(seq))
  end
  for i = 3, 5 do
    local cloud = display.newSprite("babel/cloud_front" .. i - 2 .. ".png"):align(display.CENTER_LEFT, display.width, pos[i]):addTo(self.mBg, M.CloudMid)
    local wid = cloud:getContentSize().width
    local seq = transition.sequence({
      cc.MoveTo:create(time[i], cc.p(-wid, pos[i])),
      cc.MoveTo:create(0, cc.p(display.width, pos[i])),
      cc.DelayTime:create(i * 0.5)
    })
    cloud:runAction(cc.RepeatForever:create(seq))
  end
end

function M:requestData()
  local function tFuncListener(info)
    if info.errorCode > 0 then
      local errMsg = info.errorMsg or "UNKONWN"
      
      WSToast.new(errMsg):addTo(self, 20)
    else
      CloudData.BabelInfo = info.data
      if self.initData then
        self:initData()
      else
        if self.returnCallBack then
          self:returnCallBack()
        end
        return
      end
      self:addContent()
      if not DataUtils.getGuideIsFirstPlayed("GUIDE_BABEL_STAR") then
        self.mIsCanBGMoved = false
        local guideLayer = NoviceGuide.new("GUIDE_BABEL_STAR"):addTo(self, 50)
      end
    end
  end
  
  DYHttpMgr.babelInit(tFuncListener)
end

function M:initData()
  local info = CloudData.BabelInfo
  self.mPeaceTime = checknumber(info.safeLeftTime)
  self.mFloor = checknumber(info.reachStage)
  self.mSeatFloor = checknumber(info.currentStage)
  self.mSeatFloorName = checkstring(info.seatName)
  self.mSelectFloor = self.mSeatFloor > 0 and self.mSeatFloor or self.mFloor
  self.mEmptySeat = checknumber(info.idleSeatCount)
  self.mMaxSeat = checknumber(info.totalSeatCount)
  self.mLeftTimes = checknumber(info.plunderLeftTimes)
  self.mSeatList = info.seatList or {}
  CloudData.PVP_INFO = {
    attackTeam = info.pvpAttackTeam,
    defenseTeam = info.pvpDefenseTeam,
    leftFightCount = self.mLeftTimes
  }
  self.mRewardNew = checknumber(info.isOwnAward)
  local regionId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kBabelLogId, regionId, CloudData.UID)
  local lastLogId = DYStat.getValueInt(str, 0)
  local logInfo = info.fightLog or {}
  for i = 1, #logInfo do
    local id = checknumber(logInfo[i].id)
    local attack = checknumber(logInfo[i].selfUid) == CloudData.UID and 1 or 0
    if lastLogId < id and attack ~= 1 then
      self.mLogNew = 1
      break
    elseif lastLogId >= id then
      self.mLogNew = 0
      break
    end
  end
end

function M:addContent()
  local fight = display.newSprite("babel/left_fight.png"):align(display.CENTER_RIGHT, 823, 90):addTo(self.mBg, M.Btns)
  DYLabelTTF.new({
    text = self.mLeftTimes .. DYLang.getString("S84", ""),
    size = 30,
    color = cc.c3b(0, 255, 6),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 835, 90):addTo(self.mBg, M.Btns)
  self:addTower()
  self:addFloor()
  self:addButtons()
end

function M:newTowerIcon(index)
  local img = "tower_mid"
  if index > M.MAX_FLOOR then
    return
  elseif index == M.MAX_FLOOR then
    img = "tower_top"
  elseif index == 1 then
    img = "tower_bottom"
  end
  local icon = display.newNode()
  if index == 1 then
    icon:setContentSize(445, 260)
  elseif index == M.MAX_FLOOR then
    icon:setContentSize(375, 276)
  else
    icon:setContentSize(375, 170)
  end
  local towerIcon
  local canClick = false
  if index > self.mFloor + 1 then
    towerIcon = cc.ui.UIPushButton.new({
      normal = "babel/" .. img .. "1.png"
    })
    canClick = false
    display.newSprite("babel/lock1.png"):scale(0.75):align(display.CENTER, icon:getContentSize().width * 0.5, 50):addTo(icon, 1)
  elseif index <= self.mFloor then
    towerIcon = cc.ui.UIPushButton.new({
      normal = "babel/" .. img .. ".png",
      pressed = "babel/" .. img .. "_pressed.png"
    })
    canClick = true
    if index == self.mFloor and self.mNeedAni == 1 then
      local armature = ccs.Armature:create("suo2")
      icon:addChild(armature, 1)
      armature:getAnimation():playWithIndex(0)
      if self.mFloor == 1 then
        armature:setPosition(icon:getContentSize().width * 0.5, 70)
      else
        armature:setPosition(icon:getContentSize().width * 0.5, -20)
      end
      icon.armature = armature
    end
  elseif self.mNeedAni == 1 then
    towerIcon = cc.ui.UIPushButton.new({
      normal = "babel/" .. img .. "1.png",
      pressed = "babel/" .. img .. "1.png"
    })
    canClick = true
    local lock = display.newSprite("babel/lock1.png"):scale(0.75):align(display.CENTER, icon:getContentSize().width * 0.5, 50):addTo(icon, 1)
    icon.lock = lock
  else
    towerIcon = cc.ui.UIPushButton.new({
      normal = "babel/" .. img .. ".png",
      pressed = "babel/" .. img .. "_pressed.png"
    })
    canClick = true
    local lock = display.newSprite("babel/lock.png"):align(display.CENTER, icon:getContentSize().width * 0.5, 50):addTo(icon, 1)
    if index == 1 then
      lock:setPositionY(140)
    end
  end
  towerIcon:setPosition(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5)
  towerIcon:setTouchSwallowEnabled(false)
  icon:addChild(towerIcon)
  icon.towerIcon = towerIcon
  local pos = {x = 0, y = 0}
  icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      pos.x = x
      pos.y = y
      return true
    elseif name == "ended" and math.abs(x - pos.x) < 40 and math.abs(y - pos.y) < 40 then
      self:clickTower(index)
    end
  end)
  icon:setTouchEnabled(true)
  icon:setTouchSwallowEnabled(false)
  local title = display.newSprite("babel/floor" .. index .. ".png"):align(display.CENTER, icon:getContentSize().width * 0.5, icon:getContentSize().height - 30):addTo(icon, 1)
  if index == M.MAX_FLOOR then
    title:setPositionY(icon:getContentSize().height - 135)
  end
  local tagIcon = display.newSprite("babel/tag.png"):align(display.CENTER, 50, 36):addTo(icon, 1)
  if index == 1 then
    tagIcon:setPosition(60, 125)
  end
  tagIcon:runAction(cc.RepeatForever:create(transition.sequence({
    cc.MoveBy:create(0.5, cc.p(-25, 0)),
    cc.MoveBy:create(0.5, cc.p(25, 0))
  })))
  tagIcon:setVisible(false)
  icon.tagIcon = tagIcon
  if index == self.mSeatFloor then
    tagIcon:setVisible(true)
  end
  return icon
end

function M:addTower()
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(100, 20, 450, 700),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, M.Tower)
  for i = M.MAX_FLOOR, 1, -1 do
    local content = self:newTowerIcon(i)
    if content then
      local item = list:newItem()
      item:addContent(content)
      item:setItemSize(400, content:getContentSize().height - 2)
      list:addItem(item)
      self.mTowerIcon[i] = content
    end
  end
  list:reload()
  if self.mSelectFloor < 8 and 2 < self.mSelectFloor then
    local y = 170 * (8 - self.mSelectFloor) + 10
    list:moveItems(1, M.MAX_FLOOR, 0, y, false)
  elseif self.mSelectFloor < 3 then
    local y = 1020
    list:moveItems(1, M.MAX_FLOOR, 0, y, false)
  end
  if self.mNeedAni == 1 and self.mTowerIcon[self.mFloor].armature then
    local lock = self.mTowerIcon[self.mFloor].armature
    lock:getAnimation():playWithIndex(1)
    
    local function animationEvent(armatureBack, movementType, movementID)
      if movementType == ccs.MovementEventType.complete and self.mTowerIcon[self.mFloor + 1] then
        local icon = self.mTowerIcon[self.mFloor + 1]
        if self.mFloor + 1 == 9 and icon.towerIcon then
          icon.towerIcon:setButtonImage("normal", "babel/tower_top.png")
          icon.towerIcon:setButtonImage("pressed", "babel/tower_top_pressed.png")
        elseif icon.towerIcon then
          icon.towerIcon:setButtonImage("normal", "babel/tower_mid.png")
          icon.towerIcon:setButtonImage("pressed", "babel/tower_mid_pressed.png")
        end
        if icon.lock then
          icon.lock:setTexture("babel/lock.png")
          icon.lock:setScale(1)
        end
      end
    end
    
    lock:getAnimation():setMovementEventCallFunc(animationEvent)
  end
end

function M:newCushion(index)
  local info = self.mSeatList[index]
  if not info then
    return
  end
  local cushion = cc.ui.UIPushButton.new({
    normal = "babel/cushion.png"
  }):onButtonClicked(function()
    self:clickCushion(index)
  end)
  if self.mSelectFloor > 4 then
    local seatNameBg = display.newSprite("babel/seat_name.png"):align(display.CENTER, -84, 75):addTo(cushion, 1)
    DYLabelTTF.new({
      text = info.name,
      size = 22,
      color = cc.c3b(255, 201, 57),
      align = cc.ui.TEXT_ALIGN_CENTER,
      dimensions = cc.size(25, 50),
      dyalign = "CENTER",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER, seatNameBg:getContentSize().width * 0.5, seatNameBg:getContentSize().height * 0.5):addTo(seatNameBg)
  end
  if info.uid == 0 then
    return cushion
  end
  local nameBg = display.newSprite("babel/name_bg.png"):align(display.CENTER, 0, -10):addTo(cushion, 1)
  cc.ui.UILabel.new({
    text = info.nick,
    size = 20,
    color = cc.c3b(255, 201, 57),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, nameBg:getContentSize().width * 0.5, nameBg:getContentSize().height * 0.5):addTo(nameBg)
  local progressFrame = display.newSprite("babel/pro_bg.png", 0, -46):addTo(cushion)
  local progressBar = display.newProgressTimer("babel/pro_bar.png", display.PROGRESS_TIMER_BAR):pos(progressFrame:getContentSize().width * 0.5, progressFrame:getContentSize().height * 0.5):addTo(progressFrame)
  progressBar:setMidpoint(cc.p(0, 0))
  progressBar:setBarChangeRate(cc.p(1, 0))
  local rate = 0
  if 0 < info.totalIncome then
    rate = info.currentIncome / info.totalIncome * 100
  end
  progressBar:setPercentage(rate)
  local proLab = DYLabelTTF.new({
    text = info.currentIncome .. "/" .. info.totalIncome,
    size = 22,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, progressFrame:getContentSize().width * 0.5, progressFrame:getContentSize().height * 0.5):addTo(progressFrame, 1)
  cushion.progressBar = progressBar
  cushion.proLab = proLab
  display.newSprite("babel/tang.png"):scale(0.82):align(display.CENTER, 0, 80):addTo(cushion)
  return cushion
end

function M:addFloor()
  if not self.mSeatList or #self.mSeatList == 0 then
    return
  end
  if self.mFloorIcon then
    self.mFloorIcon:runAction(cc.RemoveSelf:create())
    self.mFloorIcon = nil
  end
  local floor = display.newSprite("babel/floor.png"):align(display.CENTER, 876, 373):addTo(self.mBg, M.Floor)
  self.mFloorIcon = floor
  for i = 1, #self.mSeatList do
    local cushion = self:newCushion(i)
    if cushion then
      local x = 365 - i % 2 * 230
      if #self.mSeatList < 3 then
        cushion:setPosition(x, 200)
      else
        cushion:setPosition(x, 575 - math.ceil(i / 2) * 235)
      end
      floor:addChild(cushion)
      self.mCushionIcon[i] = cushion
    end
  end
  local platform = display.newSprite("babel/left_platform.png"):align(display.CENTER_LEFT, 120, 24):addTo(floor)
  local str = self.mEmptySeat .. "/" .. self.mMaxSeat
  if 0 >= self.mMaxSeat then
    str = DYLang.getString("S85", "")
  end
  self.mSeatNumLab = DYLabelTTF.new({
    text = str,
    size = 28,
    color = cc.c3b(0, 255, 6),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, platform:getContentSize().width + 15, 16):addTo(platform)
  if 0 < self.mSelectFloor then
    platform:setPositionX(250)
    DYLabelTTF.new({
      text = DYLang.getString("S86", ""),
      size = 25,
      color = cc.c3b(255, 255, 255),
      dyalign = "CENTER_RIGHT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_RIGHT, 117, 24):addTo(floor)
    display.newSprite("babel/floor" .. self.mSelectFloor .. ".png"):align(display.CENTER_LEFT, 120, 24):addTo(floor)
  end
end

function M:addButtons()
  local strTable = {
    [1] = DYLang.getString("S87", ""),
    [2] = DYLang.getString("S88", ""),
    [3] = DYLang.getString("S89", "")
  }
  local funcTable = {
    [1] = "RANK",
    [2] = "REWARD",
    [3] = "GUARD"
  }
  local btnList = {}
  for i = 1, 3 do
    local fontSize = 30
    if i == 1 then
      fontSize = 28
    end
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }):scale(0.8):align(display.CENTER, 165 * i + 10, 47):addTo(self.mBg, M.Btns):setButtonLabel("normal", DYLabelTTF.new({
      text = strTable[i],
      size = fontSize,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(147, 78, 1)
    })):onButtonClicked(function()
      self:clickBtn(funcTable[i])
    end)
    btnList[i] = btn
    if i == 2 then
      btn.newMark = display.newSprite("common_ui/red_point.png", 65, 20):addTo(btn)
      if self.mRewardNew ~= 0 then
        btn.newMark:setVisible(true)
      else
        btn.newMark:setVisible(false)
      end
    end
  end
  self.mRewardBtn = btnList[2]
  self.mGuardBtn = btnList[3]
  if self.mSeatFloor == 0 then
    self.mRewardBtn:setVisible(false)
    self.mGuardBtn:setVisible(false)
  end
  if self.mSeatList and 0 < #self.mSeatList then
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }):align(display.CENTER, 1025, 76):addTo(self.mBg, M.Btns):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("S90", ""),
      size = 32,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(147, 78, 1)
    })):onButtonClicked(function()
      self:clickBtn("REFRESH")
    end)
  end
  if 0 < self.mPeaceTime then
    local avoidWarStr = display.newSprite("babel/war_avoid.png", 845, 680):addTo(self.mBg, M.Btns)
    self.mPeaceIcon = avoidWarStr
    for i = 1, 3 do
      local point = display.newSprite("babel/point.png", 111 + i * 25, 20):addTo(avoidWarStr)
      local seq = transition.sequence({
        cc.DelayTime:create((i - 1) * 0.2),
        cc.MoveBy:create(0.1, cc.p(0, 10)),
        cc.MoveBy:create(0.1, cc.p(0, -10)),
        cc.DelayTime:create(0.6 - i * 0.2)
      })
      point:runAction(cc.RepeatForever:create(seq))
    end
    local timeBg = display.newSprite("babel/name_bg.png"):align(display.CENTER, 72, -20):addTo(avoidWarStr)
    self.mPeaceTimeLab = DYLabelTTF.new({
      text = "",
      size = 25,
      color = cc.c3b(0, 255, 6),
      dyalign = "CENTER",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER, timeBg:getContentSize().width * 0.5, timeBg:getContentSize().height * 0.5):addTo(timeBg)
    self:startCountDown()
    if self.mSeatFloor == 0 then
      self.mPeaceIcon:setVisible(false)
    end
  else
    self.mPeaceBtn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }):scale(0.8):align(display.CENTER, 887, 676):addTo(self.mBg, M.Btns):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("S91", ""),
      size = 32,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(147, 78, 1)
    })):onButtonClicked(function()
      self:clickBtn("PEACE")
    end)
    if self.mSeatFloor == 0 then
      self.mPeaceBtn:setVisible(false)
    end
  end
  self.mLogBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.8):align(display.CENTER, 626, 676):addTo(self.mBg, M.Btns):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S92", ""),
    size = 32,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(147, 78, 1)
  })):onButtonClicked(function()
    self:clickBtn("LOG")
  end)
  self.mLogBtn.newMark = display.newSprite("common_ui/red_point.png", 65, 20):addTo(self.mLogBtn)
  if self.mLogNew == 1 then
    self.mLogBtn.newMark:setVisible(true)
  else
    self.mLogBtn.newMark:setVisible(false)
  end
  LayerRule.newRuleIcon(LayerRule.BABEL):pos(180, 656):addTo(self.mBg, M.Btns)
end

function M:refreshWidgets()
end

function M:clickBtn(func)
  if func == "RANK" then
    self:showRank()
  elseif func == "REWARD" then
    self:showReward()
  elseif func == "GUARD" then
    LayerPVPTeam.new(LayerPVPTeam.GUARD, handler(self, self.teamCallBack)):addTo(self, M.Layers)
  elseif func == "REFRESH" then
    DYSoundMgr.playEffect(DY_SND.sfx_siwang1)
    self:refreshSeat(self.mSelectFloor)
  elseif func == "PEACE" then
    LayerAvoidWar.new(handler(self, self.keepPeace)):addTo(self, M.Layers)
  elseif func == "LOG" then
    self:showLog()
  end
end

function M:showRank()
  local function tFuncListener(info)
    if info.errorCode > 0 then
      local errMsg = info.errorMsg or "UNKONWN"
      
      WSToast.new(errMsg):addTo(self, M.Layers)
    else
      CloudData.BabelRank = info.data.list
      LayerRank.new():addTo(self, M.Layers)
    end
  end
  
  DYHttpMgr.babelRank(tFuncListener)
end

function M:showReward()
  LayerRewardShow.new(handler(self, self.rewardCallback)):addTo(self, M.Layers)
end

function M:rewardCallback(tag, time, logNum, profit)
  if tag == "UPDATE" then
    self:keepPeace(time, logNum, profit)
  elseif tag == "LOSESEAT" then
    self:loseSeat()
  end
end

function M:loseSeat()
  if self.mLogBtn and self.mLogBtn.newMark then
    self.mLogBtn.newMark:setVisible(true)
  end
  self.mRewardBtn:setVisible(false)
  self.mGuardBtn:setVisible(false)
  if self.mPeaceBtn then
    self.mPeaceBtn:setVisible(false)
  end
  if self.mTowerIcon[self.mSeatFloor] and self.mTowerIcon[self.mSeatFloor].tagIcon then
    self.mTowerIcon[self.mSeatFloor].tagIcon:setVisible(false)
  end
  self:refreshSeat(self.mSeatFloor)
  self.mSeatFloor = 0
  self.mSeatFloorName = ""
  CloudData.BabelInfo.currentStage = self.mSeatFloor
  CloudData.BabelInfo.seatName = self.mSeatFloorName
end

function M:refreshSeat(index)
  local level = index or self.mSelectFloor
  
  local function tFuncListener(info)
    if info.errorCode > 0 then
      local errMsg = info.errorMsg or "UNKONWN"
      WSToast.new(errMsg):addTo(self, M.Layers)
    else
      self.mSeatList = info.data.seatList
      self.mSelectFloor = index
      CloudData.BabelInfo.idleSeatCount = info.data.idleSeatCount
      CloudData.BabelInfo.totalSeatCount = info.data.totalSeatCount
      self.mEmptySeat = checknumber(CloudData.BabelInfo.idleSeatCount)
      self.mMaxSeat = checknumber(CloudData.BabelInfo.totalSeatCount)
      self:addFloor()
    end
  end
  
  local params = {stageId = level}
  DYHttpMgr.refreshSeat(tFuncListener, params)
end

function M:keepPeace(t, log, profit)
  if self.mRewardBtn and self.mRewardBtn.newMark then
    self.mRewardBtn.newMark:setVisible(false)
  end
  if self.mLogBtn and self.mLogBtn.newMark then
    if checknumber(log) > 0 then
      self.mLogBtn.newMark:setVisible(true)
    else
      self.mLogBtn.newMark:setVisible(false)
    end
  end
  local time = checknumber(t)
  if 0 >= self.mPeaceTime and 0 < time then
    CloudData.BabelInfo.safeLeftTime = time
    self.mPeaceTime = time
    if self.mPeaceBtn then
      self.mPeaceBtn:runAction(cc.RemoveSelf:create())
      self.mPeaceBtn = nil
    end
    local avoidWarStr = display.newSprite("babel/war_avoid.png", 845, 680):addTo(self.mBg, M.Btns)
    self.mPeaceIcon = avoidWarStr
    for i = 1, 3 do
      local point = display.newSprite("babel/point.png", 111 + i * 25, 20):addTo(avoidWarStr)
      local seq = transition.sequence({
        cc.DelayTime:create((i - 1) * 0.2),
        cc.MoveBy:create(0.1, cc.p(0, 10)),
        cc.MoveBy:create(0.1, cc.p(0, -10)),
        cc.DelayTime:create(0.6 - i * 0.2)
      })
      point:runAction(cc.RepeatForever:create(seq))
    end
    local timeBg = display.newSprite("babel/name_bg.png"):align(display.CENTER, 72, -20):addTo(avoidWarStr)
    self.mPeaceTimeLab = DYLabelTTF.new({
      text = "",
      size = 25,
      color = cc.c3b(0, 255, 6),
      dyalign = "CENTER",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER, timeBg:getContentSize().width * 0.5, timeBg:getContentSize().height * 0.5):addTo(timeBg)
    self:startCountDown()
  end
  for i = 1, #self.mSeatList do
    if self.mSeatList[i].uid == CloudData.UID then
      self.mSeatList[i].currentIncome = checknumber(profit)
      local totalPro = checknumber(self.mSeatList[i].totalIncome)
      local rate = checknumber(profit) / totalPro * 100
      local cushion = self.mCushionIcon[i]
      if cushion and cushion.progressBar then
        cushion.progressBar:setPercentage(rate)
      end
      if cushion and cushion.proLab then
        cushion.proLab:setString(checknumber(profit) .. "/" .. totalPro)
      end
    end
  end
end

function M:showLog()
  local function tFuncListener(info)
    if info.errorCode > 0 then
      local errMsg = info.errorMsg or "UNKONWN"
      
      WSToast.new(errMsg):addTo(self, M.Layers)
    else
      CloudData.BabelLog = info.data.fightLog or {}
      CloudData.BabelLog.time = checknumber(info.time)
      LayerLog.new(handler(self, self.logCallback)):addTo(self, 20)
    end
  end
  
  DYHttpMgr.babelFightLog(tFuncListener)
end

function M:logCallback()
  if self.mLogBtn and self.mLogBtn.newMark then
    self.mLogBtn.newMark:setVisible(false)
  end
end

function M:clickTower(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  if self.mFloor + 1 == index then
    LayerChallengeBabel.new(index):addTo(self, 20)
  elseif index <= self.mFloor and index ~= self.mSelectFloor then
    self:refreshSeat(index)
  end
end

function M:clickCushion(index)
  local seatInfo = self.mSeatList[index]
  if not seatInfo then
    return
  elseif seatInfo.uid == 0 then
    self:EmptySeatTip(index)
    return
  elseif seatInfo.uid == CloudData.UID then
    self:showReward()
  else
    local id = checknumber(seatInfo.seatId)
    
    local function tFuncListener(info)
      if info.errorCode > 0 then
        local errMsg = info.errorMsg or "UNKONWN"
        WSToast.new(errMsg):addTo(self, 20)
        if info.errorCode == 290 then
          if self.mCushionIcon[index] then
            self.mCushionIcon[index]:removeAllChildren()
          end
          self.mSeatList[index].uid = 0
          self:EmptySeatTip(index)
        end
      else
        local temp = info.data or {}
        temp.seatId = id
        temp.seatName = checkstring(seatInfo.name)
        temp.index = index
        temp.cb = handler(self, self.scanCallback)
        LayerToFight.new(temp):addTo(self, M.Layers)
      end
    end
    
    local params = {seatId = id}
    DYHttpMgr.babelSeatDetail(tFuncListener, params)
  end
end

function M:scanCallback(index, profit)
  if not self.mSeatList[checknumber(index)] then
    return
  end
  self.mSeatList[checknumber(index)].currentIncome = checknumber(profit)
  local totalPro = checknumber(self.mSeatList[checknumber(index)].totalIncome)
  local rate = checknumber(profit) / totalPro * 100
  local cushion = self.mCushionIcon[checknumber(index)]
  if cushion and cushion.progressBar then
    cushion.progressBar:setPercentage(rate)
  end
  if cushion and cushion.proLab then
    cushion.proLab:setString(checknumber(profit) .. "/" .. totalPro)
  end
end

function M:EmptySeatTip(index)
  local params = {
    index = index,
    seatId = self.mSeatList[index].seatId,
    seat = checkstring(self.mSeatList[index].name),
    floor = self.mSelectFloor,
    myFloor = self.mSeatFloor,
    mySeat = self.mSeatFloorName
  }
  LayerSeatInfo.new(handler(self, self.clickEmptySeat), params):addTo(self, 20)
end

function M:clickEmptySeat(index)
  local function tFuncListener(info)
    if info.errorCode > 0 then
      local errMsg = info.errorMsg or "UNKONWN"
      
      WSToast.new(errMsg):addTo(self, 20)
    else
      if info.data.uid then
        self.mSeatList[index] = info.data
        WSToast.new(DYLang.getString("S93", "")):addTo(self, 20)
      else
        for i = 1, #self.mSeatList do
          if self.mSeatList[i].uid == CloudData.UID then
            self.mSeatList[i].uid = 0
            if self.mCushionIcon[i] then
              self.mCushionIcon[i]:removeAllChildren()
            end
          end
        end
        local floorName = self.mSeatList[index].name
        self.mSeatList[index] = {
          seatId = checknumber(info.data.seatId),
          uid = CloudData.UID,
          name = floorName,
          nick = CloudData.USER_NAME,
          currentIncome = 0,
          totalIncome = checknumber(info.data.totalIncome)
        }
        self:babelMeditation(index)
      end
      self:addFloor()
    end
  end
  
  local params = {
    stageId = self.mSelectFloor,
    seatId = self.mSeatList[index].seatId
  }
  DYHttpMgr.babelMeditation(tFuncListener, params)
end

function M:babelMeditation(index)
  WSToast.new(DYLang.getString("S94", "")):addTo(self, 20)
  self.mRewardBtn:setVisible(true)
  self.mGuardBtn:setVisible(true)
  if self.mPeaceBtn then
    self.mPeaceBtn:setVisible(true)
  end
  if self.mTowerIcon[self.mSeatFloor] and self.mTowerIcon[self.mSeatFloor].tagIcon then
    self.mTowerIcon[self.mSeatFloor].tagIcon:setVisible(false)
  end
  self.mSeatFloor = self.mSelectFloor
  self.mSeatFloorName = self.mSeatList[index].name
  CloudData.BabelInfo.currentStage = self.mSeatFloor
  CloudData.BabelInfo.seatName = self.mSeatFloorName
  if self.mTowerIcon[self.mSeatFloor] and self.mTowerIcon[self.mSeatFloor].tagIcon then
    self.mTowerIcon[self.mSeatFloor].tagIcon:setVisible(true)
  end
end

function M:teamCallBack(tag, teamInfo)
  if tag == "SAVE" then
    CloudData.PVP_INFO.defenseTeam = teamInfo
  end
end

function M:startCountDown()
  local time = self.mPeaceTime
  self.mHours = math.floor(time / 3600)
  time = time % 3600
  self.mMinutes = math.floor(time / 60)
  self.mSeconds = math.floor(time % 60)
  self.mPeaceTimeLab:setString(string.format("%02d:%02d:%02d", self.mHours, self.mMinutes, self.mSeconds))
  self.schedule = self:schedule(function()
    self:updateSecond()
  end, 1)
end

function M:updateSecond()
  self.mPeaceTime = self.mPeaceTime - 1
  CloudData.BabelInfo.safeLeftTime = self.mPeaceTime
  if self.mSeconds > 0 then
    self.mSeconds = self.mSeconds - 1
  elseif 0 < self.mMinutes then
    self.mMinutes = self.mMinutes - 1
    self.mSeconds = 59
  elseif 0 < self.mHours then
    self.mHours = self.mHours - 1
    self.mMinutes = 59
    self.mSeconds = 59
  else
    self:countdownOver()
  end
  self.mPeaceTimeLab:setString(string.format("%02d:%02d:%02d", self.mHours, self.mMinutes, self.mSeconds))
end

function M:countdownOver()
  self:stopAction(self.schedule)
  if self.mPeaceIcon then
    self.mPeaceIcon:runAction(cc.RemoveSelf:create())
    self.mPeaceIcon = nil
  end
  self.mPeaceBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.8):align(display.CENTER, 887, 676):addTo(self.mBg, M.Btns):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S91", ""),
    size = 32,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(147, 78, 1)
  })):onButtonClicked(function()
    self:clickBtn("PEACE")
  end)
end

function M:returnCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  GameManager.MODE = 0
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  CloudData.PVP_INFO = {}
  CloudData.BabelInfo = {}
  CloudData.BabelRank = {}
  CloudData.BabelLog = {}
  local nextScene = require("scenes.ChapterScene").new(8)
  display.replaceScene(nextScene, "fade", 0.2)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:returnCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
  GameManager.MODE = 7
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYRes.unloadFileInfo(self.mFileInfo)
end

return M

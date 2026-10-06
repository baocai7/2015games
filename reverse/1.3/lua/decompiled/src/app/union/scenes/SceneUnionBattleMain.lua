local WSToast = require("app.utils.WSToast")
local LayerPVPTeam = require("app.layers.LayerPVPTeam")
local LayerWarSituation = require("app.union.layers.LayerWarSituation")
local LayerRule = require("app.layers.LayerRule")
local LayerChat = require("app.layers.LayerChat")
local CLASS_NAME = "SceneUnionBattleMain"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene()
end)

function M:ctor(params, callback)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCallback = callback
  DYSoundMgr.playMusic(DY_SND.bgm_opening)
  self.mIsTired = 0
  if params and params.tag then
    self.mIsTired = params.tag
  end
  self:initBaseUI()
  
  local function tFunc(event)
    if event.ret_code == 0 then
      self:checkBattleOpen(event)
      self:initData(event)
      self:initUI()
      self:safeSocketListen("CMD_CLAN_COMPETE_BOSS_SYNC", function(event)
        self:refreshBoss(event)
      end, false)
    else
      WSToast.new(event.err_msg):addTo(self, 20)
      self:performWithDelay(function()
        display.replaceScene(require("union.scenes.SceneUnionBattle").new(Const.UNION_FIGHT_END))
      end, 3)
    end
  end
  
  self:safeSocketRequest("CMD_GET_CUR_COMPETE_DATA", nil, tFunc)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData(event)
  local boss = event.boss_info
  self.mFlag = event.my_position
  self.mReliveTime = math.floor(event.recover_time / 1000)
  self.mRelivePeach = event.recover_cost
  self.mBossId = boss.boss_id
  self.mBossCurHp = boss.cur_hp
  self.mBossMaxHp = boss.max_hp
  self.mBossLevel = boss.level
  self.mInitialTeam = event.initial_team or {}
  self.mCurTeam = event.cur_team
  self.mFightIsOpen = CloudData.IS_UNION_BATTLE_OPEN
  self.mRestTime = math.floor(event.left_time / 1000)
  if self.mCurTeam == "" then
    self.mCurTeam = {}
  end
end

function M:initUI()
  DYLabelTTF.new({
    text = DYLang.getString("S1766", ""),
    size = 22,
    color = cc.c3b(0, 255, 48),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  }):pos(588, 633):addTo(self.mBg)
  M.createRemindTime(self.mRestTime):pos(658, 633):addTo(self.mBg)
  self.mVS = display.newSprite("union/battle/pic_vs.png", 630, 384):hide():addTo(self.mBg)
  self.mReliveIcon = self:createRelive(self.mReliveTime, self.mRelivePeach):hide():pos(630, 384):addTo(self.mBg, 10)
  M.bindClickEvent(self.mReliveIcon.mMainPic, function()
    self:clickRelive()
  end)
  local buzhen = display.newSprite("union/battle/buzhen.png", 0, 0)
  local duizhen = display.newSprite("union/battle/duizhen.png", 0, 0)
  self.mProgress = M.createBossProgress(self.mBossId, self.mBossCurHp, self.mBossMaxHp, self.mBossLevel):pos(192, 90):addTo(self.mBg)
  self.mProgress.mFrame:addButtonPressedEventListener(function()
    self:showBossInfo(self.mBossId, self.mBossLevel)
  end)
  self.mProgress.mFrame:onButtonRelease(function()
    self.mBossInfoTip:runAction(cc.RemoveSelf:create())
    self.mBossInfoTip = nil
  end)
  self.mInfo = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1767", ""),
    size = 30,
    color = cc.c3b(247, 227, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    LayerWarSituation.new(self.mFlag):addTo(self, 20)
  end):pos(1000, 88):addTo(self.mBg)
  if self.mFlag == Const.UNION_FIGHT_DEFENCE then
    M.bindClickEvent(self.mLeftUI, function()
      DDLOG(DYLang.getString("S1768", ""))
      self:changeTeam()
    end)
    M.bindClickEvent(self.mRightUI, function()
      DDLOG(DYLang.getString("S1769", ""))
      self:readyToFight()
    end)
    buzhen:addTo(self.mLeftUI)
    duizhen:addTo(self.mRightUI)
  elseif self.mFlag == Const.UNION_FIGHT_ATTACK then
    M.bindClickEvent(self.mLeftUI, function()
      DDLOG(DYLang.getString("S1768", ""))
      self:readyToFight()
    end)
    M.bindClickEvent(self.mRightUI, function()
      DDLOG(DYLang.getString("S1769", ""))
      self:changeTeam()
    end)
    buzhen:addTo(self.mRightUI)
    duizhen:addTo(self.mLeftUI)
  end
  self:refreshUI()
end

function M:initBaseUI()
  self.mBg = display.newSprite("union/battle/bg.jpg", display.cx, display.cy):addTo(self)
  LayerRule.newRuleIcon(LayerRule.UNIONBATTLE):pos(197, 690):addTo(self.mBg, 2)
  cc.ui.UIPushButton.new({
    normal = "union/btn_back.png",
    pressed = "union/btn_back.png"
  }):pos(1080, 685):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mBg, 2)
  self.mLeftUI = cc.ui.UIPushButton.new({
    normal = "union/battle/btn1_normal.png",
    pressed = "union/battle/btn1_press.png"
  }):pos(332, 395):addTo(self.mBg)
  self.mRightUI = cc.ui.UIPushButton.new({
    normal = "union/battle/btn2_normal.png",
    pressed = "union/battle/btn2_press.png"
  }):pos(923, 395):addTo(self.mBg)
  self:loadChatBtn()
end

function M:loadChatBtn()
  cc.ui.UIPushButton.new({
    normal = "chapter/bt_chat.png"
  }):align(display.CENTER_LEFT, 0, display.height * 0.5):addTo(self, 15):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function(event)
    LayerChat.new(3):addTo(self, 20)
  end)
end

function M:checkBattleOpen(event)
  CloudData.IS_UNION_BATTLE_OPEN = event.is_open
  self.mFightIsOpen = CloudData.IS_UNION_BATTLE_OPEN
  if self.mFightIsOpen == false then
    WSToast.new(DYLang.getString("S1772", "")):addTo(self, 20)
    self:performWithDelay(function()
      display.replaceScene(require("union.scenes.SceneUnionBattle").new(Const.UNION_FIGHT_END))
    end, 3)
  end
  return self.mFightIsOpen
end

function M:refreshBoss(event)
  if self:checkBattleOpen(event) then
    local boss = event.boss_info
    self.mBossId = boss.boss_id
    self.mBossCurHp = boss.cur_hp
    self.mBossMaxHp = boss.max_hp
    self.mBossLevel = boss.level
    DYSoundMgr.playEffect(DY_SND.sfx_attack_stab)
    self.mProgress:refresh(self.mBossId, self.mBossCurHp, self.mBossMaxHp, self.mBossLevel)
  end
end

function M:refreshUI()
  if self.mReliveTime < 0 then
    self.mVS:show()
    self.mReliveIcon:hide()
  else
    if 1 == self.mIsTired then
      WSToast.new("\233\129\173\229\143\151\230\149\140\230\150\185\229\129\183\232\162\173\239\188\140\233\152\178\229\190\161\229\161\148\231\180\175\232\174\161\230\141\159\229\164\177\232\182\133\232\191\135100%\232\161\128\233\135\143\239\188\140\230\130\168\229\183\178\233\152\181\228\186\161\239\188\129", 4):addTo(self, 20)
    end
    self.mVS:hide()
    self.mReliveIcon:show()
  end
  self.mProgress.progress:refresh(self.mBossCurHp, self.mBossMaxHp)
end

function M:changeTeam()
  if self.mFightIsOpen == false then
    WSToast.new(DYLang.getString("S1772", "")):addTo(self, 20)
    return
  end
  if self.mReliveTime > 0 then
    WSToast.new(DYLang.getString("S1774", "")):addTo(self, 20)
    return
  end
  if type(self.mCurTeam) ~= "table" or next(self.mCurTeam) == nil then
    self.mCurTeam = {}
  end
  LayerPVPTeam.new(LayerPVPTeam.UNION, function(team)
    self.mCurTeam = team
  end, self.mCurTeam):addTo(self)
end

function M:readyToFight()
  if self.mFightIsOpen == false then
    WSToast.new(DYLang.getString("S1772", "")):addTo(self, 20)
    return
  end
  if self.mReliveTime > 0 then
    WSToast.new(DYLang.getString("S1774", "")):addTo(self, 20)
    return
  end
  if type(self.mCurTeam) ~= "table" or next(self.mCurTeam) == nil then
    WSToast.new(DYLang.getString("S1777", "")):addTo(self, 20)
    self.mCurTeam = {}
    LayerPVPTeam.new(LayerPVPTeam.UNION, function(team)
      self.mCurTeam = team
    end, self.mCurTeam):addTo(self)
    return
  end
  display.replaceScene(require("union.scenes.SceneUnionBattleMatch").new())
end

function M:clickRelive()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  if self.mFightIsOpen == false then
    WSToast.new(DYLang.getString("S1772", "")):addTo(self, 20)
    return
  end
  
  local function tFunc(event)
    dump(event)
    if event.ret_code == 0 then
      WSToast.new(DYLang.getString("S1779", "")):addTo(self)
      self.mReliveTime = -1
      self.mCurTeam = self.mInitialTeam
      self:refreshUI()
    else
      WSToast.new(event.err_msg):addTo(self)
    end
  end
  
  self:safeSocketRequest("CMD_RECOVER_IMMEDIATLY", nil, tFunc)
end

function M.createBossProgress(index, curhp, maxhp, level)
  local node = display.newNode()
  local monsterModel = DataUtils.getUnionBossModel(index, level)
  node.mBossIconPath = monsterModel.npcIcon
  local frame = cc.ui.UIPushButton.new({
    normal = "common_ui/frame6.png"
  }):align(display.CENTER_LEFT, 0, 0):addTo(node)
  node.mIcon = display.newSprite(node.mBossIconPath):pos(58, 0):scale(1.02):addTo(frame)
  node.mIcon:setTouchSwallowEnabled(false)
  node.mFrame = frame
  node.mIconDead = display.newSprite("union/battle/boss_dead.png"):pos(58, 0):scale(1.02):addTo(frame)
  node.mIconDead:hide()
  local frame = display.newSprite("union/battle/xueliang.png"):align(display.CENTER_LEFT, 130, 0):addTo(node)
  node.progress = M.createProgress(curhp, maxhp):pos(450, 0):addTo(node)
  node.blinkProgress = display.newSprite("union/battle/pro_Blue.png"):addTo(node.progress)
  node.blinkProgress:hide()
  
  function node:refresh(index, curhp, maxhp, level)
    node.blinkProgress:show()
    node.blinkProgress:runAction(transition.sequence({
      cc.Blink:create(0.3, 2),
      cc.CallFunc:create(function()
        node.blinkProgress:hide()
      end)
    }))
    local monsterModel = DataUtils.getUnionBossModel(index, level)
    node.mIcon:setTexture(monsterModel.npcIcon)
    if curhp < 0 then
      curhp = 0
      node.mIconDead:show()
    else
      node.mIconDead:hide()
    end
    node.progress:refresh(curhp, maxhp)
  end
  
  return node
end

function M:createRelive(time, cost)
  local node = display.newNode()
  node.mMainPic = display.newSprite("union/battle/relive.png"):addTo(node)
  node.mCostPeach = M.createPeachCost(cost):pos(0, -90):addTo(node)
  node.mTimeLabel = M.createRemindTime(time, function()
    self.mReliveTime = -1
    self.mCurTeam = self.mInitialTeam
    self:refreshUI()
  end):pos(0, 55):addTo(node)
  return node
end

function M:showBossInfo(id, level)
  local index = 1
  local posIndex = (index - 1) % 4 + 1
  local tipPosX = {
    0.505,
    0.712,
    0.29,
    0.497
  }
  local bossInfo = DataUtils.getUnionBossModel(id, level)
  local h = 198
  local skillId = bossInfo.npcSkill
  if skillId and "table" == type(skillId) and 0 < #skillId then
    h = h + #skillId * 60
  end
  self.mBossInfoTip = display.newScale9Sprite("common_ui/common_tip.png", 0, 0, cc.size(550, h), cc.rect(200, 100, 10, 10)):pos(self.mBg:getContentSize().width * tipPosX[posIndex], display.cy):addTo(self.mBg, 50)
  local iconFrame = display.newSprite("common_ui/frame6.png"):pos(88, h - 81):addTo(self.mBossInfoTip)
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
      key = DYLang.getString("S1780", ""),
      value = bossInfo.level,
      x = 135,
      y = 101
    },
    {
      key = DYLang.getString("S1781", ""),
      value = bossInfo.life,
      x = 315,
      y = 101
    },
    {
      key = DYLang.getString("S1782", ""),
      value = bossInfo.attack,
      x = 135,
      y = 71
    },
    {
      key = DYLang.getString("S1783", ""),
      value = bossInfo.magDefence,
      x = 315,
      y = 71
    },
    {
      key = DYLang.getString("S1784", ""),
      value = bossInfo.phyDefence,
      x = 135,
      y = 41
    },
    {
      key = DYLang.getString("S1785", ""),
      value = bossInfo.attackFrequency,
      x = 315,
      y = 41
    },
    {
      key = DYLang.getString("S1786", ""),
      value = bossInfo.attackDistance,
      x = 135,
      y = 11
    },
    {
      key = DYLang.getString("S1787", ""),
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

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  display.replaceScene(require("app.union.scenes.SceneUnionBattle").new())
end

function M.createPeachCost(cost)
  local node = display.newNode()
  node.mPeachIcon = display.newSprite("item_icon/pic_peach.png"):scale(0.8):pos(-30, 0):addTo(node)
  node.mTextLable = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("*%d", cost),
    font = "fonts/greenNum.fnt"
  }):scale(0.6):addTo(node)
  return node
end

function M.createRemindTime(time, cb)
  local node = display.newNode()
  node.mCleanTime = time
  node.mCb = cb
  node.mMain = display.newSprite():addTo(node)
  
  function node:coverScend(sc)
    node.mHours = math.floor(sc / 3600)
    node.mMinutes = math.floor(sc % 3600 / 60)
    node.mSeconds = sc % 3600 % 60
  end
  
  node:coverScend(node.mCleanTime)
  node.mLabel = DYLabelTTF.new({
    text = string.format("%02d:%02d", node.mMinutes, node.mSeconds),
    size = 24,
    color = cc.c3b(0, 255, 6),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):addTo(node)
  
  function node:updateTime()
    node.mCleanTime = node.mCleanTime - 1
    node:coverScend(node.mCleanTime)
    node.mLabel:setString(string.format("%02d:%02d", node.mMinutes, node.mSeconds))
    if node.mCleanTime < 0 and node.mCb then
      node.mCb()
      node.mCb = nil
    end
  end
  
  function node:setTime(time)
    node.mCleanTime = time
  end
  
  node.mLabel:schedule(function()
    node:updateTime()
  end, 1)
  return node
end

function M.createProgress(currNum, maxxNum)
  local node = display.newNode()
  local barBg = display.newSprite("union/battle/pro_frame.png"):addTo(node)
  node.mPieceNumLabel = DYLabelTTF.new({
    UILabelType = 2,
    text = string.format("%d/%d", currNum, maxxNum),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  node.mProgressTimer = cc.ProgressTimer:create(display.newSprite("union/battle/pro_bar.png")):addTo(barBg)
  node.mProgressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  node.mProgressTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  node.mProgressTimer:setMidpoint(cc.p(0, 0))
  node.mProgressTimer:setBarChangeRate(cc.p(1, 0))
  node.mProgressTimer:setPercentage(currNum / maxxNum * 100)
  
  function node:refresh(num1, num2)
    if num1 < 0 then
      num1 = 0
    end
    node.mProgressTimer:setPercentage(num1 / num2 * 100)
    node.mPieceNumLabel:setString(string.format("%d/%d", num1, num2))
  end
  
  return node
end

function M.bindClickEvent(node, tFunc)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  node:setTouchEnabled(true)
  node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      node.pointBegan = {x = x, y = y}
      return true
    elseif name == "ended" then
      local pointEnd = {x = x, y = y}
      if math.abs(node.pointBegan.x - pointEnd.x) < 50 and math.abs(node.pointBegan.y - pointEnd.y) < 50 then
        node:runAction(transition.sequence({
          cc.ScaleTo:create(0.1, 1.1),
          cc.ScaleTo:create(0.1, 1),
          cc.CallFunc:create(function()
            tFunc()
          end)
        }))
      end
    end
  end)
  return node
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
  self:safeSocketRequest("CMD_LEAVE_COMPETE_WAIT_PANEL")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

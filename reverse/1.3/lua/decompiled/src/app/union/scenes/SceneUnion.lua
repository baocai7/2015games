local LayerUnionMember = require("app.union.layers.LayerUnionMember")
local LayerUnionInfo = require("app.union.layers.LayerUnionInfo")
local LayerUnionList = require("app.union.layers.LayerUnionList")
local LayerUnionContri = require("app.union.layers.LayerUnionContribute")
local LayerUnionBoss = require("app.union.layers.LayerUnionBoss")
local LayerUnionShop = require("app.union.layers.LayerUnionShop")
local LayerRule = require("app.layers.LayerRule")
local IconPkBubble = require("app.icons.IconPkBubble")
local LayerChat = require("app.layers.LayerChat")
local LayerPatrol = require("app.union.layers.LayerPatrol")
local DYClass = "SceneUnion"
local M = {}
M = class(DYClass, function()
  return display.newScene(DYClass)
end)
local UNION_MAX_LEVEL = 10

function M:ctor(params)
  self.mParams = params or {}
  self.mKeypadListener = handler(self, self.onKeypad)
  if not audio.isMusicPlaying() then
    DYSoundMgr.playMusic(DY_SND.bgm_theme)
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:performWithDelay(handler(self, self.loadArmatureAsync), 0.2)
  self:initUI()
  self:initPkBubble()
  self:initData()
end

function M:initData()
  local function tFuncEvent(param)
    DDLOG(" ================ GET_UNION_INFO !!!!!!!")
    
    CloudData.UNION_INFO = param.clan_base_data
    CloudData.UNION_MEMBERS = param.clan_member_list
    CloudData.UNION_CONTRI_NUM = CloudData.GAME_ITEM_INFO["9"] or 0
    CloudData.GAME_ITEM_INFO["9"] = CloudData.UNION_CONTRI_NUM
    CloudData.UNION_APPLY_LIST = param.clan_base_data.apply_list
    CloudData.UNION_SELF_INFO = param.my_clan_data
    CloudData.UNION_BOSS_FIGHT = param.my_clan_data.fight_count
    CloudData.UNION_POS = param.my_clan_data.rank
    CloudData.CONTRI_REWARD_STATE = {}
    for i = 1, 4 do
      local state = param.my_clan_data.construct_prize_record[tostring(i)]
      if state then
        table.insert(CloudData.CONTRI_REWARD_STATE, 1)
      else
        table.insert(CloudData.CONTRI_REWARD_STATE, 0)
      end
    end
    GameManager.UNION_BOX_REWARD_INFO = {}
    for i = 1, 4 do
      local pData = DataUtils.getUnionContriData(i)
      table.insert(GameManager.UNION_BOX_REWARD_INFO, pData)
    end
    CloudData.CONTRI_LEFT_TIMES = param.my_clan_data.left_construct_times
    CloudData.CONTRI_TYPE = param.my_clan_data.construct_type
    self.mIsBossOpen = param.is_open_train
    CloudData.UNION_FIGHT_IS_OPEN = false
    if not self.class or self.class.__cname ~= DYClass then
      return
    end
    self.mTopFunBtns = {}
    self:loadUnionInfo()
    self:loadCenterUI()
    self:loadTopUI()
    self:onEventChatListener()
    self.mIsClanCompeteStart = param.is_clan_compete_start
    self.mCanBeClicked = true
  end
  
  self:safeSocketRequest("CMD_UNION_INFO", nil, tFuncEvent)
end

function M:loadArmatureAsync()
  local animationPath = {
    "linglu1Idle",
    "qinglong1Idle",
    "penglaigui1Idle",
    "nianshou1Idle",
    "yelong1Idle"
  }
  self.mFiles = {}
  
  local function dataLoaded(percent)
    if 1 <= percent then
      DDLOG("=========== armature load success")
    end
  end
  
  for i = 1, #animationPath do
    local path = animationPath[i]
    local file = string.format("armature/%s/%s.csb", path, path)
    DYRes.loadFileInfoAsync(file, self.mFiles, dataLoaded)
  end
end

function M:initUI()
  self.mBg = display.newSprite("union/bg_inner.png", display.cx, display.cy):addTo(self)
  local cloud1 = display.newSprite("union/cloud1.png", 20, 550):addTo(self.mBg)
  local cloud2 = display.newSprite("union/cloud2.png", 640, 480):addTo(self.mBg)
  local cloud3 = display.newSprite("union/cloud2.png", -640, 410):addTo(self.mBg)
  
  local function tFuncUpdate()
    cloud1:setPositionX(cloud1:getPositionX() + 1)
    cloud2:setPositionX(cloud2:getPositionX() + 1)
    cloud3:setPositionX(cloud3:getPositionX() + 1)
    if cloud1:getPositionX() >= 1650 then
      cloud1:setPositionX(-910)
    end
    if cloud2:getPositionX() >= 1650 then
      cloud2:setPositionX(-910)
    end
    if cloud3:getPositionX() >= 1650 then
      cloud3:setPositionX(-910)
    end
  end
  
  self:schedule(function()
    tFuncUpdate()
  end, 0.016)
  LayerRule.newRuleIcon(LayerRule.UNIONMAP):align(display.CENTER_RIGHT, display.width - 130, display.height * 0.91):addTo(self, 2)
  cc.ui.UIPushButton.new({
    normal = "union/btn_back.png",
    pressed = "union/btn_back.png"
  }):align(display.CENTER_RIGHT, display.width - 5, display.height * 0.92):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
    local nextScene = require("scenes.ChapterScene").new()
    display.replaceScene(nextScene, "fade", 0.2)
  end):addTo(self, 2)
end

function M:loadUnionInfo()
  local unionIcon = display.newSprite("union/icon_union.png", 0, 0):align(display.CENTER_LEFT, 20, display.height * 0.92):addTo(self, 2)
  self.mLevelLabel = DYLabelTTF.new({
    text = string.format("LV.%d", CloudData.UNION_INFO.level),
    size = 24,
    color = cc.c3b(255, 194, 9),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(100, unionIcon:getPositionY() + 15):addTo(self, 2)
  DYLabelTTF.new({
    text = CloudData.UNION_INFO.name,
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(255, unionIcon:getPositionY() + 15):addTo(self, 2)
  local barBg = display.newSprite("user_center/bar_bg.png"):align(display.CENTER_LEFT, 95, unionIcon:getPositionY() - 20):addTo(self, 2)
  local currExp = CloudData.UNION_INFO.exp
  local needExp = CloudData.UNION_INFO.upgrade_exp
  self.mExpLabel = DYLabelTTF.new({
    text = currExp .. "/" .. needExp,
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  self.mProTimer = cc.ProgressTimer:create(display.newSprite("user_center/bar_pro.png")):addTo(barBg)
  self.mProTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.mProTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  self.mProTimer:setMidpoint(cc.p(0, 0))
  self.mProTimer:setBarChangeRate(cc.p(1, 0))
  self.mProTimer:setPercentage(currExp / needExp * 100)
  if CloudData.UNION_INFO.level >= UNION_MAX_LEVEL then
    self.mExpLabel:setString("max")
    self.mProTimer:setPercentage(100)
  end
  local sp = display.newSprite("union/contributions.png", 0, 0):align(display.CENTER_LEFT, 20, display.height * 0.81):addTo(self, 2)
  local lbFrame = display.newSprite("union/lb_contri.png", 0, 0):align(display.CENTER_LEFT, 20 + sp:getContentSize().width, sp:getPositionY()):addTo(self, 2)
  self.mContriLabel = DYLabelTTF.new({
    text = CloudData.UNION_CONTRI_NUM,
    size = 22,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):pos(lbFrame:getContentSize().width * 0.6, lbFrame:getContentSize().height * 0.5):addTo(lbFrame, 1)
end

function M:loadCenterUI()
  local M_NAME = {
    "union/name_monster.png",
    "union/name_contri.png",
    "union/name_battle.png",
    "union/name_shop.png"
  }
  local M_POS = {
    {x = 211, y = 223},
    {x = 527, y = 222},
    {x = 779, y = 236},
    {x = 1053, y = 239}
  }
  local icon1 = display.newSprite("union/icon1.png"):pos(M_POS[1].x, M_POS[1].y):addTo(self.mBg)
  local tx = display.newSprite("union/icon1_tx.png"):pos(icon1:getContentSize().width * 0.5, icon1:getContentSize().height * 0.5):addTo(icon1)
  tx:runAction(cc.RepeatForever:create(transition.sequence({
    cc.FadeOut:create(1.5),
    cc.FadeIn:create(1.5)
  })))
  local icon2 = display.newSprite("union/icon2.png"):pos(M_POS[2].x, M_POS[2].y):addTo(self.mBg)
  local stone = display.newSprite("union/icon2_tx2.png"):pos(icon2:getContentSize().width * 0.5, icon2:getContentSize().height * 0.5):addTo(icon2)
  local light = display.newSprite("union/icon2_tx1.png"):pos(icon2:getContentSize().width * 0.5, icon2:getContentSize().height * 0.5):addTo(icon2, 1)
  local top = display.newSprite("union/icon2_tx3.png"):pos(icon2:getContentSize().width * 0.5, icon2:getContentSize().height * 0.5):addTo(icon2, 1)
  light:runAction(cc.RepeatForever:create(transition.sequence({
    cc.FadeOut:create(1.5),
    cc.FadeIn:create(1.5)
  })))
  top:runAction(cc.RepeatForever:create(transition.sequence({
    cc.MoveBy:create(1.5, cc.p(0, -5)),
    cc.MoveBy:create(1.5, cc.p(0, 5))
  })))
  local icon3 = display.newSprite("union/icon3.png"):pos(M_POS[3].x, M_POS[3].y):addTo(self.mBg)
  local icon4 = display.newSprite("union/icon4.png"):pos(M_POS[4].x, M_POS[4].y):addTo(self.mBg)
  self.mCenterFuncBtns = {
    icon1,
    icon2,
    icon3,
    icon4
  }
  for i = 1, #self.mCenterFuncBtns do
    local icon = self.mCenterFuncBtns[i]
    local name = display.newSprite(M_NAME[i]):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height + 30):addTo(icon)
    icon:setTouchEnabled(true)
    icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
      if name == "began" then
        icon.pointBegan = {x = x, y = y}
        return true
      elseif name == "ended" then
        local pointEnd = {x = x, y = y}
        if math.abs(icon.pointBegan.x - pointEnd.x) < 50 and math.abs(icon.pointBegan.y - pointEnd.y) < 50 then
          icon:runAction(transition.sequence({
            cc.ScaleTo:create(0.1, 1.2),
            cc.ScaleTo:create(0.1, 1),
            cc.CallFunc:create(function()
              self:onEventCenterFunc(i)
            end)
          }))
        end
      end
    end)
    icon.redPoint = display.newSprite("common_ui/red_point.png"):hide():pos(name:getContentSize().width, name:getContentSize().height * 0.5):addTo(name)
  end
  self:checkBossOpen()
  self:checkContriBox()
end

function M:loadTopUI()
  local M_ICONS = {
    "union/icon_info.png",
    "union/icon_unions.png",
    "union/icon_member.png",
    "union/icon_chat.png",
    "union/icon_patrol.png"
  }
  for i = 1, #M_ICONS do
    local btn = cc.ui.UIPushButton.new({
      normal = M_ICONS[i],
      pressed = M_ICONS[i]
    }):align(display.CENTER_BOTTOM, display.width * (0.08 * i + 0.37), display.height * 0.84):onButtonPressed(function(event)
      event.target:setScale(0.72)
    end):onButtonRelease(function(event)
      event.target:setScale(0.8)
    end):onButtonClicked(function()
      self:onEventTopFunc(i)
    end):scale(0.8):addTo(self, 2)
    btn.newMark = display.newSprite("common_ui/new.png", 40, 80):hide():addTo(btn)
    table.insert(self.mTopFunBtns, btn)
  end
  self:checkNewMark()
  self:checkNewChatMsg()
  self:checkPatrolBox()
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new():addTo(self, 900)
end

function M:onEventCenterFunc(idx)
  if not self.mCanBeClicked then
    return
  end
  self.mCanBeClicked = false
  local tFunc = {
    [1] = function()
      self:clickBoss()
    end,
    [2] = function()
      LayerUnionContri.new(nil, handler(self, self.updateUnionInfo)):addTo(self, 20)
    end,
    [3] = function()
      self:clickBattle()
    end,
    [4] = function()
      LayerUnionShop.new(handler(self, self.updateUnionInfo)):addTo(self, 20)
    end
  }
  tFunc[idx]()
  self:performWithDelay(function()
    self.mCanBeClicked = true
  end, 1)
end

function M:onEventTopFunc(idx)
  if not self.mCanBeClicked then
    return
  end
  self.mCanBeClicked = false
  local tFunc = {
    [1] = function()
      LayerUnionInfo.new(nil, handler(self, self.checkNewMark)):addTo(self, 20)
    end,
    [2] = function()
      LayerUnionList.new():addTo(self, 20)
    end,
    [3] = function()
      LayerUnionMember.new():addTo(self, 20)
    end,
    [4] = function()
      self:openChatLayer()
    end,
    [5] = function()
      display.replaceScene(LayerPatrol.scene(), "fadeUp", 0.6)
    end
  }
  tFunc[idx]()
  self:performWithDelay(function()
    self.mCanBeClicked = true
  end, 1)
end

function M:openChatLayer()
  DYNotification.removeAllObservers(self)
  local btn = self.mTopFunBtns[4]
  if btn.newMark:isVisible() then
    btn.newMark:hide()
  end
  CloudData.IS_NEW_UNION_CHAT = false
  LayerChat.new(LayerChat.CHANNEL_UNION, nil, handler(self, self.onEventCloseChatLayer)):addTo(self, 20)
end

function M:onEventCloseChatLayer()
  self:onEventChatListener()
end

function M:checkBossOpen()
  local icon = self.mCenterFuncBtns[1]
  if self.mIsBossOpen then
    icon.redPoint:show()
  else
    icon.redPoint:hide()
  end
end

function M:checkContriBox()
  local icon = self.mCenterFuncBtns[2]
  local currValue = CloudData.UNION_INFO.construct_progress
  for i = 1, #CloudData.CONTRI_REWARD_STATE do
    local state = CloudData.CONTRI_REWARD_STATE[i]
    local needValue = GameManager.UNION_BOX_REWARD_INFO[i].progressNum
    if 1 ~= state and currValue >= needValue then
      icon.redPoint:show()
      break
    else
      icon.redPoint:hide()
    end
  end
end

function M:checkNewMark()
  if 1 == CloudData.UNION_POS then
    return
  end
  local btn = self.mTopFunBtns[1]
  if #CloudData.UNION_APPLY_LIST > 0 and not btn.newMark:isVisible() then
    btn.newMark:show()
    local seq = transition.sequence({
      cc.FadeOut:create(0.5),
      cc.FadeIn:create(0.5)
    })
    btn.newMark:runAction(cc.RepeatForever:create(seq))
  elseif #CloudData.UNION_APPLY_LIST == 0 and btn.newMark:isVisible() then
    btn.newMark:hide()
  end
end

function M:checkNewChatMsg()
  local btn = self.mTopFunBtns[4]
  if CloudData.IS_NEW_UNION_CHAT then
    if btn.newMark:isVisible() then
      return
    end
    btn.newMark:show()
    local seq = transition.sequence({
      cc.FadeOut:create(0.5),
      cc.FadeIn:create(0.5)
    })
    btn.newMark:runAction(cc.RepeatForever:create(seq))
  else
    btn.newMark:hide()
  end
end

function M:updateUnionInfo()
  self.mLevelLabel:setString(string.format("LV.%d", CloudData.UNION_INFO.level))
  local currExp = CloudData.UNION_INFO.exp
  local needExp = CloudData.UNION_INFO.upgrade_exp
  self.mExpLabel:setString(currExp .. "/" .. needExp)
  self.mProTimer:setPercentage(currExp / needExp * 100)
  if CloudData.UNION_INFO.level >= UNION_MAX_LEVEL then
    self.mExpLabel:setString("max")
    self.mProTimer:setPercentage(100)
  end
  self.mContriLabel:setString(CloudData.UNION_CONTRI_NUM)
  self:checkContriBox()
end

function M:checkPatrolBox(tag)
  local function tFuncListener(json)
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif checknumber(json.errorCode) == 0 and checknumber(json.data and json.data.redPoint) == 1 and self.mTopFunBtns and self.mTopFunBtns[5] and self.mTopFunBtns[5].newMark then
      self.mTopFunBtns[5].newMark:show()
    end
  end
  
  local params = {
    clanId = CloudData.UNION_INFO.id,
    clanLevel = CloudData.UNION_INFO.level
  }
  DYHttpMgr.patrolNew(tFuncListener, params)
end

function M:clickBoss()
  if CloudData.UNION_INFO.level < 3 then
    WSToast.new(DYLang.getString("S1752", "")):addTo(self, 20)
    return
  elseif CloudData.UNION_FIGHT_IS_OPEN == true then
    WSToast.new(DYLang.getString("S1753", "")):addTo(self, 20)
    return
  end
  LayerUnionBoss.new(function()
    self:updateUnionInfo()
  end):addTo(self, 20)
end

function M:clickBattle()
  if self.mIsClanCompeteStart == false then
    WSToast.new(DYLang.getString("S1754", "")):addTo(self, 20)
  elseif CloudData.UNION_INFO.level >= 3 then
    local nextScene = require("union.scenes.SceneUnionBattle").new()
    display.replaceScene(nextScene, "fade", 0.2)
  else
    WSToast.new(DYLang.getString("S1755", "")):addTo(self, 20)
  end
end

function M:onEventChatListener()
  local btn = self.mTopFunBtns[4]
  
  local function tFuncUpdate()
    if CloudData.IS_NEW_UNION_CHAT then
      if btn.newMark:isVisible() then
        return
      end
      btn.newMark:show()
      local seq = transition.sequence({
        cc.FadeOut:create(0.5),
        cc.FadeIn:create(0.5)
      })
      btn.newMark:runAction(cc.RepeatForever:create(seq))
    else
      btn.newMark:hide()
    end
  end
  
  DYNotification.registerScriptObserver(self, tFuncUpdate, DY_KEY.kUpdateChatMsg)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    local nextScene = require("scenes.ChapterScene").new()
    display.replaceScene(nextScene, "fade", 0.2)
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
  DYRes.unloadFileInfo(self.mFiles)
  self.mFiles = {}
  DYNotification.removeAllObservers(self)
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

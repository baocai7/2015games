local PanelTopInfo = require("app.pvponline.PanelTopInfo")
local LayerRule = require("app.layers.LayerRule")
local LayerTeam = require("app.layers.LayerTeam")
local DYClass = "LayerCompeteInfo"
local M = {}
M = class(DYClass, function()
  return display.newScene(DYClass)
end)
local ITEM_WIDTH, ITEM_HEIGHT = 320, 68

function M:ctor()
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function getCompeteMsg(idx)
  local msgInfo = CloudData.COMPETE_LOG[idx]
  local t = {
    DYLang.getString("S1157", ""),
    DYLang.getString("S1158", ""),
    DYLang.getString("S1159", ""),
    DYLang.getString("S1160", "")
  }
  local pNode = display.newNode()
  pNode:setContentSize(320, 68)
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S1161", ""),
    size = 21,
    color = cc.c3b(55, 23, 2),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(0, 40):addTo(pNode)
  local lb2 = DYLabelTTF.new({
    text = msgInfo.winner,
    size = 21,
    color = cc.c3b(255, 83, 15),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb1:getPositionX() + lb1:getContentSize().width, lb1:getPositionY()):addTo(pNode)
  local lb3 = DYLabelTTF.new({
    text = DYLang.getString("S1162", ""),
    size = 21,
    color = cc.c3b(55, 23, 2),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb2:getPositionX() + lb2:getContentSize().width, lb1:getPositionY()):addTo(pNode)
  local lb4 = DYLabelTTF.new({
    text = t[msgInfo.round + 1],
    size = 21,
    color = cc.c3b(55, 23, 2),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(0, lb1:getPositionY() - 28):addTo(pNode)
  return pNode
end

function M:checkTeam()
  local teamInfo = DataUtils.getBuddhaTableOnTeam()
  if #teamInfo < 6 then
    WSToast.new(DYLang.getString("S1164", ""), 2):addTo(self, 25)
    
    local function tFunc(attackTeam, helpTeam)
      local params = {}
      params.attackTeam = attackTeam
      params.helpTeam = helpTeam
      self:safeSocketRequest("CMD_UPDATE_TEAM", params)
      self:checkTeam()
    end
    
    LayerTeam.new(LayerTeam.TEAM_NORMAL, tFunc):addTo(self, 20)
  end
end

local function onEventExitScene(self)
  local pLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 50)
  local bg = display.newSprite("common_ui/common_dialog.png"):pos(display.cx, display.cy):addTo(self, 51)
  local text1 = cc.ui.UILabel.new({
    text = DYLang.getString("S1165", ""),
    size = 32,
    color = cc.c3b(55, 23, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.55):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1166", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    pLayer:removeSelf()
    bg:removeSelf()
  end):align(display.CENTER, bg:getContentSize().width * 0.32, bg:getContentSize().height * 0.2):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1167", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallback()
  end):align(display.CENTER, bg:getContentSize().width * 0.68, bg:getContentSize().height * 0.2):addTo(bg)
end

function M:initUI()
  local function tFuncListener()
    local leftTime = self.mSeconds + self.mMinutes * 60
    
    if not CloudData.IS_SEASON_END and self.mIsInMatch and leftTime <= 30 then
      onEventExitScene(self)
    else
      self:closeCallback()
    end
  end
  
  local panel = PanelTopInfo.new({
    type = PanelTopInfo.TYPE_COMPETE,
    callback = tFuncListener
  }):addTo(self.mNode)
  self.mPanel = panel
  local bg = display.newSprite("pvp_ol/bg_competeInfo.png", 640, 320):addTo(panel.mBg)
  self.mBg = bg
  LayerRule.newRuleIcon(LayerRule.PVPOLCOMPETE):align(display.CENTER, bg:getContentSize().width * 0.06, bg:getContentSize().height * 0.94):addTo(bg, 2)
end

function M:initData()
  local function tFuncEvent(param)
    DDLOG(" ================ REFRESH_COMPETE_DATA !!!!!!!")
    
    dump(param, "REFRESH_COMPETE_DATA : ", 8)
    CloudData.COMPETE_ROUND = param.cur_round + 1
    CloudData.NEXT_ROUND_TIME = param.next_round_time
    CloudData.COMPETE_LOG = param.fight_log
    CloudData.ROUND_DATA = param.round_data
    CloudData.IS_SEASON_END = param.is_end
    self.mSeasonWinner = param.champion or ""
    self.mMsgIdx = #CloudData.COMPETE_LOG
    if self.mMatchFrame ~= nil then
      self.mMatchFrame:runAction(cc.RemoveSelf:create())
      self.mMsgFrame:runAction(cc.RemoveSelf:create())
      self.mMatchFrame = nil
      self.mMsgFrame = nil
      self:safeSocketCancel("CMD_AUTO_ADVANCED")
      self:safeSocketCancel("CMD_FIGHT")
    end
    self:initMatchInfo()
    self:loadCompeteMsg()
    self:loadCompeteTime()
    self:loadSeasonWinner()
    self:onEventMatchStatus()
    self:onEventAutoAdvanced()
  end
  
  self:safeSocketListen("CMD_REFRESH_COMPETE_DATA", tFuncEvent, false)
  self:safeSocketRequest("CMD_ENTER_COMPETE")
end

function M:onEventMatchStatus()
  self:safeSocketRequest("CMD_BUG_TEST", {
    eve_name = "ADD_LISTENER_FOR_PROTO_1005"
  })
  
  local function tFuncEvent(param)
    DDLOG(" ================ on Fight !!!!!!!")
    self:safeSocketRequest("CMD_BUG_TEST", {
      eve_name = "AFTER_RECEIVE_PROTO_1005"
    })
    GameManager.MODE = 6
    local buddhaData = param.self_user_data
    local enemyData = param.enemy_user_data
    CloudData.FIGHT_SEED = param.fight_seed
    CloudData.FIGHT_PRIORITY = param.priority
    CloudData.ENEMY_INFO = {
      icon = GameManager.USER_ICON_PATH .. enemyData.icon .. ".png",
      userName = enemyData.nick,
      pvpData = param.enemy_pvp_data
    }
    local cimeliaAtk = buddhaData.attackCimelia
    local cimeliaDef = buddhaData.defenseCimelia
    local buddhaList = buddhaData.buddhaList
    local treasureList = buddhaData.treasureList
    CloudData.BUDDHA_CIMELIA_INFO = {atkCimelia = cimeliaAtk, defCimelia = cimeliaDef}
    CloudData.BUDDHA_ATTACK_TEAM = buddhaData.attackTeam
    CloudData.BUDDHA_ASSIST_TEAM = buddhaData.helpTeam
    CloudData.BUDDHA_EQUIPMENTS = buddhaData.equipmentMap
    CloudData.BUDDHA_TREASURE_INFO = {}
    CloudData.BUDDHA_NPC_INFO = {}
    for k, v in pairs(treasureList) do
      CloudData.BUDDHA_TREASURE_INFO[v.treasureId] = v.quality
    end
    for k, v in pairs(buddhaList) do
      CloudData.BUDDHA_NPC_INFO[tostring(v.id)] = {
        level = v.level,
        id = v.id,
        status = v.status,
        star = v.star,
        realStar = v.real_star,
        skills = v.skills,
        realLevel = v.real_level,
        arousals = v.arousals,
        equipments = v.equipments
      }
    end
    local cimeliaAtk = enemyData.attackCimelia
    local cimeliaDef = enemyData.defenseCimelia
    local buddhaList = enemyData.buddhaList
    local treasureList = enemyData.treasureList
    CloudData.ENEMY_CIMELIA_INFO = {atkCimelia = cimeliaAtk, defCimelia = cimeliaDef}
    CloudData.ENEMY_ATTACK_TEAM = enemyData.attackTeam
    CloudData.ENEMY_ASSIST_TEAM = enemyData.helpTeam
    CloudData.ENEMY_EQUIPMENTS = enemyData.equipmentMap or {}
    CloudData.ENEMY_TREASURE_INFO = {}
    CloudData.ENEMY_NPC_INFO = {}
    for k, v in pairs(treasureList) do
      CloudData.ENEMY_TREASURE_INFO[v.treasureId] = v.quality
    end
    for k, v in pairs(buddhaList) do
      CloudData.ENEMY_NPC_INFO[tostring(v.id)] = {
        level = v.level,
        id = v.id,
        status = v.status,
        star = v.star,
        realStar = v.real_star,
        skills = v.skills,
        realLevel = v.real_level,
        arousals = v.arousals,
        equipments = v.equipments
      }
    end
    CloudData.BUDDHA_UNION_BOSS = buddhaData.m_boss_level
    CloudData.ENEMY_UNION_BOSS = enemyData.m_boss_level
    self:safeSocketCancel("CMD_REFRESH_COMPETE_DATA")
    self:safeSocketCancel("CMD_AUTO_ADVANCED")
    self:performWithDelay(function()
      self:safeSocketRequest("CMD_BUG_TEST", {
        eve_name = "BEFORE_ENTER_SCENE_BATTLE"
      })
      display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE", "NORMAL"))
    end, 2)
  end
  
  self:safeSocketListen("CMD_FIGHT", tFuncEvent, true)
end

function M:onEventAutoAdvanced()
  local function tFuncEvent(param)
    DDLOG(" ================ auto advanced !!!!!!!")
    
    dump(param, "auto advanced : ")
    CloudData.COMPETE_ROUND = param.cur_round + 1
    CloudData.NEXT_ROUND_TIME = param.next_round_time
    WSToast.new(DYLang.getString("S1169", ""), 2.5):addTo(self, 20)
    self:loadCompeteTime()
  end
  
  self:safeSocketListen("CMD_AUTO_ADVANCED", tFuncEvent, false)
end

function M:initMatchInfo()
  local frame = display.newSprite("pvp_ol/bg_match.png"):pos(self.mBg:getContentSize().width * 0.315, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  self.mMatchFrame = frame
  
  local function matchItemAtIndex(idx)
    local matchInfo = CloudData.ROUND_DATA[idx].players
    local winner = CloudData.ROUND_DATA[idx].winner
    local isEnd = CloudData.ROUND_DATA[idx].is_end
    local itemFrame = display.newSprite("#frame_vs.png")
    for i = 1, 2 do
      local playerInfo = matchInfo[i]
      if not playerInfo then
        break
      end
      local uid = playerInfo.uid
      if CloudData.UID == uid then
        self.mIsInMatch = true
      end
      local iconFrame = display.newSprite("common_ui/frame_battle.png"):scale(0.65):align(display.CENTER_LEFT, 10 + (i - 1) * 270, itemFrame:getContentSize().height * 0.5):addTo(itemFrame)
      display.newSprite("buddha_icon/buddha" .. playerInfo.icon .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
      if winner then
        if winner == uid then
          display.newSprite("#win.png", iconFrame:getPositionX() + 60, 30):addTo(itemFrame, 1)
        else
          display.newSprite("#lose.png", iconFrame:getPositionX() + 60, 30):addTo(itemFrame, 1)
        end
      elseif isEnd then
        display.newSprite("pvp_ol/abstention.png", iconFrame:getPositionX() + 60, 30):addTo(itemFrame, 1)
      end
      DYLabelTTF.new({
        text = string.format("\227\128\138%s\227\128\139", playerInfo.server),
        size = 27,
        color = cc.c3b(24, 120, 240),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(iconFrame:getContentSize().width + 10, iconFrame:getContentSize().height * 0.5 + 40):addTo(iconFrame)
      DYLabelTTF.new({
        text = playerInfo.nick,
        size = 27,
        color = cc.c3b(79, 47, 10),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(iconFrame:getContentSize().width + 10, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
      DYLabelTTF.new({
        text = "LV." .. playerInfo.level,
        size = 27,
        color = cc.c3b(79, 47, 10),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(iconFrame:getContentSize().width + 10, iconFrame:getContentSize().height * 0.5 - 40):addTo(iconFrame)
    end
    return itemFrame
  end
  
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(25, 30, 482, 450),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  for i = 1, #CloudData.ROUND_DATA do
    local item = listView:newItem()
    local content = matchItemAtIndex(i)
    item:addContent(content)
    item:setItemSize(481, 110)
    listView:addItem(item)
  end
  listView:reload()
end

function M:loadCompeteMsg()
  local frame = display.newScale9Sprite("#common_frame.png", 0, 0, cc.size(350, 405), cc.rect(30, 30, 1, 1)):pos(self.mBg:getContentSize().width * 0.76, self.mBg:getContentSize().height * 0.57):addTo(self.mBg)
  self.mMsgFrame = frame
  display.newSprite("#title.png", 175, 425):addTo(frame)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(10, 10, 330, 360),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  for i = 1, self.mMsgIdx do
    local item = listView:newItem()
    local content = getCompeteMsg(i)
    item:addContent(content)
    item:setItemSize(ITEM_WIDTH, ITEM_HEIGHT)
    listView:addItem(item)
  end
  listView:reload()
  self.mMsgList = listView
  if self.mMsgIdx > 5 then
    local moveByParams = {
      x = 0,
      y = ITEM_HEIGHT * (self.mMsgIdx - 5),
      time = 0.2
    }
    for k, v in pairs(listView.items_) do
      transition.moveBy(v, moveByParams)
    end
  end
end

function M:loadCompeteTime()
  local t1 = {
    "16\229\188\186\232\181\155",
    "8\229\188\186\232\181\155",
    DYLang.getString("S1170", ""),
    DYLang.getString("S1171", "")
  }
  local t2 = {
    "20:08",
    "20:16",
    "20:24",
    "20:32"
  }
  local currRound = CloudData.COMPETE_ROUND
  local str = ""
  if CloudData.IS_SEASON_END then
    str = DYLang.getString("S1172", "")
  elseif currRound < 5 then
    str = t1[currRound] .. DYLang.getString("S1173", "") .. t2[currRound] .. DYLang.getString("S1174", "")
  end
  if self.mRoundLabel then
    self.mRoundLabel:setString(str)
  else
    self.mRoundLabel = DYLabelTTF.new({
      text = str,
      size = 22,
      color = cc.c3b(255, 239, 58),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(105, 56, 3),
      lineWidth = 1.5
    }):pos(self.mBg:getContentSize().width * 0.76, self.mBg:getContentSize().height * 0.2):addTo(self.mBg)
  end
  if CloudData.IS_SEASON_END then
    CloudData.NEXT_ROUND_TIME = 0
  end
  self.mMinutes = math.floor(CloudData.NEXT_ROUND_TIME / 60)
  self.mSeconds = CloudData.NEXT_ROUND_TIME - self.mMinutes * 60
  local str = string.format(DYLang.getString("S1175", ""), self.mMinutes, self.mSeconds)
  if self.mTimeLabel then
    self.mTimeLabel:setString(str)
  else
    self.mTimeLabel = DYLabelTTF.new({
      text = str,
      size = 26,
      color = cc.c3b(84, 38, 8),
      font = GameManager.FONTNAME_TTF
    }):pos(self.mBg:getContentSize().width * 0.76, self.mBg:getContentSize().height * 0.13):addTo(self.mBg)
  end
  if self.mSchedule then
    self:stopAction(self.mSchedule)
    self.mSchedule = nil
  end
  if not CloudData.IS_SEASON_END then
    self.mSchedule = self:schedule(function()
      self:updateTime()
    end, 1)
  end
end

function M:updateTime()
  if self.mSeconds > 0 then
    self.mSeconds = self.mSeconds - 1
  elseif 0 < self.mMinutes then
    self.mSeconds = 59
    self.mMinutes = self.mMinutes - 1
  else
    self:stopAction(self.mSchedule)
    self.mSchedule = nil
  end
  local str = string.format(DYLang.getString("S1175", ""), self.mMinutes, self.mSeconds)
  self.mTimeLabel:setString(str)
end

function M:loadSeasonWinner()
  if not CloudData.IS_SEASON_END then
    return
  end
  local str = DYLang.getString("S1161", "") .. self.mSeasonWinner .. DYLang.getString("S1160", "")
  WSToast.new(str, 2.5):addTo(self, 50)
end

function M:addMsgItem()
  self.mMsgIdx = self.mMsgIdx + 1
  local idx = self.mMsgIdx
  local listView = self.mMsgList
  local item = listView:newItem()
  local content = getCompeteMsg(idx)
  item:addContent(content)
  item:setItemSize(ITEM_WIDTH, ITEM_HEIGHT)
  listView:addItem(item)
  local posY = listView.items_[idx - 1]:getPositionY()
  item:setPosition(15, posY - ITEM_HEIGHT)
  if 5 < idx then
    local moveByParams = {
      x = 0,
      y = ITEM_HEIGHT,
      time = 0.2
    }
    for k, v in pairs(listView.items_) do
      transition.moveBy(v, moveByParams)
    end
  end
end

function M:closeCallback()
  self:safeSocketRequest("CMD_LEAVE_COMPETE")
  self.mPanel:returnCallBack()
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallback()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  display.addSpriteFrames("pvp_ol/ui_pvp_match.plist", "pvp_ol/ui_pvp_match.png")
  GameManager.MODE = 0
  GameManager.IS_USER_BUSY = 0
  GameManager.IS_ON_COMPETING = true
  self:initUI()
  self:initData()
  self:checkTeam()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  GameManager.IS_ON_COMPETING = false
  self:safeSocketCancel("CMD_FIGHT")
  self:safeSocketCancel("CMD_AUTO_ADVANCED")
  self:safeSocketCancel("CMD_REFRESH_COMPETE_DATA")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

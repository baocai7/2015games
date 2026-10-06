local Tip = require("app.union.layers.LayerTip")
local DYClass = "LayerUnionBattleMatch"
local M = {}
M = class(DYClass, function()
  return display.newScene()
end)
M.ALLY = 1
M.ENEMY = 2

function M:ctor(params, callback)
  DDLOG(DYClass .. ": onCreate")
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initData(params)
  self:initUI()
  self:readyForFight()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mList = {}
  local tmp = {
    name = CloudData.USER_NAME,
    level = DYLang.getString("S1788", "") .. CloudData.USER_LEVEL,
    union_name = CloudData.UNION_INFO.name,
    icon_path = CloudData.USER_ICON,
    server_name = "",
    path = "union/battle/frame_ally.png"
  }
  local tmp1 = {
    name = "?",
    level = DYLang.getString("S1788", ""),
    union_name = DYLang.getString("S1790", ""),
    icon_path = "union/battle/mark_question.png",
    server_name = "",
    path = "union/battle/frame_enemy.png"
  }
  table.insert(self.mList, M.ALLY, tmp)
  table.insert(self.mList, M.ENEMY, tmp1)
  self.mTextList = {
    DYLang.getString("S1791", ""),
    DYLang.getString("S1792", ""),
    DYLang.getString("S1793", ""),
    DYLang.getString("S1794", ""),
    DYLang.getString("S1795", "")
  }
  self.mIdx = 0
  self.mIsMacthOK = false
end

function M:initUI()
  self.mBg = display.newSprite("union/defence/bg.jpg", display.cx, display.cy):addTo(self)
  self.mAllyFrame = M.createFrame(self.mList[M.ALLY]):pos(290, 354):addTo(self.mBg)
  self.mEnemyFrame = M.createFrame(self.mList[M.ENEMY]):pos(1000, 354):addTo(self.mBg)
  local bg = self.mBg
  local pMark = display.newSprite("union/battle/pic_vs.png"):opacity(0):scale(4):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.58):addTo(bg)
  local spawn = cc.Spawn:create(cc.FadeIn:create(0.2), cc.ScaleTo:create(0.2, 0.95))
  local seq = transition.sequence({
    cc.DelayTime:create(0.5),
    spawn,
    cc.ScaleTo:create(0.1, 1)
  })
  pMark:runAction(seq)
  local textFrame = display.newSprite("union/battle/frame_label.png"):opacity(255):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.25):addTo(bg)
  self.mMatchText = DYLabelTTF.new({
    text = "",
    size = 24,
    color = cc.c3b(255, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(textFrame:getContentSize().width * 0.5, textFrame:getContentSize().height * 0.65):addTo(textFrame)
  textFrame:runAction(transition.sequence({
    cc.DelayTime:create(0.3),
    cc.FadeIn:create(0.1)
  }))
  M.createRemindTime(60):pos(textFrame:getContentSize().width * 0.5, textFrame:getContentSize().height * 0.35):addTo(textFrame)
  self.mMatchBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }, {scale9 = true}):setButtonSize(180, 69):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1796", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1796", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.1):onButtonClicked(function()
    self:TipCancle()
  end):addTo(bg)
end

function M:readyForFight()
  self.mSchedule = self:schedule(function()
    self:updateText()
  end, 0.5)
  
  local function tFuncEvent(event)
    DDLOG(" ================ on Fight !!!!!!!")
    self.mIsMacthOK = true
    self:stopAction(self.mSchedule)
    if self.mMatchBtn then
      self.mMatchBtn:hide()
    end
    local buddhaData = event.self_data
    local enemyData = event.enemy_data
    CloudData.FIGHT_SEED = event.fight_seed
    CloudData.FIGHT_PRIORITY = event.priority
    CloudData.ALLY_INFO = {
      icon = GameManager.USER_ICON_PATH .. buddhaData.icon .. ".png",
      userName = buddhaData.nick,
      uid = buddhaData.uid,
      level = buddhaData.level,
      fight_index = event.fight_index,
      left_hp = buddhaData.m_left_hp,
      flag = buddhaData.my_position,
      server_name = buddhaData.server_name,
      clan_name = buddhaData.clan_name
    }
    CloudData.ENEMY_INFO = {
      icon = GameManager.USER_ICON_PATH .. enemyData.icon .. ".png",
      userName = enemyData.nick,
      uid = enemyData.uid,
      level = enemyData.level,
      left_hp = enemyData.m_left_hp,
      flag = enemyData.my_position,
      server_name = enemyData.server_name,
      clan_name = enemyData.clan_name
    }
    local cimeliaAtk = buddhaData.attackCimelia
    local cimeliaDef = buddhaData.defenseCimelia
    local buddhaList = buddhaData.buddhaList
    local treasureList = buddhaData.treasureList
    CloudData.UNINO_BUDDHA_CUR_TEAM = buddhaData.m_cur_team
    CloudData.BUDDHA_CIMELIA_INFO = {atkCimelia = cimeliaAtk, defCimelia = cimeliaDef}
    CloudData.BUDDHA_ATTACK_TEAM = buddhaData.attackTeam
    CloudData.BUDDHA_ASSIST_TEAM = buddhaData.helpTeam
    CloudData.BUDDHA_EQUIPMENTS = buddhaData.equipmentMap
    CloudData.BUDDHA_TREASURE_INFO = {}
    CloudData.BUDDHA_NPC_INFO = {}
    for k, v in pairs(treasureList) do
      CloudData.BUDDHA_TREASURE_INFO[tostring(v.treasureId)] = v.quality
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
    CloudData.UNINO_ENEMY_CUR_TEAM = enemyData.m_cur_team
    CloudData.ENEMY_TREASURE_INFO = {}
    CloudData.ENEMY_NPC_INFO = {}
    for k, v in pairs(treasureList) do
      CloudData.ENEMY_TREASURE_INFO[tostring(v.treasureId)] = v.quality
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
    self.mMatchText:setString("      \229\140\185\233\133\141\230\136\144\229\138\159    \n\229\141\179\229\176\134\232\191\155\229\133\165\230\136\152\230\150\151")
    self:updateEnemyInfo()
    self:performWithDelay(function()
      self:toFight(self.mMode)
    end, 3)
  end
  
  local function tFuncBossEvent(event)
    dump(event)
    DDLOG(" ================ on Boss Fight !!!!!!!")
    self.mIsMacthOK = true
    self:stopAction(self.mSchedule)
    if self.mMatchBtn then
      self.mMatchBtn:hide()
    end
    local buddhaData = event.self_data
    local enemyData = event.enemy_data
    CloudData.FIGHT_SEED = event.fight_seed
    CloudData.FIGHT_PRIORITY = event.priority
    CloudData.ALLY_INFO = {
      icon = GameManager.USER_ICON_PATH .. buddhaData.icon .. ".png",
      userName = buddhaData.nick,
      uid = buddhaData.uid,
      level = buddhaData.level,
      fight_index = event.fight_index,
      left_hp = buddhaData.m_left_hp,
      flag = buddhaData.my_position,
      server_name = buddhaData.server_name,
      clan_name = buddhaData.clan_name
    }
    local bossInfo = event.boss_info
    local bossModel = DataUtils.getUnionBossModel(tonumber(bossInfo.boss_id), bossInfo.level)
    CloudData.ENEMY_INFO = {
      icon = bossModel.npcIcon,
      userName = bossModel.npcName,
      bossId = bossInfo.boss_id,
      level = bossInfo.level,
      left_hp = bossInfo.cur_hp,
      cur_hp = bossInfo.cur_hp,
      max_hp = bossInfo.max_hp,
      flag = Const.UNION_FIGHT_DEFENCE,
      server_name = bossInfo.server_name,
      clan_name = bossInfo.clan_name
    }
    local cimeliaAtk = buddhaData.attackCimelia
    local cimeliaDef = buddhaData.defenseCimelia
    local buddhaList = buddhaData.buddhaList
    local treasureList = buddhaData.treasureList
    CloudData.UNINO_BUDDHA_CUR_TEAM = buddhaData.m_cur_team
    CloudData.BUDDHA_CIMELIA_INFO = {atkCimelia = cimeliaAtk, defCimelia = cimeliaDef}
    CloudData.BUDDHA_ATTACK_TEAM = buddhaData.attackTeam
    CloudData.BUDDHA_ASSIST_TEAM = buddhaData.helpTeam
    CloudData.BUDDHA_EQUIPMENTS = buddhaData.equipmentMap
    CloudData.BUDDHA_TREASURE_INFO = {}
    CloudData.BUDDHA_NPC_INFO = {}
    for k, v in pairs(treasureList) do
      CloudData.BUDDHA_TREASURE_INFO[tostring(v.treasureId)] = v.quality
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
    CloudData.UNINO_ENEMY_CUR_TEAM = {}
    CloudData.ENEMY_CIMELIA_INFO = {atkCimelia = cimeliaAtk, defCimelia = cimeliaDef}
    CloudData.ENEMY_TREASURE_INFO = {}
    CloudData.ENEMY_NPC_INFO = {}
    CloudData.ENEMY_EQUIPMENTS = {}
    self.mMatchText:setString("      \229\140\185\233\133\141\230\136\144\229\138\159    \n\229\141\179\229\176\134\232\191\155\229\133\165\230\136\152\230\150\151")
    self:updateEnemyInfo()
    self:performWithDelay(function()
      self:toFight(self.mMode)
    end, 3)
  end
  
  local function isMatchSuc(event)
    if event.ret_code > 0 then
      WSToast.new(event.err_msg):pos(display.cx, display.cy):addTo(self)
      if event.ret_code == 24 then
        self:performWithDelay(function()
          display.replaceScene(require("union.scenes.SceneUnionBattle").new(Const.UNION_FIGHT_END))
        end, 3)
      elseif event.ret_code == 25 then
        self:performWithDelay(function()
          display.replaceScene(require("union.scenes.SceneUnionBattleMain").new())
        end, 3)
      end
      return
    else
      self:safeSocketListen("CMD_CLAN_COMPETE_FIGHT", function(event)
        self.mMode = 1
        tFuncEvent(event)
      end, true)
      self:safeSocketListen("CMD_CLAN_COMPETE_BOSS_FIGHT", function(event)
        self.mMode = 2
        tFuncBossEvent(event)
      end, true)
    end
  end
  
  self:performWithDelay(function()
    self:safeSocketRequest("CMD_CLAN_COMPETE_FIGHT_READY", nil, isMatchSuc)
  end, 0.5)
end

function M:updateText()
  if not self.mIsMacthOK then
    self.mIdx = self.mIdx + 1
    if 6 == self.mIdx then
      self.mIdx = 1
    end
    self.mMatchText:setString(self.mTextList[self.mIdx])
    if self.mMatchBtn and not self.mMatchBtn:isVisible() then
      self.mMatchBtn:show()
    end
  else
    if self.mMatchBtn then
      self.mMatchBtn:hide()
    end
    self:stopAction(self.mSchedule)
  end
end

function M:toFight()
  GameManager.MODE = 8
  GameManager.UNION_FIGHT_MODE = self.mMode
  display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE"))
end

function M:updateEnemyInfo()
  self.mAllyFrame.server:setString(CloudData.ALLY_INFO.server_name)
  self.mEnemyFrame.icon:setTexture(CloudData.ENEMY_INFO.icon)
  self.mEnemyFrame.nick:setString(CloudData.ENEMY_INFO.userName)
  self.mEnemyFrame.level:setString(DYLang.getString("S1798", "") .. CloudData.ENEMY_INFO.level)
  self.mEnemyFrame.union:setString(CloudData.ENEMY_INFO.clan_name)
  self.mEnemyFrame.server:setString(CloudData.ENEMY_INFO.server_name)
end

function M:TipCancle()
  Tip.new(DYLang.getString("S1799", ""), function()
    self:cancelCallback()
  end):addTo(self, 50)
end

function M:cancelCallback()
  local function tFuncEvent(event)
    GameManager.IS_USER_BUSY = 0
    
    self:closeCallBack()
  end
  
  self:safeSocketRequest("CMD_CLAN_COMPETE_CANCLE_READY", nil, tFuncEvent)
end

function M.createFrame(actor)
  local frame = display.newSprite(actor.path)
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.74):addTo(frame)
  frame.icon = display.newSprite(actor.icon_path):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  frame.iconFrame = iconFrame
  frame.nick = DYLabelTTF.new({
    text = actor.name,
    size = 30,
    color = cc.c3b(255, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(190, 375):addTo(frame)
  frame.level = DYLabelTTF.new({
    text = actor.level,
    size = 30,
    color = cc.c3b(255, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(190, 265):addTo(frame)
  frame.union = DYLabelTTF.new({
    text = actor.union_name,
    size = 30,
    color = cc.c3b(255, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(190, 150):addTo(frame)
  frame.server = DYLabelTTF.new({
    text = actor.server_name,
    size = 30,
    color = cc.c3b(255, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(190, 50):addTo(frame)
  return frame
end

function M.createRemindTime(time, cb)
  local node = display.newNode()
  node.mCleanTime = 0
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
    size = 30,
    color = cc.c3b(0, 255, 6),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):addTo(node)
  
  function node:updateTime()
    node.mCleanTime = node.mCleanTime + 1
    node:coverScend(node.mCleanTime)
    node.mLabel:setString(string.format("%02d:%02d", node.mMinutes, node.mSeconds))
    if node.mCleanTime <= 0 then
      node.mCleanTime = 0
    end
  end
  
  node.mLabel:schedule(function()
    node:updateTime()
  end, 1)
  return node
end

function M.bindClickEvent(node, tFunc)
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

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      display.replaceScene(require("union.scenes.SceneUnionBattleMain").new())
    end)
  })
  self:runAction(popupLayer)
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

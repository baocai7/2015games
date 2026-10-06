local DYClass = "LayerMatchPVPOL"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
local TAG_EVENT_FIGHT = "tag_event_fight"
local TAG_READY_CANCEL = "tag_ready_cancel"
local M_TEXT1 = {
  DYLang.getString("S746", ""),
  DYLang.getString("S747", ""),
  DYLang.getString("S748", ""),
  DYLang.getString("S749", ""),
  DYLang.getString("S750", ""),
  DYLang.getString("S751", "")
}
local M_TEXT2 = {
  "1\232\189\172",
  "2\232\189\172",
  "3\232\189\172",
  "4\232\189\172",
  "5\232\189\172"
}

function M:ctor()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  GameManager.IS_USER_BUSY = 1
  self:initData()
  self:initUI()
  self:performWithDelay(function()
    self:readyForFight()
  end, 1)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  display.addSpriteFrames("pvp_ol/pvp_ol.plist", "pvp_ol/pvp_ol.png")
  self.mTextList = {
    DYLang.getString("S752", ""),
    DYLang.getString("S753", ""),
    DYLang.getString("S754", ""),
    DYLang.getString("S755", ""),
    DYLang.getString("S756", "")
  }
  self.mIdx = 0
  self.mIsMacthOK = false
end

function M:initUI()
  local bg = display.newSprite("pvp_ol/bg.png"):addTo(self.mNode)
  self.mBg = bg
  self:initBuddhaInfo()
  self:initEnemyInfo()
  if CloudData.COMPETE_MODE then
    local figheMode = {
      DYLang.getString("S757", ""),
      DYLang.getString("S758", "")
    }
    local lb = DYLabelTTF.new({
      text = figheMode[CloudData.COMPETE_MODE],
      size = 36,
      color = cc.c3b(255, 250, 0),
      font = GameManager.FONTNAME_TTF
    }):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.82):hide():addTo(bg)
    local seq = transition.sequence({
      cc.DelayTime:create(0.9),
      cc.CallFunc:create(function()
        lb:show()
      end)
    })
    lb:runAction(seq)
  end
  local pMark = display.newSprite("#vs.png"):opacity(0):scale(4):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.58):addTo(bg)
  local spawn = cc.Spawn:create(cc.FadeIn:create(0.2), cc.ScaleTo:create(0.2, 0.95))
  local seq = transition.sequence({
    cc.DelayTime:create(0.5),
    spawn,
    cc.ScaleTo:create(0.1, 1)
  })
  pMark:runAction(seq)
  local textFrame = display.newSprite("#frame.png"):opacity(0):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.25):addTo(bg)
  self.mMatchText = DYLabelTTF.new({
    text = "",
    size = 30,
    color = cc.c3b(255, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(textFrame:getContentSize().width * 0.5, textFrame:getContentSize().height * 0.5):addTo(textFrame)
  textFrame:runAction(transition.sequence({
    cc.DelayTime:create(0.3),
    cc.FadeIn:create(0.1)
  }))
  self.mMatchBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }, {scale9 = true}):setButtonSize(180, 69):hide():setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S759", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S759", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.1):onButtonClicked(function()
    self:cancelCallback()
  end):addTo(bg)
end

function M:initBuddhaInfo()
  local buddhaFrame = display.newSprite("#frame_buddha.png"):pos(-self.mBg:getContentSize().width * 0.25, self.mBg:getContentSize().height * 0.5):addTo(self.mBg, 1)
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):pos(buddhaFrame:getContentSize().width * 0.5, buddhaFrame:getContentSize().height * 0.74):addTo(buddhaFrame)
  display.newSprite(CloudData.USER_ICON):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  DYLabelTTF.new({
    text = CloudData.USER_NAME,
    size = 30,
    color = cc.c3b(255, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(buddhaFrame:getContentSize().width * 0.5, buddhaFrame:getContentSize().height * 0.595):addTo(buddhaFrame)
  local gradeData = DataUtils.getPVPGradeInfo(CloudData.GRADE_INFO.score)
  local str = M_TEXT1[gradeData.grade]
  if 0 < gradeData.level then
    str = string.format("%s%s", M_TEXT1[gradeData.grade], M_TEXT2[gradeData.level])
  end
  DYLabelTTF.new({
    text = str,
    size = 30,
    color = cc.c3b(255, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(buddhaFrame:getContentSize().width * 0.5, buddhaFrame:getContentSize().height * 0.495):addTo(buddhaFrame)
  local winCount = CloudData.GRADE_INFO.win_count
  local loseCount = CloudData.GRADE_INFO.lost_count
  local rate = 0
  if 0 < winCount + loseCount then
    rate = math.round(winCount / (winCount + loseCount) * 100)
  end
  local textStr = string.format("%d\232\131\156 %d\232\180\159 %d%%", winCount, loseCount, rate)
  DYLabelTTF.new({
    text = textStr,
    size = 30,
    color = cc.c3b(0, 255, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(buddhaFrame:getContentSize().width * 0.5, buddhaFrame:getContentSize().height * 0.385):addTo(buddhaFrame)
  for i = 1, 2 do
    local ucid = CloudData.CIMELIA_EQUIPED[i]
    local cimeliaId = CloudData.CIMELIA_LIST[ucid].cid
    local quality = CloudData.CIMELIA_LIST[ucid].quality
    local cimeliaModel = DataUtils.getCimeliaTabelForWiki(cimeliaId)
    local frame = display.newSprite(string.format("common_ui/frame%d.png", quality)):scale(0.75):align(display.CENTER_LEFT, 20, 270 - 100 * i):addTo(buddhaFrame)
    display.newSprite(cimeliaModel.icon):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
    local skillDesc = DYLabelTTF.new({
      text = cimeliaModel.skillDesc,
      size = 18,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF,
      align = cc.ui.TEXT_ALIGN_LEFT,
      dimensions = cc.size(230, 70),
      dyalign = "CENTER_LEFT"
    }):pos(frame:getPositionX() + frame:getContentSize().width * 0.8, frame:getPositionY()):addTo(buddhaFrame)
  end
  local seq = transition.sequence({
    cc.MoveBy:create(0.3, cc.p(self.mBg:getContentSize().width * 0.54, 0)),
    cc.MoveBy:create(0.1, cc.p(-self.mBg:getContentSize().width * 0.04, 0))
  })
  buddhaFrame:runAction(seq)
end

function M:initEnemyInfo()
  local enemyFrame = display.newSprite("#frame_enemy.png"):pos(self.mBg:getContentSize().width * 1.25, self.mBg:getContentSize().height * 0.5):addTo(self.mBg, 1)
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):pos(enemyFrame:getContentSize().width * 0.5, enemyFrame:getContentSize().height * 0.74):addTo(enemyFrame)
  local icon = display.newSprite("#mark_question.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  local userName = DYLabelTTF.new({
    text = "? ? ? ?",
    size = 30,
    color = cc.c3b(255, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(enemyFrame:getContentSize().width * 0.5, enemyFrame:getContentSize().height * 0.595):addTo(enemyFrame)
  local rank = DYLabelTTF.new({
    text = "? ?",
    size = 30,
    color = cc.c3b(255, 252, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(enemyFrame:getContentSize().width * 0.5, enemyFrame:getContentSize().height * 0.495):addTo(enemyFrame)
  local textStr = "?\232\131\156 ?\232\180\159 ?"
  local grade = DYLabelTTF.new({
    text = textStr,
    size = 30,
    color = cc.c3b(0, 255, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(enemyFrame:getContentSize().width * 0.5, enemyFrame:getContentSize().height * 0.385):addTo(enemyFrame)
  local cimeliaInfo = {}
  for i = 1, 2 do
    local frame = display.newSprite("common_ui/frame1.png"):scale(0.75):align(display.CENTER_LEFT, 20, 270 - 100 * i):addTo(enemyFrame)
    local icon = display.newSprite("#mark_question.png"):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
    local skillDesc = DYLabelTTF.new({
      text = "",
      size = 18,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF,
      align = cc.ui.TEXT_ALIGN_LEFT,
      dimensions = cc.size(230, 70),
      dyalign = "CENTER_LEFT"
    }):pos(frame:getPositionX() + frame:getContentSize().width * 0.8, frame:getPositionY()):addTo(enemyFrame)
    local info = {
      cimeliaFrame = frame,
      cimeliaIcon = icon,
      skillDesc = skillDesc
    }
    table.insert(cimeliaInfo, info)
  end
  self.mEnemyInfo = {
    userIcon = icon,
    userName = userName,
    rank = rank,
    grade = grade,
    cimeliaInfo = cimeliaInfo
  }
  local seq = transition.sequence({
    cc.MoveBy:create(0.3, cc.p(-self.mBg:getContentSize().width * 0.54, 0)),
    cc.MoveBy:create(0.1, cc.p(self.mBg:getContentSize().width * 0.04, 0))
  })
  enemyFrame:runAction(seq)
end

function M:readyForFight()
  self.mSchedule = self:schedule(function()
    self:updateText()
  end, 0.5)
  
  local function tFuncEvent(param)
    DDLOG(" ================ on Fight !!!!!!!")
    self.mIsMacthOK = true
    self:stopAction(self.mSchedule)
    if self.mMatchBtn then
      self.mMatchBtn:hide()
    end
    CloudData.AI_ENHANCE_PARAMS = nil
    if param.fight_type and 2 == param.fight_type then
      GameManager.MODE = 9
      CloudData.PVP_ONLINE_RESULT = param.ai_fail_data
      CloudData.AI_ENHANCE_PARAMS = param.enemy_user_data.enhance
    else
      GameManager.MODE = 6
    end
    GameManager.IS_PVPOL_RANK = 1
    local buddhaData = param.self_user_data
    local enemyData = param.enemy_user_data
    local avrLevel = 0
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
    avrLevel = CloudData.BUDDHA_NPC_INFO[tostring(buddhaData.attackTeam[1])].level
    Const.PVPOL_TOWER_HP_RATIO = math.pow(1.2, avrLevel * 0.1)
    DDLOG(DYLang.getString("S764", "") .. avrLevel)
    CloudData.BUDDHA_UNION_BOSS = buddhaData.m_boss_level
    CloudData.ENEMY_UNION_BOSS = enemyData.m_boss_level
    self:updateEnemyInfo()
    self.mMatchText:setString("      \229\140\185\233\133\141\230\136\144\229\138\159    \n\229\141\179\229\176\134\232\191\155\229\133\165\230\136\152\230\150\151")
    self:performWithDelay(function()
      display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE", "NORMAL"))
    end, 3)
    self:safeSocketCancel("CMD_CANCEL_READY")
  end
  
  self:safeSocketListen("CMD_FIGHT", tFuncEvent, true)
  self:safeSocketRequest("CMD_READY")
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

function M:updateEnemyInfo()
  self.mEnemyInfo.userIcon:setTexture(CloudData.ENEMY_INFO.icon)
  self.mEnemyInfo.userName:setString(CloudData.ENEMY_INFO.userName)
  local gradeData = DataUtils.getPVPGradeInfo(CloudData.ENEMY_INFO.pvpData.score)
  local str = M_TEXT1[gradeData.grade]
  if gradeData.level > 0 then
    str = string.format("%s%s", M_TEXT1[gradeData.grade], M_TEXT2[gradeData.level])
  end
  self.mEnemyInfo.rank:setString(str)
  local winCount = CloudData.ENEMY_INFO.pvpData.win_count
  local loseCount = CloudData.ENEMY_INFO.pvpData.lost_count
  local rate = 0
  if 0 < winCount + loseCount then
    rate = math.round(winCount / (winCount + loseCount) * 100)
  end
  local textStr = string.format("%d\232\131\156 %d\232\180\159 %d%%", winCount, loseCount, rate)
  self.mEnemyInfo.grade:setString(textStr)
  local cimeliaAtkModel = DataUtils.getCimeliaTabelForWiki(CloudData.ENEMY_CIMELIA_INFO.atkCimelia.cid)
  local cimeliaDefModel = DataUtils.getCimeliaTabelForWiki(CloudData.ENEMY_CIMELIA_INFO.defCimelia.cid)
  self.mEnemyInfo.cimeliaInfo[1].cimeliaFrame:setTexture(string.format("common_ui/frame%d.png", CloudData.ENEMY_CIMELIA_INFO.atkCimelia.quality))
  self.mEnemyInfo.cimeliaInfo[1].cimeliaIcon:setTexture(cimeliaAtkModel.icon)
  self.mEnemyInfo.cimeliaInfo[1].skillDesc:setString(cimeliaAtkModel.skillDesc)
  self.mEnemyInfo.cimeliaInfo[2].cimeliaFrame:setTexture(string.format("common_ui/frame%d.png", CloudData.ENEMY_CIMELIA_INFO.defCimelia.quality))
  self.mEnemyInfo.cimeliaInfo[2].cimeliaIcon:setTexture(cimeliaDefModel.icon)
  self.mEnemyInfo.cimeliaInfo[2].skillDesc:setString(cimeliaDefModel.skillDesc)
end

function M:cancelCallback()
  local function tFuncEvent(param)
    self:safeSocketCancel("CMD_FIGHT")
    
    GameManager.IS_USER_BUSY = 0
    if self.closeCallBack then
      self:closeCallBack()
    end
  end
  
  self:safeSocketRequest("CMD_CANCEL_READY", nil, tFuncEvent)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  GameManager.MODE = 0
  self:removeSelf()
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

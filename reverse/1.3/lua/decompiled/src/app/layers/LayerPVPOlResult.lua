local CLASS_NAME = "LayerPVPOlResult"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.WIN = 1
M.LOSE = 0
M.TYPE_PK = 1
M.TYPE_RANK = 2
M.TYPE_COMPETE = 3
M.TYPE_UNION = 4

function M:ctor()
  DYSoundMgr.stopMusic(true)
  display.addSpriteFrames("pvp_ol/ui_pvp_level.plist", "pvp_ol/ui_pvp_level.png")
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  self.mWidget = nil
  self.mPanelRoot = nil
  self.mBtnClose = nil
  self.mIsWin = checknumber(CloudData.PVP_ONLINE_RESULT.is_win)
  if checknumber(GameManager.IS_FRIEND_PK) == 1 then
    self.mType = M.TYPE_PK
  elseif GameManager.MODE == 8 then
    self.mType = M.TYPE_UNION
  elseif checknumber(GameManager.IS_PVPOL_RANK) ~= 1 then
    self.mType = M.TYPE_COMPETE
    GameManager.IS_PVPOL_RANK = 0
  else
    self.mType = M.TYPE_RANK
    GameManager.IS_PVPOL_RANK = 0
  end
  GameManager.IS_FRIEND_PK = 0
  self:layoutUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:layoutUI()
  self:addWidget()
  self:addContent()
  if self.mType == M.TYPE_RANK then
    self:refreshData()
  end
end

function M:addWidget()
  local node = self.mNode
  local widget = cc.uiloader:load("ui/LayerPVPOlResult.csb")
  widget:addTo(node)
  self.mWidget = widget
  local panelRoot = cc.uiloader:seekNodeByName(widget, "PanelRoot")
  panelRoot:setPosition(dy.p(0, 0))
  self.mPanelRoot = panelRoot
  self.mBtnClose = cc.uiloader:seekNodeByName(widget, "PanelMask")
  self.mBtnClose:addTouchEventListener(handler(self, self.closeCallBack))
  self.mBtnClose:setTouchEnabled(false)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
end

function M:addContent()
  local result = self.mIsWin
  local myTowerHpRate = checknumber(BMgrOL.getBuddhaTower():getHpRate())
  local enemyTowerHpRate = checknumber(BMgrOL.getMonsterTower():getHpRate())
  local myTag = cc.uiloader:seekNodeByName(self.mWidget, "ImageMyTag")
  local enemyTag = cc.uiloader:seekNodeByName(self.mWidget, "ImageEnemyTag")
  self.myTowerHpRate = myTowerHpRate
  if result ~= M.WIN then
    DYSoundMgr.playEffect(DY_SND.sfx_failed)
    myTag:loadTexture("pvp_ol/lose.png")
    if enemyTowerHpRate and enemyTowerHpRate == 100 then
      enemyTag:loadTexture("pvp_ol/victory.png")
    else
      enemyTag:loadTexture("pvp_ol/win.png")
    end
  else
    DYSoundMgr.playEffect(DY_SND.sfx_win)
    enemyTag:loadTexture("pvp_ol/lose.png")
    if myTowerHpRate and myTowerHpRate == 100 then
      myTag:loadTexture("pvp_ol/victory.png")
    else
      myTag:loadTexture("pvp_ol/win.png")
    end
  end
  local myIcon = cc.uiloader:seekNodeByName(self.mWidget, "ImageMyIcon")
  display.newSprite(CloudData.USER_ICON):pos(myIcon:getContentSize().width * 0.5, myIcon:getContentSize().height * 0.5):addTo(myIcon)
  local enemyIcon = cc.uiloader:seekNodeByName(self.mWidget, "ImageEnemyIcon")
  display.newSprite(CloudData.ENEMY_INFO.icon):pos(enemyIcon:getContentSize().width * 0.5, enemyIcon:getContentSize().height * 0.5):addTo(enemyIcon)
  local textMyName = cc.uiloader:seekNodeByName(self.mWidget, "TextMyName")
  if textMyName then
    textMyName:setString(CloudData.USER_NAME)
  end
  local textEnemyName = cc.uiloader:seekNodeByName(self.mWidget, "TextEnemyName")
  if textEnemyName then
    textEnemyName:setString(CloudData.ENEMY_INFO.userName)
  end
  if self.mType == M.TYPE_PK then
  elseif self.mType == M.TYPE_UNION then
    self:showUnionText()
  else
    self:showScore(CloudData.PVP_ONLINE_RESULT.pvp_data)
    self:showPvpText()
  end
  self:showAnimation()
end

function M:showUnionText()
  local battleInfo = BMgrOL.getUnionBattleCount()
  dump(battleInfo)
  local myResult = cc.uiloader:seekNodeByName(self.mWidget, "ImageMyResult")
  cc.ui.UILabel.new({
    text = checkstring(battleInfo[1].union_name),
    size = 25,
    color = cc.c3b(255, 252, 6),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 177, 130):addTo(myResult)
  local myInfo = {
    [1] = {
      str = DYLang.getString("S828", ""),
      posX = 310,
      posY = 212,
      value = checknumber(battleInfo[1][2]) .. "%"
    },
    [2] = {
      str = DYLang.getString("S829", ""),
      posX = 580,
      posY = 212,
      value = checknumber(battleInfo[2][6])
    },
    [3] = {
      str = DYLang.getString("S830", ""),
      posX = 310,
      posY = 148,
      value = checknumber(battleInfo[1][6])
    },
    [4] = {
      str = DYLang.getString("S831", ""),
      posX = 580,
      posY = 148,
      value = checknumber(battleInfo[1][4])
    }
  }
  for i = 1, #myInfo do
    local lab = cc.ui.UILabel.new({
      text = myInfo[i].str,
      size = 25,
      color = cc.c3b(255, 254, 158),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, myInfo[i].posX, myInfo[i].posY):addTo(myResult)
    cc.ui.UILabel.new({
      text = myInfo[i].value,
      size = 25,
      color = cc.c3b(255, 254, 245),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, lab:getPositionX() + lab:getContentSize().width + 10, lab:getPositionY()):addTo(myResult)
  end
  local myCoin = battleInfo[Const.FLAG_BUDDHA].mCoin
  if 0 <= myCoin then
    myCoin = "+" .. myCoin
  end
  local coinIcon = display.newSprite("union/battle/score.png"):align(display.CENTER_LEFT, 660, 275):addTo(myResult)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = myCoin,
    font = "fonts/greenNum.fnt"
  }):scale(0.7):align(display.CENTER_LEFT, 60, 23):addTo(coinIcon)
  local enemyResult = cc.uiloader:seekNodeByName(self.mWidget, "ImageEnemyResult")
  cc.ui.UILabel.new({
    text = checkstring(battleInfo[2].union_name),
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 1092, 130):addTo(enemyResult)
  local tmpLabel = battleInfo.tmpDesc or DYLang.getString("S828", "")
  local enemyInfo = {
    [1] = {
      str = tmpLabel,
      posX = 485,
      posY = 216,
      value = checknumber(battleInfo[2][2]) .. "%"
    },
    [2] = {
      str = DYLang.getString("S829", ""),
      posX = 720,
      posY = 216,
      value = checknumber(battleInfo[1][6])
    },
    [3] = {
      str = DYLang.getString("S830", ""),
      posX = 485,
      posY = 153,
      value = checknumber(battleInfo[2][6])
    },
    [4] = {
      str = DYLang.getString("S831", ""),
      posX = 720,
      posY = 153,
      value = checknumber(battleInfo[2][4])
    }
  }
  for i = 1, #enemyInfo do
    local lab = cc.ui.UILabel.new({
      text = enemyInfo[i].str,
      size = 25,
      color = cc.c3b(9, 231, 251),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, enemyInfo[i].posX, enemyInfo[i].posY):addTo(enemyResult)
    cc.ui.UILabel.new({
      text = enemyInfo[i].value,
      size = 25,
      color = cc.c3b(255, 254, 245),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, lab:getPositionX() + lab:getContentSize().width + 10, lab:getPositionY()):addTo(enemyResult)
  end
  local enemyCoin = battleInfo[Const.FLAG_MONSTER].mCoin
  if 0 <= enemyCoin then
    enemyCoin = "+" .. enemyCoin
  end
  local coinIcon = display.newSprite("union/battle/score.png"):align(display.CENTER_LEFT, 800, 275):addTo(enemyResult)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = enemyCoin,
    font = "fonts/greenNum.fnt"
  }):scale(0.7):align(display.CENTER_LEFT, 60, 23):addTo(coinIcon)
end

function M:showPvpText()
  local battleInfo = BMgrOL.GetBattleCount()
  if CloudData.PVP_ONLINE_RESULT.pvp_data then
    local gradeData = DataUtils.getPVPGradeInfo(checknumber(CloudData.PVP_ONLINE_RESULT.pvp_data.score))
    local myIcon = cc.uiloader:seekNodeByName(self.mWidget, "ImageMyIcon")
    local name = display.newSprite("#name" .. checknumber(gradeData.grade) .. ".png"):align(display.CENTER_RIGHT, 80, -45):addTo(myIcon)
    if checknumber(gradeData.level) < 6 and checknumber(gradeData.level) > 0 then
      local levelLabel = display.newSprite("#level" .. checknumber(gradeData.level) .. ".png"):align(display.CENTER_LEFT, 70, -45):addTo(myIcon)
      name:setPosition(63, -45)
    end
  end
  if CloudData.PVP_ONLINE_RESULT.enemy_pvp_data then
    local gradeData = DataUtils.getPVPGradeInfo(checknumber(CloudData.PVP_ONLINE_RESULT.enemy_pvp_data.score))
    local enemyIcon = cc.uiloader:seekNodeByName(self.mWidget, "ImageEnemyIcon")
    local name = display.newSprite("#name" .. checknumber(gradeData.grade) .. ".png"):align(display.CENTER_RIGHT, 80, -45):addTo(enemyIcon)
    if checknumber(gradeData.level) < 6 and checknumber(gradeData.level) > 0 then
      local levelLabel = display.newSprite("#level" .. checknumber(gradeData.level) .. ".png"):align(display.CENTER_LEFT, 70, -45):addTo(enemyIcon)
      name:setPosition(63, -45)
    end
  end
  local info = {
    TextMyTowerHP = checknumber(battleInfo[1][2]) .. "%",
    TextMySpiritLevel = checknumber(battleInfo[1][7]),
    TextMyCostSpirit = checknumber(battleInfo[1][3]),
    TextMyBuddhaNum = checknumber(battleInfo[1][4]),
    TextMyCimeliaHurt = checknumber(battleInfo[1][5]),
    TextMyKillNum = checknumber(battleInfo[1][6]),
    TextEnemyTowerHP = checknumber(battleInfo[2][2]) .. "%",
    TextEnemySpiritLevel = checknumber(battleInfo[2][7]),
    TextEnemyCostSpirit = checknumber(battleInfo[2][3]),
    TextEnemyBuddhaNum = checknumber(battleInfo[2][4]),
    TextEnemyCimeliaHurt = checknumber(battleInfo[2][5]),
    TextEnemyKillNum = checknumber(battleInfo[2][6])
  }
  for k, v in pairs(info) do
    local textLabel = cc.uiloader:seekNodeByName(self.mWidget, k)
    if textLabel then
      textLabel:setString(v)
    end
  end
  for i = 1, 12 do
    local textLabel = cc.uiloader:seekNodeByName(self.mWidget, "Text" .. i)
    if textLabel then
      textLabel:setVisible(true)
    end
  end
end

function M:showScore(info)
  if not (info and info.score) or self.mType ~= M.TYPE_RANK then
    return
  end
  local myScoreLabel = cc.uiloader:seekNodeByName(self.mWidget, "TextMyScoreStr")
  myScoreLabel:setVisible(true)
  local enemyScoreLabel = cc.uiloader:seekNodeByName(self.mWidget, "TextEnemyScoreStr")
  enemyScoreLabel:setVisible(true)
  local result = self.mIsWin
  local myScore = checknumber(info.score)
  local myPreScore = 0
  if CloudData.GRADE_INFO then
    myPreScore = checknumber(CloudData.GRADE_INFO.score)
  end
  local mySeriesWinAdd = checknumber(CloudData.PVP_ONLINE_RESULT.extra_add_score)
  local myAddScore = myScore - myPreScore - mySeriesWinAdd
  if 0 < myAddScore then
    myAddScore = "+" .. myAddScore
  elseif myAddScore == 0 then
    if result == M.WIN then
      myAddScore = "+" .. myAddScore
    else
      myAddScore = "-" .. myAddScore
    end
  end
  local enemyScore = checknumber(CloudData.PVP_ONLINE_RESULT.enemy_pvp_data.score)
  local enemyPreScore = checknumber(CloudData.ENEMY_INFO.pvpData.score)
  local enemySeriesWinAdd = checknumber(CloudData.PVP_ONLINE_RESULT.enemy_extra_add_score) or 0
  local enemyAddScore = enemyScore - enemyPreScore - enemySeriesWinAdd
  if 0 < enemyAddScore then
    enemyAddScore = "+" .. enemyAddScore
  elseif enemyAddScore == 0 then
    if result ~= M.WIN then
      enemyAddScore = "+" .. enemyAddScore
    else
      enemyAddScore = "-" .. enemyAddScore
    end
  end
  local info = {
    TextMyPreScore = myPreScore,
    BitmapFontLabelMyAddScore = myAddScore,
    TextEnemyPreScore = enemyPreScore,
    BitmapFontLabelEnemyAddScore = enemyAddScore
  }
  for k, v in pairs(info) do
    local textLabel = cc.uiloader:seekNodeByName(self.mWidget, k)
    if textLabel then
      textLabel:setString(v)
    end
  end
  local myResult = cc.uiloader:seekNodeByName(self.mWidget, "ImageMyResult")
  if 0 < mySeriesWinAdd then
    local winningStreak = display.newSprite(string.format("pvp_ol/winning_streak.png")):align(display.CENTER_LEFT, 560, 285):addTo(myResult)
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = "+" .. mySeriesWinAdd,
      font = "fonts/orange.fnt"
    }):align(display.CENTER_LEFT, 78, 18):addTo(winningStreak)
  end
  local myCoin = checknumber(CloudData.PVP_ONLINE_RESULT.self_add_coin)
  local enemyCoin = checknumber(CloudData.PVP_ONLINE_RESULT.enemy_add_coin)
  if 0 < myCoin then
    local coinIcon = display.newSprite("item_icon/pic_horn.png"):align(display.CENTER_LEFT, 730, 285):addTo(myResult)
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = "+" .. myCoin,
      font = "fonts/greenNum.fnt"
    }):scale(0.7):align(display.CENTER_LEFT, 60, 23):addTo(coinIcon)
  end
  local enemyResult = cc.uiloader:seekNodeByName(self.mWidget, "ImageEnemyResult")
  if 0 < enemySeriesWinAdd then
    local winningStreak = display.newSprite(string.format("pvp_ol/winning_streak.png")):align(display.CENTER_LEFT, 750, 285):addTo(enemyResult)
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = "+" .. enemySeriesWinAdd,
      font = "fonts/orange.fnt"
    }):align(display.CENTER_LEFT, 78, 18):addTo(winningStreak)
  end
  if 0 < enemyCoin then
    local coinIcon = display.newSprite("item_icon/pic_horn.png"):align(display.CENTER_LEFT, 891, 285):addTo(enemyResult)
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = "+" .. enemyCoin,
      font = "fonts/greenNum.fnt"
    }):scale(0.7):align(display.CENTER_LEFT, 60, 23):addTo(coinIcon)
  end
  local double = CloudData.PVP_ONLINE_RESULT.is_double
  if double then
    local doubleImg = display.newSprite("activity/double_tag1.png")
    if result == M.WIN then
      doubleImg:setPosition(535, 310)
      myResult:addChild(doubleImg, 2)
    else
      doubleImg:setPosition(750, 310)
      enemyResult:addChild(doubleImg, 2)
    end
  end
end

function M:refreshData()
  local info = CloudData.PVP_ONLINE_RESULT.pvp_data
  if info and self.mType == M.TYPE_RANK and CloudData.GRADE_INFO then
    CloudData.GRADE_INFO.score = checknumber(info.score)
    CloudData.GRADE_INFO.win_count = checknumber(info.win_count)
    CloudData.GRADE_INFO.lost_count = checknumber(info.lost_count)
    CloudData.GRADE_INFO.ranking = checknumber(info.ranking)
    CloudData.GRADE_INFO.unbroken_count = checknumber(info.unbroken_count)
    local addCoin = checknumber(CloudData.PVP_ONLINE_RESULT.self_add_coin)
    local myCoin = checknumber(CloudData.GAME_ITEM_INFO["7"])
    CloudData.GAME_ITEM_INFO["7"] = myCoin + addCoin
  end
end

function M:showAnimation()
  local myResult = cc.uiloader:seekNodeByName(self.mWidget, "ImageMyResult")
  myResult:runAction(transition.sequence({
    cc.MoveTo:create(0.1, cc.p(-display.cx, 170)),
    cc.ScaleTo:create(0.1, 1.05, 1),
    cc.ScaleTo:create(0.2, 1),
    cc.CallFunc:create(function()
      self.mBtnClose:setTouchEnabled(true)
    end)
  }))
  local enemyResult = cc.uiloader:seekNodeByName(self.mWidget, "ImageEnemyResult")
  enemyResult:runAction(transition.sequence({
    cc.MoveTo:create(0.1, cc.p(display.cx, -170)),
    cc.ScaleTo:create(0.1, 1.05, 1),
    cc.ScaleTo:create(0.2, 1)
  }))
  local myResultTag = cc.uiloader:seekNodeByName(self.mWidget, "ImageMyTag")
  myResultTag:runAction(transition.sequence({
    cc.DelayTime:create(0.1),
    cc.FadeIn:create(0.2)
  }))
  local enemyResultTag = cc.uiloader:seekNodeByName(self.mWidget, "ImageEnemyTag")
  enemyResultTag:runAction(transition.sequence({
    cc.DelayTime:create(0.1),
    cc.FadeIn:create(0.2)
  }))
end

function M:closeCallBack(sender, eventType)
  if eventType and eventType ~= ccui.TouchEventType.ended then
    return
  end
  DYSoundMgr.playMusic(DY_SND.bgm_theme)
  GameManager.IS_USER_BUSY = 0
  cc.Director:getInstance():getScheduler():setTimeScale(1)
  if self.mType == M.TYPE_RANK then
    display.replaceScene(require("scenes.TinyLoadingScene").new("SCENE_PVPOL_RANK"))
  elseif self.mType == M.TYPE_COMPETE then
    display.replaceScene(require("scenes.TinyLoadingScene").new("SCENE_PVPOL_COMPETE"))
  elseif self.mType == M.TYPE_UNION then
    if self.mIsWin == M.WIN and 0 < self.myTowerHpRate then
      display.replaceScene(require("scenes.TinyLoadingScene").new("SCENE_UNION_BATTLE_MATCH"))
    else
      display.replaceScene(require("scenes.TinyLoadingScene").new("SCENE_UNION_BATTLE_MAIN", {
        tag = self.mIsWin
      }))
    end
  else
    GameManager.MODE = 0
    display.replaceScene(require("scenes.TinyLoadingScene").new("CHAPTER_SCENE"))
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
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

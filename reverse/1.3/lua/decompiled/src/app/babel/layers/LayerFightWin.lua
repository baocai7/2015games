local IconItem = require("app.icons.IconItem")
local CLASS_NAME = "LayerFightWin"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  self.mKeypadListener = handler(self, self.onKeypad)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mLevel = 1
  self.mIcon = ""
  self.mName = ""
  self.mPower = 0
  self.mCurProfit = 0
  self.mMaxProfit = 0
  self.mRewardInfo = {}
  self.mSeat = ""
  self.mMySeat = ""
  GameManager.IS_BABEL_GRAB = 0
  self:initData()
  self:initBg()
  self:setNodeEventEnabled(true)
end

function M:initData()
  local info = GameManager.BABEL_ENEMY_INFO
  self.mLevel = checknumber(info.level)
  self.mIcon = checknumber(info.icon)
  self.mName = checkstring(info.nick)
  self.mPower = checknumber(info.power)
  self.mCurProfit = checknumber(info.currentIncomeCount)
  self.mMaxProfit = checknumber(info.totalIncomeCount)
  self.mRewardInfo = info.awardGain
  self.mSeat = checkstring(info.seatName)
  self.mMySeat = checkstring(CloudData.BabelInfo.seatName)
end

function M:initBg()
  local bg = display.newSprite("pvp_ol/bg_rankInfo.png"):pos(0, -20):addTo(self.mNode)
  self.mBg = bg
  local titleBg = display.newSprite("common_ui/title_frame.png"):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height - 33):addTo(self.mBg)
  display.newSprite("babel/title.png"):align(display.CENTER, titleBg:getContentSize().width * 0.5, titleBg:getContentSize().height * 0.5):addTo(titleBg)
  self:addContent()
  self:addButton()
  self:addReward()
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
  DYLabelTTF.new({
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
end

function M:addButton()
  local tipIcon = display.newSprite("babel/alert.png"):align(display.CENTER, 233, 240):addTo(self.mBg)
  local lab1 = DYLabelTTF.new({
    text = self.mName,
    size = 23,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, tipIcon:getPositionX() + 26, tipIcon:getPositionY()):addTo(self.mBg)
  local lab2 = cc.ui.UILabel.new({
    text = DYLang.getString("S113", ""),
    size = 23,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, lab1:getPositionX() + lab1:getContentSize().width + 5, lab1:getPositionY()):addTo(self.mBg)
  local lab3 = DYLabelTTF.new({
    text = self.mSeat .. DYLang.getString("S114", ""),
    size = 23,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, lab2:getPositionX() + lab2:getContentSize().width + 5, lab2:getPositionY()):addTo(self.mBg)
  local lab4 = cc.ui.UILabel.new({
    text = DYLang.getString("S115", ""),
    size = 23,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, lab3:getPositionX() + lab3:getContentSize().width + 5, lab3:getPositionY()):addTo(self.mBg)
  if not self.mMySeat or self.mMySeat == "" then
    cc.ui.UILabel.new({
      UILabelType = 2,
      text = DYLang.getString("S116", ""),
      size = 22,
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, 532, 192):addTo(self.mBg)
  else
    local lab5 = cc.ui.UILabel.new({
      text = DYLang.getString("S117", ""),
      size = 23,
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_RIGHT, 532, 192):addTo(self.mBg)
    local lab6 = DYLabelTTF.new({
      text = self.mMySeat .. DYLang.getString("S114", ""),
      size = 23,
      color = cc.c3b(255, 213, 17),
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_LEFT, 540, lab5:getPositionY()):addTo(self.mBg)
    local lab7 = cc.ui.UILabel.new({
      text = DYLang.getString("S119", ""),
      size = 23,
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, lab6:getPositionX() + lab6:getContentSize().width + 5, lab6:getPositionY()):addTo(self.mBg)
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):align(display.CENTER, 310, 123):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S120", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(147, 78, 1)
  })):onButtonClicked(function()
    self:clickBtn("GRAB")
  end)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):align(display.CENTER, 775, 123):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S121", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(147, 78, 1)
  })):onButtonClicked(function()
    self:clickBtn("QUIT")
  end)
end

function M:addReward()
  display.newSprite("babel/profit_grab.png"):align(display.CENTER_LEFT, 145, 413):addTo(self.mBg)
  if not self.mRewardInfo then
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(148, 291, 730, 105),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(self.mBg)
  for k, v in pairs(self.mRewardInfo) do
    local item = list:newItem()
    local content = IconItem.new(k, v)
    content:showItemTip()
    content:setScale(0.75)
    item:addContent(content)
    item:setItemSize(117, 100)
    list:addItem(item)
  end
  list:reload()
end

function M:clickBtn(func)
  if func == "GRAB" then
    DYSoundMgr.playEffect(DY_SND.sfx_buddha_tu)
    self:getResult(2)
  elseif func == "QUIT" then
    self:getResult(1)
  end
end

function M:getResult(tag)
  local function tFuncListener(info)
    if info.errorCode > 0 then
      local errMsg = info.errorMsg or "UNKONWN"
      
      WSToast.new(errMsg):addTo(self, 20)
    else
      local award = info.data.drop or {}
      for id, num in pairs(award) do
        DataUtils.updateItemNum(id, num)
      end
      display.replaceScene(require("scenes.TinyLoadingScene").new("SCENE_BABEL"))
    end
  end
  
  local enemyTeam = GameManager.PVP_ENEMY_INFO.buddhaInfo
  local selfTeam = GameManager.PVP_BUDDHA_INFO.buddhaInfo
  local enemyTeamInfoStr = json.encode(enemyTeam)
  local selfTeamInfoStr = json.encode(selfTeam)
  local enemySword = GameManager.PVP_ENEMY_INFO.sword
  local selfSword = GameManager.PVP_BUDDHA_INFO.sword
  local enemyUid = GameManager.PVP_ENEMY_INFO.uid
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&fightResult=%s&opponentPower=%s&opponentTeam=%s&opponentUid=%s&seatId=%s&selfPower=%s&selfTeam=%s&token=%s&uid=%s", strAppSecret .. "", tag .. "", enemySword .. "", enemyTeamInfoStr .. "", enemyUid .. "", GameManager.STAGE_ID .. "", selfSword .. "", selfTeamInfoStr .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.fightResult = tag
  params.opponentPower = enemySword
  params.opponentTeam = enemyTeamInfoStr
  params.opponentUid = enemyUid
  params.seatId = GameManager.STAGE_ID
  params.selfPower = selfSword
  params.selfTeam = selfTeamInfoStr
  params.sign = crypto.md5(strSign, false)
  DYHttpMgr.babelFightResult(tFuncListener, params)
end

function M:quit()
  display.replaceScene(require("scenes.TinyLoadingScene").new("SCENE_BABEL"))
end

function M:closeCallBack()
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:quit()
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

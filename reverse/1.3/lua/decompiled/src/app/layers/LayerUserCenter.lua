local LayerChangeUserIcon = require("app.layers.LayerChangeUserIcon")
local LayerChangeUserName = require("app.layers.LayerChangeUserName")
local LayerOfCDKey = require("app.layers.LayerOfCDKey")
local LayerRecharge = require("app.layers.LayerRecharge")
local LayerToBeStronger = require("app.layers.LayerToBeStronger")
local LayerBindPhone = require("app.layers.LayerBindPhone")
local M = {}
M = class("LayerUserCenter", function()
  return display.newLayer()
end)

function M:ctor(cb)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):scale(0):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mCallback = cb
  self:initData()
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mAttackAssessment = DataUtils.getUserCountCE()
  self.mButtonTag = 1
  self.mTabBtnTable = {}
end

function M:initUI()
  self.mBg = display.newSprite("user_center/bg.png", 20, 0):addTo(self.mNode)
  self:initTabBtn()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.95, self.mBg:getContentSize().height * 0.93):addTo(self.mBg, 2)
  self:userInfoShow()
end

function M:initTabBtn()
  local M_TAB_BTN = {
    {
      normal = "user_center/btn_tab1.png",
      pressed = "user_center/btn_tab1.png",
      disabled = "user_center/btn_tab1_h.png"
    },
    {
      normal = "user_center/btn_tab2.png",
      pressed = "user_center/btn_tab2.png",
      disabled = "user_center/btn_tab2_h.png"
    },
    {
      normal = "user_center/btn_tab4.png",
      pressed = "user_center/btn_tab4.png",
      disabled = "user_center/btn_tab4_h.png"
    }
  }
  for i = 1, #M_TAB_BTN do
    local btn = cc.ui.UIPushButton.new(M_TAB_BTN[i]):onButtonClicked(function()
      self:funcChange(i)
    end):align(display.CENTER_RIGHT, 50, self.mBg:getContentSize().height * (0.9 - i * 0.15)):addTo(self.mBg, 1)
    if 1 == i then
      btn:setButtonEnabled(false)
    end
    table.insert(self.mTabBtnTable, btn)
  end
end

function M:funcChange(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mButtonTag = index
  if self.mInfoFrame then
    self.mInfoFrame:runAction(cc.RemoveSelf:create())
    self.mInfoFrame = nil
  end
  for i = 1, #self.mTabBtnTable do
    local tabBtn = self.mTabBtnTable[i]
    if index == i then
      tabBtn:setButtonEnabled(false)
    else
      tabBtn:setButtonEnabled(true)
    end
  end
  local tFunc = {
    [1] = function()
      self:userInfoShow()
    end,
    [2] = function()
      self:gameSetting()
    end,
    [3] = function()
      self:gameAbout()
    end
  }
  tFunc[index]()
end

function M:userInfoShow()
  self.mInfoFrame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(800, 400), cc.rect(40, 40, 2, 2)):opacity(0):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.52):addTo(self.mBg, 1)
  self:addTopInfo_()
  self:addMiddleInfo_()
  self:addBottomInfo_()
  self:showPhoneIcon()
end

function M:addTopInfo_()
  local frame = self.mInfoFrame
  local picFrame = display.newSprite("common_ui/frame4.png"):pos(frame:getContentSize().width * 0.1, frame:getContentSize().height * 0.8):addTo(frame)
  self.mUserIcon = display.newSprite(CloudData.USER_ICON):pos(picFrame:getContentSize().width * 0.5, picFrame:getContentSize().height * 0.5):addTo(picFrame)
  self.mUserIcon:setTouchEnabled(true)
  self.mUserIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouchIcon_(event.name, event.x, event.y)
  end)
  DYLabelTTF.new({
    text = DYLang.getString("S1015", ""),
    size = 20,
    color = cc.c3b(79, 248, 20),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(picFrame:getContentSize().width * 0.5, -picFrame:getContentSize().height * 0.12):addTo(picFrame)
  self.mUserName = cc.ui.UILabel.new({
    text = CloudData.USER_NAME,
    size = 26,
    color = cc.c3b(198, 107, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, picFrame:getPositionX() + picFrame:getContentSize().width * 0.5 + 10, picFrame:getPositionY() + 30):addTo(frame)
  self.mUIDLabel = cc.ui.UILabel.new({
    text = "UID:" .. CloudData.UID,
    size = 24,
    color = cc.c3b(198, 107, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mUserName:getPositionX(), picFrame:getPositionY() - 30):addTo(frame)
  local lv = DYLabelTTF.new({
    text = string.format("LV.%d", CloudData.USER_LEVEL),
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "RIGHT_CENTER"
  }, {}):pos(picFrame:getContentSize().width - 10, 20):addTo(picFrame)
  local barBg = display.newSprite("user_center/bar_bg.png"):align(display.CENTER_LEFT, picFrame:getPositionX() + picFrame:getContentSize().width * 0.5 + 20, frame:getContentSize().height * 0.62):addTo(frame)
  local curExp = 1
  local maxExp = 1
  local rate = 100
  if CloudData.USER_LEVEL < #DataRetainer.PLAYER_EXP_LEVEL_INFO - 1 then
    local playerExpInfo = DYCommon.getDataByTag(DataRetainer.PLAYER_EXP_LEVEL_INFO, "level", tostring(CloudData.USER_LEVEL))[1]
    if not playerExpInfo then
      DDERROR("playerExpInfo index : %d with error data", tonumber(CloudData.USER_LEVEL))
    else
      local sum = tonumber(playerExpInfo.expSum)
      maxExp = tonumber(playerExpInfo.exp)
      curExp = maxExp - (sum - CloudData.EXP)
      rate = curExp / maxExp * 100
      if rate < 0 then
        rate = 0
      elseif 100 < rate then
        rate = 100
      end
    end
  end
  local str = curExp .. " / " .. maxExp
  if maxExp == 1 then
    str = "- / -"
  end
  DYLabelTTF.new({
    UILabelType = 2,
    text = str,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  local progressTimer = cc.ProgressTimer:create(display.newSprite("user_center/bar_pro.png")):addTo(barBg)
  progressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  progressTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  progressTimer:setMidpoint(cc.p(0, 0))
  progressTimer:setBarChangeRate(cc.p(1, 0))
  progressTimer:setPercentage(rate)
  local lb = display.newSprite("user_center/label_ce.png"):align(display.CENTER_LEFT, barBg:getPositionX() + barBg:getContentSize().width + 30, barBg:getPositionY()):addTo(frame)
  DYLabelTTF.new({
    text = self.mAttackAssessment,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(lb:getContentSize().width * 0.72, lb:getContentSize().height * 0.5):addTo(lb)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1017", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
    
    local function tFuncListener(newName)
      if newName then
        self.mUserName:setString(newName)
      end
    end
    
    local pLayer = LayerChangeUserName.new(tFuncListener)
    self:addChild(pLayer, 10)
  end):align(display.CENTER, frame:getContentSize().width * 0.7, frame:getContentSize().height * 0.88):addTo(frame)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1019", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    SocketMgr:logout()
    DYSoundMgr.stopMusic()
    self:performWithDelay(function()
      DYLoginMgr.logout()
    end, 0.2)
    return
  end):align(display.CENTER, frame:getContentSize().width * 0.91, frame:getContentSize().height * 0.88):addTo(frame)
end

function M:addMiddleInfo_()
  local lb = display.newSprite("user_center/label_energy.png"):align(display.CENTER_LEFT, self.mInfoFrame:getContentSize().width * 0.05, self.mInfoFrame:getContentSize().height * 0.4):addTo(self.mInfoFrame)
  DYLabelTTF.new({
    text = string.format("%d/%d", CloudData.ENERGY, CloudData.MAX_ENERGY),
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(lb:getContentSize().width * 0.55, lb:getContentSize().height * 0.5):addTo(lb)
  local textLabel = DYLabelTTF.new({
    text = DYLang.getString("S1020", ""),
    size = 26,
    color = cc.c3b(255, 223, 10),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(self.mInfoFrame:getContentSize().width * 0.4, self.mInfoFrame:getContentSize().height * 0.4):addTo(self.mInfoFrame)
  self.mTimeLabel = DYLabelTTF.new({
    text = "00:00:00",
    size = 26,
    color = cc.c3b(20, 255, 31),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(textLabel:getPositionX() + textLabel:getContentSize().width, self.mInfoFrame:getContentSize().height * 0.4):addTo(self.mInfoFrame)
  self:tryCountDown()
end

function M:tryCountDown()
  if CloudData.ENERGY_FULL_TIME == nil then
    return
  end
  if CloudData.ENERGY >= CloudData.MAX_ENERGY then
    return
  end
  local currTime = os.time()
  local deltaTime = currTime - checknumber(GameManager.LAST_ENERGY_TIME)
  local time = CloudData.ENERGY_FULL_TIME - deltaTime
  if 0 < time then
    self:startCountDown_(time)
  end
end

function M:addBottomInfo_()
  local tFunc = {
    [1] = function()
      display.replaceScene(require("scenes.SceneStage").new())
    end,
    [2] = function()
      if CloudData.USER_LEVEL >= Const.FUNC_UNLOCK.pvp then
        display.replaceScene(require("scenes.ScenePVP").new())
      else
        local str = DYLang.getString("S1021", "") .. Const.FUNC_UNLOCK.pvp .. DYLang.getString("S1022", "")
        WSToast.new(str):addTo(self, 20)
      end
    end,
    [3] = function()
      LayerToBeStronger.new():addTo(self, 20)
    end,
    [4] = function()
      LayerOfCDKey.new():addTo(self, 20)
    end
  }
  local isCDKeyShow = DYMem.get(DY_KEY.kIsCDKeyShow, "")
  local btnText = {
    "    \230\136\145\232\166\129\229\141\135\231\186\167",
    "    \230\136\145\232\166\129\229\136\135\231\163\139",
    "      \230\136\145\232\166\129\229\143\152\229\188\186"
  }
  local btnGap = 0.3
  if isCDKeyShow == "1" then
    btnText = {
      "    \230\136\145\232\166\129\229\141\135\231\186\167",
      "    \230\136\145\232\166\129\229\136\135\231\163\139",
      "      \230\136\145\232\166\129\229\143\152\229\188\186",
      "     \230\136\145\232\166\129\229\133\145\230\141\162"
    }
    btnGap = 0.24
  end
  for i = 1, #btnText do
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }, {scale9 = true}):setButtonLabel("normal", DYLabelTTF.new({
      text = btnText[i],
      size = 24,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(143, 78, 1),
      lineWidth = 2
    })):setButtonSize(180, 69):onButtonClicked(function()
      tFunc[i]()
      local info = {
        [1] = {
          id = "usercenter_to_stage",
          lab = DYLang.getString("S1023", "")
        },
        [2] = {
          id = "usercenter_to_pvp",
          lab = DYLang.getString("S1024", "")
        },
        [3] = {
          id = "usercenter_to_strong",
          lab = DYLang.getString("S1025", "")
        },
        [4] = {
          id = "cd_key",
          lab = DYLang.getString("S1026", "")
        }
      }
      if info[i] then
      end
    end):align(display.CENTER, self.mInfoFrame:getContentSize().width * (btnGap * i - 0.1), self.mInfoFrame:getContentSize().height * 0.15):addTo(self.mInfoFrame)
    display.newSprite("user_center/mark" .. i .. ".png", -55, 0):scale(0.8):addTo(btn)
  end
end

function M:showPhoneIcon()
  if CloudData.GOT_PHONE_AWARD == 0 then
    self.mBindPhoneBtn = cc.ui.UIPushButton.new("user_center/phone.png"):onButtonPressed(function(event)
      event.target:setScale(0.9)
    end):onButtonRelease(function(event)
      event.target:setScale(1)
    end):onButtonClicked(function()
      self:clickBindPhone()
    end):align(display.CENTER, self.mInfoFrame:getContentSize().width * 0.86, self.mInfoFrame:getContentSize().height * 0.4):addTo(self.mInfoFrame)
    local str = string.format(DY_KEY.kBindPhoneNew, CloudData.UID)
    local isBindNew = DYStat.getValueInt(str, 0)
    if isBindNew == 0 then
      self.mBindPhoneBtn.newMark = display.newSprite("common_ui/red_point.png", 27, 26):addTo(self.mBindPhoneBtn)
    end
  end
end

function M:clickBindPhone()
  local str = string.format(DY_KEY.kBindPhoneNew, CloudData.UID)
  DYStat.setValueInt(str, 1)
  if self.mBindPhoneBtn and self.mBindPhoneBtn.newMark then
    self.mBindPhoneBtn.newMark:setVisible(false)
  end
  if self.mCallback then
    self.mCallback()
  end
  self:getPhone()
end

function M:getPhone()
  local userName = DYStat.getValueStr(DY_KEY.kUserName, "")
  
  local function tFuncListener(jsonTable)
    local msg = jsonTable.errorMsg
    if jsonTable.errorCode ~= 0 then
      if not msg or msg == "" then
        msg = string.format(DYLang.getString("S434", ""), jsonTable.errorCode)
      end
      WSToast.new(msg, 2):addTo(self, 20)
      return
    end
    local phone = jsonTable.data.telephone
    if phone and phone ~= "" then
      self:getPhoneAward()
    else
      LayerBindPhone.new(handler(self, self.getPhoneAward)):addTo(self, 20)
    end
  end
  
  local params = {}
  params.username = userName
  DYHttpMgr.forgetPassword(tFuncListener, params)
end

function M:getPhoneAward()
  local function tFuncListener(jsonTable)
    local msg = jsonTable.errorMsg
    
    if jsonTable.errorCode ~= 0 then
      if not msg or msg == "" then
        msg = string.format(DYLang.getString("S434", "%d"), jsonTable.errorCode)
      end
      WSToast.new(msg, 2):addTo(self, 20)
      return
    else
      self:bindSucc()
    end
  end
  
  DYHttpMgr.getPhoneAward(tFuncListener)
end

function M:bindSucc()
  CloudData.GOT_PHONE_AWARD = 1
  WSToast.new(DYLang.getString("BIND_PHONE_SUCC", ""), 2):addTo(self, 20)
  if self and self.mBindPhoneBtn then
    self.mBindPhoneBtn:runAction(cc.RemoveSelf:create())
    self.mBindPhoneBtn = nil
  end
end

function M:gameSetting()
  local musicTag = DYSoundMgr.getMusicOn()
  local soundTag = DYSoundMgr.getSoundOn()
  local msgTag = DYPushMgr.getNoticeOn()
  local friendTag = CloudData.FRIEND_ADD_TAG
  local pkTag = CloudData.FRIEND_PK_TAG
  local tagTable = {
    musicTag,
    soundTag,
    msgTag,
    friendTag,
    pkTag
  }
  local textTable = {
    DYLang.getString("S1028", ""),
    DYLang.getString("S1029", ""),
    DYLang.getString("S1030", ""),
    DYLang.getString("S1031", ""),
    DYLang.getString("S1032", "")
  }
  self.mInfoFrame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(800, 400), cc.rect(40, 40, 2, 2)):opacity(0):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.52):addTo(self.mBg, 1)
  local line = math.ceil(#textTable / 2)
  for i = 1, line do
    local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(780, 78), cc.rect(60, 35, 5, 5)):pos(self.mInfoFrame:getContentSize().width * 0.5, self.mInfoFrame:getContentSize().height * (1.05 - 0.27 * i)):addTo(self.mInfoFrame)
    local column = 2
    if i == line then
      column = (#textTable - 1) % 2 + 1
    end
    for j = 1, column do
      local index = (i - 1) * 2 + j
      cc.ui.UILabel.new({
        text = textTable[index],
        size = 30,
        color = cc.c3b(85, 55, 2),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER_LEFT, frame:getContentSize().width * (0.6 - j % 2 * 0.5), frame:getContentSize().height * 0.5):addTo(frame)
      cc.ui.UICheckBoxButton.new({
        on = "user_center/setting_open.png",
        off = "user_center/setting_close.png"
      }):align(display.CENTER, frame:getContentSize().width * (0.87 - j % 2 * 0.5), frame:getContentSize().height * 0.5):onButtonClicked(function(event)
        local tag = tagTable[index]
        tagTable[index] = not tag
        self:changeSetting(index, tagTable[index], event.target)
      end):setButtonSelected(tagTable[index]):addTo(frame)
    end
  end
end

function M:changeSetting(index, tag, target)
  local on = 0
  if tag then
    on = 1
  end
  if index == 1 then
    DYSoundMgr.setMusicOn(tag)
    if tag then
      DYSoundMgr.playMusic(DY_SND.bgm_theme)
    else
      DYSoundMgr.stopMusic(true)
    end
  elseif index == 2 then
    DYSoundMgr.setSoundOn(tag)
  elseif index == 3 then
    DYPushMgr.setNoticeOn(tag)
  elseif index == 4 then
    self:changeFriendAddTag(tag, target)
  elseif index == 5 then
    self:changeFriendPkTag(tag, target)
  end
end

function M:changeFriendAddTag(tag, target)
  target:setTouchEnabled(false)
  
  local function tFuncListener(info)
    target:setTouchEnabled(true)
    if info.errorCode ~= 0 then
      local msg = info.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      CloudData.FRIEND_ADD_TAG = tag
    end
  end
  
  local params = {}
  if tag then
    params.tag = 0
  else
    params.tag = 1
  end
  DYHttpMgr.setForbiddenAdd(tFuncListener, params)
end

function M:changeFriendPkTag(tag, target)
  target:setTouchEnabled(false)
  
  local function tFuncListener(info)
    target:setTouchEnabled(true)
    if info.errorCode ~= 0 then
      local msg = info.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      CloudData.FRIEND_PK_TAG = tag
    end
  end
  
  local params = {}
  if tag then
    params.tag = 0
  else
    params.tag = 1
  end
  DYHttpMgr.setForbiddenPk(tFuncListener, params)
end

function M:msgSetting()
  local eneygyTag1 = true
  local eneygyTag2 = false
  local eneygyTag3 = true
  local fullEnergyTag = true
  local shopRefreshTag = false
  local tagTable = {
    eneygyTag1,
    eneygyTag2,
    eneygyTag3,
    fullEnergyTag,
    shopRefreshTag
  }
  local textTable = {
    "12:00\233\162\134\229\143\150\228\189\147\229\138\155",
    "18:00\233\162\134\229\143\150\228\189\147\229\138\155",
    "21:00\233\162\134\229\143\150\228\189\147\229\138\155",
    DYLang.getString("S1038", ""),
    DYLang.getString("S1039", "")
  }
  self.mInfoFrame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(800, 400), cc.rect(40, 40, 2, 2)):opacity(0):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.52):addTo(self.mBg, 1)
  local frameTable = {}
  for i = 1, 3 do
    local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(780, 78), cc.rect(60, 35, 5, 5)):pos(self.mInfoFrame:getContentSize().width * 0.5, self.mInfoFrame:getContentSize().height * (1.05 - 0.27 * i)):addTo(self.mInfoFrame)
    table.insert(frameTable, frame)
  end
  local frame
  for i = 1, #tagTable do
    frame = frameTable[math.ceil(i / 2)]
    local tag = tagTable[i]
    cc.ui.UILabel.new({
      text = textTable[i],
      size = 25,
      color = cc.c3b(85, 55, 2),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, frame:getContentSize().width * (0.53 - i % 2 * 0.5), frame:getContentSize().height * 0.5):addTo(frame)
    cc.ui.UICheckBoxButton.new({
      on = "user_center/setting_open.png",
      off = "user_center/setting_close.png"
    }):align(display.CENTER, frame:getContentSize().width * (0.87 - i % 2 * 0.5), frame:getContentSize().height * 0.5):onButtonClicked(function()
      if tag then
        tagTable[i] = false
      else
        tagTable[i] = true
      end
    end):setButtonSelected(tag):addTo(frame)
  end
end

function M:gameAbout()
  self.mInfoFrame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(800, 400), cc.rect(40, 40, 2, 2)):opacity(0):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.52):addTo(self.mBg, 1)
  local isQQShow = DYMem.get(DY_KEY.kIsCDKeyShow, "")
  local chName = DYUtils.channelName()
  local resAbout = "user_center/pic_about.png"
  if "000255" == chName or isQQShow ~= "1" then
    resAbout = "user_center/pic_about_noqq.png"
  end
  display.newSprite(resAbout):pos(self.mInfoFrame:getContentSize().width * 0.5, self.mInfoFrame:getContentSize().height * 0.5):addTo(self.mInfoFrame)
end

function M:onTouchIcon_(event, x, y)
  if "began" == event then
    return true
  elseif "ended" == event then
    local function tFuncListener(id)
      if not id then
        return
      end
      CloudData.USER_ICON = string.format("buddha_icon/buddha%d.png", id)
      self.mUserIcon:setTexture(CloudData.USER_ICON)
      display.getRunningScene().mUserIcon:setTexture(CloudData.USER_ICON)
    end
    
    local pLayer = LayerChangeUserIcon.new(tFuncListener)
    self:addChild(pLayer, 10)
  end
end

function M:startCountDown_(time_)
  if time_ == 0 then
    self:countdownOver_()
  else
    if self.scheduleTime_ then
      return
    end
    self.mHour = math.floor(time_ / 3600)
    self.mMinutes = math.floor((time_ - self.mHour * 3600) / 60)
    self.mSeconds = math.floor(time_ - self.mHour * 3600 - self.mMinutes * 60)
    self.mTimeLabel:setString(string.format("%02d:%02d:%02d", self.mHour, self.mMinutes, self.mSeconds))
    self.scheduleTime_ = self:schedule(function()
      self:updateTime_()
    end, 1)
  end
end

function M:updateTime_()
  if self.mButtonTag ~= 1 then
    self:countdownOver_()
    return
  end
  if self.mSeconds > 0 then
    self.mSeconds = self.mSeconds - 1
  elseif 0 < self.mMinutes then
    self.mSeconds = 59
    self.mMinutes = self.mMinutes - 1
  elseif 0 < self.mHour then
    self.mSeconds = 59
    self.mMinutes = 59
    self.mHour = self.mHour - 1
  else
    self:countdownOver_()
  end
  self.mTimeLabel:setString(string.format("%02d:%02d:%02d", self.mHour, self.mMinutes, self.mSeconds))
end

function M:countdownOver_()
  self:stopAction(self.scheduleTime_)
  self.scheduleTime_ = nil
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.mNode:runAction(popupLayer)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:onNotify(tag, param)
  if tag == DY_KEY.kCloudDataUpdated then
    self:tryCountDown()
  end
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
  DYNotification.registerScriptObserver(self, handler(self, self.onNotify), DY_KEY.kCloudDataUpdated)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYNotification.removeAllObservers(self)
end

return M

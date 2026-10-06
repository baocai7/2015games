local M = {}
M = class("PanelMember", function()
  return display.newNode()
end)
M.EVENT_CHAT = 1
M.EVENT_PK = 2
M.EVENT_TEAM = 3
M.EVENT_APPOINT = 4
M.EVENT_DISMISS = 5
M.EVENT_ABDICATE = 6
M.EVENT_RESIGN = 7
M.EVENT_EXPEL = 8
M.EVENT_QUIT = 9

local function getTimeStr(time)
  local str = ""
  local day = math.floor(time / 86400)
  if 7 < day then
    str = DYLang.getString("S1731", "")
    return str
  elseif 0 < day then
    str = DYLang.getString("S1732", "") .. day .. DYLang.getString("S1733", "")
    return str
  end
  local hour = math.floor(time / 3600)
  if 0 < hour then
    str = DYLang.getString("S1732", "") .. hour .. DYLang.getString("S1735", "")
    return str
  end
  local minutes = math.floor(time / 60)
  if 0 < minutes then
    str = DYLang.getString("S1732", "") .. minutes .. DYLang.getString("S1737", "")
    return str
  end
  str = DYLang.getString("S1738", "")
  return str
end

function M:ctor(target, params, callback)
  self.mParent = target
  self.mCallback = callback
  self:initData(params)
  self:initUI()
end

function M:initData(params)
  self.mInfo = params
  self.mIsAppoint = false
  self.mIsDelate = false
  if CloudData.UID == tonumber(self.mInfo.uid) then
    self.mInfo.rank = CloudData.UNION_POS
    self.mInfo.contribution = CloudData.UNION_SELF_INFO.clan_contribution
  end
  local tFunc = {
    [1] = function()
      if CloudData.UID == tonumber(self.mInfo.uid) then
        self.mIsDelate = true
      end
    end,
    [2] = function()
      if CloudData.UID == tonumber(self.mInfo.uid) then
        self.mIsAppoint = true
        self.mIsDelate = true
      end
      if 1 == self.mInfo.rank then
        self.mIsDelate = true
      end
    end,
    [3] = function()
      if self.mInfo.rank < 3 then
        self.mIsAppoint = true
        self.mIsDelate = true
      end
    end
  }
  tFunc[CloudData.UNION_POS]()
end

function M:initUI()
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(940, 140), cc.rect(40, 40, 2, 2)):addTo(self)
  self.mBg = bg
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):scale(0.8):align(display.CENTER_LEFT, 32, bg:getContentSize().height * 0.4):addTo(bg)
  local icon = display.newSprite(GameManager.USER_ICON_PATH .. self.mInfo.icon .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  DYLabelTTF.new({
    text = "LV." .. self.mInfo.level,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {}):pos(iconFrame:getContentSize().width - 10, 20):addTo(iconFrame)
  if 0 < self.mInfo.vip then
    local vipFrame = display.newSprite("ranking/bg_vip.png"):align(display.CENTER_RIGHT, iconFrame:getContentSize().width - 5, iconFrame:getContentSize().height - 12):addTo(iconFrame)
    DYLabelTTF.new({
      text = string.format("%d", self.mInfo.vip),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(111, 47, 2)
    }):pos(vipFrame:getContentSize().width * 0.72, vipFrame:getContentSize().height * 0.32):addTo(vipFrame)
  end
  local stateLabel = DYLabelTTF.new({
    text = DYLang.getString("S1739", ""),
    size = 28,
    color = cc.c3b(0, 169, 32),
    font = GameManager.FONTNAME_TTF
  }):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height + 23):addTo(iconFrame)
  if 0 == self.mInfo.online then
    local time = self.mInfo.offline_time / 1000
    local textStr = getTimeStr(time)
    stateLabel:setString(textStr)
    stateLabel:setColor(cc.c3b(120, 120, 120))
  end
  self:loadMemberInfo()
  self:loadFuncBtn()
end

function M:loadMemberInfo()
  DYLabelTTF.new({
    text = self.mInfo.nick,
    size = 22,
    color = cc.c3b(67, 38, 1),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(160, 115):addTo(self.mBg)
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S1740", ""),
    size = 22,
    color = cc.c3b(67, 38, 1),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(325, 115):addTo(self.mBg)
  DYLabelTTF.new({
    text = self.mInfo.power,
    size = 22,
    color = cc.c3b(169, 108, 28),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb:getPositionX() + lb:getContentSize().width, 115):addTo(self.mBg)
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S1741", ""),
    size = 22,
    color = cc.c3b(67, 38, 1),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(520, 115):addTo(self.mBg)
  DYLabelTTF.new({
    text = self.mInfo.contribution,
    size = 22,
    color = cc.c3b(169, 108, 28),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb:getPositionX() + lb:getContentSize().width, 115):addTo(self.mBg)
  local strs = {
    DYLang.getString("S1742", ""),
    DYLang.getString("S1743", ""),
    DYLang.getString("S1744", "")
  }
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S1745", ""),
    size = 22,
    color = cc.c3b(67, 38, 1),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(720, 115):addTo(self.mBg)
  DYLabelTTF.new({
    text = strs[self.mInfo.rank],
    size = 22,
    color = cc.c3b(169, 108, 28),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb:getPositionX() + lb:getContentSize().width, 115):addTo(self.mBg)
end

function M:loadFuncBtn()
  local btns = {
    "union/btn_chat.png",
    "friends/btn_fight.png",
    "union/btn_team.png"
  }
  for i = 1, #btns do
    local btn = cc.ui.UIPushButton.new({
      normal = btns[i],
      pressed = btns[i]
    }):pos(60 + 155 * i, 50):onButtonPressed(function(event)
      event.target:setScale(0.9)
    end):onButtonRelease(function(event)
      event.target:setScale(1)
    end):onButtonClicked(function()
      self.mCallback(i, self.mInfo)
    end):addTo(self.mBg)
  end
  local appointBtn = cc.ui.UIPushButton.new({
    normal = "union/btn_appoint.png",
    disabled = "union/btn_appoint1.png"
  }):pos(680, 50):setButtonEnabled(self.mIsAppoint):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:appointCallback()
  end):addTo(self.mBg)
  local deleteBtn = cc.ui.UIPushButton.new({
    normal = "union/bnt_delete.png",
    disabled = "union/bnt_delete1.png"
  }):pos(835, 50):setButtonEnabled(self.mIsDelate):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:deleteCallback()
  end):addTo(self.mBg)
end

function M:appointCallback()
  if 2 == CloudData.UNION_POS then
    self.mCallback(M.EVENT_RESIGN, self.mInfo)
    return
  end
  if self.mParent.node then
    self.mParent.node:runAction(cc.RemoveSelf:create())
    self.mParent.node = nil
  end
  local pNode = display.newNode():addTo(self.mBg, 2)
  pNode:setPosition(470, 70)
  pNode:setAnchorPoint(0.5, 0.5)
  pNode:setContentSize(940, 140)
  pNode:setTouchEnabled(true)
  pNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      pNode:runAction(cc.RemoveSelf:create())
      self.mParent.node = nil
      return true
    end
  end)
  self.mParent.node = pNode
  local btnText = DYLang.getString("S1746", "")
  
  local function tFunc()
    self.mCallback(M.EVENT_APPOINT, self.mInfo)
  end
  
  if 2 == self.mInfo.rank then
    btnText = DYLang.getString("S1747", "")
    
    function tFunc()
      self.mCallback(M.EVENT_DISMISS, self.mInfo)
    end
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1748", ""),
    size = 27,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):onButtonClicked(function()
    self.mCallback(M.EVENT_ABDICATE, self.mInfo)
  end):align(display.CENTER, 680, pNode:getContentSize().height * 0.75):addTo(pNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = btnText,
    size = 27,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):onButtonClicked(function()
    tFunc()
  end):align(display.CENTER, 680, pNode:getContentSize().height * 0.25):addTo(pNode)
end

function M:deleteCallback()
  local tFunc = {
    [1] = function()
      self.mCallback(M.EVENT_QUIT, self.mInfo)
    end,
    [2] = function()
      if CloudData.UID == tonumber(self.mInfo.uid) then
        self.mCallback(M.EVENT_QUIT, self.mInfo)
      else
        self.mCallback(M.EVENT_EXPEL, self.mInfo)
      end
    end,
    [3] = function()
      self.mCallback(M.EVENT_EXPEL, self.mInfo)
    end
  }
  tFunc[CloudData.UNION_POS]()
end

return M

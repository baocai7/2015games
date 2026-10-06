local M = {}
M = class("IconLog", function()
  return display.newNode()
end)

function M:ctor(params)
  self.mIndex = params.index
  self.mInfo = params.info or {}
  self.cb = params.cb
  self.mId = 0
  self.mIsWin = 0
  self.mSelfIcon = ""
  self.mSelfLevel = 0
  self.mSelfName = ""
  self.mTargetIcon = ""
  self.mTargetLevel = 0
  self.mTargetName = ""
  self.mIsAttacking = 0
  self.mFightTime = 0
  self:initData()
  self:initUI()
end

function M:initData()
  self.mId = self.mInfo.id
  self.mFightTime = checknumber(self.mInfo.time) - checknumber(self.mInfo.fightTime)
  local myTag = "self"
  local enemyTag = "opponent"
  self.mIsAttacking = 1
  self.mIsWin = checknumber(self.mInfo.win)
  if checknumber(self.mInfo.selfUid) ~= CloudData.UID then
    myTag = "opponent"
    enemyTag = "self"
    self.mIsAttacking = 0
    self.mIsWin = (self.mIsWin + 1) % 2
  end
  self.mSelfIcon = checkstring(self.mInfo[myTag .. "Icon"])
  self.mSelfLevel = checknumber(self.mInfo[myTag .. "Level"])
  self.mSelfName = checkstring(self.mInfo[myTag .. "Name"])
  self.mTargetIcon = checkstring(self.mInfo[enemyTag .. "Icon"])
  self.mTargetLevel = checknumber(self.mInfo[enemyTag .. "Level"])
  self.mTargetName = checkstring(self.mInfo[enemyTag .. "Name"])
end

local function getTime(time)
  if not time or time < 0 then
    return ""
  end
  local day = math.floor(time / 86400)
  time = time % 86400
  local hour = math.floor(time / 3600)
  if 0 < day then
    local str = day .. DYLang.getString("S96", "")
    return str
  elseif 0 < hour then
    local str = hour .. DYLang.getString("S97", "")
    return str
  else
    local minutes = math.floor(time / 60)
    if 0 < minutes then
      local str = minutes .. DYLang.getString("S98", "")
      return str
    else
      return "1\229\136\134\233\146\159\229\134\133"
    end
  end
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(876, 168), cc.rect(45, 45, 2, 2)):addTo(self)
  local img = "pvp/win.png"
  if self.mIsWin == 0 then
    img = "pvp/lose.png"
  end
  display.newSprite(img):align(display.LEFT_TOP, 15, bg:getContentSize().height):addTo(bg)
  local myIcon = display.newSprite("common_ui/frame3.png", 346, bg:getContentSize().height * 0.6):scale(0.9):addTo(bg)
  if self.mSelfIcon ~= "" then
    display.newSprite(GameManager.USER_ICON_PATH .. self.mSelfIcon .. ".png"):pos(myIcon:getContentSize().width * 0.5, myIcon:getContentSize().height * 0.5):addTo(myIcon)
  end
  local myLevel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "LV." .. self.mSelfLevel,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.BOTTOM_RIGHT, myIcon:getContentSize().width * 0.98, myIcon:getContentSize().height * 0.05):addTo(myIcon, 1)
  myLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = self.mSelfName,
    size = 22,
    color = cc.c3b(53, 26, 3),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_TOP, myIcon:getContentSize().width * 0.5, -10):addTo(myIcon)
  local opponentIcon = display.newSprite("common_ui/frame3.png", 627, bg:getContentSize().height * 0.6):scale(0.9):addTo(bg)
  if self.mTargetIcon ~= "" then
    display.newSprite(GameManager.USER_ICON_PATH .. self.mTargetIcon .. ".png"):pos(opponentIcon:getContentSize().width * 0.5, opponentIcon:getContentSize().height * 0.5):addTo(opponentIcon)
  end
  local opponentLevel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "LV." .. self.mTargetLevel,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.BOTTOM_RIGHT, opponentIcon:getContentSize().width * 0.98, opponentIcon:getContentSize().height * 0.05):addTo(opponentIcon)
  opponentLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = self.mTargetName,
    size = 22,
    color = cc.c3b(53, 26, 3),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_TOP, opponentIcon:getContentSize().width * 0.5, -10):addTo(opponentIcon)
  local vsImg = "pvp/vs_left.png"
  if self.mIsAttacking == 1 then
    vsImg = "pvp/vs_right.png"
  end
  local vsIcon = display.newSprite(vsImg):pos(488, bg:getContentSize().height * 0.5):addTo(bg)
  local str = getTime(self.mFightTime)
  DYLabelTTF.new({
    text = str,
    size = 22,
    color = cc.c3b(232, 200, 163),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, 488, 28):addTo(bg)
  local detailBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):onButtonPressed(function()
    self:showDetail()
  end):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S99", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, 783, bg:getContentSize().height * 0.5):addTo(bg)
end

function M:showDetail()
  if self.cb then
    self.cb(checknumber(self.mIndex))
  end
end

return M

local M = {}
M = class("IconRank", function()
  return display.newNode()
end)

function M:ctor(params)
  self.mIndex = params.index
  self.mInfo = params.info or {}
  self.cb = params.cb
  self.mIcon = ""
  self.mLevel = 0
  self.mName = ""
  self.mPower = 0
  self.mSeat = ""
  self:initData()
  self:initUI()
end

function M:initData()
  self.mSeat = checkstring(self.mInfo.name)
  if self.mInfo.icon then
    self.mIcon = checkstring(self.mInfo.icon)
    self.mLevel = checknumber(self.mInfo.level)
    self.mName = checkstring(self.mInfo.nick)
    self.mPower = checknumber(self.mInfo.power)
  end
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(876, 168), cc.rect(45, 45, 2, 2)):addTo(self)
  self.mBg = bg
  if self.mIndex < 4 and 0 < self.mIndex then
    display.newSprite("ranking/rank" .. self.mIndex .. ".png"):align(display.CENTER, 61, 84):addTo(bg)
  else
    cc.ui.UILabel.new({
      UILabelType = 2,
      text = self.mIndex,
      size = 30,
      color = cc.c3b(101, 58, 8),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, 61, 84):addTo(bg)
  end
  DYLabelTTF.new({
    text = "\227\128\144" .. self.mSeat .. "\227\128\145",
    size = 30,
    color = cc.c3b(255, 210, 0),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, 598, 84):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):onButtonPressed(function()
    self:showDetail()
  end):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S100", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, 783, 84):addTo(bg)
  self:addContent()
end

function M:addContent()
  if self.mIcon == "" then
    display.newSprite("babel/tip.png"):scale(0.6069651741293532, 0.609375):pos(305, 84):addTo(self.mBg)
    return
  end
  local icon = display.newSprite("common_ui/frame3.png", 188, 84):addTo(self.mBg)
  if self.mIcon ~= "" then
    display.newSprite(GameManager.USER_ICON_PATH .. self.mIcon .. ".png"):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):addTo(icon)
  end
  local myLevel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "LV." .. self.mLevel,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.BOTTOM_RIGHT, icon:getContentSize().width * 0.98, icon:getContentSize().height * 0.05):addTo(icon, 1)
  myLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  DYLabelTTF.new({
    text = self.mName,
    size = 25,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 261, 117):addTo(self.mBg)
  local swordBg = display.newSprite("pvp/sword.png"):align(display.CENTER_LEFT, 261, 64):addTo(self.mBg)
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
end

function M:showDetail()
  if self.cb then
    self.cb(checknumber(self.mIndex))
  end
end

return M

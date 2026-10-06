local M = {}
M = class("IconBooty", function()
  return display.newNode()
end)

function M:ctor(params)
  self.mInfo = params.info
  if not self.mInfo then
    return
  end
  self.mIndex = checknumber(params.index)
  self.cb = params.cb
  self.mBoxLabel = nil
  self:initUI()
  self:adddListener()
end

function M:initUI()
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(638, 126), cc.rect(30, 30, 1, 1)):addTo(self)
  self.mBg = bg
  if self.mIndex < 4 then
    display.newSprite("ranking/rank" .. self.mIndex .. ".png"):align(display.CENTER, 56, 65):addTo(bg)
  else
    cc.ui.UILabel.new({
      text = self.mIndex,
      color = cc.c3b(138, 91, 1),
      size = 30,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 56, 65):addTo(bg)
  end
  local iconFrame = display.newSprite("common_ui/frame4.png"):scale(0.7):pos(150, 65):addTo(bg)
  if checkstring(self.mInfo.icon) ~= "" then
    display.newSprite(GameManager.USER_ICON_PATH .. self.mInfo.icon .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  end
  DYLabelTTF.new({
    text = "LV." .. checknumber(self.mInfo.level),
    size = 26,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "BOTTOM_RIGHT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(iconFrame:getContentSize().width * 0.98, iconFrame:getContentSize().height * 0.05):addTo(iconFrame, 1)
  if 0 < checknumber(self.mInfo.vip) then
    local vipFrame = display.newSprite("ranking/bg_vip.png"):align(display.CENTER_RIGHT, iconFrame:getContentSize().width, iconFrame:getContentSize().height):addTo(iconFrame)
    DYLabelTTF.new({
      text = self.mInfo.vip,
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(111, 47, 2)
    }):pos(vipFrame:getContentSize().width * 0.72, vipFrame:getContentSize().height * 0.32):addTo(vipFrame)
  end
  DYLabelTTF.new({
    text = self.mInfo.nick,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(195, 65):addTo(bg)
  DYLabelTTF.new({
    text = DYLang.getString("S1599", ""),
    size = 20,
    color = cc.c3b(255, 221, 26),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(420, 65):addTo(bg)
  DYLabelTTF.new({
    text = self.mInfo.score,
    size = 25,
    color = cc.c3b(73, 251, 11),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(423, 65):addTo(bg)
  local box = display.newSprite("union/battle/box_booty.png"):pos(565, 65):addTo(bg)
  self.mBoxLabel = DYLabelTTF.new({
    text = "X" .. checknumber(self.mInfo.box_count),
    size = 22,
    color = cc.c3b(73, 251, 11),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(63, 25):addTo(box)
end

function M:adddListener()
  local pos = {x = 0, y = 0}
  self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      pos.x = x
      pos.y = y
      return true
    elseif name == "ended" and math.abs(x - pos.x) < 40 and math.abs(y - pos.y) < 40 and self.cb then
      self.cb(self.mIndex)
    end
  end)
  self:setTouchEnabled(true)
  self:setTouchSwallowEnabled(false)
end

function M:updateBoxNum(num)
  print("num = " .. num)
  self.mBoxLabel:setString("X" .. num)
end

return M

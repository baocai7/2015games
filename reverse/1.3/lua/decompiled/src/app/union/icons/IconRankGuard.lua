local M = {}
M = class("IconRankGuard", function()
  return display.newNode()
end)

function M:ctor(params)
  self.mInfo = params
  if not self.mInfo then
    return
  end
  if checknumber(self.mInfo.tag) == 0 then
    self:initUI()
  else
    self:initMyRank()
  end
end

function M:initUI()
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(800, 125), cc.rect(30, 30, 1, 1)):addTo(self)
  self.mBg = bg
  local no = checknumber(self.mInfo.index)
  if no < 4 and 0 < no then
    display.newSprite(string.format("ranking/rank%d.png", no)):pos(78, 60):addTo(bg)
  else
    local lb = cc.ui.UILabel.new({
      text = no,
      size = 36,
      color = cc.c3b(101, 58, 8),
      font = GameManager.FONTNAME_TTF
    }):pos(78, 60):addTo(bg)
  end
  local iconFrame = display.newSprite("common_ui/frame4.png"):scale(0.7):pos(170, 60):addTo(bg)
  local icon = checkstring(self.mInfo.icon)
  if icon ~= "" then
    display.newSprite(GameManager.USER_ICON_PATH .. icon .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  end
  local playerNameLabel = cc.ui.UILabel.new({
    text = checkstring(self.mInfo.nick),
    size = 22,
    color = cc.c3b(101, 58, 8),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 220, 84):addTo(bg)
  local colorTb = {
    cc.c3b(255, 44, 233),
    cc.c3b(241, 21, 21),
    cc.c3b(36, 19, 255)
  }
  if no < 4 then
    playerNameLabel:setColor(colorTb[no])
  end
  cc.ui.UILabel.new({
    text = "LV." .. checknumber(self.mInfo.level),
    size = 22,
    color = cc.c3b(101, 58, 8),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 220, 37):addTo(bg)
  DYLabelTTF.new({
    text = DYLang.getString("S1604", ""),
    size = 25,
    color = cc.c3b(255, 221, 26),
    dyalign = "CENTER_RIGHT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_RIGHT, 460, 60):addTo(bg)
  DYLabelTTF.new({
    text = checknumber(self.mInfo.score),
    size = 25,
    color = cc.c3b(73, 251, 11),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 465, 60):addTo(bg)
end

function M:initMyRank()
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(800, 125), cc.rect(30, 30, 1, 1)):addTo(self)
  self.mBg = bg
  local no = checknumber(self.mInfo.index)
  if no < 4 and 0 < no then
    display.newSprite(string.format("ranking/rank%d.png", no)):pos(78, 60):addTo(bg)
  else
    local lb = cc.ui.UILabel.new({
      text = no,
      size = 36,
      color = cc.c3b(101, 58, 8),
      font = GameManager.FONTNAME_TTF
    }):pos(78, 60):addTo(bg)
  end
  local iconFrame = display.newSprite("common_ui/frame4.png"):scale(0.85):pos(90, 60):addTo(bg)
  display.newSprite(CloudData.USER_ICON):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  local playerNameLabel = cc.ui.UILabel.new({
    text = CloudData.USER_NAME,
    size = 22,
    color = cc.c3b(87, 35, 4),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 160, 84):addTo(bg)
  cc.ui.UILabel.new({
    text = "LV." .. CloudData.USER_LEVEL,
    size = 22,
    color = cc.c3b(87, 35, 4),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 160, 37):addTo(bg)
  DYLabelTTF.new({
    text = checkstring(CloudData.UNION_INFO.name),
    size = 25,
    color = cc.c3b(255, 221, 26),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 333, 84):addTo(bg)
  DYLabelTTF.new({
    text = DYLang.getString("S1604", ""),
    size = 25,
    color = cc.c3b(255, 221, 26),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 333, 33):addTo(bg)
  DYLabelTTF.new({
    text = checknumber(self.mInfo.score),
    size = 25,
    color = cc.c3b(73, 251, 11),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 409, 33):addTo(bg)
  DYLabelTTF.new({
    text = DYLang.getString("S1606", ""),
    size = 25,
    color = cc.c3b(255, 221, 26),
    dyalign = "CENTER_RIGHT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_RIGHT, 685, 33):addTo(bg)
  local rank = checknumber(self.mInfo.index)
  if rank == 0 then
    rank = DYLang.getString("S1607", "")
  end
  DYLabelTTF.new({
    text = rank,
    size = 25,
    color = cc.c3b(73, 251, 11),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 690, 33):addTo(bg)
end

return M

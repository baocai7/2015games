local M = {}
M = class("IconRankAttack", function()
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
  local icon = checkstring(self.mInfo.leader_icon)
  if icon ~= "" then
    display.newSprite(GameManager.USER_ICON_PATH .. icon .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  end
  DYLabelTTF.new({
    text = checkstring(self.mInfo.clan_name),
    size = 25,
    color = cc.c3b(255, 221, 26),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 230, 83):addTo(bg)
  DYLabelTTF.new({
    text = "LV." .. checknumber(self.mInfo.level),
    size = 22,
    color = cc.c3b(255, 221, 26),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 230, 40):addTo(bg)
  DYLabelTTF.new({
    text = DYLang.getString("S1600", ""),
    size = 25,
    color = cc.c3b(255, 221, 26),
    dyalign = "CENTER_RIGHT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_RIGHT, 490, 60):addTo(bg)
  DYLabelTTF.new({
    text = checknumber(self.mInfo.score),
    size = 25,
    color = cc.c3b(73, 251, 11),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 495, 60):addTo(bg)
  DYLabelTTF.new({
    text = "\227\128\144" .. checkstring(self.mInfo.server_name) .. "\227\128\145",
    size = 25,
    color = cc.c3b(119, 219, 252),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, 725, 60):addTo(bg)
end

function M:initMyRank()
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(800, 125), cc.rect(30, 30, 1, 1)):addTo(self)
  self.mBg = bg
  DYLabelTTF.new({
    text = checkstring(self.mInfo.clan_name),
    size = 25,
    color = cc.c3b(255, 221, 26),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 100, 84):addTo(bg)
  DYLabelTTF.new({
    text = DYLang.getString("S1600", ""),
    size = 25,
    color = cc.c3b(255, 221, 26),
    dyalign = "CENTER_RIGHT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_RIGHT, 420, 33):addTo(bg)
  DYLabelTTF.new({
    text = checknumber(self.mInfo.score),
    size = 25,
    color = cc.c3b(73, 251, 11),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 425, 33):addTo(bg)
  DYLabelTTF.new({
    text = DYLang.getString("S1602", ""),
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
    rank = DYLang.getString("S1603", "")
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
  DYLabelTTF.new({
    text = "\227\128\144" .. checkstring(self.mInfo.server_name) .. "\227\128\145",
    size = 22,
    color = cc.c3b(119, 219, 252),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):pos(95, 37):addTo(bg)
end

return M

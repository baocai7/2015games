local M = {}
M = class("RoundListIcon", function()
  return display.newNode()
end)

function M:ctor(rankInfo, type)
  self:initData(rankInfo, type)
  self:initUI()
end

function M:initData(rankInfo, type)
  self.mType = type
  self.mRalatedTable = {
    DYLang.getString("S78", ""),
    DYLang.getString("S79", ""),
    DYLang.getString("S78", ""),
    DYLang.getString("S81", ""),
    DYLang.getString("S82", "")
  }
  local textStr = ""
  local tFunc = {
    [1] = rankInfo.power,
    [2] = rankInfo.level,
    [3] = rankInfo.power,
    [4] = rankInfo.star
  }
  if 5 == self.mType then
    textStr = string.format(DYLang.getString("S83", ""), rankInfo.stage, rankInfo.wave)
  else
    textStr = tFunc[self.mType]
  end
  self.mRankingNum = rankInfo.rank
  self.mPlayerName = rankInfo.nick
  self.mPlayerLevel = rankInfo.level
  self.mPlayerVipLevel = rankInfo.vip
  self.mPlayerRalatedData = textStr
  self.mPlayerTemaInfo = rankInfo.team
  self.mPlayerIcon = GameManager.USER_ICON_PATH .. rankInfo.icon .. ".png"
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(767, 108), cc.rect(40, 40, 2, 2)):addTo(self)
  if self.mRankingNum < 4 then
    display.newSprite(string.format("ranking/rank%d.png", self.mRankingNum)):pos(bg:getContentSize().width * 0.07, bg:getContentSize().height * 0.5):addTo(bg)
  else
    local lb = cc.ui.UILabel.new({
      text = self.mRankingNum,
      size = 36,
      color = cc.c3b(101, 58, 8),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, bg:getContentSize().width * 0.06, bg:getContentSize().height * 0.5):addTo(bg)
    if 4 == self.mRankingNum then
      lb:setString(self.mRankingNum .. "th")
    end
  end
  local iconFrame = display.newSprite("common_ui/frame4.png"):scale(0.7):pos(bg:getContentSize().width * 0.19, bg:getContentSize().height * 0.5):addTo(bg)
  local playerIocn = display.newSprite(self.mPlayerIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 < self.mPlayerVipLevel then
    local vipFrame = display.newSprite("ranking/bg_vip.png"):align(display.CENTER_RIGHT, iconFrame:getContentSize().width, iconFrame:getContentSize().height):addTo(iconFrame)
    DYLabelTTF.new({
      text = string.format("%d", self.mPlayerVipLevel),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(111, 47, 2)
    }):pos(vipFrame:getContentSize().width * 0.72, vipFrame:getContentSize().height * 0.32):addTo(vipFrame)
  end
  local playerNameLabel = cc.ui.UILabel.new({
    text = self.mPlayerName,
    size = 22,
    color = cc.c3b(101, 58, 8),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.72):addTo(bg)
  local colorTb = {
    cc.c3b(255, 44, 233),
    cc.c3b(241, 21, 21),
    cc.c3b(36, 19, 255)
  }
  if self.mRankingNum < 4 then
    playerNameLabel:setColor(colorTb[self.mRankingNum])
  end
  if 2 ~= self.mType then
    cc.ui.UILabel.new({
      text = string.format("LV.%d", self.mPlayerLevel),
      size = 22,
      color = cc.c3b(101, 58, 8),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.28):addTo(bg)
  end
  local lb = DYLabelTTF.new({
    text = self.mRalatedTable[self.mType],
    size = 24,
    color = cc.c3b(17, 236, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(bg:getContentSize().width * 0.48, bg:getContentSize().height * 0.5):addTo(bg)
  DYLabelTTF.new({
    text = self.mPlayerRalatedData,
    size = 24,
    color = cc.c3b(17, 236, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(lb:getPositionX() + lb:getContentSize().width, bg:getContentSize().height * 0.5):addTo(bg)
end

return M

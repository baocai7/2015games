local M = {}
M = class("PanelContriRecord", function()
  return display.newNode()
end)

function M:ctor(params, callback)
  self.mCallback = callback
  self:initUI(params)
end

function M:initUI(params)
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(875, 168), cc.rect(40, 40, 2, 2)):addTo(self)
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):align(display.CENTER_LEFT, 24, bg:getContentSize().height * 0.5):addTo(bg)
  local icon = display.newSprite(GameManager.USER_ICON_PATH .. params.icon .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 < params.vip then
    local vipFrame = display.newSprite("ranking/bg_vip.png"):align(display.CENTER_RIGHT, iconFrame:getContentSize().width, iconFrame:getContentSize().height):addTo(iconFrame)
    DYLabelTTF.new({
      text = string.format("%d", params.vip),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(111, 47, 2)
    }):pos(vipFrame:getContentSize().width * 0.72, vipFrame:getContentSize().height * 0.32):addTo(vipFrame)
  end
  DYLabelTTF.new({
    text = params.nick,
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width * 1.08, bg:getContentSize().height * 0.5):addTo(bg)
  local strs = {
    DYLang.getString("S1724", ""),
    DYLang.getString("S1725", ""),
    DYLang.getString("S1726", "")
  }
  DYLabelTTF.new({
    text = strs[params.rank],
    size = 26,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg)
  DYLabelTTF.new({
    text = params.level .. DYLang.getString("S1727", ""),
    size = 26,
    color = cc.c3b(0, 255, 6),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(bg:getContentSize().width * 0.72, bg:getContentSize().height * 0.5):addTo(bg)
  local strs = {
    DYLang.getString("S1728", ""),
    DYLang.getString("S1729", ""),
    DYLang.getString("S1730", "")
  }
  DYLabelTTF.new({
    text = strs[params.type],
    size = 26,
    color = cc.c3b(255, 216, 0),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(bg:getContentSize().width * 0.88, bg:getContentSize().height * 0.5):addTo(bg)
end

return M

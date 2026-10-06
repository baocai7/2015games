local M = {}
local M = class("IconCimeliaUpgrade", function()
  return display.newNode()
end)

function M:ctor(cimeliaModel)
  if cimeliaModel == nil then
    return
  end
  self:initData(cimeliaModel)
  self:initUI()
end

function M:initData(cimeliaModel)
  self.mCimeliaModel = cimeliaModel
  self.mExpValue = cimeliaModel.expValue
  self.mIsSelected = false
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(163, 196), cc.rect(40, 35, 2, 2)):addTo(self)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mCimeliaModel.quality)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.62):addTo(bg)
  local icon = display.newSprite(self.mCimeliaModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 < self.mCimeliaModel.stage then
    local topFrame = display.newSprite("cimelia/top_frame.png"):align(display.CENTER_TOP, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame)
    local pNode = display.newNode():align(display.CENTER, topFrame:getContentSize().width * 0.5, topFrame:getContentSize().height * 0.5):addTo(topFrame)
    pNode:setContentSize(18 * (self.mCimeliaModel.stage - 1), 24)
    for i = 1, self.mCimeliaModel.stage do
      display.newSprite("cimelia/magatama.png", 18 * (i - 1), 12):addTo(pNode)
    end
  end
  cc.ui.UILabel.new({
    text = string.format("Lv.%d", self.mCimeliaModel.level),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, iconFrame:getContentSize().width - 10, 20):addTo(iconFrame, 1)
  local nameFrame = display.newSprite("cimelia/name_frame.png"):align(display.CENTER, bg:getContentSize().width * 0.5, 25):addTo(bg)
  local textColor = DataUtils.getCimeliaNameColor(self.mCimeliaModel.quality)
  local lb = cc.ui.UILabel.new({
    text = self.mCimeliaModel.name,
    size = 22,
    color = textColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, nameFrame:getContentSize().width * 0.5, nameFrame:getContentSize().height * 0.5):addTo(nameFrame)
  lb:enableOutline(cc.c4b(83, 54, 20, 255), 2)
  self.mSelectedPic = display.newSprite("cimelia/selected_frame.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):hide():addTo(bg, 1)
end

function M:setIconSelected(flag)
  self.mIsSelected = flag
  if flag then
    self.mSelectedPic:show()
    table.insert(GameManager.CIMELIA_SWALLOWED, self.mCimeliaModel)
  else
    self.mSelectedPic:hide()
    table.removebyvalue(GameManager.CIMELIA_SWALLOWED, self.mCimeliaModel)
  end
end

return M

local M = {}
local M = class("PackageIcon", function()
  return display.newNode()
end)

function M:ctor(id, num)
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):addTo(self)
  if not id then
    return
  end
  self:initData(id, num)
  iconFrame:setTexture(string.format("common_ui/frame%d.png", self.mItemModel.quality))
  local pic = display.newSprite(self.mItemModel.itemIcon, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame, 1)
  self.mNumLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("*%d", self.mItemModel.currNum),
    font = "fonts/whiteNum.fnt"
  }):align(display.CENTER_RIGHT, iconFrame:getContentSize().width * 0.95, iconFrame:getContentSize().height * 0.15):scale(0.5):addTo(iconFrame, 3)
  self.mSelectedFrame = display.newSprite("common_ui/frame_selected.png", iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):hide():addTo(iconFrame, 2)
end

function M:initData(id, num)
  local itemModel = DataUtils.getPackageItem(id)
  self.mItemModel = itemModel
end

function M:setSelected(flag)
  if flag then
    self.mSelectedFrame:show()
    self.mSelectedFrame:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.3, 0.95), cc.ScaleTo:create(0.2, 1))))
  else
    self.mSelectedFrame:hide()
    self.mSelectedFrame:stopAllActions()
  end
end

PackageIcon = M
return M

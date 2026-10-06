local M = {}
M = class("IconCimeliaWiki", function()
  return display.newNode()
end)

function M:ctor(cimeliaModel)
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):scale(0.8):addTo(self)
  if not cimeliaModel then
    return
  end
  self.mModel = cimeliaModel
  iconFrame:setTexture("common_ui/frame6.png")
  local pic = display.newSprite(cimeliaModel.icon, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame, 1)
  self.mSelectedFrame = display.newSprite("common_ui/frame_selected.png", iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):hide():addTo(iconFrame, 2)
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

local CLASS_NAME = "LayerFriendTeam"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(info, cb)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  self.mCallBack = cb
  self.mInfo = info or {}
  self:layoutUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:layoutUI()
  self:addWidget()
end

function M:addWidget()
  local node = self.mNode
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  local bg = display.newSprite("ranking/bg_team.png"):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.96, bg:getContentSize().height * 0.95):addTo(bg)
  if self.mInfo == nil or #self.mInfo == 0 then
    return
  end
  for i = 1, #self.mInfo do
    local buddhaInfo = self.mInfo[i]
    local buddhaModel = DataUtils.getOtherPlayerTeamInfo(buddhaInfo)
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality)):scale(0.95):pos(bg:getContentSize().width * (0.15 * i - 0.1) + 55, bg:getContentSize().height * 0.55):addTo(bg)
    local icon = display.newSprite(buddhaModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    if 0 == buddhaModel.isRebel then
      icon:setScaleX(-1)
    end
    DYLabelTTF.new({
      text = "LV." .. buddhaModel.level,
      size = 24,
      color = cc.c3b(101, 58, 8),
      font = GameManager.FONTNAME_TTF
    }):pos(iconFrame:getPositionX(), iconFrame:getPositionY() - 70):addTo(bg)
    display.newSprite(string.format("upgrade/star%d.png", buddhaModel.starLevel)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame)
    if 3 == self.mType then
      DYLabelTTF.new({
        text = "x" .. buddhaInfo.num,
        size = 22,
        color = display.COLOR_WHITE,
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_RIGHT"
      }, {}):pos(iconFrame:getContentSize().width - 10, 15):addTo(iconFrame, 1)
    end
  end
end

function M:closeCallBack()
  self:runAction(cc.RemoveSelf:create())
  if self.mCallBack then
    self.mCallBack()
  end
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

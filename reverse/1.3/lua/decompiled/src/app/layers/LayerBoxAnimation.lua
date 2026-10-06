local IconItem = require("app.icons.IconItem")
local LayerBoxShow = require("app.layers.LayerBoxShow")
local CLASS_NAME = "LayerBoxAnimation"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(info, index)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mNode = display.newNode():addTo(self, 1)
  self.mType = index or 4
  self.mFile = string.format("animation/zhangjiebaoxiang%d/zhangjiebaoxiang%d.csb", self.mType, self.mType)
  self.mInfo = info or {}
  self:boxOpenAni()
end

function M:boxOpenAni()
  DYSoundMgr.playEffect(DY_SND.sfx_box_open)
  local armature = ccs.Armature:create("zhangjiebaoxiang" .. self.mType)
  armature:setPosition(0, 0)
  armature:getAnimation():playWithIndex(1)
  armature:getAnimation():setSpeedScale(1.2)
  self.mNode:addChild(armature)
  
  local function animationEvent(armatureBack, movementType, movementID)
    if movementType == ccs.MovementEventType.complete then
      self:showAward()
      self:runAction(cc.RemoveSelf:create())
    end
  end
  
  armature:getAnimation():setMovementEventCallFunc(animationEvent)
end

function M:showAward()
  local info = {
    boxInfo = self.mInfo
  }
  local tip = LayerBoxShow.new(info, LayerBoxShow.AWARD_GET)
  display.getRunningScene():addChild(tip, 100)
  do return end
  local awardLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):pos(0, 0)
  display.getRunningScene():addChild(awardLayer, 100)
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  local bg = display.newSprite("common_ui/common_dialog.png"):scale(0):pos(display.cx, display.cy):addTo(awardLayer)
  local cancelLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S510", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  cancelLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.23):addTo(bg):setButtonLabel("normal", cancelLabel):onButtonClicked(function()
    awardLayer:runAction(cc.RemoveSelf:create())
  end)
  display.newSprite("stage/award.png"):align(display.CENTER_LEFT, bg:getContentSize().width * 0.1, bg:getContentSize().height * 0.87):addTo(bg)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(514, 150), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.55):addTo(bg)
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(7, 15, 501, 120),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(frame)
  local sum = 1
  for i = 1, #self.mInfo do
    local item = list:newItem()
    local content = IconItem.new(self.mInfo[i].id, self.mInfo[i].num)
    content:showItemTip()
    content:setScale(0.9)
    item:addContent(content)
    item:setItemSize(120, 120)
    list:addItem(item)
  end
  list:reload()
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  bg:runAction(popupLayer)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  return true
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

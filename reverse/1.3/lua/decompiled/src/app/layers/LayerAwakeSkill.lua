local M = {}
M = class("LayerAwakeSkill", function()
  return display.newLayer()
end)
local TEXT_COLOR = {
  cc.c3b(0, 0, 0),
  cc.c3b(0, 255, 6),
  cc.c3b(81, 204, 255),
  cc.c3b(239, 38, 237),
  cc.c3b(255, 198, 0)
}

function M:ctor(awakeSkills)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initData(awakeSkills)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData(awakeSkills)
  self.mSkillList = {}
  for k, v in pairs(awakeSkills) do
    local skillModel = DataUtils.getAwakeSkillModel(v, nil, 1)
    table.insert(self.mSkillList, skillModel)
  end
  table.sort(self.mSkillList, function(v1, v2)
    return v1.priority < v2.priority
  end)
  self.mIconTable = {}
end

function M:initUI()
  self.mBg = display.newSprite("ranking/bg.png"):addTo(self.mNode)
  self:initListView()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.96, self.mBg:getContentSize().height * 0.93):addTo(self.mBg, 2)
end

function M:initListView()
  local tb = self.mSkillList
  local listFrame = display.newScale9Sprite("common_ui/common_frame11.png", self.mBg:getContentSize().width * 0.5 + 5, self.mBg:getContentSize().height * 0.51, cc.size(800, 500), cc.rect(50, 40, 5, 5)):addTo(self.mBg)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 10, 770, 480),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(listFrame, 2)
  local totalNum = #tb
  local row = math.ceil(totalNum / 5)
  local column = totalNum % 5
  local endNum = 5
  for i = 1, row do
    if i == row and column ~= 0 then
      endNum = column
    end
    local item = listView:newItem()
    local content = display.newNode()
    for count = 1, endNum do
      local skillModel = tb[count + (i - 1) * 5]
      local icon = self:getIconFrame(skillModel)
      icon:setPosition(154 * count - 77, 92)
      content:addChild(icon)
    end
    content:setContentSize(770, 184)
    item:addContent(content)
    item:setItemSize(770, 184)
    listView:addItem(item)
  end
  listView:reload()
end

function M:getIconFrame(skillModel)
  local icon = skillModel.skillIcon
  local quality = skillModel.quality
  local bg = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(163, 196), cc.rect(40, 35, 2, 2))
  bg:setScale(0.9)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", quality)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.62):addTo(bg)
  local icon = display.newSprite(icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  local nameFrame = display.newSprite("cimelia/name_frame.png"):align(display.CENTER, bg:getContentSize().width * 0.5, 25):addTo(bg)
  local lb = DYLabelTTF.new({
    text = skillModel.skillName,
    size = 22,
    color = TEXT_COLOR[quality],
    font = GameManager.FONTNAME_TTF
  }, {}):pos(nameFrame:getContentSize().width * 0.5, nameFrame:getContentSize().height * 0.5):addTo(nameFrame)
  return bg
end

function M:touchListener(event)
  local lv = event.listView
  if "clicked" == event.name then
    local column = math.ceil(event.point.x / 154)
    local idx = (event.itemPos - 1) * 5 + column
    local skillModel = self.mSkillList[idx]
    if skillModel then
      self:getSkillInfoLayer(skillModel)
    end
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:getSkillInfoLayer(skillModel)
  local maskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 120)):addTo(self, 20)
  local bg = display.newSprite("common_ui/common_dialog.png"):pos(display.cx, display.cy):addTo(maskLayer, 1)
  local skillQuality = skillModel.quality
  local skillFrame = display.newSprite(string.format("common_ui/frame%d.png", skillQuality)):pos(bg:getContentSize().width * 0.2, bg:getContentSize().height * 0.57):addTo(bg)
  local skillIcon = display.newSprite(skillModel.skillIcon):pos(skillFrame:getContentSize().width * 0.5, skillFrame:getContentSize().height * 0.5):addTo(skillFrame, 1)
  local skillName = DYLabelTTF.new({
    text = skillModel.skillName,
    size = 25,
    color = TEXT_COLOR[skillQuality],
    font = GameManager.FONTNAME_TTF
  }, {}):pos(skillFrame:getContentSize().width * 0.5, -skillFrame:getPositionY() * 0.1):addTo(skillFrame)
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S490", ""),
    size = 24,
    color = cc.c3b(255, 252, 8),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(49, 39, 4)
  }):pos(bg:getContentSize().width * 0.37, bg:getContentSize().height * 0.75):addTo(bg)
  DYLabelTTF.new({
    text = string.format(skillModel.skillDesc, unpack(skillModel.effectTable)),
    size = 22,
    color = cc.c3b(251, 235, 150),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT",
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(336, 75)
  }, {}):pos(lb1:getPositionX(), lb1:getPositionY() - 50):addTo(bg)
  local lb2 = DYLabelTTF.new({
    text = DYLang.getString("S491", ""),
    size = 24,
    color = cc.c3b(255, 252, 8),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(49, 39, 4)
  }):pos(bg:getContentSize().width * 0.37, bg:getContentSize().height * 0.48):addTo(bg)
  DYLabelTTF.new({
    text = string.format(skillModel.skillDesc, unpack(skillModel.effectNextTable)),
    size = 22,
    color = cc.c3b(251, 235, 150),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT",
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(336, 75)
  }, {}):pos(lb2:getPositionX(), lb2:getPositionY() - 50):addTo(bg)
  local label1 = DYLabelTTF.new({
    text = DYLang.getString("S492", ""),
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(bg:getContentSize().width * 0.37, bg:getContentSize().height * 0.2):addTo(bg)
  local label2 = DYLabelTTF.new({
    text = DYLang.getString("S493", ""),
    size = 24,
    color = cc.c3b(255, 183, 11),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(label1:getContentSize().width + label1:getPositionX(), label1:getPositionY()):addTo(bg)
  local label3 = DYLabelTTF.new({
    text = skillModel.costNum,
    size = 22,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(label2:getContentSize().width + label2:getPositionX() + 5, label1:getPositionY()):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):align(display.CENTER, bg:getContentSize().width * 0.95, bg:getContentSize().height * 0.95):onButtonClicked(function()
    maskLayer:runAction(cc.RemoveSelf:create())
  end):addTo(bg)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
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

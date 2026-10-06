local CLASS_NAME = "LayerPreview"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(params)
  self.mMaskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):hide():addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mRelatedIds = params.relatedIds
  self.mGrade = params.grade or 1
  self:initData()
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function M_filePath(name)
  return string.format("equipment/%s.png", name)
end

function M:initData()
  self.mPropertyIds = {}
  self.mPropertyDatas = {}
  for i = 1, #self.mRelatedIds do
    local eid = self.mRelatedIds[i]
    local propIds, propRanges = DataUtils.getEquipmentPropIds(eid)
    table.insert(self.mPropertyIds, propIds)
    table.insert(self.mPropertyDatas, propRanges)
  end
  self.mLabelList = {}
  self.mCurrTab = nil
end

function M:initUI()
  local bg = display.newSprite(M_filePath("bg_04")):addTo(self.mNode)
  bg:align(display.CENTER_TOP, 0, -454)
  self.mBg = bg
  local _width, _height = bg:getContentSize().width, bg:getContentSize().height
  local frame = display.newSprite(M_filePath("frame_preview"))
  frame:pos(_width * 0.5, _height * 0.5)
  frame:addTo(bg)
  local propertyIds = self.mPropertyIds[self.mGrade]
  local propertyValues = self.mPropertyDatas[self.mGrade]
  local posX, posY = 30, 175
  for i = 1, #propertyIds do
    local id, value = propertyIds[i], propertyValues[i]
    local label1 = DYLabelTTF.new({
      text = EMgr.PROPERTIES[id] .. ":",
      size = 22,
      color = cc.c3b(58, 33, 4),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(posX, posY):addTo(frame)
    local label2 = DYLabelTTF.new({
      text = value,
      size = 22,
      color = cc.c3b(58, 33, 4),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(posX + label1:getContentSize().width, posY):addTo(frame)
    if 0 == i % 4 then
      posX, posY = 30, posY - 37
    else
      posX = posX + 245
    end
    table.insert(self.mLabelList, label2)
  end
  local M_TAB_BTN = {
    {
      normal = M_filePath("btn_grade_n_1"),
      pressed = M_filePath("btn_grade_p_1"),
      disabled = M_filePath("btn_grade_p_1")
    },
    {
      normal = M_filePath("btn_grade_n_2"),
      pressed = M_filePath("btn_grade_p_2"),
      disabled = M_filePath("btn_grade_p_2")
    },
    {
      normal = M_filePath("btn_grade_n_3"),
      pressed = M_filePath("btn_grade_p_3"),
      disabled = M_filePath("btn_grade_p_3")
    },
    {
      normal = M_filePath("btn_grade_n_4"),
      pressed = M_filePath("btn_grade_p_4"),
      disabled = M_filePath("btn_grade_p_4")
    }
  }
  for i = 1, #M_TAB_BTN do
    local btn = cc.ui.UIPushButton.new(M_TAB_BTN[i]):onButtonClicked(function(event)
      self:funcChange(event.target, i)
    end):align(display.CENTER_BOTTOM, _width * (0.16 * i + 0.1), _height):addTo(bg)
    if self.mGrade == i then
      btn:setButtonEnabled(false)
      self.mCurrTab = btn
    end
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:layerHide()
  end):align(display.CENTER, _width * 0.9, _height - 5):addTo(bg, 2)
end

function M:funcChange(tab, index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mCurrTab:setButtonEnabled(true)
  tab:setButtonEnabled(false)
  self.mCurrTab = tab
  local propertyValues = self.mPropertyDatas[index]
  for i = 1, #self.mLabelList do
    local label = self.mLabelList[i]
    label:setString(propertyValues[i])
  end
end

function M:layerShow()
  local seq = transition.sequence({
    cc.MoveBy:create(0.2, cc.p(0, 354)),
    cc.CallFunc:create(function()
      self.mMaskLayer:show()
    end)
  })
  self.mBg:runAction(seq)
end

function M:layerHide()
  local seq = transition.sequence({
    cc.MoveBy:create(0.2, cc.p(0, -354)),
    cc.CallFunc:create(function()
      self.mMaskLayer:hide()
      self:closeCallback()
    end)
  })
  self.mBg:runAction(seq)
end

function M:closeCallback()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:removeSelf()
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
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

local M = {}
M = class("LayerTeamStar", function()
  return display.newLayer()
end)

function M:ctor()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:initData()
  self:initUI()
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mTeamInfo = DataUtils.getBuddhaTableOnTeam()
end

local function getFateInfo(self, idx)
  local count = 0
  for i = 1, #self.mTeamInfo do
    local buddhaId = tonumber(self.mTeamInfo[i])
    local starLevel = CloudData.NPC_INFO[buddhaId].star
    if idx <= starLevel then
      count = count + 1
    end
  end
  local isActive = false
  if 6 == count then
    isActive = true
  end
  local desc = DataUtils.getTeamStarFateModel(idx).fataDesc
  return count, isActive, desc
end

function M:initUI()
  local bg = display.newSprite("team/star_bg.png"):addTo(self.mNode)
  local textList = {
    DYLang.getString("S951", ""),
    DYLang.getString("S952", ""),
    DYLang.getString("S953", ""),
    DYLang.getString("S954", ""),
    DYLang.getString("S955", "")
  }
  for i = 1, 5 do
    local countNum, isActive, fateDesc = getFateInfo(self, i)
    local label1 = cc.ui.UILabel.new({
      text = textList[i],
      size = 25,
      color = cc.c3b(80, 40, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 90, 465 - (i - 1) * 85):addTo(bg)
    local label2 = cc.ui.UILabel.new({
      text = string.format("\239\188\136%d/6\239\188\137", countNum),
      size = 25,
      color = cc.c3b(80, 40, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, label1:getPositionX() + label1:getContentSize().width, label1:getPositionY()):addTo(bg)
    local label3 = cc.ui.UILabel.new({
      text = fateDesc,
      size = 20,
      color = cc.c3b(80, 40, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 180, label1:getPositionY() - 36):addTo(bg)
    if isActive then
      label1:setColor(cc.c3b(172, 77, 0))
      label2:setColor(cc.c3b(172, 77, 0))
      label3:setColor(cc.c3b(172, 77, 0))
      local sp = display.newSprite("team/mark.png"):align(display.CENTER_LEFT, label2:getPositionX() + label2:getContentSize().width, label2:getPositionY() + 3):addTo(bg)
    end
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S38", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.02):addTo(bg)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.cb then
    self.cb()
  end
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.mNode:runAction(popupLayer)
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

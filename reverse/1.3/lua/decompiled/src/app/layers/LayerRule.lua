local rule = require("app.profiles.rule")
local CLASS_NAME = "LayerRule"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.TOWER = 1
M.PVP = 2
M.SIGN = 3
M.CIMELIA = 4
M.PURGATORY = 5
M.PVPOLRANK = 6
M.PVPOLCOMPETE = 7
M.PLACE = 19
M.REDPACKET = 9
M.NEWYEAR = 10
M.MEDITATION = 11
M.UNION = 12
M.UNIONMAP = 13
M.CONTRIBUTE = 14
M.UNIONBOSS = 15
M.UNIONBATTLE = 16
M.UNIONFAIRYLAND = 17
M.BABEL = 18
M.ACTIVITY_BUDDHA = 20
M.FLIGHT_CHESS = 21
M.PATROL = 22
M.AGGRESS = 23
M.EQUIPMENT = 24
M.CIMELIA_RECAST = 25

function M:ctor(ruleType)
  self.mType = tonumber(ruleType)
  if self.mType == nil or self.mType < 1 then
    self:removeSelf()
    return
  end
  self.mInfo = rule[self.mType] or {}
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mNode = display.newNode():pos(display.cx, display.cy):scale(0):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self:initBg()
end

local function getlines(str, fontSize, width)
  if str == nil then
    return 0
  end
  local strNum = math.ceil(#str / 3)
  local single = math.floor(width / (fontSize + 1))
  local lines = math.ceil(strNum / single)
  return lines
end

function M.newRuleIcon(tag)
  local icon = cc.ui.UIPushButton.new({
    normal = "common_ui/readme_n.png",
    pressed = "common_ui/readme_p.png"
  }):onButtonClicked(function()
    M.new(tag):addTo(display.getRunningScene(), 20)
  end)
  return icon
end

function M:initBg()
  local w = 598
  local h = 624
  local bg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(w, h), cc.rect(598, 125, 5, 5)):addTo(self.mNode)
  self.mBg = bg
  display.newSprite("purgatory/rule_title.png"):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.92):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, bg:getContentSize().width + 15, bg:getContentSize().height + 15):addTo(bg, 2):onButtonClicked(function()
    self:closeCallBack()
  end)
  local x = 40
  local y = 60
  local scrollNode = cc.Node:create()
  scrollNode:setContentSize(w - 2 * x, h - 2 * y - 20)
  local params = {
    viewRect = cc.rect(x, y, w - 2 * x, h - 2 * y - 20)
  }
  local view = cc.ui.UIScrollView.new(params):addScrollNode(scrollNode)
  local dir = cc.ui.UIScrollView.DIRECTION_VERTICAL
  view:setDirection(dir)
  view:setBounceable(true)
  bg:addChild(view, 1)
  local labelPosX = scrollNode:getContentSize().width * 0.5 + x + 10
  local markHeight = h - 2 * y - 10 + 40
  local titleLines = getlines(self.mInfo.title, self.mInfo.titleSize, w - 2 * x - 20) + 1
  if 1 < titleLines then
    titleLines = titleLines * (self.mInfo.titleSize + 3) + 20
    cc.ui.UILabel.new({
      text = self.mInfo.title,
      size = self.mInfo.titleSize,
      color = self.mInfo.titleColor,
      align = cc.ui.TEXT_ALIGN_LEFT,
      dimensions = cc.size(w - 2 * x - 20, titleLines),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, labelPosX, markHeight - titleLines / 2):addTo(scrollNode)
    markHeight = markHeight - titleLines
  end
  local addLines = getlines(self.mInfo.motto, self.mInfo.mottoSize, w - 2 * x - 20)
  if 0 < addLines then
    addLines = addLines * (self.mInfo.mottoSize + 3)
    cc.ui.UILabel.new({
      text = self.mInfo.motto,
      size = self.mInfo.mottoSize,
      color = self.mInfo.mottoColor,
      dimensions = cc.size(w - 2 * x - 20, addLines),
      align = cc.ui.TEXT_ALIGN_LEFT,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, labelPosX, markHeight - addLines / 2 - 10):addTo(scrollNode)
    markHeight = markHeight - addLines - 10
    local y = math.ceil(self.mInfo.nameSize / 2)
    cc.ui.UILabel.new({
      text = self.mInfo.mottoName,
      size = self.mInfo.nameSize,
      color = self.mInfo.nameColor,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_RIGHT, scrollNode:getContentSize().width, markHeight - y):addTo(scrollNode)
    markHeight = markHeight - self.mInfo.nameSize - 3
  end
  if self.mInfo.rule and 0 < #self.mInfo.rule then
    local ruleTitle = display.newSprite(self.mInfo.rulePic):align(display.LEFT_TOP, x, markHeight - 20):addTo(scrollNode)
    markHeight = markHeight - ruleTitle:getContentSize().height - 40
    local y = math.ceil(self.mInfo.ruleSize / 2)
    for i = 1, #self.mInfo.rule do
      display.newSprite("recharge/star.png"):align(display.CENTER_LEFT, x, markHeight - y):addTo(scrollNode)
      local ruleLines = getlines(self.mInfo.rule[i], self.mInfo.ruleSize, w - 2 * x - 40)
      if 0 < ruleLines then
        ruleLines = ruleLines * (self.mInfo.ruleSize + 3)
        cc.ui.UILabel.new({
          text = self.mInfo.rule[i],
          size = self.mInfo.ruleSize,
          color = self.mInfo.ruleColor,
          dimensions = cc.size(w - 2 * x - 40, ruleLines),
          align = cc.ui.TEXT_ALIGN_LEFT,
          font = GameManager.FONTNAME_TTF
        }):align(display.CENTER, labelPosX, markHeight - ruleLines / 2):addTo(scrollNode)
        markHeight = markHeight - ruleLines - 10
      end
    end
  end
  if self.mInfo.award and 0 < #self.mInfo.award then
    local awardTitle = display.newSprite(self.mInfo.awardPic):align(display.LEFT_TOP, x, markHeight - 20):addTo(scrollNode)
    markHeight = markHeight - awardTitle:getContentSize().height - 40
    local y = math.ceil(self.mInfo.awardSize / 2)
    for i = 1, #self.mInfo.award do
      display.newSprite("recharge/star.png"):align(display.CENTER_LEFT, x, markHeight - y):addTo(scrollNode)
      local awardLines = getlines(self.mInfo.award[i], self.mInfo.awardSize, w - 2 * x - 30)
      if 0 < awardLines then
        awardLines = awardLines * (self.mInfo.awardSize + 3)
        cc.ui.UILabel.new({
          text = self.mInfo.award[i],
          size = self.mInfo.awardSize,
          color = self.mInfo.awardColor,
          dimensions = cc.size(w - 2 * x - 30, awardLines),
          align = cc.ui.TEXT_ALIGN_LEFT,
          font = GameManager.FONTNAME_TTF
        }):align(display.CENTER, labelPosX, markHeight - awardLines / 2):addTo(scrollNode)
        markHeight = markHeight - awardLines - 10
      end
    end
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:runAction(cc.RemoveSelf:create())
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

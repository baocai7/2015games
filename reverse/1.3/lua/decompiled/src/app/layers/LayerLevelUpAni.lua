local CLASS_NAME = "LayerLevelUpAni"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(level, cb)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  DYRes.loadSheet("animation/shengli_xingxing.plist")
  DYRes.loadSheet("animation/arrow.plist")
  self.mLevel = tonumber(level) or tonumber(CloudData.USER_LEVEL)
  self.mNewFuncLevel = 0
  self.mCallBack = cb
  self.mTouchEnabled = false
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      return true
    elseif event.name == "ended" then
      self.mTouchEnabled = false
      self:setTouchEnabled(false)
      self:closeCallBack()
    end
  end)
  self:setTouchEnabled(self.mTouchEnabled)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self:checkThing()
  self:initUI()
end

local function getTips(level)
  local tips = {}
  local info = DYCommon.getDataByTag(DataRetainer.LEVEL_UP_TIPS, "level", tostring(level))[1]
  if not info then
    return tips
  end
  local indexTable = split(info.index, ";")
  for i = 1, #indexTable do
    local index = indexTable[i]
    local tipInfo = DYCommon.getDataByTag(DataRetainer.LEVEL_UP_TIPS, "targetId", tostring(index))[1]
    if tipInfo then
      local msg = {
        level = tipInfo.targetLevel,
        tip = tipInfo.tips
      }
      table.insert(tips, msg)
    end
  end
  return tips
end

function M:initUI()
  local tips = getTips(self.mLevel)
  local sum = #tips
  local addSize = sum * 55
  if tips[1] then
    self.mNewFuncLevel = tonumber(tips[1].level)
  end
  local tip = display.newScale9Sprite("war_result/bg.png", 0, 0, cc.size(698, 322 + addSize), cc.rect(350, 160, 2, 2)):addTo(self.mNode)
  local frames = display.newFrames("shengli-xingxing%d.png", 1, 19)
  local animation = display.newAnimation(frames, 0.15)
  local emptySp = display.newSprite():scale(2):pos(349, 275 + addSize):addTo(tip, 2)
  emptySp:playAnimationForever(animation)
  display.newSprite("war_result/upgrade_title.png"):pos(349, 224 + addSize):addTo(tip)
  local levelStr = cc.ui.UILabel.new({
    text = DYLang.getString("S734", ""),
    size = 25,
    color = cc.c3b(253, 255, 21),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 135, 148 + addSize):addTo(tip)
  levelStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local userLevel = self.mLevel - 1
  local originLevel = cc.ui.UILabel.new({
    text = userLevel,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 421, 148 + addSize):addTo(tip)
  originLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local newLevel = cc.ui.UILabel.new({
    text = self.mLevel,
    size = 25,
    color = cc.c3b(10, 255, 21),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 513, 148 + addSize):addTo(tip)
  newLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local levelStr = cc.ui.UILabel.new({
    text = DYLang.getString("S735", ""),
    size = 25,
    color = cc.c3b(253, 255, 21),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 135, 108 + addSize):addTo(tip)
  levelStr:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local energy = CloudData.ENERGY - 5
  local originEnergy = cc.ui.UILabel.new({
    text = energy,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 421, 108 + addSize):addTo(tip)
  originEnergy:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local newEnergy = cc.ui.UILabel.new({
    text = CloudData.ENERGY,
    size = 25,
    color = cc.c3b(10, 255, 21),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 513, 108 + addSize):addTo(tip)
  newEnergy:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  display.newSprite("war_result/spirit_str.png"):align(display.CENTER_LEFT, 133, 68 + addSize):addTo(tip)
  local spriteLevel = DataUtils.getMaxSP(userLevel)
  local originSpirit = cc.ui.UILabel.new({
    text = spriteLevel,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 421, 68 + addSize):addTo(tip)
  originSpirit:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  spriteLevel = DataUtils.getMaxSP(self.mLevel)
  local newSpirit = cc.ui.UILabel.new({
    text = spriteLevel,
    size = 25,
    color = cc.c3b(10, 255, 21),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 513, 68 + addSize):addTo(tip)
  newSpirit:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local frames1 = display.newFrames("arrow%d.png", 1, 10)
  local animation1 = display.newAnimation(frames1, 0.05)
  local emptySp1 = display.newSprite():pos(468, 148 + addSize):addTo(tip)
  emptySp1:playAnimationForever(animation1, true)
  local emptySp2 = display.newSprite():pos(468, 108 + addSize):addTo(tip)
  emptySp2:playAnimationForever(animation1, true)
  local emptySp3 = display.newSprite():pos(468, 68 + addSize):addTo(tip)
  emptySp3:playAnimationForever(animation1, true)
  for i = 1, sum do
    local tipBg = display.newSprite("war_result/tip_line.png"):pos(tip:getContentSize().width * 0.5, 84 + addSize - i * 55):addTo(tip)
    local leveltip = tips[i].level .. DYLang.getString("S736", "")
    local strColor = cc.c3b(255, 30, 30)
    if self.mLevel >= tonumber(tips[i].level) then
      strColor = cc.c3b(10, 255, 11)
    end
    local levelLabel = cc.ui.UILabel.new({
      text = leveltip,
      size = 20,
      color = strColor,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 38, tipBg:getContentSize().height * 0.5):addTo(tipBg)
    levelLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    local tipsLabel = cc.ui.UILabel.new({
      text = tips[i].tip,
      size = 20,
      color = strColor,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_RIGHT, 467, tipBg:getContentSize().height * 0.5):addTo(tipBg)
  end
  self.mTouchEnabled = true
  self:setTouchEnabled(self.mTouchEnabled)
end

function M:checkThing()
  if tonumber(self.mLevel) == 10 then
    local function tFuncListener(jsonTable)
      CloudData.GAME_ITEM_INFO["2001"] = jsonTable.data["2001"]
    end
    
    DYHttpMgr.getUserThingCount(tFuncListener, {ids = "2001"})
  end
end

function M:closeCallBack()
  local level = self.mNewFuncLevel
  local changeScene = false
  if self.mLevel == CloudData.USER_LEVEL and level == self.mLevel and level ~= 6 and level ~= 10 then
    changeScene = true
  end
  if self.mCallBack then
    self.mCallBack(changeScene)
  end
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE and self.mTouchEnabled then
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
  DYRes.unloadSheet("animation/shengli_xingxing.plist")
  DYRes.unloadSheet("animation/arrow.plist")
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

local IconItem = require("app.icons.IconItem")
local CLASS_NAME = "LayerRankDetail"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(index)
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mIndex = checknumber(index)
  self.mInfo = {}
  self:initData()
  self:initBg()
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mInfo = CloudData.BabelRank[self.mIndex]
  if not self.mInfo then
    self:closeCallBack()
  end
  local seatId = checknumber(self.mInfo.seatId)
end

function M:initBg()
  local bg = display.newSprite("pvp/log_bg.png"):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, self.mBg:getContentSize().width, self.mBg:getContentSize().height):addTo(self.mBg, 1):onButtonClicked(function()
    self:closeCallBack()
  end)
  display.newSprite("babel/adorn.png"):align(display.CENTER_RIGHT, 365, 585):addTo(bg)
  local adorn = display.newSprite("babel/adorn.png"):align(display.CENTER_RIGHT, 635, 585):addTo(bg)
  adorn:setScaleX(-1)
  local str = self.mInfo.desc .. "\194\183" .. self.mInfo.name
  DYLabelTTF.new({
    text = str,
    size = 30,
    color = cc.c3b(255, 200, 53),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, 510, 585):addTo(bg)
  self:addReward()
  self:addPlayer()
end

function M:addReward()
  display.newScale9Sprite("babel/bg_gray.png", 0, 0, cc.size(907, 153), cc.rect(26, 21, 2, 2)):align(display.CENTER, 510, 471):addTo(self.mBg)
  display.newSprite("babel/profit_time.png"):align(display.CENTER_LEFT, 73, 521):addTo(self.mBg)
  local info = self.mInfo.award
  if not info then
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(80, 400, 765, 103),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(self.mBg)
  for k, v in pairs(info) do
    local item = list:newItem()
    local content = IconItem.new(k, v)
    content:showItemTip()
    content:setScale(0.75)
    item:addContent(content)
    item:setItemSize(118, 100)
    list:addItem(item)
  end
  list:reload()
end

function M:addPlayer()
  display.newSprite("babel/player.png"):align(display.CENTER_LEFT, 73, 367):addTo(self.mBg)
  if self.mInfo.icon then
    self:addPlayerInfo()
    self:addTeam()
  else
    display.newSprite("babel/tip.png"):align(display.CENTER, 377, 204):addTo(self.mBg)
    display.newSprite("babel/miao.png"):align(display.CENTER, 845, 185):addTo(self.mBg)
  end
end

function M:addPlayerInfo()
  local icon = display.newSprite("common_ui/frame3.png", 131, 269):addTo(self.mBg)
  display.newSprite(GameManager.USER_ICON_PATH .. self.mInfo.icon .. ".png"):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):addTo(icon)
  local myLevel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "LV." .. self.mInfo.level,
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.BOTTOM_RIGHT, icon:getContentSize().width * 0.98, icon:getContentSize().height * 0.05):addTo(icon, 1)
  myLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  DYLabelTTF.new({
    text = self.mInfo.nick,
    size = 25,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 210, 302):addTo(self.mBg)
  local swordBg = display.newSprite("pvp/sword.png"):align(display.CENTER_LEFT, 210, 249):addTo(self.mBg)
  local str = self.mInfo.power
  if self.mInfo.power > 100000 then
    str = string.format("%d\228\184\135", math.floor(self.mInfo.power / 10000))
  end
  DYLabelTTF.new({
    text = str,
    size = 25,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, 120, 28):addTo(swordBg)
end

function M:addTeam()
  display.newSprite("babel/adorn.png"):scale(0.8):align(display.CENTER_RIGHT, 162, 101):addTo(self.mBg)
  local adorn = display.newSprite("babel/adorn.png"):scale(0.8):align(display.CENTER_RIGHT, 877, 101):addTo(self.mBg)
  adorn:setScaleX(-1)
  local info = self.mInfo.pvpDefenseTeamInfo
  if #info == 0 then
    return
  end
  for i = 1, #info do
    local model = DataUtils.getBuddhaFeatureInfo(info[i].buddhaId, info[i].level)
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", model.quality)):scale(0.82):pos(128 + 115 * i, 150):addTo(self.mBg)
    local icon = display.newSprite(model.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    if 0 == model.isRebel then
      icon:setScaleX(-1)
    end
    display.newSprite(string.format("upgrade/star%d.png", info[i].star)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame, 1)
    local levelFrame = display.newSprite("team/frame.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.15):addTo(iconFrame)
    cc.ui.UILabel.new({
      text = string.format("LV.%d", info[i].level),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, levelFrame:getContentSize().width * 0.5, levelFrame:getContentSize().height * 0.5):addTo(levelFrame)
    local numBg = display.newSprite("pvp/num_bg.png"):align(display.CENTER, iconFrame:getContentSize().width * 0.5, -25):addTo(iconFrame)
    local numLevel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = info[i].num,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, numBg:getContentSize().width * 0.5, numBg:getContentSize().height * 0.5):addTo(numBg)
    numLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  end
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

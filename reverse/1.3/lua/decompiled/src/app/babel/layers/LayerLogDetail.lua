local IconItem = require("app.icons.IconItem")
local CLASS_NAME = "LayerLogDetail"
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
  self.mLevel = 1
  self.mIcon = ""
  self.mName = ""
  self.mPower = 0
  self.mIsAttacking = 0
  self.mTeamInfo = {}
  self.mRewardInfo = {}
  self:initData()
  self:initBg()
  self:setNodeEventEnabled(true)
end

function M:initData()
  local info = CloudData.BabelLog[checknumber(self.mIndex)]
  if not info then
    self:closeCallBack()
    return
  end
  self.mIsAttacking = 1
  local tag = "opponent"
  if checknumber(info.selfUid) ~= CloudData.UID then
    tag = "self"
    self.mIsAttacking = 0
  end
  self.mLevel = checknumber(info[tag .. "Level"])
  self.mIcon = checkstring(info[tag .. "Icon"])
  self.mName = checkstring(info[tag .. "Name"])
  self.mPower = checknumber(info[tag .. "Power"])
  self.mTeamInfo = json.decode(info[tag .. "Team"]) or {}
  self.mRewardInfo = info.bootyMap or {}
end

function M:initBg()
  local bg = display.newSprite("pvp_ol/bg_rankInfo.png"):pos(0, -20):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, bg:getContentSize().width + 5, bg:getContentSize().height):addTo(bg):onButtonClicked(function()
    self:closeCallBack()
  end)
  local titleBg = display.newSprite("common_ui/title_frame.png"):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height - 33):addTo(self.mBg)
  display.newSprite("babel/title.png"):align(display.CENTER, titleBg:getContentSize().width * 0.5, titleBg:getContentSize().height * 0.5):addTo(titleBg)
  self:addContent()
  self:addTeam()
  self:addReward()
  self:addButton()
end

function M:addContent()
  local icon = display.newSprite("common_ui/frame4.png", 153, 525):addTo(self.mBg)
  if self.mIcon ~= "" then
    display.newSprite(GameManager.USER_ICON_PATH .. self.mIcon .. ".png"):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):addTo(icon)
  end
  DYLabelTTF.new({
    text = "LV." .. self.mLevel,
    size = 25,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_RIGHT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.BOTTOM_RIGHT, icon:getContentSize().width * 0.89, icon:getContentSize().height * 0.18):addTo(icon, 1)
  DYLabelTTF.new({
    text = self.mName,
    size = 25,
    color = cc.c3b(255, 255, 255),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 228, 558):addTo(self.mBg)
  local swordBg = display.newSprite("pvp/sword.png"):align(display.CENTER_LEFT, 228, 506):addTo(self.mBg)
  local str = self.mPower
  if self.mPower > 100000 then
    str = string.format("%d\228\184\135", math.floor(self.mPower / 10000))
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
  display.newSprite("babel/adorn.png"):align(display.CENTER_RIGHT, 174, 357):addTo(self.mBg)
  local adorn = display.newSprite("babel/adorn.png"):align(display.CENTER_RIGHT, 890, 357):addTo(self.mBg)
  adorn:setScaleX(-1)
  if not self.mTeamInfo or #self.mTeamInfo == 0 then
    return
  end
  for i = 1, #self.mTeamInfo do
    local model = DataUtils.getBuddhaFeatureInfo(self.mTeamInfo[i].id, self.mTeamInfo[i].level)
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", model.quality)):scale(0.82):pos(135 + 114 * i, 393):addTo(self.mBg)
    local icon = display.newSprite(model.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    if 0 == model.isRebel then
      icon:setScaleX(-1)
    end
    display.newSprite(string.format("upgrade/star%d.png", self.mTeamInfo[i].star)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame, 1)
    local levelFrame = display.newSprite("team/frame.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.15):addTo(iconFrame)
    cc.ui.UILabel.new({
      text = string.format("LV.%d", self.mTeamInfo[i].level),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, levelFrame:getContentSize().width * 0.5, levelFrame:getContentSize().height * 0.5):addTo(levelFrame)
    local numBg = display.newSprite("pvp/num_bg.png"):align(display.CENTER, iconFrame:getContentSize().width * 0.5, -25):addTo(iconFrame)
    local numLevel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = self.mTeamInfo[i].num,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, numBg:getContentSize().width * 0.5, numBg:getContentSize().height * 0.5):addTo(numBg)
    numLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    local cdLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = string.format(DYLang.getString("S122", ""), self.mTeamInfo[i].cd),
      size = 20,
      color = cc.c3b(126, 255, 22),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_TOP, iconFrame:getContentSize().width * 0.5, -50):addTo(iconFrame)
    cdLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  end
end

function M:addReward()
  if self.mIsAttacking == 0 then
    local lab1 = DYLabelTTF.new({
      text = self.mName,
      size = 22,
      color = cc.c3b(255, 255, 255),
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_LEFT, 94, 260):addTo(self.mBg)
    local lab2 = cc.ui.UILabel.new({
      text = DYLang.getString("S123", ""),
      size = 22,
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, lab1:getPositionX() + lab1:getContentSize().width + 5, lab1:getPositionY()):addTo(self.mBg)
  else
    local lab1 = cc.ui.UILabel.new({
      text = DYLang.getString("S124", ""),
      size = 22,
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 94, 260):addTo(self.mBg)
    local lab2 = DYLabelTTF.new({
      text = self.mName,
      size = 22,
      color = cc.c3b(255, 255, 255),
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_LEFT, lab1:getPositionX() + lab1:getContentSize().width + 5, lab1:getPositionY()):addTo(self.mBg)
    local lab3 = cc.ui.UILabel.new({
      text = DYLang.getString("S125", ""),
      size = 22,
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, lab2:getPositionX() + lab2:getContentSize().width + 5, lab2:getPositionY()):addTo(self.mBg)
  end
  if not self.mRewardInfo then
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(74, 143, 712, 100),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(self.mBg)
  for id, num in pairs(self.mRewardInfo) do
    local item = list:newItem()
    local content = IconItem.new(id, num)
    content:showItemTip()
    content:setScale(0.75)
    item:addContent(content)
    item:setItemSize(113, 100)
    list:addItem(item)
  end
  list:reload()
end

function M:addButton()
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):align(display.CENTER, 890, 184):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S126", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(147, 78, 1)
  })):onButtonClicked(function()
    self:closeCallBack()
  end)
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

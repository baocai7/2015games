local CLASS_NAME = "LayerPVPMatchInfo"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(info)
  dump(info)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mInfo = info
  if self.mInfo == nil then
    self:removeSelf()
    return
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self:initUI()
end

local function getQualityAndIcon(self, id)
  local model = DataUtils.getBuddhaModel(id) or {}
  local info = {}
  info.quality = model.quality or 1
  info.icon = model.npcIcon or ""
  info.isRebel = model.isRebel or 1
  return info
end

function M:initUI()
  local bg = display.newSprite("pvp/detail_bg.png")
  self.mNode:addChild(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.TOP_RIGHT, bg:getContentSize().width, bg:getContentSize().height):addTo(bg)
  local icon = display.newSprite("common_ui/frame3.png", bg:getContentSize().width * 0.15, bg:getContentSize().height * 0.7):scale(0.95):addTo(bg)
  display.newSprite(self.mInfo.icon, icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):addTo(icon)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = self.mInfo.nick,
    size = 25,
    color = cc.c3b(64, 32, 6),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.75):addTo(bg)
  local opponentLevel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "LV." .. self.mInfo.level,
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.64):addTo(bg)
  opponentLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local swordTag = display.newSprite("pvp/sword.png", bg:getContentSize().width * 0.8, bg:getContentSize().height * 0.73):addTo(bg)
  local num = self.mInfo.sword
  if 100000 <= num then
    local count = math.floor(num / 10000)
    num = count .. DYLang.getString("S42", "")
  end
  local swordlabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = num,
    size = 25,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, swordTag:getContentSize().width * 0.5, swordTag:getContentSize().height * 0.5):addTo(swordTag)
  swordlabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local buddhaTable = self.mInfo.buddhaInfo or {}
  if buddhaTable == "" then
    buddhaTable = {}
  end
  for i = 1, #buddhaTable do
    local star = tonumber(buddhaTable[i].star) or 0
    local level = tonumber(buddhaTable[i].level) or 0
    local quality = tonumber(buddhaTable[i].quality) or 0
    local isRebel = tonumber(buddhaTable[i].isRebel)
    local num = tonumber(buddhaTable[i].num) or 1
    local cd = tonumber(buddhaTable[i].cd) or 1
    cd = math.ceil(cd)
    local icon = display.newSprite("common_ui/frame" .. quality .. ".png", 115 * i - 10, bg:getContentSize().height * 0.4):scale(0.82):addTo(bg)
    local pTip
    icon:setTouchEnabled(true)
    icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name = event.name
      if name == "began" then
        if not pTip then
          pTip = self:showBuddhaTip(i)
          if not pTip then
            return false
          end
          pTip:setPosition(icon:getPositionX(), icon:getPositionY() + 155)
          pTip:addTo(bg, 5)
        end
        return true
      elseif name == "ended" then
        pTip:runAction(cc.RemoveSelf:create())
        pTip = nil
      end
    end)
    local buddhaIcon = display.newSprite(buddhaTable[i].icon, icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):addTo(icon)
    if 0 == isRebel then
      buddhaIcon:setScaleX(-1)
    end
    if 0 < star then
      local starPic = display.newSprite(string.format("upgrade/star%d.png", star)):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height):addTo(icon)
    end
    local levelFrame = display.newSprite("team/frame.png"):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.15):addTo(icon)
    cc.ui.UILabel.new({
      text = string.format("LV.%d", level),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, levelFrame:getContentSize().width * 0.5, levelFrame:getContentSize().height * 0.5):addTo(levelFrame)
    local numBg = display.newSprite("pvp/num_bg.png"):align(display.CENTER, icon:getContentSize().width * 0.5, -30):addTo(icon)
    local numLevel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = num,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, numBg:getContentSize().width * 0.5, numBg:getContentSize().height * 0.5):addTo(numBg)
    numLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    local cdLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = string.format(DYLang.getString("S816", ""), cd),
      size = 20,
      color = cc.c3b(126, 255, 22),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_TOP, icon:getContentSize().width * 0.5, -64):addTo(icon)
    cdLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  end
end

function M:showBuddhaTip(index)
  local info = self.mInfo.buddhaInfo or {}
  if not info[index] then
    return
  end
  local bg = display.newSprite("common_ui/common_tip.png")
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", info[index].quality)):scale(0.85):align(display.CENTER_LEFT, bg:getContentSize().width * 0.05, bg:getContentSize().height * 0.65):addTo(bg)
  local icon = display.newSprite(info[index].icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 == info[index].isRebel then
    icon:setScaleX(-1)
  end
  DYLabelTTF.new({
    text = info[index].name,
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width + 5, iconFrame:getPositionY() + 25):addTo(bg)
  DYLabelTTF.new({
    text = "Lv." .. info[index].level,
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width + 5, iconFrame:getPositionY() - 25):addTo(bg)
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S817", ""),
    size = 30,
    color = cc.c3b(255, 245, 4),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(iconFrame:getPositionX(), bg:getContentSize().height * 0.2):addTo(bg)
  local tips = {
    DYLang.getString("S818", ""),
    DYLang.getString("S819", ""),
    DYLang.getString("S820", ""),
    DYLang.getString("S821", ""),
    DYLang.getString("S822", ""),
    DYLang.getString("S823", ""),
    DYLang.getString("S824", ""),
    DYLang.getString("S825", ""),
    DYLang.getString("S826", ""),
    DYLang.getString("S827", "")
  }
  local tb = {
    info[index].tag1,
    info[index].tag2,
    info[index].tag3
  }
  local idx = 0
  for i = 1, #tb do
    local tag = tb[i]
    if 0 < tag then
      idx = idx + 1
      DYLabelTTF.new({
        text = tips[tag],
        size = 24,
        color = cc.c3b(255, 222, 120),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(lb:getPositionX() + lb:getContentSize().width + (idx - 1) * 95, lb:getPositionY()):addTo(bg)
    end
  end
  return bg
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

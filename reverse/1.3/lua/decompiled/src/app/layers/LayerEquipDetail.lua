local DYClass = "LayerEquipDetail"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M.scene(param)
  local scene = display.newScene()
  scene:addChild(M.new(param))
  return scene
end

local function M_filePath(name)
  return string.format("equipment/%s.png", name)
end

function M:ctor(param)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  if not param or "table" ~= type(param) then
    self:closeCallBack()
    return
  end
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mData = {}
  self:initData(param)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData(info)
  self.mData = GameManager.generateEquipmentData(info.ueid, info)
end

function M:initUI()
  local bg = display.newSprite("ranking/img_bottom.png", 0, 0):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 445, 675):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg)
  self:loadEquipmentInfo()
end

function M:loadEquipmentInfo()
  local data = self.mData
  local bg = self.mBg
  DYLabelTTF.new({
    text = data.name,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(233, 632):addTo(bg)
  local x = 233 - (data.maxStar - 1) * 12.5
  for i = 1, data.star do
    display.newSprite(M_filePath("icon_stars_n"), x, 597):addTo(bg)
    x = x + 25
  end
  for i = 1, data.maxStar - data.star do
    display.newSprite(M_filePath("icon_stars_p"), x, 597):addTo(bg)
    x = x + 25
  end
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", data.quality), 140, 530):scale(0.8):addTo(bg)
  display.newSprite("equipment/icon_back.png", 59, 59):addTo(iconFrame)
  display.newSprite(data.icon, 59, 59):addTo(iconFrame)
  local lb = DYLabelTTF.new({
    text = "\229\188\186\229\140\150\239\188\154" .. data.level,
    size = 20,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(207, 561):addTo(bg)
  local lbs = DYLabelTTF.new({
    text = "\233\153\144\229\136\182\239\188\154",
    size = 20,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(207, 540):addTo(bg)
  local lbn = DYLabelTTF.new({
    text = data.spirit .. "\231\129\181",
    size = 20,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(267, 540):addTo(bg)
  if 0 == data.spirit then
    lbn:setString("\230\151\160\233\153\144\229\136\182")
  end
  if 0 < data.uniqueId then
    local buddhaData = DataUtils.getBuddhaModelBaseInfo(data.uniqueId)
    lbn:setString(buddhaData.name)
  end
  local grades = {
    "\233\187\132",
    "\231\142\132",
    "\229\156\176",
    "\229\164\169",
    "\231\129\181"
  }
  local lbg = DYLabelTTF.new({
    text = "\232\175\132\228\187\183\239\188\154",
    size = 20,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(207, 519):addTo(bg)
  local label = DYLabelTTF.new({
    text = grades[data.grade],
    size = 20,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(267, 519):addTo(bg)
  if self.mData.shenbing then
    label:setString("\231\165\158\229\133\181")
  end
  DYLabelTTF.new({
    text = "\230\189\156\232\131\189\239\188\154",
    size = 20,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(207, 498):addTo(bg)
  DYLabelTTF.new({
    text = data.potential,
    size = 20,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(267, 498):addTo(bg)
  self:loadPropertyList()
end

function M:loadPropertyList()
  local listView = DYListView.new({
    viewRect = cc.rect(62, 48, 350, 426),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  for i = 1, 5 do
    local item = listView:newItem()
    local content = self:getListContent(i)
    content:setPosition(content.width * 0.5, content.height * 0.5)
    item:addContent(content)
    item:setItemSize(content.width, content.height)
    listView:addItem(item)
  end
  listView:reload()
end

local PROPERTIES = {
  [1] = "\232\161\128\233\135\143",
  [2] = "\230\148\187\229\135\187",
  [3] = "\231\137\169\231\144\134\233\152\178\229\190\161",
  [4] = "\233\173\148\230\179\149\233\152\178\229\190\161",
  [5] = "\233\135\145",
  [6] = "\230\156\168",
  [7] = "\230\176\180",
  [8] = "\231\129\171",
  [9] = "\229\156\159",
  [10] = "\229\133\168\228\186\148\232\161\140",
  [11] = "\232\163\133\229\164\135\232\161\128\233\135\143",
  [12] = "\232\163\133\229\164\135\230\148\187\229\135\187",
  [13] = "\232\163\133\229\164\135\231\137\169\233\152\178",
  [14] = "\232\163\133\229\164\135\233\173\148\233\152\178",
  [15] = "\230\154\180\229\135\187\231\142\135",
  [16] = "\230\138\151\230\154\180\231\142\135",
  [17] = "\230\154\180\229\135\187\228\188\164\229\174\179",
  [18] = "\230\154\180\228\188\164\229\135\143\229\133\141",
  [19] = "\229\145\189\228\184\173",
  [20] = "\233\151\170\233\129\191",
  [21] = "\228\188\164\229\174\179\229\135\143\229\133\141"
}
local LEVEL_ACTIVE = {
  15,
  30,
  45,
  60,
  90,
  120,
  150
}

function M:getListContent(tag)
  local content
  local tFunc = {
    [1] = function()
      content = self:getBaseProperties()
    end,
    [2] = function()
      content = self:getRelicsProperties()
    end,
    [3] = function()
      content = self:getLevelProperties()
    end,
    [4] = function()
      content = self:getStarProperties()
    end,
    [5] = function()
      content = self:getSuitProperties()
    end
  }
  tFunc[tag]()
  return content
end

function M:getBaseProperties()
  local node = display.newNode()
  node.width = 350
  node.height = 40 + (#self.mData.mainPropertyIds + #self.mData.randomPropertyIds + #self.mData.quenchingPropertyIds) * 30
  if self.mData.shenbing then
    node.height = 40 + (#self.mData.mainPropertyIds + #self.mData.randomPropertyIds) * 30
  end
  local tip = display.newSprite(M_filePath("img_reel_00")):addTo(node)
  tip:align(display.CENTER_LEFT, 0, node.height - 18)
  DYLabelTTF.new({
    text = "\229\159\186\231\161\128\229\177\158\230\128\167",
    size = 24,
    color = cc.c3b(255, 232, 199),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(6, 17):addTo(tip)
  local posY = node.height - 52
  for i = 1, #self.mData.mainPropertyIds do
    local id = self.mData.mainPropertyIds[i]
    local num = self.mData.mainPropertyNums[i]
    local label1 = DYLabelTTF.new({
      text = PROPERTIES[id] .. "\239\188\154",
      size = 20,
      color = cc.c3b(58, 38, 13),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(15, posY):addTo(node)
    local label2 = DYLabelTTF.new({
      text = num,
      size = 20,
      color = cc.c3b(58, 38, 13),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(label1:getPositionX() + label1:getContentSize().width, label1:getPositionY()):addTo(node)
    local addNum = math.round(self.mData.growNums[i] * self.mData.level)
    local label = DYLabelTTF.new({
      text = "    +" .. addNum,
      size = 20,
      color = cc.c3b(201, 94, 29),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(140, label1:getPositionY()):addTo(node)
    if 0 == self.mData.level then
      label:hide()
    end
    posY = posY - 30
  end
  for i = 1, #self.mData.randomPropertyIds do
    local id = self.mData.randomPropertyIds[i]
    local num = self.mData.randomPropertyNums[i]
    local label1 = DYLabelTTF.new({
      text = PROPERTIES[id] .. "\239\188\154",
      size = 20,
      color = cc.c3b(30, 140, 200),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(15, posY):addTo(node)
    if 10 < id and id < 21 then
      num = string.format("%d%%", num)
    end
    local label2 = DYLabelTTF.new({
      text = num,
      size = 20,
      color = cc.c3b(30, 140, 200),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(label1:getPositionX() + label1:getContentSize().width, label1:getPositionY()):addTo(node)
    posY = posY - 30
  end
  if self.mData.shenbing then
    node:setContentSize(node.width, node.height)
    return node
  end
  for i = 1, #self.mData.quenchingPropertyIds do
    local id = self.mData.quenchingPropertyIds[i]
    local num = self.mData.quenchingPropertyNums[i]
    local label1 = DYLabelTTF.new({
      text = PROPERTIES[id] .. "\239\188\154",
      size = 20,
      color = cc.c3b(0, 216, 255),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {
      lineColor = cc.c3b(1, 68, 72)
    }):pos(15, posY):addTo(node)
    local label2 = DYLabelTTF.new({
      text = num,
      size = 20,
      color = cc.c3b(0, 216, 255),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {
      lineColor = cc.c3b(1, 68, 72)
    }):pos(label1:getPositionX() + label1:getContentSize().width, label1:getPositionY()):addTo(node)
    posY = posY - 30
  end
  node:setContentSize(node.width, node.height)
  return node
end

function M:getRelicsProperties()
  local node = display.newNode()
  node.width = 350
  node.height = 1
  if not self.mData.shenbing then
    node:setContentSize(node.width, node.height)
    return node
  end
  node.height = 70
  if self.mData.skillId > 0 then
    node.height = 120
  end
  local tip = display.newSprite(M_filePath("img_reel_00")):addTo(node)
  tip:align(display.CENTER_LEFT, 0, node.height - 18)
  DYLabelTTF.new({
    text = "\231\165\158   \229\133\181",
    size = 24,
    color = cc.c3b(255, 232, 199),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(6, 17):addTo(tip)
  local posY = node.height - 52
  local id, num = tonumber(self.mData.relicsParam[1]), tonumber(self.mData.relicsParam[2])
  local str = string.format("\230\136\152\230\150\151\228\184\173\230\137\128\230\156\137\228\184\138\233\152\181\228\187\153\233\173\148%s\229\177\158\230\128\167+%d", PROPERTIES[id], num)
  local label1 = DYLabelTTF.new({
    text = str,
    size = 20,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(15, posY):addTo(node)
  if self.mData.skillId < 0 then
    node:setContentSize(node.width, node.height)
    return node
  end
  node.height = 120
  posY = posY - 18
  local skillData = DataUtils.getRelicsSkillModel(self.mData.skillId)
  local textStr = string.format("[%s]\239\188\154%s", skillData.name, skillData.intro)
  cc.ui.UILabel.new({
    text = textStr,
    size = 20,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(330, 52)
  }):align(display.TOP_LEFT, 15, posY):addTo(node)
  node:setContentSize(node.width, node.height)
  return node
end

function M:getLevelProperties()
  local node = display.newNode()
  node.width = 350
  node.height = 40 + #self.mData.levelPropertyIds * 30
  node:setContentSize(node.width, node.height)
  local tip = display.newSprite(M_filePath("img_reel_00")):addTo(node)
  tip:align(display.CENTER_LEFT, 0, node.height - 18)
  DYLabelTTF.new({
    text = "\229\188\186\229\140\150\230\191\128\230\180\187",
    size = 24,
    color = cc.c3b(255, 232, 199),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(6, 17):addTo(tip)
  local posY = node.height - 52
  for i = 1, #self.mData.levelPropertyIds do
    local id = self.mData.levelPropertyIds[i]
    local num = self.mData.levelPropertyNums[i]
    local textColor = cc.c3b(70, 43, 11)
    local textAdd = "    \239\188\136\229\183\178\230\191\128\230\180\187\239\188\137"
    if self.mData.level < LEVEL_ACTIVE[i] then
      textColor = cc.c3b(180, 160, 140)
      textAdd = "    \239\188\136\230\156\170\230\191\128\230\180\187\239\188\137"
    end
    local textStr = "+" .. num .. PROPERTIES[id]
    local label1 = DYLabelTTF.new({
      text = textStr,
      size = 20,
      color = textColor,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(15, posY):addTo(node)
    local label2 = DYLabelTTF.new({
      text = textAdd,
      size = 20,
      color = textColor,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(145, posY):addTo(node)
    posY = posY - 30
  end
  return node
end

function M:getStarProperties()
  local node = display.newNode()
  node.width = 350
  node.height = 40 + #self.mData.starPropertyIds * 30
  node:setContentSize(node.width, node.height)
  local tip = display.newSprite(M_filePath("img_reel_00")):addTo(node)
  tip:align(display.CENTER_LEFT, 0, node.height - 18)
  DYLabelTTF.new({
    text = "\231\134\148\231\130\188\229\177\158\230\128\167",
    size = 24,
    color = cc.c3b(255, 232, 199),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(6, 17):addTo(tip)
  local posY = node.height - 52
  for i = 1, #self.mData.starPropertyIds do
    local id = self.mData.starPropertyIds[i]
    local num = self.mData.starPropertyNums[i]
    if 10 < id and id < 21 then
      num = string.format("%d%%", num)
    end
    local textStr = "+" .. num .. PROPERTIES[id]
    local label1 = DYLabelTTF.new({
      text = textStr,
      size = 20,
      color = cc.c3b(80, 30, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(15, posY):addTo(node)
    posY = posY - 30
  end
  return node
end

function M:getSuitProperties()
  local node = display.newNode()
  node.width = 350
  node.height = 5
  if -1 == self.mData.suitId then
    node:setContentSize(node.width, node.height)
    return node
  end
  local suitData = DataUtils.getEquipmentSuitData(self.mData.suitId)
  node.height = 40 + #suitData.props * 30
  local tip = display.newSprite(M_filePath("img_reel_00")):addTo(node)
  tip:align(display.CENTER_LEFT, 0, node.height - 18)
  DYLabelTTF.new({
    text = "\229\165\151\232\163\133\229\177\158\230\128\167",
    size = 24,
    color = cc.c3b(255, 232, 199),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(6, 17):addTo(tip)
  local posY = node.height - 52
  for i = 1, #suitData.props do
    local id = suitData.props[i].id
    local num = suitData.props[i].num
    local textColor = cc.c3b(70, 43, 11)
    local textAdd = string.format("%s(%d\228\187\182)", suitData.name, suitData.props[i].count)
    if 10 < id and id < 21 then
      num = string.format("%d%%", num)
    end
    local textStr = textAdd .. "\239\188\154+" .. num .. PROPERTIES[id]
    local label1 = DYLabelTTF.new({
      text = textStr,
      size = 20,
      color = textColor,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(15, posY):addTo(node)
    posY = posY - 30
  end
  node:setContentSize(node.width, node.height)
  return node
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
  if self.mCallback then
    self.mCallback()
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
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

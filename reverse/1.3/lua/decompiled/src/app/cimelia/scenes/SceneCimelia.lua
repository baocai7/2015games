local LayerCimeliaEquip = require("app.cimelia.layers.LayerCimeliaEquip")
local LayerCimeliaUpgrade = require("app.cimelia.layers.LayerCimeliaUpgrade")
local LayerCimeliaSynthesize = require("app.cimelia.layers.LayerCimeliaSynthesize")
local LayerCimeliaRecast = require("app.cimelia.layers.LayerCimeliaRecast")
local IconCimeliaWiki = require("app.cimelia.icons.IconCimeliaWiki")
local IconPkBubble = require("app.icons.IconPkBubble")
local NoviceGuide = require("app.utils.NoviceGuide")
local DYClass = "SceneCimelia"
local M = {}
M = class(DYClass, function()
  return display.newScene(DYClass)
end)
local MAX_LEVEL = 80

function M:ctor()
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mPanelSynthesize = nil
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:loadAnimationFile()
  CMgr = require("app.cimelia.CimeliaManager")
  CMgr.init()
  self:initUI()
  self:initPkBubble()
  self:initData()
end

local function M_filePath(name)
  return string.format("cimelia/%s.png", name)
end

function M:initData()
  local function tFuncListener(jsonValue)
    CloudData.CIMELIA_LIST = {}
    
    for k, v in pairs(jsonValue.data.cimeliaList) do
      local ucid = v.id or 0
      CloudData.CIMELIA_LIST[ucid] = v
    end
    for i = 2007, 2012 do
      local id = tostring(i)
      CloudData.GAME_ITEM_INFO[id] = jsonValue.data.materialList[id] or 0
    end
    self.mTabBtnTable = {}
    self.mTag = 1
    if not (self.initTabBtn and self.initCimeliaInfo) or not self.dealUserProgress then
      return
    end
    self:initTabBtn()
    self:initCimeliaInfo(CloudData.CIMELIA_EQUIPED[1])
    self:dealUserProgress()
  end
  
  DYHttpMgr.cimeliaInit(tFuncListener)
  local cimeliaNumTotal = #DataRetainer.CIMELIA_INFO - 1
  self.mCimeliaList = {
    {},
    {},
    {}
  }
  for id = 1, cimeliaNumTotal do
    local pModel = DataUtils.getCimeliaTabelForWiki(id)
    if DYLang.getString("S1284", "") ~= pModel.name and DYLang.getString("S1285", "") ~= pModel.name then
      if pModel.type > 0 then
        table.insert(self.mCimeliaList[1], pModel)
      end
      if 1 == pModel.type then
        table.insert(self.mCimeliaList[2], pModel)
      end
      if 2 == pModel.type then
        table.insert(self.mCimeliaList[3], pModel)
      end
    elseif DYLang.getString("S1284", "") == pModel.name then
      if 1 == pModel.key then
        table.insert(self.mCimeliaList[1], pModel)
        table.insert(self.mCimeliaList[2], pModel)
      end
    elseif DYLang.getString("S1285", "") == pModel.name and 1 == pModel.key then
      table.insert(self.mCimeliaList[1], pModel)
      table.insert(self.mCimeliaList[3], pModel)
    end
  end
end

function M:initUI()
  display.newSprite("common_ui/common_bg.png", display.cx, display.cy):addTo(self, -1)
  self.mBg = display.newSprite(M_filePath("img_light_bottom"), display.cx, display.cy):addTo(self)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.97, self.mBg:getContentSize().height * 0.96):onButtonClicked(function()
    DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
    local nextScene = require("scenes.ChapterScene").new()
    display.replaceScene(nextScene, "fade", 0.2)
  end):addTo(self.mBg, 2)
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new()
  self:add(self.mPkBubble, 900)
end

function M:initTabBtn()
  local M_TAB_BTN = {
    {
      normal = "cimelia/tab_wand1.png",
      pressed = "cimelia/tab_wand1.png",
      disabled = "cimelia/tab_wand2.png"
    },
    {
      normal = "cimelia/tab_tower1.png",
      pressed = "cimelia/tab_tower1.png",
      disabled = "cimelia/tab_tower2.png"
    },
    {
      normal = "cimelia/tab_wiki1.png",
      pressed = "cimelia/tab_wiki1.png",
      disabled = "cimelia/tab_wiki2.png"
    }
  }
  for i = 1, #M_TAB_BTN do
    local btn = cc.ui.UIPushButton.new(M_TAB_BTN[i]):onButtonClicked(function()
      self:funcChange(i)
    end):align(display.CENTER_RIGHT, 46, self.mBg:getContentSize().height * (0.88 - i * 0.15)):addTo(self.mBg, 1)
    if 1 == i then
      btn:setButtonEnabled(false)
    end
    table.insert(self.mTabBtnTable, btn)
  end
  local synthesizeBtn = cc.ui.UIPushButton.new({
    normal = M_filePath("synthesize_pic1"),
    pressed = M_filePath("synthesize_pic1")
  }):align(display.CENTER_RIGHT, 32, self.mBg:getContentSize().height * 0.92):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    local unlockLevel = Const.FUNC_UNLOCK.cemeliamake or 12
    if unlockLevel <= CloudData.USER_LEVEL then
      DYAnalyze.event.onEvent("Click_Cime_Synthesize_Label", DYLang.getString("S1288", ""))
      LayerCimeliaSynthesize.new():addTo(self, 20)
    else
      local str = string.format(DYLang.getString("S1289", ""), unlockLevel)
      WSToast.new(str):addTo(self, 20)
    end
  end):addTo(self.mBg, 1)
  local pic = display.newSprite(M_filePath("synthesize_pic2")):align(display.CENTER_RIGHT, 0, synthesizeBtn:getContentSize().height * 0.5):opacity(0):addTo(synthesizeBtn)
  pic:runAction(cc.RepeatForever:create(transition.sequence({
    cc.FadeIn:create(0.75),
    cc.FadeOut:create(0.75)
  })))
end

function M:initCimeliaInfo(id)
  self.mFrameNode = display.newNode():addTo(self.mBg)
  self.mFrameNode:setContentSize(900, 640)
  self.mFrameNode:setAnchorPoint(0.5, 0.5)
  self.mFrameNode:setPosition(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5)
  local picFrame = display.newSprite(M_filePath("img_staff_back"), 205, 380):addTo(self.mFrameNode)
  self:initFuncBtn()
  if not id or 0 == tonumber(id) then
    return
  end
  self.mCimeliaModel = DataUtils.getCimeliaBaseInfo(id)
  local icon = display.newSprite(self.mCimeliaModel.icon):pos(picFrame:getContentSize().width * 0.16, picFrame:getContentSize().height * 0.84):addTo(picFrame)
  local pic = display.newSprite(self.mCimeliaModel.picture):pos(picFrame:getContentSize().width * 0.5, picFrame:getContentSize().height * 0.5):addTo(picFrame)
  if 2 == self.mCimeliaModel.type then
    local circle = display.newSprite("gamescene/tower_center.png"):scale(0.65):pos(pic:getContentSize().width * 0.58, pic:getContentSize().height * 0.21):addTo(pic, -1)
    circle:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 360)))
    pic:setPositionY(picFrame:getContentSize().height * 0.42)
  end
  self:addRecastAnimation(self.mCimeliaModel.type, pic)
  local nameFrame = display.newSprite("upgrade/name_frame.png"):align(display.CENTER_TOP, 205, 668):addTo(self.mFrameNode)
  local textColor = DataUtils.getCimeliaNameColor(self.mCimeliaModel.quality)
  DYLabelTTF.new({
    text = self.mCimeliaModel.name,
    size = 30,
    color = textColor,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(nameFrame:getContentSize().width * 0.5, nameFrame:getContentSize().height * 0.35):addTo(nameFrame)
  for i = 1, self.mCimeliaModel.stage do
    display.newSprite("cimelia/magatama.png"):align(display.TOP_RIGHT, picFrame:getContentSize().width - 10 - 18 * i, picFrame:getContentSize().height - 25):addTo(picFrame)
  end
  self:initCimeliaPro()
  self:initRecastPro()
  self:initCimeliaSkill()
  self:initElementProps()
  self:initCimeliaLevel()
end

function M:initCimeliaPro()
  local titleFrame = display.newSprite(M_filePath("img_title"), 645, 590):addTo(self.mFrameNode)
  DYLabelTTF.new({
    text = "\229\159\186\231\161\128\229\177\158\230\128\167",
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(110, 70, 50)
  }):pos(15, 20):addTo(titleFrame)
  local posY = 550
  for i = 1, #self.mCimeliaModel.proType do
    local proType = tonumber(self.mCimeliaModel.proType[i])
    local label1 = DYLabelTTF.new({
      text = CMgr.BASE_PROPERTIES[proType] .. "\239\188\154",
      size = 20,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {
      lineColor = cc.c3b(120, 40, 0),
      lineWidth = 1
    }):pos(415, posY):addTo(self.mFrameNode)
    local numStr = self.mCimeliaModel.proNum[i]
    local addStr = "\239\188\136+" .. self.mCimeliaModel.proAddNum[i] .. "\239\188\137"
    if 5 == proType then
      addStr = "\239\188\136" .. self.mCimeliaModel.proAddNum[i] .. "\239\188\137"
    elseif 6 == proType and -1 == tonumber(self.mCimeliaModel.proBaseNum[i]) then
      numStr = DYLang.getString("S1291", "")
      addStr = ""
    elseif 7 == proType then
      numStr = numStr .. "%"
      addStr = "\239\188\136" .. self.mCimeliaModel.proAddNum[i] .. "%\239\188\137"
    elseif 8 == proType then
      numStr = numStr .. "%"
      addStr = "\239\188\136+" .. self.mCimeliaModel.proAddNum[i] .. "%\239\188\137"
    end
    local numLabel = DYLabelTTF.new({
      text = numStr,
      size = 18,
      color = cc.c3b(80, 30, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(545, posY - 2):addTo(self.mFrameNode)
    local addLabel = DYLabelTTF.new({
      text = addStr,
      size = 18,
      color = cc.c3b(77, 155, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(605, posY - 2):addTo(self.mFrameNode)
    display.newSprite("upgrade/up.png"):scale(0.7):pos(700, posY):addTo(self.mFrameNode)
    posY = posY - 30
  end
  local gradeStr = {
    "\230\136\138",
    "\228\184\129",
    "\228\184\153",
    "\228\185\153",
    "\231\148\178"
  }
  local label1 = DYLabelTTF.new({
    text = "\230\179\149\229\153\168\232\181\132\232\180\168\239\188\154",
    size = 20,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(120, 40, 0),
    ineWidth = 1
  }):pos(415, posY):addTo(self.mFrameNode)
  local label2 = DYLabelTTF.new({
    text = gradeStr[self.mCimeliaModel.grade],
    size = 18,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(545, posY - 2):addTo(self.mFrameNode)
end

function M:initRecastPro()
  local titleFrame = display.newSprite(M_filePath("img_title"), 645, 360):addTo(self.mFrameNode)
  DYLabelTTF.new({
    text = "\229\188\128\229\133\137\229\177\158\230\128\167",
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(110, 70, 50)
  }):pos(15, 20):addTo(titleFrame)
  local posY = 320
  local ids = {
    1,
    3,
    7,
    8,
    12
  }
  local nums = {
    100,
    200,
    400,
    50,
    50
  }
  for i = 1, #self.mCimeliaModel.recastProps do
    local recastData = self.mCimeliaModel.recastProps[i]
    if recastData.type then
      local id, num = tonumber(recastData.type), tonumber(recastData.value)
      local label1 = DYLabelTTF.new({
        text = CMgr.PROPERTIES[id] .. "\239\188\154",
        size = 20,
        color = cc.c3b(255, 240, 0),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }, {
        lineColor = cc.c3b(120, 40, 0),
        lineWidth = 1
      }):pos(415, posY):addTo(self.mFrameNode)
      if 11 < id then
        num = num .. "%"
      end
      local numLabel = DYLabelTTF.new({
        text = "+" .. num,
        size = 20,
        color = cc.c3b(80, 30, 0),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(label1:getPositionX() + label1:getContentSize().width + 5, posY):addTo(self.mFrameNode)
      posY = posY - 30
    end
  end
end

function M:initCimeliaSkill()
  local titleFrame = display.newSprite(M_filePath("img_title"), 645, 155):addTo(self.mFrameNode)
  DYLabelTTF.new({
    text = "\230\179\149\229\153\168\230\138\128\232\131\189",
    size = 24,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(110, 70, 50)
  }):pos(15, 20):addTo(titleFrame)
  local skillFrame = display.newSprite("cimelia/skill_frame.png"):align(display.CENTER_LEFT, 410, 75):addTo(self.mFrameNode)
  local skillIcon = display.newSprite(self.mCimeliaModel.skillIcon):scale(0.6206896551724138):pos(skillFrame:getContentSize().width * 0.5, skillFrame:getContentSize().height * 0.5):addTo(skillFrame)
  local skillName = DYLabelTTF.new({
    text = self.mCimeliaModel.skillName,
    size = 20,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(120, 40, 0),
    lineWidth = 1
  }):pos(515, 110):addTo(self.mFrameNode)
  local elementStr = {
    "\230\176\180",
    "\231\129\171",
    "\233\135\145",
    "\230\156\168",
    "\229\156\159"
  }
  DYLabelTTF.new({
    text = "\228\186\148\232\161\140\239\188\154",
    size = 20,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(120, 40, 0),
    lineWidth = 1
  }):pos(770, 110):addTo(self.mFrameNode)
  DYLabelTTF.new({
    text = elementStr[self.mCimeliaModel.element],
    size = 20,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(820, 110):addTo(self.mFrameNode)
  local skillDesc = cc.ui.UILabel.new({
    text = self.mCimeliaModel.skillDesc,
    size = 20,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(380, 80)
  }):align(display.TOP_LEFT, 515, 85):addTo(self.mFrameNode)
end

function M:initCimeliaIntro()
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S1295", ""),
    size = 24,
    color = cc.c3b(255, 254, 1),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(self.mProFrame:getContentSize().width * 0.02, self.mProFrame:getContentSize().height * 0.2):addTo(self.mProFrame)
  local cimeliaDesc = cc.ui.UILabel.new({
    text = self.mCimeliaModel.desc,
    size = 22,
    color = cc.c3b(79, 46, 8),
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(415, 85)
  }):align(display.CENTER_LEFT, self.mProFrame:getContentSize().width * 0.03, self.mProFrame:getContentSize().height * 0.08):addTo(self.mProFrame)
end

function M:initCimeliaLevel()
  local levelLabel = DYLabelTTF.new({
    text = string.format("LV.%d", self.mCimeliaModel.level),
    size = 30,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(30, 135):addTo(self.mFrameNode)
  local rate = 3 > self.mCimeliaModel.quality and 3 or self.mCimeliaModel.quality
  local costNum = DataUtils.getExpCostCurrLevel(self.mCimeliaModel.level) * rate
  local excessNum = self.mCimeliaModel.excessExp
  local barBg = display.newSprite(M_filePath("img_bar_01"), 240, 135):addTo(self.mFrameNode)
  local progressTimer = cc.ProgressTimer:create(display.newSprite(M_filePath("img_bar_02"))):addTo(barBg)
  progressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  progressTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  progressTimer:setMidpoint(cc.p(0, 0))
  progressTimer:setBarChangeRate(cc.p(1, 0))
  progressTimer:setPercentage(excessNum / costNum * 100)
  local numLabel = DYLabelTTF.new({
    text = string.format("%d/%d", excessNum, costNum),
    size = 22,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):align(display.CENTER, barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  if self.mCimeliaModel.level >= MAX_LEVEL then
    numLabel:setString("max")
    progressTimer:setPercentage(100)
  end
end

local function getRatioInSection(num)
  local ratio = 0
  if 3000 < num then
    ratio = 1
  elseif 1200 < num then
    ratio = 0.8 + (num - 1200) / 1800 * 0.2
  elseif 700 < num then
    ratio = 0.6 + (num - 700) / 500 * 0.2
  elseif 300 < num then
    ratio = 0.4 + (num - 300) / 400 * 0.2
  elseif 50 < num then
    ratio = 0.2 + (num - 50) / 250 * 0.2
  else
    ratio = num / 50 * 0.2
  end
  return ratio
end

function M:initElementProps()
  local nums = {
    self.mCimeliaModel.propGold,
    self.mCimeliaModel.propWood,
    self.mCimeliaModel.propWater,
    self.mCimeliaModel.propFire,
    self.mCimeliaModel.propEarth
  }
  local points = {
    {0, 66},
    {-65, 22},
    {-40, -55},
    {40, -55},
    {65, 22}
  }
  local ratios = {}
  for i = 1, #nums do
    local r = getRatioInSection(nums[i])
    table.insert(ratios, r)
  end
  display.newSprite(M_filePath("img_five_01"), 800, 470):addTo(self.mFrameNode)
  local frame = display.newSprite(M_filePath("five_02"), 800, 470):scale(0.9):addTo(self.mFrameNode)
  local tempPos = {}
  for i = 1, #ratios do
    local x = points[i][1] * ratios[i] + 68
    local y = points[i][2] * ratios[i] + 68
    table.insert(tempPos, {x, y})
  end
  display.newPolygon(tempPos, {
    fillColor = cc.c4f(0, 1, 0.86, 0.6),
    borderColor = cc.c4f(1, 1, 1, 0),
    borderWidth = 0
  }):addTo(frame)
end

function M:initFuncBtn()
  local function createButton(params)
    local button = cc.ui.UIPushButton.new({
      normal = M_filePath("btn_small_01"),
      
      pressed = M_filePath("btn_small_02"),
      disabled = M_filePath("btn_small_03")
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = params.text,
      size = 30,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(70, 100, 0)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = params.text,
      size = 28,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(70, 100, 0)
    })):setButtonLabel("disabled", DYLabelTTF.new({
      text = params.text,
      size = 30,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {})):onButtonClicked(function(event)
      params.callback()
    end):align(display.CENTER, params.x, params.y)
    return button
  end
  
  local exchangeBtn = createButton({
    text = "\230\155\191\230\141\162",
    x = 90,
    y = 70,
    callback = handler(self, self.toExchangeLayer)
  }):addTo(self.mFrameNode)
  local upgradeBtn = createButton({
    text = "\229\141\135\231\186\167",
    x = 210,
    y = 70,
    callback = handler(self, self.toUpgradeLayer)
  }):addTo(self.mFrameNode)
  local recastBtn = createButton({
    text = "\229\188\128\229\133\137",
    x = 330,
    y = 70,
    callback = handler(self, self.toRecastLayer)
  }):addTo(self.mFrameNode)
  if 0 == tonumber(CloudData.CIMELIA_EQUIPED[self.mTag]) then
    self:performWithDelay(function()
      upgradeBtn:setButtonEnabled(false)
    end, 0)
  end
  if CloudData.USER_LEVEL < Const.FUNC_UNLOCK.recast then
    self:performWithDelay(function()
      recastBtn:setButtonEnabled(false)
    end, 0)
  end
end

function M:addRecastAnimation(tag, node)
  local file1 = {
    [1] = {
      name = "xing2_",
      from = 1,
      to = 23,
      pos = {72, 70}
    },
    [2] = {
      name = "xing3_",
      from = 1,
      to = 24,
      pos = {80, 40}
    },
    [3] = {
      name = "xing4_",
      from = 1,
      to = 24,
      pos = {72, 230}
    },
    [4] = {
      name = "xing5_",
      from = 1,
      to = 21,
      pos = {72, 190}
    },
    [5] = {
      name = "xing6_",
      from = 1,
      to = 22,
      pos = {72, 110}
    }
  }
  local file2 = {
    [1] = {
      name = "tasx1_",
      from = 1,
      to = 30,
      pos = {200, 50}
    },
    [2] = {
      name = "tasx2_",
      from = 1,
      to = 30,
      pos = {85, 50}
    },
    [3] = {
      name = "tasx4_",
      from = 1,
      to = 30,
      pos = {160, 125}
    },
    [4] = {
      name = "tasx5_",
      from = 1,
      to = 30,
      pos = {175, 130}
    },
    [5] = {
      name = "tasx6_",
      from = 1,
      to = 30,
      pos = {100, 180}
    }
  }
  for i = 1, #self.mCimeliaModel.recastProps do
    local file
    if 2 == tag then
      file = file2[i]
    else
      file = file1[i]
    end
    local frames = display.newFrames(file.name .. "%d.png", file.from, file.to)
    local animation = display.newAnimation(frames, 0.041666666666666664)
    local emptyPic = display.newSprite()
    emptyPic:setPosition(file.pos[1], file.pos[2])
    emptyPic:addTo(node)
    emptyPic:playAnimationForever(animation)
  end
end

function M:initCimeliaWiki()
  local bg = display.newSprite("cimelia/bg_info.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  self.mFrameNode = bg
  local picFrame = display.newSprite("cimelia/pic_frame.png"):pos(bg:getContentSize().width * 0.24, bg:getContentSize().height * 0.53):addTo(bg)
  local icon = display.newSprite():pos(picFrame:getContentSize().width * 0.17, picFrame:getContentSize().height * 0.86):addTo(picFrame)
  local pic = display.newSprite("cimelia/pic/pic7.png"):pos(picFrame:getContentSize().width * 0.5, picFrame:getContentSize().height * 0.5):addTo(picFrame)
  self.mCircle = display.newSprite("gamescene/tower_center.png"):scale(0.65):pos(pic:getContentSize().width * 0.58, pic:getContentSize().height * 0.21):hide():addTo(pic, -1)
  self.mCircle:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 360)))
  local nameFrame = display.newSprite("upgrade/name_frame.png"):align(display.CENTER_TOP, self.mBg:getContentSize().width * 0.255, self.mBg:getContentSize().height):addTo(self.mBg)
  local name = DYLabelTTF.new({
    text = "",
    size = 30,
    color = cc.c3b(88, 42, 8),
    font = GameManager.FONTNAME_TTF
  }):pos(nameFrame:getContentSize().width * 0.5, nameFrame:getContentSize().height * 0.32):addTo(nameFrame)
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S1299", ""),
    size = 25,
    color = cc.c3b(255, 240, 2),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(40, 120):addTo(bg)
  local skillName = DYLabelTTF.new({
    text = "",
    size = 20,
    color = cc.c3b(29, 140, 7),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb:getPositionX() + lb:getContentSize().width, lb:getPositionY() - 2):addTo(bg)
  local skillDesc = DYLabelTTF.new({
    text = "",
    size = 18,
    color = cc.c3b(82, 46, 11),
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(375, 65),
    dyalign = "TOP_LEFT"
  }):pos(lb:getPositionX(), 100):addTo(bg)
  self.mWikiInfo = {
    icon = icon,
    pic = pic,
    name = name,
    skillName = skillName,
    skillDesc = skillDesc
  }
  self.mWikiTab = {}
  self.mIconTable = {}
  local listFrame = display.newSprite("cimelia/bg_wiki.png"):pos(bg:getContentSize().width * 0.725, bg:getContentSize().height * 0.47):addTo(bg)
  self.mListFrame = listFrame
  local textList = {
    DYLang.getString("S1300", ""),
    DYLang.getString("S1301", ""),
    DYLang.getString("S1302", "")
  }
  for i = 1, #textList do
    local btn = cc.ui.UIPushButton.new({
      normal = "cimelia/btn1.png",
      pressed = "cimelia/btn1.png",
      disabled = "cimelia/btn2.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = textList[i],
      size = 24,
      color = cc.c3b(248, 227, 178),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(147, 105, 47)
    })):setButtonLabel("disabled", DYLabelTTF.new({
      text = textList[i],
      size = 30,
      color = cc.c3b(255, 246, 12),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(122, 75, 11)
    })):onButtonClicked(function()
      self:changeWikiTab(i)
    end):align(display.CENTER, 80 + (i - 1) * 135, listFrame:getContentSize().height + 18):addTo(listFrame, -1)
    if 1 == i then
      self:performWithDelay(function()
        btn:setButtonEnabled(false)
        self:initWikiList(self.mCimeliaList[1])
      end, 0)
    end
    table.insert(self.mWikiTab, btn)
  end
end

function M:initWikiList(tb)
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(11, 12, 420, 510),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(self.mListFrame, 1)
  local tb_count = #tb
  local totalNum = tb_count < 20 and 20 or tb_count
  local row = math.ceil(totalNum / 4)
  local endNum = 4
  for i = 1, row do
    local item = self.mListView:newItem()
    local content = display.newNode()
    for count = 1, endNum do
      local pModel = tb[count + (i - 1) * 4]
      local icon
      if pModel then
        icon = IconCimeliaWiki.new(pModel)
        table.insert(self.mIconTable, icon)
      else
        icon = IconCimeliaWiki.new()
      end
      icon:setPosition(100 * count - 50, 50)
      content:addChild(icon)
    end
    content:setContentSize(400, 100)
    item:addContent(content)
    item:setItemSize(400, 100)
    self.mListView:addItem(item)
  end
  self.mListView:reload()
  local icon = self.mIconTable[1]
  if icon then
    icon:setSelected(true)
    self:updateInfo(tb[1])
  end
end

function M:changeWikiTab(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  for i = 1, #self.mWikiTab do
    local tabBtn = self.mWikiTab[i]
    if index == i then
      tabBtn:setButtonEnabled(false)
    else
      tabBtn:setButtonEnabled(true)
    end
  end
  if self.mListView then
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
    self.mIconTable = {}
    self:initWikiList(self.mCimeliaList[index])
  end
  if 1 == index then
    DYAnalyze.event.onEvent("cimelia_wiki_all", DYLang.getString("S1303", ""))
  elseif 2 == index then
    DYAnalyze.event.onEvent("cimelia_wiki_wand", DYLang.getString("S1304", ""))
  elseif 3 == index then
    DYAnalyze.event.onEvent("cimelia_wiki_tower", DYLang.getString("S1305", ""))
  end
end

function M:updateInfo(cimeliaModel)
  self.mWikiInfo.icon:setTexture(cimeliaModel.icon)
  self.mWikiInfo.pic:setTexture(cimeliaModel.picture)
  self.mWikiInfo.name:setString(cimeliaModel.name)
  self.mWikiInfo.skillName:setString(cimeliaModel.skillName)
  self.mWikiInfo.skillDesc:setString(cimeliaModel.skillDesc)
  if 2 == cimeliaModel.type then
    self.mCircle:show()
  else
    self.mCircle:hide()
  end
end

function M:funcChange(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mTag = index
  for i = 1, #self.mTabBtnTable do
    local tabBtn = self.mTabBtnTable[i]
    if index == i then
      tabBtn:setButtonEnabled(false)
    else
      tabBtn:setButtonEnabled(true)
    end
  end
  if self.mFrameNode then
    self.mFrameNode:removeSelf()
    self.mFrameNode = nil
    if 3 == index then
      self:initCimeliaWiki()
      DYAnalyze.event.onEvent("cimelia_click_wiki", DYLang.getString("S1306", ""))
    else
      self:initCimeliaInfo(CloudData.CIMELIA_EQUIPED[index])
      if 1 == index then
        DYAnalyze.event.onEvent("cimelia_click_wand", DYLang.getString("S1307", ""))
      elseif 2 == index then
        DYAnalyze.event.onEvent("cimelia_click_tower", DYLang.getString("S1308", ""))
      end
    end
  end
end

function M:toExchangeLayer()
  local cimeliaType = LayerCimeliaEquip.TYPE_ATK
  if 2 == self.mTag then
    cimeliaType = LayerCimeliaEquip.TYPE_DEF
    DYAnalyze.event.onEvent("tower_replace", DYLang.getString("S1309", ""))
  else
    DYAnalyze.event.onEvent("wand_replace", DYLang.getString("S1310", ""))
  end
  
  local function tFuncListener(ucid)
    if not ucid then
      return
    end
    if self.mFrameNode then
      self.mFrameNode:removeSelf()
      self.mFrameNode = nil
      CloudData.CIMELIA_EQUIPED[self.mTag] = ucid
      self:initCimeliaInfo(ucid)
    end
  end
  
  LayerCimeliaEquip.new(cimeliaType, tFuncListener):addTo(self, 20)
end

function M:toUpgradeLayer()
  local function tFuncListener(ucid)
    if not ucid then
      return
    end
    if self.mFrameNode then
      self.mFrameNode:removeSelf()
      self.mFrameNode = nil
      self:initCimeliaInfo(ucid)
    end
  end
  
  LayerCimeliaUpgrade.new(CloudData.CIMELIA_EQUIPED[self.mTag], tFuncListener):addTo(self, 20)
  if 2 == self.mTag then
    DYAnalyze.event.onEvent("tower_upgrade", DYLang.getString("S1311", ""))
  else
    DYAnalyze.event.onEvent("wand_upgrade", DYLang.getString("S1312", ""))
  end
end

function M:toRecastLayer()
  local function tFuncListener(ucid)
    if not ucid then
      return
    end
    if self.mFrameNode then
      self.mFrameNode:removeSelf()
      self.mFrameNode = nil
      self:initCimeliaInfo(ucid)
    end
  end
  
  LayerCimeliaRecast.new(CloudData.CIMELIA_EQUIPED[self.mTag], tFuncListener):addTo(self, 20)
end

function M:touchListener(event)
  if "clicked" == event.name then
    local column = math.ceil(event.point.x / 100)
    local idx = (event.itemPos - 1) * 4 + column
    if idx > #self.mIconTable then
      return
    end
    for i = 1, #self.mIconTable do
      local icon = self.mIconTable[i]
      if i == idx then
        icon:setSelected(true)
        self:updateInfo(icon.mModel)
        DYAnalyze.event.onEvent("click_single_cimelia", DYLang.getString("S1313", ""))
      else
        icon:setSelected(false)
      end
    end
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    local nextScene = require("scenes.ChapterScene").new()
    display.replaceScene(nextScene, "fade", 0.2)
    return true
  end
  return false
end

function M:loadAnimationFile()
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_element0.plist")
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_element1.plist")
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_element2.plist")
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_element3.plist")
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_element4.plist")
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_element5.plist")
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_up1.plist")
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_up2.plist")
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_up3.plist")
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_up4.plist")
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_up5.plist")
  DYRes.loadSheet("cimelia/animation/wand/tx_wand_recast.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_element0.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_element1.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_element2.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_element3.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_element4.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_element5.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_up1.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_up2.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_up3.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_up4.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_up5.plist")
  DYRes.loadSheet("cimelia/animation/tower/tx_tower_recast.plist")
end

function M:unloadAnimationFile()
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_element0.plist")
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_element1.plist")
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_element2.plist")
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_element3.plist")
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_element4.plist")
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_element5.plist")
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_up1.plist")
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_up2.plist")
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_up3.plist")
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_up4.plist")
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_up5.plist")
  DYRes.unloadSheet("cimelia/animation/wand/tx_wand_recast.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_element0.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_element1.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_element2.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_element3.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_element4.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_element5.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_up1.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_up2.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_up3.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_up4.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_up5.plist")
  DYRes.unloadSheet("cimelia/animation/tower/tx_tower_recast.plist")
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  CMgr = nil
  self:unloadAnimationFile()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

function M:dealUserProgress()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  local userLevel = CloudData.USER_LEVEL
  if stageProgress == 8 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STAGE8_CEMLESCN_UPGRADE") then
    local guide = NoviceGuide.new("GUIDE_STAGE8_CEMLESCN_UPGRADE"):addTo(self)
    return
  end
  if userLevel == Const.FUNC_UNLOCK.cemeliamake and not DataUtils.getGuideIsFirstPlayed("GUIDE_CEMLESCN_COMPOSITE") then
    local function tFuncListener(jsonTable)
      local guideLayer = not (jsonTable.data["2011"] >= 10 and 10 <= jsonTable.data["2009"] and 10 <= jsonTable.data["2012"]) or DataUtils.getGuideIsFirstPlayed("GUIDE_CEMLESCN_COMPOSITE") or NoviceGuide.new("GUIDE_CEMLESCN_COMPOSITE"):addTo(self, 999)
    end
    
    DYHttpMgr.getUserThingCount(tFuncListener, {
      ids = "2011;2009;2012"
    })
    return
  end
  if userLevel == Const.FUNC_UNLOCK.cemeliamake and DataUtils.getGuideIsFirstPlayed("GUIDE_CEMLELAY_COMPOSITE_RESULT") and not DataUtils.getGuideIsFirstPlayed("GUIDE_CEMLELAY_COMPOSITE_EQUIP") then
    local guideLayer = NoviceGuide.new("GUIDE_CEMLELAY_COMPOSITE_EQUIP"):addTo(self, 999)
    return
  end
end

return M

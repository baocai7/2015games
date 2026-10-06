local LayerCommon = require("cimelia.layers.LayerCommon")
local LayerRule = require("app.layers.LayerRule")
local CLASS_NAME = "LayerCimeliaRecast"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local ANIMATION_FILE1 = {
  [0] = {
    name = "shengxizhangzg",
    from = 1,
    to = 10
  },
  [1] = {
    name = "shuixizhangzg",
    from = 1,
    to = 10
  },
  [2] = {
    name = "huoxizhangzg",
    from = 1,
    to = 10
  },
  [3] = {
    name = "jinxizhangzg",
    from = 1,
    to = 10
  },
  [4] = {
    name = "muxizhangzg",
    from = 1,
    to = 10
  },
  [5] = {
    name = "tuxizhangzg",
    from = 1,
    to = 10
  }
}
local ANIMATION_FILE2 = {
  [0] = {
    name = "btta",
    from = 1,
    to = 10
  },
  [1] = {
    name = "shuixitazg",
    from = 1,
    to = 10
  },
  [2] = {
    name = "houxitazg",
    from = 1,
    to = 10
  },
  [3] = {
    name = "jinxitazg",
    from = 1,
    to = 10
  },
  [4] = {
    name = "muxitazg",
    from = 1,
    to = 10
  },
  [5] = {
    name = "tuxitazg",
    from = 1,
    to = 10
  }
}
local ANIMATION_FILE3 = {
  [1] = {
    name = "fazhangtytx",
    from = 1,
    to = 46
  },
  [2] = {
    name = "tatykctx",
    from = 1,
    to = 50
  }
}

function M:ctor(equipedId, handler_)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mCallback = handler_
  self:initData(equipedId)
  self:initUI()
end

local function M_filePath(name)
  return string.format("cimelia/%s.png", name)
end

function M:initData(equipedId)
  self.mEquipedId = equipedId
  self.mCimeliaModel = DataUtils.getCimeliaBaseInfo(equipedId)
  self.mAniamtionFile = self:getAnimationFile()
  self.mRecastCostData = {}
  for i = 1, 3 do
    local costData = DataUtils.getCimeliaRecastCost(i)
    table.insert(self.mRecastCostData, costData)
  end
  self.mGradeUpCostData = {}
  for i = 1, 5 do
    local costData = DataUtils.getCimeliaGradeUpCost(i)
    table.insert(self.mGradeUpCostData, costData)
  end
  self.mGrade = self.mCimeliaModel.grade
  self.mModeIndex = 0
  self.mModeIndex1 = 0
  self.mTabButtons = {}
  self.mIsRecastUI = true
  self.mRecastData = self.mCimeliaModel.recastProps
end

function M:getAnimationFile()
  local index = self.mCimeliaModel.stage == 0 and 0 or self.mCimeliaModel.element
  local file
  if 1 == self.mCimeliaModel.type then
    file = ANIMATION_FILE1[index]
  else
    file = ANIMATION_FILE2[index]
  end
  return file
end

function M:initUI()
  local bg = display.newScale9Sprite(M_filePath("img_light_bottom_02")):addTo(self.mNode)
  self.mBg = bg
  self:loadCimeliaInfo()
  self:loadTabButton()
  self:loadRecastInfo()
  self:loadGradeUpInfo()
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\229\177\158\230\128\167\233\162\132\232\167\136",
    size = 30,
    color = cc.c3b(255, 246, 102),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(113, 43, 0)
  })):align(display.CENTER, 240, 95):onButtonClicked(function()
    LayerCommon.new(LayerCommon.PROP_PREVIEW, {
      tag = self.mCimeliaModel.type,
      attackType = self.mCimeliaModel.attackType
    }):addTo(self, 20)
  end):addTo(bg)
  LayerRule.newRuleIcon(LayerRule.CIMELIA_RECAST):pos(bg:getContentSize().width * 0.04, bg:getContentSize().height * 0.96):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.96, bg:getContentSize().height * 0.96):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg)
end

function M:loadCimeliaInfo()
  local picFrame = display.newSprite(M_filePath("img_staff_back"), 240, 360):addTo(self.mBg)
  local icon = display.newSprite(self.mCimeliaModel.icon):pos(picFrame:getContentSize().width * 0.16, picFrame:getContentSize().height * 0.86):addTo(picFrame)
  local pic = display.newSprite(self.mCimeliaModel.picture):pos(picFrame:getContentSize().width * 0.5, picFrame:getContentSize().height * 0.5):addTo(picFrame)
  self.mPic = pic
  self:addAnimationForCimelia(self.mCimeliaModel.type, pic)
  if 2 == self.mCimeliaModel.type then
    local circle = display.newSprite("gamescene/tower_center.png"):scale(0.65):pos(pic:getContentSize().width * 0.58, pic:getContentSize().height * 0.21):addTo(pic, -1)
    circle:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 360)))
    pic:setPositionY(picFrame:getContentSize().height * 0.42)
  end
  local nameFrame = display.newSprite("upgrade/name_frame.png"):align(display.CENTER_TOP, 240, 690):addTo(self.mBg)
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
end

function M:addAnimationForCimelia(tag, node)
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

function M:loadTabButton()
  local count = self.mGrade == 5 and 5 or self.mGrade + 1
  for i = 1, count do
    local recastData = self.mRecastData[i]
    local btnImg = "img_slot_add"
    if recastData then
      if recastData.quality then
        btnImg = "img_slot_" .. recastData.quality
      else
        btnImg = "img_slot_0"
      end
    end
    local button = cc.ui.UIPushButton.new({
      normal = M_filePath("tab_02"),
      disabled = M_filePath("tab_01")
    }):onButtonClicked(function(event)
      self:funcChange(event.target, i)
    end):align(display.CENTER_BOTTOM, 502 + (i - 1) * 110, 534):addTo(self.mBg, 1)
    button.index = i
    local buttonImg = display.newSprite(M_filePath(btnImg), 0, 50):addTo(button)
    
    function button:updateImg(quality)
      local img = "img_slot_" .. quality
      buttonImg:setTexture(M_filePath(img))
    end
    
    if i == 1 then
      button:setButtonEnabled(false)
      self.mCurrTab = button
    end
    table.insert(self.mTabButtons, button)
  end
end

function M:funcChange(button, index)
  self.mCurrTab:setButtonEnabled(true)
  button:setButtonEnabled(false)
  self.mCurrTab = button
  if index > self.mGrade then
    self.mFrame:hide()
    self.mFrame1:show()
    self.mIsRecastUI = false
    return
  end
  local recastData = self.mRecastData[index]
  if self.mIsRecastUI then
    self.mPropLabel:updateUI(recastData)
  else
    self.mFrame:show()
    self.mFrame1:hide()
    self.mPropLabel:updateUI(recastData)
  end
  self.mIsRecastUI = true
end

function M:loadRecastInfo()
  self.mFrame = display.newScale9Sprite(M_filePath("img_bottom_01"), 725, 300, cc.size(586, 478), cc.rect(40, 40, 1, 1)):addTo(self.mBg)
  
  local function createTitle(textStr, x, y)
    local titleFrame = display.newSprite(M_filePath("img_title"), x, y)
    DYLabelTTF.new({
      text = textStr,
      size = 24,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {
      lineColor = cc.c3b(110, 70, 50)
    }):pos(15, 20):addTo(titleFrame)
    return titleFrame
  end
  
  local data = self.mRecastData[1]
  local title1 = createTitle("\229\177\158\230\128\167", 243, 450):addTo(self.mFrame)
  self.mPropLabel = self:getRecastPropLabel(data)
  self.mPropLabel:setPosition(20, 400)
  self.mPropLabel:addTo(self.mFrame)
  local title3 = createTitle("\229\188\128\229\133\137\230\150\185\229\188\143", 243, 200):addTo(self.mFrame)
  self.mModeNode = self:loadRecastMode()
  self.mModeNode:setPosition(293, 135)
  self.mModeNode:addTo(self.mFrame)
  local title2 = createTitle("\230\182\136\232\128\151\230\157\144\230\150\153", 243, 350):addTo(self.mFrame)
  self.mCostNode = self:getItemCostUI(self.mRecastCostData)
  self.mCostNode:setPosition(293, 275)
  self.mCostNode:addTo(self.mFrame)
  self.mRecastBtn = cc.ui.UIPushButton.new({
    normal = M_filePath("btn_big_01"),
    pressed = M_filePath("btn_big_02"),
    disabled = M_filePath("btn_big_03")
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\229\188\128    \229\133\137",
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(70, 100, 0)
  })):setButtonLabel("pressed", DYLabelTTF.new({
    text = "\229\188\128    \229\133\137",
    size = 28,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(70, 100, 0)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = "\229\188\128    \229\133\137",
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {})):onButtonClicked(function(event)
    self:onEventRecast()
  end):align(display.CENTER, 293, 50):addTo(self.mFrame)
  if 0 == self.mModeIndex then
    self:performWithDelay(function()
      self.mRecastBtn:setButtonEnabled(false)
    end, 0)
  else
    self.mCostNode:updateUI(self.mModeIndex)
  end
end

function M:getRecastPropLabel(data)
  local function checkStr(data)
    local str = "?"
    
    if data and data.value then
      str = CMgr.PROPERTIES[tonumber(data.type)] .. " +" .. data.value
      if tonumber(data.type) > 11 then
        str = str .. "%"
      end
    end
    return str
  end
  
  local str = checkStr(data)
  local label = DYLabelTTF.new({
    text = str,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  })
  
  function label:updateUI(data)
    local str = checkStr(data)
    label:setString(str)
  end
  
  return label
end

function M:loadRecastMode()
  local node = display.newNode()
  node:setContentSize(586, 70)
  node:setAnchorPoint(0.5, 0.5)
  local initNum = 0
  local textStr = {
    "\233\147\156\231\186\167\229\188\128\229\133\137",
    "\233\147\182\231\186\167\229\188\128\229\133\137",
    "\233\135\145\231\186\167\229\188\128\229\133\137"
  }
  for i = 1, 3 do
    local posX, posY = 45 + (i - 1) * 190, 35
    local limitLevel = self.mRecastCostData[i].limitLevel
    if limitLevel > self.mCimeliaModel.level then
      display.newSprite(M_filePath("img_choose_03"), posX, posY):addTo(node)
      local str = string.format("(\230\179\149\229\153\168\231\173\137\231\186\167%d)", limitLevel)
      DYLabelTTF.new({
        text = str,
        size = 18,
        color = cc.c3b(100, 100, 100),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(posX + 30, posY):addTo(node)
    else
      cc.ui.UIPushButton.new({
        normal = M_filePath("img_choose_01")
      }):setButtonLabel("normal", DYLabelTTF.new({
        text = textStr[i],
        size = 24,
        color = cc.c3b(80, 30, 0),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      })):setButtonLabelOffset(30, 0):onButtonClicked(function(event)
        self:onEventModeChoose(event.target, i)
      end):align(display.CENTER, posX, posY):addTo(node)
      if 0 == initNum then
        initNum = i
      end
    end
  end
  self.mTip = display.newSprite(M_filePath("img_choose_02"), 0, 0):hide():addTo(node, 1)
  if 0 < initNum then
    self.mTip:show()
    self.mTip:setPosition(45, 35)
    self.mModeIndex = initNum
  end
  return node
end

function M:onEventModeChoose(button, index)
  self.mTip:setPosition(button:getPosition())
  self.mModeIndex = index
  self.mCostNode:updateUI(self.mModeIndex)
end

function M:loadGradeUpInfo()
  if 5 == self.mGrade then
    return
  end
  self.mFrame1 = display.newScale9Sprite(M_filePath("img_bottom_01"), 725, 300, cc.size(586, 478), cc.rect(40, 40, 1, 1)):addTo(self.mBg)
  self.mFrame1:hide()
  
  local function createTitle(textStr, x, y)
    local titleFrame = display.newSprite(M_filePath("img_title"), x, y)
    DYLabelTTF.new({
      text = textStr,
      size = 24,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {
      lineColor = cc.c3b(110, 70, 50)
    }):pos(15, 20):addTo(titleFrame)
    return titleFrame
  end
  
  local title1 = createTitle("\232\181\132\232\180\168", 243, 450):addTo(self.mFrame1)
  self.mPropLabel1 = self:getGradeUpLabel(data)
  self.mPropLabel1:setPosition(20, 400)
  self.mPropLabel1:addTo(self.mFrame1)
  local title3 = createTitle("\230\143\144\229\141\135\230\150\185\229\188\143", 243, 200):addTo(self.mFrame1)
  self.mModeNode1 = self:loadGradeUpMode()
  self.mModeNode1:setPosition(293, 135)
  self.mModeNode1:addTo(self.mFrame1)
  local title2 = createTitle("\230\182\136\232\128\151\230\157\144\230\150\153", 243, 350):addTo(self.mFrame1)
  self.mCostNode1 = self:getItemCostUI(self.mGradeUpCostData)
  self.mCostNode1:setPosition(293, 275)
  self.mCostNode1:addTo(self.mFrame1)
  self.mCostNode1:updateUI(self.mModeIndex1)
  self.mGradeUpBtn = cc.ui.UIPushButton.new({
    normal = M_filePath("btn_big_01"),
    pressed = M_filePath("btn_big_02"),
    disabled = M_filePath("btn_big_03")
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\232\181\132\232\180\168\230\143\144\229\141\135",
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(70, 100, 0)
  })):setButtonLabel("pressed", DYLabelTTF.new({
    text = "\232\181\132\232\180\168\230\143\144\229\141\135",
    size = 28,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(70, 100, 0)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = "\232\181\132\232\180\168\230\143\144\229\141\135",
    size = 30,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {})):onButtonClicked(function(event)
    self:onEventGradeUp()
  end):align(display.CENTER, 293, 50):addTo(self.mFrame1)
end

function M:getGradeUpLabel()
  local textStr = {
    "\230\136\138",
    "\228\184\129",
    "\228\184\153",
    "\228\185\153",
    "\231\148\178"
  }
  local label = DYLabelTTF.new({
    text = textStr[self.mGrade] .. "\226\134\146?",
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  })
  
  function label:updateUI(grade)
    label:setString(textStr[grade] .. "\226\134\146?")
  end
  
  return label
end

function M:loadGradeUpMode()
  local node = display.newNode()
  node:setContentSize(586, 70)
  node:setAnchorPoint(0.5, 0.5)
  self.mTip1 = display.newSprite(M_filePath("img_choose_02"), 355, 35):addTo(node, 1)
  self.mModeIndex1 = self.mGrade
  local textStr = {
    "\233\154\143\230\156\186\233\135\141\231\189\174",
    "\229\155\186\229\174\154\230\143\144\229\141\135"
  }
  for i = 1, #textStr do
    local posX, posY = 45 + (i - 1) * 310, 35
    cc.ui.UIPushButton.new({
      normal = M_filePath("img_choose_01")
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = textStr[i],
      size = 24,
      color = cc.c3b(80, 30, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    })):setButtonLabelOffset(30, 0):onButtonClicked(function(event)
      self:onEventModeChoose1(event.target, i)
    end):align(display.CENTER, posX, posY):addTo(node)
  end
  return node
end

function M:onEventModeChoose1(button, index)
  self.mTip1:setPosition(button:getPosition())
  self.mModeIndex1 = index == 2 and self.mGrade or 5
  self.mCostNode1:updateUI(self.mModeIndex1)
end

function M:getItemCostUI(data)
  local node = display.newNode()
  node:setContentSize(586, 96)
  node:setAnchorPoint(0.5, 0.5)
  local costNodeList = {
    {},
    {},
    {},
    {},
    {}
  }
  node.currId = 0
  
  local function createCostUI(id)
    local t = costNodeList[id]
    local costData = data[id]
    for i = 1, #costData.itemIds do
      local posX, posY = 60 + 160 * (i - 1), 48
      local itemId, num = costData.itemIds[i], tonumber(costData.costNums[i])
      local model = DataUtils.getItemModel(itemId)
      local frame = display.newSprite(string.format("common_ui/frame%d.png", model.quality), posX, posY):scale(0.65):addTo(node)
      local icon = display.newSprite(model.itemIcon, 59, 59):addTo(frame)
      local label = DYLabelTTF.new({
        text = model.currNum .. "/" .. num,
        size = 24,
        color = cc.c3b(80, 30, 0),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(posX + 40, posY):addTo(node)
      label.itemId = itemId
      label.costNum = num
      if num > model.currNum then
        label:setColor(cc.c3b(210, 0, 0))
      end
      table.insert(t, frame)
      table.insert(t, label)
    end
  end
  
  function node:updateUI(id)
    if costNodeList[self.currId] then
      for k, v in pairs(costNodeList[self.currId]) do
        v:hide()
      end
    end
    self.currId = id
    if 0 < #costNodeList[id] then
      for k, v in pairs(costNodeList[id]) do
        v:show()
      end
      return
    end
    createCostUI(id)
  end
  
  function node:updateLabel(param)
    for k, v in pairs(costNodeList[self.currId]) do
      if v.itemId then
        local costNum = v.costNum
        local currNum = CloudData.GAME_ITEM_INFO[tostring(v.itemId)]
        if param then
          costNum = param[v.itemId]
        end
        v:setString(currNum .. "/" .. costNum)
        if currNum < costNum then
          v:setColor(cc.c3b(210, 0, 0))
        end
      end
    end
  end
  
  return node
end

function M:onEventRecast()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    for k, v in pairs(jsonTable.data.drop) do
      DataUtils.updateItemNum(k, v)
    end
    local newData = jsonTable.data.prop
    self.mNewData = newData
    self.mCostNode:updateLabel()
    local params = {
      curData = self.mRecastData[self.mCurrTab.index],
      newData = newData,
      ucid = self.mEquipedId,
      index = self.mCurrTab.index
    }
    LayerCommon.new(LayerCommon.PROP_REPLACE, params, handler(self, self.onEventRecastUpdate)):addTo(self, 20)
  end
  
  DYHttpMgr.cimeliaRecast(tFuncListener, {
    ucid = self.mEquipedId,
    id = self.mModeIndex
  })
end

function M:onEventRecastUpdate()
  self.mRecastData[self.mCurrTab.index] = self.mNewData
  self.mCurrTab:updateImg(self.mNewData.quality)
  self.mPropLabel:updateUI(self.mNewData)
  self:addRecastAnimation(self.mPic)
end

function M:onEventGradeUp()
  if 5 == self.mModeIndex1 then
    LayerCommon.new(LayerCommon.GRADE_UP_ALERT, params, handler(self, self.gradeUpCallback)):addTo(self, 20)
    return
  end
  self:gradeUpCallback()
end

function M:gradeUpCallback()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    for k, v in pairs(jsonTable.data.drop) do
      DataUtils.updateItemNum(k, v)
    end
    CloudData.CIMELIA_LIST[tonumber(self.mEquipedId)] = jsonTable.data.cimelia
    self.mCimeliaModel = DataUtils.getCimeliaBaseInfo(self.mEquipedId)
    self.mGrade = self.mCimeliaModel.grade
    self.mRecastData = self.mCimeliaModel.recastProps
    self:addGradeUpAnimation(self.mPic)
    self:performWithDelay(function()
      self:addRecastAnimation(self.mPic)
    end, 1.5)
    local currGrade = self.mGrade
    if 5 == self.mModeIndex1 then
      currGrade = 5
    end
    if self.mModeIndex1 ~= 5 and currGrade == 5 then
      currGrade = 4
    end
    local costData = self.mGradeUpCostData[currGrade]
    local costParam = {}
    for i = 1, #costData.itemIds do
      costParam[costData.itemIds[i]] = tonumber(costData.costNums[i])
    end
    self.mPropLabel1:updateUI(self.mGrade)
    self.mCostNode1:updateLabel(costParam)
    for k, v in pairs(self.mTabButtons) do
      v:runAction(cc.RemoveSelf:create())
    end
    self.mTabButtons = {}
    self:loadTabButton()
    self:funcChange(self.mTabButtons[self.mGrade], self.mGrade)
    local tb = {
      "\230\136\138",
      "\228\184\129",
      "\228\184\153",
      "\228\185\153",
      "\231\148\178"
    }
    local textStr = "\230\179\149\229\153\168\232\181\132\232\180\168\230\143\144\229\141\135\229\136\176" .. tb[self.mGrade] .. "\231\186\167\239\188\129"
    if 5 == self.mModeIndex1 then
      textStr = "\230\179\149\229\153\168\232\181\132\232\180\168\233\154\143\230\156\186\233\135\141\231\189\174\229\136\176" .. tb[self.mGrade] .. "\231\186\167\239\188\129"
    end
    WSToast.new(textStr):addTo(self, 20)
  end
  
  DYHttpMgr.cimeliaGradeUp(tFuncListener, {
    ucid = self.mEquipedId,
    isRandom = self.mModeIndex1 == 5 and 1 or 0
  })
end

function M:addRecastAnimation(node)
  local file = self.mAniamtionFile
  local frames = display.newFrames(file.name .. "%d.png", file.from, file.to)
  local animation = display.newAnimation(frames, 0.041666666666666664)
  local emptyPic = display.newSprite()
  emptyPic:setPosition(node:getContentSize().width * 0.5, node:getContentSize().height * 0.5)
  emptyPic:addTo(node)
  emptyPic:playAnimationOnce(animation, true)
end

function M:addGradeUpAnimation(node)
  local file = ANIMATION_FILE3[self.mCimeliaModel.type]
  local deltaY, scaleParam = 100, 2
  if 2 == self.mCimeliaModel.type then
    deltaY = 30
  end
  local frames = display.newFrames(file.name .. "%d.png", file.from, file.to)
  local animation = display.newAnimation(frames, 0.041666666666666664)
  local emptyPic = display.newSprite()
  emptyPic:setScale(scaleParam)
  emptyPic:setPosition(node:getContentSize().width * 0.5, node:getContentSize().height * 0.5 + deltaY)
  emptyPic:addTo(node)
  emptyPic:playAnimationOnce(animation, true)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback(self.mEquipedId)
  end
  self:removeSelf()
end

return M

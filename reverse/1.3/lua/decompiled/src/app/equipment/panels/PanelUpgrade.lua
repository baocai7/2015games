local DYClass = "PanelUpgrade"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)
local MAX_AUTO_NUM = 4
local MAX_LEVEL = 160

local function M_filePath(name)
  return string.format("equipment/%s.png", name)
end

function M:ctor(params)
  cc(self):addComponent("framework.cc.components.behavior.EventProtocol"):exportMethods()
  self:setContentSize(532, 647)
  self.mData = params.data
  self.mLevel = self.mData.level
  self.mCost = DataUtils.getEquipmentUpgradeCost(self.mData.level + 1, self.mData.quality)
  self.mIsExcessed = false
  self.mExcessExp = self.mData.leftExp
  self.mIronCost = 0
  self.mEssenceCost = 0
  if self.mLevel >= CloudData.USER_LEVEL * 2 then
    self.mIsExcessed = true
  end
  self.mExpAddNum = 0
  local bg = display.newSprite(M_filePath("img_reel"), 216, 324):addTo(self)
  self.mBg = bg
  DYLabelTTF.new({
    text = self.mData.name,
    size = 30,
    color = cc.c3b(70, 43, 11),
    font = GameManager.FONTNAME_TTF
  }):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height - 36):addTo(bg)
  local bottom = display.newSprite(M_filePath("bg_02")):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height - 140):addTo(bg)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mData.quality)):scale(0.8):addTo(bottom)
  iconFrame:pos(bottom:getContentSize().width * 0.52, bottom:getContentSize().height * 0.54)
  display.newSprite("equipment/icon_back.png", 59, 59):addTo(iconFrame)
  display.newSprite(self.mData.icon, 59, 59):addTo(iconFrame)
  local levelFrame = display.newSprite(M_filePath("img_01")):pos(iconFrame:getContentSize().width - 5, 5):addTo(iconFrame)
  self.mLevelLabel = cc.ui.UILabel.new({
    text = self.mData.level,
    size = 18,
    color = cc.c3b(255, 255, 15),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, levelFrame:getContentSize().width * 0.5, levelFrame:getContentSize().height * 0.5):addTo(levelFrame)
  self.mLevelFrame = levelFrame
  local excessNum, costNum = self.mExcessExp, self.mCost
  local barBg = display.newSprite(M_filePath("bai_01")):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height - 210):addTo(bg)
  self.mProTimer = cc.ProgressTimer:create(display.newSprite(M_filePath("bar_02"))):addTo(barBg)
  self.mProTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.mProTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  self.mProTimer:setMidpoint(cc.p(0, 0))
  self.mProTimer:setBarChangeRate(cc.p(1, 0))
  self.mProTimer:setPercentage(excessNum / costNum * 100)
  self.mNumLabel = DYLabelTTF.new({
    text = excessNum .. "/" .. costNum,
    size = 16,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 2)
  if self.mLevel == MAX_LEVEL then
    self.mProTimer:setPercentage(100)
    self.mNumLabel:setString("max")
  end
  self.mAddLabel = DYLabelTTF.new({
    text = "",
    size = 24,
    color = cc.c3b(72, 153, 6),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(barBg:getPositionX() + 100, barBg:getPositionY()):addTo(bg)
  self:loadProperties()
  self:loadIronCost()
  self:loadUpgradeCost()
  self:loadFuncBtn()
end

function M:loadProperties()
  self.mPropLabels = {}
  local tip = display.newSprite(M_filePath("img_reel_00")):addTo(self.mBg)
  tip:align(display.CENTER_LEFT, 93, 400)
  DYLabelTTF.new({
    text = "\229\159\186\231\161\128\229\177\158\230\128\167",
    size = 22,
    color = cc.c3b(240, 220, 200),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(46, 26, 1)
  }):pos(12, 17):addTo(tip)
  local posY = 365
  for i = 1, #self.mData.mainPropertyIds do
    local id = self.mData.mainPropertyIds[i]
    local num = self.mData.mainPropertyNums[i]
    local label1 = DYLabelTTF.new({
      text = EMgr.PROPERTIES[id] .. "\239\188\154",
      size = 20,
      color = cc.c3b(58, 38, 13),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(108, posY):addTo(self.mBg)
    local label2 = DYLabelTTF.new({
      text = num,
      size = 20,
      color = cc.c3b(58, 38, 13),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(label1:getPositionX() + label1:getContentSize().width, label1:getPositionY()):addTo(self.mBg)
    local addNum = self.mData.growNums[i]
    local countNum = math.round(addNum * self.mData.level)
    local lable = DYLabelTTF.new({
      text = "+" .. countNum,
      size = 20,
      color = cc.c3b(201, 94, 29),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(243, label1:getPositionY()):addTo(self.mBg)
    table.insert(self.mPropLabels, lable)
    DYLabelTTF.new({
      text = string.format("+%.1f", addNum),
      size = 20,
      color = cc.c3b(72, 153, 6),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(325, label1:getPositionY()):addTo(self.mBg)
    posY = posY - 30
  end
end

function M:loadIronCost()
  local tip = display.newSprite(M_filePath("img_reel_00")):addTo(self.mBg)
  tip:align(display.CENTER_LEFT, 93, 290)
  DYLabelTTF.new({
    text = "\230\182\136\232\128\151",
    size = 22,
    color = cc.c3b(240, 220, 200),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(46, 26, 1)
  }):pos(12, 17):addTo(tip)
  local iconFrame = display.newSprite("common_ui/frame4.png", 266, 240):scale(0.4):addTo(self.mBg)
  display.newSprite("item_icon/icon_10.png", 59, 59):addTo(iconFrame)
  local currNum, totalNum = 0, CloudData.IRON
  local frame = display.newScale9Sprite(M_filePath("img_basemap_0"), 266, 180, cc.size(311, 60), cc.rect(100, 12, 1, 1)):addTo(self.mBg)
  local labelFrame = display.newSprite(M_filePath("img_basemap_1"), 105, 30):addTo(frame)
  local ironLabel = DYLabelTTF.new({
    text = 0,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):pos(41, 20):addTo(labelFrame)
  self.mIronLabel = ironLabel
  
  local function tFuncAdd()
    if self.mIsOnAction then
      return
    end
    if self.mIronCost >= CloudData.IRON then
      WSToast.new("\233\153\168\233\147\129\228\184\141\232\182\179\239\188\129"):addTo(display.getRunningScene(), 50)
      return
    end
    if self.mLevel >= CloudData.USER_LEVEL * 2 then
      WSToast.new("\229\183\178\232\190\190\229\189\147\229\137\141\230\156\128\233\171\152\231\173\137\231\186\167\239\188\129"):addTo(display.getRunningScene(), 50)
      return
    end
    local leftIron = CloudData.IRON - self.mIronCost
    local cost = DataUtils.getEquipmentUpgradeCost(self.mLevel + 1, self.mData.quality)
    local ironCost = cost - self.mExcessExp
    ironCost = leftIron < ironCost and leftIron or ironCost
    self.mIronCost = self.mIronCost + ironCost
    ironLabel:setString(self.mIronCost)
    self:updateLabel(true, ironCost)
  end
  
  local function tFuncMinus()
    if self.mIsOnAction or 0 == self.mIronCost then
      return
    end
    local ironCost = self.mExcessExp
    if 0 == ironCost then
      ironCost = DataUtils.getEquipmentUpgradeCost(self.mLevel, self.mData.quality)
    end
    self.mIronCost = self.mIronCost - ironCost
    if 0 > self.mIronCost then
      ironCost = ironCost + self.mIronCost
      self.mIronCost = 0
    end
    ironLabel:setString(self.mIronCost)
    self:updateLabel(false, ironCost)
  end
  
  local function tFuncMax()
    if self.mIsOnAction then
      return
    end
    if self.mIronCost >= CloudData.IRON then
      WSToast.new("\233\153\168\233\147\129\228\184\141\232\182\179\239\188\129"):addTo(display.getRunningScene(), 50)
      return
    end
    if self.mLevel >= CloudData.USER_LEVEL * 2 then
      WSToast.new("\229\183\178\232\190\190\229\189\147\229\137\141\230\156\128\233\171\152\231\173\137\231\186\167\239\188\129"):addTo(display.getRunningScene(), 50)
      return
    end
    local cost1 = DataUtils.getEquipmentCountCostToLevel(self.mLevel, self.mData.quality)
    local cost2 = DataUtils.getEquipmentCountCostToLevel(CloudData.USER_LEVEL * 2, self.mData.quality)
    local ironCost = cost2 - cost1 - self.mExcessExp
    local leftIron = CloudData.IRON - self.mIronCost
    ironCost = ironCost > leftIron and leftIron or ironCost
    self.mIronCost = self.mIronCost + ironCost
    ironLabel:setString(self.mIronCost)
    self:updateLabel(true, ironCost, true)
  end
  
  local function createButton(img, pos, listener)
    local button = cc.ui.UIPushButton.new(img)
    button:setScale(0.8)
    button:onButtonClicked(listener)
    button:setPosition(pos)
    button:addTo(frame)
  end
  
  createButton({
    normal = "cimelia/btn_reduce_n.png",
    pressed = "cimelia/btn_reduce_p.png"
  }, cc.p(33, 30), tFuncMinus)
  createButton({
    normal = "cimelia/btn_plus_n.png",
    pressed = "cimelia/btn_plus_p.png"
  }, cc.p(175, 30), tFuncAdd)
  createButton({
    normal = "cimelia/btn_max_n.png",
    pressed = "cimelia/btn_max_p.png"
  }, cc.p(275, 30), tFuncMax)
end

function M:loadUpgradeCost()
  local frame = display.newScale9Sprite(M_filePath("img_basemap_0"), 266, 120, cc.size(311, 40), cc.rect(100, 12, 1, 1)):addTo(self.mBg)
  local sp = display.newSprite("item_icon/pic_essence.png", 25, 20):scale(0.6):addTo(frame)
  self.mCostLabel = DYLabelTTF.new({
    text = self.mEssenceCost,
    size = 24,
    color = cc.c3b(58, 38, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(60, 20):addTo(frame)
end

function M:loadFuncBtn()
  local btnOnekey = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_orange_n.png",
    pressed = "common_ui/btn_orange_p.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\228\184\128\233\148\174\230\183\187\229\138\160",
    size = 25,
    color = cc.c3b(236, 255, 25),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(75, 41, 3)
  })):setButtonLabel("pressed", DYLabelTTF.new({
    text = "\228\184\128\233\148\174\230\183\187\229\138\160",
    size = 23,
    color = cc.c3b(236, 255, 25),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(75, 41, 3)
  })):onButtonClicked(function()
    self:onEventOnekey()
  end):align(display.CENTER, 180, 50):addTo(self.mBg)
  local btnUpgrade = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\229\188\186   \229\140\150",
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(65, 76, 15)
  })):setButtonLabel("pressed", DYLabelTTF.new({
    text = "\229\188\186   \229\140\150",
    size = 23,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(65, 76, 15)
  })):onButtonClicked(function()
    self:onEventUpgrade()
  end):align(display.CENTER, 352, 50):addTo(self.mBg)
end

function M:onEventOnekey()
  if self.mIsOnAction then
    return
  end
  local countCost1 = DataUtils.getEquipmentCountCostToLevel(self.mLevel, self.mData.quality)
  local countCost2 = DataUtils.getEquipmentCountCostToLevel(CloudData.USER_LEVEL * 2, self.mData.quality)
  local countNum = countCost2 - countCost1 - self.mExcessExp
  if countNum <= 0 then
    WSToast.new("\229\183\178\232\190\190\229\189\147\229\137\141\230\156\128\233\171\152\231\173\137\231\186\167\239\188\129"):addTo(display.getRunningScene(), 50)
    return
  end
  self:dispatchEvent({
    name = EMgr.EVENT_SELECT_ONEKEY,
    data = {countNum = countNum}
  })
end

function M:onEventUpgrade()
  if self.mEssenceCost > CloudData.ESSENCE then
    WSToast.new("\231\178\190\229\141\142\231\159\179\228\184\141\232\182\179\239\188\129"):addTo(display.getRunningScene(), 50)
    return
  end
  self:dispatchEvent({
    name = EMgr.EVENT_EQUIP_UPGRADE,
    data = {
      ironNum = self.mIronCost
    }
  })
end

function M:updateLabel(flag, addNum, isMax)
  self.mIsOnAction = true
  local textStr = 0
  if flag then
    textStr = "+" .. addNum
    self.mExpAddNum = self.mExpAddNum + addNum
    if isMax then
      self:expIncreaseMax(addNum)
    else
      self:expIncrease(addNum)
    end
  else
    textStr = "-" .. addNum
    self.mExpAddNum = self.mExpAddNum - addNum
    self:expDecrease(addNum)
  end
  local lb = cc.ui.UILabel.new({
    UILabelType = 2,
    text = textStr,
    size = 20,
    color = display.COLOR_GREEN,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height - 252):addTo(self.mBg, 3)
  lb:runAction(transition.sequence({
    cc.MoveBy:create(0.5, cc.p(0, 50)),
    cc.CallFunc:create(function()
      lb:removeSelf()
    end)
  }))
end

function M:expIncrease(addNum)
  local cost = DataUtils.getEquipmentUpgradeCost(self.mLevel + 1, self.mData.quality)
  local excessNum = self.mExcessExp
  if cost <= addNum + excessNum then
    self.mLevel = self.mLevel + 1
    self.mNumLabel:setString(string.format("%d/%d", cost, cost))
    self.mAddLabel:setString(string.format("+%d", self.mLevel - self.mData.level))
    local progressTo = cc.ProgressTo:create(0.1, 100)
    transition.execute(self.mProTimer, progressTo, {
      onComplete = function()
        if self.mLevel >= MAX_LEVEL then
          self.mExcessExp = addNum + excessNum - cost
          self.mIsExcessed = true
          self.mIsOnAction = false
          self.mEssenceCost = self:getEssenceCost(self.mData.level, self.mLevel)
          self.mNumLabel:setString("max")
          self.mCostLabel:setString(self.mEssenceCost)
          return
        end
        self.mExcessExp = 0
        local addNum = addNum + excessNum - cost
        self.mProTimer:setPercentage(0)
        self:expIncrease(addNum)
      end
    })
  else
    self.mNumLabel:setString(string.format("%d/%d", excessNum + addNum, cost))
    local progressTo = cc.ProgressTo:create(0.1, (excessNum + addNum) / cost * 100)
    transition.execute(self.mProTimer, progressTo, {
      onComplete = function()
        self.mExcessExp = excessNum + addNum
        self.mEssenceCost = self:getEssenceCost(self.mData.level, self.mLevel)
        self.mCostLabel:setString(self.mEssenceCost)
        self.mIsOnAction = false
        if self.mLevel >= CloudData.USER_LEVEL * 2 then
          self.mIsExcessed = true
        else
          self.mIsExcessed = false
        end
      end
    })
  end
end

function M:expDecrease(addNum)
  local cost = DataUtils.getEquipmentUpgradeCost(self.mLevel + 1, self.mData.quality)
  local excessNum = self.mExcessExp
  if excessNum - addNum < 0 then
    self.mLevel = self.mLevel - 1
    if 0 < self.mLevel - self.mData.level then
      self.mAddLabel:setString(string.format("+%d", self.mLevel - self.mData.level))
    else
      self.mAddLabel:setString("")
    end
    local progressTo = cc.ProgressTo:create(0.1, 0)
    transition.execute(self.mProTimer, progressTo, {
      onComplete = function()
        self.mExcessExp = DataUtils.getEquipmentUpgradeCost(self.mLevel + 1, self.mData.quality)
        local addNum = addNum - excessNum
        self.mNumLabel:setString(string.format("%d/%d", self.mExcessExp, self.mExcessExp))
        self.mProTimer:setPercentage(100)
        self:expDecrease(addNum)
      end
    })
  else
    self.mNumLabel:setString(string.format("%d/%d", excessNum - addNum, cost))
    local progressTo = cc.ProgressTo:create(0.1, (excessNum - addNum) / cost * 100)
    transition.execute(self.mProTimer, progressTo, {
      onComplete = function()
        self.mExcessExp = excessNum - addNum
        self.mIsOnAction = false
        self.mEssenceCost = self:getEssenceCost(self.mData.level, self.mLevel)
        self.mCostLabel:setString(self.mEssenceCost)
        if self.mLevel > CloudData.USER_LEVEL * 2 then
          self.mIsExcessed = true
        else
          self.mIsExcessed = false
        end
      end
    })
  end
end

function M:expIncreaseMax(addNum)
  local sum, addLevel = -self.mExcessExp, 0
  for i = self.mLevel + 1, CloudData.USER_LEVEL * 2 do
    local cost = DataUtils.getEquipmentUpgradeCost(i, self.mData.quality)
    sum = sum + cost
    addLevel = addLevel + 1
    if addNum < sum then
      local excessNum = addNum - (sum - cost)
      addLevel = addLevel - 1
      self.mExcessExp = excessNum
      self.mLevel = self.mLevel + addLevel
      self.mIsExcessed = false
      self.mNumLabel:setString(string.format("%d/%d", excessNum, cost))
      self.mProTimer:setPercentage(excessNum / cost * 100)
      break
    elseif sum == addNum then
      self.mExcessExp = 0
      self.mLevel = self.mLevel + addLevel
      if self.mLevel == MAX_LEVEL then
        self.mNumLabel:setString("max")
        self.mProTimer:setPercentage(100)
      else
        local cost1 = DataUtils.getEquipmentUpgradeCost(self.mLevel + 1, self.mData.quality)
        self.mNumLabel:setString(string.format("%d/%d", 0, cost1))
        self.mProTimer:setPercentage(0)
      end
      self.mIsExcessed = true
      break
    end
  end
  self.mIsOnAction = false
  self.mAddLabel:setString(string.format("+%d", self.mLevel - self.mData.level))
  self.mEssenceCost = self:getEssenceCost(self.mData.level, self.mLevel)
  self.mCostLabel:setString(self.mEssenceCost)
end

function M:updateUI(level)
  self:playAnimation()
  self.mData.level = level
  self.mLevel = level
  self.mEssenceCost = 0
  self.mIronCost = 0
  self.mExpAddNum = 0
  self.mCostLabel:setString(0)
  self.mIronLabel:setString(0)
  self.mLevelLabel:setString(level)
  self.mAddLabel:setString("")
  self.mPropLabels[1]:setString("+" .. level * self.mData.growNums[1])
  self.mPropLabels[2]:setString("+" .. level * self.mData.growNums[2])
end

function M:playAnimation()
  local frames = display.newFrames("qianghuajiayi%d.png", 1, 20)
  local animation = display.newAnimation(frames, 0.041666666666666664)
  local emptyPic = display.newSprite()
  emptyPic:setPosition(24, 24)
  emptyPic:addTo(self.mLevelFrame)
  emptyPic:playAnimationOnce(animation, true)
end

function M:getEssenceCost(level1, level2)
  return self.mExpAddNum * 10
end

function M:isExpExcessed()
  return self.mIsExcessed
end

function M:isOnAction()
  return self.mIsOnAction
end

return M

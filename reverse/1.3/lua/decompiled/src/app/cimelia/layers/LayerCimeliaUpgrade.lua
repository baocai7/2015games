local IconCimeliaUpgrade = require("app.cimelia.icons.IconCimeliaUpgrade")
local NoviceGuide = require("app.utils.NoviceGuide")
local CLASS_NAME = "LayerCimeliaUpgrade"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.TYPE_ATK = 1
M.TYPE_DEF = 2
local MAX_AUTO_NUM = 5
local MAX_LEVEL = 80

function M:ctor(equipedId, handler_)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mCallback = handler_
  self:initData(equipedId)
  self:initUI()
  self:dealUserProgress()
end

local function getCimeliaModel(tb)
  local tb1 = {}
  local tb2 = {}
  for i = 1, #tb do
    if 0 == tb[i].type then
      table.insert(tb1, tb[i])
    else
      table.insert(tb2, tb[i])
    end
  end
  for i = 1, #tb1 do
    for j = 1, #tb1 - 1 do
      if tb1[j].quality > tb1[j + 1].quality then
        tb1[j], tb1[j + 1] = tb1[j + 1], tb1[j]
      elseif tb1[j].quality == tb1[j + 1].quality and tb1[j].level > tb1[j + 1].level then
        tb1[j], tb1[j + 1] = tb1[j + 1], tb1[j]
      end
    end
  end
  for i = 1, #tb2 do
    for j = 1, #tb2 - 1 do
      if tb2[j].quality > tb2[j + 1].quality then
        tb2[j], tb2[j + 1] = tb2[j + 1], tb2[j]
      elseif tb2[j].quality == tb2[j + 1].quality and tb2[j].level > tb2[j + 1].level then
        tb2[j], tb2[j + 1] = tb2[j + 1], tb2[j]
      end
    end
  end
  table.insertto(tb1, tb2)
  return tb1
end

function M:initData(equipedId)
  self.mEquipedId = equipedId
  self.mCimeliaTable = {}
  for k, v in pairs(CloudData.CIMELIA_LIST) do
    if v.id ~= CloudData.CIMELIA_EQUIPED[1] and v.id ~= CloudData.CIMELIA_EQUIPED[2] then
      local cimeliaModel = DataUtils.getCimeliaBaseInfo(v.id)
      table.insert(self.mCimeliaTable, cimeliaModel)
    end
  end
  self.mCimeliaTable = getCimeliaModel(self.mCimeliaTable)
  self.mCimeliaModel = DataUtils.getCimeliaBaseInfo(equipedId)
  self.mLevel = self.mCimeliaModel.level
  self.mExcessExp = self.mCimeliaModel.excessExp
  self.mCimeliaIconTable = {}
  self.mIsOnAction = false
  self.mIsExcessed = false
  if self.mLevel > CloudData.USER_LEVEL then
    self.mIsExcessed = true
  end
  GameManager.CIMELIA_SWALLOWED = {}
end

function M:initUI()
  local bg = display.newScale9Sprite("cimelia/bg_upgrade.png"):addTo(self.mNode)
  self.mBg = bg
  self:initCimeliaList()
  self:initCimeliaLevel()
  self:initFuncBtn()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.96, bg:getContentSize().height * 0.96):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg)
end

function M:initCimeliaList()
  local countNum = #self.mCimeliaTable
  if 0 == countNum then
    return
  end
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(80, 195, 875, 455),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.onEventTouchList)):addTo(self.mBg)
  local idx = 1
  local row = math.ceil(countNum / 5)
  local rowInView = 4
  
  local function tFuncAddItem()
    if idx <= row then
      local item = listView:newItem()
      item:setItemSize(875, 210)
      listView:addItem(item)
      if idx <= rowInView then
        self:onEventDisplayItem(item, idx, true)
      else
        self:onEventDisplayItem(item, idx, false)
      end
      listView:reload()
      if idx < row then
        idx = idx + 1
        self:performWithDelay(tFuncAddItem, 0.1)
      elseif self.mListView.sprLoading then
        self.mListView.sprLoading:removeSelf()
        self.mListView.sprLoading = nil
      end
    end
  end
  
  self.mListView = listView
  self.mListViewParam = {
    row = row,
    col = 5,
    remainder = countNum % 5
  }
  self.mListView.sprLoading = display.newColorLayer(cc.c4b(0, 0, 0, 255)):addTo(self.mListView)
  self.mListView.sprLoading:setCascadeOpacityEnabled(true)
  self.mListView.sprLoading:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeTo:create(0.5, 32), cc.FadeTo:create(0.5, 128))))
  self:performWithDelay(tFuncAddItem, 0.1)
end

function M:initCimeliaLevel()
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mCimeliaModel.quality)):scale(0.9):align(display.CENTER_LEFT, 70, 78):addTo(self.mBg)
  display.newSprite(self.mCimeliaModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  self.mLevelLabel = DYLabelTTF.new({
    text = string.format("LV.%d", self.mCimeliaModel.level),
    size = 28,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(185, 105):addTo(self.mBg)
  self.mAddLabel = DYLabelTTF.new({
    text = "",
    size = 28,
    color = cc.c3b(48, 251, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(255, 105):addTo(self.mBg)
  local rate = self.mCimeliaModel.quality < 3 and 3 or self.mCimeliaModel.quality
  local costNum = math.round(((12 + self.mCimeliaModel.level) ^ 5 / 3000 + 500) / 50) * rate
  local excessNum = self.mCimeliaModel.excessExp
  local barBg = display.newSprite("cimelia/bar_bg1.png"):align(display.CENTER_LEFT, 185, 45):addTo(self.mBg)
  self.mProTimer = cc.ProgressTimer:create(display.newSprite("cimelia/bar_pro1.png")):addTo(barBg)
  self.mProTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.mProTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  self.mProTimer:setMidpoint(cc.p(0, 0))
  self.mProTimer:setBarChangeRate(cc.p(1, 0))
  self.mProTimer:setPercentage(excessNum / costNum * 100)
  self.mNumLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = string.format("%d/%d", excessNum, costNum),
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  if self.mCimeliaModel.level >= MAX_LEVEL then
    self.mNumLabel:setString("max")
    self.mProTimer:setPercentage(100)
    self.mIsExcessed = true
  end
end

function M:initFuncBtn()
  local autoBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S601", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S601", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):align(display.CENTER, self.mBg:getContentSize().width * 0.5 + 185, 75):onButtonClicked(function()
    self:autoSelect()
    if self.mEquipedId == CloudData.CIMELIA_EQUIPED[1] then
    else
    end
  end):addTo(self.mBg)
  local upgradeBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S605", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S605", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):align(display.CENTER, self.mBg:getContentSize().width * 0.5 + 360, 75):onButtonClicked(function()
    self:upgradeCallBack()
  end):addTo(self.mBg)
  if self.mIsExcessed or 0 == #self.mCimeliaTable then
    self:performWithDelay(function()
      autoBtn:setButtonEnabled(false)
      upgradeBtn:setButtonEnabled(false)
    end, 0)
  end
end

function M:updateLabel(flag, addNum)
  self.mIsOnAction = true
  local textStr = 0
  if flag then
    self:expIncrease(addNum)
    textStr = "+" .. addNum
  else
    self:expDecrease(addNum)
    textStr = "-" .. addNum
  end
  local lb = cc.ui.UILabel.new({
    UILabelType = 2,
    text = textStr,
    size = 30,
    color = display.COLOR_GREEN,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.5 + 50, 45):addTo(self.mBg, 1)
  local pointTo = cc.p(self.mBg:getContentSize().width * 0.5 + 50, 100)
  lb:runAction(transition.sequence({
    cc.MoveTo:create(0.5, pointTo),
    cc.CallFunc:create(function()
      lb:removeSelf()
    end)
  }))
end

function M:expIncrease(addNum)
  local rate = 3 > self.mCimeliaModel.quality and 3 or self.mCimeliaModel.quality
  local costNum = DataUtils.getExpCostCurrLevel(self.mLevel) * rate
  local excessNum = self.mExcessExp
  if costNum <= addNum + excessNum then
    self.mLevel = self.mLevel + 1
    self.mNumLabel:setString(string.format("%d/%d", costNum, costNum))
    self.mAddLabel:setString(string.format("+%d", self.mLevel - self.mCimeliaModel.level))
    local progressTo = cc.ProgressTo:create(0.1, 100)
    transition.execute(self.mProTimer, progressTo, {
      onComplete = function()
        if self.mLevel >= MAX_LEVEL then
          self.mExcessExp = addNum + excessNum - costNum
          self.mIsExcessed = true
          self.mIsOnAction = false
          return
        end
        self.mExcessExp = 0
        local addNum = addNum + excessNum - costNum
        self.mProTimer:setPercentage(0)
        self:expIncrease(addNum)
      end
    })
  else
    self.mNumLabel:setString(string.format("%d/%d", excessNum + addNum, costNum))
    local progressTo = cc.ProgressTo:create(0.1, (excessNum + addNum) / costNum * 100)
    transition.execute(self.mProTimer, progressTo, {
      onComplete = function()
        self.mExcessExp = excessNum + addNum
        self.mIsOnAction = false
        if self.mLevel > CloudData.USER_LEVEL then
          self.mIsExcessed = true
        else
          self.mIsExcessed = false
        end
      end
    })
  end
end

function M:expDecrease(addNum)
  local rate = 3 > self.mCimeliaModel.quality and 3 or self.mCimeliaModel.quality
  local costNum = DataUtils.getExpCostCurrLevel(self.mLevel) * rate
  local excessNum = self.mExcessExp
  if excessNum - addNum < 0 then
    self.mLevel = self.mLevel - 1
    if 0 < self.mLevel - self.mCimeliaModel.level then
      self.mAddLabel:setString(string.format("+%d", self.mLevel - self.mCimeliaModel.level))
    else
      self.mAddLabel:setString("")
    end
    local progressTo = cc.ProgressTo:create(0.1, 0)
    transition.execute(self.mProTimer, progressTo, {
      onComplete = function()
        self.mExcessExp = DataUtils.getExpCostCurrLevel(self.mLevel) * rate
        local addNum = addNum - excessNum
        self.mNumLabel:setString(string.format("%d/%d", self.mExcessExp, self.mExcessExp))
        self.mProTimer:setPercentage(100)
        self:expDecrease(addNum)
      end
    })
  else
    self.mNumLabel:setString(string.format("%d/%d", excessNum - addNum, costNum))
    local progressTo = cc.ProgressTo:create(0.1, (excessNum - addNum) / costNum * 100)
    transition.execute(self.mProTimer, progressTo, {
      onComplete = function()
        self.mExcessExp = excessNum - addNum
        self.mIsOnAction = false
        if self.mLevel > CloudData.USER_LEVEL then
          self.mIsExcessed = true
        else
          self.mIsExcessed = false
        end
      end
    })
  end
end

function M:autoSelect()
  if self.mIsOnAction then
    return
  end
  local count = 0
  local rate = 3 > self.mCimeliaModel.quality and 3 or self.mCimeliaModel.quality
  local countNum1 = DataUtils.getExpCountNumToLevel(self.mLevel) * rate
  local countNum2 = DataUtils.getExpCountNumToLevel(CloudData.USER_LEVEL) * rate
  local countNum = countNum2 - countNum1 - self.mExcessExp
  local sumNum = 0
  if countNum <= 0 then
    WSToast.new(DYLang.getString("S607", "")):addTo(self, 20)
    return
  end
  for k, v in pairs(self.mCimeliaIconTable) do
    if not v.isSelected then
      count = count + 1
      sumNum = sumNum + v.expValue
      v.isSelected = true
      if v.icon then
        v.icon:setIconSelected(true)
      end
      if countNum < sumNum or count >= MAX_AUTO_NUM then
        break
      end
    end
  end
  self:updateLabel(true, sumNum)
end

function M:upgradeCallBack()
  if not GameManager.CIMELIA_SWALLOWED or #GameManager.CIMELIA_SWALLOWED == 0 then
    WSToast.new(DYLang.getString("S608", "")):addTo(self, 20)
    return
  end
  for k, v in pairs(GameManager.CIMELIA_SWALLOWED) do
    if 0 < v.type and (v.level > 1 or v.quality >= 4) then
      self:getConfirmLayer()
      return
    end
  end
  self:confirmToUpgrade()
end

function M:confirmToUpgrade()
  local function tFunListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_cimelia_upgrade)
    CloudData.CIMELIA_LIST[self.mEquipedId].level = jsonTable.data.level
    CloudData.CIMELIA_LIST[self.mEquipedId].excessExp = jsonTable.data.excessExp
    self.mLevel = CloudData.CIMELIA_LIST[self.mEquipedId].level
    self.mCimeliaModel.level = self.mLevel
    if self.mLevel > CloudData.USER_LEVEL then
      self.mIsExcessed = true
    end
    self.mLevelLabel:setString(string.format("LV.%d", self.mLevel))
    self.mAddLabel:setString("")
    for k, v in pairs(GameManager.CIMELIA_SWALLOWED) do
      table.removebyvalue(self.mCimeliaTable, v)
      CloudData.CIMELIA_LIST[v.ucid] = nil
    end
    GameManager.CIMELIA_SWALLOWED = {}
    self:performWithDelay(function()
      if self.mListView then
        self.mListView:removeSelf()
        self.mListView = nil
        self.mCimeliaIconTable = {}
        self:initCimeliaList()
      end
    end, 0.05)
  end
  
  local idTable = {}
  for k, v in pairs(GameManager.CIMELIA_SWALLOWED) do
    table.insert(idTable, v.ucid)
  end
  local params = {}
  params.ucid = self.mEquipedId
  params.idStr = json.encode(idTable)
  DYHttpMgr.cimeliaUpgrade(tFunListener, params)
end

function M:getConfirmLayer()
  local pLayer = display.newColorLayer(cc.c4b(0, 0, 0, 120)):addTo(self, 15)
  local bg = display.newSprite("common_ui/common_dialog.png"):scale(0):pos(display.cx, display.cy):addTo(self, 16)
  bg:runAction(transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  }))
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(523, 190), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.54):addTo(bg)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S609", ""),
    size = 25,
    color = cc.c3b(66, 49, 29),
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(480, 180)
  }):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S610", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.18):onButtonClicked(function()
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0, 1),
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        bg:removeSelf()
        pLayer:removeSelf()
        self:confirmToUpgrade()
      end)
    })
    bg:runAction(popupLayer)
  end):addTo(bg)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S611", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.18):onButtonClicked(function()
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0, 1),
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        bg:removeSelf()
        pLayer:removeSelf()
      end)
    })
    bg:runAction(popupLayer)
  end):addTo(bg)
end

function M:onEventDisplayItem(item, idx, flag)
  if flag then
    if not item.isValid then
      item:removeAllChildren()
      local content = display.newNode()
      content:setContentSize(875, 210)
      local endNum = self.mListViewParam.col
      if idx == self.mListViewParam.row and self.mListViewParam.remainder ~= 0 then
        endNum = self.mListViewParam.remainder
      end
      for count = 1, endNum do
        local kIdx = (idx - 1) * 5 + count
        local cimeliaModel = self.mCimeliaTable[kIdx]
        local cimeliaIcon = IconCimeliaUpgrade.new(cimeliaModel)
        cimeliaIcon:setPosition(175 * count - 85, 105)
        content:addChild(cimeliaIcon)
        if self.mCimeliaIconTable[kIdx] then
          self.mCimeliaIconTable[kIdx].icon = cimeliaIcon
          self.mCimeliaIconTable[kIdx].expValue = cimeliaIcon.mExpValue
        else
          self.mCimeliaIconTable[kIdx] = {
            icon = cimeliaIcon,
            isSelected = false,
            expValue = cimeliaIcon.mExpValue
          }
        end
        cimeliaIcon:setIconSelected(self.mCimeliaIconTable[kIdx].isSelected)
      end
      item:addContent(content)
      item.isValid = true
    end
  elseif item.isValid or item.isValid == nil then
    item:removeAllChildren()
    local content = display.newNode()
    content:setContentSize(875, 210)
    local endNum = self.mListViewParam.col
    if idx == self.mListViewParam.row and self.mListViewParam.remainder ~= 0 then
      endNum = self.mListViewParam.remainder
    end
    for count = 1, endNum do
      local kIdx = (idx - 1) * 5 + count
      if self.mCimeliaIconTable[kIdx] then
        self.mCimeliaIconTable[kIdx].icon = nil
      else
        local cimeliaModel = self.mCimeliaTable[kIdx]
        local cimeliaIcon = IconCimeliaUpgrade.new(cimeliaModel)
        self.mCimeliaIconTable[kIdx] = {
          icon = nil,
          isSelected = false,
          expValue = cimeliaIcon.mExpValue
        }
      end
    end
    item:addContent(content)
    item.isValid = false
  end
end

function M:onEventTouchList(event)
  if "clicked" == event.name then
    local column = math.ceil(event.point.x / 175)
    local idx = (event.itemPos - 1) * 5 + column
    DDLOG("idx : %d", idx)
    if idx > #self.mCimeliaIconTable then
      return
    end
    if self.mIsOnAction then
      return
    end
    local element = self.mCimeliaIconTable[idx]
    local icon = element.icon
    local expValue = element.expValue
    if element.isSelected then
      element.isSelected = false
      if icon then
        icon:setIconSelected(false)
      end
      self:updateLabel(false, expValue)
    elseif not self.mIsExcessed then
      element.isSelected = true
      if icon then
        icon:setIconSelected(true)
      end
      self:updateLabel(true, expValue)
    else
      WSToast.new(DYLang.getString("S607", "")):addTo(self, 20)
    end
    if self.mEquipedId == CloudData.CIMELIA_EQUIPED[1] then
    else
    end
  elseif "began" == event.name then
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  elseif event.name == "itemAppearChange" then
    self:onEventDisplayItem(event.item, event.itemPos, true)
  elseif event.name == "itemDisappear" then
    self:onEventDisplayItem(event.item, event.itemPos, false)
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback(self.mEquipedId)
  end
  self:runAction(cc.RemoveSelf:create())
end

function M:dealUserProgress()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  if stageProgress == 8 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STAGE8_CEMLELAY_AUTO") then
    local guide = NoviceGuide.new("GUIDE_STAGE8_CEMLELAY_AUTO"):addTo(self, 9999)
    return
  end
end

return M

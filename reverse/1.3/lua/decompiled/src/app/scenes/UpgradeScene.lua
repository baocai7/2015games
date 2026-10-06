local DataLabelIcon = require("app.icons.DataLabelIcon")
local UpgradeBuddhaIcon = require("app.icons.UpgradeBuddhaIcon")
local UpgradeBuddhaLayer = require("app.layers.UpgradeBuddhaLayer")
local IconPkBubble = require("app.icons.IconPkBubble")
local NoviceGuide = require("app.utils.NoviceGuide")
local M = {}
M = class("UpgradeScene", function()
  return display.newScene("UpgradeScene")
end)

function M:ctor()
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initData()
  self:initUI()
  self:initPkBubble()
  self:dealUserGuide()
end

local function getBuddhaTable(self)
  self.mBuddhaModelTable = DataUtils.getBuddhaInfoTableUpgradeScene()
  self.mBuddhaModelTipTable = {
    self.mBuddhaModelTable,
    {},
    {},
    {}
  }
  for i = 1, #self.mBuddhaModelTable do
    local buddhaModel = self.mBuddhaModelTable[i]
    if CloudData.MAIN_STAGE_PROGRESS == 4 and not DataUtils.getGuideIsFirstPlayed("GUIDE_LEVEL5_UPGRADESCN") then
      local buddhaModel1 = self.mBuddhaModelTable[1]
      if 1002 == buddhaModel.npcId and 1002 ~= buddhaModel1.npcId then
        self.mBuddhaModelTable[i] = buddhaModel1
        self.mBuddhaModelTable[1] = buddhaModel
      end
    end
    if CloudData.USER_LEVEL == 10 and not DataUtils.getGuideIsFirstPlayed("GUIDE_LEVEL10_UPGRADESCN") then
      local buddhaModel1 = self.mBuddhaModelTable[1]
      if 1002 == buddhaModel.npcId and 1002 ~= buddhaModel1.npcId then
        self.mBuddhaModelTable[i] = buddhaModel1
        self.mBuddhaModelTable[1] = buddhaModel
      end
    end
    for m = 1, 3 do
      if m == buddhaModel.buddhaType then
        table.insert(self.mBuddhaModelTipTable[m + 1], buddhaModel)
      end
    end
  end
end

function M:initData()
  getBuddhaTable(self)
  self.mBuhhhaIconTable = {}
  self.mTabIconTable = {}
  self.mTabTag = 1
  self.mCurrModelTable = {}
end

function M:initUI()
  local bg = display.newSprite("common_ui/common_bg.png", display.cx, display.cy):addTo(self)
  DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ESSENCE, true):pos(display.width * 0.3, display.height * 0.95):addTo(self, 15)
  DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH, true):pos(display.width * 0.7, display.height * 0.95):addTo(self, 15)
  cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):scale(0.8):align(display.CENTER, display.width * 0.05, display.height * 0.95):onButtonClicked(function()
    DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
    local nextScene = require("scenes.ChapterScene").new()
    display.replaceScene(nextScene, "fade", 0.2)
  end):addTo(self, 15)
  local frame = display.newSprite("common_ui/common_frame9.png", bg:getContentSize().width * 0.53, bg:getContentSize().height * 0.45):addTo(bg)
  self.mFrame = frame
  self:initTabBtn()
  self.mListFrame = display.newSprite("upgrade/list_bg.png", frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  self:performWithDelay(function()
    self:initListView(self.mBuddhaModelTable)
  end, 0)
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new()
  self:add(self.mPkBubble, 900)
end

function M:initTabBtn()
  local btnImgTable = {
    {
      normal = "team/btn_all2.png",
      pressed = "team/btn_all2.png",
      disabled = "team/btn_all1.png"
    },
    {
      normal = "team/btn_front2.png",
      pressed = "team/btn_front2.png",
      disabled = "team/btn_front1.png"
    },
    {
      normal = "team/btn_mid2.png",
      pressed = "team/btn_mid2.png",
      disabled = "team/btn_mid1.png"
    },
    {
      normal = "team/btn_back2.png",
      pressed = "team/btn_back2.png",
      disabled = "team/btn_back1.png"
    }
  }
  for i = 1, #btnImgTable do
    local btn = cc.ui.UIPushButton.new(btnImgTable[i]):align(display.CENTER_LEFT, -90, self.mFrame:getContentSize().height * (1 - i * 0.15)):onButtonClicked(function()
      self:changeTab(i)
    end):addTo(self.mFrame)
    table.insert(self.mTabIconTable, btn)
    if 1 == i then
      btn:setButtonEnabled(false)
    end
  end
end

function M:initListView(tb)
  self.mItemList = {}
  self.mCurrModelTable = tb
  self.mListView = DYListView.new({
    async = true,
    viewRect = cc.rect(20, 30, 860, 540),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(self.mListFrame)
  local totalNum = #tb
  local row = math.ceil(totalNum / 2)
  local column = totalNum % 2
  local endNum = 2
  if row < 1 then
    return
  end
  
  local function tFuncDelegate(listView, tag, idx)
    if DYListView.COUNT_TAG == tag then
      return row
    else
      if DYListView.CELL_TAG == tag then
        item = self.mListView:dequeueItem(idx)
        local content
        if not item then
          item = self.mListView:newItem()
          content = display.newNode()
          item:addContent(content)
          content:setContentSize(840, 180)
          local iconTable = {}
          for count = 1, endNum do
            local buddhaModel = tb[(idx - 1) * 2 + count]
            local buddhaIcon = UpgradeBuddhaIcon.new(buddhaModel)
            buddhaIcon:setPosition(420 * count - 210, 90)
            content:addChild(buddhaIcon)
            if buddhaModel then
              table.insert(iconTable, buddhaIcon)
            end
          end
          item.iconTable = iconTable
          item:setItemSize(840, 180)
          self.mItemList[idx] = item
        else
        end
        return item
      else
      end
    end
  end
  
  self.mListView:setDelegate(tFuncDelegate)
  self.mListView:reload()
end

function M:initListView1(tb)
  self.mItemList = {}
  self.mCurrModelTable = tb
  self.mListView = DYListView.new({
    viewRect = cc.rect(20, 30, 860, 540),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(self.mListFrame)
  local totalNum = #tb
  local row = 4
  local column = totalNum % 2
  local endNum = 2
  if row < 1 then
    return
  end
  self.mListView.container:setPosition(0, 540 - 180 * row)
  local idx = 0
  
  local function tFuncAddItem(self)
    idx = idx + 1
    local item = self.mListView:newItem()
    local content = display.newNode()
    if idx == row and 0 < column then
      endNum = column
    end
    for count = 1, endNum do
      local buddhaModel = tb[(idx - 1) * 2 + count]
      local buddhaIcon = UpgradeBuddhaIcon.new(buddhaModel)
      buddhaIcon:setPosition(420 * count - 210, 90)
      content:addChild(buddhaIcon)
      table.insert(self.mBuhhhaIconTable, buddhaIcon)
    end
    content:setContentSize(840, 180)
    item:addContent(content)
    item:setItemSize(840, 180)
    self.mListView:addItem(item)
    item:setPosition(30, 30 + (row - idx) * 180)
    if idx == row then
      self.mListView:reload()
      self:unscheduleUpdate()
    end
  end
  
  self:scheduleUpdateWithPriorityLua(function()
    tFuncAddItem(self)
  end, 0)
end

function M:changeTab(idx)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mTabTag = idx
  for i = 1, #self.mTabIconTable do
    local icon = self.mTabIconTable[i]
    if idx == i then
      icon:setButtonEnabled(false)
    else
      icon:setButtonEnabled(true)
    end
  end
  if self.mListView then
    self.mListView:removeAllItems()
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
    self.mBuhhhaIconTable = {}
  end
  self:initListView(self.mBuddhaModelTipTable[idx])
end

function M:onTouch(event, x, y)
  if "began" == event then
    self.mPointBegan = {x = x, y = y}
    return true
  elseif "moved" == event then
  elseif "ended" == event then
    local pointEnded = {x = x, y = y}
    if math.abs(self.mPointBegan.x - pointEnded.x) < 20 and math.abs(self.mPointBegan.y - pointEnded.y) < 20 then
      local touchInSprite = cc.rectContainsPoint(self.mTipBar:getCascadeBoundingBox(), pointEnded)
      if touchInSprite then
        if not self.mOptionsFrame then
          self:showOptions()
          return
        end
        self.mOptionsFrame:runAction(transition.sequence({
          cc.ScaleTo:create(0.2, 1, 0),
          cc.CallFunc:create(function()
            self.mTipBtn:setButtonEnabled(true)
            self.mMaskLayer:removeSelf()
            self.mOptionsFrame:removeSelf()
            self.mMaskLayer = nil
            self.mOptionsFrame = nil
          end)
        }))
      end
    end
  end
end

function M:touchListener(event)
  if "clicked" == event.name then
    local column = math.ceil(event.point.x / 420)
    local idx = 0
    if event.itemPos ~= nil then
      idx = (event.itemPos - 1) * 2 + column
    end
    
    local function tFuncListener(buddhaModel)
      self.mCurrModelTable[idx] = buddhaModel
      getBuddhaTable(self)
      local icon = event.item.iconTable[column]
      icon:updateUI(buddhaModel)
    end
    
    local currModel = self.mCurrModelTable[idx]
    if currModel then
      local layer = UpgradeBuddhaLayer.new(self.mCurrModelTable[idx], tFuncListener)
      self:addChild(layer, 20)
    end
  elseif "began" == event.name then
    local column = math.ceil(event.point.x / 420)
    local idx = 0
    if event.itemPos ~= nil then
      idx = (event.itemPos - 1) * 2 + column
    end
    for i = 1, #self.mItemList do
      local item = self.mItemList[i]
      for j = 1, #item.iconTable do
        local icon = item.iconTable[j]
        if i == event.itemPos and j == column then
          icon:setSelected(true)
        else
          icon:setSelected(false)
        end
      end
    end
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  local userLevel = CloudData.USER_LEVEL
  if stageProgress == 4 then
    local ac = DataUtils.getBuddhaModel(1002)
    if not DataUtils.getGuideIsFirstPlayed("GUIDE_UPGRADE_STAGE2_BUDDHA") then
      local guide = NoviceGuide.new("GUIDE_UPGRADE_STAGE2_BUDDHA"):addTo(self, 50)
    end
    return
  end
  if stageProgress == 5 then
    local ac = DataUtils.getBuddhaModel(1005)
    if ac.buddhaState == 0 and DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_SUMMONLAY") and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_UPGRADESCN") then
      local guide = NoviceGuide.new("GUDIE_STAGE6_UPGRADESCN"):addTo(self, 50)
    end
    return
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

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  
  local function tFuncListener()
  end
  
  local power = M.getAllBuddhaCE()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&power=%s&token=%s&uid=%s", strAppSecret .. "", power .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.power = power
  params.sign = crypto.md5(strSign, false)
  DYHttpMgr.requestUpdateFullPower(tFuncListener, params)
end

function M.getAllBuddhaCE()
  local team = DataUtils.getBuddhaTableOnTeam()
  local sum = 0
  for k, v in pairs(team) do
    local buddhaModel = DataUtils.getBuddhaModel(v)
    sum = sum + buddhaModel.attackAssessment
  end
  return math.floor(math.sqrt(sum))
end

UpgradeScene = M
return M

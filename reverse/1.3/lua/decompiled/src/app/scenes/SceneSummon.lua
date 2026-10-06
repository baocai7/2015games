local DataLabelIcon = require("app.icons.DataLabelIcon")
local LayerSummon = require("app.layers.LayerSummon")
local LayerSummonReward = require("app.layers.LayerSummonReward")
local LayerLackEssence = require("app.layers.LayerLackEssence")
local LayerLackPeach = require("app.layers.LayerLackPeach")
local IconPkBubble = require("app.icons.IconPkBubble")
local NoviceGuide = require("app.utils.NoviceGuide")
local M = {}
M = class("SceneSummon", function()
  return display.newScene("SceneSummon")
end)
M.NORMAL_SUMMON = 2001
M.ADVANCE_SUMMON = 2002
M.VIP_SUMMON = 2003

function M:ctor()
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mBg = display.newSprite("new_fellow/bg.jpg", display.cx, display.cy):addTo(self)
  self.mNormalCoin = CloudData.GAME_ITEM_INFO["2025"] or 0
  self.mAdvanceCoin = CloudData.GAME_ITEM_INFO["2026"] or 0
  local frame1 = display.newSprite("summon_scene/summon_coin1.png"):pos(display.width * 0.21, display.height * 0.95):addTo(self, 15)
  self.mCoinLabel1 = cc.ui.UILabel.new({
    text = self.mNormalCoin,
    size = 27,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, frame1:getContentSize().width * 0.51, frame1:getContentSize().height * 0.45):addTo(frame1)
  local frame2 = display.newSprite("summon_scene/summon_coin2.png"):pos(display.width * 0.41, display.height * 0.95):addTo(self, 15)
  self.mCoinLabel2 = cc.ui.UILabel.new({
    text = self.mAdvanceCoin,
    size = 27,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, frame2:getContentSize().width * 0.51, frame2:getContentSize().height * 0.45):addTo(frame2)
  DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ESSENCE, true):pos(display.width * 0.64, display.height * 0.94):addTo(self, 15)
  DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH, true):pos(display.width * 0.88, display.height * 0.94):addTo(self, 15)
  cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):scale(0.85):align(display.CENTER, display.width * 0.05, display.height * 0.94):onButtonClicked(function()
    self:returnCallBack_()
  end):addTo(self, 15)
  self:initData()
  self:dealUserGuide()
  self:initPkBubble()
end

function M:initData()
  self.mIsVipPool = DataUtils.getIsVipFuntionsUnlock("vipPool")
  
  local function tFuncListener(jsonTable)
    local summonInfo = jsonTable.data
    self.mNormalTime = summonInfo.commonRefreshTime
    self.mAdvanceTime = summonInfo.advanceRefreshTime
    self.mFreeTimes = summonInfo.commonFreeTimes
    self.mLeftTimes = summonInfo.advanceMustTimes
    self.mVipLeftTimes = summonInfo.hongmengLeftTimes
    M.NORMAL_COST = {
      summonInfo.commonSingle,
      summonInfo.commonContinue
    }
    M.ADVANCE_COST = {
      summonInfo.advanceSingle,
      summonInfo.advanceContinue
    }
    M.VIP_COST = {
      summonInfo.hongmengSingle,
      summonInfo.hongmengContinue
    }
    self.mVipBuddhaIds = split(summonInfo.hongmengBuddhas, ";")
    self.mIsNoramlFree = false
    self.mIsAdvanceFree = false
    self.mItemTable = {}
    self.mIsMoving = false
    if self.initUI then
      self:initUI()
    end
  end
  
  DYHttpMgr.summonInit(tFuncListener)
end

function M:initUI()
  local card1 = self:getNormalCard():pos(self.mBg:getContentSize().width * 0.35, self.mBg:getContentSize().height * 0.5)
  local card2 = self:getAdvanceCard():pos(self.mBg:getContentSize().width * 0.65, self.mBg:getContentSize().height * 0.5)
  if CloudData.VIP_LEVEL >= 7 then
    local card3 = self:getVIPCard()
    card1:setPosition(self.mBg:getContentSize().width * 0.24, self.mBg:getContentSize().height * 0.5)
    card2:setPosition(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5)
    card3:setPosition(self.mBg:getContentSize().width * 0.76, self.mBg:getContentSize().height * 0.5)
  end
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new()
  self:add(self.mPkBubble, 900)
end

function M:normalCoinShow()
  if 0 == self.mNormalTime and 0 < self.mFreeTimes then
    self.mLabelFrame1:setTexture("summon_scene/free_tip.png")
    self.mLabel1:setVisible(false)
  else
    self.mLabel1:setVisible(true)
    if self.mNormalCoin >= 1 then
      self.mLabelFrame1:setTexture("summon_scene/cost_lb3.png")
      self.mLabel1:setString(1)
    else
      self.mLabelFrame1:setTexture("summon_scene/cost_lb1.png")
      self.mLabel1:setString(M.NORMAL_COST[1])
    end
  end
  if self.mNormalCoin >= 10 then
    self.mLabelFrame11:setTexture("summon_scene/cost_lb3.png")
    self.mLabel11:setString(10)
  else
    self.mLabelFrame11:setTexture("summon_scene/cost_lb1.png")
    self.mLabel11:setString(M.NORMAL_COST[2])
  end
end

function M:advanceCoinShow()
  if 0 == self.mAdvanceTime then
    self.mLabelFrame2:setTexture("summon_scene/free_tip.png")
    self.mLabel2:setVisible(false)
  else
    self.mLabel2:setVisible(true)
    if self.mAdvanceCoin >= 1 then
      self.mLabelFrame2:setTexture("summon_scene/cost_lb4.png")
      self.mLabel2:setString(1)
    else
      self.mLabelFrame2:setTexture("summon_scene/cost_lb2.png")
      self.mLabel2:setString(M.ADVANCE_COST[1])
    end
  end
  if self.mAdvanceCoin >= 10 then
    self.mLabelFrame21:setTexture("summon_scene/cost_lb4.png")
    self.mLabel21:setString(10)
  else
    self.mLabelFrame21:setTexture("summon_scene/cost_lb2.png")
    self.mLabel21:setString(M.ADVANCE_COST[2])
  end
end

function M:getNormalCard()
  local frame = display.newSprite("summon_scene/frame1.png"):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "summon_scene/skan.png",
    pressed = "summon_scene/skan.png"
  }):align(display.CENTER, frame:getContentSize().width * 0.85, frame:getContentSize().height * 0.85):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    LayerSummonReward.new(M.NORMAL_SUMMON):addTo(self, 20)
  end):addTo(frame, 1)
  local listView = DYListView.new({
    viewRect = cc.rect(56, 28, 230, 320),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  listView:enableScroll(false)
  for i = 1, 2 do
    local item = listView:newItem()
    local content = display.newNode()
    content:setContentSize(230, 320)
    if 1 == i then
      local boxPic = display.newSprite("summon_scene/icon1.png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.72):addTo(content, 1)
      self.mTimeLabel1 = DYLabelTTF.new({
        text = "",
        size = 20,
        color = cc.c3b(18, 253, 79),
        font = GameManager.FONTNAME_TTF
      }, {lineWidth = 2}):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.34):addTo(content)
      if 0 == self.mFreeTimes then
        self.mTimeLabel1:setString(DYLang.getString("S1390", ""))
      elseif 0 < self.mNormalTime then
        local minutes = math.floor(self.mNormalTime / 60)
        local seconds = self.mNormalTime - minutes * 60
        self.mTimeLabel1:setString(string.format("%02d : %02d\229\144\142\229\133\141\232\180\185", minutes, seconds))
        self:startCountDown_(M.NORMAL_SUMMON, self.mNormalTime)
      else
        self.mIsNoramlFree = true
        self.mTimeLabel1:setString(string.format(DYLang.getString("S1391", ""), self.mFreeTimes))
      end
      display.newSprite("summon_scene/label1.png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.2):addTo(content, 1)
      content:setTouchEnabled(true)
      content:setTouchEnabled(true)
      content:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
          self:frameUp(1)
          return true
        end
      end)
    else
      local btn2 = cc.ui.UIPushButton.new({
        normal = "summon_scene/pic_down.png",
        pressed = "summon_scene/pic_down.png"
      }):align(display.CENTER, content:getContentSize().width * 0.5, content:getContentSize().height * 0.9):onButtonClicked(function()
        self:performWithDelay(function()
          self:frameDown(1)
        end, 0)
      end):addTo(content)
      local ac = transition.sequence({
        cc.MoveBy:create(0.8, cc.p(0, 10)),
        cc.MoveBy:create(0.8, cc.p(0, -10))
      })
      btn2:runAction(cc.RepeatForever:create(ac))
      local textStr = {
        DYLang.getString("S1392", ""),
        DYLang.getString("S1393", "")
      }
      for j = 1, 2 do
        local labelFrame = display.newSprite("summon_scene/cost_lb1.png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * (1.1 - 0.4 * j)):addTo(content)
        local label = DYLabelTTF.new({
          text = 10,
          size = 20,
          color = display.COLOR_WHITE,
          font = GameManager.FONTNAME_TTF
        }):pos(labelFrame:getContentSize().width * 0.6, labelFrame:getContentSize().height * 0.5):addTo(labelFrame)
        if 1 == j then
          self.mLabelFrame1 = labelFrame
          self.mLabel1 = label
        else
          self.mLabelFrame11 = labelFrame
          self.mLabel11 = label
        end
        cc.ui.UIPushButton.new({
          normal = "activity/btn_normal.png",
          pressed = "activity/btn_pressed.png"
        }):align(display.CENTER, content:getContentSize().width * 0.5, content:getContentSize().height * (0.93 - 0.4 * j)):setButtonLabel("normal", DYLabelTTF.new({
          text = textStr[j],
          size = 28,
          color = cc.c3b(255, 248, 14),
          font = GameManager.FONTNAME_TTF
        }, {})):onButtonClicked(function(event)
          self:normalCallback(event.target, j)
        end):addTo(content)
      end
      self:normalCoinShow()
    end
    item:addContent(content)
    item:setItemSize(230, 320)
    listView:addItem(item)
    table.insert(self.mItemTable, item)
  end
  listView:reload()
  return frame
end

function M:getAdvanceCard()
  local frame = display.newSprite("summon_scene/frame2.png"):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "summon_scene/skan.png",
    pressed = "summon_scene/skan.png"
  }):align(display.CENTER, frame:getContentSize().width * 0.85, frame:getContentSize().height * 0.85):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    LayerSummonReward.new(M.ADVANCE_SUMMON):addTo(self, 20)
  end):addTo(frame, 1)
  local listView = DYListView.new({
    viewRect = cc.rect(56, 28, 230, 320),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  listView:enableScroll(false)
  for i = 1, 2 do
    local item = listView:newItem()
    local content = display.newNode()
    content:setContentSize(230, 320)
    if 1 == i then
      local boxPic = display.newSprite("summon_scene/icon2.png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.72):addTo(content, 1)
      local pLight = display.newSprite("summon_scene/light2.png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.72):addTo(content)
      pLight:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 60)))
      self.mTimeLabel2 = DYLabelTTF.new({
        text = "",
        size = 20,
        color = cc.c3b(18, 253, 79),
        font = GameManager.FONTNAME_TTF
      }, {lineWidth = 2}):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.34):addTo(content)
      if self.mAdvanceTime > 0 then
        local hour = math.floor(self.mAdvanceTime / 3600)
        local minutes = math.floor((self.mAdvanceTime - hour * 3600) / 60)
        local seconds = self.mAdvanceTime - hour * 3600 - minutes * 60
        self.mTimeLabel2:setString(string.format("%02d : %02d : %02d\229\144\142\229\133\141\232\180\185", hour, minutes, seconds))
        self:startCountDown_(M.ADVANCE_SUMMON, self.mAdvanceTime)
      else
        self.mIsAdvanceFree = true
        self.mTimeLabel2:setString(DYLang.getString("S1395", ""))
      end
      local lb = display.newSprite("summon_scene/label2.png"):pos(content:getContentSize().width * 0.6, content:getContentSize().height * 0.18):addTo(content, 1)
      self.mLeftLabel = DYLabelTTF.new({
        text = string.format("%d\230\172\161", self.mLeftTimes),
        size = 24,
        color = cc.c3b(18, 253, 79),
        dyalign = "CENTER_RIGHT",
        font = GameManager.FONTNAME_TTF
      }, {}):pos(-2, 15):addTo(lb)
      if 1 == self.mLeftTimes then
        self.mLeftLabel:setString(DYLang.getString("S1396", ""))
      end
      content:setTouchEnabled(true)
      content:setTouchEnabled(true)
      content:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
          self:frameUp(2)
          return true
        end
      end)
    else
      local btn2 = cc.ui.UIPushButton.new({
        normal = "summon_scene/pic_down.png",
        pressed = "summon_scene/pic_down.png"
      }):align(display.CENTER, content:getContentSize().width * 0.5, content:getContentSize().height * 0.9):onButtonClicked(function()
        self:performWithDelay(function()
          self:frameDown(2)
        end, 0)
      end):addTo(content)
      local ac = transition.sequence({
        cc.MoveBy:create(0.8, cc.p(0, 10)),
        cc.MoveBy:create(0.8, cc.p(0, -10))
      })
      btn2:runAction(cc.RepeatForever:create(ac))
      local textStr = {
        DYLang.getString("S1392", ""),
        DYLang.getString("S1393", "")
      }
      for j = 1, 2 do
        local labelFrame = display.newSprite("summon_scene/cost_lb2.png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * (1.1 - 0.4 * j)):addTo(content)
        local label = DYLabelTTF.new({
          text = 10,
          size = 24,
          color = display.COLOR_WHITE,
          font = GameManager.FONTNAME_TTF
        }):pos(labelFrame:getContentSize().width * 0.6, labelFrame:getContentSize().height * 0.5):addTo(labelFrame)
        if 1 == j then
          self.mLabelFrame2 = labelFrame
          self.mLabel2 = label
        else
          self.mLabelFrame21 = labelFrame
          self.mLabel21 = label
        end
        cc.ui.UIPushButton.new({
          normal = "activity/btn_normal.png",
          pressed = "activity/btn_pressed.png"
        }):align(display.CENTER, content:getContentSize().width * 0.5, content:getContentSize().height * (0.93 - 0.4 * j)):setButtonLabel("normal", DYLabelTTF.new({
          text = textStr[j],
          size = 28,
          color = cc.c3b(255, 248, 14),
          font = GameManager.FONTNAME_TTF
        }, {})):onButtonClicked(function(event)
          self:advanceCallback(event.target, j)
        end):addTo(content)
      end
      self:advanceCoinShow()
    end
    item:addContent(content)
    item:setItemSize(230, 320)
    listView:addItem(item)
    table.insert(self.mItemTable, item)
  end
  listView:reload()
  return frame
end

function M:getVIPCard()
  local frame = display.newSprite("summon_scene/frame3.png"):addTo(self.mBg)
  display.newSprite("summon_scene/vip.png"):pos(frame:getContentSize().width * 0.75, -5):addTo(frame)
  cc.ui.UIPushButton.new({
    normal = "summon_scene/skan.png",
    pressed = "summon_scene/skan.png"
  }):align(display.CENTER, frame:getContentSize().width * 0.85, frame:getContentSize().height * 0.85):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    LayerSummonReward.new(M.VIP_SUMMON):addTo(self, 20)
  end):addTo(frame, 1)
  local listView = DYListView.new({
    viewRect = cc.rect(56, 28, 230, 320),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  listView:enableScroll(false)
  for i = 1, 2 do
    local item = listView:newItem()
    local content = display.newNode()
    content:setContentSize(230, 320)
    if 1 == i then
      local boxPic = display.newSprite("summon_scene/icon3.png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.72):addTo(content, 1)
      local pLight = display.newSprite("summon_scene/light3.png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.72):addTo(content)
      pLight:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 60)))
      self.mVipLeftLabel = DYLabelTTF.new({
        text = string.format(DYLang.getString("S1400", ""), self.mVipLeftTimes),
        size = 24,
        color = cc.c3b(18, 253, 79),
        font = GameManager.FONTNAME_TTF
      }, {}):pos(content:getContentSize().width * 0.5, content:getContentSize().height * 0.12):addTo(content)
      for i = 1, #self.mVipBuddhaIds do
        local pModel = DataUtils.getBuddhaModelBaseInfo(self.mVipBuddhaIds[i])
        local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", pModel.quality)):scale(0.6):pos(content:getContentSize().width * (0.33 * i - 0.16), content:getContentSize().height * 0.32):addTo(content, 1)
        local pTip
        iconFrame:setTouchEnabled(true)
        iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
          local name, x, y = event.name, event.x, event.y
          if name == "began" then
            if not pTip then
              pTip = self:getVipTip(self.mVipBuddhaIds[i])
              pTip:setPosition(iconFrame:getPositionX(), iconFrame:getPositionY() + 150)
              pTip:addTo(content)
              DYUtils.setGlobalZOrder(pTip, 2)
            end
            return true
          elseif name == "moved" then
            pTip:show()
          elseif name == "ended" then
            pTip:removeSelf()
            pTip = nil
          end
        end)
        local icon = display.newSprite(pModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame, 1)
        if pModel.isRebel == 0 then
          icon:setScaleX(-1)
        end
      end
      content:setTouchEnabled(true)
      content:setTouchEnabled(true)
      content:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
          self:frameUp(3)
          return true
        end
      end)
    else
      local btn2 = cc.ui.UIPushButton.new({
        normal = "summon_scene/pic_down.png",
        pressed = "summon_scene/pic_down.png"
      }):align(display.CENTER, content:getContentSize().width * 0.5, content:getContentSize().height * 0.9):onButtonClicked(function()
        self:performWithDelay(function()
          self:frameDown(3)
        end, 0)
      end):addTo(content)
      local ac = transition.sequence({
        cc.MoveBy:create(0.8, cc.p(0, 10)),
        cc.MoveBy:create(0.8, cc.p(0, -10))
      })
      btn2:runAction(cc.RepeatForever:create(ac))
      local textStr = {
        DYLang.getString("S1392", ""),
        DYLang.getString("S1393", "")
      }
      for j = 1, 2 do
        local labelFrame = display.newSprite("summon_scene/cost_lb2.png"):pos(content:getContentSize().width * 0.5, content:getContentSize().height * (1.1 - 0.4 * j)):addTo(content)
        local numlabel = DYLabelTTF.new({
          text = M.VIP_COST[j],
          size = 24,
          color = display.COLOR_WHITE,
          font = GameManager.FONTNAME_TTF
        }):pos(labelFrame:getContentSize().width * 0.6, labelFrame:getContentSize().height * 0.5):addTo(labelFrame)
        cc.ui.UIPushButton.new({
          normal = "activity/btn_normal.png",
          pressed = "activity/btn_pressed.png"
        }):align(display.CENTER, content:getContentSize().width * 0.5, content:getContentSize().height * (0.93 - 0.4 * j)):setButtonLabel("normal", DYLabelTTF.new({
          text = textStr[j],
          size = 28,
          color = cc.c3b(255, 248, 14),
          font = GameManager.FONTNAME_TTF
        }, {})):onButtonClicked(function(event)
          self:vipCallback(event.target, j)
        end):addTo(content)
      end
    end
    item:addContent(content)
    item:setItemSize(230, 320)
    listView:addItem(item)
    table.insert(self.mItemTable, item)
  end
  listView:reload()
  return frame
end

function M:frameUp(idx)
  if self.mIsMoving then
    return
  end
  self.mIsMoving = true
  local moveByParams = {
    x = 0,
    y = 320,
    time = 0.2
  }
  local item1 = self.mItemTable[2 * idx - 1]
  local item2 = self.mItemTable[2 * idx]
  transition.moveBy(item1, moveByParams)
  transition.moveBy(item2, moveByParams)
  self:performWithDelay(function()
    self.mIsMoving = false
  end, 0.25)
end

function M:frameDown(idx)
  if self.mIsMoving then
    return
  end
  self.mIsMoving = true
  local moveByParams = {
    x = 0,
    y = -320,
    time = 0.2
  }
  local item1 = self.mItemTable[2 * idx - 1]
  local item2 = self.mItemTable[2 * idx]
  transition.moveBy(item1, moveByParams)
  transition.moveBy(item2, moveByParams)
  self:performWithDelay(function()
    self.mIsMoving = false
  end, 0.25)
end

function M:normalCallback(btn, idx)
  local coinCost = {
    [1] = 1,
    [2] = 10
  }
  if btn then
    btn:setButtonEnabled(false)
    self:performWithDelay(function()
      btn:setButtonEnabled(true)
    end, 0.5)
  end
  if 1 == idx and self.mIsNoramlFree then
    self:getSummonData(M.NORMAL_SUMMON, idx)
    return
  end
  if self.mNormalCoin >= coinCost[idx] then
    self:getSummonData(M.NORMAL_SUMMON, idx)
    return
  end
  local costNum = M.NORMAL_COST[idx]
  if costNum > CloudData.ESSENCE then
    LayerLackEssence.new():addTo(self, 20)
    return
  end
  self:getSummonData(M.NORMAL_SUMMON, idx)
end

function M:advanceCallback(btn, idx)
  local coinCost = {
    [1] = 1,
    [2] = 10
  }
  if btn then
    btn:setButtonEnabled(false)
    self:performWithDelay(function()
      btn:setButtonEnabled(true)
    end, 0.5)
  end
  if 1 == idx and self.mIsAdvanceFree then
    self:getSummonData(M.ADVANCE_SUMMON, idx)
    return
  end
  if self.mAdvanceCoin >= coinCost[idx] then
    self:getSummonData(M.ADVANCE_SUMMON, idx)
    return
  end
  local costNum = M.ADVANCE_COST[idx]
  if costNum > CloudData.PEACH then
    LayerLackPeach.new():addTo(self, 20)
    return
  end
  self:getSummonData(M.ADVANCE_SUMMON, idx)
end

function M:vipCallback(btn, idx)
  if btn then
    btn:setButtonEnabled(false)
    self:performWithDelay(function()
      btn:setButtonEnabled(true)
    end, 0.5)
  end
  if not self.mIsVipPool then
    WSToast.new("\228\188\154\229\145\15210 \229\143\175\229\143\172\229\148\164", 2):addTo(self, 20)
    if btn then
      self:performWithDelay(function()
        btn:setButtonEnabled(true)
      end, 2)
    end
    return
  end
  local costNum = M.VIP_COST[idx]
  if costNum > CloudData.PEACH then
    LayerLackPeach.new():addTo(self, 20)
    return
  end
  self:getSummonData(M.VIP_SUMMON, idx)
end

function M:getSummonData(summonType, idx)
  self.mSummonType = summonType
  local itemList = {}
  local itemNumList = {}
  local tempTime = 0
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    local summonData = jsonTable.data
    for k, v in pairs(summonData.dropGain) do
      table.insert(itemList, v.id)
      table.insert(itemNumList, v.num)
    end
    if M.NORMAL_SUMMON == summonType then
      CloudData.ESSENCE = summonData.essenceCount
      if 1 == idx then
        if self.mIsNoramlFree then
          self.mNormalTime = summonData.commonRefreshTime
          self.mFreeTimes = summonData.leftFreeTimes
          self:updateUI(M.NORMAL_SUMMON, idx)
        elseif 1 <= self.mNormalCoin then
          self.mNormalCoin = summonData.summonToken
          CloudData.GAME_ITEM_INFO["2025"] = self.mNormalCoin
          self:updateUI(M.NORMAL_SUMMON, idx)
        end
      elseif self.mNormalCoin >= 10 then
        self.mNormalCoin = summonData.summonToken
        CloudData.GAME_ITEM_INFO["2025"] = self.mNormalCoin
        self:updateUI(M.NORMAL_SUMMON, idx)
      end
    elseif M.ADVANCE_SUMMON == summonType then
      CloudData.PEACH = summonData.peachCount
      self.mLeftTimes = summonData.mustTimes
      local str = string.format("%d\230\172\161", self.mLeftTimes)
      if 1 == self.mLeftTimes then
        str = DYLang.getString("S1396", "")
      end
      self.mLeftLabel:setString(str)
      if 1 == idx then
        if self.mIsAdvanceFree then
          self.mAdvanceTime = summonData.advanceRefreshTime
          self:updateUI(M.ADVANCE_SUMMON, idx)
        elseif 1 <= self.mAdvanceCoin then
          self.mAdvanceCoin = summonData.summonToken
          CloudData.GAME_ITEM_INFO["2026"] = self.mAdvanceCoin
          self:updateUI(M.ADVANCE_SUMMON, idx)
        end
      elseif 10 <= self.mAdvanceCoin then
        self.mAdvanceCoin = summonData.summonToken
        CloudData.GAME_ITEM_INFO["2026"] = self.mAdvanceCoin
        self:updateUI(M.ADVANCE_SUMMON, idx)
      end
    else
      CloudData.PEACH = summonData.peachCount
      self.mVipLeftTimes = summonData.leftTimes
      local str = string.format(DYLang.getString("S1400", ""), self.mVipLeftTimes)
      self.mVipLeftLabel:setString(str)
    end
    
    local function tCallback(isRepeat)
      for k, v in pairs(summonData.drop) do
        DataUtils.updateItemNum(tonumber(k), v)
      end
      if isRepeat then
        self:onEventRepeatSummon(idx)
      end
    end
    
    LayerSummon.new(idx, itemList, itemNumList, tCallback):addTo(self, 20)
  end
  
  if 1 == idx then
    if M.NORMAL_SUMMON == summonType then
      DYHttpMgr.normalSingle(tFuncListener)
    elseif M.ADVANCE_SUMMON == summonType then
      DYHttpMgr.advanceSingle(tFuncListener)
    else
      DYHttpMgr.vipSingle(tFuncListener)
    end
  elseif M.NORMAL_SUMMON == summonType then
    DYHttpMgr.normalContinue(tFuncListener)
  elseif M.ADVANCE_SUMMON == summonType then
    DYHttpMgr.advanceContinue(tFuncListener)
  else
    DYHttpMgr.vipContinue(tFuncListener)
  end
end

function M:onEventRepeatSummon(idx)
  local tFunc = {
    [M.NORMAL_SUMMON] = function()
      self:normalCallback(nil, idx)
    end,
    [M.ADVANCE_SUMMON] = function()
      self:advanceCallback(nil, idx)
    end,
    [M.VIP_SUMMON] = function()
      self:vipCallback(nil, idx)
    end
  }
  tFunc[self.mSummonType]()
end

function M:startCountDown_(summonType, time)
  local pNode = display.newNode():addTo(self)
  pNode.hour = 0
  if M.ADVANCE_SUMMON == summonType then
    pNode.hour = math.floor(time / 3600)
  end
  pNode.minutes = math.floor((time - pNode.hour * 3600) / 60)
  pNode.seconds = time - pNode.hour * 3600 - pNode.minutes * 60
  pNode.schedule = self:schedule(function()
    self:updateTime_(pNode, summonType)
  end, 1)
end

function M:updateTime_(tar, summonType)
  if tar.seconds > 0 then
    tar.seconds = tar.seconds - 1
  elseif 0 < tar.minutes then
    tar.seconds = 59
    tar.minutes = tar.minutes - 1
  elseif 0 < tar.hour then
    tar.seconds = 59
    tar.minutes = 59
    tar.hour = tar.hour - 1
  else
    self:countdownOver_(tar, summonType)
    return
  end
  if M.NORMAL_SUMMON == summonType then
    self.mTimeLabel1:setString(string.format("%02d : %02d\229\144\142\229\133\141\232\180\185", tar.minutes, tar.seconds))
  elseif M.ADVANCE_SUMMON == summonType then
    self.mTimeLabel2:setString(string.format("%02d : %02d : %02d\229\144\142\229\133\141\232\180\185", tar.hour, tar.minutes, tar.seconds))
  end
end

function M:countdownOver_(tar, summonType)
  self:stopAction(tar.schedule)
  tar:removeSelf()
  tar = nil
  if M.NORMAL_SUMMON == summonType then
    self.mIsNoramlFree = true
    self.mTimeLabel1:setString(string.format(DYLang.getString("S1391", ""), self.mFreeTimes))
    self.mLabel1:setVisible(false)
    self.mLabelFrame1:setTexture("summon_scene/free_tip.png")
  elseif M.ADVANCE_SUMMON == summonType then
    self.mIsAdvanceFree = true
    self.mTimeLabel2:setString(DYLang.getString("S1395", ""))
    self.mLabel2:setVisible(false)
    self.mLabelFrame2:setTexture("summon_scene/free_tip.png")
  end
end

function M:updateUI(summonType, idx)
  if M.NORMAL_SUMMON == summonType then
    if 1 == idx then
      self.mIsNoramlFree = false
      if self.mFreeTimes > 0 then
        self:startCountDown_(summonType, self.mNormalTime)
      else
        self.mTimeLabel1:setString(DYLang.getString("S1390", ""))
      end
    end
    self:normalCoinShow()
    self.mCoinLabel1:setString(self.mNormalCoin)
  elseif M.ADVANCE_SUMMON == summonType then
    if 1 == idx then
      self.mIsAdvanceFree = false
      self:startCountDown_(summonType, self.mAdvanceTime)
    end
    self:advanceCoinShow()
    self.mCoinLabel2:setString(self.mAdvanceCoin)
  end
end

function M:getVipTip(buddhaId)
  local buddhaModel = DataUtils.getBuddhaFeatureInfo(buddhaId)
  local bg = display.newSprite("common_ui/common_tip.png")
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality)):scale(0.85):align(display.CENTER_LEFT, bg:getContentSize().width * 0.05, bg:getContentSize().height * 0.65):addTo(bg)
  local icon = display.newSprite(buddhaModel.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 == buddhaModel.isRebel then
    icon:setScaleX(-1)
  end
  DYLabelTTF.new({
    text = buddhaModel.npcName,
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width + 5, iconFrame:getPositionY() + 25):addTo(bg)
  DYLabelTTF.new({
    text = "LV.1",
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width + 5, iconFrame:getPositionY() - 25):addTo(bg)
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S1409", ""),
    size = 30,
    color = cc.c3b(255, 245, 4),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(iconFrame:getPositionX(), bg:getContentSize().height * 0.2):addTo(bg)
  local tips = {
    DYLang.getString("S1410", ""),
    DYLang.getString("S1411", ""),
    DYLang.getString("S1412", ""),
    DYLang.getString("S1413", ""),
    DYLang.getString("S1414", ""),
    DYLang.getString("S1415", ""),
    DYLang.getString("S1416", ""),
    DYLang.getString("S1417", ""),
    DYLang.getString("S1418", ""),
    DYLang.getString("S1419", "")
  }
  local tb = {
    buddhaModel.tag1,
    buddhaModel.tag2,
    buddhaModel.tag3
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

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  if stageProgress == 1 and not DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE1_SUMMONSCN") then
    local function tFun()
      local model = DataUtils.getBuddhaModel(1002)
      
      require("app.layers.NewFellowLayer").new(model)
    end
    
    local guide = NoviceGuide.new("GUDIE_STAGE1_SUMMONSCN"):addTo(self, 50)
  end
  if stageProgress == 5 then
    local ac = DataUtils.getBuddhaModel(1005)
    if ac.buddhaState == 0 and ac.currPieceNum == 0 then
      if CloudData.VIP_LEVEL < 7 then
        local guide = NoviceGuide.new("GUDIE_STAGE6_SUMMONSCN"):addTo(self, 50)
      else
        local guide = NoviceGuide.new("GUDIE_STAGE6_SUMMONSCN_VIP7"):addTo(self, 50)
      end
    end
  end
end

function M:returnCallBack_()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local nextScene = require("scenes.ChapterScene").new()
  display.replaceScene(nextScene, "fadeDown", 0.5)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:returnCallBack_()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG("onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

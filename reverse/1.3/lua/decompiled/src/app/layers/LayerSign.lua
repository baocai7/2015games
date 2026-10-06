local WSToast = require("app.utils.WSToast")
local IconItem = require("app.icons.IconItem")
local LayerRule = require("app.layers.LayerRule")
local CLASS_NAME = "LayerSign"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(cb)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mBg = nil
  self.mInfo = {}
  self.mTotalLabel = nil
  self.mContinueLabel = nil
  self.mTipLayer = nil
  self.mRuleLayer = nil
  self.mSignSuccLayer = nil
  self.mSignedLayer = nil
  self.mVip = CloudData.VIP_LEVEL
  self.mTotalNum = 0
  self.mContinueNum = 0
  self.mSignNum = 0
  self.mSignToday = 0
  self.mGoodsTable = {}
  self.cb = cb
  self.mItemTable = {}
  self.mTodayShadow = nil
  self.mSignBtn = nil
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initBg()
  self:requestData()
end

function M:initBg()
  self.mBg = display.newSprite("sign/bg.png"):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, self.mBg:getContentSize().width * 0.99, self.mBg:getContentSize().height * 0.9):addTo(self.mBg, 2):onButtonClicked(function()
    self:closeCallBack()
  end)
  LayerRule.newRuleIcon(LayerRule.SIGN):align(display.CENTER, self.mBg:getContentSize().width * 0.1, self.mBg:getContentSize().height * 0.75):addTo(self.mBg)
  self.mSignBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\231\173\190  \229\136\176",
    size = 28,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = "\229\183\178\231\173\190\229\136\176",
    size = 28,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:toSign()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.84, self.mBg:getContentSize().height * 0.74):addTo(self.mBg)
  self.mTotalLabel = cc.ui.UILabel.new({
    text = "",
    size = 25,
    color = cc.c3b(56, 28, 4),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.49, self.mBg:getContentSize().height * 0.755):addTo(self.mBg)
  self.mContinueLabel = cc.ui.UILabel.new({
    text = "",
    size = 25,
    color = cc.c3b(255, 37, 37),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.245, self.mBg:getContentSize().height * 0.742):addTo(self.mBg)
  self:initList()
  self.mIsOnTouch, self.mTouchTime, self.mTouchParams = false, 0, nil
  self:schedule(function()
    self:onEventLongTouch()
  end, 0.2)
end

function M:initList()
  if self.mListView ~= nil then
    self.mListView:removeSelf()
    self.mListView = nil
  end
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(80, 113, 670, 380),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(self.mBg)
  for i = 1, 6 do
    local item = self.mListView:newItem()
    local content = display.newNode()
    content:setAnchorPoint(0.5, 0.5)
    content:setContentSize(670, 130)
    item:addContent(content)
    item:setItemSize(670, 130)
    self.mListView:addItem(item)
    for count = 1, 5 do
      local no = (i - 1) * 5 + count
      local frame = IconItem.new(0)
      frame:setPosition(134 * count - 67, 65)
      content:addChild(frame)
      self.mItemTable[no] = frame
    end
  end
  self.mListView:reload()
end

function M:requestData()
  local function tFuncListener(signInfo)
    if signInfo.errorCode ~= 0 then
      local msg = signInfo.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      self.mInfo = signInfo.data
      self:initData()
    end
  end
  
  DYHttpMgr.signInit(tFuncListener)
end

function M:initData()
  self.mTotalNum = tonumber(self.mInfo.signTotal)
  self.mContinueNum = tonumber(self.mInfo.signContinue)
  self.mSignNum = tonumber(self.mInfo.signCircle)
  if self.mSignNum > 30 then
    self.mSignNum = 30
  end
  self.mGoodsTable = self.mInfo.list
  self.mSignToday = tonumber(self.mInfo.signToday)
  CloudData.IS_SIGNED_TODAY = self.mSignToday
  self:initUI()
end

function M:initUI()
  self.mTotalLabel:setString(DYLang.getString("S894", "") .. self.mTotalNum .. DYLang.getString("S895", ""))
  self.mContinueLabel:setString(self.mContinueNum)
  if self.mSignToday == 1 then
    self:performWithDelay(function()
      self.mSignBtn:setButtonEnabled(false)
    end, 0)
  end
  self:reloadList()
end

function M:reloadList()
  if not self.mItemTable then
    return
  end
  for i = 1, #self.mItemTable do
    local frame = self.mItemTable[i]
    if frame then
      local info = self.mGoodsTable[tostring(i)]
      frame:reloadTexture(checknumber(info.things[1]), checknumber(info.counts[1]))
      if info.vip >= 0 then
        local tip = display.newSprite("sign/vip.png"):align(display.TOP_LEFT, -59, 59):addTo(frame, 1)
        local vipLabel = cc.ui.UILabel.new({
          text = "V" .. info.vip .. DYLang.getString("S897", ""),
          size = 19,
          color = cc.c3b(255, 235, 9),
          font = GameManager.FONTNAME_TTF
        }):align(display.CENTER_LEFT, tip:getContentSize().width * 0.21, tip:getContentSize().height * 0.4):addTo(tip)
        vipLabel:setRotation(-60)
      end
      if i <= self.mSignNum then
        display.newSprite("sign/shadow.png"):addTo(frame, 2)
        display.newSprite("sign/signed.png"):addTo(frame, 2)
      elseif i - 1 == self.mSignNum and self.mSignToday == 0 then
        self.mTodayShadow = display.newSprite("sign/select.png"):addTo(frame, 2)
      end
    end
  end
  if self.mSignNum > 14 then
    local y = 375
    transition.moveBy(self.mListView.container, {
      x = 0,
      y = y,
      time = 0.2
    })
  end
end

function M:loadSignDetails(index)
  local pLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 2)
  pLayer:setTouchEnabled(true)
  local bg = display.newSprite("sign/bg_popup.png", display.cx, display.cy):addTo(pLayer)
  local frame = display.newSprite("sign/bg_popup_00.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg)
  local lv = cc.ui.UIListView.new({
    viewRect = cc.rect(5, 5, 453, 136),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(frame)
  local itemIds = self.mGoodsTable[tostring(index)].things
  local itemNums = self.mGoodsTable[tostring(index)].counts
  for i = 1, #itemIds do
    local id, num = itemIds[i], itemNums[i]
    local item = lv:newItem()
    local content = IconItem.new(id, num)
    content:setPosition(65 + (i - 1) * 130, 65)
    item:addContent(content)
    item:setItemSize(130, 130)
    lv:addItem(item)
  end
  lv:reload()
  if 3 < #itemIds then
    local spirte1 = display.newSprite("sign/btn_arrow_n.png", 20, 110):addTo(bg)
    local spirte2 = display.newSprite("sign/btn_arrow_n.png", 533, 110):addTo(bg)
    spirte2:flipX(true)
  end
  display.newSprite("sign/img_prompt.png", display.cx, display.cy - 140):addTo(pLayer)
  pLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if "began" == event.name then
      return true
    elseif "ended" == event.name then
      local x, y = event.x, event.y
      local touchInSprite = cc.rectContainsPoint(bg:getCascadeBoundingBox(), cc.p(x, y))
      if not touchInSprite then
        pLayer:removeSelf()
      end
    end
  end)
end

function M:toSign()
  if self.mSignToday == 0 then
    local function tFuncListener(info)
      if info.errorCode ~= 0 then
        local toast = WSToast.new(info.errorMsg, 2)
        
        self:addChild(toast, 20)
      elseif self.signSuccess then
        self:signSuccess(info.data)
      end
    end
    
    DYHttpMgr.toSign(tFuncListener)
  else
    self.mSignedLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 2)
    local tip = display.newSprite("common_ui/common_dialog.png"):pos(display.cx, display.cy):addTo(self.mSignedLayer)
    local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(502, 190), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.52):addTo(tip)
    local strLabel = cc.ui.UILabel.new({
      text = DYLang.getString("S898", ""),
      size = 25,
      color = cc.c3b(255, 234, 1),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.65):addTo(frame)
    strLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    local strLabel1 = cc.ui.UILabel.new({
      text = DYLang.getString("S899", ""),
      size = 25,
      color = cc.c3b(255, 234, 1),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.35):addTo(frame)
    strLabel1:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    local btnNormalText = cc.ui.UILabel.new({
      text = DYLang.getString("S900", ""),
      size = 26,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    })
    btnNormalText:enableOutline(cc.c4b(25, 30, 3, 255), 2)
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }):align(display.CENTER, tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.18):addTo(tip):setButtonLabel("normal", btnNormalText):onButtonClicked(function()
      self.mSignedLayer:runAction(cc.RemoveSelf:create())
      self:closeCallBack()
    end)
  end
end

function M:signSuccess(info)
  DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
  for id, num in pairs(info.drop) do
    local gain = DataUtils.updateItemNum(id, num)
    DYAnalyze.item.get(id, "", gain, "SIGN")
  end
  self.mSignNum = self.mSignNum + 1
  self.mSignToday = 1
  self.mTotalNum = self.mTotalNum + 1
  self.mContinueNum = self.mContinueNum + 1
  self.mTotalLabel:setString(DYLang.getString("S894", "") .. self.mTotalNum .. DYLang.getString("S895", ""))
  self.mContinueLabel:setString(self.mContinueNum)
  CloudData.IS_SIGNED_TODAY = self.mSignToday
  CloudData.SIGN_COUNT = info.signTotal
  self.mSignBtn:setButtonEnabled(false)
  if self.mTodayShadow then
    self:showSignAni(info)
  end
end

function M:showSignAni(info)
  DYRes.loadSheet("animation/sign.plist")
  local frames = display.newFrames("sign%d.png", 1, 15)
  local animation = display.newAnimation(frames, 0.1)
  local animate = cc.Animate:create(animation)
  local emptySp = display.newSprite():pos(self.mTodayShadow:getContentSize().width * 0.5 - 4, self.mTodayShadow:getContentSize().height * 0.5 + 4):addTo(self.mTodayShadow, 2)
  local func = cc.CallFunc:create(function()
    self.mTodayShadow:setTexture("sign/shadow.png")
    display.newSprite("sign/signed.png"):pos(self.mTodayShadow:getContentSize().width * 0.5, self.mTodayShadow:getContentSize().height * 0.5):addTo(self.mTodayShadow)
    self:showSignAward(info)
    emptySp:runAction(cc.RemoveSelf:create())
    DYRes.unloadSheet("animation/sign.plist")
  end)
  emptySp:runAction(transition.sequence({animate, func}))
end

function M:showSignAward(info)
  local things, counts = {}, {}
  for id, num in pairs(info.dropGain) do
    table.insert(things, id)
    table.insert(counts, num)
  end
  self.mSignSuccLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 2)
  local tip = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(598, 450), cc.rect(598, 125, 5, 5)):pos(display.cx, display.cy):addTo(self.mSignSuccLayer)
  display.newSprite("stage/award.png"):align(display.CENTER_LEFT, tip:getContentSize().width * 0.1, tip:getContentSize().height * 0.87):addTo(tip)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(502, 229), cc.rect(50, 50, 2, 2)):pos(tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.52):addTo(tip)
  local needVip = self.mGoodsTable[tostring(self.mSignNum)].vip
  if 0 <= needVip and needVip <= self.mVip then
    DYLabelTTF.new({
      text = "vip" .. needVip .. "\229\143\140\229\128\141\229\165\150\229\138\177",
      size = 24,
      color = cc.c3b(28, 255, 12),
      font = GameManager.FONTNAME_TTF
    }, {}):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.12):addTo(frame)
  end
  local lv = cc.ui.UIListView.new({
    viewRect = cc.rect(10, 65, 482, 136),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(frame)
  for i = 1, #things do
    local id, num = things[i], counts[i]
    local item = lv:newItem()
    local content = IconItem.new(id, num)
    content:setPosition(65 + (i - 1) * 130, 65)
    item:addContent(content)
    item:setItemSize(130, 130)
    lv:addItem(item)
  end
  lv:reload()
  local okLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S904", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  okLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, tip:getContentSize().width * 0.5, tip:getContentSize().height * 0.15):addTo(tip, 2):setButtonLabel("normal", okLabel):onButtonClicked(function()
    self.mSignSuccLayer:removeSelf()
    self.mSignSuccLayer = nil
  end)
end

function M:showTip(index, y)
  if self.mTipLayer ~= nil then
    self.mTipLayer:removeSelf()
    self.mTipLayer = nil
  end
  local column = (index - 1) % 5 + 1
  local x = 135 * column + 290
  if 3 < column then
    x = 135 * column - 250
  end
  if y < 155 then
    y = 155
  elseif 425 < y then
    y = 425
  end
  self.mTipLayer = display.newScale9Sprite("common_ui/common_tip.png", x, y, cc.size(425, 275), cc.rect(200, 100, 10, 10)):addTo(self.mBg, 2)
  local id = tonumber(self.mGoodsTable[tostring(index)].things[1])
  local frame = IconItem.new(id)
  frame:setPosition(self.mTipLayer:getContentSize().width * 0.2, self.mTipLayer:getContentSize().height * 0.73)
  self.mTipLayer:addChild(frame)
  local itemInfo = DataUtils.getItemModel(id)
  local name = itemInfo.itemName
  local intro = itemInfo.itemDesc
  cc.ui.UILabel.new({
    text = name,
    size = 25,
    color = cc.c3b(255, 147, 5),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTipLayer:getContentSize().width * 0.37, self.mTipLayer:getContentSize().height * 0.73):addTo(self.mTipLayer)
  cc.ui.UILabel.new({
    text = intro,
    size = 22,
    color = cc.c3b(255, 250, 219),
    dimensions = cc.size(360, 85),
    align = cc.ui.TEXT_ALIGN_LEFT,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mTipLayer:getContentSize().width * 0.505, self.mTipLayer:getContentSize().height * 0.32):addTo(self.mTipLayer)
  local str = DYLang.getString("S906", "") .. index .. DYLang.getString("S907", "")
  cc.ui.UILabel.new({
    text = str,
    size = 20,
    color = cc.c3b(79, 255, 79),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, self.mTipLayer:getContentSize().width * 0.08, self.mTipLayer:getContentSize().height * 0.13):addTo(self.mTipLayer)
end

function M:removeTip()
  if self.mTipLayer ~= nil then
    self.mTipLayer:removeSelf()
    self.mTipLayer = nil
  end
end

function M:onEventLongTouch()
  if not self.mIsOnTouch then
    return
  end
  self.mTouchTime = self.mTouchTime + 1
  if self.mTouchTime >= 5 and self.mTouchParams then
    self:showTip(self.mTouchParams.idx, self.mTouchParams.y)
    self.mTouchParams = nil
  end
end

function M:touchListener(event)
  if "clicked" == event.name then
    if not self.mGoodsTable[tostring(self.mIndex)] then
      return
    end
    if self.mTouchTime < 5 then
      self:loadSignDetails(self.mIndex)
    else
      self:removeTip()
    end
    self.mIsOnTouch, self.mTouchTime, self.mTouchParams = false, 0, nil
  elseif "began" == event.name then
    local column = math.ceil(event.point.x / 134)
    self.mIndex = (event.itemPos - 1) * 5 + column
    if not self.mGoodsTable[tostring(self.mIndex)] then
      return
    end
    local worldPoint = event.item:convertToWorldSpace(cc.p(event.point.x, event.point.y))
    self.mIsOnTouch, self.mTouchParams = true, {
      idx = self.mIndex,
      y = worldPoint.y
    }
  elseif "moved" == event.name then
    self:removeTip()
    self.mIsOnTouch, self.mTouchTime, self.mTouchParams = false, 0, nil
  elseif "ended" == event.name then
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.cb then
    self.cb()
  end
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    if self.mRuleLayer then
      self.mRuleLayer:removeSelf()
      self.mRuleLayer = nil
    elseif self.mSignSuccLayer then
      self.mSignSuccLayer:removeSelf()
      self.mSignSuccLayer = nil
    elseif self.mSignedLayer then
      self.mSignedLayer:removeSelf()
      self.mSignedLayer = nil
    elseif self.mTipLayer then
      self.mTipLayer:removeSelf()
      self.mTipLayer = nil
    else
      self:closeCallBack()
    end
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

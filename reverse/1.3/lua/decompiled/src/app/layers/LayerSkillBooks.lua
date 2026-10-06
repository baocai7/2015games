local IconItem = require("app.icons.IconItem")
local M = {}
M = class("LayerAwakeSkill", function()
  return display.newLayer()
end)
local TEXT_COLOR = {
  cc.c3b(255, 255, 255),
  cc.c3b(0, 255, 6),
  cc.c3b(81, 204, 255),
  cc.c3b(239, 38, 237),
  cc.c3b(255, 198, 0),
  cc.c3b(255, 20, 37)
}

function M:ctor(params, callback)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mCallback = callback
  self.mBuddhaId = params.buddhaId
  self.mCanLearn = true
  if params.freeSkill and 0 < params.freeSkill then
    self.mCanLearn = false
  end
  self:initData(params.awakeSkills)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData(awakeSkills)
  self.mBooks = {}
  for id, num in pairs(CloudData.GAME_ITEM_INFO) do
    if tonumber(id) then
      local itemModel = DataUtils.getItemModel(id)
      if 7 == itemModel.itemType and 0 < num then
        local index = table.indexof(awakeSkills, tostring(itemModel.param))
        if index then
          table.insert(self.mBooks, itemModel)
        end
      end
    end
  end
  table.sort(self.mBooks, function(v1, v2)
    return v1.quality > v2.quality
  end)
  self.mIconList = {}
end

function M:initUI()
  self.mBg = display.newSprite("ranking/bg.png"):addTo(self.mNode)
  self:initListView()
  self.mIsOnTouch, self.mTouchTime, self.mTouchParams = false, 0, nil
  self:schedule(function()
    self:onEventLongTouch()
  end, 0.2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("TITLE_LEARN", ""),
    size = 28,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:learnCallback()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.04):addTo(self.mBg, 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.96, self.mBg:getContentSize().height * 0.93):addTo(self.mBg, 2)
end

function M:initListView()
  local listFrame = display.newScale9Sprite("common_ui/common_frame11.png", self.mBg:getContentSize().width * 0.5 + 5, self.mBg:getContentSize().height * 0.51, cc.size(800, 500), cc.rect(50, 40, 5, 5)):addTo(self.mBg)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(15, 10, 770, 480),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(listFrame, 2)
  local totalNum = #self.mBooks
  local row = math.ceil(totalNum / 5)
  local column = totalNum % 5
  local endNum = 5
  for i = 1, row do
    if i == row and column ~= 0 then
      endNum = column
    end
    local item = listView:newItem()
    local content = display.newNode()
    for count = 1, endNum do
      local bookData = self.mBooks[count + (i - 1) * 5]
      local icon = self:getIconFrame(bookData)
      icon:setPosition(154 * count - 77, 94)
      content:addChild(icon)
      table.insert(self.mIconList, icon)
    end
    content:setContentSize(770, 188)
    item:addContent(content)
    item:setItemSize(770, 188)
    listView:addItem(item)
  end
  listView:reload()
  if 0 < #self.mIconList then
    self.mCurrIcon = self.mIconList[1]
    self.mCurrIcon:setSelected(true)
  end
end

function M:getIconFrame(bookData)
  local bg = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(163, 196), cc.rect(40, 35, 2, 2))
  bg:setScale(0.9)
  local icon = bookData.itemIcon
  local quality = bookData.quality
  local currNum = bookData.currNum
  local name = bookData.itemName
  bg.id = bookData.itemId
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", quality)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.62):addTo(bg)
  local icon = display.newSprite(icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("*%d", currNum),
    font = "fonts/whiteNum.fnt"
  }):align(display.CENTER_RIGHT, iconFrame:getContentSize().width * 0.95, iconFrame:getContentSize().height * 0.15):scale(0.5):addTo(iconFrame, 1)
  local nameFrame = display.newSprite("cimelia/name_frame.png"):align(display.CENTER, bg:getContentSize().width * 0.5, 32):addTo(bg)
  local lb = DYLabelTTF.new({
    text = name,
    size = 22,
    color = TEXT_COLOR[quality],
    font = GameManager.FONTNAME_TTF
  }, {}):pos(nameFrame:getContentSize().width * 0.5, nameFrame:getContentSize().height * 0.5):addTo(nameFrame)
  local selectedFrame = display.newSprite("upgrade/img_selected.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):hide():addTo(bg, 2)
  
  function bg:setSelected(flag)
    selectedFrame:setVisible(flag)
  end
  
  return bg
end

function M:showTip(index, point)
  if self.mTipLayer ~= nil then
    self.mTipLayer:removeSelf()
    self.mTipLayer = nil
  end
  local column = (index - 1) % 5 + 1
  local x = 3 < column and point.x - 280 or point.x + 280
  y = point.y
  self.mTipLayer = display.newScale9Sprite("common_ui/common_tip.png", x, y, cc.size(425, 275), cc.rect(200, 100, 10, 10)):addTo(self, 2)
  local itemModel = self.mBooks[index]
  local name = itemModel.itemName
  local intro = itemModel.itemDesc
  local frame = IconItem.new(itemModel.itemId)
  frame:setPosition(self.mTipLayer:getContentSize().width * 0.2, self.mTipLayer:getContentSize().height * 0.73)
  self.mTipLayer:addChild(frame)
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
    self:showTip(self.mTouchParams.idx, self.mTouchParams.point)
    self.mTouchParams = nil
  end
end

function M:touchListener(event)
  if "clicked" == event.name then
    if self.mTouchTime < 5 and self.mIndex <= #self.mIconList then
      self.mCurrIcon:setSelected(false)
      self.mCurrIcon = self.mIconList[self.mIndex]
      self.mCurrIcon:setSelected(true)
    else
      self:removeTip()
    end
    self.mIsOnTouch, self.mTouchTime, self.mTouchParams = false, 0, nil
  elseif "began" == event.name then
    local column = math.ceil(event.point.x / 154)
    self.mIndex = (event.itemPos - 1) * 5 + column
    if self.mIndex <= #self.mIconList then
      local worldPoint = event.item:convertToWorldSpace(cc.p(event.point.x, event.point.y))
      self.mIsOnTouch, self.mTouchParams = true, {
        idx = self.mIndex,
        point = worldPoint
      }
    end
  elseif "moved" == event.name then
    self:removeTip()
    self.mIsOnTouch, self.mTouchTime, self.mTouchParams = false, 0, nil
  elseif "ended" == event.name then
  end
end

function M:learnCallback()
  if not self.mCurrIcon then
    return
  end
  if not self.mCanLearn then
    WSToast.new("\230\138\128\232\131\189\230\160\143\228\189\141\229\183\178\229\173\152\229\156\168\230\150\176\230\138\128\232\131\189\239\188\129"):addTo(self, 20)
    return
  end
  
  local function tFuncListener(jsonTable)
    dump(jsonTable)
    if jsonTable.errorCode ~= 0 then
      local msg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(msg, 2):addTo(self, 20)
      return
    end
    local data = jsonTable.data
    local newSkill = tonumber(data.skillId)
    CloudData.GAME_ITEM_INFO[tostring(data.thingId)] = data.leftCount
    self:closeCallBack()
    if self.mCallback then
      self.mCallback({skillId = newSkill})
    end
  end
  
  DDLOG("id : " .. self.mCurrIcon.id)
  DYHttpMgr.useSkillBook(tFuncListener, {
    buddhaId = self.mBuddhaId,
    thingId = self.mCurrIcon.id
  })
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
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

local LayerItem = require("app.layers.LayerItem")
local M = {}
M = class("IconActivityBuy", function()
  return display.newNode()
end)

function M:ctor(params, handler_)
  self.mCallback = handler_
  self:initData(params)
  self:initUI()
end

local function getTitleFrame(textStr)
  local width = math.ceil(#textStr / 3) * 30
  local frame = display.newScale9Sprite("activity/text_frame.png", 0, 0, cc.size(width, 44), cc.rect(40, 20, 1, 1))
  return frame
end

function M:initData(params)
  self.mStatus = params.taskInfo.isDraw
  self.mTaskId = params.taskId
  self.mActivityModel = DataUtils.getActivityTaskInfo2(self.mTaskId)
  self.mRewardList = {}
  if 0 < #self.mActivityModel.rewardType then
    for i = 1, #self.mActivityModel.rewardType do
      local lb = {}
      lb.type = tonumber(self.mActivityModel.rewardType[i])
      lb.num = tonumber(self.mActivityModel.rewardNum[i])
      table.insert(self.mRewardList, lb)
    end
  end
end

function M:initUI()
  local bg = display.newSprite("activity/icon.png"):addTo(self)
  local countNum = #self.mRewardList + 2
  local weight = countNum * 110 > 360 and 360 or countNum * 110
  local scaleNum = 0.5
  local posY = 0.32
  local conType = tonumber(self.mActivityModel.taskCon[1])
  local isConditionOK = true
  if 0 < conType then
    local textList = {
      "VIP\231\173\137\231\186\167\232\190\190\229\136\176%d\231\186\167",
      DYLang.getString("S327", "")
    }
    local conditionList = {
      CloudData.VIP_LEVEL,
      CloudData.USER_LEVEL
    }
    local conditionNum = tonumber(self.mActivityModel.taskCon[2])
    local textStr = string.format(textList[conType], conditionNum)
    local titleFrame = getTitleFrame(textStr):align(display.TOP_LEFT, 0, bg:getContentSize().height):addTo(bg)
    cc.ui.UILabel.new({
      text = textStr,
      size = 25,
      color = cc.c3b(252, 255, 27),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 15, titleFrame:getContentSize().height * 0.5):addTo(titleFrame)
    if conditionNum > conditionList[conType] then
      isConditionOK = false
    end
  else
    scaleNum = 0.6
    posY = 0.45
  end
  local width = 0
  for i = 1, countNum do
    local iconFrame, itemId, itemNum
    if 2 == i then
      iconFrame = display.newSprite("activity/equal.png")
      iconFrame:setTouchEnabled(false)
    else
      if 1 == i then
        itemId = self.mActivityModel.thingId
        itemNum = self.mActivityModel.thingNum
      else
        itemId = self.mRewardList[i - 2].type
        itemNum = self.mRewardList[i - 2].num
      end
      local itemModel = DataUtils.getItemModel(itemId)
      iconFrame = display.newSprite(string.format("common_ui/frame%d.png", itemModel.quality))
      iconFrame:setTouchEnabled(true)
      local icon = display.newSprite(itemModel.itemIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
      local numStr = itemNum
      if 100000 <= itemNum then
        numStr = string.format("%d\228\184\135", math.floor(itemNum / 10000))
      end
      DYLabelTTF.new({
        text = numStr,
        size = 20,
        color = display.COLOR_WHITE,
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_RIGHT"
      }, {}):scale(1 / scaleNum):pos(iconFrame:getContentSize().width - 10, 20):addTo(iconFrame, 1)
      width = iconFrame:getContentSize().width * scaleNum + 3
    end
    iconFrame:setPosition(width * i - 20, bg:getContentSize().height * posY)
    iconFrame:setScale(scaleNum)
    bg:addChild(iconFrame)
    local pLayer
    iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
      local touchInSprite = cc.rectContainsPoint(iconFrame:getCascadeBoundingBox(), cc.p(x, y))
      if name == "began" then
        if not pLayer then
          pLayer = LayerItem.new(LayerItem.TYPE_TIP, itemId):pos(iconFrame:getPositionX(), iconFrame:getPositionY()):addTo(bg, 20)
          DYUtils.setGlobalZOrder(pLayer, 10)
        end
        return true
      elseif name == "moved" then
        pLayer:show()
      elseif name == "ended" then
        pLayer:removeSelf()
        pLayer = nil
      end
    end)
  end
  local sp = display.newSprite("activity/label2.png"):pos(bg:getContentSize().width * 0.78, bg:getContentSize().height * 0.72):addTo(bg)
  local totalNum = tonumber(self.mActivityModel.limitTimes)
  local currNum = totalNum - self.mStatus
  self.mLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text = currNum .. "/" .. totalNum,
    font = "fonts/greenNum.fnt"
  }):scale(0.6):align(display.CENTER_LEFT, sp:getPositionX() + sp:getContentSize().width * 0.53, sp:getPositionY()):addTo(bg)
  self.mBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.85):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S328", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S328", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):align(display.CENTER, bg:getContentSize().width * 0.88, bg:getContentSize().height * 0.3):onButtonClicked(function()
    self:getAwardCallback()
  end):addTo(bg)
  if not isConditionOK or self.mActivityModel.currNum < self.mActivityModel.thingNum or currNum <= 0 then
    self:performWithDelay(function()
      self.mBtn:setButtonEnabled(false)
    end, 0)
  end
end

function M:getAwardCallback()
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  local params = {
    taskId = self.mTaskId,
    thingId = self.mActivityModel.thingId,
    tar = self.mBtn,
    text = self.mLabel,
    thingNum = self.mActivityModel.thingNum
  }
  if self.mCallback then
    self.mCallback(params)
  end
end

function M:touchListener(event)
  local lv = event.listView
  if "clicked" == event.name then
    local idx = event.itemPos
    DDLOG("idx : %d", idx)
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

return M

local LayerItem = require("app.layers.LayerItem")
local M = {}
M = class("IconActivityShare", function()
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
  self.mTaskId = tonumber(params.taskId)
  self.mStatus = params.taskInfo.isDraw
  self.mCurrProgress = params.taskInfo.finishedValue
  self.mActivityModel = DataUtils.getActivityTaskInfo1(self.mTaskId)
  self.mIsActive = false
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
  local textStr = string.format(self.mActivityModel.desc, tonumber(self.mActivityModel.taskNum))
  local titleFrame = getTitleFrame(textStr):align(display.TOP_LEFT, 0, bg:getContentSize().height):addTo(bg)
  cc.ui.UILabel.new({
    text = textStr,
    size = 25,
    color = cc.c3b(252, 255, 27),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 15, titleFrame:getContentSize().height * 0.5):addTo(titleFrame)
  local labelFrame = display.newSprite("activity/icon_frame.png"):align(display.CENTER_LEFT, 8, bg:getContentSize().height * 0.32):addTo(bg)
  for i = 1, #self.mRewardList do
    local itemId = self.mRewardList[i].type
    local pModel = DataUtils.getItemModel(itemId)
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", pModel.quality)):scale(0.55):align(display.CENTER_LEFT, labelFrame:getContentSize().width * (0.32 * i - 0.3), labelFrame:getContentSize().height * 0.5):addTo(labelFrame)
    local icon = display.newSprite(pModel.itemIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    local itemNum = tonumber(self.mRewardList[i].num)
    if 100000 <= itemNum then
      itemNum = string.format("%d\228\184\135", math.floor(itemNum / 10000))
    end
    DYLabelTTF.new({
      text = "X" .. itemNum,
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):scale(1.8181818181818181):pos(iconFrame:getContentSize().width, 20):addTo(iconFrame, 1)
    local pLayer
    iconFrame:setTouchEnabled(true)
    iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
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
  local sp = display.newSprite("activity/label1.png"):pos(bg:getContentSize().width * 0.72, bg:getContentSize().height * 0.72):addTo(bg)
  local totalNum = tonumber(self.mActivityModel.taskNum)
  local currNum = self.mCurrProgress
  if 9 == self.mActivityModel.type or 12 == self.mActivityModel.type then
    totalNum = 1
  end
  local str1 = currNum < 10000 and currNum or string.format("%d\228\184\135", math.floor(currNum / 10000))
  local str2 = totalNum < 10000 and totalNum or string.format("%s\228\184\135", tostring(totalNum / 10000))
  local textStr = str1 .. "/" .. str2
  local numLabel = DYLabelTTF.new({
    text = textStr,
    color = cc.c3b(77, 255, 22),
    size = 24,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):align(display.CENTER_LEFT, sp:getPositionX() + sp:getContentSize().width * 0.55, sp:getPositionY() - 5):addTo(bg)
  local btnText1 = DYLabelTTF.new({
    text = DYLang.getString("S340", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })
  local btnText2 = DYLabelTTF.new({
    text = DYLang.getString("S341", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })
  self.mBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):scale(0.85):setButtonLabel("normal", btnText1):setButtonLabel("disabled", btnText2):align(display.CENTER, bg:getContentSize().width * 0.88, bg:getContentSize().height * 0.3):onButtonClicked(function()
    if currNum < totalNum then
      self:layerChange()
    else
      self:getAwardCallback()
    end
  end):addTo(bg)
  local str = {
    DYLang.getString("S6", ""),
    DYLang.getString("S18", ""),
    DYLang.getString("S5", ""),
    DYLang.getString("S20", ""),
    DYLang.getString("S336", ""),
    DYLang.getString("S22", ""),
    DYLang.getString("S348", ""),
    DYLang.getString("S349", ""),
    DYLang.getString("S350", "")
  }
  if currNum < totalNum then
    btnText1:setString(str[self.mActivityModel.loadTo])
  else
    numLabel:setString(DYLang.getString("S7", ""))
  end
  if currNum >= totalNum and 0 >= self.mStatus then
    self.mIsActive = true
  end
  if 0 < self.mStatus then
    self:performWithDelay(function()
      self.mBtn:setButtonEnabled(false)
    end, 0)
  end
end

function M:getAwardCallback()
  DDLOG("get award")
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  
  local function tFuncListener(event)
    dump(event, " event : ", 5)
    if dy.share.EVENT_SHARE_SUCC == event.event then
      local params = {
        taskId = self.mTaskId,
        loadTo = 0,
        tar = self.mBtn
      }
      if self.mCallback then
        self.mCallback(params)
      end
    elseif dy.share.EVENT_SHARE_FAIL == event.event then
      local errMsg = event.param.error or DYLang.getString("S352", "")
      WSToast.new(errMsg, 2):addTo(display.getRunningScene(), 100)
    end
  end
  
  local res = self.mActivityModel.param2
  local path = cc.FileUtils:getInstance():fullPathForFilename(res)
  local params = {
    method = "weixin",
    title = "",
    content = self.mActivityModel.param1,
    imgpath = path
  }
  DYShareMgr.share(params, tFuncListener)
end

function M:layerChange()
  DDLOG("layer change")
  local params = {
    taskId = self.mTaskId,
    loadTo = self.mActivityModel.loadTo
  }
  if self.mCallback then
    self.mCallback(params)
  end
  if tonumber(self.mActivityModel.loadTo) == 3 then
  elseif tonumber(self.mActivityModel.loadTo) == 1 then
  end
end

return M

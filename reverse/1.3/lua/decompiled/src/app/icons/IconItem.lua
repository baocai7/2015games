local LayerItem = require("app.layers.LayerItem")
local M = {}
local M = class("IconItem", function()
  return display.newNode()
end)

function M:ctor(id, num, state)
  self.mId = id
  self.mQuality = 0
  self.mImg = nil
  self.mFrame = nil
  self.mIcon = nil
  self.mNumLab = nil
  self.mTipLayer = nil
  if checknumber(id) == 0 then
    self.mImg = "common_ui/frame_loading.png"
  else
    local itemInfo = DataUtils.getItemModel(id)
    self.mImg = itemInfo.itemIcon
    self.mQuality = itemInfo.quality or 0
  end
  if 0 < checknumber(num) then
    self.mNum = checknumber(num)
  end
  if state and state == "GRAY" then
    self:initGrayUI()
  else
    self:initNormalUI()
  end
end

function M:initNormalUI()
  self.mFrame = display.newSprite("common_ui/frame" .. self.mQuality .. ".png"):addTo(self)
  self.mIcon = display.newSprite(self.mImg):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame)
  self.mSelectedFrame = display.newSprite("common_ui/frame_selected.png"):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):hide():addTo(self.mFrame)
  if self.mNum then
    self.mNumLab = cc.ui.UILabel.new({
      UILabelType = 1,
      text = string.format("*%d", self.mNum),
      font = "fonts/whiteNum.fnt"
    }):align(display.CENTER_RIGHT, self.mFrame:getContentSize().width * 0.95, self.mFrame:getContentSize().height * 0.15):scale(0.5):addTo(self.mFrame, 1)
  end
end

function M:initGrayUI()
  self.mFrame = display.newGraySprite("common_ui/frame" .. self.mQuality .. ".png", {
    0.2,
    0.3,
    0.5,
    0.1
  }):addTo(self)
  self.mIcon = display.newGraySprite(self.mImg, {
    0.2,
    0.3,
    0.5,
    0.1
  }):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame)
  if self.mNum then
    self.mNumLab = cc.ui.UILabel.new({
      UILabelType = 1,
      text = string.format("*%d", self.mNum),
      font = "fonts/whiteNum.fnt"
    }):align(display.CENTER_RIGHT, self.mFrame:getContentSize().width * 0.95, self.mFrame:getContentSize().height * 0.15):scale(0.5):addTo(self.mFrame, 1)
  end
end

function M:showItemTip()
  if checknumber(self.mId) == 0 then
    return
  end
  self.mFrame:setTouchEnabled(true)
  self.mFrame:setTouchSwallowEnabled(false)
  self.mFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name = event.name
    if name == "began" then
      if self.mTipLayer then
        self.mTipLayer:runAction(cc.RemoveSelf:create())
        self.mTipLayer = nil
      end
      self.mTipLayer = LayerItem.new(LayerItem.TYPE_TIP, self.mId):pos(display.cx, display.cy)
      display.getRunningScene():addChild(self.mTipLayer, 100)
      return true
    elseif name == "ended" then
      self.mTipLayer:runAction(cc.RemoveSelf:create())
      self.mTipLayer = nil
    end
  end)
end

function M:showTip()
  if checknumber(self.mId) == 0 then
    return
  end
  if self.mTipLayer then
    self.mTipLayer:runAction(cc.RemoveSelf:create())
    self.mTipLayer = nil
  end
  self.mTipLayer = LayerItem.new(LayerItem.TYPE_TIP, self.mId):pos(display.cx, display.cy)
  display.getRunningScene():addChild(self.mTipLayer, 100)
end

function M:hideTip()
  if self.mTipLayer then
    self.mTipLayer:runAction(cc.RemoveSelf:create())
    self.mTipLayer = nil
  end
end

function M:setColor(color)
  self.mFrame:setColor(color)
  self.mIcon:setColor(color)
end

function M:reloadTexture(id, num)
  if checknumber(id) == 0 then
    return
  end
  self.mId = checknumber(id)
  local itemInfo = DataUtils.getItemModel(checknumber(id))
  if itemInfo then
    self.mImg = itemInfo.itemIcon
    self.mQuality = itemInfo.quality
  end
  self.mNum = checknumber(num)
  if self.mFrame then
    self.mFrame:setTexture("common_ui/frame" .. self.mQuality .. ".png")
  end
  if self.mIcon then
    self.mIcon:setTexture(self.mImg)
  end
  if self.mNumLab then
    local str = 0 < self.mNum and self.mNum or ""
    self.mNumLab:setString(str)
  elseif 0 < self.mNum and self.mFrame then
    self.mNumLab = cc.ui.UILabel.new({
      UILabelType = 1,
      text = string.format("*%d", self.mNum),
      font = "fonts/whiteNum.fnt"
    }):align(display.CENTER_RIGHT, self.mFrame:getContentSize().width * 0.95, self.mFrame:getContentSize().height * 0.15):scale(0.5):addTo(self.mFrame, 1)
  end
end

function M:setSelected(flag)
  self.mSelectedFrame:setVisible(flag)
end

return M

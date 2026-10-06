local LayerLackEnergy = require("app.layers.LayerLackEnergy")
local LayerRecharge = require("app.layers.LayerRecharge")
local LayerLackEssence = require("app.layers.LayerLackEssence")
local WSToast = require("app.utils.WSToast")
local DataLabelIcon = {}
DataLabelIcon = class("DataLabelIcon", function()
  return display.newNode()
end)
DataLabelIcon.LABEL_TYPE_ENERGY = 1
DataLabelIcon.LABEL_TYPE_EXP = 2
DataLabelIcon.LABEL_TYPE_PEACH = 3
DataLabelIcon.LABEL_TYPE_ESSENCE = 4

function DataLabelIcon:ctor(labelType, isEnabled)
  self.type_ = labelType
  local labelFrame = display.newSprite():addTo(self)
  local dataNumber = 0
  if self.type_ == DataLabelIcon.LABEL_TYPE_ENERGY then
    dataNumber = CloudData.ENERGY
    local maxEnergyNum = CloudData.MAX_ENERGY
    self.maxEnergy_ = CloudData.MAX_ENERGY
    labelFrame:setTexture("common_ui/energy_bg.png")
    self.energyNumLabel_ = cc.ui.UILabel.new({
      UILabelType = 1,
      text = string.format(dataNumber),
      font = "fonts/whiteNum.fnt"
    }):scale(0.65):align(display.CENTER_LEFT, labelFrame:getContentSize().width * 0.25, labelFrame:getContentSize().height * 0.5):addTo(labelFrame, 2)
    self.maxEnergyNumLabel_ = cc.ui.UILabel.new({
      UILabelType = 1,
      text = string.format("/" .. maxEnergyNum),
      font = "fonts/bulefonts.fnt"
    }):scale(0.65):align(display.CENTER_LEFT, self.energyNumLabel_:getPositionX() + self.energyNumLabel_:getContentSize().width * 0.65, labelFrame:getContentSize().height * 0.5):addTo(labelFrame, 2)
  elseif self.type_ == DataLabelIcon.LABEL_TYPE_EXP then
    dataNumber = CloudData.EXP
    labelFrame:setTexture("common_ui/exp_bg.png")
    self.expNumLabel_ = cc.ui.UILabel.new({
      UILabelType = 1,
      text = string.format(dataNumber),
      font = "fonts/whiteNum.fnt"
    }):scale(0.65):align(display.CENTER, labelFrame:getContentSize().width * 0.52, labelFrame:getContentSize().height * 0.5):addTo(labelFrame, 2)
  elseif self.type_ == DataLabelIcon.LABEL_TYPE_PEACH then
    dataNumber = CloudData.PEACH
    labelFrame:setTexture("common_ui/peach_bg.png")
    local textStr = dataNumber
    if 100000 < dataNumber then
      textStr = string.format("%d\228\184\135", math.floor(dataNumber / 10000))
    end
    self.peachNumLabel_ = DYLabelTTF.new({
      text = textStr,
      size = 27,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }, {}):pos(labelFrame:getContentSize().width * 0.51, labelFrame:getContentSize().height * 0.5 - 2):addTo(labelFrame, 2)
  else
    dataNumber = CloudData.ESSENCE
    labelFrame:setTexture("common_ui/essence_bg.png")
    local textStr = dataNumber
    if 100000 < dataNumber then
      textStr = string.format("%d\228\184\135", math.floor(dataNumber / 10000))
    end
    self.essenceNumLabel_ = DYLabelTTF.new({
      text = textStr,
      size = 27,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }, {}):pos(labelFrame:getContentSize().width * 0.51, labelFrame:getContentSize().height * 0.5 - 2):addTo(labelFrame, 2)
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/add.png",
    pressed = "common_ui/add1.png"
  }):onButtonClicked(function()
    self:touchLabelIcon_(self.type_)
  end):align(display.CENTER, labelFrame:getContentSize().width * 0.91, labelFrame:getContentSize().height * 0.55):addTo(labelFrame, 3)
  self.historyDataNum_ = dataNumber
  if isEnabled then
    labelFrame:setTouchEnabled(true)
    labelFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onTouch(event.name, event.x, event.y)
    end)
  end
  self:setContentSize(cc.size(labelFrame:getContentSize().width, labelFrame:getContentSize().height))
  self.schedule_ = self:schedule(function()
    self:updateDataLabel_()
  end, 0.1)
end

function DataLabelIcon:onTouch(event, x, y)
  if event == "began" then
    self.touchBeginPoint_ = {x = x, y = y}
    return true
  end
  if event == "moved" then
  end
  if event == "ended" then
    local touchEndedPoint = {x = x, y = y}
    if math.abs(self.touchBeginPoint_.x - touchEndedPoint.x) < 20 and math.abs(self.touchBeginPoint_.y - touchEndedPoint.y) < 20 and cc.rectContainsPoint(self:getMyBoundingBox(), touchEndedPoint) then
      self:touchLabelIcon_(self.type_)
    end
  end
end

function DataLabelIcon:touchLabelIcon_(labelType)
  local currScene = display.getRunningScene()
  if self.type_ == DataLabelIcon.LABEL_TYPE_ENERGY then
    printf("LABEL_TYPE_ENERGY")
    local ene = LayerLackEnergy.new()
    currScene:addChild(ene, 20)
  elseif self.type_ == DataLabelIcon.LABEL_TYPE_PEACH then
    printf("LABEL_TYPE_PEACH")
    local layer = LayerRecharge.new()
    currScene:addChild(layer, 20)
  elseif self.type_ == DataLabelIcon.LABEL_TYPE_ESSENCE then
    printf("LABEL_TYPE_ESSENCE")
    local pLayer = LayerLackEssence.new()
    currScene:addChild(pLayer, 20)
  end
end

function DataLabelIcon:updateDataLabel_()
  if self.type_ == DataLabelIcon.LABEL_TYPE_ENERGY then
    if self.historyDataNum_ ~= CloudData.ENERGY or self.maxEnergy_ ~= CloudData.MAX_ENERGY then
      self.energyNumLabel_:setString(string.format(CloudData.ENERGY))
      self.maxEnergyNumLabel_:setString(string.format("/" .. CloudData.MAX_ENERGY))
      self.maxEnergyNumLabel_:setPositionX(self.energyNumLabel_:getPositionX() + self.energyNumLabel_:getContentSize().width * 0.65)
      self.historyDataNum_ = CloudData.ENERGY
      self.maxEnergy_ = CloudData.MAX_ENERGY
    end
  elseif self.type_ == DataLabelIcon.LABEL_TYPE_EXP then
    if self.historyDataNum_ ~= CloudData.EXP then
      self.expNumLabel_:setString(string.format(CloudData.EXP))
      self.historyDataNum_ = CloudData.EXP
    end
  elseif self.type_ == DataLabelIcon.LABEL_TYPE_PEACH then
    if self.historyDataNum_ ~= CloudData.PEACH then
      local textStr = CloudData.PEACH
      if CloudData.PEACH > 100000 then
        textStr = string.format("%d\228\184\135", math.floor(CloudData.PEACH / 10000))
      end
      self.peachNumLabel_:setString(textStr)
      self.historyDataNum_ = CloudData.PEACH
    end
  elseif self.historyDataNum_ ~= CloudData.ESSENCE then
    local textStr = CloudData.ESSENCE
    if 100000 < CloudData.ESSENCE then
      textStr = string.format("%d\228\184\135", math.floor(CloudData.ESSENCE / 10000))
    end
    self.essenceNumLabel_:setString(textStr)
    self.historyDataNum_ = CloudData.ESSENCE
  end
end

function DataLabelIcon:getMyBoundingBox()
  local rect = cc.rect(self:getPositionX() - self:getContentSize().width * 0.5, self:getPositionY() - self:getContentSize().height * 0.5, self:getContentSize().width, self:getContentSize().height)
  return rect
end

return DataLabelIcon

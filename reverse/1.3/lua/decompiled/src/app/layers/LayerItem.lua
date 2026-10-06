local CLASS_NAME = "LayerItem"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.TYPE_TIP = 20001
M.TYPE_LAYER = 20002

function M:ctor(layerType, itemId)
  self:initData(layerType, itemId)
  if M.TYPE_TIP == layerType then
    self.mNode = display.newNode():addTo(self, 1)
    self:initTipUI()
  elseif M.TYPE_LAYER == layerType then
    display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
    self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0.2, 1.1),
      cc.ScaleTo:create(0.1, 1)
    })
    self.mNode:runAction(popupLayer)
    DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
    self:initLayerUI()
  end
end

function M:initData(layerType, itemId)
  self.mLayerType = layerType
  self.mItemId = itemId
  self.mItemModel = DataUtils.getItemInfoWithSource(itemId)
end

function M:initTipUI()
  local bg = display.newSprite("common_ui/common_tip1.png"):addTo(self.mNode)
  display.newSprite("package/label_info.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.92):addTo(bg)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mItemModel.quality)):align(display.CENTER_LEFT, bg:getContentSize().width * 0.05, bg:getContentSize().height * 0.68):addTo(bg)
  display.newSprite(self.mItemModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  cc.ui.UILabel.new({
    text = self.mItemModel.name,
    color = self.mItemModel.color,
    size = 26,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, iconFrame:getContentSize().width + iconFrame:getPositionX() + 5, bg:getContentSize().height * 0.76):addTo(bg)
  local lb1 = cc.ui.UILabel.new({
    text = DYLang.getString("S710", ""),
    color = cc.c3b(255, 234, 4),
    size = 26,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, iconFrame:getContentSize().width + iconFrame:getPositionX() + 5, bg:getContentSize().height * 0.6):addTo(bg)
  cc.ui.UILabel.new({
    text = self.mItemModel.currNum,
    color = display.COLOR_WHITE,
    size = 24,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, lb1:getContentSize().width + lb1:getPositionX(), bg:getContentSize().height * 0.6):addTo(bg)
  local textFrame = display.newSprite("common_ui/dialog_bg1.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.27):addTo(bg)
  textFrame:setColor(cc.c3b(29, 22, 13))
  cc.ui.UILabel.new({
    text = self.mItemModel.itemDesc,
    color = cc.c3b(223, 185, 140),
    size = 24,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(360, 130),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, textFrame:getContentSize().width * 0.5, textFrame:getContentSize().height * 0.5):addTo(textFrame)
end

function M:initLayerUI()
  local bg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(522, 607), cc.rect(100, 100, 2, 2)):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.95, bg:getContentSize().height * 0.95):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg)
  display.newSprite("package/label_info.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.92):addTo(bg)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mItemModel.quality)):align(display.CENTER_LEFT, bg:getContentSize().width * 0.12, bg:getContentSize().height * 0.75):addTo(bg)
  display.newSprite(self.mItemModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  DYLabelTTF.new({
    text = self.mItemModel.name,
    color = self.mItemModel.color,
    size = 26,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {lineWidth = 2}):pos(iconFrame:getContentSize().width + iconFrame:getPositionX() + 5, bg:getContentSize().height * 0.8):addTo(bg)
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S710", ""),
    color = cc.c3b(252, 255, 8),
    size = 26,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {lineWidth = 2}):pos(iconFrame:getContentSize().width + iconFrame:getPositionX() + 5, bg:getContentSize().height * 0.7):addTo(bg)
  DYLabelTTF.new({
    text = self.mItemModel.currNum,
    color = display.COLOR_WHITE,
    size = 24,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {lineWidth = 2}):pos(lb1:getContentSize().width + lb1:getPositionX(), bg:getContentSize().height * 0.7):addTo(bg)
  local textFrame = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(424, 145), cc.rect(55, 45, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.52):addTo(bg)
  cc.ui.UILabel.new({
    text = self.mItemModel.itemDesc,
    color = cc.c3b(55, 35, 5),
    size = 24,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(388, 116),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, textFrame:getContentSize().width * 0.5, textFrame:getContentSize().height * 0.5):addTo(textFrame)
  DYLabelTTF.new({
    text = DYLang.getString("S712", ""),
    color = cc.c3b(252, 255, 8),
    size = 26,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(bg:getContentSize().width * 0.12, bg:getContentSize().height * 0.34):addTo(bg)
  local listFrame = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(424, 120), cc.rect(55, 45, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.21):addTo(bg)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(12, 10, 400, 100),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(listFrame)
  for i = 1, #self.mItemModel.fromNum do
    local item = listView:newItem()
    local content = self:getListContent(i)
    item:addContent(content)
    item:setItemSize(400, 65)
    listView:addItem(item)
  end
  listView:reload()
end

function M:getListContent(idx)
  local pNode = display.newNode()
  pNode:setContentSize(cc.size(400, 65))
  local textStr = self.mItemModel.fromText[idx]
  local fromNum = self.mItemModel.fromNum[idx]
  local fromParam = self.mItemModel.fromParam[idx]
  local isOpen = self.mItemModel.isOpen[idx]
  if fromNum < 0 then
    return pNode
  end
  local chapterNum = 0
  local stageNum = 0
  if 1 == fromNum then
    chapterNum = math.ceil(fromParam / 10)
    stageNum = fromParam % 10
    if 0 == stageNum then
      stageNum = 10
    end
  end
  if 2 == fromNum then
    chapterNum = math.ceil(fromParam / 4)
    stageNum = fromParam % 4
    if 0 == stageNum then
      stageNum = 4
    end
  end
  if 3 == fromNum then
    chapterNum = fromParam
  end
  local descLabel = cc.ui.UILabel.new({
    text = textStr,
    size = 24,
    color = cc.c3b(5, 153, 46),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, pNode:getContentSize().width * 0.05, pNode:getContentSize().height * 0.5):addTo(pNode)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S713", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S713", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):scale(0.7):align(display.CENTER, pNode:getContentSize().width * 0.85, pNode:getContentSize().height * 0.5):onButtonClicked(function()
    self:layerTransition(fromNum, chapterNum, stageNum)
  end):addTo(pNode)
  if 0 == isOpen then
    descLabel:setColor(cc.c3b(247, 9, 8))
    btn:setButtonEnabled(false)
  end
  return pNode
end

function M:layerTransition(fromNum, chapterNum, stageNum)
  local tFunc = {
    [1] = function()
      display.replaceScene(require("app.scenes.SceneStage").new(1, chapterNum, stageNum))
    end,
    [2] = function()
      display.replaceScene(require("app.scenes.SceneStage").new(2, chapterNum, stageNum))
    end,
    [3] = function()
      require("app.layers.LayerShopNew").new(3):addTo(self, 20)
    end,
    [4] = function()
      display.replaceScene(require("app.scenes.SceneSummon").new())
    end,
    [5] = function()
      require("app.layers.LayerActivity").new():addTo(self, 20)
    end,
    [6] = function()
      display.replaceScene(require("app.scenes.SceneTravel").new())
    end,
    [7] = function()
      display.replaceScene(require("app.scenes.SceneStage").new(2))
    end,
    [8] = function()
      display.replaceScene(require("app.scenes.SceneStage").new())
    end,
    [9] = function()
      display.replaceScene(require("app.babel.SceneBabel").new())
    end
  }
  return tFunc[fromNum]()
end

function M:touchListener(event)
  local lv = event.listView
  if "clicked" == event.name then
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.mNode:runAction(popupLayer)
end

return M

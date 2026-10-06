local PackageIcon = require("app.icons.PackageIcon")
local WSToast = require("app.utils.WSToast")
local LayerBoxShow = require("app.layers.LayerBoxShow")
local CLASS_NAME = "LayerPackage"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(cb)
  self.mCallback = cb
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initUI()
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mItemTable = {}
  self.mItemIdList = {}
  self.mIconTable = {}
  
  local function tFuncListener(packageInfo)
    if not self or self.__cname ~= CLASS_NAME then
      return
    end
    self.mItemTable = packageInfo.data
    for k, v in pairs(packageInfo.data) do
      table.insert(self.mItemIdList, tonumber(k))
    end
    table.sort(self.mItemIdList, function(v1, v2)
      return v1 < v2
    end)
    self:itemInfoShow()
    self:initItemList()
  end
  
  DYHttpMgr.initPackageInfo(tFuncListener)
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_frame9.png", display.cx, display.cy, cc.size(972, 689), cc.rect(510, 240, 1, 1)):addTo(self)
  self.mFrame = display.newSprite("package/bottom.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeDialog()
  end):align(display.CENTER, bg:getContentSize().width * 0.96, bg:getContentSize().height * 0.96):addTo(bg, 2)
end

function M:initItemList()
  local listFrame = display.newScale9Sprite("common_ui/common_frame10.png", self.mFrame:getContentSize().width * 0.7, self.mFrame:getContentSize().height * 0.51, cc.size(510, 605), cc.rect(50, 40, 5, 5)):opacity(0):addTo(self.mFrame)
  self.mListFrame = listFrame
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(10, 12, 490, 581),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(listFrame, 2)
  local tb_count = #self.mItemIdList
  local totalNum = tb_count < 20 and 20 or tb_count
  local row = math.ceil(totalNum / 4)
  local endNum = 4
  local idx = 1
  
  local function tFuncAddItem()
    if idx <= row then
      local item = listView:newItem()
      local content = display.newNode()
      for count = 1, endNum do
        local id = self.mItemIdList[count + (idx - 1) * 4]
        local currNum = self.mItemTable[tostring(id)]
        local icon
        if id then
          icon = PackageIcon.new(id, currNum)
          table.insert(self.mIconTable, icon)
        else
          icon = PackageIcon.new()
        end
        icon:setPosition(122 * count - 61, 62)
        content:addChild(icon)
      end
      content:setContentSize(488, 124)
      item:addContent(content)
      item:setItemSize(488, 124)
      listView:addItem(item)
    end
    listView:reload()
    if idx < row then
      idx = idx + 1
      self:performWithDelay(tFuncAddItem, 0)
    end
  end
  
  tFuncAddItem()
  if self.mIconTable[1] then
    self:selectedIconShow(self.mIconTable[1])
  end
end

function M:initItemList2()
  local listFrame = display.newScale9Sprite("common_ui/common_frame10.png", self.mFrame:getContentSize().width * 0.7, self.mFrame:getContentSize().height * 0.51, cc.size(510, 605), cc.rect(50, 40, 5, 5)):opacity(0):addTo(self.mFrame)
  self.mListFrame = listFrame
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(10, 12, 490, 581),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(listFrame, 2)
  local tb_count = #self.mItemIdList
  local totalNum = tb_count < 20 and 20 or tb_count
  local row = math.ceil(totalNum / 4)
  local endNum = 4
  for i = 1, row do
    local item = listView:newItem()
    local content = display.newNode()
    for count = 1, endNum do
      local id = self.mItemIdList[count + (i - 1) * 4]
      local currNum = self.mItemTable[tostring(id)]
      local icon
      if id then
        icon = PackageIcon.new(id, currNum)
        table.insert(self.mIconTable, icon)
      else
        icon = PackageIcon.new()
      end
      icon:setPosition(122 * count - 61, 62)
      content:addChild(icon)
    end
    content:setContentSize(488, 124)
    item:addContent(content)
    item:setItemSize(488, 124)
    listView:addItem(item)
  end
  listView:reload()
end

function M:itemInfoShow()
  local infoFrame = display.newScale9Sprite("common_ui/common_frame10.png", self.mFrame:getContentSize().width * 0.215, self.mFrame:getContentSize().height * 0.51, cc.size(355, 605), cc.rect(50, 40, 5, 5)):opacity(0):addTo(self.mFrame)
  local iconFrame = display.newSprite("common_ui/frame0.png"):align(display.CENTER_LEFT, 15, infoFrame:getContentSize().height * 0.9):addTo(infoFrame)
  self.mIconFrame = iconFrame
  self.mIconPic = display.newSprite("common_ui/frame0.png", iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  self.mIconName = DYLabelTTF.new({
    text = "",
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(iconFrame:getContentSize().width + iconFrame:getPositionX() + 5, infoFrame:getContentSize().height * 0.95):addTo(infoFrame)
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S774", ""),
    color = cc.c3b(69, 36, 20),
    size = 24,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getContentSize().width + iconFrame:getPositionX() + 5, infoFrame:getContentSize().height * 0.85):addTo(infoFrame)
  self.mIconNum = cc.ui.UILabel.new({
    UILabelType = 1,
    text = 0,
    font = "fonts/yellowNum.fnt"
  }):scale(0.65):align(display.CENTER_LEFT, lb1:getPositionX() + lb1:getContentSize().width, infoFrame:getContentSize().height * 0.855):addTo(infoFrame)
  local frame1 = display.newSprite("package/img_01.png"):pos(infoFrame:getContentSize().width * 0.5, infoFrame:getContentSize().height * 0.63):addTo(infoFrame)
  display.newSprite("package/img_title_02.png"):align(display.CENTER_LEFT, 0, frame1:getContentSize().height + 20):addTo(frame1)
  self.mDescLabel = cc.ui.UILabel.new({
    text = "",
    size = 20,
    color = cc.c3b(69, 36, 20),
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(304, 90),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, frame1:getContentSize().width * 0.5, frame1:getContentSize().height * 0.5):addTo(frame1)
  local frame2 = display.newSprite("package/img_02.png"):pos(infoFrame:getContentSize().width * 0.5, infoFrame:getContentSize().height * 0.31):addTo(infoFrame)
  display.newSprite("package/img_title_01.png"):align(display.CENTER_LEFT, 0, frame2:getContentSize().height + 20):addTo(frame2)
  self.mListView = cc.ui.UIListView.new({
    bgColor = cc.c4b(255, 255, 255, 160),
    viewRect = cc.rect(0, 0, 325, 174),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener1)):addTo(frame2)
  
  local function createButton(buttonImage, textStr, listener)
    local buttonImage = buttonImage or {
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }
    local button = cc.ui.UIPushButton.new(buttonImage):setButtonLabel("normal", DYLabelTTF.new({
      text = textStr,
      size = 30,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(25, 30, 3)
    })):hide():scale(0.75):onButtonClicked(function()
      listener()
    end):align(display.CENTER, infoFrame:getContentSize().width * 0.5, infoFrame:getContentSize().height * 0.08):addTo(infoFrame, 1)
    return button
  end
  
  self.mSaleBtn = createButton(nil, DYLang.getString("S775", ""), handler(self, self.saleCallBack))
  self.mUseBtn = createButton(nil, DYLang.getString("S776", ""), handler(self, self.useCallBack))
  self.mUseBtn10 = createButton({
    normal = "common_ui/btn_orange_n.png",
    pressed = "common_ui/btn_orange_p.png"
  }, "\228\189\191\231\148\168\229\141\129\230\172\161", handler(self, self.useCallBack10))
end

function M:checkFuncBtn(salePrice, canUse)
  if 0 < salePrice and 0 <= canUse then
    self.mSaleBtn:show()
    self.mUseBtn:show()
    self.mUseBtn10:hide()
    self.mSaleBtn:setPositionX(self.mSaleBtn:getParent():getContentSize().width * 0.25)
    self.mUseBtn:setPositionX(self.mSaleBtn:getParent():getContentSize().width * 0.75)
    if 0 == canUse then
      self.mUseBtn10:show()
      self.mSaleBtn:setPositionX(self.mSaleBtn:getParent():getContentSize().width * 0.18)
      self.mUseBtn:setPositionX(self.mSaleBtn:getParent():getContentSize().width * 0.5)
      self.mUseBtn10:setPositionX(self.mSaleBtn:getParent():getContentSize().width * 0.82)
    end
  elseif 0 < salePrice and canUse < 0 then
    self.mSaleBtn:show()
    self.mUseBtn:hide()
    self.mUseBtn10:hide()
    self.mSaleBtn:setPositionX(self.mSaleBtn:getParent():getContentSize().width * 0.5)
  elseif salePrice < 0 and 0 <= canUse then
    self.mSaleBtn:hide()
    self.mUseBtn:show()
    self.mUseBtn10:hide()
    self.mUseBtn:setPositionX(self.mSaleBtn:getParent():getContentSize().width * 0.5)
    if 0 == canUse then
      self.mUseBtn10:show()
      self.mUseBtn:setPositionX(self.mSaleBtn:getParent():getContentSize().width * 0.25)
      self.mUseBtn10:setPositionX(self.mSaleBtn:getParent():getContentSize().width * 0.75)
    end
  elseif salePrice < 0 and canUse < 0 then
    self.mSaleBtn:hide()
    self.mUseBtn:hide()
    self.mUseBtn10:hide()
  end
end

function M:selectedIconShow(icon)
  if not icon then
    return
  end
  icon:setSelected(true)
  self.mItemModel = icon.mItemModel
  self.mIconFrame:setTexture(string.format("common_ui/frame%d.png", self.mItemModel.quality))
  self.mIconPic:setTexture(self.mItemModel.itemIcon)
  self.mIconName:setString(self.mItemModel.itemName)
  self.mIconName:setColor(self.mItemModel.color)
  self.mIconNum:setString(tonumber(CloudData.GAME_ITEM_INFO[tostring(self.mItemModel.itemId)]))
  self.mDescLabel:setString(self.mItemModel.itemDesc)
  if self.mListView then
    local frame = self.mListView:getParent()
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
    self.mListView = cc.ui.UIListView.new({
      viewRect = cc.rect(10, 8, 311, 174),
      direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
    }):onTouch(handler(self, self.touchListener1)):addTo(frame)
    for i = 1, #self.mItemModel.fromNum do
      local item = self.mListView:newItem()
      local content = self:getListContent(self.mItemModel, i)
      item:addContent(content)
      item:setItemSize(311, 62)
      self.mListView:addItem(item)
    end
    self.mListView:reload()
  end
  local salePrice = self.mItemModel.salePrice
  local canUse = self.mItemModel.canUse
  self:checkFuncBtn(salePrice, canUse)
end

function M:getListContent(itemModel, idx)
  local pNode = display.newNode()
  pNode:setContentSize(cc.size(325, 62))
  local textStr = itemModel.fromText[idx]
  local fromNum = itemModel.fromNum[idx]
  local fromParam = itemModel.fromParam[idx]
  local isOpen = itemModel.isOpen[idx]
  if fromNum < 0 then
    return pNode
  end
  local chapterNum, stageNum = 0, 0
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
    size = 22,
    color = cc.c3b(69, 36, 20),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, pNode:getContentSize().width * 0.05, pNode:getContentSize().height * 0.5):addTo(pNode)
  local btn = cc.ui.UIPushButton.new({
    normal = "package/btn_obtain_n.png",
    pressed = "package/btn_obtain_p.png",
    disabled = "package/btn_obtain_d.png"
  }):align(display.CENTER, pNode:getContentSize().width * 0.82, pNode:getContentSize().height * 0.5):onButtonClicked(function()
    self:layerTransition(fromNum, chapterNum, stageNum)
  end):addTo(pNode)
  display.newSprite("package/img_splitline.png", pNode:getContentSize().width * 0.5, 0):addTo(pNode)
  if 0 == isOpen then
    pNode:performWithDelay(function()
      btn:setButtonEnabled(false)
    end, 0)
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
      require("app.layers.LayerShopNew").new(chapterNum + 2):addTo(self, 20)
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
  if "clicked" == event.name then
    local column = math.ceil(event.point.x / 122)
    local idx = (event.itemPos - 1) * 4 + column
    DDLOG("idx : %d", idx)
    if idx > #self.mIconTable then
      return
    end
    for i = 1, #self.mIconTable do
      local icon = self.mIconTable[i]
      if i == idx then
        icon:setSelected(true)
        self.mIndex = idx
        self:selectedIconShow(icon)
      else
        icon:setSelected(false)
      end
    end
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:touchListener1(event)
  if "clicked" == event.name then
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:saleCallBack()
  local pMaskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 1)
  local bg = display.newSprite("common_ui/common_dialog.png", display.cx, display.cy):scale(0):addTo(self, 2)
  bg:runAction(transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  }))
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(502, 122), cc.rect(40, 40, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.7):addTo(bg)
  local currNum = 0
  local totalNum = tonumber(CloudData.GAME_ITEM_INFO[tostring(self.mItemModel.itemId)])
  local saleNum = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("%d/%d", currNum, totalNum),
    font = "fonts/whiteNum.fnt"
  }):scale(0.65):align(display.CENTER, frame:getContentSize().width * 0.35, frame:getContentSize().height * 0.5):addTo(frame)
  local salePrice = self.mItemModel.salePrice
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S779", ""),
    color = cc.c3b(255, 252, 0),
    size = 30,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(7, 7, 7)
  }):pos(bg:getContentSize().width * 0.1, bg:getContentSize().height * 0.42):addTo(bg)
  local salePriceNum = cc.ui.UILabel.new({
    UILabelType = 1,
    text = salePrice * currNum,
    font = "fonts/whiteNum.fnt"
  }):scale(0.72):align(display.CENTER_LEFT, lb:getPositionX() + lb:getContentSize().width, bg:getContentSize().height * 0.42):addTo(bg)
  
  local function tFuncAddItem()
    if currNum >= totalNum then
      return
    end
    currNum = currNum + 1
    saleNum:setString(string.format("%d/%d", currNum, totalNum))
    salePriceNum:setString(salePrice * currNum)
  end
  
  local function tFuncMinusItem()
    if currNum < 1 then
      return
    end
    currNum = currNum - 1
    saleNum:setString(string.format("%d/%d", currNum, totalNum))
    salePriceNum:setString(salePrice * currNum)
  end
  
  local isOnTouch, touchTime, listener = false, 0
  self:schedule(function()
    if not isOnTouch then
      return
    end
    touchTime = touchTime + 1
    if 100 <= touchTime then
      for i = 1, 18 do
        listener()
      end
    elseif 60 <= touchTime then
      for i = 1, 9 do
        listener()
      end
    elseif 25 <= touchTime then
      for i = 1, 4 do
        listener()
      end
    elseif 10 <= touchTime then
      listener()
    end
  end, 0.1)
  local addBtn = cc.ui.UIPushButton.new({
    normal = "package/btn_add.png",
    pressed = "package/btn_add.png"
  }):onButtonPressed(function(event)
    event.target:setScale(0.95)
    isOnTouch, listener = true, tFuncAddItem
  end):onButtonRelease(function(event)
    event.target:setScale(1)
    isOnTouch, touchTime, listener = false, 0
  end):onButtonClicked(function()
    isOnTouch, touchTime, listener = false, 0
    tFuncAddItem()
  end):align(display.CENTER, frame:getContentSize().width * 0.6, frame:getContentSize().height * 0.5):addTo(frame)
  local minusBtn = cc.ui.UIPushButton.new({
    normal = "package/btn_add.png",
    pressed = "package/btn_add.png"
  }):onButtonPressed(function(event)
    event.target:setScale(-0.95, 0.95)
    isOnTouch, listener = true, tFuncMinusItem
  end):onButtonRelease(function(event)
    event.target:setScale(-1, 1)
    isOnTouch, touchTime, listener = false, 0
  end):onButtonClicked(function()
    isOnTouch, touchTime, listener = false, 0
    tFuncMinusItem()
  end):align(display.CENTER, frame:getContentSize().width * 0.1, frame:getContentSize().height * 0.5):addTo(frame)
  minusBtn:setScaleX(-1)
  local maxBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonSize(125, 61):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S780", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    currNum = totalNum
    saleNum:setString(string.format("%d/%d", currNum, totalNum))
    salePriceNum:setString(salePrice * currNum)
  end):align(display.CENTER, frame:getContentSize().width * 0.85, frame:getContentSize().height * 0.5):addTo(frame, 1)
  local ensureBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonSize(125, 61):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S38", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    if currNum == 0 then
      bg:runAction(transition.sequence({
        cc.ScaleTo:create(0.1, 1.1),
        cc.ScaleTo:create(0.2, 0),
        cc.CallFunc:create(function()
          bg:removeSelf()
          pMaskLayer:removeSelf()
        end)
      }))
      return
    end
    
    local function tFuncListener(jsonTable)
      if not self or self.__cname ~= CLASS_NAME then
        return
      end
      if jsonTable.errorCode > 0 then
        local errorMsg = jsonTable.errorMsg or "UNKNOWN"
        local toast = WSToast.new(errorMsg):addTo(self, 50)
        return
      end
      DYSoundMgr.playEffect(DY_SND.sfx_item_sell)
      CloudData.ESSENCE = jsonTable.data.essence
      CloudData.GAME_ITEM_INFO[tostring(self.mItemModel.itemId)] = jsonTable.data.leftCount
      local leftNum = jsonTable.data.leftCount
      DYAnalyze.item.consume(self.mItemModel.itemId, "", currNum, "Package_sale")
      DYAnalyze.item.get("2", "", salePrice * currNum, "Package_sale")
      self:updateLabel(leftNum)
      if 0 == leftNum then
        table.remove(self.mItemIdList, self.mIndex)
        self:updateList()
      end
      local str = DYLang.getString("S782", "") .. salePrice * currNum
      WSToast.new(str):addTo(self, 50)
      bg:runAction(transition.sequence({
        cc.ScaleTo:create(0.1, 1.1),
        cc.ScaleTo:create(0.2, 0),
        cc.CallFunc:create(function()
          bg:removeSelf()
          pMaskLayer:removeSelf()
        end)
      }))
    end
    
    local strAppSecret = "AFDASDFA47#$%@568%^076"
    local strSign = string.format("%s&count=%s&thingId=%s&token=%s&uid=%s", strAppSecret .. "", currNum .. "", self.mItemModel.itemId .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
    local params = {}
    params.thingId = self.mItemModel.itemId
    params.count = currNum
    params.sign = crypto.md5(strSign, false)
    DYHttpMgr.salePackageItem(tFuncListener, params)
  end):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.22):addTo(bg, 1)
  local cancelBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonSize(125, 61):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S783", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    bg:runAction(transition.sequence({
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        bg:removeSelf()
        pMaskLayer:removeSelf()
      end)
    }))
  end):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.22):addTo(bg, 1)
end

function M:useCallBack()
  local tFunc = {
    [2] = function()
      self:onEventItemType2(1)
    end,
    [5] = function()
      self:onEventItemType5(1)
    end,
    [6] = function()
      self:onEventItemType6(1)
    end
  }
  tFunc[self.mItemModel.itemType]()
end

function M:useCallBack10()
  if tonumber(CloudData.GAME_ITEM_INFO[tostring(self.mItemModel.itemId)]) < 10 then
    WSToast.new("\232\175\165\231\137\169\229\147\129\228\184\141\232\182\17910\228\184\170\239\188\129"):addTo(self, 50)
    return
  end
  local tFunc = {
    [2] = function()
      self:onEventItemType2(10)
    end,
    [5] = function()
      self:onEventItemType5(10)
    end,
    [6] = function()
      self:onEventItemType6(10)
    end
  }
  tFunc[self.mItemModel.itemType]()
end

function M:onEventItemType2(times)
  local tFunc = {
    [0] = function()
      local function tFuncListener(jsonTable)
        if not self or self.__cname ~= CLASS_NAME then
          return
        end
        if jsonTable.errorCode > 0 then
          local errorMsg = jsonTable.errorMsg or "UNKNOWN"
          local toast = WSToast.new(errorMsg):addTo(self, 50)
          return
        end
        CloudData.ENERGY = tonumber(jsonTable.data.energy)
        CloudData.GINSENG_FRUIT = tonumber(jsonTable.data.ginsen)
        self:updateLabel(jsonTable.data.ginsen)
        if 0 >= jsonTable.data.ginsen then
          table.remove(self.mItemIdList, self.mIndex)
          self:updateList()
        end
        local toastStr = " \231\178\190\229\138\155+" .. jsonTable.data.energyGain .. " "
        WSToast.new(toastStr):addTo(self, 50)
      end
      
      local params = {times = times}
      DYHttpMgr.useGinsen(tFuncListener, params)
    end,
    [1] = function()
      display.replaceScene(require("app.scenes.UpgradeScene").new())
    end,
    [2] = function()
      display.replaceScene(require("app.scenes.SceneStage").new())
    end,
    [3] = function()
      display.replaceScene(require("app.cimelia.scenes.SceneCimelia").new())
    end,
    [4] = function()
      require("app.layers.LayerShopNew").new(5):addTo(self, 20)
    end,
    [5] = function()
      require("app.layers.LayerShopNew").new(4):addTo(self, 20)
    end,
    [6] = function()
      require("app.layers.LayerShopNew").new(3):addTo(self, 20)
    end,
    [7] = function()
      display.replaceScene(require("app.scenes.SceneTreasure").new())
    end,
    [8] = function()
      display.replaceScene(require("app.scenes.SceneSummon").new())
    end,
    [9] = function()
      require("app.activity.collection.LayerCollection").new():addTo(self, 20)
    end
  }
  tFunc[self.mItemModel.canUse]()
end

function M:onEventItemType5(times)
  local function tFuncListener(jsonTable)
    if not self or self.__cname ~= CLASS_NAME then
      return
    end
    if jsonTable.errorCode > 0 then
      local errorMsg = jsonTable.errorMsg or "UNKNOWN"
      local toast = WSToast.new(errorMsg):addTo(self, 50)
      return
    end
    local isNewItem = false
    for k, v in pairs(jsonTable.data.drop) do
      DataUtils.updateItemNum(k, v)
      local itemModel = DataUtils.getItemModel(k)
      if 2 == itemModel.itemType or 5 == itemModel.itemType then
        local index = table.indexof(self.mItemIdList, tonumber(k))
        if not index then
          isNewItem = true
          table.insert(self.mItemIdList, tonumber(k))
        end
        self.mItemTable[tostring(k)] = v
      end
    end
    CloudData.GAME_ITEM_INFO[tostring(self.mItemModel.itemId)] = jsonTable.data.leftCount
    local leftNum = jsonTable.data.leftCount
    self:updateLabel(leftNum)
    if leftNum <= 0 then
      table.remove(self.mItemIdList, self.mIndex)
      self:updateList()
    elseif isNewItem then
      self:updateList()
    end
    local boxInfo = {}
    for k, v in pairs(jsonTable.data.dropGain) do
      local tb = {
        id = tonumber(k),
        num = v
      }
      table.insert(boxInfo, tb)
    end
    LayerBoxShow.new({boxInfo = boxInfo}, LayerBoxShow.AWARD_GET):addTo(self, 20)
  end
  
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&thingId=%s&times=%d&token=%s&uid=%s", strAppSecret .. "", self.mItemModel.itemId .. "", times, CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.thingId = self.mItemModel.itemId
  params.times = times
  params.sign = crypto.md5(strSign, false)
  DYHttpMgr.usePackageItem(tFuncListener, params)
end

function M:onEventItemType6(times)
  local function tFuncEvent(param)
    DDLOG(" ================ USE_CLAN_GIFT !!!!!!!")
    
    if param.ret_code > 0 then
      local errorMsg = param.err_msg or "UNKNOWN"
      local toast = WSToast.new(errorMsg):addTo(self, 50)
      return
    end
    CloudData.GAME_ITEM_INFO[tostring(self.mItemModel.itemId)] = param.data.leftCount
    local leftNum = param.data.leftCount
    self:updateLabel(leftNum)
    if leftNum <= 0 then
      table.remove(self.mItemIdList, self.mIndex)
      self:updateList()
    end
    WSToast.new(DYLang.getString("S784", "")):addTo(self, 50)
  end
  
  self:safeSocketRequest("CMD_USE_CLAN_GIFT", {
    thingId = self.mItemModel.itemId,
    times = times
  }, tFuncEvent)
end

function M:updateLabel(leftNum)
  DataUtils.updateItemNum(self.mItemModel.itemId, leftNum)
  self.mIconNum:setString(leftNum)
  local icon = self.mIconTable[self.mIndex]
  if icon and icon.mNumLabel then
    icon.mNumLabel:setString(string.format("*%d", leftNum))
  end
end

function M:updateList()
  if self.mListFrame then
    self.mListFrame:runAction(cc.RemoveSelf:create())
    self.mListFrame = nil
    self.mIconTable = {}
    self:initItemList()
  end
  for i = 1, #self.mIconTable do
    local icon = self.mIconTable[i]
    if icon.mItemModel.itemId == self.mItemModel.itemId then
      self.mIndex = i
      icon:setSelected(true)
      self:selectedIconShow(icon)
      return
    end
  end
  local icon = self.mIconTable[1]
  self.mIndex = 1
  if icon then
    icon:setSelected(true)
    self:selectedIconShow(icon)
  end
end

function M:closeDialog()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeDialog()
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

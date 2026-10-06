local M = {}
local M = class("IconCimeliaEquip", function()
  return display.newNode()
end)

function M:ctor(recipeData, handler_)
  self.mCallback = handler_
  self:initData(recipeData)
  self:initUI()
end

function M:initData(recipeData)
  self.mRecipeData = recipeData
  local params = {
    rate = recipeData.rate,
    quality = recipeData.quality
  }
  self.mCimeliaInfo = DataUtils.getCimeliaInfoWithId(recipeData.cid, params)
  self.mGoodsTable = {}
  local indexs = {
    1,
    2,
    3,
    4,
    5
  }
  if recipeData.fire ~= 0 then
    local tb = {
      index = 1,
      cost = recipeData.fire
    }
    table.insert(self.mGoodsTable, tb)
    indexs[1] = 0
  end
  if recipeData.gold ~= 0 then
    local tb = {
      index = 2,
      cost = recipeData.gold
    }
    table.insert(self.mGoodsTable, tb)
    indexs[2] = 0
  end
  if recipeData.wood ~= 0 then
    local tb = {
      index = 3,
      cost = recipeData.wood
    }
    table.insert(self.mGoodsTable, tb)
    indexs[3] = 0
  end
  if recipeData.earth ~= 0 then
    local tb = {
      index = 4,
      cost = recipeData.earth
    }
    table.insert(self.mGoodsTable, tb)
    indexs[4] = 0
  end
  if recipeData.water ~= 0 then
    local tb = {
      index = 5,
      cost = recipeData.water
    }
    table.insert(self.mGoodsTable, tb)
    indexs[5] = 0
  end
  local sum = 0
  for i = 1, #indexs do
    sum = sum + indexs[i]
  end
  if 7 == sum then
    self.mGoodsTable.mainIndex = 1
  elseif 5 == sum then
    self.mGoodsTable.mainIndex = 5
  else
    self.mGoodsTable.mainIndex = sum / 2
  end
  self.mIsCollected = false
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(852, 157), cc.rect(40, 40, 2, 2)):addTo(self)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mRecipeData.quality)):scale(0.8):align(display.CENTER_LEFT, 36, bg:getContentSize().height * 0.6):addTo(bg)
  local icon = display.newSprite(self.mCimeliaInfo.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  local pTip
  iconFrame:setTouchEnabled(true)
  iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      if not pTip then
        pTip = self:showIconTip()
        pTip:setPosition(display.cx, display.cy)
        pTip:addTo(display.getRunningScene(), 50)
      end
      return true
    elseif name == "moved" then
      pTip:show()
    elseif name == "ended" then
      pTip:removeSelf()
      pTip = nil
    end
  end)
  local textColor = DataUtils.getCimeliaNameColor(self.mRecipeData.quality)
  local lb = cc.ui.UILabel.new({
    text = self.mCimeliaInfo.name,
    size = 30,
    color = textColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, iconFrame:getContentSize().width * 0.5, -24):addTo(iconFrame)
  lb:enableOutline(cc.c4b(83, 54, 20, 255), 2)
  local images = {
    "cimelia/icon_fire.png",
    "cimelia/icon_gold.png",
    "cimelia/icon_wood.png",
    "cimelia/icon_earth.png",
    "cimelia/icon_water.png"
  }
  for i = 1, 3 do
    local goodInfo = self.mGoodsTable[i]
    local image = display.newSprite(images[goodInfo.index]):scale(0.5):align(display.CENTER_LEFT, bg:getContentSize().width * (0.05 + 0.15 * i), iconFrame:getPositionY()):addTo(bg)
    DYLabelTTF.new({
      text = goodInfo.cost,
      size = 30,
      color = display.COLOR_GREEN,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(image:getPositionX() + image:getContentSize().width * 0.55, image:getPositionY()):addTo(bg)
  end
  cc.ui.UILabel.new({
    text = DYLang.getString("S368", "") .. self.mRecipeData.nick,
    size = 20,
    color = cc.c3b(65, 36, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.2, bg:getContentSize().height * 0.18):addTo(bg)
  local date = os.date("*t", math.floor(self.mRecipeData.time / 1000))
  local str = string.format(DYLang.getString("S369", ""), date.year, date.month, date.day)
  cc.ui.UILabel.new({
    text = str,
    size = 20,
    color = cc.c3b(65, 36, 11),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.6, bg:getContentSize().height * 0.18):addTo(bg)
  self.collectBtn = display.newSprite("cimelia/collect.png"):pos(605, iconFrame:getPositionY()):addTo(bg)
  self.collectBtn:setTouchEnabled(true)
  self.collectBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name = event.name
    if name == "began" then
      self:collectCallback()
      return true
    end
  end)
  for i = 1, #GameManager.RECIPE_COLLECTED do
    if self.mRecipeData.id == GameManager.RECIPE_COLLECTED[i].id then
      self.mIsCollected = true
    end
  end
  if self.mIsCollected then
    self.collectBtn:setTexture("cimelia/collect1.png")
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, 750, iconFrame:getPositionY()):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S370", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    if self.mCallback then
      self.mCallback(self.mGoodsTable)
    end
  end):addTo(bg)
end

function M:collectCallback()
  DYSoundMgr.playEffect(DY_SND.sfx_treasure_falling)
  if self.mIsCollected then
    self.mIsCollected = false
    self.collectBtn:setTexture("cimelia/collect.png")
    for i = 1, #GameManager.RECIPE_COLLECTED do
      if self.mRecipeData.id == GameManager.RECIPE_COLLECTED[i].id then
        table.remove(GameManager.RECIPE_COLLECTED, i)
        break
      end
    end
  else
    self.mIsCollected = true
    self.collectBtn:setTexture("cimelia/collect1.png")
    table.insert(GameManager.RECIPE_COLLECTED, self.mRecipeData)
  end
  dump(GameManager.RECIPE_COLLECTED, "GameManager.RECIPE_COLLECTED : ")
end

function M:showIconTip()
  local bg = display.newSprite("cimelia/tip.png")
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mRecipeData.quality)):align(display.CENTER, 90, bg:getContentSize().height * 0.72):addTo(bg)
  local icon = display.newSprite(self.mCimeliaInfo.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  local textColor = DataUtils.getCimeliaNameColor(self.mRecipeData.quality)
  local lb = cc.ui.UILabel.new({
    text = self.mCimeliaInfo.name,
    size = 30,
    color = textColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, iconFrame:getPositionX(), iconFrame:getPositionY() - 85):addTo(bg)
  lb:enableOutline(cc.c4b(83, 54, 20, 255), 2)
  DYLabelTTF.new({
    text = "LV.1",
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }):pos(iconFrame:getContentSize().width - 10, 20):addTo(iconFrame)
  for i = 1, #self.mCimeliaInfo.proType do
    local proType = tonumber(self.mCimeliaInfo.proType[i])
    if 0 == proType then
      iconFrame:setPosition(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.48)
      lb:setPosition(iconFrame:getPositionX(), iconFrame:getPositionY() - 85)
      return bg
    end
    local typeLabel = display.newSprite(string.format("cimelia/type%d.png", proType)):align(display.CENTER_LEFT, bg:getContentSize().width * 0.45, bg:getContentSize().height * (1 - 0.12 * i)):addTo(bg)
    local numLabel = DYLabelTTF.new({
      text = "",
      size = 24,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(bg:getContentSize().width * 0.78, typeLabel:getPositionY()):addTo(bg)
    if 5 == proType then
      numLabel:setString(self.mCimeliaInfo.proNum[i])
    elseif 6 == proType and -1 == tonumber(self.mCimeliaInfo.proBaseNum[i]) then
      numLabel:setString(DYLang.getString("S373", ""))
    elseif 7 == proType then
      numLabel:setString(self.mCimeliaInfo.proNum[i] .. "%")
    elseif 8 == proType then
      numLabel:setString(self.mCimeliaInfo.proNum[i] .. "%")
    else
      numLabel:setString(self.mCimeliaInfo.proNum[i])
    end
  end
  local skillName = DYLabelTTF.new({
    text = self.mCimeliaInfo.skillName .. "\239\188\154",
    size = 30,
    color = cc.c3b(235, 255, 12),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(30, bg:getContentSize().height * 0.25):addTo(bg)
  local skillDesc = DYLabelTTF.new({
    text = self.mCimeliaInfo.skillDesc,
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(390, 70),
    dyalign = "TOP_LEFT"
  }):pos(30, bg:getContentSize().height * 0.2):addTo(bg)
  return bg
end

return M

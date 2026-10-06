local IconCimeliaRecipe = require("app.cimelia.icons.IconCimeliaRecipe")
local CLASS_NAME = "LayerCimeliaRecipe"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.TYPE_ATK = 1
M.TYPE_DEF = 2

function M:ctor(handler_)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  local bg = display.newSprite("cimelia/bg_recipe.png", 40, 0):addTo(self.mNode)
  self.mBg = bg
  self.mCallback = handler_
  self:initData()
end

local function getRecipeList(tb)
  local tb1 = {
    {},
    {},
    {}
  }
  if not tb then
    return tb1
  end
  table.sort(tb, function(v1, v2)
    return v1.time > v2.time
  end)
  for i = 1, #tb do
    local pModel = tb[i]
    table.insert(tb1[1], pModel)
    if 1 == pModel.type then
      table.insert(tb1[2], pModel)
    elseif 2 == pModel.type then
      table.insert(tb1[3], pModel)
    end
  end
  return tb1
end

function M:initData()
  local function tFuncListener(jsonTable)
    if not self or self.__cname ~= CLASS_NAME then
      return
    end
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    local tb = {}
    for k, v in pairs(jsonTable.data) do
      table.insert(tb, v)
    end
    self.mRecipeList = getRecipeList(tb)
    GameManager.RECIPE_COLLECTED = DYFavMgr.load(DY_KEY.kRecipeFavorite)
    self.mTabBtnTable = {}
    self:initUI()
  end
  
  DYHttpMgr.cimeliaRecipe(tFuncListener)
end

function M:initUI()
  self:initTabBtn()
  self:initRecipeList(self.mRecipeList[1])
  self.mCollectBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S587", ""),
    size = 30,
    color = cc.c3b(255, 248, 11),
    font = GameManager.FONTNAME_TTF
  }, {})):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.05):onButtonClicked(function()
    self:collectCallback()
  end):addTo(self.mBg)
  self.mRecipeBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):hide():setButtonLabel("normal", DYLabelTTF.new({
    text = "     \233\133\141\230\150\185",
    size = 30,
    color = cc.c3b(255, 248, 11),
    font = GameManager.FONTNAME_TTF
  }, {})):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.05):onButtonClicked(function()
    self:recipeCallback()
  end):addTo(self.mBg)
  display.newSprite("cimelia/recipe_pic1.png", -42, 3):addTo(self.mRecipeBtn)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.97, self.mBg:getContentSize().height * 0.95):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mBg)
end

function M:initTabBtn()
  local M_TAB_BTN = {
    {
      normal = "cimelia/tab_a.png",
      pressed = "cimelia/tab_a.png",
      disabled = "cimelia/tab_a_h.png"
    },
    {
      normal = "cimelia/tab_wand1.png",
      pressed = "cimelia/tab_wand1.png",
      disabled = "cimelia/tab_wand2.png"
    },
    {
      normal = "cimelia/tab_tower1.png",
      pressed = "cimelia/tab_tower1.png",
      disabled = "cimelia/tab_tower2.png"
    }
  }
  for i = 1, #M_TAB_BTN do
    local btn = cc.ui.UIPushButton.new(M_TAB_BTN[i]):onButtonClicked(function()
      self:funcChange(i)
    end):align(display.CENTER_RIGHT, 72, self.mBg:getContentSize().height * (0.9 - i * 0.12)):addTo(self.mBg)
    if 1 == i then
      btn:setButtonEnabled(false)
    end
    table.insert(self.mTabBtnTable, btn)
  end
end

function M:initRecipeList(tb)
  if 0 == #tb then
    return
  end
  self.mListView = cc.ui.UIListView.new({
    async = true,
    viewRect = cc.rect(75, 105, 855, 540),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(self.mBg)
  
  local function tFuncDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
      return #tb
    else
      if cc.ui.UIListView.CELL_TAG == tag then
        local item = self.mListView:dequeueItem()
        local content
        if not item then
          item = self.mListView:newItem()
        else
          content = item:getContent()
          content:removeFromParent()
        end
        content = IconCimeliaRecipe.new(tb[idx], handler(self, self.useRecipe))
        item:addContent(content)
        item:setItemSize(855, 165)
        return item
      else
      end
    end
  end
  
  self.mListView:setDelegate(tFuncDelegate)
  self.mListView:reload()
end

function M:funcChange(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mTag = index
  for i = 1, #self.mTabBtnTable do
    local tabBtn = self.mTabBtnTable[i]
    if index == i then
      tabBtn:setButtonEnabled(false)
    else
      tabBtn:setButtonEnabled(true)
    end
  end
  if self.mListView then
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
  end
  self:initRecipeList(self.mRecipeList[index])
  if 2 == index then
  elseif 3 == index then
  end
end

function M:useRecipe(recipeData)
  if self.mCallback then
    self.mCallback(recipeData)
  end
  self:closeCallBack()
end

function M:collectCallback()
  self.mCollectBtn:hide()
  self.mRecipeBtn:show()
  DYFavMgr.save(GameManager.RECIPE_COLLECTED)
  GameManager.RECIPE_COLLECTED = DYFavMgr.load(DY_KEY.kRecipeFavorite)
  local tb = DYFavMgr.load(DY_KEY.kRecipeFavorite)
  self.mRecipeList = getRecipeList(tb)
  self:funcChange(1)
end

function M:recipeCallback()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    local tb = {}
    for k, v in pairs(jsonTable.data) do
      table.insert(tb, v)
    end
    self.mCollectBtn:show()
    self.mRecipeBtn:hide()
    DYFavMgr.save(GameManager.RECIPE_COLLECTED)
    GameManager.RECIPE_COLLECTED = DYFavMgr.load(DY_KEY.kRecipeFavorite)
    self.mRecipeList = getRecipeList(tb)
    self:funcChange(1)
  end
  
  DYHttpMgr.cimeliaRecipe(tFuncListener)
end

function M:touchListener(event)
  if "clicked" == event.name then
    local idx = event.itemPos
    DDLOG("idx : %d", idx)
  elseif "moved" == event.name then
  elseif "ended" == event.name then
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  DYFavMgr.save(GameManager.RECIPE_COLLECTED)
  GameManager.RECIPE_COLLECTED = DYFavMgr.load(DY_KEY.kRecipeFavorite)
  self:removeSelf()
end

return M

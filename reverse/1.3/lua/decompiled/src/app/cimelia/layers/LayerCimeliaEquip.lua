local IconCimeliaEquip = require("app.cimelia.icons.IconCimeliaEquip")
local NoviceGuide = require("app.utils.NoviceGuide")
local CLASS_NAME = "LayerCimeliaEquip"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.TYPE_ATK = 1
M.TYPE_DEF = 2

function M:ctor(cimeliaType, handler_)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mCallback = handler_
  self:initData(cimeliaType)
  self:initUI()
  self:dealUserProgress()
end

function M:initData(cimeliaType)
  self.mCimeliaTable = {}
  for k, v in pairs(CloudData.CIMELIA_LIST) do
    if v.id ~= CloudData.CIMELIA_EQUIPED[1] and v.id ~= CloudData.CIMELIA_EQUIPED[2] then
      local cimeliaModel = DataUtils.getCimeliaBaseInfo(v.id)
      if cimeliaType == cimeliaModel.type then
        table.insert(self.mCimeliaTable, cimeliaModel)
      end
    end
  end
  
  local function tFuncComp(ta, tb)
    if ta.quality < tb.quality then
      return false
    elseif ta.quality == tb.quality and ta.stage <= tb.stage then
      return false
    end
    return true
  end
  
  table.sort(self.mCimeliaTable, tFuncComp)
  self.mType = cimeliaType
end

function M:initUI()
  local bg = display.newSprite("cimelia/bg_equip.png"):addTo(self.mNode)
  self.mBg = bg
  self:initCimeliaList()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.96, bg:getContentSize().height * 0.96):onButtonClicked(function()
    DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
    self.mCallback()
    self:closeCallBack()
  end):addTo(bg, 2)
end

function M:initCimeliaList()
  local countNum = #self.mCimeliaTable
  if 0 == countNum then
    return
  end
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(50, 80, 800, 510),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.onEventTouchList)):addTo(self.mBg)
  local idx = 1
  local row = countNum
  local rowInView = 4
  
  local function tFuncAddItem()
    while idx <= row do
      local item = listView:newItem()
      item:setItemSize(790, 170)
      listView:addItem(item)
      if idx <= rowInView then
        self:onEventDisplayItem(item, idx, true)
      else
        self:onEventDisplayItem(item, idx, false)
      end
      idx = idx + 1
    end
    listView:reload()
  end
  
  self:performWithDelay(tFuncAddItem, 0)
  self.mListView = listView
end

function M:equipCallback(ucid)
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    if self.mCallback then
      DYSoundMgr.playEffect(DY_SND.sfx_buddha_makeup)
      if self.mType == 1 then
      elseif self.mType == 1 then
      end
      self.mCallback(ucid)
      self:closeCallBack()
    end
  end
  
  local params = {}
  params.ucid = ucid
  DYHttpMgr.cimeliaEquip(tFuncListener, params)
end

function M:onEventDisplayItem(item, idx, flag)
  if flag then
    if not item.isValid then
      item:removeAllChildren()
      local content = display.newNode()
      content:setContentSize(790, 170)
      IconCimeliaEquip.new(self.mCimeliaTable[idx], handler(self, self.equipCallback)):addTo(content):pos(395, 85)
      item:addContent(content)
      item.isValid = true
    end
  elseif item.isValid or item.isValid == nil then
    item:removeAllChildren()
    local content = display.newNode()
    content:setContentSize(790, 170)
    item:addContent(content)
    item.isValid = false
  end
end

function M:onEventTouchList(event)
  if event.name == "itemAppearChange" then
    self:onEventDisplayItem(event.item, event.itemPos, true)
  elseif event.name == "itemDisappear" then
    self:onEventDisplayItem(event.item, event.itemPos, false)
  end
end

function M:closeCallBack()
  self:runAction(cc.RemoveSelf:create())
end

function M:dealUserProgress()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
end

return M

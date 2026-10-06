local IconRewardPerBoss = require("app.activity.place.IconRewardPerBoss")
local IconRewardSeason = require("app.activity.place.IconRewardSeason")
local DYClass = "LayerPVPOlRankAward"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
M.SINGLE = 1
M.HONOR = 2
M.RANK = 3
local ACT_TYPE = ""

function M:ctor(index, actType)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mBg = nil
  self.mTabList = {}
  self.mIndex = tonumber(index) or M.HONOR
  ACT_TYPE = actType
  self:initUI()
  self:changeTab(self.mIndex)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function M_createServerSumHarm(sumHarm)
  local node = display.newNode()
  local bg = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(800, 85), cc.rect(30, 30, 1, 1)):addTo(node)
  local pic = display.newSprite(string.format("new_year/place/sum_harm_%s.png", ACT_TYPE)):align(display.LEFT_CENTER, 20, 45):addTo(bg)
  node.mLabel = DYLabelTTF.new({
    text = "" .. sumHarm,
    size = 28,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.LEFT_CENTER, pic:getContentSize().width + 120, 20):addTo(pic)
  return node
end

function M:initUI()
  local bg = display.newSprite("task/bg.png", 30, 0):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, self.mBg:getContentSize().width, self.mBg:getContentSize().height):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mBg, 1)
  display.newScale9Sprite("common_ui/common_frame11.png", 500, 355, cc.size(839, 517), cc.rect(50, 50, 2, 2)):addTo(self.mBg)
  local titleBg = display.newSprite("common_ui/title_frame.png", 500, 660):addTo(bg)
  display.newSprite("new_year/place/pre_reward.png", 217, 49):addTo(titleBg)
  self:initTabList()
end

function M:initTabList()
  local info = {
    [M.SINGLE] = {
      img = "rewardBtn_1"
    },
    [M.HONOR] = {
      img = "rewardBtn_2"
    }
  }
  for i = 1, #info do
    local btn = cc.ui.UIPushButton.new({
      normal = "new_year/place/" .. info[i].img .. "h.png",
      disabled = "new_year/place/" .. info[i].img .. ".png"
    }):onButtonClicked(function(event)
      self:changeTab(i)
    end):align(display.CENTER_RIGHT, 70, 660 - 103 * i):addTo(self.mBg)
    self.mTabList[i] = btn
  end
end

function M:changeTab(index)
  for i = 1, #self.mTabList do
    self.mTabList[i]:setButtonEnabled(true)
  end
  if self.mTabList[index] then
    self.mTabList[index]:setButtonEnabled(false)
  end
  self:showList(index)
end

local function newUniqueSum(data, key)
  local num = 0
  if not data or type(data) ~= "table" then
    return num
  end
  for i = 1, #data - 1 do
    local actualInfo = DYCommon.getDataByTag(DataRetainer.NIAN_ACTUAL_INFO, key, tostring(i))[1]
    if not actualInfo then
      return num
    else
      num = i
    end
  end
  return num
end

local function getAwardSum(index)
  if index == M.SINGLE then
    return #DataRetainer.NIAN_ACTUAL_INFO - 1
  elseif index == M.HONOR then
    local num = #DataRetainer.NIAN_HURT_INFO - 1
    return num
  elseif index == M.RANK then
    return #DataRetainer.NIAN_ACTUAL_INFO - 1
  end
  return 0
end

local function newAwardIcon(index, id, self)
  local content = display.newNode()
  if index == M.SINGLE then
    content = IconRewardPerBoss.new(id)
  elseif index == M.HONOR then
    content = IconRewardSeason.new(id, self.mNowHurt)
  end
  return content
end

function M:showList(index)
  if self.mList then
    self.mList:runAction(cc.RemoveSelf:create())
    self.mList = nil
  end
  local sum = getAwardSum(index)
  if sum == 0 then
    return
  end
  self.mBg:removeChildByTag(5418)
  local height = 500
  if index == M.HONOR then
    local function tFuncListener(jsonTable)
      self.mNowHurt = jsonTable.data
      
      M_createServerSumHarm(self.mNowHurt):pos(504, 560):addTo(self.mBg, 20, 5418)
      height = height - 90
      self.mList = cc.ui.UIListView.new({
        bgColor = cc.c4b(255, 255, 255, 20),
        viewRect = cc.rect(90, 105, 825, height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
      }):addTo(self.mBg, 2)
      local iconInfo = {}
      for i = 1, sum do
        local content = newAwardIcon(index, i, self)
        if content then
          local item = self.mList:newItem()
          item:addContent(content)
          item:setItemSize(800, 90)
          self.mList:addItem(item)
        end
      end
      self.mList:reload()
    end
    
    DYHttpMgr.requestTotalHurt(tFuncListener)
    return
  end
  self.mList = cc.ui.UIListView.new({
    bgColor = cc.c4b(255, 255, 255, 20),
    viewRect = cc.rect(90, 105, 825, height),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  local iconInfo = {}
  for i = 1, sum do
    local content = newAwardIcon(index, i, self)
    if content then
      local item = self.mList:newItem()
      item:addContent(content)
      item:setItemSize(800, 90)
      self.mList:addItem(item)
    end
  end
  self.mList:reload()
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
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

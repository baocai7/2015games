local IconRewardPerGame = require("app.pvponline.IconRewardPerGame")
local IconRewardSeasonHonor = require("app.pvponline.IconRewardSeasonHonor")
local IconRewardSeasonRank = require("app.pvponline.IconRewardSeasonRank")
local DYClass = "LayerPVPOlRankAward"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
M.SINGLE = 1
M.HONOR = 2
M.RANK = 3

function M:ctor(index)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mBg = nil
  self.mTabList = {}
  self.mIndex = tonumber(index) or M.SINGLE
  self:initUI()
  self:changeTab(self.mIndex)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
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
  display.newSprite("pvp_ol/title_rank.png", 217, 49):addTo(titleBg)
  self:initTabList()
end

function M:initTabList()
  local info = {
    [M.SINGLE] = {
      img = "tab_award_single"
    },
    [M.HONOR] = {
      img = "tab_award_honor"
    },
    [M.RANK] = {
      img = "tab_award_rank"
    }
  }
  for i = 1, #info do
    local btn = cc.ui.UIPushButton.new({
      normal = "pvp_ol/" .. info[i].img .. "1.png",
      disabled = "pvp_ol/" .. info[i].img .. ".png"
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
    local actualInfo = DYCommon.getDataByTag(DataRetainer.PVP_OL_FIGHT_AWARD, key, tostring(i))[1]
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
    return #DataRetainer.PVP_OL_FIGHT_AWARD - 1
  elseif index == M.HONOR then
    local num = newUniqueSum(DataRetainer.PVP_OL_FIGHT_AWARD, "grade")
    return num
  elseif index == M.RANK then
    return #DataRetainer.PVP_OL_ACTUAL_INFO - 1
  end
  return 0
end

local function newAwardIcon(index, id)
  local content = display.newNode()
  if index == M.SINGLE then
    content = IconRewardPerGame.new(id)
  elseif index == M.HONOR then
    content = IconRewardSeasonHonor.new(id)
    if content.tag then
      content = nil
    end
  elseif index == M.RANK then
    content = IconRewardSeasonRank.new(id)
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
  self.mList = cc.ui.UIListView.new({
    bgColor = cc.c4b(255, 255, 255, 20),
    viewRect = cc.rect(90, 105, 825, 500),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  local iconInfo = {}
  for i = 1, sum do
    local content = newAwardIcon(index, i)
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

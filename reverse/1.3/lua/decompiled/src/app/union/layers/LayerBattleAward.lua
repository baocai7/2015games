local IconBattleAward = require("app.union.icons.IconBattleAward")
local IconItem = import("icons.IconItem")
local CLASS_NAME = "LayerBattleAward"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.NORMAL = 1
M.ATTACK = 2

function M:ctor(index)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mBg = nil
  self.mBgImg = nil
  self.mTabList = {}
  self.mIndex = tonumber(index) or M.NORMAL
  self.mFileInfo = {}
  DYRes.loadFileInfo("animation/daochangxiangzi/daochangxiangzi.csb", self.mFileInfo)
  self:initBg()
  self:changeTab(self.mIndex)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initBg()
  local bg = display.newSprite("task/bg.png", 30, 0):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, self.mBg:getContentSize().width, self.mBg:getContentSize().height):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mBg, 1)
  local titleBg = display.newSprite("common_ui/title_frame.png", 500, 660):addTo(bg)
  display.newSprite("union/battle/award_title.png", 217, 49):addTo(titleBg)
  self:initTabList()
end

function M:initTabList()
  local info = {
    [M.NORMAL] = {
      img = "award_normal"
    },
    [M.ATTACK] = {
      img = "award_attack"
    }
  }
  for i = 1, #info do
    local btn = cc.ui.UIPushButton.new({
      normal = "union/battle/" .. info[i].img .. "1.png",
      disabled = "union/battle/" .. info[i].img .. ".png"
    }):onButtonClicked(function(event)
      DYSoundMgr.playEffect(DY_SND.sfx_touch)
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
    self.mIndex = index
  end
  self:showList()
end

local function getAwardInfo(index, id)
  local awardFile = DataRetainer.UNION_BATTLE_AWARD
  local awardInfo = DYCommon.getDataByTag(awardFile, "id", tostring(id))[1]
  if not awardInfo then
    DDERROR("union awardInfo id : %d with error data", tonumber(id))
    return
  end
  local info = {}
  info.id = checknumber(awardInfo.id)
  info.minNum = checknumber(awardInfo.min)
  info.maxNum = checknumber(awardInfo.max)
  info.itemIds = split(awardInfo.things, ";")
  info.itemNums = split(awardInfo.counts, ";")
  return info
end

function M:showList()
  if self.mBgImg then
    self.mBgImg:runAction(cc.RemoveSelf:create())
    self.mBgImg = nil
  end
  if self.mList then
    self.mList:runAction(cc.RemoveSelf:create())
    self.mList = nil
  end
  if self.mIndex == M.NORMAL then
    self.mBgImg = display.newSprite("union/battle/award_eg.png"):pos(500, 355):addTo(self.mBg)
    local armature = ccs.Armature:create("daochangxiangzi")
    armature:getAnimation():playWithIndex(0)
    self.mBgImg:addChild(armature, 1)
    armature:setPosition(417, 186)
    return
  end
  self.mBgImg = display.newScale9Sprite("common_ui/common_frame11.png", 500, 355, cc.size(839, 517), cc.rect(50, 50, 2, 2)):addTo(self.mBg)
  local frame = display.newSprite("union/battle/guard_item.png", 420, 464):addTo(self.mBgImg)
  display.newSprite("union/battle/guard_succ.png", 90, 45):addTo(frame)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = "+30",
    font = "fonts/greenNum.fnt"
  }):scale(0.65):align(display.CENTER_RIGHT, 263, 45):addTo(frame)
  IconItem.new(5012):scale(0.65):align(display.CENTER, 310, 45):addTo(frame)
  display.newSprite("union/battle/guard_fail.png", 486, 45):addTo(frame)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = "+15",
    font = "fonts/greenNum.fnt"
  }):scale(0.65):align(display.CENTER_RIGHT, 658, 45):addTo(frame)
  IconItem.new(5012):scale(0.65):align(display.CENTER, 705, 45):addTo(frame)
  self.mList = cc.ui.UIListView.new({
    viewRect = cc.rect(90, 105, 825, 410),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  local sum = #DataRetainer.UNION_BATTLE_AWARD - 1
  for i = 1, sum do
    local info = getAwardInfo(self.mIndex, i)
    if info then
      local content = IconBattleAward.new(info)
      if content then
        local item = self.mList:newItem()
        item:addContent(content)
        item:setItemSize(800, 90)
        self.mList:addItem(item)
      end
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYRes.unloadFileInfo(self.mFileInfo)
end

return M

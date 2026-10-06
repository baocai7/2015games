local IconRankAttack = require("app.union.icons.IconRankAttack")
local IconRankGuard = require("app.union.icons.IconRankGuard")
local IconBattleLog = require("app.union.icons.IconBattleLog")
local CLASS_NAME = "LayerWarSituation"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.MYLOG = 1
M.LOG = 2
M.ATTACK = 3
M.GUARD = 4
M.ATTACKTER = 1
M.DEFENCER = 2

function M:ctor(tag, index)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mIndex = tonumber(index) or M.MYLOG
  self.mLogHeight = 0
  self.mBattleLog = {}
  self.mMyBattleLog = {}
  self.mAttackInfo = {}
  self.mGuardInfo = {}
  self.mIsAttack = tag or M.ATTACKTER
  self.mBg = nil
  self.mMyRank = nil
  self.mTabList = {}
  self:initBg()
  self:requestData()
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
  display.newSprite("union/battle/zhankuang.png", 217, 49):addTo(titleBg)
  display.newScale9Sprite("common_ui/common_frame11.png", 500, 355, cc.size(839, 517), cc.rect(50, 50, 2, 2)):addTo(self.mBg)
  self:initTabList()
end

function M:initTabList()
  local info = {
    [M.MYLOG] = {
      img = "my_situation"
    },
    [M.LOG] = {
      img = "rank_battle"
    },
    [M.ATTACK] = {
      img = "rank_attack"
    },
    [M.GUARD] = {img = "rank_guard"}
  }
  for i = 1, #info do
    local btn = cc.ui.UIPushButton.new({
      normal = "union/battle/" .. info[i].img .. "1.png",
      disabled = "union/battle/" .. info[i].img .. ".png"
    }):onButtonClicked(function(event)
      DYSoundMgr.playEffect(DY_SND.sfx_touch)
      self:changeTab(i)
    end):align(display.CENTER_RIGHT, 58, 660 - 103 * i):addTo(self.mBg)
    self.mTabList[i] = btn
  end
end

function M:requestData()
  local function tFunc(event)
    dump(event)
    
    if event.err_msg and event.err_msg ~= "" then
      WSToast.new(event.err_msg):addTo(self, 20)
    else
      self.mBattleLog = event.fight_log_list or {}
      self.mMyBattleLog = event.personal_log_list or {}
      self:logListener()
      self:changeTab(self.mIndex)
    end
  end
  
  self:safeSocketRequest("CMD_CLAN_LOG_LIST", nil, tFunc)
end

function M:changeTab(index)
  for i = 1, #self.mTabList do
    self.mTabList[i]:setButtonEnabled(true)
  end
  if self.mTabList[index] then
    self.mTabList[index]:setButtonEnabled(false)
    self.mIndex = index
  end
  if self.mMyRank then
    self.mMyRank:runAction(cc.RemoveSelf:create())
    self.mMyRank = nil
  end
  if self.mList then
    self.mList:runAction(cc.RemoveSelf:create())
    self.mList = nil
  end
  if index == M.LOG then
    self:showLog()
  elseif index == M.MYLOG then
    self:showMyLog()
  elseif index == M.ATTACK then
    self:toGetAttackRank()
  elseif index == M.GUARD then
    self:toGetGuardRank()
  end
end

function M:showMyLog()
  self.mList = cc.ui.UIListView.new({
    viewRect = cc.rect(90, 105, 825, 500),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  local height = 0
  for i = 1, #self.mMyBattleLog do
    local content = IconBattleLog.new(self.mMyBattleLog[i])
    if content then
      local size = content:getContentSize()
      local item = self.mList:newItem()
      item:addContent(content)
      item:setItemSize(800, size.height)
      self.mList:addItem(item)
      height = height + size.height
    end
  end
  self.mList:reload()
  if 500 < height then
    local moveByParams = {
      x = 0,
      y = height - 500,
      time = 0.2
    }
    for k, v in pairs(self.mList.items_) do
      transition.moveBy(v, moveByParams)
    end
  end
end

function M:showLog()
  self.mList = cc.ui.UIListView.new({
    viewRect = cc.rect(90, 105, 825, 500),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  self.mLogHeight = 0
  for i = 1, #self.mBattleLog do
    local content = IconBattleLog.new(self.mBattleLog[i])
    if content then
      local size = content:getContentSize()
      local item = self.mList:newItem()
      item:addContent(content)
      item:setItemSize(800, size.height)
      self.mList:addItem(item)
      self.mLogHeight = self.mLogHeight + size.height
    end
  end
  self.mList:reload()
  if 500 < self.mLogHeight then
    local moveByParams = {
      x = 0,
      y = self.mLogHeight - 500,
      time = 0.2
    }
    for k, v in pairs(self.mList.items_) do
      transition.moveBy(v, moveByParams)
    end
  end
end

function M:logListener()
  local function tFunc(event)
    dump(event)
    
    if event.err_msg and event.err_msg ~= "" then
      WSToast.new(event.err_msg):addTo(self, 20)
    else
      local info = event.log
      self:addLog(info)
    end
  end
  
  self:safeSocketListen("CMD_GET_CLAN_NEW_LOG", tFunc)
end

function M:addLog(info)
  if not info then
    return
  end
  table.insert(self.mBattleLog, info)
  if self.mIndex ~= M.LOG then
    return
  end
  local content = IconBattleLog.new(info)
  if not content then
    return
  end
  local height = content:getContentSize().height
  local item = self.mList:newItem()
  item:addContent(content)
  item:setItemSize(800, height)
  self.mList:addItem(item)
  self.mLogHeight = self.mLogHeight + height
  if #self.mBattleLog > 1 then
    local posY = self.mList.items_[#self.mBattleLog - 1]:getPositionY()
    item:setPosition(99, posY - height)
  else
    self.mList:reload()
  end
  if self.mLogHeight > 500 then
    local moveByParams = {
      x = 0,
      y = height,
      time = 0.2
    }
    for k, v in pairs(self.mList.items_) do
      transition.moveBy(v, moveByParams)
    end
  end
end

function M:toGetAttackRank()
  self.mAttackInfo = {}
  
  local function tFunc(event)
    dump(event)
    if event.err_msg and event.err_msg ~= "" then
      WSToast.new(event.err_msg):addTo(self, 20)
    else
      self.mAttackInfo = event.rank_list or {}
      self:showAttackRank()
    end
  end
  
  self:safeSocketRequest("CMD_CLAN_RANK_ATTACK", nil, tFunc)
end

function M:showAttackRank()
  local height = 500
  if self.mIsAttack == M.ATTACKTER then
    local myInfo = {index = 0}
    for i = 1, #self.mAttackInfo do
      local union = checkstring(self.mAttackInfo[i].clan_name)
      if union == checkstring(CloudData.UNION_INFO.name) then
        myInfo = self.mAttackInfo[i]
        myInfo.index = i
        break
      end
    end
    myInfo.tag = 1
    self.mMyRank = IconRankAttack.new(myInfo)
    self.mMyRank:setPosition(500, 540)
    self.mBg:addChild(self.mMyRank)
    height = 370
  end
  self.mList = cc.ui.UIListView.new({
    viewRect = cc.rect(90, 105, 825, height),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  for i = 1, #self.mAttackInfo do
    self.mAttackInfo[i].index = i
    self.mAttackInfo[i].tag = 0
    local content = IconRankAttack.new(self.mAttackInfo[i])
    if content then
      local item = self.mList:newItem()
      item:addContent(content)
      item:setItemSize(800, 135)
      self.mList:addItem(item)
    end
  end
  self.mList:reload()
end

function M:toGetGuardRank()
  self.mGuardInfo = {}
  
  local function tFunc(event)
    dump(event)
    if event.err_msg and event.err_msg ~= "" then
      WSToast.new(event.err_msg):addTo(self, 20)
    else
      self.mGuardInfo = event.rank_list or {}
      self:showGuardRank()
    end
  end
  
  self:safeSocketRequest("CMD_CLAN_RANK_GUARD", nil, tFunc)
end

function M:showGuardRank()
  local height = 500
  if self.mIsAttack == M.DEFENCER then
    local myInfo = {index = 0}
    for i = 1, #self.mGuardInfo do
      local union = checkstring(self.mGuardInfo[i].clan_name)
      if union == checkstring(CloudData.UNION_INFO.name) then
        myInfo = self.mGuardInfo[i]
        myInfo.index = i
        break
      end
    end
    myInfo.tag = 1
    self.mMyRank = IconRankGuard.new(myInfo)
    self.mMyRank:setPosition(500, 540)
    self.mBg:addChild(self.mMyRank)
    height = 370
  end
  self.mList = cc.ui.UIListView.new({
    viewRect = cc.rect(90, 105, 825, height),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  for i = 1, #self.mGuardInfo do
    self.mGuardInfo[i].index = i
    self.mGuardInfo[i].tag = 0
    local content = IconRankGuard.new(self.mGuardInfo[i])
    if content then
      local item = self.mList:newItem()
      item:addContent(content)
      item:setItemSize(800, 135)
      self.mList:addItem(item)
    end
  end
  self.mList:reload()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:safeSocketRequest("CMD_LEAVE_LOG_PANEL")
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
end

return M

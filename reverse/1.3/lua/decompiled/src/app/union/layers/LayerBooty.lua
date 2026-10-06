local IconBooty = require("app.union.icons.IconBooty")
local LayerTip = require("app.union.layers.LayerTip")
local LayerBoxDistribute = require("app.union.layers.LayerBoxDistribute")
local CLASS_NAME = "LayerBooty"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mBoxSum = 0
  self.mBoxNum = 0
  self.mPlayerInfo = {}
  self.mDistributed = false
  self.mIsMaster = false
  if CloudData.UNION_POS == 3 then
    self.mIsMaster = true
  end
  self.mBg = nil
  self.mBoxLabel = nil
  self.mPlayerIcons = {}
  self.mResetBtn = nil
  self.mConfirmBtn = nil
  self:initData()
  self:initBg()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  dump(CloudData.MY_CLAN_RANK)
  local info = CloudData.MY_CLAN_RANK or {}
  self.mPlayerInfo = clone(info.rank_list) or {}
  self.mDistributed = info.is_allocate
  if self.mDistributed then
    self.mBoxSum = 0
  else
    self.mBoxSum = checknumber(info.total_box)
  end
  self.mBoxNum = self.mBoxSum
end

function M:initBg()
  local bg = display.newSprite("task/bg.png", 30, 0):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, self.mBg:getContentSize().width, self.mBg:getContentSize().height):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg, 1)
  local titleBg = display.newSprite("common_ui/title_frame.png", 500, 660):addTo(bg)
  display.newSprite("union/battle/title_booty.png", 217, 49):addTo(titleBg)
  display.newSprite("union/battle/zhanlipin.png", 831, 478):addTo(bg)
  cc.ui.UILabel.new({
    text = DYLang.getString("S1619", ""),
    color = cc.c3b(89, 62, 10),
    size = 25,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_RIGHT, 829, 393):addTo(bg)
  self.mBoxLabel = DYLabelTTF.new({
    text = "X" .. self.mBoxNum,
    size = 25,
    color = cc.c3b(32, 254, 32),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):pos(833, 393):addTo(bg)
  self:addButton()
  self:initList()
end

function M:addButton()
  self.mResetBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }):align(display.CENTER, 831, 305):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1620", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1620", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:reset()
  end):addTo(self.mBg)
  self.mConfirmBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }):align(display.CENTER, 831, 179):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1622", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1622", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:clickConfirm()
  end):addTo(self.mBg)
  if self.mDistributed then
    self.mResetBtn:performWithDelay(function()
      self.mResetBtn:setButtonEnabled(false)
      self.mConfirmBtn:setButtonEnabled(false)
    end, 0)
  end
end

function M:initList()
  display.newScale9Sprite("common_ui/common_frame11.png", 407, 350, cc.size(650, 505), cc.rect(50, 50, 2, 2)):addTo(self.mBg)
  local list = cc.ui.UIListView.new({
    bgColor = cc.c4b(255, 255, 255, 20),
    viewRect = cc.rect(83, 115, 645, 480),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 1)
  for i = 1, #self.mPlayerInfo do
    local params = {
      index = i,
      cb = handler(self, self.toDistribute),
      info = self.mPlayerInfo[i]
    }
    local content = IconBooty.new(params)
    if content then
      local item = list:newItem()
      item:addContent(content)
      item:setItemSize(640, 134)
      list:addItem(item)
      self.mPlayerIcons[i] = content
    end
  end
  list:reload()
end

function M:toDistribute(index)
  if self.mDistributed then
    return
  elseif not self.mIsMaster then
    WSToast.new(DYLang.getString("S1624", "")):addTo(self, 20)
    return
  end
  local no = checknumber(index)
  local params = {
    index = no,
    info = self.mPlayerInfo[no],
    num = self.mBoxNum,
    cb = handler(self, self.distributeCallback)
  }
  LayerBoxDistribute.new(params):addTo(self, 20)
end

function M:distributeCallback(params)
  local index = checknumber(params.index)
  local num = checknumber(params.num)
  local icon = self.mPlayerIcons[index]
  if not icon then
    return
  end
  local originNum = self.mPlayerInfo[index].box_count
  self.mBoxNum = self.mBoxNum + originNum - num
  self.mBoxLabel:setString("X" .. self.mBoxNum)
  self.mPlayerInfo[index].box_count = num
  icon:updateBoxNum(num)
end

function M:reset()
  if self.mDistributed or self.mBoxSum == 0 then
    return
  elseif not self.mIsMaster then
    WSToast.new(DYLang.getString("S1624", "")):addTo(self, 20)
    return
  end
  self.mBoxNum = self.mBoxSum
  self.mBoxLabel:setString("X" .. self.mBoxNum)
  for i = 1, #self.mPlayerInfo do
    self.mPlayerInfo[i].box_count = 0
    if self.mPlayerIcons[i] then
      self.mPlayerIcons[i]:updateBoxNum(0)
    end
  end
end

function M:clickConfirm()
  if self.mDistributed or self.mBoxSum == 0 then
    return
  elseif not self.mIsMaster then
    WSToast.new(DYLang.getString("S1624", "")):addTo(self, 20)
    return
  elseif 0 < self.mBoxNum then
    LayerTip.new(DYLang.getString("S1627", "")):addTo(self, 20)
  else
    LayerTip.new(DYLang.getString("S1628", ""), handler(self, self.toConfirm)):addTo(self, 20)
  end
end

function M:toConfirm()
  local function tFunc(event)
    dump(event)
    
    if checknumber(event.ret_code) ~= 0 then
      WSToast.new(checkstring(event.err_msg)):addTo(self, 20)
    else
      CloudData.MY_CLAN_RANK.is_allocate = true
      self.mDistributed = true
      CloudData.MY_CLAN_RANK.total_box = 0
      for i = 1, #CloudData.MY_CLAN_RANK.rank_list do
        CloudData.MY_CLAN_RANK.rank_list[i].box_count = self.mPlayerInfo[i] and self.mPlayerInfo[i].box_count
      end
      WSToast.new(DYLang.getString("S1629", "")):addTo(display.getRunningScene(), 20)
      self:closeCallBack()
    end
  end
  
  local params = {
    box_list = {}
  }
  for i = 1, #self.mPlayerInfo do
    params.box_list[i] = checknumber(self.mPlayerInfo[i].box_count)
  end
  self:safeSocketRequest("CMD_CLAN_ALLOCATE_BOX", params, tFunc)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mBoxNum > 0 and self.mIsMaster then
    local function func()
      self:runAction(cc.RemoveSelf:create())
    end
    
    LayerTip.new(DYLang.getString("S1630", ""), handler(self, func)):addTo(self, 20)
  else
    self:runAction(cc.RemoveSelf:create())
  end
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

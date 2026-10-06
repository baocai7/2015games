local IconItem = require("app.icons.IconItem")
local CLASS_NAME = "LayerChallengeBabel"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(index)
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mFloor = checknumber(index)
  self.mStageId = 0
  self.mFloorName = ""
  self.mName = ""
  self.mRecommendLv = 0
  self.mRewardIdInfo = {}
  self.mRewardNumInfo = {}
  self:initData()
  self:initBg()
  self:setNodeEventEnabled(true)
end

function M:initData()
  local info = DataUtils.getStageModel(7, self.mFloor)
  if not info then
    self:closeCallBack()
  end
  self.mStageId = info.stageId
  self.mFloorName = info.desc
  self.mName = info.name
  self.mRewardIdInfo = info.awardIdList
  self.mRewardNumInfo = info.awardNumList
  self.mRecommendLv = info.recommendLv
end

function M:initBg()
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, bg:getContentSize().width + 20, bg:getContentSize().height + 20):addTo(bg):onButtonClicked(function()
    self:closeCallBack()
  end)
  self:addContent()
  self:addReward()
  self:addButton()
end

function M:addContent()
  display.newSprite("babel/adorn.png"):align(display.CENTER_RIGHT, 130, 345):addTo(self.mBg)
  local adorn = display.newSprite("babel/adorn.png"):align(display.CENTER_RIGHT, 468, 345):addTo(self.mBg)
  adorn:setScaleX(-1)
  local str = DYLang.getString("S107", "") .. self.mFloorName .. "\194\183" .. self.mName
  DYLabelTTF.new({
    text = str,
    size = 25,
    color = cc.c3b(255, 192, 0),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, 299, 345):addTo(self.mBg)
  cc.ui.UILabel.new({
    text = DYLang.getString("S108", "") .. self.mFloorName,
    size = 22,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 299, 290):addTo(self.mBg)
  local lab1 = cc.ui.UILabel.new({
    text = DYLang.getString("S109", ""),
    size = 25,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 190, 113):addTo(self.mBg)
  local lab2 = DYLabelTTF.new({
    text = self.mRecommendLv,
    size = 23,
    color = cc.c3b(0, 255, 6),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):pos(lab1:getPositionX() + lab1:getContentSize().width + 5, lab1:getPositionY()):addTo(self.mBg)
  cc.ui.UILabel.new({
    text = DYLang.getString("S110", ""),
    size = 25,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, lab2:getPositionX() + lab2:getContentSize().width + 5, lab2:getPositionY()):addTo(self.mBg)
end

function M:addReward()
  display.newSprite("babel/profit_win.png"):align(display.CENTER_LEFT, 40, 290):addTo(self.mBg)
  if not self.mRewardIdInfo or #self.mRewardIdInfo == 0 then
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(45, 143, 505, 130),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(self.mBg)
  for i = 1, #self.mRewardIdInfo do
    local item = list:newItem()
    local content = IconItem.new(checknumber(self.mRewardIdInfo[i]), checknumber(self.mRewardNumInfo[i]))
    content:showItemTip()
    item:addContent(content)
    item:setItemSize(155, 130)
    list:addItem(item)
  end
  list:reload()
end

function M:addButton()
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):scale(0.8):align(display.CENTER, 175, 57):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S111", ""),
    size = 32,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:confirm()
  end)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):scale(0.8):align(display.CENTER, 418, 57):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S112", ""),
    size = 32,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallBack()
  end)
end

function M:confirm()
  local function tFuncListener(jsonTable)
    local pData = jsonTable.data
    
    CloudData.PVE_ATK_CIMELIA_DATA = pData.attackCimelia
    CloudData.PVE_DEF_CIMELIA_DATA = pData.defenceCimelia
    for k, info in pairs(pData.teamList) do
      local npcId = info.id or 0
      CloudData.NPC_INFO[tonumber(npcId)] = info
    end
    GameManager.STAGE_ID = self.mStageId
    GameManager.STAGE_NUM = self.mFloor
    GameManager.MODE = 7
    display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE", "BABEL"))
  end
  
  DYHttpMgr.getFightData(tFuncListener, {fightMode = 0})
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
end

return M

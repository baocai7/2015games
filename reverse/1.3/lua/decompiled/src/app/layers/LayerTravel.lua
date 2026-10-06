local WSToast = require("app.utils.WSToast")
local IconItem = require("app.icons.IconItem")
ACTIVITY_TYPE_ODD = 1
ACTIVITY_TYPE_EVEN = 2
ACTIVITY_TYPE_SUNDAY = 3
local CLASS_NAME = "LayerTravel"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(activityType, times)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mMode = activityType
  self.mTimes = times
  self.mInfoTable = {
    {icon = "normal"},
    {icon = "hard"},
    {icon = "awful"},
    {icon = "terrible"}
  }
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mask = display.newColorLayer(cc.c4b(0, 0, 0, 175))
  self:addChild(self.mask, -1)
  self.mNode = display.newNode()
  self.mNode:setPosition(display.cx, display.cy)
  self:addChild(self.mNode)
  self.mNode:setScale(0)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  local stageInfo = DYCommon.getDataByTag(DataRetainer.TRAVEL_STAGE_INFO, "type", tostring(self.mMode))
  if not stageInfo then
    DDERROR("travel_stage type : %d with error data", tonumber(self.mMode))
    self:removeSelf()
    return
  end
  for i = 1, #stageInfo do
    local index = tonumber(stageInfo[i].degree)
    local idTable = {}
    local ids = split(stageInfo[i].awardIdList, ";")
    for i = 1, #ids do
      idTable[i] = tonumber(ids[i])
    end
    self.mInfoTable[index].stageId = tonumber(stageInfo[i].id)
    self.mInfoTable[index].requireLv = tonumber(stageInfo[i].requireLv)
    self.mInfoTable[index].idTable = idTable
  end
  self:initUI()
end

function M:initUI()
  local bg = display.newScale9Sprite("travel/dialog.png", 0, 0, cc.size(1065, 490), cc.rect(410, 0, 2, 0))
  self.mNode:addChild(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, bg:getContentSize().width + 10, bg:getContentSize().height + 15):addTo(bg):onButtonClicked(function()
    self:closeCallBack()
  end)
  local timeStr = display.newSprite("stage/time_str.png"):align(display.CENTER, bg:getContentSize().width * 0.48, bg:getContentSize().height * 0.94):addTo(bg)
  local timeLabel = cc.ui.UILabel.new({
    text = self.mTimes,
    size = 25,
    color = cc.c3b(0, 251, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, timeStr:getContentSize().width + 15, timeStr:getContentSize().height * 0.5):addTo(timeStr)
  timeLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  for i = 1, #self.mInfoTable do
    local frame = cc.ui.UIPushButton.new("travel/" .. self.mInfoTable[i].icon .. ".png"):pos(242 * i - 70, bg:getContentSize().height * 0.48):addTo(bg)
    if CloudData.USER_LEVEL < self.mInfoTable[i].requireLv then
      local mask = display.newSprite("travel/mask.png"):pos(0, 0):addTo(frame, 1)
      mask:setTouchSwallowEnabled(true)
      mask:setTouchEnabled(true)
      local level_str = cc.ui.UILabel.new({
        text = self.mInfoTable[i].requireLv,
        size = 35,
        color = cc.c3b(255, 2, 2),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER_RIGHT, mask:getContentSize().width * 0.3, mask:getContentSize().height * 0.32):addTo(mask)
      level_str:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    end
    local fightLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = DYLang.getString("S974", ""),
      size = 26,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    })
    fightLabel:enableOutline(cc.c4b(147, 78, 1, 255), 2)
    local fightBtn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png"
    }, {scale9 = true}):setButtonSize(135, 61):scale(0.9):pos(0, -140):addTo(frame):setButtonLabel("normal", fightLabel):onButtonClicked(function()
      self:selectMode(i)
    end)
    local awardInfo = self.mInfoTable[i].idTable
    for j = 1, 2 do
      local icon
      if awardInfo[j] then
        icon = IconItem.new(awardInfo[j])
        icon:showItemTip()
      else
        icon = display.newSprite("common_ui/frame_battle.png")
      end
      icon:setPosition(j * 90 - 135, -65)
      icon:setScale(0.6)
      frame:addChild(icon)
    end
  end
end

function M:selectMode(mode)
  local requireLv = self.mInfoTable[mode].requireLv
  if requireLv > CloudData.USER_LEVEL then
    return
  elseif self.mTimes <= 0 then
    local t = WSToast.new(DYLang.getString("S976", ""), 1)
    self:addChild(t, 20)
  else
    local function tFuncListener(jsonTable)
      local pData = jsonTable.data
      
      CloudData.PVE_ATK_CIMELIA_DATA = pData.attackCimelia
      CloudData.PVE_DEF_CIMELIA_DATA = pData.defenceCimelia
      for k, info in pairs(pData.teamList) do
        local npcId = info.id or 0
        CloudData.NPC_INFO[tonumber(npcId)] = info
      end
      GameManager.STAGE_ID = self.mInfoTable[mode].stageId
      GameManager.STAGE_NUM = self.mInfoTable[mode].stageId or 0
      GameManager.MODE = 4
      display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE"))
    end
    
    DYHttpMgr.getFightData(tFuncListener, {fightMode = 0})
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.mNode:runAction(popupLayer)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:removeSelf()
  end
  return true
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

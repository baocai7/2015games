local CLASS_NAME = "LayerDungeon"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mTag = CLASS_NAME
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self.mBabelBtn = nil
  self.mLogId = 0
  self:initUI()
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  local function tFuncListener(info)
    if info.errorCode ~= 0 then
      local msg = info.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      if not (self and self.mTag) or self.mTag ~= CLASS_NAME or not info.data then
        return
      end
      self:addBabelNew(info.data)
    end
  end
  
  DYHttpMgr.dungeonNew(tFuncListener)
end

function M:initUI()
  local bg = display.newSprite("purgatory/bg.png"):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, bg:getContentSize().width * 0.98, bg:getContentSize().height * 0.98):addTo(bg):onButtonClicked(function()
    self:closeCallBack()
  end)
  local titleFrame = display.newSprite("common_ui/title_frame.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.93):addTo(bg)
  display.newSprite("dungeon/title.png"):pos(titleFrame:getContentSize().width * 0.5, titleFrame:getContentSize().height * 0.5):addTo(titleFrame)
  local iconImg = {
    "dungeon/bg_travel.png",
    "dungeon/bg_purgatory.png",
    "dungeon/bg_infinite.png"
  }
  for i = 1, #iconImg do
    local btn = cc.ui.UIPushButton.new({
      normal = iconImg[i],
      pressed = iconImg[i]
    }):onButtonPressed(function(event)
      event.target:setScale(0.95)
    end):onButtonRelease(function(event)
      event.target:setScale(1)
    end):onButtonClicked(function(event)
      self:clickIcon(i, event.target)
    end):align(display.CENTER, bg:getContentSize().width * 0.42, bg:getContentSize().height * (0.97 - 0.24 * i)):addTo(bg)
    if i == 3 then
      self.mBabelBtn = btn
    end
  end
  display.newSprite("dungeon/tip.png"):pos(bg:getContentSize().width * 0.87, bg:getContentSize().height * 0.45):addTo(bg)
end

function M:addBabelNew(info)
  local regionId = tonumber(CloudData.USER_SERVER_ID)
  local str = string.format(DY_KEY.kDungeonLogId, regionId, CloudData.UID)
  local lastLogId = DYStat.getValueInt(str, 0)
  local logId = checknumber(info.maxLogId)
  self.mLogId = logId
  local income = checknumber(info.isIncomeFull)
  if (income == 1 or lastLogId < logId) and self.mBabelBtn then
    display.newSprite("common_ui/red_point.png"):pos(320, 50):addTo(self.mBabelBtn)
  end
end

function M:clickIcon(tag, target)
  local str = ""
  if 1 == tag then
    local limitLevel = Const.FUNC_UNLOCK.patrol
    str = DYLang.getString("S621", "") .. limitLevel .. DYLang.getString("S622", "")
    if limitLevel <= CloudData.USER_LEVEL then
      display.replaceScene(require("scenes.SceneTravel").new())
      return
    end
  elseif 2 == tag then
    local limitLevel = Const.FUNC_UNLOCK.purgatory
    str = DYLang.getString("S621", "") .. limitLevel .. DYLang.getString("S622", "")
    if limitLevel <= CloudData.USER_LEVEL then
      display.replaceScene(require("scenes.ScenePurgatory").new())
      return
    end
  else
    local limitLevel = Const.FUNC_UNLOCK.tower
    str = DYLang.getString("S621", "") .. limitLevel .. DYLang.getString("S622", "")
    if limitLevel <= CloudData.USER_LEVEL then
      local regionId = tonumber(CloudData.USER_SERVER_ID)
      local str = string.format(DY_KEY.kDungeonLogId, regionId, CloudData.UID)
      DYStat.setValueInt(str, self.mLogId)
      display.replaceScene(require("babel.SceneBabel").new(0))
      return
    end
  end
  WSToast.new(str):pos(target:getPositionX(), target:getPositionY()):addTo(self.mBg, 20)
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
    self:closeCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M

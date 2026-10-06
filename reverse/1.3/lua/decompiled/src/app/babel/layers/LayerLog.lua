local IconLog = require("app.babel.icons.IconLog")
local LayerLogDetail = require("app.babel.layers.LayerLogDetail")
local CLASS_NAME = "LayerLog"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(cb)
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.cb = cb
  self:initBg()
  self:record()
  self:setNodeEventEnabled(true)
end

function M:initBg()
  local bg = display.newSprite("pvp/log_bg.png"):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, self.mBg:getContentSize().width, self.mBg:getContentSize().height):addTo(self.mBg, 1):onButtonClicked(function()
    self:closeCallBack()
  end)
  self:addLogList()
end

function M:addLogList()
  local logInfo = CloudData.BabelLog
  if not logInfo or #logInfo == 0 then
    return
  end
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(67, 60, 880, 492),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  for i = 1, #logInfo do
    local item = list:newItem()
    logInfo[i].time = logInfo.time
    local params = {
      cb = handler(self, self.showDetail),
      index = i,
      info = logInfo[i]
    }
    local content = IconLog.new(params)
    item:addContent(content)
    item:setItemSize(941, 175)
    list:addItem(item)
  end
  list:reload()
end

function M:showDetail(index)
  if CloudData.BabelLog[checknumber(index)] then
    LayerLogDetail.new(index):addTo(self, 20)
  end
end

function M:record()
  local logInfo = CloudData.BabelLog or {}
  if logInfo[1] then
    local msgId = logInfo[1].id or 0
    local regionId = tonumber(CloudData.USER_SERVER_ID)
    local str = string.format(DY_KEY.kBabelLogId, regionId, CloudData.UID)
    DYStat.setValueInt(str, msgId)
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.cb then
    self.cb()
  end
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

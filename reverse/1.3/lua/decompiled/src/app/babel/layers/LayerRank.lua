local IconRank = require("app.babel.icons.IconRank")
local LayerRankDetail = require("app.babel.layers.LayerRankDetail")
local CLASS_NAME = "LayerRank"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mRankInfo = {}
  self.mSum = 0
  self:initData()
  self:initBg()
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mRankInfo = CloudData.BabelRank
  self.mSum = #CloudData.BabelRank
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
  self:addRankList()
end

function M:addRankList()
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(67, 60, 880, 492),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  for i = 1, #CloudData.BabelRank do
    local item = list:newItem()
    local params = {
      cb = handler(self, self.showDetail),
      index = i,
      info = self.mRankInfo[i]
    }
    local content = IconRank.new(params)
    item:addContent(content)
    item:setItemSize(941, 175)
    list:addItem(item)
  end
  list:reload()
end

function M:showDetail(index)
  LayerRankDetail.new(index):addTo(self, 20)
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
